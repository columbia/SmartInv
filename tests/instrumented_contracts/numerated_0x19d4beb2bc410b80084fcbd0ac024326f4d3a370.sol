1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
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
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
95 
96 pragma solidity ^0.8.0;
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
155     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev Interface for the optional metadata functions from the ERC20 standard.
178  *
179  * _Available since v4.1._
180  */
181 interface IERC20Metadata is IERC20 {
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() external view returns (string memory);
186 
187     /**
188      * @dev Returns the symbol of the token.
189      */
190     function symbol() external view returns (string memory);
191 
192     /**
193      * @dev Returns the decimals places of the token.
194      */
195     function decimals() external view returns (uint8);
196 }
197 
198 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @dev Implementation of the {IERC20} interface.
204  *
205  * This implementation is agnostic to the way tokens are created. This means
206  * that a supply mechanism has to be added in a derived contract using {_mint}.
207  * For a generic mechanism see {ERC20PresetMinterPauser}.
208  *
209  * TIP: For a detailed writeup see our guide
210  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
211  * to implement supply mechanisms].
212  *
213  * We have followed general OpenZeppelin guidelines: functions revert instead
214  * of returning `false` on failure. This behavior is nonetheless conventional
215  * and does not conflict with the expectations of ERC20 applications.
216  *
217  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
218  * This allows applications to reconstruct the allowance for all accounts just
219  * by listening to said events. Other implementations of the EIP may not emit
220  * these events, as it isn't required by the specification.
221  *
222  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
223  * functions have been added to mitigate the well-known issues around setting
224  * allowances. See {IERC20-approve}.
225  */
226 contract ERC20 is Context, IERC20, IERC20Metadata {
227     mapping (address => uint256) private _balances;
228 
229     mapping (address => mapping (address => uint256)) private _allowances;
230 
231     uint256 private _totalSupply;
232 
233     string private _name;
234     string private _symbol;
235 
236     /**
237      * @dev Sets the values for {name} and {symbol}.
238      *
239      * The defaut value of {decimals} is 18. To select a different value for
240      * {decimals} you should overload it.
241      *
242      * All two of these values are immutable: they can only be set once during
243      * construction.
244      */
245     constructor (string memory name_, string memory symbol_) {
246         _name = name_;
247         _symbol = symbol_;
248     }
249 
250     /**
251      * @dev Returns the name of the token.
252      */
253     function name() public view virtual override returns (string memory) {
254         return _name;
255     }
256 
257     /**
258      * @dev Returns the symbol of the token, usually a shorter version of the
259      * name.
260      */
261     function symbol() public view virtual override returns (string memory) {
262         return _symbol;
263     }
264 
265     /**
266      * @dev Returns the number of decimals used to get its user representation.
267      * For example, if `decimals` equals `2`, a balance of `505` tokens should
268      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
269      *
270      * Tokens usually opt for a value of 18, imitating the relationship between
271      * Ether and Wei. This is the value {ERC20} uses, unless this function is
272      * overridden;
273      *
274      * NOTE: This information is only used for _display_ purposes: it in
275      * no way affects any of the arithmetic of the contract, including
276      * {IERC20-balanceOf} and {IERC20-transfer}.
277      */
278     function decimals() public view virtual override returns (uint8) {
279         return 18;
280     }
281 
282     /**
283      * @dev See {IERC20-totalSupply}.
284      */
285     function totalSupply() public view virtual override returns (uint256) {
286         return _totalSupply;
287     }
288 
289     /**
290      * @dev See {IERC20-balanceOf}.
291      */
292     function balanceOf(address account) public view virtual override returns (uint256) {
293         return _balances[account];
294     }
295 
296     /**
297      * @dev See {IERC20-transfer}.
298      *
299      * Requirements:
300      *
301      * - `recipient` cannot be the zero address.
302      * - the caller must have a balance of at least `amount`.
303      */
304     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
305         _transfer(_msgSender(), recipient, amount);
306         return true;
307     }
308 
309     /**
310      * @dev See {IERC20-allowance}.
311      */
312     function allowance(address owner, address spender) public view virtual override returns (uint256) {
313         return _allowances[owner][spender];
314     }
315 
316     /**
317      * @dev See {IERC20-approve}.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function approve(address spender, uint256 amount) public virtual override returns (bool) {
324         _approve(_msgSender(), spender, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-transferFrom}.
330      *
331      * Emits an {Approval} event indicating the updated allowance. This is not
332      * required by the EIP. See the note at the beginning of {ERC20}.
333      *
334      * Requirements:
335      *
336      * - `sender` and `recipient` cannot be the zero address.
337      * - `sender` must have a balance of at least `amount`.
338      * - the caller must have allowance for ``sender``'s tokens of at least
339      * `amount`.
340      */
341     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
342         _transfer(sender, recipient, amount);
343 
344         uint256 currentAllowance = _allowances[sender][_msgSender()];
345         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
346         _approve(sender, _msgSender(), currentAllowance - amount);
347 
348         return true;
349     }
350 
351     /**
352      * @dev Atomically increases the allowance granted to `spender` by the caller.
353      *
354      * This is an alternative to {approve} that can be used as a mitigation for
355      * problems described in {IERC20-approve}.
356      *
357      * Emits an {Approval} event indicating the updated allowance.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
365         return true;
366     }
367 
368     /**
369      * @dev Atomically decreases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      * - `spender` must have allowance for the caller of at least
380      * `subtractedValue`.
381      */
382     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
383         uint256 currentAllowance = _allowances[_msgSender()][spender];
384         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
385         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
386 
387         return true;
388     }
389 
390     /**
391      * @dev Moves tokens `amount` from `sender` to `recipient`.
392      *
393      * This is internal function is equivalent to {transfer}, and can be used to
394      * e.g. implement automatic token fees, slashing mechanisms, etc.
395      *
396      * Emits a {Transfer} event.
397      *
398      * Requirements:
399      *
400      * - `sender` cannot be the zero address.
401      * - `recipient` cannot be the zero address.
402      * - `sender` must have a balance of at least `amount`.
403      */
404     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
405         require(sender != address(0), "ERC20: transfer from the zero address");
406         require(recipient != address(0), "ERC20: transfer to the zero address");
407 
408         _beforeTokenTransfer(sender, recipient, amount);
409 
410         uint256 senderBalance = _balances[sender];
411         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
412         _balances[sender] = senderBalance - amount;
413         _balances[recipient] += amount;
414 
415         emit Transfer(sender, recipient, amount);
416     }
417 
418     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
419      * the total supply.
420      *
421      * Emits a {Transfer} event with `from` set to the zero address.
422      *
423      * Requirements:
424      *
425      * - `to` cannot be the zero address.
426      */
427     function _mint(address account, uint256 amount) internal virtual {
428         require(account != address(0), "ERC20: mint to the zero address");
429 
430         _beforeTokenTransfer(address(0), account, amount);
431 
432         _totalSupply += amount;
433         _balances[account] += amount;
434         emit Transfer(address(0), account, amount);
435     }
436 
437     /**
438      * @dev Destroys `amount` tokens from `account`, reducing the
439      * total supply.
440      *
441      * Emits a {Transfer} event with `to` set to the zero address.
442      *
443      * Requirements:
444      *
445      * - `account` cannot be the zero address.
446      * - `account` must have at least `amount` tokens.
447      */
448     function _burn(address account, uint256 amount) internal virtual {
449         require(account != address(0), "ERC20: burn from the zero address");
450 
451         _beforeTokenTransfer(account, address(0), amount);
452 
453         uint256 accountBalance = _balances[account];
454         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
455         _balances[account] = accountBalance - amount;
456         _totalSupply -= amount;
457 
458         emit Transfer(account, address(0), amount);
459     }
460 
461     /**
462      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
463      *
464      * This internal function is equivalent to `approve`, and can be used to
465      * e.g. set automatic allowances for certain subsystems, etc.
466      *
467      * Emits an {Approval} event.
468      *
469      * Requirements:
470      *
471      * - `owner` cannot be the zero address.
472      * - `spender` cannot be the zero address.
473      */
474     function _approve(address owner, address spender, uint256 amount) internal virtual {
475         require(owner != address(0), "ERC20: approve from the zero address");
476         require(spender != address(0), "ERC20: approve to the zero address");
477 
478         _allowances[owner][spender] = amount;
479         emit Approval(owner, spender, amount);
480     }
481 
482     /**
483      * @dev Hook that is called before any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * will be to transferred to `to`.
490      * - when `from` is zero, `amount` tokens will be minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Extension of {ERC20} that allows token holders to destroy both their own
505  * tokens and those that they have an allowance for, in a way that can be
506  * recognized off-chain (via event analysis).
507  */
508 abstract contract ERC20Burnable is Context, ERC20 {
509     /**
510      * @dev Destroys `amount` tokens from the caller.
511      *
512      * See {ERC20-_burn}.
513      */
514     function burn(uint256 amount) public virtual {
515         _burn(_msgSender(), amount);
516     }
517 
518     /**
519      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
520      * allowance.
521      *
522      * See {ERC20-_burn} and {ERC20-allowance}.
523      *
524      * Requirements:
525      *
526      * - the caller must have allowance for ``accounts``'s tokens of at least
527      * `amount`.
528      */
529     function burnFrom(address account, uint256 amount) public virtual {
530         uint256 currentAllowance = allowance(account, _msgSender());
531         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
532         _approve(account, _msgSender(), currentAllowance - amount);
533         _burn(account, amount);
534     }
535 }
536 
537 // File: eth-token-recover/contracts/TokenRecover.sol
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @title TokenRecover
543  * @author Vittorio Minacori (https://github.com/vittominacori)
544  * @dev Allows owner to recover any ERC20 sent into the contract
545  */
546 contract TokenRecover is Ownable {
547 
548     /**
549      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
550      * @param tokenAddress The token contract address
551      * @param tokenAmount Number of tokens to be sent
552      */
553     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
554         IERC20(tokenAddress).transfer(owner(), tokenAmount);
555     }
556 }
557 
558 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
559 
560 pragma solidity ^0.8.0;
561 
562 // CAUTION
563 // This version of SafeMath should only be used with Solidity 0.8 or later,
564 // because it relies on the compiler's built in overflow checks.
565 
566 /**
567  * @dev Wrappers over Solidity's arithmetic operations.
568  *
569  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
570  * now has built in overflow checking.
571  */
572 library SafeMath {
573     /**
574      * @dev Returns the addition of two unsigned integers, with an overflow flag.
575      *
576      * _Available since v3.4._
577      */
578     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
579         unchecked {
580             uint256 c = a + b;
581             if (c < a) return (false, 0);
582             return (true, c);
583         }
584     }
585 
586     /**
587      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
588      *
589      * _Available since v3.4._
590      */
591     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         unchecked {
593             if (b > a) return (false, 0);
594             return (true, a - b);
595         }
596     }
597 
598     /**
599      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
600      *
601      * _Available since v3.4._
602      */
603     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
606             // benefit is lost if 'b' is also tested.
607             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
608             if (a == 0) return (true, 0);
609             uint256 c = a * b;
610             if (c / a != b) return (false, 0);
611             return (true, c);
612         }
613     }
614 
615     /**
616      * @dev Returns the division of two unsigned integers, with a division by zero flag.
617      *
618      * _Available since v3.4._
619      */
620     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             if (b == 0) return (false, 0);
623             return (true, a / b);
624         }
625     }
626 
627     /**
628      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             if (b == 0) return (false, 0);
635             return (true, a % b);
636         }
637     }
638 
639     /**
640      * @dev Returns the addition of two unsigned integers, reverting on
641      * overflow.
642      *
643      * Counterpart to Solidity's `+` operator.
644      *
645      * Requirements:
646      *
647      * - Addition cannot overflow.
648      */
649     function add(uint256 a, uint256 b) internal pure returns (uint256) {
650         return a + b;
651     }
652 
653     /**
654      * @dev Returns the subtraction of two unsigned integers, reverting on
655      * overflow (when the result is negative).
656      *
657      * Counterpart to Solidity's `-` operator.
658      *
659      * Requirements:
660      *
661      * - Subtraction cannot overflow.
662      */
663     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
664         return a - b;
665     }
666 
667     /**
668      * @dev Returns the multiplication of two unsigned integers, reverting on
669      * overflow.
670      *
671      * Counterpart to Solidity's `*` operator.
672      *
673      * Requirements:
674      *
675      * - Multiplication cannot overflow.
676      */
677     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
678         return a * b;
679     }
680 
681     /**
682      * @dev Returns the integer division of two unsigned integers, reverting on
683      * division by zero. The result is rounded towards zero.
684      *
685      * Counterpart to Solidity's `/` operator.
686      *
687      * Requirements:
688      *
689      * - The divisor cannot be zero.
690      */
691     function div(uint256 a, uint256 b) internal pure returns (uint256) {
692         return a / b;
693     }
694 
695     /**
696      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
697      * reverting when dividing by zero.
698      *
699      * Counterpart to Solidity's `%` operator. This function uses a `revert`
700      * opcode (which leaves remaining gas untouched) while Solidity uses an
701      * invalid opcode to revert (consuming all remaining gas).
702      *
703      * Requirements:
704      *
705      * - The divisor cannot be zero.
706      */
707     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a % b;
709     }
710 
711     /**
712      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
713      * overflow (when the result is negative).
714      *
715      * CAUTION: This function is deprecated because it requires allocating memory for the error
716      * message unnecessarily. For custom revert reasons use {trySub}.
717      *
718      * Counterpart to Solidity's `-` operator.
719      *
720      * Requirements:
721      *
722      * - Subtraction cannot overflow.
723      */
724     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
725         unchecked {
726             require(b <= a, errorMessage);
727             return a - b;
728         }
729     }
730 
731     /**
732      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
733      * division by zero. The result is rounded towards zero.
734      *
735      * Counterpart to Solidity's `%` operator. This function uses a `revert`
736      * opcode (which leaves remaining gas untouched) while Solidity uses an
737      * invalid opcode to revert (consuming all remaining gas).
738      *
739      * Counterpart to Solidity's `/` operator. Note: this function uses a
740      * `revert` opcode (which leaves remaining gas untouched) while Solidity
741      * uses an invalid opcode to revert (consuming all remaining gas).
742      *
743      * Requirements:
744      *
745      * - The divisor cannot be zero.
746      */
747     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
748         unchecked {
749             require(b > 0, errorMessage);
750             return a / b;
751         }
752     }
753 
754     /**
755      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
756      * reverting with custom message when dividing by zero.
757      *
758      * CAUTION: This function is deprecated because it requires allocating memory for the error
759      * message unnecessarily. For custom revert reasons use {tryMod}.
760      *
761      * Counterpart to Solidity's `%` operator. This function uses a `revert`
762      * opcode (which leaves remaining gas untouched) while Solidity uses an
763      * invalid opcode to revert (consuming all remaining gas).
764      *
765      * Requirements:
766      *
767      * - The divisor cannot be zero.
768      */
769     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
770         unchecked {
771             require(b > 0, errorMessage);
772             return a % b;
773         }
774     }
775 }
776 
777 // File: @openzeppelin/contracts/utils/Address.sol
778 
779 pragma solidity ^0.8.0;
780 
781 /**
782  * @dev Collection of functions related to the address type
783  */
784 library Address {
785     /**
786      * @dev Returns true if `account` is a contract.
787      *
788      * [IMPORTANT]
789      * ====
790      * It is unsafe to assume that an address for which this function returns
791      * false is an externally-owned account (EOA) and not a contract.
792      *
793      * Among others, `isContract` will return false for the following
794      * types of addresses:
795      *
796      *  - an externally-owned account
797      *  - a contract in construction
798      *  - an address where a contract will be created
799      *  - an address where a contract lived, but was destroyed
800      * ====
801      */
802     function isContract(address account) internal view returns (bool) {
803         // This method relies on extcodesize, which returns 0 for contracts in
804         // construction, since the code is only stored at the end of the
805         // constructor execution.
806 
807         uint256 size;
808         // solhint-disable-next-line no-inline-assembly
809         assembly { size := extcodesize(account) }
810         return size > 0;
811     }
812 
813     /**
814      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
815      * `recipient`, forwarding all available gas and reverting on errors.
816      *
817      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
818      * of certain opcodes, possibly making contracts go over the 2300 gas limit
819      * imposed by `transfer`, making them unable to receive funds via
820      * `transfer`. {sendValue} removes this limitation.
821      *
822      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
823      *
824      * IMPORTANT: because control is transferred to `recipient`, care must be
825      * taken to not create reentrancy vulnerabilities. Consider using
826      * {ReentrancyGuard} or the
827      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
828      */
829     function sendValue(address payable recipient, uint256 amount) internal {
830         require(address(this).balance >= amount, "Address: insufficient balance");
831 
832         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
833         (bool success, ) = recipient.call{ value: amount }("");
834         require(success, "Address: unable to send value, recipient may have reverted");
835     }
836 
837     /**
838      * @dev Performs a Solidity function call using a low level `call`. A
839      * plain`call` is an unsafe replacement for a function call: use this
840      * function instead.
841      *
842      * If `target` reverts with a revert reason, it is bubbled up by this
843      * function (like regular Solidity function calls).
844      *
845      * Returns the raw returned data. To convert to the expected return value,
846      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
847      *
848      * Requirements:
849      *
850      * - `target` must be a contract.
851      * - calling `target` with `data` must not revert.
852      *
853      * _Available since v3.1._
854      */
855     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
856       return functionCall(target, data, "Address: low-level call failed");
857     }
858 
859     /**
860      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
861      * `errorMessage` as a fallback revert reason when `target` reverts.
862      *
863      * _Available since v3.1._
864      */
865     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
866         return functionCallWithValue(target, data, 0, errorMessage);
867     }
868 
869     /**
870      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
871      * but also transferring `value` wei to `target`.
872      *
873      * Requirements:
874      *
875      * - the calling contract must have an ETH balance of at least `value`.
876      * - the called Solidity function must be `payable`.
877      *
878      * _Available since v3.1._
879      */
880     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
881         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
882     }
883 
884     /**
885      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
886      * with `errorMessage` as a fallback revert reason when `target` reverts.
887      *
888      * _Available since v3.1._
889      */
890     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
891         require(address(this).balance >= value, "Address: insufficient balance for call");
892         require(isContract(target), "Address: call to non-contract");
893 
894         // solhint-disable-next-line avoid-low-level-calls
895         (bool success, bytes memory returndata) = target.call{ value: value }(data);
896         return _verifyCallResult(success, returndata, errorMessage);
897     }
898 
899     /**
900      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
901      * but performing a static call.
902      *
903      * _Available since v3.3._
904      */
905     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
906         return functionStaticCall(target, data, "Address: low-level static call failed");
907     }
908 
909     /**
910      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
911      * but performing a static call.
912      *
913      * _Available since v3.3._
914      */
915     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
916         require(isContract(target), "Address: static call to non-contract");
917 
918         // solhint-disable-next-line avoid-low-level-calls
919         (bool success, bytes memory returndata) = target.staticcall(data);
920         return _verifyCallResult(success, returndata, errorMessage);
921     }
922 
923     /**
924      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
925      * but performing a delegate call.
926      *
927      * _Available since v3.4._
928      */
929     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
930         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
931     }
932 
933     /**
934      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
935      * but performing a delegate call.
936      *
937      * _Available since v3.4._
938      */
939     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
940         require(isContract(target), "Address: delegate call to non-contract");
941 
942         // solhint-disable-next-line avoid-low-level-calls
943         (bool success, bytes memory returndata) = target.delegatecall(data);
944         return _verifyCallResult(success, returndata, errorMessage);
945     }
946 
947     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
948         if (success) {
949             return returndata;
950         } else {
951             // Look for revert reason and bubble it up if present
952             if (returndata.length > 0) {
953                 // The easiest way to bubble the revert reason is using memory via assembly
954 
955                 // solhint-disable-next-line no-inline-assembly
956                 assembly {
957                     let returndata_size := mload(returndata)
958                     revert(add(32, returndata), returndata_size)
959                 }
960             } else {
961                 revert(errorMessage);
962             }
963         }
964     }
965 }
966 
967 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
968 
969 pragma solidity ^0.8.0;
970 
971 /**
972  * @title SafeERC20
973  * @dev Wrappers around ERC20 operations that throw on failure (when the token
974  * contract returns false). Tokens that return no value (and instead revert or
975  * throw on failure) are also supported, non-reverting calls are assumed to be
976  * successful.
977  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
978  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
979  */
980 library SafeERC20 {
981     using Address for address;
982 
983     function safeTransfer(IERC20 token, address to, uint256 value) internal {
984         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
985     }
986 
987     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
988         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
989     }
990 
991     /**
992      * @dev Deprecated. This function has issues similar to the ones found in
993      * {IERC20-approve}, and its usage is discouraged.
994      *
995      * Whenever possible, use {safeIncreaseAllowance} and
996      * {safeDecreaseAllowance} instead.
997      */
998     function safeApprove(IERC20 token, address spender, uint256 value) internal {
999         // safeApprove should only be called when setting an initial allowance,
1000         // or when resetting it to zero. To increase and decrease it, use
1001         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1002         // solhint-disable-next-line max-line-length
1003         require((value == 0) || (token.allowance(address(this), spender) == 0),
1004             "SafeERC20: approve from non-zero to non-zero allowance"
1005         );
1006         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1007     }
1008 
1009     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1010         uint256 newAllowance = token.allowance(address(this), spender) + value;
1011         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1012     }
1013 
1014     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1015         unchecked {
1016             uint256 oldAllowance = token.allowance(address(this), spender);
1017             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1018             uint256 newAllowance = oldAllowance - value;
1019             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1020         }
1021     }
1022 
1023     /**
1024      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1025      * on the return value: the return value is optional (but if data is returned, it must not be false).
1026      * @param token The token targeted by the call.
1027      * @param data The call data (encoded using abi.encode or one of its variants).
1028      */
1029     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1030         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1031         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1032         // the target address contains contract code and also asserts for success in the low-level call.
1033 
1034         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1035         if (returndata.length > 0) { // Return data is optional
1036             // solhint-disable-next-line max-line-length
1037             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1038         }
1039     }
1040 }
1041 
1042 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 /**
1047  * @dev Interface of the ERC165 standard, as defined in the
1048  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1049  *
1050  * Implementers can declare support of contract interfaces, which can then be
1051  * queried by others ({ERC165Checker}).
1052  *
1053  * For an implementation, see {ERC165}.
1054  */
1055 interface IERC165 {
1056     /**
1057      * @dev Returns true if this contract implements the interface defined by
1058      * `interfaceId`. See the corresponding
1059      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1060      * to learn more about how these ids are created.
1061      *
1062      * This function call must use less than 30 000 gas.
1063      */
1064     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1065 }
1066 
1067 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1068 
1069 pragma solidity ^0.8.0;
1070 
1071 
1072 /**
1073  * @dev Implementation of the {IERC165} interface.
1074  *
1075  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1076  * for the additional interface id that will be supported. For example:
1077  *
1078  * ```solidity
1079  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1080  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1081  * }
1082  * ```
1083  *
1084  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1085  */
1086 abstract contract ERC165 is IERC165 {
1087     /**
1088      * @dev See {IERC165-supportsInterface}.
1089      */
1090     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1091         return interfaceId == type(IERC165).interfaceId;
1092     }
1093 }
1094 
1095 // File: @openzeppelin/contracts/utils/Strings.sol
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 /**
1100  * @dev String operations.
1101  */
1102 library Strings {
1103     bytes16 private constant alphabet = "0123456789abcdef";
1104 
1105     /**
1106      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1107      */
1108     function toString(uint256 value) internal pure returns (string memory) {
1109         // Inspired by OraclizeAPI's implementation - MIT licence
1110         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1111 
1112         if (value == 0) {
1113             return "0";
1114         }
1115         uint256 temp = value;
1116         uint256 digits;
1117         while (temp != 0) {
1118             digits++;
1119             temp /= 10;
1120         }
1121         bytes memory buffer = new bytes(digits);
1122         while (value != 0) {
1123             digits -= 1;
1124             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1125             value /= 10;
1126         }
1127         return string(buffer);
1128     }
1129 
1130     /**
1131      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1132      */
1133     function toHexString(uint256 value) internal pure returns (string memory) {
1134         if (value == 0) {
1135             return "0x00";
1136         }
1137         uint256 temp = value;
1138         uint256 length = 0;
1139         while (temp != 0) {
1140             length++;
1141             temp >>= 8;
1142         }
1143         return toHexString(value, length);
1144     }
1145 
1146     /**
1147      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1148      */
1149     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1150         bytes memory buffer = new bytes(2 * length + 2);
1151         buffer[0] = "0";
1152         buffer[1] = "x";
1153         for (uint256 i = 2 * length + 1; i > 1; --i) {
1154             buffer[i] = alphabet[value & 0xf];
1155             value >>= 4;
1156         }
1157         require(value == 0, "Strings: hex length insufficient");
1158         return string(buffer);
1159     }
1160 
1161 }
1162 
1163 // File: @openzeppelin/contracts/access/AccessControl.sol
1164 
1165 pragma solidity ^0.8.0;
1166 
1167 /**
1168  * @dev External interface of AccessControl declared to support ERC165 detection.
1169  */
1170 interface IAccessControl {
1171     function hasRole(bytes32 role, address account) external view returns (bool);
1172     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1173     function grantRole(bytes32 role, address account) external;
1174     function revokeRole(bytes32 role, address account) external;
1175     function renounceRole(bytes32 role, address account) external;
1176 }
1177 
1178 /**
1179  * @dev Contract module that allows children to implement role-based access
1180  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1181  * members except through off-chain means by accessing the contract event logs. Some
1182  * applications may benefit from on-chain enumerability, for those cases see
1183  * {AccessControlEnumerable}.
1184  *
1185  * Roles are referred to by their `bytes32` identifier. These should be exposed
1186  * in the external API and be unique. The best way to achieve this is by
1187  * using `public constant` hash digests:
1188  *
1189  * ```
1190  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1191  * ```
1192  *
1193  * Roles can be used to represent a set of permissions. To restrict access to a
1194  * function call, use {hasRole}:
1195  *
1196  * ```
1197  * function foo() public {
1198  *     require(hasRole(MY_ROLE, msg.sender));
1199  *     ...
1200  * }
1201  * ```
1202  *
1203  * Roles can be granted and revoked dynamically via the {grantRole} and
1204  * {revokeRole} functions. Each role has an associated admin role, and only
1205  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1206  *
1207  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1208  * that only accounts with this role will be able to grant or revoke other
1209  * roles. More complex role relationships can be created by using
1210  * {_setRoleAdmin}.
1211  *
1212  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1213  * grant and revoke this role. Extra precautions should be taken to secure
1214  * accounts that have been granted it.
1215  */
1216 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1217     struct RoleData {
1218         mapping (address => bool) members;
1219         bytes32 adminRole;
1220     }
1221 
1222     mapping (bytes32 => RoleData) private _roles;
1223 
1224     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1225 
1226     /**
1227      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1228      *
1229      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1230      * {RoleAdminChanged} not being emitted signaling this.
1231      *
1232      * _Available since v3.1._
1233      */
1234     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1235 
1236     /**
1237      * @dev Emitted when `account` is granted `role`.
1238      *
1239      * `sender` is the account that originated the contract call, an admin role
1240      * bearer except when using {_setupRole}.
1241      */
1242     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1243 
1244     /**
1245      * @dev Emitted when `account` is revoked `role`.
1246      *
1247      * `sender` is the account that originated the contract call:
1248      *   - if using `revokeRole`, it is the admin role bearer
1249      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1250      */
1251     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1252 
1253     /**
1254      * @dev Modifier that checks that an account has a specific role. Reverts
1255      * with a standardized message including the required role.
1256      *
1257      * The format of the revert reason is given by the following regular expression:
1258      *
1259      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1260      *
1261      * _Available since v4.1._
1262      */
1263     modifier onlyRole(bytes32 role) {
1264         _checkRole(role, _msgSender());
1265         _;
1266     }
1267 
1268     /**
1269      * @dev See {IERC165-supportsInterface}.
1270      */
1271     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1272         return interfaceId == type(IAccessControl).interfaceId
1273             || super.supportsInterface(interfaceId);
1274     }
1275 
1276     /**
1277      * @dev Returns `true` if `account` has been granted `role`.
1278      */
1279     function hasRole(bytes32 role, address account) public view override returns (bool) {
1280         return _roles[role].members[account];
1281     }
1282 
1283     /**
1284      * @dev Revert with a standard message if `account` is missing `role`.
1285      *
1286      * The format of the revert reason is given by the following regular expression:
1287      *
1288      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1289      */
1290     function _checkRole(bytes32 role, address account) internal view {
1291         if(!hasRole(role, account)) {
1292             revert(string(abi.encodePacked(
1293                 "AccessControl: account ",
1294                 Strings.toHexString(uint160(account), 20),
1295                 " is missing role ",
1296                 Strings.toHexString(uint256(role), 32)
1297             )));
1298         }
1299     }
1300 
1301     /**
1302      * @dev Returns the admin role that controls `role`. See {grantRole} and
1303      * {revokeRole}.
1304      *
1305      * To change a role's admin, use {_setRoleAdmin}.
1306      */
1307     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1308         return _roles[role].adminRole;
1309     }
1310 
1311     /**
1312      * @dev Grants `role` to `account`.
1313      *
1314      * If `account` had not been already granted `role`, emits a {RoleGranted}
1315      * event.
1316      *
1317      * Requirements:
1318      *
1319      * - the caller must have ``role``'s admin role.
1320      */
1321     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1322         _grantRole(role, account);
1323     }
1324 
1325     /**
1326      * @dev Revokes `role` from `account`.
1327      *
1328      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1329      *
1330      * Requirements:
1331      *
1332      * - the caller must have ``role``'s admin role.
1333      */
1334     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1335         _revokeRole(role, account);
1336     }
1337 
1338     /**
1339      * @dev Revokes `role` from the calling account.
1340      *
1341      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1342      * purpose is to provide a mechanism for accounts to lose their privileges
1343      * if they are compromised (such as when a trusted device is misplaced).
1344      *
1345      * If the calling account had been granted `role`, emits a {RoleRevoked}
1346      * event.
1347      *
1348      * Requirements:
1349      *
1350      * - the caller must be `account`.
1351      */
1352     function renounceRole(bytes32 role, address account) public virtual override {
1353         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1354 
1355         _revokeRole(role, account);
1356     }
1357 
1358     /**
1359      * @dev Grants `role` to `account`.
1360      *
1361      * If `account` had not been already granted `role`, emits a {RoleGranted}
1362      * event. Note that unlike {grantRole}, this function doesn't perform any
1363      * checks on the calling account.
1364      *
1365      * [WARNING]
1366      * ====
1367      * This function should only be called from the constructor when setting
1368      * up the initial roles for the system.
1369      *
1370      * Using this function in any other way is effectively circumventing the admin
1371      * system imposed by {AccessControl}.
1372      * ====
1373      */
1374     function _setupRole(bytes32 role, address account) internal virtual {
1375         _grantRole(role, account);
1376     }
1377 
1378     /**
1379      * @dev Sets `adminRole` as ``role``'s admin role.
1380      *
1381      * Emits a {RoleAdminChanged} event.
1382      */
1383     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1384         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1385         _roles[role].adminRole = adminRole;
1386     }
1387 
1388     function _grantRole(bytes32 role, address account) private {
1389         if (!hasRole(role, account)) {
1390             _roles[role].members[account] = true;
1391             emit RoleGranted(role, account, _msgSender());
1392         }
1393     }
1394 
1395     function _revokeRole(bytes32 role, address account) private {
1396         if (hasRole(role, account)) {
1397             _roles[role].members[account] = false;
1398             emit RoleRevoked(role, account, _msgSender());
1399         }
1400     }
1401 }
1402 
1403 // File: contracts/ViCA.sol
1404 
1405 /* SPDX-License-Identifier: MIT
1406     The ViCA coin was created in compliance with the standard ERC20 regulations.
1407 */
1408 
1409 pragma solidity ^0.8.0;
1410 
1411 contract ViCA is ERC20 {
1412     // 18 decimals
1413     constructor() ERC20("ViCA Token", "ViCA") {
1414         _mint(_msgSender(), 2_000_000_000 * (10 ** uint256(decimals())));
1415     }
1416 
1417     function batchTransfer(address[] calldata destinations, uint256[] calldata amounts) public {
1418         uint256 n = destinations.length;
1419         address sender = _msgSender();
1420         require(n == amounts.length, "ViCA: Invalid BatchTransfer");
1421         for(uint256 i = 0; i < n; i++)
1422             _transfer(sender, destinations[i], amounts[i]);
1423     }
1424 }