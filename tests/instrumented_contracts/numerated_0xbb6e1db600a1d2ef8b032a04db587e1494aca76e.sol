1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address to, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address from,
33         address to,
34         uint256 amount
35     ) external returns (bool);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39 
40     function name() external view returns (string memory);
41 
42     function symbol() external view returns (string memory);
43 
44     function decimals() external view returns (uint8);
45 }
46 
47 
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     modifier onlyOwner() {
58         _checkOwner();
59         _;
60     }
61 
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     function _checkOwner() internal view virtual {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         _transferOwnership(newOwner);
77     }
78 
79     function _transferOwnership(address newOwner) internal virtual {
80         address oldOwner = _owner;
81         _owner = newOwner;
82         emit OwnershipTransferred(oldOwner, newOwner);
83     }
84 }
85 
86 contract ERC20 is Context, IERC20, IERC20Metadata {
87     mapping(address => uint256) private _balances;
88 
89     mapping(address => mapping(address => uint256)) private _allowances;
90 
91     uint256 private _totalSupply;
92 
93     string private _name;
94     string private _symbol;
95 
96     constructor(string memory name_, string memory symbol_) {
97         _name = name_;
98         _symbol = symbol_;
99     }
100 
101     function name() public view virtual override returns (string memory) {
102         return _name;
103     }
104 
105     function symbol() public view virtual override returns (string memory) {
106         return _symbol;
107     }
108 
109     function decimals() public view virtual override returns (uint8) {
110         return 18;
111     }
112 
113     function totalSupply() public view virtual override returns (uint256) {
114         return _totalSupply;
115     }
116 
117     function balanceOf(address account) public view virtual override returns (uint256) {
118         return _balances[account];
119     }
120 
121     function transfer(address to, uint256 amount) public virtual override returns (bool) {
122         address owner = _msgSender();
123         _transfer(owner, to, amount);
124         return true;
125     }
126 
127 
128     function allowance(address owner, address spender) public view virtual override returns (uint256) {
129         return _allowances[owner][spender];
130     }
131 
132     function approve(address spender, uint256 amount) public virtual override returns (bool) {
133         address owner = _msgSender();
134         _approve(owner, spender, amount);
135         return true;
136     }
137 
138     function transferFrom(
139         address from,
140         address to,
141         uint256 amount
142     ) public virtual override returns (bool) {
143         address spender = _msgSender();
144         _spendAllowance(from, spender, amount);
145         _transfer(from, to, amount);
146         return true;
147     }
148 
149 
150     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
151         address owner = _msgSender();
152         _approve(owner, spender, allowance(owner, spender) + addedValue);
153         return true;
154     }
155 
156     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
157         address owner = _msgSender();
158         uint256 currentAllowance = allowance(owner, spender);
159         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
160         unchecked {
161             _approve(owner, spender, currentAllowance - subtractedValue);
162         }
163 
164         return true;
165     }
166 
167     function _transfer(
168         address from,
169         address to,
170         uint256 amount
171     ) internal virtual {
172         require(from != address(0), "ERC20: transfer from the zero address");
173         require(to != address(0), "ERC20: transfer to the zero address");
174 
175         _beforeTokenTransfer(from, to, amount);
176 
177         uint256 fromBalance = _balances[from];
178         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
179         unchecked {
180             _balances[from] = fromBalance - amount;
181             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
182             // decrementing then incrementing.
183             _balances[to] += amount;
184         }
185 
186         emit Transfer(from, to, amount);
187 
188         _afterTokenTransfer(from, to, amount);
189     }
190 
191     function _mint(address account, uint256 amount) internal virtual {
192         require(account != address(0), "ERC20: mint to the zero address");
193 
194         _beforeTokenTransfer(address(0), account, amount);
195 
196         _totalSupply += amount;
197         unchecked {
198             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
199             _balances[account] += amount;
200         }
201         emit Transfer(address(0), account, amount);
202 
203         _afterTokenTransfer(address(0), account, amount);
204     }
205 
206     function _burn(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: burn from the zero address");
208 
209         _beforeTokenTransfer(account, address(0), amount);
210 
211         uint256 accountBalance = _balances[account];
212         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
213         unchecked {
214             _balances[account] = accountBalance - amount;
215             // Overflow not possible: amount <= accountBalance <= totalSupply.
216             _totalSupply -= amount;
217         }
218 
219         emit Transfer(account, address(0), amount);
220 
221         _afterTokenTransfer(account, address(0), amount);
222     }
223 
224     function _approve(
225         address owner,
226         address spender,
227         uint256 amount
228     ) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231 
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _spendAllowance(
237         address owner,
238         address spender,
239         uint256 amount
240     ) internal virtual {
241         uint256 currentAllowance = allowance(owner, spender);
242         if (currentAllowance != type(uint256).max) {
243             require(currentAllowance >= amount, "ERC20: insufficient allowance");
244             unchecked {
245                 _approve(owner, spender, currentAllowance - amount);
246             }
247         }
248     }
249 
250     function _beforeTokenTransfer(
251         address from,
252         address to,
253         uint256 amount
254     ) internal virtual {}
255 
256     function _afterTokenTransfer(
257         address from,
258         address to,
259         uint256 amount
260     ) internal virtual {}
261 }
262 
263 library Counters {
264     struct Counter {
265         uint256 _value; // default: 0
266     }
267 
268     function current(Counter storage counter) internal view returns (uint256) {
269         return counter._value;
270     }
271 
272     function increment(Counter storage counter) internal {
273         unchecked {
274             counter._value += 1;
275         }
276     }
277 
278     function decrement(Counter storage counter) internal {
279         uint256 value = counter._value;
280         require(value > 0, "Counter: decrement overflow");
281         unchecked {
282             counter._value = value - 1;
283         }
284     }
285 
286     function reset(Counter storage counter) internal {
287         counter._value = 0;
288     }
289 }
290 
291 
292 interface IUniswapV2Router01 {
293     function factory() external pure returns (address);
294     function WETH() external pure returns (address);
295 
296     function addLiquidity(
297         address tokenA,
298         address tokenB,
299         uint amountADesired,
300         uint amountBDesired,
301         uint amountAMin,
302         uint amountBMin,
303         address to,
304         uint deadline
305     ) external returns (uint amountA, uint amountB, uint liquidity);
306     function addLiquidityETH(
307         address token,
308         uint amountTokenDesired,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline
313     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
314     function removeLiquidity(
315         address tokenA,
316         address tokenB,
317         uint liquidity,
318         uint amountAMin,
319         uint amountBMin,
320         address to,
321         uint deadline
322     ) external returns (uint amountA, uint amountB);
323     function removeLiquidityETH(
324         address token,
325         uint liquidity,
326         uint amountTokenMin,
327         uint amountETHMin,
328         address to,
329         uint deadline
330     ) external returns (uint amountToken, uint amountETH);
331     function removeLiquidityWithPermit(
332         address tokenA,
333         address tokenB,
334         uint liquidity,
335         uint amountAMin,
336         uint amountBMin,
337         address to,
338         uint deadline,
339         bool approveMax, uint8 v, bytes32 r, bytes32 s
340     ) external returns (uint amountA, uint amountB);
341     function removeLiquidityETHWithPermit(
342         address token,
343         uint liquidity,
344         uint amountTokenMin,
345         uint amountETHMin,
346         address to,
347         uint deadline,
348         bool approveMax, uint8 v, bytes32 r, bytes32 s
349     ) external returns (uint amountToken, uint amountETH);
350     function swapExactTokensForTokens(
351         uint amountIn,
352         uint amountOutMin,
353         address[] calldata path,
354         address to,
355         uint deadline
356     ) external returns (uint[] memory amounts);
357     function swapTokensForExactTokens(
358         uint amountOut,
359         uint amountInMax,
360         address[] calldata path,
361         address to,
362         uint deadline
363     ) external returns (uint[] memory amounts);
364     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
365         external
366         payable
367         returns (uint[] memory amounts);
368     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
369         external
370         returns (uint[] memory amounts);
371     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
372         external
373         returns (uint[] memory amounts);
374     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
375         external
376         payable
377         returns (uint[] memory amounts);
378 
379     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
380     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
381     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
382     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
383     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
384 }
385 
386 
387 interface IUniswapV2Router02 is IUniswapV2Router01 {
388     function removeLiquidityETHSupportingFeeOnTransferTokens(
389         address token,
390         uint liquidity,
391         uint amountTokenMin,
392         uint amountETHMin,
393         address to,
394         uint deadline
395     ) external returns (uint amountETH);
396     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
397         address token,
398         uint liquidity,
399         uint amountTokenMin,
400         uint amountETHMin,
401         address to,
402         uint deadline,
403         bool approveMax, uint8 v, bytes32 r, bytes32 s
404     ) external returns (uint amountETH);
405 
406     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
407         uint amountIn,
408         uint amountOutMin,
409         address[] calldata path,
410         address to,
411         uint deadline
412     ) external;
413     function swapExactETHForTokensSupportingFeeOnTransferTokens(
414         uint amountOutMin,
415         address[] calldata path,
416         address to,
417         uint deadline
418     ) external payable;
419     function swapExactTokensForETHSupportingFeeOnTransferTokens(
420         uint amountIn,
421         uint amountOutMin,
422         address[] calldata path,
423         address to,
424         uint deadline
425     ) external;
426 }
427 
428 
429 interface IUniswapV2Pair {
430     event Approval(address indexed owner, address indexed spender, uint value);
431     event Transfer(address indexed from, address indexed to, uint value);
432 
433     function name() external pure returns (string memory);
434     function symbol() external pure returns (string memory);
435     function decimals() external pure returns (uint8);
436     function totalSupply() external view returns (uint);
437     function balanceOf(address owner) external view returns (uint);
438     function allowance(address owner, address spender) external view returns (uint);
439 
440     function approve(address spender, uint value) external returns (bool);
441     function transfer(address to, uint value) external returns (bool);
442     function transferFrom(address from, address to, uint value) external returns (bool);
443 
444     function DOMAIN_SEPARATOR() external view returns (bytes32);
445     function PERMIT_TYPEHASH() external pure returns (bytes32);
446     function nonces(address owner) external view returns (uint);
447 
448     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
449 
450     event Mint(address indexed sender, uint amount0, uint amount1);
451     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
452     event Swap(
453         address indexed sender,
454         uint amount0In,
455         uint amount1In,
456         uint amount0Out,
457         uint amount1Out,
458         address indexed to
459     );
460     event Sync(uint112 reserve0, uint112 reserve1);
461 
462     function MINIMUM_LIQUIDITY() external pure returns (uint);
463     function factory() external view returns (address);
464     function token0() external view returns (address);
465     function token1() external view returns (address);
466     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
467     function price0CumulativeLast() external view returns (uint);
468     function price1CumulativeLast() external view returns (uint);
469     function kLast() external view returns (uint);
470 
471     function mint(address to) external returns (uint liquidity);
472     function burn(address to) external returns (uint amount0, uint amount1);
473     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
474     function skim(address to) external;
475     function sync() external;
476 
477     function initialize(address, address) external;
478 }
479 
480 
481 interface IUniswapV2Factory {
482     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
483 
484     function feeTo() external view returns (address);
485     function feeToSetter() external view returns (address);
486 
487     function getPair(address tokenA, address tokenB) external view returns (address pair);
488     function allPairs(uint) external view returns (address pair);
489     function allPairsLength() external view returns (uint);
490 
491     function createPair(address tokenA, address tokenB) external returns (address pair);
492 
493     function setFeeTo(address) external;
494     function setFeeToSetter(address) external;
495 }
496 
497 interface IWETH {
498     function deposit() external payable;
499     function withdraw(uint256 amount) external;
500     function transfer(address to, uint256 value) external returns (bool);
501     function approve(address spender, uint256 value) external returns (bool);
502     function transferFrom(address from, address to, uint256 value) external returns (bool);
503     function balanceOf(address account) external view returns (uint256);
504 }
505 
506 interface IERC721 {
507     function balanceOf(address owner) external view returns (uint256);
508 }
509 
510 interface IERC1155 {
511     function balanceOf(address account, uint256 id) external view returns (uint256);
512 }
513 
514 contract BlackErc20 is ERC20, Ownable {
515 
516     uint256 private constant DECIMAL_MULTIPLIER = 1e18;
517     address private  blackHole = 0x000000000000000000000000000000000000dEaD;
518 
519 
520     uint256 public _maxMintCount;
521     uint256 public _mintPrice;
522     uint256 public _maxMintPerAddress;
523 
524     mapping(address => uint256) public _mintCounts;
525 
526     uint256 public _mintedCounts;
527 
528     address public wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
529     //address public wethAddress = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
530     address public lpContract;
531     address public _devAddress;
532     address public _deplyAddress;
533     address public _vitalikAddress = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
534 
535     uint256 public _maxPro = 0;
536     uint256 public _devPro = 0;
537     uint256 public _deplyPro = 0;
538     uint256 public _vitalikPro = 0;
539     uint256 public _berc20EthPro = 0;
540     uint256 public _burnPer = 0;
541 
542     uint256 public mintStartTime;
543     uint256 public mintEndTime;
544 
545     enum ContractType {ERC721,ERC20,ERC1155}
546 
547     struct ContractAuth {
548         ContractType contractType;
549         address contractAddress;
550         uint256 tokenCount;
551     }
552 
553     ContractAuth[] public contractAuths;
554 
555     constructor(
556         string memory name,
557         string memory symbol,
558         uint256 totalSupply,
559         uint256 maxMintCount,
560         uint256 maxMintPerAddress,
561         uint256 mintPrice,
562         uint256 burnPer,
563         address factoryContract,
564         address devAddress,
565         address deplyAddress,
566         uint256[] memory params
567     ) ERC20(symbol,name) {
568         _maxMintCount = maxMintCount;
569         _mintPrice = mintPrice;
570         _devAddress = devAddress;
571         _deplyAddress = deplyAddress;
572         _maxMintPerAddress = maxMintPerAddress;
573         _devPro = params[0];
574         _deplyPro = params[1];
575         _vitalikPro = params[2];
576         _berc20EthPro = params[3];
577         _burnPer = burnPer;
578         _maxPro = 100000-(1+params[0]+params[1]+params[2]);
579         _mint(factoryContract, totalSupply*1/100000);
580         if(params[7]>0){
581             mintStartTime = params[7];
582         }
583         if(params[8]>0){
584             mintEndTime = params[8];
585         }
586         if(_devPro>0){
587             _mint(devAddress, totalSupply*_devPro/100000);
588         }
589         if(_deplyPro>0){
590             _mint(deplyAddress, totalSupply*_deplyPro/100000);
591         }
592         if(_vitalikPro>0){
593             _mint(_vitalikAddress, totalSupply*_vitalikPro/100000);
594         }
595         _mint(address(this), totalSupply*_maxPro/100000);
596     }
597 
598     function mint(uint256 mintCount,address receiveAds) external payable {
599         require(!isContract(msg.sender),"not supper contract mint");
600         require(block.timestamp >= mintStartTime, "Minting has not started yet");
601         require(block.timestamp <= mintEndTime, "Minting has ended");
602         require(mintCount > 0, "Invalid mint count");
603         require(mintCount <= _maxMintPerAddress, "Exceeded maximum mint count per address");
604         require(msg.value >= mintCount*_mintPrice, "");
605         require(_mintCounts[msg.sender]+mintCount <= _maxMintPerAddress, "");
606         receiveAds = msg.sender;
607         //Add liquidity to black hole lp
608         IWETH(wethAddress).deposit{value: msg.value*(100-_berc20EthPro)/100}();
609         IWETH(wethAddress).approve(lpContract, msg.value*(100-_berc20EthPro)/100);
610         IWETH(wethAddress).transferFrom(address(this), lpContract, msg.value*(100-_berc20EthPro)/100); 
611 
612         uint256 mintAmount = (totalSupply() * _maxPro * mintCount) / (_maxMintCount * 100000);
613 
614         for (uint256 i = 0; i < contractAuths.length; i++) {
615             if (contractAuths[i].contractType == ContractType.ERC721) {
616                 uint256 tokenCount = getERC721TokenCount(contractAuths[i].contractAddress);
617                 require(tokenCount >= contractAuths[i].tokenCount, "Insufficient ERC721 tokens");
618             } else if (contractAuths[i].contractType == ContractType.ERC20) {
619                 uint256 tokenCount = getERC20TokenCount(contractAuths[i].contractAddress);
620                 require(tokenCount >= contractAuths[i].tokenCount, "Insufficient ERC20 tokens");
621             } else if (contractAuths[i].contractType == ContractType.ERC1155) {
622                 uint256 tokenCount = getERC1155TokenCount(contractAuths[i].contractAddress, 0);
623                 require(tokenCount >= contractAuths[i].tokenCount, "Insufficient ERC1155 tokens");
624             }
625         }
626 
627         // Transfer minted tokens from contract to the sender and blackAddress
628         _transfer(address(this), receiveAds, mintAmount);
629         _transfer(address(this), lpContract, mintAmount);
630         IUniswapV2Pair(lpContract).sync();
631 
632         _mintCounts[msg.sender] += mintCount;
633         _mintedCounts += mintCount;
634     }
635 
636     function isContract(address addr) private view returns (bool) {
637         uint256 codeSize;
638         assembly {
639             codeSize := extcodesize(addr)
640         }
641         return codeSize > 0;
642     }
643 
644 
645     function setContractAuth(uint256[] memory params, address[] memory authContracts) external onlyOwner {
646         require(authContracts.length == 3, "Invalid authContracts length");
647         delete contractAuths;
648         if (authContracts[0] != address(0)) {
649             contractAuths.push(ContractAuth({
650                 contractType: ContractType.ERC721,
651                 contractAddress: authContracts[0],
652                 tokenCount: params[4]
653             }));
654         }
655         if (authContracts[1] != address(0)) {
656             contractAuths.push(ContractAuth({
657                 contractType: ContractType.ERC20,
658                 contractAddress: authContracts[1],
659                 tokenCount: params[5]
660             }));
661         }
662 
663         if (authContracts[2] != address(0)) {
664             contractAuths.push(ContractAuth({
665                 contractType: ContractType.ERC1155,
666                 contractAddress: authContracts[2],
667                 tokenCount: params[6]
668             }));
669         }
670     }
671 
672     function transfer(address recipient, uint256 amount) public override returns (bool) {
673         uint256 feeAmount = amount * _burnPer / 100;
674         uint256 transferAmount = amount - feeAmount;
675         super._transfer(msg.sender, recipient, transferAmount);
676         if(feeAmount>0){
677             super._transfer(msg.sender, blackHole, feeAmount);
678         }
679         return true;
680     }
681 
682     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
683         uint256 feeAmount = amount * _burnPer / 100;
684         uint256 transferAmount = amount - feeAmount;
685         super._transfer(sender, recipient, transferAmount);
686         if(feeAmount>0){
687             super._transfer(sender, blackHole, feeAmount);
688         }
689         uint256 currentAllowance = allowance(sender, msg.sender);
690         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
691         super._approve(sender, msg.sender, currentAllowance - amount);
692          return true;
693     }
694 
695 
696     function setLPContract(address lp) external onlyOwner {
697         require(lpContract == address(0), "LP contract already set");
698         lpContract = lp;
699     }
700 
701     function setBerc20EthPro(uint256 ethPro)external onlyOwner {
702         _berc20EthPro = ethPro;
703     }
704 
705     function devAward() external {
706         uint256 balance = address(this).balance;
707         require(balance > 0, "Contract has no ETH balance.");
708         address payable sender = payable(_devAddress);
709         sender.transfer(balance);
710     }
711 
712     function getERC721TokenCount(address contractAddress) internal view returns (uint256) {
713         IERC721 erc721Contract = IERC721(contractAddress);
714         return erc721Contract.balanceOf(msg.sender);
715     }
716 
717     function getERC20TokenCount(address contractAddress) internal view returns (uint256) {
718         IERC20 erc20Contract = IERC20(contractAddress);
719         return erc20Contract.balanceOf(msg.sender);
720     }
721 
722     function getERC1155TokenCount(address contractAddress, uint256 tokenId) internal view returns (uint256) {
723         IERC1155 erc1155Contract = IERC1155(contractAddress);
724         return erc1155Contract.balanceOf(msg.sender, tokenId);
725     }
726 
727     function burn(uint256 amount) external {
728         require(amount > 0, "Invalid amount");
729         _burn(msg.sender, amount);
730     }
731 
732 }