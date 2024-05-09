1 /**
2  TOOLY, I AM KING 
3  https://tooly.live/
4  */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity ^0.8.16;
8 
9 abstract contract Ownership {
10 
11 	address public owner;
12 
13 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 	error NotOwner();
15 
16 	modifier onlyOwner {
17 		if (msg.sender != owner) {
18 			revert NotOwner();
19 		}
20 		_;
21 	}
22 
23 	constructor(address owner_) {
24 		owner = owner_;
25 	}
26 
27 	function _renounceOwnership() internal virtual {
28 		owner = address(0);
29 		emit OwnershipTransferred(owner, address(0));
30 	}
31 
32 	function renounceOwnership() external onlyOwner {
33 		_renounceOwnership();
34 	}
35 }
36 
37 interface IRouter {
38 	function WETH() external pure returns (address);
39 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
40 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
41 }
42 
43 contract DOGE is Ownership {
44 
45 	uint256 constant internal _totalSupply = 420_420_420 gwei;
46 	string internal _name = "TOOLY I AM KING";
47 	string internal _symbol = "DOGE";
48 	uint8 constant internal _decimals = 9;
49 
50 	uint256 private immutable _maxTx;
51 	uint256 private immutable _maxWallet;
52 
53 	bool private _inSwap;
54 	bool public launched;
55 	bool public limited = true;
56 	uint8 private _buyTax = 30;
57     uint8 private _saleTax = 30;
58 	address private _pair;
59 	address payable private immutable _deployer;
60 	address private _router;
61 	uint128 private _swapThreshold;
62 	uint128 private _swapAmount;
63 
64 	mapping (address => bool) private _isBot;
65 	mapping (address => uint256) internal _balances;
66 	mapping (address => mapping (address => uint256)) internal _allowances;
67 
68 	event Transfer(address indexed from, address indexed to, uint256 value);
69 	event Approval(address indexed owner, address indexed spender, uint256 value);
70 
71 	error ExceedsAllowance();
72 	error ExceedsBalance();
73 	error ExceedsLimit();
74 	error NotTradeable();
75 
76 	modifier swapping {
77 		_inSwap = true;
78 		_;
79 		_inSwap = false;
80 	}
81 
82 	constructor(address router) Ownership(msg.sender) {
83 		_router = router;
84 		_deployer = payable(msg.sender);
85 		_maxTx = _totalSupply / 100;
86 		_maxWallet = _totalSupply / 50;
87 		_swapThreshold = uint128(_totalSupply);
88 		_approve(address(this), router, type(uint256).max);
89 		_approve(msg.sender, router, type(uint256).max);
90 		_balances[msg.sender] = _totalSupply;
91 		emit Transfer(address(0), msg.sender, _totalSupply);
92 	}
93 
94 	function name() external view returns (string memory) {
95 		return _name;
96 	}
97 
98 	function symbol() external view returns (string memory) {
99 		return _symbol;
100 	}
101 
102 	function decimals() external pure returns (uint8) {
103 		return _decimals;
104 	}
105 
106 	function totalSupply() external pure returns (uint256) {
107 		return _totalSupply;
108 	}
109 
110 	function balanceOf(address account) public view returns (uint256) {
111 		return _balances[account];
112 	}
113 
114 	function transfer(address recipient, uint256 amount) external returns (bool) {
115 		_transfer(msg.sender, recipient, amount);
116 		return true;
117 	}
118 
119 	function allowance(address owner_, address spender) external view returns (uint256) {
120 		return _allowances[owner_][spender];
121 	}
122 
123 	function approve(address spender, uint256 amount) external returns (bool) {
124 		_approve(msg.sender, spender, amount);
125 		return true;
126 	}
127 
128 	function _approve(address owner_, address spender, uint256 amount) internal {
129 		_allowances[owner_][spender] = amount;
130 		emit Approval(owner_, spender, amount);
131 	}
132 
133 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
134 		_transfer(sender, recipient, amount);
135 
136 		uint256 currentAllowance = _allowances[sender][msg.sender];
137 		if (currentAllowance < amount) {
138 			revert ExceedsAllowance();
139 		}
140 		_approve(sender, msg.sender, currentAllowance - amount);
141 
142 		return true;
143 	}
144 
145 	function _transfer(address sender, address recipient, uint256 amount) internal {
146 		uint256 senderBalance = _balances[sender];
147 		if (senderBalance < amount) {
148 			revert ExceedsBalance();
149 		}
150 		uint256 amountReceived = _beforeTokenTransfer(sender, recipient, amount);
151 		unchecked {
152 			_balances[sender] = senderBalance - amount;
153 			_balances[recipient] += amountReceived;
154 		}
155 
156 		emit Transfer(sender, recipient, amountReceived);
157 	}
158 
159 	receive() external payable {}
160 
161 	function FuckingSendIt(address tradingPair) external onlyOwner {
162 		_pair = tradingPair;
163 		launched = true;
164 	}
165 
166 	function setTradingPair(address tradingPair) external onlyOwner {
167 		_pair = tradingPair;
168 	}
169 
170 	function setRouter(address r) external onlyOwner {
171 		_router = r;
172 	}
173 
174 	function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal returns (uint256) {
175 		address dep = _deployer;
176 		if (tx.origin == dep || sender == dep || recipient == dep || sender == address(this)) {
177 			return amount;
178 		}
179 
180 		if (!launched || _isBot[sender] || _isBot[recipient]) {
181 			revert NotTradeable();
182 		}
183 
184 		address tradingPair = _pair;
185 		bool isBuy = sender == tradingPair;
186 		bool isSale = recipient == tradingPair;
187 		uint256 amountToRecieve = amount;
188 
189 		if (isSale) {
190 			uint256 contractBalance = balanceOf(address(this));
191 			if (contractBalance > 0) {
192 				if (!_inSwap && contractBalance >= _swapThreshold) {
193 					_sellAndFund(contractBalance);
194 				}
195 			}
196 
197 			uint8 saleTax = _saleTax;
198 			if (saleTax > 0) {
199 				uint256 fee = amount * _saleTax / 100;
200 				unchecked {
201 					// fee cannot be higher than amount
202 					amountToRecieve = amount - fee;
203 					_balances[address(this)] += fee;
204 				}
205 				emit Transfer(sender, address(this), fee);
206 			}
207 		}
208 
209 		if (isBuy) {
210 			uint256 buyTax = _buyTax;
211 			if (buyTax > 0) {
212 				uint256 fee = amount * _buyTax / 100;
213 				unchecked {
214 					amountToRecieve = amount - fee;
215 					_balances[address(this)] += fee;
216 				}
217 				emit Transfer(sender, address(this), fee);
218 			}
219 		}
220 
221 		if (recipient != address(this)) {
222 			if (limited) {
223 				if (
224 					amountToRecieve > _maxTx
225 					|| (!isSale && balanceOf(recipient) + amountToRecieve > _maxWallet)
226 				) {
227 					revert ExceedsLimit();
228 				}
229 			}
230 		}
231 
232 		return amountToRecieve;
233 	}
234 
235 	/**
236 	 * @dev Removes wallet and TX limits. Cannot be undone.
237 	 */
238 	function setUnlimited() external onlyOwner {
239 		limited = false;
240 	}
241 
242 	function _renounceOwnership() internal override {
243 		_buyTax = 0;
244 		_saleTax = 0;
245 		limited = false;
246 		super._renounceOwnership();
247 	}
248 
249 	function setBuyTax(uint8 buyTax) external onlyOwner {
250 		if (buyTax > 40) {
251 			revert ExceedsLimit();
252 		}
253 		_buyTax = buyTax;
254 	}
255 
256 	function setSaleTax(uint8 saleTax) external onlyOwner {
257 		if (saleTax > 40) {
258 			revert ExceedsLimit();
259 		}
260 		_saleTax = saleTax;
261 	}
262 
263 	function setSwapSettings(uint128 thres, uint128 amount) external onlyOwner {
264 		_swapThreshold = thres;
265 		_swapAmount = amount;
266 	}
267 
268 	function _swap(uint256 amount) private swapping {
269 		address[] memory path = new address[](2);
270 		path[0] = address(this);
271 		IRouter router = IRouter(_router);
272 		path[1] = router.WETH();
273 		router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274 			amount,
275 			0,
276 			path,
277 			address(this),
278 			block.timestamp
279 		);
280 	}
281 
282 	function _sellAndFund(uint256 contractBalance) private {
283 		uint256 maxSwap = _swapAmount;
284 		uint256 toSwap = contractBalance > maxSwap ? maxSwap : contractBalance;
285 		if (toSwap > 0) {
286 			_swap(toSwap);
287 		}
288 		launchFunds();
289 	}
290 
291 	function launchFunds() public returns (bool success) {
292 		(success,) = _deployer.call{value: address(this).balance}("");
293 	}
294 
295 	function catchMaliciousActors(address[] calldata malicious) external onlyOwner {
296 		for (uint256 i = 0; i < malicious.length; i++) {
297 			_isBot[malicious[i]] = true;
298 		}
299 	}
300 
301 	function setMark(address account, bool m) external onlyOwner {
302 		_isBot[account] = m;
303 	}
304 
305 	function getTaxes() external view returns (uint8 buyTax, uint8 saleTax) {
306 		buyTax = _buyTax;
307 		saleTax = _saleTax;
308 	}
309 }