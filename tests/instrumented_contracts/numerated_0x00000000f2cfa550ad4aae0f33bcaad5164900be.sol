1 /**
2                                                                                                                         
3                                                                                                                         
4                                                                              `!'                                        
5                                                                           _*YkwV*'                                      
6                                                                       `!xomUIzwVcT^.                                    
7                                                                    _*c55G3KUIzwVcl}Y*.                                  
8                                                                 !LG6OdZ5G3KUIzwVcu}Yix<'                                
9                                                             -*kE$0E6OdZ5G3KUIzwVcu}Yixx*.                               
10                                                          :YbQQ8g$0E6OdZ5G3KUIzwVcl}L*:`                                 
11                                                      `~uEQBBQQ8g$0E6OdZ5G3KUIzwVL^_`                                    
12                                                   -rXDg8QQBBQQ8g$0E6OdZ5G3mUoL;-                                        
13                                                "ve9E0$g8QQBBQQ8g$0E6OdZ5G3Kx-                                           
14                                            -^uHZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUjx!`                                        
15                                         _*cKPGMZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUXzwV?:`                                     
16                                     `!rVzIeKPGMZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUIzwVcr.                                     
17                                  .!vuVVwzIeKPGMZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUIzwVx:'                                     
18                              `_=|L}TuVVwzIeKPGMZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUIzwVcu}x^"'                                 
19                              .!rxi}TuVVwzIeKPGMZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUIzwVcl}}v<,`                                
20                                 `:r}uVVwzIeKPGMZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUIzwV}*:'                                    
21                                    `"r}wzIeKPGMZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUIzwV}!                                      
22                                        -^}sKPGMZdO9E0$g8QQBBQQ8g$0E6OdZ5G3KUXzwVT*-                                     
23                                           '~Y3MZdO9E0$g8QQBBQQ8g$0E6OdZ5G3mUXVr,                                        
24                                              `:veO9E0$g8QQBBQQ8g$0E6OdZ5G3mx"                                           
25                                                  _)XD$g8QQBBQQ8g$0E6OdZ5G3KI}<-                                         
26                                                     `!YZQQBBQQ8g$0E6OdZ5G3KUXzwur:`                                     
27                                                         _vqQQQ8g$0E6OdZ5G3KUIzwVcu}(!.                                  
28                                                            '*V6g$0E6OdZ5G3KUIzwVcu}Yix)='                               
29                                                                :xmR6OdZ5G3KUIzwVcu}Yix),                                
30                                                                   .^}GZ5G3KUIzwVcu}Yv:                                  
31                                                                       :?w3KUXzwVcuv:                                    
32                                                                          -<LkzwVx"                                      
33                                                                             `"*:                                        
34                                                                                                                         
35                                                                                                                         
36                                                                                                                         
37                                                                                                                         
38                                                                                                                         
39           .^v--?>'    `vxx`:xxxxxxr   -xxxxxxxxxx,       .xx*         vx~         ^xx:`xxxxxxx'  `\x~      rx*          
40         'd@@@*(@@@Z.  :#@#,I@@@@@@Q   )##########}      `8@@@z        @@0         $@@j,@@@@@@@~  ,@@0      #@B          
41         k@@L   `r@@M       I@@~                         d@@Q@@x       @@0             ,@@M       _@@6      #@B          
42         !B@@8Mwx^:.`       I@@=       :zzzzzzzzz*      j@@V`B@@>      @@0             ,@@q       `zPUzzzzzz@@B          
43           =T3EQ@@@8r       I@@=       ^QQQQQQQQQV     x@@M  ,B@#,     @@0             ,@@q       ,@@@QQQQQQ@@B          
44        `0BE`   `:B@@`      I@@=                      `gQb`   "#@B'    @@0             ,@@q       ,@@0      #@B          
45         v@@#Z::aD@@d       I@@=       !ZZZZZZZZZZ^  =MZZZZZZZZB@@$    @@0 5ddddj      ,@@q       ,@@0      #@B          
46          .xa6=>DZy~        v0E_       =dddddddddd*  wddddddddddddd!   GZ} GZZZZz      .E0i       '5dT      mdk          
47                                                                                                                         
48                                                                                                                         
49                                                                                                                         
50  Telegram: https://t.me/StealthTokenOfficial
51  Website: https://StealthToken.io
52  Stealth
53  The Home of Dynamic Stealth Tokenomics
54  Making Crypto Great Again - As One
55  Contract Creator Address: 0x68739D3CEFEb50d84838B3393535675cbf59E75A
56  Multi-Sig Wallet Address for Eth: 0x852a8cb5D5e09133EDa0713C1A475A5B7dE80226
57 */
58 
59 pragma solidity ^0.8.6;
60 // SPDX-License-Identifier: UNLICENSED
61 
62 abstract contract Context {
63     function _msgSender() internal view virtual returns (address payable) {
64         return payable(msg.sender);
65     }
66 
67     function _msgData() internal view virtual returns (bytes memory) {
68         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
69         return msg.data;
70     }
71 }
72 
73 /* @dev Interface of the ERC20 standard as defined in the EIP.
74  */
75 interface IERC20 {
76     /**
77      * @dev Returns the amount of tokens in existence.
78      */
79     function totalSupply() external view returns (uint256);
80 
81     /**
82      * @dev Returns the amount of tokens owned by `account`.
83      */
84     function balanceOf(address account) external view returns (uint256);
85 
86     /**
87      * @dev Moves `amount` tokens from the caller's account to `recipient`.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transfer(address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Returns the remaining number of tokens that `spender` will be
97      * allowed to spend on behalf of `owner` through {transferFrom}. This is
98      * zero by default.
99      *
100      * This value changes when {approve} or {transferFrom} are called.
101      */
102     function allowance(address owner, address spender) external view returns (uint256);
103 
104     /**
105      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * IMPORTANT: Beware that changing an allowance with this method brings the risk
110      * that someone may use both the old and the new allowance by unfortunate
111      * transaction ordering. One possible solution to mitigate this race
112      * condition is to first reduce the spender's allowance to 0 and set the
113      * desired value afterwards:
114      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address spender, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Moves `amount` tokens from `sender` to `recipient` using the
122      * allowance mechanism. `amount` is then deducted from the caller's
123      * allowance.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(
130         address sender,
131         address recipient,
132         uint256 amount
133     ) external returns (bool);
134 
135     /**
136      * @dev Emitted when `value` tokens are moved from one account (`from`) to
137      * another (`to`).
138      *
139      * Note that `value` may be zero.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     /**
144      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
145      * a call to {approve}. `value` is the new allowance.
146      */
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 library SafeMath {
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         require(c >= a, "SafeMath: addition overflow");
154         return c;
155     }
156 
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164         return c;
165     }
166 
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         if (a == 0) {
169             return 0;
170         }
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173         return c;
174     }
175 
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b > 0, errorMessage);
182         uint256 c = a / b;
183         return c;
184     }
185 
186 }
187 
188 contract Ownable is Context {
189     address payable private _owner;
190     address payable private _previousOwner;
191     uint256 private _lockTime;
192 
193     event OwnershipTransferred(
194         address indexed previousOwner,
195         address indexed newOwner
196     );
197 
198     constructor() {
199         _owner = _msgSender();
200         emit OwnershipTransferred(address(0), _owner);
201     }
202 
203     function owner() public view returns (address) {
204         return _owner;
205     }
206 
207     modifier onlyOwner() {
208         require(_owner == _msgSender(), "Ownable: caller is not the owner");
209         _;
210     }
211 
212     function renounceOwnership() public virtual onlyOwner {
213         emit OwnershipTransferred(_owner, address(0));
214         _owner = payable(address(0));
215     }
216 
217     function transferOwnership(address payable newOwner)
218         public
219         virtual
220         onlyOwner
221     {
222         require(
223             newOwner != address(0),
224             "Ownable: new owner is the zero address"
225         );
226         emit OwnershipTransferred(_owner, newOwner);
227         _owner = newOwner;
228     }
229 
230     function getUnlockTime() public view returns (uint256) {
231         return _lockTime;
232     }
233 
234     //Locks the contract for owner for the amount of time provided
235     function lock(uint256 time) public virtual onlyOwner {
236         _previousOwner = _owner;
237         _owner = payable(address(0));
238         _lockTime = block.timestamp + time;
239         emit OwnershipTransferred(_owner, address(0));
240     }
241 
242     //Unlocks the contract for owner when _lockTime is exceeds
243     function unlock() public virtual {
244         require(
245             _previousOwner == msg.sender,
246             "You don't have permission to unlock"
247         );
248         require(
249             block.timestamp > _lockTime,
250             "Contract is locked until defined days"
251         );
252         emit OwnershipTransferred(_owner, _previousOwner);
253         _owner = _previousOwner;
254         _previousOwner = payable(address(0));
255     }
256 }
257 
258 interface IUniswapV2Factory {
259     function createPair(address tokenA, address tokenB) external returns (address pair);
260 }
261 
262 interface IUniswapV2Router02 {
263     function swapExactTokensForETHSupportingFeeOnTransferTokens(
264         uint amountIn,
265         uint amountOutMin,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external;
270     function factory() external pure returns (address);
271     function WETH() external pure returns (address);
272     function addLiquidityETH(
273         address token,
274         uint amountTokenDesired,
275         uint amountTokenMin,
276         uint amountETHMin,
277         address to,
278         uint deadline
279     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
280 }
281 
282 contract Stealth is Context, IERC20, Ownable {
283     using SafeMath for uint256;
284     // If you are reading this then welcome - this is where the work happens.
285     // StealthStandard Check
286     mapping (address => uint256) private _balances;
287     mapping (address => uint256) private _firstBuy;
288     mapping (address => uint256) private _lastBuy;
289     mapping (address => uint256) private _lastSell;
290     mapping (address => mapping (address => uint256)) private _allowances;
291     mapping (address => bool) private _isExcludedFromFee;
292     mapping (address => bool) private _hasTraded;
293     mapping (address => bool) private bots;
294     mapping (address => uint) private cooldown;
295     uint256 private constant _tTotal = 1000000000000 * 10**18;
296     uint256 private _tradingStartTimestamp;
297     uint256 public sellCoolDownTime = 60 seconds;
298     uint256 private minTokensToSell = _tTotal.div(100000);
299     
300     address payable private _stealthMultiSigWallet;
301     
302     string private constant _name = "Stealth Standard";
303     string private constant _symbol = "$STEALTH";
304     uint8 private constant _decimals = 18;
305     
306     IUniswapV2Router02 public uniswapV2Router;
307     address public uniswapV2Pair;
308     bool private tradingOpen = false;
309     bool private inSwap = false;
310     bool private swapEnabled = false;
311     bool private antiBotEnabled = false;
312 
313     modifier lockTheSwap {
314         inSwap = true;
315         _;
316         inSwap = false;
317     }
318     
319     constructor () {
320         _stealthMultiSigWallet = payable(0x852a8cb5D5e09133EDa0713C1A475A5B7dE80226);
321         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
322         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
323 
324         uniswapV2Router = _uniswapV2Router;
325         uniswapV2Pair = _uniswapV2Pair;
326         _balances[_msgSender()] = _tTotal;
327         _isExcludedFromFee[owner()] = true;
328         _isExcludedFromFee[address(this)] = true;
329         _isExcludedFromFee[_stealthMultiSigWallet] = true;
330         emit Transfer(address(0), _msgSender(), _tTotal);
331     }
332 
333     function name() public pure returns (string memory) {
334         return _name;
335     }
336 
337     function symbol() public pure returns (string memory) {
338         return _symbol;
339     }
340 
341     function decimals() public pure returns (uint8) {
342         return _decimals;
343     }
344 
345     function totalSupply() public pure override returns (uint256) {
346         return _tTotal;
347     }
348 
349     function balanceOf(address account) public view override returns (uint256) {
350         return _balances[account];
351     }
352 
353     function transfer(address recipient, uint256 amount) public override returns (bool) {
354         _transfer(_msgSender(), recipient, amount);
355         return true;
356     }
357 
358     function allowance(address owner, address spender) public view override returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     function approve(address spender, uint256 amount) public override returns (bool) {
363         _approve(_msgSender(), spender, amount);
364         return true;
365     }
366 
367     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     function _approve(address owner, address spender, uint256 amount) private {
374         require(owner != address(0), "ERC20: approve from the zero address");
375         require(spender != address(0), "ERC20: approve to the zero address");
376         _allowances[owner][spender] = amount;
377         emit Approval(owner, spender, amount);
378     }
379 
380     function _transfer(address from, address to, uint256 amount) private {
381         require(from != address(0), "ERC20: transfer from the zero address");
382         require(to != address(0), "ERC20: transfer to the zero address");
383         require(amount > 0, "Transfer amount must be greater than zero");
384         require(balanceOf(from) >= amount,"Not enough balance for tx");
385 
386 
387         // Check if we are buying or selling, or simply transferring
388         //if (to == uniswapV2Pair && from != address(uniswapV2Router) && from != owner() && from != address(this) && ! _isExcludedFromFee[from]) {
389         if ((to == uniswapV2Pair) && ! _isExcludedFromFee[from]) {
390             // Selling to uniswapV2Pair:
391 
392             // ensure trading is open
393             require(tradingOpen,"trading is not yet open");
394 
395             // Block known bots from selling - If you think this was a mistake please contact the Stealth Team
396             require(!bots[from], "Stealth is a Bot Free Zone");
397 
398             // anti bot code - checks for buys and sells in the same block or within the sellCoolDownTime
399             if  (antiBotEnabled) {
400                 uint256 lastBuy = _lastBuy[from];
401                 require(block.timestamp > lastBuy, "Sorry - no FrontRunning allowed right now");
402                 require(cooldown[from] < block.timestamp);
403                 cooldown[from] = block.timestamp + sellCoolDownTime;
404             }
405 
406             // Has Seller made a trade before? If not set to current block timestamp
407             // We check this again on a sell to make sure they didn't transfer to a new wallet
408             if (!_hasTraded[from]){
409                 _firstBuy[from] = block.timestamp;
410                 _hasTraded[from] = true;
411             }
412 
413             if (swapEnabled) {
414                 // handle sell of tokens in contract for Eth
415                 uint256 contractTokenBalance = balanceOf(address(this));
416                 if (contractTokenBalance >= minTokensToSell) {
417                     if (!inSwap) {
418                         swapTokensForEth(contractTokenBalance);
419                         uint256 contractETHBalance = address(this).balance;
420                         if(contractETHBalance > 0) {
421                         sendETHToWallet(address(this).balance);
422                         }
423                     }
424                 }
425             }
426             
427             // Check to see if just taking profits or selling over 5%
428             bool justTakingProfits = _justTakingProfits(amount, from);
429             uint256 numHours = _getHours(_lastSell[from], block.timestamp);
430             uint256 numDays = (numHours / 24);
431             if (justTakingProfits) {
432                 // just taking profits but need to make sure its been more than 7 days since last sell if so
433                 if (numDays < 7) {
434                     _firstBuy[from] = block.timestamp;
435                     _lastBuy[from] = block.timestamp;
436                 }
437             } else {
438                 if (numDays < 84) {
439                 // sold over 5% so we reset the last buy to be now
440                 _firstBuy[from] = block.timestamp;
441                 _lastBuy[from] = block.timestamp;
442                 }
443             }
444 
445             // Record last sell timestamp
446             _lastSell[from] = block.timestamp;
447 
448             // Transfer with taxes
449             _tokenTransferTaxed(from,to,amount);
450 
451         //} else if (from == uniswapV2Pair && to != address(uniswapV2Router) && to != owner() && to != address(this)) {
452         } else if ((from == uniswapV2Pair) && ! _isExcludedFromFee[to]) {
453             // Buying from uniswapV2Pair:
454 
455             // ensure trading is open
456             require(tradingOpen,"trading is not yet open");
457 
458             // Has buyer made a trade before? If not set to current block timestamp
459             if (!_hasTraded[to]){
460                 _firstBuy[to] = block.timestamp;
461                 _hasTraded[to] = true;
462             }
463 
464             // snapshot the last buy timestamp
465             _lastBuy[to] = block.timestamp;
466 
467             // Simple Transfer with no taxes 
468             _transferFree(from, to, amount);
469         } else {
470             // Other transfer
471 
472             // Block known bots from selling - If you think this was a mistake please contact the Stealth Team
473             require(!bots[from] && !bots[to], "Stealth is a Bot Free Zone");
474 
475             // Handle the case of wallet to wallet transfer
476             _firstBuy[to] = block.timestamp;
477             _hasTraded[to] = true;
478 
479             // Simple Transfer with no taxes
480             _transferFree(from, to, amount);
481         }
482 
483     }
484 
485     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
486         address[] memory path = new address[](2);
487         path[0] = address(this);
488         path[1] = uniswapV2Router.WETH();
489         _approve(address(this), address(uniswapV2Router), tokenAmount);
490         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
491             tokenAmount, 
492             0,
493             path,
494             address(this),
495             block.timestamp
496         );
497     }
498 
499     // If we are doing a tax free Transfer that happens here after _transfer:
500     function _transferFree(address sender, address recipient, uint256 tAmount) private {
501         _balances[sender] = _balances[sender].sub(tAmount);
502         _balances[recipient] = _balances[recipient].add(tAmount); 
503         emit Transfer(sender, recipient, tAmount);
504     }
505         
506     // If we are doing a taxed Transfer that happens here after _transfer:
507     function _tokenTransferTaxed(address sender, address recipient, uint256 amount) private {
508         _transferTaxed(sender, recipient, amount);
509     }
510 
511     function _transferTaxed(address sender, address recipient, uint256 tAmount) private {
512 
513         // Calculate the taxed token amount
514         uint256 tTeam = _getTaxedValue(tAmount, sender);
515         uint256 transferAmount = tAmount - tTeam;
516 
517         _balances[sender] = _balances[sender].sub(tAmount);
518         _balances[recipient] = _balances[recipient].add(transferAmount); 
519         _takeTeam(tTeam);
520         emit Transfer(sender, recipient, transferAmount);
521     }
522 
523     function _takeTeam(uint256 tTeam) private {
524         _balances[address(this)] = _balances[address(this)].add(tTeam);
525     }
526 
527     // Check to see if the sell amount is greater than 5% of tokens in a 7 day period
528     function _justTakingProfits(uint256 sellAmount, address account) private view returns(bool) {
529         // Basic cheak to see if we are selling more than 5% - if so return false
530         if ((sellAmount * 20) > _balances[account]) {
531             return false;
532         } else {
533             return true;
534         }
535     }
536 
537     // Calculate the number of taxed tokens for a transaction
538     function _getTaxedValue(uint256 transTokens, address account) private view returns(uint256){
539         uint256 taxRate = _getTaxRate(account);
540         if (taxRate == 0) {
541             return 0;
542         } else {
543             uint256 numerator = (transTokens * (10000 - (100 * taxRate)));
544             return (((transTokens * 10000) - numerator) / 10000);
545         }
546     }
547 
548     // Calculate the current tax rate.
549 	function _getTaxRate(address account) private view returns(uint256) {
550         uint256 numHours = _getHours(_tradingStartTimestamp, block.timestamp);
551 
552         if (numHours <= 24){
553             // 20% Sell Tax first 24 Hours
554             return 20;
555         } else if (numHours <= 48){
556             // 16% Sell Tax second 24 Hours
557             return 16;
558         } else {
559             // 12% Sell Tax starting rate
560             numHours = _getHours(_firstBuy[account], block.timestamp);
561             uint256 numDays = (numHours / 24);
562             if (numDays >= 84 ){
563                 //12 x 7 = 84 = tax free!
564                 return 0;
565             } else {
566                 uint256 numWeeks = (numDays / 7);
567                 return (12 - numWeeks);
568             }
569         }
570     }
571 
572     // Calculate the number of hours that have passed between endDate and startDate:
573     function _getHours(uint256 startDate, uint256 endDate) private pure returns(uint256){
574         return ((endDate - startDate) / 60 / 60);
575     }
576     
577     receive() external payable {}
578     
579     function manualswap() external {
580         require(_msgSender() == _stealthMultiSigWallet || _msgSender() == address(this) || _msgSender() == owner());
581         uint256 contractBalance = balanceOf(address(this));
582         swapTokensForEth(contractBalance);
583     }
584     
585     function manualsend() external {
586         require(_msgSender() == _stealthMultiSigWallet || _msgSender() == address(this) || _msgSender() == owner());
587         uint256 contractETHBalance = address(this).balance;
588         sendETHToWallet(contractETHBalance);
589     }
590 
591     function airdrop(address[] memory _user, uint256[] memory _amount) external onlyOwner {
592         uint256 len = _user.length;
593         require(len == _amount.length);
594         for (uint256 i = 0; i < len; i++) {
595             _balances[_msgSender()] = _balances[_msgSender()].sub(_amount[i], "ERC20: transfer amount exceeds balance");
596             _balances[_user[i]] = _balances[_user[i]].add(_amount[i]);
597             emit Transfer(_msgSender(), _user[i], _amount[i]);
598         }
599     }
600     
601     function setMultipleBots(address[] memory bots_) public onlyOwner {
602         for (uint i = 0; i < bots_.length; i++) {
603             bots[bots_[i]] = true;
604         }
605     }
606 
607     function setBot(address isbot) public onlyOwner {
608         bots[isbot] = true;
609     }
610     
611     function deleteBot(address notbot) public onlyOwner {
612         bots[notbot] = false;
613     }
614 
615     function isBlacklisted(address isbot) public view returns(bool) {
616         return bots[isbot];
617     }
618 
619     function setAntiBotMode(bool onoff) external onlyOwner() {
620         antiBotEnabled = onoff;
621     }
622 
623     function isAntiBotEnabled() public view returns(bool) {
624         return antiBotEnabled;
625     }
626 
627     function excludeFromFee(address account) public onlyOwner {
628         _isExcludedFromFee[account] = true;
629     }
630 
631     function includeInFee(address account) public onlyOwner {
632         _isExcludedFromFee[account] = false;
633     }
634 
635     function setSellCoolDownTime(uint256 _newTime) public onlyOwner {
636         sellCoolDownTime = _newTime;
637     }
638 
639     function updateRouter(IUniswapV2Router02 newRouter, address newPair) external onlyOwner {
640         uniswapV2Router = newRouter;
641         uniswapV2Pair = newPair;
642     }
643             
644     function sendETHToWallet(uint256 amount) private {
645         _stealthMultiSigWallet.transfer(amount);
646     }
647     
648     function startTrading() external onlyOwner() {
649         require(!tradingOpen,"trading is already open");
650         antiBotEnabled = true;
651         swapEnabled = true;
652         tradingOpen = true;
653         _tradingStartTimestamp = block.timestamp;
654     }
655 
656     function setSwapEnabledMode(bool swap) external onlyOwner {
657         swapEnabled = swap;
658     }
659 
660     function isTradingOpen() public view returns(bool) {
661         return tradingOpen;
662     }
663 
664 
665 }