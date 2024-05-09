1 // File: KorraInu.sol
2 
3 
4 // File: artifacts/KorraInu.sol
5 
6 
7 // File: KorraInu_flat.sol
8 
9 
10 // File: KorraInu.sol
11 
12 
13 // File: KorraInu.sol
14 
15 
16 // File: KorraInu.sol
17 
18 
19 // File: KorraInu.sol
20 
21 // File: KorraInu.sol
22 
23 
24 // File: contracts/KorraInu.sol
25 
26 /**
27 */
28 
29 // File: KorraInu.sol
30 
31 // hevm: flattened sources of src
32 
33 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
34 pragma experimental ABIEncoderV2;
35 
36 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
37 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
38 
39 /* pragma solidity ^0.8.0; */
40 
41 /**
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         return msg.data;
58     }
59 }
60 
61 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
62 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
63 
64 /* pragma solidity ^0.8.0; */
65 
66 /* import "../utils/Context.sol"; */
67 
68 /**
69  * @dev Contract module which provides a basic access control mechanism, where
70  * there is an account (an owner) that can be granted exclusive access to
71  * specific functions.
72  *
73  * By default, the owner account will be the one that deploys the contract. This
74  * can later be changed with {transferOwnership}.
75  *
76  * This module is used through inheritance. It will make available the modifier
77  * `onlyOwner`, which can be applied to your functions to restrict their use to
78  * the owner.
79  */
80 abstract contract Ownable is Context {
81     address private _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     /**
86      * @dev Initializes the contract setting the deployer as the initial owner.
87      */
88     constructor() {
89         _transferOwnership(_msgSender());
90     }
91 
92     /**
93      * @dev Returns the address of the current owner.
94      */
95     function owner() public view virtual returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(owner() == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public virtual onlyOwner {
115         _transferOwnership(address(0));
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Can only be called by the current owner.
121      */
122     function transferOwnership(address newOwner) public virtual onlyOwner {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      * Internal function without access restriction.
130      */
131     function _transferOwnership(address newOwner) internal virtual {
132         address oldOwner = _owner;
133         _owner = newOwner;
134         emit OwnershipTransferred(oldOwner, newOwner);
135     }
136 }
137 
138 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
139 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
140 
141 /* pragma solidity ^0.8.0; */
142 
143 /**
144  * @dev Interface of the ERC20 standard as defined in the EIP.
145  */
146 interface IERC20 {
147     /**
148      * @dev Returns the amount of tokens in existence.
149      */
150     function totalSupply() external view returns (uint256);
151 
152     /**
153      * @dev Returns the amount of tokens owned by `account`.
154      */
155     function balanceOf(address account) external view returns (uint256);
156 
157     /**
158      * @dev Moves `amount` tokens from the caller's account to `recipient`.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transfer(address recipient, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Returns the remaining number of tokens that `spender` will be
168      * allowed to spend on behalf of `owner` through {transferFrom}. This is
169      * zero by default.
170      *
171      * This value changes when {approve} or {transferFrom} are called.
172      */
173     function allowance(address owner, address spender) external view returns (uint256);
174 
175     /**
176      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * IMPORTANT: Beware that changing an allowance with this method brings the risk
181      * that someone may use both the old and the new allowance by unfortunate
182      * transaction ordering. One possible solution to mitigate this race
183      * condition is to first reduce the spender's allowance to 0 and set the
184      * desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      *
187      * Emits an {Approval} event.
188      */
189     function approve(address spender, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Moves `amount` tokens from `sender` to `recipient` using the
193      * allowance mechanism. `amount` is then deducted from the caller's
194      * allowance.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transferFrom(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) external returns (bool);
205 
206     /**
207      * @dev Emitted when `value` tokens are moved from one account (`from`) to
208      * another (`to`).
209      *
210      * Note that `value` may be zero.
211      */
212     event Transfer(address indexed from, address indexed to, uint256 value);
213 
214     /**
215      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
216      * a call to {approve}. `value` is the new allowance.
217      */
218     event Approval(address indexed owner, address indexed spender, uint256 value);
219 }
220 
221 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
222 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
223 
224 /* pragma solidity ^0.8.0; */
225 
226 /* import "../IERC20.sol"; */
227 
228 /**
229  * @dev Interface for the optional metadata functions from the ERC20 standard.
230  *
231  * _Available since v4.1._
232  */
233 interface IERC20Metadata is IERC20 {
234     /**
235      * @dev Returns the name of the token.
236      */
237     function name() external view returns (string memory);
238 
239     /**
240      * @dev Returns the symbol of the token.
241      */
242     function symbol() external view returns (string memory);
243 
244     /**
245      * @dev Returns the decimals places of the token.
246      */
247     function decimals() external view returns (uint8);
248 }
249 
250 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
251 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
252 
253 /* pragma solidity ^0.8.0; */
254 
255 /* import "./IERC20.sol"; */
256 /* import "./extensions/IERC20Metadata.sol"; */
257 /* import "../../utils/Context.sol"; */
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20PresetMinterPauser}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * We have followed general OpenZeppelin Contracts guidelines: functions revert
271  * instead returning `false` on failure. This behavior is nonetheless
272  * conventional and does not conflict with the expectations of ERC20
273  * applications.
274  *
275  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
276  * This allows applications to reconstruct the allowance for all accounts just
277  * by listening to said events. Other implementations of the EIP may not emit
278  * these events, as it isn't required by the specification.
279  *
280  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
281  * functions have been added to mitigate the well-known issues around setting
282  * allowances. See {IERC20-approve}.
283  */
284 contract ERC20 is Context, IERC20, IERC20Metadata {
285     mapping(address => uint256) private _balances;
286 
287     mapping(address => mapping(address => uint256)) private _allowances;
288 
289     uint256 private _totalSupply;
290 
291     string private _name;
292     string private _symbol;
293 
294     /**
295      * @dev Sets the values for {name} and {symbol}.
296      *
297      * The default value of {decimals} is 18. To select a different value for
298      * {decimals} you should overload it.
299      *
300      * All two of these values are immutable: they can only be set once during
301      * construction.
302      */
303     constructor(string memory name_, string memory symbol_) {
304         _name = name_;
305         _symbol = symbol_;
306     }
307 
308     /**
309      * @dev Returns the name of the token.
310      */
311     function name() public view virtual override returns (string memory) {
312         return _name;
313     }
314 
315     /**
316      * @dev Returns the symbol of the token, usually a shorter version of the
317      * name.
318      */
319     function symbol() public view virtual override returns (string memory) {
320         return _symbol;
321     }
322 
323     /**
324      * @dev Returns the number of decimals used to get its user representation.
325      * For example, if `decimals` equals `2`, a balance of `505` tokens should
326      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
327      *
328      * Tokens usually opt for a value of 18, imitating the relationship between
329      * Ether and Wei. This is the value {ERC20} uses, unless this function is
330      * overridden;
331      *
332      * NOTE: This information is only used for _display_ purposes: it in
333      * no way affects any of the arithmetic of the contract, including
334      * {IERC20-balanceOf} and {IERC20-transfer}.
335      */
336     function decimals() public view virtual override returns (uint8) {
337         return 18;
338     }
339 
340     /**
341      * @dev See {IERC20-totalSupply}.
342      */
343     function totalSupply() public view virtual override returns (uint256) {
344         return _totalSupply;
345     }
346 
347     /**
348      * @dev See {IERC20-balanceOf}.
349      */
350     function balanceOf(address account) public view virtual override returns (uint256) {
351         return _balances[account];
352     }
353 
354     /**
355      * @dev See {IERC20-transfer}.
356      *
357      * Requirements:
358      *
359      * - `recipient` cannot be the zero address.
360      * - the caller must have a balance of at least `amount`.
361      */
362     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
363         _transfer(_msgSender(), recipient, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-allowance}.
369      */
370     function allowance(address owner, address spender) public view virtual override returns (uint256) {
371         return _allowances[owner][spender];
372     }
373 
374     /**
375      * @dev See {IERC20-approve}.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function approve(address spender, uint256 amount) public virtual override returns (bool) {
382         _approve(_msgSender(), spender, amount);
383         return true;
384     }
385 
386     /**
387      * @dev See {IERC20-transferFrom}.
388      *
389      * Emits an {Approval} event indicating the updated allowance. This is not
390      * required by the EIP. See the note at the beginning of {ERC20}.
391      *
392      * Requirements:
393      *
394      * - `sender` and `recipient` cannot be the zero address.
395      * - `sender` must have a balance of at least `amount`.
396      * - the caller must have allowance for ``sender``'s tokens of at least
397      * `amount`.
398      */
399     function transferFrom(
400         address sender,
401         address recipient,
402         uint256 amount
403     ) public virtual override returns (bool) {
404         _transfer(sender, recipient, amount);
405 
406         uint256 currentAllowance = _allowances[sender][_msgSender()];
407         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
408         unchecked {
409             _approve(sender, _msgSender(), currentAllowance - amount);
410         }
411 
412         return true;
413     }
414 
415     /**
416      * @dev Atomically increases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
428         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
429         return true;
430     }
431 
432     /**
433      * @dev Atomically decreases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to {approve} that can be used as a mitigation for
436      * problems described in {IERC20-approve}.
437      *
438      * Emits an {Approval} event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      * - `spender` must have allowance for the caller of at least
444      * `subtractedValue`.
445      */
446     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
447         uint256 currentAllowance = _allowances[_msgSender()][spender];
448         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
449         unchecked {
450             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
451         }
452 
453         return true;
454     }
455 
456     /**
457      * @dev Moves `amount` of tokens from `sender` to `recipient`.
458      *
459      * This internal function is equivalent to {transfer}, and can be used to
460      * e.g. implement automatic token fees, slashing mechanisms, etc.
461      *
462      * Emits a {Transfer} event.
463      *
464      * Requirements:
465      *
466      * - `sender` cannot be the zero address.
467      * - `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `amount`.
469      */
470     function _transfer(
471         address sender,
472         address recipient,
473         uint256 amount
474     ) internal virtual {
475         require(sender != address(0), "ERC20: transfer from the zero address");
476         require(recipient != address(0), "ERC20: transfer to the zero address");
477 
478         _beforeTokenTransfer(sender, recipient, amount);
479 
480         uint256 senderBalance = _balances[sender];
481         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
482         unchecked {
483             _balances[sender] = senderBalance - amount;
484         }
485         _balances[recipient] += amount;
486 
487         emit Transfer(sender, recipient, amount);
488 
489         _afterTokenTransfer(sender, recipient, amount);
490     }
491 
492     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
493      * the total supply.
494      *
495      * Emits a {Transfer} event with `from` set to the zero address.
496      *
497      * Requirements:
498      *
499      * - `account` cannot be the zero address.
500      */
501     function _mint(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: mint to the zero address");
503 
504         _beforeTokenTransfer(address(0), account, amount);
505 
506         _totalSupply += amount;
507         _balances[account] += amount;
508         emit Transfer(address(0), account, amount);
509 
510         _afterTokenTransfer(address(0), account, amount);
511     }
512 
513     /**
514      * @dev Destroys `amount` tokens from `account`, reducing the
515      * total supply.
516      *
517      * Emits a {Transfer} event with `to` set to the zero address.
518      *
519      * Requirements:
520      *
521      * - `account` cannot be the zero address.
522      * - `account` must have at least `amount` tokens.
523      */
524     function _burn(address account, uint256 amount) internal virtual {
525         require(account != address(0), "ERC20: burn from the zero address");
526 
527         _beforeTokenTransfer(account, address(0), amount);
528 
529         uint256 accountBalance = _balances[account];
530         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
531         unchecked {
532             _balances[account] = accountBalance - amount;
533         }
534         _totalSupply -= amount;
535 
536         emit Transfer(account, address(0), amount);
537 
538         _afterTokenTransfer(account, address(0), amount);
539     }
540 
541     /**
542      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
543      *
544      * This internal function is equivalent to `approve`, and can be used to
545      * e.g. set automatic allowances for certain subsystems, etc.
546      *
547      * Emits an {Approval} event.
548      *
549      * Requirements:
550      *
551      * - `owner` cannot be the zero address.
552      * - `spender` cannot be the zero address.
553      */
554     function _approve(
555         address owner,
556         address spender,
557         uint256 amount
558     ) internal virtual {
559         require(owner != address(0), "ERC20: approve from the zero address");
560         require(spender != address(0), "ERC20: approve to the zero address");
561 
562         _allowances[owner][spender] = amount;
563         emit Approval(owner, spender, amount);
564     }
565 
566     /**
567      * @dev Hook that is called before any transfer of tokens. This includes
568      * minting and burning.
569      *
570      * Calling conditions:
571      *
572      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
573      * will be transferred to `to`.
574      * - when `from` is zero, `amount` tokens will be minted for `to`.
575      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
576      * - `from` and `to` are never both zero.
577      *
578      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
579      */
580     function _beforeTokenTransfer(
581         address from,
582         address to,
583         uint256 amount
584     ) internal virtual {}
585 
586     /**
587      * @dev Hook that is called after any transfer of tokens. This includes
588      * minting and burning.
589      *
590      * Calling conditions:
591      *
592      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
593      * has been transferred to `to`.
594      * - when `from` is zero, `amount` tokens have been minted for `to`.
595      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
596      * - `from` and `to` are never both zero.
597      *
598      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
599      */
600     function _afterTokenTransfer(
601         address from,
602         address to,
603         uint256 amount
604     ) internal virtual {}
605 }
606 
607 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
608 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
609 
610 /* pragma solidity ^0.8.0; */
611 
612 // CAUTION
613 // This version of SafeMath should only be used with Solidity 0.8 or later,
614 // because it relies on the compiler's built in overflow checks.
615 
616 /**
617  * @dev Wrappers over Solidity's arithmetic operations.
618  *
619  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
620  * now has built in overflow checking.
621  */
622 library SafeMath {
623     /**
624      * @dev Returns the addition of two unsigned integers, with an overflow flag.
625      *
626      * _Available since v3.4._
627      */
628     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
629         unchecked {
630             uint256 c = a + b;
631             if (c < a) return (false, 0);
632             return (true, c);
633         }
634     }
635 
636     /**
637      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
638      *
639      * _Available since v3.4._
640      */
641     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
642         unchecked {
643             if (b > a) return (false, 0);
644             return (true, a - b);
645         }
646     }
647 
648     /**
649      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
650      *
651      * _Available since v3.4._
652      */
653     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
654         unchecked {
655             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
656             // benefit is lost if 'b' is also tested.
657             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
658             if (a == 0) return (true, 0);
659             uint256 c = a * b;
660             if (c / a != b) return (false, 0);
661             return (true, c);
662         }
663     }
664 
665     /**
666      * @dev Returns the division of two unsigned integers, with a division by zero flag.
667      *
668      * _Available since v3.4._
669      */
670     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
671         unchecked {
672             if (b == 0) return (false, 0);
673             return (true, a / b);
674         }
675     }
676 
677     /**
678      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
679      *
680      * _Available since v3.4._
681      */
682     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
683         unchecked {
684             if (b == 0) return (false, 0);
685             return (true, a % b);
686         }
687     }
688 
689     /**
690      * @dev Returns the addition of two unsigned integers, reverting on
691      * overflow.
692      *
693      * Counterpart to Solidity's `+` operator.
694      *
695      * Requirements:
696      *
697      * - Addition cannot overflow.
698      */
699     function add(uint256 a, uint256 b) internal pure returns (uint256) {
700         return a + b;
701     }
702 
703     /**
704      * @dev Returns the subtraction of two unsigned integers, reverting on
705      * overflow (when the result is negative).
706      *
707      * Counterpart to Solidity's `-` operator.
708      *
709      * Requirements:
710      *
711      * - Subtraction cannot overflow.
712      */
713     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
714         return a - b;
715     }
716 
717     /**
718      * @dev Returns the multiplication of two unsigned integers, reverting on
719      * overflow.
720      *
721      * Counterpart to Solidity's `*` operator.
722      *
723      * Requirements:
724      *
725      * - Multiplication cannot overflow.
726      */
727     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
728         return a * b;
729     }
730 
731     /**
732      * @dev Returns the integer division of two unsigned integers, reverting on
733      * division by zero. The result is rounded towards zero.
734      *
735      * Counterpart to Solidity's `/` operator.
736      *
737      * Requirements:
738      *
739      * - The divisor cannot be zero.
740      */
741     function div(uint256 a, uint256 b) internal pure returns (uint256) {
742         return a / b;
743     }
744 
745     /**
746      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
747      * reverting when dividing by zero.
748      *
749      * Counterpart to Solidity's `%` operator. This function uses a `revert`
750      * opcode (which leaves remaining gas untouched) while Solidity uses an
751      * invalid opcode to revert (consuming all remaining gas).
752      *
753      * Requirements:
754      *
755      * - The divisor cannot be zero.
756      */
757     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
758         return a % b;
759     }
760 
761     /**
762      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
763      * overflow (when the result is negative).
764      *
765      * CAUTION: This function is deprecated because it requires allocating memory for the error
766      * message unnecessarily. For custom revert reasons use {trySub}.
767      *
768      * Counterpart to Solidity's `-` operator.
769      *
770      * Requirements:
771      *
772      * - Subtraction cannot overflow.
773      */
774     function sub(
775         uint256 a,
776         uint256 b,
777         string memory errorMessage
778     ) internal pure returns (uint256) {
779         unchecked {
780             require(b <= a, errorMessage);
781             return a - b;
782         }
783     }
784 
785     /**
786      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
787      * division by zero. The result is rounded towards zero.
788      *
789      * Counterpart to Solidity's `/` operator. Note: this function uses a
790      * `revert` opcode (which leaves remaining gas untouched) while Solidity
791      * uses an invalid opcode to revert (consuming all remaining gas).
792      *
793      * Requirements:
794      *
795      * - The divisor cannot be zero.
796      */
797     function div(
798         uint256 a,
799         uint256 b,
800         string memory errorMessage
801     ) internal pure returns (uint256) {
802         unchecked {
803             require(b > 0, errorMessage);
804             return a / b;
805         }
806     }
807 
808     /**
809      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
810      * reverting with custom message when dividing by zero.
811      *
812      * CAUTION: This function is deprecated because it requires allocating memory for the error
813      * message unnecessarily. For custom revert reasons use {tryMod}.
814      *
815      * Counterpart to Solidity's `%` operator. This function uses a `revert`
816      * opcode (which leaves remaining gas untouched) while Solidity uses an
817      * invalid opcode to revert (consuming all remaining gas).
818      *
819      * Requirements:
820      *
821      * - The divisor cannot be zero.
822      */
823     function mod(
824         uint256 a,
825         uint256 b,
826         string memory errorMessage
827     ) internal pure returns (uint256) {
828         unchecked {
829             require(b > 0, errorMessage);
830             return a % b;
831         }
832     }
833 }
834 
835 ////// src/IUniswapV2Factory.sol
836 /* pragma solidity 0.8.10; */
837 /* pragma experimental ABIEncoderV2; */
838 
839 interface IUniswapV2Factory {
840     event PairCreated(
841         address indexed token0,
842         address indexed token1,
843         address pair,
844         uint256
845     );
846 
847     function feeTo() external view returns (address);
848 
849     function feeToSetter() external view returns (address);
850 
851     function getPair(address tokenA, address tokenB)
852         external
853         view
854         returns (address pair);
855 
856     function allPairs(uint256) external view returns (address pair);
857 
858     function allPairsLength() external view returns (uint256);
859 
860     function createPair(address tokenA, address tokenB)
861         external
862         returns (address pair);
863 
864     function setFeeTo(address) external;
865 
866     function setFeeToSetter(address) external;
867 }
868 
869 ////// src/IUniswapV2Pair.sol
870 /* pragma solidity 0.8.10; */
871 /* pragma experimental ABIEncoderV2; */
872 
873 interface IUniswapV2Pair {
874     event Approval(
875         address indexed owner,
876         address indexed spender,
877         uint256 value
878     );
879     event Transfer(address indexed from, address indexed to, uint256 value);
880 
881     function name() external pure returns (string memory);
882 
883     function symbol() external pure returns (string memory);
884 
885     function decimals() external pure returns (uint8);
886 
887     function totalSupply() external view returns (uint256);
888 
889     function balanceOf(address owner) external view returns (uint256);
890 
891     function allowance(address owner, address spender)
892         external
893         view
894         returns (uint256);
895 
896     function approve(address spender, uint256 value) external returns (bool);
897 
898     function transfer(address to, uint256 value) external returns (bool);
899 
900     function transferFrom(
901         address from,
902         address to,
903         uint256 value
904     ) external returns (bool);
905 
906     function DOMAIN_SEPARATOR() external view returns (bytes32);
907 
908     function PERMIT_TYPEHASH() external pure returns (bytes32);
909 
910     function nonces(address owner) external view returns (uint256);
911 
912     function permit(
913         address owner,
914         address spender,
915         uint256 value,
916         uint256 deadline,
917         uint8 v,
918         bytes32 r,
919         bytes32 s
920     ) external;
921 
922     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
923     event Burn(
924         address indexed sender,
925         uint256 amount0,
926         uint256 amount1,
927         address indexed to
928     );
929     event Swap(
930         address indexed sender,
931         uint256 amount0In,
932         uint256 amount1In,
933         uint256 amount0Out,
934         uint256 amount1Out,
935         address indexed to
936     );
937     event Sync(uint112 reserve0, uint112 reserve1);
938 
939     function MINIMUM_LIQUIDITY() external pure returns (uint256);
940 
941     function factory() external view returns (address);
942 
943     function token0() external view returns (address);
944 
945     function token1() external view returns (address);
946 
947     function getReserves()
948         external
949         view
950         returns (
951             uint112 reserve0,
952             uint112 reserve1,
953             uint32 blockTimestampLast
954         );
955 
956     function price0CumulativeLast() external view returns (uint256);
957 
958     function price1CumulativeLast() external view returns (uint256);
959 
960     function kLast() external view returns (uint256);
961 
962     function mint(address to) external returns (uint256 liquidity);
963 
964     function burn(address to)
965         external
966         returns (uint256 amount0, uint256 amount1);
967 
968     function swap(
969         uint256 amount0Out,
970         uint256 amount1Out,
971         address to,
972         bytes calldata data
973     ) external;
974 
975     function skim(address to) external;
976 
977     function sync() external;
978 
979     function initialize(address, address) external;
980 }
981 
982 ////// src/IUniswapV2Router02.sol
983 /* pragma solidity 0.8.10; */
984 /* pragma experimental ABIEncoderV2; */
985 
986 interface IUniswapV2Router02 {
987     function factory() external pure returns (address);
988 
989     function WETH() external pure returns (address);
990 
991     function addLiquidity(
992         address tokenA,
993         address tokenB,
994         uint256 amountADesired,
995         uint256 amountBDesired,
996         uint256 amountAMin,
997         uint256 amountBMin,
998         address to,
999         uint256 deadline
1000     )
1001         external
1002         returns (
1003             uint256 amountA,
1004             uint256 amountB,
1005             uint256 liquidity
1006         );
1007 
1008     function addLiquidityETH(
1009         address token,
1010         uint256 amountTokenDesired,
1011         uint256 amountTokenMin,
1012         uint256 amountETHMin,
1013         address to,
1014         uint256 deadline
1015     )
1016         external
1017         payable
1018         returns (
1019             uint256 amountToken,
1020             uint256 amountETH,
1021             uint256 liquidity
1022         );
1023 
1024     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1025         uint256 amountIn,
1026         uint256 amountOutMin,
1027         address[] calldata path,
1028         address to,
1029         uint256 deadline
1030     ) external;
1031 
1032     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1033         uint256 amountOutMin,
1034         address[] calldata path,
1035         address to,
1036         uint256 deadline
1037     ) external payable;
1038 
1039     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1040         uint256 amountIn,
1041         uint256 amountOutMin,
1042         address[] calldata path,
1043         address to,
1044         uint256 deadline
1045     ) external;
1046 }
1047 
1048 ////// src/
1049 /* pragma solidity >=0.8.10; */
1050 
1051 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1052 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1053 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1054 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1055 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1056 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1057 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1058 
1059 contract KorraInu is ERC20, Ownable {
1060     using SafeMath for uint256;
1061 
1062     IUniswapV2Router02 public immutable uniswapV2Router;
1063     address public immutable uniswapV2Pair;
1064     address public constant deadAddress = address(0xdead);
1065 
1066     bool private swapping;
1067 
1068     address public marketingWallet;
1069     address public devWallet;
1070 
1071     uint256 public maxTransactionAmount;
1072     uint256 public swapTokensAtAmount;
1073     uint256 public maxWallet;
1074 
1075     uint256 public percentForLPBurn = 25; // 25 = .25%
1076     bool public lpBurnEnabled = true;
1077     uint256 public lpBurnFrequency = 3600 seconds;
1078     uint256 public lastLpBurnTime;
1079 
1080     uint256 public manualBurnFrequency = 30 minutes;
1081     uint256 public lastManualLpBurnTime;
1082 
1083     bool public limitsInEffect = true;
1084     bool public tradingActive = false;
1085     bool public swapEnabled = false;
1086 
1087     // Anti-bot and anti-whale mappings and variables
1088     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1089     bool public transferDelayEnabled = true;
1090 
1091     uint256 public buyTotalFees;
1092     uint256 public buyMarketingFee;
1093     uint256 public buyLiquidityFee;
1094     uint256 public buyDevFee;
1095 
1096     uint256 public sellTotalFees;
1097     uint256 public sellMarketingFee;
1098     uint256 public sellLiquidityFee;
1099     uint256 public sellDevFee;
1100 
1101     uint256 public tokensForMarketing;
1102     uint256 public tokensForLiquidity;
1103     uint256 public tokensForDev;
1104 
1105     /******************/
1106 
1107     // exlcude from fees and max transaction amount
1108     mapping(address => bool) private _isExcludedFromFees;
1109     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1110 
1111     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1112     // could be subject to a maximum transfer amount
1113     mapping(address => bool) public automatedMarketMakerPairs;
1114 
1115     event UpdateUniswapV2Router(
1116         address indexed newAddress,
1117         address indexed oldAddress
1118     );
1119 
1120     event ExcludeFromFees(address indexed account, bool isExcluded);
1121 
1122     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1123 
1124     event marketingWalletUpdated(
1125         address indexed newWallet,
1126         address indexed oldWallet
1127     );
1128 
1129     event devWalletUpdated(
1130         address indexed newWallet,
1131         address indexed oldWallet
1132     );
1133 
1134     event SwapAndLiquify(
1135         uint256 tokensSwapped,
1136         uint256 ethReceived,
1137         uint256 tokensIntoLiquidity
1138     );
1139 
1140     event AutoNukeLP();
1141 
1142     event ManualNukeLP();
1143 
1144     constructor() ERC20("KorraInu", "KORRA") {
1145         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1146             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1147         );
1148 
1149         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1150         uniswapV2Router = _uniswapV2Router;
1151 
1152         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1153             .createPair(address(this), _uniswapV2Router.WETH());
1154         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1155         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1156 
1157         uint256 _buyMarketingFee = 6;
1158         uint256 _buyLiquidityFee = 2;
1159         uint256 _buyDevFee = 2;
1160 
1161         uint256 _sellMarketingFee = 6;
1162         uint256 _sellLiquidityFee = 2;
1163         uint256 _sellDevFee = 2;
1164 
1165         uint256 totalSupply = 100_000_000 * 1e18;
1166 
1167         maxTransactionAmount = 90_000_000 * 1e18; // 100% from total supply maxTransactionAmountTxn
1168         maxWallet = 90_000_000 * 1e18; // 200% from total supply maxWallet
1169         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1170 
1171         buyMarketingFee = _buyMarketingFee;
1172         buyLiquidityFee = _buyLiquidityFee;
1173         buyDevFee = _buyDevFee;
1174         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1175 
1176         sellMarketingFee = _sellMarketingFee;
1177         sellLiquidityFee = _sellLiquidityFee;
1178         sellDevFee = _sellDevFee;
1179         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1180 
1181         marketingWallet = address(0x9C73B0C76d7Bd8283E0022CD8b28AEF131E76f84); // set as marketing wallet
1182         devWallet = address(0x0c38f146368aBFe5Da6E2CA8C01C106806702600); // set as dev wallet
1183 
1184         // exclude from paying fees or having max transaction amount
1185         excludeFromFees(owner(), true);
1186         excludeFromFees(address(this), true);
1187         excludeFromFees(address(0xdead), true);
1188 
1189         excludeFromMaxTransaction(owner(), true);
1190         excludeFromMaxTransaction(address(this), true);
1191         excludeFromMaxTransaction(address(0xdead), true);
1192 
1193         /*
1194             _mint is an internal function in ERC20.sol that is only called here,
1195             and CANNOT be called ever again
1196         */
1197         _mint(msg.sender, totalSupply);
1198     }
1199 
1200     receive() external payable {}
1201 
1202     // once enabled, can never be turned off
1203     function enableTrading() external onlyOwner {
1204         tradingActive = true;
1205         swapEnabled = true;
1206         lastLpBurnTime = block.timestamp;
1207     }
1208 
1209     // remove limits after token is stable
1210     function removeLimits() external onlyOwner returns (bool) {
1211         limitsInEffect = false;
1212         return true;
1213     }
1214 
1215     // disable Transfer delay - cannot be reenabled
1216     function disableTransferDelay() external onlyOwner returns (bool) {
1217         transferDelayEnabled = false;
1218         return true;
1219     }
1220 
1221     // change the minimum amount of tokens to sell from fees
1222     function updateSwapTokensAtAmount(uint256 newAmount)
1223         external
1224         onlyOwner
1225         returns (bool)
1226     {
1227         require(
1228             newAmount >= (totalSupply() * 1) / 100000,
1229             "Swap amount cannot be lower than 0.001% total supply."
1230         );
1231         require(
1232             newAmount <= (totalSupply() * 5) / 1000,
1233             "Swap amount cannot be higher than 0.5% total supply."
1234         );
1235         swapTokensAtAmount = newAmount;
1236         return true;
1237     }
1238 
1239     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1240         require(
1241             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1242             "Cannot set maxTransactionAmount lower than 0.1%"
1243         );
1244         maxTransactionAmount = newNum * (10**18);
1245     }
1246 
1247     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1248         require(
1249             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1250             "Cannot set maxWallet lower than 0.5%"
1251         );
1252         maxWallet = newNum * (10**18);
1253     }
1254 
1255     function excludeFromMaxTransaction(address updAds, bool isEx)
1256         public
1257         onlyOwner
1258     {
1259         _isExcludedMaxTransactionAmount[updAds] = isEx;
1260     }
1261 
1262     // only use to disable contract sales if absolutely necessary (emergency use only)
1263     function updateSwapEnabled(bool enabled) external onlyOwner {
1264         swapEnabled = enabled;
1265     }
1266 
1267     function updateBuyFees(
1268         uint256 _marketingFee,
1269         uint256 _liquidityFee,
1270         uint256 _devFee
1271     ) external onlyOwner {
1272         buyMarketingFee = _marketingFee;
1273         buyLiquidityFee = _liquidityFee;
1274         buyDevFee = _devFee;
1275         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1276         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1277     }
1278 
1279     function updateSellFees(
1280         uint256 _marketingFee,
1281         uint256 _liquidityFee,
1282         uint256 _devFee
1283     ) external onlyOwner {
1284         sellMarketingFee = _marketingFee;
1285         sellLiquidityFee = _liquidityFee;
1286         sellDevFee = _devFee;
1287         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1288         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1289     }
1290 
1291     function excludeFromFees(address account, bool excluded) public onlyOwner {
1292         _isExcludedFromFees[account] = excluded;
1293         emit ExcludeFromFees(account, excluded);
1294     }
1295 
1296     function setAutomatedMarketMakerPair(address pair, bool value)
1297         public
1298         onlyOwner
1299     {
1300         require(
1301             pair != uniswapV2Pair,
1302             "The pair cannot be removed from automatedMarketMakerPairs"
1303         );
1304 
1305         _setAutomatedMarketMakerPair(pair, value);
1306     }
1307 
1308     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1309         automatedMarketMakerPairs[pair] = value;
1310 
1311         emit SetAutomatedMarketMakerPair(pair, value);
1312     }
1313 
1314     function updateMarketingWallet(address newMarketingWallet)
1315         external
1316         onlyOwner
1317     {
1318         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1319         marketingWallet = newMarketingWallet;
1320     }
1321 
1322     function updateDevWallet(address newWallet) external onlyOwner {
1323         emit devWalletUpdated(newWallet, devWallet);
1324         devWallet = newWallet;
1325     }
1326 
1327     function isExcludedFromFees(address account) public view returns (bool) {
1328         return _isExcludedFromFees[account];
1329     }
1330 
1331     event BoughtEarly(address indexed sniper);
1332 
1333     function _transfer(
1334         address from,
1335         address to,
1336         uint256 amount
1337     ) internal override {
1338         require(from != address(0), "ERC20: transfer from the zero address");
1339         require(to != address(0), "ERC20: transfer to the zero address");
1340 
1341         if (amount == 0) {
1342             super._transfer(from, to, 0);
1343             return;
1344         }
1345 
1346         if (limitsInEffect) {
1347             if (
1348                 from != owner() &&
1349                 to != owner() &&
1350                 to != address(0) &&
1351                 to != address(0xdead) &&
1352                 !swapping
1353             ) {
1354                 if (!tradingActive) {
1355                     require(
1356                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1357                         "Trading is not active."
1358                     );
1359                 }
1360 
1361                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1362                 if (transferDelayEnabled) {
1363                     if (
1364                         to != owner() &&
1365                         to != address(uniswapV2Router) &&
1366                         to != address(uniswapV2Pair)
1367                     ) {
1368                         require(
1369                             _holderLastTransferTimestamp[tx.origin] <
1370                                 block.number,
1371                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1372                         );
1373                         _holderLastTransferTimestamp[tx.origin] = block.number;
1374                     }
1375                 }
1376 
1377                 //when buy
1378                 if (
1379                     automatedMarketMakerPairs[from] &&
1380                     !_isExcludedMaxTransactionAmount[to]
1381                 ) {
1382                     require(
1383                         amount <= maxTransactionAmount,
1384                         "Buy transfer amount exceeds the maxTransactionAmount."
1385                     );
1386                     require(
1387                         amount + balanceOf(to) <= maxWallet,
1388                         "Max wallet exceeded"
1389                     );
1390                 }
1391                 //when sell
1392                 else if (
1393                     automatedMarketMakerPairs[to] &&
1394                     !_isExcludedMaxTransactionAmount[from]
1395                 ) {
1396                     require(
1397                         amount <= maxTransactionAmount,
1398                         "Sell transfer amount exceeds the maxTransactionAmount."
1399                     );
1400                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1401                     require(
1402                         amount + balanceOf(to) <= maxWallet,
1403                         "Max wallet exceeded"
1404                     );
1405                 }
1406             }
1407         }
1408 
1409         uint256 contractTokenBalance = balanceOf(address(this));
1410 
1411         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1412 
1413         if (
1414             canSwap &&
1415             swapEnabled &&
1416             !swapping &&
1417             !automatedMarketMakerPairs[from] &&
1418             !_isExcludedFromFees[from] &&
1419             !_isExcludedFromFees[to]
1420         ) {
1421             swapping = true;
1422 
1423             swapBack();
1424 
1425             swapping = false;
1426         }
1427 
1428         if (
1429             !swapping &&
1430             automatedMarketMakerPairs[to] &&
1431             lpBurnEnabled &&
1432             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1433             !_isExcludedFromFees[from]
1434         ) {
1435             autoBurnLiquidityPairTokens();
1436         }
1437 
1438         bool takeFee = !swapping;
1439 
1440         // if any account belongs to _isExcludedFromFee account then remove the fee
1441         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1442             takeFee = false;
1443         }
1444 
1445         uint256 fees = 0;
1446         // only take fees on buys/sells, do not take on wallet transfers
1447         if (takeFee) {
1448             // on sell
1449             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1450                 fees = amount.mul(sellTotalFees).div(100);
1451                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1452                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1453                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1454             }
1455             // on buy
1456             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1457                 fees = amount.mul(buyTotalFees).div(100);
1458                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1459                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1460                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1461             }
1462 
1463             if (fees > 0) {
1464                 super._transfer(from, address(this), fees);
1465             }
1466 
1467             amount -= fees;
1468         }
1469 
1470         super._transfer(from, to, amount);
1471     }
1472 
1473     function swapTokensForEth(uint256 tokenAmount) private {
1474         // generate the uniswap pair path of token -> weth
1475         address[] memory path = new address[](2);
1476         path[0] = address(this);
1477         path[1] = uniswapV2Router.WETH();
1478 
1479         _approve(address(this), address(uniswapV2Router), tokenAmount);
1480 
1481         // make the swap
1482         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1483             tokenAmount,
1484             0, // accept any amount of ETH
1485             path,
1486             address(this),
1487             block.timestamp
1488         );
1489     }
1490 
1491     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1492         // approve token transfer to cover all possible scenarios
1493         _approve(address(this), address(uniswapV2Router), tokenAmount);
1494 
1495         // add the liquidity
1496         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1497             address(this),
1498             tokenAmount,
1499             0, // slippage is unavoidable
1500             0, // slippage is unavoidable
1501             deadAddress,
1502             block.timestamp
1503         );
1504     }
1505 
1506     function swapBack() private {
1507         uint256 contractBalance = balanceOf(address(this));
1508         uint256 totalTokensToSwap = tokensForLiquidity +
1509             tokensForMarketing +
1510             tokensForDev;
1511         bool success;
1512 
1513         if (contractBalance == 0 || totalTokensToSwap == 0) {
1514             return;
1515         }
1516 
1517         if (contractBalance > swapTokensAtAmount * 20) {
1518             contractBalance = swapTokensAtAmount * 20;
1519         }
1520 
1521         // Halve the amount of liquidity tokens
1522         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1523             totalTokensToSwap /
1524             2;
1525         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1526 
1527         uint256 initialETHBalance = address(this).balance;
1528 
1529         swapTokensForEth(amountToSwapForETH);
1530 
1531         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1532 
1533         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1534             totalTokensToSwap
1535         );
1536         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1537 
1538         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1539 
1540         tokensForLiquidity = 0;
1541         tokensForMarketing = 0;
1542         tokensForDev = 0;
1543 
1544         (success, ) = address(devWallet).call{value: ethForDev}("");
1545 
1546         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1547             addLiquidity(liquidityTokens, ethForLiquidity);
1548             emit SwapAndLiquify(
1549                 amountToSwapForETH,
1550                 ethForLiquidity,
1551                 tokensForLiquidity
1552             );
1553         }
1554 
1555         (success, ) = address(marketingWallet).call{
1556             value: address(this).balance
1557         }("");
1558     }
1559 
1560     function setAutoLPBurnSettings(
1561         uint256 _frequencyInSeconds,
1562         uint256 _percent,
1563         bool _Enabled
1564     ) external onlyOwner {
1565         require(
1566             _frequencyInSeconds >= 600,
1567             "cannot set buyback more often than every 10 minutes"
1568         );
1569         require(
1570             _percent <= 1000 && _percent >= 0,
1571             "Must set auto LP burn percent between 0% and 10%"
1572         );
1573         lpBurnFrequency = _frequencyInSeconds;
1574         percentForLPBurn = _percent;
1575         lpBurnEnabled = _Enabled;
1576     }
1577 
1578     function autoBurnLiquidityPairTokens() internal returns (bool) {
1579         lastLpBurnTime = block.timestamp;
1580 
1581         // get balance of liquidity pair
1582         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1583 
1584         // calculate amount to burn
1585         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1586             10000
1587         );
1588 
1589         // pull tokens from pancakePair liquidity and move to dead address permanently
1590         if (amountToBurn > 0) {
1591             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1592         }
1593 
1594         //sync price since this is not in a swap transaction!
1595         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1596         pair.sync();
1597         emit AutoNukeLP();
1598         return true;
1599     }
1600 
1601     function manualBurnLiquidityPairTokens(uint256 percent)
1602         external
1603         onlyOwner
1604         returns (bool)
1605     {
1606         require(
1607             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1608             "Must wait for cooldown to finish"
1609         );
1610         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1611         lastManualLpBurnTime = block.timestamp;
1612 
1613         // get balance of liquidity pair
1614         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1615 
1616         // calculate amount to burn
1617         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1618 
1619         // pull tokens from pancakePair liquidity and move to dead address permanently
1620         if (amountToBurn > 0) {
1621             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1622         }
1623 
1624         //sync price since this is not in a swap transaction!
1625         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1626         pair.sync();
1627         emit ManualNukeLP();
1628         return true;
1629     }
1630 }