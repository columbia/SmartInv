1 // Sources flattened with hardhat v2.11.2 https://hardhat.org
2 
3 // Website - validatoor.money (domain owned, not live as of Wednesday 21st September 2022)
4 
5 // Telegram - https://t.me/validatoor
6 
7 // Tax on the token is 5% for buys and sells -  accumulated for ETH Validators and future staking
8 
9 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 
37 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
38 
39 
40 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         _checkOwner();
73         _;
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if the sender is not the owner.
85      */
86     function _checkOwner() internal view virtual {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 
122 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1
123 
124 pragma solidity >=0.5.0;
125 
126 interface IUniswapV2Pair {
127     event Approval(address indexed owner, address indexed spender, uint value);
128     event Transfer(address indexed from, address indexed to, uint value);
129 
130     function name() external pure returns (string memory);
131     function symbol() external pure returns (string memory);
132     function decimals() external pure returns (uint8);
133     function totalSupply() external view returns (uint);
134     function balanceOf(address owner) external view returns (uint);
135     function allowance(address owner, address spender) external view returns (uint);
136 
137     function approve(address spender, uint value) external returns (bool);
138     function transfer(address to, uint value) external returns (bool);
139     function transferFrom(address from, address to, uint value) external returns (bool);
140 
141     function DOMAIN_SEPARATOR() external view returns (bytes32);
142     function PERMIT_TYPEHASH() external pure returns (bytes32);
143     function nonces(address owner) external view returns (uint);
144 
145     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
146 
147     event Mint(address indexed sender, uint amount0, uint amount1);
148     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
149     event Swap(
150         address indexed sender,
151         uint amount0In,
152         uint amount1In,
153         uint amount0Out,
154         uint amount1Out,
155         address indexed to
156     );
157     event Sync(uint112 reserve0, uint112 reserve1);
158 
159     function MINIMUM_LIQUIDITY() external pure returns (uint);
160     function factory() external view returns (address);
161     function token0() external view returns (address);
162     function token1() external view returns (address);
163     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
164     function price0CumulativeLast() external view returns (uint);
165     function price1CumulativeLast() external view returns (uint);
166     function kLast() external view returns (uint);
167 
168     function mint(address to) external returns (uint liquidity);
169     function burn(address to) external returns (uint amount0, uint amount1);
170     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
171     function skim(address to) external;
172     function sync() external;
173 
174     function initialize(address, address) external;
175 }
176 
177 
178 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
179 
180 
181 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev Interface of the ERC20 standard as defined in the EIP.
187  */
188 interface IERC20 {
189     /**
190      * @dev Emitted when `value` tokens are moved from one account (`from`) to
191      * another (`to`).
192      *
193      * Note that `value` may be zero.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 
197     /**
198      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
199      * a call to {approve}. `value` is the new allowance.
200      */
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 
203     /**
204      * @dev Returns the amount of tokens in existence.
205      */
206     function totalSupply() external view returns (uint256);
207 
208     /**
209      * @dev Returns the amount of tokens owned by `account`.
210      */
211     function balanceOf(address account) external view returns (uint256);
212 
213     /**
214      * @dev Moves `amount` tokens from the caller's account to `to`.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transfer(address to, uint256 amount) external returns (bool);
221 
222     /**
223      * @dev Returns the remaining number of tokens that `spender` will be
224      * allowed to spend on behalf of `owner` through {transferFrom}. This is
225      * zero by default.
226      *
227      * This value changes when {approve} or {transferFrom} are called.
228      */
229     function allowance(address owner, address spender) external view returns (uint256);
230 
231     /**
232      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * IMPORTANT: Beware that changing an allowance with this method brings the risk
237      * that someone may use both the old and the new allowance by unfortunate
238      * transaction ordering. One possible solution to mitigate this race
239      * condition is to first reduce the spender's allowance to 0 and set the
240      * desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      *
243      * Emits an {Approval} event.
244      */
245     function approve(address spender, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Moves `amount` tokens from `from` to `to` using the
249      * allowance mechanism. `amount` is then deducted from the caller's
250      * allowance.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * Emits a {Transfer} event.
255      */
256     function transferFrom(
257         address from,
258         address to,
259         uint256 amount
260     ) external returns (bool);
261 }
262 
263 
264 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.7.3
265 
266 
267 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @dev Interface for the optional metadata functions from the ERC20 standard.
273  *
274  * _Available since v4.1._
275  */
276 interface IERC20Metadata is IERC20 {
277     /**
278      * @dev Returns the name of the token.
279      */
280     function name() external view returns (string memory);
281 
282     /**
283      * @dev Returns the symbol of the token.
284      */
285     function symbol() external view returns (string memory);
286 
287     /**
288      * @dev Returns the decimals places of the token.
289      */
290     function decimals() external view returns (uint8);
291 }
292 
293 
294 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.7.3
295 
296 
297 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 
302 
303 /**
304  * @dev Implementation of the {IERC20} interface.
305  *
306  * This implementation is agnostic to the way tokens are created. This means
307  * that a supply mechanism has to be added in a derived contract using {_mint}.
308  * For a generic mechanism see {ERC20PresetMinterPauser}.
309  *
310  * TIP: For a detailed writeup see our guide
311  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
312  * to implement supply mechanisms].
313  *
314  * We have followed general OpenZeppelin Contracts guidelines: functions revert
315  * instead returning `false` on failure. This behavior is nonetheless
316  * conventional and does not conflict with the expectations of ERC20
317  * applications.
318  *
319  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
320  * This allows applications to reconstruct the allowance for all accounts just
321  * by listening to said events. Other implementations of the EIP may not emit
322  * these events, as it isn't required by the specification.
323  *
324  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
325  * functions have been added to mitigate the well-known issues around setting
326  * allowances. See {IERC20-approve}.
327  */
328 contract ERC20 is Context, IERC20, IERC20Metadata {
329     mapping(address => uint256) private _balances;
330 
331     mapping(address => mapping(address => uint256)) private _allowances;
332 
333     uint256 private _totalSupply;
334 
335     string private _name;
336     string private _symbol;
337 
338     /**
339      * @dev Sets the values for {name} and {symbol}.
340      *
341      * The default value of {decimals} is 18. To select a different value for
342      * {decimals} you should overload it.
343      *
344      * All two of these values are immutable: they can only be set once during
345      * construction.
346      */
347     constructor(string memory name_, string memory symbol_) {
348         _name = name_;
349         _symbol = symbol_;
350     }
351 
352     /**
353      * @dev Returns the name of the token.
354      */
355     function name() public view virtual override returns (string memory) {
356         return _name;
357     }
358 
359     /**
360      * @dev Returns the symbol of the token, usually a shorter version of the
361      * name.
362      */
363     function symbol() public view virtual override returns (string memory) {
364         return _symbol;
365     }
366 
367     /**
368      * @dev Returns the number of decimals used to get its user representation.
369      * For example, if `decimals` equals `2`, a balance of `505` tokens should
370      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
371      *
372      * Tokens usually opt for a value of 18, imitating the relationship between
373      * Ether and Wei. This is the value {ERC20} uses, unless this function is
374      * overridden;
375      *
376      * NOTE: This information is only used for _display_ purposes: it in
377      * no way affects any of the arithmetic of the contract, including
378      * {IERC20-balanceOf} and {IERC20-transfer}.
379      */
380     function decimals() public view virtual override returns (uint8) {
381         return 18;
382     }
383 
384     /**
385      * @dev See {IERC20-totalSupply}.
386      */
387     function totalSupply() public view virtual override returns (uint256) {
388         return _totalSupply;
389     }
390 
391     /**
392      * @dev See {IERC20-balanceOf}.
393      */
394     function balanceOf(address account) public view virtual override returns (uint256) {
395         return _balances[account];
396     }
397 
398     /**
399      * @dev See {IERC20-transfer}.
400      *
401      * Requirements:
402      *
403      * - `to` cannot be the zero address.
404      * - the caller must have a balance of at least `amount`.
405      */
406     function transfer(address to, uint256 amount) public virtual override returns (bool) {
407         address owner = _msgSender();
408         _transfer(owner, to, amount);
409         return true;
410     }
411 
412     /**
413      * @dev See {IERC20-allowance}.
414      */
415     function allowance(address owner, address spender) public view virtual override returns (uint256) {
416         return _allowances[owner][spender];
417     }
418 
419     /**
420      * @dev See {IERC20-approve}.
421      *
422      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
423      * `transferFrom`. This is semantically equivalent to an infinite approval.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function approve(address spender, uint256 amount) public virtual override returns (bool) {
430         address owner = _msgSender();
431         _approve(owner, spender, amount);
432         return true;
433     }
434 
435     /**
436      * @dev See {IERC20-transferFrom}.
437      *
438      * Emits an {Approval} event indicating the updated allowance. This is not
439      * required by the EIP. See the note at the beginning of {ERC20}.
440      *
441      * NOTE: Does not update the allowance if the current allowance
442      * is the maximum `uint256`.
443      *
444      * Requirements:
445      *
446      * - `from` and `to` cannot be the zero address.
447      * - `from` must have a balance of at least `amount`.
448      * - the caller must have allowance for ``from``'s tokens of at least
449      * `amount`.
450      */
451     function transferFrom(
452         address from,
453         address to,
454         uint256 amount
455     ) public virtual override returns (bool) {
456         address spender = _msgSender();
457         _spendAllowance(from, spender, amount);
458         _transfer(from, to, amount);
459         return true;
460     }
461 
462     /**
463      * @dev Atomically increases the allowance granted to `spender` by the caller.
464      *
465      * This is an alternative to {approve} that can be used as a mitigation for
466      * problems described in {IERC20-approve}.
467      *
468      * Emits an {Approval} event indicating the updated allowance.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      */
474     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
475         address owner = _msgSender();
476         _approve(owner, spender, allowance(owner, spender) + addedValue);
477         return true;
478     }
479 
480     /**
481      * @dev Atomically decreases the allowance granted to `spender` by the caller.
482      *
483      * This is an alternative to {approve} that can be used as a mitigation for
484      * problems described in {IERC20-approve}.
485      *
486      * Emits an {Approval} event indicating the updated allowance.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      * - `spender` must have allowance for the caller of at least
492      * `subtractedValue`.
493      */
494     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
495         address owner = _msgSender();
496         uint256 currentAllowance = allowance(owner, spender);
497         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
498         unchecked {
499             _approve(owner, spender, currentAllowance - subtractedValue);
500         }
501 
502         return true;
503     }
504 
505     /**
506      * @dev Moves `amount` of tokens from `from` to `to`.
507      *
508      * This internal function is equivalent to {transfer}, and can be used to
509      * e.g. implement automatic token fees, slashing mechanisms, etc.
510      *
511      * Emits a {Transfer} event.
512      *
513      * Requirements:
514      *
515      * - `from` cannot be the zero address.
516      * - `to` cannot be the zero address.
517      * - `from` must have a balance of at least `amount`.
518      */
519     function _transfer(
520         address from,
521         address to,
522         uint256 amount
523     ) internal virtual {
524         require(from != address(0), "ERC20: transfer from the zero address");
525         require(to != address(0), "ERC20: transfer to the zero address");
526 
527         _beforeTokenTransfer(from, to, amount);
528 
529         uint256 fromBalance = _balances[from];
530         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
531         unchecked {
532             _balances[from] = fromBalance - amount;
533         }
534         _balances[to] += amount;
535 
536         emit Transfer(from, to, amount);
537 
538         _afterTokenTransfer(from, to, amount);
539     }
540 
541     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
542      * the total supply.
543      *
544      * Emits a {Transfer} event with `from` set to the zero address.
545      *
546      * Requirements:
547      *
548      * - `account` cannot be the zero address.
549      */
550     function _mint(address account, uint256 amount) internal virtual {
551         require(account != address(0), "ERC20: mint to the zero address");
552 
553         _beforeTokenTransfer(address(0), account, amount);
554 
555         _totalSupply += amount;
556         _balances[account] += amount;
557         emit Transfer(address(0), account, amount);
558 
559         _afterTokenTransfer(address(0), account, amount);
560     }
561 
562     /**
563      * @dev Destroys `amount` tokens from `account`, reducing the
564      * total supply.
565      *
566      * Emits a {Transfer} event with `to` set to the zero address.
567      *
568      * Requirements:
569      *
570      * - `account` cannot be the zero address.
571      * - `account` must have at least `amount` tokens.
572      */
573     function _burn(address account, uint256 amount) internal virtual {
574         require(account != address(0), "ERC20: burn from the zero address");
575 
576         _beforeTokenTransfer(account, address(0), amount);
577 
578         uint256 accountBalance = _balances[account];
579         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
580         unchecked {
581             _balances[account] = accountBalance - amount;
582         }
583         _totalSupply -= amount;
584 
585         emit Transfer(account, address(0), amount);
586 
587         _afterTokenTransfer(account, address(0), amount);
588     }
589 
590     /**
591      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
592      *
593      * This internal function is equivalent to `approve`, and can be used to
594      * e.g. set automatic allowances for certain subsystems, etc.
595      *
596      * Emits an {Approval} event.
597      *
598      * Requirements:
599      *
600      * - `owner` cannot be the zero address.
601      * - `spender` cannot be the zero address.
602      */
603     function _approve(
604         address owner,
605         address spender,
606         uint256 amount
607     ) internal virtual {
608         require(owner != address(0), "ERC20: approve from the zero address");
609         require(spender != address(0), "ERC20: approve to the zero address");
610 
611         _allowances[owner][spender] = amount;
612         emit Approval(owner, spender, amount);
613     }
614 
615     /**
616      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
617      *
618      * Does not update the allowance amount in case of infinite allowance.
619      * Revert if not enough allowance is available.
620      *
621      * Might emit an {Approval} event.
622      */
623     function _spendAllowance(
624         address owner,
625         address spender,
626         uint256 amount
627     ) internal virtual {
628         uint256 currentAllowance = allowance(owner, spender);
629         if (currentAllowance != type(uint256).max) {
630             require(currentAllowance >= amount, "ERC20: insufficient allowance");
631             unchecked {
632                 _approve(owner, spender, currentAllowance - amount);
633             }
634         }
635     }
636 
637     /**
638      * @dev Hook that is called before any transfer of tokens. This includes
639      * minting and burning.
640      *
641      * Calling conditions:
642      *
643      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
644      * will be transferred to `to`.
645      * - when `from` is zero, `amount` tokens will be minted for `to`.
646      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
647      * - `from` and `to` are never both zero.
648      *
649      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
650      */
651     function _beforeTokenTransfer(
652         address from,
653         address to,
654         uint256 amount
655     ) internal virtual {}
656 
657     /**
658      * @dev Hook that is called after any transfer of tokens. This includes
659      * minting and burning.
660      *
661      * Calling conditions:
662      *
663      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
664      * has been transferred to `to`.
665      * - when `from` is zero, `amount` tokens have been minted for `to`.
666      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
667      * - `from` and `to` are never both zero.
668      *
669      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
670      */
671     function _afterTokenTransfer(
672         address from,
673         address to,
674         uint256 amount
675     ) internal virtual {}
676 }
677 
678 
679 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.7.3
680 
681 
682 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 // CAUTION
687 // This version of SafeMath should only be used with Solidity 0.8 or later,
688 // because it relies on the compiler's built in overflow checks.
689 
690 /**
691  * @dev Wrappers over Solidity's arithmetic operations.
692  *
693  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
694  * now has built in overflow checking.
695  */
696 library SafeMath {
697     /**
698      * @dev Returns the addition of two unsigned integers, with an overflow flag.
699      *
700      * _Available since v3.4._
701      */
702     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
703         unchecked {
704             uint256 c = a + b;
705             if (c < a) return (false, 0);
706             return (true, c);
707         }
708     }
709 
710     /**
711      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
712      *
713      * _Available since v3.4._
714      */
715     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
716         unchecked {
717             if (b > a) return (false, 0);
718             return (true, a - b);
719         }
720     }
721 
722     /**
723      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
724      *
725      * _Available since v3.4._
726      */
727     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
728         unchecked {
729             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
730             // benefit is lost if 'b' is also tested.
731             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
732             if (a == 0) return (true, 0);
733             uint256 c = a * b;
734             if (c / a != b) return (false, 0);
735             return (true, c);
736         }
737     }
738 
739     /**
740      * @dev Returns the division of two unsigned integers, with a division by zero flag.
741      *
742      * _Available since v3.4._
743      */
744     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
745         unchecked {
746             if (b == 0) return (false, 0);
747             return (true, a / b);
748         }
749     }
750 
751     /**
752      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
753      *
754      * _Available since v3.4._
755      */
756     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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
909 
910 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1
911 
912 pragma solidity >=0.5.0;
913 
914 interface IUniswapV2Factory {
915     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
916 
917     function feeTo() external view returns (address);
918     function feeToSetter() external view returns (address);
919 
920     function getPair(address tokenA, address tokenB) external view returns (address pair);
921     function allPairs(uint) external view returns (address pair);
922     function allPairsLength() external view returns (uint);
923 
924     function createPair(address tokenA, address tokenB) external returns (address pair);
925 
926     function setFeeTo(address) external;
927     function setFeeToSetter(address) external;
928 }
929 
930 
931 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
932 
933 pragma solidity >=0.6.2;
934 
935 interface IUniswapV2Router01 {
936     function factory() external pure returns (address);
937     function WETH() external pure returns (address);
938 
939     function addLiquidity(
940         address tokenA,
941         address tokenB,
942         uint amountADesired,
943         uint amountBDesired,
944         uint amountAMin,
945         uint amountBMin,
946         address to,
947         uint deadline
948     ) external returns (uint amountA, uint amountB, uint liquidity);
949     function addLiquidityETH(
950         address token,
951         uint amountTokenDesired,
952         uint amountTokenMin,
953         uint amountETHMin,
954         address to,
955         uint deadline
956     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
957     function removeLiquidity(
958         address tokenA,
959         address tokenB,
960         uint liquidity,
961         uint amountAMin,
962         uint amountBMin,
963         address to,
964         uint deadline
965     ) external returns (uint amountA, uint amountB);
966     function removeLiquidityETH(
967         address token,
968         uint liquidity,
969         uint amountTokenMin,
970         uint amountETHMin,
971         address to,
972         uint deadline
973     ) external returns (uint amountToken, uint amountETH);
974     function removeLiquidityWithPermit(
975         address tokenA,
976         address tokenB,
977         uint liquidity,
978         uint amountAMin,
979         uint amountBMin,
980         address to,
981         uint deadline,
982         bool approveMax, uint8 v, bytes32 r, bytes32 s
983     ) external returns (uint amountA, uint amountB);
984     function removeLiquidityETHWithPermit(
985         address token,
986         uint liquidity,
987         uint amountTokenMin,
988         uint amountETHMin,
989         address to,
990         uint deadline,
991         bool approveMax, uint8 v, bytes32 r, bytes32 s
992     ) external returns (uint amountToken, uint amountETH);
993     function swapExactTokensForTokens(
994         uint amountIn,
995         uint amountOutMin,
996         address[] calldata path,
997         address to,
998         uint deadline
999     ) external returns (uint[] memory amounts);
1000     function swapTokensForExactTokens(
1001         uint amountOut,
1002         uint amountInMax,
1003         address[] calldata path,
1004         address to,
1005         uint deadline
1006     ) external returns (uint[] memory amounts);
1007     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1008         external
1009         payable
1010         returns (uint[] memory amounts);
1011     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1012         external
1013         returns (uint[] memory amounts);
1014     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1015         external
1016         returns (uint[] memory amounts);
1017     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1018         external
1019         payable
1020         returns (uint[] memory amounts);
1021 
1022     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1023     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1024     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1025     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1026     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1027 }
1028 
1029 
1030 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
1031 
1032 pragma solidity >=0.6.2;
1033 
1034 interface IUniswapV2Router02 is IUniswapV2Router01 {
1035     function removeLiquidityETHSupportingFeeOnTransferTokens(
1036         address token,
1037         uint liquidity,
1038         uint amountTokenMin,
1039         uint amountETHMin,
1040         address to,
1041         uint deadline
1042     ) external returns (uint amountETH);
1043     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1044         address token,
1045         uint liquidity,
1046         uint amountTokenMin,
1047         uint amountETHMin,
1048         address to,
1049         uint deadline,
1050         bool approveMax, uint8 v, bytes32 r, bytes32 s
1051     ) external returns (uint amountETH);
1052 
1053     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1054         uint amountIn,
1055         uint amountOutMin,
1056         address[] calldata path,
1057         address to,
1058         uint deadline
1059     ) external;
1060     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1061         uint amountOutMin,
1062         address[] calldata path,
1063         address to,
1064         uint deadline
1065     ) external payable;
1066     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1067         uint amountIn,
1068         uint amountOutMin,
1069         address[] calldata path,
1070         address to,
1071         uint deadline
1072     ) external;
1073 }
1074 
1075 
1076 // File contracts/VALIDATOOR.sol
1077 
1078 // Website - validatoor.money (domain owned, not live as of Wednesday 21st September 2022)
1079 
1080 // Telegram - https://t.me/validatoor
1081 
1082 // Tax on the token is 5% for buys and sells -  accumulated for ETH Validators and future staking
1083 
1084 // SPDX-License-Identifier: UNLICENSED
1085 pragma solidity ^0.8.0;
1086 
1087 
1088 
1089 
1090 
1091 
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 contract VALIDATOOR is ERC20, Ownable {
1096     using SafeMath for uint256;
1097 
1098     modifier lockSwap() {
1099         _inSwap = true;
1100         _;
1101         _inSwap = false;
1102     }
1103 
1104     modifier liquidityAdd() {
1105         _inLiquidityAdd = true;
1106         _;
1107         _inLiquidityAdd = false;
1108     }
1109 
1110     // == CONSTANTS ==
1111     uint256 public constant MAX_SUPPLY = 1_000_000_000 ether;
1112     uint256 public constant BPS_DENOMINATOR = 10_000;
1113     uint256 public constant SNIPE_BLOCKS = 2;
1114 
1115     // == TAXES ==
1116     /// @notice Buy devTax in BPS
1117     uint256 public buyDevTax = 200;
1118     /// @notice Buy rewardsTax in BPS
1119     uint256 public buyRewardsTax = 300;
1120     /// @notice Sell devTax in BPS
1121     uint256 public sellDevTax = 200;
1122     /// @notice Sell rewardsTax in BPS
1123     uint256 public sellRewardsTax = 300;
1124     /// @notice address that devTax is sent to
1125     address payable public devTaxRecipient;
1126     /// @notice address that rewardsTax is sent to
1127     address payable public rewardsTaxRecipient;
1128     /// @notice tokens currently allocated for devTax
1129     uint256 public totalDevTax;
1130     /// @notice tokens currently allocated for rewardsTax
1131     uint256 public totalRewardsTax;
1132 
1133     // == FLAGS ==
1134     /// @notice flag indicating whether initialDistribute() was successfully called
1135     bool public initialDistributeDone = false;
1136     /// @notice flag indicating Uniswap trading status
1137     bool public tradingActive = false;
1138     /// @notice flag indicating token to token transfers
1139     bool public transfersActive = false;
1140     /// @notice flag indicating swapAll enabled
1141     bool public swapFees = true;
1142 
1143     // == UNISWAP ==
1144     IUniswapV2Router02 public router;
1145     address public pair;
1146 
1147     // == WALLET STATUSES ==
1148     /// @notice Maps each recipient to their tax exlcusion status
1149     mapping(address => bool) public taxExcluded;
1150     /// @notice Maps each recipient to the last timestamp they bought
1151     mapping(address => uint256) public lastBuy;
1152     /// @notice Maps each recipient to their blacklist status
1153     mapping(address => bool) public blacklist;
1154     /// @notice Maps each recipient to their whitelist status on buy limit
1155     mapping(address => bool) public recipientLimitWhitelist;
1156 
1157     // == MISC ==
1158     /// @notice Block when trading is first enabled
1159     uint256 public tradingBlock;
1160     /// @notice Contract token balance threshold before `_swap` is invoked
1161     uint256 public minTokenBalance = 1000 ether;
1162 
1163     // == INTERNAL ==
1164     uint256 internal _totalSupply = 0;
1165     bool internal _inSwap = false;
1166     bool internal _inLiquidityAdd = false;
1167     mapping(address => uint256) private _balances;
1168 
1169     event DevTaxRecipientChanged(
1170         address previousRecipient,
1171         address nextRecipient
1172     );
1173     event RewardsTaxRecipientChanged(
1174         address previousRecipient,
1175         address nextRecipient
1176     );
1177     event BuyDevTaxChanged(uint256 previousTax, uint256 nextTax);
1178     event SellDevTaxChanged(uint256 previousTax, uint256 nextTax);
1179     event BuyRewardsTaxChanged(uint256 previousTax, uint256 nextTax);
1180     event SellRewardsTaxChanged(uint256 previousTax, uint256 nextTax);
1181     event DevTaxRescued(uint256 amount);
1182     event RewardsTaxRescued(uint256 amount);
1183     event TradingActiveChanged(bool enabled);
1184     event TaxExclusionChanged(address user, bool taxExcluded);
1185     event BlacklistUpdated(address user, bool previousStatus, bool nextStatus);
1186     event SwapFeesChanged(bool previousStatus, bool nextStatus);
1187 
1188     constructor(
1189         address _factory,
1190         address _router,
1191         address payable _devTaxRecipient,
1192         address payable _rewardsTaxRecipient
1193     ) ERC20("Validatoor Money", "VALID") Ownable() {
1194         taxExcluded[owner()] = true;
1195         taxExcluded[address(0)] = true;
1196         taxExcluded[_devTaxRecipient] = true;
1197         taxExcluded[_rewardsTaxRecipient] = true;
1198         taxExcluded[address(this)] = true;
1199 
1200         devTaxRecipient = _devTaxRecipient;
1201         rewardsTaxRecipient = _rewardsTaxRecipient;
1202 
1203         router = IUniswapV2Router02(_router);
1204         IUniswapV2Factory factory = IUniswapV2Factory(_factory);
1205         pair = factory.createPair(address(this), router.WETH());
1206 
1207         _mint(msg.sender, MAX_SUPPLY);
1208     }
1209 
1210     function addLiquidity(uint256 tokens)
1211         external
1212         payable
1213         onlyOwner
1214         liquidityAdd
1215     {
1216         _rawTransfer(msg.sender, address(this), tokens);
1217         _approve(address(this), address(router), tokens);
1218 
1219         router.addLiquidityETH{value: msg.value}(
1220             address(this),
1221             tokens,
1222             0,
1223             0,
1224             owner(),
1225             // solhint-disable-next-line not-rely-on-time
1226             block.timestamp
1227         );
1228     }
1229 
1230     /// @notice Change the address of the devTax recipient
1231     /// @param _devTaxRecipient The new address of the devTax recipient
1232     function setDevTaxRecipient(address payable _devTaxRecipient)
1233         external
1234         onlyOwner
1235     {
1236         emit DevTaxRecipientChanged(devTaxRecipient, _devTaxRecipient);
1237         devTaxRecipient = _devTaxRecipient;
1238     }
1239 
1240     /// @notice Change the address of the rewardTax recipient
1241     /// @param _rewardsTaxRecipient The new address of the rewardTax recipient
1242     function setRewardsTaxRecipient(address payable _rewardsTaxRecipient)
1243         external
1244         onlyOwner
1245     {
1246         emit RewardsTaxRecipientChanged(
1247             rewardsTaxRecipient,
1248             _rewardsTaxRecipient
1249         );
1250         rewardsTaxRecipient = _rewardsTaxRecipient;
1251     }
1252 
1253     /// @notice Change the buy devTax rate
1254     /// @param _buyDevTax The new devTax rate
1255     function setBuyDevTax(uint256 _buyDevTax) external onlyOwner {
1256         require(
1257             _buyDevTax <= BPS_DENOMINATOR,
1258             "_buyDevTax cannot exceed BPS_DENOMINATOR"
1259         );
1260         emit BuyDevTaxChanged(buyDevTax, _buyDevTax);
1261         buyDevTax = _buyDevTax;
1262     }
1263 
1264     /// @notice Change the buy devTax rate
1265     /// @param _sellDevTax The new devTax rate
1266     function setSellDevTax(uint256 _sellDevTax) external onlyOwner {
1267         require(
1268             _sellDevTax <= BPS_DENOMINATOR,
1269             "_sellDevTax cannot exceed BPS_DENOMINATOR"
1270         );
1271         emit SellDevTaxChanged(sellDevTax, _sellDevTax);
1272         sellDevTax = _sellDevTax;
1273     }
1274 
1275     /// @notice Change the buy rewardsTax rate
1276     /// @param _buyRewardsTax The new buy rewardsTax rate
1277     function setBuyRewardsTax(uint256 _buyRewardsTax) external onlyOwner {
1278         require(
1279             _buyRewardsTax <= BPS_DENOMINATOR,
1280             "_buyRewardsTax cannot exceed BPS_DENOMINATOR"
1281         );
1282         emit BuyRewardsTaxChanged(buyRewardsTax, _buyRewardsTax);
1283         buyRewardsTax = _buyRewardsTax;
1284     }
1285 
1286     /// @notice Change the sell rewardsTax rate
1287     /// @param _sellRewardsTax The new sell rewardsTax rate
1288     function setSellRewardsTax(uint256 _sellRewardsTax) external onlyOwner {
1289         require(
1290             _sellRewardsTax <= BPS_DENOMINATOR,
1291             "_sellRewardsTax cannot exceed BPS_DENOMINATOR"
1292         );
1293         emit SellRewardsTaxChanged(sellRewardsTax, _sellRewardsTax);
1294         sellRewardsTax = _sellRewardsTax;
1295     }
1296 
1297     /// @notice Rescue ATI from the devTax amount
1298     /// @dev Should only be used in an emergency
1299     /// @param _amount The amount of ATI to rescue
1300     /// @param _recipient The recipient of the rescued ATI
1301     function rescueDevTaxTokens(uint256 _amount, address _recipient)
1302         external
1303         onlyOwner
1304     {
1305         require(
1306             _amount <= totalDevTax,
1307             "Amount cannot be greater than totalDevTax"
1308         );
1309         _rawTransfer(address(this), _recipient, _amount);
1310         emit DevTaxRescued(_amount);
1311         totalDevTax -= _amount;
1312     }
1313 
1314     /// @notice Rescue ATI from the rewardsTax amount
1315     /// @dev Should only be used in an emergency
1316     /// @param _amount The amount of ATI to rescue
1317     /// @param _recipient The recipient of the rescued ATI
1318     function rescueRewardsTaxTokens(uint256 _amount, address _recipient)
1319         external
1320         onlyOwner
1321     {
1322         require(
1323             _amount <= totalRewardsTax,
1324             "Amount cannot be greater than totalRewardsTax"
1325         );
1326         _rawTransfer(address(this), _recipient, _amount);
1327         emit RewardsTaxRescued(_amount);
1328         totalRewardsTax -= _amount;
1329     }
1330 
1331     /// @notice Admin function to update a recipient's blacklist status
1332     /// @param user the recipient
1333     /// @param status the new status
1334     function updateBlacklist(address user, bool status)
1335         external
1336         virtual
1337         onlyOwner
1338     {
1339         _updateBlacklist(user, status);
1340     }
1341 
1342     function _updateBlacklist(address user, bool status) internal virtual {
1343         emit BlacklistUpdated(user, blacklist[user], status);
1344         blacklist[user] = status;
1345     }
1346 
1347     /// @notice Enables trading on Uniswap
1348     function enableTrading() external onlyOwner {
1349         tradingActive = true;
1350     }
1351 
1352     /// @notice Disables trading on Uniswap
1353     function disableTrading() external onlyOwner {
1354         tradingActive = false;
1355     }
1356 
1357     /// @notice Enables token to token transfers
1358     function enableTransfers() external onlyOwner {
1359         transfersActive = true;
1360     }
1361 
1362     /// @notice Disables token to token transfers
1363     function disableTransfers() external onlyOwner {
1364         transfersActive = false;
1365     }
1366 
1367     /// @notice Updates tax exclusion status
1368     /// @param _account Account to update the tax exclusion status of
1369     /// @param _taxExcluded If true, exclude taxes for this user
1370     function setTaxExcluded(address _account, bool _taxExcluded)
1371         public
1372         onlyOwner
1373     {
1374         taxExcluded[_account] = _taxExcluded;
1375         emit TaxExclusionChanged(_account, _taxExcluded);
1376     }
1377 
1378     /// @notice Enable or disable whether swap occurs during `_transfer`
1379     /// @param _swapFees If true, enables swap during `_transfer`
1380     function setSwapFees(bool _swapFees) external onlyOwner {
1381         emit SwapFeesChanged(swapFees, _swapFees);
1382         swapFees = _swapFees;
1383     }
1384 
1385     function balanceOf(address account)
1386         public
1387         view
1388         virtual
1389         override
1390         returns (uint256)
1391     {
1392         return _balances[account];
1393     }
1394 
1395     function _addBalance(address account, uint256 amount) internal {
1396         _balances[account] = _balances[account] + amount;
1397     }
1398 
1399     function _subtractBalance(address account, uint256 amount) internal {
1400         _balances[account] = _balances[account] - amount;
1401     }
1402 
1403     function _transfer(
1404         address sender,
1405         address recipient,
1406         uint256 amount
1407     ) internal override {
1408         require(!blacklist[recipient], "Recipient is blacklisted");
1409 
1410         if (taxExcluded[sender] || taxExcluded[recipient]) {
1411             _rawTransfer(sender, recipient, amount);
1412             return;
1413         }
1414 
1415         bool overMinTokenBalance = balanceOf(address(this)) >= minTokenBalance;
1416         if (overMinTokenBalance && !_inSwap && sender != pair && swapFees) {
1417             swapAll();
1418         }
1419 
1420         uint256 send = amount;
1421         uint256 devTax;
1422         uint256 rewardsTax;
1423         if (sender == pair) {
1424             require(tradingActive, "Trading is not yet active");
1425             if (block.number <= tradingBlock + SNIPE_BLOCKS) {
1426                 _updateBlacklist(recipient, true);
1427             }
1428             (send, devTax, rewardsTax) = _getTaxAmounts(amount, true);
1429         } else if (recipient == pair) {
1430             require(tradingActive, "Trading is not yet active");
1431             (send, devTax, rewardsTax) = _getTaxAmounts(amount, false);
1432         } else {
1433             require(transfersActive, "Transfers are not yet active");
1434         }
1435         _rawTransfer(sender, recipient, send);
1436         _takeTaxes(sender, devTax, rewardsTax);
1437     }
1438 
1439     /// @notice Peforms auto liquidity and tax distribution
1440     function swapAll() public {
1441         if (!_inSwap) {
1442             _swap(balanceOf(address(this)));
1443         }
1444     }
1445 
1446     /// @notice Perform a Uniswap v2 swap from token to ETH and handle tax distribution
1447     /// @param amount The amount of token to swap in wei
1448     /// @dev `amount` is always <= this contract's ETH balance.
1449     function _swap(uint256 amount) internal lockSwap {
1450         address[] memory path = new address[](2);
1451         path[0] = address(this);
1452         path[1] = router.WETH();
1453 
1454         _approve(address(this), address(router), amount);
1455 
1456         uint256 contractEthBalance = address(this).balance;
1457 
1458         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1459             amount,
1460             0,
1461             path,
1462             address(this),
1463             block.timestamp
1464         );
1465 
1466         uint256 tradeValue = address(this).balance - contractEthBalance;
1467 
1468         uint256 totalTaxes = totalDevTax.add(totalRewardsTax);
1469         uint256 devAmount = amount.mul(totalDevTax).div(totalTaxes);
1470         uint256 rewardsAmount = amount.mul(totalRewardsTax).div(totalTaxes);
1471 
1472         uint256 devEth = tradeValue.mul(totalDevTax).div(totalTaxes);
1473         uint256 rewardsEth = tradeValue.mul(totalRewardsTax).div(totalTaxes);
1474 
1475         // Update state
1476         totalDevTax = totalDevTax.sub(devAmount);
1477         totalRewardsTax = totalRewardsTax.sub(rewardsAmount);
1478 
1479         // Do transfer
1480         if (devEth > 0) {
1481             devTaxRecipient.transfer(devEth);
1482         }
1483         if (rewardsEth > 0) {
1484             rewardsTaxRecipient.transfer(rewardsEth);
1485         }
1486     }
1487 
1488     /// @notice Change the minimum contract ACAP balance before `_swap` gets invoked
1489     /// @param _minTokenBalance The new minimum balance
1490     function setMinTokenBalance(uint256 _minTokenBalance) external onlyOwner {
1491         minTokenBalance = _minTokenBalance;
1492     }
1493 
1494     /// @notice Admin function to rescue ETH from the contract
1495     function rescueETH() external onlyOwner {
1496         payable(owner()).transfer(address(this).balance);
1497     }
1498 
1499     /// @notice Transfers ATI from an account to this contract for taxes
1500     /// @param _account The account to transfer ATI from
1501     /// @param _devTaxAmount The amount of devTax tax to transfer
1502     function _takeTaxes(
1503         address _account,
1504         uint256 _devTaxAmount,
1505         uint256 _rewardsTaxAmount
1506     ) internal {
1507         require(_account != address(0), "taxation from the zero address");
1508 
1509         uint256 totalAmount = _devTaxAmount.add(_rewardsTaxAmount);
1510         _rawTransfer(_account, address(this), totalAmount);
1511         totalDevTax += _devTaxAmount;
1512         totalRewardsTax += _rewardsTaxAmount;
1513     }
1514 
1515     /// @notice Get a breakdown of send and tax amounts
1516     /// @param amount The amount to tax in wei
1517     /// @return send The raw amount to send
1518     /// @return devTax The raw devTax tax amount
1519     function _getTaxAmounts(uint256 amount, bool buying)
1520         internal
1521         view
1522         returns (
1523             uint256 send,
1524             uint256 devTax,
1525             uint256 rewardsTax
1526         )
1527     {
1528         if (buying) {
1529             devTax = amount.mul(buyDevTax).div(BPS_DENOMINATOR);
1530             rewardsTax = amount.mul(buyRewardsTax).div(BPS_DENOMINATOR);
1531         } else {
1532             devTax = amount.mul(sellDevTax).div(BPS_DENOMINATOR);
1533             rewardsTax = amount.mul(sellRewardsTax).div(BPS_DENOMINATOR);
1534         }
1535         send = amount.sub(devTax).sub(rewardsTax);
1536     }
1537 
1538     // modified from OpenZeppelin ERC20
1539     function _rawTransfer(
1540         address sender,
1541         address recipient,
1542         uint256 amount
1543     ) internal {
1544         require(sender != address(0), "transfer from the zero address");
1545         require(recipient != address(0), "transfer to the zero address");
1546 
1547         uint256 senderBalance = balanceOf(sender);
1548         require(senderBalance >= amount, "transfer amount exceeds balance");
1549         unchecked {
1550             _subtractBalance(sender, amount);
1551         }
1552         _addBalance(recipient, amount);
1553 
1554         emit Transfer(sender, recipient, amount);
1555     }
1556 
1557     function totalSupply() public view override returns (uint256) {
1558         return _totalSupply;
1559     }
1560 
1561     function _mint(address account, uint256 amount) internal override {
1562         require(_totalSupply.add(amount) <= MAX_SUPPLY, "Max supply exceeded");
1563         _totalSupply += amount;
1564         _addBalance(account, amount);
1565         emit Transfer(address(0), account, amount);
1566     }
1567 
1568     receive() external payable {}
1569 }