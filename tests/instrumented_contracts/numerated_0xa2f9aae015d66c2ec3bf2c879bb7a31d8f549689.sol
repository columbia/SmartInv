1 // SPDX-License-Identifier: Unlicensed
2 
3 /*
4  TG: https://t.me/purgeentry
5  Twitter: https://twitter.com/thepurgetoken/
6  Web: thepurge.tech
7 */
8 
9 pragma solidity 0.8.21;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 /**
18  * Standard SafeMath, stripped down to just add/sub/mul/div
19  */
20 library SafeMath {
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24 
25         return c;
26     }
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         require(b <= a, errorMessage);
32         uint256 c = a - b;
33 
34         return c;
35     }
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43 
44         return c;
45     }
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 }
58 
59 /**
60  * ERC20 standard interface.
61  */
62 interface IERC20 {
63     function totalSupply() external view returns (uint256);
64     function decimals() external view returns (uint8);
65     function symbol() external view returns (string memory);
66     function name() external view returns (string memory);
67     function getOwner() external view returns (address);
68     function balanceOf(address account) external view returns (uint256);
69     function transfer(address recipient, uint256 amount) external returns (bool);
70     function allowance(address _owner, address spender) external view returns (uint256);
71     function approve(address spender, uint256 amount) external returns (bool);
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 abstract contract Ownable is Context {
78     address private _owner;
79 
80     event OwnershipTransferred(
81         address indexed previousOwner,
82         address indexed newOwner
83     );
84 
85     /**
86      * @dev Initializes the contract setting the deployer as the initial owner.
87      */
88     constructor() {
89         _transferOwnership(_msgSender());
90     }
91 
92     /**
93      * @dev Returns the address of the current owner.
94      */
95     function owner() public view virtual returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(owner() == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public virtual onlyOwner {
115         _transferOwnership(address(0));
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Can only be called by the current owner.
121      */
122     function transferOwnership(address newOwner) public virtual onlyOwner {
123         require(
124             newOwner != address(0),
125             "Ownable: new owner is the zero address"
126         );
127         _transferOwnership(newOwner);
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Internal function without access restriction.
133      */
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 interface IDEXFactory {
142     function createPair(address tokenA, address tokenB) external returns (address pair);
143 }
144 
145 interface IDEXRouter {
146     function factory() external pure returns (address);
147     function WETH() external pure returns (address);
148 
149     function addLiquidity(
150         address tokenA,
151         address tokenB,
152         uint amountADesired,
153         uint amountBDesired,
154         uint amountAMin,
155         uint amountBMin,
156         address to,
157         uint deadline
158     ) external returns (uint amountA, uint amountB, uint liquidity);
159 
160     function addLiquidityETH(
161         address token,
162         uint amountTokenDesired,
163         uint amountTokenMin,
164         uint amountETHMin,
165         address to,
166         uint deadline
167     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
168 
169     function swapExactETHForTokensSupportingFeeOnTransferTokens(
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external payable;
175 
176     function swapExactTokensForETHSupportingFeeOnTransferTokens(
177         uint amountIn,
178         uint amountOutMin,
179         address[] calldata path,
180         address to,
181         uint deadline
182     ) external;
183 }
184 
185 contract purge is IERC20, Ownable {
186     using SafeMath for uint256;
187 
188     string private constant _name = "The Purge";
189     string private constant _symbol = "PURGE";
190     uint8 private constant _decimals = 18;
191     
192     uint256 private _totalSupply = 100_000_000 * (10 ** _decimals);
193 
194     mapping(address => uint256) private _balances;
195     mapping(address => mapping(address => uint256)) private _allowances;
196     mapping (address => uint256) private cooldown;
197 
198     address private WETH;
199     address DEAD = 0x000000000000000000000000000000000000dEaD;
200     address ZERO = 0x0000000000000000000000000000000000000000;
201 
202     bool public antiBot = true;
203 
204     mapping (address => bool) private bots; 
205     mapping (address => bool) public isFeeExempt;
206     mapping (address => bool) public isTxLimitExempt;
207 
208     uint256 public launchedAt;
209     address private lpWallet = DEAD;
210 
211     uint256 public buyFee = 40;
212     uint256 public sellPurgeFee = 60;
213     uint256 public sellNormalFee = 2;
214 
215     mapping (address => uint256) public lastTxTimestamp;
216 
217     uint256 public toLiquidity = 10;
218     uint256 public toDev = 80;
219     uint256 public toBurn = 10;
220 
221     uint256 private feeSum = 100;
222 
223     IDEXRouter public router;
224     address public pair;
225     address public factory;
226     address private tokenOwner;
227     address public devWallet = payable(0xd98887FfaF5BBCda72cDB29c030Bd8B0cC17099D);
228 
229     bool inSwapAndLiquify;
230     bool public swapAndLiquifyEnabled = true;
231     bool public tradingOpen = false;
232 
233     modifier lockTheSwap {
234         inSwapAndLiquify = true;
235         _;
236         inSwapAndLiquify = false;
237     }
238 
239     uint256 public maxTx = _totalSupply.div(1000);
240     uint256 public maxWallet = _totalSupply.div(1000);
241     uint256 public swapThreshold = _totalSupply.div(500);
242 
243     constructor () {
244         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
245             
246         WETH = router.WETH();
247         
248         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
249         
250         _allowances[address(this)][address(router)] = type(uint256).max;
251         
252         isFeeExempt[owner()] = true;
253         isFeeExempt[devWallet] = true;             
254 
255         isTxLimitExempt[owner()] = true;
256         isTxLimitExempt[devWallet] = true;
257         isTxLimitExempt[pair] = true;
258         isTxLimitExempt[DEAD] = true;    
259 
260         _balances[owner()] = _totalSupply;
261     
262         emit Transfer(address(0), owner(), _totalSupply);
263     }
264 
265     receive() external payable { }
266 
267     function setBots(address[] memory bots_) external onlyOwner {
268         for (uint i = 0; i < bots_.length; i++) {
269             bots[bots_[i]] = true;
270         }
271     }
272     
273     //once enabled, cannot be reversed
274     function openTrading() external onlyOwner {
275         launchedAt = block.number;
276         tradingOpen = true;
277     }      
278 
279     function changeBuyFees(uint256 newBuyFee) external onlyOwner {
280         buyFee = newBuyFee;
281     }
282 
283     function changeSellFees(uint256 newSellPurgeFee, uint256 newSellNormallFee) external onlyOwner {
284         sellPurgeFee = newSellPurgeFee;
285         sellNormalFee = newSellNormallFee;
286     } 
287     
288     function changeFeeAllocation(uint256 newDevFee, uint256 newLpFee) external onlyOwner {
289         toDev = newDevFee;
290         toLiquidity = newLpFee;
291     }
292 
293     function updateDevWallet (address newDevWallet) external onlyOwner {
294         devWallet = newDevWallet;
295     }
296 
297     function changeTxLimit(uint256 newLimit) external onlyOwner {
298         maxTx = newLimit;
299     }
300 
301     function changeWalletLimit(uint256 newLimit) external onlyOwner {
302         maxWallet  = newLimit;
303     }
304     
305     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
306         isFeeExempt[holder] = exempt;
307     }
308 
309     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
310         isTxLimitExempt[holder] = exempt;
311     }
312 
313     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
314         swapAndLiquifyEnabled  = enableSwapBack;
315         swapThreshold = newSwapBackLimit;
316     }
317 
318     function delBot(address notbot) external onlyOwner {
319         bots[notbot] = false;
320     }
321 
322     function getCirculatingSupply() public view returns (uint256) {
323         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
324     }
325 
326     function totalSupply() external view override returns (uint256) { return _totalSupply; }
327     function decimals() external pure override returns (uint8) { return _decimals; }
328     function symbol() external pure override returns (string memory) { return _symbol; }
329     function name() external pure override returns (string memory) { return _name; }
330     function getOwner() external view override returns (address) { return owner(); }
331     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
332     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
333     
334     function approve(address spender, uint256 amount) public override returns (bool) {
335         _allowances[msg.sender][spender] = amount;
336         emit Approval(msg.sender, spender, amount);
337         return true;
338     }
339 
340     function approveMax(address spender) external returns (bool) {
341         return approve(spender, type(uint256).max);
342     }
343 
344     function transfer(address recipient, uint256 amount) external override returns (bool) {
345         return _transfer(msg.sender, recipient, amount);
346     }
347 
348     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
349         if(_allowances[sender][msg.sender] != type(uint256).max){
350             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
351         }
352 
353         return _transfer(sender, recipient, amount);
354     }
355 
356     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
357         if (sender!= owner() && recipient!= owner()) require(tradingOpen, "patience is a virtue."); //transfers disabled before tradingActive
358         require(!bots[sender] && !bots[recipient]);
359 
360         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
361 
362         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
363 
364         if(!isTxLimitExempt[recipient] && antiBot)
365         {
366             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
367         }
368 
369         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
370 
371         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
372         
373         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
374         _balances[recipient] = _balances[recipient].add(finalAmount);
375 
376         emit Transfer(sender, recipient, finalAmount);
377         lastTxTimestamp[sender] = block.timestamp;
378         lastTxTimestamp[recipient] = block.timestamp;
379         return true;
380     }    
381 
382     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
383         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
384         _balances[recipient] = _balances[recipient].add(amount);
385         emit Transfer(sender, recipient, amount);
386         return true;
387     }  
388     
389     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
390         uint256 _sellTotalFees;
391         uint256 hodlTime = block.timestamp-lastTxTimestamp[sender];
392             if (hodlTime < 24 hours) {
393                 _sellTotalFees = sellPurgeFee;
394             }
395             else if (hodlTime > 24 hours) {
396                 _sellTotalFees = sellNormalFee;
397             }
398 
399         uint256 feeApplicable = pair == recipient ? _sellTotalFees : buyFee;
400         uint256 feeAmount = amount.mul(feeApplicable).div(100);
401 
402         _balances[address(this)] = _balances[address(this)].add(feeAmount);
403         emit Transfer(sender, address(this), feeAmount);
404 
405         return amount.sub(feeAmount);
406     } 
407     
408     function swapTokensForEth(uint256 tokenAmount) private {
409 
410         address[] memory path = new address[](2);
411         path[0] = address(this);
412         path[1] = router.WETH();
413 
414         approve(address(this), tokenAmount);
415 
416         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
417             tokenAmount,
418             0, // accept any amount of ETH
419             path,
420             address(this),
421             block.timestamp
422         );
423     }
424 
425     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
426         router.addLiquidityETH{value: ethAmount}(
427             address(this),
428             tokenAmount,
429             0,
430             0,
431             lpWallet,
432             block.timestamp
433         );
434     }
435 
436     function swapBack() internal lockTheSwap {
437         uint256 tokenBalance = _balances[address(this)];
438         uint256 tokensToBurn = tokenBalance.mul(toBurn).div(100);
439         uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);     
440         uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity).sub(tokensToBurn);
441         
442         swapTokensForEth(amountToSwap);
443 
444         IERC20(address(this)).transfer(DEAD, tokensToBurn);
445 
446         uint256 totalEthBalance = address(this).balance;
447         uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);
448         
449         if (tokensForLiquidity > 0){
450             addLiquidity(tokensForLiquidity, ethForLiquidity);
451         }
452 
453         if (totalEthBalance > 0){
454             payable(devWallet).transfer(address(this).balance);
455         }
456     }
457 
458     function manualSwapBack() external onlyOwner {
459         swapBack();
460     }
461 
462     function clearStuckEth() external onlyOwner {
463         uint256 contractETHBalance = address(this).balance;
464         if(contractETHBalance > 0){          
465             payable(address(devWallet)).transfer(contractETHBalance);
466         }
467     }
468 }