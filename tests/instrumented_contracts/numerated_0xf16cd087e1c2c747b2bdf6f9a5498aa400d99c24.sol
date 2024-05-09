1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 
6 
7 pragma solidity ^0.7.0;
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
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 
33 
34 pragma solidity ^0.7.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 
113 
114 pragma solidity ^0.7.0;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
273 
274 
275 
276 pragma solidity ^0.7.0;
277 
278 
279 
280 
281 /**
282  * @dev Implementation of the {IERC20} interface.
283  *
284  * This implementation is agnostic to the way tokens are created. This means
285  * that a supply mechanism has to be added in a derived contract using {_mint}.
286  * For a generic mechanism see {ERC20PresetMinterPauser}.
287  *
288  * TIP: For a detailed writeup see our guide
289  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
290  * to implement supply mechanisms].
291  *
292  * We have followed general OpenZeppelin guidelines: functions revert instead
293  * of returning `false` on failure. This behavior is nonetheless conventional
294  * and does not conflict with the expectations of ERC20 applications.
295  *
296  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
297  * This allows applications to reconstruct the allowance for all accounts just
298  * by listening to said events. Other implementations of the EIP may not emit
299  * these events, as it isn't required by the specification.
300  *
301  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
302  * functions have been added to mitigate the well-known issues around setting
303  * allowances. See {IERC20-approve}.
304  */
305 contract ERC20 is Context, IERC20 {
306     using SafeMath for uint256;
307 
308     mapping (address => uint256) private _balances;
309 
310     mapping (address => mapping (address => uint256)) private _allowances;
311 
312     uint256 private _totalSupply;
313 
314     string private _name;
315     string private _symbol;
316     uint8 private _decimals;
317 
318     /**
319      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
320      * a default value of 18.
321      *
322      * To select a different value for {decimals}, use {_setupDecimals}.
323      *
324      * All three of these values are immutable: they can only be set once during
325      * construction.
326      */
327     constructor (string memory name_, string memory symbol_) {
328         _name = name_;
329         _symbol = symbol_;
330         _decimals = 18;
331     }
332 
333     /**
334      * @dev Returns the name of the token.
335      */
336     function name() public view returns (string memory) {
337         return _name;
338     }
339 
340     /**
341      * @dev Returns the symbol of the token, usually a shorter version of the
342      * name.
343      */
344     function symbol() public view returns (string memory) {
345         return _symbol;
346     }
347 
348     /**
349      * @dev Returns the number of decimals used to get its user representation.
350      * For example, if `decimals` equals `2`, a balance of `505` tokens should
351      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
352      *
353      * Tokens usually opt for a value of 18, imitating the relationship between
354      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
355      * called.
356      *
357      * NOTE: This information is only used for _display_ purposes: it in
358      * no way affects any of the arithmetic of the contract, including
359      * {IERC20-balanceOf} and {IERC20-transfer}.
360      */
361     function decimals() public view returns (uint8) {
362         return _decimals;
363     }
364 
365     /**
366      * @dev See {IERC20-totalSupply}.
367      */
368     function totalSupply() public view override returns (uint256) {
369         return _totalSupply;
370     }
371 
372     /**
373      * @dev See {IERC20-balanceOf}.
374      */
375     function balanceOf(address account) public view override returns (uint256) {
376         return _balances[account];
377     }
378 
379     /**
380      * @dev See {IERC20-transfer}.
381      *
382      * Requirements:
383      *
384      * - `recipient` cannot be the zero address.
385      * - the caller must have a balance of at least `amount`.
386      */
387     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
388         _transfer(_msgSender(), recipient, amount);
389         return true;
390     }
391 
392     /**
393      * @dev See {IERC20-allowance}.
394      */
395     function allowance(address owner, address spender) public view virtual override returns (uint256) {
396         return _allowances[owner][spender];
397     }
398 
399     /**
400      * @dev See {IERC20-approve}.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function approve(address spender, uint256 amount) public virtual override returns (bool) {
407         _approve(_msgSender(), spender, amount);
408         return true;
409     }
410 
411     /**
412      * @dev See {IERC20-transferFrom}.
413      *
414      * Emits an {Approval} event indicating the updated allowance. This is not
415      * required by the EIP. See the note at the beginning of {ERC20}.
416      *
417      * Requirements:
418      *
419      * - `sender` and `recipient` cannot be the zero address.
420      * - `sender` must have a balance of at least `amount`.
421      * - the caller must have allowance for ``sender``'s tokens of at least
422      * `amount`.
423      */
424     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
425         _transfer(sender, recipient, amount);
426         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
427         return true;
428     }
429 
430     /**
431      * @dev Atomically increases the allowance granted to `spender` by the caller.
432      *
433      * This is an alternative to {approve} that can be used as a mitigation for
434      * problems described in {IERC20-approve}.
435      *
436      * Emits an {Approval} event indicating the updated allowance.
437      *
438      * Requirements:
439      *
440      * - `spender` cannot be the zero address.
441      */
442     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
443         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
444         return true;
445     }
446 
447     /**
448      * @dev Atomically decreases the allowance granted to `spender` by the caller.
449      *
450      * This is an alternative to {approve} that can be used as a mitigation for
451      * problems described in {IERC20-approve}.
452      *
453      * Emits an {Approval} event indicating the updated allowance.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      * - `spender` must have allowance for the caller of at least
459      * `subtractedValue`.
460      */
461     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
462         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
463         return true;
464     }
465 
466     /**
467      * @dev Moves tokens `amount` from `sender` to `recipient`.
468      *
469      * This is internal function is equivalent to {transfer}, and can be used to
470      * e.g. implement automatic token fees, slashing mechanisms, etc.
471      *
472      * Emits a {Transfer} event.
473      *
474      * Requirements:
475      *
476      * - `sender` cannot be the zero address.
477      * - `recipient` cannot be the zero address.
478      * - `sender` must have a balance of at least `amount`.
479      */
480     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
481         require(sender != address(0), "ERC20: transfer from the zero address");
482         require(recipient != address(0), "ERC20: transfer to the zero address");
483 
484         _beforeTokenTransfer(sender, recipient, amount);
485 
486         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
487         _balances[recipient] = _balances[recipient].add(amount);
488         emit Transfer(sender, recipient, amount);
489     }
490 
491     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
492      * the total supply.
493      *
494      * Emits a {Transfer} event with `from` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `to` cannot be the zero address.
499      */
500     function _mint(address account, uint256 amount) internal virtual {
501         require(account != address(0), "ERC20: mint to the zero address");
502 
503         _beforeTokenTransfer(address(0), account, amount);
504 
505         _totalSupply = _totalSupply.add(amount);
506         _balances[account] = _balances[account].add(amount);
507         emit Transfer(address(0), account, amount);
508     }
509 
510     /**
511      * @dev Destroys `amount` tokens from `account`, reducing the
512      * total supply.
513      *
514      * Emits a {Transfer} event with `to` set to the zero address.
515      *
516      * Requirements:
517      *
518      * - `account` cannot be the zero address.
519      * - `account` must have at least `amount` tokens.
520      */
521     function _burn(address account, uint256 amount) internal virtual {
522         require(account != address(0), "ERC20: burn from the zero address");
523 
524         _beforeTokenTransfer(account, address(0), amount);
525 
526         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
527         _totalSupply = _totalSupply.sub(amount);
528         emit Transfer(account, address(0), amount);
529     }
530 
531     /**
532      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
533      *
534      * This internal function is equivalent to `approve`, and can be used to
535      * e.g. set automatic allowances for certain subsystems, etc.
536      *
537      * Emits an {Approval} event.
538      *
539      * Requirements:
540      *
541      * - `owner` cannot be the zero address.
542      * - `spender` cannot be the zero address.
543      */
544     function _approve(address owner, address spender, uint256 amount) internal virtual {
545         require(owner != address(0), "ERC20: approve from the zero address");
546         require(spender != address(0), "ERC20: approve to the zero address");
547 
548         _allowances[owner][spender] = amount;
549         emit Approval(owner, spender, amount);
550     }
551 
552     /**
553      * @dev Sets {decimals} to a value other than the default one of 18.
554      *
555      * WARNING: This function should only be called from the constructor. Most
556      * applications that interact with token contracts will not expect
557      * {decimals} to ever change, and may work incorrectly if it does.
558      */
559     function _setupDecimals(uint8 decimals_) internal {
560         _decimals = decimals_;
561     }
562 
563     /**
564      * @dev Hook that is called before any transfer of tokens. This includes
565      * minting and burning.
566      *
567      * Calling conditions:
568      *
569      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
570      * will be to transferred to `to`.
571      * - when `from` is zero, `amount` tokens will be minted for `to`.
572      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
573      * - `from` and `to` are never both zero.
574      *
575      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
576      */
577     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
581 
582 
583 
584 pragma solidity ^0.7.0;
585 
586 
587 
588 /**
589  * @dev Extension of {ERC20} that allows token holders to destroy both their own
590  * tokens and those that they have an allowance for, in a way that can be
591  * recognized off-chain (via event analysis).
592  */
593 abstract contract ERC20Burnable is Context, ERC20 {
594     using SafeMath for uint256;
595 
596     /**
597      * @dev Destroys `amount` tokens from the caller.
598      *
599      * See {ERC20-_burn}.
600      */
601     function burn(uint256 amount) public virtual {
602         _burn(_msgSender(), amount);
603     }
604 
605     /**
606      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
607      * allowance.
608      *
609      * See {ERC20-_burn} and {ERC20-allowance}.
610      *
611      * Requirements:
612      *
613      * - the caller must have allowance for ``accounts``'s tokens of at least
614      * `amount`.
615      */
616     function burnFrom(address account, uint256 amount) public virtual {
617         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
618 
619         _approve(account, _msgSender(), decreasedAllowance);
620         _burn(account, amount);
621     }
622 }
623 
624 // File: @openzeppelin/contracts/introspection/IERC165.sol
625 
626 
627 
628 pragma solidity ^0.7.0;
629 
630 /**
631  * @dev Interface of the ERC165 standard, as defined in the
632  * https://eips.ethereum.org/EIPS/eip-165[EIP].
633  *
634  * Implementers can declare support of contract interfaces, which can then be
635  * queried by others ({ERC165Checker}).
636  *
637  * For an implementation, see {ERC165}.
638  */
639 interface IERC165 {
640     /**
641      * @dev Returns true if this contract implements the interface defined by
642      * `interfaceId`. See the corresponding
643      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
644      * to learn more about how these ids are created.
645      *
646      * This function call must use less than 30 000 gas.
647      */
648     function supportsInterface(bytes4 interfaceId) external view returns (bool);
649 }
650 
651 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
652 
653 
654 
655 pragma solidity ^0.7.0;
656 
657 
658 
659 /**
660  * @title IERC1363 Interface
661  * @dev Interface for a Payable Token contract as defined in
662  *  https://eips.ethereum.org/EIPS/eip-1363
663  */
664 interface IERC1363 is IERC20, IERC165 {
665     /*
666      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
667      * 0x4bbee2df ===
668      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
669      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
670      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
671      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
672      */
673 
674     /*
675      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
676      * 0xfb9ec8ce ===
677      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
678      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
679      */
680 
681     /**
682      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
683      * @param recipient address The address which you want to transfer to
684      * @param amount uint256 The amount of tokens to be transferred
685      * @return true unless throwing
686      */
687     function transferAndCall(address recipient, uint256 amount) external returns (bool);
688 
689     /**
690      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
691      * @param recipient address The address which you want to transfer to
692      * @param amount uint256 The amount of tokens to be transferred
693      * @param data bytes Additional data with no specified format, sent in call to `recipient`
694      * @return true unless throwing
695      */
696     function transferAndCall(address recipient, uint256 amount, bytes calldata data) external returns (bool);
697 
698     /**
699      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
700      * @param sender address The address which you want to send tokens from
701      * @param recipient address The address which you want to transfer to
702      * @param amount uint256 The amount of tokens to be transferred
703      * @return true unless throwing
704      */
705     function transferFromAndCall(address sender, address recipient, uint256 amount) external returns (bool);
706 
707     /**
708      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
709      * @param sender address The address which you want to send tokens from
710      * @param recipient address The address which you want to transfer to
711      * @param amount uint256 The amount of tokens to be transferred
712      * @param data bytes Additional data with no specified format, sent in call to `recipient`
713      * @return true unless throwing
714      */
715     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes calldata data) external returns (bool);
716 
717     /**
718      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
719      * and then call `onApprovalReceived` on spender.
720      * Beware that changing an allowance with this method brings the risk that someone may use both the old
721      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
722      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
723      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
724      * @param spender address The address which will spend the funds
725      * @param amount uint256 The amount of tokens to be spent
726      */
727     function approveAndCall(address spender, uint256 amount) external returns (bool);
728 
729     /**
730      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
731      * and then call `onApprovalReceived` on spender.
732      * Beware that changing an allowance with this method brings the risk that someone may use both the old
733      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
734      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
735      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
736      * @param spender address The address which will spend the funds
737      * @param amount uint256 The amount of tokens to be spent
738      * @param data bytes Additional data with no specified format, sent in call to `spender`
739      */
740     function approveAndCall(address spender, uint256 amount, bytes calldata data) external returns (bool);
741 }
742 
743 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
744 
745 
746 
747 pragma solidity ^0.7.0;
748 
749 /**
750  * @title IERC1363Receiver Interface
751  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
752  *  from ERC1363 token contracts as defined in
753  *  https://eips.ethereum.org/EIPS/eip-1363
754  */
755 interface IERC1363Receiver {
756     /*
757      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
758      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
759      */
760 
761     /**
762      * @notice Handle the receipt of ERC1363 tokens
763      * @dev Any ERC1363 smart contract calls this function on the recipient
764      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
765      * transfer. Return of other than the magic value MUST result in the
766      * transaction being reverted.
767      * Note: the token contract address is always the message sender.
768      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
769      * @param sender address The address which are token transferred from
770      * @param amount uint256 The amount of tokens transferred
771      * @param data bytes Additional data with no specified format
772      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
773      */
774     function onTransferReceived(address operator, address sender, uint256 amount, bytes calldata data) external returns (bytes4);
775 }
776 
777 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
778 
779 
780 
781 pragma solidity ^0.7.0;
782 
783 /**
784  * @title IERC1363Spender Interface
785  * @dev Interface for any contract that wants to support approveAndCall
786  *  from ERC1363 token contracts as defined in
787  *  https://eips.ethereum.org/EIPS/eip-1363
788  */
789 interface IERC1363Spender {
790     /*
791      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
792      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
793      */
794 
795     /**
796      * @notice Handle the approval of ERC1363 tokens
797      * @dev Any ERC1363 smart contract calls this function on the recipient
798      * after an `approve`. This function MAY throw to revert and reject the
799      * approval. Return of other than the magic value MUST result in the
800      * transaction being reverted.
801      * Note: the token contract address is always the message sender.
802      * @param sender address The address which called `approveAndCall` function
803      * @param amount uint256 The amount of tokens to be spent
804      * @param data bytes Additional data with no specified format
805      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
806      */
807     function onApprovalReceived(address sender, uint256 amount, bytes calldata data) external returns (bytes4);
808 }
809 
810 // File: @openzeppelin/contracts/utils/Address.sol
811 
812 
813 
814 pragma solidity ^0.7.0;
815 
816 /**
817  * @dev Collection of functions related to the address type
818  */
819 library Address {
820     /**
821      * @dev Returns true if `account` is a contract.
822      *
823      * [IMPORTANT]
824      * ====
825      * It is unsafe to assume that an address for which this function returns
826      * false is an externally-owned account (EOA) and not a contract.
827      *
828      * Among others, `isContract` will return false for the following
829      * types of addresses:
830      *
831      *  - an externally-owned account
832      *  - a contract in construction
833      *  - an address where a contract will be created
834      *  - an address where a contract lived, but was destroyed
835      * ====
836      */
837     function isContract(address account) internal view returns (bool) {
838         // This method relies on extcodesize, which returns 0 for contracts in
839         // construction, since the code is only stored at the end of the
840         // constructor execution.
841 
842         uint256 size;
843         // solhint-disable-next-line no-inline-assembly
844         assembly { size := extcodesize(account) }
845         return size > 0;
846     }
847 
848     /**
849      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
850      * `recipient`, forwarding all available gas and reverting on errors.
851      *
852      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
853      * of certain opcodes, possibly making contracts go over the 2300 gas limit
854      * imposed by `transfer`, making them unable to receive funds via
855      * `transfer`. {sendValue} removes this limitation.
856      *
857      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
858      *
859      * IMPORTANT: because control is transferred to `recipient`, care must be
860      * taken to not create reentrancy vulnerabilities. Consider using
861      * {ReentrancyGuard} or the
862      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
863      */
864     function sendValue(address payable recipient, uint256 amount) internal {
865         require(address(this).balance >= amount, "Address: insufficient balance");
866 
867         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
868         (bool success, ) = recipient.call{ value: amount }("");
869         require(success, "Address: unable to send value, recipient may have reverted");
870     }
871 
872     /**
873      * @dev Performs a Solidity function call using a low level `call`. A
874      * plain`call` is an unsafe replacement for a function call: use this
875      * function instead.
876      *
877      * If `target` reverts with a revert reason, it is bubbled up by this
878      * function (like regular Solidity function calls).
879      *
880      * Returns the raw returned data. To convert to the expected return value,
881      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
882      *
883      * Requirements:
884      *
885      * - `target` must be a contract.
886      * - calling `target` with `data` must not revert.
887      *
888      * _Available since v3.1._
889      */
890     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
891       return functionCall(target, data, "Address: low-level call failed");
892     }
893 
894     /**
895      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
896      * `errorMessage` as a fallback revert reason when `target` reverts.
897      *
898      * _Available since v3.1._
899      */
900     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
901         return functionCallWithValue(target, data, 0, errorMessage);
902     }
903 
904     /**
905      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
906      * but also transferring `value` wei to `target`.
907      *
908      * Requirements:
909      *
910      * - the calling contract must have an ETH balance of at least `value`.
911      * - the called Solidity function must be `payable`.
912      *
913      * _Available since v3.1._
914      */
915     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
916         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
917     }
918 
919     /**
920      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
921      * with `errorMessage` as a fallback revert reason when `target` reverts.
922      *
923      * _Available since v3.1._
924      */
925     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
926         require(address(this).balance >= value, "Address: insufficient balance for call");
927         require(isContract(target), "Address: call to non-contract");
928 
929         // solhint-disable-next-line avoid-low-level-calls
930         (bool success, bytes memory returndata) = target.call{ value: value }(data);
931         return _verifyCallResult(success, returndata, errorMessage);
932     }
933 
934     /**
935      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
936      * but performing a static call.
937      *
938      * _Available since v3.3._
939      */
940     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
941         return functionStaticCall(target, data, "Address: low-level static call failed");
942     }
943 
944     /**
945      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
946      * but performing a static call.
947      *
948      * _Available since v3.3._
949      */
950     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
951         require(isContract(target), "Address: static call to non-contract");
952 
953         // solhint-disable-next-line avoid-low-level-calls
954         (bool success, bytes memory returndata) = target.staticcall(data);
955         return _verifyCallResult(success, returndata, errorMessage);
956     }
957 
958     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
959         if (success) {
960             return returndata;
961         } else {
962             // Look for revert reason and bubble it up if present
963             if (returndata.length > 0) {
964                 // The easiest way to bubble the revert reason is using memory via assembly
965 
966                 // solhint-disable-next-line no-inline-assembly
967                 assembly {
968                     let returndata_size := mload(returndata)
969                     revert(add(32, returndata), returndata_size)
970                 }
971             } else {
972                 revert(errorMessage);
973             }
974         }
975     }
976 }
977 
978 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
979 
980 
981 
982 pragma solidity ^0.7.0;
983 
984 /**
985  * @dev Library used to query support of an interface declared via {IERC165}.
986  *
987  * Note that these functions return the actual result of the query: they do not
988  * `revert` if an interface is not supported. It is up to the caller to decide
989  * what to do in these cases.
990  */
991 library ERC165Checker {
992     // As per the EIP-165 spec, no interface should ever match 0xffffffff
993     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
994 
995     /*
996      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
997      */
998     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
999 
1000     /**
1001      * @dev Returns true if `account` supports the {IERC165} interface,
1002      */
1003     function supportsERC165(address account) internal view returns (bool) {
1004         // Any contract that implements ERC165 must explicitly indicate support of
1005         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1006         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1007             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1008     }
1009 
1010     /**
1011      * @dev Returns true if `account` supports the interface defined by
1012      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1013      *
1014      * See {IERC165-supportsInterface}.
1015      */
1016     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1017         // query support of both ERC165 as per the spec and support of _interfaceId
1018         return supportsERC165(account) &&
1019             _supportsERC165Interface(account, interfaceId);
1020     }
1021 
1022     /**
1023      * @dev Returns true if `account` supports all the interfaces defined in
1024      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1025      *
1026      * Batch-querying can lead to gas savings by skipping repeated checks for
1027      * {IERC165} support.
1028      *
1029      * See {IERC165-supportsInterface}.
1030      */
1031     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1032         // query support of ERC165 itself
1033         if (!supportsERC165(account)) {
1034             return false;
1035         }
1036 
1037         // query support of each interface in _interfaceIds
1038         for (uint256 i = 0; i < interfaceIds.length; i++) {
1039             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1040                 return false;
1041             }
1042         }
1043 
1044         // all interfaces supported
1045         return true;
1046     }
1047 
1048     /**
1049      * @notice Query if a contract implements an interface, does not check ERC165 support
1050      * @param account The address of the contract to query for support of an interface
1051      * @param interfaceId The interface identifier, as specified in ERC-165
1052      * @return true if the contract at account indicates support of the interface with
1053      * identifier interfaceId, false otherwise
1054      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1055      * the behavior of this method is undefined. This precondition can be checked
1056      * with {supportsERC165}.
1057      * Interface identification is specified in ERC-165.
1058      */
1059     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1060         // success determines whether the staticcall succeeded and result determines
1061         // whether the contract at account indicates support of _interfaceId
1062         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1063 
1064         return (success && result);
1065     }
1066 
1067     /**
1068      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1069      * @param account The address of the contract to query for support of an interface
1070      * @param interfaceId The interface identifier, as specified in ERC-165
1071      * @return success true if the STATICCALL succeeded, false otherwise
1072      * @return result true if the STATICCALL succeeded and the contract at account
1073      * indicates support of the interface with identifier interfaceId, false otherwise
1074      */
1075     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1076         private
1077         view
1078         returns (bool, bool)
1079     {
1080         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1081         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1082         if (result.length < 32) return (false, false);
1083         return (success, abi.decode(result, (bool)));
1084     }
1085 }
1086 
1087 // File: @openzeppelin/contracts/introspection/ERC165.sol
1088 
1089 
1090 
1091 pragma solidity ^0.7.0;
1092 
1093 
1094 /**
1095  * @dev Implementation of the {IERC165} interface.
1096  *
1097  * Contracts may inherit from this and call {_registerInterface} to declare
1098  * their support of an interface.
1099  */
1100 abstract contract ERC165 is IERC165 {
1101     /*
1102      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1103      */
1104     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1105 
1106     /**
1107      * @dev Mapping of interface ids to whether or not it's supported.
1108      */
1109     mapping(bytes4 => bool) private _supportedInterfaces;
1110 
1111     constructor () {
1112         // Derived contracts need only register support for their own interfaces,
1113         // we register support for ERC165 itself here
1114         _registerInterface(_INTERFACE_ID_ERC165);
1115     }
1116 
1117     /**
1118      * @dev See {IERC165-supportsInterface}.
1119      *
1120      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1121      */
1122     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1123         return _supportedInterfaces[interfaceId];
1124     }
1125 
1126     /**
1127      * @dev Registers the contract as an implementer of the interface defined by
1128      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1129      * registering its interface id is not required.
1130      *
1131      * See {IERC165-supportsInterface}.
1132      *
1133      * Requirements:
1134      *
1135      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1136      */
1137     function _registerInterface(bytes4 interfaceId) internal virtual {
1138         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1139         _supportedInterfaces[interfaceId] = true;
1140     }
1141 }
1142 
1143 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1144 
1145 
1146 
1147 pragma solidity ^0.7.0;
1148 
1149 
1150 
1151 
1152 
1153 
1154 
1155 
1156 /**
1157  * @title ERC1363
1158  * @dev Implementation of an ERC1363 interface
1159  */
1160 contract ERC1363 is ERC20, IERC1363, ERC165 {
1161     using Address for address;
1162 
1163     /*
1164      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1165      * 0x4bbee2df ===
1166      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1167      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1168      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1169      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1170      */
1171     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1172 
1173     /*
1174      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1175      * 0xfb9ec8ce ===
1176      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1177      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1178      */
1179     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1180 
1181     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1182     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1183     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1184 
1185     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1186     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1187     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1188 
1189     /**
1190      * @param name Name of the token
1191      * @param symbol A symbol to be used as ticker
1192      */
1193     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
1194         // register the supported interfaces to conform to ERC1363 via ERC165
1195         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1196         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1197     }
1198 
1199     /**
1200      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1201      * @param recipient The address to transfer to.
1202      * @param amount The amount to be transferred.
1203      * @return A boolean that indicates if the operation was successful.
1204      */
1205     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
1206         return transferAndCall(recipient, amount, "");
1207     }
1208 
1209     /**
1210      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1211      * @param recipient The address to transfer to
1212      * @param amount The amount to be transferred
1213      * @param data Additional data with no specified format
1214      * @return A boolean that indicates if the operation was successful.
1215      */
1216     function transferAndCall(address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
1217         transfer(recipient, amount);
1218         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1219         return true;
1220     }
1221 
1222     /**
1223      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1224      * @param sender The address which you want to send tokens from
1225      * @param recipient The address which you want to transfer to
1226      * @param amount The amount of tokens to be transferred
1227      * @return A boolean that indicates if the operation was successful.
1228      */
1229     function transferFromAndCall(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1230         return transferFromAndCall(sender, recipient, amount, "");
1231     }
1232 
1233     /**
1234      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1235      * @param sender The address which you want to send tokens from
1236      * @param recipient The address which you want to transfer to
1237      * @param amount The amount of tokens to be transferred
1238      * @param data Additional data with no specified format
1239      * @return A boolean that indicates if the operation was successful.
1240      */
1241     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
1242         transferFrom(sender, recipient, amount);
1243         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1244         return true;
1245     }
1246 
1247     /**
1248      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1249      * @param spender The address allowed to transfer to
1250      * @param amount The amount allowed to be transferred
1251      * @return A boolean that indicates if the operation was successful.
1252      */
1253     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1254         return approveAndCall(spender, amount, "");
1255     }
1256 
1257     /**
1258      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1259      * @param spender The address allowed to transfer to.
1260      * @param amount The amount allowed to be transferred.
1261      * @param data Additional data with no specified format.
1262      * @return A boolean that indicates if the operation was successful.
1263      */
1264     function approveAndCall(address spender, uint256 amount, bytes memory data) public virtual override returns (bool) {
1265         approve(spender, amount);
1266         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1267         return true;
1268     }
1269 
1270     /**
1271      * @dev Internal function to invoke `onTransferReceived` on a target address
1272      *  The call is not executed if the target address is not a contract
1273      * @param sender address Representing the previous owner of the given token value
1274      * @param recipient address Target address that will receive the tokens
1275      * @param amount uint256 The amount mount of tokens to be transferred
1276      * @param data bytes Optional data to send along with the call
1277      * @return whether the call correctly returned the expected magic value
1278      */
1279     function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal virtual returns (bool) {
1280         if (!recipient.isContract()) {
1281             return false;
1282         }
1283         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(
1284             _msgSender(), sender, amount, data
1285         );
1286         return (retval == _ERC1363_RECEIVED);
1287     }
1288 
1289     /**
1290      * @dev Internal function to invoke `onApprovalReceived` on a target address
1291      *  The call is not executed if the target address is not a contract
1292      * @param spender address The address which will spend the funds
1293      * @param amount uint256 The amount of tokens to be spent
1294      * @param data bytes Optional data to send along with the call
1295      * @return whether the call correctly returned the expected magic value
1296      */
1297     function _checkAndCallApprove(address spender, uint256 amount, bytes memory data) internal virtual returns (bool) {
1298         if (!spender.isContract()) {
1299             return false;
1300         }
1301         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1302             _msgSender(), amount, data
1303         );
1304         return (retval == _ERC1363_APPROVED);
1305     }
1306 }
1307 
1308 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1309 
1310 
1311 
1312 pragma solidity ^0.7.0;
1313 
1314 
1315 /**
1316  * @title ERC20Mintable
1317  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1318  */
1319 abstract contract ERC20Mintable is ERC20 {
1320 
1321     // indicates if minting is finished
1322     bool private _mintingFinished = false;
1323 
1324     /**
1325      * @dev Emitted during finish minting
1326      */
1327     event MintFinished();
1328 
1329     /**
1330      * @dev Tokens can be minted only before minting finished.
1331      */
1332     modifier canMint() {
1333         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1334         _;
1335     }
1336 
1337     /**
1338      * @return if minting is finished or not.
1339      */
1340     function mintingFinished() public view returns (bool) {
1341         return _mintingFinished;
1342     }
1343 
1344     /**
1345      * @dev Function to mint tokens.
1346      *
1347      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1348      *
1349      * @param account The address that will receive the minted tokens
1350      * @param amount The amount of tokens to mint
1351      */
1352     function mint(address account, uint256 amount) public canMint {
1353         _mint(account, amount);
1354     }
1355 
1356     /**
1357      * @dev Function to stop minting new tokens.
1358      *
1359      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1360      */
1361     function finishMinting() public canMint {
1362         _finishMinting();
1363     }
1364 
1365     /**
1366      * @dev Function to stop minting new tokens.
1367      */
1368     function _finishMinting() internal virtual {
1369         _mintingFinished = true;
1370 
1371         emit MintFinished();
1372     }
1373 }
1374 
1375 // File: @openzeppelin/contracts/access/Ownable.sol
1376 
1377 
1378 
1379 pragma solidity ^0.7.0;
1380 
1381 /**
1382  * @dev Contract module which provides a basic access control mechanism, where
1383  * there is an account (an owner) that can be granted exclusive access to
1384  * specific functions.
1385  *
1386  * By default, the owner account will be the one that deploys the contract. This
1387  * can later be changed with {transferOwnership}.
1388  *
1389  * This module is used through inheritance. It will make available the modifier
1390  * `onlyOwner`, which can be applied to your functions to restrict their use to
1391  * the owner.
1392  */
1393 abstract contract Ownable is Context {
1394     address private _owner;
1395 
1396     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1397 
1398     /**
1399      * @dev Initializes the contract setting the deployer as the initial owner.
1400      */
1401     constructor () {
1402         address msgSender = _msgSender();
1403         _owner = msgSender;
1404         emit OwnershipTransferred(address(0), msgSender);
1405     }
1406 
1407     /**
1408      * @dev Returns the address of the current owner.
1409      */
1410     function owner() public view returns (address) {
1411         return _owner;
1412     }
1413 
1414     /**
1415      * @dev Throws if called by any account other than the owner.
1416      */
1417     modifier onlyOwner() {
1418         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1419         _;
1420     }
1421 
1422     /**
1423      * @dev Leaves the contract without owner. It will not be possible to call
1424      * `onlyOwner` functions anymore. Can only be called by the current owner.
1425      *
1426      * NOTE: Renouncing ownership will leave the contract without an owner,
1427      * thereby removing any functionality that is only available to the owner.
1428      */
1429     function renounceOwnership() public virtual onlyOwner {
1430         emit OwnershipTransferred(_owner, address(0));
1431         _owner = address(0);
1432     }
1433 
1434     /**
1435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1436      * Can only be called by the current owner.
1437      */
1438     function transferOwnership(address newOwner) public virtual onlyOwner {
1439         require(newOwner != address(0), "Ownable: new owner is the zero address");
1440         emit OwnershipTransferred(_owner, newOwner);
1441         _owner = newOwner;
1442     }
1443 }
1444 
1445 // File: eth-token-recover/contracts/TokenRecover.sol
1446 
1447 
1448 
1449 pragma solidity ^0.7.0;
1450 
1451 
1452 
1453 /**
1454  * @title TokenRecover
1455  * @dev Allow to recover any ERC20 sent into the contract for error
1456  */
1457 contract TokenRecover is Ownable {
1458 
1459     /**
1460      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1461      * @param tokenAddress The token contract address
1462      * @param tokenAmount Number of tokens to be sent
1463      */
1464     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1465         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1466     }
1467 }
1468 
1469 // File: contracts/service/ServiceReceiver.sol
1470 
1471 
1472 
1473 pragma solidity ^0.7.0;
1474 
1475 
1476 /**
1477  * @title ServiceReceiver
1478  * @dev Implementation of the ServiceReceiver
1479  */
1480 contract ServiceReceiver is TokenRecover {
1481 
1482     mapping (bytes32 => uint256) private _prices;
1483 
1484     event Created(string serviceName, address indexed serviceAddress);
1485 
1486     function pay(string memory serviceName) public payable {
1487         require(msg.value == _prices[_toBytes32(serviceName)], "ServiceReceiver: incorrect price");
1488 
1489         emit Created(serviceName, _msgSender());
1490     }
1491 
1492     function getPrice(string memory serviceName) public view returns (uint256) {
1493         return _prices[_toBytes32(serviceName)];
1494     }
1495 
1496     function setPrice(string memory serviceName, uint256 amount) public onlyOwner {
1497         _prices[_toBytes32(serviceName)] = amount;
1498     }
1499 
1500     function withdraw(uint256 amount) public onlyOwner {
1501         payable(owner()).transfer(amount);
1502     }
1503 
1504     function _toBytes32(string memory serviceName) private pure returns (bytes32) {
1505         return keccak256(abi.encode(serviceName));
1506     }
1507 }
1508 
1509 // File: contracts/service/ServicePayer.sol
1510 
1511 
1512 
1513 pragma solidity ^0.7.0;
1514 
1515 
1516 /**
1517  * @title ServicePayer
1518  * @dev Implementation of the ServicePayer
1519  */
1520 abstract contract ServicePayer {
1521 
1522     constructor (address payable receiver, string memory serviceName) payable {
1523         ServiceReceiver(receiver).pay{value: msg.value}(serviceName);
1524     }
1525 }
1526 
1527 // File: contracts/token/ERC20/AmazingERC20.sol
1528 
1529 
1530 
1531 pragma solidity ^0.7.0;
1532 
1533 
1534 
1535 
1536 
1537 /**
1538  * @title AmazingERC20
1539  * @dev Implementation of the AmazingERC20
1540  */
1541 contract AmazingERC20 is ERC20Mintable, ERC20Burnable, ERC1363, TokenRecover, ServicePayer {
1542 
1543     constructor (
1544         string memory name,
1545         string memory symbol,
1546         uint8 decimals,
1547         uint256 initialBalance,
1548         address payable feeReceiver
1549     )
1550         ERC1363(name, symbol)
1551         ServicePayer(feeReceiver, "AmazingERC20")
1552         payable
1553     {
1554         _setupDecimals(decimals);
1555         _mint(_msgSender(), initialBalance);
1556     }
1557 
1558     /**
1559      * @dev Function to mint tokens.
1560      *
1561      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
1562      *
1563      * @param account The address that will receive the minted tokens
1564      * @param amount The amount of tokens to mint
1565      */
1566     function _mint(address account, uint256 amount) internal override onlyOwner {
1567         super._mint(account, amount);
1568     }
1569 
1570     /**
1571      * @dev Function to stop minting new tokens.
1572      *
1573      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1574      */
1575     function _finishMinting() internal override onlyOwner {
1576         super._finishMinting();
1577     }
1578 }