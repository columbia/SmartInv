1 /**
2 
3 Website: https://www.studentinu.com
4 Twitter: @StudentInu
5 Telegram: https://t.me/StudentInuOfficial
6 
7      _.-'`'-._
8    .-'    _    '-.
9     `-.__  `\_.-'   _________
10       |  `-``\|    (@)__))___)
11       `-.....-A         \\
12               #          ^
13               #
14 
15   _   _      _       _                   
16  | | | | ___| |_ __ (_)_ __   __ _       
17  | |_| |/ _ \ | '_ \| | '_ \ / _` |      
18  |  _  |  __/ | |_) | | | | | (_| |      
19  |_| |_|\___|_| .__/|_|_| |_|\__, |      
20       _       |_|   _        |___/       
21   ___| |_ _   _  __| | ___ _ __ | |_ ___ 
22  / __| __| | | |/ _` |/ _ \ '_ \| __/ __|
23  \__ \ |_| |_| | (_| |  __/ | | | |_\__ \
24  |___/\__|\__,_|\__,_|\___|_| |_|\__|___/
25 
26 
27 */
28 
29 // SPDX-License-Identifier: MIT
30 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
31 pragma experimental ABIEncoderV2;
32 
33 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
34 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
35 
36 /* pragma solidity ^0.8.0; */
37 
38 /**
39  * @dev Provides information about the current execution context, including the
40  * sender of the transaction and its data. While these are generally available
41  * via msg.sender and msg.data, they should not be accessed in such a direct
42  * manner, since when dealing with meta-transactions the account sending and
43  * paying for execution may not be the actual sender (as far as an application
44  * is concerned).
45  *
46  * This contract is only required for intermediate, library-like contracts.
47  */
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes calldata) {
54         return msg.data;
55     }
56 }
57 
58 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
59 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
60 
61 /* pragma solidity ^0.8.0; */
62 
63 /* import "../utils/Context.sol"; */
64 
65 /**
66  * @dev Contract module which provides a basic access control mechanism, where
67  * there is an account (an owner) that can be granted exclusive access to
68  * specific functions.
69  *
70  * By default, the owner account will be the one that deploys the contract. This
71  * can later be changed with {transferOwnership}.
72  *
73  * This module is used through inheritance. It will make available the modifier
74  * `onlyOwner`, which can be applied to your functions to restrict their use to
75  * the owner.
76  */
77 abstract contract Ownable is Context {
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev Initializes the contract setting the deployer as the initial owner.
84      */
85     constructor() {
86         _transferOwnership(_msgSender());
87     }
88 
89     /**
90      * @dev Returns the address of the current owner.
91      */
92     function owner() public view virtual returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     /**
105      * @dev Leaves the contract without owner. It will not be possible to call
106      * `onlyOwner` functions anymore. Can only be called by the current owner.
107      *
108      * NOTE: Renouncing ownership will leave the contract without an owner,
109      * thereby removing any functionality that is only available to the owner.
110      */
111     function renounceOwnership() public virtual onlyOwner {
112         _transferOwnership(address(0));
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Can only be called by the current owner.
118      */
119     function transferOwnership(address newOwner) public virtual onlyOwner {
120         require(newOwner != address(0), "Ownable: new owner is the zero address");
121         _transferOwnership(newOwner);
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Internal function without access restriction.
127      */
128     function _transferOwnership(address newOwner) internal virtual {
129         address oldOwner = _owner;
130         _owner = newOwner;
131         emit OwnershipTransferred(oldOwner, newOwner);
132     }
133 }
134 
135 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
136 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
137 
138 /* pragma solidity ^0.8.0; */
139 
140 /**
141  * @dev Interface of the ERC20 standard as defined in the EIP.
142  */
143 interface IERC20 {
144     /**
145      * @dev Returns the amount of tokens in existence.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     /**
150      * @dev Returns the amount of tokens owned by `account`.
151      */
152     function balanceOf(address account) external view returns (uint256);
153 
154     /**
155      * @dev Moves `amount` tokens from the caller's account to `recipient`.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through {transferFrom}. This is
166      * zero by default.
167      *
168      * This value changes when {approve} or {transferFrom} are called.
169      */
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * IMPORTANT: Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an {Approval} event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `sender` to `recipient` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) external returns (bool);
202 
203     /**
204      * @dev Emitted when `value` tokens are moved from one account (`from`) to
205      * another (`to`).
206      *
207      * Note that `value` may be zero.
208      */
209     event Transfer(address indexed from, address indexed to, uint256 value);
210 
211     /**
212      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
213      * a call to {approve}. `value` is the new allowance.
214      */
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
219 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
220 
221 /* pragma solidity ^0.8.0; */
222 
223 /* import "../IERC20.sol"; */
224 
225 /**
226  * @dev Interface for the optional metadata functions from the ERC20 standard.
227  *
228  * _Available since v4.1._
229  */
230 interface IERC20Metadata is IERC20 {
231     /**
232      * @dev Returns the name of the token.
233      */
234     function name() external view returns (string memory);
235 
236     /**
237      * @dev Returns the symbol of the token.
238      */
239     function symbol() external view returns (string memory);
240 
241     /**
242      * @dev Returns the decimals places of the token.
243      */
244     function decimals() external view returns (uint8);
245 }
246 
247 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
248 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
249 
250 /* pragma solidity ^0.8.0; */
251 
252 /* import "./IERC20.sol"; */
253 /* import "./extensions/IERC20Metadata.sol"; */
254 /* import "../../utils/Context.sol"; */
255 
256 /**
257  * @dev Implementation of the {IERC20} interface.
258  *
259  * This implementation is agnostic to the way tokens are created. This means
260  * that a supply mechanism has to be added in a derived contract using {_mint}.
261  * For a generic mechanism see {ERC20PresetMinterPauser}.
262  *
263  * TIP: For a detailed writeup see our guide
264  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
265  * to implement supply mechanisms].
266  *
267  * We have followed general OpenZeppelin Contracts guidelines: functions revert
268  * instead returning `false` on failure. This behavior is nonetheless
269  * conventional and does not conflict with the expectations of ERC20
270  * applications.
271  *
272  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
273  * This allows applications to reconstruct the allowance for all accounts just
274  * by listening to said events. Other implementations of the EIP may not emit
275  * these events, as it isn't required by the specification.
276  *
277  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
278  * functions have been added to mitigate the well-known issues around setting
279  * allowances. See {IERC20-approve}.
280  */
281 contract ERC20 is Context, IERC20, IERC20Metadata {
282     mapping(address => uint256) private _balances;
283 
284     mapping(address => mapping(address => uint256)) private _allowances;
285 
286     uint256 private _totalSupply;
287 
288     string private _name;
289     string private _symbol;
290 
291     /**
292      * @dev Sets the values for {name} and {symbol}.
293      *
294      * The default value of {decimals} is 18. To select a different value for
295      * {decimals} you should overload it.
296      *
297      * All two of these values are immutable: they can only be set once during
298      * construction.
299      */
300     constructor(string memory name_, string memory symbol_) {
301         _name = name_;
302         _symbol = symbol_;
303     }
304 
305     /**
306      * @dev Returns the name of the token.
307      */
308     function name() public view virtual override returns (string memory) {
309         return _name;
310     }
311 
312     /**
313      * @dev Returns the symbol of the token, usually a shorter version of the
314      * name.
315      */
316     function symbol() public view virtual override returns (string memory) {
317         return _symbol;
318     }
319 
320     /**
321      * @dev Returns the number of decimals used to get its user representation.
322      * For example, if `decimals` equals `2`, a balance of `505` tokens should
323      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
324      *
325      * Tokens usually opt for a value of 18, imitating the relationship between
326      * Ether and Wei. This is the value {ERC20} uses, unless this function is
327      * overridden;
328      *
329      * NOTE: This information is only used for _display_ purposes: it in
330      * no way affects any of the arithmetic of the contract, including
331      * {IERC20-balanceOf} and {IERC20-transfer}.
332      */
333     function decimals() public view virtual override returns (uint8) {
334         return 18;
335     }
336 
337     /**
338      * @dev See {IERC20-totalSupply}.
339      */
340     function totalSupply() public view virtual override returns (uint256) {
341         return _totalSupply;
342     }
343 
344     /**
345      * @dev See {IERC20-balanceOf}.
346      */
347     function balanceOf(address account) public view virtual override returns (uint256) {
348         return _balances[account];
349     }
350 
351     /**
352      * @dev See {IERC20-transfer}.
353      *
354      * Requirements:
355      *
356      * - `recipient` cannot be the zero address.
357      * - the caller must have a balance of at least `amount`.
358      */
359     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
360         _transfer(_msgSender(), recipient, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-allowance}.
366      */
367     function allowance(address owner, address spender) public view virtual override returns (uint256) {
368         return _allowances[owner][spender];
369     }
370 
371     /**
372      * @dev See {IERC20-approve}.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      */
378     function approve(address spender, uint256 amount) public virtual override returns (bool) {
379         _approve(_msgSender(), spender, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-transferFrom}.
385      *
386      * Emits an {Approval} event indicating the updated allowance. This is not
387      * required by the EIP. See the note at the beginning of {ERC20}.
388      *
389      * Requirements:
390      *
391      * - `sender` and `recipient` cannot be the zero address.
392      * - `sender` must have a balance of at least `amount`.
393      * - the caller must have allowance for ``sender``'s tokens of at least
394      * `amount`.
395      */
396     function transferFrom(
397         address sender,
398         address recipient,
399         uint256 amount
400     ) public virtual override returns (bool) {
401         _transfer(sender, recipient, amount);
402 
403         uint256 currentAllowance = _allowances[sender][_msgSender()];
404         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
405         unchecked {
406             _approve(sender, _msgSender(), currentAllowance - amount);
407         }
408 
409         return true;
410     }
411 
412     /**
413      * @dev Atomically increases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      */
424     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
425         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
426         return true;
427     }
428 
429     /**
430      * @dev Atomically decreases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to {approve} that can be used as a mitigation for
433      * problems described in {IERC20-approve}.
434      *
435      * Emits an {Approval} event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      * - `spender` must have allowance for the caller of at least
441      * `subtractedValue`.
442      */
443     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
444         uint256 currentAllowance = _allowances[_msgSender()][spender];
445         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
446         unchecked {
447             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
448         }
449 
450         return true;
451     }
452 
453     /**
454      * @dev Moves `amount` of tokens from `sender` to `recipient`.
455      *
456      * This internal function is equivalent to {transfer}, and can be used to
457      * e.g. implement automatic token fees, slashing mechanisms, etc.
458      *
459      * Emits a {Transfer} event.
460      *
461      * Requirements:
462      *
463      * - `sender` cannot be the zero address.
464      * - `recipient` cannot be the zero address.
465      * - `sender` must have a balance of at least `amount`.
466      */
467     function _transfer(
468         address sender,
469         address recipient,
470         uint256 amount
471     ) internal virtual {
472         require(sender != address(0), "ERC20: transfer from the zero address");
473         require(recipient != address(0), "ERC20: transfer to the zero address");
474 
475         _beforeTokenTransfer(sender, recipient, amount);
476 
477         uint256 senderBalance = _balances[sender];
478         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
479         unchecked {
480             _balances[sender] = senderBalance - amount;
481         }
482         _balances[recipient] += amount;
483 
484         emit Transfer(sender, recipient, amount);
485 
486         _afterTokenTransfer(sender, recipient, amount);
487     }
488 
489     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
490      * the total supply.
491      *
492      * Emits a {Transfer} event with `from` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `account` cannot be the zero address.
497      */
498     function _mint(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: mint to the zero address");
500 
501         _beforeTokenTransfer(address(0), account, amount);
502 
503         _totalSupply += amount;
504         _balances[account] += amount;
505         emit Transfer(address(0), account, amount);
506 
507         _afterTokenTransfer(address(0), account, amount);
508     }
509 
510     /**
511      * @dev Destroys `amount` tokens from `account`, reducing the
512      * total supply.
513      *
514      * Emits a {Transfer} event with `to` set to the zero address.
515      *
516      * Requirements:
517      *
518      * - `account` cannot be the zero address.
519      * - `account` must have at least `amount` tokens.
520      */
521     function _burn(address account, uint256 amount) internal virtual {
522         require(account != address(0), "ERC20: burn from the zero address");
523 
524         _beforeTokenTransfer(account, address(0), amount);
525 
526         uint256 accountBalance = _balances[account];
527         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
528         unchecked {
529             _balances[account] = accountBalance - amount;
530         }
531         _totalSupply -= amount;
532 
533         emit Transfer(account, address(0), amount);
534 
535         _afterTokenTransfer(account, address(0), amount);
536     }
537 
538     /**
539      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
540      *
541      * This internal function is equivalent to `approve`, and can be used to
542      * e.g. set automatic allowances for certain subsystems, etc.
543      *
544      * Emits an {Approval} event.
545      *
546      * Requirements:
547      *
548      * - `owner` cannot be the zero address.
549      * - `spender` cannot be the zero address.
550      */
551     function _approve(
552         address owner,
553         address spender,
554         uint256 amount
555     ) internal virtual {
556         require(owner != address(0), "ERC20: approve from the zero address");
557         require(spender != address(0), "ERC20: approve to the zero address");
558 
559         _allowances[owner][spender] = amount;
560         emit Approval(owner, spender, amount);
561     }
562 
563     /**
564      * @dev Hook that is called before any transfer of tokens. This includes
565      * minting and burning.
566      *
567      * Calling conditions:
568      *
569      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
570      * will be transferred to `to`.
571      * - when `from` is zero, `amount` tokens will be minted for `to`.
572      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
573      * - `from` and `to` are never both zero.
574      *
575      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
576      */
577     function _beforeTokenTransfer(
578         address from,
579         address to,
580         uint256 amount
581     ) internal virtual {}
582 
583     /**
584      * @dev Hook that is called after any transfer of tokens. This includes
585      * minting and burning.
586      *
587      * Calling conditions:
588      *
589      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
590      * has been transferred to `to`.
591      * - when `from` is zero, `amount` tokens have been minted for `to`.
592      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
593      * - `from` and `to` are never both zero.
594      *
595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
596      */
597     function _afterTokenTransfer(
598         address from,
599         address to,
600         uint256 amount
601     ) internal virtual {}
602 }
603 
604 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
605 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
606 
607 /* pragma solidity ^0.8.0; */
608 
609 // CAUTION
610 // This version of SafeMath should only be used with Solidity 0.8 or later,
611 // because it relies on the compiler's built in overflow checks.
612 
613 /**
614  * @dev Wrappers over Solidity's arithmetic operations.
615  *
616  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
617  * now has built in overflow checking.
618  */
619 library SafeMath {
620     /**
621      * @dev Returns the addition of two unsigned integers, with an overflow flag.
622      *
623      * _Available since v3.4._
624      */
625     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
626         unchecked {
627             uint256 c = a + b;
628             if (c < a) return (false, 0);
629             return (true, c);
630         }
631     }
632 
633     /**
634      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
635      *
636      * _Available since v3.4._
637      */
638     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
639         unchecked {
640             if (b > a) return (false, 0);
641             return (true, a - b);
642         }
643     }
644 
645     /**
646      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
647      *
648      * _Available since v3.4._
649      */
650     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
651         unchecked {
652             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
653             // benefit is lost if 'b' is also tested.
654             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
655             if (a == 0) return (true, 0);
656             uint256 c = a * b;
657             if (c / a != b) return (false, 0);
658             return (true, c);
659         }
660     }
661 
662     /**
663      * @dev Returns the division of two unsigned integers, with a division by zero flag.
664      *
665      * _Available since v3.4._
666      */
667     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
668         unchecked {
669             if (b == 0) return (false, 0);
670             return (true, a / b);
671         }
672     }
673 
674     /**
675      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
676      *
677      * _Available since v3.4._
678      */
679     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
680         unchecked {
681             if (b == 0) return (false, 0);
682             return (true, a % b);
683         }
684     }
685 
686     /**
687      * @dev Returns the addition of two unsigned integers, reverting on
688      * overflow.
689      *
690      * Counterpart to Solidity's `+` operator.
691      *
692      * Requirements:
693      *
694      * - Addition cannot overflow.
695      */
696     function add(uint256 a, uint256 b) internal pure returns (uint256) {
697         return a + b;
698     }
699 
700     /**
701      * @dev Returns the subtraction of two unsigned integers, reverting on
702      * overflow (when the result is negative).
703      *
704      * Counterpart to Solidity's `-` operator.
705      *
706      * Requirements:
707      *
708      * - Subtraction cannot overflow.
709      */
710     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
711         return a - b;
712     }
713 
714     /**
715      * @dev Returns the multiplication of two unsigned integers, reverting on
716      * overflow.
717      *
718      * Counterpart to Solidity's `*` operator.
719      *
720      * Requirements:
721      *
722      * - Multiplication cannot overflow.
723      */
724     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
725         return a * b;
726     }
727 
728     /**
729      * @dev Returns the integer division of two unsigned integers, reverting on
730      * division by zero. The result is rounded towards zero.
731      *
732      * Counterpart to Solidity's `/` operator.
733      *
734      * Requirements:
735      *
736      * - The divisor cannot be zero.
737      */
738     function div(uint256 a, uint256 b) internal pure returns (uint256) {
739         return a / b;
740     }
741 
742     /**
743      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
744      * reverting when dividing by zero.
745      *
746      * Counterpart to Solidity's `%` operator. This function uses a `revert`
747      * opcode (which leaves remaining gas untouched) while Solidity uses an
748      * invalid opcode to revert (consuming all remaining gas).
749      *
750      * Requirements:
751      *
752      * - The divisor cannot be zero.
753      */
754     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
755         return a % b;
756     }
757 
758     /**
759      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
760      * overflow (when the result is negative).
761      *
762      * CAUTION: This function is deprecated because it requires allocating memory for the error
763      * message unnecessarily. For custom revert reasons use {trySub}.
764      *
765      * Counterpart to Solidity's `-` operator.
766      *
767      * Requirements:
768      *
769      * - Subtraction cannot overflow.
770      */
771     function sub(
772         uint256 a,
773         uint256 b,
774         string memory errorMessage
775     ) internal pure returns (uint256) {
776         unchecked {
777             require(b <= a, errorMessage);
778             return a - b;
779         }
780     }
781 
782     /**
783      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
784      * division by zero. The result is rounded towards zero.
785      *
786      * Counterpart to Solidity's `/` operator. Note: this function uses a
787      * `revert` opcode (which leaves remaining gas untouched) while Solidity
788      * uses an invalid opcode to revert (consuming all remaining gas).
789      *
790      * Requirements:
791      *
792      * - The divisor cannot be zero.
793      */
794     function div(
795         uint256 a,
796         uint256 b,
797         string memory errorMessage
798     ) internal pure returns (uint256) {
799         unchecked {
800             require(b > 0, errorMessage);
801             return a / b;
802         }
803     }
804 
805     /**
806      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
807      * reverting with custom message when dividing by zero.
808      *
809      * CAUTION: This function is deprecated because it requires allocating memory for the error
810      * message unnecessarily. For custom revert reasons use {tryMod}.
811      *
812      * Counterpart to Solidity's `%` operator. This function uses a `revert`
813      * opcode (which leaves remaining gas untouched) while Solidity uses an
814      * invalid opcode to revert (consuming all remaining gas).
815      *
816      * Requirements:
817      *
818      * - The divisor cannot be zero.
819      */
820     function mod(
821         uint256 a,
822         uint256 b,
823         string memory errorMessage
824     ) internal pure returns (uint256) {
825         unchecked {
826             require(b > 0, errorMessage);
827             return a % b;
828         }
829     }
830 }
831 
832 ////// src/IUniswapV2Factory.sol
833 /* pragma solidity 0.8.10; */
834 /* pragma experimental ABIEncoderV2; */
835 
836 interface IUniswapV2Factory {
837     event PairCreated(
838         address indexed token0,
839         address indexed token1,
840         address pair,
841         uint256
842     );
843 
844     function feeTo() external view returns (address);
845 
846     function feeToSetter() external view returns (address);
847 
848     function getPair(address tokenA, address tokenB)
849         external
850         view
851         returns (address pair);
852 
853     function allPairs(uint256) external view returns (address pair);
854 
855     function allPairsLength() external view returns (uint256);
856 
857     function createPair(address tokenA, address tokenB)
858         external
859         returns (address pair);
860 
861     function setFeeTo(address) external;
862 
863     function setFeeToSetter(address) external;
864 }
865 
866 ////// src/IUniswapV2Pair.sol
867 /* pragma solidity 0.8.10; */
868 /* pragma experimental ABIEncoderV2; */
869 
870 interface IUniswapV2Pair {
871     event Approval(
872         address indexed owner,
873         address indexed spender,
874         uint256 value
875     );
876     event Transfer(address indexed from, address indexed to, uint256 value);
877 
878     function name() external pure returns (string memory);
879 
880     function symbol() external pure returns (string memory);
881 
882     function decimals() external pure returns (uint8);
883 
884     function totalSupply() external view returns (uint256);
885 
886     function balanceOf(address owner) external view returns (uint256);
887 
888     function allowance(address owner, address spender)
889         external
890         view
891         returns (uint256);
892 
893     function approve(address spender, uint256 value) external returns (bool);
894 
895     function transfer(address to, uint256 value) external returns (bool);
896 
897     function transferFrom(
898         address from,
899         address to,
900         uint256 value
901     ) external returns (bool);
902 
903     function DOMAIN_SEPARATOR() external view returns (bytes32);
904 
905     function PERMIT_TYPEHASH() external pure returns (bytes32);
906 
907     function nonces(address owner) external view returns (uint256);
908 
909     function permit(
910         address owner,
911         address spender,
912         uint256 value,
913         uint256 deadline,
914         uint8 v,
915         bytes32 r,
916         bytes32 s
917     ) external;
918 
919     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
920     event Burn(
921         address indexed sender,
922         uint256 amount0,
923         uint256 amount1,
924         address indexed to
925     );
926     event Swap(
927         address indexed sender,
928         uint256 amount0In,
929         uint256 amount1In,
930         uint256 amount0Out,
931         uint256 amount1Out,
932         address indexed to
933     );
934     event Sync(uint112 reserve0, uint112 reserve1);
935 
936     function MINIMUM_LIQUIDITY() external pure returns (uint256);
937 
938     function factory() external view returns (address);
939 
940     function token0() external view returns (address);
941 
942     function token1() external view returns (address);
943 
944     function getReserves()
945         external
946         view
947         returns (
948             uint112 reserve0,
949             uint112 reserve1,
950             uint32 blockTimestampLast
951         );
952 
953     function price0CumulativeLast() external view returns (uint256);
954 
955     function price1CumulativeLast() external view returns (uint256);
956 
957     function kLast() external view returns (uint256);
958 
959     function mint(address to) external returns (uint256 liquidity);
960 
961     function burn(address to)
962         external
963         returns (uint256 amount0, uint256 amount1);
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
979 ////// src/IUniswapV2Router02.sol
980 /* pragma solidity 0.8.10; */
981 /* pragma experimental ABIEncoderV2; */
982 
983 interface IUniswapV2Router02 {
984     function factory() external pure returns (address);
985 
986     function WETH() external pure returns (address);
987 
988     function addLiquidity(
989         address tokenA,
990         address tokenB,
991         uint256 amountADesired,
992         uint256 amountBDesired,
993         uint256 amountAMin,
994         uint256 amountBMin,
995         address to,
996         uint256 deadline
997     )
998         external
999         returns (
1000             uint256 amountA,
1001             uint256 amountB,
1002             uint256 liquidity
1003         );
1004 
1005     function addLiquidityETH(
1006         address token,
1007         uint256 amountTokenDesired,
1008         uint256 amountTokenMin,
1009         uint256 amountETHMin,
1010         address to,
1011         uint256 deadline
1012     )
1013         external
1014         payable
1015         returns (
1016             uint256 amountToken,
1017             uint256 amountETH,
1018             uint256 liquidity
1019         );
1020 
1021     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1022         uint256 amountIn,
1023         uint256 amountOutMin,
1024         address[] calldata path,
1025         address to,
1026         uint256 deadline
1027     ) external;
1028 
1029     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1030         uint256 amountOutMin,
1031         address[] calldata path,
1032         address to,
1033         uint256 deadline
1034     ) external payable;
1035 
1036     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1037         uint256 amountIn,
1038         uint256 amountOutMin,
1039         address[] calldata path,
1040         address to,
1041         uint256 deadline
1042     ) external;
1043 }
1044 
1045 ////// src/student.sol
1046 /* pragma solidity >=0.8.10; */
1047 
1048 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1049 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1050 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1051 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1052 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1053 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1054 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1055 
1056 contract StudentInu is ERC20, Ownable {
1057     using SafeMath for uint256;
1058 
1059     IUniswapV2Router02 public immutable uniswapV2Router;
1060     address public immutable uniswapV2Pair;
1061     address public constant deadAddress = address(0xdead);
1062 
1063     bool private swapping;
1064 
1065     address public marketingWallet;
1066     address public devWallet;
1067 
1068     uint256 public maxTransactionAmount;
1069     uint256 public swapTokensAtAmount;
1070     uint256 public maxWallet;
1071 
1072     uint256 public percentForLPBurn = 25; // 25 = .25%
1073     bool public lpBurnEnabled = true;
1074     uint256 public lpBurnFrequency = 3600 seconds;
1075     uint256 public lastLpBurnTime;
1076 
1077     uint256 public manualBurnFrequency = 30 minutes;
1078     uint256 public lastManualLpBurnTime;
1079 
1080     bool public limitsInEffect = true;
1081     bool public tradingActive = false;
1082     bool public swapEnabled = false;
1083 
1084     // Anti-bot and anti-whale mappings and variables
1085     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1086     bool public transferDelayEnabled = true;
1087 
1088     uint256 public buyTotalFees;
1089     uint256 public buyMarketingFee;
1090     uint256 public buyLiquidityFee;
1091     uint256 public buyDevFee;
1092 
1093     uint256 public sellTotalFees;
1094     uint256 public sellMarketingFee;
1095     uint256 public sellLiquidityFee;
1096     uint256 public sellDevFee;
1097 
1098     uint256 public tokensForMarketing;
1099     uint256 public tokensForLiquidity;
1100     uint256 public tokensForDev;
1101 
1102     /******************/
1103 
1104     // exlcude from fees and max transaction amount
1105     mapping(address => bool) private _isExcludedFromFees;
1106     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1107 
1108     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1109     // could be subject to a maximum transfer amount
1110     mapping(address => bool) public automatedMarketMakerPairs;
1111 
1112     event UpdateUniswapV2Router(
1113         address indexed newAddress,
1114         address indexed oldAddress
1115     );
1116 
1117     event ExcludeFromFees(address indexed account, bool isExcluded);
1118 
1119     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1120 
1121     event marketingWalletUpdated(
1122         address indexed newWallet,
1123         address indexed oldWallet
1124     );
1125 
1126     event devWalletUpdated(
1127         address indexed newWallet,
1128         address indexed oldWallet
1129     );
1130 
1131     event SwapAndLiquify(
1132         uint256 tokensSwapped,
1133         uint256 ethReceived,
1134         uint256 tokensIntoLiquidity
1135     );
1136 
1137     event AutoNukeLP();
1138 
1139     event ManualNukeLP();
1140 
1141     constructor() ERC20("Student Inu", "STUDENT") {
1142         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1143             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1144         );
1145 
1146         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1147         uniswapV2Router = _uniswapV2Router;
1148 
1149         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1150             .createPair(address(this), _uniswapV2Router.WETH());
1151         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1152         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1153 
1154         uint256 _buyMarketingFee = 5;
1155         uint256 _buyLiquidityFee = 3;
1156         uint256 _buyDevFee = 2;
1157 
1158         uint256 _sellMarketingFee = 8;
1159         uint256 _sellLiquidityFee = 3;
1160         uint256 _sellDevFee = 1;
1161 
1162         uint256 totalSupply = 1_000_000_000 * 1e18;
1163 
1164         maxTransactionAmount = 10_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1165         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1166         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1167 
1168         buyMarketingFee = _buyMarketingFee;
1169         buyLiquidityFee = _buyLiquidityFee;
1170         buyDevFee = _buyDevFee;
1171         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1172 
1173         sellMarketingFee = _sellMarketingFee;
1174         sellLiquidityFee = _sellLiquidityFee;
1175         sellDevFee = _sellDevFee;
1176         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1177 
1178         marketingWallet = address(0x7436E5b9b777f7F2c15b9648c396A0BC5a50651C); // set as marketing wallet
1179         devWallet = address(0xfb7D62E04CCDEe04EC159c8331998ea2304394Bf); // set as dev wallet
1180 
1181         // exclude from paying fees or having max transaction amount
1182         excludeFromFees(owner(), true);
1183         excludeFromFees(address(this), true);
1184         excludeFromFees(address(0xdead), true);
1185 
1186         excludeFromMaxTransaction(owner(), true);
1187         excludeFromMaxTransaction(address(this), true);
1188         excludeFromMaxTransaction(address(0xdead), true);
1189 
1190         /*
1191             _mint is an internal function in ERC20.sol that is only called here,
1192             and CANNOT be called ever again
1193         */
1194         _mint(msg.sender, totalSupply);
1195     }
1196 
1197     receive() external payable {}
1198 
1199     // once enabled, can never be turned off
1200     function enableTrading() external onlyOwner {
1201         tradingActive = true;
1202         swapEnabled = true;
1203         lastLpBurnTime = block.timestamp;
1204     }
1205 
1206     // remove limits after token is stable
1207     function removeLimits() external onlyOwner returns (bool) {
1208         limitsInEffect = false;
1209         return true;
1210     }
1211 
1212     // disable Transfer delay - cannot be reenabled
1213     function disableTransferDelay() external onlyOwner returns (bool) {
1214         transferDelayEnabled = false;
1215         return true;
1216     }
1217 
1218     // change the minimum amount of tokens to sell from fees
1219     function updateSwapTokensAtAmount(uint256 newAmount)
1220         external
1221         onlyOwner
1222         returns (bool)
1223     {
1224         require(
1225             newAmount >= (totalSupply() * 1) / 100000,
1226             "Swap amount cannot be lower than 0.001% total supply."
1227         );
1228         require(
1229             newAmount <= (totalSupply() * 5) / 1000,
1230             "Swap amount cannot be higher than 0.5% total supply."
1231         );
1232         swapTokensAtAmount = newAmount;
1233         return true;
1234     }
1235 
1236     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1237         require(
1238             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1239             "Cannot set maxTransactionAmount lower than 0.1%"
1240         );
1241         maxTransactionAmount = newNum * (10**18);
1242     }
1243 
1244     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1245         require(
1246             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1247             "Cannot set maxWallet lower than 0.5%"
1248         );
1249         maxWallet = newNum * (10**18);
1250     }
1251 
1252     function excludeFromMaxTransaction(address updAds, bool isEx)
1253         public
1254         onlyOwner
1255     {
1256         _isExcludedMaxTransactionAmount[updAds] = isEx;
1257     }
1258 
1259     // only use to disable contract sales if absolutely necessary (emergency use only)
1260     function updateSwapEnabled(bool enabled) external onlyOwner {
1261         swapEnabled = enabled;
1262     }
1263 
1264     function updateBuyFees(
1265         uint256 _marketingFee,
1266         uint256 _liquidityFee,
1267         uint256 _devFee
1268     ) external onlyOwner {
1269         buyMarketingFee = _marketingFee;
1270         buyLiquidityFee = _liquidityFee;
1271         buyDevFee = _devFee;
1272         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1273         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1274     }
1275 
1276     function updateSellFees(
1277         uint256 _marketingFee,
1278         uint256 _liquidityFee,
1279         uint256 _devFee
1280     ) external onlyOwner {
1281         sellMarketingFee = _marketingFee;
1282         sellLiquidityFee = _liquidityFee;
1283         sellDevFee = _devFee;
1284         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1285         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1286     }
1287 
1288     function excludeFromFees(address account, bool excluded) public onlyOwner {
1289         _isExcludedFromFees[account] = excluded;
1290         emit ExcludeFromFees(account, excluded);
1291     }
1292 
1293     function setAutomatedMarketMakerPair(address pair, bool value)
1294         public
1295         onlyOwner
1296     {
1297         require(
1298             pair != uniswapV2Pair,
1299             "The pair cannot be removed from automatedMarketMakerPairs"
1300         );
1301 
1302         _setAutomatedMarketMakerPair(pair, value);
1303     }
1304 
1305     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1306         automatedMarketMakerPairs[pair] = value;
1307 
1308         emit SetAutomatedMarketMakerPair(pair, value);
1309     }
1310 
1311     function updateMarketingWallet(address newMarketingWallet)
1312         external
1313         onlyOwner
1314     {
1315         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1316         marketingWallet = newMarketingWallet;
1317     }
1318 
1319     function updateDevWallet(address newWallet) external onlyOwner {
1320         emit devWalletUpdated(newWallet, devWallet);
1321         devWallet = newWallet;
1322     }
1323 
1324     function isExcludedFromFees(address account) public view returns (bool) {
1325         return _isExcludedFromFees[account];
1326     }
1327 
1328     event BoughtEarly(address indexed sniper);
1329 
1330     function _transfer(
1331         address from,
1332         address to,
1333         uint256 amount
1334     ) internal override {
1335         require(from != address(0), "ERC20: transfer from the zero address");
1336         require(to != address(0), "ERC20: transfer to the zero address");
1337 
1338         if (amount == 0) {
1339             super._transfer(from, to, 0);
1340             return;
1341         }
1342 
1343         if (limitsInEffect) {
1344             if (
1345                 from != owner() &&
1346                 to != owner() &&
1347                 to != address(0) &&
1348                 to != address(0xdead) &&
1349                 !swapping
1350             ) {
1351                 if (!tradingActive) {
1352                     require(
1353                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1354                         "Trading is not active."
1355                     );
1356                 }
1357 
1358                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1359                 if (transferDelayEnabled) {
1360                     if (
1361                         to != owner() &&
1362                         to != address(uniswapV2Router) &&
1363                         to != address(uniswapV2Pair)
1364                     ) {
1365                         require(
1366                             _holderLastTransferTimestamp[tx.origin] <
1367                                 block.number,
1368                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1369                         );
1370                         _holderLastTransferTimestamp[tx.origin] = block.number;
1371                     }
1372                 }
1373 
1374                 //when buy
1375                 if (
1376                     automatedMarketMakerPairs[from] &&
1377                     !_isExcludedMaxTransactionAmount[to]
1378                 ) {
1379                     require(
1380                         amount <= maxTransactionAmount,
1381                         "Buy transfer amount exceeds the maxTransactionAmount."
1382                     );
1383                     require(
1384                         amount + balanceOf(to) <= maxWallet,
1385                         "Max wallet exceeded"
1386                     );
1387                 }
1388                 //when sell
1389                 else if (
1390                     automatedMarketMakerPairs[to] &&
1391                     !_isExcludedMaxTransactionAmount[from]
1392                 ) {
1393                     require(
1394                         amount <= maxTransactionAmount,
1395                         "Sell transfer amount exceeds the maxTransactionAmount."
1396                     );
1397                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1398                     require(
1399                         amount + balanceOf(to) <= maxWallet,
1400                         "Max wallet exceeded"
1401                     );
1402                 }
1403             }
1404         }
1405 
1406         uint256 contractTokenBalance = balanceOf(address(this));
1407 
1408         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1409 
1410         if (
1411             canSwap &&
1412             swapEnabled &&
1413             !swapping &&
1414             !automatedMarketMakerPairs[from] &&
1415             !_isExcludedFromFees[from] &&
1416             !_isExcludedFromFees[to]
1417         ) {
1418             swapping = true;
1419 
1420             swapBack();
1421 
1422             swapping = false;
1423         }
1424 
1425         if (
1426             !swapping &&
1427             automatedMarketMakerPairs[to] &&
1428             lpBurnEnabled &&
1429             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1430             !_isExcludedFromFees[from]
1431         ) {
1432             autoBurnLiquidityPairTokens();
1433         }
1434 
1435         bool takeFee = !swapping;
1436 
1437         // if any account belongs to _isExcludedFromFee account then remove the fee
1438         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1439             takeFee = false;
1440         }
1441 
1442         uint256 fees = 0;
1443         // only take fees on buys/sells, do not take on wallet transfers
1444         if (takeFee) {
1445             // on sell
1446             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1447                 fees = amount.mul(sellTotalFees).div(100);
1448                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1449                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1450                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1451             }
1452             // on buy
1453             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1454                 fees = amount.mul(buyTotalFees).div(100);
1455                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1456                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1457                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1458             }
1459 
1460             if (fees > 0) {
1461                 super._transfer(from, address(this), fees);
1462             }
1463 
1464             amount -= fees;
1465         }
1466 
1467         super._transfer(from, to, amount);
1468     }
1469 
1470     function swapTokensForEth(uint256 tokenAmount) private {
1471         // generate the uniswap pair path of token -> weth
1472         address[] memory path = new address[](2);
1473         path[0] = address(this);
1474         path[1] = uniswapV2Router.WETH();
1475 
1476         _approve(address(this), address(uniswapV2Router), tokenAmount);
1477 
1478         // make the swap
1479         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1480             tokenAmount,
1481             0, // accept any amount of ETH
1482             path,
1483             address(this),
1484             block.timestamp
1485         );
1486     }
1487 
1488     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1489         // approve token transfer to cover all possible scenarios
1490         _approve(address(this), address(uniswapV2Router), tokenAmount);
1491 
1492         // add the liquidity
1493         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1494             address(this),
1495             tokenAmount,
1496             0, // slippage is unavoidable
1497             0, // slippage is unavoidable
1498             deadAddress,
1499             block.timestamp
1500         );
1501     }
1502 
1503     function swapBack() private {
1504         uint256 contractBalance = balanceOf(address(this));
1505         uint256 totalTokensToSwap = tokensForLiquidity +
1506             tokensForMarketing +
1507             tokensForDev;
1508         bool success;
1509 
1510         if (contractBalance == 0 || totalTokensToSwap == 0) {
1511             return;
1512         }
1513 
1514         if (contractBalance > swapTokensAtAmount * 20) {
1515             contractBalance = swapTokensAtAmount * 20;
1516         }
1517 
1518         // Halve the amount of liquidity tokens
1519         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1520             totalTokensToSwap /
1521             2;
1522         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1523 
1524         uint256 initialETHBalance = address(this).balance;
1525 
1526         swapTokensForEth(amountToSwapForETH);
1527 
1528         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1529 
1530         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1531             totalTokensToSwap
1532         );
1533         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1534 
1535         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1536 
1537         tokensForLiquidity = 0;
1538         tokensForMarketing = 0;
1539         tokensForDev = 0;
1540 
1541         (success, ) = address(devWallet).call{value: ethForDev}("");
1542 
1543         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1544             addLiquidity(liquidityTokens, ethForLiquidity);
1545             emit SwapAndLiquify(
1546                 amountToSwapForETH,
1547                 ethForLiquidity,
1548                 tokensForLiquidity
1549             );
1550         }
1551 
1552         (success, ) = address(marketingWallet).call{
1553             value: address(this).balance
1554         }("");
1555     }
1556 
1557     function setAutoLPBurnSettings(
1558         uint256 _frequencyInSeconds,
1559         uint256 _percent,
1560         bool _Enabled
1561     ) external onlyOwner {
1562         require(
1563             _frequencyInSeconds >= 600,
1564             "cannot set buyback more often than every 10 minutes"
1565         );
1566         require(
1567             _percent <= 1000 && _percent >= 0,
1568             "Must set auto LP burn percent between 0% and 10%"
1569         );
1570         lpBurnFrequency = _frequencyInSeconds;
1571         percentForLPBurn = _percent;
1572         lpBurnEnabled = _Enabled;
1573     }
1574 
1575     function autoBurnLiquidityPairTokens() internal returns (bool) {
1576         lastLpBurnTime = block.timestamp;
1577 
1578         // get balance of liquidity pair
1579         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1580 
1581         // calculate amount to burn
1582         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1583             10000
1584         );
1585 
1586         // pull tokens from pancakePair liquidity and move to dead address permanently
1587         if (amountToBurn > 0) {
1588             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1589         }
1590 
1591         //sync price since this is not in a swap transaction!
1592         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1593         pair.sync();
1594         emit AutoNukeLP();
1595         return true;
1596     }
1597 
1598     function manualBurnLiquidityPairTokens(uint256 percent)
1599         external
1600         onlyOwner
1601         returns (bool)
1602     {
1603         require(
1604             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1605             "Must wait for cooldown to finish"
1606         );
1607         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1608         lastManualLpBurnTime = block.timestamp;
1609 
1610         // get balance of liquidity pair
1611         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1612 
1613         // calculate amount to burn
1614         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1615 
1616         // pull tokens from pancakePair liquidity and move to dead address permanently
1617         if (amountToBurn > 0) {
1618             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1619         }
1620 
1621         //sync price since this is not in a swap transaction!
1622         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1623         pair.sync();
1624         emit ManualNukeLP();
1625         return true;
1626     }
1627 }