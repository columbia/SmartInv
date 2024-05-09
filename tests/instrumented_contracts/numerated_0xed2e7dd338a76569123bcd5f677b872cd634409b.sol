1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
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
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor() {
20         _transferOwnership(_msgSender());
21     }
22 
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26 
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31 
32     function renounceOwnership() public virtual onlyOwner {
33         _transferOwnership(address(0));
34     }
35 
36     function transferOwnership(address newOwner) public virtual onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         _transferOwnership(newOwner);
39     }
40 
41     function getTime() public view returns (uint256) {
42         return block.timestamp;
43     }
44 
45     function _transferOwnership(address newOwner) internal virtual {
46         address oldOwner = _owner;
47         _owner = newOwner;
48         emit OwnershipTransferred(oldOwner, newOwner);
49     }
50 }
51 
52 abstract contract Initializable {
53     /**
54      * @dev Indicates that the contract has been initialized.
55      */
56     bool private _initialized;
57 
58     /**
59      * @dev Indicates that the contract is in the process of being initialized.
60      */
61     bool private _initializing;
62 
63     /**
64      * @dev Modifier to protect an initializer function from being invoked twice.
65      */
66     modifier initializer() {
67         require(_initializing || !_initialized, "Initializable: contract is already initialized");
68 
69         bool isTopLevelCall = !_initializing;
70         if (isTopLevelCall) {
71             _initializing = true;
72             _initialized = true;
73         }
74 
75         _;
76 
77         if (isTopLevelCall) {
78             _initializing = false;
79         }
80     }
81 }
82 
83 abstract contract ContextUpgradeable is Initializable {
84     function __Context_init() internal initializer {
85         __Context_init_unchained();
86     }
87 
88     function __Context_init_unchained() internal initializer {
89     }
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97     uint256[50] private __gap;
98 }
99 
100 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
101     address private _owner;
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     function __Ownable_init() internal initializer {
109         __Context_init_unchained();
110         __Ownable_init_unchained();
111     }
112 
113     function __Ownable_init_unchained() internal initializer {
114         _setOwner(_msgSender());
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
140         _setOwner(address(0));
141     }
142 
143     /**
144      * @dev Transfers ownership of the contract to a new account (`newOwner`).
145      * Can only be called by the current owner.
146      */
147     function transferOwnership(address newOwner) public virtual onlyOwner {
148         require(newOwner != address(0), "Ownable: new owner is the zero address");
149         _setOwner(newOwner);
150     }
151 
152     function _setOwner(address newOwner) private {
153         address oldOwner = _owner;
154         _owner = newOwner;
155         emit OwnershipTransferred(oldOwner, newOwner);
156     }
157     uint256[49] private __gap;
158 }
159 
160 
161 interface IERC20 {
162     function totalSupply() external view returns (uint256);
163 
164     function balanceOf(address account) external view returns (uint256);
165 
166     function transfer(address recipient, uint256 amount) external returns (bool);
167 
168     function allowance(address owner, address spender) external view returns (uint256);
169 
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177 
178     event Transfer(address indexed from, address indexed to, uint256 value);
179 
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 interface IERC20Metadata is IERC20 {
184 
185     function name() external view returns (string memory);
186 
187     function symbol() external view returns (string memory);
188 
189     function decimals() external view returns (uint8);
190 }
191 
192 library SafeMath {
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         return sub(a, b, "SafeMath: subtraction overflow");
202     }
203 
204     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b <= a, errorMessage);
206         uint256 c = a - b;
207 
208         return c;
209     }
210 
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
213         // benefit is lost if 'b' is also tested.
214         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
215         if (a == 0) {
216             return 0;
217         }
218 
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221 
222         return c;
223     }
224 
225     function div(uint256 a, uint256 b) internal pure returns (uint256) {
226         return div(a, b, "SafeMath: division by zero");
227     }
228 
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b != 0, errorMessage);
243         return a % b;
244     }
245 }
246 
247 library SafeMathInt {
248     int256 private constant MIN_INT256 = int256(1) << 255;
249     int256 private constant MAX_INT256 = ~(int256(1) << 255);
250 
251     /**
252      * @dev Multiplies two int256 variables and fails on overflow.
253      */
254     function mul(int256 a, int256 b) internal pure returns (int256) {
255         int256 c = a * b;
256 
257         // Detect overflow when multiplying MIN_INT256 with -1
258         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
259         require((b == 0) || (c / b == a));
260         return c;
261     }
262 
263     /**
264      * @dev Division of two int256 variables and fails on overflow.
265      */
266     function div(int256 a, int256 b) internal pure returns (int256) {
267         // Prevent overflow when dividing MIN_INT256 by -1
268         require(b != -1 || a != MIN_INT256);
269 
270         // Solidity already throws when dividing by 0.
271         return a / b;
272     }
273 
274     /**
275      * @dev Subtracts two int256 variables and fails on overflow.
276      */
277     function sub(int256 a, int256 b) internal pure returns (int256) {
278         int256 c = a - b;
279         require((b >= 0 && c <= a) || (b < 0 && c > a));
280         return c;
281     }
282 
283     /**
284      * @dev Adds two int256 variables and fails on overflow.
285      */
286     function add(int256 a, int256 b) internal pure returns (int256) {
287         int256 c = a + b;
288         require((b >= 0 && c >= a) || (b < 0 && c < a));
289         return c;
290     }
291 
292     /**
293      * @dev Converts to absolute value, and fails on overflow.
294      */
295     function abs(int256 a) internal pure returns (int256) {
296         require(a != MIN_INT256);
297         return a < 0 ? -a : a;
298     }
299 
300 
301     function toUint256Safe(int256 a) internal pure returns (uint256) {
302         require(a >= 0);
303         return uint256(a);
304     }
305 }
306 
307 library SafeMathUint {
308   function toInt256Safe(uint256 a) internal pure returns (int256) {
309     int256 b = int256(a);
310     require(b >= 0);
311     return b;
312   }
313 }
314 
315 library Clones {
316     /**
317      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
318      *
319      * This function uses the create opcode, which should never revert.
320      */
321     function clone(address implementation) internal returns (address instance) {
322         assembly {
323             let ptr := mload(0x40)
324             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
325             mstore(add(ptr, 0x14), shl(0x60, implementation))
326             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
327             instance := create(0, ptr, 0x37)
328         }
329         require(instance != address(0), "ERC1167: create failed");
330     }
331 
332     /**
333      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
334      *
335      * This function uses the create2 opcode and a `salt` to deterministically deploy
336      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
337      * the clones cannot be deployed twice at the same address.
338      */
339     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
340         assembly {
341             let ptr := mload(0x40)
342             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
343             mstore(add(ptr, 0x14), shl(0x60, implementation))
344             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
345             instance := create2(0, ptr, 0x37, salt)
346         }
347         require(instance != address(0), "ERC1167: create2 failed");
348     }
349 
350     /**
351      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
352      */
353     function predictDeterministicAddress(
354         address implementation,
355         bytes32 salt,
356         address deployer
357     ) internal pure returns (address predicted) {
358         assembly {
359             let ptr := mload(0x40)
360             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
361             mstore(add(ptr, 0x14), shl(0x60, implementation))
362             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
363             mstore(add(ptr, 0x38), shl(0x60, deployer))
364             mstore(add(ptr, 0x4c), salt)
365             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
366             predicted := keccak256(add(ptr, 0x37), 0x55)
367         }
368     }
369 
370     /**
371      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
372      */
373     function predictDeterministicAddress(address implementation, bytes32 salt)
374         internal
375         view
376         returns (address predicted)
377     {
378         return predictDeterministicAddress(implementation, salt, address(this));
379     }
380 }
381 
382 contract ERC20 is Context, IERC20, IERC20Metadata {
383     using SafeMath for uint256;
384 
385     mapping(address => uint256) private _balances;
386 
387     mapping(address => mapping(address => uint256)) private _allowances;
388 
389     uint256 private _totalSupply;
390 
391     string private _name;
392     string private _symbol;
393 
394     /**
395      * @dev Sets the values for {name} and {symbol}.
396      *
397      * The default value of {decimals} is 18. To select a different value for
398      * {decimals} you should overload it.
399      *
400      * All two of these values are immutable: they can only be set once during
401      * construction.
402      */
403     constructor(string memory name_, string memory symbol_) {
404         _name = name_;
405         _symbol = symbol_;
406     }
407 
408     /**
409      * @dev Returns the name of the token.
410      */
411     function name() public view virtual override returns (string memory) {
412         return _name;
413     }
414 
415     /**
416      * @dev Returns the symbol of the token, usually a shorter version of the
417      * name.
418      */
419     function symbol() public view virtual override returns (string memory) {
420         return _symbol;
421     }
422 
423     /**
424      * @dev Returns the number of decimals used to get its user representation.
425      * For example, if `decimals` equals `2`, a balance of `505` tokens should
426      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
427      *
428      * Tokens usually opt for a value of 18, imitating the relationship between
429      * Ether and Wei. This is the value {ERC20} uses, unless this function is
430      * overridden;
431      *
432      * NOTE: This information is only used for _display_ purposes: it in
433      * no way affects any of the arithmetic of the contract, including
434      * {IERC20-balanceOf} and {IERC20-transfer}.
435      */
436     function decimals() public view virtual override returns (uint8) {
437         return 18;
438     }
439 
440     /**
441      * @dev See {IERC20-totalSupply}.
442      */
443     function totalSupply() public view virtual override returns (uint256) {
444         return _totalSupply;
445     }
446 
447     /**
448      * @dev See {IERC20-balanceOf}.
449      */
450     function balanceOf(address account) public view virtual override returns (uint256) {
451         return _balances[account];
452     }
453 
454     /**
455      * @dev See {IERC20-transfer}.
456      *
457      * Requirements:
458      *
459      * - `recipient` cannot be the zero address.
460      * - the caller must have a balance of at least `amount`.
461      */
462     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
463         _transfer(_msgSender(), recipient, amount);
464         return true;
465     }
466 
467     /**
468      * @dev See {IERC20-allowance}.
469      */
470     function allowance(address owner, address spender) public view virtual override returns (uint256) {
471         return _allowances[owner][spender];
472     }
473 
474     /**
475      * @dev See {IERC20-approve}.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      */
481     function approve(address spender, uint256 amount) public virtual override returns (bool) {
482         _approve(_msgSender(), spender, amount);
483         return true;
484     }
485 
486     /**
487      * @dev See {IERC20-transferFrom}.
488      *
489      * Emits an {Approval} event indicating the updated allowance. This is not
490      * required by the EIP. See the note at the beginning of {ERC20}.
491      *
492      * Requirements:
493      *
494      * - `sender` and `recipient` cannot be the zero address.
495      * - `sender` must have a balance of at least `amount`.
496      * - the caller must have allowance for ``sender``'s tokens of at least
497      * `amount`.
498      */
499     function transferFrom(
500         address sender,
501         address recipient,
502         uint256 amount
503     ) public virtual override returns (bool) {
504         _transfer(sender, recipient, amount);
505         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
506         return true;
507     }
508 
509     /**
510      * @dev Atomically increases the allowance granted to `spender` by the caller.
511      *
512      * This is an alternative to {approve} that can be used as a mitigation for
513      * problems described in {IERC20-approve}.
514      *
515      * Emits an {Approval} event indicating the updated allowance.
516      *
517      * Requirements:
518      *
519      * - `spender` cannot be the zero address.
520      */
521     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
522         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
523         return true;
524     }
525 
526     /**
527      * @dev Atomically decreases the allowance granted to `spender` by the caller.
528      *
529      * This is an alternative to {approve} that can be used as a mitigation for
530      * problems described in {IERC20-approve}.
531      *
532      * Emits an {Approval} event indicating the updated allowance.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      * - `spender` must have allowance for the caller of at least
538      * `subtractedValue`.
539      */
540     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
541         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
542         return true;
543     }
544 
545     /**
546      * @dev Moves tokens `amount` from `sender` to `recipient`.
547      *
548      * This is internal function is equivalent to {transfer}, and can be used to
549      * e.g. implement automatic token fees, slashing mechanisms, etc.
550      *
551      * Emits a {Transfer} event.
552      *
553      * Requirements:
554      *
555      * - `sender` cannot be the zero address.
556      * - `recipient` cannot be the zero address.
557      * - `sender` must have a balance of at least `amount`.
558      */
559     function _transfer(
560         address sender,
561         address recipient,
562         uint256 amount
563     ) internal virtual {
564         require(sender != address(0), "ERC20: transfer from the zero address");
565         require(recipient != address(0), "ERC20: transfer to the zero address");
566 
567         _beforeTokenTransfer(sender, recipient, amount);
568 
569         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
570         _balances[recipient] = _balances[recipient].add(amount);
571         emit Transfer(sender, recipient, amount);
572     }
573 
574     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
575      * the total supply.
576      *
577      * Emits a {Transfer} event with `from` set to the zero address.
578      *
579      * Requirements:
580      *
581      * - `account` cannot be the zero address.
582      */
583     function _mint(address account, uint256 amount) internal virtual {
584         require(account != address(0), "ERC20: mint to the zero address");
585 
586         _beforeTokenTransfer(address(0), account, amount);
587 
588         _totalSupply = _totalSupply.add(amount);
589         _balances[account] = _balances[account].add(amount);
590         emit Transfer(address(0), account, amount);
591     }
592 
593     /**
594      * @dev Destroys `amount` tokens from `account`, reducing the
595      * total supply.
596      *
597      * Emits a {Transfer} event with `to` set to the zero address.
598      *
599      * Requirements:
600      *
601      * - `account` cannot be the zero address.
602      * - `account` must have at least `amount` tokens.
603      */
604     function _burn(address account, uint256 amount) internal virtual {
605         require(account != address(0), "ERC20: burn from the zero address");
606 
607         _beforeTokenTransfer(account, address(0), amount);
608 
609         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
610         _totalSupply = _totalSupply.sub(amount);
611         emit Transfer(account, address(0), amount);
612     }
613 
614     /**
615      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
616      *
617      * This internal function is equivalent to `approve`, and can be used to
618      * e.g. set automatic allowances for certain subsystems, etc.
619      *
620      * Emits an {Approval} event.
621      *
622      * Requirements:
623      *
624      * - `owner` cannot be the zero address.
625      * - `spender` cannot be the zero address.
626      */
627     function _approve(
628         address owner,
629         address spender,
630         uint256 amount
631     ) internal virtual {
632         require(owner != address(0), "ERC20: approve from the zero address");
633         require(spender != address(0), "ERC20: approve to the zero address");
634 
635         _allowances[owner][spender] = amount;
636         emit Approval(owner, spender, amount);
637     }
638 
639     /**
640      * @dev Hook that is called before any transfer of tokens. This includes
641      * minting and burning.
642      *
643      * Calling conditions:
644      *
645      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
646      * will be to transferred to `to`.
647      * - when `from` is zero, `amount` tokens will be minted for `to`.
648      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
649      * - `from` and `to` are never both zero.
650      *
651      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
652      */
653     function _beforeTokenTransfer(
654         address from,
655         address to,
656         uint256 amount
657     ) internal virtual {}
658 }
659 
660 interface IUniswapV2Router01 {
661     function factory() external pure returns (address);
662     function WETH() external pure returns (address);
663 
664     function addLiquidity(
665         address tokenA,
666         address tokenB,
667         uint amountADesired,
668         uint amountBDesired,
669         uint amountAMin,
670         uint amountBMin,
671         address to,
672         uint deadline
673     ) external returns (uint amountA, uint amountB, uint liquidity);
674     function addLiquidityETH(
675         address token,
676         uint amountTokenDesired,
677         uint amountTokenMin,
678         uint amountETHMin,
679         address to,
680         uint deadline
681     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
682     function removeLiquidity(
683         address tokenA,
684         address tokenB,
685         uint liquidity,
686         uint amountAMin,
687         uint amountBMin,
688         address to,
689         uint deadline
690     ) external returns (uint amountA, uint amountB);
691     function removeLiquidityETH(
692         address token,
693         uint liquidity,
694         uint amountTokenMin,
695         uint amountETHMin,
696         address to,
697         uint deadline
698     ) external returns (uint amountToken, uint amountETH);
699     function removeLiquidityWithPermit(
700         address tokenA,
701         address tokenB,
702         uint liquidity,
703         uint amountAMin,
704         uint amountBMin,
705         address to,
706         uint deadline,
707         bool approveMax, uint8 v, bytes32 r, bytes32 s
708     ) external returns (uint amountA, uint amountB);
709     function removeLiquidityETHWithPermit(
710         address token,
711         uint liquidity,
712         uint amountTokenMin,
713         uint amountETHMin,
714         address to,
715         uint deadline,
716         bool approveMax, uint8 v, bytes32 r, bytes32 s
717     ) external returns (uint amountToken, uint amountETH);
718     function swapExactTokensForTokens(
719         uint amountIn,
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external returns (uint[] memory amounts);
725     function swapTokensForExactTokens(
726         uint amountOut,
727         uint amountInMax,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external returns (uint[] memory amounts);
732     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
733         external
734         payable
735         returns (uint[] memory amounts);
736     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
737         external
738         returns (uint[] memory amounts);
739     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
740         external
741         returns (uint[] memory amounts);
742     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
743         external
744         payable
745         returns (uint[] memory amounts);
746 
747     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
748     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
749     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
750     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
751     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
752 }
753 
754 interface IUniswapV2Router02 is IUniswapV2Router01 {
755     function removeLiquidityETHSupportingFeeOnTransferTokens(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountETH);
763     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
764         address token,
765         uint liquidity,
766         uint amountTokenMin,
767         uint amountETHMin,
768         address to,
769         uint deadline,
770         bool approveMax, uint8 v, bytes32 r, bytes32 s
771     ) external returns (uint amountETH);
772 
773     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
774         uint amountIn,
775         uint amountOutMin,
776         address[] calldata path,
777         address to,
778         uint deadline
779     ) external;
780     function swapExactETHForTokensSupportingFeeOnTransferTokens(
781         uint amountOutMin,
782         address[] calldata path,
783         address to,
784         uint deadline
785     ) external payable;
786     function swapExactTokensForETHSupportingFeeOnTransferTokens(
787         uint amountIn,
788         uint amountOutMin,
789         address[] calldata path,
790         address to,
791         uint deadline
792     ) external;
793 }
794 
795 interface IUniswapV2Factory {
796     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
797 
798     function feeTo() external view returns (address);
799     function feeToSetter() external view returns (address);
800 
801     function getPair(address tokenA, address tokenB) external view returns (address pair);
802     function allPairs(uint) external view returns (address pair);
803     function allPairsLength() external view returns (uint);
804 
805     function createPair(address tokenA, address tokenB) external returns (address pair);
806 
807     function setFeeTo(address) external;
808     function setFeeToSetter(address) external;
809 }
810 
811 interface IUniswapV2Pair {
812     event Approval(address indexed owner, address indexed spender, uint value);
813     event Transfer(address indexed from, address indexed to, uint value);
814 
815     function name() external pure returns (string memory);
816     function symbol() external pure returns (string memory);
817     function decimals() external pure returns (uint8);
818     function totalSupply() external view returns (uint);
819     function balanceOf(address owner) external view returns (uint);
820     function allowance(address owner, address spender) external view returns (uint);
821 
822     function approve(address spender, uint value) external returns (bool);
823     function transfer(address to, uint value) external returns (bool);
824     function transferFrom(address from, address to, uint value) external returns (bool);
825 
826     function DOMAIN_SEPARATOR() external view returns (bytes32);
827     function PERMIT_TYPEHASH() external pure returns (bytes32);
828     function nonces(address owner) external view returns (uint);
829 
830     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
831 
832     event Mint(address indexed sender, uint amount0, uint amount1);
833     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
834     event Swap(
835         address indexed sender,
836         uint amount0In,
837         uint amount1In,
838         uint amount0Out,
839         uint amount1Out,
840         address indexed to
841     );
842     event Sync(uint112 reserve0, uint112 reserve1);
843 
844     function MINIMUM_LIQUIDITY() external pure returns (uint);
845     function factory() external view returns (address);
846     function token0() external view returns (address);
847     function token1() external view returns (address);
848     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
849     function price0CumulativeLast() external view returns (uint);
850     function price1CumulativeLast() external view returns (uint);
851     function kLast() external view returns (uint);
852 
853     function mint(address to) external returns (uint liquidity);
854     function burn(address to) external returns (uint amount0, uint amount1);
855     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
856     function skim(address to) external;
857     function sync() external;
858 
859     function initialize(address, address) external;
860 }
861 
862 
863 library IterableMapping {
864     // Iterable mapping from address to uint;
865     struct Map {
866         address[] keys;
867         mapping(address => uint256) values;
868         mapping(address => uint256) indexOf;
869         mapping(address => bool) inserted;
870     }
871 
872     function get(Map storage map, address key) public view returns (uint256) {
873         return map.values[key];
874     }
875 
876     function getIndexOfKey(Map storage map, address key)
877     public
878     view
879     returns (int256)
880     {
881         if (!map.inserted[key]) {
882             return -1;
883         }
884         return int256(map.indexOf[key]);
885     }
886 
887     function getKeyAtIndex(Map storage map, uint256 index)
888     public
889     view
890     returns (address)
891     {
892         return map.keys[index];
893     }
894 
895     function size(Map storage map) public view returns (uint256) {
896         return map.keys.length;
897     }
898 
899     function set(
900         Map storage map,
901         address key,
902         uint256 val
903     ) public {
904         if (map.inserted[key]) {
905             map.values[key] = val;
906         } else {
907             map.inserted[key] = true;
908             map.values[key] = val;
909             map.indexOf[key] = map.keys.length;
910             map.keys.push(key);
911         }
912     }
913 
914     function remove(Map storage map, address key) public {
915         if (!map.inserted[key]) {
916             return;
917         }
918 
919         delete map.inserted[key];
920         delete map.values[key];
921 
922         uint256 index = map.indexOf[key];
923         uint256 lastIndex = map.keys.length - 1;
924         address lastKey = map.keys[lastIndex];
925 
926         map.indexOf[lastKey] = index;
927         delete map.indexOf[key];
928 
929         map.keys[index] = lastKey;
930         map.keys.pop();
931     }
932 }
933 
934 /// @title Dividend-Paying Token Interface
935 /// @author Roger Wu (https://github.com/roger-wu)
936 /// @dev An interface for a dividend-paying token contract.
937 
938 interface DividendPayingTokenInterface {
939     /// @notice View the amount of dividend in wei that an address can withdraw.
940     /// @param _owner The address of a token holder.
941     /// @return The amount of dividend in wei that `_owner` can withdraw.
942     function dividendOf(address _owner) external view returns (uint256);
943 
944     /// @notice Withdraws the ether distributed to the sender.
945     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
946     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
947     function withdrawDividend() external;
948 
949     /// @dev This event MUST emit when ether is distributed to token holders.
950     /// @param from The address which sends ether to this contract.
951     /// @param weiAmount The amount of distributed ether in wei.
952     event DividendsDistributed(address indexed from, uint256 weiAmount);
953 
954     /// @dev This event MUST emit when an address withdraws their dividend.
955     /// @param to The address which withdraws ether from this contract.
956     /// @param weiAmount The amount of withdrawn ether in wei.
957     event DividendWithdrawn(address indexed to, uint256 weiAmount);
958 }
959 
960 /// @title Dividend-Paying Token Optional Interface
961 /// @author Roger Wu (https://github.com/roger-wu)
962 /// @dev OPTIONAL functions for a dividend-paying token contract.
963 interface DividendPayingTokenOptionalInterface {
964     /// @notice View the amount of dividend in wei that an address can withdraw.
965     /// @param _owner The address of a token holder.
966     /// @return The amount of dividend in wei that `_owner` can withdraw.
967     function withdrawableDividendOf(address _owner)
968     external
969     view
970     returns (uint256);
971 
972     /// @notice View the amount of dividend in wei that an address has withdrawn.
973     /// @param _owner The address of a token holder.
974     /// @return The amount of dividend in wei that `_owner` has withdrawn.
975     function withdrawnDividendOf(address _owner)
976     external
977     view
978     returns (uint256);
979 
980     /// @notice View the amount of dividend in wei that an address has earned in total.
981     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
982     /// @param _owner The address of a token holder.
983     /// @return The amount of dividend in wei that `_owner` has earned in total.
984     function accumulativeDividendOf(address _owner)
985     external
986     view
987     returns (uint256);
988 }
989 
990 interface IERC20Upgradeable {
991     /**
992      * @dev Returns the amount of tokens in existence.
993      */
994     function totalSupply() external view returns (uint256);
995 
996     /**
997      * @dev Returns the amount of tokens owned by `account`.
998      */
999     function balanceOf(address account) external view returns (uint256);
1000 
1001     /**
1002      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1003      *
1004      * Returns a boolean value indicating whether the operation succeeded.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function transfer(address recipient, uint256 amount) external returns (bool);
1009 
1010     /**
1011      * @dev Returns the remaining number of tokens that `spender` will be
1012      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1013      * zero by default.
1014      *
1015      * This value changes when {approve} or {transferFrom} are called.
1016      */
1017     function allowance(address owner, address spender) external view returns (uint256);
1018 
1019     /**
1020      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1021      *
1022      * Returns a boolean value indicating whether the operation succeeded.
1023      *
1024      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1025      * that someone may use both the old and the new allowance by unfortunate
1026      * transaction ordering. One possible solution to mitigate this race
1027      * condition is to first reduce the spender's allowance to 0 and set the
1028      * desired value afterwards:
1029      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1030      *
1031      * Emits an {Approval} event.
1032      */
1033     function approve(address spender, uint256 amount) external returns (bool);
1034 
1035     /**
1036      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1037      * allowance mechanism. `amount` is then deducted from the caller's
1038      * allowance.
1039      *
1040      * Returns a boolean value indicating whether the operation succeeded.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function transferFrom(
1045         address sender,
1046         address recipient,
1047         uint256 amount
1048     ) external returns (bool);
1049 
1050     /**
1051      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1052      * another (`to`).
1053      *
1054      * Note that `value` may be zero.
1055      */
1056     event Transfer(address indexed from, address indexed to, uint256 value);
1057 
1058     /**
1059      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1060      * a call to {approve}. `value` is the new allowance.
1061      */
1062     event Approval(address indexed owner, address indexed spender, uint256 value);
1063 }
1064 
1065 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
1066     /**
1067      * @dev Returns the name of the token.
1068      */
1069     function name() external view returns (string memory);
1070 
1071     /**
1072      * @dev Returns the symbol of the token.
1073      */
1074     function symbol() external view returns (string memory);
1075 
1076     /**
1077      * @dev Returns the decimals places of the token.
1078      */
1079     function decimals() external view returns (uint8);
1080 }
1081 
1082 
1083 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
1084     mapping(address => uint256) private _balances;
1085 
1086     mapping(address => mapping(address => uint256)) private _allowances;
1087 
1088     uint256 private _totalSupply;
1089 
1090     string private _name;
1091     string private _symbol;
1092 
1093     /**
1094      * @dev Sets the values for {name} and {symbol}.
1095      *
1096      * The default value of {decimals} is 18. To select a different value for
1097      * {decimals} you should overload it.
1098      *
1099      * All two of these values are immutable: they can only be set once during
1100      * construction.
1101      */
1102     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
1103         __Context_init_unchained();
1104         __ERC20_init_unchained(name_, symbol_);
1105     }
1106 
1107     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
1108         _name = name_;
1109         _symbol = symbol_;
1110     }
1111 
1112     /**
1113      * @dev Returns the name of the token.
1114      */
1115     function name() public view virtual override returns (string memory) {
1116         return _name;
1117     }
1118 
1119     /**
1120      * @dev Returns the symbol of the token, usually a shorter version of the
1121      * name.
1122      */
1123     function symbol() public view virtual override returns (string memory) {
1124         return _symbol;
1125     }
1126 
1127     /**
1128      * @dev Returns the number of decimals used to get its user representation.
1129      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1130      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1131      *
1132      * Tokens usually opt for a value of 18, imitating the relationship between
1133      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1134      * overridden;
1135      *
1136      * NOTE: This information is only used for _display_ purposes: it in
1137      * no way affects any of the arithmetic of the contract, including
1138      * {IERC20-balanceOf} and {IERC20-transfer}.
1139      */
1140     function decimals() public view virtual override returns (uint8) {
1141         return 18;
1142     }
1143 
1144     /**
1145      * @dev See {IERC20-totalSupply}.
1146      */
1147     function totalSupply() public view virtual override returns (uint256) {
1148         return _totalSupply;
1149     }
1150 
1151     /**
1152      * @dev See {IERC20-balanceOf}.
1153      */
1154     function balanceOf(address account) public view virtual override returns (uint256) {
1155         return _balances[account];
1156     }
1157 
1158     /**
1159      * @dev See {IERC20-transfer}.
1160      *
1161      * Requirements:
1162      *
1163      * - `recipient` cannot be the zero address.
1164      * - the caller must have a balance of at least `amount`.
1165      */
1166     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1167         _transfer(_msgSender(), recipient, amount);
1168         return true;
1169     }
1170 
1171     /**
1172      * @dev See {IERC20-allowance}.
1173      */
1174     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1175         return _allowances[owner][spender];
1176     }
1177 
1178     /**
1179      * @dev See {IERC20-approve}.
1180      *
1181      * Requirements:
1182      *
1183      * - `spender` cannot be the zero address.
1184      */
1185     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1186         _approve(_msgSender(), spender, amount);
1187         return true;
1188     }
1189 
1190     /**
1191      * @dev See {IERC20-transferFrom}.
1192      *
1193      * Emits an {Approval} event indicating the updated allowance. This is not
1194      * required by the EIP. See the note at the beginning of {ERC20}.
1195      *
1196      * Requirements:
1197      *
1198      * - `sender` and `recipient` cannot be the zero address.
1199      * - `sender` must have a balance of at least `amount`.
1200      * - the caller must have allowance for ``sender``'s tokens of at least
1201      * `amount`.
1202      */
1203     function transferFrom(
1204         address sender,
1205         address recipient,
1206         uint256 amount
1207     ) public virtual override returns (bool) {
1208         _transfer(sender, recipient, amount);
1209 
1210         uint256 currentAllowance = _allowances[sender][_msgSender()];
1211         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1212         unchecked {
1213     _approve(sender, _msgSender(), currentAllowance - amount);
1214     }
1215 
1216         return true;
1217     }
1218 
1219     /**
1220      * @dev Atomically increases the allowance granted to `spender` by the caller.
1221      *
1222      * This is an alternative to {approve} that can be used as a mitigation for
1223      * problems described in {IERC20-approve}.
1224      *
1225      * Emits an {Approval} event indicating the updated allowance.
1226      *
1227      * Requirements:
1228      *
1229      * - `spender` cannot be the zero address.
1230      */
1231     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1232         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1233         return true;
1234     }
1235 
1236     /**
1237      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1238      *
1239      * This is an alternative to {approve} that can be used as a mitigation for
1240      * problems described in {IERC20-approve}.
1241      *
1242      * Emits an {Approval} event indicating the updated allowance.
1243      *
1244      * Requirements:
1245      *
1246      * - `spender` cannot be the zero address.
1247      * - `spender` must have allowance for the caller of at least
1248      * `subtractedValue`.
1249      */
1250     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1251         uint256 currentAllowance = _allowances[_msgSender()][spender];
1252         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1253         unchecked {
1254     _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1255     }
1256 
1257         return true;
1258     }
1259 
1260     /**
1261      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1262      *
1263      * This internal function is equivalent to {transfer}, and can be used to
1264      * e.g. implement automatic token fees, slashing mechanisms, etc.
1265      *
1266      * Emits a {Transfer} event.
1267      *
1268      * Requirements:
1269      *
1270      * - `sender` cannot be the zero address.
1271      * - `recipient` cannot be the zero address.
1272      * - `sender` must have a balance of at least `amount`.
1273      */
1274     function _transfer(
1275         address sender,
1276         address recipient,
1277         uint256 amount
1278     ) internal virtual {
1279         require(sender != address(0), "ERC20: transfer from the zero address");
1280         require(recipient != address(0), "ERC20: transfer to the zero address");
1281 
1282         _beforeTokenTransfer(sender, recipient, amount);
1283 
1284         uint256 senderBalance = _balances[sender];
1285         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1286         unchecked {
1287     _balances[sender] = senderBalance - amount;
1288     }
1289         _balances[recipient] += amount;
1290 
1291         emit Transfer(sender, recipient, amount);
1292 
1293         _afterTokenTransfer(sender, recipient, amount);
1294     }
1295 
1296     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1297      * the total supply.
1298      *
1299      * Emits a {Transfer} event with `from` set to the zero address.
1300      *
1301      * Requirements:
1302      *
1303      * - `account` cannot be the zero address.
1304      */
1305     function _mint(address account, uint256 amount) internal virtual {
1306         require(account != address(0), "ERC20: mint to the zero address");
1307 
1308         _beforeTokenTransfer(address(0), account, amount);
1309 
1310         _totalSupply += amount;
1311         _balances[account] += amount;
1312         emit Transfer(address(0), account, amount);
1313 
1314         _afterTokenTransfer(address(0), account, amount);
1315     }
1316 
1317     /**
1318      * @dev Destroys `amount` tokens from `account`, reducing the
1319      * total supply.
1320      *
1321      * Emits a {Transfer} event with `to` set to the zero address.
1322      *
1323      * Requirements:
1324      *
1325      * - `account` cannot be the zero address.
1326      * - `account` must have at least `amount` tokens.
1327      */
1328     function _burn(address account, uint256 amount) internal virtual {
1329         require(account != address(0), "ERC20: burn from the zero address");
1330 
1331         _beforeTokenTransfer(account, address(0), amount);
1332 
1333         uint256 accountBalance = _balances[account];
1334         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1335         unchecked {
1336     _balances[account] = accountBalance - amount;
1337     }
1338         _totalSupply -= amount;
1339 
1340         emit Transfer(account, address(0), amount);
1341 
1342         _afterTokenTransfer(account, address(0), amount);
1343     }
1344 
1345     /**
1346      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1347      *
1348      * This internal function is equivalent to `approve`, and can be used to
1349      * e.g. set automatic allowances for certain subsystems, etc.
1350      *
1351      * Emits an {Approval} event.
1352      *
1353      * Requirements:
1354      *
1355      * - `owner` cannot be the zero address.
1356      * - `spender` cannot be the zero address.
1357      */
1358     function _approve(
1359         address owner,
1360         address spender,
1361         uint256 amount
1362     ) internal virtual {
1363         require(owner != address(0), "ERC20: approve from the zero address");
1364         require(spender != address(0), "ERC20: approve to the zero address");
1365 
1366         _allowances[owner][spender] = amount;
1367         emit Approval(owner, spender, amount);
1368     }
1369 
1370     /**
1371      * @dev Hook that is called before any transfer of tokens. This includes
1372      * minting and burning.
1373      *
1374      * Calling conditions:
1375      *
1376      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1377      * will be transferred to `to`.
1378      * - when `from` is zero, `amount` tokens will be minted for `to`.
1379      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1380      * - `from` and `to` are never both zero.
1381      *
1382      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1383      */
1384     function _beforeTokenTransfer(
1385         address from,
1386         address to,
1387         uint256 amount
1388     ) internal virtual {}
1389 
1390     /**
1391      * @dev Hook that is called after any transfer of tokens. This includes
1392      * minting and burning.
1393      *
1394      * Calling conditions:
1395      *
1396      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1397      * has been transferred to `to`.
1398      * - when `from` is zero, `amount` tokens have been minted for `to`.
1399      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1400      * - `from` and `to` are never both zero.
1401      *
1402      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1403      */
1404     function _afterTokenTransfer(
1405         address from,
1406         address to,
1407         uint256 amount
1408     ) internal virtual {}
1409     uint256[45] private __gap;
1410 }
1411 
1412 
1413 /// @title Dividend-Paying Token
1414 /// @author Roger Wu (https://github.com/roger-wu)
1415 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1416 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1417 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1418 contract DividendPayingToken is
1419 ERC20Upgradeable,
1420 OwnableUpgradeable,
1421 DividendPayingTokenInterface,
1422 DividendPayingTokenOptionalInterface
1423 {
1424     using SafeMath for uint256;
1425     using SafeMathUint for uint256;
1426     using SafeMathInt for int256;
1427 
1428     address public rewardToken;
1429 
1430     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1431     // For more discussion about choosing the value of `magnitude`,
1432     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1433     uint256 internal constant magnitude = 2**128;
1434 
1435     uint256 internal magnifiedDividendPerShare;
1436 
1437     // About dividendCorrection:
1438     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1439     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1440     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1441     //   `dividendOf(_user)` should not be changed,
1442     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1443     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1444     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1445     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1446     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1447     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1448     mapping(address => int256) internal magnifiedDividendCorrections;
1449     mapping(address => uint256) internal withdrawnDividends;
1450 
1451     uint256 public totalDividendsDistributed;
1452 
1453     function __DividendPayingToken_init(
1454         address _rewardToken,
1455         string memory _name,
1456         string memory _symbol
1457     ) internal initializer {
1458         __Ownable_init();
1459         __ERC20_init(_name, _symbol);
1460         rewardToken = _rewardToken;
1461     }
1462 
1463     function distributeCAKEDividends(uint256 amount) public onlyOwner {
1464         require(totalSupply() > 0);
1465 
1466         if (amount > 0) {
1467             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1468                 (amount).mul(magnitude) / totalSupply()
1469             );
1470             emit DividendsDistributed(msg.sender, amount);
1471 
1472             totalDividendsDistributed = totalDividendsDistributed.add(amount);
1473         }
1474     }
1475 
1476     /// @notice Withdraws the ether distributed to the sender.
1477     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1478     function withdrawDividend() public virtual override {
1479         _withdrawDividendOfUser(payable(msg.sender));
1480     }
1481 
1482     /// @notice Withdraws the ether distributed to the sender.
1483     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1484     function _withdrawDividendOfUser(address payable user)
1485     internal
1486     returns (uint256)
1487     {
1488         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1489         if (_withdrawableDividend > 0) {
1490             withdrawnDividends[user] = withdrawnDividends[user].add(
1491                 _withdrawableDividend
1492             );
1493             emit DividendWithdrawn(user, _withdrawableDividend);
1494             bool success = IERC20(rewardToken).transfer(
1495                 user,
1496                 _withdrawableDividend
1497             );
1498 
1499             if (!success) {
1500                 withdrawnDividends[user] = withdrawnDividends[user].sub(
1501                     _withdrawableDividend
1502                 );
1503                 return 0;
1504             }
1505 
1506             return _withdrawableDividend;
1507         }
1508 
1509         return 0;
1510     }
1511 
1512     /// @notice View the amount of dividend in wei that an address can withdraw.
1513     /// @param _owner The address of a token holder.
1514     /// @return The amount of dividend in wei that `_owner` can withdraw.
1515     function dividendOf(address _owner) public view override returns (uint256) {
1516         return withdrawableDividendOf(_owner);
1517     }
1518 
1519     /// @notice View the amount of dividend in wei that an address can withdraw.
1520     /// @param _owner The address of a token holder.
1521     /// @return The amount of dividend in wei that `_owner` can withdraw.
1522     function withdrawableDividendOf(address _owner)
1523     public
1524     view
1525     override
1526     returns (uint256)
1527     {
1528         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1529     }
1530 
1531     /// @notice View the amount of dividend in wei that an address has withdrawn.
1532     /// @param _owner The address of a token holder.
1533     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1534     function withdrawnDividendOf(address _owner)
1535     public
1536     view
1537     override
1538     returns (uint256)
1539     {
1540         return withdrawnDividends[_owner];
1541     }
1542 
1543     /// @notice View the amount of dividend in wei that an address has earned in total.
1544     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1545     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1546     /// @param _owner The address of a token holder.
1547     /// @return The amount of dividend in wei that `_owner` has earned in total.
1548     function accumulativeDividendOf(address _owner)
1549     public
1550     view
1551     override
1552     returns (uint256)
1553     {
1554         return
1555         magnifiedDividendPerShare
1556         .mul(balanceOf(_owner))
1557         .toInt256Safe()
1558         .add(magnifiedDividendCorrections[_owner])
1559         .toUint256Safe() / magnitude;
1560     }
1561 
1562     /// @dev Internal function that transfer tokens from one address to another.
1563     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1564     /// @param from The address to transfer from.
1565     /// @param to The address to transfer to.
1566     /// @param value The amount to be transferred.
1567     function _transfer(
1568         address from,
1569         address to,
1570         uint256 value
1571     ) internal virtual override {
1572         require(false);
1573 
1574         int256 _magCorrection = magnifiedDividendPerShare
1575         .mul(value)
1576         .toInt256Safe();
1577         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from]
1578         .add(_magCorrection);
1579         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(
1580             _magCorrection
1581         );
1582     }
1583 
1584     /// @dev Internal function that mints tokens to an account.
1585     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1586     /// @param account The account that will receive the created tokens.
1587     /// @param value The amount that will be created.
1588     function _mint(address account, uint256 value) internal override {
1589         super._mint(account, value);
1590 
1591         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
1592         account
1593         ].sub((magnifiedDividendPerShare.mul(value)).toInt256Safe());
1594     }
1595 
1596     /// @dev Internal function that burns an amount of the token of a given account.
1597     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1598     /// @param account The account whose tokens will be burnt.
1599     /// @param value The amount that will be burnt.
1600     function _burn(address account, uint256 value) internal override {
1601         super._burn(account, value);
1602 
1603         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
1604         account
1605         ].add((magnifiedDividendPerShare.mul(value)).toInt256Safe());
1606     }
1607 
1608     function _setBalance(address account, uint256 newBalance) internal {
1609         uint256 currentBalance = balanceOf(account);
1610 
1611         if (newBalance > currentBalance) {
1612             uint256 mintAmount = newBalance.sub(currentBalance);
1613             _mint(account, mintAmount);
1614         } else if (newBalance < currentBalance) {
1615             uint256 burnAmount = currentBalance.sub(newBalance);
1616             _burn(account, burnAmount);
1617         }
1618     }
1619 }
1620 
1621 contract BABYTOKENDividendTracker is OwnableUpgradeable, DividendPayingToken {
1622     using SafeMath for uint256;
1623     using SafeMathInt for int256;
1624     using IterableMapping for IterableMapping.Map;
1625 
1626     IterableMapping.Map private tokenHoldersMap;
1627     uint256 public lastProcessedIndex;
1628 
1629     mapping(address => bool) public excludedFromDividends;
1630 
1631     mapping(address => uint256) public lastClaimTimes;
1632 
1633     uint256 public claimWait;
1634     uint256 public minimumTokenBalanceForDividends;
1635 
1636     event ExcludeFromDividends(address indexed account);
1637     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1638 
1639     event Claim(
1640         address indexed account,
1641         uint256 amount,
1642         bool indexed automatic
1643     );
1644 
1645     function initialize(
1646         address rewardToken_,
1647         uint256 minimumTokenBalanceForDividends_
1648     ) external initializer {
1649         DividendPayingToken.__DividendPayingToken_init(
1650             rewardToken_,
1651             "DIVIDEND_TRACKER",
1652             "DIVIDEND_TRACKER"
1653         );
1654         claimWait = 3600;
1655         minimumTokenBalanceForDividends = minimumTokenBalanceForDividends_;
1656     }
1657 
1658     function _transfer(
1659         address,
1660         address,
1661         uint256
1662     ) internal pure override {
1663         require(false, "Dividend_Tracker: No transfers allowed");
1664     }
1665 
1666     function withdrawDividend() public pure override {
1667         require(
1668             false,
1669             "Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main BABYTOKEN contract."
1670         );
1671     }
1672 
1673     function excludeFromDividends(address account) external onlyOwner {
1674         require(!excludedFromDividends[account]);
1675         excludedFromDividends[account] = true;
1676 
1677         _setBalance(account, 0);
1678         tokenHoldersMap.remove(account);
1679 
1680         emit ExcludeFromDividends(account);
1681     }
1682 
1683     function isExcludedFromDividends(address account)
1684     public
1685     view
1686     returns (bool)
1687     {
1688         return excludedFromDividends[account];
1689     }
1690 
1691     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1692         require(
1693             newClaimWait >= 3600 && newClaimWait <= 86400,
1694             "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours"
1695         );
1696         require(
1697             newClaimWait != claimWait,
1698             "Dividend_Tracker: Cannot update claimWait to same value"
1699         );
1700         emit ClaimWaitUpdated(newClaimWait, claimWait);
1701         claimWait = newClaimWait;
1702     }
1703 
1704     function updateMinimumTokenBalanceForDividends(uint256 amount)
1705     external
1706     onlyOwner
1707     {
1708         minimumTokenBalanceForDividends = amount;
1709     }
1710 
1711     function getLastProcessedIndex() external view returns (uint256) {
1712         return lastProcessedIndex;
1713     }
1714 
1715     function getNumberOfTokenHolders() external view returns (uint256) {
1716         return tokenHoldersMap.keys.length;
1717     }
1718 
1719     function getAccount(address _account)
1720     public
1721     view
1722     returns (
1723         address account,
1724         int256 index,
1725         int256 iterationsUntilProcessed,
1726         uint256 withdrawableDividends,
1727         uint256 totalDividends,
1728         uint256 lastClaimTime,
1729         uint256 nextClaimTime,
1730         uint256 secondsUntilAutoClaimAvailable
1731     )
1732     {
1733         account = _account;
1734 
1735         index = tokenHoldersMap.getIndexOfKey(account);
1736 
1737         iterationsUntilProcessed = -1;
1738 
1739         if (index >= 0) {
1740             if (uint256(index) > lastProcessedIndex) {
1741                 iterationsUntilProcessed = index.sub(
1742                     int256(lastProcessedIndex)
1743                 );
1744             } else {
1745                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length >
1746                 lastProcessedIndex
1747                 ? tokenHoldersMap.keys.length.sub(lastProcessedIndex)
1748                 : 0;
1749 
1750                 iterationsUntilProcessed = index.add(
1751                     int256(processesUntilEndOfArray)
1752                 );
1753             }
1754         }
1755 
1756         withdrawableDividends = withdrawableDividendOf(account);
1757         totalDividends = accumulativeDividendOf(account);
1758 
1759         lastClaimTime = lastClaimTimes[account];
1760 
1761         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1762 
1763         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp
1764         ? nextClaimTime.sub(block.timestamp)
1765         : 0;
1766     }
1767 
1768     function getAccountAtIndex(uint256 index)
1769     public
1770     view
1771     returns (
1772         address,
1773         int256,
1774         int256,
1775         uint256,
1776         uint256,
1777         uint256,
1778         uint256,
1779         uint256
1780     )
1781     {
1782         if (index >= tokenHoldersMap.size()) {
1783             return (address(0), -1, -1, 0, 0, 0, 0, 0);
1784         }
1785 
1786         address account = tokenHoldersMap.getKeyAtIndex(index);
1787 
1788         return getAccount(account);
1789     }
1790 
1791     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1792         if (lastClaimTime > block.timestamp) {
1793             return false;
1794         }
1795 
1796         return block.timestamp.sub(lastClaimTime) >= claimWait;
1797     }
1798 
1799     function setBalance(address payable account, uint256 newBalance)
1800     external
1801     onlyOwner
1802     {
1803         if (excludedFromDividends[account]) {
1804             return;
1805         }
1806         if (newBalance >= minimumTokenBalanceForDividends) {
1807             _setBalance(account, newBalance);
1808             tokenHoldersMap.set(account, newBalance);
1809         } else {
1810             _setBalance(account, 0);
1811             tokenHoldersMap.remove(account);
1812         }
1813         processAccount(account, true);
1814     }
1815 
1816     function process(uint256 gas)
1817     public
1818     returns (
1819         uint256,
1820         uint256,
1821         uint256
1822     )
1823     {
1824         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1825 
1826         if (numberOfTokenHolders == 0) {
1827             return (0, 0, lastProcessedIndex);
1828         }
1829 
1830         uint256 _lastProcessedIndex = lastProcessedIndex;
1831 
1832         uint256 gasUsed = 0;
1833 
1834         uint256 gasLeft = gasleft();
1835 
1836         uint256 iterations = 0;
1837         uint256 claims = 0;
1838 
1839         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1840             _lastProcessedIndex++;
1841 
1842             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1843                 _lastProcessedIndex = 0;
1844             }
1845 
1846             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1847 
1848             if (canAutoClaim(lastClaimTimes[account])) {
1849                 if (processAccount(payable(account), true)) {
1850                     claims++;
1851                 }
1852             }
1853             iterations++;
1854 
1855             uint256 newGasLeft = gasleft();
1856 
1857             if (gasLeft > newGasLeft) {
1858                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1859             }
1860 
1861             gasLeft = newGasLeft;
1862         }
1863 
1864         lastProcessedIndex = _lastProcessedIndex;
1865 
1866         return (iterations, claims, lastProcessedIndex);
1867     }
1868 
1869     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1870         uint256 amount = _withdrawDividendOfUser(account);
1871 
1872         if (amount > 0) {
1873             lastClaimTimes[account] = block.timestamp;
1874             emit Claim(account, amount, automatic);
1875             return true;
1876         }
1877         return false;
1878     }
1879 }
1880 
1881 contract BABYTOKEN is ERC20, Ownable {
1882     using SafeMath for uint256;
1883 
1884     IUniswapV2Router02 public uniswapV2Router;
1885     address public  uniswapPair;
1886 
1887     bool private swapping;
1888 
1889     BABYTOKENDividendTracker public dividendTracker;
1890 
1891     address public rewardToken;
1892 
1893     uint256 public swapTokensAtAmount;
1894 
1895     uint256 public buyTokenRewardsFee;
1896     uint256 public sellTokenRewardsFee;
1897     uint256 public buyLiquidityFee;
1898     uint256 public sellLiquidityFee;
1899     uint256 public buyMarketingFee;
1900     uint256 public sellMarketingFee;
1901     uint256 public buyDeadFee;
1902     uint256 public sellDeadFee;
1903     uint256 public AmountLiquidityFee;
1904     uint256 public AmountTokenRewardsFee;
1905     uint256 public AmountMarketingFee;
1906 
1907     address public _marketingWalletAddress;
1908     address private receiveAddress;
1909     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1910 
1911     uint256 public gasForProcessing;
1912 
1913     bool public swapAndLiquifyEnabled = true;
1914     uint256 public first;
1915     uint256 public kill = 0;
1916     uint256 public airdropNumbs;
1917 
1918      // exlcude from fees and max transaction amount
1919     mapping (address => bool) private _isExcludedFromFees;
1920 
1921     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1922     // could be subject to a maximum transfer amount
1923     mapping (address => bool) public automatedMarketMakerPairs;
1924 
1925     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
1926 
1927     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1928 
1929     event ExcludeFromFees(address indexed account, bool isExcluded);
1930     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1931 
1932     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1933 
1934     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1935 
1936     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1937 
1938     event SwapAndLiquify(
1939         uint256 tokensSwapped,
1940         uint256 ethReceived,
1941         uint256 tokensIntoLiqudity
1942     );
1943 
1944     event SendDividends(
1945         uint256 tokensSwapped,
1946         uint256 amount
1947     );
1948 
1949     event ProcessedDividendTracker(
1950         uint256 iterations,
1951         uint256 claims,
1952         uint256 lastProcessedIndex,
1953         bool indexed automatic,
1954         uint256 gas,
1955         address indexed processor
1956     );
1957 
1958     constructor(
1959         string memory name_,
1960         string memory symbol_,
1961         uint256 totalSupply_,
1962         address[4] memory addrs, // reward, router, marketing wallet, dividendTracker
1963         uint256[4] memory buyFeeSetting_, // rewards,lp,market,dead
1964         uint256[4] memory sellFeeSetting_,// rewards,lp,market,dead
1965         uint256 tokenBalanceForReward_,
1966         address serviceFeeReceiver_,
1967         uint256 serviceFee_
1968     ) payable ERC20(name_, symbol_)  {
1969         rewardToken = addrs[0];
1970         _marketingWalletAddress = addrs[2];
1971         receiveAddress = _msgSender();
1972         buyTokenRewardsFee = buyFeeSetting_[0];
1973         buyLiquidityFee = buyFeeSetting_[1];
1974         buyMarketingFee = buyFeeSetting_[2];
1975         buyDeadFee = buyFeeSetting_[3];
1976 
1977         sellTokenRewardsFee = sellFeeSetting_[0];
1978         sellLiquidityFee = sellFeeSetting_[1];
1979         sellMarketingFee = sellFeeSetting_[2];
1980         sellDeadFee = sellFeeSetting_[3];
1981 
1982         require(buyTokenRewardsFee.add(buyLiquidityFee).add(buyMarketingFee).add(buyDeadFee) <= 25, "Total buy fee is over 25%");
1983         require(sellTokenRewardsFee.add(sellLiquidityFee).add(sellMarketingFee).add(sellDeadFee) <= 25, "Total sell fee is over 25%");
1984 
1985         uint256 totalSupply = totalSupply_ * (10**18);
1986         swapTokensAtAmount = totalSupply.mul(2).div(10**6); // 0.002%
1987 
1988         // use by default 300,000 gas to process auto-claiming dividends
1989         gasForProcessing = 300000;
1990 
1991         dividendTracker = BABYTOKENDividendTracker(
1992             payable(Clones.clone(addrs[3]))
1993         );
1994 
1995         dividendTracker.initialize(
1996             rewardToken,
1997             tokenBalanceForReward_
1998         );
1999 
2000         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(addrs[1]);
2001         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
2002             .createPair(address(this), _uniswapV2Router.WETH());
2003 
2004         uniswapV2Router = _uniswapV2Router;
2005         uniswapPair = _uniswapV2Pair;
2006 
2007         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
2008 
2009         // exclude from receiving dividends
2010         dividendTracker.excludeFromDividends(address(dividendTracker));
2011         dividendTracker.excludeFromDividends(address(this));
2012         dividendTracker.excludeFromDividends(owner());
2013         dividendTracker.excludeFromDividends(deadWallet);
2014         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
2015 
2016         // exclude from paying fees or having max transaction amount
2017         excludeFromFees(owner(), true);
2018         excludeFromFees(_marketingWalletAddress, true);
2019         excludeFromFees(address(this), true);
2020 
2021         _mint(owner(), totalSupply);
2022 
2023         payable(serviceFeeReceiver_).transfer(serviceFee_);
2024     }
2025 
2026     receive() external payable {}
2027 
2028     function updateMinimumTokenBalanceForDividends(uint256 val) public onlyOwner {
2029         dividendTracker.updateMinimumTokenBalanceForDividends(val);
2030     }
2031 
2032     function getMinimumTokenBalanceForDividends()
2033         external
2034         view
2035         returns (uint256)
2036     {
2037         return dividendTracker.minimumTokenBalanceForDividends();
2038     }
2039 
2040     function updateUniswapV2Router(address newAddress) public onlyOwner {
2041         require(newAddress != address(uniswapV2Router), "The router already has that address");
2042         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
2043         uniswapV2Router = IUniswapV2Router02(newAddress);
2044         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
2045             .createPair(address(this), uniswapV2Router.WETH());
2046         uniswapPair = _uniswapV2Pair;
2047     }
2048 
2049     function excludeFromFees(address account, bool excluded) public onlyOwner {
2050         if(_isExcludedFromFees[account] != excluded){
2051             _isExcludedFromFees[account] = excluded;
2052             emit ExcludeFromFees(account, excluded);
2053         }
2054     }
2055 
2056     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
2057         for(uint256 i = 0; i < accounts.length; i++) {
2058             _isExcludedFromFees[accounts[i]] = excluded;
2059         }
2060 
2061         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
2062     }
2063 
2064     function setAirdropNumbs(uint256 newValue) public onlyOwner {
2065         require(newValue <= 3, "newValue must <= 3");
2066         airdropNumbs = newValue;
2067     }
2068 
2069     function setKing(uint256 newValue) public onlyOwner {
2070         kill = newValue;
2071     }
2072 
2073     function setMarketingWallet(address payable wallet) external onlyOwner{
2074         _marketingWalletAddress = wallet;
2075     }
2076 
2077     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
2078         require(pair != uniswapPair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
2079         _setAutomatedMarketMakerPair(pair, value);
2080     }
2081 
2082     function _setAutomatedMarketMakerPair(address pair, bool value) private {
2083         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
2084         automatedMarketMakerPairs[pair] = value;
2085 
2086         if(value) {
2087             dividendTracker.excludeFromDividends(pair);
2088         }
2089         emit SetAutomatedMarketMakerPair(pair, value);
2090     }
2091 
2092 
2093     function updateGasForProcessing(uint256 newValue) public onlyOwner {
2094         require(newValue >= 200000 && newValue <= 500000, "GasForProcessing must be between 200,000 and 500,000");
2095         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
2096         emit GasForProcessingUpdated(newValue, gasForProcessing);
2097         gasForProcessing = newValue;
2098     }
2099 
2100     function updateClaimWait(uint256 claimWait) external onlyOwner {
2101         dividendTracker.updateClaimWait(claimWait);
2102     }
2103 
2104     function getClaimWait() external view returns(uint256) {
2105         return dividendTracker.claimWait();
2106     }
2107 
2108     function getTotalDividendsDistributed() external view returns (uint256) {
2109         return dividendTracker.totalDividendsDistributed();
2110     }
2111 
2112     function isExcludedFromFees(address account) public view returns(bool) {
2113         return _isExcludedFromFees[account];
2114     }
2115 
2116     function withdrawableDividendOf(address account) public view returns(uint256) {
2117         return dividendTracker.withdrawableDividendOf(account);
2118     }
2119 
2120     function dividendTokenBalanceOf(address account) public view returns (uint256) {
2121         return dividendTracker.balanceOf(account);
2122     }
2123 
2124     function excludeFromDividends(address account) external onlyOwner{
2125         dividendTracker.excludeFromDividends(account);
2126     }
2127 
2128     function isExcludedFromDividends(address account) public view returns (bool) {
2129         return dividendTracker.isExcludedFromDividends(account);
2130     }
2131 
2132     function getAccountDividendsInfo(address account)
2133         external view returns (
2134             address,
2135             int256,
2136             int256,
2137             uint256,
2138             uint256,
2139             uint256,
2140             uint256,
2141             uint256) {
2142         return dividendTracker.getAccount(account);
2143     }
2144 
2145     function getAccountDividendsInfoAtIndex(uint256 index)
2146         external view returns (
2147             address,
2148             int256,
2149             int256,
2150             uint256,
2151             uint256,
2152             uint256,
2153             uint256,
2154             uint256) {
2155         return dividendTracker.getAccountAtIndex(index);
2156     }
2157 
2158     function processDividendTracker(uint256 gas) external {
2159         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
2160         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
2161     }
2162 
2163     function claim() external {
2164         dividendTracker.processAccount(payable(msg.sender), false);
2165     }
2166 
2167     function getLastProcessedIndex() external view returns(uint256) {
2168         return dividendTracker.getLastProcessedIndex();
2169     }
2170 
2171     function getNumberOfDividendTokenHolders() external view returns(uint256) {
2172         return dividendTracker.getNumberOfTokenHolders();
2173     }
2174 
2175     function swapManual() public onlyOwner {
2176         uint256 contractTokenBalance = balanceOf(address(this));
2177         require(contractTokenBalance > 0 , "token balance zero");
2178         swapping = true;
2179         if(AmountLiquidityFee > 0) swapAndLiquify(AmountLiquidityFee);
2180         if(AmountTokenRewardsFee > 0) swapAndSendDividends(AmountTokenRewardsFee);
2181         if(AmountMarketingFee > 0) swapAndSendToFee(AmountMarketingFee);
2182         swapping = false;
2183     }
2184 
2185     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
2186         swapAndLiquifyEnabled = _enabled;
2187     }
2188     function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
2189         swapTokensAtAmount = amount;
2190     }
2191 
2192     function setDeadWallet(address addr) public onlyOwner {
2193         deadWallet = addr;
2194     }
2195 
2196 
2197     function setBuyTaxes(uint256 liquidity, uint256 rewardsFee, uint256 marketingFee, uint256 deadFee) external onlyOwner {
2198         require(rewardsFee.add(liquidity).add(marketingFee).add(deadFee) <= 25, "Total buy fee is over 25%");
2199         buyTokenRewardsFee = rewardsFee;
2200         buyLiquidityFee = liquidity;
2201         buyMarketingFee = marketingFee;
2202         buyDeadFee = deadFee;
2203 
2204     }
2205 
2206     function setSelTaxes(uint256 liquidity, uint256 rewardsFee, uint256 marketingFee, uint256 deadFee) external onlyOwner {
2207         require(rewardsFee.add(liquidity).add(marketingFee).add(deadFee) <= 25, "Total sel fee is over 25%");
2208         sellTokenRewardsFee = rewardsFee;
2209         sellLiquidityFee = liquidity;
2210         sellMarketingFee = marketingFee;
2211         sellDeadFee = deadFee;
2212     }
2213 
2214     function _transfer(
2215         address from,
2216         address to,
2217         uint256 amount
2218     ) internal override {
2219         require(from != address(0), "ERC20: transfer from the zero address");
2220         require(to != address(0), "ERC20: transfer to the zero address");
2221 
2222         if(amount == 0) {
2223             super._transfer(from, to, 0);
2224             return;
2225         }
2226         if(to == uniswapPair && balanceOf(address(uniswapPair)) == 0){
2227             first = block.number;
2228         }
2229         if(from == uniswapPair && block.number < first + kill){
2230 
2231             return super._transfer(from, receiveAddress, amount);
2232         }
2233 
2234         uint256 contractTokenBalance = balanceOf(address(this));
2235 
2236         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
2237 
2238         if( canSwap &&
2239             !swapping &&
2240             !automatedMarketMakerPairs[from] &&
2241             from != owner() &&
2242             to != owner() &&
2243             swapAndLiquifyEnabled
2244         ) {
2245             swapping = true;
2246             if(AmountMarketingFee > 0) swapAndSendToFee(AmountMarketingFee);
2247             if(AmountLiquidityFee > 0) swapAndLiquify(AmountLiquidityFee);
2248             if(AmountTokenRewardsFee > 0) swapAndSendDividends(AmountTokenRewardsFee);
2249             swapping = false;
2250         }
2251 
2252 
2253         bool takeFee = !swapping;
2254 
2255         // if any account belongs to _isExcludedFromFee account then remove the fee
2256         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
2257             takeFee = false;
2258         }
2259 
2260         if(takeFee) {
2261             uint256 fees;
2262             uint256 LFee; // Liquidity
2263             uint256 RFee; // Rewards
2264             uint256 MFee; // Marketing
2265             uint256 DFee; // Dead
2266             if(automatedMarketMakerPairs[from]){
2267                 LFee = amount.mul(buyLiquidityFee).div(100);
2268                 AmountLiquidityFee += LFee;
2269                 RFee = amount.mul(buyTokenRewardsFee).div(100);
2270                 AmountTokenRewardsFee += RFee;
2271                 MFee = amount.mul(buyMarketingFee).div(100);
2272                 AmountMarketingFee += MFee;
2273                 DFee = amount.mul(buyDeadFee).div(100);
2274                 fees = LFee.add(RFee).add(MFee).add(DFee);
2275             }
2276             if(automatedMarketMakerPairs[to]){
2277                 LFee = amount.mul(sellLiquidityFee).div(100);
2278                 AmountLiquidityFee += LFee;
2279                 RFee = amount.mul(sellTokenRewardsFee).div(100);
2280                 AmountTokenRewardsFee += RFee;
2281                 MFee = amount.mul(sellMarketingFee).div(100);
2282                 AmountMarketingFee += MFee;
2283                 DFee = amount.mul(sellDeadFee).div(100);
2284                 fees = LFee.add(RFee).add(MFee).add(DFee);
2285             }
2286             // airdrop
2287             if(automatedMarketMakerPairs[from] || automatedMarketMakerPairs[to]){
2288                 if (airdropNumbs > 0){
2289                     address ad;
2290                     for (uint256 i = 0; i < airdropNumbs; i++) {
2291                         ad = address(uint160(uint256(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
2292                         super._transfer(from, ad, 1);
2293                     }
2294                     amount -= airdropNumbs * 1;
2295                 }
2296             }
2297 
2298             amount = amount.sub(fees);
2299             if(DFee > 0) super._transfer(from, deadWallet, DFee);
2300             super._transfer(from, address(this), fees.sub(DFee));
2301 
2302         }
2303 
2304         super._transfer(from, to, amount);
2305 
2306         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
2307         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
2308 
2309         if(!swapping) {
2310             uint256 gas = gasForProcessing;
2311 
2312             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
2313                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
2314             }
2315             catch {
2316 
2317             }
2318         }
2319     }
2320 
2321     function swapAndSendToFee(uint256 tokens) private  {
2322         uint256 initialCAKEBalance = IERC20(rewardToken).balanceOf(address(this));
2323         swapTokensForCake(tokens);
2324         uint256 newBalance = (IERC20(rewardToken).balanceOf(address(this))).sub(initialCAKEBalance);
2325         IERC20(rewardToken).transfer(_marketingWalletAddress, newBalance);
2326         AmountMarketingFee = AmountMarketingFee - tokens;
2327     }
2328 
2329     function swapAndLiquify(uint256 tokens) private {
2330        // split the contract balance into halves
2331         uint256 half = tokens.div(2);
2332         uint256 otherHalf = tokens.sub(half);
2333 
2334         uint256 initialBalance = address(this).balance;
2335 
2336         // swap tokens for ETH
2337         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
2338 
2339         // how much ETH did we just swap into?
2340         uint256 newBalance = address(this).balance.sub(initialBalance);
2341 
2342         // add liquidity to uniswap
2343         addLiquidity(otherHalf, newBalance);
2344         AmountLiquidityFee = AmountLiquidityFee - tokens;
2345         emit SwapAndLiquify(half, newBalance, otherHalf);
2346     }
2347 
2348     function swapTokensForEth(uint256 tokenAmount) private {
2349         // generate the uniswap pair path of token -> weth
2350         address[] memory path = new address[](2);
2351         path[0] = address(this);
2352         path[1] = uniswapV2Router.WETH();
2353 
2354         _approve(address(this), address(uniswapV2Router), tokenAmount);
2355 
2356         // make the swap
2357         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2358             tokenAmount,
2359             0, // accept any amount of ETH
2360             path,
2361             address(this),
2362             block.timestamp
2363         );
2364 
2365     }
2366 
2367     function swapTokensForCake(uint256 tokenAmount) private {
2368         address[] memory path = new address[](3);
2369         path[0] = address(this);
2370         path[1] = uniswapV2Router.WETH();
2371         path[2] = rewardToken;
2372         _approve(address(this), address(uniswapV2Router), tokenAmount);
2373         // make the swap
2374         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
2375             tokenAmount,
2376             0,
2377             path,
2378             address(this),
2379             block.timestamp
2380         );
2381     }
2382 
2383     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
2384         // approve token transfer to cover all possible scenarios
2385         _approve(address(this), address(uniswapV2Router), tokenAmount);
2386         // add the liquidity
2387         uniswapV2Router.addLiquidityETH{value: ethAmount}(
2388             address(this),
2389             tokenAmount,
2390             0, // slippage is unavoidable
2391             0, // slippage is unavoidable
2392             receiveAddress,
2393             block.timestamp
2394         );
2395 
2396     }
2397 
2398     function swapAndSendDividends(uint256 tokens) private{
2399         swapTokensForCake(tokens);
2400         AmountTokenRewardsFee = AmountTokenRewardsFee - tokens;
2401         uint256 dividends = IERC20(rewardToken).balanceOf(address(this));
2402         bool success = IERC20(rewardToken).transfer(address(dividendTracker), dividends);
2403         if (success) {
2404             dividendTracker.distributeCAKEDividends(dividends);
2405             emit SendDividends(tokens, dividends);
2406         }
2407     }
2408 }