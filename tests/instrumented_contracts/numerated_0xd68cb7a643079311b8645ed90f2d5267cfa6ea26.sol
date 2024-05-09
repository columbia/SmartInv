1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.7;
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
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         emit OwnershipTransferred(_owner, newOwner);
83         _owner = newOwner;
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
117 contract WallStreetInu is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119 
120     mapping (address => uint256) private _rOwned;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private constant MAX = ~uint256(0);
127     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
128     uint256 private _rTotal = (MAX - (MAX % _tTotal));
129     uint256 private _tFeeTotal;
130     uint256 private _feeRewards = 1;
131     uint256 private _feeTeam = 3;
132     uint256 private _feeMarketing = 6;
133     address payable private _feeAddrMarketing;
134     address payable private _feeAddrTeam;
135 
136     string private constant _name = "Wall Street Inu";
137     string private constant _symbol = "WallStreetInu";
138     uint8 private constant _decimals = 9;
139     
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private cooldownEnabled = false;
146     uint256 private _maxTxAmount = _tTotal;
147 
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149 
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _feeAddrMarketing = payable(0xC00db372e4F56017414A9Fa3463D9bb5244D4add);
158         _feeAddrTeam = payable(0xC00db372e4F56017414A9Fa3463D9bb5244D4add);
159         _rOwned[_msgSender()] = _rTotal;
160         _isExcludedFromFee[owner()] = true;
161         _isExcludedFromFee[address(this)] = true;
162         _isExcludedFromFee[_feeAddrMarketing] = true;
163         _isExcludedFromFee[_feeAddrTeam] = true;
164         emit Transfer(address(0), _msgSender(), _tTotal);
165     }
166 
167     function name() public pure returns (string memory) {
168         return _name;
169     }
170 
171     function symbol() public pure returns (string memory) {
172         return _symbol;
173     }
174 
175     function decimals() public pure returns (uint8) {
176         return _decimals;
177     }
178 
179     function totalSupply() public pure override returns (uint256) {
180         return _tTotal;
181     }
182 
183     function balanceOf(address account) public view override returns (uint256) {
184         return tokenFromReflection(_rOwned[account]);
185     }
186 
187     function transfer(address recipient, uint256 amount) public override returns (bool) {
188         _transfer(_msgSender(), recipient, amount);
189         return true;
190     }
191 
192     function allowance(address owner, address spender) public view override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     function approve(address spender, uint256 amount) public override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
202         _transfer(sender, recipient, amount);
203         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
204         return true;
205     }
206 
207     function setCooldownEnabled(bool onoff) external onlyOwner() {
208         cooldownEnabled = onoff;
209     }
210 
211     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
212         require(rAmount <= _rTotal, "Amount must be less than total reflections");
213         uint256 currentRate =  _getRate();
214         return rAmount.div(currentRate);
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228        
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231             
232             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
233                 // Cooldown
234                 require(amount <= _maxTxAmount);
235                 require(cooldown[to] < block.timestamp);
236                 cooldown[to] = block.timestamp + (30 seconds);
237             }
238 
239             uint256 contractTokenBalance = balanceOf(address(this));
240 
241             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
242                 swapTokensForEth(contractTokenBalance);
243 
244                 uint256 contractETHBalance = address(this).balance;
245 
246                 if(contractETHBalance > 0) {
247                     sendETHToFee(address(this).balance);
248                 }
249             }
250         }
251 
252         _tokenTransfer(from, to, amount);
253     }
254 
255     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = uniswapV2Router.WETH();
259         _approve(address(this), address(uniswapV2Router), tokenAmount);
260         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
261             tokenAmount,
262             0,
263             path,
264             address(this),
265             block.timestamp
266         );
267     }
268         
269     function sendETHToFee(uint256 amount) private {
270         uint256 marketingPecentage = _feeMarketing.mul(10000).mul(10**9).div(_feeMarketing.add(_feeTeam));
271         
272         uint256 amountToMarketing = marketingPecentage.mul(amount).div(10000).div(10**9);
273         uint256 amountToTeam = amount.sub(amountToMarketing);
274 
275         _feeAddrMarketing.transfer(amountToMarketing);
276         _feeAddrTeam.transfer(amountToTeam);
277     }
278     
279     function openTrading() external onlyOwner() {
280         require(!tradingOpen,"trading is already open");
281         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
282         uniswapV2Router = _uniswapV2Router;
283         _approve(address(this), address(uniswapV2Router), _tTotal);
284         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
285         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
286         swapEnabled = true;
287         cooldownEnabled = true;
288         _maxTxAmount = 50000000000000000 * 10**9;
289         tradingOpen = true;
290         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
291     }
292     
293     function setBots(address[] memory bots_) public onlyOwner {
294         for (uint i = 0; i < bots_.length; i++) {
295             bots[bots_[i]] = true;
296         }
297     }
298     
299     function delBot(address notbot) public onlyOwner {
300         bots[notbot] = false;
301     }
302         
303     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
304         _transferStandard(sender, recipient, amount);
305     }
306 
307     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
308         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
309         _rOwned[sender] = _rOwned[sender].sub(rAmount);
310         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
311         _takeTeam(tTeam);
312         _reflectFee(rFee, tFee);
313         emit Transfer(sender, recipient, tTransferAmount);
314     }
315 
316     function _takeTeam(uint256 tTeam) private {
317         uint256 currentRate = _getRate();
318         uint256 rTeam = tTeam.mul(currentRate);
319         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
320     }
321 
322     function _reflectFee(uint256 rFee, uint256 tFee) private {
323         _rTotal = _rTotal.sub(rFee);
324         _tFeeTotal = _tFeeTotal.add(tFee);
325     }
326 
327     receive() external payable {}
328     
329     function manualswap() external {
330         require(_msgSender() == _feeAddrTeam);
331         uint256 contractBalance = balanceOf(address(this));
332         swapTokensForEth(contractBalance);
333     }
334     
335     function manualsend() external {
336         require(_msgSender() == _feeAddrTeam);
337         uint256 contractETHBalance = address(this).balance;
338         sendETHToFee(contractETHBalance);
339     }
340 
341     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
342         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeRewards, _feeTeam.add(_feeMarketing));
343         uint256 currentRate =  _getRate();
344         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
345         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
346     }
347 
348     function _getTValues(uint256 tAmount, uint256 feeTax, uint256 feeTeam) private pure returns (uint256, uint256, uint256) {
349         uint256 tFee = tAmount.mul(feeTax).div(100);
350         uint256 tTeam = tAmount.mul(feeTeam).div(100);
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