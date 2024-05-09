1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
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
26 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
27 
28 
29 
30 pragma solidity ^0.7.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
108 
109 
110 pragma solidity ^0.7.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
269 
270 
271 
272 pragma solidity ^0.7.0;
273 
274 
275 
276 
277 /**
278  * @dev Implementation of the {IERC20} interface.
279  *
280  * This implementation is agnostic to the way tokens are created. This means
281  * that a supply mechanism has to be added in a derived contract using {_mint}.
282  * For a generic mechanism see {ERC20PresetMinterPauser}.
283  *
284  * TIP: For a detailed writeup see our guide
285  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
286  * to implement supply mechanisms].
287  *
288  * We have followed general OpenZeppelin guidelines: functions revert instead
289  * of returning `false` on failure. This behavior is nonetheless conventional
290  * and does not conflict with the expectations of ERC20 applications.
291  *
292  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
293  * This allows applications to reconstruct the allowance for all accounts just
294  * by listening to said events. Other implementations of the EIP may not emit
295  * these events, as it isn't required by the specification.
296  *
297  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
298  * functions have been added to mitigate the well-known issues around setting
299  * allowances. See {IERC20-approve}.
300  */
301 contract ERC20 is Context, IERC20 {
302     using SafeMath for uint256;
303 
304     mapping (address => uint256) private _balances;
305 
306     mapping (address => mapping (address => uint256)) private _allowances;
307 
308     uint256 private _totalSupply;
309 
310     string private _name;
311     string private _symbol;
312     uint8 private _decimals;
313 
314     /**
315      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
316      * a default value of 18.
317      *
318      * To select a different value for {decimals}, use {_setupDecimals}.
319      *
320      * All three of these values are immutable: they can only be set once during
321      * construction.
322      */
323     constructor (string memory name_, string memory symbol_) {
324         _name = name_;
325         _symbol = symbol_;
326         _decimals = 18;
327     }
328 
329     /**
330      * @dev Returns the name of the token.
331      */
332     function name() public view returns (string memory) {
333         return _name;
334     }
335 
336     /**
337      * @dev Returns the symbol of the token, usually a shorter version of the
338      * name.
339      */
340     function symbol() public view returns (string memory) {
341         return _symbol;
342     }
343 
344     /**
345      * @dev Returns the number of decimals used to get its user representation.
346      * For example, if `decimals` equals `2`, a balance of `505` tokens should
347      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
348      *
349      * Tokens usually opt for a value of 18, imitating the relationship between
350      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
351      * called.
352      *
353      * NOTE: This information is only used for _display_ purposes: it in
354      * no way affects any of the arithmetic of the contract, including
355      * {IERC20-balanceOf} and {IERC20-transfer}.
356      */
357     function decimals() public view returns (uint8) {
358         return _decimals;
359     }
360 
361     /**
362      * @dev See {IERC20-totalSupply}.
363      */
364     function totalSupply() public view override returns (uint256) {
365         return _totalSupply;
366     }
367 
368     /**
369      * @dev See {IERC20-balanceOf}.
370      */
371     function balanceOf(address account) public view override returns (uint256) {
372         return _balances[account];
373     }
374 
375     /**
376      * @dev See {IERC20-transfer}.
377      *
378      * Requirements:
379      *
380      * - `recipient` cannot be the zero address.
381      * - the caller must have a balance of at least `amount`.
382      */
383     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
384         _transfer(_msgSender(), recipient, amount);
385         return true;
386     }
387 
388     /**
389      * @dev See {IERC20-allowance}.
390      */
391     function allowance(address owner, address spender) public view virtual override returns (uint256) {
392         return _allowances[owner][spender];
393     }
394 
395     /**
396      * @dev See {IERC20-approve}.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function approve(address spender, uint256 amount) public virtual override returns (bool) {
403         _approve(_msgSender(), spender, amount);
404         return true;
405     }
406 
407     /**
408      * @dev See {IERC20-transferFrom}.
409      *
410      * Emits an {Approval} event indicating the updated allowance. This is not
411      * required by the EIP. See the note at the beginning of {ERC20}.
412      *
413      * Requirements:
414      *
415      * - `sender` and `recipient` cannot be the zero address.
416      * - `sender` must have a balance of at least `amount`.
417      * - the caller must have allowance for ``sender``'s tokens of at least
418      * `amount`.
419      */
420     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
421         _transfer(sender, recipient, amount);
422         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
423         return true;
424     }
425 
426     /**
427      * @dev Atomically increases the allowance granted to `spender` by the caller.
428      *
429      * This is an alternative to {approve} that can be used as a mitigation for
430      * problems described in {IERC20-approve}.
431      *
432      * Emits an {Approval} event indicating the updated allowance.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      */
438     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
439         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
440         return true;
441     }
442 
443     /**
444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to {approve} that can be used as a mitigation for
447      * problems described in {IERC20-approve}.
448      *
449      * Emits an {Approval} event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      * - `spender` must have allowance for the caller of at least
455      * `subtractedValue`.
456      */
457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
458         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
459         return true;
460     }
461 
462     /**
463      * @dev Moves tokens `amount` from `sender` to `recipient`.
464      *
465      * This is internal function is equivalent to {transfer}, and can be used to
466      * e.g. implement automatic token fees, slashing mechanisms, etc.
467      *
468      * Emits a {Transfer} event.
469      *
470      * Requirements:
471      *
472      * - `sender` cannot be the zero address.
473      * - `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `amount`.
475      */
476     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
477         require(sender != address(0), "ERC20: transfer from the zero address");
478         require(recipient != address(0), "ERC20: transfer to the zero address");
479 
480         _beforeTokenTransfer(sender, recipient, amount);
481 
482         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
483         _balances[recipient] = _balances[recipient].add(amount);
484         emit Transfer(sender, recipient, amount);
485     }
486 
487     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
488      * the total supply.
489      *
490      * Emits a {Transfer} event with `from` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `to` cannot be the zero address.
495      */
496     function _mint(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: mint to the zero address");
498 
499         _beforeTokenTransfer(address(0), account, amount);
500 
501         _totalSupply = _totalSupply.add(amount);
502         _balances[account] = _balances[account].add(amount);
503         emit Transfer(address(0), account, amount);
504     }
505 
506     /**
507      * @dev Destroys `amount` tokens from `account`, reducing the
508      * total supply.
509      *
510      * Emits a {Transfer} event with `to` set to the zero address.
511      *
512      * Requirements:
513      *
514      * - `account` cannot be the zero address.
515      * - `account` must have at least `amount` tokens.
516      */
517     function _burn(address account, uint256 amount) internal virtual {
518         require(account != address(0), "ERC20: burn from the zero address");
519 
520         _beforeTokenTransfer(account, address(0), amount);
521 
522         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
523         _totalSupply = _totalSupply.sub(amount);
524         emit Transfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
529      *
530      * This internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(address owner, address spender, uint256 amount) internal virtual {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Sets {decimals} to a value other than the default one of 18.
550      *
551      * WARNING: This function should only be called from the constructor. Most
552      * applications that interact with token contracts will not expect
553      * {decimals} to ever change, and may work incorrectly if it does.
554      */
555     function _setupDecimals(uint8 decimals_) internal {
556         _decimals = decimals_;
557     }
558 
559     /**
560      * @dev Hook that is called before any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * will be to transferred to `to`.
567      * - when `from` is zero, `amount` tokens will be minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
577 
578 
579 
580 pragma solidity ^0.7.0;
581 
582 
583 
584 /**
585  * @dev Extension of {ERC20} that allows token holders to destroy both their own
586  * tokens and those that they have an allowance for, in a way that can be
587  * recognized off-chain (via event analysis).
588  */
589 abstract contract ERC20Burnable is Context, ERC20 {
590     using SafeMath for uint256;
591 
592     /**
593      * @dev Destroys `amount` tokens from the caller.
594      *
595      * See {ERC20-_burn}.
596      */
597     function burn(uint256 amount) public virtual {
598         _burn(_msgSender(), amount);
599     }
600 
601     /**
602      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
603      * allowance.
604      *
605      * See {ERC20-_burn} and {ERC20-allowance}.
606      *
607      * Requirements:
608      *
609      * - the caller must have allowance for ``accounts``'s tokens of at least
610      * `amount`.
611      */
612     function burnFrom(address account, uint256 amount) public virtual {
613         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
614 
615         _approve(account, _msgSender(), decreasedAllowance);
616         _burn(account, amount);
617     }
618 }
619 
620 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
621 
622 
623 
624 pragma solidity ^0.7.0;
625 
626 
627 /**
628  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
629  */
630 abstract contract ERC20Capped is ERC20 {
631     using SafeMath for uint256;
632 
633     uint256 private _cap;
634 
635     /**
636      * @dev Sets the value of the `cap`. This value is immutable, it can only be
637      * set once during construction.
638      */
639     constructor (uint256 cap_) {
640         require(cap_ > 0, "ERC20Capped: cap is 0");
641         _cap = cap_;
642     }
643 
644     /**
645      * @dev Returns the cap on the token's total supply.
646      */
647     function cap() public view returns (uint256) {
648         return _cap;
649     }
650 
651     /**
652      * @dev See {ERC20-_beforeTokenTransfer}.
653      *
654      * Requirements:
655      *
656      * - minted tokens must not cause the total supply to go over the cap.
657      */
658     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
659         super._beforeTokenTransfer(from, to, amount);
660 
661         if (from == address(0)) { // When minting tokens
662             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
663         }
664     }
665 }
666 
667 // File: @openzeppelin/contracts/introspection/IERC165.sol
668 
669 
670 
671 pragma solidity ^0.7.0;
672 
673 /**
674  * @dev Interface of the ERC165 standard, as defined in the
675  * https://eips.ethereum.org/EIPS/eip-165[EIP].
676  *
677  * Implementers can declare support of contract interfaces, which can then be
678  * queried by others ({ERC165Checker}).
679  *
680  * For an implementation, see {ERC165}.
681  */
682 interface IERC165 {
683     /**
684      * @dev Returns true if this contract implements the interface defined by
685      * `interfaceId`. See the corresponding
686      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
687      * to learn more about how these ids are created.
688      *
689      * This function call must use less than 30 000 gas.
690      */
691     function supportsInterface(bytes4 interfaceId) external view returns (bool);
692 }
693 
694 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
695 
696 
697 
698 pragma solidity ^0.7.0;
699 
700 
701 
702 /**
703  * @title IERC1363 Interface
704  * @dev Interface for a Payable Token contract as defined in
705  *  https://eips.ethereum.org/EIPS/eip-1363
706  */
707 interface IERC1363 is IERC20, IERC165 {
708     /*
709      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
710      * 0x4bbee2df ===
711      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
712      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
713      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
714      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
715      */
716 
717     /*
718      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
719      * 0xfb9ec8ce ===
720      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
721      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
722      */
723 
724     /**
725      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
726      * @param recipient address The address which you want to transfer to
727      * @param amount uint256 The amount of tokens to be transferred
728      * @return true unless throwing
729      */
730     function transferAndCall(address recipient, uint256 amount) external returns (bool);
731 
732     /**
733      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
734      * @param recipient address The address which you want to transfer to
735      * @param amount uint256 The amount of tokens to be transferred
736      * @param data bytes Additional data with no specified format, sent in call to `recipient`
737      * @return true unless throwing
738      */
739     function transferAndCall(address recipient, uint256 amount, bytes calldata data) external returns (bool);
740 
741     /**
742      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
743      * @param sender address The address which you want to send tokens from
744      * @param recipient address The address which you want to transfer to
745      * @param amount uint256 The amount of tokens to be transferred
746      * @return true unless throwing
747      */
748     function transferFromAndCall(address sender, address recipient, uint256 amount) external returns (bool);
749 
750     /**
751      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
752      * @param sender address The address which you want to send tokens from
753      * @param recipient address The address which you want to transfer to
754      * @param amount uint256 The amount of tokens to be transferred
755      * @param data bytes Additional data with no specified format, sent in call to `recipient`
756      * @return true unless throwing
757      */
758     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes calldata data) external returns (bool);
759 
760     /**
761      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
762      * and then call `onApprovalReceived` on spender.
763      * Beware that changing an allowance with this method brings the risk that someone may use both the old
764      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
765      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
766      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
767      * @param spender address The address which will spend the funds
768      * @param amount uint256 The amount of tokens to be spent
769      */
770     function approveAndCall(address spender, uint256 amount) external returns (bool);
771 
772     /**
773      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
774      * and then call `onApprovalReceived` on spender.
775      * Beware that changing an allowance with this method brings the risk that someone may use both the old
776      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
777      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
778      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
779      * @param spender address The address which will spend the funds
780      * @param amount uint256 The amount of tokens to be spent
781      * @param data bytes Additional data with no specified format, sent in call to `spender`
782      */
783     function approveAndCall(address spender, uint256 amount, bytes calldata data) external returns (bool);
784 }
785 
786 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
787 
788 
789 
790 pragma solidity ^0.7.0;
791 
792 /**
793  * @title IERC1363Receiver Interface
794  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
795  *  from ERC1363 token contracts as defined in
796  *  https://eips.ethereum.org/EIPS/eip-1363
797  */
798 interface IERC1363Receiver {
799     /*
800      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
801      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
802      */
803 
804     /**
805      * @notice Handle the receipt of ERC1363 tokens
806      * @dev Any ERC1363 smart contract calls this function on the recipient
807      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
808      * transfer. Return of other than the magic value MUST result in the
809      * transaction being reverted.
810      * Note: the token contract address is always the message sender.
811      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
812      * @param sender address The address which are token transferred from
813      * @param amount uint256 The amount of tokens transferred
814      * @param data bytes Additional data with no specified format
815      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
816      */
817     function onTransferReceived(address operator, address sender, uint256 amount, bytes calldata data) external returns (bytes4);
818 }
819 
820 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
821 
822 
823 
824 pragma solidity ^0.7.0;
825 
826 /**
827  * @title IERC1363Spender Interface
828  * @dev Interface for any contract that wants to support approveAndCall
829  *  from ERC1363 token contracts as defined in
830  *  https://eips.ethereum.org/EIPS/eip-1363
831  */
832 interface IERC1363Spender {
833     /*
834      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
835      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
836      */
837 
838     /**
839      * @notice Handle the approval of ERC1363 tokens
840      * @dev Any ERC1363 smart contract calls this function on the recipient
841      * after an `approve`. This function MAY throw to revert and reject the
842      * approval. Return of other than the magic value MUST result in the
843      * transaction being reverted.
844      * Note: the token contract address is always the message sender.
845      * @param sender address The address which called `approveAndCall` function
846      * @param amount uint256 The amount of tokens to be spent
847      * @param data bytes Additional data with no specified format
848      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
849      */
850     function onApprovalReceived(address sender, uint256 amount, bytes calldata data) external returns (bytes4);
851 }
852 
853 // File: @openzeppelin/contracts/utils/Address.sol
854 
855 
856 
857 pragma solidity ^0.7.0;
858 
859 /**
860  * @dev Collection of functions related to the address type
861  */
862 library Address {
863     /**
864      * @dev Returns true if `account` is a contract.
865      *
866      * [IMPORTANT]
867      * ====
868      * It is unsafe to assume that an address for which this function returns
869      * false is an externally-owned account (EOA) and not a contract.
870      *
871      * Among others, `isContract` will return false for the following
872      * types of addresses:
873      *
874      *  - an externally-owned account
875      *  - a contract in construction
876      *  - an address where a contract will be created
877      *  - an address where a contract lived, but was destroyed
878      * ====
879      */
880     function isContract(address account) internal view returns (bool) {
881         // This method relies on extcodesize, which returns 0 for contracts in
882         // construction, since the code is only stored at the end of the
883         // constructor execution.
884 
885         uint256 size;
886         // solhint-disable-next-line no-inline-assembly
887         assembly { size := extcodesize(account) }
888         return size > 0;
889     }
890 
891     /**
892      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
893      * `recipient`, forwarding all available gas and reverting on errors.
894      *
895      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
896      * of certain opcodes, possibly making contracts go over the 2300 gas limit
897      * imposed by `transfer`, making them unable to receive funds via
898      * `transfer`. {sendValue} removes this limitation.
899      *
900      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
901      *
902      * IMPORTANT: because control is transferred to `recipient`, care must be
903      * taken to not create reentrancy vulnerabilities. Consider using
904      * {ReentrancyGuard} or the
905      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
906      */
907     function sendValue(address payable recipient, uint256 amount) internal {
908         require(address(this).balance >= amount, "Address: insufficient balance");
909 
910         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
911         (bool success, ) = recipient.call{ value: amount }("");
912         require(success, "Address: unable to send value, recipient may have reverted");
913     }
914 
915     /**
916      * @dev Performs a Solidity function call using a low level `call`. A
917      * plain`call` is an unsafe replacement for a function call: use this
918      * function instead.
919      *
920      * If `target` reverts with a revert reason, it is bubbled up by this
921      * function (like regular Solidity function calls).
922      *
923      * Returns the raw returned data. To convert to the expected return value,
924      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
925      *
926      * Requirements:
927      *
928      * - `target` must be a contract.
929      * - calling `target` with `data` must not revert.
930      *
931      * _Available since v3.1._
932      */
933     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
934       return functionCall(target, data, "Address: low-level call failed");
935     }
936 
937     /**
938      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
939      * `errorMessage` as a fallback revert reason when `target` reverts.
940      *
941      * _Available since v3.1._
942      */
943     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
944         return functionCallWithValue(target, data, 0, errorMessage);
945     }
946 
947     /**
948      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
949      * but also transferring `value` wei to `target`.
950      *
951      * Requirements:
952      *
953      * - the calling contract must have an ETH balance of at least `value`.
954      * - the called Solidity function must be `payable`.
955      *
956      * _Available since v3.1._
957      */
958     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
959         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
960     }
961 
962     /**
963      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
964      * with `errorMessage` as a fallback revert reason when `target` reverts.
965      *
966      * _Available since v3.1._
967      */
968     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
969         require(address(this).balance >= value, "Address: insufficient balance for call");
970         require(isContract(target), "Address: call to non-contract");
971 
972         // solhint-disable-next-line avoid-low-level-calls
973         (bool success, bytes memory returndata) = target.call{ value: value }(data);
974         return _verifyCallResult(success, returndata, errorMessage);
975     }
976 
977     /**
978      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
979      * but performing a static call.
980      *
981      * _Available since v3.3._
982      */
983     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
984         return functionStaticCall(target, data, "Address: low-level static call failed");
985     }
986 
987     /**
988      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
989      * but performing a static call.
990      *
991      * _Available since v3.3._
992      */
993     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
994         require(isContract(target), "Address: static call to non-contract");
995 
996         // solhint-disable-next-line avoid-low-level-calls
997         (bool success, bytes memory returndata) = target.staticcall(data);
998         return _verifyCallResult(success, returndata, errorMessage);
999     }
1000 
1001     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1002         if (success) {
1003             return returndata;
1004         } else {
1005             // Look for revert reason and bubble it up if present
1006             if (returndata.length > 0) {
1007                 // The easiest way to bubble the revert reason is using memory via assembly
1008 
1009                 // solhint-disable-next-line no-inline-assembly
1010                 assembly {
1011                     let returndata_size := mload(returndata)
1012                     revert(add(32, returndata), returndata_size)
1013                 }
1014             } else {
1015                 revert(errorMessage);
1016             }
1017         }
1018     }
1019 }
1020 
1021 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
1022 
1023 
1024 
1025 pragma solidity ^0.7.0;
1026 
1027 /**
1028  * @dev Library used to query support of an interface declared via {IERC165}.
1029  *
1030  * Note that these functions return the actual result of the query: they do not
1031  * `revert` if an interface is not supported. It is up to the caller to decide
1032  * what to do in these cases.
1033  */
1034 library ERC165Checker {
1035     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1036     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1037 
1038     /*
1039      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1040      */
1041     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1042 
1043     /**
1044      * @dev Returns true if `account` supports the {IERC165} interface,
1045      */
1046     function supportsERC165(address account) internal view returns (bool) {
1047         // Any contract that implements ERC165 must explicitly indicate support of
1048         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1049         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1050             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1051     }
1052 
1053     /**
1054      * @dev Returns true if `account` supports the interface defined by
1055      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1056      *
1057      * See {IERC165-supportsInterface}.
1058      */
1059     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1060         // query support of both ERC165 as per the spec and support of _interfaceId
1061         return supportsERC165(account) &&
1062             _supportsERC165Interface(account, interfaceId);
1063     }
1064 
1065     /**
1066      * @dev Returns true if `account` supports all the interfaces defined in
1067      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1068      *
1069      * Batch-querying can lead to gas savings by skipping repeated checks for
1070      * {IERC165} support.
1071      *
1072      * See {IERC165-supportsInterface}.
1073      */
1074     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1075         // query support of ERC165 itself
1076         if (!supportsERC165(account)) {
1077             return false;
1078         }
1079 
1080         // query support of each interface in _interfaceIds
1081         for (uint256 i = 0; i < interfaceIds.length; i++) {
1082             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1083                 return false;
1084             }
1085         }
1086 
1087         // all interfaces supported
1088         return true;
1089     }
1090 
1091     /**
1092      * @notice Query if a contract implements an interface, does not check ERC165 support
1093      * @param account The address of the contract to query for support of an interface
1094      * @param interfaceId The interface identifier, as specified in ERC-165
1095      * @return true if the contract at account indicates support of the interface with
1096      * identifier interfaceId, false otherwise
1097      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1098      * the behavior of this method is undefined. This precondition can be checked
1099      * with {supportsERC165}.
1100      * Interface identification is specified in ERC-165.
1101      */
1102     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1103         // success determines whether the staticcall succeeded and result determines
1104         // whether the contract at account indicates support of _interfaceId
1105         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1106 
1107         return (success && result);
1108     }
1109 
1110     /**
1111      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1112      * @param account The address of the contract to query for support of an interface
1113      * @param interfaceId The interface identifier, as specified in ERC-165
1114      * @return success true if the STATICCALL succeeded, false otherwise
1115      * @return result true if the STATICCALL succeeded and the contract at account
1116      * indicates support of the interface with identifier interfaceId, false otherwise
1117      */
1118     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1119         private
1120         view
1121         returns (bool, bool)
1122     {
1123         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1124         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1125         if (result.length < 32) return (false, false);
1126         return (success, abi.decode(result, (bool)));
1127     }
1128 }
1129 
1130 // File: @openzeppelin/contracts/introspection/ERC165.sol
1131 
1132 
1133 
1134 pragma solidity ^0.7.0;
1135 
1136 
1137 /**
1138  * @dev Implementation of the {IERC165} interface.
1139  *
1140  * Contracts may inherit from this and call {_registerInterface} to declare
1141  * their support of an interface.
1142  */
1143 abstract contract ERC165 is IERC165 {
1144     /*
1145      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1146      */
1147     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1148 
1149     /**
1150      * @dev Mapping of interface ids to whether or not it's supported.
1151      */
1152     mapping(bytes4 => bool) private _supportedInterfaces;
1153 
1154     constructor () {
1155         // Derived contracts need only register support for their own interfaces,
1156         // we register support for ERC165 itself here
1157         _registerInterface(_INTERFACE_ID_ERC165);
1158     }
1159 
1160     /**
1161      * @dev See {IERC165-supportsInterface}.
1162      *
1163      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1164      */
1165     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1166         return _supportedInterfaces[interfaceId];
1167     }
1168 
1169     /**
1170      * @dev Registers the contract as an implementer of the interface defined by
1171      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1172      * registering its interface id is not required.
1173      *
1174      * See {IERC165-supportsInterface}.
1175      *
1176      * Requirements:
1177      *
1178      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1179      */
1180     function _registerInterface(bytes4 interfaceId) internal virtual {
1181         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1182         _supportedInterfaces[interfaceId] = true;
1183     }
1184 }
1185 
1186 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1187 
1188 
1189 
1190 pragma solidity ^0.7.0;
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 /**
1200  * @title ERC1363
1201  * @dev Implementation of an ERC1363 interface
1202  */
1203 contract ERC1363 is ERC20, IERC1363, ERC165 {
1204     using Address for address;
1205 
1206     /*
1207      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1208      * 0x4bbee2df ===
1209      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1210      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1211      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1212      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1213      */
1214     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1215 
1216     /*
1217      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1218      * 0xfb9ec8ce ===
1219      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1220      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1221      */
1222     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1223 
1224     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1225     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1226     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1227 
1228     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1229     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1230     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1231 
1232     /**
1233      * @param name Name of the token
1234      * @param symbol A symbol to be used as ticker
1235      */
1236     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
1237         // register the supported interfaces to conform to ERC1363 via ERC165
1238         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1239         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1240     }
1241 
1242     /**
1243      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1244      * @param recipient The address to transfer to.
1245      * @param amount The amount to be transferred.
1246      * @return A boolean that indicates if the operation was successful.
1247      */
1248     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
1249         return transferAndCall(recipient, amount, "");
1250     }
1251 
1252     /**
1253      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1254      * @param recipient The address to transfer to
1255      * @param amount The amount to be transferred
1256      * @param data Additional data with no specified format
1257      * @return A boolean that indicates if the operation was successful.
1258      */
1259     function transferAndCall(address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
1260         transfer(recipient, amount);
1261         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1262         return true;
1263     }
1264 
1265     /**
1266      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1267      * @param sender The address which you want to send tokens from
1268      * @param recipient The address which you want to transfer to
1269      * @param amount The amount of tokens to be transferred
1270      * @return A boolean that indicates if the operation was successful.
1271      */
1272     function transferFromAndCall(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1273         return transferFromAndCall(sender, recipient, amount, "");
1274     }
1275 
1276     /**
1277      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1278      * @param sender The address which you want to send tokens from
1279      * @param recipient The address which you want to transfer to
1280      * @param amount The amount of tokens to be transferred
1281      * @param data Additional data with no specified format
1282      * @return A boolean that indicates if the operation was successful.
1283      */
1284     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
1285         transferFrom(sender, recipient, amount);
1286         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1287         return true;
1288     }
1289 
1290     /**
1291      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1292      * @param spender The address allowed to transfer to
1293      * @param amount The amount allowed to be transferred
1294      * @return A boolean that indicates if the operation was successful.
1295      */
1296     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1297         return approveAndCall(spender, amount, "");
1298     }
1299 
1300     /**
1301      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1302      * @param spender The address allowed to transfer to.
1303      * @param amount The amount allowed to be transferred.
1304      * @param data Additional data with no specified format.
1305      * @return A boolean that indicates if the operation was successful.
1306      */
1307     function approveAndCall(address spender, uint256 amount, bytes memory data) public virtual override returns (bool) {
1308         approve(spender, amount);
1309         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1310         return true;
1311     }
1312 
1313     /**
1314      * @dev Internal function to invoke `onTransferReceived` on a target address
1315      *  The call is not executed if the target address is not a contract
1316      * @param sender address Representing the previous owner of the given token value
1317      * @param recipient address Target address that will receive the tokens
1318      * @param amount uint256 The amount mount of tokens to be transferred
1319      * @param data bytes Optional data to send along with the call
1320      * @return whether the call correctly returned the expected magic value
1321      */
1322     function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal virtual returns (bool) {
1323         if (!recipient.isContract()) {
1324             return false;
1325         }
1326         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(
1327             _msgSender(), sender, amount, data
1328         );
1329         return (retval == _ERC1363_RECEIVED);
1330     }
1331 
1332     /**
1333      * @dev Internal function to invoke `onApprovalReceived` on a target address
1334      *  The call is not executed if the target address is not a contract
1335      * @param spender address The address which will spend the funds
1336      * @param amount uint256 The amount of tokens to be spent
1337      * @param data bytes Optional data to send along with the call
1338      * @return whether the call correctly returned the expected magic value
1339      */
1340     function _checkAndCallApprove(address spender, uint256 amount, bytes memory data) internal virtual returns (bool) {
1341         if (!spender.isContract()) {
1342             return false;
1343         }
1344         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1345             _msgSender(), amount, data
1346         );
1347         return (retval == _ERC1363_APPROVED);
1348     }
1349 }
1350 
1351 // File: @openzeppelin/contracts/access/Ownable.sol
1352 
1353 
1354 
1355 pragma solidity ^0.7.0;
1356 
1357 /**
1358  * @dev Contract module which provides a basic access control mechanism, where
1359  * there is an account (an owner) that can be granted exclusive access to
1360  * specific functions.
1361  *
1362  * By default, the owner account will be the one that deploys the contract. This
1363  * can later be changed with {transferOwnership}.
1364  *
1365  * This module is used through inheritance. It will make available the modifier
1366  * `onlyOwner`, which can be applied to your functions to restrict their use to
1367  * the owner.
1368  */
1369 abstract contract Ownable is Context {
1370     address private _owner;
1371 
1372     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1373 
1374     /**
1375      * @dev Initializes the contract setting the deployer as the initial owner.
1376      */
1377     constructor () {
1378         address msgSender = _msgSender();
1379         _owner = msgSender;
1380         emit OwnershipTransferred(address(0), msgSender);
1381     }
1382 
1383     /**
1384      * @dev Returns the address of the current owner.
1385      */
1386     function owner() public view returns (address) {
1387         return _owner;
1388     }
1389 
1390     /**
1391      * @dev Throws if called by any account other than the owner.
1392      */
1393     modifier onlyOwner() {
1394         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1395         _;
1396     }
1397 
1398     /**
1399      * @dev Leaves the contract without owner. It will not be possible to call
1400      * `onlyOwner` functions anymore. Can only be called by the current owner.
1401      *
1402      * NOTE: Renouncing ownership will leave the contract without an owner,
1403      * thereby removing any functionality that is only available to the owner.
1404      */
1405     function renounceOwnership() public virtual onlyOwner {
1406         emit OwnershipTransferred(_owner, address(0));
1407         _owner = address(0);
1408     }
1409 
1410     /**
1411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1412      * Can only be called by the current owner.
1413      */
1414     function transferOwnership(address newOwner) public virtual onlyOwner {
1415         require(newOwner != address(0), "Ownable: new owner is the zero address");
1416         emit OwnershipTransferred(_owner, newOwner);
1417         _owner = newOwner;
1418     }
1419 }
1420 
1421 // File: eth-token-recover/contracts/TokenRecover.sol
1422 
1423 
1424 
1425 pragma solidity ^0.7.0;
1426 
1427 
1428 
1429 /**
1430  * @title TokenRecover
1431  * @dev Allow to recover any ERC20 sent into the contract for error
1432  */
1433 contract TokenRecover is Ownable {
1434 
1435     /**
1436      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1437      * @param tokenAddress The token contract address
1438      * @param tokenAmount Number of tokens to be sent
1439      */
1440     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1441         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1442     }
1443 }
1444 
1445 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1446 
1447 
1448 
1449 pragma solidity ^0.7.0;
1450 
1451 
1452 /**
1453  * @title ERC20Mintable
1454  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1455  */
1456 abstract contract ERC20Mintable is ERC20 {
1457 
1458     // indicates if minting is finished
1459     bool private _mintingFinished = false;
1460 
1461     /**
1462      * @dev Emitted during finish minting
1463      */
1464     event MintFinished();
1465 
1466     /**
1467      * @dev Tokens can be minted only before minting finished.
1468      */
1469     modifier canMint() {
1470         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1471         _;
1472     }
1473 
1474     /**
1475      * @return if minting is finished or not.
1476      */
1477     function mintingFinished() public view returns (bool) {
1478         return _mintingFinished;
1479     }
1480 
1481     /**
1482      * @dev Function to mint tokens.
1483      *
1484      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1485      *
1486      * @param account The address that will receive the minted tokens
1487      * @param amount The amount of tokens to mint
1488      */
1489     function mint(address account, uint256 amount) public canMint {
1490         _mint(account, amount);
1491     }
1492 
1493     /**
1494      * @dev Function to stop minting new tokens.
1495      *
1496      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1497      */
1498     function finishMinting() public canMint {
1499         _finishMinting();
1500     }
1501 
1502     /**
1503      * @dev Function to stop minting new tokens.
1504      */
1505     function _finishMinting() internal virtual {
1506         _mintingFinished = true;
1507 
1508         emit MintFinished();
1509     }
1510 }
1511 
1512 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1513 
1514 
1515 
1516 pragma solidity ^0.7.0;
1517 
1518 /**
1519  * @dev Library for managing
1520  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1521  * types.
1522  *
1523  * Sets have the following properties:
1524  *
1525  * - Elements are added, removed, and checked for existence in constant time
1526  * (O(1)).
1527  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1528  *
1529  * ```
1530  * contract Example {
1531  *     // Add the library methods
1532  *     using EnumerableSet for EnumerableSet.AddressSet;
1533  *
1534  *     // Declare a set state variable
1535  *     EnumerableSet.AddressSet private mySet;
1536  * }
1537  * ```
1538  *
1539  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1540  * and `uint256` (`UintSet`) are supported.
1541  */
1542 library EnumerableSet {
1543     // To implement this library for multiple types with as little code
1544     // repetition as possible, we write it in terms of a generic Set type with
1545     // bytes32 values.
1546     // The Set implementation uses private functions, and user-facing
1547     // implementations (such as AddressSet) are just wrappers around the
1548     // underlying Set.
1549     // This means that we can only create new EnumerableSets for types that fit
1550     // in bytes32.
1551 
1552     struct Set {
1553         // Storage of set values
1554         bytes32[] _values;
1555 
1556         // Position of the value in the `values` array, plus 1 because index 0
1557         // means a value is not in the set.
1558         mapping (bytes32 => uint256) _indexes;
1559     }
1560 
1561     /**
1562      * @dev Add a value to a set. O(1).
1563      *
1564      * Returns true if the value was added to the set, that is if it was not
1565      * already present.
1566      */
1567     function _add(Set storage set, bytes32 value) private returns (bool) {
1568         if (!_contains(set, value)) {
1569             set._values.push(value);
1570             // The value is stored at length-1, but we add 1 to all indexes
1571             // and use 0 as a sentinel value
1572             set._indexes[value] = set._values.length;
1573             return true;
1574         } else {
1575             return false;
1576         }
1577     }
1578 
1579     /**
1580      * @dev Removes a value from a set. O(1).
1581      *
1582      * Returns true if the value was removed from the set, that is if it was
1583      * present.
1584      */
1585     function _remove(Set storage set, bytes32 value) private returns (bool) {
1586         // We read and store the value's index to prevent multiple reads from the same storage slot
1587         uint256 valueIndex = set._indexes[value];
1588 
1589         if (valueIndex != 0) { // Equivalent to contains(set, value)
1590             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1591             // the array, and then remove the last element (sometimes called as 'swap and pop').
1592             // This modifies the order of the array, as noted in {at}.
1593 
1594             uint256 toDeleteIndex = valueIndex - 1;
1595             uint256 lastIndex = set._values.length - 1;
1596 
1597             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1598             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1599 
1600             bytes32 lastvalue = set._values[lastIndex];
1601 
1602             // Move the last value to the index where the value to delete is
1603             set._values[toDeleteIndex] = lastvalue;
1604             // Update the index for the moved value
1605             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1606 
1607             // Delete the slot where the moved value was stored
1608             set._values.pop();
1609 
1610             // Delete the index for the deleted slot
1611             delete set._indexes[value];
1612 
1613             return true;
1614         } else {
1615             return false;
1616         }
1617     }
1618 
1619     /**
1620      * @dev Returns true if the value is in the set. O(1).
1621      */
1622     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1623         return set._indexes[value] != 0;
1624     }
1625 
1626     /**
1627      * @dev Returns the number of values on the set. O(1).
1628      */
1629     function _length(Set storage set) private view returns (uint256) {
1630         return set._values.length;
1631     }
1632 
1633    /**
1634     * @dev Returns the value stored at position `index` in the set. O(1).
1635     *
1636     * Note that there are no guarantees on the ordering of values inside the
1637     * array, and it may change when more values are added or removed.
1638     *
1639     * Requirements:
1640     *
1641     * - `index` must be strictly less than {length}.
1642     */
1643     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1644         require(set._values.length > index, "EnumerableSet: index out of bounds");
1645         return set._values[index];
1646     }
1647 
1648     // Bytes32Set
1649 
1650     struct Bytes32Set {
1651         Set _inner;
1652     }
1653 
1654     /**
1655      * @dev Add a value to a set. O(1).
1656      *
1657      * Returns true if the value was added to the set, that is if it was not
1658      * already present.
1659      */
1660     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1661         return _add(set._inner, value);
1662     }
1663 
1664     /**
1665      * @dev Removes a value from a set. O(1).
1666      *
1667      * Returns true if the value was removed from the set, that is if it was
1668      * present.
1669      */
1670     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1671         return _remove(set._inner, value);
1672     }
1673 
1674     /**
1675      * @dev Returns true if the value is in the set. O(1).
1676      */
1677     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1678         return _contains(set._inner, value);
1679     }
1680 
1681     /**
1682      * @dev Returns the number of values in the set. O(1).
1683      */
1684     function length(Bytes32Set storage set) internal view returns (uint256) {
1685         return _length(set._inner);
1686     }
1687 
1688    /**
1689     * @dev Returns the value stored at position `index` in the set. O(1).
1690     *
1691     * Note that there are no guarantees on the ordering of values inside the
1692     * array, and it may change when more values are added or removed.
1693     *
1694     * Requirements:
1695     *
1696     * - `index` must be strictly less than {length}.
1697     */
1698     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1699         return _at(set._inner, index);
1700     }
1701 
1702     // AddressSet
1703 
1704     struct AddressSet {
1705         Set _inner;
1706     }
1707 
1708     /**
1709      * @dev Add a value to a set. O(1).
1710      *
1711      * Returns true if the value was added to the set, that is if it was not
1712      * already present.
1713      */
1714     function add(AddressSet storage set, address value) internal returns (bool) {
1715         return _add(set._inner, bytes32(uint256(value)));
1716     }
1717 
1718     /**
1719      * @dev Removes a value from a set. O(1).
1720      *
1721      * Returns true if the value was removed from the set, that is if it was
1722      * present.
1723      */
1724     function remove(AddressSet storage set, address value) internal returns (bool) {
1725         return _remove(set._inner, bytes32(uint256(value)));
1726     }
1727 
1728     /**
1729      * @dev Returns true if the value is in the set. O(1).
1730      */
1731     function contains(AddressSet storage set, address value) internal view returns (bool) {
1732         return _contains(set._inner, bytes32(uint256(value)));
1733     }
1734 
1735     /**
1736      * @dev Returns the number of values in the set. O(1).
1737      */
1738     function length(AddressSet storage set) internal view returns (uint256) {
1739         return _length(set._inner);
1740     }
1741 
1742    /**
1743     * @dev Returns the value stored at position `index` in the set. O(1).
1744     *
1745     * Note that there are no guarantees on the ordering of values inside the
1746     * array, and it may change when more values are added or removed.
1747     *
1748     * Requirements:
1749     *
1750     * - `index` must be strictly less than {length}.
1751     */
1752     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1753         return address(uint256(_at(set._inner, index)));
1754     }
1755 
1756 
1757     // UintSet
1758 
1759     struct UintSet {
1760         Set _inner;
1761     }
1762 
1763     /**
1764      * @dev Add a value to a set. O(1).
1765      *
1766      * Returns true if the value was added to the set, that is if it was not
1767      * already present.
1768      */
1769     function add(UintSet storage set, uint256 value) internal returns (bool) {
1770         return _add(set._inner, bytes32(value));
1771     }
1772 
1773     /**
1774      * @dev Removes a value from a set. O(1).
1775      *
1776      * Returns true if the value was removed from the set, that is if it was
1777      * present.
1778      */
1779     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1780         return _remove(set._inner, bytes32(value));
1781     }
1782 
1783     /**
1784      * @dev Returns true if the value is in the set. O(1).
1785      */
1786     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1787         return _contains(set._inner, bytes32(value));
1788     }
1789 
1790     /**
1791      * @dev Returns the number of values on the set. O(1).
1792      */
1793     function length(UintSet storage set) internal view returns (uint256) {
1794         return _length(set._inner);
1795     }
1796 
1797    /**
1798     * @dev Returns the value stored at position `index` in the set. O(1).
1799     *
1800     * Note that there are no guarantees on the ordering of values inside the
1801     * array, and it may change when more values are added or removed.
1802     *
1803     * Requirements:
1804     *
1805     * - `index` must be strictly less than {length}.
1806     */
1807     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1808         return uint256(_at(set._inner, index));
1809     }
1810 }
1811 
1812 // File: @openzeppelin/contracts/access/AccessControl.sol
1813 
1814 
1815 
1816 pragma solidity ^0.7.0;
1817 
1818 
1819 
1820 
1821 /**
1822  * @dev Contract module that allows children to implement role-based access
1823  * control mechanisms.
1824  *
1825  * Roles are referred to by their `bytes32` identifier. These should be exposed
1826  * in the external API and be unique. The best way to achieve this is by
1827  * using `public constant` hash digests:
1828  *
1829  * ```
1830  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1831  * ```
1832  *
1833  * Roles can be used to represent a set of permissions. To restrict access to a
1834  * function call, use {hasRole}:
1835  *
1836  * ```
1837  * function foo() public {
1838  *     require(hasRole(MY_ROLE, msg.sender));
1839  *     ...
1840  * }
1841  * ```
1842  *
1843  * Roles can be granted and revoked dynamically via the {grantRole} and
1844  * {revokeRole} functions. Each role has an associated admin role, and only
1845  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1846  *
1847  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1848  * that only accounts with this role will be able to grant or revoke other
1849  * roles. More complex role relationships can be created by using
1850  * {_setRoleAdmin}.
1851  *
1852  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1853  * grant and revoke this role. Extra precautions should be taken to secure
1854  * accounts that have been granted it.
1855  */
1856 abstract contract AccessControl is Context {
1857     using EnumerableSet for EnumerableSet.AddressSet;
1858     using Address for address;
1859 
1860     struct RoleData {
1861         EnumerableSet.AddressSet members;
1862         bytes32 adminRole;
1863     }
1864 
1865     mapping (bytes32 => RoleData) private _roles;
1866 
1867     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1868 
1869     /**
1870      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1871      *
1872      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1873      * {RoleAdminChanged} not being emitted signaling this.
1874      *
1875      * _Available since v3.1._
1876      */
1877     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1878 
1879     /**
1880      * @dev Emitted when `account` is granted `role`.
1881      *
1882      * `sender` is the account that originated the contract call, an admin role
1883      * bearer except when using {_setupRole}.
1884      */
1885     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1886 
1887     /**
1888      * @dev Emitted when `account` is revoked `role`.
1889      *
1890      * `sender` is the account that originated the contract call:
1891      *   - if using `revokeRole`, it is the admin role bearer
1892      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1893      */
1894     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1895 
1896     /**
1897      * @dev Returns `true` if `account` has been granted `role`.
1898      */
1899     function hasRole(bytes32 role, address account) public view returns (bool) {
1900         return _roles[role].members.contains(account);
1901     }
1902 
1903     /**
1904      * @dev Returns the number of accounts that have `role`. Can be used
1905      * together with {getRoleMember} to enumerate all bearers of a role.
1906      */
1907     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1908         return _roles[role].members.length();
1909     }
1910 
1911     /**
1912      * @dev Returns one of the accounts that have `role`. `index` must be a
1913      * value between 0 and {getRoleMemberCount}, non-inclusive.
1914      *
1915      * Role bearers are not sorted in any particular way, and their ordering may
1916      * change at any point.
1917      *
1918      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1919      * you perform all queries on the same block. See the following
1920      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1921      * for more information.
1922      */
1923     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1924         return _roles[role].members.at(index);
1925     }
1926 
1927     /**
1928      * @dev Returns the admin role that controls `role`. See {grantRole} and
1929      * {revokeRole}.
1930      *
1931      * To change a role's admin, use {_setRoleAdmin}.
1932      */
1933     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1934         return _roles[role].adminRole;
1935     }
1936 
1937     /**
1938      * @dev Grants `role` to `account`.
1939      *
1940      * If `account` had not been already granted `role`, emits a {RoleGranted}
1941      * event.
1942      *
1943      * Requirements:
1944      *
1945      * - the caller must have ``role``'s admin role.
1946      */
1947     function grantRole(bytes32 role, address account) public virtual {
1948         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1949 
1950         _grantRole(role, account);
1951     }
1952 
1953     /**
1954      * @dev Revokes `role` from `account`.
1955      *
1956      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1957      *
1958      * Requirements:
1959      *
1960      * - the caller must have ``role``'s admin role.
1961      */
1962     function revokeRole(bytes32 role, address account) public virtual {
1963         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1964 
1965         _revokeRole(role, account);
1966     }
1967 
1968     /**
1969      * @dev Revokes `role` from the calling account.
1970      *
1971      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1972      * purpose is to provide a mechanism for accounts to lose their privileges
1973      * if they are compromised (such as when a trusted device is misplaced).
1974      *
1975      * If the calling account had been granted `role`, emits a {RoleRevoked}
1976      * event.
1977      *
1978      * Requirements:
1979      *
1980      * - the caller must be `account`.
1981      */
1982     function renounceRole(bytes32 role, address account) public virtual {
1983         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1984 
1985         _revokeRole(role, account);
1986     }
1987 
1988     /**
1989      * @dev Grants `role` to `account`.
1990      *
1991      * If `account` had not been already granted `role`, emits a {RoleGranted}
1992      * event. Note that unlike {grantRole}, this function doesn't perform any
1993      * checks on the calling account.
1994      *
1995      * [WARNING]
1996      * ====
1997      * This function should only be called from the constructor when setting
1998      * up the initial roles for the system.
1999      *
2000      * Using this function in any other way is effectively circumventing the admin
2001      * system imposed by {AccessControl}.
2002      * ====
2003      */
2004     function _setupRole(bytes32 role, address account) internal virtual {
2005         _grantRole(role, account);
2006     }
2007 
2008     /**
2009      * @dev Sets `adminRole` as ``role``'s admin role.
2010      *
2011      * Emits a {RoleAdminChanged} event.
2012      */
2013     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2014         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
2015         _roles[role].adminRole = adminRole;
2016     }
2017 
2018     function _grantRole(bytes32 role, address account) private {
2019         if (_roles[role].members.add(account)) {
2020             emit RoleGranted(role, account, _msgSender());
2021         }
2022     }
2023 
2024     function _revokeRole(bytes32 role, address account) private {
2025         if (_roles[role].members.remove(account)) {
2026             emit RoleRevoked(role, account, _msgSender());
2027         }
2028     }
2029 }
2030 
2031 // File: contracts/access/Roles.sol
2032 
2033 
2034 
2035 pragma solidity ^0.7.0;
2036 
2037 
2038 contract Roles is AccessControl {
2039 
2040     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
2041 
2042     constructor () {
2043         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2044         _setupRole(MINTER_ROLE, _msgSender());
2045     }
2046 
2047     modifier onlyMinter() {
2048         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
2049         _;
2050     }
2051 }
2052 
2053 // File: contracts/service/ServiceReceiver.sol
2054 
2055 
2056 
2057 pragma solidity ^0.7.0;
2058 
2059 
2060 /**
2061  * @title ServiceReceiver
2062  * @dev Implementation of the ServiceReceiver
2063  */
2064 contract ServiceReceiver is TokenRecover {
2065 
2066     mapping (bytes32 => uint256) private _prices;
2067 
2068     event Created(string serviceName, address indexed serviceAddress);
2069 
2070     function pay(string memory serviceName) public payable {
2071         require(msg.value == _prices[_toBytes32(serviceName)], "ServiceReceiver: incorrect price");
2072 
2073         emit Created(serviceName, _msgSender());
2074     }
2075 
2076     function getPrice(string memory serviceName) public view returns (uint256) {
2077         return _prices[_toBytes32(serviceName)];
2078     }
2079 
2080     function setPrice(string memory serviceName, uint256 amount) public onlyOwner {
2081         _prices[_toBytes32(serviceName)] = amount;
2082     }
2083 
2084     function withdraw(uint256 amount) public onlyOwner {
2085         payable(owner()).transfer(amount);
2086     }
2087 
2088     function _toBytes32(string memory serviceName) private pure returns (bytes32) {
2089         return keccak256(abi.encode(serviceName));
2090     }
2091 }
2092 
2093 // File: contracts/service/ServicePayer.sol
2094 
2095 
2096 
2097 pragma solidity ^0.7.0;
2098 
2099 
2100 /**
2101  * @title ServicePayer
2102  * @dev Implementation of the ServicePayer
2103  */
2104 abstract contract ServicePayer {
2105 
2106     constructor (address payable receiver, string memory serviceName) payable {
2107         ServiceReceiver(receiver).pay{value: msg.value}(serviceName);
2108     }
2109 }
2110 
2111 // File: contracts/token/ERC20/PowerfulERC20.sol
2112 
2113 
2114 
2115 pragma solidity ^0.7.0;
2116 
2117 
2118 
2119 
2120 
2121 
2122 
2123 
2124 /**
2125  * @title PowerfulERC20
2126  * @dev Implementation of the PowerfulERC20
2127  */
2128 contract PowerfulERC20 is ERC20Capped, ERC20Mintable, ERC20Burnable, ERC1363, TokenRecover, Roles, ServicePayer {
2129 
2130     constructor (
2131         string memory name,
2132         string memory symbol,
2133         uint8 decimals,
2134         uint256 cap,
2135         uint256 initialBalance,
2136         address payable feeReceiver
2137     )
2138         ERC1363(name, symbol)
2139         ERC20Capped(cap)
2140         ServicePayer(feeReceiver, "PowerfulERC20")
2141         payable
2142     {
2143         _setupDecimals(decimals);
2144         _mint(_msgSender(), initialBalance);
2145     }
2146 
2147     /**
2148      * @dev Function to mint tokens.
2149      *
2150      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
2151      *
2152      * @param account The address that will receive the minted tokens
2153      * @param amount The amount of tokens to mint
2154      */
2155     function _mint(address account, uint256 amount) internal override onlyMinter {
2156         super._mint(account, amount);
2157     }
2158 
2159     /**
2160      * @dev Function to stop minting new tokens.
2161      *
2162      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
2163      */
2164     function _finishMinting() internal override onlyOwner {
2165         super._finishMinting();
2166     }
2167 
2168     /**
2169      * @dev See {ERC20-_beforeTokenTransfer}. See {ERC20Capped-_beforeTokenTransfer}.
2170      */
2171     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Capped) {
2172         super._beforeTokenTransfer(from, to, amount);
2173     }
2174 }