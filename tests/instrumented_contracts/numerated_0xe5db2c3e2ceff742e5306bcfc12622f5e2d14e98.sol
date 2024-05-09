1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 contract Ownable is Context {
15     address private _owner;
16     address private _previousOwner;
17     uint256 private _lockTime;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() {
25         address msgSender = _msgSender();
26         _owner = msgSender;
27         emit OwnershipTransferred(address(0), msgSender);
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(_owner == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         emit OwnershipTransferred(_owner, newOwner);
64         _owner = newOwner;
65     }
66 
67     function getUnlockTime() public view returns (uint256) {
68         return _lockTime;
69     }
70 
71     //Added function
72     // 1 minute = 60
73     // 1h 3600
74     // 24h 86400
75     // 1w 604800
76 
77     function getTime() public view returns (uint256) {
78         return block.timestamp;
79     }
80 
81     function lock(uint256 time) public virtual onlyOwner {
82         _previousOwner = _owner;
83         _owner = address(0);
84         _lockTime = block.timestamp + time;
85         emit OwnershipTransferred(_owner, address(0));
86     }
87 
88     function unlock() public virtual {
89         require(_previousOwner == msg.sender, "You don't have permission to unlock");
90         require(block.timestamp > _lockTime, "Contract is locked until 7 days");
91         emit OwnershipTransferred(_owner, _previousOwner);
92         _owner = _previousOwner;
93     }
94 }
95 
96 abstract contract ReentrancyGuard {
97     // Booleans are more expensive than uint256 or any type that takes up a full
98     // word because each write operation emits an extra SLOAD to first read the
99     // slot's contents, replace the bits taken up by the boolean, and then write
100     // back. This is the compiler's defense against contract upgrades and
101     // pointer aliasing, and it cannot be disabled.
102 
103     // The values being non-zero value makes deployment a bit more expensive,
104     // but in exchange the refund on every call to nonReentrant will be lower in
105     // amount. Since refunds are capped to a percentage of the total
106     // transaction's gas, it is best to keep them low in cases like this one, to
107     // increase the likelihood of the full refund coming into effect.
108     uint256 private constant _NOT_ENTERED = 1;
109     uint256 private constant _ENTERED = 2;
110 
111     uint256 private _status;
112 
113     constructor() internal {
114         _status = _NOT_ENTERED;
115     }
116 
117     /**
118      * @dev Prevents a contract from calling itself, directly or indirectly.
119      * Calling a `nonReentrant` function from another `nonReentrant`
120      * function is not supported. It is possible to prevent this from happening
121      * by making the `nonReentrant` function external, and make it call a
122      * `private` function that does the actual work.
123      */
124     modifier nonReentrant() {
125         // On the first call to nonReentrant, _notEntered will be true
126         require(_status != _ENTERED, "nonReentrant:: reentrant call");
127 
128         // Any calls to nonReentrant after this point will fail
129         _status = _ENTERED;
130 
131         _;
132 
133         // By storing the original value once again, a refund is triggered (see
134         // https://eips.ethereum.org/EIPS/eip-2200)
135         _status = _NOT_ENTERED;
136     }
137 
138     modifier isHuman() {
139         require(tx.origin == msg.sender, "isHuman:: sorry humans only");
140         _;
141     }
142 }
143 
144 interface IERC20 {
145     /**
146      * @dev Returns the amount of tokens in existence.
147      */
148     function totalSupply() external view returns (uint256);
149 
150     /**
151      * @dev Returns the amount of tokens owned by `account`.
152      */
153     function balanceOf(address account) external view returns (uint256);
154 
155     /**
156      * @dev Moves `amount` tokens from the caller's account to `recipient`.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transfer(address recipient, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Returns the remaining number of tokens that `spender` will be
166      * allowed to spend on behalf of `owner` through {transferFrom}. This is
167      * zero by default.
168      *
169      * This value changes when {approve} or {transferFrom} are called.
170      */
171     function allowance(address owner, address spender) external view returns (uint256);
172 
173     /**
174      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * IMPORTANT: Beware that changing an allowance with this method brings the risk
179      * that someone may use both the old and the new allowance by unfortunate
180      * transaction ordering. One possible solution to mitigate this race
181      * condition is to first reduce the spender's allowance to 0 and set the
182      * desired value afterwards:
183      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      *
185      * Emits an {Approval} event.
186      */
187     function approve(address spender, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Moves `amount` tokens from `sender` to `recipient` using the
191      * allowance mechanism. `amount` is then deducted from the caller's
192      * allowance.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) external returns (bool);
203 
204     /**
205      * @dev Emitted when `value` tokens are moved from one account (`from`) to
206      * another (`to`).
207      *
208      * Note that `value` may be zero.
209      */
210     event Transfer(address indexed from, address indexed to, uint256 value);
211 
212     /**
213      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
214      * a call to {approve}. `value` is the new allowance.
215      */
216     event Approval(address indexed owner, address indexed spender, uint256 value);
217 }
218 
219 interface IERC20Metadata is IERC20 {
220     /**
221      * @dev Returns the name of the token.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the symbol of the token.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the decimals places of the token.
232      */
233     function decimals() external view returns (uint8);
234 }
235 
236 contract ERC20 is Context, IERC20, IERC20Metadata {
237     using SafeMath for uint256;
238 
239     mapping(address => uint256) private _balances;
240 
241     mapping(address => mapping(address => uint256)) private _allowances;
242 
243     uint256 private _totalSupply;
244 
245     string private _name;
246     string private _symbol;
247 
248     /**
249      * @dev Sets the values for {name} and {symbol}.
250      *
251      * The default value of {decimals} is 18. To select a different value for
252      * {decimals} you should overload it.
253      *
254      * All two of these values are immutable: they can only be set once during
255      * construction.
256      */
257     constructor(string memory name_, string memory symbol_) {
258         _name = name_;
259         _symbol = symbol_;
260     }
261 
262     /**
263      * @dev Returns the name of the token.
264      */
265     function name() public view virtual override returns (string memory) {
266         return _name;
267     }
268 
269     /**
270      * @dev Returns the symbol of the token, usually a shorter version of the
271      * name.
272      */
273     function symbol() public view virtual override returns (string memory) {
274         return _symbol;
275     }
276 
277     /**
278      * @dev Returns the number of decimals used to get its user representation.
279      * For example, if `decimals` equals `2`, a balance of `505` tokens should
280      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
281      *
282      * Tokens usually opt for a value of 18, imitating the relationship between
283      * Ether and Wei. This is the value {ERC20} uses, unless this function is
284      * overridden;
285      *
286      * NOTE: This information is only used for _display_ purposes: it in
287      * no way affects any of the arithmetic of the contract, including
288      * {IERC20-balanceOf} and {IERC20-transfer}.
289      */
290     function decimals() public view virtual override returns (uint8) {
291         return 9;
292     }
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view virtual override returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev See {IERC20-balanceOf}.
303      */
304     function balanceOf(address account) public view virtual override returns (uint256) {
305         return _balances[account];
306     }
307 
308     /**
309      * @dev See {IERC20-transfer}.
310      *
311      * Requirements:
312      *
313      * - `recipient` cannot be the zero address.
314      * - the caller must have a balance of at least `amount`.
315      */
316     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
317         _transfer(_msgSender(), recipient, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-allowance}.
323      */
324     function allowance(address owner, address spender) public view virtual override returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     /**
329      * @dev See {IERC20-approve}.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function approve(address spender, uint256 amount) public virtual override returns (bool) {
336         _approve(_msgSender(), spender, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-transferFrom}.
342      *
343      * Emits an {Approval} event indicating the updated allowance. This is not
344      * required by the EIP. See the note at the beginning of {ERC20}.
345      *
346      * Requirements:
347      *
348      * - `sender` and `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      * - the caller must have allowance for ``sender``'s tokens of at least
351      * `amount`.
352      */
353     function transferFrom(
354         address sender,
355         address recipient,
356         uint256 amount
357     ) public virtual override returns (bool) {
358         _transfer(sender, recipient, amount);
359         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
360         return true;
361     }
362 
363     /**
364      * @dev Atomically increases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      */
375     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
376         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
377         return true;
378     }
379 
380     /**
381      * @dev Atomically decreases the allowance granted to `spender` by the caller.
382      *
383      * This is an alternative to {approve} that can be used as a mitigation for
384      * problems described in {IERC20-approve}.
385      *
386      * Emits an {Approval} event indicating the updated allowance.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      * - `spender` must have allowance for the caller of at least
392      * `subtractedValue`.
393      */
394     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
395         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
396         return true;
397     }
398 
399     /**
400      * @dev Moves tokens `amount` from `sender` to `recipient`.
401      *
402      * This is internal function is equivalent to {transfer}, and can be used to
403      * e.g. implement automatic token fees, slashing mechanisms, etc.
404      *
405      * Emits a {Transfer} event.
406      *
407      * Requirements:
408      *
409      * - `sender` cannot be the zero address.
410      * - `recipient` cannot be the zero address.
411      * - `sender` must have a balance of at least `amount`.
412      */
413     function _transfer(
414         address sender,
415         address recipient,
416         uint256 amount
417     ) internal virtual {
418         require(sender != address(0), "ERC20: transfer from the zero address");
419         require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421         _beforeTokenTransfer(sender, recipient, amount);
422 
423         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
424         _balances[recipient] = _balances[recipient].add(amount);
425         emit Transfer(sender, recipient, amount);
426     }
427 
428     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
429      * the total supply.
430      *
431      * Emits a {Transfer} event with `from` set to the zero address.
432      *
433      * Requirements:
434      *
435      * - `account` cannot be the zero address.
436      */
437     function _mint(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: mint to the zero address");
439 
440         _beforeTokenTransfer(address(0), account, amount);
441 
442         _totalSupply = _totalSupply.add(amount);
443         _balances[account] = _balances[account].add(amount);
444         emit Transfer(address(0), account, amount);
445     }
446 
447     /**
448      * @dev Destroys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a {Transfer} event with `to` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 amount) internal virtual {
459         require(account != address(0), "ERC20: burn from the zero address");
460 
461         _beforeTokenTransfer(account, address(0), amount);
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
470      *
471      * This internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(
482         address owner,
483         address spender,
484         uint256 amount
485     ) internal virtual {
486         require(owner != address(0), "ERC20: approve from the zero address");
487         require(spender != address(0), "ERC20: approve to the zero address");
488 
489         _allowances[owner][spender] = amount;
490         emit Approval(owner, spender, amount);
491     }
492 
493     /**
494      * @dev Hook that is called before any transfer of tokens. This includes
495      * minting and burning.
496      *
497      * Calling conditions:
498      *
499      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
500      * will be to transferred to `to`.
501      * - when `from` is zero, `amount` tokens will be minted for `to`.
502      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
503      * - `from` and `to` are never both zero.
504      *
505      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
506      */
507     function _beforeTokenTransfer(
508         address from,
509         address to,
510         uint256 amount
511     ) internal virtual {}
512 }
513 
514 library SafeMath {
515     function add(uint256 a, uint256 b) internal pure returns (uint256) {
516         uint256 c = a + b;
517         require(c >= a, "SafeMath: addition overflow");
518         return c;
519     }
520 
521     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
522         return sub(a, b, "SafeMath: subtraction overflow");
523     }
524 
525     function sub(
526         uint256 a,
527         uint256 b,
528         string memory errorMessage
529     ) internal pure returns (uint256) {
530         require(b <= a, errorMessage);
531         uint256 c = a - b;
532         return c;
533     }
534 
535     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
536         if (a == 0) {
537             return 0;
538         }
539         uint256 c = a * b;
540         require(c / a == b, "SafeMath: multiplication overflow");
541         return c;
542     }
543 
544     function div(uint256 a, uint256 b) internal pure returns (uint256) {
545         return div(a, b, "SafeMath: division by zero");
546     }
547 
548     function div(
549         uint256 a,
550         uint256 b,
551         string memory errorMessage
552     ) internal pure returns (uint256) {
553         require(b > 0, errorMessage);
554         uint256 c = a / b;
555         return c;
556     }
557 }
558 
559 interface IUniswapV2Factory {
560     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
561 
562     function feeTo() external view returns (address);
563 
564     function feeToSetter() external view returns (address);
565 
566     function getPair(address tokenA, address tokenB) external view returns (address pair);
567 
568     function allPairs(uint256) external view returns (address pair);
569 
570     function allPairsLength() external view returns (uint256);
571 
572     function createPair(address tokenA, address tokenB) external returns (address pair);
573 
574     function setFeeTo(address) external;
575 
576     function setFeeToSetter(address) external;
577 }
578 
579 interface IUniswapV2Pair {
580     event Approval(address indexed owner, address indexed spender, uint256 value);
581     event Transfer(address indexed from, address indexed to, uint256 value);
582 
583     function name() external pure returns (string memory);
584 
585     function symbol() external pure returns (string memory);
586 
587     function decimals() external pure returns (uint8);
588 
589     function totalSupply() external view returns (uint256);
590 
591     function balanceOf(address owner) external view returns (uint256);
592 
593     function allowance(address owner, address spender) external view returns (uint256);
594 
595     function approve(address spender, uint256 value) external returns (bool);
596 
597     function transfer(address to, uint256 value) external returns (bool);
598 
599     function transferFrom(
600         address from,
601         address to,
602         uint256 value
603     ) external returns (bool);
604 
605     function DOMAIN_SEPARATOR() external view returns (bytes32);
606 
607     function PERMIT_TYPEHASH() external pure returns (bytes32);
608 
609     function nonces(address owner) external view returns (uint256);
610 
611     function permit(
612         address owner,
613         address spender,
614         uint256 value,
615         uint256 deadline,
616         uint8 v,
617         bytes32 r,
618         bytes32 s
619     ) external;
620 
621     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
622     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
623     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
624     event Sync(uint112 reserve0, uint112 reserve1);
625 
626     function MINIMUM_LIQUIDITY() external pure returns (uint256);
627 
628     function factory() external view returns (address);
629 
630     function token0() external view returns (address);
631 
632     function token1() external view returns (address);
633 
634     function getReserves()
635         external
636         view
637         returns (
638             uint112 reserve0,
639             uint112 reserve1,
640             uint32 blockTimestampLast
641         );
642 
643     function price0CumulativeLast() external view returns (uint256);
644 
645     function price1CumulativeLast() external view returns (uint256);
646 
647     function kLast() external view returns (uint256);
648 
649     function mint(address to) external returns (uint256 liquidity);
650 
651     function burn(address to) external returns (uint256 amount0, uint256 amount1);
652 
653     function swap(
654         uint256 amount0Out,
655         uint256 amount1Out,
656         address to,
657         bytes calldata data
658     ) external;
659 
660     function skim(address to) external;
661 
662     function sync() external;
663 
664     function initialize(address, address) external;
665 }
666 
667 interface IUniswapV2Router01 {
668     function factory() external pure returns (address);
669 
670     function WETH() external pure returns (address);
671 
672     function addLiquidity(
673         address tokenA,
674         address tokenB,
675         uint256 amountADesired,
676         uint256 amountBDesired,
677         uint256 amountAMin,
678         uint256 amountBMin,
679         address to,
680         uint256 deadline
681     )
682         external
683         returns (
684             uint256 amountA,
685             uint256 amountB,
686             uint256 liquidity
687         );
688 
689     function addLiquidityETH(
690         address token,
691         uint256 amountTokenDesired,
692         uint256 amountTokenMin,
693         uint256 amountETHMin,
694         address to,
695         uint256 deadline
696     )
697         external
698         payable
699         returns (
700             uint256 amountToken,
701             uint256 amountETH,
702             uint256 liquidity
703         );
704 
705     function removeLiquidity(
706         address tokenA,
707         address tokenB,
708         uint256 liquidity,
709         uint256 amountAMin,
710         uint256 amountBMin,
711         address to,
712         uint256 deadline
713     ) external returns (uint256 amountA, uint256 amountB);
714 
715     function removeLiquidityETH(
716         address token,
717         uint256 liquidity,
718         uint256 amountTokenMin,
719         uint256 amountETHMin,
720         address to,
721         uint256 deadline
722     ) external returns (uint256 amountToken, uint256 amountETH);
723 
724     function removeLiquidityWithPermit(
725         address tokenA,
726         address tokenB,
727         uint256 liquidity,
728         uint256 amountAMin,
729         uint256 amountBMin,
730         address to,
731         uint256 deadline,
732         bool approveMax,
733         uint8 v,
734         bytes32 r,
735         bytes32 s
736     ) external returns (uint256 amountA, uint256 amountB);
737 
738     function removeLiquidityETHWithPermit(
739         address token,
740         uint256 liquidity,
741         uint256 amountTokenMin,
742         uint256 amountETHMin,
743         address to,
744         uint256 deadline,
745         bool approveMax,
746         uint8 v,
747         bytes32 r,
748         bytes32 s
749     ) external returns (uint256 amountToken, uint256 amountETH);
750 
751     function swapExactTokensForTokens(
752         uint256 amountIn,
753         uint256 amountOutMin,
754         address[] calldata path,
755         address to,
756         uint256 deadline
757     ) external returns (uint256[] memory amounts);
758 
759     function swapTokensForExactTokens(
760         uint256 amountOut,
761         uint256 amountInMax,
762         address[] calldata path,
763         address to,
764         uint256 deadline
765     ) external returns (uint256[] memory amounts);
766 
767     function swapExactETHForTokens(
768         uint256 amountOutMin,
769         address[] calldata path,
770         address to,
771         uint256 deadline
772     ) external payable returns (uint256[] memory amounts);
773 
774     function swapTokensForExactETH(
775         uint256 amountOut,
776         uint256 amountInMax,
777         address[] calldata path,
778         address to,
779         uint256 deadline
780     ) external returns (uint256[] memory amounts);
781 
782     function swapExactTokensForETH(
783         uint256 amountIn,
784         uint256 amountOutMin,
785         address[] calldata path,
786         address to,
787         uint256 deadline
788     ) external returns (uint256[] memory amounts);
789 
790     function swapETHForExactTokens(
791         uint256 amountOut,
792         address[] calldata path,
793         address to,
794         uint256 deadline
795     ) external payable returns (uint256[] memory amounts);
796 
797     function quote(
798         uint256 amountA,
799         uint256 reserveA,
800         uint256 reserveB
801     ) external pure returns (uint256 amountB);
802 
803     function getAmountOut(
804         uint256 amountIn,
805         uint256 reserveIn,
806         uint256 reserveOut
807     ) external pure returns (uint256 amountOut);
808 
809     function getAmountIn(
810         uint256 amountOut,
811         uint256 reserveIn,
812         uint256 reserveOut
813     ) external pure returns (uint256 amountIn);
814 
815     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
816 
817     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
818 }
819 
820 interface IUniswapV2Router02 is IUniswapV2Router01 {
821     function removeLiquidityETHSupportingFeeOnTransferTokens(
822         address token,
823         uint256 liquidity,
824         uint256 amountTokenMin,
825         uint256 amountETHMin,
826         address to,
827         uint256 deadline
828     ) external returns (uint256 amountETH);
829 
830     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
831         address token,
832         uint256 liquidity,
833         uint256 amountTokenMin,
834         uint256 amountETHMin,
835         address to,
836         uint256 deadline,
837         bool approveMax,
838         uint8 v,
839         bytes32 r,
840         bytes32 s
841     ) external returns (uint256 amountETH);
842 
843     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
844         uint256 amountIn,
845         uint256 amountOutMin,
846         address[] calldata path,
847         address to,
848         uint256 deadline
849     ) external;
850 
851     function swapExactETHForTokensSupportingFeeOnTransferTokens(
852         uint256 amountOutMin,
853         address[] calldata path,
854         address to,
855         uint256 deadline
856     ) external payable;
857 
858     function swapExactTokensForETHSupportingFeeOnTransferTokens(
859         uint256 amountIn,
860         uint256 amountOutMin,
861         address[] calldata path,
862         address to,
863         uint256 deadline
864     ) external;
865 }
866 
867 contract ClienteleCoin is ERC20, Ownable, ReentrancyGuard {
868     using SafeMath for uint256;
869 
870     //AMM swap settings
871     IUniswapV2Router02 public uniswapV2Router;
872     address public immutable uniswapV2Pair;
873     uint256 public liquidateTokensAtAmount = 1000 * (10**9);
874 
875     //Token info
876     uint256 public constant TOTAL_SUPPLY = 137000000000000 * (10**9);
877 
878     //Transfer delay info
879     bool public TDEnabled = false;
880     uint256 public TD = 30 minutes;
881     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
882     mapping(address => uint256) private _soldTimes;
883     mapping(address => uint256) private _boughtTimes;
884 
885     //Tax info
886     bool _feesEnabled = true;
887     uint256 public constant ETH_REWARDS_FEE = 25;
888     uint256 public constant MARKETING_FEE = 25;
889     uint256 public constant DEV_FEE = 25;
890     uint256 public impactFee = 200;
891     uint256 public constant TOTAL_FEES = ETH_REWARDS_FEE + MARKETING_FEE + DEV_FEE;
892     address public devWallet = 0x395DA634618C39675b560Aa5d321966672D6DC71;
893     address public marketingWallet = 0xD7F7e7C412824C6f4F107453068e7c8062B0B488;
894     address private _airdropAddress = 0xAcfE101cA7E2bc9Ee6a76Deaa9Bc6C9DAb0b5481;
895 
896     mapping(address => bool) private _isExcludedFromFees;
897     uint256 public impactThreshold = 50;
898     bool public priceImpactFeeDisabled = true;
899 
900     // Claiming info
901     mapping(address => uint256) public nextAvailableClaimDate;
902     uint256 public rewardCycleBlock = 2 days;
903     uint256 threshHoldTopUpRate = 2;
904 
905     bool private liquidating = false;
906 
907     event UpdatedUniswapV2Router(address indexed newAddress, address indexed oldAddress);
908     event CycleBlockUpdated(uint256 indexed newBlock, uint256 indexed OldBlock);
909     event ImpactFeeUpdated(uint256 indexed newFee, uint256 indexed oldFee);
910     event ThresholdFeeUpdated(uint256 indexed newThreshold, uint256 indexed oldThreshold);
911     event ImpactFeeDisableUpdated(bool indexed value);
912 
913     event LiquidationThresholdUpdated(uint256 indexed newValue, uint256 indexed oldValue);
914     event TaxDistributed(uint256 tokensSwapped, uint256 ethReceived, uint256 rewardPoolGot, uint256 devGot, uint256 marketingGot);
915 
916     event ClaimSuccessfully(address recipient, uint256 ethReceived, uint256 nextAvailableClaimDate);
917 
918     constructor(address routerAddress) ERC20("ClienteleCoin", "CLT") {
919         //set amm info
920         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress);
921         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
922         uniswapV2Router = _uniswapV2Router;
923         uniswapV2Pair = _uniswapV2Pair;
924 
925         // exclude from paying fees or having max transaction amount
926         excludeFromFees(owner());
927         excludeFromFees(address(this));
928 
929         // mint tokens
930         _mint(owner(), TOTAL_SUPPLY);
931     }
932 
933     receive() external payable {}
934 
935     function updateUniswapV2Router(address newAddress) public onlyOwner {
936         require(newAddress != address(uniswapV2Router), "CLT: The router already has that address");
937         emit UpdatedUniswapV2Router(newAddress, address(uniswapV2Router));
938         uniswapV2Router = IUniswapV2Router02(newAddress);
939     }
940 
941     function enableFees() public onlyOwner {
942         _feesEnabled = true;
943     }
944 
945     function disableFees() public onlyOwner {
946         _feesEnabled = false;
947     }
948 
949     function updateliquidateTokensAtAmount(uint256 newValue) public onlyOwner {
950         liquidateTokensAtAmount = newValue;
951     }
952 
953     function updateAirdropAddress(address airdropAddress) public onlyOwner {
954         _airdropAddress = airdropAddress;
955     }
956 
957     function updateRewardCycleBlock(uint256 newBlock) public onlyOwner {
958         emit CycleBlockUpdated(newBlock, rewardCycleBlock);
959         rewardCycleBlock = newBlock;
960     }
961 
962     function updateImpactThreshold(uint256 newValue) public onlyOwner {
963         emit ThresholdFeeUpdated(newValue, impactThreshold);
964         impactThreshold = newValue;
965     }
966 
967     function updateImpactFee(uint256 newValue) public onlyOwner {
968         emit ImpactFeeUpdated(newValue, impactFee);
969         impactFee = newValue;
970     }
971 
972     function updateImpactFeeDisabled(bool newValue) public onlyOwner {
973         emit ImpactFeeDisableUpdated(newValue);
974         priceImpactFeeDisabled = newValue;
975     }
976 
977     function excludeFromFees(address account) public onlyOwner {
978         _isExcludedFromFees[account] = true;
979     }
980 
981     function includeToFees(address account) public onlyOwner {
982         _isExcludedFromFees[account] = false;
983     }
984 
985     function updateLiquidationThreshold(uint256 newValue) external onlyOwner {
986         emit LiquidationThresholdUpdated(newValue, liquidateTokensAtAmount);
987         liquidateTokensAtAmount = newValue;
988     }
989 
990     function activateTD() external onlyOwner {
991         TDEnabled = true;
992     }
993 
994     function DisableTD() external onlyOwner {
995         TDEnabled = false;
996     }
997 
998     function setTDTime(uint256 delay) public onlyOwner returns (bool) {
999         TD = delay; // in seconds
1000         return true;
1001     }
1002 
1003     function getPriceImpactFee(uint256 amount) public view returns (uint256) {
1004         if (priceImpactFeeDisabled) return 0;
1005 
1006         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1007         address token0 = pair.token0();
1008         address token1 = pair.token1();
1009         uint256 reserve0;
1010         uint256 reserve1;
1011 
1012         if (token0 == address(this)) {
1013             (reserve1, reserve0, ) = pair.getReserves();
1014         } else if (token1 == address(this)) {
1015             (reserve0, reserve1, ) = pair.getReserves();
1016         }
1017 
1018         if (reserve0 == 0 && reserve1 == 0) {
1019             // check liquidity has ever been added or not. if not, the function will return zero impact
1020             return 0;
1021         }
1022 
1023         uint256 amountB = uniswapV2Router.getAmountIn(amount, reserve0, reserve1);
1024         uint256 priceImpact = reserve0.sub(reserve0.sub(amountB)).mul(10000) / reserve0;
1025 
1026         if (priceImpact >= impactThreshold) {
1027             return impactFee;
1028         }
1029 
1030         return 0;
1031     }
1032 
1033     function _transfer(
1034         address from,
1035         address to,
1036         uint256 amount
1037     ) internal override {
1038         require(from != address(0), "ERC20: transfer from the zero address");
1039         require(to != address(0), "ERC20: transfer to the zero address");
1040 
1041         if (amount == 0) {
1042             super._transfer(from, to, 0);
1043             return;
1044         }
1045 
1046         //check if tx delay enabled, the sender should wait until the delay passess
1047         if (TDEnabled && !liquidating) {
1048             if (from == address(uniswapV2Pair)) {
1049                 uint256 multiplier = _boughtTimes[to] == 1 ? 2 : 1;
1050                 require(
1051                     (_holderLastTransferTimestamp[to].add(TD.mul(multiplier)) <= block.timestamp) || _isExcludedFromFees[to],
1052                     "_transfer:: Transfer Delay enabled.  Please try again after the tx block passess"
1053                 );
1054                 _holderLastTransferTimestamp[to] = block.timestamp;
1055                 _boughtTimes[to] = _boughtTimes[to] + 1;
1056             } else if (to == address(uniswapV2Pair)) {
1057                 uint256 multiplier = _soldTimes[from] == 1 ? 2 : 1;
1058                 require(
1059                     (_holderLastTransferTimestamp[from].add(TD.mul(multiplier)) <= block.timestamp) || _isExcludedFromFees[from],
1060                     "_transfer:: Transfer Delay enabled.  Please try again after the tx block passess"
1061                 );
1062                 _holderLastTransferTimestamp[from] = block.timestamp;
1063                 _soldTimes[to] = _soldTimes[to] + 1;
1064             } else {
1065                 require(
1066                     (_holderLastTransferTimestamp[from].add(TD.mul(2)) <= block.timestamp) || _isExcludedFromFees[from],
1067                     "_transfer:: Transfer Delay enabled.  Please try again after the tx block passess"
1068                 );
1069                 _holderLastTransferTimestamp[from] = block.timestamp;
1070             }
1071         }
1072 
1073         //if tokens came from airdrop wallet, then add anti-dump transfer delay for recepients
1074         if (from == _airdropAddress) {
1075             _holderLastTransferTimestamp[to] = block.timestamp + 2 hours;
1076         }
1077 
1078         //check the contract balance > swap amount threshold,
1079         //then do it and distribute rewards to the reward pool, dev, markting wallet
1080         //distribution won't work in case a transfer is from uni
1081         uint256 contractTokenBalance = balanceOf(address(this));
1082         bool canSwap = contractTokenBalance >= liquidateTokensAtAmount;
1083         if (canSwap && from != address(uniswapV2Pair)) swapAndDistributeRewards(contractTokenBalance);
1084 
1085         //fee is being taken only from buy/sells
1086         //also avoid fees on liquidation
1087         bool takeFee = false;
1088         if ((to == address(uniswapV2Pair) && !_isExcludedFromFees[from]) || (from == address(uniswapV2Pair) && !_isExcludedFromFees[to])) {
1089             takeFee = true;
1090         }
1091 
1092         if (liquidating) takeFee = false;
1093 
1094         //main fee taking logic
1095         if (takeFee && _feesEnabled) {
1096             //calculate fees and send amount
1097             uint256 rewardPoolAmount = amount.mul(ETH_REWARDS_FEE).div(1000);
1098             uint256 marketingAmount = amount.mul(MARKETING_FEE).div(1000);
1099             uint256 devAmount = amount.mul(DEV_FEE).div(1000);
1100             uint256 priceFee = getPriceImpactFee(amount.sub(rewardPoolAmount).sub(marketingAmount).sub(devAmount));
1101             uint256 impactFeeAmount = amount.mul(priceFee).div(1000);
1102             uint256 sendAmount = amount.sub(rewardPoolAmount).sub(marketingAmount).sub(devAmount);
1103 
1104             //avoid stack problem
1105             sendAmount = sendAmount.sub(impactFeeAmount);
1106             uint256 taxAmount = amount.sub(sendAmount);
1107 
1108             //check if fees and send amount are correct
1109             require(amount == sendAmount.add(taxAmount), "CLT::transfer: Tax value invalid");
1110 
1111             //transfer tax to the contract wallet
1112             super._transfer(from, address(this), taxAmount);
1113 
1114             //remained tokens will be transferred to the recipient
1115             amount = sendAmount;
1116         }
1117 
1118         //block
1119         topUpClaimCycleAfterTransfer(to, amount);
1120 
1121         super._transfer(from, to, amount);
1122     }
1123 
1124     function swapAndDistributeRewards(uint256 tokens) private {
1125         //NOTE: do smth with the correct part management
1126 
1127         // capture the contract's current ETH balance.
1128         // this is so that we can capture exactly the amount of ETH that the
1129         // swap creates, and not make the liquidity event include any ETH that
1130         // has been manually sent to the contract
1131         uint256 initialBalance = address(this).balance;
1132 
1133         if (!liquidating) {
1134             liquidating = true;
1135 
1136             swapTokensForEth(tokens);
1137 
1138             // how much eth should we distribute
1139             uint256 newBalance = address(this).balance.sub(initialBalance);
1140 
1141             //split the contract balance into three parts
1142             uint256 toRewardPool = newBalance.div(3);
1143             uint256 toDevWallet = toRewardPool;
1144             uint256 toMarketingWallet = newBalance.sub(toDevWallet).sub(toRewardPool);
1145 
1146             //reward pool eth stay on the contract
1147             address(marketingWallet).call{value: toMarketingWallet}("");
1148             address(devWallet).call{value: toDevWallet}("");
1149 
1150             liquidating = false;
1151             emit TaxDistributed(tokens, newBalance, toRewardPool, toDevWallet, toMarketingWallet);
1152         }
1153     }
1154 
1155     function swapTokensForEth(uint256 tokenAmount) private {
1156         // generate the uniswap pair path of token -> weth
1157         address[] memory path = new address[](2);
1158         path[0] = address(this);
1159         path[1] = uniswapV2Router.WETH();
1160 
1161         _approve(address(this), address(uniswapV2Router), tokenAmount);
1162 
1163         // make the swap
1164         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1165             tokenAmount,
1166             0, // accept any amount of ETH
1167             path,
1168             address(this),
1169             block.timestamp
1170         );
1171     }
1172 
1173     //to do add to claim cycle after receiving
1174 
1175     function calculateReward(address ofAddress) public view returns (uint256) {
1176         uint256 totalSupply = totalSupply().sub(balanceOf(address(0))).sub(balanceOf(0x000000000000000000000000000000000000dEaD)).sub(balanceOf(address(uniswapV2Pair))); // exclude burned wallets //and uni pair
1177 
1178         uint256 poolValue = address(this).balance;
1179         uint256 currentBalance = balanceOf(address(ofAddress));
1180         uint256 reward = poolValue.mul(currentBalance).div(totalSupply);
1181 
1182         return reward;
1183     }
1184 
1185     function claimReward() public isHuman nonReentrant {
1186         require(nextAvailableClaimDate[msg.sender] <= block.timestamp, "Error: next available not reached");
1187         require(balanceOf(msg.sender) >= 0, "Error: must own token to claim reward");
1188 
1189         uint256 reward = calculateReward(msg.sender);
1190 
1191         // update rewardCycleBlock
1192         nextAvailableClaimDate[msg.sender] = block.timestamp + rewardCycleBlock;
1193         emit ClaimSuccessfully(msg.sender, reward, nextAvailableClaimDate[msg.sender]);
1194 
1195         (bool sent, ) = address(msg.sender).call{value: reward}("");
1196         require(sent, "Error: Cannot withdraw reward");
1197     }
1198 
1199     function topUpClaimCycleAfterTransfer(address recipient, uint256 amount) private {
1200         uint256 currentRecipientBalance = balanceOf(recipient);
1201         uint256 additionalBlock = 0;
1202         if (nextAvailableClaimDate[recipient] + rewardCycleBlock < block.timestamp) nextAvailableClaimDate[recipient] = block.timestamp;
1203 
1204         //if a user has zero balance, just regular rewardCycleBlock will be applied
1205         if (currentRecipientBalance > 0) {
1206             uint256 rate = amount.mul(100).div(currentRecipientBalance);
1207             if (uint256(rate) >= threshHoldTopUpRate) {
1208                 uint256 incurCycleBlock = rewardCycleBlock.mul(uint256(rate)).div(100);
1209                 if (incurCycleBlock >= rewardCycleBlock) {
1210                     incurCycleBlock = rewardCycleBlock;
1211                 }
1212                 additionalBlock = incurCycleBlock;
1213             }
1214         } else {
1215             nextAvailableClaimDate[recipient] = nextAvailableClaimDate[recipient] + rewardCycleBlock;
1216         }
1217         nextAvailableClaimDate[recipient] = nextAvailableClaimDate[recipient] + additionalBlock;
1218     }
1219 }