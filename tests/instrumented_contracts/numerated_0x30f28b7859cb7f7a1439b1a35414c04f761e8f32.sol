1 /**
2  //SPDX-License-Identifier: UNLICENSED
3 
4 */
5 
6 pragma solidity ^0.8.4;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     address private _previousOwner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }  
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract BebopInu is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _rOwned;
117     mapping (address => uint256) private _tOwned;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => bool) private bots;
121     mapping (address => uint) private cooldown;
122     uint256 private constant MAX = ~uint256(0);
123     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
124     uint256 private _rTotal = (MAX - (MAX % _tTotal));
125     uint256 private _tFeeTotal;
126     
127     uint256 private _feeAddr1;
128     uint256 private _feeAddr2;
129     address payable private _feeAddrWallet1;
130     address payable private _feeAddrWallet2;
131     
132     string private constant _name = "Bebop Inu";
133     string private constant _symbol = "Bebop-Inu";
134     uint8 private constant _decimals = 9;
135     
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
149     constructor () {
150         _feeAddrWallet1 = payable(0x3060cF7116e28139ad235Def07C744940342dAAE);
151         _feeAddrWallet2 = payable(0x3060cF7116e28139ad235Def07C744940342dAAE);
152         _rOwned[_msgSender()] = _rTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_feeAddrWallet1] = true;
156         _isExcludedFromFee[_feeAddrWallet2] = true;
157         emit Transfer(address(0xE14c40CbF85ed1fA2E204966e91841efE258Fe65), _msgSender(), _tTotal);
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
210     function _approve(address owner, address spender, uint256 amount) private {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _transfer(address from, address to, uint256 amount) private {
218         require(from != address(0), "ERC20: transfer from the zero address");
219         require(to != address(0), "ERC20: transfer to the zero address");
220         require(amount > 0, "Transfer amount must be greater than zero");
221         _feeAddr1 = 2;
222         _feeAddr2 = 8;
223         if (from != owner() && to != owner()) {
224             require(!bots[from] && !bots[to]);
225             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
226                 // Cooldown
227                 require(amount <= _maxTxAmount);
228                 require(cooldown[to] < block.timestamp);
229                 cooldown[to] = block.timestamp + (30 seconds);
230             }
231             
232             
233             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
234                 _feeAddr1 = 2;
235                 _feeAddr2 = 8;
236             }
237             uint256 contractTokenBalance = balanceOf(address(this));
238             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
239                 swapTokensForEth(contractTokenBalance);
240                 uint256 contractETHBalance = address(this).balance;
241                 if(contractETHBalance > 0) {
242                     sendETHToFee(address(this).balance);
243                 }
244             }
245         }
246 		
247         _tokenTransfer(from,to,amount);
248     }
249 
250     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
251         address[] memory path = new address[](2);
252         path[0] = address(this);
253         path[1] = uniswapV2Router.WETH();
254         _approve(address(this), address(uniswapV2Router), tokenAmount);
255         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
256             tokenAmount,
257             0,
258             path,
259             address(this),
260             block.timestamp
261         );
262     }
263         
264     function sendETHToFee(uint256 amount) private {
265         _feeAddrWallet1.transfer(amount.div(2));
266         _feeAddrWallet2.transfer(amount.div(2));
267     }
268     
269     function openTrading() external onlyOwner() {
270         require(!tradingOpen,"trading is already open");
271         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
272         uniswapV2Router = _uniswapV2Router;
273         _approve(address(this), address(uniswapV2Router), _tTotal);
274         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
275         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
276         swapEnabled = true;
277         cooldownEnabled = true;
278         _maxTxAmount = 50000000000000000 * 10**9;
279         tradingOpen = true;
280         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
281     }
282     
283     function setBots(address[] memory bots_) public onlyOwner {
284         for (uint i = 0; i < bots_.length; i++) {
285             bots[bots_[i]] = true;
286         }
287     }
288     
289     function delBot(address notbot) public onlyOwner {
290         bots[notbot] = false;
291     }
292         
293     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
294         _transferStandard(sender, recipient, amount);
295     }
296 
297     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
298         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
299         _rOwned[sender] = _rOwned[sender].sub(rAmount);
300         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
301         _takeTeam(tTeam);
302         _reflectFee(rFee, tFee);
303         emit Transfer(sender, recipient, tTransferAmount);
304     }
305 
306     function _takeTeam(uint256 tTeam) private {
307         uint256 currentRate =  _getRate();
308         uint256 rTeam = tTeam.mul(currentRate);
309         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
310     }
311 
312     function _reflectFee(uint256 rFee, uint256 tFee) private {
313         _rTotal = _rTotal.sub(rFee);
314         _tFeeTotal = _tFeeTotal.add(tFee);
315     }
316 
317     receive() external payable {}
318     
319     function manualswap() external {
320         require(_msgSender() == _feeAddrWallet1);
321         uint256 contractBalance = balanceOf(address(this));
322         swapTokensForEth(contractBalance);
323     }
324     
325     function manualsend() external {
326         require(_msgSender() == _feeAddrWallet1);
327         uint256 contractETHBalance = address(this).balance;
328         sendETHToFee(contractETHBalance);
329     }
330     
331 
332     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
333         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
334         uint256 currentRate =  _getRate();
335         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
336         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
337     }
338 
339     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
340         uint256 tFee = tAmount.mul(taxFee).div(100);
341         uint256 tTeam = tAmount.mul(TeamFee).div(100);
342         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
343         return (tTransferAmount, tFee, tTeam);
344     }
345 
346     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
347         uint256 rAmount = tAmount.mul(currentRate);
348         uint256 rFee = tFee.mul(currentRate);
349         uint256 rTeam = tTeam.mul(currentRate);
350         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
351         return (rAmount, rTransferAmount, rFee);
352     }
353 
354 	function _getRate() private view returns(uint256) {
355         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
356         return rSupply.div(tSupply);
357     }
358 
359     function _getCurrentSupply() private view returns(uint256, uint256) {
360         uint256 rSupply = _rTotal;
361         uint256 tSupply = _tTotal;      
362         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
363         return (rSupply, tSupply);
364     }
365 }