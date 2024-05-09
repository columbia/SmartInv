1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 /*
163  * @dev Provides information about the current execution context, including the
164  * sender of the transaction and its data. While these are generally available
165  * via msg.sender and msg.data, they should not be accessed in such a direct
166  * manner, since when dealing with GSN meta-transactions the account sending and
167  * paying for execution may not be the actual sender (as far as an application
168  * is concerned).
169  *
170  * This contract is only required for intermediate, library-like contracts.
171  */
172 abstract contract Context {
173     function _msgSender() internal view virtual returns (address payable) {
174         return msg.sender;
175     }
176 
177     function _msgData() internal view virtual returns (bytes memory) {
178         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
179         return msg.data;
180     }
181 }
182 
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      */
205     function isContract(address account) internal view returns (bool) {
206         // This method relies in extcodesize, which returns 0 for contracts in
207         // construction, since the code is only stored at the end of the
208         // constructor execution.
209 
210         uint256 size;
211         // solhint-disable-next-line no-inline-assembly
212         assembly { size := extcodesize(account) }
213         return size > 0;
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
236         (bool success, ) = recipient.call{ value: amount }("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240     /**
241      * @dev Performs a Solidity function call using a low level `call`. A
242      * plain`call` is an unsafe replacement for a function call: use this
243      * function instead.
244      *
245      * If `target` reverts with a revert reason, it is bubbled up by this
246      * function (like regular Solidity function calls).
247      *
248      * Returns the raw returned data. To convert to the expected return value,
249      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
250      *
251      * Requirements:
252      *
253      * - `target` must be a contract.
254      * - calling `target` with `data` must not revert.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
259       return functionCall(target, data, "Address: low-level call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
264      * `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
269         return _functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
289      * with `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
294         require(address(this).balance >= value, "Address: insufficient balance for call");
295         return _functionCallWithValue(target, data, value, errorMessage);
296     }
297 
298     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
299         require(isContract(target), "Address: call to non-contract");
300 
301         // solhint-disable-next-line avoid-low-level-calls
302         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
303         if (success) {
304             return returndata;
305         } else {
306             // Look for revert reason and bubble it up if present
307             if (returndata.length > 0) {
308                 // The easiest way to bubble the revert reason is using memory via assembly
309 
310                 // solhint-disable-next-line no-inline-assembly
311                 assembly {
312                     let returndata_size := mload(returndata)
313                     revert(add(32, returndata), returndata_size)
314                 }
315             } else {
316                 revert(errorMessage);
317             }
318         }
319     }
320 }
321 
322 
323 /**
324  * @dev Contract module which allows children to implement an emergency stop
325  * mechanism that can be triggered by an authorized account.
326  *
327  * This module is used through inheritance. It will make available the
328  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
329  * the functions of your contract. Note that they will not be pausable by
330  * simply including this module, only once the modifiers are put in place.
331  */
332 contract Pausable is Context {
333     /**
334      * @dev Emitted when the pause is triggered by `account`.
335      */
336     event Paused(address account);
337 
338     /**
339      * @dev Emitted when the pause is lifted by `account`.
340      */
341     event Unpaused(address account);
342 
343     bool private _paused;
344 
345     /**
346      * @dev Initializes the contract in unpaused state.
347      */
348     constructor () internal {
349         _paused = false;
350     }
351 
352     /**
353      * @dev Returns true if the contract is paused, and false otherwise.
354      */
355     function paused() public view returns (bool) {
356         return _paused;
357     }
358 
359     /**
360      * @dev Modifier to make a function callable only when the contract is not paused.
361      *
362      * Requirements:
363      *
364      * - The contract must not be paused.
365      */
366     modifier whenNotPaused() {
367         require(!_paused, "Pausable: paused");
368         _;
369     }
370 
371     /**
372      * @dev Modifier to make a function callable only when the contract is paused.
373      *
374      * Requirements:
375      *
376      * - The contract must be paused.
377      */
378     modifier whenPaused() {
379         require(_paused, "Pausable: not paused");
380         _;
381     }
382 
383     /**
384      * @dev Triggers stopped state.
385      *
386      * Requirements:
387      *
388      * - The contract must not be paused.
389      */
390     function _pause() internal virtual whenNotPaused {
391         _paused = true;
392         emit Paused(_msgSender());
393     }
394 
395     /**
396      * @dev Returns to normal state.
397      *
398      * Requirements:
399      *
400      * - The contract must be paused.
401      */
402     function _unpause() internal virtual whenPaused {
403         _paused = false;
404         emit Unpaused(_msgSender());
405     }
406 }
407 
408 
409 /**
410  * @dev Interface of the ERC20 standard as defined in the EIP.
411  */
412 interface IERC20 {
413     /**
414      * @dev Returns the amount of tokens in existence.
415      */
416     function totalSupply() external view returns (uint256);
417 
418     /**
419      * @dev Returns the amount of tokens owned by `account`.
420      */
421     function balanceOf(address account) external view returns (uint256);
422 
423     /**
424      * @dev Moves `amount` tokens from the caller's account to `recipient`.
425      *
426      * Returns a boolean value indicating whether the operation succeeded.
427      *
428      * Emits a {Transfer} event.
429      */
430     function transfer(address recipient, uint256 amount) external returns (bool);
431 
432     /**
433      * @dev Returns the remaining number of tokens that `spender` will be
434      * allowed to spend on behalf of `owner` through {transferFrom}. This is
435      * zero by default.
436      *
437      * This value changes when {approve} or {transferFrom} are called.
438      */
439     function allowance(address owner, address spender) external view returns (uint256);
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
443      *
444      * Returns a boolean value indicating whether the operation succeeded.
445      *
446      * IMPORTANT: Beware that changing an allowance with this method brings the risk
447      * that someone may use both the old and the new allowance by unfortunate
448      * transaction ordering. One possible solution to mitigate this race
449      * condition is to first reduce the spender's allowance to 0 and set the
450      * desired value afterwards:
451      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
452      *
453      * Emits an {Approval} event.
454      */
455     function approve(address spender, uint256 amount) external returns (bool);
456 
457     /**
458      * @dev Moves `amount` tokens from `sender` to `recipient` using the
459      * allowance mechanism. `amount` is then deducted from the caller's
460      * allowance.
461      *
462      * Returns a boolean value indicating whether the operation succeeded.
463      *
464      * Emits a {Transfer} event.
465      */
466     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
467 
468     /**
469      * @dev Emitted when `value` tokens are moved from one account (`from`) to
470      * another (`to`).
471      *
472      * Note that `value` may be zero.
473      */
474     event Transfer(address indexed from, address indexed to, uint256 value);
475 
476     /**
477      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
478      * a call to {approve}. `value` is the new allowance.
479      */
480     event Approval(address indexed owner, address indexed spender, uint256 value);
481 }
482 
483 
484 /**
485  * @dev Implementation of the {IERC20} interface.
486  *
487  * This implementation is agnostic to the way tokens are created. This means
488  * that a supply mechanism has to be added in a derived contract using {_mint}.
489  * For a generic mechanism see {ERC20PresetMinterPauser}.
490  *
491  * TIP: For a detailed writeup see our guide
492  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
493  * to implement supply mechanisms].
494  *
495  * We have followed general OpenZeppelin guidelines: functions revert instead
496  * of returning `false` on failure. This behavior is nonetheless conventional
497  * and does not conflict with the expectations of ERC20 applications.
498  *
499  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
500  * This allows applications to reconstruct the allowance for all accounts just
501  * by listening to said events. Other implementations of the EIP may not emit
502  * these events, as it isn't required by the specification.
503  *
504  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
505  * functions have been added to mitigate the well-known issues around setting
506  * allowances. See {IERC20-approve}.
507  */
508 contract ERC20 is Context, IERC20 {
509     using SafeMath for uint256;
510     using Address for address;
511 
512     mapping (address => uint256) private _balances;
513 
514     mapping (address => mapping (address => uint256)) private _allowances;
515 
516     uint256 private _totalSupply;
517 
518     string private _name;
519     string private _symbol;
520     uint8 private _decimals;
521 
522     /**
523      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
524      * a default value of 18.
525      *
526      * To select a different value for {decimals}, use {_setupDecimals}.
527      *
528      * All three of these values are immutable: they can only be set once during
529      * construction.
530      */
531     constructor (string memory name, string memory symbol) public {
532         _name = name;
533         _symbol = symbol;
534         _decimals = 18;
535     }
536 
537     /**
538      * @dev Returns the name of the token.
539      */
540     function name() public view returns (string memory) {
541         return _name;
542     }
543 
544     /**
545      * @dev Returns the symbol of the token, usually a shorter version of the
546      * name.
547      */
548     function symbol() public view returns (string memory) {
549         return _symbol;
550     }
551 
552     /**
553      * @dev Returns the number of decimals used to get its user representation.
554      * For example, if `decimals` equals `2`, a balance of `505` tokens should
555      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
556      *
557      * Tokens usually opt for a value of 18, imitating the relationship between
558      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
559      * called.
560      *
561      * NOTE: This information is only used for _display_ purposes: it in
562      * no way affects any of the arithmetic of the contract, including
563      * {IERC20-balanceOf} and {IERC20-transfer}.
564      */
565     function decimals() public view returns (uint8) {
566         return _decimals;
567     }
568 
569     /**
570      * @dev See {IERC20-totalSupply}.
571      */
572     function totalSupply() public view override returns (uint256) {
573         return _totalSupply;
574     }
575 
576     /**
577      * @dev See {IERC20-balanceOf}.
578      */
579     function balanceOf(address account) public view override returns (uint256) {
580         return _balances[account];
581     }
582 
583     /**
584      * @dev See {IERC20-transfer}.
585      *
586      * Requirements:
587      *
588      * - `recipient` cannot be the zero address.
589      * - the caller must have a balance of at least `amount`.
590      */
591     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
592         _transfer(_msgSender(), recipient, amount);
593         return true;
594     }
595 
596     /**
597      * @dev See {IERC20-allowance}.
598      */
599     function allowance(address owner, address spender) public view virtual override returns (uint256) {
600         return _allowances[owner][spender];
601     }
602 
603     /**
604      * @dev See {IERC20-approve}.
605      *
606      * Requirements:
607      *
608      * - `spender` cannot be the zero address.
609      */
610     function approve(address spender, uint256 amount) public virtual override returns (bool) {
611         _approve(_msgSender(), spender, amount);
612         return true;
613     }
614 
615     /**
616      * @dev See {IERC20-transferFrom}.
617      *
618      * Emits an {Approval} event indicating the updated allowance. This is not
619      * required by the EIP. See the note at the beginning of {ERC20};
620      *
621      * Requirements:
622      * - `sender` and `recipient` cannot be the zero address.
623      * - `sender` must have a balance of at least `amount`.
624      * - the caller must have allowance for ``sender``'s tokens of at least
625      * `amount`.
626      */
627     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
628         _transfer(sender, recipient, amount);
629         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
630         return true;
631     }
632 
633     /**
634      * @dev Atomically increases the allowance granted to `spender` by the caller.
635      *
636      * This is an alternative to {approve} that can be used as a mitigation for
637      * problems described in {IERC20-approve}.
638      *
639      * Emits an {Approval} event indicating the updated allowance.
640      *
641      * Requirements:
642      *
643      * - `spender` cannot be the zero address.
644      */
645     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
646         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
647         return true;
648     }
649 
650     /**
651      * @dev Atomically decreases the allowance granted to `spender` by the caller.
652      *
653      * This is an alternative to {approve} that can be used as a mitigation for
654      * problems described in {IERC20-approve}.
655      *
656      * Emits an {Approval} event indicating the updated allowance.
657      *
658      * Requirements:
659      *
660      * - `spender` cannot be the zero address.
661      * - `spender` must have allowance for the caller of at least
662      * `subtractedValue`.
663      */
664     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
665         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
666         return true;
667     }
668 
669     /**
670      * @dev Moves tokens `amount` from `sender` to `recipient`.
671      *
672      * This is internal function is equivalent to {transfer}, and can be used to
673      * e.g. implement automatic token fees, slashing mechanisms, etc.
674      *
675      * Emits a {Transfer} event.
676      *
677      * Requirements:
678      *
679      * - `sender` cannot be the zero address.
680      * - `recipient` cannot be the zero address.
681      * - `sender` must have a balance of at least `amount`.
682      */
683     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
684         require(sender != address(0), "ERC20: transfer from the zero address");
685         require(recipient != address(0), "ERC20: transfer to the zero address");
686 
687         _beforeTokenTransfer(sender, recipient, amount);
688 
689         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
690         _balances[recipient] = _balances[recipient].add(amount);
691         emit Transfer(sender, recipient, amount);
692     }
693 
694     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
695      * the total supply.
696      *
697      * Emits a {Transfer} event with `from` set to the zero address.
698      *
699      * Requirements
700      *
701      * - `to` cannot be the zero address.
702      */
703     function _mint(address account, uint256 amount) internal virtual {
704         require(account != address(0), "ERC20: mint to the zero address");
705 
706         _beforeTokenTransfer(address(0), account, amount);
707 
708         _totalSupply = _totalSupply.add(amount);
709         _balances[account] = _balances[account].add(amount);
710         emit Transfer(address(0), account, amount);
711     }
712 
713     /**
714      * @dev Destroys `amount` tokens from `account`, reducing the
715      * total supply.
716      *
717      * Emits a {Transfer} event with `to` set to the zero address.
718      *
719      * Requirements
720      *
721      * - `account` cannot be the zero address.
722      * - `account` must have at least `amount` tokens.
723      */
724     function _burn(address account, uint256 amount) internal virtual {
725         require(account != address(0), "ERC20: burn from the zero address");
726 
727         _beforeTokenTransfer(account, address(0), amount);
728 
729         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
730         _totalSupply = _totalSupply.sub(amount);
731         emit Transfer(account, address(0), amount);
732     }
733 
734     /**
735      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
736      *
737      * This is internal function is equivalent to `approve`, and can be used to
738      * e.g. set automatic allowances for certain subsystems, etc.
739      *
740      * Emits an {Approval} event.
741      *
742      * Requirements:
743      *
744      * - `owner` cannot be the zero address.
745      * - `spender` cannot be the zero address.
746      */
747     function _approve(address owner, address spender, uint256 amount) internal virtual {
748         require(owner != address(0), "ERC20: approve from the zero address");
749         require(spender != address(0), "ERC20: approve to the zero address");
750 
751         _allowances[owner][spender] = amount;
752         emit Approval(owner, spender, amount);
753     }
754 
755     /**
756      * @dev Sets {decimals} to a value other than the default one of 18.
757      *
758      * WARNING: This function should only be called from the constructor. Most
759      * applications that interact with token contracts will not expect
760      * {decimals} to ever change, and may work incorrectly if it does.
761      */
762     function _setupDecimals(uint8 decimals_) internal {
763         _decimals = decimals_;
764     }
765 
766     /**
767      * @dev Hook that is called before any transfer of tokens. This includes
768      * minting and burning.
769      *
770      * Calling conditions:
771      *
772      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
773      * will be to transferred to `to`.
774      * - when `from` is zero, `amount` tokens will be minted for `to`.
775      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
776      * - `from` and `to` are never both zero.
777      *
778      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
779      */
780     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
781 }
782 
783 
784 /**
785  * @dev ERC20 token with pausable token transfers, minting and burning.
786  *
787  * Useful for scenarios such as preventing trades until the end of an evaluation
788  * period, or having an emergency switch for freezing all token transfers in the
789  * event of a large bug.
790  */
791 abstract contract ERC20Pausable is ERC20, Pausable {
792     /**
793      * @dev See {ERC20-_beforeTokenTransfer}.
794      *
795      * Requirements:
796      *
797      * - the contract must not be paused.
798      */
799     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
800         super._beforeTokenTransfer(from, to, amount);
801 
802         require(!paused(), "ERC20Pausable: token transfer while paused");
803     }
804 }
805 
806 
807 /**
808  * @dev Contract module which provides a basic access control mechanism, where
809  * there is an account (an owner) that can be granted exclusive access to
810  * specific functions.
811  *
812  * By default, the owner account will be the one that deploys the contract. This
813  * can later be changed with {transferOwnership}.
814  *
815  * This module is used through inheritance. It will make available the modifier
816  * `onlyOwner`, which can be applied to your functions to restrict their use to
817  * the owner.
818  */
819 contract Ownable is Context {
820     address private _owner;
821 
822     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
823 
824     /**
825      * @dev Initializes the contract setting the deployer as the initial owner.
826      */
827     constructor () internal {
828         address msgSender = _msgSender();
829         _owner = msgSender;
830         emit OwnershipTransferred(address(0), msgSender);
831     }
832 
833     /**
834      * @dev Returns the address of the current owner.
835      */
836     function owner() public view returns (address) {
837         return _owner;
838     }
839 
840     /**
841      * @dev Throws if called by any account other than the owner.
842      */
843     modifier onlyOwner() {
844         require(_owner == _msgSender(), "Ownable: caller is not the owner");
845         _;
846     }
847 
848     /**
849      * @dev Leaves the contract without owner. It will not be possible to call
850      * `onlyOwner` functions anymore. Can only be called by the current owner.
851      *
852      * NOTE: Renouncing ownership will leave the contract without an owner,
853      * thereby removing any functionality that is only available to the owner.
854      */
855     function renounceOwnership() public virtual onlyOwner {
856         emit OwnershipTransferred(_owner, address(0));
857         _owner = address(0);
858     }
859 
860     /**
861      * @dev Transfers ownership of the contract to a new account (`newOwner`).
862      * Can only be called by the current owner.
863      */
864     function transferOwnership(address newOwner) public virtual onlyOwner {
865         require(newOwner != address(0), "Ownable: new owner is the zero address");
866         emit OwnershipTransferred(_owner, newOwner);
867         _owner = newOwner;
868     }
869 }
870 
871 
872 contract IFToken is ERC20Pausable, Ownable {
873     
874     constructor() ERC20("IFToken", "IFT") public{
875         _mint(msg.sender, 400000000000000000000000000);
876     }
877     
878     function pause() public onlyOwner{
879         _pause();
880     }
881     
882     function unpause() public onlyOwner{
883         _unpause();
884     }
885     
886     function mint(uint256 amount) public onlyOwner{
887         _mint(msg.sender, amount);
888     }
889     
890     function burn(uint256 amount) public onlyOwner{
891         _burn(msg.sender, amount);
892     }
893 }