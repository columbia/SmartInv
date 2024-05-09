1 // SPDX-License-Identifier: MIT
2 
3 /*
4                                      
5 Probably N0thing ♥ 
6 
7 Website:   https://www.GaryCashToken.io
8 Twitter:   https://twitter.com/GaryCashToken
9 
10 
11 
12                                   ,;;;;;;,
13                                 ,;;;'""`;;\
14                               ,;;;/  .'`',;\
15                             ,;;;;/   |    \|_
16                            /;;;;;    \    / .\
17                          ,;;;;;;|     '.  \/_/
18                         /;;;;;;;|       \
19              _,.---._  /;;;;;;;;|        ;   _.---.,_
20            .;;/      `.;;;;;;;;;|         ;'      \;;,
21          .;;;/         `;;;;;;;;;.._    .'         \;;;.
22         /;;;;|          _;-"`       `"-;_          |;;;;\
23        |;;;;;|.---.   .'  __.-"```"-.__  '.   .---.|;;;;;|
24        |;;;;;|     `\/  .'/__\     /__\'.  \/`     |;;;;;|
25        |;;;;;|       |_/ //  \\   //  \\ \_|       |;;;;;|
26        |;;;;;|       |/ |/    || ||    \| \|       |;;;;;|
27         \;;;;|    __ || _  .-.\| |/.-.  _ || __    |;;;;/
28          \;;;|   / _\|/ = /_$_\   /_$_\ = \|/_ \   |;;;/
29           \;;/   |`.-     `   `   `   `     -.`|   \;;/
30          _|;'    \ |    _     _   _     _    | /    ';|_
31         / .\      \\_  ( '--'(     )'--' )  _//      /. \
32         \/_/       \_/|  /_   |   |   _\  |\_/       \_\/
33                       | /|\\  \   /  //|\ |
34                       |  | \'._'-'_.'/ |  |
35                       |  ;  '-.```.-'  ;  |
36                       |   \    ```    /   |
37     __                ;    '.-$GARY-.'    ;                __
38    /\ \_         __..--\     `-$$$-'     /--..__         _/ /\
39    \_'/\`''---''`..;;;;.'.__,       ,__.',;;;;..`''---''`/\'_/
40         '-.__'';;;;;;;;;;;,,'._   _.',,;;;;;;;;;;;''__.-'
41              ``''--; ;;;;;;;;..`"`..;;;;;;;; ;--''``   _
42         .-.       /,;;;;;;;';;;;;;;;;';;;;;;;,\    _.-' `\
43       .'  /_     /,;;;;;;'/| ;;;;;;; |\';;;;;;,\  `\     '-'|
44      /      )   /,;;;;;',' | ;;;;;;; | ',';;;;;,\   \   .'-./
45      `'-..-'   /,;;;;','   | ;;;;;;; |   ',';;;;,\   `"`
46               | ;;;','     | ;;;;;;; |  ,  ', ;;;'|
47              _\__.-'  .-.  ; ;;;;;;; ;  |'-. '-.__/_
48             / .\     (   )  \';;;;;'/   |   |    /. \
49             \/_/   (`     `) \';;;'/    '-._|    \_\/
50                     '-/ \-'   '._.'         `
51                       """      /.`\
52                                \|_/
53 
54 */
55 
56 
57 
58 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
59 
60 
61 
62 
63 pragma solidity >=0.5.0;
64 
65 interface IUniswapV2Factory {
66     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
67 
68     function feeTo() external view returns (address);
69     function feeToSetter() external view returns (address);
70 
71     function getPair(address tokenA, address tokenB) external view returns (address pair);
72     function allPairs(uint) external view returns (address pair);
73     function allPairsLength() external view returns (uint);
74 
75     function createPair(address tokenA, address tokenB) external returns (address pair);
76 
77     function setFeeTo(address) external;
78     function setFeeToSetter(address) external;
79 }
80 
81 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
82 
83 
84 
85 
86 pragma solidity >=0.5.0;
87 
88 interface IUniswapV2Pair {
89     event Approval(address indexed owner, address indexed spender, uint value);
90     event Transfer(address indexed from, address indexed to, uint value);
91 
92     function name() external pure returns (string memory);
93     function symbol() external pure returns (string memory);
94     function decimals() external pure returns (uint8);
95     function totalSupply() external view returns (uint);
96     function balanceOf(address owner) external view returns (uint);
97     function allowance(address owner, address spender) external view returns (uint);
98 
99     function approve(address spender, uint value) external returns (bool);
100     function transfer(address to, uint value) external returns (bool);
101     function transferFrom(address from, address to, uint value) external returns (bool);
102 
103     function DOMAIN_SEPARATOR() external view returns (bytes32);
104     function PERMIT_TYPEHASH() external pure returns (bytes32);
105     function nonces(address owner) external view returns (uint);
106 
107     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
108 
109     event Mint(address indexed sender, uint amount0, uint amount1);
110     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
111     event Swap(
112         address indexed sender,
113         uint amount0In,
114         uint amount1In,
115         uint amount0Out,
116         uint amount1Out,
117         address indexed to
118     );
119     event Sync(uint112 reserve0, uint112 reserve1);
120 
121     function MINIMUM_LIQUIDITY() external pure returns (uint);
122     function factory() external view returns (address);
123     function token0() external view returns (address);
124     function token1() external view returns (address);
125     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
126     function price0CumulativeLast() external view returns (uint);
127     function price1CumulativeLast() external view returns (uint);
128     function kLast() external view returns (uint);
129 
130     function mint(address to) external returns (uint liquidity);
131     function burn(address to) external returns (uint amount0, uint amount1);
132     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
133     function skim(address to) external;
134     function sync() external;
135 
136     function initialize(address, address) external;
137 }
138 
139 // File: @openzeppelin/contracts@4.9.1/token/ERC20/IERC20.sol
140 
141 
142 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Interface of the ERC20 standard as defined in the EIP.
148  */
149 interface IERC20 {
150     /**
151      * @dev Emitted when `value` tokens are moved from one account (`from`) to
152      * another (`to`).
153      *
154      * Note that `value` may be zero.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 
158     /**
159      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
160      * a call to {approve}. `value` is the new allowance.
161      */
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `to`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address to, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `from` to `to` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(address from, address to, uint256 amount) external returns (bool);
218 }
219 
220 // File: @openzeppelin/contracts@4.9.1/token/ERC20/extensions/IERC20Metadata.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 
228 /**
229  * @dev Interface for the optional metadata functions from the ERC20 standard.
230  *
231  * _Available since v4.1._
232  */
233 interface IERC20Metadata is IERC20 {
234     /**
235      * @dev Returns the name of the token.
236      */
237     function name() external view returns (string memory);
238 
239     /**
240      * @dev Returns the symbol of the token.
241      */
242     function symbol() external view returns (string memory);
243 
244     /**
245      * @dev Returns the decimals places of the token.
246      */
247     function decimals() external view returns (uint8);
248 }
249 
250 // File: @openzeppelin/contracts@4.9.1/utils/Context.sol
251 
252 
253 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev Provides information about the current execution context, including the
259  * sender of the transaction and its data. While these are generally available
260  * via msg.sender and msg.data, they should not be accessed in such a direct
261  * manner, since when dealing with meta-transactions the account sending and
262  * paying for execution may not be the actual sender (as far as an application
263  * is concerned).
264  *
265  * This contract is only required for intermediate, library-like contracts.
266  */
267 abstract contract Context {
268     function _msgSender() internal view virtual returns (address) {
269         return msg.sender;
270     }
271 
272     function _msgData() internal view virtual returns (bytes calldata) {
273         return msg.data;
274     }
275 }
276 
277 // File: @openzeppelin/contracts@4.9.1/token/ERC20/ERC20.sol
278 
279 
280 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 
285 
286 
287 /**
288  * @dev Implementation of the {IERC20} interface.
289  *
290  * This implementation is agnostic to the way tokens are created. This means
291  * that a supply mechanism has to be added in a derived contract using {_mint}.
292  * For a generic mechanism see {ERC20PresetMinterPauser}.
293  *
294  * TIP: For a detailed writeup see our guide
295  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
296  * to implement supply mechanisms].
297  *
298  * The default value of {decimals} is 18. To change this, you should override
299  * this function so it returns a different value.
300  *
301  * We have followed general OpenZeppelin Contracts guidelines: functions revert
302  * instead returning `false` on failure. This behavior is nonetheless
303  * conventional and does not conflict with the expectations of ERC20
304  * applications.
305  *
306  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
307  * This allows applications to reconstruct the allowance for all accounts just
308  * by listening to said events. Other implementations of the EIP may not emit
309  * these events, as it isn't required by the specification.
310  *
311  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
312  * functions have been added to mitigate the well-known issues around setting
313  * allowances. See {IERC20-approve}.
314  */
315 contract ERC20 is Context, IERC20, IERC20Metadata {
316     mapping(address => uint256) private _balances;
317 
318     mapping(address => mapping(address => uint256)) private _allowances;
319 
320     uint256 private _totalSupply;
321 
322     string private _name;
323     string private _symbol;
324 
325     /**
326      * @dev Sets the values for {name} and {symbol}.
327      *
328      * All two of these values are immutable: they can only be set once during
329      * construction.
330      */
331     constructor(string memory name_, string memory symbol_) {
332         _name = name_;
333         _symbol = symbol_;
334     }
335 
336     /**
337      * @dev Returns the name of the token.
338      */
339     function name() public view virtual override returns (string memory) {
340         return _name;
341     }
342 
343     /**
344      * @dev Returns the symbol of the token, usually a shorter version of the
345      * name.
346      */
347     function symbol() public view virtual override returns (string memory) {
348         return _symbol;
349     }
350 
351     /**
352      * @dev Returns the number of decimals used to get its user representation.
353      * For example, if `decimals` equals `2`, a balance of `505` tokens should
354      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
355      *
356      * Tokens usually opt for a value of 18, imitating the relationship between
357      * Ether and Wei. This is the default value returned by this function, unless
358      * it's overridden.
359      *
360      * NOTE: This information is only used for _display_ purposes: it in
361      * no way affects any of the arithmetic of the contract, including
362      * {IERC20-balanceOf} and {IERC20-transfer}.
363      */
364     function decimals() public view virtual override returns (uint8) {
365         return 18;
366     }
367 
368     /**
369      * @dev See {IERC20-totalSupply}.
370      */
371     function totalSupply() public view virtual override returns (uint256) {
372         return _totalSupply;
373     }
374 
375     /**
376      * @dev See {IERC20-balanceOf}.
377      */
378     function balanceOf(address account) public view virtual override returns (uint256) {
379         return _balances[account];
380     }
381 
382     /**
383      * @dev See {IERC20-transfer}.
384      *
385      * Requirements:
386      *
387      * - `to` cannot be the zero address.
388      * - the caller must have a balance of at least `amount`.
389      */
390     function transfer(address to, uint256 amount) public virtual override returns (bool) {
391         address owner = _msgSender();
392         _transfer(owner, to, amount);
393         return true;
394     }
395 
396     /**
397      * @dev See {IERC20-allowance}.
398      */
399     function allowance(address owner, address spender) public view virtual override returns (uint256) {
400         return _allowances[owner][spender];
401     }
402 
403     /**
404      * @dev See {IERC20-approve}.
405      *
406      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
407      * `transferFrom`. This is semantically equivalent to an infinite approval.
408      *
409      * Requirements:
410      *
411      * - `spender` cannot be the zero address.
412      */
413     function approve(address spender, uint256 amount) public virtual override returns (bool) {
414         address owner = _msgSender();
415         _approve(owner, spender, amount);
416         return true;
417     }
418 
419     /**
420      * @dev See {IERC20-transferFrom}.
421      *
422      * Emits an {Approval} event indicating the updated allowance. This is not
423      * required by the EIP. See the note at the beginning of {ERC20}.
424      *
425      * NOTE: Does not update the allowance if the current allowance
426      * is the maximum `uint256`.
427      *
428      * Requirements:
429      *
430      * - `from` and `to` cannot be the zero address.
431      * - `from` must have a balance of at least `amount`.
432      * - the caller must have allowance for ``from``'s tokens of at least
433      * `amount`.
434      */
435     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
436         address spender = _msgSender();
437         _spendAllowance(from, spender, amount);
438         _transfer(from, to, amount);
439         return true;
440     }
441 
442     /**
443      * @dev Atomically increases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      */
454     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
455         address owner = _msgSender();
456         _approve(owner, spender, allowance(owner, spender) + addedValue);
457         return true;
458     }
459 
460     /**
461      * @dev Atomically decreases the allowance granted to `spender` by the caller.
462      *
463      * This is an alternative to {approve} that can be used as a mitigation for
464      * problems described in {IERC20-approve}.
465      *
466      * Emits an {Approval} event indicating the updated allowance.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      * - `spender` must have allowance for the caller of at least
472      * `subtractedValue`.
473      */
474     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
475         address owner = _msgSender();
476         uint256 currentAllowance = allowance(owner, spender);
477         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
478         unchecked {
479             _approve(owner, spender, currentAllowance - subtractedValue);
480         }
481 
482         return true;
483     }
484 
485     /**
486      * @dev Moves `amount` of tokens from `from` to `to`.
487      *
488      * This internal function is equivalent to {transfer}, and can be used to
489      * e.g. implement automatic token fees, slashing mechanisms, etc.
490      *
491      * Emits a {Transfer} event.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `from` must have a balance of at least `amount`.
498      */
499     function _transfer(address from, address to, uint256 amount) internal virtual {
500         require(from != address(0), "ERC20: transfer from the zero address");
501         require(to != address(0), "ERC20: transfer to the zero address");
502 
503         _beforeTokenTransfer(from, to, amount);
504 
505         uint256 fromBalance = _balances[from];
506         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
507         unchecked {
508             _balances[from] = fromBalance - amount;
509             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
510             // decrementing then incrementing.
511             _balances[to] += amount;
512         }
513 
514         emit Transfer(from, to, amount);
515 
516         _afterTokenTransfer(from, to, amount);
517     }
518 
519     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
520      * the total supply.
521      *
522      * Emits a {Transfer} event with `from` set to the zero address.
523      *
524      * Requirements:
525      *
526      * - `account` cannot be the zero address.
527      */
528     function _mint(address account, uint256 amount) internal virtual {
529         require(account != address(0), "ERC20: mint to the zero address");
530 
531         _beforeTokenTransfer(address(0), account, amount);
532 
533         _totalSupply += amount;
534         unchecked {
535             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
536             _balances[account] += amount;
537         }
538         emit Transfer(address(0), account, amount);
539 
540         _afterTokenTransfer(address(0), account, amount);
541     }
542 
543     /**
544      * @dev Destroys `amount` tokens from `account`, reducing the
545      * total supply.
546      *
547      * Emits a {Transfer} event with `to` set to the zero address.
548      *
549      * Requirements:
550      *
551      * - `account` cannot be the zero address.
552      * - `account` must have at least `amount` tokens.
553      */
554     function _burn(address account, uint256 amount) internal virtual {
555         require(account != address(0), "ERC20: burn from the zero address");
556 
557         _beforeTokenTransfer(account, address(0), amount);
558 
559         uint256 accountBalance = _balances[account];
560         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
561         unchecked {
562             _balances[account] = accountBalance - amount;
563             // Overflow not possible: amount <= accountBalance <= totalSupply.
564             _totalSupply -= amount;
565         }
566 
567         emit Transfer(account, address(0), amount);
568 
569         _afterTokenTransfer(account, address(0), amount);
570     }
571 
572     /**
573      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
574      *
575      * This internal function is equivalent to `approve`, and can be used to
576      * e.g. set automatic allowances for certain subsystems, etc.
577      *
578      * Emits an {Approval} event.
579      *
580      * Requirements:
581      *
582      * - `owner` cannot be the zero address.
583      * - `spender` cannot be the zero address.
584      */
585     function _approve(address owner, address spender, uint256 amount) internal virtual {
586         require(owner != address(0), "ERC20: approve from the zero address");
587         require(spender != address(0), "ERC20: approve to the zero address");
588 
589         _allowances[owner][spender] = amount;
590         emit Approval(owner, spender, amount);
591     }
592 
593     /**
594      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
595      *
596      * Does not update the allowance amount in case of infinite allowance.
597      * Revert if not enough allowance is available.
598      *
599      * Might emit an {Approval} event.
600      */
601     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
602         uint256 currentAllowance = allowance(owner, spender);
603         if (currentAllowance != type(uint256).max) {
604             require(currentAllowance >= amount, "ERC20: insufficient allowance");
605             unchecked {
606                 _approve(owner, spender, currentAllowance - amount);
607             }
608         }
609     }
610 
611     /**
612      * @dev Hook that is called before any transfer of tokens. This includes
613      * minting and burning.
614      *
615      * Calling conditions:
616      *
617      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
618      * will be transferred to `to`.
619      * - when `from` is zero, `amount` tokens will be minted for `to`.
620      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
621      * - `from` and `to` are never both zero.
622      *
623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
624      */
625     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
626 
627     /**
628      * @dev Hook that is called after any transfer of tokens. This includes
629      * minting and burning.
630      *
631      * Calling conditions:
632      *
633      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
634      * has been transferred to `to`.
635      * - when `from` is zero, `amount` tokens have been minted for `to`.
636      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
637      * - `from` and `to` are never both zero.
638      *
639      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
640      */
641     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
642 }
643 
644 // File: @openzeppelin/contracts@4.9.1/access/Ownable.sol
645 
646 
647 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
648 
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @dev Contract module which provides a basic access control mechanism, where
654  * there is an account (an owner) that can be granted exclusive access to
655  * specific functions.
656  *
657  * By default, the owner account will be the one that deploys the contract. This
658  * can later be changed with {transferOwnership}.
659  *
660  * This module is used through inheritance. It will make available the modifier
661  * `onlyOwner`, which can be applied to your functions to restrict their use to
662  * the owner.
663  */
664 abstract contract Ownable is Context {
665     address private _owner;
666 
667     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
668 
669     /**
670      * @dev Initializes the contract setting the deployer as the initial owner.
671      */
672     constructor() {
673         _transferOwnership(_msgSender());
674     }
675 
676     /**
677      * @dev Throws if called by any account other than the owner.
678      */
679     modifier onlyOwner() {
680         _checkOwner();
681         _;
682     }
683 
684     /**
685      * @dev Returns the address of the current owner.
686      */
687     function owner() public view virtual returns (address) {
688         return _owner;
689     }
690 
691     /**
692      * @dev Throws if the sender is not the owner.
693      */
694     function _checkOwner() internal view virtual {
695         require(owner() == _msgSender(), "Ownable: caller is not the owner");
696     }
697 
698     /**
699      * @dev Leaves the contract without owner. It will not be possible to call
700      * `onlyOwner` functions. Can only be called by the current owner.
701      *
702      * NOTE: Renouncing ownership will leave the contract without an owner,
703      * thereby disabling any functionality that is only available to the owner.
704      */
705     function renounceOwnership() public virtual onlyOwner {
706         _transferOwnership(address(0));
707     }
708 
709     /**
710      * @dev Transfers ownership of the contract to a new account (`newOwner`).
711      * Can only be called by the current owner.
712      */
713     function transferOwnership(address newOwner) public virtual onlyOwner {
714         require(newOwner != address(0), "Ownable: new owner is the zero address");
715         _transferOwnership(newOwner);
716     }
717 
718     /**
719      * @dev Transfers ownership of the contract to a new account (`newOwner`).
720      * Internal function without access restriction.
721      */
722     function _transferOwnership(address newOwner) internal virtual {
723         address oldOwner = _owner;
724         _owner = newOwner;
725         emit OwnershipTransferred(oldOwner, newOwner);
726     }
727 }
728 
729 // File: contracts/GARY_FINISH.sol
730 
731 
732 
733 
734 
735 pragma solidity ^0.8.0;
736 
737 
738 
739 
740 
741 contract GARY is ERC20, Ownable {
742     uint256 private constant _totalSupply = 420000000000000 * 10**18;
743      bool public limited;
744      uint256 public maxHoldingAmount;
745      uint256 public minHoldingAmount;
746      address public uniswapV2Pair;
747      mapping(address => bool) public blacklists;
748 
749 
750     constructor() ERC20("GARY", "GARY") {
751         _mint(msg.sender, _totalSupply);
752     }
753     
754     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
755     blacklists[_address] = _isBlacklisting;
756     }
757 
758     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
759     limited = _limited;
760     uniswapV2Pair = _uniswapV2Pair;
761     maxHoldingAmount = _maxHoldingAmount;
762     minHoldingAmount = _minHoldingAmount;
763     }
764 
765     function _beforeTokenTransfer(
766     address from,
767     address to,
768     uint256 amount
769     ) override internal virtual {
770     require(!blacklists[to] && !blacklists[from], "Blacklisted");
771 
772     if (uniswapV2Pair == address(0)) {
773     require(from == owner() || to == owner(), "trading is not started");
774     return;
775     }
776 
777     if (limited && from == uniswapV2Pair) {
778     require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
779     }
780   }
781 }