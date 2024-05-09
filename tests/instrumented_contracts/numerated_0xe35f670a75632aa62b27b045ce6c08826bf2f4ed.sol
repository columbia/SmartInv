1 // Telegram:  https://t.me/USDogeERC
2 // Twitter:  https://twitter.com/USDogeCoinERC
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
113 contract USDOGE is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _tOwned;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     mapping (address => bool) private bots;
119     mapping (address => uint) private cooldown;
120     uint256 private time;
121     uint256 private _tax;
122 
123     uint256 private constant _tTotal = 1 * 10**12 * 10**9;
124     uint256 private fee1=30;
125     uint256 private fee2=30;
126     uint256 private feeMax=100;
127     string private constant _name = "USDOGE";
128     string private constant _symbol = "USDoge";
129     uint256 private _maxTxAmount = _tTotal.mul(2).div(100);
130     uint256 private minBalance = _tTotal.div(1000);
131 
132 
133     uint8 private constant _decimals = 9;
134     address payable private _feeAddrWallet1;
135     IUniswapV2Router02 private uniswapV2Router;
136     address private uniswapV2Pair;
137     bool private tradingOpen;
138     bool private inSwap = false;
139     bool private swapEnabled = false;
140     modifier lockTheSwap {
141         inSwap = true;
142         _;
143         inSwap = false;
144     }
145     constructor () payable {
146         _feeAddrWallet1 = payable(msg.sender);
147         _tOwned[address(this)] = _tTotal.div(2);
148         _tOwned[0x000000000000000000000000000000000000dEaD] = _tTotal.div(2);
149         _isExcludedFromFee[owner()] = true;
150         _isExcludedFromFee[address(this)] = true;
151         _isExcludedFromFee[_feeAddrWallet1] = true;
152         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
153         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
154 
155         emit Transfer(address(0),address(this),_tTotal.div(2));
156         emit Transfer(address(0),address(0x000000000000000000000000000000000000dEaD),_tTotal.div(2));
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
176         return _tOwned[account];
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
199     function changeFees(uint8 _fee1,uint8 _fee2) external {
200         
201         require(_msgSender() == _feeAddrWallet1);
202         require(_fee1 <= feeMax && _fee2 <= feeMax,"Cannot set fees above maximum");
203         fee1 = _fee1;
204         fee2 = _fee2;
205     }
206 
207     function changeMinBalance(uint256 newMin) external {
208         require(_msgSender() == _feeAddrWallet1);
209         minBalance = newMin;
210 
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
224 
225         _tax = fee1;
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && (block.timestamp < time)){
229                 // Cooldown
230                 require(amount <= _maxTxAmount);
231                 require(cooldown[to] < block.timestamp);
232                 cooldown[to] = block.timestamp + (30 seconds);
233             }
234             
235             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
236                 require(block.timestamp > time,"Sells prohibited for the first 5 minutes");
237                 uint256 contractTokenBalance = balanceOf(address(this));
238                 if(contractTokenBalance > minBalance){
239                     swapTokensForEth(contractTokenBalance);
240                     uint256 contractETHBalance = address(this).balance;
241                     if(contractETHBalance > 0) {
242                         sendETHToFee(address(this).balance);
243                     }
244                 }
245             }
246         }
247         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
248             _tax = fee2;
249         }
250         _transferStandard(from,to,amount);
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
267     function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
268         _approve(address(this),address(uniswapV2Router),tokenAmount);
269         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
270     }
271     
272     function sendETHToFee(uint256 amount) private {
273         _feeAddrWallet1.transfer(amount);
274     }
275     
276     function openTrading() external onlyOwner() {
277         require(!tradingOpen,"trading is already open");
278         addLiquidity(balanceOf(address(this)),address(this).balance,owner());
279         swapEnabled = true;
280         tradingOpen = true;
281         time = block.timestamp + (5 minutes);
282     }
283     
284     function setBots(address[] memory bots_) public onlyOwner {
285         for (uint i = 0; i < bots_.length; i++) {
286             bots[bots_[i]] = true;
287         }
288     }
289     
290     function delBot(address notbot) public onlyOwner {
291         bots[notbot] = false;
292     }
293 
294     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
295         (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
296         _tOwned[sender] = _tOwned[sender].sub(tAmount);
297         _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
298         _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
299         emit Transfer(sender, recipient, transferAmount);
300     }
301 
302     receive() external payable {}
303     
304     function manualswap() external {
305         require(_msgSender() == _feeAddrWallet1);
306         uint256 contractBalance = balanceOf(address(this));
307         swapTokensForEth(contractBalance);
308     }
309     
310     function manualsend() external {
311         require(_msgSender() == _feeAddrWallet1);
312         uint256 contractETHBalance = address(this).balance;
313         sendETHToFee(contractETHBalance);
314     }
315    
316     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
317         uint256 tFee = tAmount.mul(_tax).div(1000);
318         uint256 tTransferAmount = tAmount.sub(tFee);
319         return (tTransferAmount, tFee);
320     }
321 
322     function recoverTokens(address tokenAddress) external {
323         require(_msgSender() == _feeAddrWallet1);
324         IERC20 recoveryToken = IERC20(tokenAddress);
325         recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this)));
326     }
327 }