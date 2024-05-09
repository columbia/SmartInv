1 // This is Spider Man, a little spider who is willing to help others promote good and eliminate evil! Join MEME together to get movie tickets! 
2 
3 // TG：http://t.me/SpiderMan_ETH
4 // WEB：https://spider-man.space
5 // WP：https://spider-man.space/spiderman.whitepaper.pdf
6 // TW：https://twitter.com/spidermancoin
7 
8 // Get your SAFU contract now via Coinsult.net
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.17;
13 
14 interface IUniswapV2Factory {
15     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
16 
17     function feeTo() external view returns (address);
18     function feeToSetter() external view returns (address);
19     function getPair(address tokenA, address tokenB) external view returns (address pair);
20     function allPairs(uint) external view returns (address pair);
21     function allPairsLength() external view returns (uint);
22     function createPair(address tokenA, address tokenB) external returns (address pair);
23     function setFeeTo(address) external;
24     function setFeeToSetter(address) external;
25 }
26 
27 interface IUniswapV2Pair {
28     event Approval(address indexed owner, address indexed spender, uint value);
29     event Transfer(address indexed from, address indexed to, uint value);
30 
31     function name() external pure returns (string memory);
32     function symbol() external pure returns (string memory);
33     function decimals() external pure returns (uint8);
34     function totalSupply() external view returns (uint);
35     function balanceOf(address owner) external view returns (uint);
36     function allowance(address owner, address spender) external view returns (uint);
37 
38     function approve(address spender, uint value) external returns (bool);
39     function transfer(address to, uint value) external returns (bool);
40     function transferFrom(address from, address to, uint value) external returns (bool);
41 
42     function DOMAIN_SEPARATOR() external view returns (bytes32);
43     function PERMIT_TYPEHASH() external pure returns (bytes32);
44     function nonces(address owner) external view returns (uint);
45 
46     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
47 
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
50     event Swap(
51         address indexed sender,
52         uint amount0In,
53         uint amount1In,
54         uint amount0Out,
55         uint amount1Out,
56         address indexed to
57     );
58     event Sync(uint112 reserve0, uint112 reserve1);
59 
60     function MINIMUM_LIQUIDITY() external pure returns (uint);
61     function factory() external view returns (address);
62     function token0() external view returns (address);
63     function token1() external view returns (address);
64     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
65     function price0CumulativeLast() external view returns (uint);
66     function price1CumulativeLast() external view returns (uint);
67     function kLast() external view returns (uint);
68 
69     function mint(address to) external returns (uint liquidity);
70     function burn(address to) external returns (uint amount0, uint amount1);
71     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
72     function skim(address to) external;
73     function sync() external;
74 
75     function initialize(address, address) external;
76 }
77 
78 interface IUniswapV2Router01 {
79     function factory() external pure returns (address);
80     function WETH() external pure returns (address);
81 
82     function addLiquidity(
83         address tokenA,
84         address tokenB,
85         uint amountADesired,
86         uint amountBDesired,
87         uint amountAMin,
88         uint amountBMin,
89         address to,
90         uint deadline
91     ) external returns (uint amountA, uint amountB, uint liquidity);
92     function addLiquidityETH(
93         address token,
94         uint amountTokenDesired,
95         uint amountTokenMin,
96         uint amountETHMin,
97         address to,
98         uint deadline
99     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
100     function removeLiquidity(
101         address tokenA,
102         address tokenB,
103         uint liquidity,
104         uint amountAMin,
105         uint amountBMin,
106         address to,
107         uint deadline
108     ) external returns (uint amountA, uint amountB);
109     function removeLiquidityETH(
110         address token,
111         uint liquidity,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external returns (uint amountToken, uint amountETH);
117     function removeLiquidityWithPermit(
118         address tokenA,
119         address tokenB,
120         uint liquidity,
121         uint amountAMin,
122         uint amountBMin,
123         address to,
124         uint deadline,
125         bool approveMax, uint8 v, bytes32 r, bytes32 s
126     ) external returns (uint amountA, uint amountB);
127     function removeLiquidityETHWithPermit(
128         address token,
129         uint liquidity,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline,
134         bool approveMax, uint8 v, bytes32 r, bytes32 s
135     ) external returns (uint amountToken, uint amountETH);
136     function swapExactTokensForTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external returns (uint[] memory amounts);
143     function swapTokensForExactTokens(
144         uint amountOut,
145         uint amountInMax,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external returns (uint[] memory amounts);
150     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
151         external
152         payable
153         returns (uint[] memory amounts);
154     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
155         external
156         returns (uint[] memory amounts);
157     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
158         external
159         returns (uint[] memory amounts);
160     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
161         external
162         payable
163         returns (uint[] memory amounts);
164 
165     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
166     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
167     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
168     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
169     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
170 }
171 
172 interface IUniswapV2Router02 is IUniswapV2Router01 {
173     function removeLiquidityETHSupportingFeeOnTransferTokens(
174         address token,
175         uint liquidity,
176         uint amountTokenMin,
177         uint amountETHMin,
178         address to,
179         uint deadline
180     ) external returns (uint amountETH);
181     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
182         address token,
183         uint liquidity,
184         uint amountTokenMin,
185         uint amountETHMin,
186         address to,
187         uint deadline,
188         bool approveMax, uint8 v, bytes32 r, bytes32 s
189     ) external returns (uint amountETH);
190 
191     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
192         uint amountIn,
193         uint amountOutMin,
194         address[] calldata path,
195         address to,
196         uint deadline
197     ) external;
198     function swapExactETHForTokensSupportingFeeOnTransferTokens(
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external payable;
204     function swapExactTokensForETHSupportingFeeOnTransferTokens(
205         uint amountIn,
206         uint amountOutMin,
207         address[] calldata path,
208         address to,
209         uint deadline
210     ) external;
211 }
212 
213 interface IERC20 {
214     function totalSupply() external view returns (uint256);
215     function balanceOf(address account) external view returns (uint256);
216     function transfer(address recipient, uint256 amount) external returns (bool);
217     function allowance(address owner, address spender) external view returns (uint256);
218     function approve(address spender, uint256 amount) external returns (bool);
219     function transferFrom(
220         address sender,
221         address recipient,
222         uint256 amount
223     ) external returns (bool);
224    
225     event Transfer(address indexed from, address indexed to, uint256 value);
226     event Approval(address indexed owner, address indexed spender, uint256 value);
227 }
228 
229 interface IERC20Metadata is IERC20 {
230     function name() external view returns (string memory);
231     function symbol() external view returns (string memory);
232     function decimals() external view returns (uint8);
233 }
234 
235 library Address {
236     function isContract(address account) internal view returns (bool) {
237         return account.code.length > 0;
238     }
239 
240     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
241         require(address(this).balance >= amount, "Address: insufficient balance");
242 
243         (bool success, ) = recipient.call{value: amount}("");
244         return success;
245     }
246 
247     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
249     }
250 
251     function functionCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         return functionCallWithValue(target, data, 0, errorMessage);
257     }
258 
259     function functionCallWithValue(
260         address target,
261         bytes memory data,
262         uint256 value
263     ) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
265     }
266 
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(address(this).balance >= value, "Address: insufficient balance for call");
274         (bool success, bytes memory returndata) = target.call{value: value}(data);
275         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
276     }
277 
278     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
279         return functionStaticCall(target, data, "Address: low-level static call failed");
280     }
281 
282     function functionStaticCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal view returns (bytes memory) {
287         (bool success, bytes memory returndata) = target.staticcall(data);
288         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
289     }
290 
291     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
293     }
294 
295     function functionDelegateCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         (bool success, bytes memory returndata) = target.delegatecall(data);
301         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
302     }
303 
304     function verifyCallResultFromTarget(
305         address target,
306         bool success,
307         bytes memory returndata,
308         string memory errorMessage
309     ) internal view returns (bytes memory) {
310         if (success) {
311             if (returndata.length == 0) {
312                 // only check isContract if the call was successful and the return data is empty
313                 // otherwise we already know that it was a contract
314                 require(isContract(target), "Address: call to non-contract");
315             }
316             return returndata;
317         } else {
318             _revert(returndata, errorMessage);
319         }
320     }
321 
322     function verifyCallResult(
323         bool success,
324         bytes memory returndata,
325         string memory errorMessage
326     ) internal pure returns (bytes memory) {
327         if (success) {
328             return returndata;
329         } else {
330             _revert(returndata, errorMessage);
331         }
332     }
333 
334     function _revert(bytes memory returndata, string memory errorMessage) private pure {
335         // Look for revert reason and bubble it up if present
336         if (returndata.length > 0) {
337             // The easiest way to bubble the revert reason is using memory via assembly
338             /// @solidity memory-safe-assembly
339             assembly {
340                 let returndata_size := mload(returndata)
341                 revert(add(32, returndata), returndata_size)
342             }
343         } else {
344             revert(errorMessage);
345         }
346     }
347 }
348 
349 abstract contract Context {
350     function _msgSender() internal view virtual returns (address) {
351         return msg.sender;
352     }
353 
354     function _msgData() internal view virtual returns (bytes calldata) {
355         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
356         return msg.data;
357     }
358 }
359 
360 abstract contract Ownable is Context {
361     address private _owner;
362 
363     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
364 
365     constructor () {
366         address msgSender = _msgSender();
367         _owner = msgSender;
368         emit OwnershipTransferred(address(0), msgSender);
369     }
370 
371     function owner() public view returns (address) {
372         return _owner;
373     }
374 
375     modifier onlyOwner() {
376         require(_owner == _msgSender(), "Ownable: caller is not the owner");
377         _;
378     }
379 
380     function renounceOwnership() public virtual onlyOwner {
381         emit OwnershipTransferred(_owner, address(0));
382         _owner = address(0);
383     }
384 
385     function transferOwnership(address newOwner) public virtual onlyOwner {
386         require(newOwner != address(0), "Ownable: new owner is the zero address");
387         emit OwnershipTransferred(_owner, newOwner);
388         _owner = newOwner;
389     }
390 }
391 
392 contract ERC20 is Context, IERC20, IERC20Metadata {
393     mapping(address => uint256) private _balances;
394 
395     mapping(address => mapping(address => uint256)) private _allowances;
396 
397     uint256 private _totalSupply;
398 
399     string private _name;
400     string private _symbol;
401 
402     constructor(string memory name_, string memory symbol_) {
403         _name = name_;
404         _symbol = symbol_;
405     }
406 
407     function name() public view virtual override returns (string memory) {
408         return _name;
409     }
410 
411     function symbol() public view virtual override returns (string memory) {
412         return _symbol;
413     }
414 
415     function decimals() public view virtual override returns (uint8) {
416         return 18;
417     }
418 
419     function totalSupply() public view virtual override returns (uint256) {
420         return _totalSupply;
421     }
422 
423     function balanceOf(address account) public view virtual override returns (uint256) {
424         return _balances[account];
425     }
426 
427     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     function allowance(address owner, address spender) public view virtual override returns (uint256) {
433         return _allowances[owner][spender];
434     }
435 
436     function approve(address spender, uint256 amount) public virtual override returns (bool) {
437         _approve(_msgSender(), spender, amount);
438         return true;
439     }
440 
441     function transferFrom(
442         address sender,
443         address recipient,
444         uint256 amount
445     ) public virtual override returns (bool) {
446         uint256 currentAllowance = _allowances[sender][_msgSender()];
447         if (currentAllowance != type(uint256).max) {
448             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
449             unchecked {
450                 _approve(sender, _msgSender(), currentAllowance - amount);
451             }
452         }
453 
454         _transfer(sender, recipient, amount);
455 
456         return true;
457     }
458 
459     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
461         return true;
462     }
463 
464     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
465         uint256 currentAllowance = _allowances[_msgSender()][spender];
466         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
467         unchecked {
468             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
469         }
470 
471         return true;
472     }
473 
474     function _transfer(
475         address sender,
476         address recipient,
477         uint256 amount
478     ) internal virtual {
479         require(sender != address(0), "ERC20: transfer from the zero address");
480         require(recipient != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(sender, recipient, amount);
483 
484         uint256 senderBalance = _balances[sender];
485         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
486         unchecked {
487             _balances[sender] = senderBalance - amount;
488         }
489         _balances[recipient] += amount;
490 
491         emit Transfer(sender, recipient, amount);
492 
493         _afterTokenTransfer(sender, recipient, amount);
494     }
495 
496     function _mint(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: mint to the zero address");
498 
499         _beforeTokenTransfer(address(0), account, amount);
500 
501         _totalSupply += amount;
502         _balances[account] += amount;
503         emit Transfer(address(0), account, amount);
504 
505         _afterTokenTransfer(address(0), account, amount);
506     }
507 
508     function _burn(address account, uint256 amount) internal virtual {
509         require(account != address(0), "ERC20: burn from the zero address");
510 
511         _beforeTokenTransfer(account, address(0), amount);
512 
513         uint256 accountBalance = _balances[account];
514         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
515         unchecked {
516             _balances[account] = accountBalance - amount;
517         }
518         _totalSupply -= amount;
519 
520         emit Transfer(account, address(0), amount);
521 
522         _afterTokenTransfer(account, address(0), amount);
523     }
524 
525     function _approve(
526         address owner,
527         address spender,
528         uint256 amount
529     ) internal virtual {
530         require(owner != address(0), "ERC20: approve from the zero address");
531         require(spender != address(0), "ERC20: approve to the zero address");
532 
533         _allowances[owner][spender] = amount;
534         emit Approval(owner, spender, amount);
535     }
536 
537     function _beforeTokenTransfer(
538         address from,
539         address to,
540         uint256 amount
541     ) internal virtual {}
542 
543     function _afterTokenTransfer(
544         address from,
545         address to,
546         uint256 amount
547     ) internal virtual {}
548 }
549 
550 contract Spider is ERC20, Ownable {
551     using Address for address payable;
552 
553     IUniswapV2Router02 public uniswapV2Router;
554     address public  uniswapV2Pair;
555 
556     mapping (address => bool) private _isExcludedFromFees;
557 
558     string  public creator;
559 
560     constructor () ERC20("Spider Man", "Spider") 
561     {   
562         address router;
563         if (block.chainid == 56) {
564             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
565         } else if (block.chainid == 97) {
566             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
567         } else if (block.chainid == 1 || block.chainid == 5) {
568             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
569         } else {
570             revert();
571         }
572 
573         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
574         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
575             .createPair(address(this), _uniswapV2Router.WETH());
576 
577         uniswapV2Router = _uniswapV2Router;
578         uniswapV2Pair   = _uniswapV2Pair;
579 
580         _approve(address(this), address(uniswapV2Router), type(uint256).max);
581 
582         creator = "coinsult.net";
583 
584         _isExcludedFromFees[owner()] = true;
585         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
586 
587         _mint(owner(), 420_690_000_000_000 * (10 ** decimals()));
588     }
589 
590     receive() external payable {
591 
592     }
593 
594     function claimStuckTokens(address token) external onlyOwner {
595         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
596         if (token == address(0x0)) {
597             payable(msg.sender).sendValue(address(this).balance);
598             return;
599         }
600         IERC20 ERC20token = IERC20(token);
601         uint256 balance = ERC20token.balanceOf(address(this));
602         ERC20token.transfer(msg.sender, balance);
603     }
604 
605     function excludeFromFees(address account, bool excluded) external onlyOwner{
606         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
607         _isExcludedFromFees[account] = excluded;
608     }
609 
610     function isExcludedFromFees(address account) public view returns(bool) {
611         return _isExcludedFromFees[account];
612     }
613 
614     bool public tradingEnabled;
615 
616     function enableTrading() external onlyOwner{
617         require(!tradingEnabled, "Trading already enabled.");
618         tradingEnabled = true;
619     }
620 
621     function _transfer(address from,address to,uint256 amount) internal  override {
622         require(from != address(0), "ERC20: transfer from the zero address");
623         require(to != address(0), "ERC20: transfer to the zero address");
624         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
625        
626         if (amount == 0) {
627             super._transfer(from, to, 0);
628             return;
629         }
630 
631         super._transfer(from, to, amount);
632     }
633 }