1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
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
111 contract LooksRare is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _rOwned;
114     mapping (address => uint256) private _tOwned;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant MAX = ~uint256(0);
120     uint256 private constant _tTotal = 100000000000000000000;
121     uint256 private _rTotal = (MAX - (MAX % _tTotal));
122     uint256 private _tFeeTotal;
123     
124     uint256 private _feeAddr1;
125     uint256 private _feeAddr2;
126     address payable private _feeAddrWallet1;
127     address payable private _feeAddrWallet2;
128     
129     string private constant _name = "Looks Rare";
130     string private constant _symbol = "LR";
131     uint8 private constant _decimals = 9;
132     
133     IUniswapV2Router02 private uniswapV2Router;
134     address private uniswapV2Pair;
135     bool private tradingOpen;
136     bool private inSwap = false;
137     bool private swapEnabled = false;
138     bool private cooldownEnabled = false;
139     uint256 public _maxTxAmount = _tTotal;
140     event MaxTxAmountUpdated(uint _maxTxAmount);
141     modifier lockTheSwap {
142         inSwap = true;
143         _;
144         inSwap = false;
145     }
146     constructor () {
147         _feeAddrWallet1 = payable(0x3d6d80733EF0f2e0D53D1290C37d6EeF37c7bCBA);
148         _feeAddrWallet2 = payable(0x3d6d80733EF0f2e0D53D1290C37d6EeF37c7bCBA);
149         _rOwned[_msgSender()] = _rTotal;
150         _isExcludedFromFee[owner()] = true;
151         _isExcludedFromFee[address(this)] = true;
152         _isExcludedFromFee[_feeAddrWallet1] = true;
153         _isExcludedFromFee[_feeAddrWallet2] = true;
154         emit Transfer(address(0x16805bF903E5f413C55B97d3d7e386C48eFD5DFa), _msgSender(), _tTotal);
155     }
156 
157     function name() public pure returns (string memory) {
158         return _name;
159     }
160 
161     function symbol() public pure returns (string memory) {
162         return _symbol;
163     }
164 
165     function decimals() public pure returns (uint8) {
166         return _decimals;
167     }
168 
169     function totalSupply() public pure override returns (uint256) {
170         return _tTotal;
171     }
172 
173     function balanceOf(address account) public view override returns (uint256) {
174         return tokenFromReflection(_rOwned[account]);
175     }
176 
177     function transfer(address recipient, uint256 amount) public override returns (bool) {
178         _transfer(_msgSender(), recipient, amount);
179         return true;
180     }
181 
182     function allowance(address owner, address spender) public view override returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     function approve(address spender, uint256 amount) public override returns (bool) {
187         _approve(_msgSender(), spender, amount);
188         return true;
189     }
190 
191     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
192         _transfer(sender, recipient, amount);
193         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
194         return true;
195     }
196 
197     function setCooldownEnabled(bool onoff) external onlyOwner() {
198         cooldownEnabled = onoff;
199     }
200 
201     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
202         require(rAmount <= _rTotal, "Amount must be less than total reflections");
203         uint256 currentRate =  _getRate();
204         return rAmount.div(currentRate);
205     }
206 
207     function _approve(address owner, address spender, uint256 amount) private {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 
214     function _transfer(address from, address to, uint256 amount) private {
215         require(from != address(0), "ERC20: transfer from the zero address");
216         require(to != address(0), "ERC20: transfer to the zero address");
217         require(amount > 0, "Transfer amount must be greater than zero");
218         _feeAddr1 = 3;
219         _feeAddr2 = 10;
220         if (from != owner() && to != owner()) {
221             require(!bots[from] && !bots[to]);
222             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
223                 // Cooldown
224                 require(amount <= _maxTxAmount);
225                 require(cooldown[to] < block.timestamp);
226                 cooldown[to] = block.timestamp + (15 seconds);
227             }
228             
229             
230             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
231                 _feeAddr1 = 3;
232                 _feeAddr2 = 10;
233             }
234             uint256 contractTokenBalance = balanceOf(address(this));
235             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
236                 swapTokensForEth(contractTokenBalance);
237                 uint256 contractETHBalance = address(this).balance;
238                 if(contractETHBalance > 0) {
239                     sendETHToFee(address(this).balance);
240                 }
241             }
242         }
243 		
244         _tokenTransfer(from,to,amount);
245     }
246 
247     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
248         address[] memory path = new address[](2);
249         path[0] = address(this);
250         path[1] = uniswapV2Router.WETH();
251         _approve(address(this), address(uniswapV2Router), tokenAmount);
252         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
253             tokenAmount,
254             0,
255             path,
256             address(this),
257             block.timestamp
258         );
259     }
260         
261     function sendETHToFee(uint256 amount) private {
262         _feeAddrWallet1.transfer(amount.div(2));
263         _feeAddrWallet2.transfer(amount.div(2));
264     }
265     
266     function openTrading() external onlyOwner() {
267         require(!tradingOpen,"trading is already open");
268         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
269         uniswapV2Router = _uniswapV2Router;
270         _approve(address(this), address(uniswapV2Router), _tTotal);
271         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
272         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
273         swapEnabled = true;
274         cooldownEnabled = true;
275         _maxTxAmount = 500000000000000000; //0.5% of Total Supply 
276         tradingOpen = true;
277         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
278     }
279     
280     function setBots(address[] memory bots_) public onlyOwner {
281         for (uint i = 0; i < bots_.length; i++) {
282             bots[bots_[i]] = true;
283         }
284     }
285     
286     function setMaxTXAmount(uint256 maxTxAmount) public onlyOwner {
287         _maxTxAmount = maxTxAmount;
288     }
289     
290     function delBot(address notbot) public onlyOwner {
291         bots[notbot] = false;
292     }
293         
294     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
295         _transferStandard(sender, recipient, amount);
296     }
297 
298     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
299         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
300         _rOwned[sender] = _rOwned[sender].sub(rAmount);
301         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
302         _takeTeam(tTeam);
303         _reflectFee(rFee, tFee);
304         emit Transfer(sender, recipient, tTransferAmount);
305     }
306 
307     function _takeTeam(uint256 tTeam) private {
308         uint256 currentRate =  _getRate();
309         uint256 rTeam = tTeam.mul(currentRate);
310         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
311     }
312 
313     function _reflectFee(uint256 rFee, uint256 tFee) private {
314         _rTotal = _rTotal.sub(rFee);
315         _tFeeTotal = _tFeeTotal.add(tFee);
316     }
317 
318     receive() external payable {}
319     
320     function manualswap() external {
321         require(_msgSender() == _feeAddrWallet1);
322         uint256 contractBalance = balanceOf(address(this));
323         swapTokensForEth(contractBalance);
324     }
325     
326     function manualsend() external {
327         require(_msgSender() == _feeAddrWallet1);
328         uint256 contractETHBalance = address(this).balance;
329         sendETHToFee(contractETHBalance);
330     }
331     
332 
333     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
334         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
335         uint256 currentRate =  _getRate();
336         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
337         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
338     }
339 
340     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
341         uint256 tFee = tAmount.mul(taxFee).div(100);
342         uint256 tTeam = tAmount.mul(TeamFee).div(100);
343         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
344         return (tTransferAmount, tFee, tTeam);
345     }
346 
347     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
348         uint256 rAmount = tAmount.mul(currentRate);
349         uint256 rFee = tFee.mul(currentRate);
350         uint256 rTeam = tTeam.mul(currentRate);
351         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
352         return (rAmount, rTransferAmount, rFee);
353     }
354 
355 	function _getRate() private view returns(uint256) {
356         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
357         return rSupply.div(tSupply);
358     }
359 
360     function _getCurrentSupply() private view returns(uint256, uint256) {
361         uint256 rSupply = _rTotal;
362         uint256 tSupply = _tTotal;      
363         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
364         return (rSupply, tSupply);
365     }
366 }