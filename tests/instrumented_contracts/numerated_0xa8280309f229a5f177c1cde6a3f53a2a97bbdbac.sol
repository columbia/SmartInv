1 // File: contracts/ShibaShabu.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2021-06-05
5 */
6 
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     address private _previousOwner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }  
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 
115 contract SHIBASHABU is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _rOwned;
118     mapping (address => uint256) private _tOwned;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     mapping (address => uint) private cooldown;
123     uint256 private constant MAX = ~uint256(0);
124     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
125     uint256 private _rTotal = (MAX - (MAX % _tTotal));
126     uint256 private _tFeeTotal;
127     string private constant _name = "Shiba Shabu";
128     string private constant _symbol = "SHIBSHABU";
129     uint8 private constant _decimals = 9;
130     uint256 private _taxFee;
131     uint256 private _teamFee;
132     uint256 private _previousTaxFee = _taxFee;
133     uint256 private _previousteamFee = _teamFee;
134     address payable private _FeeAddress;
135     address payable private _marketingWalletAddress;
136     IUniswapV2Router02 private uniswapV2Router;
137     address private uniswapV2Pair;
138     bool private tradingOpen;
139     bool private inSwap = false;
140     bool private swapEnabled = false;
141     bool private cooldownEnabled = false;
142     uint256 private _maxTxAmount = _tTotal;
143     event MaxTxAmountUpdated(uint _maxTxAmount);
144     modifier lockTheSwap {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
150         _FeeAddress = FeeAddress;
151         _marketingWalletAddress = marketingWalletAddress;
152         _rOwned[_msgSender()] = _rTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[FeeAddress] = true;
156         _isExcludedFromFee[marketingWalletAddress] = true;
157         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return tokenFromReflection(_rOwned[account]);
178     }
179 
180     function transfer(address recipient, uint256 amount) public override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address owner, address spender) public view override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function setCooldownEnabled(bool onoff) external onlyOwner() {
201         cooldownEnabled = onoff;
202     }
203 
204     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
205         require(rAmount <= _rTotal, "Amount must be less than total reflections");
206         uint256 currentRate =  _getRate();
207         return rAmount.div(currentRate);
208     }
209 
210     function removeAllFee() private {
211         if(_taxFee == 0 && _teamFee == 0) return;
212         _previousTaxFee = _taxFee;
213         _previousteamFee = _teamFee;
214         _taxFee = 0;
215         _teamFee = 0;
216     }
217     
218     function restoreAllFee() private {
219         _taxFee = _previousTaxFee;
220         _teamFee = _previousteamFee;
221     }
222 
223     function _approve(address owner, address spender, uint256 amount) private {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234         _taxFee = 5;
235         _teamFee = 10;
236         if (from != owner() && to != owner()) {
237             require(!bots[from] && !bots[to]);
238             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
239                 require(amount <= _maxTxAmount);
240                 require(cooldown[to] < block.timestamp);
241                 cooldown[to] = block.timestamp + (30 seconds);
242             }
243             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
244                 _taxFee = 5;
245                 _teamFee = 10;
246             }
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
249                 swapTokensForEth(contractTokenBalance);
250                 uint256 contractETHBalance = address(this).balance;
251                 if(contractETHBalance > 0) {
252                     sendETHToFee(address(this).balance);
253                 }
254             }
255         }
256         bool takeFee = true;
257 
258         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
259             takeFee = false;
260         }
261 		
262         _tokenTransfer(from,to,amount,takeFee);
263     }
264 
265     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
266         address[] memory path = new address[](2);
267         path[0] = address(this);
268         path[1] = uniswapV2Router.WETH();
269         _approve(address(this), address(uniswapV2Router), tokenAmount);
270         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
271             tokenAmount,
272             0,
273             path,
274             address(this),
275             block.timestamp
276         );
277     }
278         
279     function sendETHToFee(uint256 amount) private {
280         _FeeAddress.transfer(amount.div(2));
281         _marketingWalletAddress.transfer(amount.div(2));
282     }
283     
284     function openTrading() external onlyOwner() {
285         require(!tradingOpen,"trading is already open");
286         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
287         uniswapV2Router = _uniswapV2Router;
288         _approve(address(this), address(uniswapV2Router), _tTotal);
289         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
290         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
291         swapEnabled = true;
292         cooldownEnabled = true;
293         _maxTxAmount = 100000000000000000 * 10**9;
294         tradingOpen = true;
295         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
296     }
297     
298     function setBots(address[] memory bots_) public onlyOwner {
299         for (uint i = 0; i < bots_.length; i++) {
300             bots[bots_[i]] = true;
301         }
302     }
303     
304     function delBot(address notbot) public onlyOwner {
305         bots[notbot] = false;
306     }
307         
308     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
309         if(!takeFee)
310             removeAllFee();
311         _transferStandard(sender, recipient, amount);
312         if(!takeFee)
313             restoreAllFee();
314     }
315 
316     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
317         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
318         _rOwned[sender] = _rOwned[sender].sub(rAmount);
319         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
320         _takeTeam(tTeam);
321         _reflectFee(rFee, tFee);
322         emit Transfer(sender, recipient, tTransferAmount);
323     }
324 
325     function _takeTeam(uint256 tTeam) private {
326         uint256 currentRate =  _getRate();
327         uint256 rTeam = tTeam.mul(currentRate);
328         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
329     }
330 
331     function _reflectFee(uint256 rFee, uint256 tFee) private {
332         _rTotal = _rTotal.sub(rFee);
333         _tFeeTotal = _tFeeTotal.add(tFee);
334     }
335 
336     receive() external payable {}
337     
338     function manualswap() external {
339         require(_msgSender() == _FeeAddress);
340         uint256 contractBalance = balanceOf(address(this));
341         swapTokensForEth(contractBalance);
342     }
343     
344     function manualsend() external {
345         require(_msgSender() == _FeeAddress);
346         uint256 contractETHBalance = address(this).balance;
347         sendETHToFee(contractETHBalance);
348     }
349     
350 
351     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
352         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
353         uint256 currentRate =  _getRate();
354         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
355         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
356     }
357 
358     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
359         uint256 tFee = tAmount.mul(taxFee).div(100);
360         uint256 tTeam = tAmount.mul(TeamFee).div(100);
361         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
362         return (tTransferAmount, tFee, tTeam);
363     }
364 
365     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
366         uint256 rAmount = tAmount.mul(currentRate);
367         uint256 rFee = tFee.mul(currentRate);
368         uint256 rTeam = tTeam.mul(currentRate);
369         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
370         return (rAmount, rTransferAmount, rFee);
371     }
372 
373 	function _getRate() private view returns(uint256) {
374         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
375         return rSupply.div(tSupply);
376     }
377 
378     function _getCurrentSupply() private view returns(uint256, uint256) {
379         uint256 rSupply = _rTotal;
380         uint256 tSupply = _tTotal;      
381         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
382         return (rSupply, tSupply);
383     }
384 
385     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
386         require(maxTxPercent > 0, "Amount must be greater than 0");
387         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
388         emit MaxTxAmountUpdated(_maxTxAmount);
389     }
390 }