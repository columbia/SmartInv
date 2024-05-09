1 // https://babyalucard.com
2 // https://t.me/babyalucard
3 // SPDX-License-Identifier: Unlicensed
4 
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
42         if (a == 0) {
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
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     address private _previousOwner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }  
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 
113 contract BabyAlucard is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _rOwned;
116     mapping (address => uint256) private _tOwned;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping (address => uint) private cooldown;
121     uint256 private constant MAX = ~uint256(0);
122     uint256 private constant _tTotal = 1e12 * 10**9;
123     uint256 private _rTotal = (MAX - (MAX % _tTotal));
124     uint256 private _tFeeTotal;
125     
126     uint256 private _feeAddr1;
127     uint256 private _feeAddr2;
128     address payable private _feeAddrWallet1;
129     address payable private _feeAddrWallet2;
130     
131     string private constant _name = "Baby Alucard";
132     string private constant _symbol = "ALUCARD";
133     uint8 private constant _decimals = 9;   
134     
135     IUniswapV2Router02 private uniswapV2Router;
136     address private uniswapV2Pair;
137     bool private tradingOpen;
138     bool private inSwap = false;
139     bool private swapEnabled = false;
140     bool private cooldownEnabled = false;
141     uint256 private _maxTxAmount = _tTotal;
142     event MaxTxAmountUpdated(uint _maxTxAmount);
143     modifier lockTheSwap {
144         inSwap = true;
145         _;
146         inSwap = false;
147     }
148     constructor () {
149         _feeAddrWallet1 = payable(0x52Ec180Db5DaF4A6F66876Cb3D5dE841f5b36EF0);
150         _feeAddrWallet2 = payable(0xEe06ABB7ac88A47242909B1F2034E14F4b67ccC0);
151         _rOwned[_msgSender()] = _rTotal;
152         _isExcludedFromFee[owner()] = true;
153         _isExcludedFromFee[address(this)] = true;
154         _isExcludedFromFee[_feeAddrWallet1] = true;
155         _isExcludedFromFee[_feeAddrWallet2] = true;
156         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
157     }
158 
159     function name() public pure returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public pure returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public pure returns (uint8) {
168         return _decimals;
169     }
170 
171     function totalSupply() public pure override returns (uint256) {
172         return _tTotal;
173     }
174 
175     function balanceOf(address account) public view override returns (uint256) {
176         return tokenFromReflection(_rOwned[account]);
177     }
178 
179     function transfer(address recipient, uint256 amount) public override returns (bool) {
180         _transfer(_msgSender(), recipient, amount);
181         return true;
182     }
183 
184     function allowance(address owner, address spender) public view override returns (uint256) {
185         return _allowances[owner][spender];
186     }
187 
188     function approve(address spender, uint256 amount) public override returns (bool) {
189         _approve(_msgSender(), spender, amount);
190         return true;
191     }
192 
193     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
194         _transfer(sender, recipient, amount);
195         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
196         return true;
197     }
198 
199     function setCooldownEnabled(bool onoff) external onlyOwner() {
200         cooldownEnabled = onoff;
201     }
202 
203     function setMaxTxAmount (uint256 amt) external onlyOwner() {
204         _maxTxAmount = amt;
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
224         _feeAddr1 = 2;
225         _feeAddr2 = 8;
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
229                 // Cooldown
230                 require(amount <= _maxTxAmount);
231                 require(cooldown[to] < block.timestamp);
232                 cooldown[to] = block.timestamp + (30 seconds);
233             }
234             
235             
236             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
237                 _feeAddr1 = 2;
238                 _feeAddr2 = 10;
239             }
240             uint256 contractTokenBalance = balanceOf(address(this));
241             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
242                 swapTokensForEth(contractTokenBalance);
243                 uint256 contractETHBalance = address(this).balance;
244                 if(contractETHBalance > 0) {
245                     sendETHToFee(address(this).balance);
246                 }
247             }
248         }
249 		
250         _tokenTransfer(from,to,amount);
251     }
252 
253     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
254         address[] memory path = new address[](2);
255         path[0] = address(this);
256         path[1] = uniswapV2Router.WETH();
257         _approve(address(this), address(uniswapV2Router), tokenAmount);
258         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
259             tokenAmount,
260             0,
261             path,
262             address(this),
263             block.timestamp
264         );
265     }
266         
267     function sendETHToFee(uint256 amount) private {
268         _feeAddrWallet1.transfer(amount.div(2));
269         _feeAddrWallet2.transfer(amount.div(2));
270     }
271     
272     function openTrading() external onlyOwner() {
273         require(!tradingOpen,"trading is already open");
274         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
275         uniswapV2Router = _uniswapV2Router;
276         _approve(address(this), address(uniswapV2Router), _tTotal);
277         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
278         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
279         swapEnabled = true;
280         cooldownEnabled = true;
281         _maxTxAmount = 200000000;
282         tradingOpen = true;
283         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
284     }
285     
286     function setBots(address[] memory bots_) public onlyOwner {
287         for (uint i = 0; i < bots_.length; i++) {
288             bots[bots_[i]] = true;
289         }
290     }
291     
292     function removeStrictTxLimit() public onlyOwner {
293         _maxTxAmount = 1e12 * 10**9;
294     }
295     
296     function delBot(address notbot) public onlyOwner {
297         bots[notbot] = false;
298     }
299         
300     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
301         _transferStandard(sender, recipient, amount);
302     }
303 
304     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
305         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
306         _rOwned[sender] = _rOwned[sender].sub(rAmount);
307         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
308         _takeTeam(tTeam);
309         _reflectFee(rFee, tFee);
310         emit Transfer(sender, recipient, tTransferAmount);
311     }
312 
313     function _takeTeam(uint256 tTeam) private {
314         uint256 currentRate =  _getRate();
315         uint256 rTeam = tTeam.mul(currentRate);
316         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
317     }
318 
319     function _reflectFee(uint256 rFee, uint256 tFee) private {
320         _rTotal = _rTotal.sub(rFee);
321         _tFeeTotal = _tFeeTotal.add(tFee);
322     }
323 
324     receive() external payable {}
325     
326     function manualswap() external {
327         require(_msgSender() == _feeAddrWallet1);
328         uint256 contractBalance = balanceOf(address(this));
329         swapTokensForEth(contractBalance);
330     }
331     
332     function manualsend() external {
333         require(_msgSender() == _feeAddrWallet1);
334         uint256 contractETHBalance = address(this).balance;
335         sendETHToFee(contractETHBalance);
336     }
337     
338 
339     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
340         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
341         uint256 currentRate =  _getRate();
342         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
343         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
344     }
345 
346     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
347         uint256 tFee = tAmount.mul(taxFee).div(100);
348         uint256 tTeam = tAmount.mul(TeamFee).div(100);
349         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
350         return (tTransferAmount, tFee, tTeam);
351     }
352 
353     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
354         uint256 rAmount = tAmount.mul(currentRate);
355         uint256 rFee = tFee.mul(currentRate);
356         uint256 rTeam = tTeam.mul(currentRate);
357         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
358         return (rAmount, rTransferAmount, rFee);
359     }
360 
361 	function _getRate() private view returns(uint256) {
362         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
363         return rSupply.div(tSupply);
364     }
365 
366     function _getCurrentSupply() private view returns(uint256, uint256) {
367         uint256 rSupply = _rTotal;
368         uint256 tSupply = _tTotal;      
369         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
370         return (rSupply, tSupply);
371     }
372 }