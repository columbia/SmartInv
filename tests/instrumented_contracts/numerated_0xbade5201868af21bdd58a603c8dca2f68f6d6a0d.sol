1 /* 
2 
3       ___           ___           ___           ___           ___     
4      /\  \         /\__\         /\__\         /\  \         /\__\    
5     |::\  \       /:/ _/_       /:/ _/_       |::\  \       /:/ _/_   
6     |:|:\  \     /:/ /\__\     /:/ /\__\      |:|:\  \     /:/ /\  \  
7   __|:|\:\  \   /:/ /:/ _/_   /:/ /:/ _/_   __|:|\:\  \   /:/ /::\  \ 
8  /::::|_\:\__\ /:/_/:/ /\__\ /:/_/:/ /\__\ /::::|_\:\__\ /:/_/:/\:\__\
9  \:\~~\  \/__/ \:\/:/ /:/  / \:\/:/ /:/  / \:\~~\  \/__/ \:\/:/ /:/  /
10   \:\  \        \::/_/:/  /   \::/_/:/  /   \:\  \        \::/ /:/  / 
11    \:\  \        \:\/:/  /     \:\/:/  /     \:\  \        \/_/:/  /  
12     \:\__\        \::/  /       \::/  /       \:\__\         /:/  /   
13      \/__/         \/__/         \/__/         \/__/         \/__/   
14 
15 
16     As the popularity of meme tokens grew, so did the number of communities around them. 
17     The $MEEMS cryptocurrency offers a unique utility in the form of a platform for incentivizing user engagement 
18     with specific hashtags. However, these communities were often fragmented and disorganized, with no central hub 
19     for all meme token enthusiasts to come together. As part of its mission, $MEEMS provides a platform that brings 
20     users from different meme token communities together in one place, where collaboration and community take 
21     precedence over competition and fragmentation.
22     
23     Telegram: https://t.me/MeemsToken
24     Website: https://meems.io
25     Supply: 100.000.000 $MEEMS
26     Max Wallet: 2.000.000 $MEEMS
27     Max TX: 2.000.000 $MEEMS
28     Tax: 4%;
29 
30 */
31 
32 
33 // SPDX-License-Identifier: MIT
34 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
35 pragma experimental ABIEncoderV2;
36 
37 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
38 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
39 
40 /* pragma solidity ^0.8.0; */
41 
42 /**
43  * @dev Provides information about the current execution context, including the
44  * sender of the transaction and its data. While these are generally available
45  * via msg.sender and msg.data, they should not be accessed in such a direct
46  * manner, since when dealing with meta-transactions the account sending and
47  * paying for execution may not be the actual sender (as far as an application
48  * is concerned).
49  *
50  * This contract is only required for intermediate, library-like contracts.
51  */
52 
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 
58     function _msgData() internal view virtual returns (bytes calldata) {
59         return msg.data;
60     }
61 }
62 
63 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
64 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
65 
66 /* pragma solidity ^0.8.0; */
67 
68 /* import "../utils/Context.sol"; */
69 
70 /**
71  * @dev Contract module which provides a basic access control mechanism, where
72  * there is an account (an owner) that can be granted exclusive access to
73  * specific functions.
74  *
75  * By default, the owner account will be the one that deploys the contract. This
76  * can later be changed with {transferOwnership}.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 abstract contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor() {
91         _transferOwnership(_msgSender());
92     }
93 
94     /**
95      * @dev Returns the address of the current owner.
96      */
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOwner() {
105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     /**
110      * @dev Leaves the contract without owner. It will not be possible to call
111      * `onlyOwner` functions anymore. Can only be called by the current owner.
112      *
113      * NOTE: Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public virtual onlyOwner {
117         _transferOwnership(address(0));
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
131      * Internal function without access restriction.
132      */
133     function _transferOwnership(address newOwner) internal virtual {
134         address oldOwner = _owner;
135         _owner = newOwner;
136         emit OwnershipTransferred(oldOwner, newOwner);
137     }
138 }
139 
140 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
141 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
142 
143 /* pragma solidity ^0.8.0; */
144 
145 /**
146  * @dev Interface of the ERC20 standard as defined in the EIP.
147  */
148 interface IERC20 {
149     /**
150      * @dev Returns the amount of tokens in existence.
151      */
152     function totalSupply() external view returns (uint256);
153 
154     /**
155      * @dev Returns the amount of tokens owned by `account`.
156      */
157     function balanceOf(address account) external view returns (uint256);
158 
159     /**
160      * @dev Moves `amount` tokens from the caller's account to `recipient`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transfer(address recipient, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Returns the remaining number of tokens that `spender` will be
170      * allowed to spend on behalf of `owner` through {transferFrom}. This is
171      * zero by default.
172      *
173      * This value changes when {approve} or {transferFrom} are called.
174      */
175     function allowance(address owner, address spender) external view returns (uint256);
176 
177     /**
178      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * IMPORTANT: Beware that changing an allowance with this method brings the risk
183      * that someone may use both the old and the new allowance by unfortunate
184      * transaction ordering. One possible solution to mitigate this race
185      * condition is to first reduce the spender's allowance to 0 and set the
186      * desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address spender, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Moves `amount` tokens from `sender` to `recipient` using the
195      * allowance mechanism. `amount` is then deducted from the caller's
196      * allowance.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) external returns (bool);
207 
208     /**
209      * @dev Emitted when `value` tokens are moved from one account (`from`) to
210      * another (`to`).
211      *
212      * Note that `value` may be zero.
213      */
214     event Transfer(address indexed from, address indexed to, uint256 value);
215 
216     /**
217      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
218      * a call to {approve}. `value` is the new allowance.
219      */
220     event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
224 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
225 
226 /* pragma solidity ^0.8.0; */
227 
228 /* import "../IERC20.sol"; */
229 
230 /**
231  * @dev Interface for the optional metadata functions from the ERC20 standard.
232  *
233  * _Available since v4.1._
234  */
235 interface IERC20Metadata is IERC20 {
236     /**
237      * @dev Returns the name of the token.
238      */
239     function name() external view returns (string memory);
240 
241     /**
242      * @dev Returns the symbol of the token.
243      */
244     function symbol() external view returns (string memory);
245 
246     /**
247      * @dev Returns the decimals places of the token.
248      */
249     function decimals() external view returns (uint8);
250 }
251 
252 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
253 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
254 
255 /* pragma solidity ^0.8.0; */
256 
257 /* import "./IERC20.sol"; */
258 /* import "./extensions/IERC20Metadata.sol"; */
259 /* import "../../utils/Context.sol"; */
260 
261 /**
262  * @dev Implementation of the {IERC20} interface.
263  *
264  * This implementation is agnostic to the way tokens are created. This means
265  * that a supply mechanism has to be added in a derived contract using {_mint}.
266  * For a generic mechanism see {ERC20PresetMinterPauser}.
267  *
268  * TIP: For a detailed writeup see our guide
269  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
270  * to implement supply mechanisms].
271  *
272  * We have followed general OpenZeppelin Contracts guidelines: functions revert
273  * instead returning `false` on failure. This behavior is nonetheless
274  * conventional and does not conflict with the expectations of ERC20
275  * applications.
276  *
277  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
278  * This allows applications to reconstruct the allowance for all accounts just
279  * by listening to said events. Other implementations of the EIP may not emit
280  * these events, as it isn't required by the specification.
281  *
282  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
283  * functions have been added to mitigate the well-known issues around setting
284  * allowances. See {IERC20-approve}.
285  */
286 contract ERC20 is Context, IERC20, IERC20Metadata {
287     mapping(address => uint256) private _balances;
288 
289     mapping(address => mapping(address => uint256)) private _allowances;
290 
291     uint256 private _totalSupply;
292 
293     string private _name;
294     string private _symbol;
295 
296     /**
297      * @dev Sets the values for {name} and {symbol}.
298      *
299      * The default value of {decimals} is 18. To select a different value for
300      * {decimals} you should overload it.
301      *
302      * All two of these values are immutable: they can only be set once during
303      * construction.
304      */
305     constructor(string memory name_, string memory symbol_) {
306         _name = name_;
307         _symbol = symbol_;
308     }
309 
310     /**
311      * @dev Returns the name of the token.
312      */
313     function name() public view virtual override returns (string memory) {
314         return _name;
315     }
316 
317     /**
318      * @dev Returns the symbol of the token, usually a shorter version of the
319      * name.
320      */
321     function symbol() public view virtual override returns (string memory) {
322         return _symbol;
323     }
324 
325     /**
326      * @dev Returns the number of decimals used to get its user representation.
327      * For example, if `decimals` equals `2`, a balance of `505` tokens should
328      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
329      *
330      * Tokens usually opt for a value of 18, imitating the relationship between
331      * Ether and Wei. This is the value {ERC20} uses, unless this function is
332      * overridden;
333      *
334      * NOTE: This information is only used for _display_ purposes: it in
335      * no way affects any of the arithmetic of the contract, including
336      * {IERC20-balanceOf} and {IERC20-transfer}.
337      */
338     function decimals() public view virtual override returns (uint8) {
339         return 18;
340     }
341 
342     /**
343      * @dev See {IERC20-totalSupply}.
344      */
345     function totalSupply() public view virtual override returns (uint256) {
346         return _totalSupply;
347     }
348 
349     /**
350      * @dev See {IERC20-balanceOf}.
351      */
352     function balanceOf(address account) public view virtual override returns (uint256) {
353         return _balances[account];
354     }
355 
356     /**
357      * @dev See {IERC20-transfer}.
358      *
359      * Requirements:
360      *
361      * - `recipient` cannot be the zero address.
362      * - the caller must have a balance of at least `amount`.
363      */
364     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
365         _transfer(_msgSender(), recipient, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-allowance}.
371      */
372     function allowance(address owner, address spender) public view virtual override returns (uint256) {
373         return _allowances[owner][spender];
374     }
375 
376     /**
377      * @dev See {IERC20-approve}.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function approve(address spender, uint256 amount) public virtual override returns (bool) {
384         _approve(_msgSender(), spender, amount);
385         return true;
386     }
387 
388     /**
389      * @dev See {IERC20-transferFrom}.
390      *
391      * Emits an {Approval} event indicating the updated allowance. This is not
392      * required by the EIP. See the note at the beginning of {ERC20}.
393      *
394      * Requirements:
395      *
396      * - `sender` and `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      * - the caller must have allowance for ``sender``'s tokens of at least
399      * `amount`.
400      */
401     function transferFrom(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) public virtual override returns (bool) {
406         _transfer(sender, recipient, amount);
407 
408         uint256 currentAllowance = _allowances[sender][_msgSender()];
409         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
410         unchecked {
411             _approve(sender, _msgSender(), currentAllowance - amount);
412         }
413 
414         return true;
415     }
416 
417     /**
418      * @dev Atomically increases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
430         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
431         return true;
432     }
433 
434     /**
435      * @dev Atomically decreases the allowance granted to `spender` by the caller.
436      *
437      * This is an alternative to {approve} that can be used as a mitigation for
438      * problems described in {IERC20-approve}.
439      *
440      * Emits an {Approval} event indicating the updated allowance.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      * - `spender` must have allowance for the caller of at least
446      * `subtractedValue`.
447      */
448     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
449         uint256 currentAllowance = _allowances[_msgSender()][spender];
450         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
451         unchecked {
452             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
453         }
454 
455         return true;
456     }
457 
458     /**
459      * @dev Moves `amount` of tokens from `sender` to `recipient`.
460      *
461      * This internal function is equivalent to {transfer}, and can be used to
462      * e.g. implement automatic token fees, slashing mechanisms, etc.
463      *
464      * Emits a {Transfer} event.
465      *
466      * Requirements:
467      *
468      * - `sender` cannot be the zero address.
469      * - `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      */
472     function _transfer(
473         address sender,
474         address recipient,
475         uint256 amount
476     ) internal virtual {
477         require(sender != address(0), "ERC20: transfer from the zero address");
478         require(recipient != address(0), "ERC20: transfer to the zero address");
479 
480         _beforeTokenTransfer(sender, recipient, amount);
481 
482         uint256 senderBalance = _balances[sender];
483         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
484         unchecked {
485             _balances[sender] = senderBalance - amount;
486         }
487         _balances[recipient] += amount;
488 
489         emit Transfer(sender, recipient, amount);
490 
491         _afterTokenTransfer(sender, recipient, amount);
492     }
493 
494     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
495      * the total supply.
496      *
497      * Emits a {Transfer} event with `from` set to the zero address.
498      *
499      * Requirements:
500      *
501      * - `account` cannot be the zero address.
502      */
503     function _mint(address account, uint256 amount) internal virtual {
504         require(account != address(0), "ERC20: mint to the zero address");
505 
506         _beforeTokenTransfer(address(0), account, amount);
507 
508         _totalSupply += amount;
509         _balances[account] += amount;
510         emit Transfer(address(0), account, amount);
511 
512         _afterTokenTransfer(address(0), account, amount);
513     }
514 
515     /**
516      * @dev Destroys `amount` tokens from `account`, reducing the
517      * total supply.
518      *
519      * Emits a {Transfer} event with `to` set to the zero address.
520      *
521      * Requirements:
522      *
523      * - `account` cannot be the zero address.
524      * - `account` must have at least `amount` tokens.
525      */
526     function _burn(address account, uint256 amount) internal virtual {
527         require(account != address(0), "ERC20: burn from the zero address");
528 
529         _beforeTokenTransfer(account, address(0), amount);
530 
531         uint256 accountBalance = _balances[account];
532         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
533         unchecked {
534             _balances[account] = accountBalance - amount;
535         }
536         _totalSupply -= amount;
537 
538         emit Transfer(account, address(0), amount);
539 
540         _afterTokenTransfer(account, address(0), amount);
541     }
542 
543     /**
544      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
545      *
546      * This internal function is equivalent to `approve`, and can be used to
547      * e.g. set automatic allowances for certain subsystems, etc.
548      *
549      * Emits an {Approval} event.
550      *
551      * Requirements:
552      *
553      * - `owner` cannot be the zero address.
554      * - `spender` cannot be the zero address.
555      */
556     function _approve(
557         address owner,
558         address spender,
559         uint256 amount
560     ) internal virtual {
561         require(owner != address(0), "ERC20: approve from the zero address");
562         require(spender != address(0), "ERC20: approve to the zero address");
563 
564         _allowances[owner][spender] = amount;
565         emit Approval(owner, spender, amount);
566     }
567 
568     /**
569      * @dev Hook that is called before any transfer of tokens. This includes
570      * minting and burning.
571      *
572      * Calling conditions:
573      *
574      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
575      * will be transferred to `to`.
576      * - when `from` is zero, `amount` tokens will be minted for `to`.
577      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
578      * - `from` and `to` are never both zero.
579      *
580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
581      */
582     function _beforeTokenTransfer(
583         address from,
584         address to,
585         uint256 amount
586     ) internal virtual {}
587 
588     /**
589      * @dev Hook that is called after any transfer of tokens. This includes
590      * minting and burning.
591      *
592      * Calling conditions:
593      *
594      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
595      * has been transferred to `to`.
596      * - when `from` is zero, `amount` tokens have been minted for `to`.
597      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
598      * - `from` and `to` are never both zero.
599      *
600      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
601      */
602     function _afterTokenTransfer(
603         address from,
604         address to,
605         uint256 amount
606     ) internal virtual {}
607 }
608 
609 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
610 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
611 
612 /* pragma solidity ^0.8.0; */
613 
614 // CAUTION
615 // This version of SafeMath should only be used with Solidity 0.8 or later,
616 // because it relies on the compiler's built in overflow checks.
617 
618 /**
619  * @dev Wrappers over Solidity's arithmetic operations.
620  *
621  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
622  * now has built in overflow checking.
623  */
624 library SafeMath {
625     /**
626      * @dev Returns the addition of two unsigned integers, with an overflow flag.
627      *
628      * _Available since v3.4._
629      */
630     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
631         unchecked {
632             uint256 c = a + b;
633             if (c < a) return (false, 0);
634             return (true, c);
635         }
636     }
637 
638     /**
639      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
640      *
641      * _Available since v3.4._
642      */
643     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
644         unchecked {
645             if (b > a) return (false, 0);
646             return (true, a - b);
647         }
648     }
649 
650     /**
651      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
652      *
653      * _Available since v3.4._
654      */
655     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
656         unchecked {
657             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
658             // benefit is lost if 'b' is also tested.
659             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
660             if (a == 0) return (true, 0);
661             uint256 c = a * b;
662             if (c / a != b) return (false, 0);
663             return (true, c);
664         }
665     }
666 
667     /**
668      * @dev Returns the division of two unsigned integers, with a division by zero flag.
669      *
670      * _Available since v3.4._
671      */
672     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
673         unchecked {
674             if (b == 0) return (false, 0);
675             return (true, a / b);
676         }
677     }
678 
679     /**
680      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
681      *
682      * _Available since v3.4._
683      */
684     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
685         unchecked {
686             if (b == 0) return (false, 0);
687             return (true, a % b);
688         }
689     }
690 
691     /**
692      * @dev Returns the addition of two unsigned integers, reverting on
693      * overflow.
694      *
695      * Counterpart to Solidity's `+` operator.
696      *
697      * Requirements:
698      *
699      * - Addition cannot overflow.
700      */
701     function add(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a + b;
703     }
704 
705     /**
706      * @dev Returns the subtraction of two unsigned integers, reverting on
707      * overflow (when the result is negative).
708      *
709      * Counterpart to Solidity's `-` operator.
710      *
711      * Requirements:
712      *
713      * - Subtraction cannot overflow.
714      */
715     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a - b;
717     }
718 
719     /**
720      * @dev Returns the multiplication of two unsigned integers, reverting on
721      * overflow.
722      *
723      * Counterpart to Solidity's `*` operator.
724      *
725      * Requirements:
726      *
727      * - Multiplication cannot overflow.
728      */
729     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
730         return a * b;
731     }
732 
733     /**
734      * @dev Returns the integer division of two unsigned integers, reverting on
735      * division by zero. The result is rounded towards zero.
736      *
737      * Counterpart to Solidity's `/` operator.
738      *
739      * Requirements:
740      *
741      * - The divisor cannot be zero.
742      */
743     function div(uint256 a, uint256 b) internal pure returns (uint256) {
744         return a / b;
745     }
746 
747     /**
748      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
749      * reverting when dividing by zero.
750      *
751      * Counterpart to Solidity's `%` operator. This function uses a `revert`
752      * opcode (which leaves remaining gas untouched) while Solidity uses an
753      * invalid opcode to revert (consuming all remaining gas).
754      *
755      * Requirements:
756      *
757      * - The divisor cannot be zero.
758      */
759     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
760         return a % b;
761     }
762 
763     /**
764      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
765      * overflow (when the result is negative).
766      *
767      * CAUTION: This function is deprecated because it requires allocating memory for the error
768      * message unnecessarily. For custom revert reasons use {trySub}.
769      *
770      * Counterpart to Solidity's `-` operator.
771      *
772      * Requirements:
773      *
774      * - Subtraction cannot overflow.
775      */
776     function sub(
777         uint256 a,
778         uint256 b,
779         string memory errorMessage
780     ) internal pure returns (uint256) {
781         unchecked {
782             require(b <= a, errorMessage);
783             return a - b;
784         }
785     }
786 
787     /**
788      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
789      * division by zero. The result is rounded towards zero.
790      *
791      * Counterpart to Solidity's `/` operator. Note: this function uses a
792      * `revert` opcode (which leaves remaining gas untouched) while Solidity
793      * uses an invalid opcode to revert (consuming all remaining gas).
794      *
795      * Requirements:
796      *
797      * - The divisor cannot be zero.
798      */
799     function div(
800         uint256 a,
801         uint256 b,
802         string memory errorMessage
803     ) internal pure returns (uint256) {
804         unchecked {
805             require(b > 0, errorMessage);
806             return a / b;
807         }
808     }
809 
810     /**
811      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
812      * reverting with custom message when dividing by zero.
813      *
814      * CAUTION: This function is deprecated because it requires allocating memory for the error
815      * message unnecessarily. For custom revert reasons use {tryMod}.
816      *
817      * Counterpart to Solidity's `%` operator. This function uses a `revert`
818      * opcode (which leaves remaining gas untouched) while Solidity uses an
819      * invalid opcode to revert (consuming all remaining gas).
820      *
821      * Requirements:
822      *
823      * - The divisor cannot be zero.
824      */
825     function mod(
826         uint256 a,
827         uint256 b,
828         string memory errorMessage
829     ) internal pure returns (uint256) {
830         unchecked {
831             require(b > 0, errorMessage);
832             return a % b;
833         }
834     }
835 }
836 
837 ////// src/IUniswapV2Factory.sol
838 /* pragma solidity 0.8.10; */
839 /* pragma experimental ABIEncoderV2; */
840 
841 interface IUniswapV2Factory {
842     event PairCreated(
843         address indexed token0,
844         address indexed token1,
845         address pair,
846         uint256
847     );
848 
849     function feeTo() external view returns (address);
850 
851     function feeToSetter() external view returns (address);
852 
853     function getPair(address tokenA, address tokenB)
854         external
855         view
856         returns (address pair);
857 
858     function allPairs(uint256) external view returns (address pair);
859 
860     function allPairsLength() external view returns (uint256);
861 
862     function createPair(address tokenA, address tokenB)
863         external
864         returns (address pair);
865 
866     function setFeeTo(address) external;
867 
868     function setFeeToSetter(address) external;
869 }
870 
871 ////// src/IUniswapV2Pair.sol
872 /* pragma solidity 0.8.10; */
873 /* pragma experimental ABIEncoderV2; */
874 
875 interface IUniswapV2Pair {
876     event Approval(
877         address indexed owner,
878         address indexed spender,
879         uint256 value
880     );
881     event Transfer(address indexed from, address indexed to, uint256 value);
882 
883     function name() external pure returns (string memory);
884 
885     function symbol() external pure returns (string memory);
886 
887     function decimals() external pure returns (uint8);
888 
889     function totalSupply() external view returns (uint256);
890 
891     function balanceOf(address owner) external view returns (uint256);
892 
893     function allowance(address owner, address spender)
894         external
895         view
896         returns (uint256);
897 
898     function approve(address spender, uint256 value) external returns (bool);
899 
900     function transfer(address to, uint256 value) external returns (bool);
901 
902     function transferFrom(
903         address from,
904         address to,
905         uint256 value
906     ) external returns (bool);
907 
908     function DOMAIN_SEPARATOR() external view returns (bytes32);
909 
910     function PERMIT_TYPEHASH() external pure returns (bytes32);
911 
912     function nonces(address owner) external view returns (uint256);
913 
914     function permit(
915         address owner,
916         address spender,
917         uint256 value,
918         uint256 deadline,
919         uint8 v,
920         bytes32 r,
921         bytes32 s
922     ) external;
923 
924     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
925     event Burn(
926         address indexed sender,
927         uint256 amount0,
928         uint256 amount1,
929         address indexed to
930     );
931     event Swap(
932         address indexed sender,
933         uint256 amount0In,
934         uint256 amount1In,
935         uint256 amount0Out,
936         uint256 amount1Out,
937         address indexed to
938     );
939     event Sync(uint112 reserve0, uint112 reserve1);
940 
941     function MINIMUM_LIQUIDITY() external pure returns (uint256);
942 
943     function factory() external view returns (address);
944 
945     function token0() external view returns (address);
946 
947     function token1() external view returns (address);
948 
949     function getReserves()
950         external
951         view
952         returns (
953             uint112 reserve0,
954             uint112 reserve1,
955             uint32 blockTimestampLast
956         );
957 
958     function price0CumulativeLast() external view returns (uint256);
959 
960     function price1CumulativeLast() external view returns (uint256);
961 
962     function kLast() external view returns (uint256);
963 
964     function mint(address to) external returns (uint256 liquidity);
965 
966     function burn(address to)
967         external
968         returns (uint256 amount0, uint256 amount1);
969 
970     function swap(
971         uint256 amount0Out,
972         uint256 amount1Out,
973         address to,
974         bytes calldata data
975     ) external;
976 
977     function skim(address to) external;
978 
979     function sync() external;
980 
981     function initialize(address, address) external;
982 }
983 
984 ////// src/IUniswapV2Router02.sol
985 /* pragma solidity 0.8.10; */
986 /* pragma experimental ABIEncoderV2; */
987 
988 interface IUniswapV2Router02 {
989     function factory() external pure returns (address);
990 
991     function WETH() external pure returns (address);
992 
993     function addLiquidity(
994         address tokenA,
995         address tokenB,
996         uint256 amountADesired,
997         uint256 amountBDesired,
998         uint256 amountAMin,
999         uint256 amountBMin,
1000         address to,
1001         uint256 deadline
1002     )
1003         external
1004         returns (
1005             uint256 amountA,
1006             uint256 amountB,
1007             uint256 liquidity
1008         );
1009 
1010     function addLiquidityETH(
1011         address token,
1012         uint256 amountTokenDesired,
1013         uint256 amountTokenMin,
1014         uint256 amountETHMin,
1015         address to,
1016         uint256 deadline
1017     )
1018         external
1019         payable
1020         returns (
1021             uint256 amountToken,
1022             uint256 amountETH,
1023             uint256 liquidity
1024         );
1025 
1026     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1027         uint256 amountIn,
1028         uint256 amountOutMin,
1029         address[] calldata path,
1030         address to,
1031         uint256 deadline
1032     ) external;
1033 
1034     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1035         uint256 amountOutMin,
1036         address[] calldata path,
1037         address to,
1038         uint256 deadline
1039     ) external payable;
1040 
1041     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1042         uint256 amountIn,
1043         uint256 amountOutMin,
1044         address[] calldata path,
1045         address to,
1046         uint256 deadline
1047     ) external;
1048 }
1049 
1050 /* pragma solidity >=0.8.10; */
1051 
1052 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1053 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1054 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1055 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1056 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1057 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1058 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1059 
1060 contract MEEMS is ERC20, Ownable {
1061     using SafeMath for uint256;
1062 
1063     IUniswapV2Router02 public immutable uniswapV2Router;
1064     address public immutable uniswapV2Pair;
1065     address public constant deadAddress = address(0xdead);
1066 
1067     bool private swapping;
1068 
1069     address public marketingWallet;
1070     address public devWallet;
1071 
1072     uint256 public maxTransactionAmount;
1073     uint256 public swapTokensAtAmount;
1074     uint256 public maxWallet;
1075 
1076     uint256 public percentForLPBurn = 25; // 25 = .25%
1077     bool public lpBurnEnabled = false;
1078     uint256 public lpBurnFrequency = 3600 seconds;
1079     uint256 public lastLpBurnTime;
1080 
1081     uint256 public manualBurnFrequency = 30 minutes;
1082     uint256 public lastManualLpBurnTime;
1083 
1084     bool public limitsInEffect = true;
1085     bool public tradingActive = false;
1086     bool public swapEnabled = false;
1087 
1088     // Anti-bot and anti-whale mappings and variables
1089     mapping(address => uint256) private _holderLastTransferTimestamp; 
1090     bool public transferDelayEnabled = true;
1091 
1092     uint256 public buyTotalFees;
1093     uint256 public buyMarketingFee;
1094     uint256 public buyLiquidityFee;
1095     uint256 public buyDevFee;
1096 
1097     uint256 public sellTotalFees;
1098     uint256 public sellMarketingFee;
1099     uint256 public sellLiquidityFee;
1100     uint256 public sellDevFee;
1101 
1102     uint256 public tokensForMarketing;
1103     uint256 public tokensForLiquidity;
1104     uint256 public tokensForDev;
1105 
1106     /******************/
1107 
1108     // exlcude from fees and max transaction amount
1109     mapping(address => bool) private _isExcludedFromFees;
1110     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1111 
1112     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1113     // could be subject to a maximum transfer amount
1114     mapping(address => bool) public automatedMarketMakerPairs;
1115 
1116     event UpdateUniswapV2Router(
1117         address indexed newAddress,
1118         address indexed oldAddress
1119     );
1120 
1121     event ExcludeFromFees(address indexed account, bool isExcluded);
1122 
1123     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1124 
1125     event marketingWalletUpdated(
1126         address indexed newWallet,
1127         address indexed oldWallet
1128     );
1129 
1130     event devWalletUpdated(
1131         address indexed newWallet,
1132         address indexed oldWallet
1133     );
1134 
1135     event SwapAndLiquify(
1136         uint256 tokensSwapped,
1137         uint256 ethReceived,
1138         uint256 tokensIntoLiquidity
1139     );
1140 
1141     event AutoNukeLP();
1142 
1143     event ManualNukeLP();
1144 
1145     constructor() ERC20("Meems.io", "MEEMS") {
1146         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1147             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1148         );
1149 
1150         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1151         uniswapV2Router = _uniswapV2Router;
1152 
1153         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1154             .createPair(address(this), _uniswapV2Router.WETH());
1155         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1156         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1157 
1158         uint256 _buyMarketingFee = 20; //LaunchTax
1159         uint256 _buyLiquidityFee = 0;
1160         uint256 _buyDevFee = 0;
1161 
1162         uint256 _sellMarketingFee = 40; //LaunchTax
1163         uint256 _sellLiquidityFee = 0;
1164         uint256 _sellDevFee = 0;
1165 
1166         uint256 totalSupply = 100_000_000 * 1e18;
1167 
1168         maxTransactionAmount = 2_000_000 * 1e18;
1169         maxWallet = 2_000_000 * 1e18;
1170         swapTokensAtAmount = 400_000 * 1e18;
1171 
1172         buyMarketingFee = _buyMarketingFee;
1173         buyLiquidityFee = _buyLiquidityFee;
1174         buyDevFee = _buyDevFee;
1175         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1176 
1177         sellMarketingFee = _sellMarketingFee;
1178         sellLiquidityFee = _sellLiquidityFee;
1179         sellDevFee = _sellDevFee;
1180         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1181 
1182         marketingWallet = address(0xa598F16bc0bFb9e88aBF01b5347a167Cc570592A); 
1183         devWallet = address(0xa598F16bc0bFb9e88aBF01b5347a167Cc570592A); 
1184 
1185         // exclude from paying fees or having max transaction amount
1186         excludeFromFees(owner(), true);
1187         excludeFromFees(address(this), true);
1188         excludeFromFees(address(0xdead), true);
1189 
1190         excludeFromMaxTransaction(owner(), true);
1191         excludeFromMaxTransaction(address(this), true);
1192         excludeFromMaxTransaction(address(0xdead), true);
1193 
1194         /*
1195             _mint is an internal function in ERC20.sol that is only called here,
1196             and CANNOT be called ever again
1197         */
1198         _mint(msg.sender, totalSupply);
1199     }
1200 
1201     receive() external payable {}
1202 
1203     // once enabled, can never be turned off
1204     function enableTrading() external onlyOwner {
1205         tradingActive = true;
1206         swapEnabled = true;
1207         lastLpBurnTime = block.timestamp;
1208     }
1209 
1210     // remove limits after token is stable
1211     function removeLimits() external onlyOwner returns (bool) {
1212         limitsInEffect = false;
1213         return true;
1214     }
1215 
1216     // disable Transfer delay - cannot be reenabled
1217     function disableTransferDelay() external onlyOwner returns (bool) {
1218         transferDelayEnabled = false;
1219         return true;
1220     }
1221 
1222     // change the minimum amount of tokens to sell from fees
1223     function updateSwapTokensAtAmount(uint256 newAmount)
1224         external
1225         onlyOwner
1226         returns (bool)
1227     {
1228         require(
1229             newAmount >= (totalSupply() * 1) / 100000,
1230             "Swap amount cannot be lower than 0.001% total supply."
1231         );
1232         require(
1233             newAmount <= (totalSupply() * 5) / 1000,
1234             "Swap amount cannot be higher than 0.5% total supply."
1235         );
1236         swapTokensAtAmount = newAmount;
1237         return true;
1238     }
1239 
1240     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1241         require(
1242             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1243             "Cannot set maxTransactionAmount lower than 0.1%"
1244         );
1245         maxTransactionAmount = newNum * (10**18);
1246     }
1247 
1248     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1249         require(
1250             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1251             "Cannot set maxWallet lower than 0.5%"
1252         );
1253         maxWallet = newNum * (10**18);
1254     }
1255 
1256     function excludeFromMaxTransaction(address updAds, bool isEx)
1257         public
1258         onlyOwner
1259     {
1260         _isExcludedMaxTransactionAmount[updAds] = isEx;
1261     }
1262 
1263     // only use to disable contract sales if absolutely necessary (emergency use only)
1264     function updateSwapEnabled(bool enabled) external onlyOwner {
1265         swapEnabled = enabled;
1266     }
1267 
1268     function updateBuyFees(
1269         uint256 _marketingFee,
1270         uint256 _liquidityFee,
1271         uint256 _devFee
1272     ) external onlyOwner {
1273         buyMarketingFee = _marketingFee;
1274         buyLiquidityFee = _liquidityFee;
1275         buyDevFee = _devFee;
1276         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1277         require(buyTotalFees <= 5, "5% is maximum Tax for Buy.");
1278     }
1279 
1280     function updateSellFees(
1281         uint256 _marketingFee,
1282         uint256 _liquidityFee,
1283         uint256 _devFee
1284     ) external onlyOwner {
1285         sellMarketingFee = _marketingFee;
1286         sellLiquidityFee = _liquidityFee;
1287         sellDevFee = _devFee;
1288         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1289         require(sellTotalFees <= 5, "5% is maximum Tax for Buy.");
1290     }
1291 
1292     function excludeFromFees(address account, bool excluded) public onlyOwner {
1293         _isExcludedFromFees[account] = excluded;
1294         emit ExcludeFromFees(account, excluded);
1295     }
1296 
1297     function setAutomatedMarketMakerPair(address pair, bool value)
1298         public
1299         onlyOwner
1300     {
1301         require(
1302             pair != uniswapV2Pair,
1303             "The pair cannot be removed from automatedMarketMakerPairs"
1304         );
1305 
1306         _setAutomatedMarketMakerPair(pair, value);
1307     }
1308 
1309     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1310         automatedMarketMakerPairs[pair] = value;
1311 
1312         emit SetAutomatedMarketMakerPair(pair, value);
1313     }
1314 
1315     function updateMarketingWallet(address newMarketingWallet)
1316         external
1317         onlyOwner
1318     {
1319         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1320         marketingWallet = newMarketingWallet;
1321     }
1322 
1323     function updateDevWallet(address newWallet) external onlyOwner {
1324         emit devWalletUpdated(newWallet, devWallet);
1325         devWallet = newWallet;
1326     }
1327 
1328     function isExcludedFromFees(address account) public view returns (bool) {
1329         return _isExcludedFromFees[account];
1330     }
1331 
1332     event BoughtEarly(address indexed sniper);
1333 
1334     function _transfer(
1335         address from,
1336         address to,
1337         uint256 amount
1338     ) internal override {
1339         require(from != address(0), "ERC20: transfer from the zero address");
1340         require(to != address(0), "ERC20: transfer to the zero address");
1341 
1342         if (amount == 0) {
1343             super._transfer(from, to, 0);
1344             return;
1345         }
1346 
1347         if (limitsInEffect) {
1348             if (
1349                 from != owner() &&
1350                 to != owner() &&
1351                 to != address(0) &&
1352                 to != address(0xdead) &&
1353                 !swapping
1354             ) {
1355                 if (!tradingActive) {
1356                     require(
1357                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1358                         "Trading is not active."
1359                     );
1360                 }
1361 
1362                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1363                 if (transferDelayEnabled) {
1364                     if (
1365                         to != owner() &&
1366                         to != address(uniswapV2Router) &&
1367                         to != address(uniswapV2Pair)
1368                     ) {
1369                         require(
1370                             _holderLastTransferTimestamp[tx.origin] <
1371                                 block.number,
1372                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1373                         );
1374                         _holderLastTransferTimestamp[tx.origin] = block.number;
1375                     }
1376                 }
1377 
1378                 //when buy
1379                 if (
1380                     automatedMarketMakerPairs[from] &&
1381                     !_isExcludedMaxTransactionAmount[to]
1382                 ) {
1383                     require(
1384                         amount <= maxTransactionAmount,
1385                         "Buy transfer amount exceeds the maxTransactionAmount."
1386                     );
1387                     require(
1388                         amount + balanceOf(to) <= maxWallet,
1389                         "Max wallet exceeded"
1390                     );
1391                 }
1392                 //when sell
1393                 else if (
1394                     automatedMarketMakerPairs[to] &&
1395                     !_isExcludedMaxTransactionAmount[from]
1396                 ) {
1397                     require(
1398                         amount <= maxTransactionAmount,
1399                         "Sell transfer amount exceeds the maxTransactionAmount."
1400                     );
1401                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1402                     require(
1403                         amount + balanceOf(to) <= maxWallet,
1404                         "Max wallet exceeded"
1405                     );
1406                 }
1407             }
1408         }
1409 
1410         uint256 contractTokenBalance = balanceOf(address(this));
1411 
1412         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1413 
1414         if (
1415             canSwap &&
1416             swapEnabled &&
1417             !swapping &&
1418             !automatedMarketMakerPairs[from] &&
1419             !_isExcludedFromFees[from] &&
1420             !_isExcludedFromFees[to]
1421         ) {
1422             swapping = true;
1423 
1424             swapBack();
1425 
1426             swapping = false;
1427         }
1428 
1429         if (
1430             !swapping &&
1431             automatedMarketMakerPairs[to] &&
1432             lpBurnEnabled &&
1433             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1434             !_isExcludedFromFees[from]
1435         ) {
1436             autoBurnLiquidityPairTokens();
1437         }
1438 
1439         bool takeFee = !swapping;
1440 
1441         // if any account belongs to _isExcludedFromFee account then remove the fee
1442         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1443             takeFee = false;
1444         }
1445 
1446         uint256 fees = 0;
1447         // only take fees on buys/sells, do not take on wallet transfers
1448         if (takeFee) {
1449             // on sell
1450             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1451                 fees = amount.mul(sellTotalFees).div(100);
1452                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1453                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1454                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1455             }
1456             // on buy
1457             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1458                 fees = amount.mul(buyTotalFees).div(100);
1459                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1460                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1461                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1462             }
1463 
1464             if (fees > 0) {
1465                 super._transfer(from, address(this), fees);
1466             }
1467 
1468             amount -= fees;
1469         }
1470 
1471         super._transfer(from, to, amount);
1472     }
1473 
1474     function swapTokensForEth(uint256 tokenAmount) private {
1475         // generate the uniswap pair path of token -> weth
1476         address[] memory path = new address[](2);
1477         path[0] = address(this);
1478         path[1] = uniswapV2Router.WETH();
1479 
1480         _approve(address(this), address(uniswapV2Router), tokenAmount);
1481 
1482         // make the swap
1483         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1484             tokenAmount,
1485             0, // accept any amount of ETH
1486             path,
1487             address(this),
1488             block.timestamp
1489         );
1490     }
1491 
1492     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1493         // approve token transfer to cover all possible scenarios
1494         _approve(address(this), address(uniswapV2Router), tokenAmount);
1495 
1496         // add the liquidity
1497         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1498             address(this),
1499             tokenAmount,
1500             0, // slippage is unavoidable
1501             0, // slippage is unavoidable
1502             deadAddress,
1503             block.timestamp
1504         );
1505     }
1506 
1507     function swapBack() private {
1508         uint256 contractBalance = balanceOf(address(this));
1509         uint256 totalTokensToSwap = tokensForLiquidity +
1510             tokensForMarketing +
1511             tokensForDev;
1512         bool success;
1513 
1514         if (contractBalance == 0 || totalTokensToSwap == 0) {
1515             return;
1516         }
1517 
1518         if (contractBalance > swapTokensAtAmount * 20) {
1519             contractBalance = swapTokensAtAmount * 20;
1520         }
1521 
1522         // Halve the amount of liquidity tokens
1523         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1524             totalTokensToSwap /
1525             2;
1526         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1527 
1528         uint256 initialETHBalance = address(this).balance;
1529 
1530         swapTokensForEth(amountToSwapForETH);
1531 
1532         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1533 
1534         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1535             totalTokensToSwap
1536         );
1537         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1538 
1539         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1540 
1541         tokensForLiquidity = 0;
1542         tokensForMarketing = 0;
1543         tokensForDev = 0;
1544 
1545         (success, ) = address(devWallet).call{value: ethForDev}("");
1546 
1547         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1548             addLiquidity(liquidityTokens, ethForLiquidity);
1549             emit SwapAndLiquify(
1550                 amountToSwapForETH,
1551                 ethForLiquidity,
1552                 tokensForLiquidity
1553             );
1554         }
1555 
1556         (success, ) = address(marketingWallet).call{
1557             value: address(this).balance
1558         }("");
1559     }
1560 
1561     function setAutoLPBurnSettings(
1562         uint256 _frequencyInSeconds,
1563         uint256 _percent,
1564         bool _Enabled
1565     ) external onlyOwner {
1566         require(
1567             _frequencyInSeconds >= 600,
1568             "cannot set buyback more often than every 10 minutes"
1569         );
1570         require(
1571             _percent <= 1000 && _percent >= 0,
1572             "Must set auto LP burn percent between 0% and 10%"
1573         );
1574         lpBurnFrequency = _frequencyInSeconds;
1575         percentForLPBurn = _percent;
1576         lpBurnEnabled = _Enabled;
1577     }
1578 
1579     function autoBurnLiquidityPairTokens() internal returns (bool) {
1580         lastLpBurnTime = block.timestamp;
1581 
1582         // get balance of liquidity pair
1583         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1584 
1585         // calculate amount to burn
1586         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1587             10000
1588         );
1589 
1590         // pull tokens from pancakePair liquidity and move to dead address permanently
1591         if (amountToBurn > 0) {
1592             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1593         }
1594 
1595         //sync price since this is not in a swap transaction!
1596         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1597         pair.sync();
1598         emit AutoNukeLP();
1599         return true;
1600     }
1601 
1602     function manualBurnLiquidityPairTokens(uint256 percent)
1603         external
1604         onlyOwner
1605         returns (bool)
1606     {
1607         require(
1608             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1609             "Must wait for cooldown to finish"
1610         );
1611         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1612         lastManualLpBurnTime = block.timestamp;
1613 
1614         // get balance of liquidity pair
1615         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1616 
1617         // calculate amount to burn
1618         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1619 
1620         // pull tokens from pancakePair liquidity and move to dead address permanently
1621         if (amountToBurn > 0) {
1622             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1623         }
1624 
1625         //sync price since this is not in a swap transaction!
1626         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1627         pair.sync();
1628         emit ManualNukeLP();
1629         return true;
1630     }
1631 }