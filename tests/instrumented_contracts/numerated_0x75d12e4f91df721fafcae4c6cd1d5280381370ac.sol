1 /*
2 https://t.me/MyobuOfficial
3 https://myobu.io 
4 https://twitter.com/MyobuOfficial
5 https://www.reddit.com/r/Myobu/
6 
7 Myōbu are celestial fox spirits with white fur and full, fluffy tails reminiscent of ripe grain. They are holy creatures, and bring happiness and blessings to those around them.
8 
9 With a dynamic sell limit based on price impact and increasing sell cooldowns and redistribution taxes on consecutive sells, Myōbu was designed to reward holders and discourage dumping.
10 
11 1. Buy limit and cooldown timer on buys to make sure no automated bots have a chance to snipe big portions of the pool.
12 2. No Team & Marketing wallet. 100% of the tokens will come on the market for trade. 
13 3. No presale wallets that can dump on the community. 
14 
15 Token Information
16 1. 1,000,000,000,000 Total Supply
17 3. Developer provides LP
18 4. Fair launch for everyone! 
19 5. 0,2% transaction limit on launch
20 6. Buy limit lifted after launch
21 7. Sells limited to 3% of the Liquidity Pool, <2.9% price impact 
22 8. Sell cooldown increases on consecutive sells, 4 sells within a 24 hours period are allowed
23 9. 2% redistribution to holders on all buys
24 10. 7% redistribution to holders on the first sell, increases 2x, 3x, 4x on consecutive sells
25 11. Redistribution actually works!
26 12. 5-6% developer fee split within the team
27 
28                 ..`                                `..                
29              /dNdhmNy.                          .yNmhdMd/             
30             yMMdhhhNMN-                        -NMNhhhdMMy            
31            oMMmhyhhyhMN-                      -NMhyhhyhmMMs           
32           /MMNhs/hhh++NM+                    +MN++hhh/shNMM/          
33          .NMNhy`:hyyh:-mMy`                `yMm::hyyh:`yhNMN.         
34         `mMMdh. -hyohy..yNh.`............`.yNy..yhoyh- .hdMMm`        
35         hMMdh:  .hyosho...-:--------------:-...ohsoyh.  :hdMMh        
36        oMMmh+   .hyooyh/...-::---------:::-.../hyooyh.   +hmMMo       
37       /MMNhs    `hyoooyh-...://+++oo+++//:...-hyoooyh`    shNMM/      
38      .NMNhy`     hhoooshysyhhhhhhhhhhhhhhhhysyhsooohh     `yhNMN-     
39     `mMMdh.      yhsyhyso+::-.```....```.--:/osyhyshy      .hdMMm`    
40     yMMmh/      -so/-`            ..            `-/os-      /hmMMh    
41    /MMyhy      .`                 ``                 `.      shyMM/   
42    mN/+h/                                                    /h+/Nm   
43   :N:.sh.                                                    .hs.:N/  
44   s-./yh`                                                    `hy/.-s  
45   .`:/yh`                                                    `hy/:`-  
46  ``-//yh-                                                    .hy//-`` 
47  ``://oh+      `                                      `      +ho//:`` 
48 ``.://+yy`     `+`                                  `+`     `yh+//:.``
49 ``-///+oho      /y:                                :y/      ohs+///-``
50 ``:////+sh/ ``  `yhs-                            -shy`  `` /hs+////:``
51 ``:////++sh/  ```:syhs-                        -shys:```  /hs++////:``
52 ``://///++sho`    `.-/+o/.                  ./o+/-.`    `+hs++/////:``
53 ``://///+++oyy-      ``..--.              .--..``      -yyo+++/////:``
54 ``-/////+++++shs.       ``...            ...``       .ohs+++++/////-``
55  ``/////+++++++shs-        ..`          `..        -shs+++++++/////`` 
56  ``-/////++++++++oys-       ..`        `..       -syo++++++++/////-`` 
57   ``:////++++:-....+yy:      ..        ..      :yy+....-:++++////:``  
58    `.////+++:-......./yy:     ..      ..     :yy/.......-:+++////.`   
59     `.////++ooo+/-...../yy/`   .`    `.   `/yy/.....-/+ooo++////.`    
60      `.////+++oooos+/:...:sy/`  .    .  `/ys:...:/+soooo+++////.`     
61       `.:////+++++ooooso/:.:sh+` .  . `+hs:.:/osoooo+++++////:.`      
62         `-//////++++++ooooso++yh+....+hy++osoooo++++++//////-`        
63          `.:///////+++++++oooossyhoohyssoooo++++++////////:.`         
64             .:/+++++++++++++++ooosyysooo++++++++++++++//:.            
65               `-/+++++++++++++++oooooo+++++++++++++++/-`              
66                  .-/++++++++++++++++++++++++++++++/-.                 
67                     `.-//++++++++++++++++++++//-.`                    
68                          `..-::://////:::-..`                         
69                                                                       
70                                                                       
71                                                                       
72                                                                       
73 
74 SPDX-License-Identifier: Mines™®©
75 */
76 
77 
78 
79 pragma solidity ^0.8.4;
80 
81 abstract contract Context {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 }
86 
87 interface IERC20 {
88     function totalSupply() external view returns (uint256);
89     function balanceOf(address account) external view returns (uint256);
90     function transfer(address recipient, uint256 amount) external returns (bool);
91     function allowance(address owner, address spender) external view returns (uint256);
92     function approve(address spender, uint256 amount) external returns (bool);
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 library SafeMath {
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102         return c;
103     }
104 
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b <= a, errorMessage);
111         uint256 c = a - b;
112         return c;
113     }
114 
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         if (a == 0) {
117             return 0;
118         }
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121         return c;
122     }
123 
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         return c;
132     }
133 }
134 
135 contract Ownable is Context {
136     address private _owner;
137     address private _previousOwner;
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     constructor() {
141         address msgSender = _msgSender();
142         _owner = msgSender;
143         emit OwnershipTransferred(address(0), msgSender);
144     }
145 
146     function owner() public view returns (address) {
147         return _owner;
148     }
149 
150     modifier onlyOwner() {
151         require(_owner == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     function renounceOwnership() public virtual onlyOwner {
156         emit OwnershipTransferred(_owner, address(0));
157         _owner = address(0);
158     }
159 }
160 
161 interface IUniswapV2Factory {
162     function createPair(address tokenA, address tokenB) external returns (address pair);
163 }
164 
165 interface IUniswapV2Router02 {
166     function swapExactTokensForETHSupportingFeeOnTransferTokens(
167         uint256 amountIn,
168         uint256 amountOutMin,
169         address[] calldata path,
170         address to,
171         uint256 deadline
172     ) external;
173     function factory() external pure returns (address);
174     function WETH() external pure returns (address);
175     function addLiquidityETH(
176         address token,
177         uint256 amountTokenDesired,
178         uint256 amountTokenMin,
179         uint256 amountETHMin,
180         address to,
181         uint256 deadline
182     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
183 }
184 
185 contract Myobu is Context, IERC20, Ownable {
186     using SafeMath for uint256;
187     string private constant _name = unicode"Myōbu";
188     string private constant _symbol = "MYOBU";
189     uint8 private constant _decimals = 9;
190     mapping(address => uint256) private _rOwned;
191     mapping(address => uint256) private _tOwned;
192     mapping(address => mapping(address => uint256)) private _allowances;
193     mapping(address => bool) private _isExcludedFromFee;
194     uint256 private constant MAX = ~uint256(0);
195     uint256 private constant _tTotal = 1000000000000 * 10**9;
196     uint256 private _rTotal = (MAX - (MAX % _tTotal));
197     uint256 private _tFeeTotal;
198     uint256 private _taxFee = 7;
199     uint256 private _teamFee = 5;
200     mapping(address => bool) private bots;
201     mapping(address => uint256) private buycooldown;
202     mapping(address => uint256) private sellcooldown;
203     mapping(address => uint256) private firstsell;
204     mapping(address => uint256) private sellnumber;
205     address payable private _teamAddress;
206     address payable private _marketingFunds;
207     IUniswapV2Router02 private uniswapV2Router;
208     address private uniswapV2Pair;
209     bool private tradingOpen = false;
210     bool private liquidityAdded = false;
211     bool private inSwap = false;
212     bool private swapEnabled = false;
213     bool private cooldownEnabled = false;
214     uint256 private _maxTxAmount = _tTotal;
215     event MaxTxAmountUpdated(uint256 _maxTxAmount);
216     modifier lockTheSwap {
217         inSwap = true;
218         _;
219         inSwap = false;
220     }
221     constructor(address payable addr1, address payable addr2) {
222         _teamAddress = addr1;
223         _marketingFunds = addr2;
224         _rOwned[_msgSender()] = _rTotal;
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[_teamAddress] = true;
228         _isExcludedFromFee[_marketingFunds] = true;
229         emit Transfer(address(0), _msgSender(), _tTotal);
230     }
231 
232     function name() public pure returns (string memory) {
233         return _name;
234     }
235 
236     function symbol() public pure returns (string memory) {
237         return _symbol;
238     }
239 
240     function decimals() public pure returns (uint8) {
241         return _decimals;
242     }
243 
244     function totalSupply() public pure override returns (uint256) {
245         return _tTotal;
246     }
247 
248     function balanceOf(address account) public view override returns (uint256) {
249         return tokenFromReflection(_rOwned[account]);
250     }
251 
252     function transfer(address recipient, uint256 amount) public override returns (bool) {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256 
257     function allowance(address owner, address spender) public view override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     function approve(address spender, uint256 amount) public override returns (bool) {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265 
266     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
267         _transfer(sender, recipient, amount);
268         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
269         return true;
270     }
271 
272     function setCooldownEnabled(bool onoff) external onlyOwner() {
273         cooldownEnabled = onoff;
274     }
275 
276     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
277         require(rAmount <= _rTotal,"Amount must be less than total reflections");
278         uint256 currentRate = _getRate();
279         return rAmount.div(currentRate);
280     }
281     
282     function removeAllFee() private {
283         if (_taxFee == 0 && _teamFee == 0) return;
284         _taxFee = 0;
285         _teamFee = 0;
286     }
287 
288     function restoreAllFee() private {
289         _taxFee = 7;
290         _teamFee = 5;
291     }
292     
293     function setFee(uint256 multiplier) private {
294         _taxFee = _taxFee * multiplier;
295         if (multiplier > 1) {
296             _teamFee = 10;
297         }
298         
299     }
300 
301     function _approve(address owner, address spender, uint256 amount) private {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307 
308     function _transfer(address from, address to, uint256 amount) private {
309         require(from != address(0), "ERC20: transfer from the zero address");
310         require(to != address(0), "ERC20: transfer to the zero address");
311         require(amount > 0, "Transfer amount must be greater than zero");
312 
313         if (from != owner() && to != owner()) {
314             if (cooldownEnabled) {
315                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
316                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
317                 }
318             }
319             require(!bots[from] && !bots[to]);
320             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
321                 require(tradingOpen);
322                 require(amount <= _maxTxAmount);
323                 require(buycooldown[to] < block.timestamp);
324                 buycooldown[to] = block.timestamp + (30 seconds);
325                 _teamFee = 6;
326                 _taxFee = 2;
327             }
328             uint256 contractTokenBalance = balanceOf(address(this));
329             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
330                 require(amount <= balanceOf(uniswapV2Pair).mul(3).div(100) && amount <= _maxTxAmount);
331                 require(sellcooldown[from] < block.timestamp);
332                 if(firstsell[from] + (1 days) < block.timestamp){
333                     sellnumber[from] = 0;
334                 }
335                 if (sellnumber[from] == 0) {
336                     sellnumber[from]++;
337                     firstsell[from] = block.timestamp;
338                     sellcooldown[from] = block.timestamp + (1 hours);
339                 }
340                 else if (sellnumber[from] == 1) {
341                     sellnumber[from]++;
342                     sellcooldown[from] = block.timestamp + (2 hours);
343                 }
344                 else if (sellnumber[from] == 2) {
345                     sellnumber[from]++;
346                     sellcooldown[from] = block.timestamp + (6 hours);
347                 }
348                 else if (sellnumber[from] == 3) {
349                     sellnumber[from]++;
350                     sellcooldown[from] = firstsell[from] + (1 days);
351                 }
352                 swapTokensForEth(contractTokenBalance);
353                 uint256 contractETHBalance = address(this).balance;
354                 if (contractETHBalance > 0) {
355                     sendETHToFee(address(this).balance);
356                 }
357                 setFee(sellnumber[from]);
358             }
359         }
360         bool takeFee = true;
361 
362         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
363             takeFee = false;
364         }
365 
366         _tokenTransfer(from, to, amount, takeFee);
367         restoreAllFee;
368     }
369 
370     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
371         address[] memory path = new address[](2);
372         path[0] = address(this);
373         path[1] = uniswapV2Router.WETH();
374         _approve(address(this), address(uniswapV2Router), tokenAmount);
375         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
376     }
377 
378     function sendETHToFee(uint256 amount) private {
379         _teamAddress.transfer(amount.div(2));
380         _marketingFunds.transfer(amount.div(2));
381     }
382     
383     function openTrading() public onlyOwner {
384         require(liquidityAdded);
385         tradingOpen = true;
386     }
387 
388     function addLiquidity() external onlyOwner() {
389         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
390         uniswapV2Router = _uniswapV2Router;
391         _approve(address(this), address(uniswapV2Router), _tTotal);
392         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
393         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
394         swapEnabled = true;
395         cooldownEnabled = true;
396         liquidityAdded = true;
397         _maxTxAmount = 3000000000 * 10**9;
398         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
399     }
400 
401     function manualswap() external {
402         require(_msgSender() == _teamAddress);
403         uint256 contractBalance = balanceOf(address(this));
404         swapTokensForEth(contractBalance);
405     }
406 
407     function manualsend() external {
408         require(_msgSender() == _teamAddress);
409         uint256 contractETHBalance = address(this).balance;
410         sendETHToFee(contractETHBalance);
411     }
412 
413     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
414         if (!takeFee) removeAllFee();
415         _transferStandard(sender, recipient, amount);
416         if (!takeFee) restoreAllFee();
417     }
418 
419     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
420         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
421         _rOwned[sender] = _rOwned[sender].sub(rAmount);
422         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
423         _takeTeam(tTeam);
424         _reflectFee(rFee, tFee);
425         emit Transfer(sender, recipient, tTransferAmount);
426     }
427 
428     function _takeTeam(uint256 tTeam) private {
429         uint256 currentRate = _getRate();
430         uint256 rTeam = tTeam.mul(currentRate);
431         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
432     }
433 
434     function _reflectFee(uint256 rFee, uint256 tFee) private {
435         _rTotal = _rTotal.sub(rFee);
436         _tFeeTotal = _tFeeTotal.add(tFee);
437     }
438 
439     receive() external payable {}
440 
441     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
442         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
443         uint256 currentRate = _getRate();
444         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
445         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
446     }
447 
448     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
449         uint256 tFee = tAmount.mul(taxFee).div(100);
450         uint256 tTeam = tAmount.mul(teamFee).div(100);
451         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
452         return (tTransferAmount, tFee, tTeam);
453     }
454 
455     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
456         uint256 rAmount = tAmount.mul(currentRate);
457         uint256 rFee = tFee.mul(currentRate);
458         uint256 rTeam = tTeam.mul(currentRate);
459         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
460         return (rAmount, rTransferAmount, rFee);
461     }
462 
463     function _getRate() private view returns (uint256) {
464         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
465         return rSupply.div(tSupply);
466     }
467 
468     function _getCurrentSupply() private view returns (uint256, uint256) {
469         uint256 rSupply = _rTotal;
470         uint256 tSupply = _tTotal;
471         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
472         return (rSupply, tSupply);
473     }
474 
475     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
476         require(maxTxPercent > 0, "Amount must be greater than 0");
477         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
478         emit MaxTxAmountUpdated(_maxTxAmount);
479     }
480 }