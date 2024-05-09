1 pragma solidity ^0.6.0;
2 
3 
4 /* @file = ./Context.sol */
5 
6 contract Context {
7     // Empty internal constructor, to prevent people from mistakenly deploying
8     // an instance of this contract, which should be used via inheritance.
9     constructor () internal { }
10 
11     function _msgSender() internal view virtual returns (address payable) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes memory) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 /* @file = ./ERC20/IERC20.sol */
22 
23 
24 pragma solidity ^0.6.0;
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
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 /* @file = ./math/SafeMath.sol */
102 
103 
104 pragma solidity ^0.6.0;
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
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
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         // Solidity only automatically asserts when dividing by 0
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 
256 /* @file = ./utils/Address.sol */
257 
258 
259 pragma solidity ^0.6.2;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 }
317 
318 
319 /* @file = ./ERC20/ERC20.sol */
320 
321 
322 pragma solidity ^0.6.0;
323 
324 
325 /**
326  * @dev Implementation of the {IERC20} interface.
327  *
328  * This implementation is agnostic to the way tokens are created. This means
329  * that a supply mechanism has to be added in a derived contract using {_mint}.
330  * For a generic mechanism see {ERC20MinterPauser}.
331  *
332  * TIP: For a detailed writeup see our guide
333  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
334  * to implement supply mechanisms].
335  *
336  * We have followed general OpenZeppelin guidelines: functions revert instead
337  * of returning `false` on failure. This behavior is nonetheless conventional
338  * and does not conflict with the expectations of ERC20 applications.
339  *
340  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
341  * This allows applications to reconstruct the allowance for all accounts just
342  * by listening to said events. Other implementations of the EIP may not emit
343  * these events, as it isn't required by the specification.
344  *
345  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
346  * functions have been added to mitigate the well-known issues around setting
347  * allowances. See {IERC20-approve}.
348  */
349 contract ERC20 is Context, IERC20 {
350     using SafeMath for uint256;
351     using Address for address;
352 
353     mapping (address => uint256) private _balances;
354 
355     mapping (address => mapping (address => uint256)) private _allowances;
356 
357     uint256 private _totalSupply;
358 
359     string private _name = 'OM Lira';
360     string private _symbol = 'OML';
361     uint8 private _decimals = 18;
362 
363     /**
364      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
365      * a default value of 18.
366      *
367      * To select a different value for {decimals}, use {_setupDecimals}.
368      *
369      * All three of these values are immutable: they can only be set once during
370      * construction.
371      */
372     constructor () public {}
373 
374     /**
375      * @dev Returns the name of the token.
376      */
377     function name() public view returns (string memory) {
378         return _name;
379     }
380 
381     /**
382      * @dev Returns the symbol of the token, usually a shorter version of the
383      * name.
384      */
385     function symbol() public view returns (string memory) {
386         return _symbol;
387     }
388 
389     /**
390      * @dev Returns the number of decimals used to get its user representation.
391      * For example, if `decimals` equals `2`, a balance of `505` tokens should
392      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
393      *
394      * Tokens usually opt for a value of 18, imitating the relationship between
395      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
396      * called.
397      *
398      * NOTE: This information is only used for _display_ purposes: it in
399      * no way affects any of the arithmetic of the contract, including
400      * {IERC20-balanceOf} and {IERC20-transfer}.
401      */
402     function decimals() public view returns (uint8) {
403         return _decimals;
404     }
405 
406     /**
407      * @dev See {IERC20-totalSupply}.
408      */
409     function totalSupply() public view override returns (uint256) {
410         return _totalSupply;
411     }
412 
413     /**
414      * @dev See {IERC20-balanceOf}.
415      */
416     function balanceOf(address account) public view override returns (uint256) {
417         return _balances[account];
418     }
419 
420     /**
421      * @dev See {IERC20-transfer}.
422      *
423      * Requirements:
424      *
425      * - `recipient` cannot be the zero address.
426      * - the caller must have a balance of at least `amount`.
427      */
428     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
429         _transfer(_msgSender(), recipient, amount);
430         return true;
431     }
432 
433     /**
434      * @dev See {IERC20-allowance}.
435      */
436     function allowance(address owner, address spender) public view virtual override returns (uint256) {
437         return _allowances[owner][spender];
438     }
439 
440     /**
441      * @dev See {IERC20-approve}.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      */
447     function approve(address spender, uint256 amount) public virtual override returns (bool) {
448         _approve(_msgSender(), spender, amount);
449         return true;
450     }
451 
452     /**
453      * @dev See {IERC20-transferFrom}.
454      *
455      * Emits an {Approval} event indicating the updated allowance. This is not
456      * required by the EIP. See the note at the beginning of {ERC20};
457      *
458      * Requirements:
459      * - `sender` and `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      * - the caller must have allowance for ``sender``'s tokens of at least
462      * `amount`.
463      */
464     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
465         _transfer(sender, recipient, amount);
466         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically decreases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      * - `spender` must have allowance for the caller of at least
499      * `subtractedValue`.
500      */
501     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
503         return true;
504     }
505 
506     /**
507      * @dev Moves tokens `amount` from `sender` to `recipient`.
508      *
509      * This is internal function is equivalent to {transfer}, and can be used to
510      * e.g. implement automatic token fees, slashing mechanisms, etc.
511      *
512      * Emits a {Transfer} event.
513      *
514      * Requirements:
515      *
516      * - `sender` cannot be the zero address.
517      * - `recipient` cannot be the zero address.
518      * - `sender` must have a balance of at least `amount`.
519      */
520     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
521         require(sender != address(0), "ERC20: transfer from the zero address");
522         require(recipient != address(0), "ERC20: transfer to the zero address");
523 
524         _beforeTokenTransfer(sender, recipient, amount);
525 
526         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
527         _balances[recipient] = _balances[recipient].add(amount);
528         emit Transfer(sender, recipient, amount);
529     }
530 
531     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
532      * the total supply.
533      *
534      * Emits a {Transfer} event with `from` set to the zero address.
535      *
536      * Requirements
537      *
538      * - `to` cannot be the zero address.
539      */
540     function _mint(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: mint to the zero address");
542 
543         _beforeTokenTransfer(address(0), account, amount);
544 
545         _totalSupply = _totalSupply.add(amount);
546         _balances[account] = _balances[account].add(amount);
547         emit Transfer(address(0), account, amount);
548     }
549 
550     /**
551      * @dev Destroys `amount` tokens from `account`, reducing the
552      * total supply.
553      *
554      * Emits a {Transfer} event with `to` set to the zero address.
555      *
556      * Requirements
557      *
558      * - `account` cannot be the zero address.
559      * - `account` must have at least `amount` tokens.
560      */
561     function _burn(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: burn from the zero address");
563 
564         _beforeTokenTransfer(account, address(0), amount);
565 
566         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
567         _totalSupply = _totalSupply.sub(amount);
568         emit Transfer(account, address(0), amount);
569     }
570 
571     /**
572      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
573      *
574      * This is internal function is equivalent to `approve`, and can be used to
575      * e.g. set automatic allowances for certain subsystems, etc.
576      *
577      * Emits an {Approval} event.
578      *
579      * Requirements:
580      *
581      * - `owner` cannot be the zero address.
582      * - `spender` cannot be the zero address.
583      */
584     function _approve(address owner, address spender, uint256 amount) internal virtual {
585         require(owner != address(0), "ERC20: approve from the zero address");
586         require(spender != address(0), "ERC20: approve to the zero address");
587 
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     /**
593      * @dev Sets {decimals} to a value other than the default one of 18.
594      *
595      * WARNING: This function should only be called from the constructor. Most
596      * applications that interact with token contracts will not expect
597      * {decimals} to ever change, and may work incorrectly if it does.
598      */
599     function _setupDecimals(uint8 decimals_) internal {
600         _decimals = decimals_;
601     }
602 
603     /**
604      * @dev Hook that is called before any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * will be to transferred to `to`.
611      * - when `from` is zero, `amount` tokens will be minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
618 }
619 
620 
621 
622 /* @file = ./ERC20/ERC20Capped.sol */
623 
624 
625 pragma solidity ^0.6.0;
626 
627 
628 
629 /**
630  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
631  */
632 abstract contract ERC20Capped is ERC20 {
633     uint256 private _cap = 1000000000000000000000000000;
634 
635     /**
636      * @dev Sets the value of the `cap`. This value is immutable, it can only be
637      * set once during construction.
638      */
639     constructor () public {
640     }
641 
642     /**
643      * @dev Returns the cap on the token's total supply.
644      */
645     function cap() public view returns (uint256) {
646         return _cap;
647     }
648 
649     /**
650      * @dev See {ERC20-_beforeTokenTransfer}.
651      *
652      * Requirements:
653      *
654      * - minted tokens must not cause the total supply to go over the cap.
655      */
656     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
657         super._beforeTokenTransfer(from, to, amount);
658 
659         if (from == address(0)) { // When minting tokens
660             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
661         }
662     }
663 }
664 
665 
666 /* @file = ./ERC20/ERC20Burnable.sol */
667 
668 
669 pragma solidity ^0.6.0;
670 
671 
672 /**
673  * @dev Extension of {ERC20} that allows token holders to destroy both their own
674  * tokens and those that they have an allowance for, in a way that can be
675  * recognized off-chain (via event analysis).
676  */
677 abstract contract ERC20Burnable is Context, ERC20 {
678     /**
679      * @dev Destroys `amount` tokens from the caller.
680      *
681      * See {ERC20-_burn}.
682      */
683     function burn(uint256 amount) public virtual {
684         _burn(_msgSender(), amount);
685     }
686 
687     /**
688      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
689      * allowance.
690      *
691      * See {ERC20-_burn} and {ERC20-allowance}.
692      *
693      * Requirements:
694      *
695      * - the caller must have allowance for ``accounts``'s tokens of at least
696      * `amount`.
697      */
698     function burnFrom(address account, uint256 amount) public virtual {
699         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
700 
701         _approve(account, _msgSender(), decreasedAllowance);
702         _burn(account, amount);
703     }
704 }
705 
706 
707 
708 /* @file = ./introspection/IERC165.sol */
709 
710 
711 pragma solidity ^0.6.0;
712 
713 /**
714  * @dev Interface of the ERC165 standard, as defined in the
715  * https://eips.ethereum.org/EIPS/eip-165[EIP].
716  *
717  * Implementers can declare support of contract interfaces, which can then be
718  * queried by others ({ERC165Checker}).
719  *
720  * For an implementation, see {ERC165}.
721  */
722 interface IERC165 {
723     /**
724      * @dev Returns true if this contract implements the interface defined by
725      * `interfaceId`. See the corresponding
726      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
727      * to learn more about how these ids are created.
728      *
729      * This function call must use less than 30 000 gas.
730      */
731     function supportsInterface(bytes4 interfaceId) external view returns (bool);
732 }
733 
734 
735 /* @file = ./ERC1363/IERC1363.sol */
736 
737 
738 pragma solidity ^0.6.0;
739 
740 
741 /**
742  * @title IERC1363 Interface
743  * @author Vittorio Minacori (https://github.com/vittominacori)
744  * @dev Interface for a Payable Token contract as defined in
745  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
746  */
747 interface IERC1363 is IERC20, IERC165 {
748     /*
749      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
750      * 0x4bbee2df ===
751      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
752      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
753      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
754      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
755      */
756 
757     /*
758      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
759      * 0xfb9ec8ce ===
760      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
761      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
762      */
763 
764     /**
765      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
766      * @param to address The address which you want to transfer to
767      * @param value uint256 The amount of tokens to be transferred
768      * @return true unless throwing
769      */
770     function transferAndCall(address to, uint256 value) external returns (bool);
771 
772     /**
773      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
774      * @param to address The address which you want to transfer to
775      * @param value uint256 The amount of tokens to be transferred
776      * @param data bytes Additional data with no specified format, sent in call to `to`
777      * @return true unless throwing
778      */
779     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
780 
781     /**
782      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
783      * @param from address The address which you want to send tokens from
784      * @param to address The address which you want to transfer to
785      * @param value uint256 The amount of tokens to be transferred
786      * @return true unless throwing
787      */
788     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
789 
790     /**
791      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
792      * @param from address The address which you want to send tokens from
793      * @param to address The address which you want to transfer to
794      * @param value uint256 The amount of tokens to be transferred
795      * @param data bytes Additional data with no specified format, sent in call to `to`
796      * @return true unless throwing
797      */
798     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
799 
800     /**
801      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
802      * and then call `onApprovalReceived` on spender.
803      * Beware that changing an allowance with this method brings the risk that someone may use both the old
804      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
805      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
806      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
807      * @param spender address The address which will spend the funds
808      * @param value uint256 The amount of tokens to be spent
809      */
810     function approveAndCall(address spender, uint256 value) external returns (bool);
811 
812     /**
813      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
814      * and then call `onApprovalReceived` on spender.
815      * Beware that changing an allowance with this method brings the risk that someone may use both the old
816      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
817      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
818      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
819      * @param spender address The address which will spend the funds
820      * @param value uint256 The amount of tokens to be spent
821      * @param data bytes Additional data with no specified format, sent in call to `spender`
822      */
823     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
824 }
825 
826 
827 /* @file = ./ERC1363/IERC1363Receiver.sol */
828 
829 
830 
831 pragma solidity ^0.6.0;
832 
833 /**
834  * @title IERC1363Receiver Interface
835  * @author Vittorio Minacori (https://github.com/vittominacori)
836  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
837  *  from ERC1363 token contracts as defined in
838  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
839  */
840 interface IERC1363Receiver {
841     /*
842      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
843      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
844      */
845 
846     /**
847      * @notice Handle the receipt of ERC1363 tokens
848      * @dev Any ERC1363 smart contract calls this function on the recipient
849      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
850      * transfer. Return of other than the magic value MUST result in the
851      * transaction being reverted.
852      * Note: the token contract address is always the message sender.
853      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
854      * @param from address The address which are token transferred from
855      * @param value uint256 The amount of tokens transferred
856      * @param data bytes Additional data with no specified format
857      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
858      *  unless throwing
859      */
860     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
861 }
862 
863 pragma solidity ^0.6.0;
864 
865 /**
866  * @title IERC1363Spender Interface
867  * @author Vittorio Minacori (https://github.com/vittominacori)
868  * @dev Interface for any contract that wants to support approveAndCall
869  *  from ERC1363 token contracts as defined in
870  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
871  */
872 interface IERC1363Spender {
873     /*
874      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
875      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
876      */
877 
878     /**
879      * @notice Handle the approval of ERC1363 tokens
880      * @dev Any ERC1363 smart contract calls this function on the recipient
881      * after an `approve`. This function MAY throw to revert and reject the
882      * approval. Return of other than the magic value MUST result in the
883      * transaction being reverted.
884      * Note: the token contract address is always the message sender.
885      * @param owner address The address which called `approveAndCall` function
886      * @param value uint256 The amount of tokens to be spent
887      * @param data bytes Additional data with no specified format
888      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
889      *  unless throwing
890      */
891     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
892 }
893 
894 
895 
896 /* @file = ./introspection/ERC165Checker.sol */
897 
898 
899 
900 pragma solidity ^0.6.2;
901 
902 /**
903  * @dev Library used to query support of an interface declared via {IERC165}.
904  *
905  * Note that these functions return the actual result of the query: they do not
906  * `revert` if an interface is not supported. It is up to the caller to decide
907  * what to do in these cases.
908  */
909 library ERC165Checker {
910     // As per the EIP-165 spec, no interface should ever match 0xffffffff
911     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
912 
913     /*
914      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
915      */
916     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
917 
918     /**
919      * @dev Returns true if `account` supports the {IERC165} interface,
920      */
921     function supportsERC165(address account) internal view returns (bool) {
922         // Any contract that implements ERC165 must explicitly indicate support of
923         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
924         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
925             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
926     }
927 
928     /**
929      * @dev Returns true if `account` supports the interface defined by
930      * `interfaceId`. Support for {IERC165} itself is queried automatically.
931      *
932      * See {IERC165-supportsInterface}.
933      */
934     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
935         // query support of both ERC165 as per the spec and support of _interfaceId
936         return supportsERC165(account) &&
937             _supportsERC165Interface(account, interfaceId);
938     }
939 
940     /**
941      * @dev Returns true if `account` supports all the interfaces defined in
942      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
943      *
944      * Batch-querying can lead to gas savings by skipping repeated checks for
945      * {IERC165} support.
946      *
947      * See {IERC165-supportsInterface}.
948      */
949     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
950         // query support of ERC165 itself
951         if (!supportsERC165(account)) {
952             return false;
953         }
954 
955         // query support of each interface in _interfaceIds
956         for (uint256 i = 0; i < interfaceIds.length; i++) {
957             if (!_supportsERC165Interface(account, interfaceIds[i])) {
958                 return false;
959             }
960         }
961 
962         // all interfaces supported
963         return true;
964     }
965 
966     /**
967      * @notice Query if a contract implements an interface, does not check ERC165 support
968      * @param account The address of the contract to query for support of an interface
969      * @param interfaceId The interface identifier, as specified in ERC-165
970      * @return true if the contract at account indicates support of the interface with
971      * identifier interfaceId, false otherwise
972      * @dev Assumes that account contains a contract that supports ERC165, otherwise
973      * the behavior of this method is undefined. This precondition can be checked
974      * with {supportsERC165}.
975      * Interface identification is specified in ERC-165.
976      */
977     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
978         // success determines whether the staticcall succeeded and result determines
979         // whether the contract at account indicates support of _interfaceId
980         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
981 
982         return (success && result);
983     }
984 
985     /**
986      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
987      * @param account The address of the contract to query for support of an interface
988      * @param interfaceId The interface identifier, as specified in ERC-165
989      * @return success true if the STATICCALL succeeded, false otherwise
990      * @return result true if the STATICCALL succeeded and the contract at account
991      * indicates support of the interface with identifier interfaceId, false otherwise
992      */
993     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
994         private
995         view
996         returns (bool, bool)
997     {
998         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
999         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1000         if (result.length < 32) return (false, false);
1001         return (success, abi.decode(result, (bool)));
1002     }
1003 }
1004 
1005 /* @file = ./introspection/ERC165.sol */
1006 
1007 
1008 
1009 
1010 
1011 pragma solidity ^0.6.0;
1012 
1013 /**
1014  * @dev Implementation of the {IERC165} interface.
1015  *
1016  * Contracts may inherit from this and call {_registerInterface} to declare
1017  * their support of an interface.
1018  */
1019 contract ERC165 is IERC165 {
1020     /*
1021      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1022      */
1023     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1024 
1025     /**
1026      * @dev Mapping of interface ids to whether or not it's supported.
1027      */
1028     mapping(bytes4 => bool) private _supportedInterfaces;
1029 
1030     constructor () internal {
1031         // Derived contracts need only register support for their own interfaces,
1032         // we register support for ERC165 itself here
1033         _registerInterface(_INTERFACE_ID_ERC165);
1034     }
1035 
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      *
1039      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1040      */
1041     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1042         return _supportedInterfaces[interfaceId];
1043     }
1044 
1045     /**
1046      * @dev Registers the contract as an implementer of the interface defined by
1047      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1048      * registering its interface id is not required.
1049      *
1050      * See {IERC165-supportsInterface}.
1051      *
1052      * Requirements:
1053      *
1054      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1055      */
1056     function _registerInterface(bytes4 interfaceId) internal virtual {
1057         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1058         _supportedInterfaces[interfaceId] = true;
1059     }
1060 }
1061 
1062 
1063 
1064 
1065 /* @file = ./ERC1363/ERC1363.sol */
1066 
1067 
1068 
1069 pragma solidity ^0.6.0;
1070 
1071 
1072 /**
1073  * @title ERC1363
1074  * @author Vittorio Minacori (https://github.com/vittominacori)
1075  * @dev Implementation of an ERC1363 interface
1076  */
1077 contract ERC1363 is ERC20, IERC1363, ERC165 {
1078     using Address for address;
1079 
1080     /*
1081      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1082      * 0x4bbee2df ===
1083      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1084      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1085      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1086      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1087      */
1088     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1089 
1090     /*
1091      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1092      * 0xfb9ec8ce ===
1093      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1094      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1095      */
1096     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1097 
1098     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1099     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1100     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1101 
1102     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1103     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1104     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1105 
1106 
1107     constructor (
1108         
1109     ) public payable ERC20() {
1110         // register the supported interfaces to conform to ERC1363 via ERC165
1111         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1112         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1113     }
1114 
1115     /**
1116      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1117      * @param to The address to transfer to.
1118      * @param value The amount to be transferred.
1119      * @return A boolean that indicates if the operation was successful.
1120      */
1121     function transferAndCall(address to, uint256 value) public override returns (bool) {
1122         return transferAndCall(to, value, "");
1123     }
1124 
1125     /**
1126      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1127      * @param to The address to transfer to
1128      * @param value The amount to be transferred
1129      * @param data Additional data with no specified format
1130      * @return A boolean that indicates if the operation was successful.
1131      */
1132     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1133         transfer(to, value);
1134         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1135         return true;
1136     }
1137 
1138     /**
1139      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1140      * @param from The address which you want to send tokens from
1141      * @param to The address which you want to transfer to
1142      * @param value The amount of tokens to be transferred
1143      * @return A boolean that indicates if the operation was successful.
1144      */
1145     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1146         return transferFromAndCall(from, to, value, "");
1147     }
1148 
1149     /**
1150      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1151      * @param from The address which you want to send tokens from
1152      * @param to The address which you want to transfer to
1153      * @param value The amount of tokens to be transferred
1154      * @param data Additional data with no specified format
1155      * @return A boolean that indicates if the operation was successful.
1156      */
1157     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1158         transferFrom(from, to, value);
1159         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1160         return true;
1161     }
1162 
1163     /**
1164      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1165      * @param spender The address allowed to transfer to
1166      * @param value The amount allowed to be transferred
1167      * @return A boolean that indicates if the operation was successful.
1168      */
1169     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1170         return approveAndCall(spender, value, "");
1171     }
1172 
1173     /**
1174      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1175      * @param spender The address allowed to transfer to.
1176      * @param value The amount allowed to be transferred.
1177      * @param data Additional data with no specified format.
1178      * @return A boolean that indicates if the operation was successful.
1179      */
1180     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1181         approve(spender, value);
1182         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1183         return true;
1184     }
1185 
1186     /**
1187      * @dev Internal function to invoke `onTransferReceived` on a target address
1188      *  The call is not executed if the target address is not a contract
1189      * @param from address Representing the previous owner of the given token value
1190      * @param to address Target address that will receive the tokens
1191      * @param value uint256 The amount mount of tokens to be transferred
1192      * @param data bytes Optional data to send along with the call
1193      * @return whether the call correctly returned the expected magic value
1194      */
1195     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
1196         if (!to.isContract()) {
1197             return false;
1198         }
1199         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1200             _msgSender(), from, value, data
1201         );
1202         return (retval == _ERC1363_RECEIVED);
1203     }
1204 
1205     /**
1206      * @dev Internal function to invoke `onApprovalReceived` on a target address
1207      *  The call is not executed if the target address is not a contract
1208      * @param spender address The address which will spend the funds
1209      * @param value uint256 The amount of tokens to be spent
1210      * @param data bytes Optional data to send along with the call
1211      * @return whether the call correctly returned the expected magic value
1212      */
1213     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1214         if (!spender.isContract()) {
1215             return false;
1216         }
1217         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1218             _msgSender(), value, data
1219         );
1220         return (retval == _ERC1363_APPROVED);
1221     }
1222 }
1223 
1224 
1225 /* @file = ./access/Ownable.sol */
1226 
1227 
1228 
1229 pragma solidity ^0.6.0;
1230 
1231 
1232 /**
1233  * @dev Contract module which provides a basic access control mechanism, where
1234  * there is an account (an owner) that can be granted exclusive access to
1235  * specific functions.
1236  *
1237  * By default, the owner account will be the one that deploys the contract. This
1238  * can later be changed with {transferOwnership}.
1239  *
1240  * This module is used through inheritance. It will make available the modifier
1241  * `onlyOwner`, which can be applied to your functions to restrict their use to
1242  * the owner.
1243  */
1244 contract Ownable is Context {
1245     address private _owner;
1246 
1247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1248 
1249     /**
1250      * @dev Initializes the contract setting the deployer as the initial owner.
1251      */
1252     constructor () internal {
1253         address msgSender = _msgSender();
1254         _owner = msgSender;
1255         emit OwnershipTransferred(address(0), msgSender);
1256     }
1257 
1258     /**
1259      * @dev Returns the address of the current owner.
1260      */
1261     function owner() public view returns (address) {
1262         return _owner;
1263     }
1264 
1265     /**
1266      * @dev Throws if called by any account other than the owner.
1267      */
1268     modifier onlyOwner() {
1269         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1270         _;
1271     }
1272 
1273     /**
1274      * @dev Leaves the contract without owner. It will not be possible to call
1275      * `onlyOwner` functions anymore. Can only be called by the current owner.
1276      *
1277      * NOTE: Renouncing ownership will leave the contract without an owner,
1278      * thereby removing any functionality that is only available to the owner.
1279      */
1280     function renounceOwnership() public virtual onlyOwner {
1281         emit OwnershipTransferred(_owner, address(0));
1282         _owner = address(0);
1283     }
1284 
1285     /**
1286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1287      * Can only be called by the current owner.
1288      */
1289     function transferOwnership(address newOwner) public virtual onlyOwner {
1290         require(newOwner != address(0), "Ownable: new owner is the zero address");
1291         emit OwnershipTransferred(_owner, newOwner);
1292         _owner = newOwner;
1293     }
1294 }
1295 
1296 /* @file = ./TokenRecover.sol */
1297 
1298 
1299 
1300 pragma solidity ^0.6.0;
1301 
1302 
1303 /**
1304  * @title TokenRecover
1305  * @author Vittorio Minacori (https://github.com/vittominacori)
1306  * @dev Allow to recover any ERC20 sent into the contract for error
1307  */
1308 contract TokenRecover is Ownable {
1309 
1310     /**
1311      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1312      * @param tokenAddress The token contract address
1313      * @param tokenAmount Number of tokens to be sent
1314      */
1315     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1316         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1317     }
1318 }
1319 
1320 
1321 
1322 
1323 
1324 /* @file = ./utils/EnumerableSet.sol */
1325 
1326 
1327 
1328 pragma solidity ^0.6.0;
1329 
1330 /**
1331  * @dev Library for managing
1332  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1333  * types.
1334  *
1335  * Sets have the following properties:
1336  *
1337  * - Elements are added, removed, and checked for existence in constant time
1338  * (O(1)).
1339  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1340  *
1341  * ```
1342  * contract Example {
1343  *     // Add the library methods
1344  *     using EnumerableSet for EnumerableSet.AddressSet;
1345  *
1346  *     // Declare a set state variable
1347  *     EnumerableSet.AddressSet private mySet;
1348  * }
1349  * ```
1350  *
1351  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1352  * (`UintSet`) are supported.
1353  */
1354 library EnumerableSet {
1355     // To implement this library for multiple types with as little code
1356     // repetition as possible, we write it in terms of a generic Set type with
1357     // bytes32 values.
1358     // The Set implementation uses private functions, and user-facing
1359     // implementations (such as AddressSet) are just wrappers around the
1360     // underlying Set.
1361     // This means that we can only create new EnumerableSets for types that fit
1362     // in bytes32.
1363 
1364     struct Set {
1365         // Storage of set values
1366         bytes32[] _values;
1367 
1368         // Position of the value in the `values` array, plus 1 because index 0
1369         // means a value is not in the set.
1370         mapping (bytes32 => uint256) _indexes;
1371     }
1372 
1373     /**
1374      * @dev Add a value to a set. O(1).
1375      *
1376      * Returns true if the value was added to the set, that is if it was not
1377      * already present.
1378      */
1379     function _add(Set storage set, bytes32 value) private returns (bool) {
1380         if (!_contains(set, value)) {
1381             set._values.push(value);
1382             // The value is stored at length-1, but we add 1 to all indexes
1383             // and use 0 as a sentinel value
1384             set._indexes[value] = set._values.length;
1385             return true;
1386         } else {
1387             return false;
1388         }
1389     }
1390 
1391     /**
1392      * @dev Removes a value from a set. O(1).
1393      *
1394      * Returns true if the value was removed from the set, that is if it was
1395      * present.
1396      */
1397     function _remove(Set storage set, bytes32 value) private returns (bool) {
1398         // We read and store the value's index to prevent multiple reads from the same storage slot
1399         uint256 valueIndex = set._indexes[value];
1400 
1401         if (valueIndex != 0) { // Equivalent to contains(set, value)
1402             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1403             // the array, and then remove the last element (sometimes called as 'swap and pop').
1404             // This modifies the order of the array, as noted in {at}.
1405 
1406             uint256 toDeleteIndex = valueIndex - 1;
1407             uint256 lastIndex = set._values.length - 1;
1408 
1409             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1410             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1411 
1412             bytes32 lastvalue = set._values[lastIndex];
1413 
1414             // Move the last value to the index where the value to delete is
1415             set._values[toDeleteIndex] = lastvalue;
1416             // Update the index for the moved value
1417             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1418 
1419             // Delete the slot where the moved value was stored
1420             set._values.pop();
1421 
1422             // Delete the index for the deleted slot
1423             delete set._indexes[value];
1424 
1425             return true;
1426         } else {
1427             return false;
1428         }
1429     }
1430 
1431     /**
1432      * @dev Returns true if the value is in the set. O(1).
1433      */
1434     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1435         return set._indexes[value] != 0;
1436     }
1437 
1438     /**
1439      * @dev Returns the number of values on the set. O(1).
1440      */
1441     function _length(Set storage set) private view returns (uint256) {
1442         return set._values.length;
1443     }
1444 
1445    /**
1446     * @dev Returns the value stored at position `index` in the set. O(1).
1447     *
1448     * Note that there are no guarantees on the ordering of values inside the
1449     * array, and it may change when more values are added or removed.
1450     *
1451     * Requirements:
1452     *
1453     * - `index` must be strictly less than {length}.
1454     */
1455     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1456         require(set._values.length > index, "EnumerableSet: index out of bounds");
1457         return set._values[index];
1458     }
1459 
1460     // AddressSet
1461 
1462     struct AddressSet {
1463         Set _inner;
1464     }
1465 
1466     /**
1467      * @dev Add a value to a set. O(1).
1468      *
1469      * Returns true if the value was added to the set, that is if it was not
1470      * already present.
1471      */
1472     function add(AddressSet storage set, address value) internal returns (bool) {
1473         return _add(set._inner, bytes32(uint256(value)));
1474     }
1475 
1476     /**
1477      * @dev Removes a value from a set. O(1).
1478      *
1479      * Returns true if the value was removed from the set, that is if it was
1480      * present.
1481      */
1482     function remove(AddressSet storage set, address value) internal returns (bool) {
1483         return _remove(set._inner, bytes32(uint256(value)));
1484     }
1485 
1486     /**
1487      * @dev Returns true if the value is in the set. O(1).
1488      */
1489     function contains(AddressSet storage set, address value) internal view returns (bool) {
1490         return _contains(set._inner, bytes32(uint256(value)));
1491     }
1492 
1493     /**
1494      * @dev Returns the number of values in the set. O(1).
1495      */
1496     function length(AddressSet storage set) internal view returns (uint256) {
1497         return _length(set._inner);
1498     }
1499 
1500    /**
1501     * @dev Returns the value stored at position `index` in the set. O(1).
1502     *
1503     * Note that there are no guarantees on the ordering of values inside the
1504     * array, and it may change when more values are added or removed.
1505     *
1506     * Requirements:
1507     *
1508     * - `index` must be strictly less than {length}.
1509     */
1510     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1511         return address(uint256(_at(set._inner, index)));
1512     }
1513 
1514 
1515     // UintSet
1516 
1517     struct UintSet {
1518         Set _inner;
1519     }
1520 
1521     /**
1522      * @dev Add a value to a set. O(1).
1523      *
1524      * Returns true if the value was added to the set, that is if it was not
1525      * already present.
1526      */
1527     function add(UintSet storage set, uint256 value) internal returns (bool) {
1528         return _add(set._inner, bytes32(value));
1529     }
1530 
1531     /**
1532      * @dev Removes a value from a set. O(1).
1533      *
1534      * Returns true if the value was removed from the set, that is if it was
1535      * present.
1536      */
1537     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1538         return _remove(set._inner, bytes32(value));
1539     }
1540 
1541     /**
1542      * @dev Returns true if the value is in the set. O(1).
1543      */
1544     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1545         return _contains(set._inner, bytes32(value));
1546     }
1547 
1548     /**
1549      * @dev Returns the number of values on the set. O(1).
1550      */
1551     function length(UintSet storage set) internal view returns (uint256) {
1552         return _length(set._inner);
1553     }
1554 
1555    /**
1556     * @dev Returns the value stored at position `index` in the set. O(1).
1557     *
1558     * Note that there are no guarantees on the ordering of values inside the
1559     * array, and it may change when more values are added or removed.
1560     *
1561     * Requirements:
1562     *
1563     * - `index` must be strictly less than {length}.
1564     */
1565     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1566         return uint256(_at(set._inner, index));
1567     }
1568 }
1569 
1570 
1571 /* @file = ./access/AccessControl.sol */
1572 
1573 
1574 
1575 pragma solidity ^0.6.0;
1576 
1577 
1578 
1579 /**
1580  * @dev Contract module that allows children to implement role-based access
1581  * control mechanisms.
1582  *
1583  * Roles are referred to by their `bytes32` identifier. These should be exposed
1584  * in the external API and be unique. The best way to achieve this is by
1585  * using `public constant` hash digests:
1586  *
1587  * ```
1588  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1589  * ```
1590  *
1591  * Roles can be used to represent a set of permissions. To restrict access to a
1592  * function call, use {hasRole}:
1593  *
1594  * ```
1595  * function foo() public {
1596  *     require(hasRole(MY_ROLE, _msgSender()));
1597  *     ...
1598  * }
1599  * ```
1600  *
1601  * Roles can be granted and revoked dynamically via the {grantRole} and
1602  * {revokeRole} functions. Each role has an associated admin role, and only
1603  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1604  *
1605  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1606  * that only accounts with this role will be able to grant or revoke other
1607  * roles. More complex role relationships can be created by using
1608  * {_setRoleAdmin}.
1609  */
1610 abstract contract AccessControl is Context {
1611     using EnumerableSet for EnumerableSet.AddressSet;
1612     using Address for address;
1613 
1614     struct RoleData {
1615         EnumerableSet.AddressSet members;
1616         bytes32 adminRole;
1617     }
1618 
1619     mapping (bytes32 => RoleData) private _roles;
1620 
1621     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1622 
1623     /**
1624      * @dev Emitted when `account` is granted `role`.
1625      *
1626      * `sender` is the account that originated the contract call, an admin role
1627      * bearer except when using {_setupRole}.
1628      */
1629     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1630 
1631     /**
1632      * @dev Emitted when `account` is revoked `role`.
1633      *
1634      * `sender` is the account that originated the contract call:
1635      *   - if using `revokeRole`, it is the admin role bearer
1636      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1637      */
1638     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1639 
1640     /**
1641      * @dev Returns `true` if `account` has been granted `role`.
1642      */
1643     function hasRole(bytes32 role, address account) public view returns (bool) {
1644         return _roles[role].members.contains(account);
1645     }
1646 
1647     /**
1648      * @dev Returns the number of accounts that have `role`. Can be used
1649      * together with {getRoleMember} to enumerate all bearers of a role.
1650      */
1651     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1652         return _roles[role].members.length();
1653     }
1654 
1655     /**
1656      * @dev Returns one of the accounts that have `role`. `index` must be a
1657      * value between 0 and {getRoleMemberCount}, non-inclusive.
1658      *
1659      * Role bearers are not sorted in any particular way, and their ordering may
1660      * change at any point.
1661      *
1662      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1663      * you perform all queries on the same block. See the following
1664      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1665      * for more information.
1666      */
1667     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1668         return _roles[role].members.at(index);
1669     }
1670 
1671     /**
1672      * @dev Returns the admin role that controls `role`. See {grantRole} and
1673      * {revokeRole}.
1674      *
1675      * To change a role's admin, use {_setRoleAdmin}.
1676      */
1677     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1678         return _roles[role].adminRole;
1679     }
1680 
1681     /**
1682      * @dev Grants `role` to `account`.
1683      *
1684      * If `account` had not been already granted `role`, emits a {RoleGranted}
1685      * event.
1686      *
1687      * Requirements:
1688      *
1689      * - the caller must have ``role``'s admin role.
1690      */
1691     function grantRole(bytes32 role, address account) public virtual {
1692         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1693 
1694         _grantRole(role, account);
1695     }
1696 
1697     /**
1698      * @dev Revokes `role` from `account`.
1699      *
1700      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1701      *
1702      * Requirements:
1703      *
1704      * - the caller must have ``role``'s admin role.
1705      */
1706     function revokeRole(bytes32 role, address account) public virtual {
1707         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1708 
1709         _revokeRole(role, account);
1710     }
1711 
1712     /**
1713      * @dev Revokes `role` from the calling account.
1714      *
1715      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1716      * purpose is to provide a mechanism for accounts to lose their privileges
1717      * if they are compromised (such as when a trusted device is misplaced).
1718      *
1719      * If the calling account had been granted `role`, emits a {RoleRevoked}
1720      * event.
1721      *
1722      * Requirements:
1723      *
1724      * - the caller must be `account`.
1725      */
1726     function renounceRole(bytes32 role, address account) public virtual {
1727         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1728 
1729         _revokeRole(role, account);
1730     }
1731 
1732     /**
1733      * @dev Grants `role` to `account`.
1734      *
1735      * If `account` had not been already granted `role`, emits a {RoleGranted}
1736      * event. Note that unlike {grantRole}, this function doesn't perform any
1737      * checks on the calling account.
1738      *
1739      * [WARNING]
1740      * ====
1741      * This function should only be called from the constructor when setting
1742      * up the initial roles for the system.
1743      *
1744      * Using this function in any other way is effectively circumventing the admin
1745      * system imposed by {AccessControl}.
1746      * ====
1747      */
1748     function _setupRole(bytes32 role, address account) internal virtual {
1749         _grantRole(role, account);
1750     }
1751 
1752     /**
1753      * @dev Sets `adminRole` as ``role``'s admin role.
1754      */
1755     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1756         _roles[role].adminRole = adminRole;
1757     }
1758 
1759     function _grantRole(bytes32 role, address account) private {
1760         if (_roles[role].members.add(account)) {
1761             emit RoleGranted(role, account, _msgSender());
1762         }
1763     }
1764 
1765     function _revokeRole(bytes32 role, address account) private {
1766         if (_roles[role].members.remove(account)) {
1767             emit RoleRevoked(role, account, _msgSender());
1768         }
1769     }
1770 }
1771 
1772 
1773 
1774 /* @file = ./access/Roles.sol */
1775 
1776 
1777 
1778 pragma solidity ^0.6.0;
1779 
1780 
1781 contract Roles is AccessControl {
1782 
1783     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1784     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1785 
1786     constructor () public {
1787         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1788         _setupRole(MINTER_ROLE, _msgSender());
1789         _setupRole(OPERATOR_ROLE, _msgSender());
1790     }
1791 
1792     modifier onlyMinter() {
1793         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1794         _;
1795     }
1796 
1797     modifier onlyOperator() {
1798         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1799         _;
1800     }
1801 }
1802 
1803 
1804 
1805 /**
1806  * Part of the code written below was work of Vittorio Minacori
1807  * https://github.com/vittominacori
1808  */
1809  
1810  
1811 
1812 /**
1813  * @title OM Lira
1814  * @author Osman Kuzucu (https://omlira.com)
1815  * @dev Implementation of the BaseToken for OM Lira
1816  */
1817  
1818  
1819  /* @file = ./OMLira.sol */
1820 
1821 
1822 
1823 contract OMLira is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {
1824 
1825     // indicates if minting is finished
1826     bool private _mintingFinished = false;
1827 
1828     // indicates if transfer is enabled
1829     bool private _transferEnabled = false;
1830     
1831     string public constant OLUSTURAN = "omlira.com - OM Lira";
1832     string public constant _imza = "Yerli ve milli teknoloji guclu Turkiye";
1833 
1834 
1835 
1836     /**
1837      * @dev Emitted during finish minting
1838      */
1839     event MintFinished();
1840 
1841     /**
1842      * @dev Emitted during transfer enabling
1843      */
1844     event TransferEnabled();
1845     
1846     /**
1847      * @dev Tokens can be minted only before minting finished.
1848      */
1849     modifier canMint() {
1850         require(!_mintingFinished, "OMLira: token basimi tamamlandi");
1851         _;
1852     }
1853 
1854     /**
1855      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1856      */
1857     modifier canTransfer(address from) {
1858         require(
1859             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1860             "OMLira: transfer aktif degil ya da OPERATOR yetkisine sahip degilsiniz."
1861         );
1862         _;
1863     }
1864 
1865 
1866     constructor()
1867         public
1868         ERC20Capped()
1869         ERC1363()
1870     {
1871         
1872 
1873         _setupDecimals(18);
1874 
1875         
1876         _mint(owner(), 1000000000000000000000000000);
1877         finishMinting();
1878         
1879     }
1880 
1881 
1882     
1883 
1884     /**
1885      * @dev Function to mint tokens.
1886      * @param to The address that will receive the minted tokens
1887      * @param value The amount of tokens to mint
1888      */
1889     function mint(address to, uint256 value) public canMint onlyMinter {
1890         _mint(to, value);
1891     }
1892 
1893     /**
1894      * @dev Transfer tokens to a specified address.
1895      * @param to The address to transfer to
1896      * @param value The amount to be transferred
1897      * @return A boolean that indicates if the operation was successful.
1898      */
1899     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
1900         return super.transfer(to, value);
1901     }
1902 
1903     /**
1904      * @dev Transfer tokens from one address to another.
1905      * @param from The address which you want to send tokens from
1906      * @param to The address which you want to transfer to
1907      * @param value the amount of tokens to be transferred
1908      * @return A boolean that indicates if the operation was successful.
1909      */
1910     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
1911         return super.transferFrom(from, to, value);
1912     }
1913 
1914     /**
1915      * @dev Function to stop minting new tokens.
1916      */
1917     function finishMinting() public canMint onlyOwner {
1918         _mintingFinished = true;
1919 
1920         emit MintFinished();
1921     }
1922 
1923     /**
1924      * @dev Function to enable transfers.
1925      */
1926     function enableTransfer() public onlyOwner {
1927         _transferEnabled = true;
1928 
1929         emit TransferEnabled();
1930     }
1931     
1932     /**
1933      * @dev Function to disable transfers if required.
1934      */
1935     function disableTransfer() public onlyOwner {
1936         _transferEnabled = false;
1937         
1938         emit TransferEnabled();
1939     }
1940 
1941     /**
1942      * @dev See {ERC20-_beforeTokenTransfer}.
1943      */
1944     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1945         super._beforeTokenTransfer(from, to, amount);
1946     }
1947 }