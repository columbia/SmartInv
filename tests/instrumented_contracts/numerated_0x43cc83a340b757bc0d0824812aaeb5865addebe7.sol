1 /**
2 
3 SPDX-License-Identifier: UNLICENSED 
4 */
5 pragma solidity ^0.8.4;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if(a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         return c;
58     }
59 
60     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61         return mod(a, b, "SafeMath: modulo by zero");
62     }
63 
64     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b != 0, errorMessage);
66         return a % b;
67     }
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     address private _previousOwner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }  
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract vamp is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _rOwned;
124     mapping (address => uint256) private _tOwned;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private _isExcluded;
128     address[] private _excluded;
129     mapping (address => bool) private _isBlackListedBot;
130     address[] private _blackListedBots;
131     
132     mapping (address => User) private cooldown;
133     uint256 private constant MAX = ~uint256(0);
134     uint256 private constant _tTotal = 1 * 1e12 * 10**9;
135     uint256 private _rTotal = (MAX - (MAX % _tTotal));
136     uint256 private _tFeeTotal;
137     string private constant _name = unicode"Vampire Inu";
138     string private constant _symbol = unicode"VAMP";
139     uint8 private constant _decimals = 9;
140     uint256 private _taxFee = 1;
141     uint256 private _teamFee = 9;
142     uint256 private _launchTime;
143     uint256 private _previousTaxFee = _taxFee;
144     uint256 private _previousteamFee = _teamFee;
145     uint256 private _maxBuyAmount;
146     uint256 public maxWallet =  _tTotal * 2 / 100; 
147     
148     address payable private _FeeAddress;
149     address payable private _FeeAddress2;
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private _cooldownEnabled = true;
154     bool private inSwap = false;
155     uint256 private buyLimitEnd;
156 
157     
158 
159     struct User {
160         uint256 buy;
161         uint256 sell;
162         bool exists;
163     }
164 
165     event MaxBuyAmountUpdated(uint _maxBuyAmount);
166     event CooldownEnabledUpdated(bool _cooldown);
167 
168     modifier lockTheSwap {
169         inSwap = true;
170         _;
171         inSwap = false;
172     }
173     constructor (address payable FeeAddress, address payable FeeAddress2) {
174         _FeeAddress = FeeAddress;
175         _FeeAddress2 = FeeAddress2;
176         _rOwned[_msgSender()] = _rTotal;
177         _isExcludedFromFee[owner()] = true;
178         _isExcludedFromFee[address(this)] = true;
179         
180         _isExcludedFromFee[FeeAddress] = true;
181         _isExcludedFromFee[FeeAddress2] = true;
182         
183         _isBlackListedBot[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
184         _blackListedBots.push(address(0x66f049111958809841Bbe4b81c034Da2D953AA0c));
185         
186         _isBlackListedBot[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
187         _blackListedBots.push(address(0x000000005736775Feb0C8568e7DEe77222a26880));
188         
189         _isBlackListedBot[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
190         _blackListedBots.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
191         
192         _isBlackListedBot[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
193         _blackListedBots.push(address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D));
194 
195         _isBlackListedBot[address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763)] = true;
196         _blackListedBots.push(address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763));
197 
198         _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
199         _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
200 
201         _isBlackListedBot[address(0x000000000035B5e5ad9019092C665357240f594e)] = true;
202         _blackListedBots.push(address(0x000000000035B5e5ad9019092C665357240f594e));
203 
204         _isBlackListedBot[address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC)] = true;
205         _blackListedBots.push(address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC));
206 
207         _isBlackListedBot[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
208         _blackListedBots.push(address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D));
209 
210         _isBlackListedBot[address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C)] = true;
211         _blackListedBots.push(address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C));
212 
213         _isBlackListedBot[address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA)] = true;
214         _blackListedBots.push(address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA));
215         
216         _isBlackListedBot[address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7)] = true;
217         _blackListedBots.push(address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7));
218 
219         _isBlackListedBot[address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381)] = true;
220         _blackListedBots.push(address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381));
221 
222         _isBlackListedBot[address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31)] = true;
223         _blackListedBots.push(address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31));
224 
225         _isBlackListedBot[address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27)] = true;
226         _blackListedBots.push(address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27));
227 
228         _isBlackListedBot[address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830)] = true;
229         _blackListedBots.push(address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830));
230 
231         _isBlackListedBot[address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7)] = true;
232         _blackListedBots.push(address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7));
233 
234         _isBlackListedBot[address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da)] = true;
235         _blackListedBots.push(address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da));
236 
237         _isBlackListedBot[address(0x5136a9A5D077aE4247C7706b577F77153C32A01C)] = true;
238         _blackListedBots.push(address(0x5136a9A5D077aE4247C7706b577F77153C32A01C));
239 
240         _isBlackListedBot[address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be)] = true;
241         _blackListedBots.push(address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be));
242 
243         _isBlackListedBot[address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12)] = true;
244         _blackListedBots.push(address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12));
245 
246         _isBlackListedBot[address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47)] = true;
247         _blackListedBots.push(address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47));
248 
249         _isBlackListedBot[address(0x80e09203480A49f3Cf30a4714246f7af622ba470)] = true;
250         _blackListedBots.push(address(0x80e09203480A49f3Cf30a4714246f7af622ba470));
251 
252         _isBlackListedBot[address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4)] = true;
253         _blackListedBots.push(address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4));
254 
255         emit Transfer(address(0), _msgSender(), _tTotal);
256     }
257 
258     function name() public pure returns (string memory) {
259         return _name;
260     }
261 
262     function symbol() public pure returns (string memory) {
263         return _symbol;
264     }
265 
266     function decimals() public pure returns (uint8) {
267         return _decimals;
268     }
269 
270     function totalSupply() public pure override returns (uint256) {
271         return _tTotal;
272     }
273 
274     function balanceOf(address account) public view override returns (uint256) {
275         return tokenFromReflection(_rOwned[account]);
276     }
277 
278     function transfer(address recipient, uint256 amount) public override returns (bool) {
279         _transfer(_msgSender(), recipient, amount);
280         return true;
281     }
282 
283     function allowance(address owner, address spender) public view override returns (uint256) {
284         return _allowances[owner][spender];
285     }
286 
287     function approve(address spender, uint256 amount) public override returns (bool) {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291 
292     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
295         return true;
296     }
297 
298     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
299         require(rAmount <= _rTotal, "Amount must be less than total reflections");
300         uint256 currentRate =  _getRate();
301         return rAmount.div(currentRate);
302     }
303 
304     function removeAllFee() private {
305         if(_taxFee == 0 && _teamFee == 0) return;
306         _previousTaxFee = _taxFee;
307         _previousteamFee = _teamFee;
308         _taxFee = 0;
309         _teamFee = 0;
310     }
311     
312     function restoreAllFee() private {
313         _taxFee = _previousTaxFee;
314         _teamFee = _previousteamFee;
315     }
316 
317     function _approve(address owner, address spender, uint256 amount) private {
318         require(owner != address(0), "ERC20: approve from the zero address");
319         require(spender != address(0), "ERC20: approve to the zero address");
320         _allowances[owner][spender] = amount;
321         emit Approval(owner, spender, amount);
322     }
323 
324     function _transfer(address from, address to, uint256 amount) private {
325         require(from != address(0), "ERC20: transfer from the zero address");
326         require(to != address(0), "ERC20: transfer to the zero address");
327         require(amount > 0, "Transfer amount must be greater than zero");
328         require(!_isBlackListedBot[to], "You have no power here!");
329         require(!_isBlackListedBot[msg.sender], "You have no power here!");
330 
331         if(from != owner() && to != owner()) {
332             if(_cooldownEnabled) {
333                 if(!cooldown[msg.sender].exists) {
334                     cooldown[msg.sender] = User(0,0,true);
335                 }
336             }
337 
338             // buy
339             if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
340                 require(tradingOpen, "Trading not yet enabled.");
341                 require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
342                 _taxFee = 1;
343                 _teamFee = 9;
344                 if(_cooldownEnabled) {
345                     if(buyLimitEnd > block.timestamp) {
346                         require(amount <= _maxBuyAmount);
347                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
348                         cooldown[to].buy = block.timestamp + (15 seconds);
349                     }
350                 }
351             }
352 
353             // sell
354             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
355                 _taxFee = 1;
356                 _teamFee = 9;
357             }
358 
359             uint256 contractTokenBalance = balanceOf(address(this));
360             
361             if(!inSwap && from != uniswapV2Pair && tradingOpen) {
362                 if(contractTokenBalance > 0) {
363                     swapTokensForEth(contractTokenBalance);
364                 }
365                 uint256 contractETHBalance = address(this).balance;
366                 if(contractETHBalance > 0) {
367                     sendETHToFee(address(this).balance);
368                 }
369             }
370         }
371         bool takeFee = true;
372 
373         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
374             takeFee = false;
375         }
376         
377         _tokenTransfer(from,to,amount,takeFee);
378     }
379 
380     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
381         address[] memory path = new address[](2);
382         path[0] = address(this);
383         path[1] = uniswapV2Router.WETH();
384         _approve(address(this), address(uniswapV2Router), tokenAmount);
385         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
386             tokenAmount,
387             0,
388             path,
389             address(this),
390             block.timestamp
391         );
392     }
393         
394     function sendETHToFee(uint256 amount) private {
395         _FeeAddress.transfer(amount.div(2));
396         _FeeAddress2.transfer(amount.div(2));
397     }
398     
399     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
400         if(!takeFee)
401             removeAllFee();
402         if (_isExcluded[sender] && !_isExcluded[recipient]) {
403             _transferFromExcluded(sender, recipient, amount);
404         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
405             _transferToExcluded(sender, recipient, amount);
406         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
407             _transferStandard(sender, recipient, amount);
408         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
409             _transferBothExcluded(sender, recipient, amount);
410         } else {
411             _transferStandard(sender, recipient, amount);
412         }
413         if(!takeFee)
414             restoreAllFee();
415     }
416 
417     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
418         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
419         _rOwned[sender] = _rOwned[sender].sub(rAmount);
420         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
421         _takeTeam(tTeam);
422         _reflectFee(rFee, tFee);
423         emit Transfer(sender, recipient, tTransferAmount);
424     }
425     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
426         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
427         _rOwned[sender] = _rOwned[sender].sub(rAmount);
428         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
429         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
430         _takeTeam(tTeam);
431         _reflectFee(rFee, tFee);
432         emit Transfer(sender, recipient, tTransferAmount);
433     }
434     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
435         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
436         _tOwned[sender] = _tOwned[sender].sub(tAmount);
437         _rOwned[sender] = _rOwned[sender].sub(rAmount);
438         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
439         _takeTeam(tTeam);
440         _reflectFee(rFee, tFee);
441         emit Transfer(sender, recipient, tTransferAmount);
442     }
443     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
444         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
445         _tOwned[sender] = _tOwned[sender].sub(tAmount);
446         _rOwned[sender] = _rOwned[sender].sub(rAmount);
447         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
448         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
449         _takeTeam(tTeam);
450         _reflectFee(rFee, tFee);
451         emit Transfer(sender, recipient, tTransferAmount);
452     }
453 
454     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
455         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
456         uint256 currentRate =  _getRate();
457         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
458         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
459     }
460 
461     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
462         uint256 tFee = tAmount.mul(taxFee).div(100);
463         uint256 tTeam = tAmount.mul(TeamFee).div(100);
464         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
465         return (tTransferAmount, tFee, tTeam);
466     }
467 
468     function _getRate() private view returns(uint256) {
469         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
470         return rSupply.div(tSupply);
471     }
472 
473     function _getCurrentSupply() private view returns(uint256, uint256) {
474         uint256 rSupply = _rTotal;
475         uint256 tSupply = _tTotal;
476         for (uint256 i = 0; i < _excluded.length; i++) {
477             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
478             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
479             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
480         }
481         if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
482         return (rSupply, tSupply);
483     }
484 
485     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
486         uint256 rAmount = tAmount.mul(currentRate);
487         uint256 rFee = tFee.mul(currentRate);
488         uint256 rTeam = tTeam.mul(currentRate);
489         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
490         return (rAmount, rTransferAmount, rFee);
491     }
492 
493     function _takeTeam(uint256 tTeam) private {
494         uint256 currentRate =  _getRate();
495         uint256 rTeam = tTeam.mul(currentRate);
496 
497         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
498     }
499 
500     function _reflectFee(uint256 rFee, uint256 tFee) private {
501         _rTotal = _rTotal.sub(rFee);
502         _tFeeTotal = _tFeeTotal.add(tFee);
503     }
504 
505     receive() external payable {}
506     
507     function addLiquidity() external onlyOwner() {
508         require(!tradingOpen,"trading is already open");
509         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
510         uniswapV2Router = _uniswapV2Router;
511         _approve(address(this), address(uniswapV2Router), _tTotal);
512         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
513         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
514         _maxBuyAmount = 4500000000 * 10**9; // 0.45% TX LIMIT 
515         _launchTime = block.timestamp;
516         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
517     }
518 
519     function openTrading() public onlyOwner {
520         tradingOpen = true;
521         buyLimitEnd = block.timestamp + (300 seconds);
522     }
523 
524     function manualswap() external {
525         require(_msgSender() == _FeeAddress);
526         uint256 contractBalance = balanceOf(address(this));
527         swapTokensForEth(contractBalance);
528     }
529     
530     function manualsend() external {
531         require(_msgSender() == _FeeAddress);
532         uint256 contractETHBalance = address(this).balance;
533         sendETHToFee(contractETHBalance);
534     }
535 
536     function setCooldownEnabled(bool onoff) external onlyOwner() {
537         _cooldownEnabled = onoff;
538         emit CooldownEnabledUpdated(_cooldownEnabled);
539     }
540     
541     function isExcluded(address account) public view returns (bool) {
542         return _isExcluded[account];
543     }
544     
545     function excludeAccount(address account) external onlyOwner() {
546         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
547         require(!_isExcluded[account], "Account is already excluded");
548         if(_rOwned[account] > 0) {
549             _tOwned[account] = tokenFromReflection(_rOwned[account]);
550         }
551         _isExcluded[account] = true;
552         _excluded.push(account);
553     }
554 
555     function includeAccount(address account) external onlyOwner() {
556         require(_isExcluded[account], "Account is already excluded");
557         for (uint256 i = 0; i < _excluded.length; i++) {
558             if (_excluded[i] == account) {
559                 _excluded[i] = _excluded[_excluded.length - 1];
560                 _tOwned[account] = 0;
561                 _isExcluded[account] = false;
562                 _excluded.pop();
563                 break;
564             }
565         }
566     }
567     
568     function isExcludedFromFee(address account) public view returns(bool) {
569         return _isExcludedFromFee[account];
570     }
571     
572     function isBlackListed(address account) public view returns (bool) {
573         return _isBlackListedBot[account];
574     }
575     
576     function addBotToBlackList(address account) external onlyOwner() {
577         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
578         require(!_isBlackListedBot[account], "Account is already blacklisted");
579         _isBlackListedBot[account] = true;
580         _blackListedBots.push(account);
581     }
582 
583     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
584         require(newNum >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxWallet lower than 2%");
585         maxWallet = newNum * (10**9);
586     }
587     
588     function removeBotFromBlackList(address account) external onlyOwner() {
589         require(_isBlackListedBot[account], "Account is not blacklisted");
590         for (uint256 i = 0; i < _blackListedBots.length; i++) {
591             if (_blackListedBots[i] == account) {
592                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
593                 _isBlackListedBot[account] = false;
594                 _blackListedBots.pop();
595                 break;
596             }
597         }
598     }
599     
600     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
601         _isExcludedFromFee[account] = excluded;
602     }
603 
604     function thisBalance() public view returns (uint) {
605         return balanceOf(address(this));
606     }
607 
608     function cooldownEnabled() public view returns (bool) {
609         return _cooldownEnabled;
610     }
611 
612     function timeToBuy(address buyer) public view returns (uint) {
613         return block.timestamp - cooldown[buyer].buy;
614     }
615 
616     function amountInPool() public view returns (uint) {
617         return balanceOf(uniswapV2Pair);
618     }
619 }