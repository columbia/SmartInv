1 //
2 // C2D V2, with a 50% discount on reinvestments
3 // Always do the opposite of what /biz/ says.
4 // Trust the plan.
5 //
6 
7 pragma solidity ^0.5.17;
8 
9 interface Callable {
10 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
11 }
12 
13 interface CLV {
14 	function balanceOf(address) external view returns (uint256);
15 	function allowance(address, address) external view returns (uint256);
16 	function transfer(address, uint256) external returns (bool);
17 	function transferFrom(address, address, uint256) external returns (bool);
18 }
19 
20 contract CLV2D {
21 	uint256 constant private FLOAT_SCALAR = 2**64;
22 	uint256 constant private BUY_TAX = 4;
23 	uint256 constant private SELL_TAX = 4;
24 	uint256 constant private REINVEST_TAX = 2;
25 	uint256 constant private STARTING_PRICE = 10000;
26 	uint256 constant private INCREMENT = 100;
27 
28 	string constant public name = "CLV2D";
29 	string constant public symbol = "C2D";
30 	uint8 constant public decimals = 18;
31 
32 	struct User {
33 		uint256 balance;
34 		mapping(address => uint256) allowance;
35 		int256 scaledPayout;
36 	}
37 
38 	struct Info {
39 		uint256 totalSupply;
40 		mapping(address => User) users;
41 		uint256 scaledCLVPerToken;
42 		CLV clv;
43 	}
44 	
45 	Info private info;
46 
47 	event Transfer(address indexed from, address indexed to, uint256 tokens);
48 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
49 	event Buy(address indexed buyer, uint256 amountSpent, uint256 tokensReceived);
50 	event Sell(address indexed seller, uint256 tokensSpent, uint256 amountReceived);
51 	event Withdraw(address indexed user, uint256 amount);
52 	event Reinvest(address indexed user, uint256 amount);
53 
54 	constructor(address _CLV_address) public {
55 		info.clv = CLV(_CLV_address);
56 	}
57 
58 	function buy(uint256 _amount) external returns (uint256) {
59 		require(_amount > 0);
60 		require(info.clv.transferFrom(msg.sender, address(this), _amount));
61 		return _buy(_amount);
62 	}
63 
64 	function sell(uint256 _tokens) external returns (uint256) {
65 		require(balanceOf(msg.sender) >= _tokens);
66 		return _sell(_tokens);
67 	}
68 
69 	function withdraw() external returns (uint256) {
70 		uint256 _dividends = dividendsOf(msg.sender);
71 		require(_dividends > 0);
72 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
73 		info.clv.transfer(msg.sender, _dividends);
74 		emit Withdraw(msg.sender, _dividends);
75 		return _dividends;
76 	}
77 
78 	function reinvest() external returns (uint256) {
79 		uint256 _dividends = dividendsOf(msg.sender);
80 		require(_dividends > 0);
81 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
82 		emit Reinvest(msg.sender, _dividends);
83 		return _reinvest(_dividends);
84 	}
85 
86 	function transfer(address _to, uint256 _tokens) external returns (bool) {
87 		return _transfer(msg.sender, _to, _tokens);
88 	}
89 
90 	function approve(address _spender, uint256 _tokens) external returns (bool) {
91 		info.users[msg.sender].allowance[_spender] = _tokens;
92 		emit Approval(msg.sender, _spender, _tokens);
93 		return true;
94 	}
95 
96 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
97 		require(info.users[_from].allowance[msg.sender] >= _tokens);
98 		info.users[_from].allowance[msg.sender] -= _tokens;
99 		return _transfer(_from, _to, _tokens);
100 	}
101 
102 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
103 		_transfer(msg.sender, _to, _tokens);
104 		uint32 _size;
105 		assembly {
106 			_size := extcodesize(_to)
107 		}
108 		if (_size > 0) {
109 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
110 		}
111 		return true;
112 	}
113 
114 	function totalSupply() public view returns (uint256) {
115 		return info.totalSupply;
116 	}
117 
118 	function currentPrices() public view returns (uint256 truePrice, uint256 buyPrice, uint256 sellPrice) {
119 		truePrice = STARTING_PRICE + INCREMENT * totalSupply() / 1e18;
120 		buyPrice = truePrice * 100 / (100 - BUY_TAX);
121 		sellPrice = truePrice * (100 - SELL_TAX) / 100;
122 	}
123 
124 	function balanceOf(address _user) public view returns (uint256) {
125 		return info.users[_user].balance;
126 	}
127 
128 	function dividendsOf(address _user) public view returns (uint256) {
129 		return uint256(int256(info.scaledCLVPerToken * balanceOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
130 	}
131 
132 	function allInfoFor(address _user) public view returns (uint256 contractBalance, uint256 totalTokenSupply, uint256 truePrice, uint256 buyPrice, uint256 sellPrice, uint256 userCLV, uint256 userAllowance, uint256 userBalance, uint256 userDividends, uint256 userLiquidValue) {
133 		contractBalance = info.clv.balanceOf(address(this));
134 		totalTokenSupply = totalSupply();
135 		(truePrice, buyPrice, sellPrice) = currentPrices();
136 		userCLV = info.clv.balanceOf(_user);
137 		userAllowance = info.clv.allowance(_user, address(this));
138 		userBalance = balanceOf(_user);
139 		userDividends = dividendsOf(_user);
140 		userLiquidValue = calculateResult(userBalance, false, false) + userDividends;
141 	}
142 
143 	function allowance(address _user, address _spender) public view returns (uint256) {
144 		return info.users[_user].allowance[_spender];
145 	}
146 
147 	function calculateResult(uint256 _amount, bool _buy, bool _inverse) public view returns (uint256) {
148 		uint256 _buyPrice;
149 		uint256 _sellPrice;
150 		( , _buyPrice, _sellPrice) = currentPrices();
151 		uint256 _rate = (_buy ? _buyPrice : _sellPrice);
152 		uint256 _increment = INCREMENT * (_buy ? 100 : (100 - SELL_TAX)) / (_buy ? (100 - BUY_TAX) : 100);
153 		if ((_buy && !_inverse) || (!_buy && _inverse)) {
154 			if (_inverse) {
155 				return (2 * _rate - _sqrt(4 * _rate * _rate + _increment * _increment - 4 * _rate * _increment - 8 * _amount * _increment) - _increment) * 1e18 / (2 * _increment);
156 			} else {
157 				return (_sqrt((_increment + 2 * _rate) * (_increment + 2 * _rate) + 8 * _amount * _increment) - _increment - 2 * _rate) * 1e18 / (2 * _increment);
158 			}
159 		} else {
160 			if (_inverse) {
161 				return (_rate * _amount + (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
162 			} else {
163 				return (_rate * _amount - (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
164 			}
165 		}
166 	}
167 
168 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
169 		require(info.users[_from].balance >= _tokens);
170 		info.users[_from].balance -= _tokens;
171 		info.users[_from].scaledPayout -= int256(_tokens * info.scaledCLVPerToken);
172 		info.users[_to].balance += _tokens;
173 		info.users[_to].scaledPayout += int256(_tokens * info.scaledCLVPerToken);
174 		emit Transfer(_from, _to, _tokens);
175 		return true;
176 	}
177 
178 	function _buy(uint256 _amount) internal returns (uint256 tokens) {
179 		uint256 _tax = _amount * BUY_TAX / 100;
180 		tokens = calculateResult(_amount, true, false);
181 		info.totalSupply += tokens;
182 		info.users[msg.sender].balance += tokens;
183 		info.users[msg.sender].scaledPayout += int256(tokens * info.scaledCLVPerToken);
184 		info.scaledCLVPerToken += _tax * FLOAT_SCALAR / info.totalSupply;
185 		emit Transfer(address(0x0), msg.sender, tokens);
186 		emit Buy(msg.sender, _amount, tokens);
187 	}
188 
189 	function _reinvest(uint256 _amount) internal returns (uint256 tokens) {
190 		uint256 _tax = _amount * REINVEST_TAX / 100;
191 		tokens = calculateResult(_amount, true, false);
192 		info.totalSupply += tokens;
193 		info.users[msg.sender].balance += tokens;
194 		info.users[msg.sender].scaledPayout += int256(tokens * info.scaledCLVPerToken);
195 		info.scaledCLVPerToken += _tax * FLOAT_SCALAR / info.totalSupply;
196 		emit Transfer(address(0x0), msg.sender, tokens);
197 		emit Buy(msg.sender, _amount, tokens);
198 	}
199 
200 	function _sell(uint256 _tokens) internal returns (uint256 amount) {
201 		require(info.users[msg.sender].balance >= _tokens);
202 		amount = calculateResult(_tokens, false, false);
203 		uint256 _tax = amount * SELL_TAX / (100 - SELL_TAX);
204 		info.totalSupply -= _tokens;
205 		info.users[msg.sender].balance -= _tokens;
206 		info.users[msg.sender].scaledPayout -= int256(_tokens * info.scaledCLVPerToken);
207 		info.scaledCLVPerToken += _tax * FLOAT_SCALAR / info.totalSupply;
208 		info.clv.transfer(msg.sender, amount);
209 		emit Transfer(msg.sender, address(0x0), _tokens);
210 		emit Sell(msg.sender, _tokens, amount);
211 	}
212 
213 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
214 		uint256 _tmp = (_n + 1) / 2;
215 		result = _n;
216 		while (_tmp < result) {
217 			result = _tmp;
218 			_tmp = (_n / _tmp + _tmp) / 2;
219 		}
220 	}
221 }