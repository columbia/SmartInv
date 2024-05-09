1 //
2 // Daily Divs Network
3 // An Honest, Decentralized Ponzi Scheme
4 // https://dailydivs.network/
5 //
6 
7 pragma solidity ^0.5.13;
8 
9 interface Callable {
10 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
11 }
12 
13 contract DailyDivsNetwork {
14 
15 	uint256 constant private FLOAT_SCALAR = 2**64;
16 	uint256 constant private BUY_TAX = 20;
17 	uint256 constant private SELL_TAX = 5;
18 	uint256 constant private STARTING_PRICE = 0.001 ether;
19 	uint256 constant private INCREMENT = 1e10;
20 
21 	string constant public name = "Daily Divs Network";
22 	string constant public symbol = "DDN";
23 	uint8 constant public decimals = 18;
24 
25 	struct User {
26 		uint256 balance;
27 		mapping(address => uint256) allowance;
28 		int256 scaledPayout;
29 	}
30 
31 	struct Info {
32 		uint256 totalSupply;
33 		mapping(address => User) users;
34 		uint256 scaledEthPerToken;
35 	}
36 	Info private info;
37 
38 
39 	event Transfer(address indexed from, address indexed to, uint256 tokens);
40 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
41 	event Buy(address indexed buyer, uint256 amountSpent, uint256 tokensReceived);
42 	event Sell(address indexed seller, uint256 tokensSpent, uint256 amountReceived);
43 	event Withdraw(address indexed user, uint256 amount);
44 	event Reinvest(address indexed user, uint256 amount);
45 
46 
47 	function buy() external payable returns (uint256) {
48 		require(msg.value > 0);
49 		return _buy(msg.value);
50 	}
51 
52 	function sell(uint256 _tokens) external returns (uint256) {
53 		require(balanceOf(msg.sender) >= _tokens);
54 		return _sell(_tokens);
55 	}
56 
57 	function withdraw() external returns (uint256) {
58 		uint256 _dividends = dividendsOf(msg.sender);
59 		require(_dividends >= 0);
60 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
61 		msg.sender.transfer(_dividends);
62 		emit Withdraw(msg.sender, _dividends);
63 		return _dividends;
64 	}
65 
66 	function reinvest() external returns (uint256) {
67 		uint256 _dividends = dividendsOf(msg.sender);
68 		require(_dividends >= 0);
69 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
70 		emit Reinvest(msg.sender, _dividends);
71 		return _buy(_dividends);
72 	}
73 
74 	function transfer(address _to, uint256 _tokens) external returns (bool) {
75 		return _transfer(msg.sender, _to, _tokens);
76 	}
77 
78 	function approve(address _spender, uint256 _tokens) external returns (bool) {
79 		info.users[msg.sender].allowance[_spender] = _tokens;
80 		emit Approval(msg.sender, _spender, _tokens);
81 		return true;
82 	}
83 
84 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
85 		require(info.users[_from].allowance[msg.sender] >= _tokens);
86 		info.users[_from].allowance[msg.sender] -= _tokens;
87 		return _transfer(_from, _to, _tokens);
88 	}
89 
90 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
91 		_transfer(msg.sender, _to, _tokens);
92 		uint32 _size;
93 		assembly {
94 			_size := extcodesize(_to)
95 		}
96 		if (_size > 0) {
97 			require(Callable(_to).tokenCallback(msg.sender, _tokens, _data));
98 		}
99 		return true;
100 	}
101 
102 
103 	function totalSupply() public view returns (uint256) {
104 		return info.totalSupply;
105 	}
106 
107 	function currentPrices() public view returns (uint256 truePrice, uint256 buyPrice, uint256 sellPrice) {
108 		truePrice = STARTING_PRICE + INCREMENT * totalSupply() / 1e18;
109 		buyPrice = truePrice * 100 / (100 - BUY_TAX);
110 		sellPrice = truePrice * (100 - SELL_TAX) / 100;
111 	}
112 
113 	function balanceOf(address _user) public view returns (uint256) {
114 		return info.users[_user].balance;
115 	}
116 
117 	function dividendsOf(address _user) public view returns (uint256) {
118 		return uint256(int256(info.scaledEthPerToken * balanceOf(_user)) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
119 	}
120 
121 	function allInfoFor(address _user) public view returns (uint256 contractBalance, uint256 totalTokenSupply, uint256 truePrice, uint256 buyPrice, uint256 sellPrice, uint256 userBalance, uint256 userDividends, uint256 userLiquidValue) {
122 		contractBalance = address(this).balance;
123 		totalTokenSupply = totalSupply();
124 		(truePrice, buyPrice, sellPrice) = currentPrices();
125 		userBalance = balanceOf(_user);
126 		userDividends = dividendsOf(_user);
127 		userLiquidValue = calculateResult(userBalance, false, false) + userDividends;
128 	}
129 
130 	function allowance(address _user, address _spender) public view returns (uint256) {
131 		return info.users[_user].allowance[_spender];
132 	}
133 
134 	function calculateResult(uint256 _amount, bool _buy, bool _inverse) public view returns (uint256) {
135 		uint256 _buyPrice;
136 		uint256 _sellPrice;
137 		( , _buyPrice, _sellPrice) = currentPrices();
138 		uint256 _rate = (_buy ? _buyPrice : _sellPrice);
139 		uint256 _increment = INCREMENT * (_buy ? 100 : (100 - SELL_TAX)) / (_buy ? (100 - BUY_TAX) : 100);
140 		if ((_buy && !_inverse) || (!_buy && _inverse)) {
141 			if (_inverse) {
142 				return (2 * _rate - _sqrt(4 * _rate * _rate + _increment * _increment - 4 * _rate * _increment - 8 * _amount * _increment) - _increment) * 1e18 / (2 * _increment);
143 			} else {
144 				return (_sqrt((_increment + 2 * _rate) * (_increment + 2 * _rate) + 8 * _amount * _increment) - _increment - 2 * _rate) * 1e18 / (2 * _increment);
145 			}
146 		} else {
147 			if (_inverse) {
148 				return (_rate * _amount + (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
149 			} else {
150 				return (_rate * _amount - (_increment * (_amount + 1e18) / 2e18) * _amount) / 1e18;
151 			}
152 		}
153 	}
154 
155 
156 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (bool) {
157 		require(info.users[_from].balance >= _tokens);
158 		info.users[_from].balance -= _tokens;
159 		info.users[_from].scaledPayout -= int256(_tokens * info.scaledEthPerToken);
160 		info.users[_to].balance += _tokens;
161 		info.users[_to].scaledPayout += int256(_tokens * info.scaledEthPerToken);
162 		emit Transfer(_from, _to, _tokens);
163 		return true;
164 	}
165 
166 	function _buy(uint256 _amount) internal returns (uint256 tokens) {
167 		uint256 _tax = _amount * BUY_TAX / 100;
168 		tokens = calculateResult(_amount, true, false);
169 		info.totalSupply += tokens;
170 		info.users[msg.sender].balance += tokens;
171 		info.users[msg.sender].scaledPayout += int256(tokens * info.scaledEthPerToken);
172 		info.scaledEthPerToken += _tax * FLOAT_SCALAR / info.totalSupply;
173 		emit Transfer(address(0x0), msg.sender, tokens);
174 		emit Buy(msg.sender, _amount, tokens);
175 	}
176 
177 	function _sell(uint256 _tokens) internal returns (uint256 amount) {
178 		require(info.users[msg.sender].balance >= _tokens);
179 		amount = calculateResult(_tokens, false, false);
180 		uint256 _tax = amount * SELL_TAX / (100 - SELL_TAX);
181 		info.totalSupply -= _tokens;
182 		info.users[msg.sender].balance -= _tokens;
183 		info.users[msg.sender].scaledPayout -= int256(_tokens * info.scaledEthPerToken);
184 		info.scaledEthPerToken += _tax * FLOAT_SCALAR / info.totalSupply;
185 		msg.sender.transfer(amount);
186 		emit Transfer(msg.sender, address(0x0), _tokens);
187 		emit Sell(msg.sender, _tokens, amount);
188 	}
189 
190 
191 	function _sqrt(uint256 _n) internal pure returns (uint256 result) {
192 		uint256 _tmp = (_n + 1) / 2;
193 		result = _n;
194 		while (_tmp < result) {
195 			result = _tmp;
196 			_tmp = (_n / _tmp + _tmp) / 2;
197 		}
198 	}
199 }