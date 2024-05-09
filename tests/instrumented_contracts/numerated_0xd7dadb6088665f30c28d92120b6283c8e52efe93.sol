1 /** 
2  * SPDX-License-Identifier: Unlicensed
3 
4 Welcome to SHIB MINER
5 
6 Empowering the Ethereum blockchain.
7 
8 A new unique reward token and future ecosystem from miners on the ethereum blockchain.
9 
10 Buy on Uniswap
11 
12 Website: www.shib-miner.com
13 
14 Telegram: https://t.me/ShibMinerToken
15 
16 Twitter: @MinerShib
17 
18 
19 
20 
21  * */
22 
23 pragma solidity ^0.8.4;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if(a == 0) {
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
72     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         return mod(a, b, "SafeMath: modulo by zero");
80     }
81 
82     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b != 0, errorMessage);
84         return a % b;
85     }
86 }
87 
88 contract Ownable is Context {
89     address private _owner;
90     address private _previousOwner;
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor () {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113 }  
114 
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB) external returns (address pair);
117 }
118 
119 interface IUniswapV2Router02 {
120     function swapExactTokensForETHSupportingFeeOnTransferTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external;
127     function factory() external pure returns (address);
128     function WETH() external pure returns (address);
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137 }
138 
139 interface AntiSnipe {
140     function checkUser(address from, address to, uint256 amt) external returns (bool);
141     function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;
142     function setLpPair(address pair, bool enabled) external;
143     function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;
144     function setGasPriceLimit(uint256 gas) external;
145     function removeSniper(address account) external;
146     function getSniperAmt() external view returns (uint256);
147     function removeBlacklisted(address account) external;
148     function isBlacklisted(address account) external view returns (bool);
149     function setBlacklistEnabled(address account, bool enabled) external;
150     function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;
151 }
152 contract Miner is Context, IERC20, Ownable {
153     using SafeMath for uint256;
154     mapping (address => uint256) private _rOwned;
155     mapping (address => uint256) private _tOwned;
156     mapping (address => mapping (address => uint256)) private _allowances;
157     mapping (address => bool) private _isExcludedFromFee;
158     mapping (address => bool) private _isExcluded;
159     address[] private _excluded;
160     mapping (address => bool) private _isBlackListedBot;
161     address[] private _blackListedBots;
162     
163     mapping (address => User) private cooldown;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 1 * 1e18 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     string private constant _name = unicode"Shib Miner";
169     string private constant _symbol = unicode"MINER";
170     uint8 private constant _decimals = 9;
171     uint256 private _taxFee = 2;
172     uint256 private _teamFee = 10;
173     uint256 private _launchTime;
174     uint256 private _previousTaxFee = _taxFee;
175     uint256 private _previousteamFee = _teamFee;
176     uint256 private _maxBuyAmount;
177     uint256 public maxWallet =  20000000000000001 * 10**9; 
178 
179     uint256 private _BuytaxFee = 2;
180     uint256 private _BuyteamFee = 10;
181    
182     uint256 private _SelltaxFee = 2;
183     uint256 private _SellteamFee = 10;
184     
185     address payable private _FeeAddress;
186     address payable private _FeeAddress2;
187     IUniswapV2Router02 public uniswapV2Router;
188     address public uniswapV2Pair;
189     bool private tradingOpen;
190     bool private _cooldownEnabled = true;
191     bool private inSwap = false;
192     uint256 private buyLimitEnd;
193     AntiSnipe antiSnipe;
194 
195     
196 
197     struct User {
198         uint256 buy;
199         uint256 sell;
200         bool exists;
201     }
202 
203     event MaxBuyAmountUpdated(uint _maxBuyAmount);
204     event CooldownEnabledUpdated(bool _cooldown);
205 
206     modifier lockTheSwap {
207         inSwap = true;
208         _;
209         inSwap = false;
210     }
211     constructor (address payable FeeAddress, address payable FeeAddress2) {
212         _FeeAddress = FeeAddress;
213         _FeeAddress2 = FeeAddress2;
214         _rOwned[_msgSender()] = _rTotal;
215         _isExcludedFromFee[owner()] = true;
216         _isExcludedFromFee[address(this)] = true;
217         
218         _isExcludedFromFee[FeeAddress] = true;
219         _isExcludedFromFee[FeeAddress2] = true;
220         
221         _isBlackListedBot[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
222         _blackListedBots.push(address(0x66f049111958809841Bbe4b81c034Da2D953AA0c));
223         
224         _isBlackListedBot[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
225         _blackListedBots.push(address(0x000000005736775Feb0C8568e7DEe77222a26880));
226         
227         _isBlackListedBot[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
228         _blackListedBots.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
229         
230         _isBlackListedBot[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
231         _blackListedBots.push(address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D));
232 
233         _isBlackListedBot[address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763)] = true;
234         _blackListedBots.push(address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763));
235 
236         _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
237         _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
238 
239         _isBlackListedBot[address(0x000000000035B5e5ad9019092C665357240f594e)] = true;
240         _blackListedBots.push(address(0x000000000035B5e5ad9019092C665357240f594e));
241 
242         _isBlackListedBot[address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC)] = true;
243         _blackListedBots.push(address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC));
244 
245         _isBlackListedBot[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
246         _blackListedBots.push(address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D));
247 
248         _isBlackListedBot[address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C)] = true;
249         _blackListedBots.push(address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C));
250 
251         _isBlackListedBot[address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA)] = true;
252         _blackListedBots.push(address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA));
253         
254         _isBlackListedBot[address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7)] = true;
255         _blackListedBots.push(address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7));
256 
257         _isBlackListedBot[address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381)] = true;
258         _blackListedBots.push(address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381));
259 
260         _isBlackListedBot[address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31)] = true;
261         _blackListedBots.push(address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31));
262 
263         _isBlackListedBot[address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27)] = true;
264         _blackListedBots.push(address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27));
265 
266         _isBlackListedBot[address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830)] = true;
267         _blackListedBots.push(address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830));
268 
269         _isBlackListedBot[address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7)] = true;
270         _blackListedBots.push(address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7));
271 
272         _isBlackListedBot[address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da)] = true;
273         _blackListedBots.push(address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da));
274 
275         _isBlackListedBot[address(0x5136a9A5D077aE4247C7706b577F77153C32A01C)] = true;
276         _blackListedBots.push(address(0x5136a9A5D077aE4247C7706b577F77153C32A01C));
277 
278         _isBlackListedBot[address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be)] = true;
279         _blackListedBots.push(address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be));
280 
281         _isBlackListedBot[address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12)] = true;
282         _blackListedBots.push(address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12));
283 
284         _isBlackListedBot[address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47)] = true;
285         _blackListedBots.push(address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47));
286 
287         _isBlackListedBot[address(0x80e09203480A49f3Cf30a4714246f7af622ba470)] = true;
288         _blackListedBots.push(address(0x80e09203480A49f3Cf30a4714246f7af622ba470));
289 
290         _isBlackListedBot[address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4)] = true;
291         _blackListedBots.push(address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4));
292 
293         _isBlackListedBot[address(0xa57Bd00134B2850B2a1c55860c9e9ea100fDd6CF)] = true;
294         _blackListedBots.push(address(0xa57Bd00134B2850B2a1c55860c9e9ea100fDd6CF));
295 
296         _isBlackListedBot[address(0x0000000000007F150Bd6f54c40A34d7C3d5e9f56)] = true;
297         _blackListedBots.push(address(0x0000000000007F150Bd6f54c40A34d7C3d5e9f56));
298 
299     
300 
301         emit Transfer(address(0), _msgSender(), _tTotal);
302     }
303 
304     function name() public pure returns (string memory) {
305         return _name;
306     }
307 
308     function symbol() public pure returns (string memory) {
309         return _symbol;
310     }
311 
312     function decimals() public pure returns (uint8) {
313         return _decimals;
314     }
315 
316     function totalSupply() public pure override returns (uint256) {
317         return _tTotal;
318     }
319 
320     function balanceOf(address account) public view override returns (uint256) {
321         return tokenFromReflection(_rOwned[account]);
322     }
323 
324     function transfer(address recipient, uint256 amount) public override returns (bool) {
325         _transfer(_msgSender(), recipient, amount);
326         return true;
327     }
328 
329     function allowance(address owner, address spender) public view override returns (uint256) {
330         return _allowances[owner][spender];
331     }
332 
333     function approve(address spender, uint256 amount) public override returns (bool) {
334         _approve(_msgSender(), spender, amount);
335         return true;
336     }
337 
338     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
339         _transfer(sender, recipient, amount);
340         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
341         return true;
342     }
343 
344     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
345         require(rAmount <= _rTotal, "Amount must be less than total reflections");
346         uint256 currentRate =  _getRate();
347         return rAmount.div(currentRate);
348     }
349 
350     function removeAllFee() private {
351         if(_taxFee == 0 && _teamFee == 0) return;
352         _previousTaxFee = _taxFee;
353         _previousteamFee = _teamFee;
354         _taxFee = 0;
355         _teamFee = 0;
356     }
357     
358     function restoreAllFee() private {
359         _taxFee = _previousTaxFee;
360         _teamFee = _previousteamFee;
361     }
362 
363     function _approve(address owner, address spender, uint256 amount) private {
364         require(owner != address(0), "ERC20: approve from the zero address");
365         require(spender != address(0), "ERC20: approve to the zero address");
366         _allowances[owner][spender] = amount;
367         emit Approval(owner, spender, amount);
368     }
369 
370     function _transfer(address from, address to, uint256 amount) private {
371         require(from != address(0), "ERC20: transfer from the zero address");
372         require(to != address(0), "ERC20: transfer to the zero address");
373         require(amount > 0, "Transfer amount must be greater than zero");
374         require(!_isBlackListedBot[to], "You have no power here!");
375         require(!_isBlackListedBot[msg.sender], "You have no power here!");
376 
377         if(from != owner() && to != owner()) {
378             if(_cooldownEnabled) {
379                 if(!cooldown[msg.sender].exists) {
380                     cooldown[msg.sender] = User(0,0,true);
381                 }
382             }
383 
384             // buy
385             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
386                 require(tradingOpen, "Trading not yet enabled.");
387                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
388                 _taxFee = _BuytaxFee;
389                 _teamFee = _BuyteamFee;
390                 if(_cooldownEnabled) {
391                     if(buyLimitEnd > block.timestamp) {
392                         require(amount <= _maxBuyAmount);
393                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
394                         cooldown[to].buy = block.timestamp + (15 seconds);
395                     }
396                 }
397             }
398 
399             // sell
400             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
401                 _taxFee = _SelltaxFee;
402                 _teamFee = _SellteamFee;
403             }
404 
405             uint256 contractTokenBalance = balanceOf(address(this));
406             
407             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
408                 if(contractTokenBalance > 0) {
409                     swapTokensForEth(contractTokenBalance);
410                 }
411                 uint256 contractETHBalance = address(this).balance;
412                 if(contractETHBalance > 0) {
413                     sendETHToFee(address(this).balance);
414                 }
415             }
416         }
417         bool takeFee = true;
418 
419         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
420             takeFee = false;
421         }
422         
423         _tokenTransfer(from,to,amount,takeFee);
424     }
425 
426     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
427         address[] memory path = new address[](2);
428         path[0] = address(this);
429         path[1] = uniswapV2Router.WETH();
430         _approve(address(this), address(uniswapV2Router), tokenAmount);
431         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
432             tokenAmount,
433             0,
434             path,
435             address(this),
436             block.timestamp
437         );
438     }
439         
440     function sendETHToFee(uint256 amount) private {
441         _FeeAddress.transfer(amount.div(2));
442         _FeeAddress2.transfer(amount.div(2));
443     }
444 
445     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
446         if(!takeFee)
447             removeAllFee();
448         if (_isExcluded[sender] && !_isExcluded[recipient]) {
449             _transferFromExcluded(sender, recipient, amount);
450         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
451             _transferToExcluded(sender, recipient, amount);
452         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
453             _transferStandard(sender, recipient, amount);
454         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
455             _transferBothExcluded(sender, recipient, amount);
456         } else {
457             _transferStandard(sender, recipient, amount);
458         }
459         if(!takeFee || sender == uniswapV2Pair || recipient == uniswapV2Pair)
460             restoreAllFee();
461     }
462 
463     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
464         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
465         _rOwned[sender] = _rOwned[sender].sub(rAmount);
466         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
467         _takeTeam(tTeam);
468         _reflectFee(rFee, tFee);
469         emit Transfer(sender, recipient, tTransferAmount);
470     }
471     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
472         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
473         _rOwned[sender] = _rOwned[sender].sub(rAmount);
474         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
475         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
476         _takeTeam(tTeam);
477         _reflectFee(rFee, tFee);
478         emit Transfer(sender, recipient, tTransferAmount);
479     }
480     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
481         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
482         _tOwned[sender] = _tOwned[sender].sub(tAmount);
483         _rOwned[sender] = _rOwned[sender].sub(rAmount);
484         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
485         _takeTeam(tTeam);
486         _reflectFee(rFee, tFee);
487         emit Transfer(sender, recipient, tTransferAmount);
488     }
489     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
490         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
491         _tOwned[sender] = _tOwned[sender].sub(tAmount);
492         _rOwned[sender] = _rOwned[sender].sub(rAmount);
493         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
494         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
495         _takeTeam(tTeam);
496         _reflectFee(rFee, tFee);
497         emit Transfer(sender, recipient, tTransferAmount);
498     }
499 
500     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
501         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
502         uint256 currentRate =  _getRate();
503         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
504         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
505     }
506 
507     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
508         uint256 tFee = tAmount.mul(taxFee).div(100);
509         uint256 tTeam = tAmount.mul(TeamFee).div(100);
510         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
511         return (tTransferAmount, tFee, tTeam);
512     }
513 
514     function _getRate() private view returns(uint256) {
515         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
516         return rSupply.div(tSupply);
517     }
518 
519     function _getCurrentSupply() private view returns(uint256, uint256) {
520         uint256 rSupply = _rTotal;
521         uint256 tSupply = _tTotal;
522         for (uint256 i = 0; i < _excluded.length; i++) {
523             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
524             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
525             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
526         }
527         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
528         return (rSupply, tSupply);
529     }
530 
531     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
532         uint256 rAmount = tAmount.mul(currentRate);
533         uint256 rFee = tFee.mul(currentRate);
534         uint256 rTeam = tTeam.mul(currentRate);
535         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
536         return (rAmount, rTransferAmount, rFee);
537     }
538 
539     function _takeTeam(uint256 tTeam) private {
540         uint256 currentRate =  _getRate();
541         uint256 rTeam = tTeam.mul(currentRate);
542 
543         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
544     }
545 
546     function _reflectFee(uint256 rFee, uint256 tFee) private {
547         _rTotal = _rTotal.sub(rFee);
548         _tFeeTotal = _tFeeTotal.add(tFee);
549     }
550 
551     receive() external payable {}
552     
553     function addLiquidity() external onlyOwner() {
554         require(!tradingOpen,"trading is already open");
555         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
556         uniswapV2Router = _uniswapV2Router;
557         _approve(address(this), address(uniswapV2Router), _tTotal);
558         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
559         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
560         _maxBuyAmount = 20000000000000001 * 10**9; // 2% TX LIMIT 
561         _launchTime = block.timestamp;
562         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
563     }
564 
565     function openTrading() public onlyOwner {
566         tradingOpen = true;
567         buyLimitEnd = block.timestamp + (300 seconds);
568     }
569 
570     function manualswap() external {
571         require(_msgSender() == _FeeAddress);
572         uint256 contractBalance = balanceOf(address(this));
573         swapTokensForEth(contractBalance);
574     }
575     
576     function manualsend() external {
577         require(_msgSender() == _FeeAddress);
578         uint256 contractETHBalance = address(this).balance;
579         sendETHToFee(contractETHBalance);
580     }
581 
582     function setCooldownEnabled(bool onoff) external onlyOwner() {
583         _cooldownEnabled = onoff;
584         emit CooldownEnabledUpdated(_cooldownEnabled);
585     }
586     
587     function isExcluded(address account) public view returns (bool) {
588         return _isExcluded[account];
589     }
590     
591     function excludeAccount(address account) external onlyOwner() {
592         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
593         require(!_isExcluded[account], "Account is already excluded");
594         if(_rOwned[account] > 0) {
595             _tOwned[account] = tokenFromReflection(_rOwned[account]);
596         }
597         _isExcluded[account] = true;
598         _excluded.push(account);
599     }
600 
601     function includeAccount(address account) external onlyOwner() {
602         require(_isExcluded[account], "Account is already excluded");
603         for (uint256 i = 0; i < _excluded.length; i++) {
604             if (_excluded[i] == account) {
605                 _excluded[i] = _excluded[_excluded.length - 1];
606                 _tOwned[account] = 0;
607                 _isExcluded[account] = false;
608                 _excluded.pop();
609                 break;
610             }
611         }
612     }
613     
614     function isExcludedFromFee(address account) public view returns(bool) {
615         return _isExcludedFromFee[account];
616     }
617     
618     function isBlackListed(address account) public view returns (bool) {
619         return _isBlackListedBot[account];
620     }
621     
622     function addBotToBlackList(address account) external {
623         require(_msgSender() == _FeeAddress);
624         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, "We can not blacklist Uniswap router.");
625         require(!_isBlackListedBot[account], "Account is already blacklisted");
626         _isBlackListedBot[account] = true;
627         _blackListedBots.push(account);
628     }
629 
630 
631     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
632         require(newNum >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxWallet lower than 2%");
633         maxWallet = newNum * (10**9);
634     }
635     
636     function removeBotFromBlackList(address account) external {
637         require(_msgSender() == _FeeAddress);
638         require(_isBlackListedBot[account], "Account is not blacklisted");
639         for (uint256 i = 0; i < _blackListedBots.length; i++) {
640             if (_blackListedBots[i] == account) {
641                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
642                 _isBlackListedBot[account] = false;
643                 _blackListedBots.pop();
644                 break;
645             }
646         }
647     }
648 
649     function getSniperAmt(address account) external onlyOwner {
650         (account);
651     }
652     
653 
654     function removeSniper(address account) external onlyOwner {
655         (account);
656     }
657     
658     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
659         _isExcludedFromFee[account] = excluded;
660     }
661 
662     function cooldownEnabled() public view returns (bool) {
663         return _cooldownEnabled;
664     }
665 
666     function timeToBuy(address buyer) public view returns (uint) {
667         return block.timestamp - cooldown[buyer].buy;
668     }
669 
670     function amountInPool() public view returns (uint) {
671         return balanceOf(uniswapV2Pair);
672     }
673     
674 }