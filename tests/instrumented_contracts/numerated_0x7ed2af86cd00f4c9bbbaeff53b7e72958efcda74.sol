1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     address private _previousOwner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract TSUKADOM is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _rOwned;
114     mapping (address => uint256) private _tOwned;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant MAX = ~uint256(0);
120     uint256 private constant _tTotal = 100000000 * 10**8;
121     uint256 private _rTotal = (MAX - (MAX % _tTotal));
122     uint256 private _tFeeTotal;
123 
124     uint256 private _feeAddr1;
125     uint256 private _feeAddr2;
126     uint256 private _initialTax;
127     uint256 private _finalTax;
128     uint256 private _reduceTaxCountdown;
129     address payable private _feeAddrWallet;
130 
131     string private constant _name = "The Tsuka Kingdom";
132     string private constant _symbol = "TSUKADOM";
133     uint8 private constant _decimals = 8;
134 
135     IUniswapV2Router02 private uniswapV2Router;
136     address private uniswapV2Pair;
137     bool private tradingOpen;
138     bool private inSwap = false;
139     bool private swapEnabled = false;
140     bool private cooldownEnabled = false;
141     uint256 public _maxTxAmount = 2000000 * 10**8;
142     uint256 public _maxWalletSize = 2000000 * 10**8;
143     event MaxTxAmountUpdated(uint _maxTxAmount);
144     modifier lockTheSwap {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149 
150     constructor () {
151         _feeAddrWallet = payable(_msgSender());
152         _rOwned[_msgSender()] = _rTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_feeAddrWallet] = true;
156         _initialTax=5;
157         _finalTax=0;
158         _reduceTaxCountdown=45;
159 
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return tokenFromReflection(_rOwned[account]);
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function setCooldownEnabled(bool onoff) external onlyOwner() {
204         cooldownEnabled = onoff;
205     }
206 
207     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
208         require(rAmount <= _rTotal, "Amount must be less than total reflections");
209         uint256 currentRate =  _getRate();
210         return rAmount.div(currentRate);
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224         if (from != owner() && to != owner()) {
225             require(!bots[from] && !bots[to]);
226             _feeAddr1 = 0;
227             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
229 
230                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
231                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
232                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
233             }
234 
235 
236             uint256 contractTokenBalance = balanceOf(address(this));
237             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0 && _reduceTaxCountdown<20) {
238                 swapTokensForEth(contractTokenBalance);
239                 uint256 contractETHBalance = address(this).balance;
240                 if(contractETHBalance > 0) {
241                     sendETHToFee(address(this).balance);
242                 }
243             }
244         }else{
245           _feeAddr1 = 0;
246           _feeAddr2 = 0;
247         }
248         _tokenTransfer(from,to,amount);
249     }
250 
251     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
252         address[] memory path = new address[](2);
253         path[0] = address(this);
254         path[1] = uniswapV2Router.WETH();
255         _approve(address(this), address(uniswapV2Router), tokenAmount);
256         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
257             tokenAmount,
258             0,
259             path,
260             address(this),
261             block.timestamp
262         );
263     }
264 
265 
266     function removeLimits() external onlyOwner{
267         _maxTxAmount = _tTotal;
268         _maxWalletSize = _tTotal;
269     }
270 
271     function sendETHToFee(uint256 amount) private {
272         _feeAddrWallet.transfer(amount);
273     }
274 
275     function addBots(address[] memory bots_) public onlyOwner {
276         for (uint i = 0; i < bots_.length; i++) {
277             bots[bots_[i]] = true;
278         }
279     }
280 
281     function delBots(address[] memory notbot) public onlyOwner {
282       for (uint i = 0; i < notbot.length; i++) {
283           bots[notbot[i]] = false;
284       }
285 
286     }
287 
288     function openTrading() external onlyOwner() {
289         require(!tradingOpen,"trading is already open");
290         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
291         uniswapV2Router = _uniswapV2Router;
292         _approve(address(this), address(uniswapV2Router), _tTotal);
293         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
294         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
295         swapEnabled = true;
296         cooldownEnabled = true;
297 
298         tradingOpen = true;
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300     }
301 
302     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
303         _transferStandard(sender, recipient, amount);
304     }
305 
306     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
307         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
308         _rOwned[sender] = _rOwned[sender].sub(rAmount);
309         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
310         _takeTeam(tTeam);
311         _reflectFee(rFee, tFee);
312         emit Transfer(sender, recipient, tTransferAmount);
313     }
314 
315     function _takeTeam(uint256 tTeam) private {
316         uint256 currentRate =  _getRate();
317         uint256 rTeam = tTeam.mul(currentRate);
318         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
319     }
320 
321     function _reflectFee(uint256 rFee, uint256 tFee) private {
322         _rTotal = _rTotal.sub(rFee);
323         _tFeeTotal = _tFeeTotal.add(tFee);
324     }
325 
326     receive() external payable {}
327 
328     function manualswap() external {
329         require(_msgSender() == _feeAddrWallet);
330         uint256 contractBalance = balanceOf(address(this));
331         swapTokensForEth(contractBalance);
332     }
333 
334     function manualsend() external {
335         require(_msgSender() == _feeAddrWallet);
336         uint256 contractETHBalance = address(this).balance;
337         sendETHToFee(contractETHBalance);
338     }
339 
340 
341     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
342         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
343         uint256 currentRate =  _getRate();
344         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
345         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
346     }
347 
348     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
349         uint256 tFee = tAmount.mul(taxFee).div(100);
350         uint256 tTeam = tAmount.mul(TeamFee).div(100);
351         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
352         return (tTransferAmount, tFee, tTeam);
353     }
354 
355     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
356         uint256 rAmount = tAmount.mul(currentRate);
357         uint256 rFee = tFee.mul(currentRate);
358         uint256 rTeam = tTeam.mul(currentRate);
359         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
360         return (rAmount, rTransferAmount, rFee);
361     }
362 
363 	function _getRate() private view returns(uint256) {
364         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
365         return rSupply.div(tSupply);
366     }
367 
368     function _getCurrentSupply() private view returns(uint256, uint256) {
369         uint256 rSupply = _rTotal;
370         uint256 tSupply = _tTotal;
371         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
372         return (rSupply, tSupply);
373     }
374 }