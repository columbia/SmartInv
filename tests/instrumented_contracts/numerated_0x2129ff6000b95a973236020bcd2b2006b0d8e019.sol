1 /**
2  * Official Site: https://myx.network
3  * Telegram: https://t.me/myxnetwork
4  * Twitter: https://twitter.com/myxnetwork
5  * Copyright 2020 MYX Network All Rights Reserved.
6  * No alteration, reproduction or replication of this contract without prior written consent from MYX Network
7 */
8 
9 pragma solidity ^0.5.13;
10 
11 interface Callable {
12 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
13 }
14 
15 contract MYXNetwork {
16 
17 	uint256 constant private FLOAT_SCALAR = 2**64;
18 	uint256 constant private INITIAL_SUPPLY = 1e27; // 1B
19 	uint256 constant private BURN_RATE = 5; // 5% per tx
20 	uint256 constant private SUPPLY_FLOOR = 10; // 10% of 1B = 100M
21 	uint256 constant private MIN_FREEZE_AMOUNT = 1e20; // 100
22 
23 	string constant public name = "MYX Network";
24 	string constant public symbol = "MYX";
25 	uint8 constant public decimals = 18;
26 
27 	struct User {
28 		bool whitelisted;
29 		uint256 balance;
30 		uint256 frozen;
31 		mapping(address => uint256) allowance;
32 		int256 scaledPayout;
33 	}
34 
35 	struct Info {
36 		uint256 totalSupply;
37 		uint256 totalFrozen;
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
66 	function unfreeze(uint256 _tokens) external {
67 		_unfreeze(_tokens);
68 	}
69 
70 	function collect() external returns (uint256) {
71 		uint256 _dividends = dividendsOf(msg.sender);
72 		require(_dividends >= 0);
73 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
74 		info.users[msg.sender].balance += _dividends;
75 		emit Transfer(address(this), msg.sender, _dividends);
76 		emit Collect(msg.sender, _dividends);
77 		return _dividends;
78 	}
79 
80 	function burn(uint256 _tokens) external {
81 		require(balanceOf(msg.sender) >= _tokens);
82 		info.users[msg.sender].balance -= _tokens;
83 		uint256 _burnedAmount = _tokens;
84 		if (info.totalFrozen > 0) {
85 			_burnedAmount /= 2;
86 			info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
87 			emit Transfer(msg.sender, address(this), _burnedAmount);
88 		}
89 		info.totalSupply -= _burnedAmount;
90 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
91 		emit Burn(_burnedAmount);
92 	}
93 
94 	function distribute(uint256 _tokens) external {
95 		require(info.totalFrozen > 0);
96 		require(balanceOf(msg.sender) >= _tokens);
97 		info.users[msg.sender].balance -= _tokens;
98 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalFrozen;
99 		emit Transfer(msg.sender, address(this), _tokens);
100 	}
101 
102 	function transfer(address _to, uint256 _tokens) external returns (bool) {
103 		_transfer(msg.sender, _to, _tokens);
104 		return true;
105 	}
106 
107 	function approve(address _spender, uint256 _tokens) external returns (bool) {
108 		info.users[msg.sender].allowance[_spender] = _tokens;
109 		emit Approval(msg.sender, _spender, _tokens);
110 		return true;
111 	}
112 
113 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
114 		require(info.users[_from].allowance[msg.sender] >= _tokens);
115 		info.users[_from].allowance[msg.sender] -= _tokens;
116 		_transfer(_from, _to, _tokens);
117 		return true;
118 	}
119 
120 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
121 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
122 		uint32 _size;
123 		assembly {
124 			_size := extcodesize(_to)
125 		}
126 		if (_size > 0) {
127 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
128 		}
129 		return true;
130 	}
131 
132 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
133 		require(_receivers.length == _amounts.length);
134 		for (uint256 i = 0; i < _receivers.length; i++) {
135 			_transfer(msg.sender, _receivers[i], _amounts[i]);
136 		}
137 	}
138 
139 	function whitelist(address _user, bool _status) public {
140 		require(msg.sender == info.admin);
141 		info.users[_user].whitelisted = _status;
142 		emit Whitelist(_user, _status);
143 	}
144 
145 
146 	function totalSupply() public view returns (uint256) {
147 		return info.totalSupply;
148 	}
149 
150 	function totalFrozen() public view returns (uint256) {
151 		return info.totalFrozen;
152 	}
153 
154 	function balanceOf(address _user) public view returns (uint256) {
155 		return info.users[_user].balance - frozenOf(_user);
156 	}
157 
158 	function frozenOf(address _user) public view returns (uint256) {
159 		return info.users[_user].frozen;
160 	}
161 
162 	function dividendsOf(address _user) public view returns (uint256) {
163 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
164 	}
165 
166 	function allowance(address _user, address _spender) public view returns (uint256) {
167 		return info.users[_user].allowance[_spender];
168 	}
169 
170 	function isWhitelisted(address _user) public view returns (bool) {
171 		return info.users[_user].whitelisted;
172 	}
173 
174 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance, uint256 userFrozen, uint256 userDividends) {
175 		return (totalSupply(), totalFrozen(), balanceOf(_user), frozenOf(_user), dividendsOf(_user));
176 	}
177 
178 
179 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
180 		require(balanceOf(_from) >= _tokens);
181 		info.users[_from].balance -= _tokens;
182 		uint256 _burnedAmount = _tokens * BURN_RATE / 100;
183 		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 || isWhitelisted(_from)) {
184 			_burnedAmount = 0;
185 		}
186 		uint256 _transferred = _tokens - _burnedAmount;
187 		info.users[_to].balance += _transferred;
188 		emit Transfer(_from, _to, _transferred);
189 		if (_burnedAmount > 0) {
190 			if (info.totalFrozen > 0) {
191 				_burnedAmount /= 2;
192 				info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
193 				emit Transfer(_from, address(this), _burnedAmount);
194 			}
195 			info.totalSupply -= _burnedAmount;
196 			emit Transfer(_from, address(0x0), _burnedAmount);
197 			emit Burn(_burnedAmount);
198 		}
199 		return _transferred;
200 	}
201 
202 	function _freeze(uint256 _amount) internal {
203 		require(balanceOf(msg.sender) >= _amount);
204 		require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT);
205 		info.totalFrozen += _amount;
206 		info.users[msg.sender].frozen += _amount;
207 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
208 		emit Transfer(msg.sender, address(this), _amount);
209 		emit Freeze(msg.sender, _amount);
210 	}
211 
212 	function _unfreeze(uint256 _amount) internal {
213 		require(frozenOf(msg.sender) >= _amount);
214 		uint256 _burnedAmount = _amount * BURN_RATE / 100;
215 		info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
216 		info.totalFrozen -= _amount;
217 		info.users[msg.sender].balance -= _burnedAmount;
218 		info.users[msg.sender].frozen -= _amount;
219 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
220 		emit Transfer(address(this), msg.sender, _amount - _burnedAmount);
221 		emit Unfreeze(msg.sender, _amount);
222 	}
223 }