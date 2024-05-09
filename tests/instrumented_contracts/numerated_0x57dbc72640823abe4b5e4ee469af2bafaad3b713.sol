1 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
2 /*
3 ███╗░░██╗░█████╗░██╗░░░██╗░██████╗░██╗░░██╗████████╗██╗██╗░░░██╗░██████╗
4 ████╗░██║██╔══██╗██║░░░██║██╔════╝░██║░░██║╚══██╔══╝██║██║░░░██║██╔════╝
5 ██╔██╗██║███████║██║░░░██║██║░░██╗░███████║░░░██║░░░██║██║░░░██║╚█████╗░
6 ██║╚████║██╔══██║██║░░░██║██║░░╚██╗██╔══██║░░░██║░░░██║██║░░░██║░╚═══██╗
7 ██║░╚███║██║░░██║╚██████╔╝╚██████╔╝██║░░██║░░░██║░░░██║╚██████╔╝██████╔╝
8 ╚═╝░░╚══╝╚═╝░░╚═╝░╚═════╝░░╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚═════╝░╚═════╝░
9 
10 ███╗░░░███╗░█████╗░██╗░░██╗██╗███╗░░░███╗██╗░░░██╗░██████╗
11 ████╗░████║██╔══██╗╚██╗██╔╝██║████╗░████║██║░░░██║██╔════╝
12 ██╔████╔██║███████║░╚███╔╝░██║██╔████╔██║██║░░░██║╚█████╗░
13 ██║╚██╔╝██║██╔══██║░██╔██╗░██║██║╚██╔╝██║██║░░░██║░╚═══██╗
14 ██║░╚═╝░██║██║░░██║██╔╝╚██╗██║██║░╚═╝░██║╚██████╔╝██████╔╝
15 ╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝░╚═════╝░╚═════╝░                          ░                                                                                        //
16 */
17 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
18 
19 /*
20  * https://t.me/NaughtiusMaximusElon
21  * 
22  */
23 
24 // SPDX-License-Identifier: MIT
25 
26 pragma solidity ^0.8.0;
27 
28 interface IUniswapV2Factory {
29     function createPair(address tokenA, address tokenB)
30         external
31         returns (address pair);
32 }
33 
34 interface IUniswapV2Router01 {
35     function factory() external pure returns (address);
36 
37     function WETH() external pure returns (address);
38 
39     function addLiquidityETH(
40         address token,
41         uint256 amountTokenDesired,
42         uint256 amountTokenMin,
43         uint256 amountETHMin,
44         address to,
45         uint256 deadline
46     )
47         external
48         payable
49         returns (
50             uint256 amountToken,
51             uint256 amountETH,
52             uint256 liquidity
53         );
54 }
55 
56 interface IUniswapV2Router02 is IUniswapV2Router01 {
57     function swapExactTokensForETHSupportingFeeOnTransferTokens(
58         uint256 amountIn,
59         uint256 amountOutMin,
60         address[] calldata path,
61         address to,
62         uint256 deadline
63     ) external;
64 }
65 
66 interface IUniswapV2Pair {
67     function sync() external;
68 }
69 
70 /**
71  * @dev Provides information about the current execution context, including the
72  * sender of the transaction and its data. While these are generally available
73  * via msg.sender and msg.data, they should not be accessed in such a direct
74  * manner, since when dealing with meta-transactions the account sending and
75  * paying for execution may not be the actual sender (as far as an application
76  * is concerned).
77  *
78  * This contract is only required for intermediate, library-like contracts.
79  */
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view virtual returns (bytes calldata) {
86         return msg.data;
87     }
88 }
89 
90 /**
91  * @dev Contract module which provides a basic access control mechanism, where
92  * there is an account (an owner) that can be granted exclusive access to
93  * specific functions.
94  *
95  * By default, the owner account will be the one that deploys the contract. This
96  * can later be changed with {transferOwnership}.
97  *
98  * This module is used through inheritance. It will make available the modifier
99  * `onlyOwner`, which can be applied to your functions to restrict their use to
100  * the owner.
101  */
102 abstract contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(
106         address indexed previousOwner,
107         address indexed newOwner
108     );
109 
110     /**
111      * @dev Initializes the contract setting the deployer as the initial owner.
112      */
113     constructor() {
114         _transferOwnership(_msgSender());
115     }
116 
117     /**
118      * @dev Returns the address of the current owner.
119      */
120     function owner() public view virtual returns (address) {
121         return _owner;
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the owner.
126      */
127     modifier onlyOwner() {
128         require(owner() == _msgSender(), "Ownable: caller is not the owner");
129         _;
130     }
131 
132     /**
133      * @dev Leaves the contract without owner. It will not be possible to call
134      * `onlyOwner` functions anymore. Can only be called by the current owner.
135      *
136      * NOTE: Renouncing ownership will leave the contract without an owner,
137      * thereby removing any functionality that is only available to the owner.
138      */
139     function renounceOwnership() public virtual onlyOwner {
140         _transferOwnership(address(0));
141     }
142 
143     /**
144      * @dev Transfers ownership of the contract to a new account (`newOwner`).
145      * Can only be called by the current owner.
146      */
147     function transferOwnership(address newOwner) public virtual onlyOwner {
148         require(
149             newOwner != address(0),
150             "Ownable: new owner is the zero address"
151         );
152         _transferOwnership(newOwner);
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Internal function without access restriction.
158      */
159     function _transferOwnership(address newOwner) internal virtual {
160         address oldOwner = _owner;
161         _owner = newOwner;
162         emit OwnershipTransferred(oldOwner, newOwner);
163     }
164 }
165 
166 /**
167  * @dev Interface of the ERC20 standard as defined in the EIP.
168  */
169 interface IERC20 {
170     /**
171      * @dev Returns the amount of tokens in existence.
172      */
173     function totalSupply() external view returns (uint256);
174 
175     /**
176      * @dev Returns the amount of tokens owned by `account`.
177      */
178     function balanceOf(address account) external view returns (uint256);
179 
180     /**
181      * @dev Moves `amount` tokens from the caller's account to `recipient`.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transfer(address recipient, uint256 amount)
188         external
189         returns (bool);
190 
191     /**
192      * @dev Returns the remaining number of tokens that `spender` will be
193      * allowed to spend on behalf of `owner` through {transferFrom}. This is
194      * zero by default.
195      *
196      * This value changes when {approve} or {transferFrom} are called.
197      */
198     function allowance(address owner, address spender)
199         external
200         view
201         returns (uint256);
202 
203     /**
204      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * IMPORTANT: Beware that changing an allowance with this method brings the risk
209      * that someone may use both the old and the new allowance by unfortunate
210      * transaction ordering. One possible solution to mitigate this race
211      * condition is to first reduce the spender's allowance to 0 and set the
212      * desired value afterwards:
213      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214      *
215      * Emits an {Approval} event.
216      */
217     function approve(address spender, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Moves `amount` tokens from `sender` to `recipient` using the
221      * allowance mechanism. `amount` is then deducted from the caller's
222      * allowance.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transferFrom(
229         address sender,
230         address recipient,
231         uint256 amount
232     ) external returns (bool);
233 
234     /**
235      * @dev Emitted when `value` tokens are moved from one account (`from`) to
236      * another (`to`).
237      *
238      * Note that `value` may be zero.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 value);
241 
242     /**
243      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
244      * a call to {approve}. `value` is the new allowance.
245      */
246     event Approval(
247         address indexed owner,
248         address indexed spender,
249         uint256 value
250     );
251 }
252 
253 /**
254  * @dev Interface for the optional metadata functions from the ERC20 standard.
255  *
256  * _Available since v4.1._
257  */
258 interface IERC20Metadata is IERC20 {
259     /**
260      * @dev Returns the name of the token.
261      */
262     function name() external view returns (string memory);
263 
264     /**
265      * @dev Returns the symbol of the token.
266      */
267     function symbol() external view returns (string memory);
268 
269     /**
270      * @dev Returns the decimals places of the token.
271      */
272     function decimals() external view returns (uint8);
273 }
274 
275 /**
276  * @dev Implementation of the {IERC20} interface.
277  *
278  * This implementation is agnostic to the way tokens are created. This means
279  * that a supply mechanism has to be added in a derived contract using {_mint}.
280  * For a generic mechanism see {ERC20PresetMinterPauser}.
281  *
282  * TIP: For a detailed writeup see our guide
283  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
284  * to implement supply mechanisms].
285  *
286  * We have followed general OpenZeppelin Contracts guidelines: functions revert
287  * instead returning `false` on failure. This behavior is nonetheless
288  * conventional and does not conflict with the expectations of ERC20
289  * applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20, IERC20Metadata {
301     mapping(address => uint256) private _balances;
302 
303     mapping(address => mapping(address => uint256)) private _allowances;
304 
305     uint256 private _totalSupply;
306 
307     string private _name;
308     string private _symbol;
309 
310     /**
311      * @dev Sets the values for {name} and {symbol}.
312      *
313      * The default value of {decimals} is 18. To select a different value for
314      * {decimals} you should overload it.
315      *
316      * All two of these values are immutable: they can only be set once during
317      * construction.
318      */
319     constructor(string memory name_, string memory symbol_) {
320         _name = name_;
321         _symbol = symbol_;
322     }
323 
324     /**
325      * @dev Returns the name of the token.
326      */
327     function name() public view virtual override returns (string memory) {
328         return _name;
329     }
330 
331     /**
332      * @dev Returns the symbol of the token, usually a shorter version of the
333      * name.
334      */
335     function symbol() public view virtual override returns (string memory) {
336         return _symbol;
337     }
338 
339     /**
340      * @dev Returns the number of decimals used to get its user representation.
341      * For example, if `decimals` equals `2`, a balance of `505` tokens should
342      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
343      *
344      * Tokens usually opt for a value of 18, imitating the relationship between
345      * Ether and Wei. This is the value {ERC20} uses, unless this function is
346      * overridden;
347      *
348      * NOTE: This information is only used for _display_ purposes: it in
349      * no way affects any of the arithmetic of the contract, including
350      * {IERC20-balanceOf} and {IERC20-transfer}.
351      */
352     function decimals() public view virtual override returns (uint8) {
353         return 18;
354     }
355 
356     /**
357      * @dev See {IERC20-totalSupply}.
358      */
359     function totalSupply() public view virtual override returns (uint256) {
360         return _totalSupply;
361     }
362 
363     /**
364      * @dev See {IERC20-balanceOf}.
365      */
366     function balanceOf(address account)
367         public
368         view
369         virtual
370         override
371         returns (uint256)
372     {
373         return _balances[account];
374     }
375 
376     /**
377      * @dev See {IERC20-transfer}.
378      *
379      * Requirements:
380      *
381      * - `recipient` cannot be the zero address.
382      * - the caller must have a balance of at least `amount`.
383      */
384     function transfer(address recipient, uint256 amount)
385         public
386         virtual
387         override
388         returns (bool)
389     {
390         _transfer(_msgSender(), recipient, amount);
391         return true;
392     }
393 
394     /**
395      * @dev See {IERC20-allowance}.
396      */
397     function allowance(address owner, address spender)
398         public
399         view
400         virtual
401         override
402         returns (uint256)
403     {
404         return _allowances[owner][spender];
405     }
406 
407     /**
408      * @dev See {IERC20-approve}.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      */
414     function approve(address spender, uint256 amount)
415         public
416         virtual
417         override
418         returns (bool)
419     {
420         _approve(_msgSender(), spender, amount);
421         return true;
422     }
423 
424     /**
425      * @dev See {IERC20-transferFrom}.
426      *
427      * Emits an {Approval} event indicating the updated allowance. This is not
428      * required by the EIP. See the note at the beginning of {ERC20}.
429      *
430      * Requirements:
431      *
432      * - `sender` and `recipient` cannot be the zero address.
433      * - `sender` must have a balance of at least `amount`.
434      * - the caller must have allowance for ``sender``'s tokens of at least
435      * `amount`.
436      */
437     function transferFrom(
438         address sender,
439         address recipient,
440         uint256 amount
441     ) public virtual override returns (bool) {
442         _transfer(sender, recipient, amount);
443 
444         uint256 currentAllowance = _allowances[sender][_msgSender()];
445         require(
446             currentAllowance >= amount,
447             "ERC20: transfer amount exceeds allowance"
448         );
449         unchecked {
450             _approve(sender, _msgSender(), currentAllowance - amount);
451         }
452 
453         return true;
454     }
455 
456     /**
457      * @dev Atomically increases the allowance granted to `spender` by the caller.
458      *
459      * This is an alternative to {approve} that can be used as a mitigation for
460      * problems described in {IERC20-approve}.
461      *
462      * Emits an {Approval} event indicating the updated allowance.
463      *
464      * Requirements:
465      *
466      * - `spender` cannot be the zero address.
467      */
468     function increaseAllowance(address spender, uint256 addedValue)
469         public
470         virtual
471         returns (bool)
472     {
473         _approve(
474             _msgSender(),
475             spender,
476             _allowances[_msgSender()][spender] + addedValue
477         );
478         return true;
479     }
480 
481     /**
482      * @dev Atomically decreases the allowance granted to `spender` by the caller.
483      *
484      * This is an alternative to {approve} that can be used as a mitigation for
485      * problems described in {IERC20-approve}.
486      *
487      * Emits an {Approval} event indicating the updated allowance.
488      *
489      * Requirements:
490      *
491      * - `spender` cannot be the zero address.
492      * - `spender` must have allowance for the caller of at least
493      * `subtractedValue`.
494      */
495     function decreaseAllowance(address spender, uint256 subtractedValue)
496         public
497         virtual
498         returns (bool)
499     {
500         uint256 currentAllowance = _allowances[_msgSender()][spender];
501         require(
502             currentAllowance >= subtractedValue,
503             "ERC20: decreased allowance below zero"
504         );
505         unchecked {
506             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
507         }
508 
509         return true;
510     }
511 
512     /**
513      * @dev Moves `amount` of tokens from `sender` to `recipient`.
514      *
515      * This internal function is equivalent to {transfer}, and can be used to
516      * e.g. implement automatic token fees, slashing mechanisms, etc.
517      *
518      * Emits a {Transfer} event.
519      *
520      * Requirements:
521      *
522      * - `sender` cannot be the zero address.
523      * - `recipient` cannot be the zero address.
524      * - `sender` must have a balance of at least `amount`.
525      */
526     function _transfer(
527         address sender,
528         address recipient,
529         uint256 amount
530     ) internal virtual {
531         require(sender != address(0), "ERC20: transfer from the zero address");
532         require(recipient != address(0), "ERC20: transfer to the zero address");
533 
534         _beforeTokenTransfer(sender, recipient, amount);
535 
536         uint256 senderBalance = _balances[sender];
537         require(
538             senderBalance >= amount,
539             "ERC20: transfer amount exceeds balance"
540         );
541         unchecked {
542             _balances[sender] = senderBalance - amount;
543         }
544         _balances[recipient] += amount;
545 
546         emit Transfer(sender, recipient, amount);
547 
548         _afterTokenTransfer(sender, recipient, amount);
549     }
550 
551     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
552      * the total supply.
553      *
554      * Emits a {Transfer} event with `from` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      */
560     function _mint(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: mint to the zero address");
562 
563         _beforeTokenTransfer(address(0), account, amount);
564 
565         _totalSupply += amount;
566         _balances[account] += amount;
567         emit Transfer(address(0), account, amount);
568 
569         _afterTokenTransfer(address(0), account, amount);
570     }
571 
572     /**
573      * @dev Destroys `amount` tokens from `account`, reducing the
574      * total supply.
575      *
576      * Emits a {Transfer} event with `to` set to the zero address.
577      *
578      * Requirements:
579      *
580      * - `account` cannot be the zero address.
581      * - `account` must have at least `amount` tokens.
582      */
583     function _burn(address account, uint256 amount) internal virtual {
584         require(account != address(0), "ERC20: burn from the zero address");
585 
586         _beforeTokenTransfer(account, address(0), amount);
587 
588         uint256 accountBalance = _balances[account];
589         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
590         unchecked {
591             _balances[account] = accountBalance - amount;
592         }
593         _totalSupply -= amount;
594 
595         emit Transfer(account, address(0), amount);
596 
597         _afterTokenTransfer(account, address(0), amount);
598     }
599 
600     /**
601      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
602      *
603      * This internal function is equivalent to `approve`, and can be used to
604      * e.g. set automatic allowances for certain subsystems, etc.
605      *
606      * Emits an {Approval} event.
607      *
608      * Requirements:
609      *
610      * - `owner` cannot be the zero address.
611      * - `spender` cannot be the zero address.
612      */
613     function _approve(
614         address owner,
615         address spender,
616         uint256 amount
617     ) internal virtual {
618         require(owner != address(0), "ERC20: approve from the zero address");
619         require(spender != address(0), "ERC20: approve to the zero address");
620 
621         _allowances[owner][spender] = amount;
622         emit Approval(owner, spender, amount);
623     }
624 
625     /**
626      * @dev Hook that is called before any transfer of tokens. This includes
627      * minting and burning.
628      *
629      * Calling conditions:
630      *
631      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
632      * will be transferred to `to`.
633      * - when `from` is zero, `amount` tokens will be minted for `to`.
634      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
635      * - `from` and `to` are never both zero.
636      *
637      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
638      */
639     function _beforeTokenTransfer(
640         address from,
641         address to,
642         uint256 amount
643     ) internal virtual {}
644 
645     /**
646      * @dev Hook that is called after any transfer of tokens. This includes
647      * minting and burning.
648      *
649      * Calling conditions:
650      *
651      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
652      * has been transferred to `to`.
653      * - when `from` is zero, `amount` tokens have been minted for `to`.
654      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
655      * - `from` and `to` are never both zero.
656      *
657      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
658      */
659     function _afterTokenTransfer(
660         address from,
661         address to,
662         uint256 amount
663     ) internal virtual {}
664 }
665 
666 // CAUTION
667 // This version of SafeMath should only be used with Solidity 0.8 or later,
668 // because it relies on the compiler's built in overflow checks.
669 
670 /**
671  * @dev Wrappers over Solidity's arithmetic operations.
672  *
673  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
674  * now has built in overflow checking.
675  */
676 library SafeMath {
677     /**
678      * @dev Returns the addition of two unsigned integers, with an overflow flag.
679      *
680      * _Available since v3.4._
681      */
682     function tryAdd(uint256 a, uint256 b)
683         internal
684         pure
685         returns (bool, uint256)
686     {
687         unchecked {
688             uint256 c = a + b;
689             if (c < a) return (false, 0);
690             return (true, c);
691         }
692     }
693 
694     /**
695      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
696      *
697      * _Available since v3.4._
698      */
699     function trySub(uint256 a, uint256 b)
700         internal
701         pure
702         returns (bool, uint256)
703     {
704         unchecked {
705             if (b > a) return (false, 0);
706             return (true, a - b);
707         }
708     }
709 
710     /**
711      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
712      *
713      * _Available since v3.4._
714      */
715     function tryMul(uint256 a, uint256 b)
716         internal
717         pure
718         returns (bool, uint256)
719     {
720         unchecked {
721             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
722             // benefit is lost if 'b' is also tested.
723             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
724             if (a == 0) return (true, 0);
725             uint256 c = a * b;
726             if (c / a != b) return (false, 0);
727             return (true, c);
728         }
729     }
730 
731     /**
732      * @dev Returns the division of two unsigned integers, with a division by zero flag.
733      *
734      * _Available since v3.4._
735      */
736     function tryDiv(uint256 a, uint256 b)
737         internal
738         pure
739         returns (bool, uint256)
740     {
741         unchecked {
742             if (b == 0) return (false, 0);
743             return (true, a / b);
744         }
745     }
746 
747     /**
748      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
749      *
750      * _Available since v3.4._
751      */
752     function tryMod(uint256 a, uint256 b)
753         internal
754         pure
755         returns (bool, uint256)
756     {
757         unchecked {
758             if (b == 0) return (false, 0);
759             return (true, a % b);
760         }
761     }
762 
763     /**
764      * @dev Returns the addition of two unsigned integers, reverting on
765      * overflow.
766      *
767      * Counterpart to Solidity's `+` operator.
768      *
769      * Requirements:
770      *
771      * - Addition cannot overflow.
772      */
773     function add(uint256 a, uint256 b) internal pure returns (uint256) {
774         return a + b;
775     }
776 
777     /**
778      * @dev Returns the subtraction of two unsigned integers, reverting on
779      * overflow (when the result is negative).
780      *
781      * Counterpart to Solidity's `-` operator.
782      *
783      * Requirements:
784      *
785      * - Subtraction cannot overflow.
786      */
787     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
788         return a - b;
789     }
790 
791     /**
792      * @dev Returns the multiplication of two unsigned integers, reverting on
793      * overflow.
794      *
795      * Counterpart to Solidity's `*` operator.
796      *
797      * Requirements:
798      *
799      * - Multiplication cannot overflow.
800      */
801     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
802         return a * b;
803     }
804 
805     /**
806      * @dev Returns the integer division of two unsigned integers, reverting on
807      * division by zero. The result is rounded towards zero.
808      *
809      * Counterpart to Solidity's `/` operator.
810      *
811      * Requirements:
812      *
813      * - The divisor cannot be zero.
814      */
815     function div(uint256 a, uint256 b) internal pure returns (uint256) {
816         return a / b;
817     }
818 
819     /**
820      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
821      * reverting when dividing by zero.
822      *
823      * Counterpart to Solidity's `%` operator. This function uses a `revert`
824      * opcode (which leaves remaining gas untouched) while Solidity uses an
825      * invalid opcode to revert (consuming all remaining gas).
826      *
827      * Requirements:
828      *
829      * - The divisor cannot be zero.
830      */
831     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
832         return a % b;
833     }
834 
835     /**
836      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
837      * overflow (when the result is negative).
838      *
839      * CAUTION: This function is deprecated because it requires allocating memory for the error
840      * message unnecessarily. For custom revert reasons use {trySub}.
841      *
842      * Counterpart to Solidity's `-` operator.
843      *
844      * Requirements:
845      *
846      * - Subtraction cannot overflow.
847      */
848     function sub(
849         uint256 a,
850         uint256 b,
851         string memory errorMessage
852     ) internal pure returns (uint256) {
853         unchecked {
854             require(b <= a, errorMessage);
855             return a - b;
856         }
857     }
858 
859     /**
860      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
861      * division by zero. The result is rounded towards zero.
862      *
863      * Counterpart to Solidity's `/` operator. Note: this function uses a
864      * `revert` opcode (which leaves remaining gas untouched) while Solidity
865      * uses an invalid opcode to revert (consuming all remaining gas).
866      *
867      * Requirements:
868      *
869      * - The divisor cannot be zero.
870      */
871     function div(
872         uint256 a,
873         uint256 b,
874         string memory errorMessage
875     ) internal pure returns (uint256) {
876         unchecked {
877             require(b > 0, errorMessage);
878             return a / b;
879         }
880     }
881 
882     /**
883      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
884      * reverting with custom message when dividing by zero.
885      *
886      * CAUTION: This function is deprecated because it requires allocating memory for the error
887      * message unnecessarily. For custom revert reasons use {tryMod}.
888      *
889      * Counterpart to Solidity's `%` operator. This function uses a `revert`
890      * opcode (which leaves remaining gas untouched) while Solidity uses an
891      * invalid opcode to revert (consuming all remaining gas).
892      *
893      * Requirements:
894      *
895      * - The divisor cannot be zero.
896      */
897     function mod(
898         uint256 a,
899         uint256 b,
900         string memory errorMessage
901     ) internal pure returns (uint256) {
902         unchecked {
903             require(b > 0, errorMessage);
904             return a % b;
905         }
906     }
907 }
908 
909 contract Maximus is ERC20, Ownable {
910     using SafeMath for uint256;
911 
912     IUniswapV2Router02 public immutable uniswapV2Router;
913     address public uniswapV2Pair;
914     address public constant deadAddress = address(0xdead);
915 
916     bool private swapping;
917 
918     address public marketingWallet;
919     address public devWallet;
920 
921     uint256 public maxTransactionAmount;
922     uint256 public swapTokensAtAmount;
923     uint256 public maxWallet;
924 
925     uint256 public percentForLPBurn = 20; // 20 = .20%
926     bool public lpBurnEnabled = true;
927     uint256 public lpBurnFrequency = 3600 seconds;
928     uint256 public lastLpBurnTime;
929 
930     uint256 public manualBurnFrequency = 30 minutes;
931     uint256 public lastManualLpBurnTime;
932 
933     bool public limitsInEffect = true;
934     bool public tradingActive = false;
935     bool public swapEnabled = false;
936 
937     // Anti-bot and anti-whale mappings and variables
938     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
939     bool public transferDelayEnabled = true;
940 
941     uint256 public buyTotalFees;
942     uint256 public constant buyMarketingFee = 0;
943     uint256 public constant buyLiquidityFee = 3;
944     uint256 public constant buyDevFee = 0;
945 
946     uint256 public sellTotalFees;
947     uint256 public constant sellMarketingFee = 3;
948     uint256 public constant sellLiquidityFee = 0;
949     uint256 public constant sellDevFee = 3;
950 
951     uint256 public tokensForMarketing;
952     uint256 public tokensForLiquidity;
953     uint256 public tokensForDev;
954 
955     /******************/
956 
957     // exlcude from fees and max transaction amount
958     mapping(address => bool) private _isExcludedFromFees;
959     mapping(address => bool) public _isExcludedMaxTransactionAmount;
960 
961     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
962     // could be subject to a maximum transfer amount
963     mapping(address => bool) public automatedMarketMakerPairs;
964 
965     event UpdateUniswapV2Router(
966         address indexed newAddress,
967         address indexed oldAddress
968     );
969 
970     event ExcludeFromFees(address indexed account, bool isExcluded);
971 
972     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
973 
974     event marketingWalletUpdated(
975         address indexed newWallet,
976         address indexed oldWallet
977     );
978 
979     event devWalletUpdated(
980         address indexed newWallet,
981         address indexed oldWallet
982     );
983 
984     event SwapAndLiquify(
985         uint256 tokensSwapped,
986         uint256 ethReceived,
987         uint256 tokensIntoLiquidity
988     );
989 
990     event AutoNukeLP();
991 
992     event ManualNukeLP();
993 
994     event BoughtEarly(address indexed sniper);
995 
996     constructor() ERC20("Naughtius Maximus", "MAXIMUS") {
997         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
998             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
999         );
1000 
1001         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1002         uniswapV2Router = _uniswapV2Router;
1003 
1004         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1005             .createPair(address(this), _uniswapV2Router.WETH());
1006         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1007         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1008 
1009         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 billion total supply
1010 
1011         maxTransactionAmount = 15_000_000 * 1e18; // 1.5% from total supply maxTransactionAmountTxn
1012         maxWallet = 30_000_000 * 1e18; // 3% from total supply maxWallet
1013         swapTokensAtAmount = (totalSupply * 3) / 10000; // 0.03% swap wallet
1014 
1015         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1016         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1017 
1018         marketingWallet = address(0x9402f9A9135cFDBF094F5A66a14Ca01A755093Bd); // set as marketing wallet
1019         devWallet = address(0x925851854198a096E19eA4d2Ea250e459C8e1cA2); // set as dev wallet
1020 
1021         // exclude from paying fees or having max transaction amount
1022         excludeFromFees(owner(), true);
1023         excludeFromFees(address(this), true);
1024         excludeFromFees(address(0xdead), true);
1025 
1026         excludeFromMaxTransaction(owner(), true);
1027         excludeFromMaxTransaction(address(this), true);
1028         excludeFromMaxTransaction(address(0xdead), true);
1029 
1030         /*
1031             _mint is an internal function in ERC20.sol that is only called here,
1032             and CANNOT be called ever again
1033         */
1034         _mint(msg.sender, totalSupply);
1035     }
1036 
1037     receive() external payable {}
1038 
1039     // once enabled, can never be turned off
1040     function startTrading() external onlyOwner {
1041         tradingActive = true;
1042         swapEnabled = true;
1043         lastLpBurnTime = block.timestamp;
1044     }
1045 
1046     // remove limits after token is stable
1047     function removeLimits() external onlyOwner returns (bool) {
1048         limitsInEffect = false;
1049         return true;
1050     }
1051 
1052     // disable Transfer delay - cannot be reenabled
1053     function disableTransferDelay() external onlyOwner returns (bool) {
1054         transferDelayEnabled = false;
1055         return true;
1056     }
1057 
1058     // change the minimum amount of tokens to sell from fees
1059     function updateSwapTokensAtAmount(uint256 newAmount)
1060         external
1061         onlyOwner
1062         returns (bool)
1063     {
1064         require(
1065             newAmount >= (totalSupply() * 1) / 100000,
1066             "Swap amount cannot be lower than 0.001% total supply."
1067         );
1068         require(
1069             newAmount <= (totalSupply() * 5) / 1000,
1070             "Swap amount cannot be higher than 0.5% total supply."
1071         );
1072         swapTokensAtAmount = newAmount;
1073         return true;
1074     }
1075 
1076     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1077         require(
1078             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1079             "Cannot set maxTransactionAmount lower than 0.1%"
1080         );
1081         maxTransactionAmount = newNum * (10**18);
1082     }
1083 
1084     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1085         require(
1086             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1087             "Cannot set maxWallet lower than 0.5%"
1088         );
1089         maxWallet = newNum * (10**18);
1090     }
1091 
1092     function excludeFromMaxTransaction(address updAds, bool isEx)
1093         public
1094         onlyOwner
1095     {
1096         _isExcludedMaxTransactionAmount[updAds] = isEx;
1097     }
1098 
1099     // only use to disable contract sales if absolutely necessary (emergency use only)
1100     function updateSwapEnabled(bool enabled) external onlyOwner {
1101         swapEnabled = enabled;
1102     }
1103 
1104     function excludeFromFees(address account, bool excluded) public onlyOwner {
1105         _isExcludedFromFees[account] = excluded;
1106         emit ExcludeFromFees(account, excluded);
1107     }
1108 
1109     function setAutomatedMarketMakerPair(address pair, bool value)
1110         public
1111         onlyOwner
1112     {
1113         require(
1114             pair != uniswapV2Pair,
1115             "The pair cannot be removed from automatedMarketMakerPairs"
1116         );
1117 
1118         _setAutomatedMarketMakerPair(pair, value);
1119     }
1120 
1121     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1122         automatedMarketMakerPairs[pair] = value;
1123 
1124         emit SetAutomatedMarketMakerPair(pair, value);
1125     }
1126 
1127     function updateMarketingWallet(address newMarketingWallet)
1128         external
1129         onlyOwner
1130     {
1131         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1132         marketingWallet = newMarketingWallet;
1133     }
1134 
1135     function updateDevWallet(address newWallet) external onlyOwner {
1136         emit devWalletUpdated(newWallet, devWallet);
1137         devWallet = newWallet;
1138     }
1139 
1140     function isExcludedFromFees(address account) public view returns (bool) {
1141         return _isExcludedFromFees[account];
1142     }
1143 
1144     function _transfer(
1145         address from,
1146         address to,
1147         uint256 amount
1148     ) internal override {
1149         require(from != address(0), "ERC20: transfer from the zero address");
1150         require(to != address(0), "ERC20: transfer to the zero address");
1151 
1152         if (amount == 0) {
1153             super._transfer(from, to, 0);
1154             return;
1155         }
1156 
1157         if (limitsInEffect) {
1158             if (
1159                 from != owner() &&
1160                 to != owner() &&
1161                 to != address(0) &&
1162                 to != address(0xdead) &&
1163                 !swapping
1164             ) {
1165                 if (!tradingActive) {
1166                     require(
1167                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1168                         "Trading is not active."
1169                     );
1170                 }
1171 
1172                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1173                 if (transferDelayEnabled) {
1174                     if (
1175                         to != owner() &&
1176                         to != address(uniswapV2Router) &&
1177                         to != address(uniswapV2Pair)
1178                     ) {
1179                         require(
1180                             _holderLastTransferTimestamp[tx.origin] <
1181                                 block.number,
1182                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1183                         );
1184                         _holderLastTransferTimestamp[tx.origin] = block.number;
1185                     }
1186                 }
1187 
1188                 //when buy
1189                 if (
1190                     automatedMarketMakerPairs[from] &&
1191                     !_isExcludedMaxTransactionAmount[to]
1192                 ) {
1193                     require(
1194                         amount <= maxTransactionAmount,
1195                         "Buy transfer amount exceeds the maxTransactionAmount."
1196                     );
1197                     require(
1198                         amount + balanceOf(to) <= maxWallet,
1199                         "Max wallet exceeded"
1200                     );
1201                 }
1202                 //when sell
1203                 else if (
1204                     automatedMarketMakerPairs[to] &&
1205                     !_isExcludedMaxTransactionAmount[from]
1206                 ) {
1207                     require(
1208                         amount <= maxTransactionAmount,
1209                         "Sell transfer amount exceeds the maxTransactionAmount."
1210                     );
1211                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1212                     require(
1213                         amount + balanceOf(to) <= maxWallet,
1214                         "Max wallet exceeded"
1215                     );
1216                 }
1217             }
1218         }
1219 
1220         uint256 contractTokenBalance = balanceOf(address(this));
1221 
1222         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1223 
1224         if (
1225             canSwap &&
1226             swapEnabled &&
1227             !swapping &&
1228             !automatedMarketMakerPairs[from] &&
1229             !_isExcludedFromFees[from] &&
1230             !_isExcludedFromFees[to]
1231         ) {
1232             swapping = true;
1233 
1234             swapBack();
1235 
1236             swapping = false;
1237         }
1238 
1239         if (
1240             !swapping &&
1241             automatedMarketMakerPairs[to] &&
1242             lpBurnEnabled &&
1243             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1244             !_isExcludedFromFees[from]
1245         ) {
1246             autoBurnLiquidityPairTokens();
1247         }
1248 
1249         bool takeFee = !swapping;
1250 
1251         // if any account belongs to _isExcludedFromFee account then remove the fee
1252         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1253             takeFee = false;
1254         }
1255 
1256         uint256 fees = 0;
1257         // only take fees on buys/sells, do not take on wallet transfers
1258         if (takeFee) {
1259             // on sell
1260             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1261                 fees = amount.mul(sellTotalFees).div(100);
1262                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1263                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1264                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1265             }
1266             // on buy
1267             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1268                 fees = amount.mul(buyTotalFees).div(100);
1269                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1270                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1271                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1272             }
1273 
1274             if (fees > 0) {
1275                 super._transfer(from, address(this), fees);
1276             }
1277 
1278             amount -= fees;
1279         }
1280 
1281         super._transfer(from, to, amount);
1282     }
1283 
1284     function swapTokensForEth(uint256 tokenAmount) private {
1285         // generate the uniswap pair path of token -> weth
1286         address[] memory path = new address[](2);
1287         path[0] = address(this);
1288         path[1] = uniswapV2Router.WETH();
1289 
1290         _approve(address(this), address(uniswapV2Router), tokenAmount);
1291 
1292         // make the swap
1293         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1294             tokenAmount,
1295             0, // accept any amount of ETH
1296             path,
1297             address(this),
1298             block.timestamp
1299         );
1300     }
1301 
1302     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1303         // approve token transfer to cover all possible scenarios
1304         _approve(address(this), address(uniswapV2Router), tokenAmount);
1305 
1306         // add the liquidity
1307         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1308             address(this),
1309             tokenAmount,
1310             0, // slippage is unavoidable
1311             0, // slippage is unavoidable
1312             deadAddress,
1313             block.timestamp
1314         );
1315     }
1316 
1317     function swapBack() private {
1318         uint256 contractBalance = balanceOf(address(this));
1319         uint256 totalTokensToSwap = tokensForLiquidity +
1320             tokensForMarketing +
1321             tokensForDev;
1322         bool success;
1323 
1324         if (contractBalance == 0 || totalTokensToSwap == 0) {
1325             return;
1326         }
1327 
1328         if (contractBalance > swapTokensAtAmount * 20) {
1329             contractBalance = swapTokensAtAmount * 20;
1330         }
1331 
1332         // Halve the amount of liquidity tokens
1333         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1334             totalTokensToSwap /
1335             2;
1336         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1337 
1338         uint256 initialETHBalance = address(this).balance;
1339 
1340         swapTokensForEth(amountToSwapForETH);
1341 
1342         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1343 
1344         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1345             totalTokensToSwap
1346         );
1347         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1348 
1349         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1350 
1351         tokensForLiquidity = 0;
1352         tokensForMarketing = 0;
1353         tokensForDev = 0;
1354 
1355         (success, ) = address(devWallet).call{value: ethForDev}("");
1356 
1357         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1358             addLiquidity(liquidityTokens, ethForLiquidity);
1359             emit SwapAndLiquify(
1360                 amountToSwapForETH,
1361                 ethForLiquidity,
1362                 tokensForLiquidity
1363             );
1364         }
1365 
1366         (success, ) = address(marketingWallet).call{
1367             value: address(this).balance
1368         }("");
1369     }
1370 
1371     function setAutoLPBurnSettings(
1372         uint256 _frequencyInSeconds,
1373         uint256 _percent,
1374         bool _Enabled
1375     ) external onlyOwner {
1376         require(
1377             _frequencyInSeconds >= 600,
1378             "cannot set buyback more often than every 10 minutes"
1379         );
1380         require(
1381             _percent <= 1000 && _percent >= 0,
1382             "Must set auto LP burn percent between 0% and 10%"
1383         );
1384         lpBurnFrequency = _frequencyInSeconds;
1385         percentForLPBurn = _percent;
1386         lpBurnEnabled = _Enabled;
1387     }
1388 
1389     function autoBurnLiquidityPairTokens() internal returns (bool) {
1390         lastLpBurnTime = block.timestamp;
1391 
1392         // get balance of liquidity pair
1393         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1394 
1395         // calculate amount to burn
1396         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1397             10000
1398         );
1399 
1400         // pull tokens from pancakePair liquidity and move to dead address permanently
1401         if (amountToBurn > 0) {
1402             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1403         }
1404 
1405         //sync price since this is not in a swap transaction!
1406         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1407         pair.sync();
1408         emit AutoNukeLP();
1409         return true;
1410     }
1411 
1412     function manualBurnLiquidityPairTokens(uint256 percent)
1413         external
1414         onlyOwner
1415         returns (bool)
1416     {
1417         require(
1418             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1419             "Must wait for cooldown to finish"
1420         );
1421         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1422         lastManualLpBurnTime = block.timestamp;
1423 
1424         // get balance of liquidity pair
1425         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1426 
1427         // calculate amount to burn
1428         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1429 
1430         // pull tokens from pancakePair liquidity and move to dead address permanently
1431         if (amountToBurn > 0) {
1432             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1433         }
1434 
1435         //sync price since this is not in a swap transaction!
1436         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1437         pair.sync();
1438         emit ManualNukeLP();
1439         return true;
1440     }
1441 }