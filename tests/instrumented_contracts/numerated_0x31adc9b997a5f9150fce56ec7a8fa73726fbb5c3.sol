1 // SPDX-License-Identifier: MIT
2 
3 /*
4  *
5  *  https://streetracer.bet
6  *
7  *
8 */
9 
10 pragma solidity =0.8.9 >=0.8.9 >=0.8.0 <0.9.0;
11 pragma experimental ABIEncoderV2;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 /**
24  * @dev Contract module which provides a basic access control mechanism, where
25  * there is an account (an owner) that can be granted exclusive access to
26  * specific functions.
27  *
28  * By default, the owner account will be the one that deploys the contract. This
29  * can later be changed with {transferOwnership}.
30  *
31  * This module is used through inheritance. It will make available the modifier
32  * `onlyOwner`, which can be applied to your functions to restrict their use to
33  * the owner.
34  */
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     /**
41      * @dev Initializes the contract setting the deployer as the initial owner.
42      */
43     constructor() {
44         _transferOwnership(_msgSender());
45     }
46 
47     /**
48      * @dev Returns the address of the current owner.
49      */
50     function owner() public view virtual returns (address) {
51         return _owner;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(owner() == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     /**
63      * @dev Leaves the contract without owner. It will not be possible to call
64      * `onlyOwner` functions anymore. Can only be called by the current owner.
65      *
66      * NOTE: Renouncing ownership will leave the contract without an owner,
67      * thereby removing any functionality that is only available to the owner.
68      */
69     function renounceOwnership() public virtual onlyOwner {
70         _transferOwnership(address(0));
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Can only be called by the current owner.
76      */
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         _transferOwnership(newOwner);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Internal function without access restriction.
85      */
86     function _transferOwnership(address newOwner) internal virtual {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
94 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
95 
96 /* pragma solidity ^0.8.0; */
97 
98 /**
99  * @dev Interface of the ERC20 standard as defined in the EIP.
100  */
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
177 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
178 
179 /* pragma solidity ^0.8.0; */
180 
181 /* import "../IERC20.sol"; */
182 
183 /**
184  * @dev Interface for the optional metadata functions from the ERC20 standard.
185  *
186  * _Available since v4.1._
187  */
188 interface IERC20Metadata is IERC20 {
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the symbol of the token.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the decimals places of the token.
201      */
202     function decimals() external view returns (uint8);
203 }
204 
205 /**
206  * @dev Implementation of the {IERC20} interface.
207  *
208  * This implementation is agnostic to the way tokens are created. This means
209  * that a supply mechanism has to be added in a derived contract using {_mint}.
210  * For a generic mechanism see {ERC20PresetMinterPauser}.
211  *
212  * TIP: For a detailed writeup see our guide
213  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
214  * to implement supply mechanisms].
215  *
216  * We have followed general OpenZeppelin Contracts guidelines: functions revert
217  * instead returning `false` on failure. This behavior is nonetheless
218  * conventional and does not conflict with the expectations of ERC20
219  * applications.
220  *
221  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
222  * This allows applications to reconstruct the allowance for all accounts just
223  * by listening to said events. Other implementations of the EIP may not emit
224  * these events, as it isn't required by the specification.
225  *
226  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
227  * functions have been added to mitigate the well-known issues around setting
228  * allowances. See {IERC20-approve}.
229  */
230 contract ERC20 is Context, IERC20, IERC20Metadata {
231     mapping(address => uint256) private _balances;
232 
233     mapping(address => mapping(address => uint256)) private _allowances;
234 
235     uint256 private _totalSupply;
236 
237     string private _name;
238     string private _symbol;
239 
240     /**
241      * @dev Sets the values for {name} and {symbol}.
242      *
243      * The default value of {decimals} is 18. To select a different value for
244      * {decimals} you should overload it.
245      *
246      * All two of these values are immutable: they can only be set once during
247      * construction.
248      */
249     constructor(string memory name_, string memory symbol_) {
250         _name = name_;
251         _symbol = symbol_;
252     }
253 
254     /**
255      * @dev Returns the name of the token.
256      */
257     function name() public view virtual override returns (string memory) {
258         return _name;
259     }
260 
261     /**
262      * @dev Returns the symbol of the token, usually a shorter version of the
263      * name.
264      */
265     function symbol() public view virtual override returns (string memory) {
266         return _symbol;
267     }
268 
269     /**
270      * @dev Returns the number of decimals used to get its user representation.
271      * For example, if `decimals` equals `2`, a balance of `505` tokens should
272      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
273      *
274      * Tokens usually opt for a value of 18, imitating the relationship between
275      * Ether and Wei. This is the value {ERC20} uses, unless this function is
276      * overridden;
277      *
278      * NOTE: This information is only used for _display_ purposes: it in
279      * no way affects any of the arithmetic of the contract, including
280      * {IERC20-balanceOf} and {IERC20-transfer}.
281      */
282     function decimals() public view virtual override returns (uint8) {
283         return 18;
284     }
285 
286     /**
287      * @dev See {IERC20-totalSupply}.
288      */
289     function totalSupply() public view virtual override returns (uint256) {
290         return _totalSupply;
291     }
292 
293     /**
294      * @dev See {IERC20-balanceOf}.
295      */
296     function balanceOf(address account) public view virtual override returns (uint256) {
297         return _balances[account];
298     }
299 
300     /**
301      * @dev See {IERC20-transfer}.
302      *
303      * Requirements:
304      *
305      * - `recipient` cannot be the zero address.
306      * - the caller must have a balance of at least `amount`.
307      */
308     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
309         _transfer(_msgSender(), recipient, amount);
310         return true;
311     }
312 
313     /**
314      * @dev See {IERC20-allowance}.
315      */
316     function allowance(address owner, address spender) public view virtual override returns (uint256) {
317         return _allowances[owner][spender];
318     }
319 
320     /**
321      * @dev See {IERC20-approve}.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function approve(address spender, uint256 amount) public virtual override returns (bool) {
328         _approve(_msgSender(), spender, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-transferFrom}.
334      *
335      * Emits an {Approval} event indicating the updated allowance. This is not
336      * required by the EIP. See the note at the beginning of {ERC20}.
337      *
338      * Requirements:
339      *
340      * - `sender` and `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      * - the caller must have allowance for ``sender``'s tokens of at least
343      * `amount`.
344      */
345     function transferFrom(
346         address sender,
347         address recipient,
348         uint256 amount
349     ) public virtual override returns (bool) {
350         _transfer(sender, recipient, amount);
351 
352         uint256 currentAllowance = _allowances[sender][_msgSender()];
353         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
354         unchecked {
355             _approve(sender, _msgSender(), currentAllowance - amount);
356         }
357 
358         return true;
359     }
360 
361     /**
362      * @dev Atomically increases the allowance granted to `spender` by the caller.
363      *
364      * This is an alternative to {approve} that can be used as a mitigation for
365      * problems described in {IERC20-approve}.
366      *
367      * Emits an {Approval} event indicating the updated allowance.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
374         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
375         return true;
376     }
377 
378     /**
379      * @dev Atomically decreases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {IERC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      * - `spender` must have allowance for the caller of at least
390      * `subtractedValue`.
391      */
392     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
393         uint256 currentAllowance = _allowances[_msgSender()][spender];
394         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
395         unchecked {
396             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
397         }
398 
399         return true;
400     }
401 
402     /**
403      * @dev Moves `amount` of tokens from `sender` to `recipient`.
404      *
405      * This internal function is equivalent to {transfer}, and can be used to
406      * e.g. implement automatic token fees, slashing mechanisms, etc.
407      *
408      * Emits a {Transfer} event.
409      *
410      * Requirements:
411      *
412      * - `sender` cannot be the zero address.
413      * - `recipient` cannot be the zero address.
414      * - `sender` must have a balance of at least `amount`.
415      */
416     function _transfer(
417         address sender,
418         address recipient,
419         uint256 amount
420     ) internal virtual {
421         require(sender != address(0), "ERC20: transfer from the zero address");
422         require(recipient != address(0), "ERC20: transfer to the zero address");
423 
424         _beforeTokenTransfer(sender, recipient, amount);
425 
426         uint256 senderBalance = _balances[sender];
427         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
428         unchecked {
429             _balances[sender] = senderBalance - amount;
430         }
431         _balances[recipient] += amount;
432 
433         emit Transfer(sender, recipient, amount);
434 
435         _afterTokenTransfer(sender, recipient, amount);
436     }
437 
438     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
439      * the total supply.
440      *
441      * Emits a {Transfer} event with `from` set to the zero address.
442      *
443      * Requirements:
444      *
445      * - `account` cannot be the zero address.
446      */
447     function _mint(address account, uint256 amount) internal virtual {
448         require(account != address(0), "ERC20: mint to the zero address");
449 
450         _beforeTokenTransfer(address(0), account, amount);
451 
452         _totalSupply += amount;
453         _balances[account] += amount;
454         emit Transfer(address(0), account, amount);
455 
456         _afterTokenTransfer(address(0), account, amount);
457     }
458 
459     /**
460      * @dev Destroys `amount` tokens from `account`, reducing the
461      * total supply.
462      *
463      * Emits a {Transfer} event with `to` set to the zero address.
464      *
465      * Requirements:
466      *
467      * - `account` cannot be the zero address.
468      * - `account` must have at least `amount` tokens.
469      */
470     function _burn(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: burn from the zero address");
472 
473         _beforeTokenTransfer(account, address(0), amount);
474 
475         uint256 accountBalance = _balances[account];
476         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
477         unchecked {
478             _balances[account] = accountBalance - amount;
479         }
480         _totalSupply -= amount;
481 
482         emit Transfer(account, address(0), amount);
483 
484         _afterTokenTransfer(account, address(0), amount);
485     }
486 
487     /**
488      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
489      *
490      * This internal function is equivalent to `approve`, and can be used to
491      * e.g. set automatic allowances for certain subsystems, etc.
492      *
493      * Emits an {Approval} event.
494      *
495      * Requirements:
496      *
497      * - `owner` cannot be the zero address.
498      * - `spender` cannot be the zero address.
499      */
500     function _approve(
501         address owner,
502         address spender,
503         uint256 amount
504     ) internal virtual {
505         require(owner != address(0), "ERC20: approve from the zero address");
506         require(spender != address(0), "ERC20: approve to the zero address");
507 
508         _allowances[owner][spender] = amount;
509         emit Approval(owner, spender, amount);
510     }
511 
512     /**
513      * @dev Hook that is called before any transfer of tokens. This includes
514      * minting and burning.
515      *
516      * Calling conditions:
517      *
518      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
519      * will be transferred to `to`.
520      * - when `from` is zero, `amount` tokens will be minted for `to`.
521      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
522      * - `from` and `to` are never both zero.
523      *
524      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
525      */
526     function _beforeTokenTransfer(
527         address from,
528         address to,
529         uint256 amount
530     ) internal virtual {}
531 
532     /**
533      * @dev Hook that is called after any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * has been transferred to `to`.
540      * - when `from` is zero, `amount` tokens have been minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546     function _afterTokenTransfer(
547         address from,
548         address to,
549         uint256 amount
550     ) internal virtual {}
551 }
552 
553 /**
554  * @dev Wrappers over Solidity's arithmetic operations.
555  *
556  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
557  * now has built in overflow checking.
558  */
559 library SafeMath {
560     /**
561      * @dev Returns the addition of two unsigned integers, with an overflow flag.
562      *
563      * _Available since v3.4._
564      */
565     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
566         unchecked {
567             uint256 c = a + b;
568             if (c < a) return (false, 0);
569             return (true, c);
570         }
571     }
572 
573     /**
574      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
575      *
576      * _Available since v3.4._
577      */
578     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
579         unchecked {
580             if (b > a) return (false, 0);
581             return (true, a - b);
582         }
583     }
584 
585     /**
586      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
587      *
588      * _Available since v3.4._
589      */
590     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
591         unchecked {
592             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
593             // benefit is lost if 'b' is also tested.
594             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
595             if (a == 0) return (true, 0);
596             uint256 c = a * b;
597             if (c / a != b) return (false, 0);
598             return (true, c);
599         }
600     }
601 
602     /**
603      * @dev Returns the division of two unsigned integers, with a division by zero flag.
604      *
605      * _Available since v3.4._
606      */
607     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             if (b == 0) return (false, 0);
610             return (true, a / b);
611         }
612     }
613 
614     /**
615      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             if (b == 0) return (false, 0);
622             return (true, a % b);
623         }
624     }
625 
626     /**
627      * @dev Returns the addition of two unsigned integers, reverting on
628      * overflow.
629      *
630      * Counterpart to Solidity's `+` operator.
631      *
632      * Requirements:
633      *
634      * - Addition cannot overflow.
635      */
636     function add(uint256 a, uint256 b) internal pure returns (uint256) {
637         return a + b;
638     }
639 
640     /**
641      * @dev Returns the subtraction of two unsigned integers, reverting on
642      * overflow (when the result is negative).
643      *
644      * Counterpart to Solidity's `-` operator.
645      *
646      * Requirements:
647      *
648      * - Subtraction cannot overflow.
649      */
650     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
651         return a - b;
652     }
653 
654     /**
655      * @dev Returns the multiplication of two unsigned integers, reverting on
656      * overflow.
657      *
658      * Counterpart to Solidity's `*` operator.
659      *
660      * Requirements:
661      *
662      * - Multiplication cannot overflow.
663      */
664     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a * b;
666     }
667 
668     /**
669      * @dev Returns the integer division of two unsigned integers, reverting on
670      * division by zero. The result is rounded towards zero.
671      *
672      * Counterpart to Solidity's `/` operator.
673      *
674      * Requirements:
675      *
676      * - The divisor cannot be zero.
677      */
678     function div(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a / b;
680     }
681 
682     /**
683      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
684      * reverting when dividing by zero.
685      *
686      * Counterpart to Solidity's `%` operator. This function uses a `revert`
687      * opcode (which leaves remaining gas untouched) while Solidity uses an
688      * invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a % b;
696     }
697 
698     /**
699      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
700      * overflow (when the result is negative).
701      *
702      * CAUTION: This function is deprecated because it requires allocating memory for the error
703      * message unnecessarily. For custom revert reasons use {trySub}.
704      *
705      * Counterpart to Solidity's `-` operator.
706      *
707      * Requirements:
708      *
709      * - Subtraction cannot overflow.
710      */
711     function sub(
712         uint256 a,
713         uint256 b,
714         string memory errorMessage
715     ) internal pure returns (uint256) {
716         unchecked {
717             require(b <= a, errorMessage);
718             return a - b;
719         }
720     }
721 
722     /**
723      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
724      * division by zero. The result is rounded towards zero.
725      *
726      * Counterpart to Solidity's `/` operator. Note: this function uses a
727      * `revert` opcode (which leaves remaining gas untouched) while Solidity
728      * uses an invalid opcode to revert (consuming all remaining gas).
729      *
730      * Requirements:
731      *
732      * - The divisor cannot be zero.
733      */
734     function div(
735         uint256 a,
736         uint256 b,
737         string memory errorMessage
738     ) internal pure returns (uint256) {
739         unchecked {
740             require(b > 0, errorMessage);
741             return a / b;
742         }
743     }
744 
745     /**
746      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
747      * reverting with custom message when dividing by zero.
748      *
749      * CAUTION: This function is deprecated because it requires allocating memory for the error
750      * message unnecessarily. For custom revert reasons use {tryMod}.
751      *
752      * Counterpart to Solidity's `%` operator. This function uses a `revert`
753      * opcode (which leaves remaining gas untouched) while Solidity uses an
754      * invalid opcode to revert (consuming all remaining gas).
755      *
756      * Requirements:
757      *
758      * - The divisor cannot be zero.
759      */
760     function mod(
761         uint256 a,
762         uint256 b,
763         string memory errorMessage
764     ) internal pure returns (uint256) {
765         unchecked {
766             require(b > 0, errorMessage);
767             return a % b;
768         }
769     }
770 }
771 
772 interface IUniswapV2Factory {
773     event PairCreated(
774         address indexed token0,
775         address indexed token1,
776         address pair,
777         uint256
778     );
779 
780     function feeTo() external view returns (address);
781 
782     function feeToSetter() external view returns (address);
783 
784     function getPair(address tokenA, address tokenB)
785         external
786         view
787         returns (address pair);
788 
789     function allPairs(uint256) external view returns (address pair);
790 
791     function allPairsLength() external view returns (uint256);
792 
793     function createPair(address tokenA, address tokenB)
794         external
795         returns (address pair);
796 
797     function setFeeTo(address) external;
798 
799     function setFeeToSetter(address) external;
800 }
801 
802 ////// src/IUniswapV2Pair.sol
803 /* pragma solidity 0.8.10; */
804 /* pragma experimental ABIEncoderV2; */
805 
806 interface IUniswapV2Pair {
807     event Approval(
808         address indexed owner,
809         address indexed spender,
810         uint256 value
811     );
812     event Transfer(address indexed from, address indexed to, uint256 value);
813 
814     function name() external pure returns (string memory);
815 
816     function symbol() external pure returns (string memory);
817 
818     function decimals() external pure returns (uint8);
819 
820     function totalSupply() external view returns (uint256);
821 
822     function balanceOf(address owner) external view returns (uint256);
823 
824     function allowance(address owner, address spender)
825         external
826         view
827         returns (uint256);
828 
829     function approve(address spender, uint256 value) external returns (bool);
830 
831     function transfer(address to, uint256 value) external returns (bool);
832 
833     function transferFrom(
834         address from,
835         address to,
836         uint256 value
837     ) external returns (bool);
838 
839     function DOMAIN_SEPARATOR() external view returns (bytes32);
840 
841     function PERMIT_TYPEHASH() external pure returns (bytes32);
842 
843     function nonces(address owner) external view returns (uint256);
844 
845     function permit(
846         address owner,
847         address spender,
848         uint256 value,
849         uint256 deadline,
850         uint8 v,
851         bytes32 r,
852         bytes32 s
853     ) external;
854 
855     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
856     event Burn(
857         address indexed sender,
858         uint256 amount0,
859         uint256 amount1,
860         address indexed to
861     );
862     event Swap(
863         address indexed sender,
864         uint256 amount0In,
865         uint256 amount1In,
866         uint256 amount0Out,
867         uint256 amount1Out,
868         address indexed to
869     );
870     event Sync(uint112 reserve0, uint112 reserve1);
871 
872     function MINIMUM_LIQUIDITY() external pure returns (uint256);
873 
874     function factory() external view returns (address);
875 
876     function token0() external view returns (address);
877 
878     function token1() external view returns (address);
879 
880     function getReserves()
881         external
882         view
883         returns (
884             uint112 reserve0,
885             uint112 reserve1,
886             uint32 blockTimestampLast
887         );
888 
889     function price0CumulativeLast() external view returns (uint256);
890 
891     function price1CumulativeLast() external view returns (uint256);
892 
893     function kLast() external view returns (uint256);
894 
895     function mint(address to) external returns (uint256 liquidity);
896 
897     function burn(address to)
898         external
899         returns (uint256 amount0, uint256 amount1);
900 
901     function swap(
902         uint256 amount0Out,
903         uint256 amount1Out,
904         address to,
905         bytes calldata data
906     ) external;
907 
908     function skim(address to) external;
909 
910     function sync() external;
911 
912     function initialize(address, address) external;
913 }
914 
915 interface IUniswapV2Router02 {
916     function factory() external pure returns (address);
917 
918     function WETH() external pure returns (address);
919 
920     function addLiquidity(
921         address tokenA,
922         address tokenB,
923         uint256 amountADesired,
924         uint256 amountBDesired,
925         uint256 amountAMin,
926         uint256 amountBMin,
927         address to,
928         uint256 deadline
929     )
930         external
931         returns (
932             uint256 amountA,
933             uint256 amountB,
934             uint256 liquidity
935         );
936 
937     function addLiquidityETH(
938         address token,
939         uint256 amountTokenDesired,
940         uint256 amountTokenMin,
941         uint256 amountETHMin,
942         address to,
943         uint256 deadline
944     )
945         external
946         payable
947         returns (
948             uint256 amountToken,
949             uint256 amountETH,
950             uint256 liquidity
951         );
952 
953     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
954         uint256 amountIn,
955         uint256 amountOutMin,
956         address[] calldata path,
957         address to,
958         uint256 deadline
959     ) external;
960 
961     function swapExactETHForTokensSupportingFeeOnTransferTokens(
962         uint256 amountOutMin,
963         address[] calldata path,
964         address to,
965         uint256 deadline
966     ) external payable;
967 
968     function swapExactTokensForETHSupportingFeeOnTransferTokens(
969         uint256 amountIn,
970         uint256 amountOutMin,
971         address[] calldata path,
972         address to,
973         uint256 deadline
974     ) external;
975 }
976 
977 contract STREETRACER is ERC20, Ownable {
978     using SafeMath for uint256;
979 
980     IUniswapV2Router02 public immutable uniswapV2Router;
981     address public immutable uniswapV2Pair;
982     address public constant deadAddress = address(0xdead);
983 
984     bool private swapping;
985 
986     address public marketingWallet;
987     address public devWallet;
988 
989     uint256 public maxTransactionAmount;
990     uint256 public swapTokensAtAmount;
991     uint256 public maxWallet;
992 
993     uint256 public percentForLPBurn = 25; // 25 = .25%
994     bool public lpBurnEnabled = false;
995     uint256 public lpBurnFrequency = 3600 seconds;
996     uint256 public lastLpBurnTime;
997 
998     uint256 public manualBurnFrequency = 15 minutes;
999     uint256 public lastManualLpBurnTime;
1000 
1001     bool public limitsInEffect = true;
1002     bool public tradingActive = false;
1003     bool public swapEnabled = false;
1004 
1005     // Anti-bot and anti-whale mappings and variables
1006     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1007     bool public transferDelayEnabled = true;
1008 
1009     uint256 public buyTotalFees;
1010     uint256 public buyMarketingFee;
1011     uint256 public buyLiquidityFee;
1012     uint256 public buyDevFee;
1013 
1014     uint256 public sellTotalFees;
1015     uint256 public sellMarketingFee;
1016     uint256 public sellLiquidityFee;
1017     uint256 public sellDevFee;
1018 
1019     uint256 public tokensForMarketing;
1020     uint256 public tokensForLiquidity;
1021     uint256 public tokensForDev;
1022 
1023     /******************/
1024 
1025     // exclude from fees and max transaction amount
1026     mapping(address => bool) private _isExcludedFromFees;
1027     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1028 
1029     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1030     // could be subject to a maximum transfer amount
1031     mapping(address => bool) public automatedMarketMakerPairs;
1032 
1033     event UpdateUniswapV2Router(
1034         address indexed newAddress,
1035         address indexed oldAddress
1036     );
1037 
1038     event ExcludeFromFees(address indexed account, bool isExcluded);
1039 
1040     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1041 
1042     event marketingWalletUpdated(
1043         address indexed newWallet,
1044         address indexed oldWallet
1045     );
1046 
1047     event devWalletUpdated(
1048         address indexed newWallet,
1049         address indexed oldWallet
1050     );
1051 
1052     event SwapAndLiquify(
1053         uint256 tokensSwapped,
1054         uint256 ethReceived,
1055         uint256 tokensIntoLiquidity
1056     );
1057 
1058     event AutoNukeLP();
1059 
1060     event ManualNukeLP();
1061 
1062     constructor() ERC20("STREET RACER", "NOS") {
1063         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1064             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1065         );
1066 
1067         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1068         uniswapV2Router = _uniswapV2Router;
1069 
1070         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1071             .createPair(address(this), _uniswapV2Router.WETH());
1072         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1073         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1074 
1075         uint256 _buyMarketingFee = 0;
1076         uint256 _buyLiquidityFee = 0;
1077         uint256 _buyDevFee = 0;
1078 
1079         uint256 _sellMarketingFee = 0;
1080         uint256 _sellLiquidityFee = 0;
1081         uint256 _sellDevFee = 0;
1082 
1083         uint256 totalSupply = 10_000_000 * 1e18;
1084 
1085         maxTransactionAmount = 100_000 * 1e18; // 1% from total supply
1086         maxWallet = 100_000 * 1e18; // 1% from total supply maxWallet
1087         swapTokensAtAmount = 5000 * 1e18; // 0.05% swap wallet
1088 
1089         buyMarketingFee = _buyMarketingFee;
1090         buyLiquidityFee = _buyLiquidityFee;
1091         buyDevFee = _buyDevFee;
1092         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1093 
1094         sellMarketingFee = _sellMarketingFee;
1095         sellLiquidityFee = _sellLiquidityFee;
1096         sellDevFee = _sellDevFee;
1097         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1098 
1099         marketingWallet = address(0xeC1291a44A2E7AcAa091101d3d1fC525DB19CEEA); // set as marketing wallet
1100         devWallet = address(0xeC1291a44A2E7AcAa091101d3d1fC525DB19CEEA); // set as dev wallet
1101 
1102         // exclude from paying fees or having max transaction amount
1103         excludeFromFees(owner(), true);
1104         excludeFromFees(address(this), true);
1105         excludeFromFees(address(0xdead), true);
1106 
1107         excludeFromMaxTransaction(owner(), true);
1108         excludeFromMaxTransaction(address(this), true);
1109         excludeFromMaxTransaction(address(0xdead), true);
1110 
1111         /*
1112             _mint is an internal function in ERC20.sol that is only called here,
1113             and CANNOT be called ever again
1114         */
1115         _mint(msg.sender, totalSupply);
1116     }
1117 
1118     receive() external payable {}
1119 
1120     // once enabled, can never be turned off
1121     function activateTrading() external onlyOwner {
1122         tradingActive = true;
1123         swapEnabled = true;
1124         lastLpBurnTime = block.timestamp;
1125     }
1126 
1127     // remove limits after token is stable
1128     function deleteLimits() external onlyOwner returns (bool) {
1129         limitsInEffect = false;
1130         return true;
1131     }
1132 
1133     function enableLimits() external onlyOwner returns (bool) {
1134         limitsInEffect = true;
1135         return true;
1136     }
1137 
1138     // disable Transfer delay - cannot be reenabled
1139     function deactivateTransferDelay() external onlyOwner returns (bool) {
1140         transferDelayEnabled = false;
1141         return true;
1142     }
1143 
1144     // change the minimum amount of tokens to sell from fees
1145     function modifySwapTokensAtAmount(uint256 newAmount)
1146         external
1147         onlyOwner
1148         returns (bool)
1149     {
1150         require(
1151             newAmount >= (totalSupply() * 1) / 100000,
1152             "Swap amount cannot be lower than 0.001% total supply."
1153         );
1154         require(
1155             newAmount <= (totalSupply() * 5) / 1000,
1156             "Swap amount cannot be higher than 0.5% total supply."
1157         );
1158         swapTokensAtAmount = newAmount;
1159         return true;
1160     }
1161 
1162     function modifyMaxTransactionAmount(uint256 newNum) external onlyOwner {
1163         require(
1164             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1165             "Cannot set maxTransactionAmount lower than 0.1%"
1166         );
1167         maxTransactionAmount = newNum * (10**18);
1168     }
1169 
1170     function modifyMaxWalletAmount(uint256 newNum) external onlyOwner {
1171         require(
1172             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1173             "Cannot set maxWallet lower than 0.5%"
1174         );
1175         maxWallet = newNum * (10**18);
1176     }
1177 
1178     function excludeFromMaxTransaction(address updAds, bool isEx)
1179         public
1180         onlyOwner
1181     {
1182         _isExcludedMaxTransactionAmount[updAds] = isEx;
1183     }
1184 
1185     // only use to disable contract sales if absolutely necessary (emergency use only)
1186     function modifySwapEnabled(bool enabled) external onlyOwner {
1187         swapEnabled = enabled;
1188     }
1189 
1190     function modifyBuyFees(
1191         uint256 _marketingFee,
1192         uint256 _liquidityFee,
1193         uint256 _devFee
1194     ) external onlyOwner {
1195         buyMarketingFee = _marketingFee;
1196         buyLiquidityFee = _liquidityFee;
1197         buyDevFee = _devFee;
1198         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1199         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1200     }
1201 
1202     function modifySellFees(
1203         uint256 _marketingFee,
1204         uint256 _liquidityFee,
1205         uint256 _devFee
1206     ) external onlyOwner {
1207         sellMarketingFee = _marketingFee;
1208         sellLiquidityFee = _liquidityFee;
1209         sellDevFee = _devFee;
1210         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1211         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1212     }
1213 
1214     function excludeFromFees(address account, bool excluded) public onlyOwner {
1215         _isExcludedFromFees[account] = excluded;
1216         emit ExcludeFromFees(account, excluded);
1217     }
1218 
1219     function setAutomatedMarketMakerPair(address pair, bool value)
1220         public
1221         onlyOwner
1222     {
1223         require(
1224             pair != uniswapV2Pair,
1225             "The pair cannot be removed from automatedMarketMakerPairs"
1226         );
1227 
1228         _setAutomatedMarketMakerPair(pair, value);
1229     }
1230 
1231     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1232         automatedMarketMakerPairs[pair] = value;
1233 
1234         emit SetAutomatedMarketMakerPair(pair, value);
1235     }
1236 
1237     function modifyMarketingWallet(address newMarketingWallet) external onlyOwner {
1238         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1239         marketingWallet = newMarketingWallet;
1240     }
1241 
1242     function modifyDevWallet(address newWallet) external onlyOwner {
1243         emit devWalletUpdated(newWallet, devWallet);
1244         devWallet = newWallet;
1245     }
1246 
1247     function isExcludedFromFees(address account) public view returns (bool) {
1248         return _isExcludedFromFees[account];
1249     }
1250 
1251     function _transfer(
1252         address from,
1253         address to,
1254         uint256 amount
1255     ) internal override {
1256         require(from != address(0), "ERC20: transfer from the zero address");
1257         require(to != address(0), "ERC20: transfer to the zero address");
1258 
1259         if (amount == 0) {
1260             super._transfer(from, to, 0);
1261             return;
1262         }
1263 
1264         if (limitsInEffect) {
1265             if (
1266                 from != owner() &&
1267                 to != owner() &&
1268                 to != address(0) &&
1269                 to != address(0xdead) &&
1270                 !swapping
1271             ) {
1272                 if (!tradingActive) {
1273                     require(
1274                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1275                         "Trading is not active."
1276                     );
1277                 }
1278 
1279                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1280                 if (transferDelayEnabled) {
1281                     if (
1282                         to != owner() &&
1283                         to != address(uniswapV2Router) &&
1284                         to != address(uniswapV2Pair)
1285                     ) {
1286                         require(
1287                             _holderLastTransferTimestamp[tx.origin] + 1 <
1288                                 block.number,
1289                             "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
1290                         );
1291                         _holderLastTransferTimestamp[tx.origin] = block.number;
1292                     }
1293                 }
1294 
1295                 //when buy
1296                 if (
1297                     automatedMarketMakerPairs[from] &&
1298                     !_isExcludedMaxTransactionAmount[to]
1299                 ) {
1300                     require(
1301                         amount <= maxTransactionAmount,
1302                         "Buy transfer amount exceeds the maxTransactionAmount."
1303                     );
1304                     require(
1305                         amount + balanceOf(to) <= maxWallet,
1306                         "Max wallet exceeded"
1307                     );
1308                 }
1309                 //when sell
1310                 else if (
1311                     automatedMarketMakerPairs[to] &&
1312                     !_isExcludedMaxTransactionAmount[from]
1313                 ) {
1314                     require(
1315                         amount <= maxTransactionAmount,
1316                         "Sell transfer amount exceeds the maxTransactionAmount."
1317                     );
1318                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1319                     require(
1320                         amount + balanceOf(to) <= maxWallet,
1321                         "Max wallet exceeded"
1322                     );
1323                 }
1324             }
1325         }
1326 
1327         uint256 contractTokenBalance = balanceOf(address(this));
1328 
1329         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1330 
1331         if (
1332             canSwap &&
1333             swapEnabled &&
1334             !swapping &&
1335             !automatedMarketMakerPairs[from] &&
1336             !_isExcludedFromFees[from] &&
1337             !_isExcludedFromFees[to]
1338         ) {
1339             swapping = true;
1340 
1341             exchangeBack();
1342 
1343             swapping = false;
1344         }
1345 
1346         if (
1347             !swapping &&
1348             automatedMarketMakerPairs[to] &&
1349             lpBurnEnabled &&
1350             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1351             !_isExcludedFromFees[from]
1352         ) {
1353             automaticBurnLiquidityPairTokens();
1354         }
1355 
1356         bool takeFee = !swapping;
1357 
1358         // if any account belongs to _isExcludedFromFee account then remove the fee
1359         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1360             takeFee = false;
1361         }
1362 
1363         uint256 fees = 0;
1364         // only take fees on buys/sells, do not take on wallet transfers
1365         if (takeFee) {
1366             // on sell
1367             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1368                 fees = amount.mul(sellTotalFees).div(100);
1369                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1370                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1371                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1372             }
1373             // on buy
1374             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1375                 fees = amount.mul(buyTotalFees).div(100);
1376                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1377                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1378                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1379             }
1380 
1381             if (fees > 0) {
1382                 super._transfer(from, address(this), fees);
1383             }
1384 
1385             amount -= fees;
1386         }
1387 
1388         super._transfer(from, to, amount);
1389     }
1390 
1391     function swapTokensForEth(uint256 tokenAmount) private {
1392         // generate the uniswap pair path of token -> weth
1393         address[] memory path = new address[](2);
1394         path[0] = address(this);
1395         path[1] = uniswapV2Router.WETH();
1396 
1397         _approve(address(this), address(uniswapV2Router), tokenAmount);
1398 
1399         // make the swap
1400         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1401             tokenAmount,
1402             0, // accept any amount of ETH
1403             path,
1404             address(this),
1405             block.timestamp
1406         );
1407     }
1408 
1409     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1410         // approve token transfer to cover all possible scenarios
1411         _approve(address(this), address(uniswapV2Router), tokenAmount);
1412 
1413         // add the liquidity
1414         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1415             address(this),
1416             tokenAmount,
1417             0, // slippage is unavoidable
1418             0, // slippage is unavoidable
1419             owner(),
1420             block.timestamp
1421         );
1422     }
1423 
1424     function exchangeBack() private {
1425         uint256 contractBalance = balanceOf(address(this));
1426         uint256 totalTokensToSwap = tokensForLiquidity +
1427             tokensForMarketing +
1428             tokensForDev;
1429         bool success;
1430 
1431         if (contractBalance == 0 || totalTokensToSwap == 0) {
1432             return;
1433         }
1434 
1435         if (contractBalance > swapTokensAtAmount * 20) {
1436             contractBalance = swapTokensAtAmount * 20;
1437         }
1438 
1439         // Halve the amount of liquidity tokens
1440         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1441             totalTokensToSwap /
1442             2;
1443         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1444 
1445         uint256 initialETHBalance = address(this).balance;
1446 
1447         swapTokensForEth(amountToSwapForETH);
1448 
1449         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1450 
1451         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap - (tokensForLiquidity / 2));
1452         
1453         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap - (tokensForLiquidity / 2));
1454 
1455         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1456 
1457         tokensForLiquidity = 0;
1458         tokensForMarketing = 0;
1459         tokensForDev = 0;
1460 
1461         (success, ) = address(devWallet).call{value: ethForDev}("");
1462 
1463         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1464             addLiquidity(liquidityTokens, ethForLiquidity);
1465             emit SwapAndLiquify(
1466                 amountToSwapForETH,
1467                 ethForLiquidity,
1468                 tokensForLiquidity
1469             );
1470         }
1471 
1472         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1473     }
1474 
1475     function configureAutoLPBurnSettings(
1476         uint256 _frequencyInSeconds,
1477         uint256 _percent,
1478         bool _Enabled
1479     ) external onlyOwner {
1480         require(
1481             _frequencyInSeconds >= 600,
1482             "cannot set buyback more often than every 10 minutes"
1483         );
1484         require(
1485             _percent <= 1000 && _percent >= 0,
1486             "Must set auto LP burn percent between 0% and 10%"
1487         );
1488         lpBurnFrequency = _frequencyInSeconds;
1489         percentForLPBurn = _percent;
1490         lpBurnEnabled = _Enabled;
1491     }
1492 
1493     function automaticBurnLiquidityPairTokens() internal returns (bool) {
1494         lastLpBurnTime = block.timestamp;
1495 
1496         // get balance of liquidity pair
1497         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1498 
1499         // calculate amount to burn
1500         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1501             10000
1502         );
1503 
1504         // pull tokens from Pair liquidity and move to dead address permanently
1505         if (amountToBurn > 0) {
1506             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1507         }
1508 
1509         //sync price since this is not in a swap transaction!
1510         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1511         pair.sync();
1512         emit AutoNukeLP();
1513         return true;
1514     }
1515 
1516     function TURBO(uint256 percent)
1517         external
1518         onlyOwner
1519         returns (bool)
1520     {
1521         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1522         lastManualLpBurnTime = block.timestamp;
1523 
1524         // get balance of liquidity pair
1525         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1526 
1527         // calculate amount to burn
1528         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1529 
1530         // pull tokens from Pair liquidity and move to dead address permanently
1531         if (amountToBurn > 0) {
1532             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1533         }
1534 
1535         //sync price since this is not in a swap transaction!
1536         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1537         pair.sync();
1538         emit ManualNukeLP();
1539         return true;
1540     }
1541 
1542     function withdraw() external onlyOwner {
1543         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1544         IERC20(address(this)).transfer(msg.sender, balance);
1545         payable(msg.sender).transfer(address(this).balance);
1546     }
1547 
1548     function withdrawToken(address _token, address _to) external onlyOwner {
1549         require(_token != address(0), "_token address cannot be 0");
1550         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1551         IERC20(_token).transfer(_to, _contractBalance);
1552     }
1553 }