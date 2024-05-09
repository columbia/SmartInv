1 /*
2  
3     https://t.me/ReliefInu
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
843 /* pragma solidity 0.8.10; */
844 /* pragma experimental ABIEncoderV2; */
845 
846 interface IUniswapV2Pair {
847     event Approval(
848         address indexed owner,
849         address indexed spender,
850         uint256 value
851     );
852     event Transfer(address indexed from, address indexed to, uint256 value);
853 
854     function name() external pure returns (string memory);
855 
856     function symbol() external pure returns (string memory);
857 
858     function decimals() external pure returns (uint8);
859 
860     function totalSupply() external view returns (uint256);
861 
862     function balanceOf(address owner) external view returns (uint256);
863 
864     function allowance(address owner, address spender)
865         external
866         view
867         returns (uint256);
868 
869     function approve(address spender, uint256 value) external returns (bool);
870 
871     function transfer(address to, uint256 value) external returns (bool);
872 
873     function transferFrom(
874         address from,
875         address to,
876         uint256 value
877     ) external returns (bool);
878 
879     function DOMAIN_SEPARATOR() external view returns (bytes32);
880 
881     function PERMIT_TYPEHASH() external pure returns (bytes32);
882 
883     function nonces(address owner) external view returns (uint256);
884 
885     function permit(
886         address owner,
887         address spender,
888         uint256 value,
889         uint256 deadline,
890         uint8 v,
891         bytes32 r,
892         bytes32 s
893     ) external;
894 
895     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
896     event Burn(
897         address indexed sender,
898         uint256 amount0,
899         uint256 amount1,
900         address indexed to
901     );
902     event Swap(
903         address indexed sender,
904         uint256 amount0In,
905         uint256 amount1In,
906         uint256 amount0Out,
907         uint256 amount1Out,
908         address indexed to
909     );
910     event Sync(uint112 reserve0, uint112 reserve1);
911 
912     function MINIMUM_LIQUIDITY() external pure returns (uint256);
913 
914     function factory() external view returns (address);
915 
916     function token0() external view returns (address);
917 
918     function token1() external view returns (address);
919 
920     function getReserves()
921         external
922         view
923         returns (
924             uint112 reserve0,
925             uint112 reserve1,
926             uint32 blockTimestampLast
927         );
928 
929     function price0CumulativeLast() external view returns (uint256);
930 
931     function price1CumulativeLast() external view returns (uint256);
932 
933     function kLast() external view returns (uint256);
934 
935     function mint(address to) external returns (uint256 liquidity);
936 
937     function burn(address to)
938         external
939         returns (uint256 amount0, uint256 amount1);
940 
941     function swap(
942         uint256 amount0Out,
943         uint256 amount1Out,
944         address to,
945         bytes calldata data
946     ) external;
947 
948     function skim(address to) external;
949 
950     function sync() external;
951 
952     function initialize(address, address) external;
953 }
954 
955 /* pragma solidity 0.8.10; */
956 /* pragma experimental ABIEncoderV2; */
957 
958 interface IUniswapV2Router02 {
959     function factory() external pure returns (address);
960 
961     function WETH() external pure returns (address);
962 
963     function addLiquidity(
964         address tokenA,
965         address tokenB,
966         uint256 amountADesired,
967         uint256 amountBDesired,
968         uint256 amountAMin,
969         uint256 amountBMin,
970         address to,
971         uint256 deadline
972     )
973         external
974         returns (
975             uint256 amountA,
976             uint256 amountB,
977             uint256 liquidity
978         );
979 
980     function addLiquidityETH(
981         address token,
982         uint256 amountTokenDesired,
983         uint256 amountTokenMin,
984         uint256 amountETHMin,
985         address to,
986         uint256 deadline
987     )
988         external
989         payable
990         returns (
991             uint256 amountToken,
992             uint256 amountETH,
993             uint256 liquidity
994         );
995 
996     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
997         uint256 amountIn,
998         uint256 amountOutMin,
999         address[] calldata path,
1000         address to,
1001         uint256 deadline
1002     ) external;
1003 
1004     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1005         uint256 amountOutMin,
1006         address[] calldata path,
1007         address to,
1008         uint256 deadline
1009     ) external payable;
1010 
1011     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1012         uint256 amountIn,
1013         uint256 amountOutMin,
1014         address[] calldata path,
1015         address to,
1016         uint256 deadline
1017     ) external;
1018 }
1019 
1020 /* pragma solidity >=0.8.10; */
1021 
1022 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1023 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1024 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1025 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1026 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1027 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1028 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1029 
1030 contract RINU is ERC20, Ownable {
1031     using SafeMath for uint256;
1032 
1033     IUniswapV2Router02 public immutable uniswapV2Router;
1034     address public immutable uniswapV2Pair;
1035     address public constant deadAddress = address(0xdead);
1036 
1037     bool private swapping;
1038 
1039 	address public charityWallet;
1040     address public marketingWallet;
1041     address public devWallet;
1042 
1043     uint256 public maxTransactionAmount;
1044     uint256 public swapTokensAtAmount;
1045     uint256 public maxWallet;
1046 
1047     bool public limitsInEffect = true;
1048     bool public tradingActive = false;
1049     bool public swapEnabled = false;
1050 
1051     // Anti-bot and anti-whale mappings and variables
1052     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1053     bool public transferDelayEnabled = true;
1054 
1055     uint256 public buyTotalFees;
1056 	uint256 public buyCharityFee;
1057     uint256 public buyMarketingFee;
1058     uint256 public buyLiquidityFee;
1059     uint256 public buyDevFee;
1060 
1061     uint256 public sellTotalFees;
1062 	uint256 public sellCharityFee;
1063     uint256 public sellMarketingFee;
1064     uint256 public sellLiquidityFee;
1065     uint256 public sellDevFee;
1066 
1067 	uint256 public tokensForCharity;
1068     uint256 public tokensForMarketing;
1069     uint256 public tokensForLiquidity;
1070     uint256 public tokensForDev;
1071 
1072     /******************/
1073 
1074     // exlcude from fees and max transaction amount
1075     mapping(address => bool) private _isExcludedFromFees;
1076     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1077 
1078     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1079     // could be subject to a maximum transfer amount
1080     mapping(address => bool) public automatedMarketMakerPairs;
1081 
1082     event UpdateUniswapV2Router(
1083         address indexed newAddress,
1084         address indexed oldAddress
1085     );
1086 
1087     event ExcludeFromFees(address indexed account, bool isExcluded);
1088 
1089     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1090 
1091     event SwapAndLiquify(
1092         uint256 tokensSwapped,
1093         uint256 ethReceived,
1094         uint256 tokensIntoLiquidity
1095     );
1096 
1097     constructor() ERC20("Relief Inu", "RINU") {
1098         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1099             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1100         );
1101 
1102         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1103         uniswapV2Router = _uniswapV2Router;
1104 
1105         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1106             .createPair(address(this), _uniswapV2Router.WETH());
1107         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1108         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1109 
1110 		uint256 _buyCharityFee = 0;
1111         uint256 _buyMarketingFee = 15;
1112         uint256 _buyLiquidityFee = 0;
1113         uint256 _buyDevFee = 0;
1114 
1115 		uint256 _sellCharityFee = 0;
1116         uint256 _sellMarketingFee = 15;
1117         uint256 _sellLiquidityFee = 0;
1118         uint256 _sellDevFee = 0;
1119 
1120         uint256 totalSupply = 1920000000 * 1e18;
1121 
1122         maxTransactionAmount = 19200000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1123         maxWallet = 19200000 * 1e18; // 1% from total supply maxWallet
1124         swapTokensAtAmount = (totalSupply * 40) / 10000; // 0.4% swap wallet
1125 
1126 		buyCharityFee = _buyCharityFee;
1127         buyMarketingFee = _buyMarketingFee;
1128         buyLiquidityFee = _buyLiquidityFee;
1129         buyDevFee = _buyDevFee;
1130         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1131 
1132 		sellCharityFee = _sellCharityFee;
1133         sellMarketingFee = _sellMarketingFee;
1134         sellLiquidityFee = _sellLiquidityFee;
1135         sellDevFee = _sellDevFee;
1136         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1137 
1138 		charityWallet = address(0x68A99f89E475a078645f4BAC491360aFe255Dff1); // set as charity wallet
1139         marketingWallet = address(0xaca27C6c24Ee88f1d9666A8D759D708B48f210A8); // set as marketing wallet
1140         devWallet = address(0xaca27C6c24Ee88f1d9666A8D759D708B48f210A8); // set as dev wallet
1141 
1142         // exclude from paying fees or having max transaction amount
1143         excludeFromFees(owner(), true);
1144         excludeFromFees(address(this), true);
1145         excludeFromFees(address(0xdead), true);
1146 
1147         excludeFromMaxTransaction(owner(), true);
1148         excludeFromMaxTransaction(address(this), true);
1149         excludeFromMaxTransaction(address(0xdead), true);
1150 
1151         /*
1152             _mint is an internal function in ERC20.sol that is only called here,
1153             and CANNOT be called ever again
1154         */
1155         _mint(msg.sender, totalSupply);
1156     }
1157 
1158     receive() external payable {}
1159 
1160     // once enabled, can never be turned off
1161     function enableTrading() external onlyOwner {
1162         tradingActive = true;
1163         swapEnabled = true;
1164     }
1165 
1166     // remove limits after token is stable
1167     function removeLimits() external onlyOwner returns (bool) {
1168         limitsInEffect = false;
1169         return true;
1170     }
1171 
1172     // disable Transfer delay - cannot be reenabled
1173     function disableTransferDelay() external onlyOwner returns (bool) {
1174         transferDelayEnabled = false;
1175         return true;
1176     }
1177 
1178     // change the minimum amount of tokens to sell from fees
1179     function updateSwapTokensAtAmount(uint256 newAmount)
1180         external
1181         onlyOwner
1182         returns (bool)
1183     {
1184         require(
1185             newAmount >= (totalSupply() * 1) / 100000,
1186             "Swap amount cannot be lower than 0.001% total supply."
1187         );
1188         require(
1189             newAmount <= (totalSupply() * 5) / 1000,
1190             "Swap amount cannot be higher than 0.5% total supply."
1191         );
1192         swapTokensAtAmount = newAmount;
1193         return true;
1194     }
1195 
1196     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1197         require(
1198             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1199             "Cannot set maxTransactionAmount lower than 0.1%"
1200         );
1201         maxTransactionAmount = newNum * (10**18);
1202     }
1203 
1204     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1205         require(
1206             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1207             "Cannot set maxWallet lower than 0.5%"
1208         );
1209         maxWallet = newNum * (10**18);
1210     }
1211 	
1212     function excludeFromMaxTransaction(address updAds, bool isEx)
1213         public
1214         onlyOwner
1215     {
1216         _isExcludedMaxTransactionAmount[updAds] = isEx;
1217     }
1218 
1219     // only use to disable contract sales if absolutely necessary (emergency use only)
1220     function updateSwapEnabled(bool enabled) external onlyOwner {
1221         swapEnabled = enabled;
1222     }
1223 
1224     function updateBuyFees(
1225 		uint256 _charityFee,
1226         uint256 _marketingFee,
1227         uint256 _liquidityFee,
1228         uint256 _devFee
1229     ) external onlyOwner {
1230 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 8, "Max BuyFee 8%");
1231 		buyCharityFee = _charityFee;
1232         buyMarketingFee = _marketingFee;
1233         buyLiquidityFee = _liquidityFee;
1234         buyDevFee = _devFee;
1235         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1236      }
1237 
1238     function updateSellFees(
1239 		uint256 _charityFee,
1240         uint256 _marketingFee,
1241         uint256 _liquidityFee,
1242         uint256 _devFee
1243     ) external onlyOwner {
1244 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1245 		sellCharityFee = _charityFee;
1246         sellMarketingFee = _marketingFee;
1247         sellLiquidityFee = _liquidityFee;
1248         sellDevFee = _devFee;
1249         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1250     }
1251 
1252     function excludeFromFees(address account, bool excluded) public onlyOwner {
1253         _isExcludedFromFees[account] = excluded;
1254         emit ExcludeFromFees(account, excluded);
1255     }
1256 
1257     function setAutomatedMarketMakerPair(address pair, bool value)
1258         public
1259         onlyOwner
1260     {
1261         require(
1262             pair != uniswapV2Pair,
1263             "The pair cannot be removed from automatedMarketMakerPairs"
1264         );
1265 
1266         _setAutomatedMarketMakerPair(pair, value);
1267     }
1268 
1269     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1270         automatedMarketMakerPairs[pair] = value;
1271 
1272         emit SetAutomatedMarketMakerPair(pair, value);
1273     }
1274 
1275     function isExcludedFromFees(address account) public view returns (bool) {
1276         return _isExcludedFromFees[account];
1277     }
1278 
1279     function _transfer(
1280         address from,
1281         address to,
1282         uint256 amount
1283     ) internal override {
1284         require(from != address(0), "ERC20: transfer from the zero address");
1285         require(to != address(0), "ERC20: transfer to the zero address");
1286 
1287         if (amount == 0) {
1288             super._transfer(from, to, 0);
1289             return;
1290         }
1291 
1292         if (limitsInEffect) {
1293             if (
1294                 from != owner() &&
1295                 to != owner() &&
1296                 to != address(0) &&
1297                 to != address(0xdead) &&
1298                 !swapping
1299             ) {
1300                 if (!tradingActive) {
1301                     require(
1302                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1303                         "Trading is not active."
1304                     );
1305                 }
1306 
1307                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1308                 if (transferDelayEnabled) {
1309                     if (
1310                         to != owner() &&
1311                         to != address(uniswapV2Router) &&
1312                         to != address(uniswapV2Pair)
1313                     ) {
1314                         require(
1315                             _holderLastTransferTimestamp[tx.origin] <
1316                                 block.number,
1317                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1318                         );
1319                         _holderLastTransferTimestamp[tx.origin] = block.number;
1320                     }
1321                 }
1322 
1323                 //when buy
1324                 if (
1325                     automatedMarketMakerPairs[from] &&
1326                     !_isExcludedMaxTransactionAmount[to]
1327                 ) {
1328                     require(
1329                         amount <= maxTransactionAmount,
1330                         "Buy transfer amount exceeds the maxTransactionAmount."
1331                     );
1332                     require(
1333                         amount + balanceOf(to) <= maxWallet,
1334                         "Max wallet exceeded"
1335                     );
1336                 }
1337                 //when sell
1338                 else if (
1339                     automatedMarketMakerPairs[to] &&
1340                     !_isExcludedMaxTransactionAmount[from]
1341                 ) {
1342                     require(
1343                         amount <= maxTransactionAmount,
1344                         "Sell transfer amount exceeds the maxTransactionAmount."
1345                     );
1346                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1347                     require(
1348                         amount + balanceOf(to) <= maxWallet,
1349                         "Max wallet exceeded"
1350                     );
1351                 }
1352             }
1353         }
1354 
1355         uint256 contractTokenBalance = balanceOf(address(this));
1356 
1357         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1358 
1359         if (
1360             canSwap &&
1361             swapEnabled &&
1362             !swapping &&
1363             !automatedMarketMakerPairs[from] &&
1364             !_isExcludedFromFees[from] &&
1365             !_isExcludedFromFees[to]
1366         ) {
1367             swapping = true;
1368 
1369             swapBack();
1370 
1371             swapping = false;
1372         }
1373 
1374         bool takeFee = !swapping;
1375 
1376         // if any account belongs to _isExcludedFromFee account then remove the fee
1377         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1378             takeFee = false;
1379         }
1380 
1381         uint256 fees = 0;
1382         // only take fees on buys/sells, do not take on wallet transfers
1383         if (takeFee) {
1384             // on sell
1385             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1386                 fees = amount.mul(sellTotalFees).div(100);
1387 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1388                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1389                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1390                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1391             }
1392             // on buy
1393             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1394                 fees = amount.mul(buyTotalFees).div(100);
1395 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1396                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1397                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1398                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1399             }
1400 
1401             if (fees > 0) {
1402                 super._transfer(from, address(this), fees);
1403             }
1404 
1405             amount -= fees;
1406         }
1407 
1408         super._transfer(from, to, amount);
1409     }
1410 
1411     function swapTokensForEth(uint256 tokenAmount) private {
1412         // generate the uniswap pair path of token -> weth
1413         address[] memory path = new address[](2);
1414         path[0] = address(this);
1415         path[1] = uniswapV2Router.WETH();
1416 
1417         _approve(address(this), address(uniswapV2Router), tokenAmount);
1418 
1419         // make the swap
1420         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1421             tokenAmount,
1422             0, // accept any amount of ETH
1423             path,
1424             address(this),
1425             block.timestamp
1426         );
1427     }
1428 
1429     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1430         // approve token transfer to cover all possible scenarios
1431         _approve(address(this), address(uniswapV2Router), tokenAmount);
1432 
1433         // add the liquidity
1434         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1435             address(this),
1436             tokenAmount,
1437             0, // slippage is unavoidable
1438             0, // slippage is unavoidable
1439             devWallet,
1440             block.timestamp
1441         );
1442     }
1443 
1444     function swapBack() private {
1445         uint256 contractBalance = balanceOf(address(this));
1446         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1447         bool success;
1448 
1449         if (contractBalance == 0 || totalTokensToSwap == 0) {
1450             return;
1451         }
1452 
1453         if (contractBalance > swapTokensAtAmount * 20) {
1454             contractBalance = swapTokensAtAmount * 20;
1455         }
1456 
1457         // Halve the amount of liquidity tokens
1458         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1459         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1460 
1461         uint256 initialETHBalance = address(this).balance;
1462 
1463         swapTokensForEth(amountToSwapForETH);
1464 
1465         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1466 
1467 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1468         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1469         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1470 
1471         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1472 
1473         tokensForLiquidity = 0;
1474 		tokensForCharity = 0;
1475         tokensForMarketing = 0;
1476         tokensForDev = 0;
1477 
1478         (success, ) = address(devWallet).call{value: ethForDev}("");
1479         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1480 
1481 
1482         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1483             addLiquidity(liquidityTokens, ethForLiquidity);
1484             emit SwapAndLiquify(
1485                 amountToSwapForETH,
1486                 ethForLiquidity,
1487                 tokensForLiquidity
1488             );
1489         }
1490 
1491         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1492     }
1493 
1494 }