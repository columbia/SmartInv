1 pragma solidity ^0.8.4;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36 
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         return c;
54     }
55 
56 }
57 
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor () {
64         address msgSender = _msgSender();
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83 }  
84 
85 interface IUniswapV2Factory {
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87 }
88 
89 interface IUniswapV2Router02 {
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external;
97     function factory() external pure returns (address);
98     function WETH() external pure returns (address);
99     function addLiquidityETH(
100         address token,
101         uint amountTokenDesired,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
107 }
108 
109 contract RickAndMorty is Context, IERC20, Ownable {
110     using SafeMath for uint256;
111     mapping (address => uint256) private _rOwned;
112     mapping (address => uint256) private _tOwned;
113     mapping (address => mapping (address => uint256)) private _allowances;
114     mapping (address => bool) private _isExcludedFromFee;
115     mapping (address => bool) private bots;
116     mapping (address => uint) private cooldown;
117     uint256 private constant MAX = ~uint256(0);
118     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
119     uint256 private _rTotal = (MAX - (MAX % _tTotal));
120     uint256 private _tFeeTotal;
121     
122     uint256 private _feeAddr1;
123     uint256 private _feeAddr2;
124     address payable private _feeAddrWallet1;
125     address payable private _feeAddrWallet2;
126     
127     string private constant _name = "Rick And Morty";
128     string private constant _symbol = "RICKMORTY";
129     uint8 private constant _decimals = 9;
130     
131     IUniswapV2Router02 private uniswapV2Router;
132     address private uniswapV2Pair;
133     bool private tradingOpen;
134     bool private inSwap = false;
135     bool private swapEnabled = false;
136     bool private cooldownEnabled = false;
137     uint256 private _maxTxAmount = _tTotal;
138     event MaxTxAmountUpdated(uint _maxTxAmount);
139     modifier lockTheSwap {
140         inSwap = true;
141         _;
142         inSwap = false;
143     }
144     constructor () {
145         _feeAddrWallet1 = payable(0x08992fda30f56D6dE4DB639D78406F51d5a4Ca06);
146         _feeAddrWallet2 = payable(0x08992fda30f56D6dE4DB639D78406F51d5a4Ca06);
147         _rOwned[_msgSender()] = _rTotal;
148         _isExcludedFromFee[owner()] = true;
149         _isExcludedFromFee[address(this)] = true;
150         _isExcludedFromFee[_feeAddrWallet1] = true;
151         _isExcludedFromFee[_feeAddrWallet2] = true;
152         emit Transfer(address(0xF273b655A6e7EE55F70539Cf365A57fae5036E6f), _msgSender(), _tTotal);
153     }
154 
155     function name() public pure returns (string memory) {
156         return _name;
157     }
158 
159     function symbol() public pure returns (string memory) {
160         return _symbol;
161     }
162 
163     function decimals() public pure returns (uint8) {
164         return _decimals;
165     }
166 
167     function totalSupply() public pure override returns (uint256) {
168         return _tTotal;
169     }
170 
171     function balanceOf(address account) public view override returns (uint256) {
172         return tokenFromReflection(_rOwned[account]);
173     }
174 
175     function transfer(address recipient, uint256 amount) public override returns (bool) {
176         _transfer(_msgSender(), recipient, amount);
177         return true;
178     }
179 
180     function allowance(address owner, address spender) public view override returns (uint256) {
181         return _allowances[owner][spender];
182     }
183 
184     function approve(address spender, uint256 amount) public override returns (bool) {
185         _approve(_msgSender(), spender, amount);
186         return true;
187     }
188 
189     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
190         _transfer(sender, recipient, amount);
191         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
192         return true;
193     }
194 
195     function setCooldownEnabled(bool onoff) external onlyOwner() {
196         cooldownEnabled = onoff;
197     }
198 
199     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
200         require(rAmount <= _rTotal, "Amount must be less than total reflections");
201         uint256 currentRate =  _getRate();
202         return rAmount.div(currentRate);
203     }
204 
205     function _approve(address owner, address spender, uint256 amount) private {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212     function _transfer(address from, address to, uint256 amount) private {
213         require(from != address(0), "ERC20: transfer from the zero address");
214         require(to != address(0), "ERC20: transfer to the zero address");
215         require(amount > 0, "Transfer amount must be greater than zero");
216         _feeAddr1 = 2;
217         _feeAddr2 = 8;
218         if (from != owner() && to != owner()) {
219             require(!bots[from] && !bots[to]);
220             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
221                 // Cooldown
222                 require(amount <= _maxTxAmount);
223                 require(cooldown[to] < block.timestamp);
224                 cooldown[to] = block.timestamp + (30 seconds);
225             }
226             
227             
228             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
229                 _feeAddr1 = 2;
230                 _feeAddr2 = 8;
231             }
232             uint256 contractTokenBalance = balanceOf(address(this));
233             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
234                 swapTokensForEth(contractTokenBalance);
235                 uint256 contractETHBalance = address(this).balance;
236                 if(contractETHBalance > 0) {
237                     sendETHToFee(address(this).balance);
238                 }
239             }
240         }
241 		
242         _tokenTransfer(from,to,amount);
243     }
244 
245     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
246         address[] memory path = new address[](2);
247         path[0] = address(this);
248         path[1] = uniswapV2Router.WETH();
249         _approve(address(this), address(uniswapV2Router), tokenAmount);
250         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
251             tokenAmount,
252             0,
253             path,
254             address(this),
255             block.timestamp
256         );
257     }
258         
259     function sendETHToFee(uint256 amount) private {
260         _feeAddrWallet1.transfer(amount.div(2));
261         _feeAddrWallet2.transfer(amount.div(2));
262     }
263     
264     function openTrading() external onlyOwner() {
265         require(!tradingOpen,"trading is already open");
266         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
267         uniswapV2Router = _uniswapV2Router;
268         _approve(address(this), address(uniswapV2Router), _tTotal);
269         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
270         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
271         swapEnabled = true;
272         cooldownEnabled = true;
273         _maxTxAmount = 50000000000000000 * 10**9;
274         tradingOpen = true;
275         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
276     }
277     
278     function setBots(address[] memory bots_) public onlyOwner {
279         for (uint i = 0; i < bots_.length; i++) {
280             bots[bots_[i]] = true;
281         }
282     }
283     
284     function delBot(address notbot) public onlyOwner {
285         bots[notbot] = false;
286     }
287         
288     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
289         _transferStandard(sender, recipient, amount);
290     }
291 
292     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
293         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
294         _rOwned[sender] = _rOwned[sender].sub(rAmount);
295         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
296         _takeTeam(tTeam);
297         _reflectFee(rFee, tFee);
298         emit Transfer(sender, recipient, tTransferAmount);
299     }
300 
301     function _takeTeam(uint256 tTeam) private {
302         uint256 currentRate =  _getRate();
303         uint256 rTeam = tTeam.mul(currentRate);
304         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
305     }
306 
307     function _reflectFee(uint256 rFee, uint256 tFee) private {
308         _rTotal = _rTotal.sub(rFee);
309         _tFeeTotal = _tFeeTotal.add(tFee);
310     }
311 
312     receive() external payable {}
313     
314     function manualswap() external {
315         require(_msgSender() == _feeAddrWallet1);
316         uint256 contractBalance = balanceOf(address(this));
317         swapTokensForEth(contractBalance);
318     }
319     
320     function manualsend() external {
321         require(_msgSender() == _feeAddrWallet1);
322         uint256 contractETHBalance = address(this).balance;
323         sendETHToFee(contractETHBalance);
324     }
325     
326 
327     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
328         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
329         uint256 currentRate =  _getRate();
330         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
331         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
332     }
333 
334     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
335         uint256 tFee = tAmount.mul(taxFee).div(100);
336         uint256 tTeam = tAmount.mul(TeamFee).div(100);
337         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
338         return (tTransferAmount, tFee, tTeam);
339     }
340 
341     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
342         uint256 rAmount = tAmount.mul(currentRate);
343         uint256 rFee = tFee.mul(currentRate);
344         uint256 rTeam = tTeam.mul(currentRate);
345         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
346         return (rAmount, rTransferAmount, rFee);
347     }
348 
349 	function _getRate() private view returns(uint256) {
350         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
351         return rSupply.div(tSupply);
352     }
353 
354     function _getCurrentSupply() private view returns(uint256, uint256) {
355         uint256 rSupply = _rTotal;
356         uint256 tSupply = _tTotal;      
357         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
358         return (rSupply, tSupply);
359     }
360 }