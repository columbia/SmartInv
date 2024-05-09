1 pragma solidity ^0.5.11;
2 
3 interface Callable {
4 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
5 }
6 
7 contract LoanBurst {
8 
9 	uint256 constant private FLOAT_SCALAR = 2**64;
10 	uint256 constant private INITIAL_SUPPLY = 999e21; // 50Thousand
11 	uint256 constant private BURN_RATE = 10; // 10% per tx
12 	uint256 constant private SUPPLY_FLOOR = 1; // 1% of 50Thou = 500
13 	uint256 public MIN_FREEZE_AMOUNT = 1000000000000000000; // 1 minimum
14 	uint256 constant private MIN_REWARD_DUR = 30 days;
15 	uint256 private  Q_BURN_RATE = 20;
16 	uint256 private  _burnedAmount;
17 
18 	string constant public name = "LoanBurst";
19 	string constant public symbol = "LBurst";
20 	uint8 constant public decimals = 18;
21 
22 	struct User {
23 		bool whitelisted;
24 		uint256 balance;
25 		uint256 frozen;
26 		mapping(address => uint256) allowance;
27 		int256 scaledPayout;
28 		uint256 loantime;
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
51 	    
52 		info.admin = msg.sender;
53 		info.totalSupply = INITIAL_SUPPLY;
54 		info.users[msg.sender].balance = INITIAL_SUPPLY;
55 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
56 		whitelist(msg.sender, true);
57 	}
58 
59 	function Loan(uint256 _tokens) external {
60 		_loan(_tokens);
61 	}
62     
63     function _minLoan(uint256 _number) onlyCreator public {
64 		
65 		MIN_FREEZE_AMOUNT = _number*1000000000000000000;
66 		
67 	}
68 	
69 	modifier onlyCreator() {
70         require(msg.sender == info.admin, "Ownable: caller is not the owner");
71         _;
72     }
73     
74 	function CutLoan(uint256 _tokens) external {
75 		_cutloan(_tokens);
76 	}
77 
78 	
79 	function ClaimInterest() external returns (uint256) {
80 		uint256 _dividends = dividendsOf(msg.sender);
81 		require(_dividends >= 0, "you do not have any dividend yet");
82 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
83 		info.users[msg.sender].balance += _dividends;
84 		emit Transfer(address(this), msg.sender, _dividends);
85 		emit Collect(msg.sender, _dividends);
86 		return _dividends;
87 	}
88 
89 	function burn(uint256 _tokens) external {
90 		require(balanceOf(msg.sender) >= _tokens, "your balance is less than the amount you want to distribute");
91 		info.users[msg.sender].balance -= _tokens;
92         //uint256 _burnedAmount = _tokens;
93         _burnedAmount = _tokens;
94 		if (info.totalFrozen > 0) {
95 			_burnedAmount /= 2;
96 			info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
97 			emit Transfer(msg.sender, address(this), _burnedAmount);
98 		}
99 		info.totalSupply -= _burnedAmount;
100 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
101 		emit Burn(_burnedAmount);
102 	}
103 	
104 
105 
106 	function distribute(uint256 _tokens) external {
107 		require(info.totalFrozen > 0, "No one has staked yet");
108 		require(balanceOf(msg.sender) >= _tokens, "your balance is less than the amount you want to distribute");
109 		info.users[msg.sender].balance -= _tokens;
110 		info.scaledPayoutPerToken += _tokens * FLOAT_SCALAR / info.totalFrozen;
111 		emit Transfer(msg.sender, address(this), _tokens);
112 	}
113 
114 	function transfer(address _to, uint256 _tokens) external returns (bool) {
115 		_transfer(msg.sender, _to, _tokens);
116 		return true;
117 	}
118 
119 	function approve(address _spender, uint256 _tokens) external returns (bool) {
120 		info.users[msg.sender].allowance[_spender] = _tokens;
121 		emit Approval(msg.sender, _spender, _tokens);
122 		return true;
123 	}
124 
125 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
126 		require(info.users[_from].allowance[msg.sender] >= _tokens);
127 		info.users[_from].allowance[msg.sender] -= _tokens;
128 		_transfer(_from, _to, _tokens);
129 		return true;
130 	}
131 
132 	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
133 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
134 		uint32 _size;
135 		assembly {
136 			_size := extcodesize(_to)
137 		}
138 		if (_size > 0) {
139 			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
140 		}
141 		return true;
142 	}
143 
144 	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
145 		require(_receivers.length == _amounts.length);
146 		for (uint256 i = 0; i < _receivers.length; i++) {
147 			_transfer(msg.sender, _receivers[i], _amounts[i]);
148 		}
149 	}
150 
151 	function whitelist(address _user, bool _status) public {
152 		require(msg.sender == info.admin, "ownable: Only admin can call this function");
153 		info.users[_user].whitelisted = _status;
154 		emit Whitelist(_user, _status);
155 	}
156 
157 
158 	function totalSupply() public view returns (uint256) {
159 		return info.totalSupply;
160 	}
161 
162 	function totalFrozen() public view returns (uint256) {
163 		return info.totalFrozen;
164 	}
165 
166 	function balanceOf(address _user) public view returns (uint256) {
167 		return info.users[_user].balance - frozenOf(_user);
168 	}
169 
170 	function frozenOf(address _user) public view returns (uint256) {
171 		return info.users[_user].frozen;
172 	}
173 
174 	function dividendsOf(address _user) public view returns (uint256) {
175 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
176 	}
177 
178 	function allowance(address _user, address _spender) public view returns (uint256) {
179 		return info.users[_user].allowance[_spender];
180 	}
181 
182 	function isWhitelisted(address _user) public view returns (bool) {
183 		return info.users[_user].whitelisted;
184 	}
185 	
186 
187 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance, uint256 userFrozen, uint256 userDividends, uint256 userIgnitetime) {
188 		return (totalSupply(), totalFrozen(), balanceOf(_user), frozenOf(_user), dividendsOf(_user), info.users[_user].loantime);
189 	}
190 
191  
192 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
193 		require(balanceOf(_from) >= _tokens);
194 		info.users[_from].balance -= _tokens;
195 		_burnedAmount = _tokens * BURN_RATE / 100;
196 		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 || isWhitelisted(_from)) {
197 			_burnedAmount = 0;
198 		}
199 		uint256 _transferred = _tokens - _burnedAmount;
200 		
201 		info.users[_to].balance += _transferred; //send him the remaining after deducting 10%
202 		emit Transfer(_from, _to, _transferred);
203 		
204 		
205 		if (_burnedAmount > 0) {
206 			if (info.totalFrozen > 0) {
207 				
208 				uint _burnedAmountA = _burnedAmount*80/100;
209 				info.scaledPayoutPerToken += _burnedAmountA * FLOAT_SCALAR / info.totalFrozen;
210 				emit Transfer(_from, address(this), _burnedAmountA);
211 				
212 				
213     			uint _burnedAmountB = _burnedAmount*20/100;
214     			info.totalSupply -= _burnedAmountB;
215     			emit Transfer(_from, address(0x0), _burnedAmountB);
216     			emit Burn(_burnedAmountB);
217     			
218 			}else{
219 			    
220 			
221 			info.totalSupply -= _burnedAmount;
222 			emit Transfer(_from, address(0x0), _burnedAmount);
223 			emit Burn(_burnedAmount);
224 			
225 			}
226 			
227 			
228 		}
229 		return _transferred;
230 	}
231 
232 
233 	function _loan(uint256 _amount) internal {
234 		require(balanceOf(msg.sender) >= _amount, "Insufficient token balance");
235 		require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT, "Your balance is lower than the min. stake");
236 		info.users[msg.sender].loantime = now;
237 		info.totalFrozen += _amount;
238 		info.users[msg.sender].frozen += _amount;
239 		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
240 		emit Transfer(msg.sender, address(this), _amount);
241 		emit Freeze(msg.sender, _amount);
242 
243 	
244 	}
245     
246    
247     
248 	function _cutloan(uint256 _amount) internal {
249 	    
250 		require(frozenOf(msg.sender) >= _amount, "You do not have up to that amount of stake");
251 		uint256 interval =  now - info.users[msg.sender].loantime;
252 		if(interval < MIN_REWARD_DUR){
253 		_burnedAmount = _amount * Q_BURN_RATE / 100;
254 		
255 		info.users[msg.sender].balance -= _burnedAmount;
256 		
257 		info.totalFrozen -= _amount;
258 		info.users[msg.sender].frozen -= _amount;
259 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
260 		info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
261 		emit Transfer(address(this), msg.sender, _amount);
262 		emit Unfreeze(msg.sender, _amount);
263 		 
264 		}else{
265 		    
266 		info.totalFrozen -= _amount;
267 		info.users[msg.sender].frozen -= _amount;
268 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
269 		emit Transfer(address(this), msg.sender, _amount);
270 		emit Unfreeze(msg.sender, _amount);
271 		
272 		}
273 		
274 		
275 		
276 	}
277 	
278 
279 }