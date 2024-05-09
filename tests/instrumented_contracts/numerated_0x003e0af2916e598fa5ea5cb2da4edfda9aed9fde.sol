1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
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
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
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
159     function sub(
160         uint256 a,
161         uint256 b,
162         string memory errorMessage
163     ) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(
263         uint256 a,
264         uint256 b,
265         string memory errorMessage
266     ) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // This method relies in extcodesize, which returns 0 for contracts in
295         // construction, since the code is only stored at the end of the
296         // constructor execution.
297 
298         uint256 size;
299         // solhint-disable-next-line no-inline-assembly
300         assembly {
301             size := extcodesize(account)
302         }
303         return size > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
326         (bool success, ) = recipient.call{value: amount}("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         return _functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(address(this).balance >= value, "Address: insufficient balance for call");
398         return _functionCallWithValue(target, data, value, errorMessage);
399     }
400 
401     function _functionCallWithValue(
402         address target,
403         bytes memory data,
404         uint256 weiValue,
405         string memory errorMessage
406     ) private returns (bytes memory) {
407         require(isContract(target), "Address: call to non-contract");
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
411         if (success) {
412             return returndata;
413         } else {
414             // Look for revert reason and bubble it up if present
415             if (returndata.length > 0) {
416                 // The easiest way to bubble the revert reason is using memory via assembly
417 
418                 // solhint-disable-next-line no-inline-assembly
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 /**
431  * @dev Implementation of the {IERC20} interface.
432  *
433  * This implementation is agnostic to the way tokens are created. This means
434  * that a supply mechanism has to be added in a derived contract using {_mint}.
435  * For a generic mechanism see {ERC20PresetMinterPauser}.
436  *
437  * TIP: For a detailed writeup see our guide
438  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
439  * to implement supply mechanisms].
440  *
441  * We have followed general OpenZeppelin guidelines: functions revert instead
442  * of returning `false` on failure. This behavior is nonetheless conventional
443  * and does not conflict with the expectations of ERC20 applications.
444  *
445  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
446  * This allows applications to reconstruct the allowance for all accounts just
447  * by listening to said events. Other implementations of the EIP may not emit
448  * these events, as it isn't required by the specification.
449  *
450  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
451  * functions have been added to mitigate the well-known issues around setting
452  * allowances. See {IERC20-approve}.
453  */
454 contract ERC20 is Context, IERC20 {
455     using SafeMath for uint256;
456     using Address for address;
457 
458     mapping(address => uint256) private _balances;
459 
460     mapping(address => mapping(address => uint256)) private _allowances;
461 
462     uint256 private _totalSupply;
463 
464     string private _name;
465     string private _symbol;
466     uint8 private _decimals;
467 
468     /**
469      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
470      * a default value of 18.
471      *
472      * To select a different value for {decimals}, use {_setupDecimals}.
473      *
474      * All three of these values are immutable: they can only be set once during
475      * construction.
476      */
477     constructor(string memory name, string memory symbol) public {
478         _name = name;
479         _symbol = symbol;
480         _decimals = 18;
481     }
482 
483     /**
484      * @dev Returns the name of the token.
485      */
486     function name() public view returns (string memory) {
487         return _name;
488     }
489 
490     /**
491      * @dev Returns the symbol of the token, usually a shorter version of the
492      * name.
493      */
494     function symbol() public view returns (string memory) {
495         return _symbol;
496     }
497 
498     /**
499      * @dev Returns the number of decimals used to get its user representation.
500      * For example, if `decimals` equals `2`, a balance of `505` tokens should
501      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
502      *
503      * Tokens usually opt for a value of 18, imitating the relationship between
504      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
505      * called.
506      *
507      * NOTE: This information is only used for _display_ purposes: it in
508      * no way affects any of the arithmetic of the contract, including
509      * {IERC20-balanceOf} and {IERC20-transfer}.
510      */
511     function decimals() public view returns (uint8) {
512         return _decimals;
513     }
514 
515     /**
516      * @dev See {IERC20-totalSupply}.
517      */
518     function totalSupply() public view override returns (uint256) {
519         return _totalSupply;
520     }
521 
522     /**
523      * @dev See {IERC20-balanceOf}.
524      */
525     function balanceOf(address account) public view override returns (uint256) {
526         return _balances[account];
527     }
528 
529     /**
530      * @dev See {IERC20-transfer}.
531      *
532      * Requirements:
533      *
534      * - `recipient` cannot be the zero address.
535      * - the caller must have a balance of at least `amount`.
536      */
537     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
538         _transfer(_msgSender(), recipient, amount);
539         return true;
540     }
541 
542     /**
543      * @dev See {IERC20-allowance}.
544      */
545     function allowance(address owner, address spender) public view virtual override returns (uint256) {
546         return _allowances[owner][spender];
547     }
548 
549     /**
550      * @dev See {IERC20-approve}.
551      *
552      * Requirements:
553      *
554      * - `spender` cannot be the zero address.
555      */
556     function approve(address spender, uint256 amount) public virtual override returns (bool) {
557         _approve(_msgSender(), spender, amount);
558         return true;
559     }
560 
561     /**
562      * @dev See {IERC20-transferFrom}.
563      *
564      * Emits an {Approval} event indicating the updated allowance. This is not
565      * required by the EIP. See the note at the beginning of {ERC20};
566      *
567      * Requirements:
568      * - `sender` and `recipient` cannot be the zero address.
569      * - `sender` must have a balance of at least `amount`.
570      * - the caller must have allowance for ``sender``'s tokens of at least
571      * `amount`.
572      */
573     function transferFrom(
574         address sender,
575         address recipient,
576         uint256 amount
577     ) public virtual override returns (bool) {
578         _transfer(sender, recipient, amount);
579         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
580         return true;
581     }
582 
583     /**
584      * @dev Atomically increases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      */
595     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
596         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
597         return true;
598     }
599 
600     /**
601      * @dev Atomically decreases the allowance granted to `spender` by the caller.
602      *
603      * This is an alternative to {approve} that can be used as a mitigation for
604      * problems described in {IERC20-approve}.
605      *
606      * Emits an {Approval} event indicating the updated allowance.
607      *
608      * Requirements:
609      *
610      * - `spender` cannot be the zero address.
611      * - `spender` must have allowance for the caller of at least
612      * `subtractedValue`.
613      */
614     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
615         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
616         return true;
617     }
618 
619     /**
620      * @dev Moves tokens `amount` from `sender` to `recipient`.
621      *
622      * This is internal function is equivalent to {transfer}, and can be used to
623      * e.g. implement automatic token fees, slashing mechanisms, etc.
624      *
625      * Emits a {Transfer} event.
626      *
627      * Requirements:
628      *
629      * - `sender` cannot be the zero address.
630      * - `recipient` cannot be the zero address.
631      * - `sender` must have a balance of at least `amount`.
632      */
633     function _transfer(
634         address sender,
635         address recipient,
636         uint256 amount
637     ) internal virtual {
638         require(sender != address(0), "ERC20: transfer from the zero address");
639         require(recipient != address(0), "ERC20: transfer to the zero address");
640 
641         _beforeTokenTransfer(sender, recipient, amount);
642 
643         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
644         _balances[recipient] = _balances[recipient].add(amount);
645         emit Transfer(sender, recipient, amount);
646     }
647 
648     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
649      * the total supply.
650      *
651      * Emits a {Transfer} event with `from` set to the zero address.
652      *
653      * Requirements
654      *
655      * - `to` cannot be the zero address.
656      */
657     function _mint(address account, uint256 amount) internal virtual {
658         require(account != address(0), "ERC20: mint to the zero address");
659 
660         _beforeTokenTransfer(address(0), account, amount);
661 
662         _totalSupply = _totalSupply.add(amount);
663         _balances[account] = _balances[account].add(amount);
664         emit Transfer(address(0), account, amount);
665     }
666 
667     /**
668      * @dev Destroys `amount` tokens from `account`, reducing the
669      * total supply.
670      *
671      * Emits a {Transfer} event with `to` set to the zero address.
672      *
673      * Requirements
674      *
675      * - `account` cannot be the zero address.
676      * - `account` must have at least `amount` tokens.
677      */
678     function _burn(address account, uint256 amount) internal virtual {
679         require(account != address(0), "ERC20: burn from the zero address");
680 
681         _beforeTokenTransfer(account, address(0), amount);
682 
683         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
684         _totalSupply = _totalSupply.sub(amount);
685         emit Transfer(account, address(0), amount);
686     }
687 
688     /**
689      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
690      *
691      * This internal function is equivalent to `approve`, and can be used to
692      * e.g. set automatic allowances for certain subsystems, etc.
693      *
694      * Emits an {Approval} event.
695      *
696      * Requirements:
697      *
698      * - `owner` cannot be the zero address.
699      * - `spender` cannot be the zero address.
700      */
701     function _approve(
702         address owner,
703         address spender,
704         uint256 amount
705     ) internal virtual {
706         require(owner != address(0), "ERC20: approve from the zero address");
707         require(spender != address(0), "ERC20: approve to the zero address");
708 
709         _allowances[owner][spender] = amount;
710         emit Approval(owner, spender, amount);
711     }
712 
713     /**
714      * @dev Sets {decimals} to a value other than the default one of 18.
715      *
716      * WARNING: This function should only be called from the constructor. Most
717      * applications that interact with token contracts will not expect
718      * {decimals} to ever change, and may work incorrectly if it does.
719      */
720     function _setupDecimals(uint8 decimals_) internal {
721         _decimals = decimals_;
722     }
723 
724     /**
725      * @dev Hook that is called before any transfer of tokens. This includes
726      * minting and burning.
727      *
728      * Calling conditions:
729      *
730      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
731      * will be to transferred to `to`.
732      * - when `from` is zero, `amount` tokens will be minted for `to`.
733      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
734      * - `from` and `to` are never both zero.
735      *
736      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
737      */
738     function _beforeTokenTransfer(
739         address from,
740         address to,
741         uint256 amount
742     ) internal virtual {}
743 }
744 
745 /**
746  * @dev Extension of {ERC20} that allows token holders to destroy both their own
747  * tokens and those that they have an allowance for, in a way that can be
748  * recognized off-chain (via event analysis).
749  */
750 abstract contract ERC20Burnable is Context, ERC20 {
751     /**
752      * @dev Destroys `amount` tokens from the caller.
753      *
754      * See {ERC20-_burn}.
755      */
756     function burn(uint256 amount) public virtual {
757         _burn(_msgSender(), amount);
758     }
759 
760     /**
761      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
762      * allowance.
763      *
764      * See {ERC20-_burn} and {ERC20-allowance}.
765      *
766      * Requirements:
767      *
768      * - the caller must have allowance for ``accounts``'s tokens of at least
769      * `amount`.
770      */
771     function burnFrom(address account, uint256 amount) public virtual {
772         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
773 
774         _approve(account, _msgSender(), decreasedAllowance);
775         _burn(account, amount);
776     }
777 }
778 
779 /**
780  * @dev Contract module which provides a basic access control mechanism, where
781  * there is an account (an owner) that can be granted exclusive access to
782  * specific functions.
783  *
784  * By default, the owner account will be the one that deploys the contract. This
785  * can later be changed with {transferOwnership}.
786  *
787  * This module is used through inheritance. It will make available the modifier
788  * `onlyOwner`, which can be applied to your functions to restrict their use to
789  * the owner.
790  */
791 contract Ownable is Context {
792     address private _owner;
793 
794     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
795 
796     /**
797      * @dev Initializes the contract setting the deployer as the initial owner.
798      */
799     constructor() internal {
800         address msgSender = _msgSender();
801         _owner = msgSender;
802         emit OwnershipTransferred(address(0), msgSender);
803     }
804 
805     /**
806      * @dev Returns the address of the current owner.
807      */
808     function owner() public view returns (address) {
809         return _owner;
810     }
811 
812     /**
813      * @dev Throws if called by any account other than the owner.
814      */
815     modifier onlyOwner() {
816         require(_owner == _msgSender(), "Ownable: caller is not the owner");
817         _;
818     }
819 
820     /**
821      * @dev Leaves the contract without owner. It will not be possible to call
822      * `onlyOwner` functions anymore. Can only be called by the current owner.
823      *
824      * NOTE: Renouncing ownership will leave the contract without an owner,
825      * thereby removing any functionality that is only available to the owner.
826      */
827     function renounceOwnership() public virtual onlyOwner {
828         emit OwnershipTransferred(_owner, address(0));
829         _owner = address(0);
830     }
831 
832     /**
833      * @dev Transfers ownership of the contract to a new account (`newOwner`).
834      * Can only be called by the current owner.
835      */
836     function transferOwnership(address newOwner) public virtual onlyOwner {
837         require(newOwner != address(0), "Ownable: new owner is the zero address");
838         emit OwnershipTransferred(_owner, newOwner);
839         _owner = newOwner;
840     }
841 }
842 
843 contract Operator is Context, Ownable {
844     address private _operator;
845 
846     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
847 
848     constructor() internal {
849         _operator = _msgSender();
850         emit OperatorTransferred(address(0), _operator);
851     }
852 
853     function operator() public view returns (address) {
854         return _operator;
855     }
856 
857     modifier onlyOperator() {
858         require(_operator == msg.sender, "operator: caller is not the operator");
859         _;
860     }
861 
862     function isOperator() public view returns (bool) {
863         return _msgSender() == _operator;
864     }
865 
866     function transferOperator(address newOperator_) public onlyOwner {
867         _transferOperator(newOperator_);
868     }
869 
870     function _transferOperator(address newOperator_) internal {
871         require(newOperator_ != address(0), "operator: zero address given for new operator");
872         emit OperatorTransferred(address(0), newOperator_);
873         _operator = newOperator_;
874     }
875 }
876 
877 contract Dollar is ERC20Burnable, Operator {
878     uint256 public constant STABLES_POOL_REWARD_ALLOCATION = 500000 ether;
879 
880     bool public rewardPoolDistributed = false;
881 
882     /**
883      * @notice Constructs the Basis Dollar ERC-20 contract.
884      */
885     constructor() public ERC20("Basis Dollar", "BSD") {
886         // Mints 1 Basis Dollar to contract creator for initial pool setup
887         _mint(msg.sender, 1 ether);
888     }
889 
890     /**
891      * @notice Operator mints basis dollar to a recipient
892      * @param recipient_ The address of recipient
893      * @param amount_ The amount of basis dollar to mint to
894      * @return whether the process has been done
895      */
896     function mint(address recipient_, uint256 amount_) public onlyOperator returns (bool) {
897         uint256 balanceBefore = balanceOf(recipient_);
898         _mint(recipient_, amount_);
899         uint256 balanceAfter = balanceOf(recipient_);
900 
901         return balanceAfter > balanceBefore;
902     }
903 
904     function burn(uint256 amount) public override onlyOperator {
905         super.burn(amount);
906     }
907 
908     function burnFrom(address account, uint256 amount) public override onlyOperator {
909         super.burnFrom(account, amount);
910     }
911 
912     /**
913      * @notice distribute to reward pool (only once)
914      */
915     function distributeReward(address _stablesPool) external onlyOperator {
916         require(!rewardPoolDistributed, "only can distribute once");
917         require(_stablesPool != address(0), "!_stablesPool");
918         rewardPoolDistributed = true;
919         _mint(_stablesPool, STABLES_POOL_REWARD_ALLOCATION);
920     }
921 }