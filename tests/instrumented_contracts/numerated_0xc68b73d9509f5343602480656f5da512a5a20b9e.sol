1 pragma solidity ^0.5.13;
2 
3 interface Callable {
4 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
5 }
6 
7 contract Acid {
8 
9 	uint256 constant private FLOAT_SCALAR = 2**64;
10 	uint256 constant private INITIAL_SUPPLY = 77e22; // 770k
11 	uint256 constant private STAKE_FEE = 2; // 1% per tx
12 	uint256 constant private MIN_STAKE_AMOUNT = 1e19; // 10
13 
14 	string constant public name = "ACIDTOKEN";
15 	string constant public symbol = "ACID";
16 	uint8 constant public decimals = 18;
17 
18 	struct User {
19 		bool whitelisted;
20 		uint256 balance;
21 		uint256 staked;
22 		mapping(address => uint256) allowance;
23 		int256 scaledPayout;
24 	}
25 
26 	struct Info {
27 		uint256 totalSupply;
28 		uint256 totalStaked;
29 		mapping(address => User) users;
30 		uint256 scaledPayoutPerToken;
31 		address admin;
32 	}
33 	Info private info;
34 
35 
36 	event Transfer(address indexed from, address indexed to, uint256 tokens);
37 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
38 	event Whitelist(address indexed user, bool status);
39 	event Stake(address indexed owner, uint256 tokens);
40 	event Unstake(address indexed owner, uint256 tokens);
41 	event Collect(address indexed owner, uint256 tokens);
42 	event Fee(uint256 tokens);
43 
44 
45 	constructor() public {
46 		info.admin = msg.sender;
47 		info.totalSupply = INITIAL_SUPPLY;
48 		info.users[msg.sender].balance = INITIAL_SUPPLY;
49 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
50 		whitelist(msg.sender, true);
51 	}
52 
53 	function stake(uint256 _tokens) external {
54 		_stake(_tokens);
55 	}
56 
57 	function unstake(uint256 _tokens) external {
58 		_unstake(_tokens);
59 	}
60 
61 	function collect() external returns (uint256) {
62 		uint256 _dividends = dividendsOf(msg.sender);
63 		require(_dividends >= 0);
64 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
65 		info.users[msg.sender].balance += _dividends;
66 		emit Transfer(address(this), msg.sender, _dividends);
67 		emit Collect(msg.sender, _dividends);
68 		return _dividends;
69 	}
70 
71     function stakeDrop(uint256 _tokens) external {
72 		require(balanceOf(msg.sender) >= _tokens);
73 		uint256 _droppedAmount = _tokens;
74         info.users[msg.sender].balance -= _tokens;
75 		if (info.totalStaked > 0) {
76 			info.scaledPayoutPerToken += _droppedAmount * FLOAT_SCALAR / info.totalStaked;
77 			emit Transfer(msg.sender, address(this), _droppedAmount);
78             emit Fee(_droppedAmount);
79 		}else{
80             revert();
81         }
82 	}
83 
84 	function distribute(uint256 _tokens) external {
85 		require(info.totalStaked > 0);
86 		require(balanceOf(msg.sender) >= _tokens);
87 		info.users[msg.sender].balance -= _tokens;
88 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalStaked;
89 		emit Transfer(msg.sender, address(this), _tokens);
90 	}
91 
92 	function transfer(address _to, uint256 _tokens) external returns (bool) {
93 		_transfer(msg.sender, _to, _tokens);
94 		return true;
95 	}
96 
97 	function approve(address _spender, uint256 _tokens) external returns (bool) {
98 		info.users[msg.sender].allowance[_spender] = _tokens;
99 		emit Approval(msg.sender, _spender, _tokens);
100 		return true;
101 	}
102 
103 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
104 		require(info.users[_from].allowance[msg.sender] >= _tokens);
105 		info.users[_from].allowance[msg.sender] -= _tokens;
106 		_transfer(_from, _to, _tokens);
107 		return true;
108 	}
109 
110 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
111 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
112 		uint32 _size;
113 		assembly {
114 			_size := extcodesize(_to)
115 		}
116 		if (_size > 0) {
117 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
118 		}
119 		return true;
120 	}
121 
122 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
123 		require(_receivers.length == _amounts.length);
124 		for (uint256 i = 0; i < _receivers.length; i++) {
125 			_transfer(msg.sender, _receivers[i], _amounts[i]);
126 		}
127 	}
128 
129 	function whitelist(address _user, bool _status) public {
130 		require(msg.sender == info.admin);
131 		info.users[_user].whitelisted = _status;
132 		emit Whitelist(_user, _status);
133 	}
134 
135 
136 	function totalSupply() public view returns (uint256) {
137 		return info.totalSupply;
138 	}
139 
140 	function totalStaked() public view returns (uint256) {
141 		return info.totalStaked;
142 	}
143 
144 	function balanceOf(address _user) public view returns (uint256) {
145 		return info.users[_user].balance - stakedOf(_user);
146 	}
147 
148 	function stakedOf(address _user) public view returns (uint256) {
149 		return info.users[_user].staked;
150 	}
151 
152 	function dividendsOf(address _user) public view returns (uint256) {
153 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].staked) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
154 	}
155 
156 	function allowance(address _user, address _spender) public view returns (uint256) {
157 		return info.users[_user].allowance[_spender];
158 	}
159 
160 	function isWhitelisted(address _user) public view returns (bool) {
161 		return info.users[_user].whitelisted;
162 	}
163 
164 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensStaked, uint256 userBalance, uint256 userStaked, uint256 userDividends) {
165 		return (totalSupply(), totalStaked(), balanceOf(_user), stakedOf(_user), dividendsOf(_user));
166 	}
167 
168     function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
169 		require(balanceOf(_from) >= _tokens);
170 		info.users[_from].balance -= _tokens;
171         uint256 _feeAmount = _tokens * STAKE_FEE / 100;
172         uint256 _transferred = _tokens - _feeAmount;
173         if (info.totalStaked > 0) {
174             info.users[_to].balance += _transferred;
175             emit Transfer(_from, _to, _transferred);
176             info.scaledPayoutPerToken += _feeAmount * FLOAT_SCALAR / info.totalStaked;
177             emit Transfer(_from, address(this), _feeAmount);
178             emit Fee(_feeAmount);
179             return _transferred;
180         }else {
181             info.users[_to].balance += _tokens;
182             emit Transfer(_from, _to, _tokens);
183             return _tokens;
184         }
185     }
186 
187 	function _stake(uint256 _amount) internal {
188 		require(balanceOf(msg.sender) >= _amount);
189 		require(stakedOf(msg.sender) + _amount >= MIN_STAKE_AMOUNT);
190 		info.totalStaked += _amount;
191 		info.users[msg.sender].staked += _amount;
192 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
193 		emit Transfer(msg.sender, address(this), _amount);
194 		emit Stake(msg.sender, _amount);
195 	}
196 
197     function _unstake(uint256 _amount) internal {
198 		require(stakedOf(msg.sender) >= _amount);
199 		uint256 _feeAmount = _amount * 10 / 100;
200 		info.scaledPayoutPerToken += _feeAmount * FLOAT_SCALAR / info.totalStaked;
201 		info.totalStaked -= _amount;
202 		info.users[msg.sender].balance -= _feeAmount;
203 		info.users[msg.sender].staked -= _amount;
204 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
205 		emit Transfer(address(this), msg.sender, _amount - _feeAmount);
206 		emit Unstake(msg.sender, _amount);
207 	}
208 }