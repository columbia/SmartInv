1 /*
2 
3 t.me/degeninu
4 
5  ██████████   ██████████   █████████  ██████████ ██████   █████
6 ░░███░░░░███ ░░███░░░░░█  ███░░░░░███░░███░░░░░█░░██████ ░░███ 
7  ░███   ░░███ ░███  █ ░  ███     ░░░  ░███  █ ░  ░███░███ ░███ 
8  ░███    ░███ ░██████   ░███          ░██████    ░███░░███░███ 
9  ░███    ░███ ░███░░█   ░███    █████ ░███░░█    ░███ ░░██████ 
10  ░███    ███  ░███ ░   █░░███  ░░███  ░███ ░   █ ░███  ░░█████ 
11  ██████████   ██████████ ░░█████████  ██████████ █████  ░░█████
12 ░░░░░░░░░░   ░░░░░░░░░░   ░░░░░░░░░  ░░░░░░░░░░ ░░░░░    ░░░░░ 
13                                                                
14  █████ ██████   █████ █████  █████                             
15 ░░███ ░░██████ ░░███ ░░███  ░░███                              
16  ░███  ░███░███ ░███  ░███   ░███                              
17  ░███  ░███░░███░███  ░███   ░███                              
18  ░███  ░███ ░░██████  ░███   ░███                              
19  ░███  ░███  ░░█████  ░███   ░███                              
20  █████ █████  ░░█████ ░░████████                               
21 ░░░░░ ░░░░░    ░░░░░   ░░░░░░░░                                
22 
23 t.me/degeninu
24 
25 
26 SPDX-License-Identifier: Mines™®©
27 */
28 pragma solidity ^0.8.4;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61         return c;
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b > 0, errorMessage);
79         uint256 c = a / b;
80         return c;
81     }
82 
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
87     address private _previousOwner;
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110 }  
111 
112 interface IUniswapV2Factory {
113     function createPair(address tokenA, address tokenB) external returns (address pair);
114 }
115 
116 interface IUniswapV2Router02 {
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
126     function addLiquidityETH(
127         address token,
128         uint amountTokenDesired,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
134 }
135 
136 contract DEGENINU is Context, IERC20, Ownable {
137     using SafeMath for uint256;
138     mapping (address => uint256) private _rOwned;
139     mapping (address => uint256) private _tOwned;
140     mapping (address => mapping (address => uint256)) private _allowances;
141     mapping (address => bool) private _isExcludedFromFee;
142     mapping (address => bool) private bots;
143     mapping (address => uint) private cooldown;
144     uint256 private constant MAX = ~uint256(0);
145     uint256 private constant _tTotal = 1e12 * 10**9;
146     uint256 private _rTotal = (MAX - (MAX % _tTotal));
147     uint256 private _tFeeTotal;
148     string private constant _name = unicode"DEGENINU🍾💸🚬🤪";
149     string private constant _symbol = 'DEGENINU';
150     uint8 private constant _decimals = 9;
151     uint256 private _taxFee;
152     uint256 private _teamFee;
153     uint256 private _previousTaxFee = _taxFee;
154     uint256 private _previousteamFee = _teamFee;
155     address payable private _FeeAddress;
156     address payable private _marketingWalletAddress;
157     IUniswapV2Router02 private uniswapV2Router;
158     address private uniswapV2Pair;
159     bool private tradingOpen;
160     bool private inSwap = false;
161     bool private swapEnabled = false;
162     bool private cooldownEnabled = false;
163     uint256 private _maxTxAmount = _tTotal;
164     event MaxTxAmountUpdated(uint _maxTxAmount);
165     modifier lockTheSwap {
166         inSwap = true;
167         _;
168         inSwap = false;
169     }
170     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
171         _FeeAddress = FeeAddress;
172         _marketingWalletAddress = marketingWalletAddress;
173         _rOwned[_msgSender()] = _rTotal;
174         _isExcludedFromFee[owner()] = true;
175         _isExcludedFromFee[address(this)] = true;
176         _isExcludedFromFee[FeeAddress] = true;
177         _isExcludedFromFee[marketingWalletAddress] = true;
178         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
179     }
180 
181     function name() public pure returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public pure returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public pure returns (uint8) {
190         return _decimals;
191     }
192 
193     function totalSupply() public pure override returns (uint256) {
194         return _tTotal;
195     }
196 
197     function balanceOf(address account) public view override returns (uint256) {
198         return tokenFromReflection(_rOwned[account]);
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function setCooldownEnabled(bool onoff) external onlyOwner() {
222         cooldownEnabled = onoff;
223     }
224 
225     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
226         require(rAmount <= _rTotal, "Amount must be less than total reflections");
227         uint256 currentRate =  _getRate();
228         return rAmount.div(currentRate);
229     }
230 
231     function removeAllFee() private {
232         if(_taxFee == 0 && _teamFee == 0) return;
233         _previousTaxFee = _taxFee;
234         _previousteamFee = _teamFee;
235         _taxFee = 0;
236         _teamFee = 0;
237     }
238     
239     function restoreAllFee() private {
240         _taxFee = _previousTaxFee;
241         _teamFee = _previousteamFee;
242     }
243 
244     function _approve(address owner, address spender, uint256 amount) private {
245         require(owner != address(0), "ERC20: approve from the zero address");
246         require(spender != address(0), "ERC20: approve to the zero address");
247         _allowances[owner][spender] = amount;
248         emit Approval(owner, spender, amount);
249     }
250 
251     function _transfer(address from, address to, uint256 amount) private {
252         require(from != address(0), "ERC20: transfer from the zero address");
253         require(to != address(0), "ERC20: transfer to the zero address");
254         require(amount > 0, "Transfer amount must be greater than zero");
255         _taxFee = 7;
256         _teamFee = 5;
257         if (from != owner() && to != owner()) {
258             require(!bots[from] && !bots[to]);
259             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
260                 require(amount <= _maxTxAmount);
261                 require(cooldown[to] < block.timestamp);
262                 cooldown[to] = block.timestamp + (33 seconds);
263             }
264             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
265                 _taxFee = 7;
266                 _teamFee = 8;
267             }
268             uint256 contractTokenBalance = balanceOf(address(this));
269             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
270                 swapTokensForEth(contractTokenBalance);
271                 uint256 contractETHBalance = address(this).balance;
272                 if(contractETHBalance > 0) {
273                     sendETHToFee(address(this).balance);
274                 }
275             }
276         }
277         bool takeFee = true;
278 
279         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
280             takeFee = false;
281         }
282 		
283         _tokenTransfer(from,to,amount,takeFee);
284     }
285 
286     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
287         address[] memory path = new address[](2);
288         path[0] = address(this);
289         path[1] = uniswapV2Router.WETH();
290         _approve(address(this), address(uniswapV2Router), tokenAmount);
291         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
292             tokenAmount,
293             0,
294             path,
295             address(this),
296             block.timestamp
297         );
298     }
299         
300     function sendETHToFee(uint256 amount) private {
301         payable(0x69696902c8e3950Ca062527c61E23B8Aedb444cB).transfer(amount.div(2));
302         _marketingWalletAddress.transfer(amount.div(2));
303     }
304     
305     function openTrading() external onlyOwner() {
306         require(!tradingOpen,"trading is already open");
307         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
308         uniswapV2Router = _uniswapV2Router;
309         _approve(address(this), address(uniswapV2Router), _tTotal);
310         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
311         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
312         swapEnabled = true;
313         cooldownEnabled = true;
314         _maxTxAmount = 2.125e9 * 10**9;
315         tradingOpen = true;
316         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
317     }
318     
319     function setBots(address[] memory bots_) public onlyOwner {
320         for (uint i = 0; i < bots_.length; i++) {
321             bots[bots_[i]] = true;
322         }
323     }
324     
325     function delBot(address notbot) public onlyOwner {
326         bots[notbot] = false;
327     }
328         
329     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
330         if(!takeFee)
331             removeAllFee();
332         _transferStandard(sender, recipient, amount);
333         if(!takeFee)
334             restoreAllFee();
335     }
336 
337     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
338         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
339         _rOwned[sender] = _rOwned[sender].sub(rAmount);
340         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
341         _takeTeam(tTeam);
342         _reflectFee(rFee, tFee);
343         emit Transfer(sender, recipient, tTransferAmount);
344     }
345 
346     function _takeTeam(uint256 tTeam) private {
347         uint256 currentRate =  _getRate();
348         uint256 rTeam = tTeam.mul(currentRate);
349         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
350     }
351 
352     function _reflectFee(uint256 rFee, uint256 tFee) private {
353         _rTotal = _rTotal.sub(rFee);
354         _tFeeTotal = _tFeeTotal.add(tFee);
355     }
356 
357     receive() external payable {}
358     
359     function manualswap() external {
360         require(_msgSender() == _FeeAddress);
361         uint256 contractBalance = balanceOf(address(this));
362         swapTokensForEth(contractBalance);
363     }
364     
365     function manualsend() external {
366         require(_msgSender() == _FeeAddress);
367         uint256 contractETHBalance = address(this).balance;
368         sendETHToFee(contractETHBalance);
369     }
370     
371 
372     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
373         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
374         uint256 currentRate =  _getRate();
375         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
376         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
377     }
378 
379     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
380         uint256 tFee = tAmount.mul(taxFee).div(100);
381         uint256 tTeam = tAmount.mul(TeamFee).div(100);
382         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
383         return (tTransferAmount, tFee, tTeam);
384     }
385 
386     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
387         uint256 rAmount = tAmount.mul(currentRate);
388         uint256 rFee = tFee.mul(currentRate);
389         uint256 rTeam = tTeam.mul(currentRate);
390         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
391         return (rAmount, rTransferAmount, rFee);
392     }
393 
394 	function _getRate() private view returns(uint256) {
395         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
396         return rSupply.div(tSupply);
397     }
398 
399     function _getCurrentSupply() private view returns(uint256, uint256) {
400         uint256 rSupply = _rTotal;
401         uint256 tSupply = _tTotal;      
402         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
403         return (rSupply, tSupply);
404     }
405 
406     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
407         require(maxTxPercent > 0, "Amount must be greater than 0");
408         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
409         emit MaxTxAmountUpdated(_maxTxAmount);
410     }
411 }