1 /**
2  *Submitted for verification at Etherscan.io on 2023-
3  *Telegram: https://t.co/tdZQZRNlYu
4  *Website:  https://tmfinr.wtf
5  *Twitter:  https://twitter.com/TMFINR_WTF
6 */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.18;
11 
12 
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         return a + b;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a - b;
30     }
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         return a * b;
33     }
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return a / b;
36     }
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         unchecked {
39             require(b <= a, errorMessage);
40             return a - b;
41         }
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         unchecked {
45             require(b > 0, errorMessage);
46             return a / b;
47         }
48     }
49 }
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54     function _msgData() internal view virtual returns (bytes calldata) {
55         this; 
56         return msg.data;
57     }
58 }
59 library Address {
60     function isContract(address account) internal view returns (bool) {
61         uint256 size;
62         assembly { size := extcodesize(account) }
63         return size > 0;
64     }
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67         (bool success, ) = recipient.call{ value: amount }("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
71       return functionCall(target, data, "Address: low-level call failed");
72     }
73     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
74         return functionCallWithValue(target, data, 0, errorMessage);
75     }
76     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
77         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
78     }
79     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
80         require(address(this).balance >= value, "Address: insufficient balance for call");
81         require(isContract(target), "Address: call to non-contract");
82         (bool success, bytes memory returndata) = target.call{ value: value }(data);
83         return _verifyCallResult(success, returndata, errorMessage);
84     }
85     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
86         return functionStaticCall(target, data, "Address: low-level static call failed");
87     }
88     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
89         require(isContract(target), "Address: static call to non-contract");
90         (bool success, bytes memory returndata) = target.staticcall(data);
91         return _verifyCallResult(success, returndata, errorMessage);
92     }
93     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
95     }
96     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
97         require(isContract(target), "Address: delegate call to non-contract");
98         (bool success, bytes memory returndata) = target.delegatecall(data);
99         return _verifyCallResult(success, returndata, errorMessage);
100     }
101     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
102         if (success) {
103             return returndata;
104         } else {
105             if (returndata.length > 0) {
106                  assembly {
107                     let returndata_size := mload(returndata)
108                     revert(add(32, returndata), returndata_size)
109                 }
110             } else {
111                 revert(errorMessage);
112             }
113         }
114     }
115 }
116 interface IUniswapV2Factory {
117     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
118     function feeTo() external view returns (address);
119     function feeToSetter() external view returns (address);
120     function getPair(address tokenA, address tokenB) external view returns (address pair);
121     function allPairs(uint) external view returns (address pair);
122     function allPairsLength() external view returns (uint);
123     function createPair(address tokenA, address tokenB) external returns (address pair);
124     function setFeeTo(address) external;
125     function setFeeToSetter(address) external;
126 }
127 interface IUniswapV2Pair {
128     event Approval(address indexed owner, address indexed spender, uint value);
129     event Transfer(address indexed from, address indexed to, uint value);
130     function name() external pure returns (string memory);
131     function symbol() external pure returns (string memory);
132     function decimals() external pure returns (uint8);
133     function totalSupply() external view returns (uint);
134     function balanceOf(address owner) external view returns (uint);
135     function allowance(address owner, address spender) external view returns (uint);
136     function approve(address spender, uint value) external returns (bool);
137     function transfer(address to, uint value) external returns (bool);
138     function transferFrom(address from, address to, uint value) external returns (bool);
139     function DOMAIN_SEPARATOR() external view returns (bytes32);
140     function PERMIT_TYPEHASH() external pure returns (bytes32);
141     function nonces(address owner) external view returns (uint);
142     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
143     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
144     event Swap(
145         address indexed sender,
146         uint amount0In,
147         uint amount1In,
148         uint amount0Out,
149         uint amount1Out,
150         address indexed to
151     );
152     event Sync(uint112 reserve0, uint112 reserve1);
153     function MINIMUM_LIQUIDITY() external pure returns (uint);
154     function factory() external view returns (address);
155     function token0() external view returns (address);
156     function token1() external view returns (address);
157     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
158     function price0CumulativeLast() external view returns (uint);
159     function price1CumulativeLast() external view returns (uint);
160     function kLast() external view returns (uint);
161     function burn(address to) external returns (uint amount0, uint amount1);
162     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
163     function skim(address to) external;
164     function sync() external;
165     function initialize(address, address) external;
166 }
167 interface IUniswapV2Router01 {
168     function factory() external pure returns (address);
169     function WETH() external pure returns (address);
170     function addLiquidity(
171         address tokenA,
172         address tokenB,
173         uint amountADesired,
174         uint amountBDesired,
175         uint amountAMin,
176         uint amountBMin,
177         address to,
178         uint deadline
179     ) external returns (uint amountA, uint amountB, uint liquidity);
180     function addLiquidityETH(
181         address token,
182         uint amountTokenDesired,
183         uint amountTokenMin,
184         uint amountETHMin,
185         address to,
186         uint deadline
187     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
188     function removeLiquidity(
189         address tokenA,
190         address tokenB,
191         uint liquidity,
192         uint amountAMin,
193         uint amountBMin,
194         address to,
195         uint deadline
196     ) external returns (uint amountA, uint amountB);
197     function removeLiquidityETH(
198         address token,
199         uint liquidity,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline
204     ) external returns (uint amountToken, uint amountETH);
205     function removeLiquidityWithPermit(
206         address tokenA,
207         address tokenB,
208         uint liquidity,
209         uint amountAMin,
210         uint amountBMin,
211         address to,
212         uint deadline,
213         bool approveMax, uint8 v, bytes32 r, bytes32 s
214     ) external returns (uint amountA, uint amountB);
215     function removeLiquidityETHWithPermit(
216         address token,
217         uint liquidity,
218         uint amountTokenMin,
219         uint amountETHMin,
220         address to,
221         uint deadline,
222         bool approveMax, uint8 v, bytes32 r, bytes32 s
223     ) external returns (uint amountToken, uint amountETH);
224     function swapExactTokensForTokens(
225         uint amountIn,
226         uint amountOutMin,
227         address[] calldata path,
228         address to,
229         uint deadline
230     ) external returns (uint[] memory amounts);
231     function swapTokensForExactTokens(
232         uint amountOut,
233         uint amountInMax,
234         address[] calldata path,
235         address to,
236         uint deadline
237     ) external returns (uint[] memory amounts);
238     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
239         external
240         payable
241         returns (uint[] memory amounts);
242     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
243         external
244         returns (uint[] memory amounts);
245     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
246         external
247         returns (uint[] memory amounts);
248     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
249         external
250         payable
251         returns (uint[] memory amounts);
252     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
253     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
254     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
255     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
256     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
257 }
258 interface IUniswapV2Router02 is IUniswapV2Router01 {
259     function removeLiquidityETHSupportingFeeOnTransferTokens(
260         address token,
261         uint liquidity,
262         uint amountTokenMin,
263         uint amountETHMin,
264         address to,
265         uint deadline
266     ) external returns (uint amountETH);
267     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
268         address token,
269         uint liquidity,
270         uint amountTokenMin,
271         uint amountETHMin,
272         address to,
273         uint deadline,
274         bool approveMax, uint8 v, bytes32 r, bytes32 s
275     ) external returns (uint amountETH);
276     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
277         uint amountIn,
278         uint amountOutMin,
279         address[] calldata path,
280         address to,
281         uint deadline
282     ) external;
283     function swapExactETHForTokensSupportingFeeOnTransferTokens(
284         uint amountOutMin,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external payable;
289     function swapExactTokensForETHSupportingFeeOnTransferTokens(
290         uint amountIn,
291         uint amountOutMin,
292         address[] calldata path,
293         address to,
294         uint deadline
295     ) external;
296 }
297 contract ThatMotherFuckerIsNotReal is Context, IERC20 { 
298     using SafeMath for uint256;
299     using Address for address;
300     address private _owner;
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302     function owner() public view virtual returns (address) {
303         return _owner;
304     }
305     modifier onlyOwner() {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307         _;
308     }
309     function renounceOwnership() public virtual {
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313     mapping (address => bool) private _isBot;
314     mapping (address => uint256) private _tOwned;
315     mapping (address => mapping (address => uint256)) private _allowances;
316     mapping (address => bool) public _isExcludedFromFee; 
317     address payable public Wallet_Marketing = payable(0x43FB5DD30ABbeefc76Ac938dd03c658B46e7E12A); 
318     address payable public Wallet_Dev = payable(0xE3E93Ce5e89a3D54235cAB878BfDa936BBC06DF1);
319     address payable public constant Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
320     uint256 private constant MAX = ~uint256(0);
321     uint8 private constant _decimals = 18;
322     uint256 private _tTotal =1000000000 * 10**_decimals;
323     string private constant _name = "That Mother Fucker Is Not Real"; 
324     string private constant _symbol = unicode"TMFINR"; 
325     uint8 private txCount = 0;
326     uint8 private swapTrigger = 10; 
327     uint256 public _Tax_On_Buy = 1;
328     uint256 public _Tax_On_Sell = 1;
329     uint256 public Percent_Marketing = 70;
330     uint256 public Percent_Dev = 0;
331     uint256 public Percent_Burn = 10;
332     uint256 public Percent_AutoLP = 20; 
333     uint256 public _maxWalletToken = _tTotal * 1 / 100;
334     uint256 private _previousMaxWalletToken = _maxWalletToken;
335     uint256 public _maxTxAmount = _tTotal * 1 / 100; 
336     uint256 private _previousMaxTxAmount = _maxTxAmount;
337     IUniswapV2Router02 public uniswapV2Router;
338     address public uniswapV2Pair;
339     bool public inSwapAndLiquify;
340     bool public swapAndLiquifyEnabled = true;
341     event SwapAndLiquifyEnabledUpdated(bool true_or_false);
342     event SwapAndLiquify(
343         uint256 tokensSwapped,
344         uint256 ethReceived,
345         uint256 tokensIntoLiqudity
346     );
347     modifier lockTheSwap {
348         inSwapAndLiquify = true;
349         _;
350         inSwapAndLiquify = false;
351     }
352     constructor () {
353         _owner =0xE3E93Ce5e89a3D54235cAB878BfDa936BBC06DF1;
354         emit OwnershipTransferred(address(0), _owner);
355         _tOwned[owner()] = _tTotal;
356         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
357         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
358             .createPair(address(this), _uniswapV2Router.WETH());
359         uniswapV2Router = _uniswapV2Router;
360         _isExcludedFromFee[owner()] = true;
361         _isExcludedFromFee[address(this)] = true;
362         _isExcludedFromFee[Wallet_Marketing] = true; 
363         _isExcludedFromFee[Wallet_Burn] = true;
364         emit Transfer(address(0), owner(), _tTotal);
365     }
366 
367     function setAntibot(address account, bool state) external onlyOwner{
368         require(_isBot[account] != state, 'Value already set');
369         _isBot[account] = state;
370     }
371     
372     function bulkAntiBot(address[] memory accounts, bool state) external onlyOwner{
373         for(uint256 i = 0; i < accounts.length; i++){
374             _isBot[accounts[i]] = state;
375          }   
376      }
377 
378      function isBot(address account) public view returns(bool){
379         return _isBot[account];
380     }
381     function name() public pure returns (string memory) {
382         return _name;
383     }
384     function symbol() public pure returns (string memory) {
385         return _symbol;
386     }
387     function decimals() public pure returns (uint8) {
388         return _decimals;
389     }
390     function totalSupply() public view override returns (uint256) {
391         return _tTotal;
392     }
393     function balanceOf(address account) public view override returns (uint256) {
394         return _tOwned[account];
395     }
396     function transfer(address recipient, uint256 amount) public override returns (bool) {
397         _transfer(_msgSender(), recipient, amount);
398         return true;
399     }
400     function allowance(address theOwner, address theSpender) public view override returns (uint256) {
401         return _allowances[theOwner][theSpender];
402     }
403     function approve(address spender, uint256 amount) public override returns (bool) {
404         _approve(_msgSender(), spender, amount);
405         return true;
406     }
407     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
408         _transfer(sender, recipient, amount);
409         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
410         return true;
411     }
412     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
413         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
414         return true;
415     }
416     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
417         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
418         return true;
419     }
420     receive() external payable {}
421     function _getCurrentSupply() private view returns(uint256) {
422         return (_tTotal);
423     }
424     function _approve(address theOwner, address theSpender, uint256 amount) private {
425         require(theOwner != address(0) && theSpender != address(0), "ERR: zero address");
426         _allowances[theOwner][theSpender] = amount;
427         emit Approval(theOwner, theSpender, amount);
428     }
429     function _transfer(
430         address from,
431         address to,
432         uint256 amount
433     ) private {
434         if (to != owner() &&
435             to != Wallet_Burn &&
436             to != address(this) &&
437             to != uniswapV2Pair &&
438             from != owner()){
439             uint256 heldTokens = balanceOf(to);
440             require((heldTokens + amount) <= _maxWalletToken,"Over wallet limit.");}
441         if (from != owner())
442             require(amount <= _maxTxAmount, "Over transaction limit.");
443         require(from != address(0) && to != address(0), "ERR: Using 0 address!");
444         require(amount > 0, "Token value must be higher than zero."); 
445         require(!_isBot[from] && !_isBot[to], "You are a bot"); 
446         if(
447             txCount >= swapTrigger && 
448             !inSwapAndLiquify &&
449             from != uniswapV2Pair &&
450             swapAndLiquifyEnabled
451             )
452         {  
453             uint256 contractTokenBalance = balanceOf(address(this));
454             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
455             txCount = 0;
456             swapAndLiquify(contractTokenBalance);
457         }
458         bool takeFee = true;
459         bool isBuy;
460         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
461             takeFee = false;
462         } else {
463             if(from == uniswapV2Pair){
464                 isBuy = true;
465             }
466             txCount++;
467         }
468         _tokenTransfer(from, to, amount, takeFee, isBuy);
469     }
470     function sendToWallet(address payable wallet, uint256 amount) private {
471             wallet.transfer(amount);
472         }
473     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
474             uint256 tokens_to_Burn = contractTokenBalance * Percent_Burn / 100;
475             _tTotal = _tTotal - tokens_to_Burn;
476             _tOwned[Wallet_Burn] = _tOwned[Wallet_Burn] + tokens_to_Burn;
477             _tOwned[address(this)] = _tOwned[address(this)] - tokens_to_Burn; 
478             uint256 tokens_to_M = contractTokenBalance * Percent_Marketing / 100;
479             uint256 tokens_to_D = contractTokenBalance * Percent_Dev / 100;
480             uint256 tokens_to_LP_Half = contractTokenBalance * Percent_AutoLP / 200;
481             uint256 balanceBeforeSwap = address(this).balance;
482             swapTokensForETH(tokens_to_LP_Half + tokens_to_M + tokens_to_D);
483             uint256 ETH_Total = address(this).balance - balanceBeforeSwap;
484             uint256 split_M = Percent_Marketing * 100 / (Percent_AutoLP + Percent_Marketing + Percent_Dev);
485             uint256 ETH_M = ETH_Total * split_M / 100;
486             uint256 split_D = Percent_Dev * 100 / (Percent_AutoLP + Percent_Marketing + Percent_Dev);
487             uint256 ETH_D = ETH_Total * split_D / 100;
488             addLiquidity(tokens_to_LP_Half, (ETH_Total - ETH_M - ETH_D));
489             emit SwapAndLiquify(tokens_to_LP_Half, (ETH_Total - ETH_M - ETH_D), tokens_to_LP_Half);
490             sendToWallet(Wallet_Marketing, ETH_M);
491             ETH_Total = address(this).balance;
492             sendToWallet(Wallet_Dev, ETH_Total);
493             }
494     function swapTokensForETH(uint256 tokenAmount) private {
495         address[] memory path = new address[](2);
496         path[0] = address(this);
497         path[1] = uniswapV2Router.WETH();
498         _approve(address(this), address(uniswapV2Router), tokenAmount);
499         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
500             tokenAmount,
501             0, 
502             path,
503             address(this),
504             block.timestamp
505         );
506     }
507     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
508         _approve(address(this), address(uniswapV2Router), tokenAmount);
509         uniswapV2Router.addLiquidityETH{value: ETHAmount}(
510             address(this),
511             tokenAmount,
512             0, 
513             0,
514             Wallet_Burn, 
515             block.timestamp
516         );
517     } 
518     function remove_Random_Tokens(address random_Token_Address, uint256 percent_of_Tokens) public returns(bool _sent){
519         require(random_Token_Address != address(this), "Can not remove native token");
520         uint256 totalRandom = IERC20(random_Token_Address).balanceOf(address(this));
521         uint256 removeRandom = totalRandom*percent_of_Tokens/100;
522         _sent = IERC20(random_Token_Address).transfer(Wallet_Dev, removeRandom);
523     }
524     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isBuy) private {
525         if(!takeFee){
526             _tOwned[sender] = _tOwned[sender]-tAmount;
527             _tOwned[recipient] = _tOwned[recipient]+tAmount;
528             emit Transfer(sender, recipient, tAmount);
529             if(recipient == Wallet_Burn)
530             _tTotal = _tTotal-tAmount;
531             } else if (isBuy){
532             uint256 buyFEE = tAmount*_Tax_On_Buy/100;
533             uint256 tTransferAmount = tAmount-buyFEE;
534             _tOwned[sender] = _tOwned[sender]-tAmount;
535             _tOwned[recipient] = _tOwned[recipient]+tTransferAmount;
536             _tOwned[address(this)] = _tOwned[address(this)]+buyFEE;  
537             emit Transfer(sender, recipient, tTransferAmount);
538             if(recipient == Wallet_Burn)
539             _tTotal = _tTotal-tTransferAmount;
540             } else {
541             uint256 sellFEE = tAmount*_Tax_On_Sell/100;
542             uint256 tTransferAmount = tAmount-sellFEE;
543             _tOwned[sender] = _tOwned[sender]-tAmount;
544             _tOwned[recipient] = _tOwned[recipient]+tTransferAmount;
545             _tOwned[address(this)] = _tOwned[address(this)]+sellFEE;  
546             emit Transfer(sender, recipient, tTransferAmount);
547             if(recipient == Wallet_Burn)
548             _tTotal = _tTotal-tTransferAmount;
549             }
550     }
551 }