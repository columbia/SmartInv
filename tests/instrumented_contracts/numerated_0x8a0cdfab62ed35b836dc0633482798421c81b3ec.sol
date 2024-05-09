1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
99 
100 
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Interface of the ERC20 standard as defined in the EIP.
106  */
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through {transferFrom}. This is
130      * zero by default.
131      *
132      * This value changes when {approve} or {transferFrom} are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
179 
180 
181 
182 pragma solidity ^0.8.0;
183 
184 
185 /**
186  * @dev Interface for the optional metadata functions from the ERC20 standard.
187  *
188  * _Available since v4.1._
189  */
190 interface IERC20Metadata is IERC20 {
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the symbol of the token.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the decimals places of the token.
203      */
204     function decimals() external view returns (uint8);
205 }
206 
207 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
208 
209 
210 
211 pragma solidity ^0.8.0;
212 
213 
214 
215 
216 /**
217  * @dev Implementation of the {IERC20} interface.
218  *
219  * This implementation is agnostic to the way tokens are created. This means
220  * that a supply mechanism has to be added in a derived contract using {_mint}.
221  * For a generic mechanism see {ERC20PresetMinterPauser}.
222  *
223  * TIP: For a detailed writeup see our guide
224  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
225  * to implement supply mechanisms].
226  *
227  * We have followed general OpenZeppelin guidelines: functions revert instead
228  * of returning `false` on failure. This behavior is nonetheless conventional
229  * and does not conflict with the expectations of ERC20 applications.
230  *
231  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
232  * This allows applications to reconstruct the allowance for all accounts just
233  * by listening to said events. Other implementations of the EIP may not emit
234  * these events, as it isn't required by the specification.
235  *
236  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
237  * functions have been added to mitigate the well-known issues around setting
238  * allowances. See {IERC20-approve}.
239  */
240 contract ERC20 is Context, IERC20, IERC20Metadata {
241     mapping (address => uint256) private _balances;
242 
243     mapping (address => mapping (address => uint256)) private _allowances;
244 
245     uint256 private _totalSupply;
246 
247     string private _name;
248     string private _symbol;
249 
250     /**
251      * @dev Sets the values for {name} and {symbol}.
252      *
253      * The defaut value of {decimals} is 18. To select a different value for
254      * {decimals} you should overload it.
255      *
256      * All two of these values are immutable: they can only be set once during
257      * construction.
258      */
259     constructor (string memory name_, string memory symbol_) {
260         _name = name_;
261         _symbol = symbol_;
262     }
263 
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() public view virtual override returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @dev Returns the symbol of the token, usually a shorter version of the
273      * name.
274      */
275     function symbol() public view virtual override returns (string memory) {
276         return _symbol;
277     }
278 
279     /**
280      * @dev Returns the number of decimals used to get its user representation.
281      * For example, if `decimals` equals `2`, a balance of `505` tokens should
282      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
283      *
284      * Tokens usually opt for a value of 18, imitating the relationship between
285      * Ether and Wei. This is the value {ERC20} uses, unless this function is
286      * overridden;
287      *
288      * NOTE: This information is only used for _display_ purposes: it in
289      * no way affects any of the arithmetic of the contract, including
290      * {IERC20-balanceOf} and {IERC20-transfer}.
291      */
292     function decimals() public view virtual override returns (uint8) {
293         return 18;
294     }
295 
296     /**
297      * @dev See {IERC20-totalSupply}.
298      */
299     function totalSupply() public view virtual override returns (uint256) {
300         return _totalSupply;
301     }
302 
303     /**
304      * @dev See {IERC20-balanceOf}.
305      */
306     function balanceOf(address account) public view virtual override returns (uint256) {
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
318     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
319         _transfer(_msgSender(), recipient, amount);
320         return true;
321     }
322 
323     /**
324      * @dev See {IERC20-allowance}.
325      */
326     function allowance(address owner, address spender) public view virtual override returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     /**
331      * @dev See {IERC20-approve}.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function approve(address spender, uint256 amount) public virtual override returns (bool) {
338         _approve(_msgSender(), spender, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-transferFrom}.
344      *
345      * Emits an {Approval} event indicating the updated allowance. This is not
346      * required by the EIP. See the note at the beginning of {ERC20}.
347      *
348      * Requirements:
349      *
350      * - `sender` and `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      * - the caller must have allowance for ``sender``'s tokens of at least
353      * `amount`.
354      */
355     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
356         _transfer(sender, recipient, amount);
357 
358         uint256 currentAllowance = _allowances[sender][_msgSender()];
359         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
360         _approve(sender, _msgSender(), currentAllowance - amount);
361 
362         return true;
363     }
364 
365     /**
366      * @dev Atomically increases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to {approve} that can be used as a mitigation for
369      * problems described in {IERC20-approve}.
370      *
371      * Emits an {Approval} event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
379         return true;
380     }
381 
382     /**
383      * @dev Atomically decreases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      * - `spender` must have allowance for the caller of at least
394      * `subtractedValue`.
395      */
396     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
397         uint256 currentAllowance = _allowances[_msgSender()][spender];
398         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
399         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
400 
401         return true;
402     }
403 
404     /**
405      * @dev Moves tokens `amount` from `sender` to `recipient`.
406      *
407      * This is internal function is equivalent to {transfer}, and can be used to
408      * e.g. implement automatic token fees, slashing mechanisms, etc.
409      *
410      * Emits a {Transfer} event.
411      *
412      * Requirements:
413      *
414      * - `sender` cannot be the zero address.
415      * - `recipient` cannot be the zero address.
416      * - `sender` must have a balance of at least `amount`.
417      */
418     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
419         require(sender != address(0), "ERC20: transfer from the zero address");
420         require(recipient != address(0), "ERC20: transfer to the zero address");
421 
422         _beforeTokenTransfer(sender, recipient, amount);
423 
424         uint256 senderBalance = _balances[sender];
425         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
426         _balances[sender] = senderBalance - amount;
427         _balances[recipient] += amount;
428 
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal virtual {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _beforeTokenTransfer(address(0), account, amount);
445 
446         _totalSupply += amount;
447         _balances[account] += amount;
448         emit Transfer(address(0), account, amount);
449     }
450 
451     /**
452      * @dev Destroys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a {Transfer} event with `to` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 amount) internal virtual {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _beforeTokenTransfer(account, address(0), amount);
466 
467         uint256 accountBalance = _balances[account];
468         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
469         _balances[account] = accountBalance - amount;
470         _totalSupply -= amount;
471 
472         emit Transfer(account, address(0), amount);
473     }
474 
475     /**
476      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
477      *
478      * This internal function is equivalent to `approve`, and can be used to
479      * e.g. set automatic allowances for certain subsystems, etc.
480      *
481      * Emits an {Approval} event.
482      *
483      * Requirements:
484      *
485      * - `owner` cannot be the zero address.
486      * - `spender` cannot be the zero address.
487      */
488     function _approve(address owner, address spender, uint256 amount) internal virtual {
489         require(owner != address(0), "ERC20: approve from the zero address");
490         require(spender != address(0), "ERC20: approve to the zero address");
491 
492         _allowances[owner][spender] = amount;
493         emit Approval(owner, spender, amount);
494     }
495 
496     /**
497      * @dev Hook that is called before any transfer of tokens. This includes
498      * minting and burning.
499      *
500      * Calling conditions:
501      *
502      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
503      * will be to transferred to `to`.
504      * - when `from` is zero, `amount` tokens will be minted for `to`.
505      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
506      * - `from` and `to` are never both zero.
507      *
508      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
509      */
510     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
511 }
512 
513 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
522  */
523 abstract contract ERC20Capped is ERC20 {
524     uint256 immutable private _cap;
525 
526     /**
527      * @dev Sets the value of the `cap`. This value is immutable, it can only be
528      * set once during construction.
529      */
530     constructor (uint256 cap_) {
531         require(cap_ > 0, "ERC20Capped: cap is 0");
532         _cap = cap_;
533     }
534 
535     /**
536      * @dev Returns the cap on the token's total supply.
537      */
538     function cap() public view virtual returns (uint256) {
539         return _cap;
540     }
541 
542     /**
543      * @dev See {ERC20-_mint}.
544      */
545     function _mint(address account, uint256 amount) internal virtual override {
546         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
547         super._mint(account, amount);
548     }
549 }
550 
551 // File: contracts/libraries/SafeMath.sol
552 
553 
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Wrappers over Solidity's arithmetic operations with added overflow
559  * checks.
560  *
561  * Arithmetic operations in Solidity wrap on overflow. This can easily result
562  * in bugs, because programmers usually assume that an overflow raises an
563  * error, which is the standard behavior in high level programming languages.
564  * `SafeMath` restores this intuition by reverting the transaction when an
565  * operation overflows.
566  *
567  * Using this library instead of the unchecked operations eliminates an entire
568  * class of bugs, so it's recommended to use it always.
569  */
570 
571 library SafeMath {
572     /**
573      * @dev Returns the addition of two unsigned integers, with an overflow flag.
574      *
575      * _Available since v3.4._
576      */
577     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
578         uint256 c = a + b;
579         if (c < a) return (false, 0);
580         return (true, c);
581     }
582 
583     /**
584      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
585      *
586      * _Available since v3.4._
587      */
588     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
589         if (b > a) return (false, 0);
590         return (true, a - b);
591     }
592 
593     /**
594      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
595      *
596      * _Available since v3.4._
597      */
598     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
599         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
600         // benefit is lost if 'b' is also tested.
601         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
602         if (a == 0) return (true, 0);
603         uint256 c = a * b;
604         if (c / a != b) return (false, 0);
605         return (true, c);
606     }
607 
608     /**
609      * @dev Returns the division of two unsigned integers, with a division by zero flag.
610      *
611      * _Available since v3.4._
612      */
613     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
614         if (b == 0) return (false, 0);
615         return (true, a / b);
616     }
617 
618     /**
619      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
620      *
621      * _Available since v3.4._
622      */
623     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
624         if (b == 0) return (false, 0);
625         return (true, a % b);
626     }
627 
628     /**
629      * @dev Returns the addition of two unsigned integers, reverting on
630      * overflow.
631      *
632      * Counterpart to Solidity's `+` operator.
633      *
634      * Requirements:
635      *
636      * - Addition cannot overflow.
637      */
638     function add(uint256 a, uint256 b) internal pure returns (uint256) {
639         uint256 c = a + b;
640         require(c >= a, "SafeMath: addition overflow");
641         return c;
642     }
643 
644     /**
645      * @dev Returns the subtraction of two unsigned integers, reverting on
646      * overflow (when the result is negative).
647      *
648      * Counterpart to Solidity's `-` operator.
649      *
650      * Requirements:
651      *
652      * - Subtraction cannot overflow.
653      */
654     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
655         require(b <= a, "SafeMath: subtraction overflow");
656         return a - b;
657     }
658 
659     /**
660      * @dev Returns the multiplication of two unsigned integers, reverting on
661      * overflow.
662      *
663      * Counterpart to Solidity's `*` operator.
664      *
665      * Requirements:
666      *
667      * - Multiplication cannot overflow.
668      */
669     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
670         if (a == 0) return 0;
671         uint256 c = a * b;
672         require(c / a == b, "SafeMath: multiplication overflow");
673         return c;
674     }
675 
676     /**
677      * @dev Returns the integer division of two unsigned integers, reverting on
678      * division by zero. The result is rounded towards zero.
679      *
680      * Counterpart to Solidity's `/` operator. Note: this function uses a
681      * `revert` opcode (which leaves remaining gas untouched) while Solidity
682      * uses an invalid opcode to revert (consuming all remaining gas).
683      *
684      * Requirements:
685      *
686      * - The divisor cannot be zero.
687      */
688     function div(uint256 a, uint256 b) internal pure returns (uint256) {
689         require(b > 0, "SafeMath: division by zero");
690         return a / b;
691     }
692 
693     /**
694      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
695      * reverting when dividing by zero.
696      *
697      * Counterpart to Solidity's `%` operator. This function uses a `revert`
698      * opcode (which leaves remaining gas untouched) while Solidity uses an
699      * invalid opcode to revert (consuming all remaining gas).
700      *
701      * Requirements:
702      *
703      * - The divisor cannot be zero.
704      */
705     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
706         require(b > 0, "SafeMath: modulo by zero");
707         return a % b;
708     }
709 
710     /**
711      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
712      * overflow (when the result is negative).
713      *
714      * CAUTION: This function is deprecated because it requires allocating memory for the error
715      * message unnecessarily. For custom revert reasons use {trySub}.
716      *
717      * Counterpart to Solidity's `-` operator.
718      *
719      * Requirements:
720      *
721      * - Subtraction cannot overflow.
722      */
723     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
724         require(b <= a, errorMessage);
725         return a - b;
726     }
727 
728     /**
729      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
730      * division by zero. The result is rounded towards zero.
731      *
732      * CAUTION: This function is deprecated because it requires allocating memory for the error
733      * message unnecessarily. For custom revert reasons use {tryDiv}.
734      *
735      * Counterpart to Solidity's `/` operator. Note: this function uses a
736      * `revert` opcode (which leaves remaining gas untouched) while Solidity
737      * uses an invalid opcode to revert (consuming all remaining gas).
738      *
739      * Requirements:
740      *
741      * - The divisor cannot be zero.
742      */
743     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
744         require(b > 0, errorMessage);
745         return a / b;
746     }
747 
748     /**
749      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
750      * reverting with custom message when dividing by zero.
751      *
752      * CAUTION: This function is deprecated because it requires allocating memory for the error
753      * message unnecessarily. For custom revert reasons use {tryMod}.
754      *
755      * Counterpart to Solidity's `%` operator. This function uses a `revert`
756      * opcode (which leaves remaining gas untouched) while Solidity uses an
757      * invalid opcode to revert (consuming all remaining gas).
758      *
759      * Requirements:
760      *
761      * - The divisor cannot be zero.
762      */
763     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
764         require(b > 0, errorMessage);
765         return a % b;
766     }
767 }
768 
769 // File: contracts/SpheriumToken.sol
770 
771 
772 pragma solidity ^0.8.0;
773 
774 
775 
776 
777 
778 
779 
780 pragma solidity ^0.8.0;
781 
782 interface ILiquidityProtectionService {
783     event Blocked(address pool, address trader, string trap);
784 
785     function getLiquidityPool(address tokenA, address tokenB)
786     external view returns(address);
787 
788     function LiquidityAmountTrap_preValidateTransfer(
789         address from, address to, uint amount,
790         address counterToken, uint8 trapBlocks, uint128 trapAmount)
791     external returns(bool passed);
792 
793     function FirstBlockTrap_preValidateTransfer(
794         address from, address to, uint amount, address counterToken)
795     external returns(bool passed);
796 
797     function LiquidityPercentTrap_preValidateTransfer(
798         address from, address to, uint amount,
799         address counterToken, uint8 trapBlocks, uint64 trapPercent)
800     external returns(bool passed);
801 
802     function LiquidityActivityTrap_preValidateTransfer(
803         address from, address to, uint amount,
804         address counterToken, uint8 trapBlocks, uint8 trapCount)
805     external returns(bool passed);
806 
807     function isBlocked(address counterToken, address who)
808     external view returns(bool);
809 }
810 
811 
812 
813 
814 pragma solidity ^0.8.0;
815 
816 abstract contract UsingLiquidityProtectionService {
817     bool private protected = true;
818     uint64 internal constant HUNDRED_PERCENT = 1e18;
819 
820     function liquidityProtectionService() internal pure virtual returns(address);
821     function LPS_isAdmin() internal view virtual returns(bool);
822     function LPS_balanceOf(address _holder) internal view virtual returns(uint);
823     function LPS_transfer(address _from, address _to, uint _value) internal virtual;
824     function counterToken() internal pure virtual returns(address) {
825         return 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
826     }
827     function protectionChecker() internal view virtual returns(bool) {
828         return ProtectionSwitch_manual();
829     }
830 
831     function FirstBlockTrap_skip() internal pure virtual returns(bool) {
832         return false;
833     }
834 
835     function LiquidityAmountTrap_skip() internal pure virtual returns(bool) {
836         return false;
837     }
838     function LiquidityAmountTrap_blocks() internal pure virtual returns(uint8) {
839         return 5;
840     }
841     function LiquidityAmountTrap_amount() internal pure virtual returns(uint128) {
842         return 5000 * 1e18; // Only valid for tokens with 18 decimals.
843     }
844 
845     function LiquidityPercentTrap_skip() internal pure virtual returns(bool) {
846         return false;
847     }
848     function LiquidityPercentTrap_blocks() internal pure virtual returns(uint8) {
849         return 50;
850     }
851     function LiquidityPercentTrap_percent() internal pure virtual returns(uint64) {
852         return HUNDRED_PERCENT / 1000; // 0.1%
853     }
854 
855     function LiquidityActivityTrap_skip() internal pure virtual returns(bool) {
856         return false;
857     }
858     function LiquidityActivityTrap_blocks() internal pure virtual returns(uint8) {
859         return 30;
860     }
861     function LiquidityActivityTrap_count() internal pure virtual returns(uint8) {
862         return 15;
863     }
864 
865     function lps() private pure returns(ILiquidityProtectionService) {
866         return ILiquidityProtectionService(liquidityProtectionService());
867     }
868 
869     function LPS_beforeTokenTransfer(address _from, address _to, uint _amount) internal {
870         if (protectionChecker()) {
871             if (!protected) {
872                 return;
873             }
874             require(FirstBlockTrap_skip() || lps().FirstBlockTrap_preValidateTransfer(
875                 _from, _to, _amount, counterToken()), 'FirstBlockTrap: blocked');
876             require(LiquidityAmountTrap_skip() || lps().LiquidityAmountTrap_preValidateTransfer(
877                 _from,
878                 _to,
879                 _amount,
880                 counterToken(),
881                 LiquidityAmountTrap_blocks(),
882                 LiquidityAmountTrap_amount()), 'LiquidityAmountTrap: blocked');
883             require(LiquidityPercentTrap_skip() || lps().LiquidityPercentTrap_preValidateTransfer(
884                 _from,
885                 _to,
886                 _amount,
887                 counterToken(),
888                 LiquidityPercentTrap_blocks(),
889                 LiquidityPercentTrap_percent()), 'LiquidityPercentTrap: blocked');
890             require(LiquidityActivityTrap_skip() || lps().LiquidityActivityTrap_preValidateTransfer(
891                 _from,
892                 _to,
893                 _amount,
894                 counterToken(),
895                 LiquidityActivityTrap_blocks(),
896                 LiquidityActivityTrap_count()), 'LiquidityActivityTrap: blocked');
897         }
898     }
899 
900     function revokeBlocked(address[] calldata _holders, address _revokeTo) external {
901         require(LPS_isAdmin(), 'UsingLiquidityProtectionService: not admin');
902         require(protectionChecker(), 'UsingLiquidityProtectionService: protection removed');
903         protected = false;
904         for (uint i = 0; i < _holders.length; i++) {
905             address holder = _holders[i];
906             if (lps().isBlocked(counterToken(), _holders[i])) {
907                 LPS_transfer(holder, _revokeTo, LPS_balanceOf(holder));
908             }
909         }
910         protected = true;
911     }
912 
913     function disableProtection() external {
914         require(LPS_isAdmin(), 'UsingLiquidityProtectionService: not admin');
915         protected = false;
916     }
917 
918     function isProtected() public view returns(bool) {
919         return protected;
920     }
921 
922     function ProtectionSwitch_manual() internal view returns(bool) {
923         return protected;
924     }
925 
926     function ProtectionSwitch_timestamp(uint _timestamp) internal view returns(bool) {
927         return not(passed(_timestamp));
928     }
929 
930     function ProtectionSwitch_block(uint _block) internal view returns(bool) {
931         return not(blockPassed(_block));
932     }
933 
934     function blockPassed(uint _block) internal view returns(bool) {
935         return _block < block.number;
936     }
937 
938     function passed(uint _timestamp) internal view returns(bool) {
939         return _timestamp < block.timestamp;
940     }
941 
942     function not(bool _condition) internal pure returns(bool) {
943         return !_condition;
944     }
945 }
946 
947 
948 
949 
950 
951 
952 contract spheriumToken is ERC20, ERC20Capped, Ownable, UsingLiquidityProtectionService{
953 
954     using SafeMath for uint256;
955 
956     /// @dev A record of each accounts delegate
957     mapping (address => address) internal _delegates;
958 
959     /// @notice A checkpoint for marking number of votes from a given block
960     struct Checkpoint {
961         uint32 fromBlock;
962         uint256 votes;
963     }
964 
965     /// @notice A record of votes checkpoints for each account, by index
966     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
967 
968     /// @notice The number of checkpoints for each account
969     mapping (address => uint32) public numCheckpoints;
970 
971     /// @notice The EIP-712 typehash for the contract's domain
972     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
973 
974     /// @notice The EIP-712 typehash for the delegation struct used by the contract
975     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
976 
977     /// @notice A record of states for signing / validating signatures
978     mapping (address => uint) public nonces;
979 
980       /// @notice An event thats emitted when an account changes its delegate
981     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
982 
983     /// @notice An event thats emitted when a delegate account's vote balance changes
984     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
985 
986 
987 
988     constructor() ERC20("Spherium Token", "SPHRI") ERC20Capped(100000000 * (10**uint256(18))){}
989 
990      function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
991         super._mint(account, amount);
992     }
993 
994 
995     function mint(address account, uint256 amount)public onlyOwner{
996         uint256 amount_ = amount * (10**uint256(18));
997         _mint(account,amount_);
998     }
999 
1000         /**
1001      * @dev Moves tokens `amount` from `sender` to `recipient`.
1002      *
1003      * This is internal function is equivalent to {transfer}, and can be used to
1004      * e.g. implement automatic token fees, slashing mechanisms, etc.
1005      *
1006      * Emits a {Transfer} event.
1007      *
1008      * Requirements:
1009      *
1010      * - `sender` cannot be the zero address.
1011      * - `recipient` cannot be the zero address.
1012      * - `sender` must have a balance of at least `amount`.
1013      */
1014     function _transfer(address sender, address recipient, uint256 amount) internal override {
1015         super._transfer(sender,recipient,amount);
1016         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1017 
1018     }
1019 
1020     /**
1021      * @notice Delegate votes from `msg.sender` to `delegatee`
1022      * @param delegator The address to get delegatee for
1023      */
1024     function delegates(address delegator)
1025         external
1026         view
1027         returns (address)
1028     {
1029         return _delegates[delegator];
1030     }
1031 
1032     /**
1033     * @notice Delegate votes from `msg.sender` to `delegatee`
1034     * @param delegatee The address to delegate votes to
1035     */
1036     function delegate(address delegatee) external {
1037         return _delegate(msg.sender, delegatee);
1038     }
1039 
1040     /**
1041      * @notice Delegates votes from signatory to `delegatee`
1042      * @param delegatee The address to delegate votes to
1043      * @param nonce The contract state required to match the signature
1044      * @param expiry The time at which to expire the signature
1045      * @param v The recovery byte of the signature
1046      * @param r Half of the ECDSA signature pair
1047      * @param s Half of the ECDSA signature pair
1048      */
1049     function delegateBySig(
1050         address delegatee,
1051         uint nonce,
1052         uint expiry,
1053         uint8 v,
1054         bytes32 r,
1055         bytes32 s
1056     )
1057         external
1058     {
1059         bytes32 domainSeparator = keccak256(
1060             abi.encode(
1061                 DOMAIN_TYPEHASH,
1062                 keccak256(bytes(name())),
1063                 getChainId(),
1064                 address(this)
1065             )
1066         );
1067 
1068         bytes32 structHash = keccak256(
1069             abi.encode(
1070                 DELEGATION_TYPEHASH,
1071                 delegatee,
1072                 nonce,
1073                 expiry
1074             )
1075         );
1076 
1077         bytes32 digest = keccak256(
1078             abi.encodePacked(
1079                 "\x19\x01",
1080                 domainSeparator,
1081                 structHash
1082             )
1083         );
1084 
1085         address signatory = ecrecover(digest, v, r, s);
1086         require(signatory != address(0), "SPHRI::delegateBySig: invalid signature");
1087         require(nonce == nonces[signatory]++, "SPHRI::delegateBySig: invalid nonce");
1088         require(block.timestamp <= expiry, "SPHRI::delegateBySig: signature expired");
1089         return _delegate(signatory, delegatee);
1090     }
1091 
1092     /**
1093      * @notice Gets the current votes balance for `account`
1094      * @param account The address to get votes balance
1095      * @return The number of current votes for `account`
1096      */
1097     function getCurrentVotes(address account)
1098         external
1099         view
1100         returns (uint256)
1101     {
1102         uint32 nCheckpoints = numCheckpoints[account];
1103         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1104     }
1105 
1106     /**
1107      * @notice Determine the prior number of votes for an account as of a block number
1108      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1109      * @param account The address of the account to check
1110      * @param blockNumber The block number to get the vote balance at
1111      * @return The number of votes the account had as of the given block
1112      */
1113     function getPriorVotes(address account, uint blockNumber)
1114         external
1115         view
1116         returns (uint256)
1117     {
1118         require(blockNumber < block.number, "SPHRI::getPriorVotes: not yet determined");
1119 
1120         uint32 nCheckpoints = numCheckpoints[account];
1121         if (nCheckpoints == 0) {
1122             return 0;
1123         }
1124 
1125         // First check most recent balance
1126         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1127             return checkpoints[account][nCheckpoints - 1].votes;
1128         }
1129 
1130         // Next check implicit zero balance
1131         if (checkpoints[account][0].fromBlock > blockNumber) {
1132             return 0;
1133         }
1134 
1135         uint32 lower = 0;
1136         uint32 upper = nCheckpoints - 1;
1137         while (upper > lower) {
1138             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1139             Checkpoint memory cp = checkpoints[account][center];
1140             if (cp.fromBlock == blockNumber) {
1141                 return cp.votes;
1142             } else if (cp.fromBlock < blockNumber) {
1143                 lower = center;
1144             } else {
1145                 upper = center - 1;
1146             }
1147         }
1148         return checkpoints[account][lower].votes;
1149     }
1150 
1151     function _delegate(address delegator, address delegatee)
1152         internal
1153     {
1154         address currentDelegate = _delegates[delegator];
1155         uint256 delegatorBalance = balanceOf(delegator);
1156         _delegates[delegator] = delegatee;
1157 
1158         emit DelegateChanged(delegator, currentDelegate, delegatee);
1159 
1160         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1161     }
1162 
1163     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1164         if (srcRep != dstRep && amount > 0) {
1165             if (srcRep != address(0)) {
1166                 // decrease old representative
1167                 uint32 srcRepNum = numCheckpoints[srcRep];
1168                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1169                 uint256 srcRepNew = srcRepOld.sub(amount);
1170                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1171             }
1172 
1173             if (dstRep != address(0)) {
1174                 // increase new representative
1175                 uint32 dstRepNum = numCheckpoints[dstRep];
1176                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1177                 uint256 dstRepNew = dstRepOld.add(amount);
1178                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1179             }
1180         }
1181     }
1182 
1183     function _writeCheckpoint(
1184         address delegatee,
1185         uint32 nCheckpoints,
1186         uint256 oldVotes,
1187         uint256 newVotes
1188     )
1189         internal
1190     {
1191         uint32 blockNumber = safe32(block.number, "SPHRI::_writeCheckpoint: block number exceeds 32 bits");
1192 
1193         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1194             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1195         } else {
1196             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1197             numCheckpoints[delegatee] = nCheckpoints + 1;
1198         }
1199 
1200         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1201     }
1202 
1203     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1204         require(n < 2**32, errorMessage);
1205         return uint32(n);
1206     }
1207 
1208     function getChainId() internal view returns (uint) {
1209         uint256 chainId;
1210         assembly { chainId := chainid() }
1211         return chainId;
1212     }
1213 
1214 
1215 
1216     // Mandatory overrides.
1217     function _beforeTokenTransfer(address _from, address _to, uint _amount) internal override {
1218         super._beforeTokenTransfer(_from, _to, _amount);
1219         LPS_beforeTokenTransfer(_from, _to, _amount);
1220     }
1221 
1222     function LPS_isAdmin() internal view override returns(bool) {
1223         return _msgSender() == owner();
1224     }
1225     function liquidityProtectionService() internal pure override returns(address) {
1226         return 0xaabAe39230233d4FaFf04111EF08665880BD6dFb; // Replace with the correct address.
1227     }
1228     // Expose balanceOf().
1229     function LPS_balanceOf(address _holder) internal view override returns(uint) {
1230         return balanceOf(_holder);
1231     }
1232     // Expose internal transfer function.
1233     function LPS_transfer(address _from, address _to, uint _value) internal override {
1234         _transfer(_from, _to, _value);
1235     }
1236     // All the following overrides are optional, if you want to modify default behavior.
1237 
1238     // How the protection gets disabled.
1239     function protectionChecker() internal view override returns(bool) {
1240         return ProtectionSwitch_timestamp(1624665599); // Switch off protection on Friday, June 25, 2021 11:59:59 PM GMT
1241         // return ProtectionSwitch_block(13000000); // Switch off protection on block 13000000.
1242         //return ProtectionSwitch_manual(); // Switch off protection by calling disableProtection(); from owner. Default.
1243     }
1244 
1245     // This token will be pooled in pair with:
1246     function counterToken() internal pure override returns(address) {
1247         return 0xdAC17F958D2ee523a2206206994597C13D831ec7; // USDT
1248     }
1249 
1250     // Disable/Enable FirstBlockTrap
1251     function FirstBlockTrap_skip() internal pure override returns(bool) {
1252         return false;
1253     }
1254 
1255     // Disable/Enable absolute amount of tokens bought trap.
1256     // Per address per LiquidityAmountTrap_blocks.
1257     function LiquidityAmountTrap_skip() internal pure override returns(bool) {
1258         return false;
1259     }
1260     function LiquidityAmountTrap_blocks() internal pure override returns(uint8) {
1261         return 4;
1262     }
1263     function LiquidityAmountTrap_amount() internal pure override returns(uint128) {
1264         return 19000 * 1e18; // Only valid for tokens with 18 decimals.
1265     }
1266 
1267     // Disable/Enable percent of remaining liquidity bought trap.
1268     // Per address per block.
1269     function LiquidityPercentTrap_skip() internal pure override returns(bool) {
1270         return false;
1271     }
1272     function LiquidityPercentTrap_blocks() internal pure override returns(uint8) {
1273         return 6;
1274     }
1275     function LiquidityPercentTrap_percent() internal pure override returns(uint64) {
1276         return HUNDRED_PERCENT / 25; // 4%
1277     }
1278 
1279     // Disable/Enable number of trades trap.
1280     // Per block.
1281     function LiquidityActivityTrap_skip() internal pure override returns(bool) {
1282         return false;
1283     }
1284     function LiquidityActivityTrap_blocks() internal pure override returns(uint8) {
1285         return 3;
1286     }
1287     function LiquidityActivityTrap_count() internal pure override returns(uint8) {
1288         return 8;
1289     }
1290 
1291 }