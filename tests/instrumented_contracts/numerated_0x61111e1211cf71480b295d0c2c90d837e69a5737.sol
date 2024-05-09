1 /**
2 btfd.quest
3 https://t.me/BTFDeth
4 */
5 
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.8.4;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     address private _previousOwner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91 }  
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract BTFD is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _rOwned;
120     mapping (address => uint256) private _tOwned;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping (address => uint) private cooldown;
125     uint256 private constant MAX = ~uint256(0);
126     uint256 private constant _tTotal = 1e12 * 10**9;
127     uint256 private _rTotal = (MAX - (MAX % _tTotal));
128     uint256 private _tFeeTotal;
129     
130     uint256 private _feeAddr1;
131     uint256 private _feeAddr2;
132     address payable private _feeAddrWallet1;
133     address payable private _feeAddrWallet2;
134     
135     string private constant _name = "BTFD";
136     string private constant _symbol = "BTFD";
137     uint8 private constant _decimals = 9;
138     
139     IUniswapV2Router02 private uniswapV2Router;
140     address private uniswapV2Pair;
141     bool private tradingOpen;
142     bool private inSwap = false;
143     bool private swapEnabled = false;
144     bool private cooldownEnabled = false;
145     uint256 private _maxTxAmount = _tTotal;
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152     constructor () {
153         _feeAddrWallet1 = payable(0xcc3DCdC97276a743157bb1f49B32C5203140c489);
154         _feeAddrWallet2 = payable(0xcc3DCdC97276a743157bb1f49B32C5203140c489);
155         _rOwned[_msgSender()] = _rTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_feeAddrWallet1] = true;
159         _isExcludedFromFee[_feeAddrWallet2] = true;
160         emit Transfer(address(0xA221af4a429b734Abb1CC53Fbd0c1D0Fa47e1494), _msgSender(), _tTotal);
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
224         _feeAddr1 = 1;
225         _feeAddr2 = 9;
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
237                 _feeAddr1 = 1;
238                 _feeAddr2 = 9;
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
281         _maxTxAmount = 1e12 * 10**9;
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