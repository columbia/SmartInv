1 // SPDX-License-Identifier: Unlicensed
2 
3 /**
4  * $Vala - Token of Power
5  *
6  * tokenofpower.xyz
7  * twitter.com/tokenofpowererc
8  * t.me/tokenofpower
9  *
10  * It all began with the forging of the Great Rings. 
11  * Three were given to the Elves; immortal, wisest and fairest of all beings.
12  * Seven, to the Dwarf Lords, great miners and craftsmen of the mountain halls. 
13  * And nine, nine rings were gifted to the race of Men, who above all else desire power.
14  * ...Another ring was made...One ring, to rule them all...
15  *
16  * As you commence on your journey, your quest for the almighty Æther shall be taxed according to the ring you hold.
17  * The ring you hold shall be determined by the length of time you've held your purse.  
18  *
19  *
20  * The Ring of Men: 0-2 hours - 9% sell tax
21  *
22  * The Ring of Dwarves: 2-12 hours - 7% sell tax
23  *
24  * The Ring of Elves: 12-24 hours - 3% sell tax
25  *
26  * The Ring of Power: after 24 hours - 1% sell tax
27  * 
28  * ALL buy tax - 1%
29  *
30  */
31 pragma solidity 0.8.13;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38 
39 /**
40  * Standard SafeMath, stripped down to just add/sub/mul/div
41  */
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55 
56         return c;
57     }
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         // Solidity only automatically asserts when dividing by 0
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 }
80 
81 /**
82  * ERC20 standard interface.
83  */
84 interface IERC20 {
85     function totalSupply() external view returns (uint256);
86     function decimals() external view returns (uint8);
87     function symbol() external view returns (string memory);
88     function name() external view returns (string memory);
89     function getOwner() external view returns (address);
90     function balanceOf(address account) external view returns (uint256);
91     function transfer(address recipient, uint256 amount) external returns (bool);
92     function allowance(address _owner, address spender) external view returns (uint256);
93     function approve(address spender, uint256 amount) external returns (bool);
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 abstract contract Ownable is Context {
100     address private _owner;
101 
102     event OwnershipTransferred(
103         address indexed previousOwner,
104         address indexed newOwner
105     );
106 
107     /**
108      * @dev Initializes the contract setting the deployer as the initial owner.
109      */
110     constructor() {
111         _transferOwnership(_msgSender());
112     }
113 
114     /**
115      * @dev Returns the address of the current owner.
116      */
117     function owner() public view virtual returns (address) {
118         return _owner;
119     }
120 
121     /**
122      * @dev Throws if called by any account other than the owner.
123      */
124     modifier onlyOwner() {
125         require(owner() == _msgSender(), "Ownable: caller is not the owner");
126         _;
127     }
128 
129     /**
130      * @dev Leaves the contract without owner. It will not be possible to call
131      * `onlyOwner` functions anymore. Can only be called by the current owner.
132      *
133      * NOTE: Renouncing ownership will leave the contract without an owner,
134      * thereby removing any functionality that is only available to the owner.
135      */
136     function renounceOwnership() public virtual onlyOwner {
137         _transferOwnership(address(0));
138     }
139 
140     /**
141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
142      * Can only be called by the current owner.
143      */
144     function transferOwnership(address newOwner) public virtual onlyOwner {
145         require(
146             newOwner != address(0),
147             "Ownable: new owner is the zero address"
148         );
149         _transferOwnership(newOwner);
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Internal function without access restriction.
155      */
156     function _transferOwnership(address newOwner) internal virtual {
157         address oldOwner = _owner;
158         _owner = newOwner;
159         emit OwnershipTransferred(oldOwner, newOwner);
160     }
161 }
162 
163 interface IDEXFactory {
164     function createPair(address tokenA, address tokenB) external returns (address pair);
165 }
166 
167 interface IDEXRouter {
168     function factory() external pure returns (address);
169     function WETH() external pure returns (address);
170 
171     function addLiquidity(
172         address tokenA,
173         address tokenB,
174         uint amountADesired,
175         uint amountBDesired,
176         uint amountAMin,
177         uint amountBMin,
178         address to,
179         uint deadline
180     ) external returns (uint amountA, uint amountB, uint liquidity);
181 
182     function addLiquidityETH(
183         address token,
184         uint amountTokenDesired,
185         uint amountTokenMin,
186         uint amountETHMin,
187         address to,
188         uint deadline
189     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
190 
191     function swapExactETHForTokensSupportingFeeOnTransferTokens(
192         uint amountOutMin,
193         address[] calldata path,
194         address to,
195         uint deadline
196     ) external payable;
197 
198     function swapExactTokensForETHSupportingFeeOnTransferTokens(
199         uint amountIn,
200         uint amountOutMin,
201         address[] calldata path,
202         address to,
203         uint deadline
204     ) external;
205 }
206 
207 contract Valar is IERC20, Ownable {
208     using SafeMath for uint256;
209 
210     string private constant _name = "Token of Power";
211     string private constant _symbol = "Valar";
212     uint8 private constant _decimals = 18;
213     
214     uint256 private _totalSupply = 1_000_000 * (10 ** _decimals);
215 
216     mapping(address => uint256) private _balances;
217     mapping(address => mapping(address => uint256)) private _allowances;
218     mapping (address => uint256) private cooldown;
219 
220     address private WETH;
221     address DEAD = 0x000000000000000000000000000000000000dEaD;
222     address ZERO = 0x0000000000000000000000000000000000000000;
223 
224     bool public antiBot = true;
225 
226     mapping (address => bool) private bots; 
227     mapping (address => bool) public isFeeExempt;
228     mapping (address => bool) public isTxLimitExempt;
229 
230     uint256 public launchedAt;
231     address private lpWallet = DEAD;
232 
233     uint256 public buyFee = 1;
234     uint256 public sellFeeMen = 9;
235     uint256 public sellFeeDwarves = 7;
236     uint256 public sellFeeElves = 3;
237     uint256 public sellFeeGreatRing = 1;
238 
239     mapping (address => uint256) public lastTxTimestamp;
240 
241     uint256 public toLiquidity = 20;
242     uint256 public toDev = 80;
243 
244     uint256 private feeSum = 100;
245 
246     IDEXRouter public router;
247     address public pair;
248     address public factory;
249     address private tokenOwner;
250     address public devWallet = payable(0x8162739A254f676390e116e2f0dE2aBA3867CB6f);
251 
252     bool inSwapAndLiquify;
253     bool public swapAndLiquifyEnabled = true;
254     bool public tradingOpen = false;
255 
256     modifier lockTheSwap {
257         inSwapAndLiquify = true;
258         _;
259         inSwapAndLiquify = false;
260     }
261 
262     uint256 public maxTx = _totalSupply.div(100);
263     uint256 public maxWallet = _totalSupply.div(100);
264     uint256 public swapThreshold = _totalSupply.div(400);
265 
266     constructor () {
267         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
268             
269         WETH = router.WETH();
270         
271         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
272         
273         _allowances[address(this)][address(router)] = type(uint256).max;
274         
275         isFeeExempt[owner()] = true;
276         isFeeExempt[devWallet] = true;             
277 
278         isTxLimitExempt[owner()] = true;
279         isTxLimitExempt[devWallet] = true;
280         isTxLimitExempt[pair] = true;
281         isTxLimitExempt[DEAD] = true;    
282 
283         _balances[owner()] = _totalSupply;
284     
285         emit Transfer(address(0), owner(), _totalSupply);
286     }
287 
288     receive() external payable { }
289 
290     function setBots(address[] memory bots_) external onlyOwner {
291         for (uint i = 0; i < bots_.length; i++) {
292             bots[bots_[i]] = true;
293         }
294     }
295     
296     //once enabled, cannot be reversed
297     function openTrading() external onlyOwner {
298         launchedAt = block.number;
299         tradingOpen = true;
300     }      
301 
302 
303     function changeTotalFees(uint256 newBuyFee, uint256 newSellFeeMen, uint256 newSellFeeDwarves, uint256 newSellFeeElves, uint256 newSellFeeGreatRing) external onlyOwner {
304         buyFee = newBuyFee;
305         sellFeeMen = newSellFeeMen;
306         sellFeeDwarves = newSellFeeDwarves;
307         sellFeeElves = newSellFeeElves;
308         sellFeeGreatRing = newSellFeeGreatRing;
309     } 
310     
311     function changeFeeAllocation(uint256 newDevFee, uint256 newLpFee) external onlyOwner {
312         toDev = newDevFee;
313         toLiquidity = newLpFee;
314     }
315 
316     function updateDevWallet (address newDevWallet) external onlyOwner {
317         devWallet = newDevWallet;
318     }
319 
320     function changeTxLimit(uint256 newLimit) external onlyOwner {
321         maxTx = newLimit;
322     }
323 
324     function changeWalletLimit(uint256 newLimit) external onlyOwner {
325         maxWallet  = newLimit;
326     }
327     
328     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
329         isFeeExempt[holder] = exempt;
330     }
331 
332     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {      
333         isTxLimitExempt[holder] = exempt;
334     }
335 
336     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
337         swapAndLiquifyEnabled  = enableSwapBack;
338         swapThreshold = newSwapBackLimit;
339     }
340 
341     function delBot(address notbot) external onlyOwner {
342         bots[notbot] = false;
343     }
344 
345     function getCirculatingSupply() public view returns (uint256) {
346         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
347     }
348 
349     function totalSupply() external view override returns (uint256) { return _totalSupply; }
350     function decimals() external pure override returns (uint8) { return _decimals; }
351     function symbol() external pure override returns (string memory) { return _symbol; }
352     function name() external pure override returns (string memory) { return _name; }
353     function getOwner() external view override returns (address) { return owner(); }
354     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
355     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
356     
357     function approve(address spender, uint256 amount) public override returns (bool) {
358         _allowances[msg.sender][spender] = amount;
359         emit Approval(msg.sender, spender, amount);
360         return true;
361     }
362 
363     function approveMax(address spender) external returns (bool) {
364         return approve(spender, type(uint256).max);
365     }
366 
367     function transfer(address recipient, uint256 amount) external override returns (bool) {
368         return _transfer(msg.sender, recipient, amount);
369     }
370 
371     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
372         if(_allowances[sender][msg.sender] != type(uint256).max){
373             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
374         }
375 
376         return _transfer(sender, recipient, amount);
377     }
378 
379     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
380         if (sender!= owner() && recipient!= owner()) require(tradingOpen, "patience is a virtue."); //transfers disabled before tradingActive
381         require(!bots[sender] && !bots[recipient]);
382 
383         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
384 
385         require(amount <= maxTx || isTxLimitExempt[sender], "tx");
386 
387         if(!isTxLimitExempt[recipient] && antiBot)
388         {
389             require(_balances[recipient].add(amount) <= maxWallet, "wallet");
390         }
391 
392         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
393 
394         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
395         
396         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
397         _balances[recipient] = _balances[recipient].add(finalAmount);
398 
399         emit Transfer(sender, recipient, finalAmount);
400         lastTxTimestamp[sender] = block.timestamp;
401         lastTxTimestamp[recipient] = block.timestamp;
402         return true;
403     }    
404 
405     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
406         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
407         _balances[recipient] = _balances[recipient].add(amount);
408         emit Transfer(sender, recipient, amount);
409         return true;
410     }  
411     
412     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
413         uint256 _sellTotalFees = sellFeeMen;
414         uint256 hodlTime = block.timestamp-lastTxTimestamp[sender];
415             if (hodlTime > 2 hours && hodlTime <= 12 hours) {
416                 _sellTotalFees = sellFeeDwarves;
417             }
418             else if (hodlTime > 12 hours && hodlTime <= 24 hours) {
419                 _sellTotalFees = sellFeeElves;
420             }
421             else if (hodlTime > 24 hours) {
422                 _sellTotalFees = sellFeeGreatRing;
423             }
424 
425         uint256 feeApplicable = pair == recipient ? _sellTotalFees : buyFee;
426         uint256 feeAmount = amount.mul(feeApplicable).div(100);
427 
428         _balances[address(this)] = _balances[address(this)].add(feeAmount);
429         emit Transfer(sender, address(this), feeAmount);
430 
431         return amount.sub(feeAmount);
432     }
433     
434     function swapTokensForEth(uint256 tokenAmount) private {
435 
436         address[] memory path = new address[](2);
437         path[0] = address(this);
438         path[1] = router.WETH();
439 
440         approve(address(this), tokenAmount);
441 
442         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
443             tokenAmount,
444             0, // accept any amount of ETH
445             path,
446             address(this),
447             block.timestamp
448         );
449     }
450 
451     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
452         router.addLiquidityETH{value: ethAmount}(
453             address(this),
454             tokenAmount,
455             0,
456             0,
457             lpWallet,
458             block.timestamp
459         );
460     }
461 
462     function swapBack() internal lockTheSwap {
463     
464         uint256 tokenBalance = _balances[address(this)]; 
465         uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2);     
466         uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity);
467 
468         swapTokensForEth(amountToSwap);
469 
470         uint256 totalEthBalance = address(this).balance;
471         uint256 ethForDev = totalEthBalance.mul(toDev).div(100);
472         uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2);
473       
474         if (totalEthBalance > 0){
475             payable(devWallet).transfer(ethForDev);
476         }
477         
478         if (tokensForLiquidity > 0){
479             addLiquidity(tokensForLiquidity, ethForLiquidity);
480         }
481     }
482 
483     function manualSwapBack() external onlyOwner {
484         swapBack();
485     }
486 
487     function clearStuckEth() external onlyOwner {
488         uint256 contractETHBalance = address(this).balance;
489         if(contractETHBalance > 0){          
490             payable(address(devWallet)).transfer(contractETHBalance);
491         }
492     }
493 }