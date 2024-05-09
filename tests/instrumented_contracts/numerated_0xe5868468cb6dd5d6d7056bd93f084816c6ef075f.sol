1 
2 pragma solidity ^0.5.13;
3 
4 interface Callable {
5 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
6 }
7 
8 contract PoorFag {
9 
10 	uint256 constant private FLOAT_SCALAR = 2**64;
11 	uint256 constant private INITIAL_SUPPLY = 1000000e18; // 1M
12 	uint256 constant private STAKE_FEE = 2; // 2% per tx
13 	uint256 constant private MIN_STAKE_AMOUNT = 1e19; // 10
14 
15 	string constant public name = "PoorFag";
16 	string constant public symbol = "FAG";
17 	uint8 constant public decimals = 18;
18 
19 	struct User {
20 		bool whitelisted;
21 		uint256 balance;
22 		uint256 staked;
23 		mapping(address => uint256) allowance;
24 		int256 scaledPayout;
25 	}
26 
27 	struct Info {
28 		uint256 totalSupply;
29 		uint256 totalStaked;
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
40 	event Stake(address indexed owner, uint256 tokens);
41 	event Unstake(address indexed owner, uint256 tokens);
42 	event Collect(address indexed owner, uint256 tokens);
43 	event Fee(uint256 tokens);
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
54 	function stake(uint256 _tokens) external {
55 		_stake(_tokens);
56 	}
57 
58 	function unstake(uint256 _tokens) external {
59 		_unstake(_tokens);
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
72     function stakeDrop(uint256 _tokens) external {
73 		require(balanceOf(msg.sender) >= _tokens);
74 		uint256 _droppedAmount = _tokens;
75         info.users[msg.sender].balance -= _tokens;
76 		if (info.totalStaked > 0) {
77 			info.scaledPayoutPerToken += _droppedAmount * FLOAT_SCALAR / info.totalStaked;
78 			emit Transfer(msg.sender, address(this), _droppedAmount);
79             emit Fee(_droppedAmount);
80 		}else{
81             revert();
82         }
83 	}
84 
85 	function distribute(uint256 _tokens) external {
86 		require(info.totalStaked > 0);
87 		require(balanceOf(msg.sender) >= _tokens);
88 		info.users[msg.sender].balance -= _tokens;
89 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalStaked;
90 		emit Transfer(msg.sender, address(this), _tokens);
91 	}
92 
93 	function transfer(address _to, uint256 _tokens) external returns (bool) {
94 		_transfer(msg.sender, _to, _tokens);
95 		return true;
96 	}
97 
98 	function approve(address _spender, uint256 _tokens) external returns (bool) {
99 		info.users[msg.sender].allowance[_spender] = _tokens;
100 		emit Approval(msg.sender, _spender, _tokens);
101 		return true;
102 	}
103 
104 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
105 		require(info.users[_from].allowance[msg.sender] >= _tokens);
106 		info.users[_from].allowance[msg.sender] -= _tokens;
107 		_transfer(_from, _to, _tokens);
108 		return true;
109 	}
110 
111 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
112 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
113 		uint32 _size;
114 		assembly {
115 			_size := extcodesize(_to)
116 		}
117 		if (_size > 0) {
118 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
119 		}
120 		return true;
121 	}
122 
123 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
124 		require(_receivers.length == _amounts.length);
125 		for (uint256 i = 0; i < _receivers.length; i++) {
126 			_transfer(msg.sender, _receivers[i], _amounts[i]);
127 		}
128 	}
129 
130 	function whitelist(address _user, bool _status) public {
131 		require(msg.sender == info.admin);
132 		info.users[_user].whitelisted = _status;
133 		emit Whitelist(_user, _status);
134 	}
135 
136 
137 	function totalSupply() public view returns (uint256) {
138 		return info.totalSupply;
139 	}
140 
141 	function totalStaked() public view returns (uint256) {
142 		return info.totalStaked;
143 	}
144 
145 	function balanceOf(address _user) public view returns (uint256) {
146 		return info.users[_user].balance - stakedOf(_user);
147 	}
148 
149 	function stakedOf(address _user) public view returns (uint256) {
150 		return info.users[_user].staked;
151 	}
152 
153 	function dividendsOf(address _user) public view returns (uint256) {
154 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].staked) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
155 	}
156 
157 	function allowance(address _user, address _spender) public view returns (uint256) {
158 		return info.users[_user].allowance[_spender];
159 	}
160 
161 	function isWhitelisted(address _user) public view returns (bool) {
162 		return info.users[_user].whitelisted;
163 	}
164 
165 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensStaked, uint256 userBalance, uint256 userStaked, uint256 userDividends) {
166 		return (totalSupply(), totalStaked(), balanceOf(_user), stakedOf(_user), dividendsOf(_user));
167 	}
168 
169     function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
170 		require(balanceOf(_from) >= _tokens);
171 		info.users[_from].balance -= _tokens;
172         uint256 _feeAmount = _tokens * STAKE_FEE / 100;
173         uint256 _transferred = _tokens - _feeAmount;
174         if (info.totalStaked > 0) {
175             info.users[_to].balance += _transferred;
176             emit Transfer(_from, _to, _transferred);
177             info.scaledPayoutPerToken += _feeAmount * FLOAT_SCALAR / info.totalStaked;
178             emit Transfer(_from, address(this), _feeAmount);
179             emit Fee(_feeAmount);
180             return _transferred;
181         }else {
182             info.users[_to].balance += _tokens;
183             emit Transfer(_from, _to, _tokens);
184             return _tokens;
185         }
186     }
187 
188 	function _stake(uint256 _amount) internal {
189 		require(balanceOf(msg.sender) >= _amount);
190 		require(stakedOf(msg.sender) + _amount >= MIN_STAKE_AMOUNT);
191 		info.totalStaked += _amount;
192 		info.users[msg.sender].staked += _amount;
193 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
194 		emit Transfer(msg.sender, address(this), _amount);
195 		emit Stake(msg.sender, _amount);
196 	}
197 
198     function _unstake(uint256 _amount) internal {
199 		require(stakedOf(msg.sender) >= _amount);
200 		uint256 _feeAmount = _amount * 5 / 100;
201 		info.scaledPayoutPerToken += _feeAmount * FLOAT_SCALAR / info.totalStaked;
202 		info.totalStaked -= _amount;
203 		info.users[msg.sender].balance -= _feeAmount;
204 		info.users[msg.sender].staked -= _amount;
205 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
206 		emit Transfer(address(this), msg.sender, _amount - _feeAmount);
207 		emit Unstake(msg.sender, _amount);
208 	}
209 }
