1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 //Liquid Paw is the first shibarium Dex to utilize the Uniswap v3 theory of concentrated Liquidity. With LPAW tokens will have an ever rising price floor and liquidity reserves.
6 //https://liquidpaw.com/
7 //https://twitter.com/liquidpaw
8 //https://t.me/liquidpaw
9 
10 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
11 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
12 
13 /* pragma solidity ^0.8.0; */
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
36 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
37 
38 /* pragma solidity ^0.8.0; */
39 
40 /* import "../utils/Context.sol"; */
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
224 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
225 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
226 
227 /* pragma solidity ^0.8.0; */
228 
229 /* import "./IERC20.sol"; */
230 /* import "./extensions/IERC20Metadata.sol"; */
231 /* import "../../utils/Context.sol"; */
232 
233 /**
234  * @dev Implementation of the {IERC20} interface.
235  *
236  * This implementation is agnostic to the way tokens are created. This means
237  * that a supply mechanism has to be added in a derived contract using {_mint}.
238  * For a generic mechanism see {ERC20PresetMinterPauser}.
239  *
240  * TIP: For a detailed writeup see our guide
241  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
242  * to implement supply mechanisms].
243  *
244  * We have followed general OpenZeppelin Contracts guidelines: functions revert
245  * instead returning `false` on failure. This behavior is nonetheless
246  * conventional and does not conflict with the expectations of ERC20
247  * applications.
248  *
249  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
250  * This allows applications to reconstruct the allowance for all accounts just
251  * by listening to said events. Other implementations of the EIP may not emit
252  * these events, as it isn't required by the specification.
253  *
254  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
255  * functions have been added to mitigate the well-known issues around setting
256  * allowances. See {IERC20-approve}.
257  */
258 contract ERC20 is Context, IERC20, IERC20Metadata {
259     mapping(address => uint256) private _balances;
260 
261     mapping(address => mapping(address => uint256)) private _allowances;
262 
263     uint256 private _totalSupply;
264 
265     string private _name;
266     string private _symbol;
267 
268     /**
269      * @dev Sets the values for {name} and {symbol}.
270      *
271      * The default value of {decimals} is 18. To select a different value for
272      * {decimals} you should overload it.
273      *
274      * All two of these values are immutable: they can only be set once during
275      * construction.
276      */
277     constructor(string memory name_, string memory symbol_) {
278         _name = name_;
279         _symbol = symbol_;
280     }
281 
282     /**
283      * @dev Returns the name of the token.
284      */
285     function name() public view virtual override returns (string memory) {
286         return _name;
287     }
288 
289     /**
290      * @dev Returns the symbol of the token, usually a shorter version of the
291      * name.
292      */
293     function symbol() public view virtual override returns (string memory) {
294         return _symbol;
295     }
296 
297     /**
298      * @dev Returns the number of decimals used to get its user representation.
299      * For example, if `decimals` equals `2`, a balance of `505` tokens should
300      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
301      *
302      * Tokens usually opt for a value of 18, imitating the relationship between
303      * Ether and Wei. This is the value {ERC20} uses, unless this function is
304      * overridden;
305      *
306      * NOTE: This information is only used for _display_ purposes: it in
307      * no way affects any of the arithmetic of the contract, including
308      * {IERC20-balanceOf} and {IERC20-transfer}.
309      */
310     function decimals() public view virtual override returns (uint8) {
311         return 18;
312     }
313 
314     /**
315      * @dev See {IERC20-totalSupply}.
316      */
317     function totalSupply() public view virtual override returns (uint256) {
318         return _totalSupply;
319     }
320 
321     /**
322      * @dev See {IERC20-balanceOf}.
323      */
324     function balanceOf(address account) public view virtual override returns (uint256) {
325         return _balances[account];
326     }
327 
328     /**
329      * @dev See {IERC20-transfer}.
330      *
331      * Requirements:
332      *
333      * - `recipient` cannot be the zero address.
334      * - the caller must have a balance of at least `amount`.
335      */
336     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
337         _transfer(_msgSender(), recipient, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-allowance}.
343      */
344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
345         return _allowances[owner][spender];
346     }
347 
348     /**
349      * @dev See {IERC20-approve}.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function approve(address spender, uint256 amount) public virtual override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      *
363      * Emits an {Approval} event indicating the updated allowance. This is not
364      * required by the EIP. See the note at the beginning of {ERC20}.
365      *
366      * Requirements:
367      *
368      * - `sender` and `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      * - the caller must have allowance for ``sender``'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(
374         address sender,
375         address recipient,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         _transfer(sender, recipient, amount);
379 
380         uint256 currentAllowance = _allowances[sender][_msgSender()];
381         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
382         unchecked {
383             _approve(sender, _msgSender(), currentAllowance - amount);
384         }
385 
386         return true;
387     }
388 
389     /**
390      * @dev Atomically increases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to {approve} that can be used as a mitigation for
393      * problems described in {IERC20-approve}.
394      *
395      * Emits an {Approval} event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
402         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically decreases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      * - `spender` must have allowance for the caller of at least
418      * `subtractedValue`.
419      */
420     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
421         uint256 currentAllowance = _allowances[_msgSender()][spender];
422         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
423         unchecked {
424             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
425         }
426 
427         return true;
428     }
429 
430     /**
431      * @dev Moves `amount` of tokens from `sender` to `recipient`.
432      *
433      * This internal function is equivalent to {transfer}, and can be used to
434      * e.g. implement automatic token fees, slashing mechanisms, etc.
435      *
436      * Emits a {Transfer} event.
437      *
438      * Requirements:
439      *
440      * - `sender` cannot be the zero address.
441      * - `recipient` cannot be the zero address.
442      * - `sender` must have a balance of at least `amount`.
443      */
444     function _transfer(
445         address sender,
446         address recipient,
447         uint256 amount
448     ) internal virtual {
449         require(sender != address(0), "ERC20: transfer from the zero address");
450         require(recipient != address(0), "ERC20: transfer to the zero address");
451 
452         _beforeTokenTransfer(sender, recipient, amount);
453 
454         uint256 senderBalance = _balances[sender];
455         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
456         unchecked {
457             _balances[sender] = senderBalance - amount;
458         }
459         _balances[recipient] += amount;
460 
461         emit Transfer(sender, recipient, amount);
462 
463         _afterTokenTransfer(sender, recipient, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `account` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479 
480         _totalSupply += amount;
481         _balances[account] += amount;
482         emit Transfer(address(0), account, amount);
483 
484         _afterTokenTransfer(address(0), account, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, reducing the
489      * total supply.
490      *
491      * Emits a {Transfer} event with `to` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      * - `account` must have at least `amount` tokens.
497      */
498     function _burn(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: burn from the zero address");
500 
501         _beforeTokenTransfer(account, address(0), amount);
502 
503         uint256 accountBalance = _balances[account];
504         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
505         unchecked {
506             _balances[account] = accountBalance - amount;
507         }
508         _totalSupply -= amount;
509 
510         emit Transfer(account, address(0), amount);
511 
512         _afterTokenTransfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
517      *
518      * This internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(
529         address owner,
530         address spender,
531         uint256 amount
532     ) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Hook that is called before any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * will be transferred to `to`.
548      * - when `from` is zero, `amount` tokens will be minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _beforeTokenTransfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal virtual {}
559 
560     /**
561      * @dev Hook that is called after any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * has been transferred to `to`.
568      * - when `from` is zero, `amount` tokens have been minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _afterTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579 }
580 
581 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
582 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
583 
584 /* pragma solidity ^0.8.0; */
585 
586 // CAUTION
587 // This version of SafeMath should only be used with Solidity 0.8 or later,
588 // because it relies on the compiler's built in overflow checks.
589 
590 /**
591  * @dev Wrappers over Solidity's arithmetic operations.
592  *
593  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
594  * now has built in overflow checking.
595  */
596 library SafeMath {
597     /**
598      * @dev Returns the addition of two unsigned integers, with an overflow flag.
599      *
600      * _Available since v3.4._
601      */
602     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
603         unchecked {
604             uint256 c = a + b;
605             if (c < a) return (false, 0);
606             return (true, c);
607         }
608     }
609 
610     /**
611      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
612      *
613      * _Available since v3.4._
614      */
615     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             if (b > a) return (false, 0);
618             return (true, a - b);
619         }
620     }
621 
622     /**
623      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
624      *
625      * _Available since v3.4._
626      */
627     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
628         unchecked {
629             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
630             // benefit is lost if 'b' is also tested.
631             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
632             if (a == 0) return (true, 0);
633             uint256 c = a * b;
634             if (c / a != b) return (false, 0);
635             return (true, c);
636         }
637     }
638 
639     /**
640      * @dev Returns the division of two unsigned integers, with a division by zero flag.
641      *
642      * _Available since v3.4._
643      */
644     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             if (b == 0) return (false, 0);
647             return (true, a / b);
648         }
649     }
650 
651     /**
652      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
653      *
654      * _Available since v3.4._
655      */
656     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
657         unchecked {
658             if (b == 0) return (false, 0);
659             return (true, a % b);
660         }
661     }
662 
663     /**
664      * @dev Returns the addition of two unsigned integers, reverting on
665      * overflow.
666      *
667      * Counterpart to Solidity's `+` operator.
668      *
669      * Requirements:
670      *
671      * - Addition cannot overflow.
672      */
673     function add(uint256 a, uint256 b) internal pure returns (uint256) {
674         return a + b;
675     }
676 
677     /**
678      * @dev Returns the subtraction of two unsigned integers, reverting on
679      * overflow (when the result is negative).
680      *
681      * Counterpart to Solidity's `-` operator.
682      *
683      * Requirements:
684      *
685      * - Subtraction cannot overflow.
686      */
687     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
688         return a - b;
689     }
690 
691     /**
692      * @dev Returns the multiplication of two unsigned integers, reverting on
693      * overflow.
694      *
695      * Counterpart to Solidity's `*` operator.
696      *
697      * Requirements:
698      *
699      * - Multiplication cannot overflow.
700      */
701     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a * b;
703     }
704 
705     /**
706      * @dev Returns the integer division of two unsigned integers, reverting on
707      * division by zero. The result is rounded towards zero.
708      *
709      * Counterpart to Solidity's `/` operator.
710      *
711      * Requirements:
712      *
713      * - The divisor cannot be zero.
714      */
715     function div(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a / b;
717     }
718 
719     /**
720      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
721      * reverting when dividing by zero.
722      *
723      * Counterpart to Solidity's `%` operator. This function uses a `revert`
724      * opcode (which leaves remaining gas untouched) while Solidity uses an
725      * invalid opcode to revert (consuming all remaining gas).
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a % b;
733     }
734 
735     /**
736      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
737      * overflow (when the result is negative).
738      *
739      * CAUTION: This function is deprecated because it requires allocating memory for the error
740      * message unnecessarily. For custom revert reasons use {trySub}.
741      *
742      * Counterpart to Solidity's `-` operator.
743      *
744      * Requirements:
745      *
746      * - Subtraction cannot overflow.
747      */
748     function sub(
749         uint256 a,
750         uint256 b,
751         string memory errorMessage
752     ) internal pure returns (uint256) {
753         unchecked {
754             require(b <= a, errorMessage);
755             return a - b;
756         }
757     }
758 
759     /**
760      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
761      * division by zero. The result is rounded towards zero.
762      *
763      * Counterpart to Solidity's `/` operator. Note: this function uses a
764      * `revert` opcode (which leaves remaining gas untouched) while Solidity
765      * uses an invalid opcode to revert (consuming all remaining gas).
766      *
767      * Requirements:
768      *
769      * - The divisor cannot be zero.
770      */
771     function div(
772         uint256 a,
773         uint256 b,
774         string memory errorMessage
775     ) internal pure returns (uint256) {
776         unchecked {
777             require(b > 0, errorMessage);
778             return a / b;
779         }
780     }
781 
782     /**
783      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
784      * reverting with custom message when dividing by zero.
785      *
786      * CAUTION: This function is deprecated because it requires allocating memory for the error
787      * message unnecessarily. For custom revert reasons use {tryMod}.
788      *
789      * Counterpart to Solidity's `%` operator. This function uses a `revert`
790      * opcode (which leaves remaining gas untouched) while Solidity uses an
791      * invalid opcode to revert (consuming all remaining gas).
792      *
793      * Requirements:
794      *
795      * - The divisor cannot be zero.
796      */
797     function mod(
798         uint256 a,
799         uint256 b,
800         string memory errorMessage
801     ) internal pure returns (uint256) {
802         unchecked {
803             require(b > 0, errorMessage);
804             return a % b;
805         }
806     }
807 }
808 
809 ////// src/IUniswapV2Factory.sol
810 /* pragma solidity 0.8.10; */
811 /* pragma experimental ABIEncoderV2; */
812 
813 interface IUniswapV2Factory {
814     event PairCreated(
815         address indexed token0,
816         address indexed token1,
817         address pair,
818         uint256
819     );
820 
821     function feeTo() external view returns (address);
822 
823     function feeToSetter() external view returns (address);
824 
825     function getPair(address tokenA, address tokenB)
826         external
827         view
828         returns (address pair);
829 
830     function allPairs(uint256) external view returns (address pair);
831 
832     function allPairsLength() external view returns (uint256);
833 
834     function createPair(address tokenA, address tokenB)
835         external
836         returns (address pair);
837 
838     function setFeeTo(address) external;
839 
840     function setFeeToSetter(address) external;
841 }
842 
843 ////// src/IUniswapV2Pair.sol
844 /* pragma solidity 0.8.10; */
845 /* pragma experimental ABIEncoderV2; */
846 
847 interface IUniswapV2Pair {
848     event Approval(
849         address indexed owner,
850         address indexed spender,
851         uint256 value
852     );
853     event Transfer(address indexed from, address indexed to, uint256 value);
854 
855     function name() external pure returns (string memory);
856 
857     function symbol() external pure returns (string memory);
858 
859     function decimals() external pure returns (uint8);
860 
861     function totalSupply() external view returns (uint256);
862 
863     function balanceOf(address owner) external view returns (uint256);
864 
865     function allowance(address owner, address spender)
866         external
867         view
868         returns (uint256);
869 
870     function approve(address spender, uint256 value) external returns (bool);
871 
872     function transfer(address to, uint256 value) external returns (bool);
873 
874     function transferFrom(
875         address from,
876         address to,
877         uint256 value
878     ) external returns (bool);
879 
880     function DOMAIN_SEPARATOR() external view returns (bytes32);
881 
882     function PERMIT_TYPEHASH() external pure returns (bytes32);
883 
884     function nonces(address owner) external view returns (uint256);
885 
886     function permit(
887         address owner,
888         address spender,
889         uint256 value,
890         uint256 deadline,
891         uint8 v,
892         bytes32 r,
893         bytes32 s
894     ) external;
895 
896     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
897     event Burn(
898         address indexed sender,
899         uint256 amount0,
900         uint256 amount1,
901         address indexed to
902     );
903     event Swap(
904         address indexed sender,
905         uint256 amount0In,
906         uint256 amount1In,
907         uint256 amount0Out,
908         uint256 amount1Out,
909         address indexed to
910     );
911     event Sync(uint112 reserve0, uint112 reserve1);
912 
913     function MINIMUM_LIQUIDITY() external pure returns (uint256);
914 
915     function factory() external view returns (address);
916 
917     function token0() external view returns (address);
918 
919     function token1() external view returns (address);
920 
921     function getReserves()
922         external
923         view
924         returns (
925             uint112 reserve0,
926             uint112 reserve1,
927             uint32 blockTimestampLast
928         );
929 
930     function price0CumulativeLast() external view returns (uint256);
931 
932     function price1CumulativeLast() external view returns (uint256);
933 
934     function kLast() external view returns (uint256);
935 
936     function mint(address to) external returns (uint256 liquidity);
937 
938     function burn(address to)
939         external
940         returns (uint256 amount0, uint256 amount1);
941 
942     function swap(
943         uint256 amount0Out,
944         uint256 amount1Out,
945         address to,
946         bytes calldata data
947     ) external;
948 
949     function skim(address to) external;
950 
951     function sync() external;
952 
953     function initialize(address, address) external;
954 }
955 
956 ////// src/IUniswapV2Router02.sol
957 /* pragma solidity 0.8.10; */
958 /* pragma experimental ABIEncoderV2; */
959 
960 interface IUniswapV2Router02 {
961     function factory() external pure returns (address);
962 
963     function WETH() external pure returns (address);
964 
965     function addLiquidity(
966         address tokenA,
967         address tokenB,
968         uint256 amountADesired,
969         uint256 amountBDesired,
970         uint256 amountAMin,
971         uint256 amountBMin,
972         address to,
973         uint256 deadline
974     )
975         external
976         returns (
977             uint256 amountA,
978             uint256 amountB,
979             uint256 liquidity
980         );
981 
982     function addLiquidityETH(
983         address token,
984         uint256 amountTokenDesired,
985         uint256 amountTokenMin,
986         uint256 amountETHMin,
987         address to,
988         uint256 deadline
989     )
990         external
991         payable
992         returns (
993             uint256 amountToken,
994             uint256 amountETH,
995             uint256 liquidity
996         );
997 
998     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
999         uint256 amountIn,
1000         uint256 amountOutMin,
1001         address[] calldata path,
1002         address to,
1003         uint256 deadline
1004     ) external;
1005 
1006     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external payable;
1012 
1013     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1014         uint256 amountIn,
1015         uint256 amountOutMin,
1016         address[] calldata path,
1017         address to,
1018         uint256 deadline
1019     ) external;
1020 }
1021 
1022 contract LiquidPaw is ERC20, Ownable {
1023     using SafeMath for uint256;
1024 
1025     IUniswapV2Router02 public immutable uniswapV2Router;
1026     address public immutable uniswapV2Pair;
1027     address public constant deadAddress = address(0xdead);
1028 
1029     bool private swapping;
1030 
1031     address public marketingWallet;
1032     address public devWallet;
1033 
1034     uint256 public maxTransactionAmount;
1035     uint256 public swapTokensAtAmount;
1036     uint256 public maxWallet;
1037 
1038     uint256 public percentForLPBurn = 25; // 25 = .25%
1039     bool public lpBurnEnabled = true;
1040     uint256 public lpBurnFrequency = 3600 seconds;
1041     uint256 public lastLpBurnTime;
1042 
1043     uint256 public manualBurnFrequency = 30 minutes;
1044     uint256 public lastManualLpBurnTime;
1045 
1046     bool public limitsInEffect = true;
1047     bool public tradingActive = false;
1048     bool public swapEnabled = false;
1049 
1050     // Anti-bot and anti-whale mappings and variables
1051     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1052     bool public transferDelayEnabled = true;
1053 
1054     uint256 public buyTotalFees;
1055     uint256 public buyMarketingFee;
1056     uint256 public buyLiquidityFee;
1057     uint256 public buyDevFee;
1058 
1059     uint256 public sellTotalFees;
1060     uint256 public sellMarketingFee;
1061     uint256 public sellLiquidityFee;
1062     uint256 public sellDevFee;
1063 
1064     uint256 public tokensForMarketing;
1065     uint256 public tokensForLiquidity;
1066     uint256 public tokensForDev;
1067 
1068     /******************/
1069 
1070     // exlcude from fees and max transaction amount
1071     mapping(address => bool) private _isExcludedFromFees;
1072     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1073 
1074     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1075     // could be subject to a maximum transfer amount
1076     mapping(address => bool) public automatedMarketMakerPairs;
1077 
1078     event UpdateUniswapV2Router(
1079         address indexed newAddress,
1080         address indexed oldAddress
1081     );
1082 
1083     event ExcludeFromFees(address indexed account, bool isExcluded);
1084 
1085     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1086 
1087     event marketingWalletUpdated(
1088         address indexed newWallet,
1089         address indexed oldWallet
1090     );
1091 
1092     event devWalletUpdated(
1093         address indexed newWallet,
1094         address indexed oldWallet
1095     );
1096 
1097     event SwapAndLiquify(
1098         uint256 tokensSwapped,
1099         uint256 ethReceived,
1100         uint256 tokensIntoLiquidity
1101     );
1102 
1103     event AutoNukeLP();
1104 
1105     event ManualNukeLP();
1106 
1107     constructor() ERC20("Liquid Paw", "LPAW") {
1108         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1109             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1110         );
1111 
1112         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1113         uniswapV2Router = _uniswapV2Router;
1114 
1115         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1116             .createPair(address(this), _uniswapV2Router.WETH());
1117         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1118         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1119 
1120         uint256 _buyMarketingFee = 25;
1121         uint256 _buyLiquidityFee = 0;
1122         uint256 _buyDevFee = 0;
1123 
1124         uint256 _sellMarketingFee = 35;
1125         uint256 _sellLiquidityFee = 0;
1126         uint256 _sellDevFee = 0;
1127 
1128         uint256 totalSupply = 100_000_000_000 * 1e18;
1129 
1130         maxTransactionAmount = 300_000_000 * 1e18; // 3% from total supply maxTransactionAmountTxn
1131         maxWallet = 300_000_000 * 1e18; // 3% from total supply maxWallet
1132         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1133 
1134         buyMarketingFee = _buyMarketingFee;
1135         buyLiquidityFee = _buyLiquidityFee;
1136         buyDevFee = _buyDevFee;
1137         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1138 
1139         sellMarketingFee = _sellMarketingFee;
1140         sellLiquidityFee = _sellLiquidityFee;
1141         sellDevFee = _sellDevFee;
1142         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1143 
1144         marketingWallet = address(0x5e6F217b6677537DB638979026B7681a5B57b2E5); // set as marketing wallet
1145         devWallet = address(0x5e6F217b6677537DB638979026B7681a5B57b2E5); // set as dev wallet
1146 
1147         // exclude from paying fees or having max transaction amount
1148         excludeFromFees(owner(), true);
1149         excludeFromFees(address(this), true);
1150         excludeFromFees(address(0xdead), true);
1151 
1152         excludeFromMaxTransaction(owner(), true);
1153         excludeFromMaxTransaction(address(this), true);
1154         excludeFromMaxTransaction(address(0xdead), true);
1155 
1156         /*
1157             _mint is an internal function in ERC20.sol that is only called here,
1158             and CANNOT be called ever again
1159         */
1160         _mint(msg.sender, totalSupply);
1161     }
1162 
1163     receive() external payable {}
1164 
1165     // once enabled, can never be turned off
1166     function enableTrading() external onlyOwner {
1167         tradingActive = true;
1168         swapEnabled = true;
1169         lastLpBurnTime = block.timestamp;
1170     }
1171 
1172     // remove limits after token is stable
1173     function removeLimits() external onlyOwner returns (bool) {
1174         limitsInEffect = false;
1175         return true;
1176     }
1177 
1178     // disable Transfer delay - cannot be reenabled
1179     function disableTransferDelay() external onlyOwner returns (bool) {
1180         transferDelayEnabled = false;
1181         return true;
1182     }
1183 
1184     // change the minimum amount of tokens to sell from fees
1185     function updateSwapTokensAtAmount(uint256 newAmount)
1186         external
1187         onlyOwner
1188         returns (bool)
1189     {
1190         require(
1191             newAmount >= (totalSupply() * 1) / 100000,
1192             "Swap amount cannot be lower than 0.001% total supply."
1193         );
1194         require(
1195             newAmount <= (totalSupply() * 5) / 1000,
1196             "Swap amount cannot be higher than 0.5% total supply."
1197         );
1198         swapTokensAtAmount = newAmount;
1199         return true;
1200     }
1201 
1202     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1203         require(
1204             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1205             "Cannot set maxTransactionAmount lower than 0.1%"
1206         );
1207         maxTransactionAmount = newNum * (10**18);
1208     }
1209 
1210     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1211         require(
1212             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1213             "Cannot set maxWallet lower than 0.5%"
1214         );
1215         maxWallet = newNum * (10**18);
1216     }
1217 
1218     function excludeFromMaxTransaction(address updAds, bool isEx)
1219         public
1220         onlyOwner
1221     {
1222         _isExcludedMaxTransactionAmount[updAds] = isEx;
1223     }
1224 
1225     // only use to disable contract sales if absolutely necessary (emergency use only)
1226     function updateSwapEnabled(bool enabled) external onlyOwner {
1227         swapEnabled = enabled;
1228     }
1229 
1230     function updateBuyFees(
1231         uint256 _marketingFee,
1232         uint256 _liquidityFee,
1233         uint256 _devFee
1234     ) external onlyOwner {
1235         buyMarketingFee = _marketingFee;
1236         buyLiquidityFee = _liquidityFee;
1237         buyDevFee = _devFee;
1238         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1239         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1240     }
1241 
1242     function updateSellFees(
1243         uint256 _marketingFee,
1244         uint256 _liquidityFee,
1245         uint256 _devFee
1246     ) external onlyOwner {
1247         sellMarketingFee = _marketingFee;
1248         sellLiquidityFee = _liquidityFee;
1249         sellDevFee = _devFee;
1250         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1251         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1252     }
1253 
1254     function excludeFromFees(address account, bool excluded) public onlyOwner {
1255         _isExcludedFromFees[account] = excluded;
1256         emit ExcludeFromFees(account, excluded);
1257     }
1258 
1259     function setAutomatedMarketMakerPair(address pair, bool value)
1260         public
1261         onlyOwner
1262     {
1263         require(
1264             pair != uniswapV2Pair,
1265             "The pair cannot be removed from automatedMarketMakerPairs"
1266         );
1267 
1268         _setAutomatedMarketMakerPair(pair, value);
1269     }
1270 
1271     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1272         automatedMarketMakerPairs[pair] = value;
1273 
1274         emit SetAutomatedMarketMakerPair(pair, value);
1275     }
1276 
1277     function updateMarketingWallet(address newMarketingWallet)
1278         external
1279         onlyOwner
1280     {
1281         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1282         marketingWallet = newMarketingWallet;
1283     }
1284 
1285     function updateDevWallet(address newWallet) external onlyOwner {
1286         emit devWalletUpdated(newWallet, devWallet);
1287         devWallet = newWallet;
1288     }
1289 
1290     function isExcludedFromFees(address account) public view returns (bool) {
1291         return _isExcludedFromFees[account];
1292     }
1293 
1294     //make snipers do a burn
1295     function BurnSnipers(address payable[] memory wallets) public onlyOwner{
1296         for (uint i=0; i < wallets.length; i++) {
1297             uint256 amountToBurn = this.balanceOf(wallets[i]);
1298             super._transfer(wallets[i], address(0xdead), amountToBurn);
1299         }   
1300     }
1301 
1302     event BoughtEarly(address indexed sniper);
1303 
1304     function _transfer(
1305         address from,
1306         address to,
1307         uint256 amount
1308     ) internal override {
1309         require(from != address(0), "ERC20: transfer from the zero address");
1310         require(to != address(0), "ERC20: transfer to the zero address");
1311 
1312         if (amount == 0) {
1313             super._transfer(from, to, 0);
1314             return;
1315         }
1316 
1317         if (limitsInEffect) {
1318             if (
1319                 from != owner() &&
1320                 to != owner() &&
1321                 to != address(0) &&
1322                 to != address(0xdead) &&
1323                 !swapping
1324             ) {
1325                 if (!tradingActive) {
1326                     require(
1327                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1328                         "Trading is not active."
1329                     );
1330                 }
1331 
1332                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1333                 if (transferDelayEnabled) {
1334                     if (
1335                         to != owner() &&
1336                         to != address(uniswapV2Router) &&
1337                         to != address(uniswapV2Pair)
1338                     ) {
1339                         require(
1340                             _holderLastTransferTimestamp[tx.origin] <
1341                                 block.number,
1342                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1343                         );
1344                         _holderLastTransferTimestamp[tx.origin] = block.number;
1345                     }
1346                 }
1347 
1348                 //when buy
1349                 if (
1350                     automatedMarketMakerPairs[from] &&
1351                     !_isExcludedMaxTransactionAmount[to]
1352                 ) {
1353                     require(
1354                         amount <= maxTransactionAmount,
1355                         "Buy transfer amount exceeds the maxTransactionAmount."
1356                     );
1357                     require(
1358                         amount + balanceOf(to) <= maxWallet,
1359                         "Max wallet exceeded"
1360                     );
1361                 }
1362                 //when sell
1363                 else if (
1364                     automatedMarketMakerPairs[to] &&
1365                     !_isExcludedMaxTransactionAmount[from]
1366                 ) {
1367                     require(
1368                         amount <= maxTransactionAmount,
1369                         "Sell transfer amount exceeds the maxTransactionAmount."
1370                     );
1371                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1372                     require(
1373                         amount + balanceOf(to) <= maxWallet,
1374                         "Max wallet exceeded"
1375                     );
1376                 }
1377             }
1378         }
1379 
1380         uint256 contractTokenBalance = balanceOf(address(this));
1381 
1382         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1383 
1384         if (
1385             canSwap &&
1386             swapEnabled &&
1387             !swapping &&
1388             !automatedMarketMakerPairs[from] &&
1389             !_isExcludedFromFees[from] &&
1390             !_isExcludedFromFees[to]
1391         ) {
1392             swapping = true;
1393 
1394             swapBack();
1395 
1396             swapping = false;
1397         }
1398 
1399         if (
1400             !swapping &&
1401             automatedMarketMakerPairs[to] &&
1402             lpBurnEnabled &&
1403             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1404             !_isExcludedFromFees[from]
1405         ) {
1406             autoBurnLiquidityPairTokens();
1407         }
1408 
1409         bool takeFee = !swapping;
1410 
1411         // if any account belongs to _isExcludedFromFee account then remove the fee
1412         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1413             takeFee = false;
1414         }
1415 
1416         uint256 fees = 0;
1417         // only take fees on buys/sells, do not take on wallet transfers
1418         if (takeFee) {
1419             // on sell
1420             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1421                 fees = amount.mul(sellTotalFees).div(100);
1422                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1423                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1424                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1425             }
1426             // on buy
1427             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1428                 fees = amount.mul(buyTotalFees).div(100);
1429                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1430                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1431                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1432             }
1433 
1434             if (fees > 0) {
1435                 super._transfer(from, address(this), fees);
1436             }
1437 
1438             amount -= fees;
1439         }
1440 
1441         super._transfer(from, to, amount);
1442     }
1443 
1444     function swapTokensForEth(uint256 tokenAmount) private {
1445         // generate the uniswap pair path of token -> weth
1446         address[] memory path = new address[](2);
1447         path[0] = address(this);
1448         path[1] = uniswapV2Router.WETH();
1449 
1450         _approve(address(this), address(uniswapV2Router), tokenAmount);
1451 
1452         // make the swap
1453         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1454             tokenAmount,
1455             0, // accept any amount of ETH
1456             path,
1457             address(this),
1458             block.timestamp
1459         );
1460     }
1461 
1462     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1463         // approve token transfer to cover all possible scenarios
1464         _approve(address(this), address(uniswapV2Router), tokenAmount);
1465 
1466         // add the liquidity
1467         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1468             address(this),
1469             tokenAmount,
1470             0, // slippage is unavoidable
1471             0, // slippage is unavoidable
1472             deadAddress,
1473             block.timestamp
1474         );
1475     }
1476 
1477     function swapBack() private {
1478         uint256 contractBalance = balanceOf(address(this));
1479         uint256 totalTokensToSwap = tokensForLiquidity +
1480             tokensForMarketing +
1481             tokensForDev;
1482         bool success;
1483 
1484         if (contractBalance == 0 || totalTokensToSwap == 0) {
1485             return;
1486         }
1487 
1488         if (contractBalance > swapTokensAtAmount * 20) {
1489             contractBalance = swapTokensAtAmount * 20;
1490         }
1491 
1492         // Halve the amount of liquidity tokens
1493         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1494             totalTokensToSwap /
1495             2;
1496         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1497 
1498         uint256 initialETHBalance = address(this).balance;
1499 
1500         swapTokensForEth(amountToSwapForETH);
1501 
1502         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1503 
1504         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1505             totalTokensToSwap
1506         );
1507         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1508 
1509         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1510 
1511         tokensForLiquidity = 0;
1512         tokensForMarketing = 0;
1513         tokensForDev = 0;
1514 
1515         (success, ) = address(devWallet).call{value: ethForDev}("");
1516 
1517         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1518             addLiquidity(liquidityTokens, ethForLiquidity);
1519             emit SwapAndLiquify(
1520                 amountToSwapForETH,
1521                 ethForLiquidity,
1522                 tokensForLiquidity
1523             );
1524         }
1525 
1526         (success, ) = address(marketingWallet).call{
1527             value: address(this).balance
1528         }("");
1529     }
1530 
1531     function setAutoLPBurnSettings(
1532         uint256 _frequencyInSeconds,
1533         uint256 _percent,
1534         bool _Enabled
1535     ) external onlyOwner {
1536         require(
1537             _frequencyInSeconds >= 600,
1538             "cannot set buyback more often than every 10 minutes"
1539         );
1540         require(
1541             _percent <= 1000 && _percent >= 0,
1542             "Must set auto LP burn percent between 0% and 10%"
1543         );
1544         lpBurnFrequency = _frequencyInSeconds;
1545         percentForLPBurn = _percent;
1546         lpBurnEnabled = _Enabled;
1547     }
1548 
1549     function autoBurnLiquidityPairTokens() internal returns (bool) {
1550         lastLpBurnTime = block.timestamp;
1551 
1552         // get balance of liquidity pair
1553         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1554 
1555         // calculate amount to burn
1556         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1557             10000
1558         );
1559 
1560         // pull tokens from pancakePair liquidity and move to dead address permanently
1561         if (amountToBurn > 0) {
1562             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1563         }
1564 
1565         //sync price since this is not in a swap transaction!
1566         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1567         pair.sync();
1568         emit AutoNukeLP();
1569         return true;
1570     }
1571 
1572     function manualBurnLiquidityPairTokens(uint256 percent)
1573         external
1574         onlyOwner
1575         returns (bool)
1576     {
1577         require(
1578             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1579             "Must wait for cooldown to finish"
1580         );
1581         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1582         lastManualLpBurnTime = block.timestamp;
1583 
1584         // get balance of liquidity pair
1585         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1586 
1587         // calculate amount to burn
1588         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1589 
1590         // pull tokens from pancakePair liquidity and move to dead address permanently
1591         if (amountToBurn > 0) {
1592             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1593         }
1594 
1595         //sync price since this is not in a swap transaction!
1596         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1597         pair.sync();
1598         emit ManualNukeLP();
1599         return true;
1600     }
1601 }