1 //SPDX-License-Identifier: UNLICENSED
2  
3 // .____                .___        __      __          __        __    
4 //|    |   _____     __| _/__.__. /  \    /  \____    |__|____  |  | __
5 //|    |   \__  \   / __ <   |  | \   \/\/   /  _ \   |  \__  \ |  |/ /
6 //|    |___ / __ \_/ /_/ |\___  |  \        (  <_> )  |  |/ __ \|    < 
7 //|_______ (____  /\____ |/ ____|   \__/\  / \____/\__|  (____  /__|_ \
8 //        \/    \/      \/\/             \/       \______|    \/     \/
9 //
10 // Don't be sad, join the Lady Wojak community and get Wojakin'!
11 // Telegram-> t.me/LadyWojak 
12 // Twitter -> twitter.com/Lady_Wojak
13 
14 
15 pragma solidity ^0.8.4;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         return c;
68     }
69 
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     address private _previousOwner;
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor () {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97 }  
98 
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102 
103 interface IUniswapV2Router02 {
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121 }
122 
123 contract LadyWojak is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _rOwned;
126     mapping (address => uint256) private _tOwned;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping (address => uint) private cooldown;
131     uint256 private constant MAX = ~uint256(0);
132     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
133     uint256 private _rTotal = (MAX - (MAX % _tTotal));
134     uint256 private _tFeeTotal;
135     
136     uint256 private _feeAddr1;
137     uint256 private _feeAddr2;
138     address payable private _feeAddrWallet1;
139     address payable private _feeAddrWallet2;
140     
141     string private constant _name = "LadyWojak";
142     string private constant _symbol = "LadyWojak";
143     uint8 private constant _decimals = 9;
144     
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150     bool private cooldownEnabled = false;
151     uint256 private _maxTxAmount = _tTotal;
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158     constructor () {
159         _feeAddrWallet1 = payable(0x9E0d765c3A8d4c680a7DA273a12c61178C3a3DEC);
160         _feeAddrWallet2 = payable(0x9E0d765c3A8d4c680a7DA273a12c61178C3a3DEC);
161         _rOwned[_msgSender()] = _rTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_feeAddrWallet1] = true;
165         _isExcludedFromFee[_feeAddrWallet2] = true;
166         emit Transfer(address(0x347EC6793B6eA5aa7e893012a702150668B0Aaf7), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return tokenFromReflection(_rOwned[account]);
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function setCooldownEnabled(bool onoff) external onlyOwner() {
210         cooldownEnabled = onoff;
211     }
212 
213     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
214         require(rAmount <= _rTotal, "Amount must be less than total reflections");
215         uint256 currentRate =  _getRate();
216         return rAmount.div(currentRate);
217     }
218 
219     function _approve(address owner, address spender, uint256 amount) private {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 
226     function _transfer(address from, address to, uint256 amount) private {
227         require(from != address(0), "ERC20: transfer from the zero address");
228         require(to != address(0), "ERC20: transfer to the zero address");
229         require(amount > 0, "Transfer amount must be greater than zero");
230         _feeAddr1 = 1;
231         _feeAddr2 = 7;
232         if (from != owner() && to != owner()) {
233             require(!bots[from] && !bots[to]);
234             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
235                 // Cooldown
236                 require(amount <= _maxTxAmount);
237                 require(cooldown[to] < block.timestamp);
238                 cooldown[to] = block.timestamp + (30 seconds);
239             }
240             
241             
242             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
243                 _feeAddr1 = 1;
244                 _feeAddr2 = 7;
245             }
246             uint256 contractTokenBalance = balanceOf(address(this));
247             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
248                 swapTokensForEth(contractTokenBalance);
249                 uint256 contractETHBalance = address(this).balance;
250                 if(contractETHBalance > 0) {
251                     sendETHToFee(address(this).balance);
252                 }
253             }
254         }
255 		
256         _tokenTransfer(from,to,amount);
257     }
258 
259     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
260         address[] memory path = new address[](2);
261         path[0] = address(this);
262         path[1] = uniswapV2Router.WETH();
263         _approve(address(this), address(uniswapV2Router), tokenAmount);
264         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
265             tokenAmount,
266             0,
267             path,
268             address(this),
269             block.timestamp
270         );
271     }
272         
273     function sendETHToFee(uint256 amount) private {
274         _feeAddrWallet1.transfer(amount.div(2));
275         _feeAddrWallet2.transfer(amount.div(2));
276     }
277     
278     function openTrading() external onlyOwner() {
279         require(!tradingOpen,"trading is already open");
280         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
281         uniswapV2Router = _uniswapV2Router;
282         _approve(address(this), address(uniswapV2Router), _tTotal);
283         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
284         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
285         swapEnabled = true;
286         cooldownEnabled = true;
287         _maxTxAmount = 50000000000000000 * 10**9;
288         tradingOpen = true;
289         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
290     }
291     
292     function setBots(address[] memory bots_) public onlyOwner {
293         for (uint i = 0; i < bots_.length; i++) {
294             bots[bots_[i]] = true;
295         }
296     }
297     
298     function delBot(address notbot) public onlyOwner {
299         bots[notbot] = false;
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
329         require(_msgSender() == _feeAddrWallet1);
330         uint256 contractBalance = balanceOf(address(this));
331         swapTokensForEth(contractBalance);
332     }
333     
334     function manualsend() external {
335         require(_msgSender() == _feeAddrWallet1);
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