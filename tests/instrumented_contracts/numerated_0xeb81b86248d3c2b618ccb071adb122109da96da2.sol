1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.6.2 https://hardhat.org
5 
6 // File contracts/Math/Math.sol
7 
8 
9 /**
10  * @dev Standard math utilities missing in the Solidity language.
11  */
12 library Math {
13     /**
14      * @dev Returns the largest of two numbers.
15      */
16     function max(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     /**
21      * @dev Returns the smallest of two numbers.
22      */
23     function min(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a < b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the average of two numbers. The result is rounded towards
29      * zero.
30      */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
34     }
35 
36     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
37     function sqrt(uint y) internal pure returns (uint z) {
38         if (y > 3) {
39             z = y;
40             uint x = y / 2 + 1;
41             while (x < z) {
42                 z = x;
43                 x = (y / x + x) / 2;
44             }
45         } else if (y != 0) {
46             z = 1;
47         }
48     }
49 }
50 
51 
52 // File contracts/Math/SafeMath.sol
53 
54 
55 /**
56  * @dev Wrappers over Solidity's arithmetic operations with added overflow
57  * checks.
58  *
59  * Arithmetic operations in Solidity wrap on overflow. This can easily result
60  * in bugs, because programmers usually assume that an overflow raises an
61  * error, which is the standard behavior in high level programming languages.
62  * `SafeMath` restores this intuition by reverting the transaction when an
63  * operation overflows.
64  *
65  * Using this library instead of the unchecked operations eliminates an entire
66  * class of bugs, so it's recommended to use it always.
67  */
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `+` operator.
74      *
75      * Requirements:
76      * - Addition cannot overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the subtraction of two unsigned integers, reverting on
87      * overflow (when the result is negative).
88      *
89      * Counterpart to Solidity's `-` operator.
90      *
91      * Requirements:
92      * - Subtraction cannot overflow.
93      */
94     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95         return sub(a, b, "SafeMath: subtraction overflow");
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      * - Subtraction cannot overflow.
106      *
107      * _Available since v2.4.0._
108      */
109     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b <= a, errorMessage);
111         uint256 c = a - b;
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127         // benefit is lost if 'b' is also tested.
128         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
129         if (a == 0) {
130             return 0;
131         }
132 
133         uint256 c = a * b;
134         require(c / a == b, "SafeMath: multiplication overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers. Reverts on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator. Note: this function uses a
144      * `revert` opcode (which leaves remaining gas untouched) while Solidity
145      * uses an invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b) internal pure returns (uint256) {
151         return div(a, b, "SafeMath: division by zero");
152     }
153 
154     /**
155      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
156      * division by zero. The result is rounded towards zero.
157      *
158      * Counterpart to Solidity's `/` operator. Note: this function uses a
159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
160      * uses an invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      *
165      * _Available since v2.4.0._
166      */
167     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         // Solidity only automatically asserts when dividing by 0
169         require(b > 0, errorMessage);
170         uint256 c = a / b;
171         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * Reverts when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         return mod(a, b, "SafeMath: modulo by zero");
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * Reverts with custom message when dividing by zero.
194      *
195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
196      * opcode (which leaves remaining gas untouched) while Solidity uses an
197      * invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      *
202      * _Available since v2.4.0._
203      */
204     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b != 0, errorMessage);
206         return a % b;
207     }
208 }
209 
210 
211 // File contracts/Common/Context.sol
212 
213 
214 /*
215  * @dev Provides information about the current execution context, including the
216  * sender of the transaction and its data. While these are generally available
217  * via msg.sender and msg.data, they should not be accessed in such a direct
218  * manner, since when dealing with GSN meta-transactions the account sending and
219  * paying for execution may not be the actual sender (as far as an application
220  * is concerned).
221  *
222  * This contract is only required for intermediate, library-like contracts.
223  */
224 abstract contract Context {
225     function _msgSender() internal view virtual returns (address payable) {
226         return payable(msg.sender);
227     }
228 
229     function _msgData() internal view virtual returns (bytes memory) {
230         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
231         return msg.data;
232     }
233 }
234 
235 
236 // File contracts/ERC20/IERC20.sol
237 
238 
239 
240 /**
241  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
242  * the optional functions; to access them see {ERC20Detailed}.
243  */
244 interface IERC20 {
245     /**
246      * @dev Returns the amount of tokens in existence.
247      */
248     function totalSupply() external view returns (uint256);
249 
250     /**
251      * @dev Returns the amount of tokens owned by `account`.
252      */
253     function balanceOf(address account) external view returns (uint256);
254 
255     /**
256      * @dev Moves `amount` tokens from the caller's account to `recipient`.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transfer(address recipient, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Returns the remaining number of tokens that `spender` will be
266      * allowed to spend on behalf of `owner` through {transferFrom}. This is
267      * zero by default.
268      *
269      * This value changes when {approve} or {transferFrom} are called.
270      */
271     function allowance(address owner, address spender) external view returns (uint256);
272 
273     /**
274      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * IMPORTANT: Beware that changing an allowance with this method brings the risk
279      * that someone may use both the old and the new allowance by unfortunate
280      * transaction ordering. One possible solution to mitigate this race
281      * condition is to first reduce the spender's allowance to 0 and set the
282      * desired value afterwards:
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address spender, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Moves `amount` tokens from `sender` to `recipient` using the
291      * allowance mechanism. `amount` is then deducted from the caller's
292      * allowance.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Emitted when `value` tokens are moved from one account (`from`) to
302      * another (`to`).
303      *
304      * Note that `value` may be zero.
305      */
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     /**
309      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
310      * a call to {approve}. `value` is the new allowance.
311      */
312     event Approval(address indexed owner, address indexed spender, uint256 value);
313 }
314 
315 
316 // File contracts/Utils/Address.sol
317 
318 
319 /**
320  * @dev Collection of functions related to the address type
321  */
322 library Address {
323     /**
324      * @dev Returns true if `account` is a contract.
325      *
326      * [IMPORTANT]
327      * ====
328      * It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      *
331      * Among others, `isContract` will return false for the following
332      * types of addresses:
333      *
334      *  - an externally-owned account
335      *  - a contract in construction
336      *  - an address where a contract will be created
337      *  - an address where a contract lived, but was destroyed
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize, which returns 0 for contracts in
342         // construction, since the code is only stored at the end of the
343         // constructor execution.
344 
345         uint256 size;
346         // solhint-disable-next-line no-inline-assembly
347         assembly { size := extcodesize(account) }
348         return size > 0;
349     }
350 
351     /**
352      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
353      * `recipient`, forwarding all available gas and reverting on errors.
354      *
355      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
356      * of certain opcodes, possibly making contracts go over the 2300 gas limit
357      * imposed by `transfer`, making them unable to receive funds via
358      * `transfer`. {sendValue} removes this limitation.
359      *
360      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
361      *
362      * IMPORTANT: because control is transferred to `recipient`, care must be
363      * taken to not create reentrancy vulnerabilities. Consider using
364      * {ReentrancyGuard} or the
365      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
366      */
367     function sendValue(address payable recipient, uint256 amount) internal {
368         require(address(this).balance >= amount, "Address: insufficient balance");
369 
370         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
371         (bool success, ) = recipient.call{ value: amount }("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain`call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394       return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
429         require(address(this).balance >= value, "Address: insufficient balance for call");
430         require(isContract(target), "Address: call to non-contract");
431 
432         // solhint-disable-next-line avoid-low-level-calls
433         (bool success, bytes memory returndata) = target.call{ value: value }(data);
434         return _verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
454         require(isContract(target), "Address: static call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = target.staticcall(data);
458         return _verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
468         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
478         require(isContract(target), "Address: delegate call to non-contract");
479 
480         // solhint-disable-next-line avoid-low-level-calls
481         (bool success, bytes memory returndata) = target.delegatecall(data);
482         return _verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
486         if (success) {
487             return returndata;
488         } else {
489             // Look for revert reason and bubble it up if present
490             if (returndata.length > 0) {
491                 // The easiest way to bubble the revert reason is using memory via assembly
492 
493                 // solhint-disable-next-line no-inline-assembly
494                 assembly {
495                     let returndata_size := mload(returndata)
496                     revert(add(32, returndata), returndata_size)
497                 }
498             } else {
499                 revert(errorMessage);
500             }
501         }
502     }
503 }
504 
505 
506 // File contracts/ERC20/ERC20.sol
507 
508 
509 
510 
511 
512 /**
513  * @dev Implementation of the {IERC20} interface.
514  *
515  * This implementation is agnostic to the way tokens are created. This means
516  * that a supply mechanism has to be added in a derived contract using {_mint}.
517  * For a generic mechanism see {ERC20Mintable}.
518  *
519  * TIP: For a detailed writeup see our guide
520  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
521  * to implement supply mechanisms].
522  *
523  * We have followed general OpenZeppelin guidelines: functions revert instead
524  * of returning `false` on failure. This behavior is nonetheless conventional
525  * and does not conflict with the expectations of ERC20 applications.
526  *
527  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
528  * This allows applications to reconstruct the allowance for all accounts just
529  * by listening to said events. Other implementations of the EIP may not emit
530  * these events, as it isn't required by the specification.
531  *
532  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
533  * functions have been added to mitigate the well-known issues around setting
534  * allowances. See {IERC20-approve}.
535  */
536  
537 contract ERC20 is Context, IERC20 {
538     using SafeMath for uint256;
539 
540     mapping (address => uint256) private _balances;
541 
542     mapping (address => mapping (address => uint256)) private _allowances;
543 
544     uint256 private _totalSupply;
545 
546     string private _name;
547     string private _symbol;
548     uint8 private _decimals;
549     
550     /**
551      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
552      * a default value of 18.
553      *
554      * To select a different value for {decimals}, use {_setupDecimals}.
555      *
556      * All three of these values are immutable: they can only be set once during
557      * construction.
558      */
559     constructor (string memory __name, string memory __symbol) public {
560         _name = __name;
561         _symbol = __symbol;
562         _decimals = 18;
563     }
564 
565     /**
566      * @dev Returns the name of the token.
567      */
568     function name() public view returns (string memory) {
569         return _name;
570     }
571 
572     /**
573      * @dev Returns the symbol of the token, usually a shorter version of the
574      * name.
575      */
576     function symbol() public view returns (string memory) {
577         return _symbol;
578     }
579 
580     /**
581      * @dev Returns the number of decimals used to get its user representation.
582      * For example, if `decimals` equals `2`, a balance of `505` tokens should
583      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
584      *
585      * Tokens usually opt for a value of 18, imitating the relationship between
586      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
587      * called.
588      *
589      * NOTE: This information is only used for _display_ purposes: it in
590      * no way affects any of the arithmetic of the contract, including
591      * {IERC20-balanceOf} and {IERC20-transfer}.
592      */
593     function decimals() public view returns (uint8) {
594         return _decimals;
595     }
596 
597     /**
598      * @dev See {IERC20-totalSupply}.
599      */
600     function totalSupply() public view override returns (uint256) {
601         return _totalSupply;
602     }
603 
604     /**
605      * @dev See {IERC20-balanceOf}.
606      */
607     function balanceOf(address account) public view override returns (uint256) {
608         return _balances[account];
609     }
610 
611     /**
612      * @dev See {IERC20-transfer}.
613      *
614      * Requirements:
615      *
616      * - `recipient` cannot be the zero address.
617      * - the caller must have a balance of at least `amount`.
618      */
619     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
620         _transfer(_msgSender(), recipient, amount);
621         return true;
622     }
623 
624     /**
625      * @dev See {IERC20-allowance}.
626      */
627     function allowance(address owner, address spender) public view virtual override returns (uint256) {
628         return _allowances[owner][spender];
629     }
630 
631     /**
632      * @dev See {IERC20-approve}.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.approve(address spender, uint256 amount)
637      */
638     function approve(address spender, uint256 amount) public virtual override returns (bool) {
639         _approve(_msgSender(), spender, amount);
640         return true;
641     }
642 
643     /**
644      * @dev See {IERC20-transferFrom}.
645      *
646      * Emits an {Approval} event indicating the updated allowance. This is not
647      * required by the EIP. See the note at the beginning of {ERC20};
648      *
649      * Requirements:
650      * - `sender` and `recipient` cannot be the zero address.
651      * - `sender` must have a balance of at least `amount`.
652      * - the caller must have allowance for `sender`'s tokens of at least
653      * `amount`.
654      */
655     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
656         _transfer(sender, recipient, amount);
657         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
658         return true;
659     }
660 
661     /**
662      * @dev Atomically increases the allowance granted to `spender` by the caller.
663      *
664      * This is an alternative to {approve} that can be used as a mitigation for
665      * problems described in {IERC20-approve}.
666      *
667      * Emits an {Approval} event indicating the updated allowance.
668      *
669      * Requirements:
670      *
671      * - `spender` cannot be the zero address.
672      */
673     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
674         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
675         return true;
676     }
677 
678     /**
679      * @dev Atomically decreases the allowance granted to `spender` by the caller.
680      *
681      * This is an alternative to {approve} that can be used as a mitigation for
682      * problems described in {IERC20-approve}.
683      *
684      * Emits an {Approval} event indicating the updated allowance.
685      *
686      * Requirements:
687      *
688      * - `spender` cannot be the zero address.
689      * - `spender` must have allowance for the caller of at least
690      * `subtractedValue`.
691      */
692     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
693         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
694         return true;
695     }
696 
697     /**
698      * @dev Moves tokens `amount` from `sender` to `recipient`.
699      *
700      * This is internal function is equivalent to {transfer}, and can be used to
701      * e.g. implement automatic token fees, slashing mechanisms, etc.
702      *
703      * Emits a {Transfer} event.
704      *
705      * Requirements:
706      *
707      * - `sender` cannot be the zero address.
708      * - `recipient` cannot be the zero address.
709      * - `sender` must have a balance of at least `amount`.
710      */
711     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
712         require(sender != address(0), "ERC20: transfer from the zero address");
713         require(recipient != address(0), "ERC20: transfer to the zero address");
714 
715         _beforeTokenTransfer(sender, recipient, amount);
716 
717         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
718         _balances[recipient] = _balances[recipient].add(amount);
719         emit Transfer(sender, recipient, amount);
720     }
721 
722     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
723      * the total supply.
724      *
725      * Emits a {Transfer} event with `from` set to the zero address.
726      *
727      * Requirements
728      *
729      * - `to` cannot be the zero address.
730      */
731     function _mint(address account, uint256 amount) internal virtual {
732         require(account != address(0), "ERC20: mint to the zero address");
733 
734         _beforeTokenTransfer(address(0), account, amount);
735 
736         _totalSupply = _totalSupply.add(amount);
737         _balances[account] = _balances[account].add(amount);
738         emit Transfer(address(0), account, amount);
739     }
740 
741     /**
742      * @dev Destroys `amount` tokens from the caller.
743      *
744      * See {ERC20-_burn}.
745      */
746     function burn(uint256 amount) public virtual {
747         _burn(_msgSender(), amount);
748     }
749 
750     /**
751      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
752      * allowance.
753      *
754      * See {ERC20-_burn} and {ERC20-allowance}.
755      *
756      * Requirements:
757      *
758      * - the caller must have allowance for `accounts`'s tokens of at least
759      * `amount`.
760      */
761     function burnFrom(address account, uint256 amount) public virtual {
762         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
763 
764         _approve(account, _msgSender(), decreasedAllowance);
765         _burn(account, amount);
766     }
767 
768 
769     /**
770      * @dev Destroys `amount` tokens from `account`, reducing the
771      * total supply.
772      *
773      * Emits a {Transfer} event with `to` set to the zero address.
774      *
775      * Requirements
776      *
777      * - `account` cannot be the zero address.
778      * - `account` must have at least `amount` tokens.
779      */
780     function _burn(address account, uint256 amount) internal virtual {
781         require(account != address(0), "ERC20: burn from the zero address");
782 
783         _beforeTokenTransfer(account, address(0), amount);
784 
785         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
786         _totalSupply = _totalSupply.sub(amount);
787         emit Transfer(account, address(0), amount);
788     }
789 
790     /**
791      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
792      *
793      * This is internal function is equivalent to `approve`, and can be used to
794      * e.g. set automatic allowances for certain subsystems, etc.
795      *
796      * Emits an {Approval} event.
797      *
798      * Requirements:
799      *
800      * - `owner` cannot be the zero address.
801      * - `spender` cannot be the zero address.
802      */
803     function _approve(address owner, address spender, uint256 amount) internal virtual {
804         require(owner != address(0), "ERC20: approve from the zero address");
805         require(spender != address(0), "ERC20: approve to the zero address");
806 
807         _allowances[owner][spender] = amount;
808         emit Approval(owner, spender, amount);
809     }
810 
811     /**
812      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
813      * from the caller's allowance.
814      *
815      * See {_burn} and {_approve}.
816      */
817     function _burnFrom(address account, uint256 amount) internal virtual {
818         _burn(account, amount);
819         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
820     }
821 
822     /**
823      * @dev Hook that is called before any transfer of tokens. This includes
824      * minting and burning.
825      *
826      * Calling conditions:
827      *
828      * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
829      * will be to transferred to `to`.
830      * - when `from` is zero, `amount` tokens will be minted for `to`.
831      * - when `to` is zero, `amount` of `from`'s tokens will be burned.
832      * - `from` and `to` are never both zero.
833      *
834      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
835      */
836     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
837 }
838 
839 
840 // File contracts/Curve/IveFXS.sol
841 
842 pragma abicoder v2;
843 
844 interface IveFXS {
845 
846     struct LockedBalance {
847         int128 amount;
848         uint256 end;
849     }
850 
851     function commit_transfer_ownership(address addr) external;
852     function apply_transfer_ownership() external;
853     function commit_smart_wallet_checker(address addr) external;
854     function apply_smart_wallet_checker() external;
855     function toggleEmergencyUnlock() external;
856     function recoverERC20(address token_addr, uint256 amount) external;
857     function get_last_user_slope(address addr) external view returns (int128);
858     function user_point_history__ts(address _addr, uint256 _idx) external view returns (uint256);
859     function locked__end(address _addr) external view returns (uint256);
860     function checkpoint() external;
861     function deposit_for(address _addr, uint256 _value) external;
862     function create_lock(uint256 _value, uint256 _unlock_time) external;
863     function increase_amount(uint256 _value) external;
864     function increase_unlock_time(uint256 _unlock_time) external;
865     function withdraw() external;
866     function balanceOf(address addr) external view returns (uint256);
867     function balanceOf(address addr, uint256 _t) external view returns (uint256);
868     function balanceOfAt(address addr, uint256 _block) external view returns (uint256);
869     function totalSupply() external view returns (uint256);
870     function totalSupply(uint256 t) external view returns (uint256);
871     function totalSupplyAt(uint256 _block) external view returns (uint256);
872     function totalFXSSupply() external view returns (uint256);
873     function totalFXSSupplyAt(uint256 _block) external view returns (uint256);
874     function changeController(address _newController) external;
875     function token() external view returns (address);
876     function supply() external view returns (uint256);
877     function locked(address addr) external view returns (LockedBalance memory);
878     function epoch() external view returns (uint256);
879     function point_history(uint256 arg0) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
880     function user_point_history(address arg0, uint256 arg1) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
881     function user_point_epoch(address arg0) external view returns (uint256);
882     function slope_changes(uint256 arg0) external view returns (int128);
883     function controller() external view returns (address);
884     function transfersEnabled() external view returns (bool);
885     function emergencyUnlockActive() external view returns (bool);
886     function name() external view returns (string memory);
887     function symbol() external view returns (string memory);
888     function version() external view returns (string memory);
889     function decimals() external view returns (uint256);
890     function future_smart_wallet_checker() external view returns (address);
891     function smart_wallet_checker() external view returns (address);
892     function admin() external view returns (address);
893     function future_admin() external view returns (address);
894 }
895 
896 
897 // File contracts/ERC20/SafeERC20.sol
898 
899 
900 
901 
902 /**
903  * @title SafeERC20
904  * @dev Wrappers around ERC20 operations that throw on failure (when the token
905  * contract returns false). Tokens that return no value (and instead revert or
906  * throw on failure) are also supported, non-reverting calls are assumed to be
907  * successful.
908  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
909  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
910  */
911 library SafeERC20 {
912     using SafeMath for uint256;
913     using Address for address;
914 
915     function safeTransfer(IERC20 token, address to, uint256 value) internal {
916         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
917     }
918 
919     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
920         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
921     }
922 
923     /**
924      * @dev Deprecated. This function has issues similar to the ones found in
925      * {IERC20-approve}, and its usage is discouraged.
926      *
927      * Whenever possible, use {safeIncreaseAllowance} and
928      * {safeDecreaseAllowance} instead.
929      */
930     function safeApprove(IERC20 token, address spender, uint256 value) internal {
931         // safeApprove should only be called when setting an initial allowance,
932         // or when resetting it to zero. To increase and decrease it, use
933         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
934         // solhint-disable-next-line max-line-length
935         require((value == 0) || (token.allowance(address(this), spender) == 0),
936             "SafeERC20: approve from non-zero to non-zero allowance"
937         );
938         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
939     }
940 
941     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
942         uint256 newAllowance = token.allowance(address(this), spender).add(value);
943         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
944     }
945 
946     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
947         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
948         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
949     }
950 
951     /**
952      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
953      * on the return value: the return value is optional (but if data is returned, it must not be false).
954      * @param token The token targeted by the call.
955      * @param data The call data (encoded using abi.encode or one of its variants).
956      */
957     function _callOptionalReturn(IERC20 token, bytes memory data) private {
958         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
959         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
960         // the target address contains contract code and also asserts for success in the low-level call.
961 
962         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
963         if (returndata.length > 0) { // Return data is optional
964             // solhint-disable-next-line max-line-length
965             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
966         }
967     }
968 }
969 
970 
971 // File contracts/Uniswap/TransferHelper.sol
972 
973 
974 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
975 library TransferHelper {
976     function safeApprove(address token, address to, uint value) internal {
977         // bytes4(keccak256(bytes('approve(address,uint256)')));
978         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
979         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
980     }
981 
982     function safeTransfer(address token, address to, uint value) internal {
983         // bytes4(keccak256(bytes('transfer(address,uint256)')));
984         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
985         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
986     }
987 
988     function safeTransferFrom(address token, address from, address to, uint value) internal {
989         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
990         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
991         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
992     }
993 
994     function safeTransferETH(address to, uint value) internal {
995         (bool success,) = to.call{value:value}(new bytes(0));
996         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
997     }
998 }
999 
1000 
1001 // File contracts/Misc_AMOs/stakedao/IStakeDaoVault.sol
1002 
1003 
1004 interface IStakeDaoVault {
1005   function allowance(address owner, address spender) external view returns (uint256);
1006   function approve(address spender, uint256 amount) external returns (bool);
1007   function available() external view returns (uint256);
1008   function balance() external view returns (uint256);
1009   function balanceOf(address account) external view returns (uint256);
1010   function controller() external view returns (address);
1011   function decimals() external view returns (uint8);
1012   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
1013   function deposit(uint256 _amount) external;
1014   function depositAll() external;
1015   function earn() external;
1016   function getPricePerFullShare() external view returns (uint256);
1017   function governance() external view returns (address);
1018   function harvest(address reserve, uint256 amount) external;
1019   function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
1020   function max() external view returns (uint256);
1021   function min() external view returns (uint256);
1022   function name() external view returns (string memory);
1023   function setController(address _controller) external;
1024   function setGovernance(address _governance) external;
1025   function setMin(uint256 _min) external;
1026   function symbol() external view returns (string memory);
1027   function token() external view returns (address);
1028   function totalSupply() external view returns (uint256);
1029   function transfer(address recipient, uint256 amount) external returns (bool);
1030   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1031   function withdraw(uint256 _shares) external;
1032   function withdrawAll() external;
1033 }
1034 
1035 
1036 // // Part: IController
1037 
1038 // interface IController {
1039 //     function withdraw(address, uint256) external;
1040 
1041 //     function balanceOf(address) external view returns (uint256);
1042 
1043 //     function earn(address, uint256) external;
1044 
1045 //     function want(address) external view returns (address);
1046 
1047 //     function rewards() external view returns (address);
1048 
1049 //     function vaults(address) external view returns (address);
1050 
1051 //     function strategies(address) external view returns (address);
1052 // }
1053 
1054 // // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Address
1055 
1056 // /**
1057 //  * @dev Collection of functions related to the address type
1058 //  */
1059 // library Address {
1060 //     /**
1061 //      * @dev Returns true if `account` is a contract.
1062 //      *
1063 //      * [IMPORTANT]
1064 //      * ====
1065 //      * It is unsafe to assume that an address for which this function returns
1066 //      * false is an externally-owned account (EOA) and not a contract.
1067 //      *
1068 //      * Among others, `isContract` will return false for the following 
1069 //      * types of addresses:
1070 //      *
1071 //      *  - an externally-owned account
1072 //      *  - a contract in construction
1073 //      *  - an address where a contract will be created
1074 //      *  - an address where a contract lived, but was destroyed
1075 //      * ====
1076 //      */
1077 //     function isContract(address account) internal view returns (bool) {
1078 //         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1079 //         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1080 //         // for accounts without code, i.e. `keccak256('')`
1081 //         bytes32 codehash;
1082 //         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1083 //         // solhint-disable-next-line no-inline-assembly
1084 //         assembly { codehash := extcodehash(account) }
1085 //         return (codehash != accountHash && codehash != 0x0);
1086 //     }
1087 
1088 //     /**
1089 //      * @dev Converts an `address` into `address payable`. Note that this is
1090 //      * simply a type cast: the actual underlying value is not changed.
1091 //      *
1092 //      * _Available since v2.4.0._
1093 //      */
1094 //     function toPayable(address account) internal pure returns (address payable) {
1095 //         return address(uint160(account));
1096 //     }
1097 
1098 //     /**
1099 //      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1100 //      * `recipient`, forwarding all available gas and reverting on errors.
1101 //      *
1102 //      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1103 //      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1104 //      * imposed by `transfer`, making them unable to receive funds via
1105 //      * `transfer`. {sendValue} removes this limitation.
1106 //      *
1107 //      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1108 //      *
1109 //      * IMPORTANT: because control is transferred to `recipient`, care must be
1110 //      * taken to not create reentrancy vulnerabilities. Consider using
1111 //      * {ReentrancyGuard} or the
1112 //      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1113 //      *
1114 //      * _Available since v2.4.0._
1115 //      */
1116 //     function sendValue(address payable recipient, uint256 amount) internal {
1117 //         require(address(this).balance >= amount, "Address: insufficient balance");
1118 
1119 //         // solhint-disable-next-line avoid-call-value
1120 //         (bool success, ) = recipient.call.value(amount)("");
1121 //         require(success, "Address: unable to send value, recipient may have reverted");
1122 //     }
1123 // }
1124 
1125 // // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Context
1126 
1127 // /*
1128 //  * @dev Provides information about the current execution context, including the
1129 //  * sender of the transaction and its data. While these are generally available
1130 //  * via msg.sender and msg.data, they should not be accessed in such a direct
1131 //  * manner, since when dealing with GSN meta-transactions the account sending and
1132 //  * paying for execution may not be the actual sender (as far as an application
1133 //  * is concerned).
1134 //  *
1135 //  * This contract is only required for intermediate, library-like contracts.
1136 //  */
1137 // contract Context {
1138 //     // Empty internal constructor, to prevent people from mistakenly deploying
1139 //     // an instance of this contract, which should be used via inheritance.
1140 //     constructor () internal { }
1141 //     // solhint-disable-previous-line no-empty-blocks
1142 
1143 //     function _msgSender() internal view returns (address payable) {
1144 //         return msg.sender;
1145 //     }
1146 
1147 //     function _msgData() internal view returns (bytes memory) {
1148 //         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1149 //         return msg.data;
1150 //     }
1151 // }
1152 
1153 // // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/IERC20
1154 
1155 // /**
1156 //  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1157 //  * the optional functions; to access them see {ERC20Detailed}.
1158 //  */
1159 // interface IERC20 {
1160 //     /**
1161 //      * @dev Returns the amount of tokens in existence.
1162 //      */
1163 //     function totalSupply() external view returns (uint256);
1164 
1165 //     /**
1166 //      * @dev Returns the amount of tokens owned by `account`.
1167 //      */
1168 //     function balanceOf(address account) external view returns (uint256);
1169 
1170 //     /**
1171 //      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1172 //      *
1173 //      * Returns a boolean value indicating whether the operation succeeded.
1174 //      *
1175 //      * Emits a {Transfer} event.
1176 //      */
1177 //     function transfer(address recipient, uint256 amount) external returns (bool);
1178 
1179 //     /**
1180 //      * @dev Returns the remaining number of tokens that `spender` will be
1181 //      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1182 //      * zero by default.
1183 //      *
1184 //      * This value changes when {approve} or {transferFrom} are called.
1185 //      */
1186 //     function allowance(address owner, address spender) external view returns (uint256);
1187 
1188 //     /**
1189 //      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1190 //      *
1191 //      * Returns a boolean value indicating whether the operation succeeded.
1192 //      *
1193 //      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1194 //      * that someone may use both the old and the new allowance by unfortunate
1195 //      * transaction ordering. One possible solution to mitigate this race
1196 //      * condition is to first reduce the spender's allowance to 0 and set the
1197 //      * desired value afterwards:
1198 //      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1199 //      *
1200 //      * Emits an {Approval} event.
1201 //      */
1202 //     function approve(address spender, uint256 amount) external returns (bool);
1203 
1204 //     /**
1205 //      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1206 //      * allowance mechanism. `amount` is then deducted from the caller's
1207 //      * allowance.
1208 //      *
1209 //      * Returns a boolean value indicating whether the operation succeeded.
1210 //      *
1211 //      * Emits a {Transfer} event.
1212 //      */
1213 //     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1214 
1215 //     /**
1216 //      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1217 //      * another (`to`).
1218 //      *
1219 //      * Note that `value` may be zero.
1220 //      */
1221 //     event Transfer(address indexed from, address indexed to, uint256 value);
1222 
1223 //     /**
1224 //      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1225 //      * a call to {approve}. `value` is the new allowance.
1226 //      */
1227 //     event Approval(address indexed owner, address indexed spender, uint256 value);
1228 // }
1229 
1230 // // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/SafeMath
1231 
1232 // /**
1233 //  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1234 //  * checks.
1235 //  *
1236 //  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1237 //  * in bugs, because programmers usually assume that an overflow raises an
1238 //  * error, which is the standard behavior in high level programming languages.
1239 //  * `SafeMath` restores this intuition by reverting the transaction when an
1240 //  * operation overflows.
1241 //  *
1242 //  * Using this library instead of the unchecked operations eliminates an entire
1243 //  * class of bugs, so it's recommended to use it always.
1244 //  */
1245 // library SafeMath {
1246 //     /**
1247 //      * @dev Returns the addition of two unsigned integers, reverting on
1248 //      * overflow.
1249 //      *
1250 //      * Counterpart to Solidity's `+` operator.
1251 //      *
1252 //      * Requirements:
1253 //      * - Addition cannot overflow.
1254 //      */
1255 //     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1256 //         uint256 c = a + b;
1257 //         require(c >= a, "SafeMath: addition overflow");
1258 
1259 //         return c;
1260 //     }
1261 
1262 //     /**
1263 //      * @dev Returns the subtraction of two unsigned integers, reverting on
1264 //      * overflow (when the result is negative).
1265 //      *
1266 //      * Counterpart to Solidity's `-` operator.
1267 //      *
1268 //      * Requirements:
1269 //      * - Subtraction cannot overflow.
1270 //      */
1271 //     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1272 //         return sub(a, b, "SafeMath: subtraction overflow");
1273 //     }
1274 
1275 //     /**
1276 //      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1277 //      * overflow (when the result is negative).
1278 //      *
1279 //      * Counterpart to Solidity's `-` operator.
1280 //      *
1281 //      * Requirements:
1282 //      * - Subtraction cannot overflow.
1283 //      *
1284 //      * _Available since v2.4.0._
1285 //      */
1286 //     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1287 //         require(b <= a, errorMessage);
1288 //         uint256 c = a - b;
1289 
1290 //         return c;
1291 //     }
1292 
1293 //     /**
1294 //      * @dev Returns the multiplication of two unsigned integers, reverting on
1295 //      * overflow.
1296 //      *
1297 //      * Counterpart to Solidity's `*` operator.
1298 //      *
1299 //      * Requirements:
1300 //      * - Multiplication cannot overflow.
1301 //      */
1302 //     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1303 //         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1304 //         // benefit is lost if 'b' is also tested.
1305 //         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1306 //         if (a == 0) {
1307 //             return 0;
1308 //         }
1309 
1310 //         uint256 c = a * b;
1311 //         require(c / a == b, "SafeMath: multiplication overflow");
1312 
1313 //         return c;
1314 //     }
1315 
1316 //     /**
1317 //      * @dev Returns the integer division of two unsigned integers. Reverts on
1318 //      * division by zero. The result is rounded towards zero.
1319 //      *
1320 //      * Counterpart to Solidity's `/` operator. Note: this function uses a
1321 //      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1322 //      * uses an invalid opcode to revert (consuming all remaining gas).
1323 //      *
1324 //      * Requirements:
1325 //      * - The divisor cannot be zero.
1326 //      */
1327 //     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1328 //         return div(a, b, "SafeMath: division by zero");
1329 //     }
1330 
1331 //     /**
1332 //      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1333 //      * division by zero. The result is rounded towards zero.
1334 //      *
1335 //      * Counterpart to Solidity's `/` operator. Note: this function uses a
1336 //      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1337 //      * uses an invalid opcode to revert (consuming all remaining gas).
1338 //      *
1339 //      * Requirements:
1340 //      * - The divisor cannot be zero.
1341 //      *
1342 //      * _Available since v2.4.0._
1343 //      */
1344 //     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1345 //         // Solidity only automatically asserts when dividing by 0
1346 //         require(b > 0, errorMessage);
1347 //         uint256 c = a / b;
1348 //         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1349 
1350 //         return c;
1351 //     }
1352 
1353 //     /**
1354 //      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1355 //      * Reverts when dividing by zero.
1356 //      *
1357 //      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1358 //      * opcode (which leaves remaining gas untouched) while Solidity uses an
1359 //      * invalid opcode to revert (consuming all remaining gas).
1360 //      *
1361 //      * Requirements:
1362 //      * - The divisor cannot be zero.
1363 //      */
1364 //     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1365 //         return mod(a, b, "SafeMath: modulo by zero");
1366 //     }
1367 
1368 //     /**
1369 //      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1370 //      * Reverts with custom message when dividing by zero.
1371 //      *
1372 //      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1373 //      * opcode (which leaves remaining gas untouched) while Solidity uses an
1374 //      * invalid opcode to revert (consuming all remaining gas).
1375 //      *
1376 //      * Requirements:
1377 //      * - The divisor cannot be zero.
1378 //      *
1379 //      * _Available since v2.4.0._
1380 //      */
1381 //     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1382 //         require(b != 0, errorMessage);
1383 //         return a % b;
1384 //     }
1385 // }
1386 
1387 // // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/ERC20
1388 
1389 // /**
1390 //  * @dev Implementation of the {IERC20} interface.
1391 //  *
1392 //  * This implementation is agnostic to the way tokens are created. This means
1393 //  * that a supply mechanism has to be added in a derived contract using {_mint}.
1394 //  * For a generic mechanism see {ERC20Mintable}.
1395 //  *
1396 //  * TIP: For a detailed writeup see our guide
1397 //  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1398 //  * to implement supply mechanisms].
1399 //  *
1400 //  * We have followed general OpenZeppelin guidelines: functions revert instead
1401 //  * of returning `false` on failure. This behavior is nonetheless conventional
1402 //  * and does not conflict with the expectations of ERC20 applications.
1403 //  *
1404 //  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1405 //  * This allows applications to reconstruct the allowance for all accounts just
1406 //  * by listening to said events. Other implementations of the EIP may not emit
1407 //  * these events, as it isn't required by the specification.
1408 //  *
1409 //  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1410 //  * functions have been added to mitigate the well-known issues around setting
1411 //  * allowances. See {IERC20-approve}.
1412 //  */
1413 // contract ERC20 is Context, IERC20 {
1414 //     using SafeMath for uint256;
1415 
1416 //     mapping (address => uint256) private _balances;
1417 
1418 //     mapping (address => mapping (address => uint256)) private _allowances;
1419 
1420 //     uint256 private _totalSupply;
1421 
1422 //     /**
1423 //      * @dev See {IERC20-totalSupply}.
1424 //      */
1425 //     function totalSupply() public view returns (uint256) {
1426 //         return _totalSupply;
1427 //     }
1428 
1429 //     /**
1430 //      * @dev See {IERC20-balanceOf}.
1431 //      */
1432 //     function balanceOf(address account) public view returns (uint256) {
1433 //         return _balances[account];
1434 //     }
1435 
1436 //     /**
1437 //      * @dev See {IERC20-transfer}.
1438 //      *
1439 //      * Requirements:
1440 //      *
1441 //      * - `recipient` cannot be the zero address.
1442 //      * - the caller must have a balance of at least `amount`.
1443 //      */
1444 //     function transfer(address recipient, uint256 amount) public returns (bool) {
1445 //         _transfer(_msgSender(), recipient, amount);
1446 //         return true;
1447 //     }
1448 
1449 //     /**
1450 //      * @dev See {IERC20-allowance}.
1451 //      */
1452 //     function allowance(address owner, address spender) public view returns (uint256) {
1453 //         return _allowances[owner][spender];
1454 //     }
1455 
1456 //     /**
1457 //      * @dev See {IERC20-approve}.
1458 //      *
1459 //      * Requirements:
1460 //      *
1461 //      * - `spender` cannot be the zero address.
1462 //      */
1463 //     function approve(address spender, uint256 amount) public returns (bool) {
1464 //         _approve(_msgSender(), spender, amount);
1465 //         return true;
1466 //     }
1467 
1468 //     /**
1469 //      * @dev See {IERC20-transferFrom}.
1470 //      *
1471 //      * Emits an {Approval} event indicating the updated allowance. This is not
1472 //      * required by the EIP. See the note at the beginning of {ERC20};
1473 //      *
1474 //      * Requirements:
1475 //      * - `sender` and `recipient` cannot be the zero address.
1476 //      * - `sender` must have a balance of at least `amount`.
1477 //      * - the caller must have allowance for `sender`'s tokens of at least
1478 //      * `amount`.
1479 //      */
1480 //     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1481 //         _transfer(sender, recipient, amount);
1482 //         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1483 //         return true;
1484 //     }
1485 
1486 //     /**
1487 //      * @dev Atomically increases the allowance granted to `spender` by the caller.
1488 //      *
1489 //      * This is an alternative to {approve} that can be used as a mitigation for
1490 //      * problems described in {IERC20-approve}.
1491 //      *
1492 //      * Emits an {Approval} event indicating the updated allowance.
1493 //      *
1494 //      * Requirements:
1495 //      *
1496 //      * - `spender` cannot be the zero address.
1497 //      */
1498 //     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1499 //         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1500 //         return true;
1501 //     }
1502 
1503 //     /**
1504 //      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1505 //      *
1506 //      * This is an alternative to {approve} that can be used as a mitigation for
1507 //      * problems described in {IERC20-approve}.
1508 //      *
1509 //      * Emits an {Approval} event indicating the updated allowance.
1510 //      *
1511 //      * Requirements:
1512 //      *
1513 //      * - `spender` cannot be the zero address.
1514 //      * - `spender` must have allowance for the caller of at least
1515 //      * `subtractedValue`.
1516 //      */
1517 //     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1518 //         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1519 //         return true;
1520 //     }
1521 
1522 //     /**
1523 //      * @dev Moves tokens `amount` from `sender` to `recipient`.
1524 //      *
1525 //      * This is internal function is equivalent to {transfer}, and can be used to
1526 //      * e.g. implement automatic token fees, slashing mechanisms, etc.
1527 //      *
1528 //      * Emits a {Transfer} event.
1529 //      *
1530 //      * Requirements:
1531 //      *
1532 //      * - `sender` cannot be the zero address.
1533 //      * - `recipient` cannot be the zero address.
1534 //      * - `sender` must have a balance of at least `amount`.
1535 //      */
1536 //     function _transfer(address sender, address recipient, uint256 amount) internal {
1537 //         require(sender != address(0), "ERC20: transfer from the zero address");
1538 //         require(recipient != address(0), "ERC20: transfer to the zero address");
1539 
1540 //         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1541 //         _balances[recipient] = _balances[recipient].add(amount);
1542 //         emit Transfer(sender, recipient, amount);
1543 //     }
1544 
1545 //     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1546 //      * the total supply.
1547 //      *
1548 //      * Emits a {Transfer} event with `from` set to the zero address.
1549 //      *
1550 //      * Requirements
1551 //      *
1552 //      * - `to` cannot be the zero address.
1553 //      */
1554 //     function _mint(address account, uint256 amount) internal {
1555 //         require(account != address(0), "ERC20: mint to the zero address");
1556 
1557 //         _totalSupply = _totalSupply.add(amount);
1558 //         _balances[account] = _balances[account].add(amount);
1559 //         emit Transfer(address(0), account, amount);
1560 //     }
1561 
1562 //     /**
1563 //      * @dev Destroys `amount` tokens from `account`, reducing the
1564 //      * total supply.
1565 //      *
1566 //      * Emits a {Transfer} event with `to` set to the zero address.
1567 //      *
1568 //      * Requirements
1569 //      *
1570 //      * - `account` cannot be the zero address.
1571 //      * - `account` must have at least `amount` tokens.
1572 //      */
1573 //     function _burn(address account, uint256 amount) internal {
1574 //         require(account != address(0), "ERC20: burn from the zero address");
1575 
1576 //         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1577 //         _totalSupply = _totalSupply.sub(amount);
1578 //         emit Transfer(account, address(0), amount);
1579 //     }
1580 
1581 //     /**
1582 //      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1583 //      *
1584 //      * This is internal function is equivalent to `approve`, and can be used to
1585 //      * e.g. set automatic allowances for certain subsystems, etc.
1586 //      *
1587 //      * Emits an {Approval} event.
1588 //      *
1589 //      * Requirements:
1590 //      *
1591 //      * - `owner` cannot be the zero address.
1592 //      * - `spender` cannot be the zero address.
1593 //      */
1594 //     function _approve(address owner, address spender, uint256 amount) internal {
1595 //         require(owner != address(0), "ERC20: approve from the zero address");
1596 //         require(spender != address(0), "ERC20: approve to the zero address");
1597 
1598 //         _allowances[owner][spender] = amount;
1599 //         emit Approval(owner, spender, amount);
1600 //     }
1601 
1602 //     /**
1603 //      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1604 //      * from the caller's allowance.
1605 //      *
1606 //      * See {_burn} and {_approve}.
1607 //      */
1608 //     function _burnFrom(address account, uint256 amount) internal {
1609 //         _burn(account, amount);
1610 //         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1611 //     }
1612 // }
1613 
1614 // // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/ERC20Detailed
1615 
1616 // /**
1617 //  * @dev Optional functions from the ERC20 standard.
1618 //  */
1619 // contract ERC20Detailed is IERC20 {
1620 //     string private _name;
1621 //     string private _symbol;
1622 //     uint8 private _decimals;
1623 
1624 //     /**
1625 //      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1626 //      * these values are immutable: they can only be set once during
1627 //      * construction.
1628 //      */
1629 //     constructor (string memory name, string memory symbol, uint8 decimals) public {
1630 //         _name = name;
1631 //         _symbol = symbol;
1632 //         _decimals = decimals;
1633 //     }
1634 
1635 //     /**
1636 //      * @dev Returns the name of the token.
1637 //      */
1638 //     function name() public view returns (string memory) {
1639 //         return _name;
1640 //     }
1641 
1642 //     /**
1643 //      * @dev Returns the symbol of the token, usually a shorter version of the
1644 //      * name.
1645 //      */
1646 //     function symbol() public view returns (string memory) {
1647 //         return _symbol;
1648 //     }
1649 
1650 //     /**
1651 //      * @dev Returns the number of decimals used to get its user representation.
1652 //      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1653 //      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1654 //      *
1655 //      * Tokens usually opt for a value of 18, imitating the relationship between
1656 //      * Ether and Wei.
1657 //      *
1658 //      * NOTE: This information is only used for _display_ purposes: it in
1659 //      * no way affects any of the arithmetic of the contract, including
1660 //      * {IERC20-balanceOf} and {IERC20-transfer}.
1661 //      */
1662 //     function decimals() public view returns (uint8) {
1663 //         return _decimals;
1664 //     }
1665 // }
1666 
1667 // // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/SafeERC20
1668 
1669 // /**
1670 //  * @title SafeERC20
1671 //  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1672 //  * contract returns false). Tokens that return no value (and instead revert or
1673 //  * throw on failure) are also supported, non-reverting calls are assumed to be
1674 //  * successful.
1675 //  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1676 //  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1677 //  */
1678 // library SafeERC20 {
1679 //     using SafeMath for uint256;
1680 //     using Address for address;
1681 
1682 //     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1683 //         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1684 //     }
1685 
1686 //     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1687 //         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1688 //     }
1689 
1690 //     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1691 //         // safeApprove should only be called when setting an initial allowance,
1692 //         // or when resetting it to zero. To increase and decrease it, use
1693 //         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1694 //         // solhint-disable-next-line max-line-length
1695 //         require((value == 0) || (token.allowance(address(this), spender) == 0),
1696 //             "SafeERC20: approve from non-zero to non-zero allowance"
1697 //         );
1698 //         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1699 //     }
1700 
1701 //     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1702 //         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1703 //         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1704 //     }
1705 
1706 //     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1707 //         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1708 //         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1709 //     }
1710 
1711 //     /**
1712 //      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1713 //      * on the return value: the return value is optional (but if data is returned, it must not be false).
1714 //      * @param token The token targeted by the call.
1715 //      * @param data The call data (encoded using abi.encode or one of its variants).
1716 //      */
1717 //     function callOptionalReturn(IERC20 token, bytes memory data) private {
1718 //         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1719 //         // we're implementing it ourselves.
1720 
1721 //         // A Solidity high level call has three parts:
1722 //         //  1. The target address is checked to verify it contains contract code
1723 //         //  2. The call itself is made, and success asserted
1724 //         //  3. The return value is decoded, which in turn checks the size of the returned data.
1725 //         // solhint-disable-next-line max-line-length
1726 //         require(address(token).isContract(), "SafeERC20: call to non-contract");
1727 
1728 //         // solhint-disable-next-line avoid-low-level-calls
1729 //         (bool success, bytes memory returndata) = address(token).call(data);
1730 //         require(success, "SafeERC20: low-level call failed");
1731 
1732 //         if (returndata.length > 0) { // Return data is optional
1733 //             // solhint-disable-next-line max-line-length
1734 //             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1735 //         }
1736 //     }
1737 // }
1738 
1739 // // File: Vault.sol
1740 
1741 // contract Vault is ERC20, ERC20Detailed {
1742 //     using SafeERC20 for IERC20;
1743 //     using Address for address;
1744 //     using SafeMath for uint256;
1745 
1746 //     IERC20 public token;
1747 
1748 //     uint256 public min = 9500;
1749 //     uint256 public constant max = 10000;
1750 
1751 //     address public governance;
1752 //     address public controller;
1753 
1754 //     constructor (
1755 //         address _token,
1756 //         address _controller,
1757 //         address _governance
1758 //     )
1759 //         public
1760 //         ERC20Detailed(
1761 //             string(
1762 //                 abi.encodePacked("Stake DAO ", ERC20Detailed(_token).name())
1763 //             ),
1764 //             string(abi.encodePacked("sd", ERC20Detailed(_token).symbol())),
1765 //             ERC20Detailed(_token).decimals()
1766 //         )
1767 //     {
1768 //         token = IERC20(_token);
1769 //         controller = _controller;
1770 //         governance = _governance;
1771 //     }
1772 
1773 //     function balance() public view returns (uint256) {
1774 //         return
1775 //             token.balanceOf(address(this)).add(
1776 //                 IController(controller).balanceOf(address(token))
1777 //             );
1778 //     }
1779 
1780 //     function setMin(uint256 _min) external {
1781 //         require(msg.sender == governance, "!governance");
1782 //         min = _min;
1783 //     }
1784 
1785 //     function setGovernance(address _governance) public {
1786 //         require(msg.sender == governance, "!governance");
1787 //         governance = _governance;
1788 //     }
1789 
1790 //     function setController(address _controller) public {
1791 //         require(msg.sender == governance, "!governance");
1792 //         controller = _controller;
1793 //     }
1794 
1795 //     // Custom logic in here for how much the vault allows to be borrowed
1796 //     // Sets minimum required on-hand to keep small withdrawals cheap
1797 //     function available() public view returns (uint256) {
1798 //         return token.balanceOf(address(this)).mul(min).div(max);
1799 //     }
1800 
1801 //     function earn() public {
1802 //         uint256 _bal = available();
1803 //         token.safeTransfer(controller, _bal);
1804 //         IController(controller).earn(address(token), _bal);
1805 //     }
1806 
1807 //     function depositAll() external {
1808 //         deposit(token.balanceOf(msg.sender));
1809 //     }
1810 
1811 //     function deposit(uint256 _amount) public {
1812 //         uint256 _pool = balance();
1813 //         uint256 _before = token.balanceOf(address(this));
1814 //         token.safeTransferFrom(msg.sender, address(this), _amount);
1815 //         uint256 _after = token.balanceOf(address(this));
1816 //         _amount = _after.sub(_before); // Additional check for deflationary tokens
1817 //         uint256 shares = 0;
1818 //         if (totalSupply() == 0) {
1819 //             shares = _amount;
1820 //         } else {
1821 //             shares = (_amount.mul(totalSupply())).div(_pool);
1822 //         }
1823 //         _mint(msg.sender, shares);
1824 //     }
1825 
1826 //     function withdrawAll() external {
1827 //         withdraw(balanceOf(msg.sender));
1828 //     }
1829 
1830 //     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
1831 //     function harvest(address reserve, uint256 amount) external {
1832 //         require(msg.sender == controller, "!controller");
1833 //         require(reserve != address(token), "token");
1834 //         IERC20(reserve).safeTransfer(controller, amount);
1835 //     }
1836 
1837 //     // No rebalance implementation for lower fees and faster swaps
1838 //     function withdraw(uint256 _shares) public {
1839 //         uint256 r = (balance().mul(_shares)).div(totalSupply());
1840 //         _burn(msg.sender, _shares);
1841 
1842 //         // Check balance
1843 //         uint256 b = token.balanceOf(address(this));
1844 //         if (b < r) {
1845 //             uint256 _withdraw = r.sub(b);
1846 //             IController(controller).withdraw(address(token), _withdraw);
1847 //             uint256 _after = token.balanceOf(address(this));
1848 //             uint256 _diff = _after.sub(b);
1849 //             if (_diff < _withdraw) {
1850 //                 r = b.add(_diff);
1851 //             }
1852 //         }
1853 
1854 //         token.safeTransfer(msg.sender, r);
1855 //     }
1856 
1857 //     function getPricePerFullShare() public view returns (uint256) {
1858 //         return
1859 //             totalSupply() == 0 ? 1e18 : balance().mul(1e18).div(totalSupply());
1860 //     }
1861 // }
1862 
1863 
1864 // File contracts/Curve/IFraxGaugeController.sol
1865 
1866 
1867 // https://github.com/swervefi/swerve/edit/master/packages/swerve-contracts/interfaces/IGaugeController.sol
1868 
1869 interface IFraxGaugeController {
1870     struct Point {
1871         uint256 bias;
1872         uint256 slope;
1873     }
1874 
1875     struct VotedSlope {
1876         uint256 slope;
1877         uint256 power;
1878         uint256 end;
1879     }
1880 
1881     // Public variables
1882     function admin() external view returns (address);
1883     function future_admin() external view returns (address);
1884     function token() external view returns (address);
1885     function voting_escrow() external view returns (address);
1886     function n_gauge_types() external view returns (int128);
1887     function n_gauges() external view returns (int128);
1888     function gauge_type_names(int128) external view returns (string memory);
1889     function gauges(uint256) external view returns (address);
1890     function vote_user_slopes(address, address)
1891         external
1892         view
1893         returns (VotedSlope memory);
1894     function vote_user_power(address) external view returns (uint256);
1895     function last_user_vote(address, address) external view returns (uint256);
1896     function points_weight(address, uint256)
1897         external
1898         view
1899         returns (Point memory);
1900     function time_weight(address) external view returns (uint256);
1901     function points_sum(int128, uint256) external view returns (Point memory);
1902     function time_sum(uint256) external view returns (uint256);
1903     function points_total(uint256) external view returns (uint256);
1904     function time_total() external view returns (uint256);
1905     function points_type_weight(int128, uint256)
1906         external
1907         view
1908         returns (uint256);
1909     function time_type_weight(uint256) external view returns (uint256);
1910 
1911     // Getter functions
1912     function gauge_types(address) external view returns (int128);
1913     function gauge_relative_weight(address) external view returns (uint256);
1914     function gauge_relative_weight(address, uint256) external view returns (uint256);
1915     function get_gauge_weight(address) external view returns (uint256);
1916     function get_type_weight(int128) external view returns (uint256);
1917     function get_total_weight() external view returns (uint256);
1918     function get_weights_sum_per_type(int128) external view returns (uint256);
1919 
1920     // External functions
1921     function commit_transfer_ownership(address) external;
1922     function apply_transfer_ownership() external;
1923     function add_gauge(
1924         address,
1925         int128,
1926         uint256
1927     ) external;
1928     function checkpoint() external;
1929     function checkpoint_gauge(address) external;
1930     function global_emission_rate() external view returns (uint256);
1931     function gauge_relative_weight_write(address)
1932         external
1933         returns (uint256);
1934     function gauge_relative_weight_write(address, uint256)
1935         external
1936         returns (uint256);
1937     function add_type(string memory, uint256) external;
1938     function change_type_weight(int128, uint256) external;
1939     function change_gauge_weight(address, uint256) external;
1940     function change_global_emission_rate(uint256) external;
1941     function vote_for_gauge_weights(address, uint256) external;
1942 }
1943 
1944 
1945 // File contracts/Curve/IFraxGaugeFXSRewardsDistributor.sol
1946 
1947 
1948 interface IFraxGaugeFXSRewardsDistributor {
1949   function acceptOwnership() external;
1950   function curator_address() external view returns(address);
1951   function currentReward(address gauge_address) external view returns(uint256 reward_amount);
1952   function distributeReward(address gauge_address) external returns(uint256 weeks_elapsed, uint256 reward_tally);
1953   function distributionsOn() external view returns(bool);
1954   function gauge_whitelist(address) external view returns(bool);
1955   function is_middleman(address) external view returns(bool);
1956   function last_time_gauge_paid(address) external view returns(uint256);
1957   function nominateNewOwner(address _owner) external;
1958   function nominatedOwner() external view returns(address);
1959   function owner() external view returns(address);
1960   function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
1961   function setCurator(address _new_curator_address) external;
1962   function setGaugeController(address _gauge_controller_address) external;
1963   function setGaugeState(address _gauge_address, bool _is_middleman, bool _is_active) external;
1964   function setTimelock(address _new_timelock) external;
1965   function timelock_address() external view returns(address);
1966   function toggleDistributions() external;
1967 }
1968 
1969 
1970 // File contracts/Utils/ReentrancyGuard.sol
1971 
1972 
1973 /**
1974  * @dev Contract module that helps prevent reentrant calls to a function.
1975  *
1976  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1977  * available, which can be applied to functions to make sure there are no nested
1978  * (reentrant) calls to them.
1979  *
1980  * Note that because there is a single `nonReentrant` guard, functions marked as
1981  * `nonReentrant` may not call one another. This can be worked around by making
1982  * those functions `private`, and then adding `external` `nonReentrant` entry
1983  * points to them.
1984  *
1985  * TIP: If you would like to learn more about reentrancy and alternative ways
1986  * to protect against it, check out our blog post
1987  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1988  */
1989 abstract contract ReentrancyGuard {
1990     // Booleans are more expensive than uint256 or any type that takes up a full
1991     // word because each write operation emits an extra SLOAD to first read the
1992     // slot's contents, replace the bits taken up by the boolean, and then write
1993     // back. This is the compiler's defense against contract upgrades and
1994     // pointer aliasing, and it cannot be disabled.
1995 
1996     // The values being non-zero value makes deployment a bit more expensive,
1997     // but in exchange the refund on every call to nonReentrant will be lower in
1998     // amount. Since refunds are capped to a percentage of the total
1999     // transaction's gas, it is best to keep them low in cases like this one, to
2000     // increase the likelihood of the full refund coming into effect.
2001     uint256 private constant _NOT_ENTERED = 1;
2002     uint256 private constant _ENTERED = 2;
2003 
2004     uint256 private _status;
2005 
2006     constructor () internal {
2007         _status = _NOT_ENTERED;
2008     }
2009 
2010     /**
2011      * @dev Prevents a contract from calling itself, directly or indirectly.
2012      * Calling a `nonReentrant` function from another `nonReentrant`
2013      * function is not supported. It is possible to prevent this from happening
2014      * by making the `nonReentrant` function external, and make it call a
2015      * `private` function that does the actual work.
2016      */
2017     modifier nonReentrant() {
2018         // On the first call to nonReentrant, _notEntered will be true
2019         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2020 
2021         // Any calls to nonReentrant after this point will fail
2022         _status = _ENTERED;
2023 
2024         _;
2025 
2026         // By storing the original value once again, a refund is triggered (see
2027         // https://eips.ethereum.org/EIPS/eip-2200)
2028         _status = _NOT_ENTERED;
2029     }
2030 }
2031 
2032 
2033 // File contracts/Staking/Owned.sol
2034 
2035 
2036 // https://docs.synthetix.io/contracts/Owned
2037 contract Owned {
2038     address public owner;
2039     address public nominatedOwner;
2040 
2041     constructor (address _owner) public {
2042         require(_owner != address(0), "Owner address cannot be 0");
2043         owner = _owner;
2044         emit OwnerChanged(address(0), _owner);
2045     }
2046 
2047     function nominateNewOwner(address _owner) external onlyOwner {
2048         nominatedOwner = _owner;
2049         emit OwnerNominated(_owner);
2050     }
2051 
2052     function acceptOwnership() external {
2053         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
2054         emit OwnerChanged(owner, nominatedOwner);
2055         owner = nominatedOwner;
2056         nominatedOwner = address(0);
2057     }
2058 
2059     modifier onlyOwner {
2060         require(msg.sender == owner, "Only the contract owner may perform this action");
2061         _;
2062     }
2063 
2064     event OwnerNominated(address newOwner);
2065     event OwnerChanged(address oldOwner, address newOwner);
2066 }
2067 
2068 
2069 // File contracts/Staking/StakingRewardsMultiGauge.sol
2070 
2071 pragma experimental ABIEncoderV2;
2072 
2073 // ====================================================================
2074 // |     ______                   _______                             |
2075 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
2076 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
2077 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
2078 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
2079 // |                                                                  |
2080 // ====================================================================
2081 // ===================== StakingRewardsMultiGauge =====================
2082 // ====================================================================
2083 // veFXS-enabled
2084 // Multiple tokens with different reward rates can be emitted
2085 // Multiple teams can set the reward rates for their token(s)
2086 // Those teams can also use a gauge, or an external function with 
2087 // Apes together strong
2088 
2089 // Frax Finance: https://github.com/FraxFinance
2090 
2091 // Primary Author(s)
2092 // Travis Moore: https://github.com/FortisFortuna
2093 
2094 // Reviewer(s) / Contributor(s)
2095 // Jason Huan: https://github.com/jasonhuan 
2096 // Sam Kazemian: https://github.com/samkazemian
2097 // Saddle Team: https://github.com/saddle-finance
2098 // Fei Team: https://github.com/fei-protocol
2099 // Alchemix Team: https://github.com/alchemix-finance
2100 // Liquity Team: https://github.com/liquity
2101 
2102 // Originally inspired by Synthetix.io, but heavily modified by the Frax team
2103 // https://raw.githubusercontent.com/Synthetixio/synthetix/develop/contracts/StakingRewards.sol
2104 
2105 
2106 
2107 
2108 
2109 
2110 // -------------------- VARIES --------------------
2111 
2112 // mStable
2113 // import '../Misc_AMOs/mstable/IFeederPool.sol';
2114 
2115 // StakeDAO
2116 
2117 // import '../Curve/IMetaImplementationUSD.sol';
2118 
2119 // Uniswap V2
2120 // import '../Uniswap/Interfaces/IUniswapV2Pair.sol';
2121 
2122 // ------------------------------------------------
2123 
2124 
2125 
2126 // Inheritance
2127 
2128 contract StakingRewardsMultiGauge is Owned, ReentrancyGuard {
2129     using SafeMath for uint256;
2130     using SafeERC20 for ERC20;
2131 
2132     /* ========== STATE VARIABLES ========== */
2133 
2134     // Instances
2135     IveFXS private veFXS = IveFXS(0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0);
2136 
2137     // -------------------- VARIES --------------------
2138     
2139     // mStable
2140     // IFeederPool public stakingToken;
2141 
2142     // StakeDAO Vault
2143     IStakeDaoVault public stakingToken;
2144     
2145     // Uniswap V2
2146     // IUniswapV2Pair public stakingToken;
2147 
2148     // ------------------------------------------------
2149 
2150     IFraxGaugeFXSRewardsDistributor public rewards_distributor;
2151 
2152     // FRAX
2153     address private constant frax_address = 0x853d955aCEf822Db058eb8505911ED77F175b99e;
2154     
2155     // Constant for various precisions
2156     uint256 private constant MULTIPLIER_PRECISION = 1e18;
2157 
2158     // Time tracking
2159     uint256 public periodFinish;
2160     uint256 public lastUpdateTime;
2161 
2162     // Lock time and multiplier settings
2163     uint256 public lock_max_multiplier = uint256(3e18); // E18. 1x = e18
2164     uint256 public lock_time_for_max_multiplier = 3 * 365 * 86400; // 3 years
2165     uint256 public lock_time_min = 86400; // 1 * 86400  (1 day)
2166 
2167     // veFXS related
2168     uint256 public vefxs_per_frax_for_max_boost = uint256(4e18); // E18. 4e18 means 4 veFXS must be held by the staker per 1 FRAX
2169     uint256 public vefxs_max_multiplier = uint256(2e18); // E18. 1x = 1e18
2170     mapping(address => uint256) private _vefxsMultiplierStored;
2171 
2172     // Reward addresses, gauge addresses, reward rates, and reward managers
2173     mapping(address => address) public rewardManagers; // token addr -> manager addr
2174     address[] public rewardTokens;
2175     address[] public gaugeControllers;
2176     uint256[] public rewardRatesManual;
2177     string[] public rewardSymbols;
2178     mapping(address => uint256) public rewardTokenAddrToIdx; // token addr -> token index
2179     
2180     // Reward period
2181     uint256 public rewardsDuration = 604800; // 7 * 86400  (7 days)
2182 
2183     // Reward tracking
2184     uint256[] private rewardsPerTokenStored;
2185     mapping(address => mapping(uint256 => uint256)) private userRewardsPerTokenPaid; // staker addr -> token id -> paid amount
2186     mapping(address => mapping(uint256 => uint256)) private rewards; // staker addr -> token id -> reward amount
2187     mapping(address => uint256) private lastRewardClaimTime; // staker addr -> timestamp
2188     uint256[] private last_gauge_relative_weights;
2189     uint256[] private last_gauge_time_totals;
2190 
2191     // Balance tracking
2192     uint256 private _total_liquidity_locked;
2193     uint256 private _total_combined_weight;
2194     mapping(address => uint256) private _locked_liquidity;
2195     mapping(address => uint256) private _combined_weights;
2196 
2197     // List of valid migrators (set by governance)
2198     mapping(address => bool) public valid_migrators;
2199 
2200     // Stakers set which migrator(s) they want to use
2201     mapping(address => mapping(address => bool)) public staker_allowed_migrators;
2202 
2203     // Uniswap V2 ONLY
2204     bool frax_is_token0;
2205 
2206     // Stake tracking
2207     mapping(address => LockedStake[]) private lockedStakes;
2208 
2209     // Greylisting of bad addresses
2210     mapping(address => bool) public greylist;
2211 
2212     // Administrative booleans
2213     bool public stakesUnlocked; // Release locked stakes in case of emergency
2214     bool public migrationsOn; // Used for migrations. Prevents new stakes, but allows LP and reward withdrawals
2215     bool public withdrawalsPaused; // For emergencies
2216     bool public rewardsCollectionPaused; // For emergencies
2217     bool public stakingPaused; // For emergencies
2218 
2219     /* ========== STRUCTS ========== */
2220     
2221     struct LockedStake {
2222         bytes32 kek_id;
2223         uint256 start_timestamp;
2224         uint256 liquidity;
2225         uint256 ending_timestamp;
2226         uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
2227     }
2228 
2229     /* ========== MODIFIERS ========== */
2230 
2231     modifier onlyByOwner() {
2232         require(msg.sender == owner, "Not the owner");
2233         _;
2234     }
2235 
2236     modifier onlyTknMgrs(address reward_token_address) {
2237         require(msg.sender == owner || isTokenManagerFor(msg.sender, reward_token_address), "Not owner or tkn mgr");
2238         _;
2239     }
2240 
2241 
2242     modifier isMigrating() {
2243         require(migrationsOn == true, "Not in migration");
2244         _;
2245     }
2246 
2247     modifier notStakingPaused() {
2248         require(stakingPaused == false, "Staking paused");
2249         _;
2250     }
2251 
2252     modifier updateRewardAndBalance(address account, bool sync_too) {
2253         _updateRewardAndBalance(account, sync_too);
2254         _;
2255     }
2256     
2257     /* ========== CONSTRUCTOR ========== */
2258 
2259     constructor (
2260         address _owner,
2261         address _stakingToken,
2262         address _rewards_distributor_address,
2263         string[] memory _rewardSymbols,
2264         address[] memory _rewardTokens,
2265         address[] memory _rewardManagers,
2266         uint256[] memory _rewardRatesManual,
2267         address[] memory _gaugeControllers
2268     ) Owned(_owner){
2269 
2270         // -------------------- VARIES --------------------
2271         // mStable
2272         // stakingToken = IFeederPool(_stakingToken);
2273 
2274         // StakeDAO
2275         stakingToken = IStakeDaoVault(_stakingToken);
2276 
2277         // Uniswap V2
2278         // stakingToken = IUniswapV2Pair(_stakingToken);
2279         // address token0 = stakingToken.token0();
2280         // if (token0 == frax_address) frax_is_token0 = true;
2281         // else frax_is_token0 = false;
2282         // ------------------------------------------------
2283 
2284         rewards_distributor = IFraxGaugeFXSRewardsDistributor(_rewards_distributor_address);
2285 
2286         rewardTokens = _rewardTokens;
2287         gaugeControllers = _gaugeControllers;
2288         rewardRatesManual = _rewardRatesManual;
2289         rewardSymbols = _rewardSymbols;
2290 
2291         for (uint256 i = 0; i < _rewardTokens.length; i++){ 
2292             // For fast token address -> token ID lookups later
2293             rewardTokenAddrToIdx[_rewardTokens[i]] = i;
2294 
2295             // Initialize the stored rewards
2296             rewardsPerTokenStored.push(0);
2297 
2298             // Initialize the reward managers
2299             rewardManagers[_rewardTokens[i]] = _rewardManagers[i];
2300 
2301             // Push in empty relative weights to initialize the array
2302             last_gauge_relative_weights.push(0);
2303 
2304             // Push in empty time totals to initialize the array
2305             last_gauge_time_totals.push(0);
2306         }
2307 
2308         // Other booleans
2309         stakesUnlocked = false;
2310 
2311         // Initialization
2312         lastUpdateTime = block.timestamp;
2313         periodFinish = block.timestamp.add(rewardsDuration);
2314 
2315     }
2316 
2317     /* ========== VIEWS ========== */
2318 
2319     // Total locked liquidity tokens
2320     function totalLiquidityLocked() external view returns (uint256) {
2321         return _total_liquidity_locked;
2322     }
2323 
2324     // Locked liquidity for a given account
2325     function lockedLiquidityOf(address account) external view returns (uint256) {
2326         return _locked_liquidity[account];
2327     }
2328 
2329     // Total 'balance' used for calculating the percent of the pool the account owns
2330     // Takes into account the locked stake time multiplier
2331     function totalCombinedWeight() external view returns (uint256) {
2332         return _total_combined_weight;
2333     }
2334 
2335     // Combined weight for a specific account
2336     function combinedWeightOf(address account) external view returns (uint256) {
2337         return _combined_weights[account];
2338     }
2339 
2340     function fraxPerLPToken() public view returns (uint256) {
2341         // Get the amount of FRAX 'inside' of the lp tokens
2342         uint256 frax_per_lp_token;
2343 
2344         // // Uniswap V2
2345         // // ============================================
2346         // {
2347         //     uint256 total_frax_reserves;
2348         //     (uint256 reserve0, uint256 reserve1, ) = (stakingToken.getReserves());
2349         //     if (frax_is_token0) total_frax_reserves = reserve0;
2350         //     else total_frax_reserves = reserve1;
2351 
2352         //     frax_per_lp_token = total_frax_reserves.mul(1e18).div(stakingToken.totalSupply());
2353         // }
2354 
2355         // // mStable
2356         // // ============================================
2357         // {
2358         //     uint256 total_frax_reserves;
2359         //     (, IFeederPool.BassetData memory vaultData) = (stakingToken.getBasset(frax_address));
2360         //     total_frax_reserves = uint256(vaultData.vaultBalance);
2361         //     frax_per_lp_token = total_frax_reserves.mul(1e18).div(stakingToken.totalSupply());
2362         // }
2363 
2364         // StakeDAO
2365         // ============================================
2366         {
2367             uint256 frax3crv_held = stakingToken.balance();
2368 
2369             // Optimistically assume 50/50 FRAX/3CRV ratio in the metapool to save gas
2370             frax_per_lp_token = frax3crv_held.mul(1e18).div(stakingToken.totalSupply()) / 2;
2371         }
2372 
2373         return frax_per_lp_token;
2374     }
2375 
2376     function userStakedFrax(address account) public view returns (uint256) {
2377         return (fraxPerLPToken()).mul(_locked_liquidity[account]).div(1e18);
2378     }
2379 
2380     function minVeFXSForMaxBoost(address account) public view returns (uint256) {
2381         return (userStakedFrax(account)).mul(vefxs_per_frax_for_max_boost).div(MULTIPLIER_PRECISION);
2382     }
2383 
2384     function veFXSMultiplier(address account) public view returns (uint256) {
2385         // The claimer gets a boost depending on amount of veFXS they have relative to the amount of FRAX 'inside'
2386         // of their locked LP tokens
2387         uint256 veFXS_needed_for_max_boost = minVeFXSForMaxBoost(account);
2388         if (veFXS_needed_for_max_boost > 0){ 
2389             uint256 user_vefxs_fraction = (veFXS.balanceOf(account)).mul(MULTIPLIER_PRECISION).div(veFXS_needed_for_max_boost);
2390             
2391             uint256 vefxs_multiplier = ((user_vefxs_fraction).mul(vefxs_max_multiplier)).div(MULTIPLIER_PRECISION);
2392 
2393             // Cap the boost to the vefxs_max_multiplier
2394             if (vefxs_multiplier > vefxs_max_multiplier) vefxs_multiplier = vefxs_max_multiplier;
2395 
2396             return vefxs_multiplier;        
2397         }
2398         else return 0; // This will happen with the first stake, when user_staked_frax is 0
2399     }
2400 
2401     // Calculated the combined weight for an account
2402     function calcCurCombinedWeight(address account) public view
2403         returns (
2404             uint256 old_combined_weight,
2405             uint256 new_vefxs_multiplier,
2406             uint256 new_combined_weight
2407         )
2408     {
2409         // Get the old combined weight
2410         old_combined_weight = _combined_weights[account];
2411 
2412         // Get the veFXS multipliers
2413         // For the calculations, use the midpoint (analogous to midpoint Riemann sum)
2414         new_vefxs_multiplier = veFXSMultiplier(account);
2415 
2416         uint256 midpoint_vefxs_multiplier;
2417         if (_locked_liquidity[account] == 0 && _combined_weights[account] == 0) {
2418             // This is only called for the first stake to make sure the veFXS multiplier is not cut in half
2419             midpoint_vefxs_multiplier = new_vefxs_multiplier;
2420         }
2421         else {
2422             midpoint_vefxs_multiplier = ((new_vefxs_multiplier).add(_vefxsMultiplierStored[account])).div(2);
2423         }
2424 
2425         // Loop through the locked stakes, first by getting the liquidity * lock_multiplier portion
2426         new_combined_weight = 0;
2427         for (uint256 i = 0; i < lockedStakes[account].length; i++) {
2428             LockedStake memory thisStake = lockedStakes[account][i];
2429             uint256 lock_multiplier = thisStake.lock_multiplier;
2430 
2431             // If the lock is expired
2432             if (thisStake.ending_timestamp <= block.timestamp) {
2433                 // If the lock expired in the time since the last claim, the weight needs to be proportionately averaged this time
2434                 if (lastRewardClaimTime[account] < thisStake.ending_timestamp){
2435                     uint256 time_before_expiry = (thisStake.ending_timestamp).sub(lastRewardClaimTime[account]);
2436                     uint256 time_after_expiry = (block.timestamp).sub(thisStake.ending_timestamp);
2437 
2438                     // Get the weighted-average lock_multiplier
2439                     uint256 numerator = ((lock_multiplier).mul(time_before_expiry)).add(((MULTIPLIER_PRECISION).mul(time_after_expiry)));
2440                     lock_multiplier = numerator.div(time_before_expiry.add(time_after_expiry));
2441                 }
2442                 // Otherwise, it needs to just be 1x
2443                 else {
2444                     lock_multiplier = MULTIPLIER_PRECISION;
2445                 }
2446             }
2447 
2448             uint256 liquidity = thisStake.liquidity;
2449             uint256 combined_boosted_amount = liquidity.mul(lock_multiplier.add(midpoint_vefxs_multiplier)).div(MULTIPLIER_PRECISION);
2450             new_combined_weight = new_combined_weight.add(combined_boosted_amount);
2451         }
2452     }
2453 
2454     // All the locked stakes for a given account
2455     function lockedStakesOf(address account) external view returns (LockedStake[] memory) {
2456         return lockedStakes[account];
2457     }
2458 
2459     // All the locked stakes for a given account
2460     function getRewardSymbols() external view returns (string[] memory) {
2461         return rewardSymbols;
2462     }
2463 
2464     // All the reward tokens
2465     function getAllRewardTokens() external view returns (address[] memory) {
2466         return rewardTokens;
2467     }
2468     
2469     // Multiplier amount, given the length of the lock
2470     function lockMultiplier(uint256 secs) public view returns (uint256) {
2471         uint256 lock_multiplier =
2472             uint256(MULTIPLIER_PRECISION).add(
2473                 secs
2474                     .mul(lock_max_multiplier.sub(MULTIPLIER_PRECISION))
2475                     .div(lock_time_for_max_multiplier)
2476             );
2477         if (lock_multiplier > lock_max_multiplier) lock_multiplier = lock_max_multiplier;
2478         return lock_multiplier;
2479     }
2480 
2481     // Last time the reward was applicable
2482     function lastTimeRewardApplicable() internal view returns (uint256) {
2483         return Math.min(block.timestamp, periodFinish);
2484     }
2485 
2486     function rewardRates(uint256 token_idx) public view returns (uint256 rwd_rate) {
2487         address gauge_controller_address = gaugeControllers[token_idx];
2488         if (gauge_controller_address != address(0)) {
2489             rwd_rate = (IFraxGaugeController(gauge_controller_address).global_emission_rate()).mul(last_gauge_relative_weights[token_idx]).div(1e18);
2490         }
2491         else {
2492             rwd_rate = rewardRatesManual[token_idx];
2493         }
2494     }
2495 
2496     // Amount of reward tokens per LP token
2497     function rewardsPerToken() public view returns (uint256[] memory newRewardsPerTokenStored) {
2498         if (_total_liquidity_locked == 0 || _total_combined_weight == 0) {
2499             return rewardsPerTokenStored;
2500         }
2501         else {
2502             newRewardsPerTokenStored = new uint256[](rewardTokens.length);
2503             for (uint256 i = 0; i < rewardsPerTokenStored.length; i++){ 
2504                 newRewardsPerTokenStored[i] = rewardsPerTokenStored[i].add(
2505                     lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRates(i)).mul(1e18).div(_total_combined_weight)
2506                 );
2507             }
2508             return newRewardsPerTokenStored;
2509         }
2510     }
2511 
2512     // Amount of reward tokens an account has earned / accrued
2513     // Note: In the edge-case of one of the account's stake expiring since the last claim, this will
2514     // return a slightly inflated number
2515     function earned(address account) public view returns (uint256[] memory new_earned) {
2516         uint256[] memory reward_arr = rewardsPerToken();
2517         new_earned = new uint256[](rewardTokens.length);
2518 
2519         if (_combined_weights[account] == 0){
2520             for (uint256 i = 0; i < rewardTokens.length; i++){ 
2521                 new_earned[i] = 0;
2522             }
2523         }
2524         else {
2525             for (uint256 i = 0; i < rewardTokens.length; i++){ 
2526                 new_earned[i] = (_combined_weights[account])
2527                     .mul(reward_arr[i].sub(userRewardsPerTokenPaid[account][i]))
2528                     .div(1e18)
2529                     .add(rewards[account][i]);
2530             }
2531         }
2532     }
2533 
2534     // Total reward tokens emitted in the given period
2535     function getRewardForDuration() external view returns (uint256[] memory rewards_per_duration_arr) {
2536         rewards_per_duration_arr = new uint256[](rewardRatesManual.length);
2537 
2538         for (uint256 i = 0; i < rewardRatesManual.length; i++){ 
2539             rewards_per_duration_arr[i] = rewardRates(i).mul(rewardsDuration);
2540         }
2541     }
2542 
2543     // See if the caller_addr is a manager for the reward token 
2544     function isTokenManagerFor(address caller_addr, address reward_token_addr) public view returns (bool){
2545         if (caller_addr == owner) return true; // Contract owner
2546         else if (rewardManagers[reward_token_addr] == caller_addr) return true; // Reward manager
2547         return false; 
2548     }
2549 
2550     /* ========== MUTATIVE FUNCTIONS ========== */
2551 
2552     // Staker can allow a migrator 
2553     function stakerAllowMigrator(address migrator_address) external {
2554         require(valid_migrators[migrator_address], "Invalid migrator address");
2555         staker_allowed_migrators[msg.sender][migrator_address] = true; 
2556     }
2557 
2558     // Staker can disallow a previously-allowed migrator  
2559     function stakerDisallowMigrator(address migrator_address) external {
2560         // Delete from the mapping
2561         delete staker_allowed_migrators[msg.sender][migrator_address];
2562     }
2563 
2564     function _updateRewardAndBalance(address account, bool sync_too) internal {
2565         // Need to retro-adjust some things if the period hasn't been renewed, then start a new one
2566         if (sync_too){
2567             sync();
2568         }
2569         
2570         if (account != address(0)) {
2571             // To keep the math correct, the user's combined weight must be recomputed to account for their
2572             // ever-changing veFXS balance.
2573             (   
2574                 uint256 old_combined_weight,
2575                 uint256 new_vefxs_multiplier,
2576                 uint256 new_combined_weight
2577             ) = calcCurCombinedWeight(account);
2578 
2579             // Calculate the earnings first
2580             _syncEarned(account);
2581 
2582             // Update the user's stored veFXS multipliers
2583             _vefxsMultiplierStored[account] = new_vefxs_multiplier;
2584 
2585             // Update the user's and the global combined weights
2586             if (new_combined_weight >= old_combined_weight) {
2587                 uint256 weight_diff = new_combined_weight.sub(old_combined_weight);
2588                 _total_combined_weight = _total_combined_weight.add(weight_diff);
2589                 _combined_weights[account] = old_combined_weight.add(weight_diff);
2590             } else {
2591                 uint256 weight_diff = old_combined_weight.sub(new_combined_weight);
2592                 _total_combined_weight = _total_combined_weight.sub(weight_diff);
2593                 _combined_weights[account] = old_combined_weight.sub(weight_diff);
2594             }
2595 
2596         }
2597     }
2598 
2599     function _syncEarned(address account) internal {
2600         if (account != address(0)) {
2601             // Calculate the earnings
2602             uint256[] memory earned_arr = earned(account);
2603 
2604             // Update the rewards array
2605             for (uint256 i = 0; i < earned_arr.length; i++){ 
2606                 rewards[account][i] = earned_arr[i];
2607             }
2608 
2609             // Update the rewards paid array
2610             for (uint256 i = 0; i < earned_arr.length; i++){ 
2611                 userRewardsPerTokenPaid[account][i] = rewardsPerTokenStored[i];
2612             }
2613         }
2614     }
2615 
2616     // Two different stake functions are needed because of delegateCall and msg.sender issues
2617     function stakeLocked(uint256 liquidity, uint256 secs) nonReentrant public {
2618         _stakeLocked(msg.sender, msg.sender, liquidity, secs, block.timestamp);
2619     }
2620 
2621     // If this were not internal, and source_address had an infinite approve, this could be exploitable
2622     // (pull funds from source_address and stake for an arbitrary staker_address)
2623     function _stakeLocked(
2624         address staker_address, 
2625         address source_address, 
2626         uint256 liquidity, 
2627         uint256 secs,
2628         uint256 start_timestamp
2629     ) internal updateRewardAndBalance(staker_address, true) {
2630         require(!stakingPaused, "Staking paused");
2631         require(liquidity > 0, "Must stake more than zero");
2632         require(greylist[staker_address] == false, "Address has been greylisted");
2633         require(secs >= lock_time_min, "Minimum stake time not met");
2634         require(secs <= lock_time_for_max_multiplier,"Trying to lock for too long");
2635 
2636         uint256 lock_multiplier = lockMultiplier(secs);
2637         bytes32 kek_id = keccak256(abi.encodePacked(staker_address, start_timestamp, liquidity, _locked_liquidity[staker_address]));
2638         lockedStakes[staker_address].push(LockedStake(
2639             kek_id,
2640             start_timestamp,
2641             liquidity,
2642             start_timestamp.add(secs),
2643             lock_multiplier
2644         ));
2645 
2646         // Pull the tokens from the source_address
2647         TransferHelper.safeTransferFrom(address(stakingToken), source_address, address(this), liquidity);
2648 
2649         // Update liquidities
2650         _total_liquidity_locked = _total_liquidity_locked.add(liquidity);
2651         _locked_liquidity[staker_address] = _locked_liquidity[staker_address].add(liquidity);
2652 
2653         // Need to call to update the combined weights
2654         _updateRewardAndBalance(staker_address, false);
2655 
2656         // Needed for edge case if the staker only claims once, and after the lock expired
2657         if (lastRewardClaimTime[staker_address] == 0) lastRewardClaimTime[staker_address] = block.timestamp;
2658 
2659         emit StakeLocked(staker_address, liquidity, secs, kek_id, source_address);
2660     }
2661 
2662     // Two different withdrawLocked functions are needed because of delegateCall and msg.sender issues
2663     function withdrawLocked(bytes32 kek_id) nonReentrant public {
2664         require(withdrawalsPaused == false, "Withdrawals paused");
2665         _withdrawLocked(msg.sender, msg.sender, kek_id);
2666     }
2667 
2668     // No withdrawer == msg.sender check needed since this is only internally callable and the checks are done in the wrapper
2669     // functions like withdraw(), migrator_withdraw_unlocked() and migrator_withdraw_locked()
2670     function _withdrawLocked(address staker_address, address destination_address, bytes32 kek_id) internal  {
2671         // Collect rewards first and then update the balances
2672         _getReward(staker_address, destination_address);
2673 
2674         LockedStake memory thisStake;
2675         thisStake.liquidity = 0;
2676         uint theArrayIndex;
2677         for (uint256 i = 0; i < lockedStakes[staker_address].length; i++){ 
2678             if (kek_id == lockedStakes[staker_address][i].kek_id){
2679                 thisStake = lockedStakes[staker_address][i];
2680                 theArrayIndex = i;
2681                 break;
2682             }
2683         }
2684         require(thisStake.kek_id == kek_id, "Stake not found");
2685         require(block.timestamp >= thisStake.ending_timestamp || stakesUnlocked == true || valid_migrators[msg.sender] == true, "Stake is still locked!");
2686 
2687         uint256 liquidity = thisStake.liquidity;
2688 
2689         if (liquidity > 0) {
2690             // Update liquidities
2691             _total_liquidity_locked = _total_liquidity_locked.sub(liquidity);
2692             _locked_liquidity[staker_address] = _locked_liquidity[staker_address].sub(liquidity);
2693 
2694             // Remove the stake from the array
2695             delete lockedStakes[staker_address][theArrayIndex];
2696 
2697             // Need to call to update the combined weights
2698             _updateRewardAndBalance(staker_address, false);
2699 
2700             // Give the tokens to the destination_address
2701             // Should throw if insufficient balance
2702             stakingToken.transfer(destination_address, liquidity);
2703 
2704             emit WithdrawLocked(staker_address, liquidity, kek_id, destination_address);
2705         }
2706 
2707     }
2708     
2709     // Two different getReward functions are needed because of delegateCall and msg.sender issues
2710     function getReward() external nonReentrant returns (uint256[] memory) {
2711         require(rewardsCollectionPaused == false,"Rewards collection paused");
2712         return _getReward(msg.sender, msg.sender);
2713     }
2714 
2715     // No withdrawer == msg.sender check needed since this is only internally callable
2716     function _getReward(address rewardee, address destination_address) internal updateRewardAndBalance(rewardee, true) returns (uint256[] memory rewards_before) {
2717         // Update the rewards array and distribute rewards
2718         rewards_before = new uint256[](rewardTokens.length);
2719 
2720         for (uint256 i = 0; i < rewardTokens.length; i++){ 
2721             rewards_before[i] = rewards[rewardee][i];
2722             rewards[rewardee][i] = 0;
2723             ERC20(rewardTokens[i]).transfer(destination_address, rewards_before[i]);
2724             emit RewardPaid(rewardee, rewards_before[i], rewardTokens[i], destination_address);
2725         }
2726 
2727         lastRewardClaimTime[rewardee] = block.timestamp;
2728     }
2729 
2730     // If the period expired, renew it
2731     function retroCatchUp() internal {
2732         // Pull in rewards from the rewards distributor
2733         rewards_distributor.distributeReward(address(this));
2734 
2735         // Ensure the provided reward amount is not more than the balance in the contract.
2736         // This keeps the reward rate in the right range, preventing overflows due to
2737         // very high values of rewardRate in the earned and rewardsPerToken functions;
2738         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
2739         uint256 num_periods_elapsed = uint256(block.timestamp.sub(periodFinish)) / rewardsDuration; // Floor division to the nearest period
2740         
2741         // Make sure there are enough tokens to renew the reward period
2742         for (uint256 i = 0; i < rewardTokens.length; i++){ 
2743             require(rewardRates(i).mul(rewardsDuration).mul(num_periods_elapsed + 1) <= ERC20(rewardTokens[i]).balanceOf(address(this)), string(abi.encodePacked("Not enough reward tokens available: ", rewardTokens[i])) );
2744         }
2745         
2746         // uint256 old_lastUpdateTime = lastUpdateTime;
2747         // uint256 new_lastUpdateTime = block.timestamp;
2748 
2749         // lastUpdateTime = periodFinish;
2750         periodFinish = periodFinish.add((num_periods_elapsed.add(1)).mul(rewardsDuration));
2751 
2752         _updateStoredRewardsAndTime();
2753 
2754         emit RewardsPeriodRenewed(address(stakingToken));
2755     }
2756 
2757     function _updateStoredRewardsAndTime() internal {
2758         // Get the rewards
2759         uint256[] memory rewards_per_token = rewardsPerToken();
2760 
2761         // Update the rewardsPerTokenStored
2762         for (uint256 i = 0; i < rewardsPerTokenStored.length; i++){ 
2763             rewardsPerTokenStored[i] = rewards_per_token[i];
2764         }
2765 
2766         // Update the last stored time
2767         lastUpdateTime = lastTimeRewardApplicable();
2768     }
2769 
2770     function sync_gauge_weights(bool force_update) public {
2771         // Loop through the gauge controllers
2772         for (uint256 i = 0; i < gaugeControllers.length; i++){ 
2773             address gauge_controller_address = gaugeControllers[i];
2774             if (gauge_controller_address != address(0)) {
2775                 if (force_update || (block.timestamp > last_gauge_time_totals[i])){
2776                     // Update the gauge_relative_weight
2777                     last_gauge_relative_weights[i] = IFraxGaugeController(gauge_controller_address).gauge_relative_weight_write(address(this), block.timestamp);
2778                     last_gauge_time_totals[i] = IFraxGaugeController(gauge_controller_address).time_total();
2779                 }
2780             }
2781         }
2782     }
2783 
2784     function sync() public {
2785         // Sync the gauge weight, if applicable
2786         sync_gauge_weights(false);
2787 
2788         if (block.timestamp >= periodFinish) {
2789             retroCatchUp();
2790         }
2791         else {
2792             _updateStoredRewardsAndTime();
2793         }
2794     }
2795 
2796     /* ========== RESTRICTED FUNCTIONS ========== */
2797 
2798     // Migrator can stake for someone else (they won't be able to withdraw it back though, only staker_address can). 
2799     function migrator_stakeLocked_for(address staker_address, uint256 amount, uint256 secs, uint256 start_timestamp) external isMigrating {
2800         require(staker_allowed_migrators[staker_address][msg.sender] && valid_migrators[msg.sender], "Mig. invalid or unapproved");
2801         _stakeLocked(staker_address, msg.sender, amount, secs, start_timestamp);
2802     }
2803 
2804     // Used for migrations
2805     function migrator_withdraw_locked(address staker_address, bytes32 kek_id) external isMigrating {
2806         require(staker_allowed_migrators[staker_address][msg.sender] && valid_migrators[msg.sender], "Mig. invalid or unapproved");
2807         _withdrawLocked(staker_address, msg.sender, kek_id);
2808     }
2809 
2810     // Adds supported migrator address 
2811     function addMigrator(address migrator_address) external onlyByOwner {
2812         valid_migrators[migrator_address] = true;
2813     }
2814 
2815     // Remove a migrator address
2816     function removeMigrator(address migrator_address) external onlyByOwner {
2817         require(valid_migrators[migrator_address] == true, "Address nonexistant");
2818         
2819         // Delete from the mapping
2820         delete valid_migrators[migrator_address];
2821     }
2822 
2823     // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
2824     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyTknMgrs(tokenAddress) {
2825         // Check if the desired token is a reward token
2826         bool isRewardToken = false;
2827         for (uint256 i = 0; i < rewardTokens.length; i++){ 
2828             if (rewardTokens[i] == tokenAddress) {
2829                 isRewardToken = true;
2830                 break;
2831             }
2832         }
2833 
2834         // Only the reward managers can take back their reward tokens
2835         if (isRewardToken && rewardManagers[tokenAddress] == msg.sender){
2836             ERC20(tokenAddress).transfer(msg.sender, tokenAmount);
2837             emit Recovered(msg.sender, tokenAddress, tokenAmount);
2838             return;
2839         }
2840 
2841         // Other tokens, like the staking token, airdrops, or accidental deposits, can be withdrawn by the owner
2842         else if (!isRewardToken && (msg.sender == owner)){
2843             ERC20(tokenAddress).transfer(msg.sender, tokenAmount);
2844             emit Recovered(msg.sender, tokenAddress, tokenAmount);
2845             return;
2846         }
2847 
2848         // If none of the above conditions are true
2849         else {
2850             revert("No valid tokens to recover");
2851         }
2852     }
2853 
2854     function setRewardsDuration(uint256 _rewardsDuration) external onlyByOwner {
2855         require(_rewardsDuration >= 86400, "Rewards duration too short");
2856         require(
2857             periodFinish == 0 || block.timestamp > periodFinish,
2858             "Reward period incomplete"
2859         );
2860         rewardsDuration = _rewardsDuration;
2861         emit RewardsDurationUpdated(rewardsDuration);
2862     }
2863 
2864     function setMultipliers(uint256 _lock_max_multiplier, uint256 _vefxs_max_multiplier, uint256 _vefxs_per_frax_for_max_boost) external onlyByOwner {
2865         require(_lock_max_multiplier >= MULTIPLIER_PRECISION, "Mult must be >= MULTIPLIER_PRECISION");
2866         require(_vefxs_max_multiplier >= 0, "veFXS mul must be >= 0");
2867         require(_vefxs_per_frax_for_max_boost > 0, "veFXS pct max must be >= 0");
2868 
2869         lock_max_multiplier = _lock_max_multiplier;
2870         vefxs_max_multiplier = _vefxs_max_multiplier;
2871         vefxs_per_frax_for_max_boost = _vefxs_per_frax_for_max_boost;
2872 
2873         emit MaxVeFXSMultiplier(vefxs_max_multiplier);
2874         emit LockedStakeMaxMultiplierUpdated(lock_max_multiplier);
2875         emit veFXSPerFraxForMaxBoostUpdated(vefxs_per_frax_for_max_boost);
2876     }
2877 
2878     function setLockedStakeTimeForMinAndMaxMultiplier(uint256 _lock_time_for_max_multiplier, uint256 _lock_time_min) external onlyByOwner {
2879         require(_lock_time_for_max_multiplier >= 1, "Mul max time must be >= 1");
2880         require(_lock_time_min >= 1, "Mul min time must be >= 1");
2881 
2882         lock_time_for_max_multiplier = _lock_time_for_max_multiplier;
2883         lock_time_min = _lock_time_min;
2884 
2885         emit LockedStakeTimeForMaxMultiplier(lock_time_for_max_multiplier);
2886         emit LockedStakeMinTime(_lock_time_min);
2887     }
2888 
2889     function greylistAddress(address _address) external onlyByOwner {
2890         greylist[_address] = !(greylist[_address]);
2891     }
2892 
2893     function unlockStakes() external onlyByOwner {
2894         stakesUnlocked = !stakesUnlocked;
2895     }
2896 
2897     function toggleStaking() external onlyByOwner {
2898         stakingPaused = !stakingPaused;
2899     }
2900 
2901     function toggleMigrations() external onlyByOwner {
2902         migrationsOn = !migrationsOn;
2903     }
2904 
2905     function toggleWithdrawals() external onlyByOwner {
2906         withdrawalsPaused = !withdrawalsPaused;
2907     }
2908 
2909     function toggleRewardsCollection() external onlyByOwner {
2910         rewardsCollectionPaused = !rewardsCollectionPaused;
2911     }
2912 
2913     // The owner or the reward token managers can set reward rates 
2914     function setRewardRate(address reward_token_address, uint256 new_rate, bool sync_too) external onlyTknMgrs(reward_token_address) {
2915         rewardRatesManual[rewardTokenAddrToIdx[reward_token_address]] = new_rate;
2916         
2917         if (sync_too){
2918             sync();
2919         }
2920     }
2921 
2922     // The owner or the reward token managers can set reward rates 
2923     function setGaugeController(address reward_token_address, address _rewards_distributor_address, address _gauge_controller_address, bool sync_too) external onlyTknMgrs(reward_token_address) {
2924         gaugeControllers[rewardTokenAddrToIdx[reward_token_address]] = _gauge_controller_address;
2925         rewards_distributor = IFraxGaugeFXSRewardsDistributor(_rewards_distributor_address);
2926 
2927         if (sync_too){
2928             sync();
2929         }
2930     }
2931 
2932     // The owner or the reward token managers can change managers
2933     function changeTokenManager(address reward_token_address, address new_manager_address) external onlyTknMgrs(reward_token_address) {
2934         rewardManagers[reward_token_address] = new_manager_address;
2935     }
2936 
2937     /* ========== EVENTS ========== */
2938 
2939     event StakeLocked(address indexed user, uint256 amount, uint256 secs, bytes32 kek_id, address source_address);
2940     event WithdrawLocked(address indexed user, uint256 amount, bytes32 kek_id, address destination_address);
2941     event RewardPaid(address indexed user, uint256 reward, address token_address, address destination_address);
2942     event RewardsDurationUpdated(uint256 newDuration);
2943     event Recovered(address destination_address, address token, uint256 amount);
2944     event RewardsPeriodRenewed(address token);
2945     event LockedStakeMaxMultiplierUpdated(uint256 multiplier);
2946     event LockedStakeTimeForMaxMultiplier(uint256 secs);
2947     event LockedStakeMinTime(uint256 secs);
2948     event MaxVeFXSMultiplier(uint256 multiplier);
2949     event veFXSPerFraxForMaxBoostUpdated(uint256 scale_factor);
2950 }
2951 
2952 
2953 // File contracts/Staking/Variants/StakingRewardsMultiGauge_StakeDAO.sol
2954 
2955 contract StakingRewardsMultiGauge_StakeDAO is StakingRewardsMultiGauge {
2956     constructor (
2957         address _owner,
2958         address _stakingToken, 
2959         address _rewards_distributor_address,
2960         string[] memory _rewardSymbols,
2961         address[] memory _rewardTokens,
2962         address[] memory _rewardManagers,
2963         uint256[] memory _rewardRates,
2964         address[] memory _gaugeControllers
2965     ) 
2966     StakingRewardsMultiGauge(_owner, _stakingToken, _rewards_distributor_address, _rewardSymbols, _rewardTokens, _rewardManagers, _rewardRates, _gaugeControllers)
2967     {}
2968 }