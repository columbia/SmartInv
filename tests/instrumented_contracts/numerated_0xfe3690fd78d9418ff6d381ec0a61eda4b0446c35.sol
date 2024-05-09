1 /**
2 ███    ███  ██████  ███████ ███████ ███████      ██████  ██████  ██ ███    ██ 
3 ████  ████ ██    ██ ██      ██      ██          ██      ██    ██ ██ ████   ██ 
4 ██ ████ ██ ██    ██ ███████ █████   ███████     ██      ██    ██ ██ ██ ██  ██ 
5 ██  ██  ██ ██    ██      ██ ██           ██     ██      ██    ██ ██ ██  ██ ██ 
6 ██      ██  ██████  ███████ ███████ ███████      ██████  ██████  ██ ██   ████ */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.19;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor() {
28         _transferOwnership(_msgSender());
29     }
30 
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     modifier onlyOwner() {
36         require(owner() == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     function renounceOwnership() public virtual onlyOwner {
41         _transferOwnership(address(0));
42     }
43 
44     function transferOwnership(address newOwner) public virtual onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         _transferOwnership(newOwner);
47     }
48 
49     function _transferOwnership(address newOwner) internal virtual {
50         address oldOwner = _owner;
51         _owner = newOwner;
52         emit OwnershipTransferred(oldOwner, newOwner);
53     }
54 }
55 
56 interface IUniswapV2Factory {
57     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
58 
59     function feeTo() external view returns (address);
60     function feeToSetter() external view returns (address);
61     function getPair(address tokenA, address tokenB) external view returns (address pair);
62     function allPairs(uint) external view returns (address pair);
63     function allPairsLength() external view returns (uint);
64     function createPair(address tokenA, address tokenB) external returns (address pair);
65     function setFeeTo(address) external;
66     function setFeeToSetter(address) external;
67 }
68 
69 interface IUniswapV2Pair {
70     event Approval(address indexed owner, address indexed spender, uint value);
71     event Transfer(address indexed from, address indexed to, uint value);
72 
73     function name() external pure returns (string memory);
74     function symbol() external pure returns (string memory);
75     function decimals() external pure returns (uint8);
76     function totalSupply() external view returns (uint);
77     function balanceOf(address owner) external view returns (uint);
78     function allowance(address owner, address spender) external view returns (uint);
79 
80     function approve(address spender, uint value) external returns (bool);
81     function transfer(address to, uint value) external returns (bool);
82     function transferFrom(address from, address to, uint value) external returns (bool);
83 
84     function DOMAIN_SEPARATOR() external view returns (bytes32);
85     function PERMIT_TYPEHASH() external pure returns (bytes32);
86     function nonces(address owner) external view returns (uint);
87 
88     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
89 
90     event Swap(
91         address indexed sender,
92         uint amount0In,
93         uint amount1In,
94         uint amount0Out,
95         uint amount1Out,
96         address indexed to
97     );
98     event Sync(uint112 reserve0, uint112 reserve1);
99 
100     function MINIMUM_LIQUIDITY() external pure returns (uint);
101     function factory() external view returns (address);
102     function token0() external view returns (address);
103     function token1() external view returns (address);
104     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
105     function price0CumulativeLast() external view returns (uint);
106     function price1CumulativeLast() external view returns (uint);
107     function kLast() external view returns (uint);
108     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
109     function skim(address to) external;
110     function sync() external;
111 
112     function initialize(address, address) external;
113 }
114 
115 interface IUniswapV2Router01 {
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118 
119     function addLiquidity(
120         address tokenA,
121         address tokenB,
122         uint amountADesired,
123         uint amountBDesired,
124         uint amountAMin,
125         uint amountBMin,
126         address to,
127         uint deadline
128     ) external returns (uint amountA, uint amountB, uint liquidity);
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137     function removeLiquidity(
138         address tokenA,
139         address tokenB,
140         uint liquidity,
141         uint amountAMin,
142         uint amountBMin,
143         address to,
144         uint deadline
145     ) external returns (uint amountA, uint amountB);
146     function removeLiquidityETH(
147         address token,
148         uint liquidity,
149         uint amountTokenMin,
150         uint amountETHMin,
151         address to,
152         uint deadline
153     ) external returns (uint amountToken, uint amountETH);
154     function removeLiquidityWithPermit(
155         address tokenA,
156         address tokenB,
157         uint liquidity,
158         uint amountAMin,
159         uint amountBMin,
160         address to,
161         uint deadline,
162         bool approveMax, uint8 v, bytes32 r, bytes32 s
163     ) external returns (uint amountA, uint amountB);
164     function removeLiquidityETHWithPermit(
165         address token,
166         uint liquidity,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline,
171         bool approveMax, uint8 v, bytes32 r, bytes32 s
172     ) external returns (uint amountToken, uint amountETH);
173     function swapExactTokensForTokens(
174         uint amountIn,
175         uint amountOutMin,
176         address[] calldata path,
177         address to,
178         uint deadline
179     ) external returns (uint[] memory amounts);
180     function swapTokensForExactTokens(
181         uint amountOut,
182         uint amountInMax,
183         address[] calldata path,
184         address to,
185         uint deadline
186     ) external returns (uint[] memory amounts);
187     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
188         external
189         payable
190         returns (uint[] memory amounts);
191     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
192         external
193         returns (uint[] memory amounts);
194     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
195         external
196         returns (uint[] memory amounts);
197     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
198         external
199         payable
200         returns (uint[] memory amounts);
201 
202     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
203     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
204     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
205     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
206     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
207 }
208 
209 interface IUniswapV2Router02 is IUniswapV2Router01 {
210     function removeLiquidityETHSupportingFeeOnTransferTokens(
211         address token,
212         uint liquidity,
213         uint amountTokenMin,
214         uint amountETHMin,
215         address to,
216         uint deadline
217     ) external returns (uint amountETH);
218     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
219         address token,
220         uint liquidity,
221         uint amountTokenMin,
222         uint amountETHMin,
223         address to,
224         uint deadline,
225         bool approveMax, uint8 v, bytes32 r, bytes32 s
226     ) external returns (uint amountETH);
227 
228     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
229         uint amountIn,
230         uint amountOutMin,
231         address[] calldata path,
232         address to,
233         uint deadline
234     ) external;
235     function swapExactETHForTokensSupportingFeeOnTransferTokens(
236         uint amountOutMin,
237         address[] calldata path,
238         address to,
239         uint deadline
240     ) external payable;
241     function swapExactTokensForETHSupportingFeeOnTransferTokens(
242         uint amountIn,
243         uint amountOutMin,
244         address[] calldata path,
245         address to,
246         uint deadline
247     ) external;
248 }
249 
250 interface IERC20 {
251     function totalSupply() external view returns (uint256);
252     function balanceOf(address who) external view returns (uint256);
253     function allowance(address owner, address spender) external view returns (uint256);
254     function transfer(address to, uint256 value) external returns (bool);
255     function approve(address spender, uint256 value) external returns (bool);
256     function transferFrom(address from, address to, uint256 value) external returns (bool);
257 
258     event Transfer(address indexed from, address indexed to, uint256 value);
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 
261 }
262 
263 interface IERC20Metadata is IERC20 {
264 	function name() external view returns (string memory);
265 	function symbol() external view returns (string memory);
266 	function decimals() external view returns (uint8);
267 }
268 
269 contract ERC20 is Context, IERC20, IERC20Metadata {
270     mapping(address => uint256) internal _balances;
271 
272     mapping(address => mapping(address => uint256)) private _allowances;
273 
274     uint256 internal _totalSupply;
275 
276     string private _name;
277     string private _symbol;
278 
279     constructor(string memory name_, string memory symbol_) {
280         _name = name_;
281         _symbol = symbol_;
282     }
283 
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     function symbol() public view virtual override returns (string memory) {
289         return _symbol;
290     }
291 
292     function decimals() public view virtual override returns (uint8) {
293         return 18;
294     }
295 
296     function totalSupply() public view virtual override returns (uint256) {
297         return _totalSupply;
298     }
299 
300     function balanceOf(address account)
301         public
302         view
303         virtual
304         override
305         returns (uint256)
306     {
307         return _balances[account];
308     }
309 
310     function transfer(address recipient, uint256 amount)
311         public
312         virtual
313         override
314         returns (bool)
315     {
316         _transfer(_msgSender(), recipient, amount);
317         return true;
318     }
319 
320     function allowance(address owner, address spender)
321         public
322         view
323         virtual
324         override
325         returns (uint256)
326     {
327         return _allowances[owner][spender];
328     }
329 
330     function approve(address spender, uint256 amount)
331         public
332         virtual
333         override
334         returns (bool)
335     {
336         _approve(_msgSender(), spender, amount);
337         return true;
338     }
339 
340     function transferFrom(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) public virtual override returns (bool) {
345         uint256 currentAllowance = _allowances[sender][_msgSender()];
346         if (currentAllowance != type(uint256).max) {
347             require(
348                 currentAllowance >= amount,
349                 "ERC20: transfer amount exceeds allowance"
350             );
351             unchecked {
352                 _approve(sender, _msgSender(), currentAllowance - amount);
353             }
354         }
355 
356         _transfer(sender, recipient, amount);
357 
358         return true;
359     }
360 
361     function increaseAllowance(address spender, uint256 addedValue)
362         public
363         virtual
364         returns (bool)
365     {
366         _approve(
367             _msgSender(),
368             spender,
369             _allowances[_msgSender()][spender] + addedValue
370         );
371         return true;
372     }
373 
374     function decreaseAllowance(address spender, uint256 subtractedValue)
375         public
376         virtual
377         returns (bool)
378     {
379         uint256 currentAllowance = _allowances[_msgSender()][spender];
380         require(
381             currentAllowance >= subtractedValue,
382             "ERC20: decreased allowance below zero"
383         );
384         unchecked {
385             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
386         }
387 
388         return true;
389     }
390 
391     function _transfer(
392         address sender,
393         address recipient,
394         uint256 amount
395     ) internal virtual {
396         require(sender != address(0), "ERC20: transfer from the zero address");
397         require(recipient != address(0), "ERC20: transfer to the zero address");
398 
399         _beforeTokenTransfer(sender, recipient, amount);
400 
401         uint256 senderBalance = _balances[sender];
402         require(
403             senderBalance >= amount,
404             "ERC20: transfer amount exceeds balance"
405         );
406         unchecked {
407             _balances[sender] = senderBalance - amount;
408         }
409         _balances[recipient] += amount;
410 
411         emit Transfer(sender, recipient, amount);
412 
413         _afterTokenTransfer(sender, recipient, amount);
414     }
415 
416     function _mint(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: mint to the zero address");
418         _beforeTokenTransfer(address(0), account, amount);
419         _totalSupply = _totalSupply + (amount);
420         _balances[account] = _balances[account] + (amount);
421         emit Transfer(address(0), account, amount);
422     }
423 
424     function _burn(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: burn from the zero address");
426         _beforeTokenTransfer(account, address(0), amount);
427 
428         uint256 accountBalance = _balances[account];
429         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
430 
431         _balances[account] = accountBalance - amount;
432         _totalSupply -= amount;
433 
434         emit Transfer(account, address(0), amount);
435     }
436 
437     function _approve(
438         address owner,
439         address spender,
440         uint256 amount
441     ) internal virtual {
442         require(owner != address(0), "ERC20: approve from the zero address");
443         require(spender != address(0), "ERC20: approve to the zero address");
444 
445         _allowances[owner][spender] = amount;
446         emit Approval(owner, spender, amount);
447     }
448 
449     function _beforeTokenTransfer(
450         address from,
451         address to,
452         uint256 amount
453     ) internal virtual {}
454 
455     function _afterTokenTransfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {}
460 }
461 
462 contract MosesCoin is ERC20, Ownable {
463    
464 
465     uint256 public  burnFeeOnBuy        = 2;
466     uint256 public  burnFeeOnSell       = 2;
467 
468     IUniswapV2Router02 public uniswapV2Router;
469     address public  uniswapV2Pair;
470     mapping (address => bool) public automatedMarketMakerPairs;
471     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
472 
473 
474     
475     address private constant dead = 0x000000000000000000000000000000000000dEaD;
476     address private constant burnerWallet = 0xD9EcB8BEFA8EfE4A0E5ef56e95ef7dfd5D3C1C3A;
477 
478    
479     uint256 public burnAmount;
480     bool public lockBurner = false;
481 
482     //=======Fee=======//
483     mapping (address => bool) private _isExcludedFromFees;
484 
485     event ExcludeFromFees(address indexed account);
486     event IncludeInFees(address indexed account);
487     event UpdateBuyFees(uint256 burnFeeOnBuy);
488     event UpdateSellFees(uint256 burnFeeOnSell);
489     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
490     event TokenBurn(uint256 burnAmount);
491 
492     modifier onlyBurner() {
493         require(burnerWallet == _msgSender(), "Ownable: caller is not the owner");
494         _;
495     }
496 
497     constructor()ERC20("MosesCoin",  "Moses") {
498         transferOwnership(0xc959340Fc1C964bE5D6c06b46bbc2FE2322cD64E);
499         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
500 
501         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
502             .createPair(address(this), _uniswapV2Router.WETH());
503         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
504 
505 
506         uniswapV2Router = _uniswapV2Router;
507         uniswapV2Pair   = _uniswapV2Pair;
508 
509         _approve(address(this), address(uniswapV2Router), type(uint256).max);
510            
511         _isExcludedFromFees[owner()] = true;
512         _isExcludedFromFees[dead] = true;
513         _isExcludedFromFees[address(this)] = true;
514         _isExcludedFromFees[address(0)] = true;
515         _isExcludedFromFees[burnerWallet] = true;
516 
517         _totalSupply = 1_000_000_000_000 * 10 ** decimals();      
518          burnAmount = totalSupply() * 777 / 1000;  // 77.7% of the total supply
519         _balances[owner()] = totalSupply();
520         emit Transfer(address(0), owner(), totalSupply());
521     }
522 
523     receive() external payable {
524 
525   	}
526 
527 
528     function claimStuckTokens(address token) external onlyOwner {
529         require(token != address(this), "Owner cannot claim Moses tokens");
530         if (token == address(0x0)) {
531             payable(msg.sender).transfer(address(this).balance);
532             return;
533         }
534         IERC20 ERC20token = IERC20(token);
535         uint256 balance = ERC20token.balanceOf(address(this));
536         ERC20token.transfer(msg.sender, balance);
537     }
538 
539     //=======FeeManagement=======//
540     function excludeFromFees(address account) external onlyOwner {
541         require(!_isExcludedFromFees[account], "Account is already excluded");
542         _isExcludedFromFees[account] = true;
543 
544         emit ExcludeFromFees(account);
545     }
546 
547     function includeInFees(address account) external onlyOwner {
548         require(_isExcludedFromFees[account], "Account is already included");
549         _isExcludedFromFees[account] = false;
550         
551         emit IncludeInFees(account);
552     }
553 
554     function isExcludedFromFees(address account) public view returns(bool) {
555         return _isExcludedFromFees[account];
556     }
557 
558     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
559         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
560  
561         _setAutomatedMarketMakerPair(pair, value);
562     }
563  
564     function _setAutomatedMarketMakerPair(address pair, bool value) private {
565         automatedMarketMakerPairs[pair] = value;
566  
567         emit SetAutomatedMarketMakerPair(pair, value);
568     }
569  
570 
571     function updateBuyFees(uint256 _burnFeeOnBuy) external onlyOwner {
572         require(
573             _burnFeeOnBuy<= 10,
574             "Fees must be less than 10%"
575         );
576         burnFeeOnBuy = _burnFeeOnBuy;
577         emit UpdateBuyFees(_burnFeeOnBuy);
578     }
579 
580     function updateSellFees(uint256 _burnFeeOnSell) external onlyOwner {
581         require(
582             _burnFeeOnSell<= 10,
583             "Fees must be less than 10%"
584         );
585         burnFeeOnSell = _burnFeeOnSell;
586         emit UpdateSellFees(_burnFeeOnSell);
587     }
588 
589     function _transfer(
590         address from,
591         address to,
592         uint256 amount
593     ) internal override {
594         require(from != address(0), "ERC20: transfer from the zero address");
595         require(to != address(0), "ERC20: transfer to the zero address");
596 
597         if (lockBurner){
598             require(from != burnerWallet, "Account to be used for burning tokens only");
599             require(to != burnerWallet, "Account to be used for burning tokens only");
600         }
601 
602         if(amount == 0) {
603             super._transfer(from, to, 0);
604             return;
605         }     
606 
607         bool takeFee = true;
608 
609         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
610             takeFee = false;
611         }
612 
613         if (takeFee) {
614             uint256 burnTokens;
615             if(automatedMarketMakerPairs[from] ) {
616                 burnTokens = (burnFeeOnBuy * amount) / 100;
617             } else {
618                 burnTokens = (burnFeeOnSell * amount) / 100;
619             }
620 
621             amount -= (burnTokens);
622 
623             if(burnTokens > 0)
624                 super._transfer(from, dead, burnTokens);
625                 emit TokenBurn(burnTokens); 
626             }
627 
628         super._transfer(from, to, amount);
629     }
630 
631     function setBurner() external onlyOwner(){
632         require(!lockBurner);
633         _transfer(msg.sender, burnerWallet, burnAmount);
634         lockBurner = true;
635     }
636 
637     function burn(uint256 value) external onlyOwner(){
638         _burn(msg.sender, value);
639     }
640 
641     function burnFromBurner() external onlyBurner(){
642         lockBurner = false;
643         _burn(msg.sender, burnAmount);
644     }
645 
646 }