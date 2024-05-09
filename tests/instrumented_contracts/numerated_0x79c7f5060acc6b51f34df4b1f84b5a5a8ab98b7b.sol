1 // SPDX-License-Identifier: MIT
2 
3 /*
4   _____   ______          ________ _____  ____  _    _ _      _      
5  |  __ \ / __ \ \        / /  ____|  __ \|  _ \| |  | | |    | |     
6  | |__) | |  | \ \  /\  / /| |__  | |__) | |_) | |  | | |    | |     
7  |  ___/| |  | |\ \/  \/ / |  __| |  _  /|  _ <| |  | | |    | |     
8  | |    | |__| | \  /\  /  | |____| | \ \| |_) | |__| | |____| |____ 
9  |_|     \____/   \/  \/   |______|_|  \_\____/ \____/|______|______|
10 
11  The first ever memecoin lottery. Winners drawn every hour!
12                                                                                                                                         
13  Website: https://powerbull.io
14  Telegram: https://t.me/powerbulltoken
15  Twitter: https://twitter.com/powerbulltoken
16  
17 */
18 
19 pragma solidity 0.8.20;
20 pragma experimental ABIEncoderV2;
21 
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
113 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
114 
115 /* pragma solidity ^0.8.0; */
116 
117 /**
118  * @dev Interface of the ERC20 standard as defined in the EIP.
119  */
120 interface IERC20 {
121     /**
122      * @dev Returns the amount of tokens in existence.
123      */
124     function totalSupply() external view returns (uint256);
125 
126     /**
127      * @dev Returns the amount of tokens owned by `account`.
128      */
129     function balanceOf(address account) external view returns (uint256);
130 
131     /**
132      * @dev Moves `amount` tokens from the caller's account to `recipient`.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transfer(address recipient, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Returns the remaining number of tokens that `spender` will be
142      * allowed to spend on behalf of `owner` through {transferFrom}. This is
143      * zero by default.
144      *
145      * This value changes when {approve} or {transferFrom} are called.
146      */
147     function allowance(address owner, address spender) external view returns (uint256);
148 
149     /**
150      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * IMPORTANT: Beware that changing an allowance with this method brings the risk
155      * that someone may use both the old and the new allowance by unfortunate
156      * transaction ordering. One possible solution to mitigate this race
157      * condition is to first reduce the spender's allowance to 0 and set the
158      * desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address spender, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Moves `amount` tokens from `sender` to `recipient` using the
167      * allowance mechanism. `amount` is then deducted from the caller's
168      * allowance.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) external returns (bool);
179 
180     /**
181      * @dev Emitted when `value` tokens are moved from one account (`from`) to
182      * another (`to`).
183      *
184      * Note that `value` may be zero.
185      */
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     /**
189      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
190      * a call to {approve}. `value` is the new allowance.
191      */
192     event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
196 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
197 
198 /* pragma solidity ^0.8.0; */
199 
200 /* import "../IERC20.sol"; */
201 
202 /**
203  * @dev Interface for the optional metadata functions from the ERC20 standard.
204  *
205  * _Available since v4.1._
206  */
207 interface IERC20Metadata is IERC20 {
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the symbol of the token.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the decimals places of the token.
220      */
221     function decimals() external view returns (uint8);
222 }
223 
224 /**
225  * @dev Implementation of the {IERC20} interface.
226  *
227  * This implementation is agnostic to the way tokens are created. This means
228  * that a supply mechanism has to be added in a derived contract using {_mint}.
229  * For a generic mechanism see {ERC20PresetMinterPauser}.
230  *
231  * TIP: For a detailed writeup see our guide
232  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
233  * to implement supply mechanisms].
234  *
235  * We have followed general OpenZeppelin Contracts guidelines: functions revert
236  * instead returning `false` on failure. This behavior is nonetheless
237  * conventional and does not conflict with the expectations of ERC20
238  * applications.
239  *
240  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
241  * This allows applications to reconstruct the allowance for all accounts just
242  * by listening to said events. Other implementations of the EIP may not emit
243  * these events, as it isn't required by the specification.
244  *
245  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
246  * functions have been added to mitigate the well-known issues around setting
247  * allowances. See {IERC20-approve}.
248  */
249 contract ERC20 is Context, IERC20, IERC20Metadata {
250     mapping(address => uint256) private _balances;
251 
252     mapping(address => mapping(address => uint256)) private _allowances;
253 
254     uint256 private _totalSupply;
255 
256     string private _name;
257     string private _symbol;
258 
259     /**
260      * @dev Sets the values for {name} and {symbol}.
261      *
262      * The default value of {decimals} is 18. To select a different value for
263      * {decimals} you should overload it.
264      *
265      * All two of these values are immutable: they can only be set once during
266      * construction.
267      */
268     constructor(string memory name_, string memory symbol_) {
269         _name = name_;
270         _symbol = symbol_;
271     }
272 
273     /**
274      * @dev Returns the name of the token.
275      */
276     function name() public view virtual override returns (string memory) {
277         return _name;
278     }
279 
280     /**
281      * @dev Returns the symbol of the token, usually a shorter version of the
282      * name.
283      */
284     function symbol() public view virtual override returns (string memory) {
285         return _symbol;
286     }
287 
288     /**
289      * @dev Returns the number of decimals used to get its user representation.
290      * For example, if `decimals` equals `2`, a balance of `505` tokens should
291      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
292      *
293      * Tokens usually opt for a value of 18, imitating the relationship between
294      * Ether and Wei. This is the value {ERC20} uses, unless this function is
295      * overridden;
296      *
297      * NOTE: This information is only used for _display_ purposes: it in
298      * no way affects any of the arithmetic of the contract, including
299      * {IERC20-balanceOf} and {IERC20-transfer}.
300      */
301     function decimals() public view virtual override returns (uint8) {
302         return 18;
303     }
304 
305     /**
306      * @dev See {IERC20-totalSupply}.
307      */
308     function totalSupply() public view virtual override returns (uint256) {
309         return _totalSupply;
310     }
311 
312     /**
313      * @dev See {IERC20-balanceOf}.
314      */
315     function balanceOf(address account) public view virtual override returns (uint256) {
316         return _balances[account];
317     }
318 
319     /**
320      * @dev See {IERC20-transfer}.
321      *
322      * Requirements:
323      *
324      * - `recipient` cannot be the zero address.
325      * - the caller must have a balance of at least `amount`.
326      */
327     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
328         _transfer(_msgSender(), recipient, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-allowance}.
334      */
335     function allowance(address owner, address spender) public view virtual override returns (uint256) {
336         return _allowances[owner][spender];
337     }
338 
339     /**
340      * @dev See {IERC20-approve}.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      */
346     function approve(address spender, uint256 amount) public virtual override returns (bool) {
347         _approve(_msgSender(), spender, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-transferFrom}.
353      *
354      * Emits an {Approval} event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of {ERC20}.
356      *
357      * Requirements:
358      *
359      * - `sender` and `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      * - the caller must have allowance for ``sender``'s tokens of at least
362      * `amount`.
363      */
364     function transferFrom(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) public virtual override returns (bool) {
369         _transfer(sender, recipient, amount);
370 
371         uint256 currentAllowance = _allowances[sender][_msgSender()];
372         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
373         unchecked {
374             _approve(sender, _msgSender(), currentAllowance - amount);
375         }
376 
377         return true;
378     }
379 
380     /**
381      * @dev Atomically increases the allowance granted to `spender` by the caller.
382      *
383      * This is an alternative to {approve} that can be used as a mitigation for
384      * problems described in {IERC20-approve}.
385      *
386      * Emits an {Approval} event indicating the updated allowance.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
393         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
394         return true;
395     }
396 
397     /**
398      * @dev Atomically decreases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      * - `spender` must have allowance for the caller of at least
409      * `subtractedValue`.
410      */
411     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
412         uint256 currentAllowance = _allowances[_msgSender()][spender];
413         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
414         unchecked {
415             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
416         }
417 
418         return true;
419     }
420 
421     /**
422      * @dev Moves `amount` of tokens from `sender` to `recipient`.
423      *
424      * This internal function is equivalent to {transfer}, and can be used to
425      * e.g. implement automatic token fees, slashing mechanisms, etc.
426      *
427      * Emits a {Transfer} event.
428      *
429      * Requirements:
430      *
431      * - `sender` cannot be the zero address.
432      * - `recipient` cannot be the zero address.
433      * - `sender` must have a balance of at least `amount`.
434      */
435     function _transfer(
436         address sender,
437         address recipient,
438         uint256 amount
439     ) internal virtual {
440         require(sender != address(0), "ERC20: transfer from the zero address");
441         require(recipient != address(0), "ERC20: transfer to the zero address");
442 
443         _beforeTokenTransfer(sender, recipient, amount);
444 
445         uint256 senderBalance = _balances[sender];
446         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
447         unchecked {
448             _balances[sender] = senderBalance - amount;
449         }
450         _balances[recipient] += amount;
451 
452         emit Transfer(sender, recipient, amount);
453 
454         _afterTokenTransfer(sender, recipient, amount);
455     }
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `account` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal virtual {
467         require(account != address(0), "ERC20: mint to the zero address");
468 
469         _beforeTokenTransfer(address(0), account, amount);
470 
471         _totalSupply += amount;
472         _balances[account] += amount;
473         emit Transfer(address(0), account, amount);
474 
475         _afterTokenTransfer(address(0), account, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`, reducing the
480      * total supply.
481      *
482      * Emits a {Transfer} event with `to` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      * - `account` must have at least `amount` tokens.
488      */
489     function _burn(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: burn from the zero address");
491 
492         _beforeTokenTransfer(account, address(0), amount);
493 
494         uint256 accountBalance = _balances[account];
495         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
496         unchecked {
497             _balances[account] = accountBalance - amount;
498         }
499         _totalSupply -= amount;
500 
501         emit Transfer(account, address(0), amount);
502 
503         _afterTokenTransfer(account, address(0), amount);
504     }
505 
506     /**
507      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
508      *
509      * This internal function is equivalent to `approve`, and can be used to
510      * e.g. set automatic allowances for certain subsystems, etc.
511      *
512      * Emits an {Approval} event.
513      *
514      * Requirements:
515      *
516      * - `owner` cannot be the zero address.
517      * - `spender` cannot be the zero address.
518      */
519     function _approve(
520         address owner,
521         address spender,
522         uint256 amount
523     ) internal virtual {
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }
530 
531     /**
532      * @dev Hook that is called before any transfer of tokens. This includes
533      * minting and burning.
534      *
535      * Calling conditions:
536      *
537      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
538      * will be transferred to `to`.
539      * - when `from` is zero, `amount` tokens will be minted for `to`.
540      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
541      * - `from` and `to` are never both zero.
542      *
543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
544      */
545     function _beforeTokenTransfer(
546         address from,
547         address to,
548         uint256 amount
549     ) internal virtual {}
550 
551     /**
552      * @dev Hook that is called after any transfer of tokens. This includes
553      * minting and burning.
554      *
555      * Calling conditions:
556      *
557      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
558      * has been transferred to `to`.
559      * - when `from` is zero, `amount` tokens have been minted for `to`.
560      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
561      * - `from` and `to` are never both zero.
562      *
563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
564      */
565     function _afterTokenTransfer(
566         address from,
567         address to,
568         uint256 amount
569     ) internal virtual {}
570 }
571 
572 /**
573  * @dev Wrappers over Solidity's arithmetic operations.
574  *
575  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
576  * now has built in overflow checking.
577  */
578 library SafeMath {
579     /**
580      * @dev Returns the addition of two unsigned integers, with an overflow flag.
581      *
582      * _Available since v3.4._
583      */
584     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
585         unchecked {
586             uint256 c = a + b;
587             if (c < a) return (false, 0);
588             return (true, c);
589         }
590     }
591 
592     /**
593      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
594      *
595      * _Available since v3.4._
596      */
597     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
598         unchecked {
599             if (b > a) return (false, 0);
600             return (true, a - b);
601         }
602     }
603 
604     /**
605      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
606      *
607      * _Available since v3.4._
608      */
609     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
610         unchecked {
611             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
612             // benefit is lost if 'b' is also tested.
613             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
614             if (a == 0) return (true, 0);
615             uint256 c = a * b;
616             if (c / a != b) return (false, 0);
617             return (true, c);
618         }
619     }
620 
621     /**
622      * @dev Returns the division of two unsigned integers, with a division by zero flag.
623      *
624      * _Available since v3.4._
625      */
626     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
627         unchecked {
628             if (b == 0) return (false, 0);
629             return (true, a / b);
630         }
631     }
632 
633     /**
634      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
635      *
636      * _Available since v3.4._
637      */
638     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
639         unchecked {
640             if (b == 0) return (false, 0);
641             return (true, a % b);
642         }
643     }
644 
645     /**
646      * @dev Returns the addition of two unsigned integers, reverting on
647      * overflow.
648      *
649      * Counterpart to Solidity's `+` operator.
650      *
651      * Requirements:
652      *
653      * - Addition cannot overflow.
654      */
655     function add(uint256 a, uint256 b) internal pure returns (uint256) {
656         return a + b;
657     }
658 
659     /**
660      * @dev Returns the subtraction of two unsigned integers, reverting on
661      * overflow (when the result is negative).
662      *
663      * Counterpart to Solidity's `-` operator.
664      *
665      * Requirements:
666      *
667      * - Subtraction cannot overflow.
668      */
669     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a - b;
671     }
672 
673     /**
674      * @dev Returns the multiplication of two unsigned integers, reverting on
675      * overflow.
676      *
677      * Counterpart to Solidity's `*` operator.
678      *
679      * Requirements:
680      *
681      * - Multiplication cannot overflow.
682      */
683     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a * b;
685     }
686 
687     /**
688      * @dev Returns the integer division of two unsigned integers, reverting on
689      * division by zero. The result is rounded towards zero.
690      *
691      * Counterpart to Solidity's `/` operator.
692      *
693      * Requirements:
694      *
695      * - The divisor cannot be zero.
696      */
697     function div(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a / b;
699     }
700 
701     /**
702      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
703      * reverting when dividing by zero.
704      *
705      * Counterpart to Solidity's `%` operator. This function uses a `revert`
706      * opcode (which leaves remaining gas untouched) while Solidity uses an
707      * invalid opcode to revert (consuming all remaining gas).
708      *
709      * Requirements:
710      *
711      * - The divisor cannot be zero.
712      */
713     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
714         return a % b;
715     }
716 
717     /**
718      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
719      * overflow (when the result is negative).
720      *
721      * CAUTION: This function is deprecated because it requires allocating memory for the error
722      * message unnecessarily. For custom revert reasons use {trySub}.
723      *
724      * Counterpart to Solidity's `-` operator.
725      *
726      * Requirements:
727      *
728      * - Subtraction cannot overflow.
729      */
730     function sub(
731         uint256 a,
732         uint256 b,
733         string memory errorMessage
734     ) internal pure returns (uint256) {
735         unchecked {
736             require(b <= a, errorMessage);
737             return a - b;
738         }
739     }
740 
741     /**
742      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
743      * division by zero. The result is rounded towards zero.
744      *
745      * Counterpart to Solidity's `/` operator. Note: this function uses a
746      * `revert` opcode (which leaves remaining gas untouched) while Solidity
747      * uses an invalid opcode to revert (consuming all remaining gas).
748      *
749      * Requirements:
750      *
751      * - The divisor cannot be zero.
752      */
753     function div(
754         uint256 a,
755         uint256 b,
756         string memory errorMessage
757     ) internal pure returns (uint256) {
758         unchecked {
759             require(b > 0, errorMessage);
760             return a / b;
761         }
762     }
763 
764     /**
765      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
766      * reverting with custom message when dividing by zero.
767      *
768      * CAUTION: This function is deprecated because it requires allocating memory for the error
769      * message unnecessarily. For custom revert reasons use {tryMod}.
770      *
771      * Counterpart to Solidity's `%` operator. This function uses a `revert`
772      * opcode (which leaves remaining gas untouched) while Solidity uses an
773      * invalid opcode to revert (consuming all remaining gas).
774      *
775      * Requirements:
776      *
777      * - The divisor cannot be zero.
778      */
779     function mod(
780         uint256 a,
781         uint256 b,
782         string memory errorMessage
783     ) internal pure returns (uint256) {
784         unchecked {
785             require(b > 0, errorMessage);
786             return a % b;
787         }
788     }
789 }
790 
791 interface IUniswapV2Factory {
792     event PairCreated(
793         address indexed token0,
794         address indexed token1,
795         address pair,
796         uint256
797     );
798 
799     function feeTo() external view returns (address);
800 
801     function feeToSetter() external view returns (address);
802 
803     function getPair(address tokenA, address tokenB)
804         external
805         view
806         returns (address pair);
807 
808     function allPairs(uint256) external view returns (address pair);
809 
810     function allPairsLength() external view returns (uint256);
811 
812     function createPair(address tokenA, address tokenB)
813         external
814         returns (address pair);
815 
816     function setFeeTo(address) external;
817 
818     function setFeeToSetter(address) external;
819 }
820 
821 ////// src/IUniswapV2Pair.sol
822 /* pragma solidity 0.8.10; */
823 /* pragma experimental ABIEncoderV2; */
824 
825 interface IUniswapV2Pair {
826     event Approval(
827         address indexed owner,
828         address indexed spender,
829         uint256 value
830     );
831     event Transfer(address indexed from, address indexed to, uint256 value);
832 
833     function name() external pure returns (string memory);
834 
835     function symbol() external pure returns (string memory);
836 
837     function decimals() external pure returns (uint8);
838 
839     function totalSupply() external view returns (uint256);
840 
841     function balanceOf(address owner) external view returns (uint256);
842 
843     function allowance(address owner, address spender)
844         external
845         view
846         returns (uint256);
847 
848     function approve(address spender, uint256 value) external returns (bool);
849 
850     function transfer(address to, uint256 value) external returns (bool);
851 
852     function transferFrom(
853         address from,
854         address to,
855         uint256 value
856     ) external returns (bool);
857 
858     function DOMAIN_SEPARATOR() external view returns (bytes32);
859 
860     function PERMIT_TYPEHASH() external pure returns (bytes32);
861 
862     function nonces(address owner) external view returns (uint256);
863 
864     function permit(
865         address owner,
866         address spender,
867         uint256 value,
868         uint256 deadline,
869         uint8 v,
870         bytes32 r,
871         bytes32 s
872     ) external;
873 
874     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
875     event Burn(
876         address indexed sender,
877         uint256 amount0,
878         uint256 amount1,
879         address indexed to
880     );
881     event Swap(
882         address indexed sender,
883         uint256 amount0In,
884         uint256 amount1In,
885         uint256 amount0Out,
886         uint256 amount1Out,
887         address indexed to
888     );
889     event Sync(uint112 reserve0, uint112 reserve1);
890 
891     function MINIMUM_LIQUIDITY() external pure returns (uint256);
892 
893     function factory() external view returns (address);
894 
895     function token0() external view returns (address);
896 
897     function token1() external view returns (address);
898 
899     function getReserves()
900         external
901         view
902         returns (
903             uint112 reserve0,
904             uint112 reserve1,
905             uint32 blockTimestampLast
906         );
907 
908     function price0CumulativeLast() external view returns (uint256);
909 
910     function price1CumulativeLast() external view returns (uint256);
911 
912     function kLast() external view returns (uint256);
913 
914     function mint(address to) external returns (uint256 liquidity);
915 
916     function burn(address to)
917         external
918         returns (uint256 amount0, uint256 amount1);
919 
920     function swap(
921         uint256 amount0Out,
922         uint256 amount1Out,
923         address to,
924         bytes calldata data
925     ) external;
926 
927     function skim(address to) external;
928 
929     function sync() external;
930 
931     function initialize(address, address) external;
932 }
933 
934 interface IUniswapV2Router02 {
935     function factory() external pure returns (address);
936 
937     function WETH() external pure returns (address);
938 
939     function addLiquidity(
940         address tokenA,
941         address tokenB,
942         uint256 amountADesired,
943         uint256 amountBDesired,
944         uint256 amountAMin,
945         uint256 amountBMin,
946         address to,
947         uint256 deadline
948     )
949         external
950         returns (
951             uint256 amountA,
952             uint256 amountB,
953             uint256 liquidity
954         );
955 
956     function addLiquidityETH(
957         address token,
958         uint256 amountTokenDesired,
959         uint256 amountTokenMin,
960         uint256 amountETHMin,
961         address to,
962         uint256 deadline
963     )
964         external
965         payable
966         returns (
967             uint256 amountToken,
968             uint256 amountETH,
969             uint256 liquidity
970         );
971 
972     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
973         uint256 amountIn,
974         uint256 amountOutMin,
975         address[] calldata path,
976         address to,
977         uint256 deadline
978     ) external;
979 
980     function swapExactETHForTokensSupportingFeeOnTransferTokens(
981         uint256 amountOutMin,
982         address[] calldata path,
983         address to,
984         uint256 deadline
985     ) external payable;
986 
987     function swapExactTokensForETHSupportingFeeOnTransferTokens(
988         uint256 amountIn,
989         uint256 amountOutMin,
990         address[] calldata path,
991         address to,
992         uint256 deadline
993     ) external;
994 }
995 
996 contract Powerbull is ERC20, Ownable {
997     using SafeMath for uint256;
998 
999     IUniswapV2Router02 public immutable uniswapV2Router;
1000     address public immutable uniswapV2Pair;
1001     address public constant deadAddress = address(0xdead);
1002 
1003     bool private swapping;
1004 
1005     address public lotteryWallet;
1006     address public teamWallet;
1007 
1008     uint256 public maxTransactionAmount;
1009     uint256 public swapTokensAtAmount;
1010     uint256 public maxWallet;
1011 
1012     bool public limitsInEffect = true;
1013     bool public tradingActive = false;
1014     bool public swapEnabled = false;
1015 
1016     bool public blacklistRenounced = false;
1017 
1018     // Anti-bot and anti-whale mappings and variables
1019     mapping(address => bool) blacklisted;
1020 
1021     uint256 public buyTotalFees;
1022     uint256 public buyLotteryFee;
1023     uint256 public buyLiquidityFee;
1024     uint256 public buyTeamFee;
1025 
1026     uint256 public sellTotalFees;
1027     uint256 public sellLotteryFee;
1028     uint256 public sellLiquidityFee;
1029     uint256 public sellTeamFee;
1030 
1031     uint256 public tokensForLottery;
1032     uint256 public tokensForLiquidity;
1033     uint256 public tokensForTeam;
1034 
1035     /******************/
1036 
1037     // exclude from fees and max transaction amount
1038     mapping(address => bool) private _isExcludedFromFees;
1039     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1040 
1041     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1042     // could be subject to a maximum transfer amount
1043     mapping(address => bool) public automatedMarketMakerPairs;
1044 
1045   
1046 
1047     event UpdateUniswapV2Router(
1048         address indexed newAddress,
1049         address indexed oldAddress
1050     );
1051 
1052     event ExcludeFromFees(address indexed account, bool isExcluded);
1053 
1054     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1055 
1056     event lotteryWalletUpdated(
1057         address indexed newWallet,
1058         address indexed oldWallet
1059     );
1060 
1061     event teamWalletUpdated(
1062         address indexed newWallet,
1063         address indexed oldWallet
1064     );
1065 
1066     event SwapAndLiquify(
1067         uint256 tokensSwapped,
1068         uint256 ethReceived,
1069         uint256 tokensIntoLiquidity
1070     );
1071 
1072     constructor() ERC20("Powerbull", "POWERBULL") {
1073         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1074             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1075         );
1076 
1077         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1078         uniswapV2Router = _uniswapV2Router;
1079 
1080         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1081             .createPair(address(this), _uniswapV2Router.WETH());
1082         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1083         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1084 
1085         uint256 _buyLotteryFee = 33; // prevent bots, will be updated before renounce
1086         uint256 _buyLiquidityFee = 33; // prevent bots, will be updated before renounce
1087         uint256 _buyTeamFee = 33; // prevent bots, will be updated before renounce
1088 
1089         uint256 _sellLotteryFee = 2;
1090         uint256 _sellLiquidityFee = 1;
1091         uint256 _sellTeamFee = 1;
1092 
1093         uint256 totalSupply = 100_000_000 * 1e18;
1094 
1095         maxTransactionAmount = 1000_000 * 1e18; // 1%
1096         maxWallet = 1000_000 * 1e18; // 1% 
1097         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1098 
1099         buyLotteryFee = _buyLotteryFee;
1100         buyLiquidityFee = _buyLiquidityFee;
1101         buyTeamFee = _buyTeamFee;
1102         buyTotalFees = buyLotteryFee + buyLiquidityFee + buyTeamFee;
1103 
1104         sellLotteryFee = _sellLotteryFee;
1105         sellLiquidityFee = _sellLiquidityFee;
1106         sellTeamFee = _sellTeamFee;
1107         sellTotalFees = sellLotteryFee + sellLiquidityFee + sellTeamFee;
1108 
1109         lotteryWallet = address(0xDA3fB87700fb448220f9602E50d689D180993F5F); // set as Lottery wallet
1110         teamWallet = owner(); // set as team wallet
1111 
1112         // exclude from paying fees or having max transaction amount
1113         excludeFromFees(owner(), true);
1114         excludeFromFees(address(this), true);
1115         excludeFromFees(address(0xdead), true);
1116 
1117         excludeFromMaxTransaction(owner(), true);
1118         excludeFromMaxTransaction(address(this), true);
1119         excludeFromMaxTransaction(address(0xdead), true);
1120 
1121       
1122 
1123         /*
1124             _mint is an internal function in ERC20.sol that is only called here,
1125             and CANNOT be called ever again
1126         */
1127         _mint(msg.sender, totalSupply);
1128     }
1129 
1130     receive() external payable {}
1131 
1132     // once enabled, can never be turned off
1133     function enableTrading() external onlyOwner {
1134         tradingActive = true;
1135         swapEnabled = true;
1136       
1137     }
1138 
1139     // remove limits after token is stable
1140     function removeLimits() external onlyOwner returns (bool) {
1141         limitsInEffect = false;
1142         return true;
1143     }
1144 
1145     // change the minimum amount of tokens to sell from fees
1146     function updateSwapTokensAtAmount(uint256 newAmount)
1147         external
1148         onlyOwner
1149         returns (bool)
1150     {
1151         require(
1152             newAmount >= (totalSupply() * 1) / 100000,
1153             "Swap amount cannot be lower than 0.001% total supply."
1154         );
1155         require(
1156             newAmount <= (totalSupply() * 5) / 1000,
1157             "Swap amount cannot be higher than 0.5% total supply."
1158         );
1159         swapTokensAtAmount = newAmount;
1160         return true;
1161     }
1162 
1163     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1164         require(
1165             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1166             "Cannot set maxTransactionAmount lower than 0.5%"
1167         );
1168         maxTransactionAmount = newNum * (10**18);
1169     }
1170 
1171     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1172         require(
1173             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1174             "Cannot set maxWallet lower than 1.0%"
1175         );
1176         maxWallet = newNum * (10**18);
1177     }
1178 
1179     function excludeFromMaxTransaction(address updAds, bool isEx)
1180         public
1181         onlyOwner
1182     {
1183         _isExcludedMaxTransactionAmount[updAds] = isEx;
1184     }
1185 
1186     // only use to disable contract sales if absolutely necessary (emergency use only)
1187     function updateSwapEnabled(bool enabled) external onlyOwner {
1188         swapEnabled = enabled;
1189     }
1190 
1191     function updateBuyFees(
1192         uint256 _lotteryFee,
1193         uint256 _liquidityFee,
1194         uint256 _teamFee
1195     ) external onlyOwner {
1196         buyLotteryFee = _lotteryFee;
1197         buyLiquidityFee = _liquidityFee;
1198         buyTeamFee = _teamFee;
1199         buyTotalFees = buyLotteryFee + buyLiquidityFee + buyTeamFee;
1200         require(buyTotalFees <= 50, "Buy fees must be <= 50.");
1201     }
1202 
1203     function updateSellFees(
1204         uint256 _lotteryFee,
1205         uint256 _liquidityFee,
1206         uint256 _teamFee
1207     ) external onlyOwner {
1208         sellLotteryFee = _lotteryFee;
1209         sellLiquidityFee = _liquidityFee;
1210         sellTeamFee = _teamFee;
1211         sellTotalFees = sellLotteryFee + sellLiquidityFee + sellTeamFee;
1212         require(sellTotalFees <= 5, "Sell fees must be <= 5.");
1213     }
1214 
1215     function excludeFromFees(address account, bool excluded) public onlyOwner {
1216         _isExcludedFromFees[account] = excluded;
1217         emit ExcludeFromFees(account, excluded);
1218     }
1219 
1220     function setAutomatedMarketMakerPair(address pair, bool value)
1221         public
1222         onlyOwner
1223     {
1224         require(
1225             pair != uniswapV2Pair,
1226             "The pair cannot be removed from automatedMarketMakerPairs"
1227         );
1228 
1229         _setAutomatedMarketMakerPair(pair, value);
1230     }
1231 
1232     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1233         automatedMarketMakerPairs[pair] = value;
1234 
1235         emit SetAutomatedMarketMakerPair(pair, value);
1236     }
1237 
1238     function updateLotteryWallet(address newLotteryWallet) external onlyOwner {
1239         emit lotteryWalletUpdated(newLotteryWallet, lotteryWallet);
1240         lotteryWallet = newLotteryWallet;
1241     }
1242 
1243     function updateTeamWallet(address newWallet) external onlyOwner {
1244         emit teamWalletUpdated(newWallet, teamWallet);
1245         teamWallet = newWallet;
1246     }
1247 
1248     function isExcludedFromFees(address account) public view returns (bool) {
1249         return _isExcludedFromFees[account];
1250     }
1251 
1252     function isBlacklisted(address account) public view returns (bool) {
1253         return blacklisted[account];
1254     }
1255 
1256     function _transfer(
1257         address from,
1258         address to,
1259         uint256 amount
1260     ) internal override {
1261         require(from != address(0), "ERC20: transfer from the zero address");
1262         require(to != address(0), "ERC20: transfer to the zero address");
1263         require(!blacklisted[from],"Sender blacklisted");
1264         require(!blacklisted[to],"Receiver blacklisted");
1265 
1266         
1267         
1268 
1269         if (amount == 0) {
1270             super._transfer(from, to, 0);
1271             return;
1272         }
1273 
1274         if (limitsInEffect) {
1275             if (
1276                 from != owner() &&
1277                 to != owner() &&
1278                 to != address(0) &&
1279                 to != address(0xdead) &&
1280                 !swapping
1281             ) {
1282                 if (!tradingActive) {
1283                     require(
1284                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1285                         "Trading is not active."
1286                     );
1287                 }
1288 
1289                 //when buy
1290                 if (
1291                     automatedMarketMakerPairs[from] &&
1292                     !_isExcludedMaxTransactionAmount[to]
1293                 ) {
1294                     require(
1295                         amount <= maxTransactionAmount,
1296                         "Buy transfer amount exceeds the maxTransactionAmount."
1297                     );
1298                     require(
1299                         amount + balanceOf(to) <= maxWallet,
1300                         "Max wallet exceeded"
1301                     );
1302                 }
1303                 //when sell
1304                 else if (
1305                     automatedMarketMakerPairs[to] &&
1306                     !_isExcludedMaxTransactionAmount[from]
1307                 ) {
1308                     require(
1309                         amount <= maxTransactionAmount,
1310                         "Sell transfer amount exceeds the maxTransactionAmount."
1311                     );
1312                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1313                     require(
1314                         amount + balanceOf(to) <= maxWallet,
1315                         "Max wallet exceeded"
1316                     );
1317                 }
1318             }
1319         }
1320 
1321         uint256 contractTokenBalance = balanceOf(address(this));
1322 
1323         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1324 
1325         if (
1326             canSwap &&
1327             swapEnabled &&
1328             !swapping &&
1329             !automatedMarketMakerPairs[from] &&
1330             !_isExcludedFromFees[from] &&
1331             !_isExcludedFromFees[to]
1332         ) {
1333             swapping = true;
1334 
1335             swapBack();
1336 
1337             swapping = false;
1338         }
1339 
1340         bool takeFee = !swapping;
1341 
1342         // if any account belongs to _isExcludedFromFee account then remove the fee
1343         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1344             takeFee = false;
1345         }
1346 
1347         uint256 fees = 0;
1348         // only take fees on buys/sells, do not take on wallet transfers
1349         if (takeFee) {
1350             // on sell
1351             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1352                 fees = amount.mul(sellTotalFees).div(100);
1353                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1354                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1355                 tokensForLottery += (fees * sellLotteryFee) / sellTotalFees;
1356             }
1357             // on buy
1358             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1359                 fees = amount.mul(buyTotalFees).div(100);
1360                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1361                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1362                 tokensForLottery += (fees * buyLotteryFee) / buyTotalFees;
1363             }
1364 
1365             if (fees > 0) {
1366                 super._transfer(from, address(this), fees);
1367             }
1368 
1369             amount -= fees;
1370         }
1371 
1372         super._transfer(from, to, amount);
1373     }
1374 
1375     function swapTokensForEth(uint256 tokenAmount) private {
1376         // generate the uniswap pair path of token -> weth
1377         address[] memory path = new address[](2);
1378         path[0] = address(this);
1379         path[1] = uniswapV2Router.WETH();
1380 
1381         _approve(address(this), address(uniswapV2Router), tokenAmount);
1382 
1383         // make the swap
1384         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1385             tokenAmount,
1386             0, // accept any amount of ETH
1387             path,
1388             address(this),
1389             block.timestamp
1390         );
1391     }
1392 
1393     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1394         // approve token transfer to cover all possible scenarios
1395         _approve(address(this), address(uniswapV2Router), tokenAmount);
1396 
1397         // add the liquidity
1398         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1399             address(this),
1400             tokenAmount,
1401             0, // slippage is unavoidable
1402             0, // slippage is unavoidable
1403             owner(),
1404             block.timestamp
1405         );
1406     }
1407 
1408     function swapBack() private {
1409         uint256 contractBalance = balanceOf(address(this));
1410         uint256 totalTokensToSwap = tokensForLiquidity +
1411             tokensForLottery +
1412             tokensForTeam;
1413         bool success;
1414 
1415         if (contractBalance == 0 || totalTokensToSwap == 0) {
1416             return;
1417         }
1418 
1419         if (contractBalance > swapTokensAtAmount * 20) {
1420             contractBalance = swapTokensAtAmount * 20;
1421         }
1422 
1423         // Halve the amount of liquidity tokens
1424         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1425             totalTokensToSwap /
1426             2;
1427         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1428 
1429         uint256 initialETHBalance = address(this).balance;
1430 
1431         swapTokensForEth(amountToSwapForETH);
1432 
1433         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1434 
1435         uint256 ethForLottery = ethBalance.mul(tokensForLottery).div(totalTokensToSwap - (tokensForLiquidity / 2));
1436         
1437         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLiquidity / 2));
1438 
1439         uint256 ethForLiquidity = ethBalance - ethForLottery - ethForTeam;
1440 
1441         tokensForLiquidity = 0;
1442         tokensForLottery = 0;
1443         tokensForTeam = 0;
1444 
1445         (success, ) = address(teamWallet).call{value: ethForTeam}("");
1446 
1447         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1448             addLiquidity(liquidityTokens, ethForLiquidity);
1449             emit SwapAndLiquify(
1450                 amountToSwapForETH,
1451                 ethForLiquidity,
1452                 tokensForLiquidity
1453             );
1454         }
1455 
1456         (success, ) = address(lotteryWallet).call{value: address(this).balance}("");
1457     }
1458 
1459     function withdrawStuckUnibot() external onlyOwner {
1460         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1461         IERC20(address(this)).transfer(msg.sender, balance);
1462         payable(msg.sender).transfer(address(this).balance);
1463     }
1464 
1465     function withdrawStuckToken(address _token, address _to) external onlyOwner {
1466         require(_token != address(0), "_token address cannot be 0");
1467         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1468         IERC20(_token).transfer(_to, _contractBalance);
1469     }
1470 
1471     function withdrawStuckEth(address toAddr) external onlyOwner {
1472         (bool success, ) = toAddr.call{
1473             value: address(this).balance
1474         } ("");
1475         require(success);
1476     }
1477 
1478     // @dev team renounce blacklist commands
1479     function renounceBlacklist() public onlyOwner {
1480         blacklistRenounced = true;
1481     }
1482 
1483     function blacklist(address _addr) public onlyOwner {
1484         require(!blacklistRenounced, "Team has revoked blacklist rights");
1485         require(
1486             _addr != address(uniswapV2Pair) && _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1487             "Cannot blacklist token's v2 router or v2 pool."
1488         );
1489         blacklisted[_addr] = true;
1490     }
1491 
1492     // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
1493     function blacklistLiquidityPool(address lpAddress) public onlyOwner {
1494         require(!blacklistRenounced, "Team has revoked blacklist rights");
1495         require(
1496             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1497             "Cannot blacklist token's v2 router or v2 pool."
1498         );
1499         blacklisted[lpAddress] = true;
1500     }
1501 
1502     // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1503     function unblacklist(address _addr) public onlyOwner {
1504         blacklisted[_addr] = false;
1505     }
1506 }