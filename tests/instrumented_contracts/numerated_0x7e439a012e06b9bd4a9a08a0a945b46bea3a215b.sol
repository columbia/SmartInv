1 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.1.0
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 
55 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.1.0
56 
57 pragma solidity ^0.6.0;
58 
59 
60 /**
61  * @dev Implementation of the {IERC165} interface.
62  *
63  * Contracts may inherit from this and call {_registerInterface} to declare
64  * their support of an interface.
65  */
66 contract ERC165 is IERC165 {
67     /*
68      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
69      */
70     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
71 
72     /**
73      * @dev Mapping of interface ids to whether or not it's supported.
74      */
75     mapping(bytes4 => bool) private _supportedInterfaces;
76 
77     constructor () internal {
78         // Derived contracts need only register support for their own interfaces,
79         // we register support for ERC165 itself here
80         _registerInterface(_INTERFACE_ID_ERC165);
81     }
82 
83     /**
84      * @dev See {IERC165-supportsInterface}.
85      *
86      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
87      */
88     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
89         return _supportedInterfaces[interfaceId];
90     }
91 
92     /**
93      * @dev Registers the contract as an implementer of the interface defined by
94      * `interfaceId`. Support of the actual ERC165 interface is automatic and
95      * registering its interface id is not required.
96      *
97      * See {IERC165-supportsInterface}.
98      *
99      * Requirements:
100      *
101      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
102      */
103     function _registerInterface(bytes4 interfaceId) internal virtual {
104         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
105         _supportedInterfaces[interfaceId] = true;
106     }
107 }
108 
109 
110 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0
111 
112 pragma solidity ^0.6.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 
271 // File @openzeppelin/contracts/utils/Address.sol@v3.1.0
272 
273 pragma solidity ^0.6.2;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
298         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
299         // for accounts without code, i.e. `keccak256('')`
300         bytes32 codehash;
301         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { codehash := extcodehash(account) }
304         return (codehash != accountHash && codehash != 0x0);
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 
414 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20.sol@v3.0.0
415 
416 /*
417 https://github.com/OpenZeppelin/openzeppelin-contracts
418 
419 The MIT License (MIT)
420 
421 Copyright (c) 2016-2019 zOS Global Limited
422 
423 Permission is hereby granted, free of charge, to any person obtaining
424 a copy of this software and associated documentation files (the
425 "Software"), to deal in the Software without restriction, including
426 without limitation the rights to use, copy, modify, merge, publish,
427 distribute, sublicense, and/or sell copies of the Software, and to
428 permit persons to whom the Software is furnished to do so, subject to
429 the following conditions:
430 
431 The above copyright notice and this permission notice shall be included
432 in all copies or substantial portions of the Software.
433 
434 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
435 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
436 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
437 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
438 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
439 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
440 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
441 */
442 
443 pragma solidity 0.6.8;
444 
445 /**
446  * @dev Interface of the ERC20 standard as defined in the EIP.
447  */
448 interface IERC20 {
449 
450     /**
451      * @dev Emitted when `value` tokens are moved from one account (`from`) to
452      * another (`to`).
453      *
454      * Note that `value` may be zero.
455      */
456     event Transfer(
457         address indexed _from,
458         address indexed _to,
459         uint256 _value
460     );
461 
462     /**
463      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
464      * a call to {approve}. `value` is the new allowance.
465      */
466     event Approval(
467         address indexed _owner,
468         address indexed _spender,
469         uint256 _value
470     );
471 
472     /**
473      * @dev Returns the amount of tokens in existence.
474      */
475     function totalSupply() external view returns (uint256);
476 
477     /**
478      * @dev Returns the amount of tokens owned by `account`.
479      */
480     function balanceOf(address account) external view returns (uint256);
481 
482     /**
483      * @dev Moves `amount` tokens from the caller's account to `recipient`.
484      *
485      * Returns a boolean value indicating whether the operation succeeded.
486      *
487      * Emits a {Transfer} event.
488      */
489     function transfer(address recipient, uint256 amount) external returns (bool);
490 
491     /**
492      * @dev Returns the remaining number of tokens that `spender` will be
493      * allowed to spend on behalf of `owner` through {transferFrom}. This is
494      * zero by default.
495      *
496      * This value changes when {approve} or {transferFrom} are called.
497      */
498     function allowance(address owner, address spender) external view returns (uint256);
499 
500     /**
501      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
502      *
503      * Returns a boolean value indicating whether the operation succeeded.
504      *
505      * IMPORTANT: Beware that changing an allowance with this method brings the risk
506      * that someone may use both the old and the new allowance by unfortunate
507      * transaction ordering. One possible solution to mitigate this race
508      * condition is to first reduce the spender's allowance to 0 and set the
509      * desired value afterwards:
510      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
511      *
512      * Emits an {Approval} event.
513      */
514     function approve(address spender, uint256 amount) external returns (bool);
515 
516     /**
517      * @dev Moves `amount` tokens from `sender` to `recipient` using the
518      * allowance mechanism. `amount` is then deducted from the caller's
519      * allowance.
520      *
521      * Returns a boolean value indicating whether the operation succeeded.
522      *
523      * Emits a {Transfer} event.
524      */
525     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
526 }
527 
528 
529 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20Detailed.sol@v3.0.0
530 
531 /*
532 https://github.com/OpenZeppelin/openzeppelin-contracts
533 
534 The MIT License (MIT)
535 
536 Copyright (c) 2016-2019 zOS Global Limited
537 
538 Permission is hereby granted, free of charge, to any person obtaining
539 a copy of this software and associated documentation files (the
540 "Software"), to deal in the Software without restriction, including
541 without limitation the rights to use, copy, modify, merge, publish,
542 distribute, sublicense, and/or sell copies of the Software, and to
543 permit persons to whom the Software is furnished to do so, subject to
544 the following conditions:
545 
546 The above copyright notice and this permission notice shall be included
547 in all copies or substantial portions of the Software.
548 
549 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
550 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
551 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
552 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
553 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
554 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
555 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
556 */
557 
558 pragma solidity 0.6.8;
559 
560 /**
561  * @dev Interface for commonly used additional ERC20 interfaces
562  */
563 interface IERC20Detailed {
564 
565     /**
566      * @dev Returns the name of the token.
567      */
568     function name() external view returns (string memory);
569 
570     /**
571      * @dev Returns the symbol of the token, usually a shorter version of the
572      * name.
573      */
574     function symbol() external view returns (string memory);
575 
576     /**
577      * @dev Returns the number of decimals used to get its user representation.
578      * For example, if `decimals` equals `2`, a balance of `505` tokens should
579      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
580      *
581      * Tokens usually opt for a value of 18, imitating the relationship between
582      * Ether and Wei. This is the value {ERC20} uses.
583      *
584      * NOTE: This information is only used for _display_ purposes: it in
585      * no way affects any of the arithmetic of the contract, including
586      * {IERC20-balanceOf} and {IERC20-transfer}.
587      */
588     function decimals() external view returns (uint8);
589 }
590 
591 
592 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20Allowance.sol@v3.0.0
593 
594 pragma solidity 0.6.8;
595 
596 /**
597  * @dev Interface for additional ERC20 allowance features
598  */
599 interface IERC20Allowance {
600 
601     /**
602      * @dev Atomically increases the allowance granted to `spender` by the caller.
603      *
604      * This is an alternative to {approve} that can be used as a mitigation for
605      * problems described in {IERC20-approve}.
606      *
607      * Emits an {Approval} event indicating the updated allowance.
608      *
609      * Requirements:
610      *
611      * - `spender` cannot be the zero address.
612      */
613     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
614 
615     /**
616      * @dev Atomically decreases the allowance granted to `spender` by the caller.
617      *
618      * This is an alternative to {approve} that can be used as a mitigation for
619      * problems described in {IERC20-approve}.
620      *
621      * Emits an {Approval} event indicating the updated allowance.
622      *
623      * Requirements:
624      *
625      * - `spender` cannot be the zero address.
626      * - `spender` must have allowance for the caller of at least
627      * `subtractedValue`.
628      */
629     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
630 
631 }
632 
633 
634 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/ERC20.sol@v3.0.0
635 
636 /*
637 https://github.com/OpenZeppelin/openzeppelin-contracts
638 
639 The MIT License (MIT)
640 
641 Copyright (c) 2016-2019 zOS Global Limited
642 
643 Permission is hereby granted, free of charge, to any person obtaining
644 a copy of this software and associated documentation files (the
645 "Software"), to deal in the Software without restriction, including
646 without limitation the rights to use, copy, modify, merge, publish,
647 distribute, sublicense, and/or sell copies of the Software, and to
648 permit persons to whom the Software is furnished to do so, subject to
649 the following conditions:
650 
651 The above copyright notice and this permission notice shall be included
652 in all copies or substantial portions of the Software.
653 
654 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
655 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
656 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
657 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
658 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
659 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
660 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
661 */
662 
663 pragma solidity 0.6.8;
664 
665 
666 
667 
668 
669 
670 
671 
672 /**
673  * @dev Implementation of the {IERC20} interface.
674  *
675  * This implementation is agnostic to the way tokens are created. This means
676  * that a supply mechanism has to be added in a derived contract using {_mint}.
677  * For a generic mechanism see {ERC20MinterPauser}.
678  *
679  * TIP: For a detailed writeup see our guide
680  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
681  * to implement supply mechanisms].
682  *
683  * We have followed general OpenZeppelin guidelines: functions revert instead
684  * of returning `false` on failure. This behavior is nonetheless conventional
685  * and does not conflict with the expectations of ERC20 applications.
686  *
687  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
688  * This allows applications to reconstruct the allowance for all accounts just
689  * by listening to said events. Other implementations of the EIP may not emit
690  * these events, as it isn't required by the specification.
691  *
692  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
693  * functions have been added to mitigate the well-known issues around setting
694  * allowances. See {IERC20-approve}.
695  */
696 abstract contract ERC20 is ERC165, Context, IERC20, IERC20Detailed, IERC20Allowance {
697 
698     using SafeMath for uint256;
699     using Address for address;
700 
701     mapping (address => uint256) internal _balances;
702     mapping (address => mapping (address => uint256)) internal _allowances;
703     uint256 internal _totalSupply;
704 
705     constructor() internal {
706         _registerInterface(type(IERC20).interfaceId);
707         _registerInterface(type(IERC20Detailed).interfaceId);
708         _registerInterface(type(IERC20Allowance).interfaceId);
709 
710         // ERC20Name interfaceId: bytes4(keccak256("name()"))
711         _registerInterface(0x06fdde03);
712         // ERC20Symbol interfaceId: bytes4(keccak256("symbol()"))
713         _registerInterface(0x95d89b41);
714         // ERC20Decimals interfaceId: bytes4(keccak256("decimals()"))
715         _registerInterface(0x313ce567);
716     }
717 
718 /////////////////////////////////////////// ERC20 ///////////////////////////////////////
719 
720     /**
721      * @dev See {IERC20-totalSupply}.
722      */
723     function totalSupply() public view override returns (uint256) {
724         return _totalSupply;
725     }
726 
727     /**
728      * @dev See {IERC20-balanceOf}.
729      */
730     function balanceOf(address account) public view override returns (uint256) {
731         return _balances[account];
732     }
733 
734     /**
735      * @dev See {IERC20-transfer}.
736      *
737      * Requirements:
738      *
739      * - `recipient` cannot be the zero address.
740      * - the caller must have a balance of at least `amount`.
741      */
742     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
743         _transfer(_msgSender(), recipient, amount);
744         return true;
745     }
746 
747     /**
748      * @dev See {IERC20-allowance}.
749      */
750     function allowance(address owner, address spender) public view virtual override returns (uint256) {
751         return _allowances[owner][spender];
752     }
753 
754     /**
755      * @dev See {IERC20-approve}.
756      *
757      * Requirements:
758      *
759      * - `spender` cannot be the zero address.
760      */
761     function approve(address spender, uint256 amount) public virtual override returns (bool) {
762         _approve(_msgSender(), spender, amount);
763         return true;
764     }
765 
766     /**
767      * @dev See {IERC20-transferFrom}.
768      *
769      * Emits an {Approval} event indicating the updated allowance. This is not
770      * required by the EIP. See the note at the beginning of {ERC20};
771      *
772      * Requirements:
773      * - `sender` and `recipient` cannot be the zero address.
774      * - `sender` must have a balance of at least `amount`.
775      * - the caller must have allowance for ``sender``'s tokens of at least
776      * `amount`.
777      */
778     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
779         _transfer(sender, recipient, amount);
780         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
781         return true;
782     }
783 
784 /////////////////////////////////////////// ERC20Allowance ///////////////////////////////////////
785 
786     /**
787      * @dev See {IERC20Allowance-increaseAllowance}.
788      */
789     function increaseAllowance(
790         address spender,
791         uint256 addedValue
792     ) public virtual override returns (bool)
793     {
794         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
795         return true;
796     }
797 
798     /**
799      * @dev See {IERC20Allowance-decreaseAllowance}.
800      */
801     function decreaseAllowance(
802         address spender,
803         uint256 subtractedValue
804     ) public virtual override returns (bool)
805     {
806         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
807         return true;
808     }
809 
810 /////////////////////////////////////////// Internal Functions ///////////////////////////////////////
811 
812     /**
813      * @dev Moves tokens `amount` from `sender` to `recipient`.
814      *
815      * This is internal function is equivalent to {transfer}, and can be used to
816      * e.g. implement automatic token fees, slashing mechanisms, etc.
817      *
818      * Emits a {Transfer} event.
819      *
820      * Requirements:
821      *
822      * - `sender` cannot be the zero address.
823      * - `recipient` cannot be the zero address.
824      * - `sender` must have a balance of at least `amount`.
825      */
826     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
827         require(sender != address(0), "ERC20: transfer from the zero address");
828         require(recipient != address(0), "ERC20: transfer to the zero address");
829 
830         _beforeTokenTransfer(sender, recipient, amount);
831 
832         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
833         _balances[recipient] = _balances[recipient].add(amount);
834         emit Transfer(sender, recipient, amount);
835     }
836 
837     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
838      * the total supply.
839      *
840      * Emits a {Transfer} event with `from` set to the zero address.
841      *
842      * Requirements
843      *
844      * - `to` cannot be the zero address.
845      */
846     function _mint(address account, uint256 amount) internal virtual {
847         require(account != address(0), "ERC20: mint to the zero address");
848 
849         _beforeTokenTransfer(address(0), account, amount);
850 
851         _totalSupply = _totalSupply.add(amount);
852         _balances[account] = _balances[account].add(amount);
853         emit Transfer(address(0), account, amount);
854     }
855 
856     /**
857      * @dev Destroys `amount` tokens from `account`, reducing the
858      * total supply.
859      *
860      * Emits a {Transfer} event with `to` set to the zero address.
861      *
862      * Requirements
863      *
864      * - `account` cannot be the zero address.
865      * - `account` must have at least `amount` tokens.
866      */
867     function _burn(address account, uint256 amount) internal virtual {
868         require(account != address(0), "ERC20: burn from the zero address");
869 
870         _beforeTokenTransfer(account, address(0), amount);
871 
872         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
873         _totalSupply = _totalSupply.sub(amount);
874         emit Transfer(account, address(0), amount);
875     }
876 
877     /**
878      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
879      *
880      * This is internal function is equivalent to `approve`, and can be used to
881      * e.g. set automatic allowances for certain subsystems, etc.
882      *
883      * Emits an {Approval} event.
884      *
885      * Requirements:
886      *
887      * - `owner` cannot be the zero address.
888      * - `spender` cannot be the zero address.
889      */
890     function _approve(address owner, address spender, uint256 amount) internal virtual {
891         require(owner != address(0), "ERC20: approve from the zero address");
892         require(spender != address(0), "ERC20: approve to the zero address");
893 
894         _allowances[owner][spender] = amount;
895         emit Approval(owner, spender, amount);
896     }
897 
898 /////////////////////////////////////////// Hooks ///////////////////////////////////////
899 
900     /**
901      * @dev Hook that is called before any transfer of tokens. This includes
902      * minting and burning.
903      *
904      * Calling conditions:
905      *
906      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
907      * will be to transferred to `to`.
908      * - when `from` is zero, `amount` tokens will be minted for `to`.
909      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
910      * - `from` and `to` are never both zero.
911      */
912     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
913 }
914 
915 
916 // File @openzeppelin/contracts/access/Ownable.sol@v3.1.0
917 
918 pragma solidity ^0.6.0;
919 
920 /**
921  * @dev Contract module which provides a basic access control mechanism, where
922  * there is an account (an owner) that can be granted exclusive access to
923  * specific functions.
924  *
925  * By default, the owner account will be the one that deploys the contract. This
926  * can later be changed with {transferOwnership}.
927  *
928  * This module is used through inheritance. It will make available the modifier
929  * `onlyOwner`, which can be applied to your functions to restrict their use to
930  * the owner.
931  */
932 contract Ownable is Context {
933     address private _owner;
934 
935     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
936 
937     /**
938      * @dev Initializes the contract setting the deployer as the initial owner.
939      */
940     constructor () internal {
941         address msgSender = _msgSender();
942         _owner = msgSender;
943         emit OwnershipTransferred(address(0), msgSender);
944     }
945 
946     /**
947      * @dev Returns the address of the current owner.
948      */
949     function owner() public view returns (address) {
950         return _owner;
951     }
952 
953     /**
954      * @dev Throws if called by any account other than the owner.
955      */
956     modifier onlyOwner() {
957         require(_owner == _msgSender(), "Ownable: caller is not the owner");
958         _;
959     }
960 
961     /**
962      * @dev Leaves the contract without owner. It will not be possible to call
963      * `onlyOwner` functions anymore. Can only be called by the current owner.
964      *
965      * NOTE: Renouncing ownership will leave the contract without an owner,
966      * thereby removing any functionality that is only available to the owner.
967      */
968     function renounceOwnership() public virtual onlyOwner {
969         emit OwnershipTransferred(_owner, address(0));
970         _owner = address(0);
971     }
972 
973     /**
974      * @dev Transfers ownership of the contract to a new account (`newOwner`).
975      * Can only be called by the current owner.
976      */
977     function transferOwnership(address newOwner) public virtual onlyOwner {
978         require(newOwner != address(0), "Ownable: new owner is the zero address");
979         emit OwnershipTransferred(_owner, newOwner);
980         _owner = newOwner;
981     }
982 }
983 
984 
985 // File @animoca/f1dt-ethereum-contracts/contracts/token/ERC20/F1DTCrateKey.sol@v1.0.0
986 
987 pragma solidity 0.6.8;
988 
989 
990 
991 /**
992  * @title F1DTCrateKey
993  * A token contract for Crate Keys
994  * @dev F1DT.CCK for Common crate.
995  * @dev F1DT.RCK for Rare crate.
996  * @dev F1DT.ECK for Epic crate.
997  * @dev F1DT.LCK for Legendary crate.
998   */
999 contract F1DTCrateKey is ERC20, Ownable {
1000 
1001     // solhint-disable-next-line const-name-snakecase
1002     string public override symbol;
1003     // solhint-disable-next-line const-name-snakecase
1004     string public override name;
1005     // solhint-disable-next-line const-name-snakecase
1006     uint8 public constant override decimals = 18;
1007 
1008     address public holder;
1009 
1010     string public tokenURI;
1011 
1012     /**
1013      * Constructor.
1014      * @dev Reverts if `symbol_` is not valid
1015      * @dev Reverts if `name_` is not valid
1016      * @dev Reverts if `tokenURI_` is not valid
1017      * @dev Reverts if `holder_` is an invalid address
1018      * @dev Reverts if `totalSupply_` is equal to zero
1019      * @param symbol_ Symbol of the token.
1020      * @param name_ Name of the token.
1021      * @param holder_ Holder account of the token initial supply.
1022      * @param totalSupply_ Total supply amount
1023      */
1024     constructor (
1025         string memory symbol_, 
1026         string memory name_,
1027         string memory tokenURI_,    
1028         address holder_, 
1029         uint256 totalSupply_) public {
1030 
1031         require(bytes(symbol_).length != 0, "F1DTCrateKey: invalid symbol");
1032         require(bytes(name_).length != 0, "F1DTCrateKey: invalid name");
1033         require(bytes(tokenURI_).length != 0, "F1DTCrateKey: invalid tokeURI");
1034         require(holder_ != address(0), "F1DTCrateKey: invalid holder");
1035         require(totalSupply_ != 0, "F1DTCrateKey: invalid initial supply");
1036 
1037         symbol = symbol_;
1038         name = name_;
1039         holder = holder_;
1040         tokenURI = tokenURI_;
1041         _mint(holder, totalSupply_);
1042     }
1043 
1044     /**
1045      * Destroys `amount` tokens.
1046      * @dev Reverts if called by any other than the contract owner.
1047      * @dev Reverts is `amount` is invalid
1048      * @param amount_ Amount of token to burn
1049      */
1050     function burn(uint256 amount_) external onlyOwner {
1051         require(amount_ != 0, "F1DTCrateKey: invalid amount");
1052 
1053         _burn(_msgSender(), amount_);
1054     }
1055 }