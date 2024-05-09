1 pragma solidity ^0.5.17;
2 
3 interface Callable {
4 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
5 }
6 
7 contract HEXULTRA {
8 	string constant public name = "HEXULTRA";
9 	string constant public symbol = "HEXULTRA";
10 	uint256 constant private FLOAT_SCALAR = 2**64;
11 	uint256 constant private INITIAL_SUPPLY = 3e26; // 
12 	uint256 constant private BURN_RATE = 15; // 15% per tx
13 	uint256 constant private SUPPLY_FLOOR = 1; // 1% of 300M = 3M
14 	uint256 constant private MIN_FREEZE_AMOUNT = 1e20; // 100 minimum
15 	uint8 constant public decimals = 18;
16 	event Transfer(address indexed from, address indexed to, uint256 tokens);
17 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
18 	event Whitelist(address indexed user, bool status);
19 	event Stake(address indexed owner, uint256 tokens);
20 	event Burn(uint256 tokens);
21 	event Unstake(address indexed owner, uint256 tokens);
22 	event Yield(address indexed owner, uint256 tokens);
23 	struct User {
24 		bool whitelisted;
25 		uint256 balance;
26 		uint256 frozen;
27 		mapping(address => uint256) allowance;
28 		int256 scaledPayout;
29 	}
30 	struct Info {
31 		uint256 totalSupply;
32 		uint256 totalFrozen;
33 		mapping(address => User) users;
34 		uint256 scaledPayoutPerToken;
35 		address admin;
36 	}
37 	Info private info;
38 
39 	constructor() public {
40 		info.admin = msg.sender;
41 		info.totalSupply = INITIAL_SUPPLY;
42 		info.users[msg.sender].balance = INITIAL_SUPPLY;
43 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
44 		whitelist(msg.sender, true);
45 	}
46 
47 	function yield() external returns (uint256) {
48 		uint256 _dividends = dividendsOf(msg.sender);
49 		require(_dividends >= 0);
50 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
51 		info.users[msg.sender].balance += _dividends;
52 		emit Transfer(address(this), msg.sender, _dividends);
53 		emit Yield(msg.sender, _dividends);
54 		return _dividends;
55 	}
56 
57 	function burn(uint256 _tokens) external {
58 		require(balanceOf(msg.sender) >= _tokens);
59 		info.users[msg.sender].balance -= _tokens;
60 		uint256 _burnedAmount = _tokens;
61 		if (info.totalFrozen > 0) {
62 			_burnedAmount /= 2;
63 			info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
64 			emit Transfer(msg.sender, address(this), _burnedAmount);
65 		}
66 		info.totalSupply -= _burnedAmount;
67 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
68 		emit Burn(_burnedAmount);
69 	}
70 
71 	function distribute(uint256 _tokens) external {
72 		require(info.totalFrozen > 0);
73 		require(balanceOf(msg.sender) >= _tokens);
74 		info.users[msg.sender].balance -= _tokens;
75 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalFrozen;
76 		emit Transfer(msg.sender, address(this), _tokens);
77 	}
78 
79 	function transfer(address _to, uint256 _tokens) external returns (bool) {
80 		_transfer(msg.sender, _to, _tokens);
81 		return true;
82 	}
83 
84 	function approve(address _spender, uint256 _tokens) external returns (bool) {
85 		info.users[msg.sender].allowance[_spender] = _tokens;
86 		emit Approval(msg.sender, _spender, _tokens);
87 		return true;
88 	}
89 
90 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
91 		require(info.users[_from].allowance[msg.sender] >= _tokens);
92 		info.users[_from].allowance[msg.sender] -= _tokens;
93 		_transfer(_from, _to, _tokens);
94 		return true;
95 	}
96 
97 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
98 		require(_receivers.length == _amounts.length);
99 		for (uint256 i = 0; i < _receivers.length; i++) {
100 			_transfer(msg.sender, _receivers[i], _amounts[i]);
101 		}
102 	}
103 
104 	function whitelist(address _user, bool _status) public {
105 		require(msg.sender == info.admin);
106 		info.users[_user].whitelisted = _status;
107 		emit Whitelist(_user, _status);
108 	}
109 
110 
111 	function totalSupply() public view returns (uint256) {
112 		return info.totalSupply;
113 	}
114 
115 	function totalFrozen() public view returns (uint256) {
116 		return info.totalFrozen;
117 	}
118 
119 	function balanceOf(address _user) public view returns (uint256) {
120 		return info.users[_user].balance - frozenOf(_user);
121 	}
122 
123 	function frozenOf(address _user) public view returns (uint256) {
124 		return info.users[_user].frozen;
125 	}
126 
127 	function dividendsOf(address _user) public view returns (uint256) {
128 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
129 	}
130 
131 	function allowance(address _user, address _spender) public view returns (uint256) {
132 		return info.users[_user].allowance[_spender];
133 	}
134 
135 	function isWhitelisted(address _user) public view returns (bool) {
136 		return info.users[_user].whitelisted;
137 	}
138 
139 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance, uint256 userFrozen, uint256 userDividends) {
140 		return (totalSupply(), totalFrozen(), balanceOf(_user), frozenOf(_user), dividendsOf(_user));
141 	}
142 
143 
144 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
145 		require(balanceOf(_from) >= _tokens);
146 		info.users[_from].balance -= _tokens;
147 		uint256 _burnedAmount = _tokens * BURN_RATE / 100;
148 		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 || isWhitelisted(_from)) {
149 			_burnedAmount = 0;
150 		}
151 		uint256 _transferred = _tokens - _burnedAmount;
152 		info.users[_to].balance += _transferred;
153 		emit Transfer(_from, _to, _transferred);
154 		if (_burnedAmount > 0) {
155 			if (info.totalFrozen > 0) {
156 				_burnedAmount /= 2;
157 				info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
158 				emit Transfer(_from, address(this), _burnedAmount);
159 			}
160 			info.totalSupply -= _burnedAmount;
161 			emit Transfer(_from, address(0x0), _burnedAmount);
162 			emit Burn(_burnedAmount);
163 		}
164 		return _transferred;
165 	}
166 
167 	function stakeInt(uint256 _amount) internal {
168 		require(balanceOf(msg.sender) >= _amount);
169 		require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT);
170 		info.totalFrozen += _amount;
171 		info.users[msg.sender].frozen += _amount;
172 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
173 		emit Transfer(msg.sender, address(this), _amount);
174 		emit Stake(msg.sender, _amount);
175 	}
176 
177 	function unstakeInt(uint256 _amount) internal {
178 		require(frozenOf(msg.sender) >= _amount);
179 		uint256 _burnedAmount = _amount * BURN_RATE / 100;
180 		info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
181 		info.totalFrozen -= _amount;
182 		info.users[msg.sender].balance -= _burnedAmount;
183 		info.users[msg.sender].frozen -= _amount;
184 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
185 		emit Transfer(address(this), msg.sender, _amount - _burnedAmount);
186 		emit Unstake(msg.sender, _amount);
187 	}
188 	
189 	function stake(uint256 amount) external {
190 		stakeInt(amount);
191 	}
192 
193 	function unstake(uint256 amount) external {
194 		unstakeInt(amount);
195 	}
196 }