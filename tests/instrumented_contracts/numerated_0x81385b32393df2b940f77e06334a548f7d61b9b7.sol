1 pragma solidity 0.4.23;
2 
3 /**
4  * Overflow aware uint math functions.
5  *
6  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
7  */
8 
9 contract SafeMath {
10 	/**
11 	* @dev Multiplies two numbers, throws on overflow.
12 	*/
13 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
14 		if (a == 0) {
15 			return 0;
16 		}
17 		uint256 c = a * b;
18 		assert(c / a == b);
19 		return c;
20 	}
21 
22 	/**
23 	* @dev Integer division of two numbers, truncating the quotient.
24 	*/
25 	function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
26 	// assert(b > 0); // Solidity automatically throws when dividing by 0
27 	// uint256 c = a / b;
28 	// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return a / b;
30 	}
31 
32 	/**
33 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34 	*/
35 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	/**
41 	* @dev Adds two numbers, throws on overflow.
42 	*/
43 	function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
44 		uint256 c = a + b;
45 		assert(c >= a);
46 		return c;
47 	}
48 
49 
50 	// mitigate short address attack
51 	// thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
52 	// TODO: doublecheck implication of >= compared to ==
53 	modifier onlyPayloadSize(uint numWords) {
54 		assert(msg.data.length >= numWords * 32 + 4);
55 		_;
56 	}
57 }
58 
59 contract Token { // ERC20 standard
60 	function balanceOf(address _owner) public constant returns (uint256 balance);
61 	function transfer(address _to, uint256 _value) public returns (bool success);
62 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
63 	function approve(address _spender, uint256 _value) public returns (bool success);
64 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
65 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
66 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 
68 }
69 
70 contract StandardToken is Token, SafeMath {
71 
72 	uint256 public totalSupply;
73 
74 	mapping (address => uint256) public index;
75 	mapping (uint256 => Info) public infos;
76 	mapping (address => mapping (address => uint256)) allowed;
77 
78 	struct Info {
79 		uint256 tokenBalances;
80 		address holderAddress;
81 	}
82 
83 	// TODO: update tests to expect throw
84 	function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool success) {
85 		require(_to != address(0));
86 		require(infos[index[msg.sender]].tokenBalances >= _value && _value > 0);
87 		infos[index[msg.sender]].tokenBalances = safeSub(infos[index[msg.sender]].tokenBalances, _value);
88 		infos[index[_to]].tokenBalances = safeAdd(infos[index[_to]].tokenBalances, _value);
89 		emit Transfer(msg.sender, _to, _value);
90 
91 		return true;
92 	}
93 
94 	// TODO: update tests to expect throw
95 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool success) {
96 		require(_to != address(0));
97 		require(infos[index[_from]].tokenBalances >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
98 		infos[index[_from]].tokenBalances = safeSub(infos[index[_from]].tokenBalances, _value);
99 		infos[index[_to]].tokenBalances = safeAdd(infos[index[_to]].tokenBalances, _value);
100 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
101 		emit Transfer(_from, _to, _value);
102 
103 		return true;
104 	}
105 
106 	function balanceOf(address _owner) public constant returns (uint256 balance) {
107 		return infos[index[_owner]].tokenBalances;
108 	}
109 
110 	//  To change the approve amount you first have to reduce the addresses'
111 	//  allowance to zero by calling 'approve(_spender, 0)' if it is not
112 	//  already 0 to mitigate the race condition described here:
113 	//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114 	function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool success) {
115 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
116 		allowed[msg.sender][_spender] = _value;
117 		emit Approval(msg.sender, _spender, _value);
118 
119 		return true;
120 	}
121 
122 	function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success) {
123 		require(allowed[msg.sender][_spender] == _oldValue);
124 		allowed[msg.sender][_spender] = _newValue;
125 		emit Approval(msg.sender, _spender, _newValue);
126 
127 		return true;
128 	}
129 
130 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
131 	  return allowed[_owner][_spender];
132 	}
133 }
134 
135 contract JCFv2 is StandardToken {
136 
137 	// FIELDS
138 
139 	string public name = "JCFv2";
140 	string public symbol = "JCFv2";
141 	uint256 public decimals = 18;
142 	string public version = "2.0";
143 
144 	uint256 public tokenCap = 1048576000000 * 10**18;
145 
146 	// root control
147 	address public fundWallet;
148 	// control of liquidity and limited control of updatePrice
149 	address public controlWallet;
150 
151 	// fundWallet controlled state variables
152 	// halted: halt buying due to emergency, tradeable: signal that assets have been acquired
153 	bool public halted = false;
154 	bool public tradeable = false;
155 
156 	// -- totalSupply defined in StandardToken
157 	// -- mapping to token balances done in StandardToken
158 
159 	uint256 public minAmount = 0.04 ether;
160 	uint256 public totalHolder;
161 
162 	// map participant address to a withdrawal request
163 	mapping (address => Withdrawal) public withdrawals;
164 
165 	// maps addresses
166 	mapping (address => bool) public whitelist;
167 
168 	// TYPES
169 
170 	struct Withdrawal {
171 		uint256 tokens;
172 		uint256 time; // time for each withdrawal is set to the previousUpdateTime
173 		// uint256 totalAmount;
174 	}
175 
176 	// EVENTS
177 
178 	event Whitelist(address indexed participant);
179 	event AddLiquidity(uint256 ethAmount);
180 	event RemoveLiquidity(uint256 ethAmount);
181 	event WithdrawRequest(address indexed participant, uint256 amountTokens, uint256 requestTime);
182 	event Withdraw(address indexed participant, uint256 amountTokens, uint256 etherAmount);
183 	event Burn(address indexed burner, uint256 value);
184 
185 	// MODIFIERS
186 
187 	modifier isTradeable {
188 		require(tradeable || msg.sender == fundWallet);
189 		_;
190 	}
191 
192 	modifier onlyWhitelist {
193 		require(whitelist[msg.sender]);
194 		_;
195 	}
196 
197 	modifier onlyFundWallet {
198 		require(msg.sender == fundWallet);
199 		_;
200 	}
201 
202 	modifier onlyManagingWallets {
203 		require(msg.sender == controlWallet || msg.sender == fundWallet);
204 		_;
205 	}
206 
207 	modifier only_if_controlWallet {
208 		if (msg.sender == controlWallet) {
209 			_;
210 		}
211 	}
212 
213 	constructor () public {
214 		fundWallet = msg.sender;
215 		controlWallet = msg.sender;
216 		infos[index[fundWallet]].tokenBalances = 1048576000000 * 10**18;
217 		totalSupply = infos[index[fundWallet]].tokenBalances;
218 		whitelist[fundWallet] = true;
219 		whitelist[controlWallet] = true;
220 		totalHolder = 0;
221 		index[msg.sender] = 0;
222 		infos[0].holderAddress = msg.sender;
223 	}
224 
225 	function verifyParticipant(address participant) external onlyManagingWallets {
226 		whitelist[participant] = true;
227 		emit Whitelist(participant);
228 	}
229 
230 	function withdraw_to(address participant, uint256 withdrawValue, uint256 amountTokensToWithdraw, uint256 requestTime) public onlyFundWallet {
231 		require(amountTokensToWithdraw > 0);
232 		require(withdrawValue > 0);
233 		require(balanceOf(participant) >= amountTokensToWithdraw);
234 		require(withdrawals[participant].tokens == 0);
235 
236 		infos[index[participant]].tokenBalances = safeSub(infos[index[participant]].tokenBalances, amountTokensToWithdraw);
237 
238 		withdrawals[participant] = Withdrawal({tokens: amountTokensToWithdraw, time: requestTime});
239 
240 		emit WithdrawRequest(participant, amountTokensToWithdraw, requestTime);
241 
242 		if (address(this).balance >= withdrawValue) {
243 			enact_withdrawal_greater_equal(participant, withdrawValue, amountTokensToWithdraw);
244 		} else {
245 			enact_withdrawal_less(participant, withdrawValue, amountTokensToWithdraw);
246 		}
247 	}
248 
249 	function enact_withdrawal_greater_equal(address participant, uint256 withdrawValue, uint256 tokens) private {
250 		assert(address(this).balance >= withdrawValue);
251 		infos[index[fundWallet]].tokenBalances = safeAdd(infos[index[fundWallet]].tokenBalances, tokens);
252 
253 		participant.transfer(withdrawValue);
254 		withdrawals[participant].tokens = 0;
255 		emit Withdraw(participant, tokens, withdrawValue);
256 	}
257 
258 	function enact_withdrawal_less(address participant, uint256 withdrawValue, uint256 tokens) private {
259 		assert(address(this).balance < withdrawValue);
260 		infos[index[participant]].tokenBalances = safeAdd(infos[index[participant]].tokenBalances, tokens);
261 
262 		withdrawals[participant].tokens = 0;
263 		emit Withdraw(participant, tokens, 0); // indicate a failed withdrawal
264 	}
265 
266 	function addLiquidity() external onlyManagingWallets payable {
267 		require(msg.value > 0);
268 		emit AddLiquidity(msg.value);
269 	}
270 
271 	function removeLiquidity(uint256 amount) external onlyManagingWallets {
272 		require(amount <= address(this).balance);
273 		fundWallet.transfer(amount);
274 		emit RemoveLiquidity(amount);
275 	}
276 
277 	function changeFundWallet(address newFundWallet) external onlyFundWallet {
278 		require(newFundWallet != address(0));
279 		fundWallet = newFundWallet;
280 	}
281 
282 	function changeControlWallet(address newControlWallet) external onlyFundWallet {
283 		require(newControlWallet != address(0));
284 		controlWallet = newControlWallet;
285 	}
286 
287 	function halt() external onlyFundWallet {
288 		halted = true;
289 	}
290 	function unhalt() external onlyFundWallet {
291 		halted = false;
292 	}
293 
294 	function enableTrading() external onlyFundWallet {
295 		// require(block.number > fundingEndBlock);
296 		tradeable = true;
297 	}
298 
299 	function disableTrading() external onlyFundWallet {
300 		// require(block.number > fundingEndBlock);
301 		tradeable = false;
302 	}
303 
304 	function claimTokens(address _token) external onlyFundWallet {
305 		require(_token != address(0));
306 		Token token = Token(_token);
307 		uint256 balance = token.balanceOf(this);
308 		token.transfer(fundWallet, balance);
309 	}
310 
311 	function transfer(address _to, uint256 _value) public isTradeable returns (bool success) {
312 		if (index[_to] > 0) {
313 			// do nothing
314 		} else {
315 			// store token holder infos
316 			totalHolder = safeAdd(totalHolder, 1);
317 			index[_to] = totalHolder;
318 			infos[index[_to]].holderAddress = _to;
319 		}
320 
321 		return super.transfer(_to, _value);
322 	}
323 
324 	function transferFrom(address _from, address _to, uint256 _value) public isTradeable returns (bool success) {
325 		if (index[_to] > 0) {
326 			// do nothing
327 		} else {
328 			// store token holder infos
329 			totalHolder = safeAdd(totalHolder, 1);
330 			index[_to] = totalHolder;
331 			infos[index[_to]].holderAddress = _to;
332 		}
333 		return super.transferFrom(_from, _to, _value);
334 	}
335 
336 	function burn(address _who, uint256 _value) external only_if_controlWallet {
337 		require(_value <= infos[index[_who]].tokenBalances);
338 		// no need to require value <= totalSupply, since that would imply the
339 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
340 		infos[index[_who]].tokenBalances = safeSub(infos[index[_who]].tokenBalances, _value);
341 
342 		totalSupply = safeSub(totalSupply, _value);
343 		emit Burn(_who, _value);
344 		emit Transfer(_who, address(0), _value);
345 	}
346 }