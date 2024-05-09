1 /**
2  * 
3  * fuck Spydr. karma will find them                                                             
4  * 
5 */
6 
7 pragma solidity ^0.5.13;
8 
9 interface Callable {
10 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
11 }
12 
13 contract DYX {
14 
15 	uint256 constant private FLOAT_SCALAR = 2**64;
16 	uint256 constant private INITIAL_SUPPLY = 6.9e25; // 69M
17 	uint256 constant private BURN_RATE = 10; // 10% per tx
18 	uint256 constant private SUPPLY_FLOOR = 1; // 1% of 69M
19 	uint256 constant private MIN_FREEZE_AMOUNT = 1e20; // 100 minimum
20 
21 	string constant public name = "DYX Network";
22 	string constant public symbol = "DYX";
23 	uint8 constant public decimals = 18;
24 
25 	struct User {
26 		bool whitelisted;
27 		uint256 balance;
28 		uint256 frozen;
29 		mapping(address => uint256) allowance;
30 		int256 scaledPayout;
31 	}
32 
33 	struct Info {
34 		uint256 totalSupply;
35 		uint256 totalFrozen;
36 		mapping(address => User) users;
37 		uint256 scaledPayoutPerToken;
38 		address admin;
39 	}
40 	Info private info;
41 
42 
43 	event Transfer(address indexed from, address indexed to, uint256 tokens);
44 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
45 	event Whitelist(address indexed user, bool status);
46 	event Freeze(address indexed owner, uint256 tokens);
47 	event Unfreeze(address indexed owner, uint256 tokens);
48 	event Collect(address indexed owner, uint256 tokens);
49 	event Burn(uint256 tokens);
50 
51 
52 	constructor() public {
53 		info.admin = msg.sender;
54 		info.totalSupply = INITIAL_SUPPLY;
55 		info.users[msg.sender].balance = INITIAL_SUPPLY;
56 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
57 		whitelist(msg.sender, true);
58 	}
59 
60 	function freeze(uint256 _tokens) external {
61 		_freeze(_tokens);
62 	}
63 
64 	function unfreeze(uint256 _tokens) external {
65 		_unfreeze(_tokens);
66 	}
67 
68 	function collect() external returns (uint256) {
69 		uint256 _dividends = dividendsOf(msg.sender);
70 		require(_dividends >= 0);
71 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
72 		info.users[msg.sender].balance += _dividends;
73 		emit Transfer(address(this), msg.sender, _dividends);
74 		emit Collect(msg.sender, _dividends);
75 		return _dividends;
76 	}
77 
78 	function burn(uint256 _tokens) external {
79 		require(balanceOf(msg.sender) >= _tokens);
80 		info.users[msg.sender].balance -= _tokens;
81 		uint256 _burnedAmount = _tokens;
82 		if (info.totalFrozen > 0) {
83 			_burnedAmount /= 2;
84 			info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
85 			emit Transfer(msg.sender, address(this), _burnedAmount);
86 		}
87 		info.totalSupply -= _burnedAmount;
88 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
89 		emit Burn(_burnedAmount);
90 	}
91 
92 	function distribute(uint256 _tokens) external {
93 		require(info.totalFrozen > 0);
94 		require(balanceOf(msg.sender) >= _tokens);
95 		info.users[msg.sender].balance -= _tokens;
96 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalFrozen;
97 		emit Transfer(msg.sender, address(this), _tokens);
98 	}
99 
100 	function transfer(address _to, uint256 _tokens) external returns (bool) {
101 		_transfer(msg.sender, _to, _tokens);
102 		return true;
103 	}
104 
105 	function approve(address _spender, uint256 _tokens) external returns (bool) {
106 		info.users[msg.sender].allowance[_spender] = _tokens;
107 		emit Approval(msg.sender, _spender, _tokens);
108 		return true;
109 	}
110 
111 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
112 		require(info.users[_from].allowance[msg.sender] >= _tokens);
113 		info.users[_from].allowance[msg.sender] -= _tokens;
114 		_transfer(_from, _to, _tokens);
115 		return true;
116 	}
117 
118 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
119 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
120 		uint32 _size;
121 		assembly {
122 			_size := extcodesize(_to)
123 		}
124 		if (_size > 0) {
125 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
126 		}
127 		return true;
128 	}
129 
130 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
131 		require(_receivers.length == _amounts.length);
132 		for (uint256 i = 0; i < _receivers.length; i++) {
133 			_transfer(msg.sender, _receivers[i], _amounts[i]);
134 		}
135 	}
136 
137 	function whitelist(address _user, bool _status) public {
138 		require(msg.sender == info.admin);
139 		info.users[_user].whitelisted = _status;
140 		emit Whitelist(_user, _status);
141 	}
142 
143 
144 	function totalSupply() public view returns (uint256) {
145 		return info.totalSupply;
146 	}
147 
148 	function totalFrozen() public view returns (uint256) {
149 		return info.totalFrozen;
150 	}
151 
152 	function balanceOf(address _user) public view returns (uint256) {
153 		return info.users[_user].balance - frozenOf(_user);
154 	}
155 
156 	function frozenOf(address _user) public view returns (uint256) {
157 		return info.users[_user].frozen;
158 	}
159 
160 	function dividendsOf(address _user) public view returns (uint256) {
161 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
162 	}
163 
164 	function allowance(address _user, address _spender) public view returns (uint256) {
165 		return info.users[_user].allowance[_spender];
166 	}
167 
168 	function isWhitelisted(address _user) public view returns (bool) {
169 		return info.users[_user].whitelisted;
170 	}
171 
172 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance, uint256 userFrozen, uint256 userDividends) {
173 		return (totalSupply(), totalFrozen(), balanceOf(_user), frozenOf(_user), dividendsOf(_user));
174 	}
175 
176 
177 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
178 		require(balanceOf(_from) >= _tokens);
179 		info.users[_from].balance -= _tokens;
180 		uint256 _burnedAmount = _tokens * BURN_RATE / 100;
181 		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 || isWhitelisted(_from)) {
182 			_burnedAmount = 0;
183 		}
184 		uint256 _transferred = _tokens - _burnedAmount;
185 		info.users[_to].balance += _transferred;
186 		emit Transfer(_from, _to, _transferred);
187 		if (_burnedAmount > 0) {
188 			if (info.totalFrozen > 0) {
189 				_burnedAmount /= 2;
190 				info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
191 				emit Transfer(_from, address(this), _burnedAmount);
192 			}
193 			info.totalSupply -= _burnedAmount;
194 			emit Transfer(_from, address(0x0), _burnedAmount);
195 			emit Burn(_burnedAmount);
196 		}
197 		return _transferred;
198 	}
199 
200 	function _freeze(uint256 _amount) internal {
201 		require(balanceOf(msg.sender) >= _amount);
202 		require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT);
203 		info.totalFrozen += _amount;
204 		info.users[msg.sender].frozen += _amount;
205 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
206 		emit Transfer(msg.sender, address(this), _amount);
207 		emit Freeze(msg.sender, _amount);
208 	}
209 
210 	function _unfreeze(uint256 _amount) internal {
211 		require(frozenOf(msg.sender) >= _amount);
212 		uint256 _burnedAmount = _amount * BURN_RATE / 100;
213 		info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
214 		info.totalFrozen -= _amount;
215 		info.users[msg.sender].balance -= _burnedAmount;
216 		info.users[msg.sender].frozen -= _amount;
217 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
218 		emit Transfer(address(this), msg.sender, _amount - _burnedAmount);
219 		emit Unfreeze(msg.sender, _amount);
220 	}
221 }