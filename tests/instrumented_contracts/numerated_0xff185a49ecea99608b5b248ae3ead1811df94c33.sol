1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-18
3 */
4 
5 pragma solidity ^0.5.13;
6 
7 interface Callable {
8 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
9 }
10 
11 contract ADMX {
12 
13 	uint256 constant private FLOAT_SCALAR = 2**64;
14 	uint256 constant private INITIAL_SUPPLY = 1e25; // 1B
15 	uint256 constant private BURN_RATE = 5; // 5% per tx
16 	uint256 constant private SUPPLY_FLOOR = 1; // 1% of 1M = 100K
17 	uint256 constant private MIN_FREEZE_AMOUNT = 0; // 0
18 
19 	string constant public name = "ADMX";
20 	string constant public symbol = "ADMX";
21 	uint8 constant public decimals = 18;
22 
23 	struct User {
24 		bool whitelisted;
25 		uint256 balance;
26 		uint256 frozen;
27 		mapping(address => uint256) allowance;
28 		int256 scaledPayout;
29 	}
30 
31 	struct Info {
32 		uint256 totalSupply;
33 		uint256 totalFrozen;
34 		mapping(address => User) users;
35 		uint256 scaledPayoutPerToken;
36 		address admin;
37 	}
38 	Info private info;
39 
40 
41 	event Transfer(address indexed from, address indexed to, uint256 tokens);
42 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
43 	event Whitelist(address indexed user, bool status);
44 	event Freeze(address indexed owner, uint256 tokens);
45 	event Unfreeze(address indexed owner, uint256 tokens);
46 	event Collect(address indexed owner, uint256 tokens);
47 	event Burn(uint256 tokens);
48 
49 
50 	constructor() public {
51 		info.admin = msg.sender;
52 		info.totalSupply = INITIAL_SUPPLY;
53 		info.users[msg.sender].balance = INITIAL_SUPPLY;
54 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
55 		whitelist(msg.sender, true);
56 	}
57 
58 	function freeze(uint256 _tokens) external {
59 		_freeze(_tokens);
60 	}
61 
62 	function unfreeze(uint256 _tokens) external {
63 		_unfreeze(_tokens);
64 	}
65 
66 	function collect() external returns (uint256) {
67 		uint256 _dividends = dividendsOf(msg.sender);
68 		require(_dividends >= 0);
69 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
70 		info.users[msg.sender].balance += _dividends;
71 		emit Transfer(address(this), msg.sender, _dividends);
72 		emit Collect(msg.sender, _dividends);
73 		return _dividends;
74 	}
75 
76 	function burn(uint256 _tokens) external {
77 		require(balanceOf(msg.sender) >= _tokens);
78 		info.users[msg.sender].balance -= _tokens;
79 		uint256 _burnedAmount = _tokens;
80 		if (info.totalFrozen > 0) {
81 			_burnedAmount /= 2;
82 			info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
83 			emit Transfer(msg.sender, address(this), _burnedAmount);
84 		}
85 		info.totalSupply -= _burnedAmount;
86 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
87 		emit Burn(_burnedAmount);
88 	}
89 
90 	function distribute(uint256 _tokens) external {
91 		require(info.totalFrozen > 0);
92 		require(balanceOf(msg.sender) >= _tokens);
93 		info.users[msg.sender].balance -= _tokens;
94 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalFrozen;
95 		emit Transfer(msg.sender, address(this), _tokens);
96 	}
97 
98 	function transfer(address _to, uint256 _tokens) external returns (bool) {
99 		_transfer(msg.sender, _to, _tokens);
100 		return true;
101 	}
102 
103 	function approve(address _spender, uint256 _tokens) external returns (bool) {
104 		info.users[msg.sender].allowance[_spender] = _tokens;
105 		emit Approval(msg.sender, _spender, _tokens);
106 		return true;
107 	}
108 
109 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
110 		require(info.users[_from].allowance[msg.sender] >= _tokens);
111 		info.users[_from].allowance[msg.sender] -= _tokens;
112 		_transfer(_from, _to, _tokens);
113 		return true;
114 	}
115 
116 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
117 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
118 		uint32 _size;
119 		assembly {
120 			_size := extcodesize(_to)
121 		}
122 		if (_size > 0) {
123 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
124 		}
125 		return true;
126 	}
127 
128 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
129 		require(_receivers.length == _amounts.length);
130 		for (uint256 i = 0; i < _receivers.length; i++) {
131 			_transfer(msg.sender, _receivers[i], _amounts[i]);
132 		}
133 	}
134 
135 	function whitelist(address _user, bool _status) public {
136 		require(msg.sender == info.admin);
137 		info.users[_user].whitelisted = _status;
138 		emit Whitelist(_user, _status);
139 	}
140 
141 
142 	function totalSupply() public view returns (uint256) {
143 		return info.totalSupply;
144 	}
145 
146 	function totalFrozen() public view returns (uint256) {
147 		return info.totalFrozen;
148 	}
149 
150 	function balanceOf(address _user) public view returns (uint256) {
151 		return info.users[_user].balance - frozenOf(_user);
152 	}
153 
154 	function frozenOf(address _user) public view returns (uint256) {
155 		return info.users[_user].frozen;
156 	}
157 
158 	function dividendsOf(address _user) public view returns (uint256) {
159 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
160 	}
161 
162 	function allowance(address _user, address _spender) public view returns (uint256) {
163 		return info.users[_user].allowance[_spender];
164 	}
165 
166 	function isWhitelisted(address _user) public view returns (bool) {
167 		return info.users[_user].whitelisted;
168 	}
169 
170 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance, uint256 userFrozen, uint256 userDividends) {
171 		return (totalSupply(), totalFrozen(), balanceOf(_user), frozenOf(_user), dividendsOf(_user));
172 	}
173 
174 
175 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
176 		require(balanceOf(_from) >= _tokens);
177 		info.users[_from].balance -= _tokens;
178 		uint256 _burnedAmount = _tokens * BURN_RATE / 100;
179 		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 || isWhitelisted(_from)) {
180 			_burnedAmount = 0;
181 		}
182 		uint256 _transferred = _tokens - _burnedAmount;
183 		info.users[_to].balance += _transferred;
184 		emit Transfer(_from, _to, _transferred);
185 		if (_burnedAmount > 0) {
186 			if (info.totalFrozen > 0) {
187 				_burnedAmount /= 2;
188 				info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
189 				emit Transfer(_from, address(this), _burnedAmount);
190 			}
191 			info.totalSupply -= _burnedAmount;
192 			emit Transfer(_from, address(0x0), _burnedAmount);
193 			emit Burn(_burnedAmount);
194 		}
195 		return _transferred;
196 	}
197 
198 	function _freeze(uint256 _amount) internal {
199 		require(balanceOf(msg.sender) >= _amount);
200 		require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT);
201 		info.totalFrozen += _amount;
202 		info.users[msg.sender].frozen += _amount;
203 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
204 		emit Transfer(msg.sender, address(this), _amount);
205 		emit Freeze(msg.sender, _amount);
206 	}
207 
208 	function _unfreeze(uint256 _amount) internal {
209 		require(frozenOf(msg.sender) >= _amount);
210 		uint256 _burnedAmount = _amount * BURN_RATE / 100;
211 		info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
212 		info.totalFrozen -= _amount;
213 		info.users[msg.sender].balance -= _burnedAmount;
214 		info.users[msg.sender].frozen -= _amount;
215 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
216 		emit Transfer(address(this), msg.sender, _amount - _burnedAmount);
217 		emit Unfreeze(msg.sender, _amount);
218 	}
219 }