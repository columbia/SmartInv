1 pragma solidity ^0.5.13;
2 
3 interface Callable {
4 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
5 }
6 
7 contract AdamantX {
8 
9 	uint256 constant private FLOAT_SCALAR = 2**64;
10 	uint256 constant private INITIAL_SUPPLY = 1e27; // 1B
11 	uint256 constant private BURN_RATE = 5; // 5% per tx
12 	uint256 constant private SUPPLY_FLOOR = 1; // 1% of 1B = 10M
13 	uint256 constant private MIN_FREEZE_AMOUNT = 0; // 1,000
14 
15 	string constant public name = "Adamant X";
16 	string constant public symbol = "ADX";
17 	uint8 constant public decimals = 18;
18 
19 	struct User {
20 		bool whitelisted;
21 		uint256 balance;
22 		uint256 frozen;
23 		mapping(address => uint256) allowance;
24 		int256 scaledPayout;
25 	}
26 
27 	struct Info {
28 		uint256 totalSupply;
29 		uint256 totalFrozen;
30 		mapping(address => User) users;
31 		uint256 scaledPayoutPerToken;
32 		address admin;
33 	}
34 	Info private info;
35 
36 
37 	event Transfer(address indexed from, address indexed to, uint256 tokens);
38 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
39 	event Whitelist(address indexed user, bool status);
40 	event Freeze(address indexed owner, uint256 tokens);
41 	event Unfreeze(address indexed owner, uint256 tokens);
42 	event Collect(address indexed owner, uint256 tokens);
43 	event Burn(uint256 tokens);
44 
45 
46 	constructor() public {
47 		info.admin = msg.sender;
48 		info.totalSupply = INITIAL_SUPPLY;
49 		info.users[msg.sender].balance = INITIAL_SUPPLY;
50 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
51 		whitelist(msg.sender, true);
52 	}
53 
54 	function freeze(uint256 _tokens) external {
55 		_freeze(_tokens);
56 	}
57 
58 	function unfreeze(uint256 _tokens) external {
59 		_unfreeze(_tokens);
60 	}
61 
62 	function collect() external returns (uint256) {
63 		uint256 _dividends = dividendsOf(msg.sender);
64 		require(_dividends >= 0);
65 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
66 		info.users[msg.sender].balance += _dividends;
67 		emit Transfer(address(this), msg.sender, _dividends);
68 		emit Collect(msg.sender, _dividends);
69 		return _dividends;
70 	}
71 
72 	function burn(uint256 _tokens) external {
73 		require(balanceOf(msg.sender) >= _tokens);
74 		info.users[msg.sender].balance -= _tokens;
75 		uint256 _burnedAmount = _tokens;
76 		if (info.totalFrozen > 0) {
77 			_burnedAmount /= 2;
78 			info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
79 			emit Transfer(msg.sender, address(this), _burnedAmount);
80 		}
81 		info.totalSupply -= _burnedAmount;
82 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
83 		emit Burn(_burnedAmount);
84 	}
85 
86 	function distribute(uint256 _tokens) external {
87 		require(info.totalFrozen > 0);
88 		require(balanceOf(msg.sender) >= _tokens);
89 		info.users[msg.sender].balance -= _tokens;
90 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalFrozen;
91 		emit Transfer(msg.sender, address(this), _tokens);
92 	}
93 
94 	function transfer(address _to, uint256 _tokens) external returns (bool) {
95 		_transfer(msg.sender, _to, _tokens);
96 		return true;
97 	}
98 
99 	function approve(address _spender, uint256 _tokens) external returns (bool) {
100 		info.users[msg.sender].allowance[_spender] = _tokens;
101 		emit Approval(msg.sender, _spender, _tokens);
102 		return true;
103 	}
104 
105 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
106 		require(info.users[_from].allowance[msg.sender] >= _tokens);
107 		info.users[_from].allowance[msg.sender] -= _tokens;
108 		_transfer(_from, _to, _tokens);
109 		return true;
110 	}
111 
112 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
113 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
114 		uint32 _size;
115 		assembly {
116 			_size := extcodesize(_to)
117 		}
118 		if (_size > 0) {
119 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
120 		}
121 		return true;
122 	}
123 
124 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
125 		require(_receivers.length == _amounts.length);
126 		for (uint256 i = 0; i < _receivers.length; i++) {
127 			_transfer(msg.sender, _receivers[i], _amounts[i]);
128 		}
129 	}
130 
131 	function whitelist(address _user, bool _status) public {
132 		require(msg.sender == info.admin);
133 		info.users[_user].whitelisted = _status;
134 		emit Whitelist(_user, _status);
135 	}
136 
137 
138 	function totalSupply() public view returns (uint256) {
139 		return info.totalSupply;
140 	}
141 
142 	function totalFrozen() public view returns (uint256) {
143 		return info.totalFrozen;
144 	}
145 
146 	function balanceOf(address _user) public view returns (uint256) {
147 		return info.users[_user].balance - frozenOf(_user);
148 	}
149 
150 	function frozenOf(address _user) public view returns (uint256) {
151 		return info.users[_user].frozen;
152 	}
153 
154 	function dividendsOf(address _user) public view returns (uint256) {
155 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
156 	}
157 
158 	function allowance(address _user, address _spender) public view returns (uint256) {
159 		return info.users[_user].allowance[_spender];
160 	}
161 
162 	function isWhitelisted(address _user) public view returns (bool) {
163 		return info.users[_user].whitelisted;
164 	}
165 
166 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance, uint256 userFrozen, uint256 userDividends) {
167 		return (totalSupply(), totalFrozen(), balanceOf(_user), frozenOf(_user), dividendsOf(_user));
168 	}
169 
170 
171 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
172 		require(balanceOf(_from) >= _tokens);
173 		info.users[_from].balance -= _tokens;
174 		uint256 _burnedAmount = _tokens * BURN_RATE / 100;
175 		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 || isWhitelisted(_from)) {
176 			_burnedAmount = 0;
177 		}
178 		uint256 _transferred = _tokens - _burnedAmount;
179 		info.users[_to].balance += _transferred;
180 		emit Transfer(_from, _to, _transferred);
181 		if (_burnedAmount > 0) {
182 			if (info.totalFrozen > 0) {
183 				_burnedAmount /= 2;
184 				info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
185 				emit Transfer(_from, address(this), _burnedAmount);
186 			}
187 			info.totalSupply -= _burnedAmount;
188 			emit Transfer(_from, address(0x0), _burnedAmount);
189 			emit Burn(_burnedAmount);
190 		}
191 		return _transferred;
192 	}
193 
194 	function _freeze(uint256 _amount) internal {
195 		require(balanceOf(msg.sender) >= _amount);
196 		require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT);
197 		info.totalFrozen += _amount;
198 		info.users[msg.sender].frozen += _amount;
199 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
200 		emit Transfer(msg.sender, address(this), _amount);
201 		emit Freeze(msg.sender, _amount);
202 	}
203 
204 	function _unfreeze(uint256 _amount) internal {
205 		require(frozenOf(msg.sender) >= _amount);
206 		uint256 _burnedAmount = _amount * BURN_RATE / 100;
207 		info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
208 		info.totalFrozen -= _amount;
209 		info.users[msg.sender].balance -= _burnedAmount;
210 		info.users[msg.sender].frozen -= _amount;
211 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
212 		emit Transfer(address(this), msg.sender, _amount - _burnedAmount);
213 		emit Unfreeze(msg.sender, _amount);
214 	}
215 }