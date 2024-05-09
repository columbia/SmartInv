1 pragma solidity ^0.5.13;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      *
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      *
29      * - Subtraction cannot overflow.
30      */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      *
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      *
86      * - The divisor cannot be zero.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112 }
113 
114 interface Callable {
115 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
116 }
117 
118 contract BDAONetwork {
119     
120     using SafeMath for uint256;
121 	uint256 constant private FLOAT_SCALAR = 2**64;
122 	uint256 constant private INITIAL_SUPPLY = 30000000e18;
123 	uint256 constant private XFER_FEE = 5; // 5% per tx
124 	uint256 constant private POOL_FEE = 4; // 4% to pool
125 	uint256 constant private DEV_FEE = 1;  // 1% to dev
126 	uint256 constant private SHARE_DIVIDENDS = 25;  // 25% every collect
127 	uint256 constant private MIN_STAKE_AMOUNT = 1e21; // 1,000 Tokens Needed
128 
129 	string constant public name = "BDAO Network";
130 	string constant public symbol = "BDAO";
131 	uint8 constant public decimals = 18;
132 
133 	struct User {
134 		
135 		uint256 balance;
136 		uint256 staked;
137 		mapping(address => uint256) allowance;
138 		uint collectTime;
139 		uint unstakeTime;
140 		int256 scaledPayout;
141 	}
142 
143 	struct Info {
144 		uint256 totalSupply;
145 		uint256 totalStaked;
146 		uint256 totalStake;
147 		mapping(address => User) users;
148 		uint256 scaledPayoutPerToken;
149 		address admin;
150 	}
151 	Info private info;
152 
153 
154 	event Transfer(address indexed from, address indexed to, uint256 tokens);
155 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
156 	
157 	event Stake(address indexed owner, uint256 tokens);
158 	event Unstake(address indexed owner, uint256 tokens);
159 	event Collect(address indexed owner, uint256 tokens);
160 	event Tax(uint256 tokens);
161 
162 
163 	constructor() public {
164 		info.admin = msg.sender;
165 		info.totalSupply = INITIAL_SUPPLY;
166 		info.users[msg.sender].balance = INITIAL_SUPPLY;
167 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
168 		
169 	}
170 
171 	function stake(uint256 _tokens) external {
172 		_stake(_tokens);
173 	}
174 
175 	function unstake(uint256 _tokens) external {
176 		_unstake(_tokens);
177 	}
178 
179 	function collect() external returns (uint256) {
180 		uint256 _dividends = dividendsOf(msg.sender);
181 		require(_dividends >= 0);
182 		require(info.users[msg.sender].collectTime < now);
183 		info.users[msg.sender].scaledPayout += int256(_dividends.mul(FLOAT_SCALAR).mul(SHARE_DIVIDENDS).div(100));
184 		info.users[msg.sender].balance += _dividends.mul(SHARE_DIVIDENDS).div(100);
185 		info.users[msg.sender].collectTime = now + 86400;
186 		emit Transfer(address(this), msg.sender, _dividends);
187 		emit Collect(msg.sender, _dividends);
188 		return _dividends;
189 	}
190 
191 	function distribute(uint256 _tokens) external {
192 		require(info.totalStaked > 0);
193 		require(balanceOf(msg.sender) >= _tokens);
194 		info.users[msg.sender].balance -= _tokens;
195 		info.scaledPayoutPerToken += _tokens.mul(FLOAT_SCALAR).div(info.totalStaked);
196 		emit Transfer(msg.sender, address(this), _tokens);
197 	}
198 
199 	function transfer(address _to, uint256 _tokens) external returns (bool) {
200 		_transfer(msg.sender, _to, _tokens);
201 		return true;
202 	}
203 
204 	function approve(address _spender, uint256 _tokens) external returns (bool) {
205 		info.users[msg.sender].allowance[_spender] = _tokens;
206 		emit Approval(msg.sender, _spender, _tokens);
207 		return true;
208 	}
209 
210 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
211 		require(info.users[_from].allowance[msg.sender] >= _tokens);
212 		info.users[_from].allowance[msg.sender] -= _tokens;
213 		_transfer(_from, _to, _tokens);
214 		return true;
215 	}
216 
217 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
218 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
219 		uint32 _size;
220 		assembly {
221 			_size := extcodesize(_to)
222 		}
223 		if (_size > 0) {
224 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
225 		}
226 		return true;
227 	}
228 
229 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
230 		require(_receivers.length == _amounts.length);
231 		for (uint256 i = 0; i < _receivers.length; i++) {
232 			_transfer(msg.sender, _receivers[i], _amounts[i]);
233 		}
234 	}
235 
236 
237 	function totalSupply() public view returns (uint256) {
238 		return info.totalSupply;
239 	}
240 
241 	function totalStaked() public view returns (uint256) {
242 		return info.totalStaked;
243 	}
244 
245 	function balanceOf(address _user) public view returns (uint256) {
246 		return info.users[_user].balance - stakedOf(_user);
247 	}
248 
249 	function stakedOf(address _user) public view returns (uint256) {
250 		return info.users[_user].staked;
251 	}
252 	
253 	function collectTimeOf(address _user) public view returns (uint256) {
254 		return info.users[_user].collectTime;
255 	}
256 
257 	function dividendsOf(address _user) public view returns (uint256) {
258 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].staked) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
259 	}
260 
261 	function allowance(address _user, address _spender) public view returns (uint256) {
262 		return info.users[_user].allowance[_spender];
263 	}
264 
265 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensStaked, uint256 userBalance, uint256 userStaked, uint256 userDividends, uint usercollectTime) {
266 		return (totalSupply(), totalStaked(), balanceOf(_user), stakedOf(_user), dividendsOf(_user), collectTimeOf(_user));
267 	}
268 
269 
270 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
271 		require(balanceOf(_from) >= _tokens);
272 		info.users[_from].balance -= _tokens;
273 		
274 		uint256 _taxAmount = _tokens.mul(XFER_FEE).div(100);
275 		uint256 _poolAmount = _tokens.mul(POOL_FEE).div(100);
276 		uint256 _devAmount = _tokens.mul(DEV_FEE).div(100);
277 		
278 		uint256 _transferred = _tokens - _taxAmount;
279 		
280         if (info.totalStaked > 0) {
281             info.users[_to].balance += _transferred;
282             info.users[info.admin].balance += _devAmount;
283             emit Transfer(_from, _to, _transferred);
284             info.scaledPayoutPerToken += _poolAmount.mul(FLOAT_SCALAR).div(info.totalStaked);
285             emit Transfer(_from, address(this), _poolAmount);
286             emit Transfer(_from, info.admin, _devAmount);
287             emit Tax(_taxAmount);
288             return _transferred;
289         } else {
290             info.users[_to].balance += _tokens;
291             emit Transfer(_from, _to, _tokens);
292             return _tokens;
293         }
294     }
295 
296 	function _stake(uint256 _amount) internal {
297 		require(balanceOf(msg.sender) >= _amount);
298 		require(stakedOf(msg.sender) + _amount >= MIN_STAKE_AMOUNT);
299 		info.users[msg.sender].unstakeTime = now + 86400;
300 		info.totalStaked += _amount;
301 		info.users[msg.sender].staked += _amount;
302 		info.users[msg.sender].scaledPayout += int256(_amount.mul(info.scaledPayoutPerToken));
303 		emit Transfer(msg.sender, address(this), _amount);
304 		emit Stake(msg.sender, _amount);
305 	}
306 
307 	function _unstake(uint256 _amount) internal {
308 	    require(info.users[msg.sender].unstakeTime < now);
309 		require(stakedOf(msg.sender) >= _amount);
310 		uint256 _taxAmount = _amount.mul(XFER_FEE).div(100);
311 		info.scaledPayoutPerToken += _taxAmount.mul(FLOAT_SCALAR).div(info.totalStaked);
312 		info.totalStaked -= _amount;
313 		info.users[msg.sender].balance -= _taxAmount;
314 		info.users[msg.sender].staked -= _amount;
315 		info.users[msg.sender].scaledPayout -= int256(_amount.mul(info.scaledPayoutPerToken));
316 		emit Transfer(address(this), msg.sender, _amount.sub(_taxAmount));
317 		emit Unstake(msg.sender, _amount);
318 	}
319 }