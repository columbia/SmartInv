1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 // Shadow Paw is the First ZK Private node and validator protocol for Shibarium. The first and untraceable protocol for Shibarium.
6 //Twitter: https://twitter.com/shadowpawECO
7 //Website:https://shadowpaw.co/
8 //Tg: https://t.me/shadowpawerc
9 //Litepaper: https://shadow-paw-manual.gitbook.io/shadowpaw/
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
1023 contract ShadowPaw is ERC20, Ownable {
1024     using SafeMath for uint256;
1025 
1026     IUniswapV2Router02 public immutable uniswapV2Router;
1027     address public immutable uniswapV2Pair;
1028     address public constant deadAddress = address(0xdead);
1029 
1030     bool private swapping;
1031 
1032     address public marketingWallet;
1033     address public devWallet;
1034 
1035     uint256 public maxTransactionAmount;
1036     uint256 public swapTokensAtAmount;
1037     uint256 public maxWallet;
1038 
1039     uint256 public percentForLPBurn = 25; // 25 = .25%
1040     bool public lpBurnEnabled = true;
1041     uint256 public lpBurnFrequency = 3600 seconds;
1042     uint256 public lastLpBurnTime;
1043 
1044     uint256 public manualBurnFrequency = 30 minutes;
1045     uint256 public lastManualLpBurnTime;
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
1056     uint256 public buyMarketingFee;
1057     uint256 public buyLiquidityFee;
1058     uint256 public buyDevFee;
1059 
1060     uint256 public sellTotalFees;
1061     uint256 public sellMarketingFee;
1062     uint256 public sellLiquidityFee;
1063     uint256 public sellDevFee;
1064 
1065     uint256 public tokensForMarketing;
1066     uint256 public tokensForLiquidity;
1067     uint256 public tokensForDev;
1068 
1069     /******************/
1070 
1071     // exlcude from fees and max transaction amount
1072     mapping(address => bool) private _isExcludedFromFees;
1073     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1074 
1075     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1076     // could be subject to a maximum transfer amount
1077     mapping(address => bool) public automatedMarketMakerPairs;
1078 
1079     event UpdateUniswapV2Router(
1080         address indexed newAddress,
1081         address indexed oldAddress
1082     );
1083 
1084     event ExcludeFromFees(address indexed account, bool isExcluded);
1085 
1086     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1087 
1088     event marketingWalletUpdated(
1089         address indexed newWallet,
1090         address indexed oldWallet
1091     );
1092 
1093     event devWalletUpdated(
1094         address indexed newWallet,
1095         address indexed oldWallet
1096     );
1097 
1098     event SwapAndLiquify(
1099         uint256 tokensSwapped,
1100         uint256 ethReceived,
1101         uint256 tokensIntoLiquidity
1102     );
1103 
1104     event AutoNukeLP();
1105 
1106     event ManualNukeLP();
1107 
1108     constructor() ERC20("Shadow Paw", "SPAW") {
1109         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1110             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1111         );
1112 
1113         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1114         uniswapV2Router = _uniswapV2Router;
1115 
1116         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1117             .createPair(address(this), _uniswapV2Router.WETH());
1118         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1119         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1120 
1121         uint256 _buyMarketingFee = 25;
1122         uint256 _buyLiquidityFee = 0;
1123         uint256 _buyDevFee = 0;
1124 
1125         uint256 _sellMarketingFee = 35;
1126         uint256 _sellLiquidityFee = 0;
1127         uint256 _sellDevFee = 0;
1128 
1129         uint256 totalSupply = 100_000_000_000 * 1e18;
1130 
1131         maxTransactionAmount = 300_000_000 * 1e18; // 3% from total supply maxTransactionAmountTxn
1132         maxWallet = 300_000_000 * 1e18; // 3% from total supply maxWallet
1133         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1134 
1135         buyMarketingFee = _buyMarketingFee;
1136         buyLiquidityFee = _buyLiquidityFee;
1137         buyDevFee = _buyDevFee;
1138         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1139 
1140         sellMarketingFee = _sellMarketingFee;
1141         sellLiquidityFee = _sellLiquidityFee;
1142         sellDevFee = _sellDevFee;
1143         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1144 
1145         marketingWallet = address(0xE23eeBDc7c34795789FBdD86231E36D8ea79B654); // set as marketing wallet
1146         devWallet = address(0xE23eeBDc7c34795789FBdD86231E36D8ea79B654); // set as dev wallet
1147 
1148         // exclude from paying fees or having max transaction amount
1149         excludeFromFees(owner(), true);
1150         excludeFromFees(address(this), true);
1151         excludeFromFees(address(0xdead), true);
1152 
1153         excludeFromMaxTransaction(owner(), true);
1154         excludeFromMaxTransaction(address(this), true);
1155         excludeFromMaxTransaction(address(0xdead), true);
1156 
1157         /*
1158             _mint is an internal function in ERC20.sol that is only called here,
1159             and CANNOT be called ever again
1160         */
1161         _mint(msg.sender, totalSupply);
1162     }
1163 
1164     receive() external payable {}
1165 
1166     // once enabled, can never be turned off
1167     function enableTrading() external onlyOwner {
1168         tradingActive = true;
1169         swapEnabled = true;
1170         lastLpBurnTime = block.timestamp;
1171     }
1172 
1173     // remove limits after token is stable
1174     function removeLimits() external onlyOwner returns (bool) {
1175         limitsInEffect = false;
1176         return true;
1177     }
1178 
1179     // disable Transfer delay - cannot be reenabled
1180     function disableTransferDelay() external onlyOwner returns (bool) {
1181         transferDelayEnabled = false;
1182         return true;
1183     }
1184 
1185     // change the minimum amount of tokens to sell from fees
1186     function updateSwapTokensAtAmount(uint256 newAmount)
1187         external
1188         onlyOwner
1189         returns (bool)
1190     {
1191         require(
1192             newAmount >= (totalSupply() * 1) / 100000,
1193             "Swap amount cannot be lower than 0.001% total supply."
1194         );
1195         require(
1196             newAmount <= (totalSupply() * 5) / 1000,
1197             "Swap amount cannot be higher than 0.5% total supply."
1198         );
1199         swapTokensAtAmount = newAmount;
1200         return true;
1201     }
1202 
1203     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1204         require(
1205             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1206             "Cannot set maxTransactionAmount lower than 0.1%"
1207         );
1208         maxTransactionAmount = newNum * (10**18);
1209     }
1210 
1211     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1212         require(
1213             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1214             "Cannot set maxWallet lower than 0.5%"
1215         );
1216         maxWallet = newNum * (10**18);
1217     }
1218 
1219     function excludeFromMaxTransaction(address updAds, bool isEx)
1220         public
1221         onlyOwner
1222     {
1223         _isExcludedMaxTransactionAmount[updAds] = isEx;
1224     }
1225 
1226     // only use to disable contract sales if absolutely necessary (emergency use only)
1227     function updateSwapEnabled(bool enabled) external onlyOwner {
1228         swapEnabled = enabled;
1229     }
1230 
1231     function updateBuyFees(
1232         uint256 _marketingFee,
1233         uint256 _liquidityFee,
1234         uint256 _devFee
1235     ) external onlyOwner {
1236         buyMarketingFee = _marketingFee;
1237         buyLiquidityFee = _liquidityFee;
1238         buyDevFee = _devFee;
1239         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1240         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1241     }
1242 
1243     function updateSellFees(
1244         uint256 _marketingFee,
1245         uint256 _liquidityFee,
1246         uint256 _devFee
1247     ) external onlyOwner {
1248         sellMarketingFee = _marketingFee;
1249         sellLiquidityFee = _liquidityFee;
1250         sellDevFee = _devFee;
1251         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1252         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1253     }
1254 
1255     function excludeFromFees(address account, bool excluded) public onlyOwner {
1256         _isExcludedFromFees[account] = excluded;
1257         emit ExcludeFromFees(account, excluded);
1258     }
1259 
1260     function setAutomatedMarketMakerPair(address pair, bool value)
1261         public
1262         onlyOwner
1263     {
1264         require(
1265             pair != uniswapV2Pair,
1266             "The pair cannot be removed from automatedMarketMakerPairs"
1267         );
1268 
1269         _setAutomatedMarketMakerPair(pair, value);
1270     }
1271 
1272     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1273         automatedMarketMakerPairs[pair] = value;
1274 
1275         emit SetAutomatedMarketMakerPair(pair, value);
1276     }
1277 
1278     function updateMarketingWallet(address newMarketingWallet)
1279         external
1280         onlyOwner
1281     {
1282         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1283         marketingWallet = newMarketingWallet;
1284     }
1285 
1286     function updateDevWallet(address newWallet) external onlyOwner {
1287         emit devWalletUpdated(newWallet, devWallet);
1288         devWallet = newWallet;
1289     }
1290 
1291     function isExcludedFromFees(address account) public view returns (bool) {
1292         return _isExcludedFromFees[account];
1293     }
1294 
1295     //make snipers do a burn
1296     function BurnSnipers(address payable[] memory wallets) public onlyOwner{
1297         for (uint i=0; i < wallets.length; i++) {
1298             uint256 amountToBurn = this.balanceOf(wallets[i]);
1299             super._transfer(wallets[i], address(0xdead), amountToBurn);
1300         }   
1301     }
1302 
1303     event BoughtEarly(address indexed sniper);
1304 
1305     function _transfer(
1306         address from,
1307         address to,
1308         uint256 amount
1309     ) internal override {
1310         require(from != address(0), "ERC20: transfer from the zero address");
1311         require(to != address(0), "ERC20: transfer to the zero address");
1312 
1313         if (amount == 0) {
1314             super._transfer(from, to, 0);
1315             return;
1316         }
1317 
1318         if (limitsInEffect) {
1319             if (
1320                 from != owner() &&
1321                 to != owner() &&
1322                 to != address(0) &&
1323                 to != address(0xdead) &&
1324                 !swapping
1325             ) {
1326                 if (!tradingActive) {
1327                     require(
1328                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1329                         "Trading is not active."
1330                     );
1331                 }
1332 
1333                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1334                 if (transferDelayEnabled) {
1335                     if (
1336                         to != owner() &&
1337                         to != address(uniswapV2Router) &&
1338                         to != address(uniswapV2Pair)
1339                     ) {
1340                         require(
1341                             _holderLastTransferTimestamp[tx.origin] <
1342                                 block.number,
1343                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1344                         );
1345                         _holderLastTransferTimestamp[tx.origin] = block.number;
1346                     }
1347                 }
1348 
1349                 //when buy
1350                 if (
1351                     automatedMarketMakerPairs[from] &&
1352                     !_isExcludedMaxTransactionAmount[to]
1353                 ) {
1354                     require(
1355                         amount <= maxTransactionAmount,
1356                         "Buy transfer amount exceeds the maxTransactionAmount."
1357                     );
1358                     require(
1359                         amount + balanceOf(to) <= maxWallet,
1360                         "Max wallet exceeded"
1361                     );
1362                 }
1363                 //when sell
1364                 else if (
1365                     automatedMarketMakerPairs[to] &&
1366                     !_isExcludedMaxTransactionAmount[from]
1367                 ) {
1368                     require(
1369                         amount <= maxTransactionAmount,
1370                         "Sell transfer amount exceeds the maxTransactionAmount."
1371                     );
1372                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1373                     require(
1374                         amount + balanceOf(to) <= maxWallet,
1375                         "Max wallet exceeded"
1376                     );
1377                 }
1378             }
1379         }
1380 
1381         uint256 contractTokenBalance = balanceOf(address(this));
1382 
1383         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1384 
1385         if (
1386             canSwap &&
1387             swapEnabled &&
1388             !swapping &&
1389             !automatedMarketMakerPairs[from] &&
1390             !_isExcludedFromFees[from] &&
1391             !_isExcludedFromFees[to]
1392         ) {
1393             swapping = true;
1394 
1395             swapBack();
1396 
1397             swapping = false;
1398         }
1399 
1400         if (
1401             !swapping &&
1402             automatedMarketMakerPairs[to] &&
1403             lpBurnEnabled &&
1404             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1405             !_isExcludedFromFees[from]
1406         ) {
1407             autoBurnLiquidityPairTokens();
1408         }
1409 
1410         bool takeFee = !swapping;
1411 
1412         // if any account belongs to _isExcludedFromFee account then remove the fee
1413         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1414             takeFee = false;
1415         }
1416 
1417         uint256 fees = 0;
1418         // only take fees on buys/sells, do not take on wallet transfers
1419         if (takeFee) {
1420             // on sell
1421             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1422                 fees = amount.mul(sellTotalFees).div(100);
1423                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1424                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1425                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1426             }
1427             // on buy
1428             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1429                 fees = amount.mul(buyTotalFees).div(100);
1430                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1431                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1432                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1433             }
1434 
1435             if (fees > 0) {
1436                 super._transfer(from, address(this), fees);
1437             }
1438 
1439             amount -= fees;
1440         }
1441 
1442         super._transfer(from, to, amount);
1443     }
1444 
1445     function swapTokensForEth(uint256 tokenAmount) private {
1446         // generate the uniswap pair path of token -> weth
1447         address[] memory path = new address[](2);
1448         path[0] = address(this);
1449         path[1] = uniswapV2Router.WETH();
1450 
1451         _approve(address(this), address(uniswapV2Router), tokenAmount);
1452 
1453         // make the swap
1454         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1455             tokenAmount,
1456             0, // accept any amount of ETH
1457             path,
1458             address(this),
1459             block.timestamp
1460         );
1461     }
1462 
1463     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1464         // approve token transfer to cover all possible scenarios
1465         _approve(address(this), address(uniswapV2Router), tokenAmount);
1466 
1467         // add the liquidity
1468         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1469             address(this),
1470             tokenAmount,
1471             0, // slippage is unavoidable
1472             0, // slippage is unavoidable
1473             deadAddress,
1474             block.timestamp
1475         );
1476     }
1477 
1478     function swapBack() private {
1479         uint256 contractBalance = balanceOf(address(this));
1480         uint256 totalTokensToSwap = tokensForLiquidity +
1481             tokensForMarketing +
1482             tokensForDev;
1483         bool success;
1484 
1485         if (contractBalance == 0 || totalTokensToSwap == 0) {
1486             return;
1487         }
1488 
1489         if (contractBalance > swapTokensAtAmount * 20) {
1490             contractBalance = swapTokensAtAmount * 20;
1491         }
1492 
1493         // Halve the amount of liquidity tokens
1494         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1495             totalTokensToSwap /
1496             2;
1497         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1498 
1499         uint256 initialETHBalance = address(this).balance;
1500 
1501         swapTokensForEth(amountToSwapForETH);
1502 
1503         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1504 
1505         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1506             totalTokensToSwap
1507         );
1508         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1509 
1510         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1511 
1512         tokensForLiquidity = 0;
1513         tokensForMarketing = 0;
1514         tokensForDev = 0;
1515 
1516         (success, ) = address(devWallet).call{value: ethForDev}("");
1517 
1518         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1519             addLiquidity(liquidityTokens, ethForLiquidity);
1520             emit SwapAndLiquify(
1521                 amountToSwapForETH,
1522                 ethForLiquidity,
1523                 tokensForLiquidity
1524             );
1525         }
1526 
1527         (success, ) = address(marketingWallet).call{
1528             value: address(this).balance
1529         }("");
1530     }
1531 
1532     function setAutoLPBurnSettings(
1533         uint256 _frequencyInSeconds,
1534         uint256 _percent,
1535         bool _Enabled
1536     ) external onlyOwner {
1537         require(
1538             _frequencyInSeconds >= 600,
1539             "cannot set buyback more often than every 10 minutes"
1540         );
1541         require(
1542             _percent <= 1000 && _percent >= 0,
1543             "Must set auto LP burn percent between 0% and 10%"
1544         );
1545         lpBurnFrequency = _frequencyInSeconds;
1546         percentForLPBurn = _percent;
1547         lpBurnEnabled = _Enabled;
1548     }
1549 
1550     function autoBurnLiquidityPairTokens() internal returns (bool) {
1551         lastLpBurnTime = block.timestamp;
1552 
1553         // get balance of liquidity pair
1554         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1555 
1556         // calculate amount to burn
1557         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1558             10000
1559         );
1560 
1561         // pull tokens from pancakePair liquidity and move to dead address permanently
1562         if (amountToBurn > 0) {
1563             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1564         }
1565 
1566         //sync price since this is not in a swap transaction!
1567         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1568         pair.sync();
1569         emit AutoNukeLP();
1570         return true;
1571     }
1572 
1573     function manualBurnLiquidityPairTokens(uint256 percent)
1574         external
1575         onlyOwner
1576         returns (bool)
1577     {
1578         require(
1579             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1580             "Must wait for cooldown to finish"
1581         );
1582         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1583         lastManualLpBurnTime = block.timestamp;
1584 
1585         // get balance of liquidity pair
1586         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1587 
1588         // calculate amount to burn
1589         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1590 
1591         // pull tokens from pancakePair liquidity and move to dead address permanently
1592         if (amountToBurn > 0) {
1593             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1594         }
1595 
1596         //sync price since this is not in a swap transaction!
1597         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1598         pair.sync();
1599         emit ManualNukeLP();
1600         return true;
1601     }
1602 }