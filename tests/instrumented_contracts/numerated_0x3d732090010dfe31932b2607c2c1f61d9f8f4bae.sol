1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-31
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.20;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(
88             newOwner != address(0),
89             "Ownable: new owner is the zero address"
90         );
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
106 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
107 
108 /* pragma solidity ^0.8.0; */
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(
132         address recipient,
133         uint256 amount
134     ) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(
144         address owner,
145         address spender
146     ) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * IMPORTANT: Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) external returns (bool);
178 
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(
192         address indexed owner,
193         address indexed spender,
194         uint256 value
195     );
196 }
197 
198 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
199 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
200 
201 /* pragma solidity ^0.8.0; */
202 
203 /* import "../IERC20.sol"; */
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226 
227 /**
228  * @dev Implementation of the {IERC20} interface.
229  *
230  * This implementation is agnostic to the way tokens are created. This means
231  * that a supply mechanism has to be added in a derived contract using {_mint}.
232  * For a generic mechanism see {ERC20PresetMinterPauser}.
233  *
234  * TIP: For a detailed writeup see our guide
235  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
236  * to implement supply mechanisms].
237  *
238  * We have followed general OpenZeppelin Contracts guidelines: functions revert
239  * instead returning `false` on failure. This behavior is nonetheless
240  * conventional and does not conflict with the expectations of ERC20
241  * applications.
242  *
243  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
244  * This allows applications to reconstruct the allowance for all accounts just
245  * by listening to said events. Other implementations of the EIP may not emit
246  * these events, as it isn't required by the specification.
247  *
248  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
249  * functions have been added to mitigate the well-known issues around setting
250  * allowances. See {IERC20-approve}.
251  */
252 contract ERC20 is Context, IERC20, IERC20Metadata {
253     mapping(address => uint256) private _balances;
254 
255     mapping(address => mapping(address => uint256)) private _allowances;
256 
257     uint256 private _totalSupply;
258 
259     string private _name;
260     string private _symbol;
261 
262     /**
263      * @dev Sets the values for {name} and {symbol}.
264      *
265      * The default value of {decimals} is 18. To select a different value for
266      * {decimals} you should overload it.
267      *
268      * All two of these values are immutable: they can only be set once during
269      * construction.
270      */
271     constructor(string memory name_, string memory symbol_) {
272         _name = name_;
273         _symbol = symbol_;
274     }
275 
276     /**
277      * @dev Returns the name of the token.
278      */
279     function name() public view virtual override returns (string memory) {
280         return _name;
281     }
282 
283     /**
284      * @dev Returns the symbol of the token, usually a shorter version of the
285      * name.
286      */
287     function symbol() public view virtual override returns (string memory) {
288         return _symbol;
289     }
290 
291     /**
292      * @dev Returns the number of decimals used to get its user representation.
293      * For example, if `decimals` equals `2`, a balance of `505` tokens should
294      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
295      *
296      * Tokens usually opt for a value of 18, imitating the relationship between
297      * Ether and Wei. This is the value {ERC20} uses, unless this function is
298      * overridden;
299      *
300      * NOTE: This information is only used for _display_ purposes: it in
301      * no way affects any of the arithmetic of the contract, including
302      * {IERC20-balanceOf} and {IERC20-transfer}.
303      */
304     function decimals() public view virtual override returns (uint8) {
305         return 18;
306     }
307 
308     /**
309      * @dev See {IERC20-totalSupply}.
310      */
311     function totalSupply() public view virtual override returns (uint256) {
312         return _totalSupply;
313     }
314 
315     /**
316      * @dev See {IERC20-balanceOf}.
317      */
318     function balanceOf(
319         address account
320     ) public view virtual override returns (uint256) {
321         return _balances[account];
322     }
323 
324     /**
325      * @dev See {IERC20-transfer}.
326      *
327      * Requirements:
328      *
329      * - `recipient` cannot be the zero address.
330      * - the caller must have a balance of at least `amount`.
331      */
332     function transfer(
333         address recipient,
334         uint256 amount
335     ) public virtual override returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(
344         address owner,
345         address spender
346     ) public view virtual override returns (uint256) {
347         return _allowances[owner][spender];
348     }
349 
350     /**
351      * @dev See {IERC20-approve}.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function approve(
358         address spender,
359         uint256 amount
360     ) public virtual override returns (bool) {
361         _approve(_msgSender(), spender, amount);
362         return true;
363     }
364 
365     /**
366      * @dev See {IERC20-transferFrom}.
367      *
368      * Emits an {Approval} event indicating the updated allowance. This is not
369      * required by the EIP. See the note at the beginning of {ERC20}.
370      *
371      * Requirements:
372      *
373      * - `sender` and `recipient` cannot be the zero address.
374      * - `sender` must have a balance of at least `amount`.
375      * - the caller must have allowance for ``sender``'s tokens of at least
376      * `amount`.
377      */
378     function transferFrom(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) public virtual override returns (bool) {
383         _transfer(sender, recipient, amount);
384 
385         uint256 currentAllowance = _allowances[sender][_msgSender()];
386         require(
387             currentAllowance >= amount,
388             "ERC20: transfer amount exceeds allowance"
389         );
390         unchecked {
391             _approve(sender, _msgSender(), currentAllowance - amount);
392         }
393 
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(
410         address spender,
411         uint256 addedValue
412     ) public virtual returns (bool) {
413         _approve(
414             _msgSender(),
415             spender,
416             _allowances[_msgSender()][spender] + addedValue
417         );
418         return true;
419     }
420 
421     /**
422      * @dev Atomically decreases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      * - `spender` must have allowance for the caller of at least
433      * `subtractedValue`.
434      */
435     function decreaseAllowance(
436         address spender,
437         uint256 subtractedValue
438     ) public virtual returns (bool) {
439         uint256 currentAllowance = _allowances[_msgSender()][spender];
440         require(
441             currentAllowance >= subtractedValue,
442             "ERC20: decreased allowance below zero"
443         );
444         unchecked {
445             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
446         }
447 
448         return true;
449     }
450 
451     /**
452      * @dev Moves `amount` of tokens from `sender` to `recipient`.
453      *
454      * This internal function is equivalent to {transfer}, and can be used to
455      * e.g. implement automatic token fees, slashing mechanisms, etc.
456      *
457      * Emits a {Transfer} event.
458      *
459      * Requirements:
460      *
461      * - `sender` cannot be the zero address.
462      * - `recipient` cannot be the zero address.
463      * - `sender` must have a balance of at least `amount`.
464      */
465     function _transfer(
466         address sender,
467         address recipient,
468         uint256 amount
469     ) internal virtual {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _beforeTokenTransfer(sender, recipient, amount);
474 
475         uint256 senderBalance = _balances[sender];
476         require(
477             senderBalance >= amount,
478             "ERC20: transfer amount exceeds balance"
479         );
480         unchecked {
481             _balances[sender] = senderBalance - amount;
482         }
483         _balances[recipient] += amount;
484 
485         emit Transfer(sender, recipient, amount);
486 
487         _afterTokenTransfer(sender, recipient, amount);
488     }
489 
490     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
491      * the total supply.
492      *
493      * Emits a {Transfer} event with `from` set to the zero address.
494      *
495      * Requirements:
496      *
497      * - `account` cannot be the zero address.
498      */
499     function _mint(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: mint to the zero address");
501 
502         _beforeTokenTransfer(address(0), account, amount);
503 
504         _totalSupply += amount;
505         _balances[account] += amount;
506         emit Transfer(address(0), account, amount);
507 
508         _afterTokenTransfer(address(0), account, amount);
509     }
510 
511     /**
512      * @dev Destroys `amount` tokens from `account`, reducing the
513      * total supply.
514      *
515      * Emits a {Transfer} event with `to` set to the zero address.
516      *
517      * Requirements:
518      *
519      * - `account` cannot be the zero address.
520      * - `account` must have at least `amount` tokens.
521      */
522     function _burn(address account, uint256 amount) internal virtual {
523         require(account != address(0), "ERC20: burn from the zero address");
524 
525         _beforeTokenTransfer(account, address(0), amount);
526 
527         uint256 accountBalance = _balances[account];
528         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
529         unchecked {
530             _balances[account] = accountBalance - amount;
531         }
532         _totalSupply -= amount;
533 
534         emit Transfer(account, address(0), amount);
535 
536         _afterTokenTransfer(account, address(0), amount);
537     }
538 
539     /**
540      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
541      *
542      * This internal function is equivalent to `approve`, and can be used to
543      * e.g. set automatic allowances for certain subsystems, etc.
544      *
545      * Emits an {Approval} event.
546      *
547      * Requirements:
548      *
549      * - `owner` cannot be the zero address.
550      * - `spender` cannot be the zero address.
551      */
552     function _approve(
553         address owner,
554         address spender,
555         uint256 amount
556     ) internal virtual {
557         require(owner != address(0), "ERC20: approve from the zero address");
558         require(spender != address(0), "ERC20: approve to the zero address");
559 
560         _allowances[owner][spender] = amount;
561         emit Approval(owner, spender, amount);
562     }
563 
564     /**
565      * @dev Hook that is called before any transfer of tokens. This includes
566      * minting and burning.
567      *
568      * Calling conditions:
569      *
570      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
571      * will be transferred to `to`.
572      * - when `from` is zero, `amount` tokens will be minted for `to`.
573      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
574      * - `from` and `to` are never both zero.
575      *
576      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
577      */
578     function _beforeTokenTransfer(
579         address from,
580         address to,
581         uint256 amount
582     ) internal virtual {}
583 
584     /**
585      * @dev Hook that is called after any transfer of tokens. This includes
586      * minting and burning.
587      *
588      * Calling conditions:
589      *
590      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
591      * has been transferred to `to`.
592      * - when `from` is zero, `amount` tokens have been minted for `to`.
593      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
594      * - `from` and `to` are never both zero.
595      *
596      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
597      */
598     function _afterTokenTransfer(
599         address from,
600         address to,
601         uint256 amount
602     ) internal virtual {}
603 }
604 
605 /**
606  * @dev Wrappers over Solidity's arithmetic operations.
607  *
608  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
609  * now has built in overflow checking.
610  */
611 library SafeMath {
612     /**
613      * @dev Returns the addition of two unsigned integers, with an overflow flag.
614      *
615      * _Available since v3.4._
616      */
617     function tryAdd(
618         uint256 a,
619         uint256 b
620     ) internal pure returns (bool, uint256) {
621         unchecked {
622             uint256 c = a + b;
623             if (c < a) return (false, 0);
624             return (true, c);
625         }
626     }
627 
628     /**
629      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
630      *
631      * _Available since v3.4._
632      */
633     function trySub(
634         uint256 a,
635         uint256 b
636     ) internal pure returns (bool, uint256) {
637         unchecked {
638             if (b > a) return (false, 0);
639             return (true, a - b);
640         }
641     }
642 
643     /**
644      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
645      *
646      * _Available since v3.4._
647      */
648     function tryMul(
649         uint256 a,
650         uint256 b
651     ) internal pure returns (bool, uint256) {
652         unchecked {
653             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
654             // benefit is lost if 'b' is also tested.
655             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
656             if (a == 0) return (true, 0);
657             uint256 c = a * b;
658             if (c / a != b) return (false, 0);
659             return (true, c);
660         }
661     }
662 
663     /**
664      * @dev Returns the division of two unsigned integers, with a division by zero flag.
665      *
666      * _Available since v3.4._
667      */
668     function tryDiv(
669         uint256 a,
670         uint256 b
671     ) internal pure returns (bool, uint256) {
672         unchecked {
673             if (b == 0) return (false, 0);
674             return (true, a / b);
675         }
676     }
677 
678     /**
679      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
680      *
681      * _Available since v3.4._
682      */
683     function tryMod(
684         uint256 a,
685         uint256 b
686     ) internal pure returns (bool, uint256) {
687         unchecked {
688             if (b == 0) return (false, 0);
689             return (true, a % b);
690         }
691     }
692 
693     /**
694      * @dev Returns the addition of two unsigned integers, reverting on
695      * overflow.
696      *
697      * Counterpart to Solidity's `+` operator.
698      *
699      * Requirements:
700      *
701      * - Addition cannot overflow.
702      */
703     function add(uint256 a, uint256 b) internal pure returns (uint256) {
704         return a + b;
705     }
706 
707     /**
708      * @dev Returns the subtraction of two unsigned integers, reverting on
709      * overflow (when the result is negative).
710      *
711      * Counterpart to Solidity's `-` operator.
712      *
713      * Requirements:
714      *
715      * - Subtraction cannot overflow.
716      */
717     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a - b;
719     }
720 
721     /**
722      * @dev Returns the multiplication of two unsigned integers, reverting on
723      * overflow.
724      *
725      * Counterpart to Solidity's `*` operator.
726      *
727      * Requirements:
728      *
729      * - Multiplication cannot overflow.
730      */
731     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a * b;
733     }
734 
735     /**
736      * @dev Returns the integer division of two unsigned integers, reverting on
737      * division by zero. The result is rounded towards zero.
738      *
739      * Counterpart to Solidity's `/` operator.
740      *
741      * Requirements:
742      *
743      * - The divisor cannot be zero.
744      */
745     function div(uint256 a, uint256 b) internal pure returns (uint256) {
746         return a / b;
747     }
748 
749     /**
750      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
751      * reverting when dividing by zero.
752      *
753      * Counterpart to Solidity's `%` operator. This function uses a `revert`
754      * opcode (which leaves remaining gas untouched) while Solidity uses an
755      * invalid opcode to revert (consuming all remaining gas).
756      *
757      * Requirements:
758      *
759      * - The divisor cannot be zero.
760      */
761     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
762         return a % b;
763     }
764 
765     /**
766      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
767      * overflow (when the result is negative).
768      *
769      * CAUTION: This function is deprecated because it requires allocating memory for the error
770      * message unnecessarily. For custom revert reasons use {trySub}.
771      *
772      * Counterpart to Solidity's `-` operator.
773      *
774      * Requirements:
775      *
776      * - Subtraction cannot overflow.
777      */
778     function sub(
779         uint256 a,
780         uint256 b,
781         string memory errorMessage
782     ) internal pure returns (uint256) {
783         unchecked {
784             require(b <= a, errorMessage);
785             return a - b;
786         }
787     }
788 
789     /**
790      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
791      * division by zero. The result is rounded towards zero.
792      *
793      * Counterpart to Solidity's `/` operator. Note: this function uses a
794      * `revert` opcode (which leaves remaining gas untouched) while Solidity
795      * uses an invalid opcode to revert (consuming all remaining gas).
796      *
797      * Requirements:
798      *
799      * - The divisor cannot be zero.
800      */
801     function div(
802         uint256 a,
803         uint256 b,
804         string memory errorMessage
805     ) internal pure returns (uint256) {
806         unchecked {
807             require(b > 0, errorMessage);
808             return a / b;
809         }
810     }
811 
812     /**
813      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
814      * reverting with custom message when dividing by zero.
815      *
816      * CAUTION: This function is deprecated because it requires allocating memory for the error
817      * message unnecessarily. For custom revert reasons use {tryMod}.
818      *
819      * Counterpart to Solidity's `%` operator. This function uses a `revert`
820      * opcode (which leaves remaining gas untouched) while Solidity uses an
821      * invalid opcode to revert (consuming all remaining gas).
822      *
823      * Requirements:
824      *
825      * - The divisor cannot be zero.
826      */
827     function mod(
828         uint256 a,
829         uint256 b,
830         string memory errorMessage
831     ) internal pure returns (uint256) {
832         unchecked {
833             require(b > 0, errorMessage);
834             return a % b;
835         }
836     }
837 }
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
851     function getPair(
852         address tokenA,
853         address tokenB
854     ) external view returns (address pair);
855 
856     function allPairs(uint256) external view returns (address pair);
857 
858     function allPairsLength() external view returns (uint256);
859 
860     function createPair(
861         address tokenA,
862         address tokenB
863     ) external returns (address pair);
864 
865     function setFeeTo(address) external;
866 
867     function setFeeToSetter(address) external;
868 }
869 
870 ////// src/IUniswapV2Pair.sol
871 /* pragma solidity 0.8.10; */
872 /* pragma experimental ABIEncoderV2; */
873 
874 interface IUniswapV2Pair {
875     event Approval(
876         address indexed owner,
877         address indexed spender,
878         uint256 value
879     );
880     event Transfer(address indexed from, address indexed to, uint256 value);
881 
882     function name() external pure returns (string memory);
883 
884     function symbol() external pure returns (string memory);
885 
886     function decimals() external pure returns (uint8);
887 
888     function totalSupply() external view returns (uint256);
889 
890     function balanceOf(address owner) external view returns (uint256);
891 
892     function allowance(
893         address owner,
894         address spender
895     ) external view returns (uint256);
896 
897     function approve(address spender, uint256 value) external returns (bool);
898 
899     function transfer(address to, uint256 value) external returns (bool);
900 
901     function transferFrom(
902         address from,
903         address to,
904         uint256 value
905     ) external returns (bool);
906 
907     function DOMAIN_SEPARATOR() external view returns (bytes32);
908 
909     function PERMIT_TYPEHASH() external pure returns (bytes32);
910 
911     function nonces(address owner) external view returns (uint256);
912 
913     function permit(
914         address owner,
915         address spender,
916         uint256 value,
917         uint256 deadline,
918         uint8 v,
919         bytes32 r,
920         bytes32 s
921     ) external;
922 
923     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
924     event Burn(
925         address indexed sender,
926         uint256 amount0,
927         uint256 amount1,
928         address indexed to
929     );
930     event Swap(
931         address indexed sender,
932         uint256 amount0In,
933         uint256 amount1In,
934         uint256 amount0Out,
935         uint256 amount1Out,
936         address indexed to
937     );
938     event Sync(uint112 reserve0, uint112 reserve1);
939 
940     function MINIMUM_LIQUIDITY() external pure returns (uint256);
941 
942     function factory() external view returns (address);
943 
944     function token0() external view returns (address);
945 
946     function token1() external view returns (address);
947 
948     function getReserves()
949         external
950         view
951         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
952 
953     function price0CumulativeLast() external view returns (uint256);
954 
955     function price1CumulativeLast() external view returns (uint256);
956 
957     function kLast() external view returns (uint256);
958 
959     function mint(address to) external returns (uint256 liquidity);
960 
961     function burn(
962         address to
963     ) external returns (uint256 amount0, uint256 amount1);
964 
965     function swap(
966         uint256 amount0Out,
967         uint256 amount1Out,
968         address to,
969         bytes calldata data
970     ) external;
971 
972     function skim(address to) external;
973 
974     function sync() external;
975 
976     function initialize(address, address) external;
977 }
978 
979 interface IUniswapV2Router02 {
980     function factory() external pure returns (address);
981 
982     function WETH() external pure returns (address);
983 
984     function addLiquidity(
985         address tokenA,
986         address tokenB,
987         uint256 amountADesired,
988         uint256 amountBDesired,
989         uint256 amountAMin,
990         uint256 amountBMin,
991         address to,
992         uint256 deadline
993     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
994 
995     function addLiquidityETH(
996         address token,
997         uint256 amountTokenDesired,
998         uint256 amountTokenMin,
999         uint256 amountETHMin,
1000         address to,
1001         uint256 deadline
1002     )
1003         external
1004         payable
1005         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
1006 
1007     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1008         uint256 amountIn,
1009         uint256 amountOutMin,
1010         address[] calldata path,
1011         address to,
1012         uint256 deadline
1013     ) external;
1014 
1015     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1016         uint256 amountOutMin,
1017         address[] calldata path,
1018         address to,
1019         uint256 deadline
1020     ) external payable;
1021 
1022     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1023         uint256 amountIn,
1024         uint256 amountOutMin,
1025         address[] calldata path,
1026         address to,
1027         uint256 deadline
1028     ) external;
1029 }
1030 
1031 contract JackNichPikachuBinLaden69420 is ERC20, Ownable {
1032     IUniswapV2Router02 public immutable uniswapV2Router;
1033     address public immutable uniswapV2Pair;
1034     bool private swapping;
1035 
1036     address public immutable revShareWallet;
1037 
1038     uint256 public maxTransactionAmount;
1039     uint256 public immutable swapTokensAtAmount;
1040     uint256 public maxWallet;
1041 
1042     bool public tradingActive = false;
1043     bool public swapEnabled = false;
1044 
1045     // Anti-bot and anti-whale mappings and variables
1046     mapping(address => bool) blacklisted;
1047 
1048     uint256 public buyTotalFees;
1049     uint256 public buyRevShareFee;
1050     uint256 public buyLiquidityFee;
1051 
1052     uint256 public sellTotalFees;
1053     uint256 public sellRevShareFee;
1054     uint256 public sellLiquidityFee;
1055 
1056     uint256 public tokensForRevShare;
1057     uint256 public tokensForLiquidity;
1058 
1059     // Exclude from fees and max transaction amount
1060     mapping(address => bool) private _isExcludedFromFees;
1061     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1062 
1063     // Store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1064     // could be subject to a maximum transfer amount
1065     mapping(address => bool) public automatedMarketMakerPairs;
1066 
1067     event UpdateUniswapV2Router(
1068         address indexed newAddress,
1069         address indexed oldAddress
1070     );
1071 
1072     event ExcludeFromFees(address indexed account, bool isExcluded);
1073 
1074     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1075 
1076     event SwapAndLiquify(
1077         uint256 tokensSwapped,
1078         uint256 ethReceived,
1079         uint256 tokensIntoLiquidity
1080     );
1081 
1082     constructor(
1083         address _revShareWallet
1084     ) ERC20("JackNichPikachuBinLaden69420", "$BITCONNECT") {
1085         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1086             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //Uniswap V2 Router
1087         );
1088 
1089         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1090         uniswapV2Router = _uniswapV2Router;
1091 
1092         // Creates the Uniswap Pair
1093         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1094             .createPair(address(this), _uniswapV2Router.WETH());
1095         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1096         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1097 
1098         uint256 _buyRevShareFee = 8; // Lowered to 4% after launch
1099         uint256 _buyLiquidityFee = 2; // Lowered to 1% after launch
1100 
1101         uint256 _sellRevShareFee = 8; // Lowered to 4% after launch
1102         uint256 _sellLiquidityFee = 2; // Lowered to 1% after launch
1103 
1104         uint256 totalSupply = 1_000_000 * 1e18; // 1 Million
1105 
1106         maxTransactionAmount = 2_500 * 1e18; // 0.25%
1107         maxWallet = 2_500 * 1e18; // 0.25%
1108         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05%
1109 
1110         buyRevShareFee = _buyRevShareFee;
1111         buyLiquidityFee = _buyLiquidityFee;
1112         buyTotalFees = buyRevShareFee + buyLiquidityFee;
1113 
1114         sellRevShareFee = _sellRevShareFee;
1115         sellLiquidityFee = _sellLiquidityFee;
1116         sellTotalFees = sellRevShareFee + sellLiquidityFee;
1117 
1118         revShareWallet = _revShareWallet; // Set as revShare wallet - Helper Contract
1119 
1120         // Exclude from paying fees or having max transaction amount if; is owner, is deployer, is dead address.
1121         excludeFromFees(owner(), true);
1122         excludeFromFees(address(this), true);
1123         excludeFromFees(address(0xdead), true);
1124 
1125         excludeFromMaxTransaction(owner(), true);
1126         excludeFromMaxTransaction(address(this), true);
1127         excludeFromMaxTransaction(address(0xdead), true);
1128 
1129         /*
1130             _mint is an internal function in ERC20.sol that is only called here,
1131             and CANNOT be called ever again
1132         */
1133         _mint(msg.sender, (totalSupply * 80) / 100);
1134         _mint(
1135             0x561F33fBCB2999112f7406414e6d292097DBd8E7,
1136             (totalSupply * 20) / 100
1137         ); //marketing wallet
1138     }
1139 
1140     receive() external payable {}
1141 
1142     // Will enable trading, once this is toggeled, it will not be able to be turned off.
1143     function enableTrading() external onlyOwner {
1144         tradingActive = true;
1145         swapEnabled = true;
1146     }
1147 
1148     // Trigger this post launch once price is more stable. Made to avoid whales and snipers hogging supply.
1149     function updateLimitsAndFees() external onlyOwner {
1150         maxTransactionAmount = 10_000 * (10 ** 18); // 1%
1151         maxWallet = 25_000 * (10 ** 18); // 2.5%
1152 
1153         buyRevShareFee = 4; // 4%
1154         buyLiquidityFee = 1; // 1%
1155         buyTotalFees = 5;
1156 
1157         sellRevShareFee = 4; // 4%
1158         sellLiquidityFee = 1; // 1%
1159         sellTotalFees = 5;
1160     }
1161 
1162     function excludeFromMaxTransaction(
1163         address updAds,
1164         bool isEx
1165     ) public onlyOwner {
1166         _isExcludedMaxTransactionAmount[updAds] = isEx;
1167     }
1168 
1169     function excludeFromFees(address account, bool excluded) public onlyOwner {
1170         _isExcludedFromFees[account] = excluded;
1171         emit ExcludeFromFees(account, excluded);
1172     }
1173 
1174     function setAutomatedMarketMakerPair(
1175         address pair,
1176         bool value
1177     ) public onlyOwner {
1178         require(
1179             pair != uniswapV2Pair,
1180             "The pair cannot be removed from automatedMarketMakerPairs"
1181         );
1182 
1183         _setAutomatedMarketMakerPair(pair, value);
1184     }
1185 
1186     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1187         automatedMarketMakerPairs[pair] = value;
1188 
1189         emit SetAutomatedMarketMakerPair(pair, value);
1190     }
1191 
1192     function isExcludedFromFees(address account) public view returns (bool) {
1193         return _isExcludedFromFees[account];
1194     }
1195 
1196     function isBlacklisted(address account) public view returns (bool) {
1197         return blacklisted[account];
1198     }
1199 
1200     function _transfer(
1201         address from,
1202         address to,
1203         uint256 amount
1204     ) internal override {
1205         require(from != address(0), "ERC20: transfer from the zero address");
1206         require(to != address(0), "ERC20: transfer to the zero address");
1207         require(!blacklisted[from], "Sender blacklisted");
1208         require(!blacklisted[to], "Receiver blacklisted");
1209 
1210         if (amount == 0) {
1211             super._transfer(from, to, 0);
1212             return;
1213         }
1214 
1215         if (
1216             from != owner() &&
1217             to != owner() &&
1218             to != address(0) &&
1219             to != address(0xdead) &&
1220             !swapping
1221         ) {
1222             if (!tradingActive) {
1223                 require(
1224                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1225                     "Trading is not active."
1226                 );
1227             }
1228 
1229             // Buying
1230             if (
1231                 automatedMarketMakerPairs[from] &&
1232                 !_isExcludedMaxTransactionAmount[to]
1233             ) {
1234                 require(
1235                     amount <= maxTransactionAmount,
1236                     "Buy transfer amount exceeds the maxTransactionAmount."
1237                 );
1238                 require(
1239                     amount + balanceOf(to) <= maxWallet,
1240                     "Max wallet exceeded"
1241                 );
1242             }
1243             // Selling
1244             else if (
1245                 automatedMarketMakerPairs[to] &&
1246                 !_isExcludedMaxTransactionAmount[from]
1247             ) {
1248                 require(
1249                     amount <= maxTransactionAmount,
1250                     "Sell transfer amount exceeds the maxTransactionAmount."
1251                 );
1252             } else if (!_isExcludedMaxTransactionAmount[to]) {
1253                 require(
1254                     amount + balanceOf(to) <= maxWallet,
1255                     "Max wallet exceeded"
1256                 );
1257             }
1258         }
1259 
1260         uint256 contractTokenBalance = balanceOf(address(this));
1261 
1262         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1263 
1264         if (
1265             canSwap &&
1266             swapEnabled &&
1267             !swapping &&
1268             !automatedMarketMakerPairs[from] &&
1269             !_isExcludedFromFees[from] &&
1270             !_isExcludedFromFees[to]
1271         ) {
1272             swapping = true;
1273 
1274             swapBack();
1275 
1276             swapping = false;
1277         }
1278 
1279         bool takeFee = !swapping;
1280 
1281         // If any account belongs to _isExcludedFromFee account then remove the fee
1282         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1283             takeFee = false;
1284         }
1285 
1286         uint256 fees = 0;
1287         // Only take fees on buys/sells, do not take on wallet transfers
1288         if (takeFee) {
1289             // Sell
1290             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1291                 fees = (amount * sellTotalFees) / 100;
1292                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1293                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1294             }
1295             // Buy
1296             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1297                 fees = (amount * buyTotalFees) / 100;
1298                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1299                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1300             }
1301 
1302             if (fees > 0) {
1303                 super._transfer(from, address(this), fees);
1304             }
1305 
1306             amount -= fees;
1307         }
1308 
1309         super._transfer(from, to, amount);
1310     }
1311 
1312     function swapTokensForEth(uint256 tokenAmount) private {
1313         // Generate the uniswap pair path of token -> weth
1314         address[] memory path = new address[](2);
1315         path[0] = address(this);
1316         path[1] = uniswapV2Router.WETH();
1317 
1318         _approve(address(this), address(uniswapV2Router), tokenAmount);
1319 
1320         // Make the swap
1321         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1322             tokenAmount,
1323             0, // Accept any amount of ETH; ignore slippage
1324             path,
1325             address(this),
1326             block.timestamp
1327         );
1328     }
1329 
1330     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1331         // approve token transfer to cover all possible scenarios
1332         _approve(address(this), address(uniswapV2Router), tokenAmount);
1333 
1334         // add the liquidity
1335         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1336             address(this),
1337             tokenAmount,
1338             0, // Slippage is unavoidable
1339             0, // Slippage is unavoidable
1340             owner(),
1341             block.timestamp
1342         );
1343     }
1344 
1345     function swapBack() private {
1346         uint256 contractBalance = balanceOf(address(this));
1347         uint256 totalTokensToSwap = tokensForLiquidity + tokensForRevShare;
1348         bool success;
1349 
1350         if (contractBalance == 0 || totalTokensToSwap == 0) {
1351             return;
1352         }
1353 
1354         if (contractBalance > swapTokensAtAmount * 20) {
1355             contractBalance = swapTokensAtAmount * 20;
1356         }
1357 
1358         // Halve the amount of liquidity tokens
1359         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1360             totalTokensToSwap /
1361             2;
1362         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1363 
1364         uint256 initialETHBalance = address(this).balance;
1365 
1366         swapTokensForEth(amountToSwapForETH);
1367 
1368         uint256 ethBalance = address(this).balance - initialETHBalance;
1369 
1370         uint256 ethForRevShare = (ethBalance * tokensForRevShare) /
1371             (totalTokensToSwap - (tokensForLiquidity / 2));
1372 
1373         uint256 ethForLiquidity = ethBalance - ethForRevShare;
1374 
1375         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1376             addLiquidity(liquidityTokens, ethForLiquidity);
1377             emit SwapAndLiquify(
1378                 amountToSwapForETH,
1379                 ethForLiquidity,
1380                 tokensForLiquidity
1381             );
1382         }
1383 
1384         tokensForLiquidity = 0;
1385         tokensForRevShare = 0;
1386 
1387         (success, ) = address(revShareWallet).call{
1388             value: address(this).balance
1389         }("");
1390     }
1391 
1392     // The helper contract will also be used to be able to call the 5 functions below.
1393     // Any functions that have to do with ETH or Tokens will be sent directly to the helper contract.
1394     // This means that the split of 80% to the team, and 20% to the holders is intact.
1395     modifier onlyHelper() {
1396         require(
1397             revShareWallet == _msgSender(),
1398             "Token: caller is not the Helper"
1399         );
1400         _;
1401     }
1402 
1403     // @Helper - Callable by Helper contract in-case tokens get's stuck in the token contract.
1404     function withdrawStuckToken(
1405         address _token,
1406         address _to
1407     ) external onlyHelper {
1408         require(_token != address(0), "_token address cannot be 0");
1409         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1410         IERC20(_token).transfer(_to, _contractBalance);
1411     }
1412 
1413     // @Helper - Callable by Helper contract in-case ETH get's stuck in the token contract.
1414     function withdrawStuckEth(address toAddr) external onlyHelper {
1415         (bool success, ) = toAddr.call{value: address(this).balance}("");
1416         require(success);
1417     }
1418 
1419     // @Helper - Blacklist v3 pools; can unblacklist() down the road to suit project and community
1420     function blacklistLiquidityPool(address lpAddress) public onlyHelper {
1421         require(
1422             lpAddress != address(uniswapV2Pair) &&
1423                 lpAddress !=
1424                 address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D),
1425             "Cannot blacklist token's v2 router or v2 pool."
1426         );
1427         blacklisted[lpAddress] = true;
1428     }
1429 
1430     // @Helper - Unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1431     function unblacklist(address _addr) public onlyHelper {
1432         blacklisted[_addr] = false;
1433     }
1434 }