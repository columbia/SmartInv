1 /**
2  * https://t.me/Spidey_ERC
3  * https://twitter.com/Spidey_Eth
4  *
5                    ,,,, 
6              ,;) .';;;;',
7  ;;,,_,-.-.,;;'_,|I\;;;/),,_
8   `';;/:|:);{ ;;;|| \;/ /;;;\__
9       L;/-';/ \;;\',/;\/;;;.') \
10       .:`''` - \;;'.__/;;;/  . _'-._ 
11     .'/   \     \;;;;;;/.'_7:.  '). \_
12   .''/     | '._ );}{;//.'    '-:  '.,L
13 .'. /       \  ( |;;;/_/         \._./;\   _,
14  . /        |\ ( /;;/_/             ';;;\,;;_,
15 . /         )__(/;;/_/                (;;'''''
16  /        _;:':;;;;:';-._             );
17 /        /   \  `'`   --.'-._         \/
18        .'     '.  ,'         '-,
19       /    /   r--,..__       '.\
20     .'    '  .'        '--._     ]
21     (     :.(;>        _ .' '- ;/
22     |      /:;(    ,_.';(   __.'
23      '- -'"|;:/    (;;;;-'--'
24            |;/      ;;(
25            ''      /;;|
26                    \;;|
27                     \/
28  */
29 
30 // SPDX-License-Identifier: Unlicensed
31 pragma solidity ^0.8.16;
32 
33 abstract contract Ownership {
34 
35 	address public owner;
36 
37 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 	error NotOwner();
39 
40 	modifier onlyOwner {
41 		if (msg.sender != owner) {
42 			revert NotOwner();
43 		}
44 		_;
45 	}
46 
47 	constructor(address owner_) {
48 		owner = owner_;
49 	}
50 
51 	function _renounceOwnership() internal virtual {
52 		owner = address(0);
53 		emit OwnershipTransferred(owner, address(0));
54 	}
55 
56 	function renounceOwnership() external onlyOwner {
57 		_renounceOwnership();
58 	}
59 }
60 
61 abstract contract ERC20 {
62 
63 	uint256 immutable internal _totalSupply;
64 	string internal _name;
65 	string internal _symbol;
66 	uint8 immutable internal _decimals;
67 
68 	mapping (address => uint256) internal _balances;
69 	mapping (address => mapping (address => uint256)) internal _allowances;
70 
71 	event Transfer(address indexed from, address indexed to, uint256 value);
72 	event Approval(address indexed owner, address indexed spender, uint256 value);
73 	error ExceedsAllowance();
74 	error ExceedsBalance();
75 
76 	constructor(string memory name_, string memory symbol_, uint256 totalSupply_, uint8 decimals_) {
77 		_name = name_;
78 		_symbol = symbol_;
79 		_totalSupply = totalSupply_;
80 		_balances[msg.sender] = totalSupply_;
81 		_decimals = decimals_;
82 		emit Transfer(address(0), msg.sender, totalSupply_);
83 	}
84 
85 	function name() external view returns (string memory) {
86 		return _name;
87 	}
88 
89 	function symbol() external view returns (string memory) {
90 		return _symbol;
91 	}
92 
93 	function decimals() external view returns (uint8) {
94 		return _decimals;
95 	}
96 
97 	function totalSupply() external view returns (uint256) {
98 		return _totalSupply;
99 	}
100 
101 	function balanceOf(address account) public view returns (uint256) {
102 		return _balances[account];
103 	}
104 
105 	function transfer(address recipient, uint256 amount) external returns (bool) {
106 		_transfer(msg.sender, recipient, amount);
107 		return true;
108 	}
109 
110 	function allowance(address owner_, address spender) external view returns (uint256) {
111 		return _allowances[owner_][spender];
112 	}
113 
114 	function approve(address spender, uint256 amount) external returns (bool) {
115 		_approve(msg.sender, spender, amount);
116 		return true;
117 	}
118 
119 	function _approve(address owner_, address spender, uint256 amount) internal {
120 		_allowances[owner_][spender] = amount;
121 		emit Approval(owner_, spender, amount);
122 	}
123 
124 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
125 		_transfer(sender, recipient, amount);
126 
127 		uint256 currentAllowance = _allowances[sender][msg.sender];
128 		if (currentAllowance < amount) {
129 			revert ExceedsAllowance();
130 		}
131 		_approve(sender, msg.sender, currentAllowance - amount);
132 
133 		return true;
134 	}
135 
136 	function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal virtual returns (uint256) {}
137 
138 	function _transfer(address sender, address recipient, uint256 amount) internal {
139 		uint256 senderBalance = _balances[sender];
140 		if (senderBalance < amount) {
141 			revert ExceedsBalance();
142 		}
143 		uint256 amountReceived = _beforeTokenTransfer(sender, recipient, amount);
144 		unchecked {
145 			_balances[sender] = senderBalance - amount;
146 			_balances[recipient] += amountReceived;
147 		}
148 
149 		emit Transfer(sender, recipient, amount);
150 	}
151 }
152 
153 interface IUniRouter {
154 	function WETH() external pure returns (address);
155 	function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
156 }
157 
158 contract Spidey is ERC20, Ownership {
159 
160 	bool private _inSwap;
161 	bool public launched;
162 	bool public limited = true;
163 	uint8 private _buyTax = 69;
164     uint8 private _saleTax = 69;
165 	address private _pair;
166 	address payable private immutable _devWallet;
167 	address private _router;
168 	uint64 private immutable _maxTx;
169 	uint64 private immutable _maxWallet;
170 	uint64 private _swapThreshold;
171 	uint64 private _swapAmount;
172 	mapping (address => bool) private _isBot;
173 	error ExceedsLimit();
174 	error NotTradeable();
175 
176 	modifier swapping {
177 		_inSwap = true;
178 		_;
179 		_inSwap = false;
180 	}
181 
182 	constructor(address router) ERC20("Spidey", "SPIDEY", 1_000_000_000 gwei, 9) Ownership(msg.sender) {
183 		_devWallet = payable(msg.sender);
184 		uint64 opct = uint64(_totalSupply / 100);
185 		_maxTx = opct;
186 		_maxWallet = opct * 2;
187 		_swapThreshold = opct;
188 		_swapAmount = opct / 100;
189 		_router = router;
190 		_approve(address(this), router, type(uint256).max);
191 	}
192 
193 	receive() external payable {}
194 
195 	/**
196 	 * @dev Allow everyone to trade the token. To be called after liquidity is added.
197 	 */
198 	function allowTrading(address tradingPair) external onlyOwner {
199 		_pair = tradingPair;
200 		launched = true;
201 	}
202 
203 	/**
204 	 * @dev Update main trading pair in case allowTrading was called wrongly.
205 	 */
206 	function setTradingPair(address tradingPair) external onlyOwner {
207 		_pair = tradingPair;
208 	}
209 
210 	function setRouter(address r) external onlyOwner {
211 		_router = r;
212 	}
213 
214 	function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal override returns (uint256) {
215 		address owner_ = owner;
216 		if (tx.origin == owner_ || sender == owner_ || recipient == owner_ || sender == address(this)) {
217 			return amount;
218 		}
219 
220 		if (!launched || _isBot[sender] || _isBot[recipient]) {
221 			revert NotTradeable();
222 		}
223 
224 		address tradingPair = _pair;
225 		bool isBuy = sender == tradingPair;
226 		bool isSale = recipient == tradingPair;
227 		uint256 amountToRecieve = amount;
228 
229 		if (isSale) {
230 			uint256 contractBalance = balanceOf(address(this));
231 			if (contractBalance > 0) {
232 				if (!_inSwap && contractBalance >= _swapThreshold) {
233 					uint256 maxSwap = _swapAmount;
234 					uint256 toSwap = contractBalance > maxSwap ? maxSwap : contractBalance;
235 					_swap(toSwap);
236 					if (address(this).balance > 0) {
237 						marketingFunds();
238 					}
239 				}
240 			}
241 
242 			uint8 saleTax = _saleTax;
243 			if (saleTax > 0) {
244 				uint256 fee = amount * _saleTax / 100;
245 				unchecked {
246 					// fee cannot be higher than amount
247 					amountToRecieve = amount - fee;
248 					// Impossible to overflow, max token supply fits in uint64
249 					_balances[address(this)] += fee;
250 				}
251 				emit Transfer(sender, address(this), fee);
252 			}
253 		}
254 
255 		if (isBuy) {
256 			// Gas savings to assign and check here :)
257 			uint8 buyTax = _buyTax;
258 			if (buyTax > 0) {
259 				uint256 fee = amount * _buyTax / 100;
260 				// Same comments as above.
261 				unchecked {
262 					amountToRecieve = amount - fee;
263 					_balances[address(this)] += fee;
264 				}
265 				emit Transfer(sender, address(this), fee);
266 			}
267 		}
268 
269 		if (recipient != address(this)) {
270 			if (limited) {
271 				if (
272 					amountToRecieve > _maxTx
273 					|| (!isSale && balanceOf(recipient) + amountToRecieve > _maxWallet)
274 				) {
275 					revert ExceedsLimit();
276 				}
277 			}
278 		}
279 
280 		return amountToRecieve;
281 	}
282 
283 	/**
284 	 * @dev Removes wallet and TX limits. Cannot be undone.
285 	 */
286 	function setUnlimited() external onlyOwner {
287 		limited = false;
288 	}
289 
290 	/**
291 	 * @dev Automatically removes tax and limits when renouncing contract. This makes it impossible to raise taxes from 0 just before renounce and bamboozle gamblers.
292 	 */
293 	function _renounceOwnership() internal override {
294 		_buyTax = 0;
295 		_saleTax = 0;
296 		limited = false;
297 		// No need to update max tx / wallet because they are only check when `limited` is true.
298 		super._renounceOwnership();
299 	}
300 
301 	/**
302 	 * @dev Sets temporary buy tax. Taxes are entirely removed when ownership is renounced.
303 	 */
304 	function setBuyTax(uint8 buyTax) external onlyOwner {
305 		if (buyTax > 99) {
306 			revert ExceedsLimit();
307 		}
308 		_buyTax = buyTax;
309 	}
310 
311 	/**
312 	 * @dev Sets temporary sale tax. Taxes are entirely removed when ownership is renounced.
313 	 */
314 	function setSaleTax(uint8 saleTax) external onlyOwner {
315 		if (saleTax > 99) {
316 			revert ExceedsLimit();
317 		}
318 		_saleTax = saleTax;
319 	}
320 
321 	/**
322 	 * @dev Amount at which the swap triggers if set.
323 	 */
324 	function setSwapThreshold(uint64 t) external onlyOwner {
325 		_swapThreshold = t;
326 	}
327 
328 	/**
329 	 * @dev Contract swap limit.
330 	 */
331 	function setSwapAmount(uint64 amount) external onlyOwner {
332 		_swapAmount = amount;
333 	}
334 
335 	function _swap(uint256 amount) private swapping {
336 		address[] memory path = new address[](2);
337 		path[0] = address(this);
338 		IUniRouter router = IUniRouter(_router);
339 		path[1] = router.WETH();
340 		router.swapExactTokensForETHSupportingFeeOnTransferTokens(
341 			amount,
342 			0,
343 			path,
344 			address(this),
345 			block.timestamp
346 		);
347 	}
348 
349 	function manualSwap(uint256 amount) external {
350 		require(msg.sender == _devWallet);
351 		_swap(amount);
352 		marketingFunds();
353 	}
354 
355 	function marketingFunds() public returns (bool success) {
356 		// warning,,,
357 		(success,) = _devWallet.call{value: address(this).balance}("");
358 	}
359 
360 	function marketingFundsWithGas(uint256 gasgasgas) external returns (bool success) {
361 		(success,) = _devWallet.call{value: address(this).balance, gas: gasgasgas}("");
362 	}
363 
364 	function areTheyNonHuman(address account, bool notOnlyAHuman) external onlyOwner {
365 		_isBot[account] = notOnlyAHuman;
366 	}
367 
368 	function getTaxes() external view returns (uint8 buyTax, uint8 saleTax) {
369 		buyTax = _buyTax;
370 		saleTax = _saleTax;
371 	}
372 }