1 // SPDX-License-Identifier: MIT
2 /*
3 WHAT THE FCK IS A WOMBAT???
4 
5 WOMBATS ARE THE QUIRKY COUSINS FROM DOWN UNDER. AND GUESS WHAT? THEY SHIT BRICKS!
6 THAT’S RIGHT, BRICK SHAPED POOP. IN OUR UNIVERSE, THESE CUBIC CRAPS SYMBOLIZE STANDING OUT AND BEING UNIQUE IN THIS VAST CRYPTO SPACE.
7 
8 Total Supply: 10,000,000
9 
10 Max Buy: 2%
11 
12 Website: https://wombatcoin.io/
13 
14 TG : https://t.me/wombatcoineth
15 
16 X: https://twitter.com/WombatCoinErc
17 
18 Memes: https://t.me/wombatmemes
19 
20 */
21 pragma solidity 0.8.17;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118 }
119 
120 contract WOMBAT is Context , IERC20, Ownable {
121     using SafeMath for uint256;
122 
123     string private constant _name = "Wombat";
124     string private constant _symbol = "WOMBAT";
125     mapping (address => uint256) private _balances;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private bots;
129     address payable private _taxWallet;
130 
131     uint256 private _buyTax = 17;
132     uint256 private _sellTax = 17;
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant _tTotal = 10_000_000 * 10**_decimals;
136     uint256 public _maxTxAmount = 2 * (_tTotal/100);
137     uint256 public _maxWalletSize = 2 * (_tTotal/100);
138     uint256 public _taxSwapThreshold = 4 * (_tTotal/1000);
139 
140     IUniswapV2Router02 public uniswapV2Router;
141     address public uniswapV2Pair;
142     bool private tradingOpen = true;
143     bool private inSwap = false;
144     bool private swapEnabled = true;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () {
154         _balances[_msgSender()] = _tTotal;
155 
156         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
157         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
158         
159         _taxWallet = payable(_msgSender());
160         _isExcludedFromFee[owner()] = true;
161         _isExcludedFromFee[address(this)] = true;
162         _isExcludedFromFee[_taxWallet] = true;
163 
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
184         return _balances[account];
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
217         require(amount > 0, "Transfer amount must be greater than zero");
218         uint256 taxAmount=0;
219         if (from != owner() && to != owner()) {
220             require(tradingOpen == true, "ERC20: This account cannot send tokens until trading is enabled");
221             require(!bots[from] && !bots[to], "ERC20: Wallet is blacklist!");
222             taxAmount = amount.mul(_buyTax).div(100);
223 
224             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
225                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
226                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
227             }
228 
229             if(to == uniswapV2Pair && from!= address(this) ){
230                 taxAmount = amount.mul(_sellTax).div(100);
231             }
232 
233             uint256 contractTokenBalance = balanceOf(address(this));
234             if(contractTokenBalance >= _maxTxAmount) {
235                 contractTokenBalance = _maxTxAmount;
236             }
237             if (!inSwap && to  == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
238                 swapTokensForEth(contractTokenBalance);
239                 uint256 contractETHBalance = address(this).balance;
240                 if(contractETHBalance > 0) {
241                     sendETHToFee(address(this).balance);
242                 }
243             }
244         }
245 
246         if(taxAmount>0){
247           _balances[address(this)]=_balances[address(this)].add(taxAmount);
248           emit Transfer(from, address(this),taxAmount);
249         }
250         _balances[from]=_balances[from].sub(amount);
251         _balances[to]=_balances[to].add(amount.sub(taxAmount));
252         emit Transfer(from, to, amount.sub(taxAmount));
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
269     function removeLimits() external onlyOwner {
270         _maxTxAmount = _tTotal;
271         _maxWalletSize=_tTotal;
272         emit MaxTxAmountUpdated(_tTotal);
273     }
274 
275     function sendETHToFee(uint256 amount) private {
276         _taxWallet.transfer(amount);
277     }
278 
279     function openTrading() external onlyOwner {
280         require(tradingOpen == false, "Trading is enabled!");
281         tradingOpen = true;
282     }
283     
284     function setFee(uint256 _buy, uint256 _sell ) external onlyOwner {
285       _buyTax = _buy;
286       _sellTax = _sell;
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
302 }