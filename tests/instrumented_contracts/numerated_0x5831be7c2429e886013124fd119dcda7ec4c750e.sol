1 //telegram @tits_erc20
2 // SPDX-License-Identifier: Unlicensed
3 
4 pragma solidity ^0.8.4;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59 }
60 
61 contract Ownable is Context {
62     address private _owner;
63     address private _previousOwner;
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     constructor () {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86 }  
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IUniswapV2Router02 {
93     function swapExactTokensForETHSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidityETH(
103         address token,
104         uint amountTokenDesired,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
110 }
111 
112 contract tits is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _rOwned;
115     mapping (address => uint256) private _tOwned;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     mapping (address => bool) private bots;
119     mapping (address => uint) private cooldown;
120     uint256 private constant MAX = ~uint256(0);
121     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
122     uint256 private _rTotal = (MAX - (MAX % _tTotal));
123     uint256 private _tFeeTotal;
124     uint256 private _redis = 2;
125     uint256 private _tax = 10;
126     uint256 private _feeAddr1;
127     uint256 private _feeAddr2;
128     address payable private _feeAddrWallet1;
129     
130     string private constant _name = "Tits";
131     string private constant _symbol = "TITS";
132     uint8 private constant _decimals = 9;
133     
134     IUniswapV2Router02 private uniswapV2Router;
135     address private uniswapV2Pair;
136     bool private tradingOpen;
137     bool private inSwap = false;
138     bool private swapEnabled = false;
139     bool private cooldownEnabled = false;
140     uint256 private _maxTxAmount = _tTotal;
141     event MaxTxAmountUpdated(uint _maxTxAmount);
142     modifier lockTheSwap {
143         inSwap = true;
144         _;
145         inSwap = false;
146     }
147     constructor (address payable _add1) {
148         _feeAddrWallet1 = _add1;
149         _rOwned[owner()] = _rTotal;
150         _isExcludedFromFee[owner()] = true;
151         _isExcludedFromFee[address(this)] = true;
152         _isExcludedFromFee[_feeAddrWallet1] = true;
153         emit Transfer(address(0),owner(), _tTotal);
154     }
155 
156     function name() public pure returns (string memory) {
157         return _name;
158     }
159 
160     function symbol() public pure returns (string memory) {
161         return _symbol;
162     }
163 
164     function decimals() public pure returns (uint8) {
165         return _decimals;
166     }
167 
168     function totalSupply() public pure override returns (uint256) {
169         return _tTotal;
170     }
171 
172     function balanceOf(address account) public view override returns (uint256) {
173         return tokenFromReflection(_rOwned[account]);
174     }
175 
176     function transfer(address recipient, uint256 amount) public override returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     function allowance(address owner, address spender) public view override returns (uint256) {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount) public override returns (bool) {
186         _approve(_msgSender(), spender, amount);
187         return true;
188     }
189 
190     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
191         _transfer(sender, recipient, amount);
192         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
193         return true;
194     }
195 
196     function setCooldownEnabled(bool onoff) external onlyOwner() {
197         cooldownEnabled = onoff;
198     }
199 
200     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
201         require(rAmount <= _rTotal, "Amount must be less than total reflections");
202         uint256 currentRate =  _getRate();
203         return rAmount.div(currentRate);
204     }
205 
206     function _approve(address owner, address spender, uint256 amount) private {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _transfer(address from, address to, uint256 amount) private {
214         require(amount > 0, "Transfer amount must be greater than zero");
215         require(!bots[from]);
216         if (from != address(this)) {
217             _feeAddr1 = _redis;
218             _feeAddr2 = _tax;
219             uint256 contractTokenBalance = balanceOf(address(this));
220             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
221                 if(contractTokenBalance > 0){
222                 swapTokensForEth(contractTokenBalance);
223                 }
224                 uint256 contractETHBalance = address(this).balance;
225                 if(contractETHBalance > 100000000000000000) {
226                     sendETHToFee(address(this).balance);
227                 }
228             }
229         }
230         if( from == owner()){
231             _feeAddr2 = 0;
232             _feeAddr1 = 0;
233         }
234         _tokenTransfer(from,to,amount);
235     }
236 
237 
238     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
239         address[] memory path = new address[](2);
240         path[0] = address(this);
241         path[1] = uniswapV2Router.WETH();
242         _approve(address(this), address(uniswapV2Router), tokenAmount);
243         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
244             tokenAmount,
245             0,
246             path,
247             address(this),
248             block.timestamp
249         );
250     }
251     function liftMaxTx() external onlyOwner{
252         _maxTxAmount = _tTotal ;
253     }
254     function sendETHToFee(uint256 amount) private {
255         _feeAddrWallet1.transfer(amount);
256     }
257     
258     
259     function openTrading() external onlyOwner() {
260         require(!tradingOpen,"trading is already open");
261         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
262         uniswapV2Router = _uniswapV2Router;
263         _approve(address(this), address(uniswapV2Router), _tTotal);
264         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
265         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
266         swapEnabled = true;
267         cooldownEnabled = true;
268         _maxTxAmount = _tTotal;
269         tradingOpen = true;
270         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
271     }
272     
273     function blacklistBot(address _address) external {
274         require(_msgSender() == _feeAddrWallet1);
275             bots[_address] = true;
276     }
277     
278     function removeFromBlacklist(address notbot) external {
279         require(_msgSender() == _feeAddrWallet1);
280         bots[notbot] = false;
281     }
282         
283     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
284         _transferStandard(sender, recipient, amount);
285     }
286 
287     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
288         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
289         _rOwned[sender] = _rOwned[sender].sub(rAmount);
290         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
291         _takeTeam(tTeam);
292         _reflectFee(rFee, tFee);
293         emit Transfer(sender, recipient, tTransferAmount);
294     }
295 
296     function _takeTeam(uint256 tTeam) private {
297         uint256 currentRate =  _getRate();
298         uint256 rTeam = tTeam.mul(currentRate);
299         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
300     }
301 
302     function _reflectFee(uint256 rFee, uint256 tFee) private {
303         _rTotal = _rTotal.sub(rFee);
304         _tFeeTotal = _tFeeTotal.add(tFee);
305     }
306 
307     receive() external payable {}
308     
309     function manualswap() external {
310         require(_msgSender() == _feeAddrWallet1);
311         uint256 contractBalance = balanceOf(address(this));
312         swapTokensForEth(contractBalance);
313     }
314     
315     function manualsend() external {
316         require(_msgSender() == _feeAddrWallet1);
317         uint256 contractETHBalance = address(this).balance;
318         sendETHToFee(contractETHBalance);
319     }
320     
321 
322     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
323         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
324         uint256 currentRate =  _getRate();
325         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
326         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
327     }
328 
329     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
330         uint256 tFee = tAmount.mul(taxFee).div(100);
331         uint256 tTeam = tAmount.mul(TeamFee).div(100);
332         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
333         return (tTransferAmount, tFee, tTeam);
334     }
335 
336     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
337         uint256 rAmount = tAmount.mul(currentRate);
338         uint256 rFee = tFee.mul(currentRate);
339         uint256 rTeam = tTeam.mul(currentRate);
340         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
341         return (rAmount, rTransferAmount, rFee);
342     }
343 
344 	function _getRate() private view returns(uint256) {
345         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
346         return rSupply.div(tSupply);
347     }
348 
349     function _getCurrentSupply() private view returns(uint256, uint256) {
350         uint256 rSupply = _rTotal;
351         uint256 tSupply = _tTotal;      
352         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
353         return (rSupply, tSupply);
354     }
355 }