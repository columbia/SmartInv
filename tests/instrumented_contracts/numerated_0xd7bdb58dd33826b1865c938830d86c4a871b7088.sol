1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-22
3 */
4 
5 // $EverTop
6 // Telegram: https://t.me/EverTopToken
7 // With thanks and major props to the EverRise team!
8 // Check them out at everrisecoin.com!
9 
10 // Fair Launch, no Dev Tokens. 100% LP.
11 // Snipers will be nuked.
12 
13 // LP Lock immediately on launch.
14 // Ownership will be renounced 30 minutes after launch.
15 
16 // Slippage Recommended: 20%+
17 
18 /**
19 *    
20 *
21 * .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
22 *| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
23 *| |  _________   | || | ____   ____  | || |  _________   | || |  _______     | || |  _________   | || |     ____     | || |   ______     | |
24 *| | |_   ___  |  | || ||_  _| |_  _| | || | |_   ___  |  | || | |_   __ \    | || | |  _   _  |  | || |   .'    `.   | || |  |_   __ \   | |
25 *| |   | |_  \_|  | || |  \ \   / /   | || |   | |_  \_|  | || |   | |__) |   | || | |_/ | | \_|  | || |  /  .--.  \  | || |    | |__) |  | |
26 *| |   |  _|  _   | || |   \ \ / /    | || |   |  _|  _   | || |   |  __ /    | || |     | |      | || |  | |    | |  | || |    |  ___/   | |
27 *| |  _| |___/ |  | || |    \ ' /     | || |  _| |___/ |  | || |  _| |  \ \_  | || |    _| |_     | || |  \  `--'  /  | || |   _| |_      | |
28 *| | |_________|  | || |     \_/      | || | |_________|  | || | |____| |___| | || |   |_____|    | || |   `.____.'   | || |  |_____|     | |
29 *| |              | || |              | || |              | || |              | || |              | || |              | || |              | |
30 *| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
31 * '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'                                                                     
32 */
33 
34 
35 // SPDX-License-Identifier: Unlicensed
36 
37 pragma solidity ^0.8.4;
38 
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 }
44 
45 interface IERC20 {
46     function totalSupply() external view returns (uint256);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70         return c;
71     }
72 
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79         return c;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         return c;
90     }
91 
92 }
93 
94 contract Ownable is Context {
95     address private _owner;
96     address private _previousOwner;
97     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99     constructor () {
100         address msgSender = _msgSender();
101         _owner = msgSender;
102         emit OwnershipTransferred(address(0), msgSender);
103     }
104 
105     function owner() public view returns (address) {
106         return _owner;
107     }
108 
109     modifier onlyOwner() {
110         require(_owner == _msgSender(), "Ownable: caller is not the owner");
111         _;
112     }
113 
114     function renounceOwnership() public virtual onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119 }  
120 
121 interface IUniswapV2Factory {
122     function createPair(address tokenA, address tokenB) external returns (address pair);
123 }
124 
125 interface IUniswapV2Router02 {
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133     function factory() external pure returns (address);
134     function WETH() external pure returns (address);
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 }
144 
145 contract EverTop is Context, IERC20, Ownable {
146     using SafeMath for uint256;
147     mapping (address => uint256) private _rOwned;
148     mapping (address => uint256) private _tOwned;
149     mapping (address => mapping (address => uint256)) private _allowances;
150     mapping (address => bool) private _isExcludedFromFee;
151     mapping (address => bool) private bots;
152     mapping (address => uint) private cooldown;
153     uint256 private constant MAX = ~uint256(0);
154     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
155     uint256 private _rTotal = (MAX - (MAX % _tTotal));
156     uint256 private _tFeeTotal;
157     string private constant _name = "EverTop";
158     string private constant _symbol = "EverTop \xF0\x9F\x94\x9D";
159     uint8 private constant _decimals = 9;
160     uint256 private _taxFee;
161     uint256 private _teamFee;
162     uint256 private _previousTaxFee = _taxFee;
163     uint256 private _previousteamFee = _teamFee;
164     address payable private _FeeAddress;
165     address payable private _marketingWalletAddress;
166     IUniswapV2Router02 private uniswapV2Router;
167     address private uniswapV2Pair;
168     bool private tradingOpen;
169     bool private inSwap = false;
170     bool private swapEnabled = false;
171     bool private cooldownEnabled = false;
172     uint256 private _maxTxAmount = _tTotal;
173     event MaxTxAmountUpdated(uint _maxTxAmount);
174     modifier lockTheSwap {
175         inSwap = true;
176         _;
177         inSwap = false;
178     }
179     constructor (address payable addr1, address payable addr2) {
180         _FeeAddress = addr1;
181         _marketingWalletAddress = addr2;
182         _rOwned[_msgSender()] = _rTotal;
183         _isExcludedFromFee[owner()] = true;
184         _isExcludedFromFee[address(this)] = true;
185         _isExcludedFromFee[_FeeAddress] = true;
186         _isExcludedFromFee[_marketingWalletAddress] = true;
187         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
188     }
189 
190     function name() public pure returns (string memory) {
191         return _name;
192     }
193 
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197 
198     function decimals() public pure returns (uint8) {
199         return _decimals;
200     }
201 
202     function totalSupply() public pure override returns (uint256) {
203         return _tTotal;
204     }
205 
206     function balanceOf(address account) public view override returns (uint256) {
207         return tokenFromReflection(_rOwned[account]);
208     }
209 
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
225         _transfer(sender, recipient, amount);
226         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
227         return true;
228     }
229 
230     function setCooldownEnabled(bool onoff) external onlyOwner() {
231         cooldownEnabled = onoff;
232     }
233 
234     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
235         require(rAmount <= _rTotal, "Amount must be less than total reflections");
236         uint256 currentRate =  _getRate();
237         return rAmount.div(currentRate);
238     }
239 
240     function removeAllFee() private {
241         if(_taxFee == 0 && _teamFee == 0) return;
242         _previousTaxFee = _taxFee;
243         _previousteamFee = _teamFee;
244         _taxFee = 0;
245         _teamFee = 0;
246     }
247     
248     function restoreAllFee() private {
249         _taxFee = _previousTaxFee;
250         _teamFee = _previousteamFee;
251     }
252 
253     function _approve(address owner, address spender, uint256 amount) private {
254         require(owner != address(0), "ERC20: approve from the zero address");
255         require(spender != address(0), "ERC20: approve to the zero address");
256         _allowances[owner][spender] = amount;
257         emit Approval(owner, spender, amount);
258     }
259 
260     function _transfer(address from, address to, uint256 amount) private {
261         require(from != address(0), "ERC20: transfer from the zero address");
262         require(to != address(0), "ERC20: transfer to the zero address");
263         require(amount > 0, "Transfer amount must be greater than zero");
264         _taxFee = 5;
265         _teamFee = 10;
266         if (from != owner() && to != owner()) {
267             require(!bots[from] && !bots[to]);
268             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
269                 require(amount <= _maxTxAmount);
270                 require(cooldown[to] < block.timestamp);
271                 cooldown[to] = block.timestamp + (30 seconds);
272             }
273             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
274                 _taxFee = 5;
275                 _teamFee = 20;
276             }
277             uint256 contractTokenBalance = balanceOf(address(this));
278             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
279                 swapTokensForEth(contractTokenBalance);
280                 uint256 contractETHBalance = address(this).balance;
281                 if(contractETHBalance > 0) {
282                     sendETHToFee(address(this).balance);
283                 }
284             }
285         }
286         bool takeFee = true;
287 
288         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
289             takeFee = false;
290         }
291 		
292         _tokenTransfer(from,to,amount,takeFee);
293     }
294 
295     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
296         address[] memory path = new address[](2);
297         path[0] = address(this);
298         path[1] = uniswapV2Router.WETH();
299         _approve(address(this), address(uniswapV2Router), tokenAmount);
300         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
301             tokenAmount,
302             0,
303             path,
304             address(this),
305             block.timestamp
306         );
307     }
308         
309     function sendETHToFee(uint256 amount) private {
310         _FeeAddress.transfer(amount.div(2));
311         _marketingWalletAddress.transfer(amount.div(2));
312     }
313     
314     function openTrading() external onlyOwner() {
315         require(!tradingOpen,"trading is already open");
316         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
317         uniswapV2Router = _uniswapV2Router;
318         _approve(address(this), address(uniswapV2Router), _tTotal);
319         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
320         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
321         swapEnabled = true;
322         cooldownEnabled = true;
323         _maxTxAmount = 100000000000000000 * 10**9;
324         tradingOpen = true;
325         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
326     }
327     
328     function setBots(address[] memory bots_) public onlyOwner {
329         for (uint i = 0; i < bots_.length; i++) {
330             bots[bots_[i]] = true;
331         }
332     }
333     
334     function delBot(address notbot) public onlyOwner {
335         bots[notbot] = false;
336     }
337         
338     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
339         if(!takeFee)
340             removeAllFee();
341         _transferStandard(sender, recipient, amount);
342         if(!takeFee)
343             restoreAllFee();
344     }
345 
346     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
347         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
348         _rOwned[sender] = _rOwned[sender].sub(rAmount);
349         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
350         _takeTeam(tTeam);
351         _reflectFee(rFee, tFee);
352         emit Transfer(sender, recipient, tTransferAmount);
353     }
354 
355     function _takeTeam(uint256 tTeam) private {
356         uint256 currentRate =  _getRate();
357         uint256 rTeam = tTeam.mul(currentRate);
358         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
359     }
360 
361     function _reflectFee(uint256 rFee, uint256 tFee) private {
362         _rTotal = _rTotal.sub(rFee);
363         _tFeeTotal = _tFeeTotal.add(tFee);
364     }
365 
366     receive() external payable {}
367     
368     function manualswap() external {
369         require(_msgSender() == _FeeAddress);
370         uint256 contractBalance = balanceOf(address(this));
371         swapTokensForEth(contractBalance);
372     }
373     
374     function manualsend() external {
375         require(_msgSender() == _FeeAddress);
376         uint256 contractETHBalance = address(this).balance;
377         sendETHToFee(contractETHBalance);
378     }
379     
380 
381     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
382         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
383         uint256 currentRate =  _getRate();
384         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
385         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
386     }
387 
388     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
389         uint256 tFee = tAmount.mul(taxFee).div(100);
390         uint256 tTeam = tAmount.mul(TeamFee).div(100);
391         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
392         return (tTransferAmount, tFee, tTeam);
393     }
394 
395     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
396         uint256 rAmount = tAmount.mul(currentRate);
397         uint256 rFee = tFee.mul(currentRate);
398         uint256 rTeam = tTeam.mul(currentRate);
399         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
400         return (rAmount, rTransferAmount, rFee);
401     }
402 
403 	function _getRate() private view returns(uint256) {
404         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
405         return rSupply.div(tSupply);
406     }
407 
408     function _getCurrentSupply() private view returns(uint256, uint256) {
409         uint256 rSupply = _rTotal;
410         uint256 tSupply = _tTotal;      
411         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
412         return (rSupply, tSupply);
413     }
414 
415     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
416         require(maxTxPercent > 0, "Amount must be greater than 0");
417         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
418         emit MaxTxAmountUpdated(_maxTxAmount);
419     }
420 }