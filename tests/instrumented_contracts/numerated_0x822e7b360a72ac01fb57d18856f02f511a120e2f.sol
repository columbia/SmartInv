1 // SPDX-License-Identifier: Unlicensed
2 
3     pragma solidity ^0.8.0;
4 
5     interface IERC20 {
6         
7         function totalSupply() external view returns (uint256);
8         function balanceOf(address account) external view returns (uint256);
9         function transfer(address recipient, uint256 amount) external returns (bool);
10         function allowance(address owner, address spender) external view returns (uint256);
11         function approve(address spender, uint256 amount) external returns (bool);
12         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13         
14         event Transfer(address indexed from, address indexed to, uint256 value);
15         event Approval(address indexed owner, address indexed spender, uint256 value);
16     }
17 
18     library SafeMath {
19         
20         function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21             unchecked {
22                 uint256 c = a + b;
23                 if (c < a) return (false, 0);
24                 return (true, c);
25             }
26         }
27         
28         function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29             unchecked {
30                 if (b > a) return (false, 0);
31                 return (true, a - b);
32             }
33         }
34         
35         function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36             unchecked {
37                 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38                 // benefit is lost if 'b' is also tested.
39                 // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40                 if (a == 0) return (true, 0);
41                 uint256 c = a * b;
42                 if (c / a != b) return (false, 0);
43                 return (true, c);
44             }
45         }
46         
47         function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48             unchecked {
49                 if (b == 0) return (false, 0);
50                 return (true, a / b);
51             }
52         }
53         
54         function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55             unchecked {
56                 if (b == 0) return (false, 0);
57                 return (true, a % b);
58             }
59         }
60 
61         function add(uint256 a, uint256 b) internal pure returns (uint256) {
62             return a + b;
63         }
64 
65 
66         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67             return a - b;
68         }
69 
70 
71         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72             return a * b;
73         }
74         
75         function div(uint256 a, uint256 b) internal pure returns (uint256) {
76             return a / b;
77         }
78 
79 
80         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81             return a % b;
82         }
83         
84         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85             unchecked {
86                 require(b <= a, errorMessage);
87                 return a - b;
88             }
89         }
90         
91         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92             unchecked {
93                 require(b > 0, errorMessage);
94                 return a / b;
95             }
96         }
97         
98         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99             unchecked {
100                 require(b > 0, errorMessage);
101                 return a % b;
102             }
103         }
104     }
105 
106     abstract contract Context {
107         function _msgSender() internal view virtual returns (address) {
108             return msg.sender;
109         }
110 
111         function _msgData() internal view virtual returns (bytes calldata) {
112             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
113             return msg.data;
114         }
115     }
116 
117     library Address {
118         
119         function isContract(address account) internal view returns (bool) {
120             uint256 size;
121             assembly { size := extcodesize(account) }
122             return size > 0;
123         }
124 
125         function sendValue(address payable recipient, uint256 amount) internal {
126             require(address(this).balance >= amount, "Address: insufficient balance");
127             (bool success, ) = recipient.call{ value: amount }("");
128             require(success, "Address: unable to send value, recipient may have reverted");
129         }
130         
131         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
132         return functionCall(target, data, "Address: low-level call failed");
133         }
134         
135         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
136             return functionCallWithValue(target, data, 0, errorMessage);
137         }
138         
139         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
140             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
141         }
142         
143         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
144             require(address(this).balance >= value, "Address: insufficient balance for call");
145             require(isContract(target), "Address: call to non-contract");
146             (bool success, bytes memory returndata) = target.call{ value: value }(data);
147             return _verifyCallResult(success, returndata, errorMessage);
148         }
149         
150         function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151             return functionStaticCall(target, data, "Address: low-level static call failed");
152         }
153         
154         function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
155             require(isContract(target), "Address: static call to non-contract");
156             (bool success, bytes memory returndata) = target.staticcall(data);
157             return _verifyCallResult(success, returndata, errorMessage);
158         }
159 
160 
161         function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
162             return functionDelegateCall(target, data, "Address: low-level delegate call failed");
163         }
164         
165         function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
166             require(isContract(target), "Address: delegate call to non-contract");
167             (bool success, bytes memory returndata) = target.delegatecall(data);
168             return _verifyCallResult(success, returndata, errorMessage);
169         }
170 
171         function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
172             if (success) {
173                 return returndata;
174             } else {
175                 if (returndata.length > 0) {
176                     assembly {
177                         let returndata_size := mload(returndata)
178                         revert(add(32, returndata), returndata_size)
179                     }
180                 } else {
181                     revert(errorMessage);
182                 }
183             }
184         }
185     }
186 
187     abstract contract Ownable is Context {
188         address internal _owner;
189         address private _previousOwner;
190 
191         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192         constructor () {
193             _owner = _msgSender();
194             emit OwnershipTransferred(address(0), _owner);
195         }
196         
197         function owner() public view virtual returns (address) {
198             return _owner;
199         }
200         
201         modifier onlyOwner() {
202             require(owner() == _msgSender(), "Ownable: caller is not the owner");
203             _;
204         }
205         
206         function renounceOwnership() public virtual onlyOwner {
207             emit OwnershipTransferred(_owner, address(0));
208             _owner = address(0);
209         }
210 
211 
212         function transferOwnership(address newOwner) public virtual onlyOwner {
213             require(newOwner != address(0), "Ownable: new owner is the zero address");
214             emit OwnershipTransferred(_owner, newOwner);
215             _owner = newOwner;
216         }
217     
218     }
219 
220     interface IERC20Metadata is IERC20 {
221         /**
222         * @dev Returns the name of the token.
223         */
224         function name() external view returns (string memory);
225 
226         /**
227         * @dev Returns the symbol of the token.
228         */
229         function symbol() external view returns (string memory);
230 
231         /**
232         * @dev Returns the decimals places of the token.
233         */
234         function decimals() external view returns (uint8);
235     }
236     contract ERC20 is Context,Ownable, IERC20, IERC20Metadata {
237         using SafeMath for uint256;
238 
239         mapping(address => uint256) private _balances;
240 
241         mapping(address => mapping(address => uint256)) private _allowances;
242 
243         uint256 private _totalSupply;
244 
245         string private _name;
246         string private _symbol;
247 
248         /**
249         * @dev Sets the values for {name} and {symbol}.
250         *
251         * The default value of {decimals} is 18. To select a different value for
252         * {decimals} you should overload it.
253         *
254         * All two of these values are immutable: they can only be set once during
255         * construction.
256         */
257         constructor(string memory name_, string memory symbol_) {
258             _name = name_;
259             _symbol = symbol_;
260         }
261 
262         /**
263         * @dev Returns the name of the token.
264         */
265         function name() public view virtual override returns (string memory) {
266             return _name;
267         }
268 
269         /**
270         * @dev Returns the symbol of the token, usually a shorter version of the
271         * name.
272         */
273         function symbol() public view virtual override returns (string memory) {
274             return _symbol;
275         }
276 
277         /**
278         * @dev Returns the number of decimals used to get its user representation.
279         * For example, if `decimals` equals `2`, a balance of `505` tokens should
280         * be displayed to a user as `5,05` (`505 / 10 ** 2`).
281         *
282         * Tokens usually opt for a value of 18, imitating the relationship between
283         * Ether and Wei. This is the value {ERC20} uses, unless this function is
284         * overridden;
285         *
286         * NOTE: This information is only used for _display_ purposes: it in
287         * no way affects any of the arithmetic of the contract, including
288         * {IERC20-balanceOf} and {IERC20-transfer}.
289         */
290         function decimals() public view virtual override returns (uint8) {
291             return 18;
292         }
293 
294         /**
295         * @dev See {IERC20-totalSupply}.
296         */
297         function totalSupply() public view virtual override returns (uint256) {
298             return _totalSupply;
299         }
300 
301         /**
302         * @dev See {IERC20-balanceOf}.
303         */
304         function balanceOf(address account) public view virtual override returns (uint256) {
305             return _balances[account];
306         }
307 
308         /**
309         * @dev See {IERC20-transfer}.
310         *
311         * Requirements:
312         *
313         * - `recipient` cannot be the zero address.
314         * - the caller must have a balance of at least `amount`.
315         */
316         function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
317             _transfer(_msgSender(), recipient, amount);
318             return true;
319         }
320 
321         /**
322         * @dev See {IERC20-allowance}.
323         */
324         function allowance(address owner, address spender) public view virtual override returns (uint256) {
325             return _allowances[owner][spender];
326         }
327 
328         /**
329         * @dev See {IERC20-approve}.
330         *
331         * Requirements:
332         *
333         * - `spender` cannot be the zero address.
334         */
335         function approve(address spender, uint256 amount) public virtual override returns (bool) {
336             _approve(_msgSender(), spender, amount);
337             return true;
338         }
339 
340         /**
341         * @dev See {IERC20-transferFrom}.
342         *
343         * Emits an {Approval} event indicating the updated allowance. This is not
344         * required by the EIP. See the note at the beginning of {ERC20}.
345         *
346         * Requirements:
347         *
348         * - `sender` and `recipient` cannot be the zero address.
349         * - `sender` must have a balance of at least `amount`.
350         * - the caller must have allowance for ``sender``'s tokens of at least
351         * `amount`.
352         */
353         function transferFrom(
354             address sender,
355             address recipient,
356             uint256 amount
357         ) public virtual override returns (bool) {
358             _transfer(sender, recipient, amount);
359             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
360             return true;
361         }
362 
363         /**
364         * @dev Atomically increases the allowance granted to `spender` by the caller.
365         *
366         * This is an alternative to {approve} that can be used as a mitigation for
367         * problems described in {IERC20-approve}.
368         *
369         * Emits an {Approval} event indicating the updated allowance.
370         *
371         * Requirements:
372         *
373         * - `spender` cannot be the zero address.
374         */
375         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
376             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
377             return true;
378         }
379 
380         /**
381         * @dev Atomically decreases the allowance granted to `spender` by the caller.
382         *
383         * This is an alternative to {approve} that can be used as a mitigation for
384         * problems described in {IERC20-approve}.
385         *
386         * Emits an {Approval} event indicating the updated allowance.
387         *
388         * Requirements:
389         *
390         * - `spender` cannot be the zero address.
391         * - `spender` must have allowance for the caller of at least
392         * `subtractedValue`.
393         */
394         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
395             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
396             return true;
397         }
398 
399         /**
400         * @dev Moves tokens `amount` from `sender` to `recipient`.
401         *
402         * This is internal function is equivalent to {transfer}, and can be used to
403         * e.g. implement automatic token fees, slashing mechanisms, etc.
404         *
405         * Emits a {Transfer} event.
406         *
407         * Requirements:
408         *
409         * - `sender` cannot be the zero address.
410         * - `recipient` cannot be the zero address.
411         * - `sender` must have a balance of at least `amount`.
412         */
413         function _transfer(
414             address sender,
415             address recipient,
416             uint256 amount
417         ) internal virtual {
418             require(sender != address(0), "ERC20: transfer from the zero address");
419             require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421             _beforeTokenTransfer(sender, recipient, amount);
422 
423             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
424             _balances[recipient] = _balances[recipient].add(amount);
425             emit Transfer(sender, recipient, amount);
426         }
427 
428         /** @dev Creates `amount` tokens and assigns them to `account`, increasing
429         * the total supply.
430         *
431         * Emits a {Transfer} event with `from` set to the zero address.
432         *
433         * Requirements:
434         *
435         * - `account` cannot be the zero address.
436         */
437         function _mint(address account, uint256 amount) internal virtual {
438             require(account != address(0), "ERC20: mint to the zero address");
439 
440             _beforeTokenTransfer(address(0), account, amount);
441 
442             _totalSupply = _totalSupply.add(amount);
443             _balances[account] = _balances[account].add(amount);
444             emit Transfer(address(0), account, amount);
445         }
446 
447         /**
448         * @dev Destroys `amount` tokens from `account`, reducing the
449         * total supply.
450         *
451         * Emits a {Transfer} event with `to` set to the zero address.
452         *
453         * Requirements:
454         *
455         * - `account` cannot be the zero address.
456         * - `account` must have at least `amount` tokens.
457         */
458         function _burn(address account, uint256 amount) internal virtual {
459             require(account != address(0), "ERC20: burn from the zero address");
460 
461             _beforeTokenTransfer(account, address(0), amount);
462 
463             _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464             _totalSupply = _totalSupply.sub(amount);
465             emit Transfer(account, address(0), amount);
466         }
467 
468         /**
469         * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
470         *
471         * This internal function is equivalent to `approve`, and can be used to
472         * e.g. set automatic allowances for certain subsystems, etc.
473         *
474         * Emits an {Approval} event.
475         *
476         * Requirements:
477         *
478         * - `owner` cannot be the zero address.
479         * - `spender` cannot be the zero address.
480         */
481         function _approve(
482             address owner,
483             address spender,
484             uint256 amount
485         ) internal virtual {
486             require(owner != address(0), "ERC20: approve from the zero address");
487             require(spender != address(0), "ERC20: approve to the zero address");
488 
489             _allowances[owner][spender] = amount;
490             emit Approval(owner, spender, amount);
491         }
492 
493         /**
494         * @dev Hook that is called before any transfer of tokens. This includes
495         * minting and burning.
496         *
497         * Calling conditions:
498         *
499         * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
500         * will be to transferred to `to`.
501         * - when `from` is zero, `amount` tokens will be minted for `to`.
502         * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
503         * - `from` and `to` are never both zero.
504         *
505         * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
506         */
507         function _beforeTokenTransfer(
508             address from,
509             address to,
510             uint256 amount
511         ) internal virtual {}
512     }
513 
514 
515     interface IUniswapV2Factory {
516         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
517         function feeTo() external view returns (address);
518         function feeToSetter() external view returns (address);
519         function getPair(address tokenA, address tokenB) external view returns (address pair);
520         function allPairs(uint) external view returns (address pair);
521         function allPairsLength() external view returns (uint);
522         function createPair(address tokenA, address tokenB) external returns (address pair);
523         function setFeeTo(address) external;
524         function setFeeToSetter(address) external;
525     }
526 
527     interface IUniswapV2Pair {
528         event Approval(address indexed owner, address indexed spender, uint value);
529         event Transfer(address indexed from, address indexed to, uint value);
530         function name() external pure returns (string memory);
531         function symbol() external pure returns (string memory);
532         function decimals() external pure returns (uint8);
533         function totalSupply() external view returns (uint);
534         function balanceOf(address owner) external view returns (uint);
535         function allowance(address owner, address spender) external view returns (uint);
536         function approve(address spender, uint value) external returns (bool);
537         function transfer(address to, uint value) external returns (bool);
538         function transferFrom(address from, address to, uint value) external returns (bool);
539         function DOMAIN_SEPARATOR() external view returns (bytes32);
540         function PERMIT_TYPEHASH() external pure returns (bytes32);
541         function nonces(address owner) external view returns (uint);
542         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
543         event Mint(address indexed sender, uint amount0, uint amount1);
544         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
545         event Swap(
546             address indexed sender,
547             uint amount0In,
548             uint amount1In,
549             uint amount0Out,
550             uint amount1Out,
551             address indexed to
552         );
553         event Sync(uint112 reserve0, uint112 reserve1);
554         function MINIMUM_LIQUIDITY() external pure returns (uint);
555         function factory() external view returns (address);
556         function token0() external view returns (address);
557         function token1() external view returns (address);
558         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
559         function price0CumulativeLast() external view returns (uint);
560         function price1CumulativeLast() external view returns (uint);
561         function kLast() external view returns (uint);
562         function mint(address to) external returns (uint liquidity);
563         function burn(address to) external returns (uint amount0, uint amount1);
564         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
565         function skim(address to) external;
566         function sync() external;
567         function initialize(address, address) external;
568     }
569 
570     interface IUniswapV2Router01 {
571         function factory() external pure returns (address);
572         function WETH() external pure returns (address);
573         function addLiquidity(
574             address tokenA,
575             address tokenB,
576             uint amountADesired,
577             uint amountBDesired,
578             uint amountAMin,
579             uint amountBMin,
580             address to,
581             uint deadline
582         ) external returns (uint amountA, uint amountB, uint liquidity);
583         function addLiquidityETH(
584             address token,
585             uint amountTokenDesired,
586             uint amountTokenMin,
587             uint amountETHMin,
588             address to,
589             uint deadline
590         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
591         function removeLiquidity(
592             address tokenA,
593             address tokenB,
594             uint liquidity,
595             uint amountAMin,
596             uint amountBMin,
597             address to,
598             uint deadline
599         ) external returns (uint amountA, uint amountB);
600         function removeLiquidityETH(
601             address token,
602             uint liquidity,
603             uint amountTokenMin,
604             uint amountETHMin,
605             address to,
606             uint deadline
607         ) external returns (uint amountToken, uint amountETH);
608         function removeLiquidityWithPermit(
609             address tokenA,
610             address tokenB,
611             uint liquidity,
612             uint amountAMin,
613             uint amountBMin,
614             address to,
615             uint deadline,
616             bool approveMax, uint8 v, bytes32 r, bytes32 s
617         ) external returns (uint amountA, uint amountB);
618         function removeLiquidityETHWithPermit(
619             address token,
620             uint liquidity,
621             uint amountTokenMin,
622             uint amountETHMin,
623             address to,
624             uint deadline,
625             bool approveMax, uint8 v, bytes32 r, bytes32 s
626         ) external returns (uint amountToken, uint amountETH);
627         function swapExactTokensForTokens(
628             uint amountIn,
629             uint amountOutMin,
630             address[] calldata path,
631             address to,
632             uint deadline
633         ) external returns (uint[] memory amounts);
634         function swapTokensForExactTokens(
635             uint amountOut,
636             uint amountInMax,
637             address[] calldata path,
638             address to,
639             uint deadline
640         ) external returns (uint[] memory amounts);
641         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
642             external
643             payable
644             returns (uint[] memory amounts);
645         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
646             external
647             returns (uint[] memory amounts);
648         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
649             external
650             returns (uint[] memory amounts);
651         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
652             external
653             payable
654             returns (uint[] memory amounts);
655 
656         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
657         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
658         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
659         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
660         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
661     }
662 
663     interface IUniswapV2Router02 is IUniswapV2Router01 {
664         function removeLiquidityETHSupportingFeeOnTransferTokens(
665             address token,
666             uint liquidity,
667             uint amountTokenMin,
668             uint amountETHMin,
669             address to,
670             uint deadline
671         ) external returns (uint amountETH);
672         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
673             address token,
674             uint liquidity,
675             uint amountTokenMin,
676             uint amountETHMin,
677             address to,
678             uint deadline,
679             bool approveMax, uint8 v, bytes32 r, bytes32 s
680         ) external returns (uint amountETH);
681 
682         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
683             uint amountIn,
684             uint amountOutMin,
685             address[] calldata path,
686             address to,
687             uint deadline
688         ) external;
689         function swapExactETHForTokensSupportingFeeOnTransferTokens(
690             uint amountOutMin,
691             address[] calldata path,
692             address to,
693             uint deadline
694         ) external payable;
695         function swapExactTokensForETHSupportingFeeOnTransferTokens(
696             uint amountIn,
697             uint amountOutMin,
698             address[] calldata path,
699             address to,
700             uint deadline
701         ) external;
702     }
703 
704     contract TOKEN is ERC20 {
705         using SafeMath for uint256;
706         using Address for address;
707 
708         mapping (address => bool) private _isExcludedFromFee;
709         mapping(address => bool) private _isExcludedFromMaxWallet;
710         mapping(address => bool) private _isExcludedFromMaxTnxLimit;
711 
712         address public _devWalletAddress;    
713 
714         uint256 public _buyDevFee = 5;  
715         uint256 public _sellDevFee = 5; 
716 
717         IUniswapV2Router02 public uniswapV2Router;
718         address public uniswapV2Pair;
719         bool inSwapAndLiquify;
720         bool public swapAndSendFeeEnabled = true;
721         uint256 public _maxWalletBalance;
722         uint256 public _maxTxAmount;
723         uint256 public numTokensSellToSendEthToDev;
724         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
725         event swapAndSendFeeEnabledUpdated(bool enabled);
726         event SwapAndLiquify(
727             uint256 tokensSwapped,
728             uint256 ethReceived,
729             uint256 tokensIntoLiqudity
730         );
731         
732         modifier lockTheSwap {
733             inSwapAndLiquify = true;
734             _;
735             inSwapAndLiquify = false;
736         }
737         
738         constructor () ERC20("Body Snatchers", "kill"){
739 
740             numTokensSellToSendEthToDev = 100000 * 10 ** decimals();
741             _devWalletAddress = 0x0ceAfdBDed2c8B5CCe1bF3472619773a3694F5E8;
742             
743             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
744             // Create a uniswap pair for this new token
745             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
746                 .createPair(address(this), _uniswapV2Router.WETH());
747 
748             // set the rest of the contract variables
749             uniswapV2Router = _uniswapV2Router;
750             
751             //exclude owner and this contract from fee
752             _isExcludedFromFee[_msgSender()] = true;
753             _isExcludedFromFee[address(this)] = true;
754             _isExcludedFromFee[_devWalletAddress] = true;
755 
756             // exclude from the Max wallet balance 
757             _isExcludedFromMaxWallet[owner()] = true;
758             _isExcludedFromMaxWallet[address(this)] = true;
759             _isExcludedFromMaxWallet[_devWalletAddress] = true;
760 
761             // exclude from the max tnx limit 
762             _isExcludedFromMaxTnxLimit[owner()] = true;
763             _isExcludedFromMaxTnxLimit[address(this)] = true;
764             _isExcludedFromMaxTnxLimit[_devWalletAddress] = true;
765 
766 
767             /*
768                 _mint is an internal function in ERC20.sol that is only called here,
769                 and CANNOT be called ever again
770             */
771             _mint(owner(), 666666666 * 10 ** decimals());		
772             _maxWalletBalance = (totalSupply() * 2 ) / 100;
773             _maxTxAmount = (totalSupply() * 1 ) / 100;
774 
775             
776         }
777 
778         function includeAndExcludeInWhitelist(address account, bool value) public onlyOwner {
779             _isExcludedFromFee[account] = value;
780         }
781 
782         function includeAndExcludedFromMaxWallet(address account, bool value) public onlyOwner {
783             _isExcludedFromMaxWallet[account] = value;
784         }
785 
786         function includeAndExcludedFromMaxTnxLimit(address account, bool value) public onlyOwner {
787             _isExcludedFromMaxTnxLimit[account] = value;
788         }
789 
790         function isExcludedFromFee(address account) public view returns(bool) {
791             return _isExcludedFromFee[account];
792         }
793 
794         function isExcludedFromMaxWallet(address account) public view returns(bool){
795             return _isExcludedFromMaxWallet[account];
796         }
797 
798         function isExcludedFromMaxTnxLimit(address account) public view returns(bool) {
799             return _isExcludedFromMaxTnxLimit[account];
800         }
801 
802         function setMaxWalletBalance(uint256 maxBalancePercent) external onlyOwner {
803         _maxWalletBalance = maxBalancePercent * 10** decimals();
804         }
805 
806         function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
807         _maxTxAmount = maxTxAmount * 10** decimals();
808        }
809 
810 
811         function setSellDevFess(
812             uint256 dFee
813         ) external onlyOwner {
814             _sellDevFee = dFee;
815         }
816 
817         function setBuyDevFees(
818             uint256 dFee
819         ) external onlyOwner {
820             _buyDevFee = dFee;
821         }
822         function setDevWalletAddress(address _addr) external onlyOwner {
823             _devWalletAddress = _addr;
824         }  
825         
826         function setnumTokensSellToSendEthToDev(uint256 amount) external onlyOwner {
827             numTokensSellToSendEthToDev = amount * 10 ** decimals();
828         }
829 
830         function setRouterAddress(address newRouter) external onlyOwner {
831             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouter);
832             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
833             uniswapV2Router = _uniswapV2Router;
834         }
835 
836         function setSwapAndSendFeeEnabled(bool _enabled) external onlyOwner {
837             swapAndSendFeeEnabled = _enabled;
838             emit swapAndSendFeeEnabledUpdated(_enabled);
839         }
840         
841         //to recieve ETH from uniswapV2Router when swaping
842         receive() external payable {}
843 
844         // to withdraw stucked BNB 
845         function withdrawStuckedBNB(uint amount) external onlyOwner{
846             // This is the current recommended method to use.
847             (bool sent,) = _owner.call{value: amount}("");
848             require(sent, "Failed to send BNB");    
849             }
850 
851            // Withdraw stuked tokens 
852         function withdrawStuckedTokens(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success){
853         return IERC20(tokenAddress).transfer(msg.sender, tokens);
854         }
855     
856         function _transfer(
857             address from,
858             address to,
859             uint256 amount
860         ) internal override {
861             require(from != address(0), "ERC20: transfer from the zero address");
862             require(to != address(0), "ERC20: transfer to the zero address");
863             require(amount > 0, "Transfer amount must be greater than zero");
864         
865         if (from != owner() && to != owner())
866             require( _isExcludedFromMaxTnxLimit[from] || _isExcludedFromMaxTnxLimit[to] || 
867                 amount <= _maxTxAmount,
868                 "ERC20: Transfer amount exceeds the maxTxAmount."
869             );
870         
871         
872         if (
873             from != owner() &&
874             to != address(this) &&
875             to != uniswapV2Pair ) 
876         {
877             uint256 currentBalance = balanceOf(to);
878             require(_isExcludedFromMaxWallet[to] || (currentBalance + amount <= _maxWalletBalance),
879                     "ERC20: Reached max wallet holding");
880         }
881       
882             uint256 contractTokenBalance = balanceOf(address(this)); 
883             bool overMinTokenBalance = contractTokenBalance >= numTokensSellToSendEthToDev;
884             if (
885                 overMinTokenBalance &&
886                 !inSwapAndLiquify &&
887                 from != uniswapV2Pair &&
888                 swapAndSendFeeEnabled
889             ) {
890                 contractTokenBalance = numTokensSellToSendEthToDev;
891                 swapTokensForFees(contractTokenBalance);
892             }
893 
894             bool takeFee = true;
895         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
896             super._transfer(from, to, amount);
897             takeFee = false;
898         } else {
899 
900             if (from == uniswapV2Pair) {
901                 // Buy
902                 uint256 DevTokens = amount.mul(_buyDevFee).div(100);
903 
904                 amount= amount.sub(DevTokens);
905                 super._transfer(from, address(this), DevTokens);
906                 super._transfer(from, to, amount);
907 
908             } else if (to == uniswapV2Pair) {
909                 // Sell
910                 uint256 DevTokens = amount.mul(_sellDevFee).div(100);
911 
912                 amount= amount.sub(DevTokens);
913                 super._transfer(from, address(this), DevTokens);
914                 super._transfer(from, to, amount);
915             } else {
916                 // Transfer
917                 super._transfer(from, to, amount);
918             }
919         
920         }
921 
922         }
923 
924         function swapTokensForFees(uint256 tokenAmount) private lockTheSwap {
925             address[] memory path = new address[](2);
926             path[0] = address(this);
927             path[1] = uniswapV2Router.WETH();
928             _approve(address(this), address(uniswapV2Router), tokenAmount);
929             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
930                 tokenAmount,
931                 0, // accept any amount of ETH
932                 path,
933                 _devWalletAddress,
934                 block.timestamp
935             );
936         }
937     }