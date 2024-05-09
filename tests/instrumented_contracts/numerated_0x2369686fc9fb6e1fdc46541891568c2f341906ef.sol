1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 pragma solidity ^0.6.0;
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 pragma solidity ^0.6.2;
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // This method relies in extcodesize, which returns 0 for contracts in
285         // construction, since the code is only stored at the end of the
286         // constructor execution.
287 
288         uint256 size;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { size := extcodesize(account) }
291         return size > 0;
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 pragma solidity ^0.6.0;
401 
402 
403 /**
404  * @dev Implementation of the {IERC20} interface.
405  *
406  * This implementation is agnostic to the way tokens are created. This means
407  * that a supply mechanism has to be added in a derived contract using {_mint}.
408  * For a generic mechanism see {ERC20PresetMinterPauser}.
409  *
410  * TIP: For a detailed writeup see our guide
411  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
412  * to implement supply mechanisms].
413  *
414  * We have followed general OpenZeppelin guidelines: functions revert instead
415  * of returning `false` on failure. This behavior is nonetheless conventional
416  * and does not conflict with the expectations of ERC20 applications.
417  *
418  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
419  * This allows applications to reconstruct the allowance for all accounts just
420  * by listening to said events. Other implementations of the EIP may not emit
421  * these events, as it isn't required by the specification.
422  *
423  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
424  * functions have been added to mitigate the well-known issues around setting
425  * allowances. See {IERC20-approve}.
426  */
427 contract ERC20 is Context, IERC20 {
428     using SafeMath for uint256;
429     using Address for address;
430 
431     mapping (address => uint256) private _balances;
432 
433     mapping (address => mapping (address => uint256)) private _allowances;
434 
435     uint256 private _totalSupply;
436 
437     string private _name;
438     string private _symbol;
439     uint8 private _decimals;
440 
441     /**
442      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
443      * a default value of 18.
444      *
445      * To select a different value for {decimals}, use {_setupDecimals}.
446      *
447      * All three of these values are immutable: they can only be set once during
448      * construction.
449      */
450     constructor (string memory name, string memory symbol) public {
451         _name = name;
452         _symbol = symbol;
453         _decimals = 18;
454     }
455 
456     /**
457      * @dev Returns the name of the token.
458      */
459     function name() public view returns (string memory) {
460         return _name;
461     }
462 
463     /**
464      * @dev Returns the symbol of the token, usually a shorter version of the
465      * name.
466      */
467     function symbol() public view returns (string memory) {
468         return _symbol;
469     }
470 
471     /**
472      * @dev Returns the number of decimals used to get its user representation.
473      * For example, if `decimals` equals `2`, a balance of `505` tokens should
474      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
475      *
476      * Tokens usually opt for a value of 18, imitating the relationship between
477      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
478      * called.
479      *
480      * NOTE: This information is only used for _display_ purposes: it in
481      * no way affects any of the arithmetic of the contract, including
482      * {IERC20-balanceOf} and {IERC20-transfer}.
483      */
484     function decimals() public view returns (uint8) {
485         return _decimals;
486     }
487 
488     /**
489      * @dev See {IERC20-totalSupply}.
490      */
491     function totalSupply() public view override returns (uint256) {
492         return _totalSupply;
493     }
494 
495     /**
496      * @dev See {IERC20-balanceOf}.
497      */
498     function balanceOf(address account) public view override returns (uint256) {
499         return _balances[account];
500     }
501 
502     /**
503      * @dev See {IERC20-transfer}.
504      *
505      * Requirements:
506      *
507      * - `recipient` cannot be the zero address.
508      * - the caller must have a balance of at least `amount`.
509      */
510     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
511         _transfer(_msgSender(), recipient, amount);
512         return true;
513     }
514 
515     /**
516      * @dev See {IERC20-allowance}.
517      */
518     function allowance(address owner, address spender) public view virtual override returns (uint256) {
519         return _allowances[owner][spender];
520     }
521 
522     /**
523      * @dev See {IERC20-approve}.
524      *
525      * Requirements:
526      *
527      * - `spender` cannot be the zero address.
528      */
529     function approve(address spender, uint256 amount) public virtual override returns (bool) {
530         _approve(_msgSender(), spender, amount);
531         return true;
532     }
533 
534     /**
535      * @dev See {IERC20-transferFrom}.
536      *
537      * Emits an {Approval} event indicating the updated allowance. This is not
538      * required by the EIP. See the note at the beginning of {ERC20};
539      *
540      * Requirements:
541      * - `sender` and `recipient` cannot be the zero address.
542      * - `sender` must have a balance of at least `amount`.
543      * - the caller must have allowance for ``sender``'s tokens of at least
544      * `amount`.
545      */
546     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
547         _transfer(sender, recipient, amount);
548         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
549         return true;
550     }
551 
552     /**
553      * @dev Atomically increases the allowance granted to `spender` by the caller.
554      *
555      * This is an alternative to {approve} that can be used as a mitigation for
556      * problems described in {IERC20-approve}.
557      *
558      * Emits an {Approval} event indicating the updated allowance.
559      *
560      * Requirements:
561      *
562      * - `spender` cannot be the zero address.
563      */
564     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
565         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
566         return true;
567     }
568 
569     /**
570      * @dev Atomically decreases the allowance granted to `spender` by the caller.
571      *
572      * This is an alternative to {approve} that can be used as a mitigation for
573      * problems described in {IERC20-approve}.
574      *
575      * Emits an {Approval} event indicating the updated allowance.
576      *
577      * Requirements:
578      *
579      * - `spender` cannot be the zero address.
580      * - `spender` must have allowance for the caller of at least
581      * `subtractedValue`.
582      */
583     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
584         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
585         return true;
586     }
587 
588     /**
589      * @dev Moves tokens `amount` from `sender` to `recipient`.
590      *
591      * This is internal function is equivalent to {transfer}, and can be used to
592      * e.g. implement automatic token fees, slashing mechanisms, etc.
593      *
594      * Emits a {Transfer} event.
595      *
596      * Requirements:
597      *
598      * - `sender` cannot be the zero address.
599      * - `recipient` cannot be the zero address.
600      * - `sender` must have a balance of at least `amount`.
601      */
602     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
603         require(sender != address(0), "ERC20: transfer from the zero address");
604         require(recipient != address(0), "ERC20: transfer to the zero address");
605 
606         _beforeTokenTransfer(sender, recipient, amount);
607 
608         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
609         _balances[recipient] = _balances[recipient].add(amount);
610         emit Transfer(sender, recipient, amount);
611     }
612 
613     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
614      * the total supply.
615      *
616      * Emits a {Transfer} event with `from` set to the zero address.
617      *
618      * Requirements
619      *
620      * - `to` cannot be the zero address.
621      */
622     function _mint(address account, uint256 amount) internal virtual {
623         require(account != address(0), "ERC20: mint to the zero address");
624 
625         _beforeTokenTransfer(address(0), account, amount);
626 
627         _totalSupply = _totalSupply.add(amount);
628         _balances[account] = _balances[account].add(amount);
629         emit Transfer(address(0), account, amount);
630     }
631 
632     /**
633      * @dev Destroys `amount` tokens from `account`, reducing the
634      * total supply.
635      *
636      * Emits a {Transfer} event with `to` set to the zero address.
637      *
638      * Requirements
639      *
640      * - `account` cannot be the zero address.
641      * - `account` must have at least `amount` tokens.
642      */
643     function _burn(address account, uint256 amount) internal virtual {
644         require(account != address(0), "ERC20: burn from the zero address");
645 
646         _beforeTokenTransfer(account, address(0), amount);
647 
648         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
649         _totalSupply = _totalSupply.sub(amount);
650         emit Transfer(account, address(0), amount);
651     }
652 
653     /**
654      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
655      *
656      * This internal function is equivalent to `approve`, and can be used to
657      * e.g. set automatic allowances for certain subsystems, etc.
658      *
659      * Emits an {Approval} event.
660      *
661      * Requirements:
662      *
663      * - `owner` cannot be the zero address.
664      * - `spender` cannot be the zero address.
665      */
666     function _approve(address owner, address spender, uint256 amount) internal virtual {
667         require(owner != address(0), "ERC20: approve from the zero address");
668         require(spender != address(0), "ERC20: approve to the zero address");
669 
670         _allowances[owner][spender] = amount;
671         emit Approval(owner, spender, amount);
672     }
673 
674     /**
675      * @dev Sets {decimals} to a value other than the default one of 18.
676      *
677      * WARNING: This function should only be called from the constructor. Most
678      * applications that interact with token contracts will not expect
679      * {decimals} to ever change, and may work incorrectly if it does.
680      */
681     function _setupDecimals(uint8 decimals_) internal {
682         _decimals = decimals_;
683     }
684 
685     /**
686      * @dev Hook that is called before any transfer of tokens. This includes
687      * minting and burning.
688      *
689      * Calling conditions:
690      *
691      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
692      * will be to transferred to `to`.
693      * - when `from` is zero, `amount` tokens will be minted for `to`.
694      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
695      * - `from` and `to` are never both zero.
696      *
697      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
698      */
699     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
700 }
701 
702 pragma solidity ^0.6.0;
703 
704 
705 /**
706  * @dev Contract module which allows children to implement an emergency stop
707  * mechanism that can be triggered by an authorized account.
708  *
709  * This module is used through inheritance. It will make available the
710  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
711  * the functions of your contract. Note that they will not be pausable by
712  * simply including this module, only once the modifiers are put in place.
713  */
714 contract Pausable is Context {
715     /**
716      * @dev Emitted when the pause is triggered by `account`.
717      */
718     event Paused(address account);
719 
720     /**
721      * @dev Emitted when the pause is lifted by `account`.
722      */
723     event Unpaused(address account);
724 
725     bool private _paused;
726 
727     /**
728      * @dev Initializes the contract in unpaused state.
729      */
730     constructor () internal {
731         _paused = false;
732     }
733 
734     /**
735      * @dev Returns true if the contract is paused, and false otherwise.
736      */
737     function paused() public view returns (bool) {
738         return _paused;
739     }
740 
741     /**
742      * @dev Modifier to make a function callable only when the contract is not paused.
743      *
744      * Requirements:
745      *
746      * - The contract must not be paused.
747      */
748     modifier whenNotPaused() {
749         require(!_paused, "Pausable: paused");
750         _;
751     }
752 
753     /**
754      * @dev Modifier to make a function callable only when the contract is paused.
755      *
756      * Requirements:
757      *
758      * - The contract must be paused.
759      */
760     modifier whenPaused() {
761         require(_paused, "Pausable: not paused");
762         _;
763     }
764 
765     /**
766      * @dev Triggers stopped state.
767      *
768      * Requirements:
769      *
770      * - The contract must not be paused.
771      */
772     function _pause() internal virtual whenNotPaused {
773         _paused = true;
774         emit Paused(_msgSender());
775     }
776 
777     /**
778      * @dev Returns to normal state.
779      *
780      * Requirements:
781      *
782      * - The contract must be paused.
783      */
784     function _unpause() internal virtual whenPaused {
785         _paused = false;
786         emit Unpaused(_msgSender());
787     }
788 }
789 
790 pragma solidity ^0.6.0;
791 
792 
793 /**
794  * @dev ERC20 token with pausable token transfers, minting and burning.
795  *
796  * Useful for scenarios such as preventing trades until the end of an evaluation
797  * period, or having an emergency switch for freezing all token transfers in the
798  * event of a large bug.
799  */
800 abstract contract ERC20Pausable is ERC20, Pausable {
801     /**
802      * @dev See {ERC20-_beforeTokenTransfer}.
803      *
804      * Requirements:
805      *
806      * - the contract must not be paused.
807      */
808     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
809         super._beforeTokenTransfer(from, to, amount);
810 
811         require(!paused(), "ERC20Pausable: token transfer while paused");
812     }
813 }
814 
815 pragma solidity ^0.6.0;
816 
817 /**
818  * @dev Extension of {ERC20} that allows token holders to destroy both their own
819  * tokens and those that they have an allowance for, in a way that can be
820  * recognized off-chain (via event analysis).
821  */
822 abstract contract ERC20Burnable is Context, ERC20 {
823     /**
824      * @dev Destroys `amount` tokens from the caller.
825      *
826      * See {ERC20-_burn}.
827      */
828     function burn(uint256 amount) public virtual {
829         _burn(_msgSender(), amount);
830     }
831 
832     /**
833      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
834      * allowance.
835      *
836      * See {ERC20-_burn} and {ERC20-allowance}.
837      *
838      * Requirements:
839      *
840      * - the caller must have allowance for ``accounts``'s tokens of at least
841      * `amount`.
842      */
843     function burnFrom(address account, uint256 amount) public virtual {
844         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
845 
846         _approve(account, _msgSender(), decreasedAllowance);
847         _burn(account, amount);
848     }
849 }
850 
851 pragma solidity ^0.6.12;
852 
853 /// @title Drakoin
854 /// @author Drakons Team
855 /// @dev The main token contract for Drakons Utility token
856 
857 contract Drakoin is ERC20Burnable, ERC20Pausable {
858 
859     uint256 private _fractionMultiplier;
860     uint256 private _valuePerStakedToken;
861     uint256 private _maximumSupply;
862 
863     uint256 public burnRate;
864     uint256 public minimumSupply;
865     uint256 public minStakeAmount;
866     uint256 public minStakeDays;
867     uint256 public bonusBalance;
868     uint256 public maxHolderBonusCount;
869     uint256 public bonusDuedays;
870 
871     address public CEOAddress;
872     address public CIOAddress;
873     address public COOAddress;
874 
875     address[] internal stakeholders;
876     mapping(address => uint256) internal bonus;
877     mapping(address => uint256) internal duedate;
878     mapping(address => uint256) internal holderBonusCount;
879     mapping(address => uint256) internal holderBonusDue;
880     mapping(address => uint256) internal rewards;
881     mapping(address => uint256) internal rewardsForClaiming;
882     mapping(address => uint256) internal rewardsWithdrawn;
883     mapping(address => uint256) internal stakes;
884     mapping(address => uint256) internal stakedDays;
885     mapping(address => bool) internal stakeholder;
886     mapping(address => uint256) internal stakerValuePerStakedToken;
887     mapping(uint256 => uint256) internal tierDayRate;
888     mapping(address => bool) internal whitelisted;
889 
890     event BurnTokens(address _address, uint256 _amount);
891     event CEOAddressUpdated(address newAddress);
892     event CIOAddressUpdated(address newAddress);
893     event COOAddressUpdated(address newAddress);
894     event CreateStake(address _address, uint256 _amount, uint256 _numberOfDays);
895     event RemoveStake(address _address, uint256 _amount);
896     event ClaimRewards(address _address, uint256 _amount);
897     event UpdateBurnRate(uint256 _newRate);
898     event UpdateMinStakeAmount(uint256 _amount);
899     event UpdateMinStakeDays(uint256 _amount);
900     event UpdateTierDayRate(uint256 _newNumberOfDays, uint256 _newRate);
901     event UpdateBonusBalance(uint256 bonusBalance, uint256 _addValue);
902     event UpdateBonusDuedays(uint256 _newValue);
903     event UpdateMaxHolderBonusCount(uint256 _newValue);
904 
905     modifier onlyCEO() {
906         require(msg.sender == CEOAddress, "Only the CEO is allowed to call this function.");
907         _;
908     }
909 
910     modifier onlyCLevel() {
911         require(
912             msg.sender == CEOAddress ||
913             msg.sender == CIOAddress ||
914             msg.sender == COOAddress
915         , "Only accounts with C-Level admin rights are allowed to call this function.");
916         _;
917     }
918 
919     constructor (address _cooAddress, address _cioAddress) public ERC20("Drakoin", "DRK") {
920         _fractionMultiplier = 1e18;
921 
922         burnRate = 500; // 5.0% per tx of non-whitelisted address
923 
924         _maximumSupply = 500000000;
925         minimumSupply = 250000000 * (10 ** 18);
926         minStakeAmount = 1e21;
927         minStakeDays = 5;
928         maxHolderBonusCount = 5;
929         bonusDuedays = 5;
930 
931         tierDayRate[5] = 10;     //5 days - 0.1%
932         tierDayRate[10] = 30;    //10 days - 0.3%
933         tierDayRate[30] = 100;   //30 days - 1.0%
934         tierDayRate[90] = 350;   //90 days - 3.5%
935         tierDayRate[180] = 750;  //180 days - 7.5%
936 
937         COOAddress = _cooAddress;
938         CIOAddress = _cioAddress;
939         CEOAddress = msg.sender;
940 
941         whitelisted[_cooAddress] = true;
942         whitelisted[_cioAddress] = true;
943         whitelisted[msg.sender] = true;
944 
945         _mint(msg.sender, _maximumSupply * (10 ** uint256(decimals())));
946     }
947 
948     function transfer(address to, uint256 _amount) public virtual override returns (bool) {
949         return super.transfer(to, _partialBurn(msg.sender, _amount));
950     }
951 
952     function transferFrom(address _from, address _to, uint256 _amount) public virtual override returns (bool) {
953         return super.transferFrom(_from, _to, _partialBurn(_from, _amount));
954     }
955 
956     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal virtual override (ERC20, ERC20Pausable) {
957         return super._beforeTokenTransfer(_from, _to, _amount);
958     }
959 
960     function _partialBurn(address _from, uint256 _amount) internal returns (uint256) {
961         uint256 _burnAmount = _calculateBurnAmount(_amount);
962 
963         if (_burnAmount > 0) {
964             // Calculate rewarwds
965             uint256 _currentTotalStakes = _totalStakes();
966             if (_currentTotalStakes > 0) {
967                 uint256 _stakeAmount = (_burnAmount.mul(2)).div(5);
968                 _valuePerStakedToken = _valuePerStakedToken.add((_stakeAmount.mul(_fractionMultiplier)).div(_currentTotalStakes));
969             }
970 
971             _transfer(_from, address(this), _burnAmount);
972             _burn(address(this), ((_burnAmount.mul(3)).div(5)));
973             //_burn(_from, ((_burnAmount.mul(3)).div(5)));
974             //_transfer(_from, address(this), ((_burnAmount.mul(2)).div(5)));
975 
976         }
977 
978         return _amount.sub(_burnAmount);
979     }
980 
981     function _calculateBurnAmount(uint256 _amount) internal view returns (uint256) {
982         if (whitelisted[msg.sender]) return 0;
983         uint256 _burnAmount = 0;
984 
985         //Calculate tokens to be burned
986         if (totalSupply() > minimumSupply) {
987             _burnAmount = _amount.mul(burnRate).div(10000);
988             uint256 _tryToBurn = totalSupply().sub(minimumSupply);
989             if (_burnAmount > _tryToBurn) {
990                 _burnAmount = _tryToBurn;
991             }
992         }
993 
994         return _burnAmount;
995     }
996 
997     function setCEOAddress(address _address) external onlyCEO() {
998         whitelisted[CEOAddress] = false;
999         CEOAddress = _address;
1000         whitelisted[_address] = true;
1001         emit CEOAddressUpdated(_address);
1002     }
1003 
1004     function setCIOAddress(address _address) external onlyCEO() {
1005         if (CEOAddress != CIOAddress)
1006         {
1007             whitelisted[CIOAddress] = false;
1008         }
1009         CIOAddress = _address;
1010         whitelisted[_address] = true;
1011         emit CIOAddressUpdated(_address);
1012     }
1013 
1014     function setCOOAddress(address _address) external onlyCEO() {
1015         if (CEOAddress != COOAddress)
1016         {
1017             whitelisted[COOAddress] = false;
1018         }
1019         COOAddress = _address;
1020         whitelisted[_address] = true;
1021         emit COOAddressUpdated(_address);
1022     }
1023 
1024     function pause() external onlyCEO() {
1025         super._pause();
1026     }
1027 
1028     function unpause() external onlyCEO() {
1029         super._unpause();
1030     }
1031 
1032     function burnTokens(uint256 _amount) external {
1033         require(balanceOf(msg.sender) >= _amount, "Drakoin: Amount must be equal or greater than the account balance.");
1034 
1035         if (totalSupply() > minimumSupply) {
1036             uint256 _burnAmount = _amount;
1037             uint256 _tryToBurn = totalSupply().sub(minimumSupply);
1038             if (_burnAmount > _tryToBurn) {
1039                 _burnAmount = _tryToBurn;
1040             }
1041 
1042             uint256 _currentTotalStakes = _totalStakes();
1043             if (_currentTotalStakes > 0) {
1044                 uint256 _stakeAmount = (_burnAmount.mul(3)).div(5);
1045                 _valuePerStakedToken = _valuePerStakedToken.add((_stakeAmount.mul(_fractionMultiplier)).div(_currentTotalStakes));
1046             }
1047 
1048             _burn(msg.sender, ((_burnAmount.mul(2)).div(5)));
1049             _transfer(msg.sender, address(this), ((_burnAmount.mul(3)).div(5)));
1050 
1051         }
1052         emit BurnTokens(msg.sender, _amount);
1053     }
1054 
1055     function updateBurnRate(uint256 _newRate) external onlyCEO() {
1056         require(_newRate >= 500, "Drakoin: Burn rate must be equal or greater than 500.");
1057         require(_newRate <= 800, "Drakoin: Burn rate must be equal or less than 800.");
1058         burnRate = _newRate;
1059 
1060         emit UpdateBurnRate(burnRate);
1061     }
1062 
1063     function isStakeholder(address _address) public view returns(bool) {
1064         return stakeholder[_address];
1065     }
1066 
1067     function _isStakeholder(address _address) internal view returns(bool, uint256) {
1068         for (uint256 s = 0; s < stakeholders.length; s += 1){
1069             if (_address == stakeholders[s]) return (true, s);
1070         }
1071         return (false, 0);
1072     }
1073 
1074     function _addStakeholder(address _address) internal {
1075         (bool _isAddressStakeholder, ) = _isStakeholder(_address);
1076         if(!_isAddressStakeholder) stakeholders.push(_address);
1077 
1078         stakeholder[_address] = true;
1079     }
1080 
1081     function _removeStakeholder(address _address) internal {
1082         (bool _isAddressStakeholder, uint256 s) = _isStakeholder(_address);
1083         if(_isAddressStakeholder){
1084             stakeholders[s] = stakeholders[stakeholders.length - 1];
1085             stakeholders.pop();
1086         }
1087 
1088         stakeholder[_address] = false;
1089     }
1090 
1091     function stakeOf(address _stakeholder) public view returns(uint256) {
1092         return stakes[_stakeholder];
1093     }
1094 
1095     function _totalStakes() internal view returns(uint256) {
1096         uint256 _stakes = 0;
1097         for (uint256 s = 0; s < stakeholders.length; s += 1) {
1098             _stakes = _stakes.add(stakes[stakeholders[s]]);
1099         }
1100         return _stakes;
1101     }
1102 
1103     function totalStakes() public view returns(uint256) {
1104         return _totalStakes();
1105     }
1106 
1107     function _calculateBonus(uint256 _amount, uint256 _numberOfDays) internal returns (uint256) {
1108         if (bonusBalance == 0) {
1109             return 0;
1110         }
1111 
1112         uint256 _bonus = _amount.mul(tierDayRate[_numberOfDays]).div(10000);
1113 
1114         if (_bonus > bonusBalance) {
1115             _bonus = bonusBalance;
1116             bonusBalance = 0;
1117             return _bonus;
1118         }
1119 
1120         bonusBalance = bonusBalance.sub(_bonus);
1121         return _bonus;
1122     }
1123 
1124     function createStake(uint256 _amount, uint256 _numberOfDays) public {
1125         require(_numberOfDays >= minStakeDays, "Drakoin: Number of days must be >= than 5.");
1126         require(balanceOf(msg.sender) >= _amount, "Drakoin: Amount must be <= account balance.");
1127         require(stakes[msg.sender] + _amount >= minStakeAmount, "Drakoin: Total stake >= minimum allowed value.");
1128         require(tierDayRate[_numberOfDays] > 0, "Drakoin: Invalid number of days.");
1129 
1130         if (stakeholder[msg.sender]) {
1131             require(_numberOfDays >= stakedDays[msg.sender], "Drakoin: Stake days cannot be lowered.");
1132         }
1133         stakedDays[msg.sender] = _numberOfDays;
1134 
1135         rewardsForClaiming[msg.sender] = rewardOf(msg.sender);
1136         stakerValuePerStakedToken[msg.sender] = _valuePerStakedToken;
1137 
1138         _transfer(msg.sender, address(this), _amount);
1139         if(!stakeholder[msg.sender]) {
1140             _addStakeholder(msg.sender);
1141         }
1142         stakes[msg.sender] = stakes[msg.sender].add(_amount);
1143 
1144         if (holderBonusCount[msg.sender] < maxHolderBonusCount) {
1145             holderBonusCount[msg.sender]++;
1146 
1147             if (now >= holderBonusDue[msg.sender]) {
1148                 bonus[msg.sender] = 0;
1149             }
1150             bonus[msg.sender] = bonus[msg.sender].add(_calculateBonus(_amount, _numberOfDays));
1151 
1152             holderBonusDue[msg.sender] = now.add((bonusDuedays.mul(1 days)));
1153         }
1154 
1155         duedate[msg.sender] = now.add((_numberOfDays.mul(1 days)));
1156         emit CreateStake(msg.sender, _amount, _numberOfDays);
1157     }
1158 
1159     function removeStake(uint256 _amount) public {
1160         require(now >= duedate[msg.sender], "Drakoin: Current time is before due date.");
1161         require(stakes[msg.sender] >= _amount, "Drakoin: No current stake for this account.");
1162 
1163         rewardsForClaiming[msg.sender] = rewardOf(msg.sender);
1164         stakerValuePerStakedToken[msg.sender] = _valuePerStakedToken;
1165 
1166         stakes[msg.sender] = stakes[msg.sender].sub(_amount);
1167         if(stakes[msg.sender] == 0) _removeStakeholder(msg.sender);
1168         stakedDays[msg.sender] = 5;
1169 
1170         uint256 _burnAmount = _calculateBurnAmount(_amount);
1171         if (_burnAmount > 0) {
1172             uint256 _currentTotalStakes = _totalStakes();
1173             _burn(address(this), ((_burnAmount.mul(3)).div(5)));
1174 
1175             if (_currentTotalStakes > 0) {
1176                 uint256 _stakeAmount = (_burnAmount.mul(2)).div(5);
1177                 _valuePerStakedToken = _valuePerStakedToken.add((_stakeAmount.mul(_fractionMultiplier)).div(_currentTotalStakes));
1178             }
1179         }
1180 
1181         if (now >= holderBonusDue[msg.sender]) {
1182             bonus[msg.sender] = 0;
1183         }
1184 
1185         _transfer(address(this), msg.sender, _amount.sub(_burnAmount));
1186         emit RemoveStake(msg.sender, _amount);
1187     }
1188 
1189     function updateMinStakeAmount(uint256 _newAmount) external onlyCEO() {
1190         require(_newAmount >= 1e20, "Drakoin: Value must be more than 1000.");
1191         minStakeAmount = _newAmount;
1192 
1193         emit UpdateMinStakeAmount(minStakeAmount);
1194     }
1195 
1196     function updateMinStakeDays(uint256 _newStakeDays) external onlyCEO() {
1197         require(_newStakeDays > 0, "Drakoin: Value must be more than 0.");
1198         minStakeDays = _newStakeDays;
1199 
1200         emit UpdateMinStakeDays(minStakeDays);
1201     }
1202 
1203     function isWhitelisted(address _address) public view returns(bool) {
1204         return whitelisted[_address];
1205     }
1206 
1207     function addWhitelisted(address _whitelisted) external onlyCEO() {
1208         whitelisted[_whitelisted] = true;
1209     }
1210 
1211     function removeWhitelisted(address _whitelisted) external onlyCEO() {
1212         whitelisted[_whitelisted] = false;
1213     }
1214 
1215     function updateTierDayRate(uint256 _newNumberOfDays, uint256 _newRate) external onlyCEO() {
1216         require(_newNumberOfDays > 0, "Drakoin: Number of days must be more than 0.");
1217         require(_newRate >= 0, "Drakoin: Rate must be more than 0.");
1218         tierDayRate[_newNumberOfDays] = _newRate;
1219 
1220         emit UpdateTierDayRate(_newNumberOfDays, _newRate);
1221     }
1222 
1223     function totalRewards() public view returns(uint256)
1224     {
1225         uint256 _totalRewards = 0;
1226         for (uint256 s = 0; s < stakeholders.length; s += 1){
1227             _totalRewards = _totalRewards.add(rewardsForClaiming[stakeholders[s]]);
1228         }
1229 
1230         return _totalRewards;
1231     }
1232 
1233     function rewardOf(address _address) public view returns(uint256) {
1234         uint256 _bonus = 0;
1235         uint256 _additionalRewards = ((_valuePerStakedToken.sub(stakerValuePerStakedToken[_address])).mul(stakes[_address])).div(_fractionMultiplier);
1236 
1237         if (now >= holderBonusDue[_address]) {
1238             _bonus = bonus[_address];
1239         }
1240 
1241         return rewardsForClaiming[_address].add(_bonus.add(_additionalRewards));
1242     }
1243 
1244     function claimRewards() external returns (uint256) {
1245         uint256 _rewards = rewardOf(msg.sender);
1246         require(_rewards > 0);
1247 
1248         if (now >= holderBonusDue[msg.sender]) {
1249             bonus[msg.sender] = 0;
1250         }
1251 
1252         rewardsForClaiming[msg.sender] = 0;
1253         stakerValuePerStakedToken[msg.sender] = _valuePerStakedToken;
1254 
1255         _transfer(address(this), msg.sender, _rewards);
1256         emit ClaimRewards(msg.sender, _rewards);
1257         return _rewards;
1258     }
1259 
1260     function bonusOf(address _address) public view returns(uint256) {
1261         return bonus[_address];
1262     }
1263 
1264     function updateBonusBalance(uint256 _addValue) external onlyCEO() {
1265         require(_addValue > 0, "Drakoin: Value must be more than 0.");
1266         bonusBalance = bonusBalance.add(_addValue);
1267 
1268         _transfer(msg.sender, address(this), _addValue);
1269 
1270         emit UpdateBonusBalance(bonusBalance, _addValue);
1271     }
1272 
1273 
1274     function updateMaxHolderBonusCount(uint256 _newValue) external onlyCEO() {
1275         require(_newValue > 5, "Drakoin: Value must be more than 5.");
1276         maxHolderBonusCount = _newValue;
1277 
1278         emit UpdateMaxHolderBonusCount(_newValue);
1279     }
1280 
1281     function updateBonusDuedays(uint256 _newValue) external onlyCEO() {
1282         require(_newValue > 5, "Drakoin: Value must be more than 5.");
1283         bonusDuedays = _newValue;
1284 
1285         emit UpdateBonusDuedays(_newValue);
1286     }
1287 
1288     function get_valuePerStakedToken() external view onlyCLevel returns(uint256) {
1289         return _valuePerStakedToken;
1290     }
1291 
1292     function getReleaseDateOf(address _addresss) public view returns(uint256) {
1293         return duedate[_addresss];
1294     }
1295 
1296     function get_stakedDays(address _addresss) public view returns(uint256) {
1297         return stakedDays[_addresss];
1298     }
1299 
1300     function get_holderBonusCount(address _addresss) public view returns(uint256) {
1301         return holderBonusCount[_addresss];
1302     }
1303 
1304     function get_holderBonusDue(address _addresss) public view returns(uint256) {
1305         return holderBonusDue[_addresss];
1306     }
1307 
1308 }