1 /**
2  * 
3  * Kevin is Satoshi                                              
4  * 
5 */
6 
7 pragma solidity ^0.5.13;
8 
9 interface Callable {
10 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
11 }
12 
13 contract H4X {
14 
15 	uint256 constant private FLOAT_SCALAR = 2**64;
16 	uint256 constant private INITIAL_SUPPLY = 44e21; // 44.000 total Supply
17 	uint256 constant private BURN_RATE = 8; // 8% per tx
18 	uint256 constant private SUPPLY_FLOOR = 1; // 1% of 44k = 440
19 	uint256 constant private MIN_FREEZE_AMOUNT = 1e15; // 0.0001 minimum
20 
21 	string constant public name = "H4X";
22 	string constant public symbol = "H4X";
23 	uint8 constant public decimals = 18;
24 
25 	struct User {
26 		bool whitelisted;
27 		uint256 balance;
28 		uint256 frozen;
29 		uint256 dividends;
30 		mapping(address => uint256) allowance;
31 		int256 scaledPayout;
32 	}
33 
34 	struct Info {
35 		uint256 totalSupply;
36 		uint256 totalFrozen;
37 		uint256 dividends;
38 		mapping(address => User) users;
39 		uint256 scaledPayoutPerToken;
40 		address admin;
41 	}
42 	Info private info;
43 
44 
45 	event Transfer(address indexed from, address indexed to, uint256 tokens);
46 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
47 	event Whitelist(address indexed user, bool status);
48 	event Freeze(address indexed owner, uint256 tokens);
49 	event Unfreeze(address indexed owner, uint256 tokens);
50 	event Collect(address indexed owner, uint256 tokens);
51 	event Burn(uint256 tokens);
52 
53 
54 	constructor() public {
55 		info.admin = msg.sender;
56 		info.totalSupply = INITIAL_SUPPLY;
57 		info.users[msg.sender].balance = INITIAL_SUPPLY;
58 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
59 		whitelist(msg.sender, true);
60 	}
61 
62 	function freeze(uint256 _tokens) external {
63 		_freeze(_tokens);
64 	}
65 	
66 
67 
68 	function unfreeze(uint256 _tokens) external {
69 		_unfreeze(_tokens);
70 	}
71 
72 	function collect() external returns (uint256) {
73 		uint256 _dividends = dividendsOf(msg.sender);
74 		require(_dividends >= 0);
75 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
76 		info.users[msg.sender].balance += _dividends;
77 		emit Transfer(address(this), msg.sender, _dividends);
78 		emit Collect(msg.sender, _dividends);
79 		return _dividends;
80 	}
81 
82 	function burn(uint256 _tokens) external {
83 		require(balanceOf(msg.sender) >= _tokens);
84 		info.users[msg.sender].balance -= _tokens;
85 		uint256 _burnedAmount = _tokens;
86 		if (info.totalFrozen > 0) {
87 			_burnedAmount /= 2;
88 			info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
89 			emit Transfer(msg.sender, address(this), _burnedAmount);
90 		}
91 		info.totalSupply -= _burnedAmount;
92 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
93 		emit Burn(_burnedAmount);
94 	}
95 
96 	function distribute(uint256 _tokens) external {
97 		require(info.totalFrozen > 0);
98 		require(balanceOf(msg.sender) >= _tokens);
99 		info.users[msg.sender].balance -= _tokens;
100 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalFrozen;
101 		emit Transfer(msg.sender, address(this), _tokens);
102 	}
103 
104 	function transfer(address _to, uint256 _tokens) external returns (bool) {
105 		_transfer(msg.sender, _to, _tokens);
106 		return true;
107 	}
108 
109 	function approve(address _spender, uint256 _tokens) external returns (bool) {
110 		info.users[msg.sender].allowance[_spender] = _tokens;
111 		emit Approval(msg.sender, _spender, _tokens);
112 		return true;
113 	}
114 
115 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
116 		require(info.users[_from].allowance[msg.sender] >= _tokens);
117 		info.users[_from].allowance[msg.sender] -= _tokens;
118 		_transfer(_from, _to, _tokens);
119 		return true;
120 	}
121 
122 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
123 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
124 		uint32 _size;
125 		assembly {
126 			_size := extcodesize(_to)
127 		}
128 		if (_size > 0) {
129 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
130 		}
131 		return true;
132 	}
133 
134 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
135 		require(_receivers.length == _amounts.length);
136 		for (uint256 i = 0; i < _receivers.length; i++) {
137 			_transfer(msg.sender, _receivers[i], _amounts[i]);
138 		}
139 	}
140 
141 	function whitelist(address _user, bool _status) public {
142 		require(msg.sender == info.admin);
143 		info.users[_user].whitelisted = _status;
144 		emit Whitelist(_user, _status);
145 	}
146 
147 
148 	function totalSupply() public view returns (uint256) {
149 		return info.totalSupply;
150 	}
151 
152 	function totalFrozen() public view returns (uint256) {
153 		return info.totalFrozen;
154 	}
155 
156 	function balanceOf(address _user) public view returns (uint256) {
157 		return info.users[_user].balance - frozenOf(_user);
158 	}
159 
160 	function frozenOf(address _user) public view returns (uint256) {
161 		return info.users[_user].frozen;
162 	}
163 
164 	function dividendsOf(address _user) public view returns (uint256) {
165 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
166 	}
167 
168 	function allowance(address _user, address _spender) public view returns (uint256) {
169 		return info.users[_user].allowance[_spender];
170 	}
171 
172 	function isWhitelisted(address _user) public view returns (bool) {
173 		return info.users[_user].whitelisted;
174 	}
175 
176 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance, uint256 userFrozen, uint256 userDividends) {
177 		return (totalSupply(), totalFrozen(), balanceOf(_user), frozenOf(_user), dividendsOf(_user));
178 	}
179 
180 
181 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
182 		require(balanceOf(_from) >= _tokens);
183 		info.users[_from].balance -= _tokens;
184 		uint256 _burnedAmount = _tokens * BURN_RATE / 100;
185 		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 ) {
186 			_burnedAmount = 0;
187 		}
188 		uint256 _transferred = _tokens - _burnedAmount;
189 		info.users[_to].balance += _transferred;
190 		
191 		if (_burnedAmount > 0) {
192 			if (info.totalFrozen > 0) {
193 				_burnedAmount /= 2;
194 				info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
195 				emit Transfer(_from, address(this), _burnedAmount);
196 			}
197 			info.totalSupply -= _burnedAmount;
198 			emit Transfer(_from, address(0x0), _burnedAmount);
199 			emit Burn(_burnedAmount);
200 			emit Transfer(_from, _to, _transferred);
201 		}
202 		return _transferred;
203 	}
204 
205 
206 	function _freeze(uint256 _amount) internal {
207 		require(balanceOf(msg.sender) >= _amount);
208 		require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT);
209 		info.totalFrozen += _amount;
210 		info.users[msg.sender].frozen += _amount;
211 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
212 		emit Transfer(msg.sender, address(this), _amount);
213 		emit Freeze(msg.sender, _amount);
214 	}
215 
216 	function _unfreeze(uint256 _amount) internal {
217 		require(frozenOf(msg.sender) >= _amount);
218 		uint256 _burnedAmount = _amount * BURN_RATE / 100;
219 		info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
220 		info.totalFrozen -= _amount;
221 		info.users[msg.sender].balance -= _burnedAmount;
222 		info.users[msg.sender].frozen -= _amount;
223 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
224 		emit Transfer(address(this), msg.sender, _amount - _burnedAmount);
225 		emit Unfreeze(msg.sender, _amount);
226 	}
227 }