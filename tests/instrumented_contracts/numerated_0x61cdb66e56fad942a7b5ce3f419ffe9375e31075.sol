1 // -- 1% Tax on EVERY token transfer
2 // -- 1,000 Token Staking Minimum
3 // -- 1% tax distributed to ALL stakers proportiontally
4 // -- https://rainnetwork.github.io
5 // -- Discord: https://discord.gg/WNDCMVr
6 
7 pragma solidity ^0.5.13;
8 
9 interface Callable {
10 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
11 }
12 
13 contract RainNetwork {
14 
15 	uint256 constant private FLOAT_SCALAR = 2**64;
16 	uint256 constant private INITIAL_SUPPLY = 1000000000 * (10 ** 18); // 1 Billion
17 	uint256 constant private XFER_FEE = 1; // 1% per tx
18 	uint256 constant private MIN_STAKE_AMOUNT = 1e21; // 1,000 Tokens Needed
19 
20 	string constant public name = "RAIN Network";
21 	string constant public symbol = "RAIN";
22 	uint8 constant public decimals = 18;
23 
24 	struct User {
25 		
26 		uint256 balance;
27 		uint256 staked;
28 		mapping(address => uint256) allowance;
29 		int256 scaledPayout;
30 	}
31 
32 	struct Info {
33 		uint256 totalSupply;
34 		uint256 totalStaked;
35 		mapping(address => User) users;
36 		uint256 scaledPayoutPerToken;
37 		address admin;
38 	}
39 	Info private info;
40 
41 
42 	event Transfer(address indexed from, address indexed to, uint256 tokens);
43 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
44 	
45 	event Stake(address indexed owner, uint256 tokens);
46 	event Unstake(address indexed owner, uint256 tokens);
47 	event Collect(address indexed owner, uint256 tokens);
48 	event Tax(uint256 tokens);
49 
50 
51 	constructor() public {
52 		info.admin = msg.sender;
53 		info.totalSupply = INITIAL_SUPPLY;
54 		info.users[msg.sender].balance = INITIAL_SUPPLY;
55 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
56 		
57 	}
58 
59 	function stake(uint256 _tokens) external {
60 		_stake(_tokens);
61 	}
62 
63 	function unstake(uint256 _tokens) external {
64 		_unstake(_tokens);
65 	}
66 
67 	function collect() external returns (uint256) {
68 		uint256 _dividends = dividendsOf(msg.sender);
69 		require(_dividends >= 0);
70 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
71 		info.users[msg.sender].balance += _dividends;
72 		emit Transfer(address(this), msg.sender, _dividends);
73 		emit Collect(msg.sender, _dividends);
74 		return _dividends;
75 	}
76 
77 	function distribute(uint256 _tokens) external {
78 		require(info.totalStaked > 0);
79 		require(balanceOf(msg.sender) >= _tokens);
80 		info.users[msg.sender].balance -= _tokens;
81 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalStaked;
82 		emit Transfer(msg.sender, address(this), _tokens);
83 	}
84 
85 	function transfer(address _to, uint256 _tokens) external returns (bool) {
86 		_transfer(msg.sender, _to, _tokens);
87 		return true;
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
99 		_transfer(_from, _to, _tokens);
100 		return true;
101 	}
102 
103 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
104 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
105 		uint32 _size;
106 		assembly {
107 			_size := extcodesize(_to)
108 		}
109 		if (_size > 0) {
110 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
111 		}
112 		return true;
113 	}
114 
115 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
116 		require(_receivers.length == _amounts.length);
117 		for (uint256 i = 0; i < _receivers.length; i++) {
118 			_transfer(msg.sender, _receivers[i], _amounts[i]);
119 		}
120 	}
121 
122 
123 	function totalSupply() public view returns (uint256) {
124 		return info.totalSupply;
125 	}
126 
127 	function totalStaked() public view returns (uint256) {
128 		return info.totalStaked;
129 	}
130 
131 	function balanceOf(address _user) public view returns (uint256) {
132 		return info.users[_user].balance - stakedOf(_user);
133 	}
134 
135 	function stakedOf(address _user) public view returns (uint256) {
136 		return info.users[_user].staked;
137 	}
138 
139 	function dividendsOf(address _user) public view returns (uint256) {
140 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].staked) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
141 	}
142 
143 	function allowance(address _user, address _spender) public view returns (uint256) {
144 		return info.users[_user].allowance[_spender];
145 	}
146 
147 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensStaked, uint256 userBalance, uint256 userStaked, uint256 userDividends) {
148 		return (totalSupply(), totalStaked(), balanceOf(_user), stakedOf(_user), dividendsOf(_user));
149 	}
150 
151 
152 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
153 		require(balanceOf(_from) >= _tokens);
154 		info.users[_from].balance -= _tokens;
155 		uint256 _taxAmount = _tokens * XFER_FEE / 100;
156 		uint256 _transferred = _tokens - _taxAmount;
157         if (info.totalStaked > 0) {
158             info.users[_to].balance += _transferred;
159             emit Transfer(_from, _to, _transferred);
160             info.scaledPayoutPerToken += _taxAmount * FLOAT_SCALAR / info.totalStaked;
161             emit Transfer(_from, address(this), _taxAmount);
162             emit Tax(_taxAmount);
163             return _transferred;
164         } else {
165             info.users[_to].balance += _tokens;
166             emit Transfer(_from, _to, _tokens);
167             return _tokens;
168         }
169     }
170 
171 	function _stake(uint256 _amount) internal {
172 		require(balanceOf(msg.sender) >= _amount);
173 		require(stakedOf(msg.sender) + _amount >= MIN_STAKE_AMOUNT);
174 		info.totalStaked += _amount;
175 		info.users[msg.sender].staked += _amount;
176 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
177 		emit Transfer(msg.sender, address(this), _amount);
178 		emit Stake(msg.sender, _amount);
179 	}
180 
181 	function _unstake(uint256 _amount) internal {
182 		require(stakedOf(msg.sender) >= _amount);
183 		uint256 _taxAmount = _amount * XFER_FEE / 100;
184 		info.scaledPayoutPerToken += _taxAmount * FLOAT_SCALAR / info.totalStaked;
185 		info.totalStaked -= _amount;
186 		info.users[msg.sender].balance -= _taxAmount;
187 		info.users[msg.sender].staked -= _amount;
188 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
189 		emit Transfer(address(this), msg.sender, _amount - _taxAmount);
190 		emit Unstake(msg.sender, _amount);
191 	}
192 }