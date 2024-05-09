1 // ███╗   ███╗ ██████╗  ██████╗ ███╗   ██╗████████╗██████╗  █████╗ ██╗███╗   ██╗
2 // ████╗ ████║██╔═══██╗██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██║████╗  ██║
3 // ██╔████╔██║██║   ██║██║   ██║██╔██╗ ██║   ██║   ██████╔╝███████║██║██╔██╗ ██║
4 // ██║╚██╔╝██║██║   ██║██║   ██║██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║██║╚██╗██║
5 // ██║ ╚═╝ ██║╚██████╔╝╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║  ██║██║██║ ╚████║
6 // ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
7 
8 // Website: https://moontrain.vip
9 // Telegram: https://t.me/MoonTrainETH
10 // Twitter: https://twitter.com/MoonTrainETH
11 // Medium: https://medium.com/@MoonTrain
12                                                                              
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations.
39  *
40  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
41  * now has built in overflow checking.
42  */
43 library SafeMath {
44     /**
45      * @dev Returns the addition of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             uint256 c = a + b;
52             if (c < a) return (false, 0);
53             return (true, c);
54         }
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
59      *
60      * _Available since v3.4._
61      */
62     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             if (b > a) return (false, 0);
65             return (true, a - b);
66         }
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77             // benefit is lost if 'b' is also tested.
78             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79             if (a == 0) return (true, 0);
80             uint256 c = a * b;
81             if (c / a != b) return (false, 0);
82             return (true, c);
83         }
84     }
85 
86     /**
87      * @dev Returns the division of two unsigned integers, with a division by zero flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         unchecked {
93             if (b == 0) return (false, 0);
94             return (true, a / b);
95         }
96     }
97 
98     /**
99      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
100      *
101      * _Available since v3.4._
102      */
103     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         unchecked {
105             if (b == 0) return (false, 0);
106             return (true, a % b);
107         }
108     }
109 
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a + b;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a - b;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      *
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a * b;
150     }
151 
152     /**
153      * @dev Returns the integer division of two unsigned integers, reverting on
154      * division by zero. The result is rounded towards zero.
155      *
156      * Counterpart to Solidity's `/` operator.
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a / b;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * reverting when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a % b;
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
184      * overflow (when the result is negative).
185      *
186      * CAUTION: This function is deprecated because it requires allocating memory for the error
187      * message unnecessarily. For custom revert reasons use {trySub}.
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         unchecked {
197             require(b <= a, errorMessage);
198             return a - b;
199         }
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         unchecked {
216             require(b > 0, errorMessage);
217             return a / b;
218         }
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting with custom message when dividing by zero.
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {tryMod}.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         unchecked {
238             require(b > 0, errorMessage);
239             return a % b;
240         }
241     }
242 }
243 
244 /**
245  * @dev Contract module which provides a basic access control mechanism, where
246  * there is an account (an owner) that can be granted exclusive access to
247  * specific functions.
248  *
249  * By default, the owner account will be the one that deploys the contract. This
250  * can later be changed with {transferOwnership}.
251  *
252  * This module is used through inheritance. It will make available the modifier
253  * `onlyOwner`, which can be applied to your functions to restrict their use to
254  * the owner.
255  */
256 abstract contract Ownable is Context {
257     address private _owner;
258 
259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
260 
261     /**
262      * @dev Initializes the contract setting the deployer as the initial owner.
263      */
264     constructor() {
265         _transferOwnership(_msgSender());
266     }
267 
268     /**
269      * @dev Returns the address of the current owner.
270      */
271     function owner() public view virtual returns (address) {
272         return _owner;
273     }
274 
275     /**
276      * @dev Throws if called by any account other than the owner.
277      */
278     modifier onlyOwner() {
279         require(owner() == _msgSender(), "Ownable: caller is not the owner");
280         _;
281     }
282 
283     /**
284      * @dev Leaves the contract without owner. It will not be possible to call
285      * `onlyOwner` functions anymore. Can only be called by the current owner.
286      *
287      * NOTE: Renouncing ownership will leave the contract without an owner,
288      * thereby removing any functionality that is only available to the owner.
289      */
290     function renounceOwnership() public virtual onlyOwner {
291         _transferOwnership(address(0));
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Can only be called by the current owner.
297      */
298     function transferOwnership(address newOwner) public virtual onlyOwner {
299         require(newOwner != address(0), "Ownable: new owner is the zero address");
300         _transferOwnership(newOwner);
301     }
302 
303     /**
304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
305      * Internal function without access restriction.
306      */
307     function _transferOwnership(address newOwner) internal virtual {
308         address oldOwner = _owner;
309         _owner = newOwner;
310         emit OwnershipTransferred(oldOwner, newOwner);
311     }
312 }
313 
314 /**
315  * @dev Interface of the ERC20 standard as defined in the EIP.
316  */
317 interface IERC20 {
318     /**
319      * @dev Returns the amount of tokens in existence.
320      */
321     function totalSupply() external view returns (uint256);
322 
323     /**
324      * @dev Returns the amount of tokens owned by `account`.
325      */
326     function balanceOf(address account) external view returns (uint256);
327 
328     /**
329      * @dev Moves `amount` tokens from the caller's account to `recipient`.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transfer(address recipient, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Returns the remaining number of tokens that `spender` will be
339      * allowed to spend on behalf of `owner` through {transferFrom}. This is
340      * zero by default.
341      *
342      * This value changes when {approve} or {transferFrom} are called.
343      */
344     function allowance(address owner, address spender) external view returns (uint256);
345 
346     /**
347      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * IMPORTANT: Beware that changing an allowance with this method brings the risk
352      * that someone may use both the old and the new allowance by unfortunate
353      * transaction ordering. One possible solution to mitigate this race
354      * condition is to first reduce the spender's allowance to 0 and set the
355      * desired value afterwards:
356      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357      *
358      * Emits an {Approval} event.
359      */
360     function approve(address spender, uint256 amount) external returns (bool);
361 
362     /**
363      * @dev Moves `amount` tokens from `sender` to `recipient` using the
364      * allowance mechanism. `amount` is then deducted from the caller's
365      * allowance.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transferFrom(
372         address sender,
373         address recipient,
374         uint256 amount
375     ) external returns (bool);
376 
377     /**
378      * @dev Emitted when `value` tokens are moved from one account (`from`) to
379      * another (`to`).
380      *
381      * Note that `value` may be zero.
382      */
383     event Transfer(address indexed from, address indexed to, uint256 value);
384 
385     /**
386      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
387      * a call to {approve}. `value` is the new allowance.
388      */
389     event Approval(address indexed owner, address indexed spender, uint256 value);
390 }
391 
392 /**
393  * @dev Interface for the optional metadata functions from the ERC20 standard.
394  *
395  * _Available since v4.1._
396  */
397 interface IERC20Metadata is IERC20 {
398     /**
399      * @dev Returns the name of the token.
400      */
401     function name() external view returns (string memory);
402 
403     /**
404      * @dev Returns the symbol of the token.
405      */
406     function symbol() external view returns (string memory);
407 
408     /**
409      * @dev Returns the decimals places of the token.
410      */
411     function decimals() external view returns (uint8);
412 }
413 
414 /**
415  * @dev Implementation of the {IERC20} interface.
416  *
417  * This implementation is agnostic to the way tokens are created. This means
418  * that a supply mechanism has to be added in a derived contract using {_mint}.
419  * For a generic mechanism see {ERC20PresetMinterPauser}.
420  *
421  * TIP: For a detailed writeup see our guide
422  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
423  * to implement supply mechanisms].
424  *
425  * We have followed general OpenZeppelin Contracts guidelines: functions revert
426  * instead returning `false` on failure. This behavior is nonetheless
427  * conventional and does not conflict with the expectations of ERC20
428  * applications.
429  *
430  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
431  * This allows applications to reconstruct the allowance for all accounts just
432  * by listening to said events. Other implementations of the EIP may not emit
433  * these events, as it isn't required by the specification.
434  *
435  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
436  * functions have been added to mitigate the well-known issues around setting
437  * allowances. See {IERC20-approve}.
438  */
439 contract ERC20 is Context, IERC20, IERC20Metadata {
440     mapping(address => uint256) private _balances;
441 
442     mapping(address => mapping(address => uint256)) private _allowances;
443 
444     uint256 private _totalSupply;
445 
446     string private _name;
447     string private _symbol;
448 
449     /**
450      * @dev Sets the values for {name} and {symbol}.
451      *
452      * The default value of {decimals} is 18. To select a different value for
453      * {decimals} you should overload it.
454      *
455      * All two of these values are immutable: they can only be set once during
456      * construction.
457      */
458     constructor(string memory name_, string memory symbol_) {
459         _name = name_;
460         _symbol = symbol_;
461     }
462 
463     /**
464      * @dev Returns the name of the token.
465      */
466     function name() public view virtual override returns (string memory) {
467         return _name;
468     }
469 
470     /**
471      * @dev Returns the symbol of the token, usually a shorter version of the
472      * name.
473      */
474     function symbol() public view virtual override returns (string memory) {
475         return _symbol;
476     }
477 
478     /**
479      * @dev Returns the number of decimals used to get its user representation.
480      * For example, if `decimals` equals `2`, a balance of `505` tokens should
481      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
482      *
483      * Tokens usually opt for a value of 18, imitating the relationship between
484      * Ether and Wei. This is the value {ERC20} uses, unless this function is
485      * overridden;
486      *
487      * NOTE: This information is only used for _display_ purposes: it in
488      * no way affects any of the arithmetic of the contract, including
489      * {IERC20-balanceOf} and {IERC20-transfer}.
490      */
491     function decimals() public view virtual override returns (uint8) {
492         return 18;
493     }
494 
495     /**
496      * @dev See {IERC20-totalSupply}.
497      */
498     function totalSupply() public view virtual override returns (uint256) {
499         return _totalSupply;
500     }
501 
502     /**
503      * @dev See {IERC20-balanceOf}.
504      */
505     function balanceOf(address account) public view virtual override returns (uint256) {
506         return _balances[account];
507     }
508 
509     /**
510      * @dev See {IERC20-transfer}.
511      *
512      * Requirements:
513      *
514      * - `recipient` cannot be the zero address.
515      * - the caller must have a balance of at least `amount`.
516      */
517     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
518         _transfer(_msgSender(), recipient, amount);
519         return true;
520     }
521 
522     /**
523      * @dev See {IERC20-allowance}.
524      */
525     function allowance(address owner, address spender) public view virtual override returns (uint256) {
526         return _allowances[owner][spender];
527     }
528 
529     /**
530      * @dev See {IERC20-approve}.
531      *
532      * Requirements:
533      *
534      * - `spender` cannot be the zero address.
535      */
536     function approve(address spender, uint256 amount) public virtual override returns (bool) {
537         _approve(_msgSender(), spender, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-transferFrom}.
543      *
544      * Emits an {Approval} event indicating the updated allowance. This is not
545      * required by the EIP. See the note at the beginning of {ERC20}.
546      *
547      * Requirements:
548      *
549      * - `sender` and `recipient` cannot be the zero address.
550      * - `sender` must have a balance of at least `amount`.
551      * - the caller must have allowance for ``sender``'s tokens of at least
552      * `amount`.
553      */
554     function transferFrom(
555         address sender,
556         address recipient,
557         uint256 amount
558     ) public virtual override returns (bool) {
559         _transfer(sender, recipient, amount);
560 
561         uint256 currentAllowance = _allowances[sender][_msgSender()];
562         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
563         unchecked {
564             _approve(sender, _msgSender(), currentAllowance - amount);
565         }
566 
567         return true;
568     }
569 
570     /**
571      * @dev Atomically increases the allowance granted to `spender` by the caller.
572      *
573      * This is an alternative to {approve} that can be used as a mitigation for
574      * problems described in {IERC20-approve}.
575      *
576      * Emits an {Approval} event indicating the updated allowance.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      */
582     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
583         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
584         return true;
585     }
586 
587     /**
588      * @dev Atomically decreases the allowance granted to `spender` by the caller.
589      *
590      * This is an alternative to {approve} that can be used as a mitigation for
591      * problems described in {IERC20-approve}.
592      *
593      * Emits an {Approval} event indicating the updated allowance.
594      *
595      * Requirements:
596      *
597      * - `spender` cannot be the zero address.
598      * - `spender` must have allowance for the caller of at least
599      * `subtractedValue`.
600      */
601     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
602         uint256 currentAllowance = _allowances[_msgSender()][spender];
603         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
604         unchecked {
605             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
606         }
607 
608         return true;
609     }
610 
611     /**
612      * @dev Moves `amount` of tokens from `sender` to `recipient`.
613      *
614      * This internal function is equivalent to {transfer}, and can be used to
615      * e.g. implement automatic token fees, slashing mechanisms, etc.
616      *
617      * Emits a {Transfer} event.
618      *
619      * Requirements:
620      *
621      * - `sender` cannot be the zero address.
622      * - `recipient` cannot be the zero address.
623      * - `sender` must have a balance of at least `amount`.
624      */
625     function _transfer(
626         address sender,
627         address recipient,
628         uint256 amount
629     ) internal virtual {
630         require(sender != address(0), "ERC20: transfer from the zero address");
631         require(recipient != address(0), "ERC20: transfer to the zero address");
632 
633         _beforeTokenTransfer(sender, recipient, amount);
634 
635         uint256 senderBalance = _balances[sender];
636         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
637         unchecked {
638             _balances[sender] = senderBalance - amount;
639         }
640         _balances[recipient] += amount;
641 
642         emit Transfer(sender, recipient, amount);
643 
644         _afterTokenTransfer(sender, recipient, amount);
645     }
646 
647     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
648      * the total supply.
649      *
650      * Emits a {Transfer} event with `from` set to the zero address.
651      *
652      * Requirements:
653      *
654      * - `account` cannot be the zero address.
655      */
656     function _mint(address account, uint256 amount) internal virtual {
657         require(account != address(0), "ERC20: mint to the zero address");
658 
659         _beforeTokenTransfer(address(0), account, amount);
660 
661         _totalSupply += amount;
662         _balances[account] += amount;
663         emit Transfer(address(0), account, amount);
664 
665         _afterTokenTransfer(address(0), account, amount);
666     }
667 
668     /**
669      * @dev Destroys `amount` tokens from `account`, reducing the
670      * total supply.
671      *
672      * Emits a {Transfer} event with `to` set to the zero address.
673      *
674      * Requirements:
675      *
676      * - `account` cannot be the zero address.
677      * - `account` must have at least `amount` tokens.
678      */
679     function _burn(address account, uint256 amount) internal virtual {
680         require(account != address(0), "ERC20: burn from the zero address");
681 
682         _beforeTokenTransfer(account, address(0), amount);
683 
684         uint256 accountBalance = _balances[account];
685         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
686         unchecked {
687             _balances[account] = accountBalance - amount;
688         }
689         _totalSupply -= amount;
690 
691         emit Transfer(account, address(0), amount);
692 
693         _afterTokenTransfer(account, address(0), amount);
694     }
695 
696     /**
697      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
698      *
699      * This internal function is equivalent to `approve`, and can be used to
700      * e.g. set automatic allowances for certain subsystems, etc.
701      *
702      * Emits an {Approval} event.
703      *
704      * Requirements:
705      *
706      * - `owner` cannot be the zero address.
707      * - `spender` cannot be the zero address.
708      */
709     function _approve(
710         address owner,
711         address spender,
712         uint256 amount
713     ) internal virtual {
714         require(owner != address(0), "ERC20: approve from the zero address");
715         require(spender != address(0), "ERC20: approve to the zero address");
716 
717         _allowances[owner][spender] = amount;
718         emit Approval(owner, spender, amount);
719     }
720 
721     /**
722      * @dev Hook that is called before any transfer of tokens. This includes
723      * minting and burning.
724      *
725      * Calling conditions:
726      *
727      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
728      * will be transferred to `to`.
729      * - when `from` is zero, `amount` tokens will be minted for `to`.
730      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
731      * - `from` and `to` are never both zero.
732      *
733      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
734      */
735     function _beforeTokenTransfer(
736         address from,
737         address to,
738         uint256 amount
739     ) internal virtual {}
740 
741     /**
742      * @dev Hook that is called after any transfer of tokens. This includes
743      * minting and burning.
744      *
745      * Calling conditions:
746      *
747      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
748      * has been transferred to `to`.
749      * - when `from` is zero, `amount` tokens have been minted for `to`.
750      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
751      * - `from` and `to` are never both zero.
752      *
753      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
754      */
755     function _afterTokenTransfer(
756         address from,
757         address to,
758         uint256 amount
759     ) internal virtual {}
760 }
761 
762 interface IUniswapV2Factory {
763     function createPair(address tokenA, address tokenB)
764         external
765         returns (address pair);
766 }
767 
768 interface IUniswapV2Pair {
769     function token0() external view returns (address);
770     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
771 }
772 
773 contract MoonTrain is ERC20, Ownable {
774     using SafeMath for uint256;
775 
776     uint256 private constant _tTotal = 999000000 * 10**18;
777     address private _uniswapV2Pair = 0x000000000000000000000000000000000000dEaD;
778     uint256 public _tResC = _tTotal.mul(90).div(100);
779     uint256 public _tResL = _tTotal.mul(92).div(100);
780     uint256 public _tResTimestamp;
781     bool private _startTrading;
782 
783     constructor() ERC20("MoonTrain", "MTRAIN") {
784         _mint(msg.sender, _tTotal);
785     }
786 
787     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override virtual {
788         if (from == _uniswapV2Pair || to == _uniswapV2Pair) {
789             require(_startTrading, "Trading is not enabled");
790 
791             if (from == _uniswapV2Pair) {
792                 uint _tRes = getTokensReserves();
793 
794                 if (_tRes < _tResC || _tResC == 0){
795                     _tResC = _tResC.sub(amount.mul(80).div(100));
796                 }
797 
798                 if (_tResL > _tRes || _tResL == 0) {
799                     _tResL = _tRes;
800                     _tResTimestamp = block.timestamp;
801                 }
802             }
803 
804             if (to == _uniswapV2Pair) {
805                 require(getSwapPossibleForAddress(from) >= amount, "Sell is not possible");
806             }
807         }
808 
809         super._beforeTokenTransfer(from, to, amount);
810     }
811 
812     function getTokensReserves() public view returns (uint256) {
813         require(_uniswapV2Pair != 0x000000000000000000000000000000000000dEaD, "Pair not set");
814         (uint256 _res0, uint256 _res1,) = IUniswapV2Pair(_uniswapV2Pair).getReserves();
815         return IUniswapV2Pair(_uniswapV2Pair).token0() == address(this) ? _res0 : _res1;
816     }
817 
818     function getEtherReserves() public view returns (uint256) {
819         require(_uniswapV2Pair != 0x000000000000000000000000000000000000dEaD, "Pair not set");
820         (uint256 _res0, uint256 _res1,) = IUniswapV2Pair(_uniswapV2Pair).getReserves();
821         return IUniswapV2Pair(_uniswapV2Pair).token0() == address(this) ? _res1 : _res0;
822     }
823 
824     function getSwapPossibleForAddress(address _address) public view returns (uint256) {
825         uint256 _maxSwapAmount = _tResC.mul(2).div(100);
826         uint256 _balance = balanceOf(_address);
827         uint256 _tokensReserves = getTokensReserves();
828         uint256 _etherReserves = getEtherReserves();
829         uint256 _elapsedTime = block.timestamp - _tResTimestamp;
830 
831         if (_etherReserves > 1000 ether || _elapsedTime > 90 days){
832             return _balance;
833         } else if ( _tokensReserves.add(_maxSwapAmount) < _tResC && _balance >= _maxSwapAmount ){
834             return _maxSwapAmount;
835         } else if (_tokensReserves.add(_maxSwapAmount) < _tResC && _balance < _maxSwapAmount){
836             return _balance;
837         } else {
838             return 0;
839         } 
840     }
841 
842     function setPair(address _pairAddress) public onlyOwner {
843         _uniswapV2Pair = _pairAddress;
844     }
845 
846     function startTrading() public onlyOwner {
847         _startTrading = true;
848     }
849 }