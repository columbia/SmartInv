1 /*
2               🚀                        🐕
3             /)-_-(\                    /)-_-(\
4              (o o)                      (o o)
5      .-----__/\o/                        \o/\__-----.
6     /  __      /       Bonsai Inu         \      __  \
7 \__/\ /  \_\ |/                            \| /_/  \ /\__/
8      \\     ||       t.me/bonsaiinu        ||      \\
9      //     ||                             ||      //
10      |\     |\                             /|     /|
11                          ,.,
12                    MMMM_    ,..,
13                      "_ "__"MMMMM          ,...,,
14               ,..., __." --"    ,.,     _-"MMMMMMM
15              MMMMMM"___ "_._   MMM"_."" _ """"""
16               """""    "" , \_.   "_. ."
17                      ,., _"__ \__./ ."
18                     MMMMM_"  "_    ./
19                      ''''      (    )
20               ._______________.-'____"---._.
21                \                          /
22                 \________________________/
23                 (_)                    (_)
24 
25 From the makers of $DONSHIBA, we present to you... Bonsai Inu!
26 Bonsai Inu was raised in the Aokigahara jungle. 
27 The fresh air coming from Mount Hotaka breezes through the jungle flora, and made sure all those who were raised here would be stronger then any of it's species.
28 Bonsai Inu dropped his past, since his superior bloodline was always involved in conflicts between different Inu tribes. 
29 His interests for taking care of Bonsai trees increased over the year.
30 Holding Bonsai Inu will be rewarding because of the reflection & redistribution tokenomics. 
31 As always, the developer will fund the starting liquidity, and after a burn there will be no wallets with any sort of tokens. 
32 Fairest launch possible! Fake presale wallets and owner wallets are something Bonsai Inu doesn't want to see!
33 What Bonsai Inu offers you:
34 
35 1. Buy limit and cooldown timer on buys to make sure no automated bots have a chance to snipe big portions of the pool.
36 2. No Team & Marketing wallet. After a 15% burn, 85% of the tokens will come on the market for trade. 
37 3. No presale wallets that can dump on the community. This is in my eyes, illegal! 
38 4. A fast growing community that has a passion for ERC20 meme tokens! 
39 5. Very nicely, from scratch made Bonsai Inu art, so those who take a glimps at him, will never forget it. 
40 
41 Token Information
42 1. 100,000,000,000 Total Supply
43 2. 15% Burned
44 3. Developer provides LP
45 4. Buy limit/cool down
46 5. Fair launch for everyone! 
47 6. 5% redistribution to holders
48 7. 10% developer fee split within the team
49 
50 Join our telegram: t.me/bonsaiinu
51 
52 Good luck on launch!
53 
54 */
55 
56 // SPDX-License-Identifier: Unlicensed
57 pragma solidity ^0.8.4;
58 
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 }
64 
65 interface IERC20 {
66     function totalSupply() external view returns (uint256);
67     function balanceOf(address account) external view returns (uint256);
68     function transfer(address recipient, uint256 amount) external returns (bool);
69     function allowance(address owner, address spender) external view returns (uint256);
70     function approve(address spender, uint256 amount) external returns (bool);
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80         return c;
81     }
82 
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86 
87     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         return c;
91     }
92 
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99         return c;
100     }
101 
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         return c;
110     }
111 
112 }
113 
114 contract Ownable is Context {
115     address private _owner;
116     address private _previousOwner;
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     constructor () {
120         address msgSender = _msgSender();
121         _owner = msgSender;
122         emit OwnershipTransferred(address(0), msgSender);
123     }
124 
125     function owner() public view returns (address) {
126         return _owner;
127     }
128 
129     modifier onlyOwner() {
130         require(_owner == _msgSender(), "Ownable: caller is not the owner");
131         _;
132     }
133 
134     function renounceOwnership() public virtual onlyOwner {
135         emit OwnershipTransferred(_owner, address(0));
136         _owner = address(0);
137     }
138 
139 }  
140 
141 interface IUniswapV2Factory {
142     function createPair(address tokenA, address tokenB) external returns (address pair);
143 }
144 
145 interface IUniswapV2Router02 {
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153     function factory() external pure returns (address);
154     function WETH() external pure returns (address);
155     function addLiquidityETH(
156         address token,
157         uint amountTokenDesired,
158         uint amountTokenMin,
159         uint amountETHMin,
160         address to,
161         uint deadline
162     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
163 }
164 
165 contract BONINU is Context, IERC20, Ownable {
166     using SafeMath for uint256;
167     mapping (address => uint256) private _rOwned;
168     mapping (address => uint256) private _tOwned;
169     mapping (address => mapping (address => uint256)) private _allowances;
170     mapping (address => bool) private _isExcludedFromFee;
171     mapping (address => bool) private bots;
172     mapping (address => uint) private cooldown;
173     uint256 private constant MAX = ~uint256(0);
174     uint256 private constant _tTotal = 1000000000000 * 10**9;
175     uint256 private _rTotal = (MAX - (MAX % _tTotal));
176     uint256 private _tFeeTotal;
177     string private constant _name = "Bonsai Inu\xf0\x9f\x8d\x83\xf0\x9f\x90\x95\xf0\x9f\x8c\xb1\xf0\x9f\x8d\x83";
178     string private constant _symbol = 'BONINU';
179     uint8 private constant _decimals = 9;
180     uint256 private _taxFee = 5;
181     uint256 private _teamFee = 10;
182     uint256 private _previousTaxFee = _taxFee;
183     uint256 private _previousteamFee = _teamFee;
184     address payable private _FeeAddress;
185     address payable private _marketingWalletAddress;
186     IUniswapV2Router02 private uniswapV2Router;
187     address private uniswapV2Pair;
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = false;
191     bool private cooldownEnabled = false;
192     uint256 private _maxTxAmount = _tTotal;
193     event MaxTxAmountUpdated(uint _maxTxAmount);
194     modifier lockTheSwap {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
200         _FeeAddress = FeeAddress;
201         _marketingWalletAddress = marketingWalletAddress;
202         _rOwned[_msgSender()] = _rTotal;
203         _isExcludedFromFee[owner()] = true;
204         _isExcludedFromFee[address(this)] = true;
205         _isExcludedFromFee[FeeAddress] = true;
206         _isExcludedFromFee[marketingWalletAddress] = true;
207         emit Transfer(address(0), _msgSender(), _tTotal);
208     }
209 
210     function name() public pure returns (string memory) {
211         return _name;
212     }
213 
214     function symbol() public pure returns (string memory) {
215         return _symbol;
216     }
217 
218     function decimals() public pure returns (uint8) {
219         return _decimals;
220     }
221 
222     function totalSupply() public pure override returns (uint256) {
223         return _tTotal;
224     }
225 
226     function balanceOf(address account) public view override returns (uint256) {
227         return tokenFromReflection(_rOwned[account]);
228     }
229 
230     function transfer(address recipient, uint256 amount) public override returns (bool) {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     function allowance(address owner, address spender) public view override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     function approve(address spender, uint256 amount) public override returns (bool) {
240         _approve(_msgSender(), spender, amount);
241         return true;
242     }
243 
244     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
245         _transfer(sender, recipient, amount);
246         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
247         return true;
248     }
249 
250     function setCooldownEnabled(bool onoff) external onlyOwner() {
251         cooldownEnabled = onoff;
252     }
253 
254     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
255         require(rAmount <= _rTotal, "Amount must be less than total reflections");
256         uint256 currentRate =  _getRate();
257         return rAmount.div(currentRate);
258     }
259 
260     function removeAllFee() private {
261         if(_taxFee == 0 && _teamFee == 0) return;
262         _previousTaxFee = _taxFee;
263         _previousteamFee = _teamFee;
264         _taxFee = 0;
265         _teamFee = 0;
266     }
267     
268     function restoreAllFee() private {
269         _taxFee = _previousTaxFee;
270         _teamFee = _previousteamFee;
271     }
272 
273     function _approve(address owner, address spender, uint256 amount) private {
274         require(owner != address(0), "ERC20: approve from the zero address");
275         require(spender != address(0), "ERC20: approve to the zero address");
276         _allowances[owner][spender] = amount;
277         emit Approval(owner, spender, amount);
278     }
279 
280     function _transfer(address from, address to, uint256 amount) private {
281         require(from != address(0), "ERC20: transfer from the zero address");
282         require(to != address(0), "ERC20: transfer to the zero address");
283         require(amount > 0, "Transfer amount must be greater than zero");
284         
285         if (from != owner() && to != owner()) {
286             if (cooldownEnabled) {
287                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
288                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
289                 }
290             }
291             require(amount <= _maxTxAmount);
292             require(!bots[from] && !bots[to]);
293             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
294                 require(cooldown[to] < block.timestamp);
295                 cooldown[to] = block.timestamp + (30 seconds);
296             }
297             uint256 contractTokenBalance = balanceOf(address(this));
298             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
299                 swapTokensForEth(contractTokenBalance);
300                 uint256 contractETHBalance = address(this).balance;
301                 if(contractETHBalance > 0) {
302                     sendETHToFee(address(this).balance);
303                 }
304             }
305         }
306         bool takeFee = true;
307 
308         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
309             takeFee = false;
310         }
311 		
312         _tokenTransfer(from,to,amount,takeFee);
313     }
314 
315     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
316         address[] memory path = new address[](2);
317         path[0] = address(this);
318         path[1] = uniswapV2Router.WETH();
319         _approve(address(this), address(uniswapV2Router), tokenAmount);
320         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
321             tokenAmount,
322             0,
323             path,
324             address(this),
325             block.timestamp
326         );
327     }
328         
329     function sendETHToFee(uint256 amount) private {
330         _FeeAddress.transfer(amount.div(2));
331         _marketingWalletAddress.transfer(amount.div(2));
332     }
333 
334     function openTrading() external onlyOwner() {
335         require(!tradingOpen,"trading is already open");
336         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
337         uniswapV2Router = _uniswapV2Router;
338         _approve(address(this), address(uniswapV2Router), _tTotal);
339         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
340         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
341         swapEnabled = true;
342         cooldownEnabled = true;
343         _maxTxAmount = 4250000000 * 10**9;
344         tradingOpen = true;
345         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
346     }
347     
348     function manualswap() external {
349         require(_msgSender() == _FeeAddress);
350         uint256 contractBalance = balanceOf(address(this));
351         swapTokensForEth(contractBalance);
352     }
353     
354     function manualsend() external {
355         require(_msgSender() == _FeeAddress);
356         uint256 contractETHBalance = address(this).balance;
357         sendETHToFee(contractETHBalance);
358     }
359     
360     function setBots(address[] memory bots_) public onlyOwner {
361         for (uint i = 0; i < bots_.length; i++) {
362             bots[bots_[i]] = true;
363         }
364     }
365     
366     function delBot(address notbot) public onlyOwner {
367         bots[notbot] = false;
368     }
369         
370     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
371         if(!takeFee)
372             removeAllFee();
373         _transferStandard(sender, recipient, amount);
374         if(!takeFee)
375             restoreAllFee();
376     }
377 
378     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
379         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
380         _rOwned[sender] = _rOwned[sender].sub(rAmount);
381         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
382         _takeTeam(tTeam); 
383         _reflectFee(rFee, tFee);
384         emit Transfer(sender, recipient, tTransferAmount);
385     }
386 
387     function _takeTeam(uint256 tTeam) private {
388         uint256 currentRate =  _getRate();
389         uint256 rTeam = tTeam.mul(currentRate);
390         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
391     }
392 
393     function _reflectFee(uint256 rFee, uint256 tFee) private {
394         _rTotal = _rTotal.sub(rFee);
395         _tFeeTotal = _tFeeTotal.add(tFee);
396     }
397 
398     receive() external payable {}
399 
400     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
401         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
402         uint256 currentRate =  _getRate();
403         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
404         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
405     }
406 
407     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
408         uint256 tFee = tAmount.mul(taxFee).div(100);
409         uint256 tTeam = tAmount.mul(TeamFee).div(100);
410         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
411         return (tTransferAmount, tFee, tTeam);
412     }
413 
414     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
415         uint256 rAmount = tAmount.mul(currentRate);
416         uint256 rFee = tFee.mul(currentRate);
417         uint256 rTeam = tTeam.mul(currentRate);
418         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
419         return (rAmount, rTransferAmount, rFee);
420     }
421 
422     function _getRate() private view returns(uint256) {
423         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
424         return rSupply.div(tSupply);
425     }
426 
427     function _getCurrentSupply() private view returns(uint256, uint256) {
428         uint256 rSupply = _rTotal;
429         uint256 tSupply = _tTotal;      
430         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
431         return (rSupply, tSupply);
432     }
433         
434     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
435         require(maxTxPercent > 0, "Amount must be greater than 0");
436         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
437         emit MaxTxAmountUpdated(_maxTxAmount);
438     }
439 }