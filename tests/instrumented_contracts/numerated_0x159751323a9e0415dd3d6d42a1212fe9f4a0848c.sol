1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.0;
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
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 
32 pragma solidity ^0.7.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 
111 
112 pragma solidity ^0.7.0;
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
270 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
271 
272 
273 
274 pragma solidity ^0.7.0;
275 
276 
277 
278 
279 /**
280  * @dev Implementation of the {IERC20} interface.
281  *
282  * This implementation is agnostic to the way tokens are created. This means
283  * that a supply mechanism has to be added in a derived contract using {_mint}.
284  * For a generic mechanism see {ERC20PresetMinterPauser}.
285  *
286  * TIP: For a detailed writeup see our guide
287  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
288  * to implement supply mechanisms].
289  *
290  * We have followed general OpenZeppelin guidelines: functions revert instead
291  * of returning `false` on failure. This behavior is nonetheless conventional
292  * and does not conflict with the expectations of ERC20 applications.
293  *
294  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
295  * This allows applications to reconstruct the allowance for all accounts just
296  * by listening to said events. Other implementations of the EIP may not emit
297  * these events, as it isn't required by the specification.
298  *
299  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
300  * functions have been added to mitigate the well-known issues around setting
301  * allowances. See {IERC20-approve}.
302  */
303 contract ERC20 is Context, IERC20 {
304     using SafeMath for uint256;
305 
306     mapping (address => uint256) private _balances;
307 
308     mapping (address => mapping (address => uint256)) private _allowances;
309 
310     uint256 private _totalSupply;
311 
312     string private _name;
313     string private _symbol;
314     uint8 private _decimals;
315 
316     /**
317      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
318      * a default value of 18.
319      *
320      * To select a different value for {decimals}, use {_setupDecimals}.
321      *
322      * All three of these values are immutable: they can only be set once during
323      * construction.
324      */
325     constructor (string memory name_, string memory symbol_) {
326         _name = name_;
327         _symbol = symbol_;
328         _decimals = 18;
329     }
330 
331     /**
332      * @dev Returns the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @dev Returns the symbol of the token, usually a shorter version of the
340      * name.
341      */
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346     /**
347      * @dev Returns the number of decimals used to get its user representation.
348      * For example, if `decimals` equals `2`, a balance of `505` tokens should
349      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
350      *
351      * Tokens usually opt for a value of 18, imitating the relationship between
352      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
353      * called.
354      *
355      * NOTE: This information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * {IERC20-balanceOf} and {IERC20-transfer}.
358      */
359     function decimals() public view returns (uint8) {
360         return _decimals;
361     }
362 
363     /**
364      * @dev See {IERC20-totalSupply}.
365      */
366     function totalSupply() public view override returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371      * @dev See {IERC20-balanceOf}.
372      */
373     function balanceOf(address account) public view override returns (uint256) {
374         return _balances[account];
375     }
376 
377     /**
378      * @dev See {IERC20-transfer}.
379      *
380      * Requirements:
381      *
382      * - `recipient` cannot be the zero address.
383      * - the caller must have a balance of at least `amount`.
384      */
385     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-allowance}.
392      */
393     function allowance(address owner, address spender) public view virtual override returns (uint256) {
394         return _allowances[owner][spender];
395     }
396 
397     /**
398      * @dev See {IERC20-approve}.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function approve(address spender, uint256 amount) public virtual override returns (bool) {
405         _approve(_msgSender(), spender, amount);
406         return true;
407     }
408 
409     /**
410      * @dev See {IERC20-transferFrom}.
411      *
412      * Emits an {Approval} event indicating the updated allowance. This is not
413      * required by the EIP. See the note at the beginning of {ERC20}.
414      *
415      * Requirements:
416      *
417      * - `sender` and `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      * - the caller must have allowance for ``sender``'s tokens of at least
420      * `amount`.
421      */
422     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
423         _transfer(sender, recipient, amount);
424         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
425         return true;
426     }
427 
428     /**
429      * @dev Atomically increases the allowance granted to `spender` by the caller.
430      *
431      * This is an alternative to {approve} that can be used as a mitigation for
432      * problems described in {IERC20-approve}.
433      *
434      * Emits an {Approval} event indicating the updated allowance.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      */
440     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
441         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
442         return true;
443     }
444 
445     /**
446      * @dev Atomically decreases the allowance granted to `spender` by the caller.
447      *
448      * This is an alternative to {approve} that can be used as a mitigation for
449      * problems described in {IERC20-approve}.
450      *
451      * Emits an {Approval} event indicating the updated allowance.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      * - `spender` must have allowance for the caller of at least
457      * `subtractedValue`.
458      */
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
461         return true;
462     }
463 
464     /**
465      * @dev Moves tokens `amount` from `sender` to `recipient`.
466      *
467      * This is internal function is equivalent to {transfer}, and can be used to
468      * e.g. implement automatic token fees, slashing mechanisms, etc.
469      *
470      * Emits a {Transfer} event.
471      *
472      * Requirements:
473      *
474      * - `sender` cannot be the zero address.
475      * - `recipient` cannot be the zero address.
476      * - `sender` must have a balance of at least `amount`.
477      */
478     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
479         require(sender != address(0), "ERC20: transfer from the zero address");
480         require(recipient != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(sender, recipient, amount);
483 
484         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
485         _balances[recipient] = _balances[recipient].add(amount);
486         emit Transfer(sender, recipient, amount);
487     }
488 
489     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
490      * the total supply.
491      *
492      * Emits a {Transfer} event with `from` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `to` cannot be the zero address.
497      */
498     function _mint(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: mint to the zero address");
500 
501         _beforeTokenTransfer(address(0), account, amount);
502 
503         _totalSupply = _totalSupply.add(amount);
504         _balances[account] = _balances[account].add(amount);
505         emit Transfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements:
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal virtual {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _beforeTokenTransfer(account, address(0), amount);
523 
524         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
525         _totalSupply = _totalSupply.sub(amount);
526         emit Transfer(account, address(0), amount);
527     }
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
531      *
532      * This internal function is equivalent to `approve`, and can be used to
533      * e.g. set automatic allowances for certain subsystems, etc.
534      *
535      * Emits an {Approval} event.
536      *
537      * Requirements:
538      *
539      * - `owner` cannot be the zero address.
540      * - `spender` cannot be the zero address.
541      */
542     function _approve(address owner, address spender, uint256 amount) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Sets {decimals} to a value other than the default one of 18.
552      *
553      * WARNING: This function should only be called from the constructor. Most
554      * applications that interact with token contracts will not expect
555      * {decimals} to ever change, and may work incorrectly if it does.
556      */
557     function _setupDecimals(uint8 decimals_) internal {
558         _decimals = decimals_;
559     }
560 
561     /**
562      * @dev Hook that is called before any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * will be to transferred to `to`.
569      * - when `from` is zero, `amount` tokens will be minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
579 
580 
581 
582 pragma solidity ^0.7.0;
583 
584 
585 
586 /**
587  * @dev Extension of {ERC20} that allows token holders to destroy both their own
588  * tokens and those that they have an allowance for, in a way that can be
589  * recognized off-chain (via event analysis).
590  */
591 abstract contract ERC20Burnable is Context, ERC20 {
592     using SafeMath for uint256;
593 
594     /**
595      * @dev Destroys `amount` tokens from the caller.
596      *
597      * See {ERC20-_burn}.
598      */
599     function burn(uint256 amount) public virtual {
600         _burn(_msgSender(), amount);
601     }
602 
603     /**
604      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
605      * allowance.
606      *
607      * See {ERC20-_burn} and {ERC20-allowance}.
608      *
609      * Requirements:
610      *
611      * - the caller must have allowance for ``accounts``'s tokens of at least
612      * `amount`.
613      */
614     function burnFrom(address account, uint256 amount) public virtual {
615         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
616 
617         _approve(account, _msgSender(), decreasedAllowance);
618         _burn(account, amount);
619     }
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
623 
624 
625 
626 pragma solidity ^0.7.0;
627 
628 
629 /**
630  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
631  */
632 abstract contract ERC20Capped is ERC20 {
633     using SafeMath for uint256;
634 
635     uint256 private _cap;
636 
637     /**
638      * @dev Sets the value of the `cap`. This value is immutable, it can only be
639      * set once during construction.
640      */
641     constructor (uint256 cap_) {
642         require(cap_ > 0, "ERC20Capped: cap is 0");
643         _cap = cap_;
644     }
645 
646     /**
647      * @dev Returns the cap on the token's total supply.
648      */
649     function cap() public view returns (uint256) {
650         return _cap;
651     }
652 
653     /**
654      * @dev See {ERC20-_beforeTokenTransfer}.
655      *
656      * Requirements:
657      *
658      * - minted tokens must not cause the total supply to go over the cap.
659      */
660     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
661         super._beforeTokenTransfer(from, to, amount);
662 
663         if (from == address(0)) { // When minting tokens
664             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
665         }
666     }
667 }
668 
669 // File: @openzeppelin/contracts/introspection/IERC165.sol
670 
671 
672 
673 pragma solidity ^0.7.0;
674 
675 /**
676  * @dev Interface of the ERC165 standard, as defined in the
677  * https://eips.ethereum.org/EIPS/eip-165[EIP].
678  *
679  * Implementers can declare support of contract interfaces, which can then be
680  * queried by others ({ERC165Checker}).
681  *
682  * For an implementation, see {ERC165}.
683  */
684 interface IERC165 {
685     /**
686      * @dev Returns true if this contract implements the interface defined by
687      * `interfaceId`. See the corresponding
688      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
689      * to learn more about how these ids are created.
690      *
691      * This function call must use less than 30 000 gas.
692      */
693     function supportsInterface(bytes4 interfaceId) external view returns (bool);
694 }
695 
696 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
697 
698 
699 
700 pragma solidity ^0.7.0;
701 
702 
703 
704 /**
705  * @title IERC1363 Interface
706  * @dev Interface for a Payable Token contract as defined in
707  *  https://eips.ethereum.org/EIPS/eip-1363
708  */
709 interface IERC1363 is IERC20, IERC165 {
710     /*
711      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
712      * 0x4bbee2df ===
713      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
714      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
715      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
716      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
717      */
718 
719     /*
720      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
721      * 0xfb9ec8ce ===
722      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
723      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
724      */
725 
726     /**
727      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
728      * @param recipient address The address which you want to transfer to
729      * @param amount uint256 The amount of tokens to be transferred
730      * @return true unless throwing
731      */
732     function transferAndCall(address recipient, uint256 amount) external returns (bool);
733 
734     /**
735      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
736      * @param recipient address The address which you want to transfer to
737      * @param amount uint256 The amount of tokens to be transferred
738      * @param data bytes Additional data with no specified format, sent in call to `recipient`
739      * @return true unless throwing
740      */
741     function transferAndCall(address recipient, uint256 amount, bytes calldata data) external returns (bool);
742 
743     /**
744      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
745      * @param sender address The address which you want to send tokens from
746      * @param recipient address The address which you want to transfer to
747      * @param amount uint256 The amount of tokens to be transferred
748      * @return true unless throwing
749      */
750     function transferFromAndCall(address sender, address recipient, uint256 amount) external returns (bool);
751 
752     /**
753      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
754      * @param sender address The address which you want to send tokens from
755      * @param recipient address The address which you want to transfer to
756      * @param amount uint256 The amount of tokens to be transferred
757      * @param data bytes Additional data with no specified format, sent in call to `recipient`
758      * @return true unless throwing
759      */
760     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes calldata data) external returns (bool);
761 
762     /**
763      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
764      * and then call `onApprovalReceived` on spender.
765      * Beware that changing an allowance with this method brings the risk that someone may use both the old
766      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
767      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
768      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
769      * @param spender address The address which will spend the funds
770      * @param amount uint256 The amount of tokens to be spent
771      */
772     function approveAndCall(address spender, uint256 amount) external returns (bool);
773 
774     /**
775      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
776      * and then call `onApprovalReceived` on spender.
777      * Beware that changing an allowance with this method brings the risk that someone may use both the old
778      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
779      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
780      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
781      * @param spender address The address which will spend the funds
782      * @param amount uint256 The amount of tokens to be spent
783      * @param data bytes Additional data with no specified format, sent in call to `spender`
784      */
785     function approveAndCall(address spender, uint256 amount, bytes calldata data) external returns (bool);
786 }
787 
788 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
789 
790 
791 
792 pragma solidity ^0.7.0;
793 
794 /**
795  * @title IERC1363Receiver Interface
796  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
797  *  from ERC1363 token contracts as defined in
798  *  https://eips.ethereum.org/EIPS/eip-1363
799  */
800 interface IERC1363Receiver {
801     /*
802      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
803      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
804      */
805 
806     /**
807      * @notice Handle the receipt of ERC1363 tokens
808      * @dev Any ERC1363 smart contract calls this function on the recipient
809      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
810      * transfer. Return of other than the magic value MUST result in the
811      * transaction being reverted.
812      * Note: the token contract address is always the message sender.
813      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
814      * @param sender address The address which are token transferred from
815      * @param amount uint256 The amount of tokens transferred
816      * @param data bytes Additional data with no specified format
817      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
818      */
819     function onTransferReceived(address operator, address sender, uint256 amount, bytes calldata data) external returns (bytes4);
820 }
821 
822 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
823 
824 
825 
826 pragma solidity ^0.7.0;
827 
828 /**
829  * @title IERC1363Spender Interface
830  * @dev Interface for any contract that wants to support approveAndCall
831  *  from ERC1363 token contracts as defined in
832  *  https://eips.ethereum.org/EIPS/eip-1363
833  */
834 interface IERC1363Spender {
835     /*
836      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
837      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
838      */
839 
840     /**
841      * @notice Handle the approval of ERC1363 tokens
842      * @dev Any ERC1363 smart contract calls this function on the recipient
843      * after an `approve`. This function MAY throw to revert and reject the
844      * approval. Return of other than the magic value MUST result in the
845      * transaction being reverted.
846      * Note: the token contract address is always the message sender.
847      * @param sender address The address which called `approveAndCall` function
848      * @param amount uint256 The amount of tokens to be spent
849      * @param data bytes Additional data with no specified format
850      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
851      */
852     function onApprovalReceived(address sender, uint256 amount, bytes calldata data) external returns (bytes4);
853 }
854 
855 // File: @openzeppelin/contracts/utils/Address.sol
856 
857 
858 
859 pragma solidity ^0.7.0;
860 
861 /**
862  * @dev Collection of functions related to the address type
863  */
864 library Address {
865     /**
866      * @dev Returns true if `account` is a contract.
867      *
868      * [IMPORTANT]
869      * ====
870      * It is unsafe to assume that an address for which this function returns
871      * false is an externally-owned account (EOA) and not a contract.
872      *
873      * Among others, `isContract` will return false for the following
874      * types of addresses:
875      *
876      *  - an externally-owned account
877      *  - a contract in construction
878      *  - an address where a contract will be created
879      *  - an address where a contract lived, but was destroyed
880      * ====
881      */
882     function isContract(address account) internal view returns (bool) {
883         // This method relies on extcodesize, which returns 0 for contracts in
884         // construction, since the code is only stored at the end of the
885         // constructor execution.
886 
887         uint256 size;
888         // solhint-disable-next-line no-inline-assembly
889         assembly { size := extcodesize(account) }
890         return size > 0;
891     }
892 
893     /**
894      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
895      * `recipient`, forwarding all available gas and reverting on errors.
896      *
897      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
898      * of certain opcodes, possibly making contracts go over the 2300 gas limit
899      * imposed by `transfer`, making them unable to receive funds via
900      * `transfer`. {sendValue} removes this limitation.
901      *
902      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
903      *
904      * IMPORTANT: because control is transferred to `recipient`, care must be
905      * taken to not create reentrancy vulnerabilities. Consider using
906      * {ReentrancyGuard} or the
907      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
908      */
909     function sendValue(address payable recipient, uint256 amount) internal {
910         require(address(this).balance >= amount, "Address: insufficient balance");
911 
912         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
913         (bool success, ) = recipient.call{ value: amount }("");
914         require(success, "Address: unable to send value, recipient may have reverted");
915     }
916 
917     /**
918      * @dev Performs a Solidity function call using a low level `call`. A
919      * plain`call` is an unsafe replacement for a function call: use this
920      * function instead.
921      *
922      * If `target` reverts with a revert reason, it is bubbled up by this
923      * function (like regular Solidity function calls).
924      *
925      * Returns the raw returned data. To convert to the expected return value,
926      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
927      *
928      * Requirements:
929      *
930      * - `target` must be a contract.
931      * - calling `target` with `data` must not revert.
932      *
933      * _Available since v3.1._
934      */
935     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
936       return functionCall(target, data, "Address: low-level call failed");
937     }
938 
939     /**
940      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
941      * `errorMessage` as a fallback revert reason when `target` reverts.
942      *
943      * _Available since v3.1._
944      */
945     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
946         return functionCallWithValue(target, data, 0, errorMessage);
947     }
948 
949     /**
950      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
951      * but also transferring `value` wei to `target`.
952      *
953      * Requirements:
954      *
955      * - the calling contract must have an ETH balance of at least `value`.
956      * - the called Solidity function must be `payable`.
957      *
958      * _Available since v3.1._
959      */
960     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
961         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
962     }
963 
964     /**
965      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
966      * with `errorMessage` as a fallback revert reason when `target` reverts.
967      *
968      * _Available since v3.1._
969      */
970     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
971         require(address(this).balance >= value, "Address: insufficient balance for call");
972         require(isContract(target), "Address: call to non-contract");
973 
974         // solhint-disable-next-line avoid-low-level-calls
975         (bool success, bytes memory returndata) = target.call{ value: value }(data);
976         return _verifyCallResult(success, returndata, errorMessage);
977     }
978 
979     /**
980      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
981      * but performing a static call.
982      *
983      * _Available since v3.3._
984      */
985     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
986         return functionStaticCall(target, data, "Address: low-level static call failed");
987     }
988 
989     /**
990      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
991      * but performing a static call.
992      *
993      * _Available since v3.3._
994      */
995     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
996         require(isContract(target), "Address: static call to non-contract");
997 
998         // solhint-disable-next-line avoid-low-level-calls
999         (bool success, bytes memory returndata) = target.staticcall(data);
1000         return _verifyCallResult(success, returndata, errorMessage);
1001     }
1002 
1003     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1004         if (success) {
1005             return returndata;
1006         } else {
1007             // Look for revert reason and bubble it up if present
1008             if (returndata.length > 0) {
1009                 // The easiest way to bubble the revert reason is using memory via assembly
1010 
1011                 // solhint-disable-next-line no-inline-assembly
1012                 assembly {
1013                     let returndata_size := mload(returndata)
1014                     revert(add(32, returndata), returndata_size)
1015                 }
1016             } else {
1017                 revert(errorMessage);
1018             }
1019         }
1020     }
1021 }
1022 
1023 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
1024 
1025 
1026 
1027 pragma solidity ^0.7.0;
1028 
1029 /**
1030  * @dev Library used to query support of an interface declared via {IERC165}.
1031  *
1032  * Note that these functions return the actual result of the query: they do not
1033  * `revert` if an interface is not supported. It is up to the caller to decide
1034  * what to do in these cases.
1035  */
1036 library ERC165Checker {
1037     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1038     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1039 
1040     /*
1041      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1042      */
1043     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1044 
1045     /**
1046      * @dev Returns true if `account` supports the {IERC165} interface,
1047      */
1048     function supportsERC165(address account) internal view returns (bool) {
1049         // Any contract that implements ERC165 must explicitly indicate support of
1050         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1051         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1052             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1053     }
1054 
1055     /**
1056      * @dev Returns true if `account` supports the interface defined by
1057      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1058      *
1059      * See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1062         // query support of both ERC165 as per the spec and support of _interfaceId
1063         return supportsERC165(account) &&
1064             _supportsERC165Interface(account, interfaceId);
1065     }
1066 
1067     /**
1068      * @dev Returns true if `account` supports all the interfaces defined in
1069      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1070      *
1071      * Batch-querying can lead to gas savings by skipping repeated checks for
1072      * {IERC165} support.
1073      *
1074      * See {IERC165-supportsInterface}.
1075      */
1076     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1077         // query support of ERC165 itself
1078         if (!supportsERC165(account)) {
1079             return false;
1080         }
1081 
1082         // query support of each interface in _interfaceIds
1083         for (uint256 i = 0; i < interfaceIds.length; i++) {
1084             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1085                 return false;
1086             }
1087         }
1088 
1089         // all interfaces supported
1090         return true;
1091     }
1092 
1093     /**
1094      * @notice Query if a contract implements an interface, does not check ERC165 support
1095      * @param account The address of the contract to query for support of an interface
1096      * @param interfaceId The interface identifier, as specified in ERC-165
1097      * @return true if the contract at account indicates support of the interface with
1098      * identifier interfaceId, false otherwise
1099      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1100      * the behavior of this method is undefined. This precondition can be checked
1101      * with {supportsERC165}.
1102      * Interface identification is specified in ERC-165.
1103      */
1104     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1105         // success determines whether the staticcall succeeded and result determines
1106         // whether the contract at account indicates support of _interfaceId
1107         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1108 
1109         return (success && result);
1110     }
1111 
1112     /**
1113      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1114      * @param account The address of the contract to query for support of an interface
1115      * @param interfaceId The interface identifier, as specified in ERC-165
1116      * @return success true if the STATICCALL succeeded, false otherwise
1117      * @return result true if the STATICCALL succeeded and the contract at account
1118      * indicates support of the interface with identifier interfaceId, false otherwise
1119      */
1120     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1121         private
1122         view
1123         returns (bool, bool)
1124     {
1125         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1126         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1127         if (result.length < 32) return (false, false);
1128         return (success, abi.decode(result, (bool)));
1129     }
1130 }
1131 
1132 // File: @openzeppelin/contracts/introspection/ERC165.sol
1133 
1134 
1135 
1136 pragma solidity ^0.7.0;
1137 
1138 
1139 /**
1140  * @dev Implementation of the {IERC165} interface.
1141  *
1142  * Contracts may inherit from this and call {_registerInterface} to declare
1143  * their support of an interface.
1144  */
1145 abstract contract ERC165 is IERC165 {
1146     /*
1147      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1148      */
1149     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1150 
1151     /**
1152      * @dev Mapping of interface ids to whether or not it's supported.
1153      */
1154     mapping(bytes4 => bool) private _supportedInterfaces;
1155 
1156     constructor () {
1157         // Derived contracts need only register support for their own interfaces,
1158         // we register support for ERC165 itself here
1159         _registerInterface(_INTERFACE_ID_ERC165);
1160     }
1161 
1162     /**
1163      * @dev See {IERC165-supportsInterface}.
1164      *
1165      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1166      */
1167     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1168         return _supportedInterfaces[interfaceId];
1169     }
1170 
1171     /**
1172      * @dev Registers the contract as an implementer of the interface defined by
1173      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1174      * registering its interface id is not required.
1175      *
1176      * See {IERC165-supportsInterface}.
1177      *
1178      * Requirements:
1179      *
1180      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1181      */
1182     function _registerInterface(bytes4 interfaceId) internal virtual {
1183         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1184         _supportedInterfaces[interfaceId] = true;
1185     }
1186 }
1187 
1188 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1189 
1190 
1191 
1192 pragma solidity ^0.7.0;
1193 
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201 /**
1202  * @title ERC1363
1203  * @dev Implementation of an ERC1363 interface
1204  */
1205 contract ERC1363 is ERC20, IERC1363, ERC165 {
1206     using Address for address;
1207 
1208     /*
1209      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1210      * 0x4bbee2df ===
1211      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1212      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1213      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1214      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1215      */
1216     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1217 
1218     /*
1219      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1220      * 0xfb9ec8ce ===
1221      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1222      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1223      */
1224     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1225 
1226     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1227     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1228     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1229 
1230     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1231     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1232     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1233 
1234     /**
1235      * @param name Name of the token
1236      * @param symbol A symbol to be used as ticker
1237      */
1238     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
1239         // register the supported interfaces to conform to ERC1363 via ERC165
1240         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1241         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1242     }
1243 
1244     /**
1245      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1246      * @param recipient The address to transfer to.
1247      * @param amount The amount to be transferred.
1248      * @return A boolean that indicates if the operation was successful.
1249      */
1250     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
1251         return transferAndCall(recipient, amount, "");
1252     }
1253 
1254     /**
1255      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1256      * @param recipient The address to transfer to
1257      * @param amount The amount to be transferred
1258      * @param data Additional data with no specified format
1259      * @return A boolean that indicates if the operation was successful.
1260      */
1261     function transferAndCall(address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
1262         transfer(recipient, amount);
1263         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1264         return true;
1265     }
1266 
1267     /**
1268      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1269      * @param sender The address which you want to send tokens from
1270      * @param recipient The address which you want to transfer to
1271      * @param amount The amount of tokens to be transferred
1272      * @return A boolean that indicates if the operation was successful.
1273      */
1274     function transferFromAndCall(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1275         return transferFromAndCall(sender, recipient, amount, "");
1276     }
1277 
1278     /**
1279      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1280      * @param sender The address which you want to send tokens from
1281      * @param recipient The address which you want to transfer to
1282      * @param amount The amount of tokens to be transferred
1283      * @param data Additional data with no specified format
1284      * @return A boolean that indicates if the operation was successful.
1285      */
1286     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
1287         transferFrom(sender, recipient, amount);
1288         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1289         return true;
1290     }
1291 
1292     /**
1293      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1294      * @param spender The address allowed to transfer to
1295      * @param amount The amount allowed to be transferred
1296      * @return A boolean that indicates if the operation was successful.
1297      */
1298     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1299         return approveAndCall(spender, amount, "");
1300     }
1301 
1302     /**
1303      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1304      * @param spender The address allowed to transfer to.
1305      * @param amount The amount allowed to be transferred.
1306      * @param data Additional data with no specified format.
1307      * @return A boolean that indicates if the operation was successful.
1308      */
1309     function approveAndCall(address spender, uint256 amount, bytes memory data) public virtual override returns (bool) {
1310         approve(spender, amount);
1311         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1312         return true;
1313     }
1314 
1315     /**
1316      * @dev Internal function to invoke `onTransferReceived` on a target address
1317      *  The call is not executed if the target address is not a contract
1318      * @param sender address Representing the previous owner of the given token value
1319      * @param recipient address Target address that will receive the tokens
1320      * @param amount uint256 The amount mount of tokens to be transferred
1321      * @param data bytes Optional data to send along with the call
1322      * @return whether the call correctly returned the expected magic value
1323      */
1324     function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal virtual returns (bool) {
1325         if (!recipient.isContract()) {
1326             return false;
1327         }
1328         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(
1329             _msgSender(), sender, amount, data
1330         );
1331         return (retval == _ERC1363_RECEIVED);
1332     }
1333 
1334     /**
1335      * @dev Internal function to invoke `onApprovalReceived` on a target address
1336      *  The call is not executed if the target address is not a contract
1337      * @param spender address The address which will spend the funds
1338      * @param amount uint256 The amount of tokens to be spent
1339      * @param data bytes Optional data to send along with the call
1340      * @return whether the call correctly returned the expected magic value
1341      */
1342     function _checkAndCallApprove(address spender, uint256 amount, bytes memory data) internal virtual returns (bool) {
1343         if (!spender.isContract()) {
1344             return false;
1345         }
1346         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1347             _msgSender(), amount, data
1348         );
1349         return (retval == _ERC1363_APPROVED);
1350     }
1351 }
1352 
1353 // File: @openzeppelin/contracts/access/Ownable.sol
1354 
1355 
1356 
1357 pragma solidity ^0.7.0;
1358 
1359 /**
1360  * @dev Contract module which provides a basic access control mechanism, where
1361  * there is an account (an owner) that can be granted exclusive access to
1362  * specific functions.
1363  *
1364  * By default, the owner account will be the one that deploys the contract. This
1365  * can later be changed with {transferOwnership}.
1366  *
1367  * This module is used through inheritance. It will make available the modifier
1368  * `onlyOwner`, which can be applied to your functions to restrict their use to
1369  * the owner.
1370  */
1371 abstract contract Ownable is Context {
1372     address private _owner;
1373 
1374     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1375 
1376     /**
1377      * @dev Initializes the contract setting the deployer as the initial owner.
1378      */
1379     constructor () {
1380         address msgSender = _msgSender();
1381         _owner = msgSender;
1382         emit OwnershipTransferred(address(0), msgSender);
1383     }
1384 
1385     /**
1386      * @dev Returns the address of the current owner.
1387      */
1388     function owner() public view returns (address) {
1389         return _owner;
1390     }
1391 
1392     /**
1393      * @dev Throws if called by any account other than the owner.
1394      */
1395     modifier onlyOwner() {
1396         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1397         _;
1398     }
1399 
1400     /**
1401      * @dev Leaves the contract without owner. It will not be possible to call
1402      * `onlyOwner` functions anymore. Can only be called by the current owner.
1403      *
1404      * NOTE: Renouncing ownership will leave the contract without an owner,
1405      * thereby removing any functionality that is only available to the owner.
1406      */
1407     function renounceOwnership() public virtual onlyOwner {
1408         emit OwnershipTransferred(_owner, address(0));
1409         _owner = address(0);
1410     }
1411 
1412     /**
1413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1414      * Can only be called by the current owner.
1415      */
1416     function transferOwnership(address newOwner) public virtual onlyOwner {
1417         require(newOwner != address(0), "Ownable: new owner is the zero address");
1418         emit OwnershipTransferred(_owner, newOwner);
1419         _owner = newOwner;
1420     }
1421 }
1422 
1423 // File: eth-token-recover/contracts/TokenRecover.sol
1424 
1425 
1426 
1427 pragma solidity ^0.7.0;
1428 
1429 
1430 
1431 /**
1432  * @title TokenRecover
1433  * @dev Allow to recover any ERC20 sent into the contract for error
1434  */
1435 contract TokenRecover is Ownable {
1436 
1437     /**
1438      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1439      * @param tokenAddress The token contract address
1440      * @param tokenAmount Number of tokens to be sent
1441      */
1442     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1443         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1444     }
1445 }
1446 
1447 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1448 
1449 
1450 
1451 pragma solidity ^0.7.0;
1452 
1453 
1454 /**
1455  * @title ERC20Mintable
1456  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1457  */
1458 abstract contract ERC20Mintable is ERC20 {
1459 
1460     // indicates if minting is finished
1461     bool private _mintingFinished = false;
1462 
1463     /**
1464      * @dev Emitted during finish minting
1465      */
1466     event MintFinished();
1467 
1468     /**
1469      * @dev Tokens can be minted only before minting finished.
1470      */
1471     modifier canMint() {
1472         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1473         _;
1474     }
1475 
1476     /**
1477      * @return if minting is finished or not.
1478      */
1479     function mintingFinished() public view returns (bool) {
1480         return _mintingFinished;
1481     }
1482 
1483     /**
1484      * @dev Function to mint tokens.
1485      *
1486      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1487      *
1488      * @param account The address that will receive the minted tokens
1489      * @param amount The amount of tokens to mint
1490      */
1491     function mint(address account, uint256 amount) public canMint {
1492         _mint(account, amount);
1493     }
1494 
1495     /**
1496      * @dev Function to stop minting new tokens.
1497      *
1498      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1499      */
1500     function finishMinting() public canMint {
1501         _finishMinting();
1502     }
1503 
1504     /**
1505      * @dev Function to stop minting new tokens.
1506      */
1507     function _finishMinting() internal virtual {
1508         _mintingFinished = true;
1509 
1510         emit MintFinished();
1511     }
1512 }
1513 
1514 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1515 
1516 
1517 
1518 pragma solidity ^0.7.0;
1519 
1520 /**
1521  * @dev Library for managing
1522  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1523  * types.
1524  *
1525  * Sets have the following properties:
1526  *
1527  * - Elements are added, removed, and checked for existence in constant time
1528  * (O(1)).
1529  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1530  *
1531  * ```
1532  * contract Example {
1533  *     // Add the library methods
1534  *     using EnumerableSet for EnumerableSet.AddressSet;
1535  *
1536  *     // Declare a set state variable
1537  *     EnumerableSet.AddressSet private mySet;
1538  * }
1539  * ```
1540  *
1541  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1542  * and `uint256` (`UintSet`) are supported.
1543  */
1544 library EnumerableSet {
1545     // To implement this library for multiple types with as little code
1546     // repetition as possible, we write it in terms of a generic Set type with
1547     // bytes32 values.
1548     // The Set implementation uses private functions, and user-facing
1549     // implementations (such as AddressSet) are just wrappers around the
1550     // underlying Set.
1551     // This means that we can only create new EnumerableSets for types that fit
1552     // in bytes32.
1553 
1554     struct Set {
1555         // Storage of set values
1556         bytes32[] _values;
1557 
1558         // Position of the value in the `values` array, plus 1 because index 0
1559         // means a value is not in the set.
1560         mapping (bytes32 => uint256) _indexes;
1561     }
1562 
1563     /**
1564      * @dev Add a value to a set. O(1).
1565      *
1566      * Returns true if the value was added to the set, that is if it was not
1567      * already present.
1568      */
1569     function _add(Set storage set, bytes32 value) private returns (bool) {
1570         if (!_contains(set, value)) {
1571             set._values.push(value);
1572             // The value is stored at length-1, but we add 1 to all indexes
1573             // and use 0 as a sentinel value
1574             set._indexes[value] = set._values.length;
1575             return true;
1576         } else {
1577             return false;
1578         }
1579     }
1580 
1581     /**
1582      * @dev Removes a value from a set. O(1).
1583      *
1584      * Returns true if the value was removed from the set, that is if it was
1585      * present.
1586      */
1587     function _remove(Set storage set, bytes32 value) private returns (bool) {
1588         // We read and store the value's index to prevent multiple reads from the same storage slot
1589         uint256 valueIndex = set._indexes[value];
1590 
1591         if (valueIndex != 0) { // Equivalent to contains(set, value)
1592             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1593             // the array, and then remove the last element (sometimes called as 'swap and pop').
1594             // This modifies the order of the array, as noted in {at}.
1595 
1596             uint256 toDeleteIndex = valueIndex - 1;
1597             uint256 lastIndex = set._values.length - 1;
1598 
1599             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1600             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1601 
1602             bytes32 lastvalue = set._values[lastIndex];
1603 
1604             // Move the last value to the index where the value to delete is
1605             set._values[toDeleteIndex] = lastvalue;
1606             // Update the index for the moved value
1607             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1608 
1609             // Delete the slot where the moved value was stored
1610             set._values.pop();
1611 
1612             // Delete the index for the deleted slot
1613             delete set._indexes[value];
1614 
1615             return true;
1616         } else {
1617             return false;
1618         }
1619     }
1620 
1621     /**
1622      * @dev Returns true if the value is in the set. O(1).
1623      */
1624     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1625         return set._indexes[value] != 0;
1626     }
1627 
1628     /**
1629      * @dev Returns the number of values on the set. O(1).
1630      */
1631     function _length(Set storage set) private view returns (uint256) {
1632         return set._values.length;
1633     }
1634 
1635    /**
1636     * @dev Returns the value stored at position `index` in the set. O(1).
1637     *
1638     * Note that there are no guarantees on the ordering of values inside the
1639     * array, and it may change when more values are added or removed.
1640     *
1641     * Requirements:
1642     *
1643     * - `index` must be strictly less than {length}.
1644     */
1645     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1646         require(set._values.length > index, "EnumerableSet: index out of bounds");
1647         return set._values[index];
1648     }
1649 
1650     // Bytes32Set
1651 
1652     struct Bytes32Set {
1653         Set _inner;
1654     }
1655 
1656     /**
1657      * @dev Add a value to a set. O(1).
1658      *
1659      * Returns true if the value was added to the set, that is if it was not
1660      * already present.
1661      */
1662     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1663         return _add(set._inner, value);
1664     }
1665 
1666     /**
1667      * @dev Removes a value from a set. O(1).
1668      *
1669      * Returns true if the value was removed from the set, that is if it was
1670      * present.
1671      */
1672     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1673         return _remove(set._inner, value);
1674     }
1675 
1676     /**
1677      * @dev Returns true if the value is in the set. O(1).
1678      */
1679     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1680         return _contains(set._inner, value);
1681     }
1682 
1683     /**
1684      * @dev Returns the number of values in the set. O(1).
1685      */
1686     function length(Bytes32Set storage set) internal view returns (uint256) {
1687         return _length(set._inner);
1688     }
1689 
1690    /**
1691     * @dev Returns the value stored at position `index` in the set. O(1).
1692     *
1693     * Note that there are no guarantees on the ordering of values inside the
1694     * array, and it may change when more values are added or removed.
1695     *
1696     * Requirements:
1697     *
1698     * - `index` must be strictly less than {length}.
1699     */
1700     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1701         return _at(set._inner, index);
1702     }
1703 
1704     // AddressSet
1705 
1706     struct AddressSet {
1707         Set _inner;
1708     }
1709 
1710     /**
1711      * @dev Add a value to a set. O(1).
1712      *
1713      * Returns true if the value was added to the set, that is if it was not
1714      * already present.
1715      */
1716     function add(AddressSet storage set, address value) internal returns (bool) {
1717         return _add(set._inner, bytes32(uint256(value)));
1718     }
1719 
1720     /**
1721      * @dev Removes a value from a set. O(1).
1722      *
1723      * Returns true if the value was removed from the set, that is if it was
1724      * present.
1725      */
1726     function remove(AddressSet storage set, address value) internal returns (bool) {
1727         return _remove(set._inner, bytes32(uint256(value)));
1728     }
1729 
1730     /**
1731      * @dev Returns true if the value is in the set. O(1).
1732      */
1733     function contains(AddressSet storage set, address value) internal view returns (bool) {
1734         return _contains(set._inner, bytes32(uint256(value)));
1735     }
1736 
1737     /**
1738      * @dev Returns the number of values in the set. O(1).
1739      */
1740     function length(AddressSet storage set) internal view returns (uint256) {
1741         return _length(set._inner);
1742     }
1743 
1744    /**
1745     * @dev Returns the value stored at position `index` in the set. O(1).
1746     *
1747     * Note that there are no guarantees on the ordering of values inside the
1748     * array, and it may change when more values are added or removed.
1749     *
1750     * Requirements:
1751     *
1752     * - `index` must be strictly less than {length}.
1753     */
1754     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1755         return address(uint256(_at(set._inner, index)));
1756     }
1757 
1758 
1759     // UintSet
1760 
1761     struct UintSet {
1762         Set _inner;
1763     }
1764 
1765     /**
1766      * @dev Add a value to a set. O(1).
1767      *
1768      * Returns true if the value was added to the set, that is if it was not
1769      * already present.
1770      */
1771     function add(UintSet storage set, uint256 value) internal returns (bool) {
1772         return _add(set._inner, bytes32(value));
1773     }
1774 
1775     /**
1776      * @dev Removes a value from a set. O(1).
1777      *
1778      * Returns true if the value was removed from the set, that is if it was
1779      * present.
1780      */
1781     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1782         return _remove(set._inner, bytes32(value));
1783     }
1784 
1785     /**
1786      * @dev Returns true if the value is in the set. O(1).
1787      */
1788     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1789         return _contains(set._inner, bytes32(value));
1790     }
1791 
1792     /**
1793      * @dev Returns the number of values on the set. O(1).
1794      */
1795     function length(UintSet storage set) internal view returns (uint256) {
1796         return _length(set._inner);
1797     }
1798 
1799    /**
1800     * @dev Returns the value stored at position `index` in the set. O(1).
1801     *
1802     * Note that there are no guarantees on the ordering of values inside the
1803     * array, and it may change when more values are added or removed.
1804     *
1805     * Requirements:
1806     *
1807     * - `index` must be strictly less than {length}.
1808     */
1809     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1810         return uint256(_at(set._inner, index));
1811     }
1812 }
1813 
1814 // File: @openzeppelin/contracts/access/AccessControl.sol
1815 
1816 
1817 
1818 pragma solidity ^0.7.0;
1819 
1820 
1821 
1822 
1823 /**
1824  * @dev Contract module that allows children to implement role-based access
1825  * control mechanisms.
1826  *
1827  * Roles are referred to by their `bytes32` identifier. These should be exposed
1828  * in the external API and be unique. The best way to achieve this is by
1829  * using `public constant` hash digests:
1830  *
1831  * ```
1832  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1833  * ```
1834  *
1835  * Roles can be used to represent a set of permissions. To restrict access to a
1836  * function call, use {hasRole}:
1837  *
1838  * ```
1839  * function foo() public {
1840  *     require(hasRole(MY_ROLE, msg.sender));
1841  *     ...
1842  * }
1843  * ```
1844  *
1845  * Roles can be granted and revoked dynamically via the {grantRole} and
1846  * {revokeRole} functions. Each role has an associated admin role, and only
1847  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1848  *
1849  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1850  * that only accounts with this role will be able to grant or revoke other
1851  * roles. More complex role relationships can be created by using
1852  * {_setRoleAdmin}.
1853  *
1854  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1855  * grant and revoke this role. Extra precautions should be taken to secure
1856  * accounts that have been granted it.
1857  */
1858 abstract contract AccessControl is Context {
1859     using EnumerableSet for EnumerableSet.AddressSet;
1860     using Address for address;
1861 
1862     struct RoleData {
1863         EnumerableSet.AddressSet members;
1864         bytes32 adminRole;
1865     }
1866 
1867     mapping (bytes32 => RoleData) private _roles;
1868 
1869     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1870 
1871     /**
1872      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1873      *
1874      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1875      * {RoleAdminChanged} not being emitted signaling this.
1876      *
1877      * _Available since v3.1._
1878      */
1879     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1880 
1881     /**
1882      * @dev Emitted when `account` is granted `role`.
1883      *
1884      * `sender` is the account that originated the contract call, an admin role
1885      * bearer except when using {_setupRole}.
1886      */
1887     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1888 
1889     /**
1890      * @dev Emitted when `account` is revoked `role`.
1891      *
1892      * `sender` is the account that originated the contract call:
1893      *   - if using `revokeRole`, it is the admin role bearer
1894      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1895      */
1896     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1897 
1898     /**
1899      * @dev Returns `true` if `account` has been granted `role`.
1900      */
1901     function hasRole(bytes32 role, address account) public view returns (bool) {
1902         return _roles[role].members.contains(account);
1903     }
1904 
1905     /**
1906      * @dev Returns the number of accounts that have `role`. Can be used
1907      * together with {getRoleMember} to enumerate all bearers of a role.
1908      */
1909     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1910         return _roles[role].members.length();
1911     }
1912 
1913     /**
1914      * @dev Returns one of the accounts that have `role`. `index` must be a
1915      * value between 0 and {getRoleMemberCount}, non-inclusive.
1916      *
1917      * Role bearers are not sorted in any particular way, and their ordering may
1918      * change at any point.
1919      *
1920      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1921      * you perform all queries on the same block. See the following
1922      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1923      * for more information.
1924      */
1925     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1926         return _roles[role].members.at(index);
1927     }
1928 
1929     /**
1930      * @dev Returns the admin role that controls `role`. See {grantRole} and
1931      * {revokeRole}.
1932      *
1933      * To change a role's admin, use {_setRoleAdmin}.
1934      */
1935     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1936         return _roles[role].adminRole;
1937     }
1938 
1939     /**
1940      * @dev Grants `role` to `account`.
1941      *
1942      * If `account` had not been already granted `role`, emits a {RoleGranted}
1943      * event.
1944      *
1945      * Requirements:
1946      *
1947      * - the caller must have ``role``'s admin role.
1948      */
1949     function grantRole(bytes32 role, address account) public virtual {
1950         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1951 
1952         _grantRole(role, account);
1953     }
1954 
1955     /**
1956      * @dev Revokes `role` from `account`.
1957      *
1958      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1959      *
1960      * Requirements:
1961      *
1962      * - the caller must have ``role``'s admin role.
1963      */
1964     function revokeRole(bytes32 role, address account) public virtual {
1965         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1966 
1967         _revokeRole(role, account);
1968     }
1969 
1970     /**
1971      * @dev Revokes `role` from the calling account.
1972      *
1973      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1974      * purpose is to provide a mechanism for accounts to lose their privileges
1975      * if they are compromised (such as when a trusted device is misplaced).
1976      *
1977      * If the calling account had been granted `role`, emits a {RoleRevoked}
1978      * event.
1979      *
1980      * Requirements:
1981      *
1982      * - the caller must be `account`.
1983      */
1984     function renounceRole(bytes32 role, address account) public virtual {
1985         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1986 
1987         _revokeRole(role, account);
1988     }
1989 
1990     /**
1991      * @dev Grants `role` to `account`.
1992      *
1993      * If `account` had not been already granted `role`, emits a {RoleGranted}
1994      * event. Note that unlike {grantRole}, this function doesn't perform any
1995      * checks on the calling account.
1996      *
1997      * [WARNING]
1998      * ====
1999      * This function should only be called from the constructor when setting
2000      * up the initial roles for the system.
2001      *
2002      * Using this function in any other way is effectively circumventing the admin
2003      * system imposed by {AccessControl}.
2004      * ====
2005      */
2006     function _setupRole(bytes32 role, address account) internal virtual {
2007         _grantRole(role, account);
2008     }
2009 
2010     /**
2011      * @dev Sets `adminRole` as ``role``'s admin role.
2012      *
2013      * Emits a {RoleAdminChanged} event.
2014      */
2015     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2016         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
2017         _roles[role].adminRole = adminRole;
2018     }
2019 
2020     function _grantRole(bytes32 role, address account) private {
2021         if (_roles[role].members.add(account)) {
2022             emit RoleGranted(role, account, _msgSender());
2023         }
2024     }
2025 
2026     function _revokeRole(bytes32 role, address account) private {
2027         if (_roles[role].members.remove(account)) {
2028             emit RoleRevoked(role, account, _msgSender());
2029         }
2030     }
2031 }
2032 
2033 // File: contracts/access/Roles.sol
2034 
2035 
2036 
2037 pragma solidity ^0.7.0;
2038 
2039 
2040 contract Roles is AccessControl {
2041 
2042     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
2043 
2044     constructor () {
2045         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2046         _setupRole(MINTER_ROLE, _msgSender());
2047     }
2048 
2049     modifier onlyMinter() {
2050         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
2051         _;
2052     }
2053 }
2054 
2055 // File: contracts/service/ServiceReceiver.sol
2056 
2057 
2058 
2059 pragma solidity ^0.7.0;
2060 
2061 
2062 /**
2063  * @title ServiceReceiver
2064  * @dev Implementation of the ServiceReceiver
2065  */
2066 contract ServiceReceiver is TokenRecover {
2067 
2068     mapping (bytes32 => uint256) private _prices;
2069 
2070     event Created(string serviceName, address indexed serviceAddress);
2071 
2072     function pay(string memory serviceName) public payable {
2073         require(msg.value == _prices[_toBytes32(serviceName)], "ServiceReceiver: incorrect price");
2074 
2075         emit Created(serviceName, _msgSender());
2076     }
2077 
2078     function getPrice(string memory serviceName) public view returns (uint256) {
2079         return _prices[_toBytes32(serviceName)];
2080     }
2081 
2082     function setPrice(string memory serviceName, uint256 amount) public onlyOwner {
2083         _prices[_toBytes32(serviceName)] = amount;
2084     }
2085 
2086     function withdraw(uint256 amount) public onlyOwner {
2087         payable(owner()).transfer(amount);
2088     }
2089 
2090     function _toBytes32(string memory serviceName) private pure returns (bytes32) {
2091         return keccak256(abi.encode(serviceName));
2092     }
2093 }
2094 
2095 // File: contracts/service/ServicePayer.sol
2096 
2097 
2098 
2099 pragma solidity ^0.7.0;
2100 
2101 
2102 /**
2103  * @title ServicePayer
2104  * @dev Implementation of the ServicePayer
2105  */
2106 abstract contract ServicePayer {
2107 
2108     constructor (address payable receiver, string memory serviceName) payable {
2109         ServiceReceiver(receiver).pay{value: msg.value}(serviceName);
2110     }
2111 }
2112 
2113 // File: contracts/token/ERC20/PowerfulERC20.sol
2114 
2115 
2116 
2117 pragma solidity ^0.7.0;
2118 
2119 
2120 
2121 
2122 
2123 
2124 
2125 
2126 /**
2127  * @title PowerfulERC20
2128  * @dev Implementation of the PowerfulERC20
2129  */
2130 contract PowerfulERC20 is ERC20Capped, ERC20Mintable, ERC20Burnable, ERC1363, TokenRecover, Roles, ServicePayer {
2131 
2132     constructor (
2133         string memory name,
2134         string memory symbol,
2135         uint8 decimals,
2136         uint256 cap,
2137         uint256 initialBalance,
2138         address payable feeReceiver
2139     )
2140         ERC1363(name, symbol)
2141         ERC20Capped(cap)
2142         ServicePayer(feeReceiver, "PowerfulERC20")
2143         payable
2144     {
2145         _setupDecimals(decimals);
2146         _mint(_msgSender(), initialBalance);
2147     }
2148 
2149     /**
2150      * @dev Function to mint tokens.
2151      *
2152      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
2153      *
2154      * @param account The address that will receive the minted tokens
2155      * @param amount The amount of tokens to mint
2156      */
2157     function _mint(address account, uint256 amount) internal override onlyMinter {
2158         super._mint(account, amount);
2159     }
2160 
2161     /**
2162      * @dev Function to stop minting new tokens.
2163      *
2164      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
2165      */
2166     function _finishMinting() internal override onlyOwner {
2167         super._finishMinting();
2168     }
2169 
2170     /**
2171      * @dev See {ERC20-_beforeTokenTransfer}. See {ERC20Capped-_beforeTokenTransfer}.
2172      */
2173     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Capped) {
2174         super._beforeTokenTransfer(from, to, amount);
2175     }
2176 }