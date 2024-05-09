1 /***
2  *    ██████╗ ███████╗ ██████╗  ██████╗ 
3  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
4  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
5  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
6  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
7  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
8  *    
9  * https://dego.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2022 dego
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */// File: @openzeppelin/contracts/math/SafeMath.sol
33 
34 // SPDX-License-Identifier: MIT
35 
36 pragma solidity ^0.6.0;
37 
38 /**
39  * @dev Wrappers over Solidity's arithmetic operations with added overflow
40  * checks.
41  *
42  * Arithmetic operations in Solidity wrap on overflow. This can easily result
43  * in bugs, because programmers usually assume that an overflow raises an
44  * error, which is the standard behavior in high level programming languages.
45  * `SafeMath` restores this intuition by reverting the transaction when an
46  * operation overflows.
47  *
48  * Using this library instead of the unchecked operations eliminates an entire
49  * class of bugs, so it's recommended to use it always.
50  */
51 library SafeMath {
52     /**
53      * @dev Returns the addition of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `+` operator.
57      *
58      * Requirements:
59      *
60      * - Addition cannot overflow.
61      */
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the subtraction of two unsigned integers, reverting on
71      * overflow (when the result is negative).
72      *
73      * Counterpart to Solidity's `-` operator.
74      *
75      * Requirements:
76      *
77      * - Subtraction cannot overflow.
78      */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     /**
84      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
85      * overflow (when the result is negative).
86      *
87      * Counterpart to Solidity's `-` operator.
88      *
89      * Requirements:
90      *
91      * - Subtraction cannot overflow.
92      */
93     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      *
108      * - Multiplication cannot overflow.
109      */
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
112         // benefit is lost if 'b' is also tested.
113         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
114         if (a == 0) {
115             return 0;
116         }
117 
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers. Reverts on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator. Note: this function uses a
129      * `revert` opcode (which leaves remaining gas untouched) while Solidity
130      * uses an invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return div(a, b, "SafeMath: division by zero");
138     }
139 
140     /**
141      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
142      * division by zero. The result is rounded towards zero.
143      *
144      * Counterpart to Solidity's `/` operator. Note: this function uses a
145      * `revert` opcode (which leaves remaining gas untouched) while Solidity
146      * uses an invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b > 0, errorMessage);
154         uint256 c = a / b;
155         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
162      * Reverts when dividing by zero.
163      *
164      * Counterpart to Solidity's `%` operator. This function uses a `revert`
165      * opcode (which leaves remaining gas untouched) while Solidity uses an
166      * invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173         return mod(a, b, "SafeMath: modulo by zero");
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * Reverts with custom message when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b != 0, errorMessage);
190         return a % b;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/GSN/Context.sol
195 
196 
197 
198 pragma solidity ^0.6.0;
199 
200 /*
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with GSN meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 abstract contract Context {
211     function _msgSender() internal view virtual returns (address payable) {
212         return msg.sender;
213     }
214 
215     function _msgData() internal view virtual returns (bytes memory) {
216         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
217         return msg.data;
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Pausable.sol
222 
223 
224 
225 pragma solidity ^0.6.0;
226 
227 /**
228  * @dev Contract module which allows children to implement an emergency stop
229  * mechanism that can be triggered by an authorized account.
230  *
231  * This module is used through inheritance. It will make available the
232  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
233  * the functions of your contract. Note that they will not be pausable by
234  * simply including this module, only once the modifiers are put in place.
235  */
236 contract Pausable is Context {
237     /**
238      * @dev Emitted when the pause is triggered by `account`.
239      */
240     event Paused(address account);
241 
242     /**
243      * @dev Emitted when the pause is lifted by `account`.
244      */
245     event Unpaused(address account);
246 
247     bool private _paused;
248 
249     /**
250      * @dev Initializes the contract in unpaused state.
251      */
252     constructor () internal {
253         _paused = false;
254     }
255 
256     /**
257      * @dev Returns true if the contract is paused, and false otherwise.
258      */
259     function paused() public view returns (bool) {
260         return _paused;
261     }
262 
263     /**
264      * @dev Modifier to make a function callable only when the contract is not paused.
265      *
266      * Requirements:
267      *
268      * - The contract must not be paused.
269      */
270     modifier whenNotPaused() {
271         require(!_paused, "Pausable: paused");
272         _;
273     }
274 
275     /**
276      * @dev Modifier to make a function callable only when the contract is paused.
277      *
278      * Requirements:
279      *
280      * - The contract must be paused.
281      */
282     modifier whenPaused() {
283         require(_paused, "Pausable: not paused");
284         _;
285     }
286 
287     /**
288      * @dev Triggers stopped state.
289      *
290      * Requirements:
291      *
292      * - The contract must not be paused.
293      */
294     function _pause() internal virtual whenNotPaused {
295         _paused = true;
296         emit Paused(_msgSender());
297     }
298 
299     /**
300      * @dev Returns to normal state.
301      *
302      * Requirements:
303      *
304      * - The contract must be paused.
305      */
306     function _unpause() internal virtual whenPaused {
307         _paused = false;
308         emit Unpaused(_msgSender());
309     }
310 }
311 
312 // File: @openzeppelin/contracts/access/Ownable.sol
313 
314 
315 
316 pragma solidity ^0.6.0;
317 
318 /**
319  * @dev Contract module which provides a basic access control mechanism, where
320  * there is an account (an owner) that can be granted exclusive access to
321  * specific functions.
322  *
323  * By default, the owner account will be the one that deploys the contract. This
324  * can later be changed with {transferOwnership}.
325  *
326  * This module is used through inheritance. It will make available the modifier
327  * `onlyOwner`, which can be applied to your functions to restrict their use to
328  * the owner.
329  */
330 contract Ownable is Context {
331     address private _owner;
332 
333     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
334 
335     /**
336      * @dev Initializes the contract setting the deployer as the initial owner.
337      */
338     constructor () internal {
339         address msgSender = _msgSender();
340         _owner = msgSender;
341         emit OwnershipTransferred(address(0), msgSender);
342     }
343 
344     /**
345      * @dev Returns the address of the current owner.
346      */
347     function owner() public view returns (address) {
348         return _owner;
349     }
350 
351     /**
352      * @dev Throws if called by any account other than the owner.
353      */
354     modifier onlyOwner() {
355         require(_owner == _msgSender(), "Ownable: caller is not the owner");
356         _;
357     }
358 
359     /**
360      * @dev Leaves the contract without owner. It will not be possible to call
361      * `onlyOwner` functions anymore. Can only be called by the current owner.
362      *
363      * NOTE: Renouncing ownership will leave the contract without an owner,
364      * thereby removing any functionality that is only available to the owner.
365      */
366     function renounceOwnership() public virtual onlyOwner {
367         emit OwnershipTransferred(_owner, address(0));
368         _owner = address(0);
369     }
370 
371     /**
372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
373      * Can only be called by the current owner.
374      */
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         emit OwnershipTransferred(_owner, newOwner);
378         _owner = newOwner;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
383 
384 
385 
386 pragma solidity ^0.6.0;
387 
388 /**
389  * @dev Interface of the ERC20 standard as defined in the EIP.
390  */
391 interface IERC20 {
392     /**
393      * @dev Returns the amount of tokens in existence.
394      */
395     function totalSupply() external view returns (uint256);
396 
397     /**
398      * @dev Returns the amount of tokens owned by `account`.
399      */
400     function balanceOf(address account) external view returns (uint256);
401 
402     /**
403      * @dev Moves `amount` tokens from the caller's account to `recipient`.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transfer(address recipient, uint256 amount) external returns (bool);
410 
411     /**
412      * @dev Returns the remaining number of tokens that `spender` will be
413      * allowed to spend on behalf of `owner` through {transferFrom}. This is
414      * zero by default.
415      *
416      * This value changes when {approve} or {transferFrom} are called.
417      */
418     function allowance(address owner, address spender) external view returns (uint256);
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * IMPORTANT: Beware that changing an allowance with this method brings the risk
426      * that someone may use both the old and the new allowance by unfortunate
427      * transaction ordering. One possible solution to mitigate this race
428      * condition is to first reduce the spender's allowance to 0 and set the
429      * desired value afterwards:
430      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
431      *
432      * Emits an {Approval} event.
433      */
434     function approve(address spender, uint256 amount) external returns (bool);
435 
436     /**
437      * @dev Moves `amount` tokens from `sender` to `recipient` using the
438      * allowance mechanism. `amount` is then deducted from the caller's
439      * allowance.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
446 
447     /**
448      * @dev Emitted when `value` tokens are moved from one account (`from`) to
449      * another (`to`).
450      *
451      * Note that `value` may be zero.
452      */
453     event Transfer(address indexed from, address indexed to, uint256 value);
454 
455     /**
456      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
457      * a call to {approve}. `value` is the new allowance.
458      */
459     event Approval(address indexed owner, address indexed spender, uint256 value);
460 }
461 
462 // File: @openzeppelin/contracts/utils/Address.sol
463 
464 
465 
466 pragma solidity ^0.6.2;
467 
468 /**
469  * @dev Collection of functions related to the address type
470  */
471 library Address {
472     /**
473      * @dev Returns true if `account` is a contract.
474      *
475      * [IMPORTANT]
476      * ====
477      * It is unsafe to assume that an address for which this function returns
478      * false is an externally-owned account (EOA) and not a contract.
479      *
480      * Among others, `isContract` will return false for the following
481      * types of addresses:
482      *
483      *  - an externally-owned account
484      *  - a contract in construction
485      *  - an address where a contract will be created
486      *  - an address where a contract lived, but was destroyed
487      * ====
488      */
489     function isContract(address account) internal view returns (bool) {
490         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
491         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
492         // for accounts without code, i.e. `keccak256('')`
493         bytes32 codehash;
494         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
495         // solhint-disable-next-line no-inline-assembly
496         assembly { codehash := extcodehash(account) }
497         return (codehash != accountHash && codehash != 0x0);
498     }
499 
500     /**
501      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
502      * `recipient`, forwarding all available gas and reverting on errors.
503      *
504      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
505      * of certain opcodes, possibly making contracts go over the 2300 gas limit
506      * imposed by `transfer`, making them unable to receive funds via
507      * `transfer`. {sendValue} removes this limitation.
508      *
509      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
510      *
511      * IMPORTANT: because control is transferred to `recipient`, care must be
512      * taken to not create reentrancy vulnerabilities. Consider using
513      * {ReentrancyGuard} or the
514      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
515      */
516     function sendValue(address payable recipient, uint256 amount) internal {
517         require(address(this).balance >= amount, "Address: insufficient balance");
518 
519         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
520         (bool success, ) = recipient.call{ value: amount }("");
521         require(success, "Address: unable to send value, recipient may have reverted");
522     }
523 
524     /**
525      * @dev Performs a Solidity function call using a low level `call`. A
526      * plain`call` is an unsafe replacement for a function call: use this
527      * function instead.
528      *
529      * If `target` reverts with a revert reason, it is bubbled up by this
530      * function (like regular Solidity function calls).
531      *
532      * Returns the raw returned data. To convert to the expected return value,
533      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
534      *
535      * Requirements:
536      *
537      * - `target` must be a contract.
538      * - calling `target` with `data` must not revert.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
543       return functionCall(target, data, "Address: low-level call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
548      * `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
553         return _functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
573      * with `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
578         require(address(this).balance >= value, "Address: insufficient balance for call");
579         return _functionCallWithValue(target, data, value, errorMessage);
580     }
581 
582     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
583         require(isContract(target), "Address: call to non-contract");
584 
585         // solhint-disable-next-line avoid-low-level-calls
586         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
587         if (success) {
588             return returndata;
589         } else {
590             // Look for revert reason and bubble it up if present
591             if (returndata.length > 0) {
592                 // The easiest way to bubble the revert reason is using memory via assembly
593 
594                 // solhint-disable-next-line no-inline-assembly
595                 assembly {
596                     let returndata_size := mload(returndata)
597                     revert(add(32, returndata), returndata_size)
598                 }
599             } else {
600                 revert(errorMessage);
601             }
602         }
603     }
604 }
605 
606 // File: contracts/library/ERC20.sol
607 
608 
609 
610 pragma solidity ^0.6.0;
611 
612 
613 
614 
615 /**
616  * @dev Implementation of the {IERC20} interface.
617  *
618  * This implementation is agnostic to the way tokens are created. This means
619  * that a supply mechanism has to be added in a derived contract using {_mint}.
620  * For a generic mechanism see {ERC20PresetMinterPauser}.
621  *
622  * TIP: For a detailed writeup see our guide
623  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
624  * to implement supply mechanisms].
625  *
626  * We have followed general OpenZeppelin guidelines: functions revert instead
627  * of returning `false` on failure. This behavior is nonetheless conventional
628  * and does not conflict with the expectations of ERC20 applications.
629  *
630  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
631  * This allows applications to reconstruct the allowance for all accounts just
632  * by listening to said events. Other implementations of the EIP may not emit
633  * these events, as it isn't required by the specification.
634  *
635  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
636  * functions have been added to mitigate the well-known issues around setting
637  * allowances. See {IERC20-approve}.
638  */
639 contract ERC20 is Context, IERC20 {
640     using SafeMath for uint256;
641     using Address for address;
642 
643     mapping (address => uint256) private _balances;
644 
645     mapping (address => mapping (address => uint256)) private _allowances;
646 
647     uint256 _totalSupply;
648 
649     string private _name;
650     string private _symbol;
651     uint8 private _decimals;
652 
653     /**
654      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
655      * a default value of 18.
656      *
657      * To select a different value for {decimals}, use {_setupDecimals}.
658      *
659      * All three of these values are immutable: they can only be set once during
660      * construction.
661      */
662     constructor (string memory name, string memory symbol) public {
663         _name = name;
664         _symbol = symbol;
665         _decimals = 18;
666     }
667 
668     /**
669      * @dev Returns the name of the token.
670      */
671     function name() public view returns (string memory) {
672         return _name;
673     }
674 
675     /**
676      * @dev Returns the symbol of the token, usually a shorter version of the
677      * name.
678      */
679     function symbol() public view returns (string memory) {
680         return _symbol;
681     }
682 
683     /**
684      * @dev Returns the number of decimals used to get its user representation.
685      * For example, if `decimals` equals `2`, a balance of `505` tokens should
686      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
687      *
688      * Tokens usually opt for a value of 18, imitating the relationship between
689      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
690      * called.
691      *
692      * NOTE: This information is only used for _display_ purposes: it in
693      * no way affects any of the arithmetic of the contract, including
694      * {IERC20-balanceOf} and {IERC20-transfer}.
695      */
696     function decimals() public view returns (uint8) {
697         return _decimals;
698     }
699 
700     /**
701      * @dev See {IERC20-totalSupply}.
702      */
703     function totalSupply() public view override returns (uint256) {
704         return _totalSupply;
705     }
706 
707     /**
708      * @dev See {IERC20-balanceOf}.
709      */
710     function balanceOf(address account) public view override returns (uint256) {
711         return _balances[account];
712     }
713 
714     /**
715      * @dev See {IERC20-transfer}.
716      *
717      * Requirements:
718      *
719      * - `recipient` cannot be the zero address.
720      * - the caller must have a balance of at least `amount`.
721      */
722     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
723         _transfer(_msgSender(), recipient, amount);
724         return true;
725     }
726 
727     /**
728      * @dev See {IERC20-allowance}.
729      */
730     function allowance(address owner, address spender) public view virtual override returns (uint256) {
731         return _allowances[owner][spender];
732     }
733 
734     /**
735      * @dev See {IERC20-approve}.
736      *
737      * Requirements:
738      *
739      * - `spender` cannot be the zero address.
740      */
741     function approve(address spender, uint256 amount) public virtual override returns (bool) {
742         _approve(_msgSender(), spender, amount);
743         return true;
744     }
745 
746     /**
747      * @dev See {IERC20-transferFrom}.
748      *
749      * Emits an {Approval} event indicating the updated allowance. This is not
750      * required by the EIP. See the note at the beginning of {ERC20};
751      *
752      * Requirements:
753      * - `sender` and `recipient` cannot be the zero address.
754      * - `sender` must have a balance of at least `amount`.
755      * - the caller must have allowance for ``sender``'s tokens of at least
756      * `amount`.
757      */
758     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
759         _transfer(sender, recipient, amount);
760         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
761         return true;
762     }
763 
764     /**
765      * @dev Atomically increases the allowance granted to `spender` by the caller.
766      *
767      * This is an alternative to {approve} that can be used as a mitigation for
768      * problems described in {IERC20-approve}.
769      *
770      * Emits an {Approval} event indicating the updated allowance.
771      *
772      * Requirements:
773      *
774      * - `spender` cannot be the zero address.
775      */
776     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
777         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
778         return true;
779     }
780 
781     /**
782      * @dev Atomically decreases the allowance granted to `spender` by the caller.
783      *
784      * This is an alternative to {approve} that can be used as a mitigation for
785      * problems described in {IERC20-approve}.
786      *
787      * Emits an {Approval} event indicating the updated allowance.
788      *
789      * Requirements:
790      *
791      * - `spender` cannot be the zero address.
792      * - `spender` must have allowance for the caller of at least
793      * `subtractedValue`.
794      */
795     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
796         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
797         return true;
798     }
799 
800     /**
801      * @dev Moves tokens `amount` from `sender` to `recipient`.
802      *
803      * This is internal function is equivalent to {transfer}, and can be used to
804      * e.g. implement automatic token fees, slashing mechanisms, etc.
805      *
806      * Emits a {Transfer} event.
807      *
808      * Requirements:
809      *
810      * - `sender` cannot be the zero address.
811      * - `recipient` cannot be the zero address.
812      * - `sender` must have a balance of at least `amount`.
813      */
814     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
815         require(sender != address(0), "ERC20: transfer from the zero address");
816         require(recipient != address(0), "ERC20: transfer to the zero address");
817 
818         _beforeTokenTransfer(sender, recipient, amount);
819 
820         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
821         _balances[recipient] = _balances[recipient].add(amount);
822         emit Transfer(sender, recipient, amount);
823     }
824 
825     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
826      * the total supply.
827      *
828      * Emits a {Transfer} event with `from` set to the zero address.
829      *
830      * Requirements
831      *
832      * - `to` cannot be the zero address.
833      */
834     function _mint(address account, uint256 amount) internal virtual {
835         require(account != address(0), "ERC20: mint to the zero address");
836 
837         _beforeTokenTransfer(address(0), account, amount);
838 
839         _totalSupply = _totalSupply.add(amount);
840         _balances[account] = _balances[account].add(amount);
841         emit Transfer(address(0), account, amount);
842     }
843 
844     /**
845      * @dev Destroys `amount` tokens from `account`, reducing the
846      * total supply.
847      *
848      * Emits a {Transfer} event with `to` set to the zero address.
849      *
850      * Requirements
851      *
852      * - `account` cannot be the zero address.
853      * - `account` must have at least `amount` tokens.
854      */
855     function _burn(address account, uint256 amount) internal virtual {
856         require(account != address(0), "ERC20: burn from the zero address");
857 
858         _beforeTokenTransfer(account, address(0), amount);
859 
860         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
861         _totalSupply = _totalSupply.sub(amount);
862         emit Transfer(account, address(0), amount);
863     }
864 
865     /**
866      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
867      *
868      * This is internal function is equivalent to `approve`, and can be used to
869      * e.g. set automatic allowances for certain subsystems, etc.
870      *
871      * Emits an {Approval} event.
872      *
873      * Requirements:
874      *
875      * - `owner` cannot be the zero address.
876      * - `spender` cannot be the zero address.
877      */
878     function _approve(address owner, address spender, uint256 amount) internal virtual {
879         require(owner != address(0), "ERC20: approve from the zero address");
880         require(spender != address(0), "ERC20: approve to the zero address");
881 
882         _allowances[owner][spender] = amount;
883         emit Approval(owner, spender, amount);
884     }
885 
886     /**
887      * @dev Sets {decimals} to a value other than the default one of 18.
888      *
889      * WARNING: This function should only be called from the constructor. Most
890      * applications that interact with token contracts will not expect
891      * {decimals} to ever change, and may work incorrectly if it does.
892      */
893     function _setupDecimals(uint8 decimals_) internal {
894         _decimals = decimals_;
895     }
896 
897     /**
898      * @dev Hook that is called before any transfer of tokens. This includes
899      * minting and burning.
900      *
901      * Calling conditions:
902      *
903      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
904      * will be to transferred to `to`.
905      * - when `from` is zero, `amount` tokens will be minted for `to`.
906      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
907      * - `from` and `to` are never both zero.
908      *
909      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
910      */
911     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
912 }
913 
914 // File: contracts/dego/DegoTokenV2.sol
915 
916 
917 pragma solidity ^0.6.0;
918 
919 
920 
921 
922 /// @title DegoTokenV2 Contract
923 contract DegoTokenV2 is Ownable, ERC20, Pausable {
924     using SafeMath for uint256;
925 
926     //events
927     event eveSetRate(uint256 burn_rate, uint256 reward_rate);
928     event eveRewardPool(address rewardPool);
929     event Mint(address indexed from, address indexed to, uint256 value);
930     event Burn(address indexed sender, uint256 indexed value);
931 
932     event AddMinter(address minter);
933     event DelMinter(address minter);
934 
935     event AddBlackAccount(address blackAccount);
936     event DelBlackAccount(address blackAccount);
937 
938     // for minters
939     mapping (address => bool) public _minters;
940 
941     // for black list
942     mapping(address => bool) public blackAccountMap;
943     
944     /// Constant token specific fields
945     uint256 public  _maxSupply = 0;
946 
947     // hardcode limit rate
948     uint256 public constant _maxGovernValueRate = 2000;// 2000/10000
949     uint256 public constant _minGovernValueRate = 0;  // 0
950     uint256 public constant _rateBase = 10000; 
951 
952     // additional variables for use if transaction fees ever became necessary
953     uint256 public  _burnRate = 0;       
954     uint256 public  _rewardRate = 0;   
955 
956     uint256 public _totalBurnToken = 0;
957     uint256 public _totalRewardToken = 0;
958 
959     // reward pool!
960     address public _rewardPool = 0x6666666666666666666666666666666666666666;
961     
962     // burn pool!
963     address public _burnPool = 0x6666666666666666666666666666666666666666;
964 
965     /**
966      * CONSTRUCTOR
967      *
968      * @dev Initialize the Token
969      */
970 
971     constructor () public ERC20("dego.finance", "DEGOV2") {
972          _maxSupply = 21000000 * (10**18);
973     }
974 
975     /**
976     * @dev for mint function
977     */
978     function mint(address account, uint256 amount) external 
979     {
980         require(account != address(0), "ERC20: mint to the zero address");
981         require(_minters[msg.sender], "!minter");
982 
983         uint256 curMintSupply = totalSupply().add(_totalBurnToken);
984         uint256 newMintSupply = curMintSupply.add(amount);
985         require(newMintSupply <= _maxSupply,"supply is max!");
986         
987         _mint(account, amount);
988         emit Mint(address(0), account, amount);
989     }
990 
991     function pause() external onlyOwner{
992         super._pause();
993     }
994 
995     function unpause() external onlyOwner{
996         super._unpause();
997     }
998 
999     function addMinter(address _minter) external onlyOwner
1000     {
1001         require(!_minters[_minter], "is minter");
1002         _minters[_minter] = true;
1003         emit AddMinter(_minter);
1004     }
1005     
1006     function removeMinter(address _minter) external onlyOwner 
1007     {
1008         require(_minters[_minter], "not is minter");
1009         _minters[_minter] = false;
1010         emit DelMinter(_minter);
1011     }
1012 
1013     function addBlackAccount(address _blackAccount) external onlyOwner {
1014         require(!blackAccountMap[_blackAccount], "has in black list");
1015         blackAccountMap[_blackAccount] = true;
1016         emit AddBlackAccount(_blackAccount);
1017     }
1018 
1019     function delBlackAccount(address _blackAccount) external onlyOwner {
1020         require(blackAccountMap[_blackAccount], "not in black list");
1021 
1022         blackAccountMap[_blackAccount] = false;
1023         emit DelBlackAccount(_blackAccount);
1024     }
1025 
1026     /**
1027     * @dev for govern value
1028     */
1029     function setRate(uint256 burn_rate, uint256 reward_rate) external 
1030         onlyOwner 
1031     {
1032         require(_maxGovernValueRate >= burn_rate && burn_rate >= _minGovernValueRate,"invalid burn rate");
1033         require(_maxGovernValueRate >= reward_rate && reward_rate >= _minGovernValueRate,"invalid reward rate");
1034 
1035         _burnRate = burn_rate;
1036         _rewardRate = reward_rate;
1037 
1038         emit eveSetRate(burn_rate, reward_rate);
1039     }
1040 
1041     /**
1042     * @dev for set reward
1043     */
1044     function setRewardPool(address rewardPool) external 
1045         onlyOwner 
1046     {
1047         require(rewardPool != address(0x0));
1048 
1049         _rewardPool = rewardPool;
1050 
1051         emit eveRewardPool(_rewardPool);
1052     }
1053     
1054     
1055     /**
1056     * @dev Transfer tokens with fee
1057     * @param from address The address which you want to send tokens from
1058     * @param to address The address which you want to transfer to
1059     * @param value uint256s the amount of tokens to be transferred
1060     */
1061     function _transfer(address from, address to, uint256 value)
1062     internal override whenNotPaused
1063     {
1064         require(!blackAccountMap[from], "can't transfer");
1065         uint256 sendAmount = value;
1066         uint256 burnFee = (value.mul(_burnRate)).div(_rateBase);
1067         if (burnFee > 0) {
1068             //to burn
1069             super._transfer(from, _burnPool, burnFee);
1070             _totalSupply = _totalSupply.sub(burnFee);
1071             sendAmount = sendAmount.sub(burnFee);
1072             _totalBurnToken = _totalBurnToken.add(burnFee);
1073         }
1074 
1075         uint256 rewardFee = (value.mul(_rewardRate)).div(_rateBase);
1076         if (rewardFee > 0) {
1077            //to reward
1078             super._transfer(from, _rewardPool, rewardFee);
1079             sendAmount = sendAmount.sub(rewardFee);
1080             _totalRewardToken = _totalRewardToken.add(rewardFee);
1081         }
1082         super._transfer(from, to, sendAmount);
1083     }
1084 }