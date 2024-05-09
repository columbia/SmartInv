1 pragma solidity ^0.5.13;
2 
3 // UniDollar is the first experimental PoL+PoS token (Proof of Liquidity) + (Proof of Stake)
4 // https://t.me/unidollar
5 
6 interface Callable {
7 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
8 }
9 
10 contract UniDollar {
11 
12 	uint256 constant private FLOAT_SCALAR = 2**64;
13 	uint256 constant private INITIAL_SUPPLY = 125000000 * (10 ** 18); // 125 Million
14 	uint256 constant private XFER_FEE = 2; // 2% per tx
15 	uint256 constant private MIN_STAKE_AMOUNT = 2e22; // 20,000 Tokens Needed
16 
17 	string constant public name = "UniDollar";
18 	string constant public symbol = "UNIUSD";
19 	uint8 constant public decimals = 18;
20 
21 	struct User {
22 		
23 		uint256 balance;
24 		uint256 staked;
25 		mapping(address => uint256) allowance;
26 		int256 scaledPayout;
27 	}
28 
29 	struct Info {
30 		uint256 totalSupply;
31 		uint256 totalStaked;
32 		mapping(address => User) users;
33 		uint256 scaledPayoutPerToken;
34 		address admin;
35 	}
36 	Info private info;
37 
38 
39 	event Transfer(address indexed from, address indexed to, uint256 tokens);
40 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
41 	
42 	event Stake(address indexed owner, uint256 tokens);
43 	event Unstake(address indexed owner, uint256 tokens);
44 	event Collect(address indexed owner, uint256 tokens);
45 	event Tax(uint256 tokens);
46 
47 
48 	constructor() public {
49 		info.admin = msg.sender;
50 		info.totalSupply = INITIAL_SUPPLY;
51 		info.users[msg.sender].balance = INITIAL_SUPPLY;
52 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
53 		
54 	}
55 
56 	function stake(uint256 _tokens) external {
57 		_stake(_tokens);
58 	}
59 
60 	function unstake(uint256 _tokens) external {
61 		_unstake(_tokens);
62 	}
63 
64 	function collect() external returns (uint256) {
65 		uint256 _dividends = dividendsOf(msg.sender);
66 		require(_dividends >= 0);
67 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
68 		info.users[msg.sender].balance += _dividends;
69 		emit Transfer(address(this), msg.sender, _dividends);
70 		emit Collect(msg.sender, _dividends);
71 		return _dividends;
72 	}
73 
74 	function distribute(uint256 _tokens) external {
75 		require(info.totalStaked > 0);
76 		require(balanceOf(msg.sender) >= _tokens);
77 		info.users[msg.sender].balance -= _tokens;
78 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalStaked;
79 		emit Transfer(msg.sender, address(this), _tokens);
80 	}
81 
82 	function transfer(address _to, uint256 _tokens) external returns (bool) {
83 		_transfer(msg.sender, _to, _tokens);
84 		return true;
85 	}
86 
87 	function approve(address _spender, uint256 _tokens) external returns (bool) {
88 		info.users[msg.sender].allowance[_spender] = _tokens;
89 		emit Approval(msg.sender, _spender, _tokens);
90 		return true;
91 	}
92 
93 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
94 		require(info.users[_from].allowance[msg.sender] >= _tokens);
95 		info.users[_from].allowance[msg.sender] -= _tokens;
96 		_transfer(_from, _to, _tokens);
97 		return true;
98 	}
99 
100 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
101 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
102 		uint32 _size;
103 		assembly {
104 			_size := extcodesize(_to)
105 		}
106 		if (_size > 0) {
107 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
108 		}
109 		return true;
110 	}
111 
112 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
113 		require(_receivers.length == _amounts.length);
114 		for (uint256 i = 0; i < _receivers.length; i++) {
115 			_transfer(msg.sender, _receivers[i], _amounts[i]);
116 		}
117 	}
118 
119 
120 	function totalSupply() public view returns (uint256) {
121 		return info.totalSupply;
122 	}
123 
124 	function totalStaked() public view returns (uint256) {
125 		return info.totalStaked;
126 	}
127 
128 	function balanceOf(address _user) public view returns (uint256) {
129 		return info.users[_user].balance - stakedOf(_user);
130 	}
131 
132 	function stakedOf(address _user) public view returns (uint256) {
133 		return info.users[_user].staked;
134 	}
135 
136 	function dividendsOf(address _user) public view returns (uint256) {
137 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].staked) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
138 	}
139 
140 	function allowance(address _user, address _spender) public view returns (uint256) {
141 		return info.users[_user].allowance[_spender];
142 	}
143 
144 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensStaked, uint256 userBalance, uint256 userStaked, uint256 userDividends) {
145 		return (totalSupply(), totalStaked(), balanceOf(_user), stakedOf(_user), dividendsOf(_user));
146 	}
147 
148 
149 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
150 		require(balanceOf(_from) >= _tokens);
151 		info.users[_from].balance -= _tokens;
152 		uint256 _taxAmount = _tokens * XFER_FEE / 100;
153 		uint256 _transferred = _tokens - _taxAmount;
154         if (info.totalStaked > 0) {
155             info.users[_to].balance += _transferred;
156             emit Transfer(_from, _to, _transferred);
157             info.scaledPayoutPerToken += _taxAmount * FLOAT_SCALAR / info.totalStaked;
158             emit Transfer(_from, address(this), _taxAmount);
159             emit Tax(_taxAmount);
160             return _transferred;
161         } else {
162             info.users[_to].balance += _tokens;
163             emit Transfer(_from, _to, _tokens);
164             return _tokens;
165         }
166     }
167 
168 	function _stake(uint256 _amount) internal {
169 		require(balanceOf(msg.sender) >= _amount);
170 		require(stakedOf(msg.sender) + _amount >= MIN_STAKE_AMOUNT);
171 		info.totalStaked += _amount;
172 		info.users[msg.sender].staked += _amount;
173 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
174 		emit Transfer(msg.sender, address(this), _amount);
175 		emit Stake(msg.sender, _amount);
176 	}
177 
178 	function _unstake(uint256 _amount) internal {
179 		require(stakedOf(msg.sender) >= _amount);
180 		uint256 _taxAmount = _amount * XFER_FEE / 100;
181 		info.scaledPayoutPerToken += _taxAmount * FLOAT_SCALAR / info.totalStaked;
182 		info.totalStaked -= _amount;
183 		info.users[msg.sender].balance -= _taxAmount;
184 		info.users[msg.sender].staked -= _amount;
185 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
186 		emit Transfer(address(this), msg.sender, _amount - _taxAmount);
187 		emit Unstake(msg.sender, _amount);
188 	}
189 }