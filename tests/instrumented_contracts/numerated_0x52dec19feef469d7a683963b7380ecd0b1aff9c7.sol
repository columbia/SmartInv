1 //SPDX-License-Identifier: Unlicense
2 pragma solidity 0.8.4;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Emitted when `value` tokens are moved from one account (`from`) to
10      * another (`to`).
11      *
12      * Note that `value` may be zero.
13      */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /**
17      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
18      * a call to {approve}. `value` is the new allowance.
19      */
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `to`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address to, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `from` to `to` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address from,
77         address to,
78         uint256 amount
79     ) external returns (bool);
80 }
81 
82 /**
83  * @dev Interface for the optional metadata functions from the ERC20 standard.
84  *
85  * _Available since v4.1._
86  */
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 /**
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         return msg.data;
121     }
122 }
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Implementation of the {IERC20} interface.
128  *
129  * This implementation is agnostic to the way tokens are created. This means
130  * that a supply mechanism has to be added in a derived contract using {_mint}.
131  * For a generic mechanism see {ERC20PresetMinterPauser}.
132  *
133  * TIP: For a detailed writeup see our guide
134  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
135  * to implement supply mechanisms].
136  *
137  * We have followed general OpenZeppelin Contracts guidelines: functions revert
138  * instead returning `false` on failure. This behavior is nonetheless
139  * conventional and does not conflict with the expectations of ERC20
140  * applications.
141  *
142  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
143  * This allows applications to reconstruct the allowance for all accounts just
144  * by listening to said events. Other implementations of the EIP may not emit
145  * these events, as it isn't required by the specification.
146  *
147  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
148  * functions have been added to mitigate the well-known issues around setting
149  * allowances. See {IERC20-approve}.
150  */
151 contract ERC20 is Context, IERC20, IERC20Metadata {
152     mapping(address => uint256) private _balances;
153 
154     mapping(address => mapping(address => uint256)) private _allowances;
155 
156     uint256 internal _totalSupply;
157 
158     string private _name;
159     string private _symbol;
160 
161     /**
162      * @dev Sets the values for {name} and {symbol}.
163      *
164      * The default value of {decimals} is 18. To select a different value for
165      * {decimals} you should overload it.
166      *
167      * All two of these values are immutable: they can only be set once during
168      * construction.
169      */
170     constructor(string memory name_, string memory symbol_) {
171         _name = name_;
172         _symbol = symbol_;
173     }
174 
175     /**
176      * @dev Returns the name of the token.
177      */
178     function name() public view virtual override returns (string memory) {
179         return _name;
180     }
181 
182     /**
183      * @dev Returns the symbol of the token, usually a shorter version of the
184      * name.
185      */
186     function symbol() public view virtual override returns (string memory) {
187         return _symbol;
188     }
189 
190     /**
191      * @dev Returns the number of decimals used to get its user representation.
192      * For example, if `decimals` equals `2`, a balance of `505` tokens should
193      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
194      *
195      * Tokens usually opt for a value of 18, imitating the relationship between
196      * Ether and Wei. This is the value {ERC20} uses, unless this function is
197      * overridden;
198      *
199      * NOTE: This information is only used for _display_ purposes: it in
200      * no way affects any of the arithmetic of the contract, including
201      * {IERC20-balanceOf} and {IERC20-transfer}.
202      */
203     function decimals() public view virtual override returns (uint8) {
204         return 18;
205     }
206 
207     /**
208      * @dev See {IERC20-totalSupply}.
209      */
210     function totalSupply() public view virtual override returns (uint256) {
211         return _totalSupply;
212     }
213 
214     /**
215      * @dev See {IERC20-balanceOf}.
216      */
217     function balanceOf(address account) public view virtual override returns (uint256) {
218         return _balances[account];
219     }
220 
221     /**
222      * @dev See {IERC20-transfer}.
223      *
224      * Requirements:
225      *
226      * - `to` cannot be the zero address.
227      * - the caller must have a balance of at least `amount`.
228      */
229     function transfer(address to, uint256 amount) public virtual override returns (bool) {
230         address owner = _msgSender();
231         _transfer(owner, to, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-allowance}.
237      */
238     function allowance(address owner, address spender) public view virtual override returns (uint256) {
239         return _allowances[owner][spender];
240     }
241 
242     /**
243      * @dev See {IERC20-approve}.
244      *
245      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
246      * `transferFrom`. This is semantically equivalent to an infinite approval.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      */
252     function approve(address spender, uint256 amount) public virtual override returns (bool) {
253         address owner = _msgSender();
254         _approve(owner, spender, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-transferFrom}.
260      *
261      * Emits an {Approval} event indicating the updated allowance. This is not
262      * required by the EIP. See the note at the beginning of {ERC20}.
263      *
264      * NOTE: Does not update the allowance if the current allowance
265      * is the maximum `uint256`.
266      *
267      * Requirements:
268      *
269      * - `from` and `to` cannot be the zero address.
270      * - `from` must have a balance of at least `amount`.
271      * - the caller must have allowance for ``from``'s tokens of at least
272      * `amount`.
273      */
274     function transferFrom(
275         address from,
276         address to,
277         uint256 amount
278     ) public virtual override returns (bool) {
279         address spender = _msgSender();
280         _spendAllowance(from, spender, amount);
281         _transfer(from, to, amount);
282         return true;
283     }
284 
285     /**
286      * @dev Atomically increases the allowance granted to `spender` by the caller.
287      *
288      * This is an alternative to {approve} that can be used as a mitigation for
289      * problems described in {IERC20-approve}.
290      *
291      * Emits an {Approval} event indicating the updated allowance.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      */
297     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
298         address owner = _msgSender();
299         _approve(owner, spender, allowance(owner, spender) + addedValue);
300         return true;
301     }
302 
303     /**
304      * @dev Atomically decreases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      * - `spender` must have allowance for the caller of at least
315      * `subtractedValue`.
316      */
317     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
318         address owner = _msgSender();
319         uint256 currentAllowance = allowance(owner, spender);
320         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
321         unchecked {
322             _approve(owner, spender, currentAllowance - subtractedValue);
323         }
324 
325         return true;
326     }
327 
328     /**
329      * @dev Moves `amount` of tokens from `from` to `to`.
330      *
331      * This internal function is equivalent to {transfer}, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a {Transfer} event.
335      *
336      * Requirements:
337      *
338      * - `from` cannot be the zero address.
339      * - `to` cannot be the zero address.
340      * - `from` must have a balance of at least `amount`.
341      */
342     function _transfer(
343         address from,
344         address to,
345         uint256 amount
346     ) internal virtual {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349 
350         _beforeTokenTransfer(from, to, amount);
351 
352         uint256 fromBalance = _balances[from];
353         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
354         unchecked {
355             _balances[from] = fromBalance - amount;
356         }
357         _balances[to] += amount;
358 
359         emit Transfer(from, to, amount);
360 
361         _afterTokenTransfer(from, to, amount);
362     }
363 
364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
365      * the total supply.
366      *
367      * Emits a {Transfer} event with `from` set to the zero address.
368      *
369      * Requirements:
370      *
371      * - `account` cannot be the zero address.
372      */
373     function _mint(address account, uint256 amount) internal virtual {
374         require(account != address(0), "ERC20: mint to the zero address");
375 
376         _beforeTokenTransfer(address(0), account, amount);
377 
378         _totalSupply += amount;
379         _balances[account] += amount;
380         emit Transfer(address(0), account, amount);
381 
382         _afterTokenTransfer(address(0), account, amount);
383     }
384 
385     /**
386      * @dev Destroys `amount` tokens from `account`, reducing the
387      * total supply.
388      *
389      * Emits a {Transfer} event with `to` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      * - `account` must have at least `amount` tokens.
395      */
396     function _burn(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: burn from the zero address");
398 
399         _beforeTokenTransfer(account, address(0), amount);
400 
401         uint256 accountBalance = _balances[account];
402         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
403         unchecked {
404             _balances[account] = accountBalance - amount;
405         }
406         _totalSupply -= amount;
407 
408         emit Transfer(account, address(0), amount);
409 
410         _afterTokenTransfer(account, address(0), amount);
411     }
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
415      *
416      * This internal function is equivalent to `approve`, and can be used to
417      * e.g. set automatic allowances for certain subsystems, etc.
418      *
419      * Emits an {Approval} event.
420      *
421      * Requirements:
422      *
423      * - `owner` cannot be the zero address.
424      * - `spender` cannot be the zero address.
425      */
426     function _approve(
427         address owner,
428         address spender,
429         uint256 amount
430     ) internal virtual {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437 
438     /**
439      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
440      *
441      * Does not update the allowance amount in case of infinite allowance.
442      * Revert if not enough allowance is available.
443      *
444      * Might emit an {Approval} event.
445      */
446     function _spendAllowance(
447         address owner,
448         address spender,
449         uint256 amount
450     ) internal virtual {
451         uint256 currentAllowance = allowance(owner, spender);
452         if (currentAllowance != type(uint256).max) {
453             require(currentAllowance >= amount, "ERC20: insufficient allowance");
454             unchecked {
455                 _approve(owner, spender, currentAllowance - amount);
456             }
457         }
458     }
459 
460     /**
461      * @dev Hook that is called before any transfer of tokens. This includes
462      * minting and burning.
463      *
464      * Calling conditions:
465      *
466      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
467      * will be transferred to `to`.
468      * - when `from` is zero, `amount` tokens will be minted for `to`.
469      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
470      * - `from` and `to` are never both zero.
471      *
472      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
473      */
474     function _beforeTokenTransfer(
475         address from,
476         address to,
477         uint256 amount
478     ) internal virtual {}
479 
480     /**
481      * @dev Hook that is called after any transfer of tokens. This includes
482      * minting and burning.
483      *
484      * Calling conditions:
485      *
486      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
487      * has been transferred to `to`.
488      * - when `from` is zero, `amount` tokens have been minted for `to`.
489      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
490      * - `from` and `to` are never both zero.
491      *
492      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
493      */
494     function _afterTokenTransfer(
495         address from,
496         address to,
497         uint256 amount
498     ) internal virtual {}
499 }
500 
501 library SafeMath {
502     /**
503      * @dev Returns the addition of two unsigned integers, with an overflow flag.
504      *
505      * _Available since v3.4._
506      */
507     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
508         unchecked {
509             uint256 c = a + b;
510             if (c < a) return (false, 0);
511             return (true, c);
512         }
513     }
514 
515     /**
516      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
517      *
518      * _Available since v3.4._
519      */
520     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
521         unchecked {
522             if (b > a) return (false, 0);
523             return (true, a - b);
524         }
525     }
526 
527     /**
528      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
529      *
530      * _Available since v3.4._
531      */
532     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
533         unchecked {
534             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
535             // benefit is lost if 'b' is also tested.
536             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
537             if (a == 0) return (true, 0);
538             uint256 c = a * b;
539             if (c / a != b) return (false, 0);
540             return (true, c);
541         }
542     }
543 
544     /**
545      * @dev Returns the division of two unsigned integers, with a division by zero flag.
546      *
547      * _Available since v3.4._
548      */
549     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
550         unchecked {
551             if (b == 0) return (false, 0);
552             return (true, a / b);
553         }
554     }
555 
556     /**
557      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
558      *
559      * _Available since v3.4._
560      */
561     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
562         unchecked {
563             if (b == 0) return (false, 0);
564             return (true, a % b);
565         }
566     }
567 
568     /**
569      * @dev Returns the addition of two unsigned integers, reverting on
570      * overflow.
571      *
572      * Counterpart to Solidity's `+` operator.
573      *
574      * Requirements:
575      *
576      * - Addition cannot overflow.
577      */
578     function add(uint256 a, uint256 b) internal pure returns (uint256) {
579         return a + b;
580     }
581 
582     /**
583      * @dev Returns the subtraction of two unsigned integers, reverting on
584      * overflow (when the result is negative).
585      *
586      * Counterpart to Solidity's `-` operator.
587      *
588      * Requirements:
589      *
590      * - Subtraction cannot overflow.
591      */
592     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
593         return a - b;
594     }
595 
596     /**
597      * @dev Returns the multiplication of two unsigned integers, reverting on
598      * overflow.
599      *
600      * Counterpart to Solidity's `*` operator.
601      *
602      * Requirements:
603      *
604      * - Multiplication cannot overflow.
605      */
606     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
607         return a * b;
608     }
609 
610     /**
611      * @dev Returns the integer division of two unsigned integers, reverting on
612      * division by zero. The result is rounded towards zero.
613      *
614      * Counterpart to Solidity's `/` operator.
615      *
616      * Requirements:
617      *
618      * - The divisor cannot be zero.
619      */
620     function div(uint256 a, uint256 b) internal pure returns (uint256) {
621         return a / b;
622     }
623 
624     /**
625      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
626      * reverting when dividing by zero.
627      *
628      * Counterpart to Solidity's `%` operator. This function uses a `revert`
629      * opcode (which leaves remaining gas untouched) while Solidity uses an
630      * invalid opcode to revert (consuming all remaining gas).
631      *
632      * Requirements:
633      *
634      * - The divisor cannot be zero.
635      */
636     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
637         return a % b;
638     }
639 
640     /**
641      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
642      * overflow (when the result is negative).
643      *
644      * CAUTION: This function is deprecated because it requires allocating memory for the error
645      * message unnecessarily. For custom revert reasons use {trySub}.
646      *
647      * Counterpart to Solidity's `-` operator.
648      *
649      * Requirements:
650      *
651      * - Subtraction cannot overflow.
652      */
653     function sub(
654         uint256 a,
655         uint256 b,
656         string memory errorMessage
657     ) internal pure returns (uint256) {
658         unchecked {
659             require(b <= a, errorMessage);
660             return a - b;
661         }
662     }
663 
664     /**
665      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
666      * division by zero. The result is rounded towards zero.
667      *
668      * Counterpart to Solidity's `/` operator. Note: this function uses a
669      * `revert` opcode (which leaves remaining gas untouched) while Solidity
670      * uses an invalid opcode to revert (consuming all remaining gas).
671      *
672      * Requirements:
673      *
674      * - The divisor cannot be zero.
675      */
676     function div(
677         uint256 a,
678         uint256 b,
679         string memory errorMessage
680     ) internal pure returns (uint256) {
681         unchecked {
682             require(b > 0, errorMessage);
683             return a / b;
684         }
685     }
686 
687     /**
688      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
689      * reverting with custom message when dividing by zero.
690      *
691      * CAUTION: This function is deprecated because it requires allocating memory for the error
692      * message unnecessarily. For custom revert reasons use {tryMod}.
693      *
694      * Counterpart to Solidity's `%` operator. This function uses a `revert`
695      * opcode (which leaves remaining gas untouched) while Solidity uses an
696      * invalid opcode to revert (consuming all remaining gas).
697      *
698      * Requirements:
699      *
700      * - The divisor cannot be zero.
701      */
702     function mod(
703         uint256 a,
704         uint256 b,
705         string memory errorMessage
706     ) internal pure returns (uint256) {
707         unchecked {
708             require(b > 0, errorMessage);
709             return a % b;
710         }
711     }
712 
713     function sqrrt(uint256 a) internal pure returns (uint c) {
714         if (a > 3) {
715             c = a;
716             uint b = add( div( a, 2), 1 );
717             while (b < c) {
718                 c = b;
719                 b = div( add( div( a, b ), b), 2 );
720             }
721         } else if (a != 0) {
722             c = 1;
723         }
724     }
725 }
726 
727 contract OCTO is ERC20 {
728 
729     using SafeMath for uint256;
730 
731     address public minter;
732     address owner;
733     uint256 public constant maxSupply = 1000000000 ether;
734     uint256 public initialSupply = 150000000 ether;
735   
736     constructor() public ERC20("OCTO Token", "OCTO") {
737         owner = msg.sender;
738         _mint(msg.sender, initialSupply);
739     }   
740 
741     function mint(address to, uint256 amount) public onlyMinter {
742         require(_totalSupply <= maxSupply,"exceeds max supply!" );
743         _mint(to, amount);
744     }
745 
746     function burn(uint256 amount) public {
747         _burn(msg.sender, amount);
748     }
749 
750     function burnFrom(address account_, uint256 amount_) public {
751         _burnFrom(account_, amount_);
752     }
753 
754     function _burnFrom(address account_, uint256 amount_) internal {
755         uint256 decreasedAllowance_ =
756             allowance(account_, msg.sender).sub(
757                 amount_,
758                 "ERC20: burn amount exceeds allowance"
759             );
760 
761         _approve(account_, msg.sender, decreasedAllowance_);
762         _burn(account_, amount_);
763     }
764 
765     function setMinter(address addr) public {
766         require(msg.sender == owner,"invalid user!");
767         require(addr != address(0),'invalid address!');
768         require(minter == address(0),"already setted!");
769         minter = addr;
770     }
771 
772     modifier onlyMinter() {
773         require(minter == msg.sender, "Ownable: caller is not the owner" );
774         _;
775     }
776 
777 }