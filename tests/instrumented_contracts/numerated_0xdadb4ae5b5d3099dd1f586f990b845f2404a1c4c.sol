1 /**
2 
3 
4 Website: https://www.lenny-coin.com/
5 
6 Twitter: https://twitter.com/Lennyface_coin
7 
8 Telegram: https://t.me/LennyFaceCoin
9 
10 
11 */
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.10;
14 pragma experimental ABIEncoderV2;
15 
16 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
17 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
18 
19 /* pragma solidity ^0.8.0; */
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
42 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
43 
44 /* pragma solidity ^0.8.0; */
45 
46 /* import "../utils/Context.sol"; */
47 
48 /**
49  * @dev Contract module which provides a basic access control mechanism, where
50  * there is an account (an owner) that can be granted exclusive access to
51  * specific functions.
52  *
53  * By default, the owner account will be the one that deploys the contract. This
54  * can later be changed with {transferOwnership}.
55  *
56  * This module is used through inheritance. It will make available the modifier
57  * `onlyOwner`, which can be applied to your functions to restrict their use to
58  * the owner.
59  */
60 abstract contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public virtual onlyOwner {
95         _transferOwnership(address(0));
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Internal function without access restriction.
110      */
111     function _transferOwnership(address newOwner) internal virtual {
112         address oldOwner = _owner;
113         _owner = newOwner;
114         emit OwnershipTransferred(oldOwner, newOwner);
115     }
116 }
117 
118 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
119 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
120 
121 /* pragma solidity ^0.8.0; */
122 
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP.
125  */
126 interface IERC20 {
127     /**
128      * @dev Returns the amount of tokens in existence.
129      */
130     function totalSupply() external view returns (uint256);
131 
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `recipient`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address recipient, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `sender` to `recipient` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) external returns (bool);
185 
186     /**
187      * @dev Emitted when `value` tokens are moved from one account (`from`) to
188      * another (`to`).
189      *
190      * Note that `value` may be zero.
191      */
192     event Transfer(address indexed from, address indexed to, uint256 value);
193 
194     /**
195      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
196      * a call to {approve}. `value` is the new allowance.
197      */
198     event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
202 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
203 
204 /* pragma solidity ^0.8.0; */
205 
206 /* import "../IERC20.sol"; */
207 
208 /**
209  * @dev Interface for the optional metadata functions from the ERC20 standard.
210  *
211  * _Available since v4.1._
212  */
213 interface IERC20Metadata is IERC20 {
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the symbol of the token.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the decimals places of the token.
226      */
227     function decimals() external view returns (uint8);
228 }
229 
230 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
231 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
232 
233 /* pragma solidity ^0.8.0; */
234 
235 /* import "./IERC20.sol"; */
236 /* import "./extensions/IERC20Metadata.sol"; */
237 /* import "../../utils/Context.sol"; */
238 
239 /**
240  * @dev Implementation of the {IERC20} interface.
241  *
242  * This implementation is agnostic to the way tokens are created. This means
243  * that a supply mechanism has to be added in a derived contract using {_mint}.
244  * For a generic mechanism see {ERC20PresetMinterPauser}.
245  *
246  * TIP: For a detailed writeup see our guide
247  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
248  * to implement supply mechanisms].
249  *
250  * We have followed general OpenZeppelin Contracts guidelines: functions revert
251  * instead returning `false` on failure. This behavior is nonetheless
252  * conventional and does not conflict with the expectations of ERC20
253  * applications.
254  *
255  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
256  * This allows applications to reconstruct the allowance for all accounts just
257  * by listening to said events. Other implementations of the EIP may not emit
258  * these events, as it isn't required by the specification.
259  *
260  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
261  * functions have been added to mitigate the well-known issues around setting
262  * allowances. See {IERC20-approve}.
263  */
264 contract ERC20 is Context, IERC20, IERC20Metadata {
265     mapping(address => uint256) private _balances;
266 
267     mapping(address => mapping(address => uint256)) private _allowances;
268 
269     uint256 private _totalSupply;
270 
271     string private _name;
272     string private _symbol;
273 
274     /**
275      * @dev Sets the values for {name} and {symbol}.
276      *
277      * The default value of {decimals} is 18. To select a different value for
278      * {decimals} you should overload it.
279      *
280      * All two of these values are immutable: they can only be set once during
281      * construction.
282      */
283     constructor(string memory name_, string memory symbol_) {
284         _name = name_;
285         _symbol = symbol_;
286     }
287 
288     /**
289      * @dev Returns the name of the token.
290      */
291     function name() public view virtual override returns (string memory) {
292         return _name;
293     }
294 
295     /**
296      * @dev Returns the symbol of the token, usually a shorter version of the
297      * name.
298      */
299     function symbol() public view virtual override returns (string memory) {
300         return _symbol;
301     }
302 
303     /**
304      * @dev Returns the number of decimals used to get its user representation.
305      * For example, if `decimals` equals `2`, a balance of `505` tokens should
306      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
307      *
308      * Tokens usually opt for a value of 18, imitating the relationship between
309      * Ether and Wei. This is the value {ERC20} uses, unless this function is
310      * overridden;
311      *
312      * NOTE: This information is only used for _display_ purposes: it in
313      * no way affects any of the arithmetic of the contract, including
314      * {IERC20-balanceOf} and {IERC20-transfer}.
315      */
316     function decimals() public view virtual override returns (uint8) {
317         return 18;
318     }
319 
320     /**
321      * @dev See {IERC20-totalSupply}.
322      */
323     function totalSupply() public view virtual override returns (uint256) {
324         return _totalSupply;
325     }
326 
327     /**
328      * @dev See {IERC20-balanceOf}.
329      */
330     function balanceOf(address account) public view virtual override returns (uint256) {
331         return _balances[account];
332     }
333 
334     /**
335      * @dev See {IERC20-transfer}.
336      *
337      * Requirements:
338      *
339      * - `recipient` cannot be the zero address.
340      * - the caller must have a balance of at least `amount`.
341      */
342     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
343         _transfer(_msgSender(), recipient, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-allowance}.
349      */
350     function allowance(address owner, address spender) public view virtual override returns (uint256) {
351         return _allowances[owner][spender];
352     }
353 
354     /**
355      * @dev See {IERC20-approve}.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function approve(address spender, uint256 amount) public virtual override returns (bool) {
362         _approve(_msgSender(), spender, amount);
363         return true;
364     }
365 
366     /**
367      * @dev See {IERC20-transferFrom}.
368      *
369      * Emits an {Approval} event indicating the updated allowance. This is not
370      * required by the EIP. See the note at the beginning of {ERC20}.
371      *
372      * Requirements:
373      *
374      * - `sender` and `recipient` cannot be the zero address.
375      * - `sender` must have a balance of at least `amount`.
376      * - the caller must have allowance for ``sender``'s tokens of at least
377      * `amount`.
378      */
379     function transferFrom(
380         address sender,
381         address recipient,
382         uint256 amount
383     ) public virtual override returns (bool) {
384         _transfer(sender, recipient, amount);
385 
386         uint256 currentAllowance = _allowances[sender][_msgSender()];
387         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
388         unchecked {
389             _approve(sender, _msgSender(), currentAllowance - amount);
390         }
391 
392         return true;
393     }
394 
395     /**
396      * @dev Atomically increases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
408         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
409         return true;
410     }
411 
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
427         uint256 currentAllowance = _allowances[_msgSender()][spender];
428         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
429         unchecked {
430             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
431         }
432 
433         return true;
434     }
435 
436     /**
437      * @dev Moves `amount` of tokens from `sender` to `recipient`.
438      *
439      * This internal function is equivalent to {transfer}, and can be used to
440      * e.g. implement automatic token fees, slashing mechanisms, etc.
441      *
442      * Emits a {Transfer} event.
443      *
444      * Requirements:
445      *
446      * - `sender` cannot be the zero address.
447      * - `recipient` cannot be the zero address.
448      * - `sender` must have a balance of at least `amount`.
449      */
450     function _transfer(
451         address sender,
452         address recipient,
453         uint256 amount
454     ) internal virtual {
455         require(sender != address(0), "ERC20: transfer from the zero address");
456         require(recipient != address(0), "ERC20: transfer to the zero address");
457 
458         _beforeTokenTransfer(sender, recipient, amount);
459 
460         uint256 senderBalance = _balances[sender];
461         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
462         unchecked {
463             _balances[sender] = senderBalance - amount;
464         }
465         _balances[recipient] += amount;
466 
467         emit Transfer(sender, recipient, amount);
468 
469         _afterTokenTransfer(sender, recipient, amount);
470     }
471 
472     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
473      * the total supply.
474      *
475      * Emits a {Transfer} event with `from` set to the zero address.
476      *
477      * Requirements:
478      *
479      * - `account` cannot be the zero address.
480      */
481     function _mint(address account, uint256 amount) internal virtual {
482         require(account != address(0), "ERC20: mint to the zero address");
483 
484         _beforeTokenTransfer(address(0), account, amount);
485 
486         _totalSupply += amount;
487         _balances[account] += amount;
488         emit Transfer(address(0), account, amount);
489 
490         _afterTokenTransfer(address(0), account, amount);
491     }
492 
493     /**
494      * @dev Destroys `amount` tokens from `account`, reducing the
495      * total supply.
496      *
497      * Emits a {Transfer} event with `to` set to the zero address.
498      *
499      * Requirements:
500      *
501      * - `account` cannot be the zero address.
502      * - `account` must have at least `amount` tokens.
503      */
504     function _burn(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: burn from the zero address");
506 
507         _beforeTokenTransfer(account, address(0), amount);
508 
509         uint256 accountBalance = _balances[account];
510         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
511         unchecked {
512             _balances[account] = accountBalance - amount;
513         }
514         _totalSupply -= amount;
515 
516         emit Transfer(account, address(0), amount);
517 
518         _afterTokenTransfer(account, address(0), amount);
519     }
520 
521     /**
522      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
523      *
524      * This internal function is equivalent to `approve`, and can be used to
525      * e.g. set automatic allowances for certain subsystems, etc.
526      *
527      * Emits an {Approval} event.
528      *
529      * Requirements:
530      *
531      * - `owner` cannot be the zero address.
532      * - `spender` cannot be the zero address.
533      */
534     function _approve(
535         address owner,
536         address spender,
537         uint256 amount
538     ) internal virtual {
539         require(owner != address(0), "ERC20: approve from the zero address");
540         require(spender != address(0), "ERC20: approve to the zero address");
541 
542         _allowances[owner][spender] = amount;
543         emit Approval(owner, spender, amount);
544     }
545 
546     /**
547      * @dev Hook that is called before any transfer of tokens. This includes
548      * minting and burning.
549      *
550      * Calling conditions:
551      *
552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
553      * will be transferred to `to`.
554      * - when `from` is zero, `amount` tokens will be minted for `to`.
555      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
556      * - `from` and `to` are never both zero.
557      *
558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
559      */
560     function _beforeTokenTransfer(
561         address from,
562         address to,
563         uint256 amount
564     ) internal virtual {}
565 
566     /**
567      * @dev Hook that is called after any transfer of tokens. This includes
568      * minting and burning.
569      *
570      * Calling conditions:
571      *
572      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
573      * has been transferred to `to`.
574      * - when `from` is zero, `amount` tokens have been minted for `to`.
575      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
576      * - `from` and `to` are never both zero.
577      *
578      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
579      */
580     function _afterTokenTransfer(
581         address from,
582         address to,
583         uint256 amount
584     ) internal virtual {}
585 }
586 
587 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
588 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
589 
590 /* pragma solidity ^0.8.0; */
591 
592 // CAUTION
593 // This version of SafeMath should only be used with Solidity 0.8 or later,
594 // because it relies on the compiler's built in overflow checks.
595 
596 /**
597  * @dev Wrappers over Solidity's arithmetic operations.
598  *
599  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
600  * now has built in overflow checking.
601  */
602 library SafeMath {
603     /**
604      * @dev Returns the addition of two unsigned integers, with an overflow flag.
605      *
606      * _Available since v3.4._
607      */
608     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
609         unchecked {
610             uint256 c = a + b;
611             if (c < a) return (false, 0);
612             return (true, c);
613         }
614     }
615 
616     /**
617      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
618      *
619      * _Available since v3.4._
620      */
621     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
622         unchecked {
623             if (b > a) return (false, 0);
624             return (true, a - b);
625         }
626     }
627 
628     /**
629      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
630      *
631      * _Available since v3.4._
632      */
633     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
634         unchecked {
635             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
636             // benefit is lost if 'b' is also tested.
637             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
638             if (a == 0) return (true, 0);
639             uint256 c = a * b;
640             if (c / a != b) return (false, 0);
641             return (true, c);
642         }
643     }
644 
645     /**
646      * @dev Returns the division of two unsigned integers, with a division by zero flag.
647      *
648      * _Available since v3.4._
649      */
650     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
651         unchecked {
652             if (b == 0) return (false, 0);
653             return (true, a / b);
654         }
655     }
656 
657     /**
658      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
659      *
660      * _Available since v3.4._
661      */
662     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
663         unchecked {
664             if (b == 0) return (false, 0);
665             return (true, a % b);
666         }
667     }
668 
669     /**
670      * @dev Returns the addition of two unsigned integers, reverting on
671      * overflow.
672      *
673      * Counterpart to Solidity's `+` operator.
674      *
675      * Requirements:
676      *
677      * - Addition cannot overflow.
678      */
679     function add(uint256 a, uint256 b) internal pure returns (uint256) {
680         return a + b;
681     }
682 
683     /**
684      * @dev Returns the subtraction of two unsigned integers, reverting on
685      * overflow (when the result is negative).
686      *
687      * Counterpart to Solidity's `-` operator.
688      *
689      * Requirements:
690      *
691      * - Subtraction cannot overflow.
692      */
693     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a - b;
695     }
696 
697     /**
698      * @dev Returns the multiplication of two unsigned integers, reverting on
699      * overflow.
700      *
701      * Counterpart to Solidity's `*` operator.
702      *
703      * Requirements:
704      *
705      * - Multiplication cannot overflow.
706      */
707     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a * b;
709     }
710 
711     /**
712      * @dev Returns the integer division of two unsigned integers, reverting on
713      * division by zero. The result is rounded towards zero.
714      *
715      * Counterpart to Solidity's `/` operator.
716      *
717      * Requirements:
718      *
719      * - The divisor cannot be zero.
720      */
721     function div(uint256 a, uint256 b) internal pure returns (uint256) {
722         return a / b;
723     }
724 
725     /**
726      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
727      * reverting when dividing by zero.
728      *
729      * Counterpart to Solidity's `%` operator. This function uses a `revert`
730      * opcode (which leaves remaining gas untouched) while Solidity uses an
731      * invalid opcode to revert (consuming all remaining gas).
732      *
733      * Requirements:
734      *
735      * - The divisor cannot be zero.
736      */
737     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
738         return a % b;
739     }
740 
741     /**
742      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
743      * overflow (when the result is negative).
744      *
745      * CAUTION: This function is deprecated because it requires allocating memory for the error
746      * message unnecessarily. For custom revert reasons use {trySub}.
747      *
748      * Counterpart to Solidity's `-` operator.
749      *
750      * Requirements:
751      *
752      * - Subtraction cannot overflow.
753      */
754     function sub(
755         uint256 a,
756         uint256 b,
757         string memory errorMessage
758     ) internal pure returns (uint256) {
759         unchecked {
760             require(b <= a, errorMessage);
761             return a - b;
762         }
763     }
764 
765     /**
766      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
767      * division by zero. The result is rounded towards zero.
768      *
769      * Counterpart to Solidity's `/` operator. Note: this function uses a
770      * `revert` opcode (which leaves remaining gas untouched) while Solidity
771      * uses an invalid opcode to revert (consuming all remaining gas).
772      *
773      * Requirements:
774      *
775      * - The divisor cannot be zero.
776      */
777     function div(
778         uint256 a,
779         uint256 b,
780         string memory errorMessage
781     ) internal pure returns (uint256) {
782         unchecked {
783             require(b > 0, errorMessage);
784             return a / b;
785         }
786     }
787 
788     /**
789      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
790      * reverting with custom message when dividing by zero.
791      *
792      * CAUTION: This function is deprecated because it requires allocating memory for the error
793      * message unnecessarily. For custom revert reasons use {tryMod}.
794      *
795      * Counterpart to Solidity's `%` operator. This function uses a `revert`
796      * opcode (which leaves remaining gas untouched) while Solidity uses an
797      * invalid opcode to revert (consuming all remaining gas).
798      *
799      * Requirements:
800      *
801      * - The divisor cannot be zero.
802      */
803     function mod(
804         uint256 a,
805         uint256 b,
806         string memory errorMessage
807     ) internal pure returns (uint256) {
808         unchecked {
809             require(b > 0, errorMessage);
810             return a % b;
811         }
812     }
813 }
814 
815 ////// src/IUniswapV2Factory.sol
816 /* pragma solidity 0.8.10; */
817 /* pragma experimental ABIEncoderV2; */
818 
819 interface IUniswapV2Factory {
820     event PairCreated(
821         address indexed token0,
822         address indexed token1,
823         address pair,
824         uint256
825     );
826 
827     function feeTo() external view returns (address);
828 
829     function feeToSetter() external view returns (address);
830 
831     function getPair(address tokenA, address tokenB)
832         external
833         view
834         returns (address pair);
835 
836     function allPairs(uint256) external view returns (address pair);
837 
838     function allPairsLength() external view returns (uint256);
839 
840     function createPair(address tokenA, address tokenB)
841         external
842         returns (address pair);
843 
844     function setFeeTo(address) external;
845 
846     function setFeeToSetter(address) external;
847 }
848 
849 ////// src/IUniswapV2Pair.sol
850 /* pragma solidity 0.8.10; */
851 /* pragma experimental ABIEncoderV2; */
852 
853 interface IUniswapV2Pair {
854     event Approval(
855         address indexed owner,
856         address indexed spender,
857         uint256 value
858     );
859     event Transfer(address indexed from, address indexed to, uint256 value);
860 
861     function name() external pure returns (string memory);
862 
863     function symbol() external pure returns (string memory);
864 
865     function decimals() external pure returns (uint8);
866 
867     function totalSupply() external view returns (uint256);
868 
869     function balanceOf(address owner) external view returns (uint256);
870 
871     function allowance(address owner, address spender)
872         external
873         view
874         returns (uint256);
875 
876     function approve(address spender, uint256 value) external returns (bool);
877 
878     function transfer(address to, uint256 value) external returns (bool);
879 
880     function transferFrom(
881         address from,
882         address to,
883         uint256 value
884     ) external returns (bool);
885 
886     function DOMAIN_SEPARATOR() external view returns (bytes32);
887 
888     function PERMIT_TYPEHASH() external pure returns (bytes32);
889 
890     function nonces(address owner) external view returns (uint256);
891 
892     function permit(
893         address owner,
894         address spender,
895         uint256 value,
896         uint256 deadline,
897         uint8 v,
898         bytes32 r,
899         bytes32 s
900     ) external;
901 
902     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
903     event Burn(
904         address indexed sender,
905         uint256 amount0,
906         uint256 amount1,
907         address indexed to
908     );
909     event Swap(
910         address indexed sender,
911         uint256 amount0In,
912         uint256 amount1In,
913         uint256 amount0Out,
914         uint256 amount1Out,
915         address indexed to
916     );
917     event Sync(uint112 reserve0, uint112 reserve1);
918 
919     function MINIMUM_LIQUIDITY() external pure returns (uint256);
920 
921     function factory() external view returns (address);
922 
923     function token0() external view returns (address);
924 
925     function token1() external view returns (address);
926 
927     function getReserves()
928         external
929         view
930         returns (
931             uint112 reserve0,
932             uint112 reserve1,
933             uint32 blockTimestampLast
934         );
935 
936     function price0CumulativeLast() external view returns (uint256);
937 
938     function price1CumulativeLast() external view returns (uint256);
939 
940     function kLast() external view returns (uint256);
941 
942     function mint(address to) external returns (uint256 liquidity);
943 
944     function burn(address to)
945         external
946         returns (uint256 amount0, uint256 amount1);
947 
948     function swap(
949         uint256 amount0Out,
950         uint256 amount1Out,
951         address to,
952         bytes calldata data
953     ) external;
954 
955     function skim(address to) external;
956 
957     function sync() external;
958 
959     function initialize(address, address) external;
960 }
961 
962 ////// src/IUniswapV2Router02.sol
963 /* pragma solidity 0.8.10; */
964 /* pragma experimental ABIEncoderV2; */
965 
966 interface IUniswapV2Router02 {
967     function factory() external pure returns (address);
968 
969     function WETH() external pure returns (address);
970 
971     function addLiquidity(
972         address tokenA,
973         address tokenB,
974         uint256 amountADesired,
975         uint256 amountBDesired,
976         uint256 amountAMin,
977         uint256 amountBMin,
978         address to,
979         uint256 deadline
980     )
981         external
982         returns (
983             uint256 amountA,
984             uint256 amountB,
985             uint256 liquidity
986         );
987 
988     function addLiquidityETH(
989         address token,
990         uint256 amountTokenDesired,
991         uint256 amountTokenMin,
992         uint256 amountETHMin,
993         address to,
994         uint256 deadline
995     )
996         external
997         payable
998         returns (
999             uint256 amountToken,
1000             uint256 amountETH,
1001             uint256 liquidity
1002         );
1003 
1004     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1005         uint256 amountIn,
1006         uint256 amountOutMin,
1007         address[] calldata path,
1008         address to,
1009         uint256 deadline
1010     ) external;
1011 
1012     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1013         uint256 amountOutMin,
1014         address[] calldata path,
1015         address to,
1016         uint256 deadline
1017     ) external payable;
1018 
1019     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1020         uint256 amountIn,
1021         uint256 amountOutMin,
1022         address[] calldata path,
1023         address to,
1024         uint256 deadline
1025     ) external;
1026 }
1027 
1028 /* pragma solidity >=0.8.10; */
1029 
1030 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1031 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1032 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1033 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1034 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1035 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1036 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1037 
1038 contract LennyFaceCoin is ERC20, Ownable {
1039     using SafeMath for uint256;
1040 
1041     IUniswapV2Router02 public immutable uniswapV2Router;
1042     address public immutable uniswapV2Pair;
1043     address public constant deadAddress = address(0xdead);
1044 
1045     bool private swapping;
1046 
1047     address public marketingWallet;
1048     address public devWallet;
1049 
1050     uint256 public maxTransactionAmount;
1051     uint256 public swapTokensAtAmount;
1052     uint256 public maxWallet;
1053 
1054     uint256 public percentForLPBurn = 25; // 25 = .25%
1055     bool public lpBurnEnabled = true;
1056     uint256 public lpBurnFrequency = 3600 seconds;
1057     uint256 public lastLpBurnTime;
1058 
1059     uint256 public manualBurnFrequency = 30 minutes;
1060     uint256 public lastManualLpBurnTime;
1061 
1062     bool public limitsInEffect = true;
1063     bool public tradingActive = false;
1064     bool public swapEnabled = false;
1065 
1066     // Anti-bot and anti-whale mappings and variables
1067     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1068     bool public transferDelayEnabled = true;
1069 
1070     uint256 public buyTotalFees;
1071     uint256 public buyMarketingFee;
1072     uint256 public buyLiquidityFee;
1073     uint256 public buyDevFee;
1074 
1075     uint256 public sellTotalFees;
1076     uint256 public sellMarketingFee;
1077     uint256 public sellLiquidityFee;
1078     uint256 public sellDevFee;
1079 
1080     uint256 public tokensForMarketing;
1081     uint256 public tokensForLiquidity;
1082     uint256 public tokensForDev;
1083 
1084     /******************/
1085 
1086     // exlcude from fees and max transaction amount
1087     mapping(address => bool) private _isExcludedFromFees;
1088     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1089 
1090     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1091     // could be subject to a maximum transfer amount
1092     mapping(address => bool) public automatedMarketMakerPairs;
1093 
1094     event UpdateUniswapV2Router(
1095         address indexed newAddress,
1096         address indexed oldAddress
1097     );
1098 
1099     event ExcludeFromFees(address indexed account, bool isExcluded);
1100 
1101     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1102 
1103     event marketingWalletUpdated(
1104         address indexed newWallet,
1105         address indexed oldWallet
1106     );
1107 
1108     event devWalletUpdated(
1109         address indexed newWallet,
1110         address indexed oldWallet
1111     );
1112 
1113     event SwapAndLiquify(
1114         uint256 tokensSwapped,
1115         uint256 ethReceived,
1116         uint256 tokensIntoLiquidity
1117     );
1118 
1119     event AutoNukeLP();
1120 
1121     event ManualNukeLP();
1122 
1123     constructor() ERC20("Lenny Face", unicode"( ͡° ͜ʖ ͡°)") {
1124         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1125             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1126         );
1127 
1128         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1129         uniswapV2Router = _uniswapV2Router;
1130 
1131         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1132             .createPair(address(this), _uniswapV2Router.WETH());
1133         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1134         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1135 
1136         uint256 _buyMarketingFee = 0;
1137         uint256 _buyLiquidityFee = 1;
1138         uint256 _buyDevFee = 19;
1139 
1140         uint256 _sellMarketingFee = 0;
1141         uint256 _sellLiquidityFee = 1;
1142         uint256 _sellDevFee = 49;
1143 
1144         uint256 totalSupply = 1_000_000_000 * 1e18;
1145 
1146         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1147         maxWallet = 20_000_000 * 1e18; // 3% from total supply maxWallet
1148         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1149 
1150         buyMarketingFee = _buyMarketingFee;
1151         buyLiquidityFee = _buyLiquidityFee;
1152         buyDevFee = _buyDevFee;
1153         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1154 
1155         sellMarketingFee = _sellMarketingFee;
1156         sellLiquidityFee = _sellLiquidityFee;
1157         sellDevFee = _sellDevFee;
1158         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1159 
1160         marketingWallet = address(0x94be3cB0b1BD900Fa44F62f3c5733d5587571683); // set as marketing wallet
1161         devWallet = address(0x94be3cB0b1BD900Fa44F62f3c5733d5587571683); // set as dev wallet
1162 
1163         // exclude from paying fees or having max transaction amount
1164         excludeFromFees(owner(), true);
1165         excludeFromFees(address(this), true);
1166         excludeFromFees(address(0xdead), true);
1167 
1168         excludeFromMaxTransaction(owner(), true);
1169         excludeFromMaxTransaction(address(this), true);
1170         excludeFromMaxTransaction(address(0xdead), true);
1171 
1172         /*
1173             _mint is an internal function in ERC20.sol that is only called here,
1174             and CANNOT be called ever again
1175         */
1176         _mint(msg.sender, totalSupply);
1177     }
1178 
1179     receive() external payable {}
1180 
1181     // once enabled, can never be turned off
1182     function enableTrading() external onlyOwner {
1183         tradingActive = true;
1184         swapEnabled = true;
1185         lastLpBurnTime = block.timestamp;
1186     }
1187 
1188     // remove limits after token is stable
1189     function removeLimits() external onlyOwner returns (bool) {
1190         limitsInEffect = false;
1191         return true;
1192     }
1193 
1194     // disable Transfer delay - cannot be reenabled
1195     function disableTransferDelay() external onlyOwner returns (bool) {
1196         transferDelayEnabled = false;
1197         return true;
1198     }
1199 
1200     // change the minimum amount of tokens to sell from fees
1201     function updateSwapTokensAtAmount(uint256 newAmount)
1202         external
1203         onlyOwner
1204         returns (bool)
1205     {
1206         require(
1207             newAmount >= (totalSupply() * 1) / 100000,
1208             "Swap amount cannot be lower than 0.001% total supply."
1209         );
1210         require(
1211             newAmount <= (totalSupply() * 5) / 1000,
1212             "Swap amount cannot be higher than 0.5% total supply."
1213         );
1214         swapTokensAtAmount = newAmount;
1215         return true;
1216     }
1217 
1218     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1219         require(
1220             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1221             "Cannot set maxTransactionAmount lower than 0.1%"
1222         );
1223         maxTransactionAmount = newNum * (10**18);
1224     }
1225 
1226     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1227         require(
1228             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1229             "Cannot set maxWallet lower than 0.5%"
1230         );
1231         maxWallet = newNum * (10**18);
1232     }
1233 
1234     function excludeFromMaxTransaction(address updAds, bool isEx)
1235         public
1236         onlyOwner
1237     {
1238         _isExcludedMaxTransactionAmount[updAds] = isEx;
1239     }
1240 
1241     // only use to disable contract sales if absolutely necessary (emergency use only)
1242     function updateSwapEnabled(bool enabled) external onlyOwner {
1243         swapEnabled = enabled;
1244     }
1245 
1246     function updateBuyFees(
1247         uint256 _marketingFee,
1248         uint256 _liquidityFee,
1249         uint256 _devFee
1250     ) external onlyOwner {
1251         buyMarketingFee = _marketingFee;
1252         buyLiquidityFee = _liquidityFee;
1253         buyDevFee = _devFee;
1254         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1255         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1256     }
1257 
1258     function updateSellFees(
1259         uint256 _marketingFee,
1260         uint256 _liquidityFee,
1261         uint256 _devFee
1262     ) external onlyOwner {
1263         sellMarketingFee = _marketingFee;
1264         sellLiquidityFee = _liquidityFee;
1265         sellDevFee = _devFee;
1266         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1267         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1268     }
1269 
1270     function excludeFromFees(address account, bool excluded) public onlyOwner {
1271         _isExcludedFromFees[account] = excluded;
1272         emit ExcludeFromFees(account, excluded);
1273     }
1274 
1275     function setAutomatedMarketMakerPair(address pair, bool value)
1276         public
1277         onlyOwner
1278     {
1279         require(
1280             pair != uniswapV2Pair,
1281             "The pair cannot be removed from automatedMarketMakerPairs"
1282         );
1283 
1284         _setAutomatedMarketMakerPair(pair, value);
1285     }
1286 
1287     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1288         automatedMarketMakerPairs[pair] = value;
1289 
1290         emit SetAutomatedMarketMakerPair(pair, value);
1291     }
1292 
1293     function updateMarketingWallet(address newMarketingWallet)
1294         external
1295         onlyOwner
1296     {
1297         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1298         marketingWallet = newMarketingWallet;
1299     }
1300 
1301     function updateDevWallet(address newWallet) external onlyOwner {
1302         emit devWalletUpdated(newWallet, devWallet);
1303         devWallet = newWallet;
1304     }
1305 
1306     function isExcludedFromFees(address account) public view returns (bool) {
1307         return _isExcludedFromFees[account];
1308     }
1309 
1310     event BoughtEarly(address indexed sniper);
1311 
1312     function _transfer(
1313         address from,
1314         address to,
1315         uint256 amount
1316     ) internal override {
1317         require(from != address(0), "ERC20: transfer from the zero address");
1318         require(to != address(0), "ERC20: transfer to the zero address");
1319 
1320         if (amount == 0) {
1321             super._transfer(from, to, 0);
1322             return;
1323         }
1324 
1325         if (limitsInEffect) {
1326             if (
1327                 from != owner() &&
1328                 to != owner() &&
1329                 to != address(0) &&
1330                 to != address(0xdead) &&
1331                 !swapping
1332             ) {
1333                 if (!tradingActive) {
1334                     require(
1335                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1336                         "Trading is not active."
1337                     );
1338                 }
1339 
1340                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1341                 if (transferDelayEnabled) {
1342                     if (
1343                         to != owner() &&
1344                         to != address(uniswapV2Router) &&
1345                         to != address(uniswapV2Pair)
1346                     ) {
1347                         require(
1348                             _holderLastTransferTimestamp[tx.origin] <
1349                                 block.number,
1350                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1351                         );
1352                         _holderLastTransferTimestamp[tx.origin] = block.number;
1353                     }
1354                 }
1355 
1356                 //when buy
1357                 if (
1358                     automatedMarketMakerPairs[from] &&
1359                     !_isExcludedMaxTransactionAmount[to]
1360                 ) {
1361                     require(
1362                         amount <= maxTransactionAmount,
1363                         "Buy transfer amount exceeds the maxTransactionAmount."
1364                     );
1365                     require(
1366                         amount + balanceOf(to) <= maxWallet,
1367                         "Max wallet exceeded"
1368                     );
1369                 }
1370                 //when sell
1371                 else if (
1372                     automatedMarketMakerPairs[to] &&
1373                     !_isExcludedMaxTransactionAmount[from]
1374                 ) {
1375                     require(
1376                         amount <= maxTransactionAmount,
1377                         "Sell transfer amount exceeds the maxTransactionAmount."
1378                     );
1379                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1380                     require(
1381                         amount + balanceOf(to) <= maxWallet,
1382                         "Max wallet exceeded"
1383                     );
1384                 }
1385             }
1386         }
1387 
1388         uint256 contractTokenBalance = balanceOf(address(this));
1389 
1390         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1391 
1392         if (
1393             canSwap &&
1394             swapEnabled &&
1395             !swapping &&
1396             !automatedMarketMakerPairs[from] &&
1397             !_isExcludedFromFees[from] &&
1398             !_isExcludedFromFees[to]
1399         ) {
1400             swapping = true;
1401 
1402             swapBack();
1403 
1404             swapping = false;
1405         }
1406 
1407         if (
1408             !swapping &&
1409             automatedMarketMakerPairs[to] &&
1410             lpBurnEnabled &&
1411             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1412             !_isExcludedFromFees[from]
1413         ) {
1414             autoBurnLiquidityPairTokens();
1415         }
1416 
1417         bool takeFee = !swapping;
1418 
1419         // if any account belongs to _isExcludedFromFee account then remove the fee
1420         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1421             takeFee = false;
1422         }
1423 
1424         uint256 fees = 0;
1425         // only take fees on buys/sells, do not take on wallet transfers
1426         if (takeFee) {
1427             // on sell
1428             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1429                 fees = amount.mul(sellTotalFees).div(100);
1430                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1431                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1432                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1433             }
1434             // on buy
1435             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1436                 fees = amount.mul(buyTotalFees).div(100);
1437                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1438                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1439                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1440             }
1441 
1442             if (fees > 0) {
1443                 super._transfer(from, address(this), fees);
1444             }
1445 
1446             amount -= fees;
1447         }
1448 
1449         super._transfer(from, to, amount);
1450     }
1451 
1452     function swapTokensForEth(uint256 tokenAmount) private {
1453         // generate the uniswap pair path of token -> weth
1454         address[] memory path = new address[](2);
1455         path[0] = address(this);
1456         path[1] = uniswapV2Router.WETH();
1457 
1458         _approve(address(this), address(uniswapV2Router), tokenAmount);
1459 
1460         // make the swap
1461         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1462             tokenAmount,
1463             0, // accept any amount of ETH
1464             path,
1465             address(this),
1466             block.timestamp
1467         );
1468     }
1469 
1470     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1471         // approve token transfer to cover all possible scenarios
1472         _approve(address(this), address(uniswapV2Router), tokenAmount);
1473 
1474         // add the liquidity
1475         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1476             address(this),
1477             tokenAmount,
1478             0, // slippage is unavoidable
1479             0, // slippage is unavoidable
1480             deadAddress,
1481             block.timestamp
1482         );
1483     }
1484 
1485     function swapBack() private {
1486         uint256 contractBalance = balanceOf(address(this));
1487         uint256 totalTokensToSwap = tokensForLiquidity +
1488             tokensForMarketing +
1489             tokensForDev;
1490         bool success;
1491 
1492         if (contractBalance == 0 || totalTokensToSwap == 0) {
1493             return;
1494         }
1495 
1496         if (contractBalance > swapTokensAtAmount * 20) {
1497             contractBalance = swapTokensAtAmount * 20;
1498         }
1499 
1500         // Halve the amount of liquidity tokens
1501         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1502             totalTokensToSwap /
1503             2;
1504         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1505 
1506         uint256 initialETHBalance = address(this).balance;
1507 
1508         swapTokensForEth(amountToSwapForETH);
1509 
1510         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1511 
1512         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1513             totalTokensToSwap
1514         );
1515         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1516 
1517         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1518 
1519         tokensForLiquidity = 0;
1520         tokensForMarketing = 0;
1521         tokensForDev = 0;
1522 
1523         (success, ) = address(devWallet).call{value: ethForDev}("");
1524 
1525         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1526             addLiquidity(liquidityTokens, ethForLiquidity);
1527             emit SwapAndLiquify(
1528                 amountToSwapForETH,
1529                 ethForLiquidity,
1530                 tokensForLiquidity
1531             );
1532         }
1533 
1534         (success, ) = address(marketingWallet).call{
1535             value: address(this).balance
1536         }("");
1537     }
1538 
1539     function setAutoLPBurnSettings(
1540         uint256 _frequencyInSeconds,
1541         uint256 _percent,
1542         bool _Enabled
1543     ) external onlyOwner {
1544         require(
1545             _frequencyInSeconds >= 600,
1546             "cannot set buyback more often than every 10 minutes"
1547         );
1548         require(
1549             _percent <= 1000 && _percent >= 0,
1550             "Must set auto LP burn percent between 0% and 10%"
1551         );
1552         lpBurnFrequency = _frequencyInSeconds;
1553         percentForLPBurn = _percent;
1554         lpBurnEnabled = _Enabled;
1555     }
1556 
1557     function autoBurnLiquidityPairTokens() internal returns (bool) {
1558         lastLpBurnTime = block.timestamp;
1559 
1560         // get balance of liquidity pair
1561         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1562 
1563         // calculate amount to burn
1564         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1565             10000
1566         );
1567 
1568         // pull tokens from pancakePair liquidity and move to dead address permanently
1569         if (amountToBurn > 0) {
1570             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1571         }
1572 
1573         //sync price since this is not in a swap transaction!
1574         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1575         pair.sync();
1576         emit AutoNukeLP();
1577         return true;
1578     }
1579 
1580     function manualBurnLiquidityPairTokens(uint256 percent)
1581         external
1582         onlyOwner
1583         returns (bool)
1584     {
1585         require(
1586             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1587             "Must wait for cooldown to finish"
1588         );
1589         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1590         lastManualLpBurnTime = block.timestamp;
1591 
1592         // get balance of liquidity pair
1593         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1594 
1595         // calculate amount to burn
1596         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1597 
1598         // pull tokens from pancakePair liquidity and move to dead address permanently
1599         if (amountToBurn > 0) {
1600             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1601         }
1602 
1603         //sync price since this is not in a swap transaction!
1604         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1605         pair.sync();
1606         emit ManualNukeLP();
1607         return true;
1608     }
1609 }