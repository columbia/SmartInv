1 // SPDX-License-Identifier: MIT
2 /**
3 
4 🤖 Utopia Bot
5 Web: https://utopia-bot.com
6 Portal: https://t.me/utopiabotportal
7 Twitter: https://twitter.com/Utopiabots
8 Gitbook: https://utopiabots.gitbook.io/utopia-bot/
9 Youtube: https://www.youtube.com/@utopiabot
10 
11 **/
12 pragma solidity 0.8.17;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
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
119 contract UtopiaBot is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping(address => uint256) private _holderLastTransferTimestamp;
125     address payable private _taxWallet;
126 
127     uint256 private _Tax=25;
128 
129     uint8 private constant _decimals = 18;
130     uint256 private constant _tTotal = 100000000 * 10**_decimals;
131     string private constant _name = "UTOPIA BOT";
132     string private constant _symbol = "UB";
133     uint256 public _maxTxAmount =   2000000 * 10**_decimals;
134     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
135     uint256 public _taxSwapThreshold=500000 * 10**_decimals;
136     uint256 public _maxTaxSwap=500000 * 10**_decimals;
137 
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143 
144     event updateMaxAmount(uint _maxTxAmount);
145     
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151 
152     constructor () {
153         _taxWallet = payable(_msgSender());
154         _balances[_msgSender()] = _tTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_taxWallet] = true;
158 
159         emit Transfer(address(0), _msgSender(), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public pure override returns (uint256) {
175         return _tTotal;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return _balances[account];
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function changeTax(uint256 _newTax) external onlyOwner{
203           require(_newTax <= 25, "ERC20: tax must be under 25%");
204           _Tax = _newTax;
205     }
206 
207     function _approve(address owner, address spender, uint256 amount) private {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 
214     function _transfer(address from, address to, uint256 amount) private {
215         require(from != address(0), "ERC20: transfer from the zero address");
216         require(to != address(0), "ERC20: transfer to the zero address");
217         require(amount > 0, "Transfer amount > zero");
218         uint256 taxAmount=0;
219         if (from != owner() && to != owner()) {
220             taxAmount = amount.mul(_Tax).div(100);
221             
222             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to]) {
223                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
224                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
225             }
226 
227             if(to == uniswapV2Pair && from!= address(this) ){
228                 taxAmount = amount.mul(_Tax).div(100);
229             }
230 
231             uint256 contractTokenBalance = balanceOf(address(this));
232             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
233                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
234                 uint256 contractETHBalance = address(this).balance;
235                 if(contractETHBalance > 0) {
236                     sendETHToFee(address(this).balance);
237                 }
238             }
239         }
240 
241         if(taxAmount>0){
242           _balances[address(this)]=_balances[address(this)].add(taxAmount);
243           emit Transfer(from, address(this),taxAmount);
244         }
245         _balances[from]=_balances[from].sub(amount);
246         _balances[to]=_balances[to].add(amount.sub(taxAmount));
247         emit Transfer(from, to, amount.sub(taxAmount));
248     }
249 
250     function min(uint256 a, uint256 b) private pure returns (uint256){
251       return (a>b)?b:a;
252     }
253 
254     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
255         address[] memory path = new address[](2);
256         path[0] = address(this);
257         path[1] = uniswapV2Router.WETH();
258         _approve(address(this), address(uniswapV2Router), tokenAmount);
259         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
260             tokenAmount,
261             0,
262             path,
263             address(this),
264             block.timestamp
265         );
266     }
267 
268     function removeLimits() external onlyOwner{
269         _maxTxAmount = _tTotal;
270         _maxWalletSize=_tTotal;
271         emit updateMaxAmount(_tTotal);
272     }
273 
274     function sendETHToFee(uint256 amount) private {
275         _taxWallet.transfer(amount);
276     }
277 
278     function openTrading() external onlyOwner() {
279         require(!tradingOpen,"trading is already open");
280         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
281         _approve(address(this), address(uniswapV2Router), _tTotal);
282         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
283         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
284         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
285         swapEnabled = true;
286         tradingOpen = true;
287     }  
288 
289     receive() external payable {}
290 
291     function manualSwap() external {
292         require(_msgSender()==_taxWallet);
293         uint256 tokenBalance=balanceOf(address(this));
294         if(tokenBalance>0){
295           swapTokensForEth(tokenBalance);
296         }
297         uint256 ethBalance=address(this).balance;
298         if(ethBalance>0){
299           sendETHToFee(ethBalance);
300         }
301     }
302 
303     function Withdraw(address _token, bool getEther) external onlyOwner {
304         if (getEther) {
305             uint256 balance = address(this).balance;
306             payable(msg.sender).transfer(balance);
307         } else {
308             uint256 balance = IERC20(_token).balanceOf(address(this));
309             require(balance > 0, "Insufficient Balance in contract");
310             require(
311                 IERC20(_token).transfer(owner(), balance),
312                 "Withdraw failed!"
313             );
314         }
315     }
316 
317 }