1 /**
2 
3 t.me/bountytech
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 
11 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
12 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
13 
14 /* pragma solidity ^0.8.0; */
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
37 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
38 
39 /* pragma solidity ^0.8.0; */
40 
41 /* import "../utils/Context.sol"; */
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
114 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
115 
116 /* pragma solidity ^0.8.0; */
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Returns the remaining number of tokens that `spender` will be
143      * allowed to spend on behalf of `owner` through {transferFrom}. This is
144      * zero by default.
145      *
146      * This value changes when {approve} or {transferFrom} are called.
147      */
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
197 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
198 
199 /* pragma solidity ^0.8.0; */
200 
201 /* import "../IERC20.sol"; */
202 
203 /**
204  * @dev Interface for the optional metadata functions from the ERC20 standard.
205  *
206  * _Available since v4.1._
207  */
208 interface IERC20Metadata is IERC20 {
209     /**
210      * @dev Returns the name of the token.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the symbol of the token.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the decimals places of the token.
221      */
222     function decimals() external view returns (uint8);
223 }
224 
225 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
226 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
227 
228 /* pragma solidity ^0.8.0; */
229 
230 /* import "./IERC20.sol"; */
231 /* import "./extensions/IERC20Metadata.sol"; */
232 /* import "../../utils/Context.sol"; */
233 
234 /**
235  * @dev Implementation of the {IERC20} interface.
236  *
237  * This implementation is agnostic to the way tokens are created. This means
238  * that a supply mechanism has to be added in a derived contract using {_mint}.
239  * For a generic mechanism see {ERC20PresetMinterPauser}.
240  *
241  * TIP: For a detailed writeup see our guide
242  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
243  * to implement supply mechanisms].
244  *
245  * We have followed general OpenZeppelin Contracts guidelines: functions revert
246  * instead returning `false` on failure. This behavior is nonetheless
247  * conventional and does not conflict with the expectations of ERC20
248  * applications.
249  *
250  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
251  * This allows applications to reconstruct the allowance for all accounts just
252  * by listening to said events. Other implementations of the EIP may not emit
253  * these events, as it isn't required by the specification.
254  *
255  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
256  * functions have been added to mitigate the well-known issues around setting
257  * allowances. See {IERC20-approve}.
258  */
259 contract ERC20 is Context, IERC20, IERC20Metadata {
260     mapping(address => uint256) private _balances;
261 
262     mapping(address => mapping(address => uint256)) private _allowances;
263 
264     uint256 private _totalSupply;
265 
266     string private _name;
267     string private _symbol;
268 
269     /**
270      * @dev Sets the values for {name} and {symbol}.
271      *
272      * The default value of {decimals} is 18. To select a different value for
273      * {decimals} you should overload it.
274      *
275      * All two of these values are immutable: they can only be set once during
276      * construction.
277      */
278     constructor(string memory name_, string memory symbol_) {
279         _name = name_;
280         _symbol = symbol_;
281     }
282 
283     /**
284      * @dev Returns the name of the token.
285      */
286     function name() public view virtual override returns (string memory) {
287         return _name;
288     }
289 
290     /**
291      * @dev Returns the symbol of the token, usually a shorter version of the
292      * name.
293      */
294     function symbol() public view virtual override returns (string memory) {
295         return _symbol;
296     }
297 
298     /**
299      * @dev Returns the number of decimals used to get its user representation.
300      * For example, if `decimals` equals `2`, a balance of `505` tokens should
301      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
302      *
303      * Tokens usually opt for a value of 18, imitating the relationship between
304      * Ether and Wei. This is the value {ERC20} uses, unless this function is
305      * overridden;
306      *
307      * NOTE: This information is only used for _display_ purposes: it in
308      * no way affects any of the arithmetic of the contract, including
309      * {IERC20-balanceOf} and {IERC20-transfer}.
310      */
311     function decimals() public view virtual override returns (uint8) {
312         return 18;
313     }
314 
315     /**
316      * @dev See {IERC20-totalSupply}.
317      */
318     function totalSupply() public view virtual override returns (uint256) {
319         return _totalSupply;
320     }
321 
322     /**
323      * @dev See {IERC20-balanceOf}.
324      */
325     function balanceOf(address account) public view virtual override returns (uint256) {
326         return _balances[account];
327     }
328 
329     /**
330      * @dev See {IERC20-transfer}.
331      *
332      * Requirements:
333      *
334      * - `recipient` cannot be the zero address.
335      * - the caller must have a balance of at least `amount`.
336      */
337     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
338         _transfer(_msgSender(), recipient, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-allowance}.
344      */
345     function allowance(address owner, address spender) public view virtual override returns (uint256) {
346         return _allowances[owner][spender];
347     }
348 
349     /**
350      * @dev See {IERC20-approve}.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function approve(address spender, uint256 amount) public virtual override returns (bool) {
357         _approve(_msgSender(), spender, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-transferFrom}.
363      *
364      * Emits an {Approval} event indicating the updated allowance. This is not
365      * required by the EIP. See the note at the beginning of {ERC20}.
366      *
367      * Requirements:
368      *
369      * - `sender` and `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      * - the caller must have allowance for ``sender``'s tokens of at least
372      * `amount`.
373      */
374     function transferFrom(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) public virtual override returns (bool) {
379         _transfer(sender, recipient, amount);
380 
381         uint256 currentAllowance = _allowances[sender][_msgSender()];
382         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
383         unchecked {
384             _approve(sender, _msgSender(), currentAllowance - amount);
385         }
386 
387         return true;
388     }
389 
390     /**
391      * @dev Atomically increases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
403         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
404         return true;
405     }
406 
407     /**
408      * @dev Atomically decreases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      * - `spender` must have allowance for the caller of at least
419      * `subtractedValue`.
420      */
421     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
422         uint256 currentAllowance = _allowances[_msgSender()][spender];
423         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
424         unchecked {
425             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
426         }
427 
428         return true;
429     }
430 
431     /**
432      * @dev Moves `amount` of tokens from `sender` to `recipient`.
433      *
434      * This internal function is equivalent to {transfer}, and can be used to
435      * e.g. implement automatic token fees, slashing mechanisms, etc.
436      *
437      * Emits a {Transfer} event.
438      *
439      * Requirements:
440      *
441      * - `sender` cannot be the zero address.
442      * - `recipient` cannot be the zero address.
443      * - `sender` must have a balance of at least `amount`.
444      */
445     function _transfer(
446         address sender,
447         address recipient,
448         uint256 amount
449     ) internal virtual {
450         require(sender != address(0), "ERC20: transfer from the zero address");
451         require(recipient != address(0), "ERC20: transfer to the zero address");
452 
453         _beforeTokenTransfer(sender, recipient, amount);
454 
455         uint256 senderBalance = _balances[sender];
456         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
457         unchecked {
458             _balances[sender] = senderBalance - amount;
459         }
460         _balances[recipient] += amount;
461 
462         emit Transfer(sender, recipient, amount);
463 
464         _afterTokenTransfer(sender, recipient, amount);
465     }
466 
467     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
468      * the total supply.
469      *
470      * Emits a {Transfer} event with `from` set to the zero address.
471      *
472      * Requirements:
473      *
474      * - `account` cannot be the zero address.
475      */
476     function _mint(address account, uint256 amount) internal virtual {
477         require(account != address(0), "ERC20: mint to the zero address");
478 
479         _beforeTokenTransfer(address(0), account, amount);
480 
481         _totalSupply += amount;
482         _balances[account] += amount;
483         emit Transfer(address(0), account, amount);
484 
485         _afterTokenTransfer(address(0), account, amount);
486     }
487 
488     /**
489      * @dev Destroys `amount` tokens from `account`, reducing the
490      * total supply.
491      *
492      * Emits a {Transfer} event with `to` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `account` cannot be the zero address.
497      * - `account` must have at least `amount` tokens.
498      */
499     function _burn(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: burn from the zero address");
501 
502         _beforeTokenTransfer(account, address(0), amount);
503 
504         uint256 accountBalance = _balances[account];
505         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
506         unchecked {
507             _balances[account] = accountBalance - amount;
508         }
509         _totalSupply -= amount;
510 
511         emit Transfer(account, address(0), amount);
512 
513         _afterTokenTransfer(account, address(0), amount);
514     }
515 
516     /**
517      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
518      *
519      * This internal function is equivalent to `approve`, and can be used to
520      * e.g. set automatic allowances for certain subsystems, etc.
521      *
522      * Emits an {Approval} event.
523      *
524      * Requirements:
525      *
526      * - `owner` cannot be the zero address.
527      * - `spender` cannot be the zero address.
528      */
529     function _approve(
530         address owner,
531         address spender,
532         uint256 amount
533     ) internal virtual {
534         require(owner != address(0), "ERC20: approve from the zero address");
535         require(spender != address(0), "ERC20: approve to the zero address");
536 
537         _allowances[owner][spender] = amount;
538         emit Approval(owner, spender, amount);
539     }
540 
541     /**
542      * @dev Hook that is called before any transfer of tokens. This includes
543      * minting and burning.
544      *
545      * Calling conditions:
546      *
547      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
548      * will be transferred to `to`.
549      * - when `from` is zero, `amount` tokens will be minted for `to`.
550      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
551      * - `from` and `to` are never both zero.
552      *
553      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
554      */
555     function _beforeTokenTransfer(
556         address from,
557         address to,
558         uint256 amount
559     ) internal virtual {}
560 
561     /**
562      * @dev Hook that is called after any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * has been transferred to `to`.
569      * - when `from` is zero, `amount` tokens have been minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _afterTokenTransfer(
576         address from,
577         address to,
578         uint256 amount
579     ) internal virtual {}
580 }
581 
582 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
583 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
584 
585 /* pragma solidity ^0.8.0; */
586 
587 // CAUTION
588 // This version of SafeMath should only be used with Solidity 0.8 or later,
589 // because it relies on the compiler's built in overflow checks.
590 
591 /**
592  * @dev Wrappers over Solidity's arithmetic operations.
593  *
594  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
595  * now has built in overflow checking.
596  */
597 library SafeMath {
598     /**
599      * @dev Returns the addition of two unsigned integers, with an overflow flag.
600      *
601      * _Available since v3.4._
602      */
603     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             uint256 c = a + b;
606             if (c < a) return (false, 0);
607             return (true, c);
608         }
609     }
610 
611     /**
612      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
613      *
614      * _Available since v3.4._
615      */
616     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
617         unchecked {
618             if (b > a) return (false, 0);
619             return (true, a - b);
620         }
621     }
622 
623     /**
624      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
625      *
626      * _Available since v3.4._
627      */
628     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
629         unchecked {
630             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
631             // benefit is lost if 'b' is also tested.
632             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
633             if (a == 0) return (true, 0);
634             uint256 c = a * b;
635             if (c / a != b) return (false, 0);
636             return (true, c);
637         }
638     }
639 
640     /**
641      * @dev Returns the division of two unsigned integers, with a division by zero flag.
642      *
643      * _Available since v3.4._
644      */
645     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
646         unchecked {
647             if (b == 0) return (false, 0);
648             return (true, a / b);
649         }
650     }
651 
652     /**
653      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
654      *
655      * _Available since v3.4._
656      */
657     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
658         unchecked {
659             if (b == 0) return (false, 0);
660             return (true, a % b);
661         }
662     }
663 
664     /**
665      * @dev Returns the addition of two unsigned integers, reverting on
666      * overflow.
667      *
668      * Counterpart to Solidity's `+` operator.
669      *
670      * Requirements:
671      *
672      * - Addition cannot overflow.
673      */
674     function add(uint256 a, uint256 b) internal pure returns (uint256) {
675         return a + b;
676     }
677 
678     /**
679      * @dev Returns the subtraction of two unsigned integers, reverting on
680      * overflow (when the result is negative).
681      *
682      * Counterpart to Solidity's `-` operator.
683      *
684      * Requirements:
685      *
686      * - Subtraction cannot overflow.
687      */
688     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
689         return a - b;
690     }
691 
692     /**
693      * @dev Returns the multiplication of two unsigned integers, reverting on
694      * overflow.
695      *
696      * Counterpart to Solidity's `*` operator.
697      *
698      * Requirements:
699      *
700      * - Multiplication cannot overflow.
701      */
702     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
703         return a * b;
704     }
705 
706     /**
707      * @dev Returns the integer division of two unsigned integers, reverting on
708      * division by zero. The result is rounded towards zero.
709      *
710      * Counterpart to Solidity's `/` operator.
711      *
712      * Requirements:
713      *
714      * - The divisor cannot be zero.
715      */
716     function div(uint256 a, uint256 b) internal pure returns (uint256) {
717         return a / b;
718     }
719 
720     /**
721      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
722      * reverting when dividing by zero.
723      *
724      * Counterpart to Solidity's `%` operator. This function uses a `revert`
725      * opcode (which leaves remaining gas untouched) while Solidity uses an
726      * invalid opcode to revert (consuming all remaining gas).
727      *
728      * Requirements:
729      *
730      * - The divisor cannot be zero.
731      */
732     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
733         return a % b;
734     }
735 
736     /**
737      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
738      * overflow (when the result is negative).
739      *
740      * CAUTION: This function is deprecated because it requires allocating memory for the error
741      * message unnecessarily. For custom revert reasons use {trySub}.
742      *
743      * Counterpart to Solidity's `-` operator.
744      *
745      * Requirements:
746      *
747      * - Subtraction cannot overflow.
748      */
749     function sub(
750         uint256 a,
751         uint256 b,
752         string memory errorMessage
753     ) internal pure returns (uint256) {
754         unchecked {
755             require(b <= a, errorMessage);
756             return a - b;
757         }
758     }
759 
760     /**
761      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
762      * division by zero. The result is rounded towards zero.
763      *
764      * Counterpart to Solidity's `/` operator. Note: this function uses a
765      * `revert` opcode (which leaves remaining gas untouched) while Solidity
766      * uses an invalid opcode to revert (consuming all remaining gas).
767      *
768      * Requirements:
769      *
770      * - The divisor cannot be zero.
771      */
772     function div(
773         uint256 a,
774         uint256 b,
775         string memory errorMessage
776     ) internal pure returns (uint256) {
777         unchecked {
778             require(b > 0, errorMessage);
779             return a / b;
780         }
781     }
782 
783     /**
784      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
785      * reverting with custom message when dividing by zero.
786      *
787      * CAUTION: This function is deprecated because it requires allocating memory for the error
788      * message unnecessarily. For custom revert reasons use {tryMod}.
789      *
790      * Counterpart to Solidity's `%` operator. This function uses a `revert`
791      * opcode (which leaves remaining gas untouched) while Solidity uses an
792      * invalid opcode to revert (consuming all remaining gas).
793      *
794      * Requirements:
795      *
796      * - The divisor cannot be zero.
797      */
798     function mod(
799         uint256 a,
800         uint256 b,
801         string memory errorMessage
802     ) internal pure returns (uint256) {
803         unchecked {
804             require(b > 0, errorMessage);
805             return a % b;
806         }
807     }
808 }
809 
810 ////// src/IUniswapV2Factory.sol
811 /* pragma solidity 0.8.10; */
812 /* pragma experimental ABIEncoderV2; */
813 
814 interface IUniswapV2Factory {
815     event PairCreated(
816         address indexed token0,
817         address indexed token1,
818         address pair,
819         uint256
820     );
821 
822     function feeTo() external view returns (address);
823 
824     function feeToSetter() external view returns (address);
825 
826     function getPair(address tokenA, address tokenB)
827         external
828         view
829         returns (address pair);
830 
831     function allPairs(uint256) external view returns (address pair);
832 
833     function allPairsLength() external view returns (uint256);
834 
835     function createPair(address tokenA, address tokenB)
836         external
837         returns (address pair);
838 
839     function setFeeTo(address) external;
840 
841     function setFeeToSetter(address) external;
842 }
843 
844 ////// src/IUniswapV2Pair.sol
845 /* pragma solidity 0.8.10; */
846 /* pragma experimental ABIEncoderV2; */
847 
848 interface IUniswapV2Pair {
849     event Approval(
850         address indexed owner,
851         address indexed spender,
852         uint256 value
853     );
854     event Transfer(address indexed from, address indexed to, uint256 value);
855 
856     function name() external pure returns (string memory);
857 
858     function symbol() external pure returns (string memory);
859 
860     function decimals() external pure returns (uint8);
861 
862     function totalSupply() external view returns (uint256);
863 
864     function balanceOf(address owner) external view returns (uint256);
865 
866     function allowance(address owner, address spender)
867         external
868         view
869         returns (uint256);
870 
871     function approve(address spender, uint256 value) external returns (bool);
872 
873     function transfer(address to, uint256 value) external returns (bool);
874 
875     function transferFrom(
876         address from,
877         address to,
878         uint256 value
879     ) external returns (bool);
880 
881     function DOMAIN_SEPARATOR() external view returns (bytes32);
882 
883     function PERMIT_TYPEHASH() external pure returns (bytes32);
884 
885     function nonces(address owner) external view returns (uint256);
886 
887     function permit(
888         address owner,
889         address spender,
890         uint256 value,
891         uint256 deadline,
892         uint8 v,
893         bytes32 r,
894         bytes32 s
895     ) external;
896 
897     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
898     event Burn(
899         address indexed sender,
900         uint256 amount0,
901         uint256 amount1,
902         address indexed to
903     );
904     event Swap(
905         address indexed sender,
906         uint256 amount0In,
907         uint256 amount1In,
908         uint256 amount0Out,
909         uint256 amount1Out,
910         address indexed to
911     );
912     event Sync(uint112 reserve0, uint112 reserve1);
913 
914     function MINIMUM_LIQUIDITY() external pure returns (uint256);
915 
916     function factory() external view returns (address);
917 
918     function token0() external view returns (address);
919 
920     function token1() external view returns (address);
921 
922     function getReserves()
923         external
924         view
925         returns (
926             uint112 reserve0,
927             uint112 reserve1,
928             uint32 blockTimestampLast
929         );
930 
931     function price0CumulativeLast() external view returns (uint256);
932 
933     function price1CumulativeLast() external view returns (uint256);
934 
935     function kLast() external view returns (uint256);
936 
937     function mint(address to) external returns (uint256 liquidity);
938 
939     function burn(address to)
940         external
941         returns (uint256 amount0, uint256 amount1);
942 
943     function swap(
944         uint256 amount0Out,
945         uint256 amount1Out,
946         address to,
947         bytes calldata data
948     ) external;
949 
950     function skim(address to) external;
951 
952     function sync() external;
953 
954     function initialize(address, address) external;
955 }
956 
957 ////// src/IUniswapV2Router02.sol
958 /* pragma solidity 0.8.10; */
959 /* pragma experimental ABIEncoderV2; */
960 
961 interface IUniswapV2Router02 {
962     function factory() external pure returns (address);
963 
964     function WETH() external pure returns (address);
965 
966     function addLiquidity(
967         address tokenA,
968         address tokenB,
969         uint256 amountADesired,
970         uint256 amountBDesired,
971         uint256 amountAMin,
972         uint256 amountBMin,
973         address to,
974         uint256 deadline
975     )
976         external
977         returns (
978             uint256 amountA,
979             uint256 amountB,
980             uint256 liquidity
981         );
982 
983     function addLiquidityETH(
984         address token,
985         uint256 amountTokenDesired,
986         uint256 amountTokenMin,
987         uint256 amountETHMin,
988         address to,
989         uint256 deadline
990     )
991         external
992         payable
993         returns (
994             uint256 amountToken,
995             uint256 amountETH,
996             uint256 liquidity
997         );
998 
999     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1000         uint256 amountIn,
1001         uint256 amountOutMin,
1002         address[] calldata path,
1003         address to,
1004         uint256 deadline
1005     ) external;
1006 
1007     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1008         uint256 amountOutMin,
1009         address[] calldata path,
1010         address to,
1011         uint256 deadline
1012     ) external payable;
1013 
1014     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1015         uint256 amountIn,
1016         uint256 amountOutMin,
1017         address[] calldata path,
1018         address to,
1019         uint256 deadline
1020     ) external;
1021 }
1022 
1023 /* pragma solidity >=0.8.10; */
1024 
1025 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1026 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1027 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1028 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1029 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1030 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1031 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1032 
1033 contract BOUNTY is ERC20, Ownable {
1034     using SafeMath for uint256;
1035 
1036     IUniswapV2Router02 public immutable uniswapV2Router;
1037     address public immutable uniswapV2Pair;
1038     address public constant deadAddress = address(0xdead);
1039 
1040     bool private swapping;
1041 
1042     address public marketingWallet;
1043     address public devWallet;
1044 
1045     uint256 public maxTransactionAmount;
1046     uint256 public swapTokensAtAmount;
1047     uint256 public maxWallet;
1048 
1049     uint256 public percentForLPBurn = 5; // 5 = .05%
1050     bool public lpBurnEnabled = true;
1051     uint256 public lpBurnFrequency = 3600 seconds;
1052     uint256 public lastLpBurnTime;
1053 
1054     uint256 public manualBurnFrequency = 30 minutes;
1055     uint256 public lastManualLpBurnTime;
1056 
1057     bool public limitsInEffect = true;
1058     bool public tradingActive = false;
1059     bool public swapEnabled = false;
1060 
1061     // Anti-bot and anti-whale mappings and variables
1062     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1063     bool public transferDelayEnabled = true;
1064 
1065     uint256 public buyTotalFees;
1066     uint256 public buyMarketingFee;
1067     uint256 public buyLiquidityFee;
1068     uint256 public buyDevFee;
1069 
1070     uint256 public sellTotalFees;
1071     uint256 public sellMarketingFee;
1072     uint256 public sellLiquidityFee;
1073     uint256 public sellDevFee;
1074 
1075     uint256 public tokensForMarketing;
1076     uint256 public tokensForLiquidity;
1077     uint256 public tokensForDev;
1078 
1079     /******************/
1080 
1081     // exlcude from fees and max transaction amount
1082     mapping(address => bool) private _isExcludedFromFees;
1083     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1084 
1085     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1086     // could be subject to a maximum transfer amount
1087     mapping(address => bool) public automatedMarketMakerPairs;
1088 
1089     event UpdateUniswapV2Router(
1090         address indexed newAddress,
1091         address indexed oldAddress
1092     );
1093 
1094     event ExcludeFromFees(address indexed account, bool isExcluded);
1095 
1096     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1097 
1098     event marketingWalletUpdated(
1099         address indexed newWallet,
1100         address indexed oldWallet
1101     );
1102 
1103     event devWalletUpdated(
1104         address indexed newWallet,
1105         address indexed oldWallet
1106     );
1107 
1108     event SwapAndLiquify(
1109         uint256 tokensSwapped,
1110         uint256 ethReceived,
1111         uint256 tokensIntoLiquidity
1112     );
1113 
1114     event AutoNukeLP();
1115 
1116     event ManualNukeLP();
1117 
1118     constructor() ERC20("bounty.tech", "BOUNTY") {
1119         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1120             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1121         );
1122 
1123         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1124         uniswapV2Router = _uniswapV2Router;
1125 
1126         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1127             .createPair(address(this), _uniswapV2Router.WETH());
1128         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1129         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1130 
1131         uint256 _buyMarketingFee = 10;
1132         uint256 _buyLiquidityFee = 0;
1133         uint256 _buyDevFee = 0;
1134 
1135         uint256 _sellMarketingFee = 39;
1136         uint256 _sellLiquidityFee = 0;
1137         uint256 _sellDevFee = 0;
1138 
1139         uint256 totalSupply = 10_000_000_000 * 1e18;
1140 
1141         maxTransactionAmount = 200_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1142         maxWallet = 200_000_000 * 1e18; // 2% from total supply maxWallet
1143         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1144 
1145         buyMarketingFee = _buyMarketingFee;
1146         buyLiquidityFee = _buyLiquidityFee;
1147         buyDevFee = _buyDevFee;
1148         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1149 
1150         sellMarketingFee = _sellMarketingFee;
1151         sellLiquidityFee = _sellLiquidityFee;
1152         sellDevFee = _sellDevFee;
1153         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1154 
1155         marketingWallet = address(0xb37fb7353354b27C70C2dAD04324C1DE4B81367D); // set as marketing wallet
1156         devWallet = address(0xFEe01Dd60F80f67B31A9199F68D25721B47f9607); // set as dev wallet
1157 
1158         // exclude from paying fees or having max transaction amount
1159         excludeFromFees(owner(), true);
1160         excludeFromFees(address(this), true);
1161         excludeFromFees(address(0xdead), true);
1162 
1163         excludeFromMaxTransaction(owner(), true);
1164         excludeFromMaxTransaction(address(this), true);
1165         excludeFromMaxTransaction(address(0xdead), true);
1166 
1167         /*
1168             _mint is an internal function in ERC20.sol that is only called here,
1169             and CANNOT be called ever again
1170         */
1171         _mint(msg.sender, totalSupply);
1172     }
1173 
1174     receive() external payable {}
1175 
1176     // once enabled, can never be turned off
1177     function enableTrading() external onlyOwner {
1178         tradingActive = true;
1179         swapEnabled = true;
1180         lastLpBurnTime = block.timestamp;
1181     }
1182 
1183     // remove limits after token is stable
1184     function removeLimits() external onlyOwner returns (bool) {
1185         limitsInEffect = false;
1186         return true;
1187     }
1188 
1189     // disable Transfer delay - cannot be reenabled
1190     function disableTransferDelay() external onlyOwner returns (bool) {
1191         transferDelayEnabled = false;
1192         return true;
1193     }
1194 
1195     // change the minimum amount of tokens to sell from fees
1196     function updateSwapTokensAtAmount(uint256 newAmount)
1197         external
1198         onlyOwner
1199         returns (bool)
1200     {
1201         require(
1202             newAmount >= (totalSupply() * 1) / 100000,
1203             "Swap amount cannot be lower than 0.001% total supply."
1204         );
1205         require(
1206             newAmount <= (totalSupply() * 5) / 1000,
1207             "Swap amount cannot be higher than 0.5% total supply."
1208         );
1209         swapTokensAtAmount = newAmount;
1210         return true;
1211     }
1212 
1213     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1214         require(
1215             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1216             "Cannot set maxTransactionAmount lower than 0.1%"
1217         );
1218         maxTransactionAmount = newNum * (10**18);
1219     }
1220 
1221     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1222         require(
1223             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1224             "Cannot set maxWallet lower than 0.5%"
1225         );
1226         maxWallet = newNum * (10**18);
1227     }
1228 
1229     function excludeFromMaxTransaction(address updAds, bool isEx)
1230         public
1231         onlyOwner
1232     {
1233         _isExcludedMaxTransactionAmount[updAds] = isEx;
1234     }
1235 
1236     // only use to disable contract sales if absolutely necessary (emergency use only)
1237     function updateSwapEnabled(bool enabled) external onlyOwner {
1238         swapEnabled = enabled;
1239     }
1240 
1241     function updateBuyFees(
1242         uint256 _marketingFee,
1243         uint256 _liquidityFee,
1244         uint256 _devFee
1245     ) external onlyOwner {
1246         buyMarketingFee = _marketingFee;
1247         buyLiquidityFee = _liquidityFee;
1248         buyDevFee = _devFee;
1249         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1250         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
1251     }
1252 
1253     function updateSellFees(
1254         uint256 _marketingFee,
1255         uint256 _liquidityFee,
1256         uint256 _devFee
1257     ) external onlyOwner {
1258         sellMarketingFee = _marketingFee;
1259         sellLiquidityFee = _liquidityFee;
1260         sellDevFee = _devFee;
1261         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1262         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
1263     }
1264 
1265     function excludeFromFees(address account, bool excluded) public onlyOwner {
1266         _isExcludedFromFees[account] = excluded;
1267         emit ExcludeFromFees(account, excluded);
1268     }
1269 
1270     function setAutomatedMarketMakerPair(address pair, bool value)
1271         public
1272         onlyOwner
1273     {
1274         require(
1275             pair != uniswapV2Pair,
1276             "The pair cannot be removed from automatedMarketMakerPairs"
1277         );
1278 
1279         _setAutomatedMarketMakerPair(pair, value);
1280     }
1281 
1282     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1283         automatedMarketMakerPairs[pair] = value;
1284 
1285         emit SetAutomatedMarketMakerPair(pair, value);
1286     }
1287 
1288     function updateMarketingWallet(address newMarketingWallet)
1289         external
1290         onlyOwner
1291     {
1292         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1293         marketingWallet = newMarketingWallet;
1294     }
1295 
1296     function updateDevWallet(address newWallet) external onlyOwner {
1297         emit devWalletUpdated(newWallet, devWallet);
1298         devWallet = newWallet;
1299     }
1300 
1301     function isExcludedFromFees(address account) public view returns (bool) {
1302         return _isExcludedFromFees[account];
1303     }
1304 
1305     event BoughtEarly(address indexed sniper);
1306 
1307     function _transfer(
1308         address from,
1309         address to,
1310         uint256 amount
1311     ) internal override {
1312         require(from != address(0), "ERC20: transfer from the zero address");
1313         require(to != address(0), "ERC20: transfer to the zero address");
1314 
1315         if (amount == 0) {
1316             super._transfer(from, to, 0);
1317             return;
1318         }
1319 
1320         if (limitsInEffect) {
1321             if (
1322                 from != owner() &&
1323                 to != owner() &&
1324                 to != address(0) &&
1325                 to != address(0xdead) &&
1326                 !swapping
1327             ) {
1328                 if (!tradingActive) {
1329                     require(
1330                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1331                         "Trading is not active."
1332                     );
1333                 }
1334 
1335                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1336                 if (transferDelayEnabled) {
1337                     if (
1338                         to != owner() &&
1339                         to != address(uniswapV2Router) &&
1340                         to != address(uniswapV2Pair)
1341                     ) {
1342                         require(
1343                             _holderLastTransferTimestamp[tx.origin] <
1344                                 block.number,
1345                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1346                         );
1347                         _holderLastTransferTimestamp[tx.origin] = block.number;
1348                     }
1349                 }
1350 
1351                 //when buy
1352                 if (
1353                     automatedMarketMakerPairs[from] &&
1354                     !_isExcludedMaxTransactionAmount[to]
1355                 ) {
1356                     require(
1357                         amount <= maxTransactionAmount,
1358                         "Buy transfer amount exceeds the maxTransactionAmount."
1359                     );
1360                     require(
1361                         amount + balanceOf(to) <= maxWallet,
1362                         "Max wallet exceeded"
1363                     );
1364                 }
1365                 //when sell
1366                 else if (
1367                     automatedMarketMakerPairs[to] &&
1368                     !_isExcludedMaxTransactionAmount[from]
1369                 ) {
1370                     require(
1371                         amount <= maxTransactionAmount,
1372                         "Sell transfer amount exceeds the maxTransactionAmount."
1373                     );
1374                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1375                     require(
1376                         amount + balanceOf(to) <= maxWallet,
1377                         "Max wallet exceeded"
1378                     );
1379                 }
1380             }
1381         }
1382 
1383         uint256 contractTokenBalance = balanceOf(address(this));
1384 
1385         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1386 
1387         if (
1388             canSwap &&
1389             swapEnabled &&
1390             !swapping &&
1391             !automatedMarketMakerPairs[from] &&
1392             !_isExcludedFromFees[from] &&
1393             !_isExcludedFromFees[to]
1394         ) {
1395             swapping = true;
1396 
1397             swapBack();
1398 
1399             swapping = false;
1400         }
1401 
1402         if (
1403             !swapping &&
1404             automatedMarketMakerPairs[to] &&
1405             lpBurnEnabled &&
1406             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1407             !_isExcludedFromFees[from]
1408         ) {
1409             autoBurnLiquidityPairTokens();
1410         }
1411 
1412         bool takeFee = !swapping;
1413 
1414         // if any account belongs to _isExcludedFromFee account then remove the fee
1415         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1416             takeFee = false;
1417         }
1418 
1419         uint256 fees = 0;
1420         // only take fees on buys/sells, do not take on wallet transfers
1421         if (takeFee) {
1422             // on sell
1423             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1424                 fees = amount.mul(sellTotalFees).div(100);
1425                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1426                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1427                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1428             }
1429             // on buy
1430             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1431                 fees = amount.mul(buyTotalFees).div(100);
1432                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1433                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1434                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1435             }
1436 
1437             if (fees > 0) {
1438                 super._transfer(from, address(this), fees);
1439             }
1440 
1441             amount -= fees;
1442         }
1443 
1444         super._transfer(from, to, amount);
1445     }
1446 
1447     function swapTokensForEth(uint256 tokenAmount) private {
1448         // generate the uniswap pair path of token -> weth
1449         address[] memory path = new address[](2);
1450         path[0] = address(this);
1451         path[1] = uniswapV2Router.WETH();
1452 
1453         _approve(address(this), address(uniswapV2Router), tokenAmount);
1454 
1455         // make the swap
1456         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1457             tokenAmount,
1458             0, // accept any amount of ETH
1459             path,
1460             address(this),
1461             block.timestamp
1462         );
1463     }
1464 
1465     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1466         // approve token transfer to cover all possible scenarios
1467         _approve(address(this), address(uniswapV2Router), tokenAmount);
1468 
1469         // add the liquidity
1470         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1471             address(this),
1472             tokenAmount,
1473             0, // slippage is unavoidable
1474             0, // slippage is unavoidable
1475             deadAddress,
1476             block.timestamp
1477         );
1478     }
1479 
1480     function swapBack() private {
1481         uint256 contractBalance = balanceOf(address(this));
1482         uint256 totalTokensToSwap = tokensForLiquidity +
1483             tokensForMarketing +
1484             tokensForDev;
1485         bool success;
1486 
1487         if (contractBalance == 0 || totalTokensToSwap == 0) {
1488             return;
1489         }
1490 
1491         if (contractBalance > swapTokensAtAmount * 20) {
1492             contractBalance = swapTokensAtAmount * 20;
1493         }
1494 
1495         // Halve the amount of liquidity tokens
1496         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1497             totalTokensToSwap /
1498             2;
1499         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1500 
1501         uint256 initialETHBalance = address(this).balance;
1502 
1503         swapTokensForEth(amountToSwapForETH);
1504 
1505         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1506 
1507         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1508             totalTokensToSwap
1509         );
1510         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1511 
1512         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1513 
1514         tokensForLiquidity = 0;
1515         tokensForMarketing = 0;
1516         tokensForDev = 0;
1517 
1518         (success, ) = address(devWallet).call{value: ethForDev}("");
1519 
1520         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1521             addLiquidity(liquidityTokens, ethForLiquidity);
1522             emit SwapAndLiquify(
1523                 amountToSwapForETH,
1524                 ethForLiquidity,
1525                 tokensForLiquidity
1526             );
1527         }
1528 
1529         (success, ) = address(marketingWallet).call{
1530             value: address(this).balance
1531         }("");
1532     }
1533 
1534     function setAutoLPBurnSettings(
1535         uint256 _frequencyInSeconds,
1536         uint256 _percent,
1537         bool _Enabled
1538     ) external onlyOwner {
1539         require(
1540             _frequencyInSeconds >= 600,
1541             "cannot set buyback more often than every 10 minutes"
1542         );
1543         require(
1544             _percent <= 1000 && _percent >= 0,
1545             "Must set auto LP burn percent between 0% and 10%"
1546         );
1547         lpBurnFrequency = _frequencyInSeconds;
1548         percentForLPBurn = _percent;
1549         lpBurnEnabled = _Enabled;
1550     }
1551 
1552     function autoBurnLiquidityPairTokens() internal returns (bool) {
1553         lastLpBurnTime = block.timestamp;
1554 
1555         // get balance of liquidity pair
1556         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1557 
1558         // calculate amount to burn
1559         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1560             10000
1561         );
1562 
1563         // pull tokens from pancakePair liquidity and move to dead address permanently
1564         if (amountToBurn > 0) {
1565             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1566         }
1567 
1568         //sync price since this is not in a swap transaction!
1569         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1570         pair.sync();
1571         emit AutoNukeLP();
1572         return true;
1573     }
1574 
1575     function manualBurnLiquidityPairTokens(uint256 percent)
1576         external
1577         onlyOwner
1578         returns (bool)
1579     {
1580         require(
1581             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1582             "Must wait for cooldown to finish"
1583         );
1584         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1585         lastManualLpBurnTime = block.timestamp;
1586 
1587         // get balance of liquidity pair
1588         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1589 
1590         // calculate amount to burn
1591         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1592 
1593         // pull tokens from pancakePair liquidity and move to dead address permanently
1594         if (amountToBurn > 0) {
1595             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1596         }
1597 
1598         //sync price since this is not in a swap transaction!
1599         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1600         pair.sync();
1601         emit ManualNukeLP();
1602         return true;
1603     }
1604 }