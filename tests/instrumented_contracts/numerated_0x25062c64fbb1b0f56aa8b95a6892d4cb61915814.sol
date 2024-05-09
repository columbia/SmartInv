1 /*
2 TG:  T.me/reeecoineth 
3 
4 Website:  https://www.reee.club/
5 
6 Twitter:  https://twitter.com/ReeeClub
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity ^0.8.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     address private _previousOwner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }  
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract Reee is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private time;
127     uint256 private _tax;
128 
129     uint256 private constant _tTotal = 69420 * 10**3 * 10**9;
130     uint256 private fee1=0;
131     uint256 private fee2=0;
132     uint256 private feeMax=0;
133     string private constant _name = "Reee";
134     string private constant _symbol = "REEE";
135     uint256 private _maxTxAmount = _tTotal.mul(50).div(10000);
136     uint256 private minBalance = _tTotal.div(1000);
137 
138 
139     uint8 private constant _decimals = 9;
140     address payable private _feeAddrWallet1;
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private tradingOpen;
144     bool private inSwap = false;
145     bool private swapEnabled = false;
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151     constructor () payable {
152         _feeAddrWallet1 = payable(msg.sender);
153         _tOwned[address(this)] = _tTotal.div(10).mul(9);
154         _tOwned[msg.sender] = _tTotal.div(10);
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_feeAddrWallet1] = true;
158         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
159         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
160 
161         emit Transfer(address(0),address(this),_tTotal.div(10).mul(9));
162         emit Transfer(address(0),address(msg.sender),_tTotal.div(10));
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return _tOwned[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204    
205     function changeFees(uint8 _fee1,uint8 _fee2) external {
206         
207         require(_msgSender() == _feeAddrWallet1);
208         require(_fee1 <= feeMax && _fee2 <= feeMax,"Cannot set fees above maximum");
209         fee1 = _fee1;
210         fee2 = _fee2;
211     }
212 
213     function changeMinBalance(uint256 newMin) external {
214         require(_msgSender() == _feeAddrWallet1);
215         minBalance = newMin;
216 
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
230 
231         _tax = fee1;
232         if (from != owner() && to != owner()) {
233             require(!bots[from] && !bots[to]);
234             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && (block.timestamp < time)){
235                 // Cooldown
236                 require(amount <= _maxTxAmount);
237                 require(cooldown[to] < block.timestamp);
238                 cooldown[to] = block.timestamp + (30 seconds);
239             }
240             
241             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
242                 require(block.timestamp > time,"Sells prohibited for the first 5 minutes");
243                 uint256 contractTokenBalance = balanceOf(address(this));
244                 if(contractTokenBalance > minBalance){
245                     swapTokensForEth(contractTokenBalance);
246                     uint256 contractETHBalance = address(this).balance;
247                     if(contractETHBalance > 0) {
248                         sendETHToFee(address(this).balance);
249                     }
250                 }
251             }
252         }
253         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
254             _tax = fee2;
255         }
256         _transferStandard(from,to,amount);
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
273     function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
274         _approve(address(this),address(uniswapV2Router),tokenAmount);
275         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
276     }
277     
278     function sendETHToFee(uint256 amount) private {
279         _feeAddrWallet1.transfer(amount);
280     }
281     
282     function openTrading() external onlyOwner() {
283         require(!tradingOpen,"trading is already open");
284         addLiquidity(balanceOf(address(this)),address(this).balance,owner());
285         swapEnabled = true;
286         tradingOpen = true;
287         time = block.timestamp + (5 minutes);
288     }
289     
290     function setBots(address[] memory bots_) public onlyOwner {
291         for (uint i = 0; i < bots_.length; i++) {
292             bots[bots_[i]] = true;
293         }
294     }
295     
296     function delBot(address notbot) public onlyOwner {
297         bots[notbot] = false;
298     }
299 
300     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
301         (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
302         _tOwned[sender] = _tOwned[sender].sub(tAmount);
303         _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
304         _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
305         emit Transfer(sender, recipient, transferAmount);
306     }
307 
308     receive() external payable {}
309     
310     function manualswap() external {
311         require(_msgSender() == _feeAddrWallet1);
312         uint256 contractBalance = balanceOf(address(this));
313         swapTokensForEth(contractBalance);
314     }
315     
316     function manualsend() external {
317         require(_msgSender() == _feeAddrWallet1);
318         uint256 contractETHBalance = address(this).balance;
319         sendETHToFee(contractETHBalance);
320     }
321    
322     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
323         uint256 tFee = tAmount.mul(_tax).div(1000);
324         uint256 tTransferAmount = tAmount.sub(tFee);
325         return (tTransferAmount, tFee);
326     }
327 
328     function recoverTokens(address tokenAddress) external {
329         require(_msgSender() == _feeAddrWallet1);
330         IERC20 recoveryToken = IERC20(tokenAddress);
331         recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this)));
332     }
333 }