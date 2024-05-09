1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.18;
4 
5 
6 
7 
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a + b;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a - b;
25     }
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a * b;
28     }
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         return a / b;
31     }
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         unchecked {
34             require(b <= a, errorMessage);
35             return a - b;
36         }
37     }
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         unchecked {
40             require(b > 0, errorMessage);
41             return a / b;
42         }
43     }
44 }
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49     function _msgData() internal view virtual returns (bytes calldata) {
50         this; 
51         return msg.data;
52     }
53 }
54 library Address {
55     function isContract(address account) internal view returns (bool) {
56         uint256 size;
57         assembly { size := extcodesize(account) }
58         return size > 0;
59     }
60     function sendValue(address payable recipient, uint256 amount) internal {
61         require(address(this).balance >= amount, "Address: insufficient balance");
62         (bool success, ) = recipient.call{ value: amount }("");
63         require(success, "Address: unable to send value, recipient may have reverted");
64     }
65     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
66       return functionCall(target, data, "Address: low-level call failed");
67     }
68     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
69         return functionCallWithValue(target, data, 0, errorMessage);
70     }
71     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
72         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
73     }
74     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
75         require(address(this).balance >= value, "Address: insufficient balance for call");
76         require(isContract(target), "Address: call to non-contract");
77         (bool success, bytes memory returndata) = target.call{ value: value }(data);
78         return _verifyCallResult(success, returndata, errorMessage);
79     }
80     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
81         return functionStaticCall(target, data, "Address: low-level static call failed");
82     }
83     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
84         require(isContract(target), "Address: static call to non-contract");
85         (bool success, bytes memory returndata) = target.staticcall(data);
86         return _verifyCallResult(success, returndata, errorMessage);
87     }
88     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
90     }
91     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         require(isContract(target), "Address: delegate call to non-contract");
93         (bool success, bytes memory returndata) = target.delegatecall(data);
94         return _verifyCallResult(success, returndata, errorMessage);
95     }
96     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
97         if (success) {
98             return returndata;
99         } else {
100             if (returndata.length > 0) {
101                  assembly {
102                     let returndata_size := mload(returndata)
103                     revert(add(32, returndata), returndata_size)
104                 }
105             } else {
106                 revert(errorMessage);
107             }
108         }
109     }
110 }
111 interface IUniswapV2Factory {
112     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
113     function feeTo() external view returns (address);
114     function feeToSetter() external view returns (address);
115     function getPair(address tokenA, address tokenB) external view returns (address pair);
116     function allPairs(uint) external view returns (address pair);
117     function allPairsLength() external view returns (uint);
118     function createPair(address tokenA, address tokenB) external returns (address pair);
119     function setFeeTo(address) external;
120     function setFeeToSetter(address) external;
121 }
122 interface IUniswapV2Pair {
123     event Approval(address indexed owner, address indexed spender, uint value);
124     event Transfer(address indexed from, address indexed to, uint value);
125     function name() external pure returns (string memory);
126     function symbol() external pure returns (string memory);
127     function decimals() external pure returns (uint8);
128     function totalSupply() external view returns (uint);
129     function balanceOf(address owner) external view returns (uint);
130     function allowance(address owner, address spender) external view returns (uint);
131     function approve(address spender, uint value) external returns (bool);
132     function transfer(address to, uint value) external returns (bool);
133     function transferFrom(address from, address to, uint value) external returns (bool);
134     function DOMAIN_SEPARATOR() external view returns (bytes32);
135     function PERMIT_TYPEHASH() external pure returns (bytes32);
136     function nonces(address owner) external view returns (uint);
137     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
138     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
139     event Swap(
140         address indexed sender,
141         uint amount0In,
142         uint amount1In,
143         uint amount0Out,
144         uint amount1Out,
145         address indexed to
146     );
147     event Sync(uint112 reserve0, uint112 reserve1);
148     function MINIMUM_LIQUIDITY() external pure returns (uint);
149     function factory() external view returns (address);
150     function token0() external view returns (address);
151     function token1() external view returns (address);
152     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
153     function price0CumulativeLast() external view returns (uint);
154     function price1CumulativeLast() external view returns (uint);
155     function kLast() external view returns (uint);
156     function burn(address to) external returns (uint amount0, uint amount1);
157     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
158     function skim(address to) external;
159     function sync() external;
160     function initialize(address, address) external;
161 }
162 interface IUniswapV2Router01 {
163     function factory() external pure returns (address);
164     function WETH() external pure returns (address);
165     function addLiquidity(
166         address tokenA,
167         address tokenB,
168         uint amountADesired,
169         uint amountBDesired,
170         uint amountAMin,
171         uint amountBMin,
172         address to,
173         uint deadline
174     ) external returns (uint amountA, uint amountB, uint liquidity);
175     function addLiquidityETH(
176         address token,
177         uint amountTokenDesired,
178         uint amountTokenMin,
179         uint amountETHMin,
180         address to,
181         uint deadline
182     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
183     function removeLiquidity(
184         address tokenA,
185         address tokenB,
186         uint liquidity,
187         uint amountAMin,
188         uint amountBMin,
189         address to,
190         uint deadline
191     ) external returns (uint amountA, uint amountB);
192     function removeLiquidityETH(
193         address token,
194         uint liquidity,
195         uint amountTokenMin,
196         uint amountETHMin,
197         address to,
198         uint deadline
199     ) external returns (uint amountToken, uint amountETH);
200     function removeLiquidityWithPermit(
201         address tokenA,
202         address tokenB,
203         uint liquidity,
204         uint amountAMin,
205         uint amountBMin,
206         address to,
207         uint deadline,
208         bool approveMax, uint8 v, bytes32 r, bytes32 s
209     ) external returns (uint amountA, uint amountB);
210     function removeLiquidityETHWithPermit(
211         address token,
212         uint liquidity,
213         uint amountTokenMin,
214         uint amountETHMin,
215         address to,
216         uint deadline,
217         bool approveMax, uint8 v, bytes32 r, bytes32 s
218     ) external returns (uint amountToken, uint amountETH);
219     function swapExactTokensForTokens(
220         uint amountIn,
221         uint amountOutMin,
222         address[] calldata path,
223         address to,
224         uint deadline
225     ) external returns (uint[] memory amounts);
226     function swapTokensForExactTokens(
227         uint amountOut,
228         uint amountInMax,
229         address[] calldata path,
230         address to,
231         uint deadline
232     ) external returns (uint[] memory amounts);
233     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
234         external
235         payable
236         returns (uint[] memory amounts);
237     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
238         external
239         returns (uint[] memory amounts);
240     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
241         external
242         returns (uint[] memory amounts);
243     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
244         external
245         payable
246         returns (uint[] memory amounts);
247     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
248     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
249     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
250     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
251     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
252 }
253 interface IUniswapV2Router02 is IUniswapV2Router01 {
254     function removeLiquidityETHSupportingFeeOnTransferTokens(
255         address token,
256         uint liquidity,
257         uint amountTokenMin,
258         uint amountETHMin,
259         address to,
260         uint deadline
261     ) external returns (uint amountETH);
262     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
263         address token,
264         uint liquidity,
265         uint amountTokenMin,
266         uint amountETHMin,
267         address to,
268         uint deadline,
269         bool approveMax, uint8 v, bytes32 r, bytes32 s
270     ) external returns (uint amountETH);
271     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
272         uint amountIn,
273         uint amountOutMin,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external;
278     function swapExactETHForTokensSupportingFeeOnTransferTokens(
279         uint amountOutMin,
280         address[] calldata path,
281         address to,
282         uint deadline
283     ) external payable;
284     function swapExactTokensForETHSupportingFeeOnTransferTokens(
285         uint amountIn,
286         uint amountOutMin,
287         address[] calldata path,
288         address to,
289         uint deadline
290     ) external;
291 }
292 contract CRIP is Context, IERC20 { 
293     using SafeMath for uint256;
294     using Address for address;
295     address private _owner;
296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297     function owner() public view virtual returns (address) {
298         return _owner;
299     }
300     modifier whenNotPaused() {
301         require(!paused, "Pausable: paused");
302         _;
303     }
304      modifier whenPaused() {
305         require(paused, "Pausable: not paused");
306         _;
307     }
308     modifier onlyOwner() {
309         require(owner() == _msgSender(), "Ownable: caller is not the owner");
310         _;
311     }
312     function pause() public {
313         require(msg.sender == owner(), "Pausable: only owner can pause");
314         paused = true;
315     }
316     function renounceOwnership() public virtual {
317         emit OwnershipTransferred(_owner, address(0));
318         _owner = address(0);
319     }
320     mapping (address => bool) private _isBot;
321     mapping (address => uint256) private _tOwned;
322     mapping (address => mapping (address => uint256)) private _allowances;
323     mapping (address => bool) public _isExcludedFromFee; 
324     address payable public Wallet_Marketing = payable(0x8662DbFf781DfE5424B2D4d6b692De5c97D5D8FE); 
325     address payable public Wallet_Dev = payable(0xce523C516861d8734CAD87aa6d51e192efB1088F);
326     address payable public constant Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
327     uint256 private constant MAX = ~uint256(0);
328     uint8 private constant _decimals = 18;
329     uint256 private _tTotal =60000000 * 10**_decimals;
330     string private constant _name = "CRIP"; 
331     string private constant _symbol = unicode"CRIP"; 
332     uint8 private txCount = 0;
333     uint8 private swapTrigger = 3; 
334     uint256 public _Tax_On_Buy = 1;
335     uint256 public _Tax_On_Sell = 1;
336     uint256 public Percent_Marketing = 85;
337     uint256 public Percent_Dev = 5;
338     uint256 public Percent_Burn = 5;
339     uint256 public Percent_AutoLP = 5; 
340     uint256 public _maxWalletToken = _tTotal * 1 / 100;
341     uint256 private _previousMaxWalletToken = _maxWalletToken;
342     uint256 public _maxTxAmount = _tTotal * 1 / 100; 
343     uint256 private _previousMaxTxAmount = _maxTxAmount;
344     IUniswapV2Router02 public uniswapV2Router;
345     address public uniswapV2Pair;
346     bool public inSwapAndLiquify;
347     bool public swapAndLiquifyEnabled = true;
348     bool public paused = false;
349 
350     event SwapAndLiquifyEnabledUpdated(bool true_or_false);
351     event SwapAndLiquify(
352         uint256 tokensSwapped,
353         uint256 ethReceived,
354         uint256 tokensIntoLiqudity
355     );
356     modifier lockTheSwap {
357         inSwapAndLiquify = true;
358         _;
359         inSwapAndLiquify = false;
360     }
361     constructor () {
362         _owner =0x8662DbFf781DfE5424B2D4d6b692De5c97D5D8FE;
363         emit OwnershipTransferred(address(0), _owner);
364         _tOwned[owner()] = _tTotal;
365         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
366         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
367             .createPair(address(this), _uniswapV2Router.WETH());
368         uniswapV2Router = _uniswapV2Router;
369         _isExcludedFromFee[owner()] = true;
370         _isExcludedFromFee[address(this)] = true;
371         _isExcludedFromFee[Wallet_Marketing] = true; 
372         _isExcludedFromFee[Wallet_Burn] = true;
373         emit Transfer(address(0), owner(), _tTotal);
374     }
375 
376     function setAntibot(address account, bool state) external onlyOwner{
377         require(_isBot[account] != state, 'Value already set');
378         _isBot[account] = state;
379     }
380     
381     function bulkAntiBot(address[] memory accounts, bool state) external onlyOwner{
382         for(uint256 i = 0; i < accounts.length; i++){
383             _isBot[accounts[i]] = state;
384          }   
385      }
386 
387      function isBot(address account) public view returns(bool){
388         return _isBot[account];
389     }
390     function name() public pure returns (string memory) {
391         return _name;
392     }
393     function symbol() public pure returns (string memory) {
394         return _symbol;
395     }
396     function setTaxes(uint256 buyTax, uint256 sellTax) public onlyOwner {
397         _Tax_On_Buy = buyTax;
398         _Tax_On_Sell = sellTax;
399     }
400     function decimals() public pure returns (uint8) {
401         return _decimals;
402     }
403     function totalSupply() public view override returns (uint256) {
404         return _tTotal;
405     }
406     function balanceOf(address account) public view override returns (uint256) {
407         return _tOwned[account];
408     }
409     function transfer(address recipient, uint256 amount) public override returns (bool) {
410         _transfer(_msgSender(), recipient, amount);
411         return true;
412     }
413     function allowance(address theOwner, address theSpender) public view override returns (uint256) {
414         return _allowances[theOwner][theSpender];
415     }
416     function approve(address spender, uint256 amount) public override returns (bool) {
417         _approve(_msgSender(), spender, amount);
418         return true;
419     }
420     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
421         _transfer(sender, recipient, amount);
422         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
423         return true;
424     }
425     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
426         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
427         return true;
428     }
429     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
430         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
431         return true;
432     }
433     receive() external payable {}
434     function _getCurrentSupply() private view returns(uint256) {
435         return (_tTotal);
436     }
437     function _approve(address theOwner, address theSpender, uint256 amount) private {
438         require(theOwner != address(0) && theSpender != address(0), "ERR: zero address");
439         _allowances[theOwner][theSpender] = amount;
440         emit Approval(theOwner, theSpender, amount);
441     }
442     function _transfer(
443         address from,
444         address to,
445         uint256 amount
446     ) private {
447         if (to != owner() &&
448             to != Wallet_Burn &&
449             to != address(this) &&
450             to != uniswapV2Pair &&
451             from != owner()){
452             uint256 heldTokens = balanceOf(to);
453             require((heldTokens + amount) <= _maxWalletToken,"Over wallet limit.");}
454         if (from != owner())
455             require(amount <= _maxTxAmount, "Over transaction limit.");
456         require(from != address(0) && to != address(0), "ERR: Using 0 address!");
457         require(amount > 0, "Token value must be higher than zero."); 
458         require(!_isBot[from] && !_isBot[to], "You are a bot"); 
459         if(
460             txCount >= swapTrigger && 
461             !inSwapAndLiquify &&
462             from != uniswapV2Pair &&
463             swapAndLiquifyEnabled
464             )
465         {  
466             uint256 contractTokenBalance = balanceOf(address(this));
467             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
468             txCount = 0;
469             swapAndLiquify(contractTokenBalance);
470         }
471         bool takeFee = true;
472         bool isBuy;
473         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
474             takeFee = false;
475         } else {
476             if(from == uniswapV2Pair){
477                 isBuy = true;
478             }
479             txCount++;
480         }
481         _tokenTransfer(from, to, amount, takeFee, isBuy);
482     }
483     function sendToWallet(address payable wallet, uint256 amount) private {
484             wallet.transfer(amount);
485         }
486     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
487             uint256 tokens_to_Burn = contractTokenBalance * Percent_Burn / 100;
488             _tTotal = _tTotal - tokens_to_Burn;
489             _tOwned[Wallet_Burn] = _tOwned[Wallet_Burn] + tokens_to_Burn;
490             _tOwned[address(this)] = _tOwned[address(this)] - tokens_to_Burn; 
491             uint256 tokens_to_M = contractTokenBalance * Percent_Marketing / 100;
492             uint256 tokens_to_D = contractTokenBalance * Percent_Dev / 100;
493             uint256 tokens_to_LP_Half = contractTokenBalance * Percent_AutoLP / 200;
494             uint256 balanceBeforeSwap = address(this).balance;
495             swapTokensForETH(tokens_to_LP_Half + tokens_to_M + tokens_to_D);
496             uint256 ETH_Total = address(this).balance - balanceBeforeSwap;
497             uint256 split_M = Percent_Marketing * 100 / (Percent_AutoLP + Percent_Marketing + Percent_Dev);
498             uint256 ETH_M = ETH_Total * split_M / 100;
499             uint256 split_D = Percent_Dev * 100 / (Percent_AutoLP + Percent_Marketing + Percent_Dev);
500             uint256 ETH_D = ETH_Total * split_D / 100;
501             addLiquidity(tokens_to_LP_Half, (ETH_Total - ETH_M - ETH_D));
502             emit SwapAndLiquify(tokens_to_LP_Half, (ETH_Total - ETH_M - ETH_D), tokens_to_LP_Half);
503             sendToWallet(Wallet_Marketing, ETH_M);
504             ETH_Total = address(this).balance;
505             sendToWallet(Wallet_Dev, ETH_Total);
506             }
507     function swapTokensForETH(uint256 tokenAmount) private {
508         address[] memory path = new address[](2);
509         path[0] = address(this);
510         path[1] = uniswapV2Router.WETH();
511         _approve(address(this), address(uniswapV2Router), tokenAmount);
512         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
513             tokenAmount,
514             0, 
515             path,
516             address(this),
517             block.timestamp
518         );
519     }
520     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
521         _approve(address(this), address(uniswapV2Router), tokenAmount);
522         uniswapV2Router.addLiquidityETH{value: ETHAmount}(
523             address(this),
524             tokenAmount,
525             0, 
526             0,
527             Wallet_Burn, 
528             block.timestamp
529         );
530     } 
531     function remove_Random_Tokens(address random_Token_Address, uint256 percent_of_Tokens) public returns(bool _sent){
532         require(random_Token_Address != address(this), "Can not remove native token");
533         uint256 totalRandom = IERC20(random_Token_Address).balanceOf(address(this));
534         uint256 removeRandom = totalRandom*percent_of_Tokens/100;
535         _sent = IERC20(random_Token_Address).transfer(Wallet_Dev, removeRandom);
536     }
537     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isBuy) private {
538         if(!takeFee){
539             _tOwned[sender] = _tOwned[sender]-tAmount;
540             _tOwned[recipient] = _tOwned[recipient]+tAmount;
541             emit Transfer(sender, recipient, tAmount);
542             if(recipient == Wallet_Burn)
543             _tTotal = _tTotal-tAmount;
544             } else if (isBuy){
545             uint256 buyFEE = tAmount*_Tax_On_Buy/100;
546             uint256 tTransferAmount = tAmount-buyFEE;
547             _tOwned[sender] = _tOwned[sender]-tAmount;
548             _tOwned[recipient] = _tOwned[recipient]+tTransferAmount;
549             _tOwned[address(this)] = _tOwned[address(this)]+buyFEE;  
550             emit Transfer(sender, recipient, tTransferAmount);
551             if(recipient == Wallet_Burn)
552             _tTotal = _tTotal-tTransferAmount;
553             } else {
554             uint256 sellFEE = tAmount*_Tax_On_Sell/100;
555             uint256 tTransferAmount = tAmount-sellFEE;
556             _tOwned[sender] = _tOwned[sender]-tAmount;
557             _tOwned[recipient] = _tOwned[recipient]+tTransferAmount;
558             _tOwned[address(this)] = _tOwned[address(this)]+sellFEE;  
559             emit Transfer(sender, recipient, tTransferAmount);
560             if(recipient == Wallet_Burn)
561             _tTotal = _tTotal-tTransferAmount;
562             }
563     }
564 }