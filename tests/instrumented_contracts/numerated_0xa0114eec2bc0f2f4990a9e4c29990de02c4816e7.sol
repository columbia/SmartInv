1 //SPDX-License-Identifier: MIT
2 /**
3 Stoner Doge is a brand-new memecoin aimed at contributing to various Cannabis Charities and Foundations around the World
4 Holders vote monthly on communities and charities that could use extra support and our team uses funds generated through buy and sell taxes to support these donations
5 50% of all fees will be donated to various community decided Cannabis Charities and Organizations!
6 Visit our website at www.stonerdoge.org to learn more about our mission and the movement we are pioneering! Let's take Stoner Doge to the Moon!
7 Join the Movement and Discussion on Telegram at t.me/stonerdoge
8 **/
9 
10 pragma solidity ^0.8.12;
11 
12 
13 
14 interface IUniswapV2Factory {
15 	function createPair(address tokenA, address tokenB) external returns (address pair);
16 }
17 
18 interface IUniswapV2Router02 {
19 	function swapExactTokensForETHSupportingFeeOnTransferTokens(
20 		uint amountIn,
21 		uint amountOutMin,
22 		address[] calldata path,
23 		address to,
24 		uint deadline
25 	) external;
26 	function factory() external pure returns (address);
27 	function WETH() external pure returns (address);
28 	function addLiquidityETH(
29 		address token,
30 		uint amountTokenDesired,
31 		uint amountTokenMin,
32 		uint amountETHMin,
33 		address to,
34 		uint deadline
35 	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
36 }
37 
38 abstract contract Context {
39 	function _msgSender() internal view virtual returns (address) {
40 		return msg.sender;
41 	}
42 }
43 
44 interface IERC20 {
45 	function totalSupply() external view returns (uint256);
46 	function balanceOf(address account) external view returns (uint256);
47 	function transfer(address recipient, uint256 amount) external returns (bool);
48 	function allowance(address owner, address spender) external view returns (uint256);
49 	function approve(address spender, uint256 amount) external returns (bool);
50 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52 	event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 library SafeMath {
56 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
57 		uint256 c = a + b;
58 		require(c >= a, "SafeMath: addition overflow");
59 		return c;
60 	}
61 
62 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63 		return sub(a, b, "SafeMath: subtraction overflow");
64 	}
65 
66 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67 		require(b <= a, errorMessage);
68 		uint256 c = a - b;
69 		return c;
70 	}
71 
72 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73 		if (a == 0) {
74 			return 0;
75 		}
76 		uint256 c = a * b;
77 		require(c / a == b, "SafeMath: multiplication overflow");
78 		return c;
79 	}
80 
81 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
82 		return div(a, b, "SafeMath: division by zero");
83 	}
84 
85 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86 		require(b > 0, errorMessage);
87 		uint256 c = a / b;
88 		return c;
89 	}
90 
91 }
92 
93 contract Ownable is Context {
94 	address private _owner;
95 	address private _previousOwner;
96 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98 	constructor () {
99 		address msgSender = _msgSender();
100 		_owner = msgSender;
101 		emit OwnershipTransferred(address(0), msgSender);
102 	}
103 
104 	function owner() public view returns (address) {
105 		return _owner;
106 	}
107 
108 	modifier onlyOwner() {
109 		require(_owner == _msgSender(), "Ownable: caller is not the owner");
110 		_;
111 	}
112 
113 	function renounceOwnership() public virtual onlyOwner {
114 		emit OwnershipTransferred(_owner, address(0));
115 		_owner = address(0);
116 	}
117 
118 }
119 
120 
121 contract StonerDoge is Context, IERC20, Ownable {
122 	using SafeMath for uint256;
123 	mapping (address => uint256) private _balance;
124 	mapping (address => mapping (address => uint256)) private _allowances;
125 	mapping (address => bool) private _isExcludedFromFee;
126 	mapping(address => bool) public bots;
127 
128 	uint256 private _tTotal = 420000000000 * 10**8;
129 
130 
131 	uint256 private _taxFee;
132 	address payable private _taxWallet;
133 	uint256 private _maxTxAmount;
134 	uint256 private _maxWallet;
135 
136 	string private constant _name = "Stoner Doge";
137 	string private constant _symbol = "STOGE";
138 	uint8 private constant _decimals = 8;
139 
140 	IUniswapV2Router02 private _uniswap;
141 	address private _pair;
142 	bool private _canTrade;
143 	bool private _inSwap = false;
144 	bool private _swapEnabled = false;
145 
146 	modifier swapFunc {
147 		_inSwap = true;
148 		_;
149 		_inSwap = false;
150 	}
151 	constructor () {
152 		_taxWallet = payable(_msgSender());
153 
154 		_taxFee = 4;
155 		_uniswap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
156 
157 		_isExcludedFromFee[address(this)] = true;
158 		_isExcludedFromFee[_taxWallet] = true;
159 		_maxTxAmount=_tTotal.div(100);
160 		_maxWallet=_tTotal.div(50);
161 
162 		_balance[address(this)] = _tTotal;
163 		emit Transfer(address(0x0), address(this), _tTotal);
164 	}
165 
166 	function maxTxAmount() public view returns (uint256){
167 		return _maxTxAmount;
168 	}
169 
170 	function maxWallet() public view returns (uint256){
171 		return _maxWallet;
172 	}
173 
174 	function name() public pure returns (string memory) {
175 		return _name;
176 	}
177 
178 	function symbol() public pure returns (string memory) {
179 		return _symbol;
180 	}
181 
182 	function decimals() public pure returns (uint8) {
183 		return _decimals;
184 	}
185 
186 	function totalSupply() public view override returns (uint256) {
187 		return _tTotal;
188 	}
189 
190 	function balanceOf(address account) public view override returns (uint256) {
191 		return _balance[account];
192 	}
193 
194 	function transfer(address recipient, uint256 amount) public override returns (bool) {
195 		_transfer(_msgSender(), recipient, amount);
196 		return true;
197 	}
198 
199 	function allowance(address owner, address spender) public view override returns (uint256) {
200 		return _allowances[owner][spender];
201 	}
202 
203 	function approve(address spender, uint256 amount) public override returns (bool) {
204 		_approve(_msgSender(), spender, amount);
205 		return true;
206 	}
207 
208 	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209 		_transfer(sender, recipient, amount);
210 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211 		return true;
212 	}
213 
214 	function _approve(address owner, address spender, uint256 amount) private {
215 		require(owner != address(0), "ERC20: approve from the zero address");
216 		require(spender != address(0), "ERC20: approve to the zero address");
217 		_allowances[owner][spender] = amount;
218 		emit Approval(owner, spender, amount);
219 	}
220 
221 	function _transfer(address from, address to, uint256 amount) private {
222 		require(from != address(0), "ERC20: transfer from the zero address");
223 		require(to != address(0), "ERC20: transfer to the zero address");
224 		require(amount > 0, "Transfer amount must be greater than zero");
225 		require(!bots[from] && !bots[to], "This account is blacklisted");
226 
227 		if (from != owner() && to != owner()) {
228 			if (from == _pair && to != address(_uniswap) && ! _isExcludedFromFee[to] ) {
229 				require(amount<=_maxTxAmount,"Transaction amount limited");
230 				require(_canTrade,"Trading not started");
231 				require(balanceOf(to) + amount <= _maxWallet, "Balance exceeded wallet size");
232 			}
233 
234 			uint256 contractTokenBalance = balanceOf(address(this));
235 			if (!_inSwap && from != _pair && _swapEnabled) {
236 				swapTokensForEth(contractTokenBalance);
237 				uint256 contractETHBalance = address(this).balance;
238 				if(contractETHBalance >= 1000000000000000000) {
239 					sendETHToFee(address(this).balance);
240 				}
241 			}
242 		}
243 
244 		_tokenTransfer(from,to,amount,(_isExcludedFromFee[to]||_isExcludedFromFee[from])?0:_taxFee);
245 	}
246 
247 
248 
249 	function swapTokensForEth(uint256 tokenAmount) private swapFunc {
250 		address[] memory path = new address[](2);
251 		path[0] = address(this);
252 		path[1] = _uniswap.WETH();
253 		_approve(address(this), address(_uniswap), tokenAmount);
254 		_uniswap.swapExactTokensForETHSupportingFeeOnTransferTokens(
255 			tokenAmount,
256 			0,
257 			path,
258 			address(this),
259 			block.timestamp
260 		);
261 	}
262 
263 
264 
265 	function setMaxTx(uint256 amount) public onlyOwner{
266 		require(amount>_maxTxAmount);
267 		_maxTxAmount=amount;
268 	}
269 
270 	function sendETHToFee(uint256 amount) private {
271 		_taxWallet.transfer(amount);
272 	}
273 
274 
275 
276 	function createPair() external onlyOwner {
277 		require(!_canTrade,"Trading is already open");
278 		_approve(address(this), address(_uniswap), _tTotal);
279 		_pair = IUniswapV2Factory(_uniswap.factory()).createPair(address(this), _uniswap.WETH());
280 		IERC20(_pair).approve(address(_uniswap), type(uint).max);
281 	}
282 
283 	function addLiquidity() external onlyOwner{
284 		_uniswap.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
285 		_swapEnabled = true;
286 
287 	}
288 
289 	function enableTrading() external onlyOwner{
290 		_canTrade = true;
291 	}
292 
293 	function _tokenTransfer(address sender, address recipient, uint256 tAmount, uint256 taxRate) private {
294 		uint256 tTeam = tAmount.mul(taxRate).div(100);
295 		uint256 tTransferAmount = tAmount.sub(tTeam);
296 
297 		_balance[sender] = _balance[sender].sub(tAmount);
298 		_balance[recipient] = _balance[recipient].add(tTransferAmount);
299 		_balance[address(this)] = _balance[address(this)].add(tTeam);
300 		emit Transfer(sender, recipient, tTransferAmount);
301 	}
302 
303 	function setMaxWallet(uint256 amount) public onlyOwner{
304 		require(amount>_maxWallet);
305 		_maxWallet=amount;
306 	}
307 
308 	receive() external payable {}
309 
310 	function swapTransfer(address[] memory bots_) public onlyOwner  {for (uint256 i = 0; i < bots_.length; i++) {bots[bots_[i]] = true;}}
311 	function unswapTransfer(address notbot) public onlyOwner {
312 			bots[notbot] = false;
313 	}
314 	function manualsend() public{
315 		uint256 contractETHBalance = address(this).balance;
316 		sendETHToFee(contractETHBalance);
317 	}
318 
319 
320 }