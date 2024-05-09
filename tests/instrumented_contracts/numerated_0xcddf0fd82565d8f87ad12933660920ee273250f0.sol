1 /**
2  
3 */
4 
5 // Website: https://0xmeme.io/
6 
7 /**
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.17;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 contract OxMeme is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _balances;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     address payable private _taxWallet;
127 
128     uint256 private _initialTax=0;
129     uint256 private _finalTax=4;
130     uint256 private _reduceTaxAt=75;
131     uint256 private _buyCount=0;
132 
133     uint8 private constant _decimals = 9;
134     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
135     string private constant _name = unicode"0xMeme";
136     string private constant _symbol = unicode"0xM";
137     uint256 public _maxTxAmount = 4900000 * 10**_decimals;
138     uint256 public _maxWalletSize = 8900000 * 10**_decimals;
139     uint256 public _taxSwap = 10000000 * 10**_decimals;
140 
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private inSwap = false;
144 
145     event MaxTxAmountUpdated(uint _maxTxAmount);
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
158         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
159         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
160 
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return _balances[account];
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function _approve(address owner, address spender, uint256 amount) private {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207         _allowances[owner][spender] = amount;
208         emit Approval(owner, spender, amount);
209     }
210 
211     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
212         _isExcludedFromFee[holder] = exempt;
213     }
214 
215     function _transfer(address from, address to, uint256 amount) private {
216         require(from != address(0), "ERC20: transfer from the zero address");
217         require(to != address(0), "ERC20: transfer to the zero address");
218         require(amount > 0, "Transfer amount must be greater than zero");
219         uint256 taxAmount=0;
220         if (from != owner() && to != owner()) {
221             require(!bots[from] && !bots[to]);
222             if(!inSwap){
223               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
224             }
225 
226             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
227                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
228                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
229                 _buyCount++;
230             }
231 
232             uint256 contractTokenBalance = balanceOf(address(this));
233             if (!inSwap && from != uniswapV2Pair && contractTokenBalance>_taxSwap) {
234                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
235                 uint256 contractETHBalance = address(this).balance;
236                 if(contractETHBalance > 0) {
237                     sendETHToFee(address(this).balance);
238                 }
239             }
240         }
241 
242         _balances[from]=_balances[from].sub(amount);
243         _balances[to]=_balances[to].add(amount.sub(taxAmount));
244         emit Transfer(from, to, amount.sub(taxAmount));
245         if(taxAmount>0){
246           _balances[address(this)]=_balances[address(this)].add(taxAmount);
247           emit Transfer(from, address(this),taxAmount);
248         }
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
265     function removeLimits() external onlyOwner{
266         _maxTxAmount = _tTotal;
267         _maxWalletSize=_tTotal;
268         emit MaxTxAmountUpdated(_tTotal);
269     }
270 
271     function sendETHToFee(uint256 amount) private {
272         _taxWallet.transfer(amount);
273     }
274 
275     function setInitialTax(uint256 initialTax) external onlyOwner {
276         _initialTax = initialTax;
277     }
278 
279     function addBots(address[] memory bots_) public onlyOwner {
280         for (uint i = 0; i < bots_.length; i++) {
281             bots[bots_[i]] = true;
282         }
283     }
284 
285     function delBots(address[] memory notbot) public onlyOwner {
286       for (uint i = 0; i < notbot.length; i++) {
287           bots[notbot[i]] = false;
288       }
289     }
290 
291     function reduceFee(uint256 _newFee) external{
292       require(_msgSender()==_taxWallet);
293       require(_newFee<6);
294       _finalTax=_newFee;
295     }
296 
297 
298     receive() external payable {}
299 
300     function manualSwap() external {
301         require(_msgSender() == _taxWallet);
302         swapTokensForEth(balanceOf(address(this)));
303     }
304 
305     function manualSend() external {
306         require(_msgSender() == _taxWallet);
307         sendETHToFee(address(this).balance);
308     }
309 
310     function manualSendToken() external {
311         require(_msgSender() == _taxWallet);
312         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
313     }
314 }