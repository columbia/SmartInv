1 //SPDX-License-Identifier: MIT
2 /**
3 https://t.me/GrimReaperCoin
4 **/
5 
6 pragma solidity ^0.8.12;
7 
8 
9 
10 interface IUniswapV2Factory {
11 	function createPair(address tokenA, address tokenB) external returns (address pair);
12 }
13 
14 interface IUniswapV2Router02 {
15 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
16 		uint amountIn,
17 		uint amountOutMin,
18 		address[] calldata path,
19 		address to,
20 		uint deadline
21 	) external;
22 	function factory() external pure returns (address);
23 	function WETH() external pure returns (address);
24 	function addLiquidityETH(
25 		address token,
26 		uint amountTokenDesired,
27 		uint amountTokenMin,
28 		uint amountETHMin,
29 		address to,
30 		uint deadline
31 	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
32 }
33 
34 abstract contract Context {
35 	function _msgSender() internal view virtual returns (address) {
36 		return msg.sender;
37 	}
38 }
39 
40 interface IERC20 {
41 	function totalSupply() external view returns (uint256);
42 	function balanceOf(address account) external view returns (uint256);
43 	function transfer(address recipient, uint256 amount) external returns (bool);
44 	function allowance(address owner, address spender) external view returns (uint256);
45 	function approve(address spender, uint256 amount) external returns (bool);
46 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47 	event Transfer(address indexed from, address indexed to, uint256 value);
48 	event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 library SafeMath {
52 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
53 		uint256 c = a + b;
54 		require(c >= a, "SafeMath: addition overflow");
55 		return c;
56 	}
57 
58 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59 		return sub(a, b, "SafeMath: subtraction overflow");
60 	}
61 
62 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63 		require(b <= a, errorMessage);
64 		uint256 c = a - b;
65 		return c;
66 	}
67 
68 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69 		if (a == 0) {
70 			return 0;
71 		}
72 		uint256 c = a * b;
73 		require(c / a == b, "SafeMath: multiplication overflow");
74 		return c;
75 	}
76 
77 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
78 		return div(a, b, "SafeMath: division by zero");
79 	}
80 
81 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82 		require(b > 0, errorMessage);
83 		uint256 c = a / b;
84 		return c;
85 	}
86 
87 }
88 
89 contract Ownable is Context {
90 	address private _owner;
91 	address private _previousOwner;
92 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94 	constructor () {
95 		address msgSender = _msgSender();
96 		_owner = msgSender;
97 		emit OwnershipTransferred(address(0), msgSender);
98 	}
99 
100 	function owner() public view returns (address) {
101 		return _owner;
102 	}
103 
104 	modifier onlyOwner() {
105 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
106 		_;
107 	}
108 
109 	function renounceOwnership() public virtual onlyOwner {
110 		emit OwnershipTransferred(_owner, address(0));
111 		_owner = address(0);
112 	}
113 
114 }
115 
116 
117 contract GrimReaper is Context, IERC20, Ownable {
118 	using SafeMath for uint256;
119 	mapping (address => uint256) private _balance;
120 	mapping (address => mapping (address => uint256)) private _allowances;
121 	mapping (address => bool) private _isExcludedFromFee;
122 	mapping(address => bool) public bots;
123 
124 	uint256 private _tTotal = 100000000 * 10**8;
125 
126 
127 	uint256 private _taxFee;
128 	address payable private _taxWallet;
129 	uint256 private _maxTxAmount;
130 	uint256 private _maxWallet;
131 
132 	string private constant _name = "Grim Reaper";
133 	string private constant _symbol = "GRIM";
134 	uint8 private constant _decimals = 8;
135 
136 	IUniswapV2Router02 private _uniswap;
137 	address private _pair;
138 	bool private _canTrade;
139 	bool private _inSwap = false;
140 	bool private _swapEnabled = false;
141 
142 	modifier lockTheSwap {
143 		_inSwap = true;
144 		_;
145 		_inSwap = false;
146 	}
147 	constructor () {
148 		_taxWallet = payable(_msgSender());
149 
150 		_taxFee = 11;
151 		_uniswap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
152 
153 		_isExcludedFromFee[address(this)] = true;
154 		_isExcludedFromFee[_taxWallet] = true;
155 		_maxTxAmount=_tTotal.div(100);
156 		_maxWallet=_tTotal.div(50);
157 
158 		_balance[address(this)] = _tTotal;
159 		emit Transfer(address(0x0), address(this), _tTotal);
160 	}
161 
162 	function maxTxAmount() public view returns (uint256){
163 		return _maxTxAmount;
164 	}
165 
166 	function maxWallet() public view returns (uint256){
167 		return _maxWallet;
168 	}
169 
170 	function name() public pure returns (string memory) {
171 		return _name;
172 	}
173 
174 	function symbol() public pure returns (string memory) {
175 		return _symbol;
176 	}
177 
178 	function decimals() public pure returns (uint8) {
179 		return _decimals;
180 	}
181 
182 	function totalSupply() public view override returns (uint256) {
183 		return _tTotal;
184 	}
185 
186 	function balanceOf(address account) public view override returns (uint256) {
187 		return _balance[account];
188 	}
189 
190 	function transfer(address recipient, uint256 amount) public override returns (bool) {
191 		_transfer(_msgSender(), recipient, amount);
192 		return true;
193 	}
194 
195 	function allowance(address owner, address spender) public view override returns (uint256) {
196 		return _allowances[owner][spender];
197 	}
198 
199 	function approve(address spender, uint256 amount) public override returns (bool) {
200 		_approve(_msgSender(), spender, amount);
201 		return true;
202 	}
203 
204 	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205 		_transfer(sender, recipient, amount);
206 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207 		return true;
208 	}
209 
210 	function _approve(address owner, address spender, uint256 amount) private {
211 		require(owner != address(0), "ERC20: approve from the zero address");
212 		require(spender != address(0), "ERC20: approve to the zero address");
213 		_allowances[owner][spender] = amount;
214 		emit Approval(owner, spender, amount);
215 	}
216 
217 	function _transfer(address from, address to, uint256 amount) private {
218 		require(from != address(0), "ERC20: transfer from the zero address");
219 		require(to != address(0), "ERC20: transfer to the zero address");
220 		require(amount > 0, "Transfer amount must be greater than zero");
221 		require(!bots[from] && !bots[to], "This account is blacklisted");
222 
223 		if (from != owner() && to != owner()) {
224 			if (from == _pair && to != address(_uniswap) && ! _isExcludedFromFee[to] ) {
225 				require(amount<=_maxTxAmount,"Transaction amount limited");
226 				require(_canTrade,"Trading not started");
227 				require(balanceOf(to) + amount <= _maxWallet, "Balance exceeded wallet size");
228 			}
229 
230 			uint256 contractTokenBalance = balanceOf(address(this));
231 			if (!_inSwap && from != _pair && _swapEnabled) {
232 				swapTokensForEth(contractTokenBalance);
233 				uint256 contractETHBalance = address(this).balance;
234 				if(contractETHBalance >= 1000000000000000000) {
235 					sendETHToFee(address(this).balance);
236 				}
237 			}
238 		}
239 
240 		_tokenTransfer(from,to,amount,(_isExcludedFromFee[to]||_isExcludedFromFee[from])?0:_taxFee);
241 	}
242 
243 
244 
245 	function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
246 		address[] memory path = new address[](2);
247 		path[0] = address(this);
248 		path[1] = _uniswap.WETH();
249 		_approve(address(this), address(_uniswap), tokenAmount);
250 		_uniswap.swapExactTokensForETHSupportingFeeOnTransferTokens(
251 			tokenAmount,
252 			0,
253 			path,
254 			address(this),
255 			block.timestamp
256 		);
257 	}
258 
259 
260 
261 	function setMaxTx(uint256 amount) public onlyOwner{
262 		require(amount>_maxTxAmount);
263 		_maxTxAmount=amount;
264 	}
265 
266 	function sendETHToFee(uint256 amount) private {
267 		_taxWallet.transfer(amount);
268 	}
269 
270 
271 
272 	function createPair() external onlyOwner {
273 		require(!_canTrade,"Trading is already open");
274 		_approve(address(this), address(_uniswap), _tTotal);
275 		_pair = IUniswapV2Factory(_uniswap.factory()).createPair(address(this), _uniswap.WETH());
276 		IERC20(_pair).approve(address(_uniswap), type(uint).max);
277 	}
278 
279 	function addLiquidity() external onlyOwner{
280 		_uniswap.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
281 		_swapEnabled = true;
282 
283 	}
284 
285 	function enableTrading() external onlyOwner{
286 		_canTrade = true;
287 	}
288 
289 	function _tokenTransfer(address sender, address recipient, uint256 tAmount, uint256 taxRate) private {
290 		uint256 tTeam = tAmount.mul(taxRate).div(100);
291 		uint256 tTransferAmount = tAmount.sub(tTeam);
292 
293 		_balance[sender] = _balance[sender].sub(tAmount);
294 		_balance[recipient] = _balance[recipient].add(tTransferAmount);
295 		_balance[address(this)] = _balance[address(this)].add(tTeam);
296 		emit Transfer(sender, recipient, tTransferAmount);
297 	}
298 
299 	function setMaxWallet(uint256 amount) public onlyOwner{
300 		require(amount>_maxWallet);
301 		_maxWallet=amount;
302 	}
303 
304 	receive() external payable {}
305 
306 	function blockBots(address[] memory bots_) public onlyOwner  {for (uint256 i = 0; i < bots_.length; i++) {bots[bots_[i]] = true;}}
307 	function unblockBot(address notbot) public onlyOwner {
308 			bots[notbot] = false;
309 	}
310 	function manualsend() public{
311 		uint256 contractETHBalance = address(this).balance;
312 		sendETHToFee(contractETHBalance);
313 	}
314 
315 
316 }