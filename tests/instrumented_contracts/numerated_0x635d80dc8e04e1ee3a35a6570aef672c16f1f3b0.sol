1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-13
7 */
8 
9 /**
10  
11  Baby Ryukyu Inu $BRKI
12  Join Our Telegram: https://t.me/BabyRyukyu
13    
14 */
15 
16 pragma solidity ^0.8.4;
17 // SPDX-License-Identifier: UNLICENSED
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 
71 }
72 
73 contract Ownable is Context {
74     address private _owner;
75     address private _previousOwner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }  
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract BabyRyukyuInu is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _rOwned;
127     mapping (address => uint256) private _tOwned;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping (address => uint) private cooldown;
132     uint256 private constant MAX = ~uint256(0);
133     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
134     uint256 private _rTotal = (MAX - (MAX % _tTotal));
135     uint256 private _tFeeTotal;
136     
137     uint256 private _feeAddr1;
138     uint256 private _feeAddr2;
139     address payable private _feeAddrWallet1;
140     address payable private _feeAddrWallet2;
141     
142     string private constant _name = "Baby Ryukyu Inu";
143     string private constant _symbol = "BRKI";
144     uint8 private constant _decimals = 9;
145     
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private inSwap = false;
150     bool private swapEnabled = false;
151     bool private cooldownEnabled = false;
152     uint256 private _maxTxAmount = _tTotal;
153     event MaxTxAmountUpdated(uint _maxTxAmount);
154     modifier lockTheSwap {
155         inSwap = true;
156         _;
157         inSwap = false;
158     }
159     constructor () {
160         _feeAddrWallet1 = payable(0x2319DcFfbbB57e228122B0f61a2dc0d92842F2D1);
161         _feeAddrWallet2 = payable(0x695D2c19Fbcd810baE5350E88669f40aCE1aBd32);
162         _rOwned[_msgSender()] = _rTotal;
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[_feeAddrWallet1] = true;
166         _isExcludedFromFee[_feeAddrWallet2] = true;
167         emit Transfer(address(0xf135A2A10597cb7f6E3C99D70BbE4f5473a3c5C5), _msgSender(), _tTotal);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return tokenFromReflection(_rOwned[account]);
188     }
189 
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender) public view override returns (uint256) {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     function setCooldownEnabled(bool onoff) external onlyOwner() {
211         cooldownEnabled = onoff;
212     }
213 
214     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
215         require(rAmount <= _rTotal, "Amount must be less than total reflections");
216         uint256 currentRate =  _getRate();
217         return rAmount.div(currentRate);
218     }
219 
220     function _approve(address owner, address spender, uint256 amount) private {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227     function _transfer(address from, address to, uint256 amount) private {
228         require(from != address(0), "ERC20: transfer from the zero address");
229         require(to != address(0), "ERC20: transfer to the zero address");
230         require(amount > 0, "Transfer amount must be greater than zero");
231         _feeAddr1 = 2;
232         _feeAddr2 = 8;
233         if (from != owner() && to != owner()) {
234             require(!bots[from] && !bots[to]);
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
236                 // Cooldown
237                 require(amount <= _maxTxAmount);
238                 require(cooldown[to] < block.timestamp);
239                 cooldown[to] = block.timestamp + (30 seconds);
240             }
241             
242             
243             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
244                 _feeAddr1 = 2;
245                 _feeAddr2 = 10;
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
256 		
257         _tokenTransfer(from,to,amount);
258     }
259 
260     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = uniswapV2Router.WETH();
264         _approve(address(this), address(uniswapV2Router), tokenAmount);
265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             tokenAmount,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272     }
273         
274     function sendETHToFee(uint256 amount) private {
275         _feeAddrWallet1.transfer(amount.div(2));
276         _feeAddrWallet2.transfer(amount.div(2));
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
317         uint256 currentRate =  _getRate();
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
330         require(_msgSender() == _feeAddrWallet1);
331         uint256 contractBalance = balanceOf(address(this));
332         swapTokensForEth(contractBalance);
333     }
334     
335     function manualsend() external {
336         require(_msgSender() == _feeAddrWallet1);
337         uint256 contractETHBalance = address(this).balance;
338         sendETHToFee(contractETHBalance);
339     }
340     
341 
342     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
343         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
344         uint256 currentRate =  _getRate();
345         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
346         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
347     }
348 
349     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
350         uint256 tFee = tAmount.mul(taxFee).div(100);
351         uint256 tTeam = tAmount.mul(TeamFee).div(100);
352         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
353         return (tTransferAmount, tFee, tTeam);
354     }
355 
356     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
357         uint256 rAmount = tAmount.mul(currentRate);
358         uint256 rFee = tFee.mul(currentRate);
359         uint256 rTeam = tTeam.mul(currentRate);
360         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
361         return (rAmount, rTransferAmount, rFee);
362     }
363 
364 	function _getRate() private view returns(uint256) {
365         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
366         return rSupply.div(tSupply);
367     }
368 
369     function _getCurrentSupply() private view returns(uint256, uint256) {
370         uint256 rSupply = _rTotal;
371         uint256 tSupply = _tTotal;      
372         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
373         return (rSupply, tSupply);
374     }
375 }