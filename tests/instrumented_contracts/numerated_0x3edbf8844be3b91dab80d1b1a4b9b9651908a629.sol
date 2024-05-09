1 /*
2               (/;                           o
3              (/;                         o^/|\^o
4             (/;                       o_^|\/^\/|^_o
5      .--..-(/;                       o\^`'.\|/.'`^/o
6      |    (/;                         \\\\\\|//////
7    __|====/=|__                        {><><@><><}              )
8   (____________)   t.me/notoriousinu   `"""""""""`             (
9      __/o \_                             _/ o\__  _ ___________ )
10      \____  \                           /  ____/ [_[___________#
11          /   \                         /   /
12    __   //\   \     Notorious Inu     /   /\\   __
13 __/o \-//--\   \_/                 \_/   /--\\-/ o\__
14 \____  ___  \  |                     |  /  ___  ____/
15      ||   \ |\ |                     | /| /   ||
16     _||   _||_||                     ||_||_   ||_
17        +--^----------,--------,-----,--------^-,
18        | |||||||||   `--------'     |          O
19        `+---------------------------^----------|
20          `\_,---------,---------,--------------'
21            / XXXXXX /'|       /'
22           / XXXXXX /  `\    /'
23          / XXXXXX /`-------'
24         / XXXXXX /
25        / XXXXXX /
26       (________(                
27        `------'
28 
29 SPDX-License-Identifier: Mines™®©
30 */
31 pragma solidity ^0.8.4;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73         return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 
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
139 contract NOTINU is Context, IERC20, Ownable {
140     using SafeMath for uint256;
141     mapping (address => uint256) private _rOwned;
142     mapping (address => uint256) private _tOwned;
143     mapping (address => mapping (address => uint256)) private _allowances;
144     mapping (address => bool) private _isExcludedFromFee;
145     mapping (address => bool) private bots;
146     mapping (address => uint) private cooldown;
147     uint256 private constant MAX = ~uint256(0);
148     uint256 private constant _tTotal = 1e12 * 10**9;
149     uint256 private _rTotal = (MAX - (MAX % _tTotal));
150     uint256 private _tFeeTotal;
151     string private constant _name = unicode"Notorious Inu🎩🕶💪💵🚬🖕";
152     string private constant _symbol = 'NOTINU';
153     uint8 private constant _decimals = 9;
154     uint256 private _taxFee;
155     uint256 private _teamFee;
156     uint256 private _previousTaxFee = _taxFee;
157     uint256 private _previousteamFee = _teamFee;
158     address payable private _FeeAddress;
159     address payable private _marketingWalletAddress;
160     IUniswapV2Router02 private uniswapV2Router;
161     address private uniswapV2Pair;
162     bool private tradingOpen;
163     bool private inSwap = false;
164     bool private swapEnabled = false;
165     bool private cooldownEnabled = false;
166     uint256 private _maxTxAmount = _tTotal;
167     event MaxTxAmountUpdated(uint _maxTxAmount);
168     modifier lockTheSwap {
169         inSwap = true;
170         _;
171         inSwap = false;
172     }
173     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
174         _FeeAddress = FeeAddress;
175         _marketingWalletAddress = marketingWalletAddress;
176         _rOwned[_msgSender()] = _rTotal;
177         _isExcludedFromFee[owner()] = true;
178         _isExcludedFromFee[address(this)] = true;
179         _isExcludedFromFee[FeeAddress] = true;
180         _isExcludedFromFee[marketingWalletAddress] = true;
181         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
182     }
183 
184     function name() public pure returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public pure returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public pure returns (uint8) {
193         return _decimals;
194     }
195 
196     function totalSupply() public pure override returns (uint256) {
197         return _tTotal;
198     }
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return tokenFromReflection(_rOwned[account]);
202     }
203 
204     function transfer(address recipient, uint256 amount) public override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender) public view override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217 
218     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
221         return true;
222     }
223 
224     function setCooldownEnabled(bool onoff) external onlyOwner() {
225         cooldownEnabled = onoff;
226     }
227 
228     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
229         require(rAmount <= _rTotal, "Amount must be less than total reflections");
230         uint256 currentRate =  _getRate();
231         return rAmount.div(currentRate);
232     }
233 
234     function removeAllFee() private {
235         if(_taxFee == 0 && _teamFee == 0) return;
236         _previousTaxFee = _taxFee;
237         _previousteamFee = _teamFee;
238         _taxFee = 0;
239         _teamFee = 0;
240     }
241     
242     function restoreAllFee() private {
243         _taxFee = _previousTaxFee;
244         _teamFee = _previousteamFee;
245     }
246 
247     function _approve(address owner, address spender, uint256 amount) private {
248         require(owner != address(0), "ERC20: approve from the zero address");
249         require(spender != address(0), "ERC20: approve to the zero address");
250         _allowances[owner][spender] = amount;
251         emit Approval(owner, spender, amount);
252     }
253 
254     function _transfer(address from, address to, uint256 amount) private {
255         require(from != address(0), "ERC20: transfer from the zero address");
256         require(to != address(0), "ERC20: transfer to the zero address");
257         require(amount > 0, "Transfer amount must be greater than zero");
258         _taxFee = 7;
259         _teamFee = 3;
260         if (from != owner() && to != owner()) {
261             require(!bots[from] && !bots[to]);
262             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
263                 require(amount <= _maxTxAmount);
264                 require(cooldown[to] < block.timestamp);
265                 cooldown[to] = block.timestamp + (30 seconds);
266             }
267             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
268                 _taxFee = 7;
269                 _teamFee = 7;
270             }
271             uint256 contractTokenBalance = balanceOf(address(this));
272             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
273                 swapTokensForEth(contractTokenBalance);
274                 uint256 contractETHBalance = address(this).balance;
275                 if(contractETHBalance > 0) {
276                     sendETHToFee(address(this).balance);
277                 }
278             }
279         }
280         bool takeFee = true;
281 
282         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
283             takeFee = false;
284         }
285 		
286         _tokenTransfer(from,to,amount,takeFee);
287     }
288 
289     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp
300         );
301     }
302         
303     function sendETHToFee(uint256 amount) private {
304         _FeeAddress.transfer(amount.div(2));
305         _marketingWalletAddress.transfer(amount.div(2));
306     }
307     
308     function openTrading() external onlyOwner() {
309         require(!tradingOpen,"trading is already open");
310         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
311         uniswapV2Router = _uniswapV2Router;
312         _approve(address(this), address(uniswapV2Router), _tTotal);
313         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
314         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
315         swapEnabled = true;
316         cooldownEnabled = true;
317         _maxTxAmount = 4.25e9 * 10**9;
318         tradingOpen = true;
319         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
320     }
321     
322     function setBots(address[] memory bots_) public onlyOwner {
323         for (uint i = 0; i < bots_.length; i++) {
324             bots[bots_[i]] = true;
325         }
326     }
327     
328     function delBot(address notbot) public onlyOwner {
329         bots[notbot] = false;
330     }
331         
332     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
333         if(!takeFee)
334             removeAllFee();
335         _transferStandard(sender, recipient, amount);
336         if(!takeFee)
337             restoreAllFee();
338     }
339 
340     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
341         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
342         _rOwned[sender] = _rOwned[sender].sub(rAmount);
343         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
344         _takeTeam(tTeam);
345         _reflectFee(rFee, tFee);
346         emit Transfer(sender, recipient, tTransferAmount);
347     }
348 
349     function _takeTeam(uint256 tTeam) private {
350         uint256 currentRate =  _getRate();
351         uint256 rTeam = tTeam.mul(currentRate);
352         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
353     }
354 
355     function _reflectFee(uint256 rFee, uint256 tFee) private {
356         _rTotal = _rTotal.sub(rFee);
357         _tFeeTotal = _tFeeTotal.add(tFee);
358     }
359 
360     receive() external payable {}
361     
362     function manualswap() external {
363         require(_msgSender() == _FeeAddress);
364         uint256 contractBalance = balanceOf(address(this));
365         swapTokensForEth(contractBalance);
366     }
367     
368     function manualsend() external {
369         require(_msgSender() == _FeeAddress);
370         uint256 contractETHBalance = address(this).balance;
371         sendETHToFee(contractETHBalance);
372     }
373     
374 
375     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
376         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
377         uint256 currentRate =  _getRate();
378         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
379         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
380     }
381 
382     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
383         uint256 tFee = tAmount.mul(taxFee).div(100);
384         uint256 tTeam = tAmount.mul(TeamFee).div(100);
385         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
386         return (tTransferAmount, tFee, tTeam);
387     }
388 
389     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
390         uint256 rAmount = tAmount.mul(currentRate);
391         uint256 rFee = tFee.mul(currentRate);
392         uint256 rTeam = tTeam.mul(currentRate);
393         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
394         return (rAmount, rTransferAmount, rFee);
395     }
396 
397 	function _getRate() private view returns(uint256) {
398         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
399         return rSupply.div(tSupply);
400     }
401 
402     function _getCurrentSupply() private view returns(uint256, uint256) {
403         uint256 rSupply = _rTotal;
404         uint256 tSupply = _tTotal;      
405         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
406         return (rSupply, tSupply);
407     }
408 
409     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
410         require(maxTxPercent > 0, "Amount must be greater than 0");
411         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
412         emit MaxTxAmountUpdated(_maxTxAmount);
413     }
414 }