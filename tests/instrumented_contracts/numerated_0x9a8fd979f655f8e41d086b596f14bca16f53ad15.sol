1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 interface Callable {
5 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
6 }
7 
8 interface KRILL {
9 	function balanceOf(address) external view returns (uint256);
10 	function transfer(address, uint256) external returns (bool);
11 	function transferFrom(address, address, uint256) external returns (bool);
12 }
13 
14 contract cKRILL {
15 
16 	uint256 constant private FLOAT_SCALAR = 2**64;
17 	uint256 constant private BUY_TAX = 10;
18 	uint256 constant private SELL_TAX = 10;
19 	uint256 constant private STARTING_PRICE = 1e18;
20 	uint256 constant private INCREMENT = 1e13;
21 
22 	string constant public name = "Krill Compounder";
23 	string constant public symbol = "cKRILL";
24 	uint8 constant public decimals = 18;
25 
26 	struct User {
27 		uint256 balance;
28 		mapping(address => uint256) allowance;
29 		int256 scaledPayout;
30 	}
31 
32 	struct Info {
33 		uint256 totalSupply;
34 		mapping(address => User) users;
35 		uint256 scaledKrillPerToken;
36 		uint256 openingTime;
37 		KRILL krill;
38 	}
39 	Info private info;
40 
41 
42 	event Transfer(address indexed from, address indexed to, uint256 tokens);
43 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
44 	event Buy(address indexed buyer, uint256 amountSpent, uint256 tokensReceived);
45 	event Sell(address indexed seller, uint256 tokensSpent, uint256 amountReceived);
46 	event Withdraw(address indexed user, uint256 amount);
47 	event Reinvest(address indexed user, uint256 amount);
48 
49 
50 	constructor(KRILL _krill, uint256 _openingTime) {
51 		info.krill = _krill;
52 		info.openingTime = _openingTime;
53 	}
54 
55 	function disburse(uint256 _amount) external {
56 		require(_amount > 0);
57 		uint256 _balanceBefore = info.krill.balanceOf(address(this));
58 		info.krill.transferFrom(msg.sender, address(this), _amount);
59 		uint256 _amountReceived = info.krill.balanceOf(address(this)) - _balanceBefore;
60 		info.scaledKrillPerToken += _amountReceived * FLOAT_SCALAR / info.totalSupply;
61 	}
62 
63 	function buy(uint256 _amount) external returns (uint256) {
64 		return buyFor(_amount, msg.sender);
65 	}
66 
67 	function buyFor(uint256 _amount, address _user) public returns (uint256) {
68 		require(_amount > 0);
69 		uint256 _balanceBefore = info.krill.balanceOf(address(this));
70 		info.krill.transferFrom(msg.sender, address(this), _amount);
71 		uint256 _amountReceived = info.krill.balanceOf(address(this)) - _balanceBefore;
72 		return _buy(_amountReceived, _user);
73 	}
74 
75 	function tokenCallback(address _from, uint256 _tokens, bytes calldata) external returns (bool) {
76 		require(msg.sender == address(info.krill));
77 		require(_tokens > 0);
78 		_buy(_tokens, _from);
79 		return true;
80 	}
81 
82 	function sell(uint256 _tokens) external returns (uint256) {
83 		require(balanceOf(msg.sender) >= _tokens);
84 		return _sell(_tokens);
85 	}
86 
87 	function withdraw() external returns (uint256) {
88 		uint256 _dividends = dividendsOf(msg.sender);
89 		require(_dividends > 0);
90 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
91 		info.krill.transfer(msg.sender, _dividends);
92 		emit Withdraw(msg.sender, _dividends);
93 		return _dividends;
94 	}
95 
96 	function reinvest() external returns (uint256) {
97 		uint256 _dividends = dividendsOf(msg.sender);
98 		require(_dividends > 0);
99 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
100 		emit Reinvest(msg.sender, _dividends);
101 		return _buy(_dividends, msg.sender);
102 	}
103 
104 	function transfer(address _to, uint256 _tokens) external returns (bool) {
105 		return _transfer(msg.sender, _to, _tokens);
106 	}
107 
108 	function approve(address _spender, uint256 _tokens) external returns (bool) {
109 		info.users[msg.sender].allowance[_spender] = _tokens;
110 		emit Approval(msg.sender, _spender, _tokens);
111 		return true;
112 	}
113 
114 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
115 		require(info.users[_from].allowance[msg.sender] >= _tokens);
116 		info.users[_from].allowance[msg.sender] -= _tokens;
117 		return _transfer(_from, _to, _tokens);
118 	}
119 
120 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
121 		_transfer(msg.sender, _to, _tokens);
122 		uint32 _size;
123 		assembly {
124 			_size := extcodesize(_to)
125 		}
126 		if (_size > 0) {
127 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
128 		}
129 		return true;
130 	}
131 
132 
133 	function totalSupply() public view returns (uint256) {
134 		return info.totalSupply;
135 	}
136 
137 	function currentPrices() public view returns (uint256 truePrice, uint256 buyPrice, uint256 sellPrice) {
138 		truePrice = STARTING_PRICE + INCREMENT * totalSupply() / 1e18;
139 		buyPrice = truePrice * 100 / (100 - BUY_TAX);
140 		sellPrice = truePrice * (100 - SELL_TAX) / 100;
141 	}
142 
143 	function balanceOf(address _user) public view returns (uint256) {
144 		return info.users[_user].balance;
145 	}
146 
147 	function dividendsOf(address _user) public view returns (uint256) {
148 		return uint256(int256(info.scaledKrillPerToken * balanceOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
149 	}
150 
151 	function allInfoFor(address _user) external view returns (uint256 contractBalance, uint256 totalTokenSupply, uint256 truePrice, uint256 buyPrice, uint256 sellPrice, uint256 openingTime, uint256 userETH, uint256 userKRILL, uint256 userBalance, uint256 userDividends, uint256 userLiquidValue) {
152 		contractBalance = info.krill.balanceOf(address(this));
153 		totalTokenSupply = totalSupply();
154 		(truePrice, buyPrice, sellPrice) = currentPrices();
155 		openingTime = info.openingTime;
156 		userETH = _user.balance;
157 		userKRILL = info.krill.balanceOf(_user);
158 		userBalance = balanceOf(_user);
159 		userDividends = dividendsOf(_user);
160 		userLiquidValue = calculateResult(userBalance, false, false) + userDividends;
161 	}
162 
163 	function allowance(address _user, address _spender) external view returns (uint256) {
164 		return info.users[_user].allowance[_spender];
165 	}
166 
167 	function calculateResult(uint256 _amount, bool _isBuy, bool _inverse) public view returns (uint256) {
168 		uint256 _buyPrice;
169 		uint256 _sellPrice;
170 		( , _buyPrice, _sellPrice) = currentPrices();
171 		uint256 _rate = (_isBuy ? _buyPrice : _sellPrice);
172 		uint256 _increment = INCREMENT * (_isBuy ? 100 : (100 - SELL_TAX)) / (_isBuy ? (100 - BUY_TAX) : 100);
173 		if ((_isBuy && !_inverse) || (!_isBuy && _inverse)) {
174 			if (_inverse) {
175 				return (2 * _rate - _sqrt(4 * _rate * _rate + _increment * _increment - 4 * _rate * _increment - 8 * _amount * _increment) - _increment) * 1e18 / (2 * _increment);
176 			} else {
177 				return (_sqrt((_increment + 2 * _rate) * (_increment + 2 * _rate) + 8 * _amount * _increment) - _increment - 2 * _rate) * 1e18 / (2 * _increment);
178 			}
179 		} else {
180 			if (_inverse) {
181 				return (_rate * _amount + (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
182 			} else {
183 				return (_rate * _amount - (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
184 			}
185 		}
186 	}
187 
188 
189 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
190 		require(info.users[_from].balance >= _tokens);
191 		info.users[_from].balance -= _tokens;
192 		info.users[_from].scaledPayout -= int256(_tokens * info.scaledKrillPerToken);
193 		info.users[_to].balance += _tokens;
194 		info.users[_to].scaledPayout += int256(_tokens * info.scaledKrillPerToken);
195 		emit Transfer(_from, _to, _tokens);
196 		return true;
197 	}
198 
199 	function _buy(uint256 _amount, address _user) internal returns (uint256 tokens) {
200 		require(block.timestamp >= info.openingTime);
201 		uint256 _tax = _amount * BUY_TAX / 100;
202 		tokens = calculateResult(_amount, true, false);
203 		info.totalSupply += tokens;
204 		info.users[_user].balance += tokens;
205 		info.users[_user].scaledPayout += int256(tokens * info.scaledKrillPerToken);
206 		info.scaledKrillPerToken += _tax * FLOAT_SCALAR / info.totalSupply;
207 		emit Transfer(address(0x0), _user, tokens);
208 		emit Buy(_user, _amount, tokens);
209 	}
210 
211 	function _sell(uint256 _tokens) internal returns (uint256 amount) {
212 		require(info.users[msg.sender].balance >= _tokens);
213 		amount = calculateResult(_tokens, false, false);
214 		uint256 _tax = amount * SELL_TAX / (100 - SELL_TAX);
215 		info.totalSupply -= _tokens;
216 		info.users[msg.sender].balance -= _tokens;
217 		info.users[msg.sender].scaledPayout -= int256(_tokens * info.scaledKrillPerToken);
218 		info.scaledKrillPerToken += _tax * FLOAT_SCALAR / info.totalSupply;
219 		info.krill.transfer(msg.sender, amount);
220 		emit Transfer(msg.sender, address(0x0), _tokens);
221 		emit Sell(msg.sender, _tokens, amount);
222 	}
223 
224 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
225 		uint256 _tmp = (_n + 1) / 2;
226 		result = _n;
227 		while (_tmp < result) {
228 			result = _tmp;
229 			_tmp = (_n / _tmp + _tmp) / 2;
230 		}
231 	}
232 }