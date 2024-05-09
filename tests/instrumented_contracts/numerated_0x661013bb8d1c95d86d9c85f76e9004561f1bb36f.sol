1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _transferOwnership(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(
83             newOwner != address(0),
84             "Ownable: new owner is the zero address"
85         );
86         _transferOwnership(newOwner);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Internal function without access restriction.
92      */
93     function _transferOwnership(address newOwner) internal virtual {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount)
122         external
123         returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender)
133         external
134         view
135         returns (uint256);
136 
137     /**
138      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * IMPORTANT: Beware that changing an allowance with this method brings the risk
143      * that someone may use both the old and the new allowance by unfortunate
144      * transaction ordering. One possible solution to mitigate this race
145      * condition is to first reduce the spender's allowance to 0 and set the
146      * desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Moves `amount` tokens from `sender` to `recipient` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) external returns (bool);
167 
168     /**
169      * @dev Emitted when `value` tokens are moved from one account (`from`) to
170      * another (`to`).
171      *
172      * Note that `value` may be zero.
173      */
174     event Transfer(address indexed from, address indexed to, uint256 value);
175 
176     /**
177      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
178      * a call to {approve}. `value` is the new allowance.
179      */
180     event Approval(
181         address indexed owner,
182         address indexed spender,
183         uint256 value
184     );
185 }
186 
187 /**
188  * @dev Interface for the optional metadata functions from the ERC20 standard.
189  *
190  * _Available since v4.1._
191  */
192 interface IERC20Metadata is IERC20 {
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the symbol of the token.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the decimals places of the token.
205      */
206     function decimals() external view returns (uint8);
207 }
208 
209 /**
210  * @dev Implementation of the {IERC20} interface.
211  *
212  * This implementation is agnostic to the way tokens are created. This means
213  * that a supply mechanism has to be added in a derived contract using {_mint}.
214  * For a generic mechanism see {ERC20PresetMinterPauser}.
215  *
216  * TIP: For a detailed writeup see our guide
217  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
218  * to implement supply mechanisms].
219  *
220  * We have followed general OpenZeppelin Contracts guidelines: functions revert
221  * instead returning `false` on failure. This behavior is nonetheless
222  * conventional and does not conflict with the expectations of ERC20
223  * applications.
224  *
225  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
226  * This allows applications to reconstruct the allowance for all accounts just
227  * by listening to said events. Other implementations of the EIP may not emit
228  * these events, as it isn't required by the specification.
229  *
230  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
231  * functions have been added to mitigate the well-known issues around setting
232  * allowances. See {IERC20-approve}.
233  */
234 contract ERC20 is Context, IERC20, IERC20Metadata {
235     mapping(address => uint256) private _balances;
236 
237     mapping(address => mapping(address => uint256)) private _allowances;
238 
239     uint256 private _totalSupply;
240 
241     string private _name;
242     string private _symbol;
243 
244     /**
245      * @dev Sets the values for {name} and {symbol}.
246      *
247      * The default value of {decimals} is 18. To select a different value for
248      * {decimals} you should overload it.
249      *
250      * All two of these values are immutable: they can only be set once during
251      * construction.
252      */
253     constructor(string memory name_, string memory symbol_) {
254         _name = name_;
255         _symbol = symbol_;
256     }
257 
258     /**
259      * @dev Returns the name of the token.
260      */
261     function name() public view virtual override returns (string memory) {
262         return _name;
263     }
264 
265     /**
266      * @dev Returns the symbol of the token, usually a shorter version of the
267      * name.
268      */
269     function symbol() public view virtual override returns (string memory) {
270         return _symbol;
271     }
272 
273     /**
274      * @dev Returns the number of decimals used to get its user representation.
275      * For example, if `decimals` equals `2`, a balance of `505` tokens should
276      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
277      *
278      * Tokens usually opt for a value of 18, imitating the relationship between
279      * Ether and Wei. This is the value {ERC20} uses, unless this function is
280      * overridden;
281      *
282      * NOTE: This information is only used for _display_ purposes: it in
283      * no way affects any of the arithmetic of the contract, including
284      * {IERC20-balanceOf} and {IERC20-transfer}.
285      */
286     function decimals() public view virtual override returns (uint8) {
287         return 18;
288     }
289 
290     /**
291      * @dev See {IERC20-totalSupply}.
292      */
293     function totalSupply() public view virtual override returns (uint256) {
294         return _totalSupply;
295     }
296 
297     /**
298      * @dev See {IERC20-balanceOf}.
299      */
300     function balanceOf(address account)
301         public
302         view
303         virtual
304         override
305         returns (uint256)
306     {
307         return _balances[account];
308     }
309 
310     /**
311      * @dev See {IERC20-transfer}.
312      *
313      * Requirements:
314      *
315      * - `recipient` cannot be the zero address.
316      * - the caller must have a balance of at least `amount`.
317      */
318     function transfer(address recipient, uint256 amount)
319         public
320         virtual
321         override
322         returns (bool)
323     {
324         _transfer(_msgSender(), recipient, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-allowance}.
330      */
331     function allowance(address owner, address spender)
332         public
333         view
334         virtual
335         override
336         returns (uint256)
337     {
338         return _allowances[owner][spender];
339     }
340 
341     /**
342      * @dev See {IERC20-approve}.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function approve(address spender, uint256 amount)
349         public
350         virtual
351         override
352         returns (bool)
353     {
354         _approve(_msgSender(), spender, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-transferFrom}.
360      *
361      * Emits an {Approval} event indicating the updated allowance. This is not
362      * required by the EIP. See the note at the beginning of {ERC20}.
363      *
364      * Requirements:
365      *
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      * - the caller must have allowance for ``sender``'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(
372         address sender,
373         address recipient,
374         uint256 amount
375     ) public virtual override returns (bool) {
376         _transfer(sender, recipient, amount);
377 
378         uint256 currentAllowance = _allowances[sender][_msgSender()];
379         require(
380             currentAllowance >= amount,
381             "ERC20: transfer amount exceeds allowance"
382         );
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
402     function increaseAllowance(address spender, uint256 addedValue)
403         public
404         virtual
405         returns (bool)
406     {
407         _approve(
408             _msgSender(),
409             spender,
410             _allowances[_msgSender()][spender] + addedValue
411         );
412         return true;
413     }
414 
415     /**
416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      * - `spender` must have allowance for the caller of at least
427      * `subtractedValue`.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue)
430         public
431         virtual
432         returns (bool)
433     {
434         uint256 currentAllowance = _allowances[_msgSender()][spender];
435         require(
436             currentAllowance >= subtractedValue,
437             "ERC20: decreased allowance below zero"
438         );
439         unchecked {
440             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
441         }
442 
443         return true;
444     }
445 
446     /**
447      * @dev Moves `amount` of tokens from `sender` to `recipient`.
448      *
449      * This internal function is equivalent to {transfer}, and can be used to
450      * e.g. implement automatic token fees, slashing mechanisms, etc.
451      *
452      * Emits a {Transfer} event.
453      *
454      * Requirements:
455      *
456      * - `sender` cannot be the zero address.
457      * - `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      */
460     function _transfer(
461         address sender,
462         address recipient,
463         uint256 amount
464     ) internal virtual {
465         require(sender != address(0), "ERC20: transfer from the zero address");
466         require(recipient != address(0), "ERC20: transfer to the zero address");
467 
468         _beforeTokenTransfer(sender, recipient, amount);
469 
470         uint256 senderBalance = _balances[sender];
471         require(
472             senderBalance >= amount,
473             "ERC20: transfer amount exceeds balance"
474         );
475         unchecked {
476             _balances[sender] = senderBalance - amount;
477         }
478         _balances[recipient] += amount;
479 
480         emit Transfer(sender, recipient, amount);
481 
482         _afterTokenTransfer(sender, recipient, amount);
483     }
484 
485     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
486      * the total supply.
487      *
488      * Emits a {Transfer} event with `from` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `account` cannot be the zero address.
493      */
494     function _mint(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: mint to the zero address");
496 
497         _beforeTokenTransfer(address(0), account, amount);
498 
499         _totalSupply += amount;
500         _balances[account] += amount;
501         emit Transfer(address(0), account, amount);
502 
503         _afterTokenTransfer(address(0), account, amount);
504     }
505 
506     /**
507      * @dev Destroys `amount` tokens from `account`, reducing the
508      * total supply.
509      *
510      * Emits a {Transfer} event with `to` set to the zero address.
511      *
512      * Requirements:
513      *
514      * - `account` cannot be the zero address.
515      * - `account` must have at least `amount` tokens.
516      */
517     function _burn(address account, uint256 amount) internal virtual {
518         require(account != address(0), "ERC20: burn from the zero address");
519 
520         _beforeTokenTransfer(account, address(0), amount);
521 
522         uint256 accountBalance = _balances[account];
523         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
524         unchecked {
525             _balances[account] = accountBalance - amount;
526         }
527         _totalSupply -= amount;
528 
529         emit Transfer(account, address(0), amount);
530 
531         _afterTokenTransfer(account, address(0), amount);
532     }
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
536      *
537      * This internal function is equivalent to `approve`, and can be used to
538      * e.g. set automatic allowances for certain subsystems, etc.
539      *
540      * Emits an {Approval} event.
541      *
542      * Requirements:
543      *
544      * - `owner` cannot be the zero address.
545      * - `spender` cannot be the zero address.
546      */
547     function _approve(
548         address owner,
549         address spender,
550         uint256 amount
551     ) internal virtual {
552         require(owner != address(0), "ERC20: approve from the zero address");
553         require(spender != address(0), "ERC20: approve to the zero address");
554 
555         _allowances[owner][spender] = amount;
556         emit Approval(owner, spender, amount);
557     }
558 
559     /**
560      * @dev Hook that is called before any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * will be transferred to `to`.
567      * - when `from` is zero, `amount` tokens will be minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _beforeTokenTransfer(
574         address from,
575         address to,
576         uint256 amount
577     ) internal virtual {}
578 
579     /**
580      * @dev Hook that is called after any transfer of tokens. This includes
581      * minting and burning.
582      *
583      * Calling conditions:
584      *
585      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
586      * has been transferred to `to`.
587      * - when `from` is zero, `amount` tokens have been minted for `to`.
588      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
589      * - `from` and `to` are never both zero.
590      *
591      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
592      */
593     function _afterTokenTransfer(
594         address from,
595         address to,
596         uint256 amount
597     ) internal virtual {}
598 }
599 
600 /**
601  * @dev Wrappers over Solidity's arithmetic operations.
602  *
603  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
604  * now has built in overflow checking.
605  */
606 library SafeMath {
607     /**
608      * @dev Returns the addition of two unsigned integers, with an overflow flag.
609      *
610      * _Available since v3.4._
611      */
612     function tryAdd(uint256 a, uint256 b)
613         internal
614         pure
615         returns (bool, uint256)
616     {
617         unchecked {
618             uint256 c = a + b;
619             if (c < a) return (false, 0);
620             return (true, c);
621         }
622     }
623 
624     /**
625      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
626      *
627      * _Available since v3.4._
628      */
629     function trySub(uint256 a, uint256 b)
630         internal
631         pure
632         returns (bool, uint256)
633     {
634         unchecked {
635             if (b > a) return (false, 0);
636             return (true, a - b);
637         }
638     }
639 
640     /**
641      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
642      *
643      * _Available since v3.4._
644      */
645     function tryMul(uint256 a, uint256 b)
646         internal
647         pure
648         returns (bool, uint256)
649     {
650         unchecked {
651             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
652             // benefit is lost if 'b' is also tested.
653             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
654             if (a == 0) return (true, 0);
655             uint256 c = a * b;
656             if (c / a != b) return (false, 0);
657             return (true, c);
658         }
659     }
660 
661     /**
662      * @dev Returns the division of two unsigned integers, with a division by zero flag.
663      *
664      * _Available since v3.4._
665      */
666     function tryDiv(uint256 a, uint256 b)
667         internal
668         pure
669         returns (bool, uint256)
670     {
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
682     function tryMod(uint256 a, uint256 b)
683         internal
684         pure
685         returns (bool, uint256)
686     {
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
869 interface IUniswapV2Pair {
870     event Approval(
871         address indexed owner,
872         address indexed spender,
873         uint256 value
874     );
875     event Transfer(address indexed from, address indexed to, uint256 value);
876 
877     function name() external pure returns (string memory);
878 
879     function symbol() external pure returns (string memory);
880 
881     function decimals() external pure returns (uint8);
882 
883     function totalSupply() external view returns (uint256);
884 
885     function balanceOf(address owner) external view returns (uint256);
886 
887     function allowance(address owner, address spender)
888         external
889         view
890         returns (uint256);
891 
892     function approve(address spender, uint256 value) external returns (bool);
893 
894     function transfer(address to, uint256 value) external returns (bool);
895 
896     function transferFrom(
897         address from,
898         address to,
899         uint256 value
900     ) external returns (bool);
901 
902     function DOMAIN_SEPARATOR() external view returns (bytes32);
903 
904     function PERMIT_TYPEHASH() external pure returns (bytes32);
905 
906     function nonces(address owner) external view returns (uint256);
907 
908     function permit(
909         address owner,
910         address spender,
911         uint256 value,
912         uint256 deadline,
913         uint8 v,
914         bytes32 r,
915         bytes32 s
916     ) external;
917 
918     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
919     event Burn(
920         address indexed sender,
921         uint256 amount0,
922         uint256 amount1,
923         address indexed to
924     );
925     event Swap(
926         address indexed sender,
927         uint256 amount0In,
928         uint256 amount1In,
929         uint256 amount0Out,
930         uint256 amount1Out,
931         address indexed to
932     );
933     event Sync(uint112 reserve0, uint112 reserve1);
934 
935     function MINIMUM_LIQUIDITY() external pure returns (uint256);
936 
937     function factory() external view returns (address);
938 
939     function token0() external view returns (address);
940 
941     function token1() external view returns (address);
942 
943     function getReserves()
944         external
945         view
946         returns (
947             uint112 reserve0,
948             uint112 reserve1,
949             uint32 blockTimestampLast
950         );
951 
952     function price0CumulativeLast() external view returns (uint256);
953 
954     function price1CumulativeLast() external view returns (uint256);
955 
956     function kLast() external view returns (uint256);
957 
958     function mint(address to) external returns (uint256 liquidity);
959 
960     function burn(address to)
961         external
962         returns (uint256 amount0, uint256 amount1);
963 
964     function swap(
965         uint256 amount0Out,
966         uint256 amount1Out,
967         address to,
968         bytes calldata data
969     ) external;
970 
971     function skim(address to) external;
972 
973     function sync() external;
974 
975     function initialize(address, address) external;
976 }
977 
978 interface IUniswapV2Router02 {
979     function factory() external pure returns (address);
980 
981     function WETH() external pure returns (address);
982 
983     function addLiquidity(
984         address tokenA,
985         address tokenB,
986         uint256 amountADesired,
987         uint256 amountBDesired,
988         uint256 amountAMin,
989         uint256 amountBMin,
990         address to,
991         uint256 deadline
992     )
993         external
994         returns (
995             uint256 amountA,
996             uint256 amountB,
997             uint256 liquidity
998         );
999 
1000     function addLiquidityETH(
1001         address token,
1002         uint256 amountTokenDesired,
1003         uint256 amountTokenMin,
1004         uint256 amountETHMin,
1005         address to,
1006         uint256 deadline
1007     )
1008         external
1009         payable
1010         returns (
1011             uint256 amountToken,
1012             uint256 amountETH,
1013             uint256 liquidity
1014         );
1015 
1016     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1017         uint256 amountIn,
1018         uint256 amountOutMin,
1019         address[] calldata path,
1020         address to,
1021         uint256 deadline
1022     ) external;
1023 
1024     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1025         uint256 amountOutMin,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline
1029     ) external payable;
1030 
1031     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1032         uint256 amountIn,
1033         uint256 amountOutMin,
1034         address[] calldata path,
1035         address to,
1036         uint256 deadline
1037     ) external;
1038 }
1039 
1040 contract DeFiRobot is ERC20, Ownable {
1041     using SafeMath for uint256;
1042 
1043     IUniswapV2Router02 public immutable uniswapV2Router;
1044     address public immutable uniswapV2Pair;
1045     address public constant deadAddress = address(0xdead);
1046 
1047     bool private swapping;
1048 
1049     address public devWallet;
1050 
1051     uint256 public maxTransactionAmount;
1052     uint256 public swapTokensAtAmount;
1053     uint256 public maxWallet;
1054 
1055     bool public limitsInEffect = false;
1056     bool public tradingActive = false;
1057     bool public swapEnabled = false;
1058 
1059     // Anti-bot and anti-whale mappings and variables
1060     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1061     bool public transferDelayEnabled = true;
1062 
1063     uint256 public buyTotalFees;
1064     uint256 public buyLiquidityFee;
1065     uint256 public buyDevFee;
1066 
1067     uint256 public sellTotalFees;
1068     uint256 public sellLiquidityFee;
1069     uint256 public sellDevFee;
1070 
1071     uint256 public tokensForLiquidity;
1072     uint256 public tokensForDev;
1073 
1074     /******************/
1075 
1076     // exlcude from fees and max transaction amount
1077     mapping(address => bool) private _isExcludedFromFees;
1078     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1079 
1080     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1081     // could be subject to a maximum transfer amount
1082     mapping(address => bool) public automatedMarketMakerPairs;
1083 
1084     event UpdateUniswapV2Router(
1085         address indexed newAddress,
1086         address indexed oldAddress
1087     );
1088 
1089     event ExcludeFromFees(address indexed account, bool isExcluded);
1090 
1091     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1092 
1093     event marketingWalletUpdated(
1094         address indexed newWallet,
1095         address indexed oldWallet
1096     );
1097 
1098     event devWalletUpdated(
1099         address indexed newWallet,
1100         address indexed oldWallet
1101     );
1102 
1103     event SwapAndLiquify(
1104         uint256 tokensSwapped,
1105         uint256 ethReceived,
1106         uint256 tokensIntoLiquidity
1107     );
1108 
1109     event AutoNukeLP();
1110 
1111     event ManualNukeLP();
1112 
1113     constructor() ERC20("DeFi-Robot", "DRBT") {
1114         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1115             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1116         );
1117 
1118         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1119         uniswapV2Router = _uniswapV2Router;
1120 
1121         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1122             .createPair(address(this), _uniswapV2Router.WETH());
1123         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1124         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1125 
1126         uint256 _buyLiquidityFee = 2;
1127         uint256 _buyDevFee = 8;
1128 
1129         uint256 _sellLiquidityFee = 2;
1130         uint256 _sellDevFee = 8;
1131 
1132         uint256 totalSupply = 1_000_000_000 * 1e18;
1133 
1134         maxTransactionAmount = 10_000_001 * 1e18; // 1% from total supply maxTransactionAmountTxn
1135         maxWallet = 10_000_002 * 1e18; // 1% from total supply maxWallet
1136         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1137 
1138         buyLiquidityFee = _buyLiquidityFee;
1139         buyDevFee = _buyDevFee;
1140         buyTotalFees = buyLiquidityFee + buyDevFee;
1141 
1142         sellLiquidityFee = _sellLiquidityFee;
1143         sellDevFee = _sellDevFee;
1144         sellTotalFees = sellLiquidityFee + sellDevFee;
1145 
1146         devWallet = owner(); // set as dev wallet
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
1167     function Launch() external onlyOwner {
1168         tradingActive = true;
1169         swapEnabled = true;
1170     }
1171 
1172     // Update limits after token is stable
1173     function UpdateLimits(bool _limitsInEffect) external onlyOwner returns (bool) {
1174         limitsInEffect = _limitsInEffect;
1175         return limitsInEffect;
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
1230     function updateBuyFees(uint256 _liquidityFee, uint256 _devFee)
1231         external
1232         onlyOwner
1233     {
1234         buyLiquidityFee = _liquidityFee;
1235         buyDevFee = _devFee;
1236         buyTotalFees = buyLiquidityFee + buyDevFee;
1237         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
1238     }
1239 
1240     function updateSellFees(uint256 _liquidityFee, uint256 _devFee)
1241         external
1242         onlyOwner
1243     {
1244         sellLiquidityFee = _liquidityFee;
1245         sellDevFee = _devFee;
1246         sellTotalFees = sellLiquidityFee + sellDevFee;
1247         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
1248     }
1249 
1250     function excludeFromFees(address account, bool excluded) public onlyOwner {
1251         _isExcludedFromFees[account] = excluded;
1252         emit ExcludeFromFees(account, excluded);
1253     }
1254 
1255     function setAutomatedMarketMakerPair(address pair, bool value)
1256         public
1257         onlyOwner
1258     {
1259         require(
1260             pair != uniswapV2Pair,
1261             "The pair cannot be removed from automatedMarketMakerPairs"
1262         );
1263 
1264         _setAutomatedMarketMakerPair(pair, value);
1265     }
1266 
1267     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1268         automatedMarketMakerPairs[pair] = value;
1269 
1270         emit SetAutomatedMarketMakerPair(pair, value);
1271     }
1272 
1273     function updateDevWallet(address newWallet) external onlyOwner {
1274         emit devWalletUpdated(newWallet, devWallet);
1275         devWallet = newWallet;
1276     }
1277 
1278     function isExcludedFromFees(address account) public view returns (bool) {
1279         return _isExcludedFromFees[account];
1280     }
1281 
1282     event BoughtEarly(address indexed sniper);
1283 
1284     function _transfer(
1285         address from,
1286         address to,
1287         uint256 amount
1288     ) internal override {
1289         require(from != address(0), "ERC20: transfer from the zero address");
1290         require(to != address(0), "ERC20: transfer to the zero address");
1291 
1292         if (amount == 0) {
1293             super._transfer(from, to, 0);
1294             return;
1295         }
1296 
1297         if (limitsInEffect) {
1298             if (
1299                 from != owner() &&
1300                 to != owner() &&
1301                 to != address(0) &&
1302                 to != address(0xdead) &&
1303                 !swapping
1304             ) {
1305                 if (!tradingActive) {
1306                     require(
1307                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1308                         "Trading is not active."
1309                     );
1310                 }
1311 
1312                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1313                 if (transferDelayEnabled) {
1314                     if (
1315                         to != owner() &&
1316                         to != address(uniswapV2Router) &&
1317                         to != address(uniswapV2Pair)
1318                     ) {
1319                         require(
1320                             _holderLastTransferTimestamp[tx.origin] <
1321                                 block.number,
1322                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1323                         );
1324                         _holderLastTransferTimestamp[tx.origin] = block.number;
1325                     }
1326                 }
1327 
1328                 //when buy
1329                 if (
1330                     automatedMarketMakerPairs[from] &&
1331                     !_isExcludedMaxTransactionAmount[to]
1332                 ) {
1333                     require(
1334                         amount <= maxTransactionAmount,
1335                         "Buy transfer amount exceeds the maxTransactionAmount."
1336                     );
1337                     require(
1338                         amount + balanceOf(to) <= maxWallet,
1339                         "Max wallet exceeded"
1340                     );
1341                 }
1342                 //when sell
1343                 else if (
1344                     automatedMarketMakerPairs[to] &&
1345                     !_isExcludedMaxTransactionAmount[from]
1346                 ) {
1347                     require(
1348                         amount <= maxTransactionAmount,
1349                         "Sell transfer amount exceeds the maxTransactionAmount."
1350                     );
1351                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1352                     require(
1353                         amount + balanceOf(to) <= maxWallet,
1354                         "Max wallet exceeded"
1355                     );
1356                 }
1357             }
1358         }
1359 
1360         uint256 contractTokenBalance = balanceOf(address(this));
1361 
1362         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1363 
1364         if (
1365             canSwap &&
1366             swapEnabled &&
1367             !swapping &&
1368             !automatedMarketMakerPairs[from] &&
1369             !_isExcludedFromFees[from] &&
1370             !_isExcludedFromFees[to]
1371         ) {
1372             swapping = true;
1373 
1374             swapBack();
1375 
1376             swapping = false;
1377         }
1378 
1379         bool takeFee = !swapping;
1380 
1381         // if any account belongs to _isExcludedFromFee account then remove the fee
1382         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1383             takeFee = false;
1384         }
1385 
1386         uint256 fees = 0;
1387         // only take fees on buys/sells, do not take on wallet transfers
1388         if (takeFee) {
1389             // on sell
1390             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1391                 fees = amount.mul(sellTotalFees).div(100);
1392                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1393                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1394             }
1395             // on buy
1396             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1397                 fees = amount.mul(buyTotalFees).div(100);
1398                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1399                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1400             }
1401 
1402             if (fees > 0) {
1403                 super._transfer(from, address(this), fees);
1404             }
1405 
1406             amount -= fees;
1407         }
1408 
1409         super._transfer(from, to, amount);
1410     }
1411 
1412     function swapTokensForEth(uint256 tokenAmount) private {
1413         // generate the uniswap pair path of token -> weth
1414         address[] memory path = new address[](2);
1415         path[0] = address(this);
1416         path[1] = uniswapV2Router.WETH();
1417 
1418         _approve(address(this), address(uniswapV2Router), tokenAmount);
1419 
1420         // make the swap
1421         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1422             tokenAmount,
1423             0, // accept any amount of ETH
1424             path,
1425             address(this),
1426             block.timestamp
1427         );
1428     }
1429 
1430     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1431         // approve token transfer to cover all possible scenarios
1432         _approve(address(this), address(uniswapV2Router), tokenAmount);
1433 
1434         // add the liquidity
1435         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1436             address(this),
1437             tokenAmount,
1438             0, // slippage is unavoidable
1439             0, // slippage is unavoidable
1440             deadAddress,
1441             block.timestamp
1442         );
1443     }
1444 
1445     function swapBack() private {
1446         uint256 contractBalance = balanceOf(address(this));
1447         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
1448         bool success;
1449 
1450         if (contractBalance == 0 || totalTokensToSwap == 0) {
1451             return;
1452         }
1453 
1454         if (contractBalance > swapTokensAtAmount * 20) {
1455             contractBalance = swapTokensAtAmount * 20;
1456         }
1457 
1458         // Halve the amount of liquidity tokens
1459         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1460             totalTokensToSwap /
1461             2;
1462         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1463 
1464         uint256 initialETHBalance = address(this).balance;
1465 
1466         swapTokensForEth(amountToSwapForETH);
1467 
1468         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1469 
1470         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1471 
1472         uint256 ethForLiquidity = ethBalance - ethForDev;
1473 
1474         tokensForLiquidity = 0;
1475         tokensForDev = 0;
1476 
1477         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1478             addLiquidity(liquidityTokens, ethForLiquidity);
1479             emit SwapAndLiquify(
1480                 amountToSwapForETH,
1481                 ethForLiquidity,
1482                 tokensForLiquidity
1483             );
1484         }
1485 
1486         (success, ) = address(devWallet).call{value: address(this).balance}("");
1487     }
1488 }