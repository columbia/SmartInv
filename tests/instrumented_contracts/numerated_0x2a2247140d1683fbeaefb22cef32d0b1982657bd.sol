1 pragma solidity 0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9 	/**
10 	* @dev Multiplies two numbers, reverts on overflow.
11 	*/
12 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14 		// benefit is lost if 'b' is also tested.
15 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16 		if (a == 0) {
17 			return 0;
18 		}
19 
20 		uint256 c = a * b;
21 		require(c / a == b);
22 
23 		return c;
24 	}
25 
26 	/**
27 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28 	*/
29 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
30 		require(b > 0); // Solidity only automatically asserts when dividing by 0
31 		uint256 c = a / b;
32 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34 		return c;
35 	}
36 
37 	/**
38 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39 	*/
40 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41 		require(b <= a);
42 		uint256 c = a - b;
43 
44 		return c;
45 	}
46 
47 	/**
48 	* @dev Adds two numbers, reverts on overflow.
49 	*/
50 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
51 		uint256 c = a + b;
52 		require(c >= a);
53 
54 		return c;
55 	}
56 
57 	/**
58 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59 	* reverts when dividing by zero.
60 	*/
61 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62 		require(b != 0);
63 		return a % b;
64 	}
65 }
66 
67 contract Owned {
68 
69 	address public owner = msg.sender;
70 	address public potentialOwner;
71 
72 	modifier onlyOwner {
73 		require(msg.sender == owner);
74 		_;
75 	}
76 
77 	modifier onlyPotentialOwner {
78 		require(msg.sender == potentialOwner);
79 		_;
80 	}
81 
82 	event NewOwner(address old, address current);
83 	event NewPotentialOwner(address old, address potential);
84 
85 	function setOwner(address _new)
86 		public
87 		onlyOwner
88 	{
89 		emit NewPotentialOwner(owner, _new);
90 		potentialOwner = _new;
91 	}
92 
93 	function confirmOwnership()
94 		public
95 		onlyPotentialOwner
96 	{
97 		emit NewOwner(owner, potentialOwner);
98 		owner = potentialOwner;
99 		potentialOwner = address(0);
100 	}
101 }
102 
103 // @title Abstract ERC20 token interface
104 interface IERC20 {
105 	function balanceOf(address owner) external view returns (uint256 balance);
106 	function transfer(address to, uint256 value) external returns (bool success);
107 	function transferFrom(address from, address to, uint256 value) external returns (bool success);
108 	function approve(address spender, uint256 value) external returns (bool success);
109 	function allowance(address owner, address spender) external view returns (uint256 remaining);
110 
111 	event Transfer(address indexed from, address indexed to, uint256 value);
112 	event Approval(address indexed owner, address indexed spender, uint256 value);
113 	event Issuance(address indexed to, uint256 value);
114 }
115 
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
122  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract ERC20 is IERC20 {
125 	using SafeMath for uint256;
126 
127 	mapping (address => uint256) private _balances;
128 
129 	mapping (address => mapping (address => uint256)) private _allowed;
130 
131 	uint256 private _totalSupply;
132 
133 	/**
134 	* @dev Total number of tokens in existence
135 	*/
136 	function totalSupply() public view returns (uint256) {
137 		return _totalSupply;
138 	}
139 
140 	/**
141 	* @dev Gets the balance of the specified address.
142 	* @param owner The address to query the balance of.
143 	* @return An uint256 representing the amount owned by the passed address.
144 	*/
145 	function balanceOf(address owner) public view returns (uint256) {
146 		return _balances[owner];
147 	}
148 
149 	/**
150 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
151 	 * @param owner address The address which owns the funds.
152 	 * @param spender address The address which will spend the funds.
153 	 * @return A uint256 specifying the amount of tokens still available for the spender.
154 	 */
155 	function allowance(
156 		address owner,
157 		address spender
158 	 )
159 		public
160 		view
161 		returns (uint256)
162 	{
163 		return _allowed[owner][spender];
164 	}
165 
166 	/**
167 	* @dev Transfer token for a specified address
168 	* @param to The address to transfer to.
169 	* @param value The amount to be transferred.
170 	*/
171 	function transfer(address to, uint256 value) public returns (bool) {
172 		_transfer(msg.sender, to, value);
173 		return true;
174 	}
175 
176 	/**
177 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
179 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182 	 * @param spender The address which will spend the funds.
183 	 * @param value The amount of tokens to be spent.
184 	 */
185 	function approve(address spender, uint256 value) public returns (bool) {
186 		require(spender != address(0));
187 
188 		_allowed[msg.sender][spender] = value;
189 		emit Approval(msg.sender, spender, value);
190 		return true;
191 	}
192 
193 	/**
194 	 * @dev Transfer tokens from one address to another
195 	 * @param from address The address which you want to send tokens from
196 	 * @param to address The address which you want to transfer to
197 	 * @param value uint256 the amount of tokens to be transferred
198 	 */
199 	function transferFrom(
200 		address from,
201 		address to,
202 		uint256 value
203 	)
204 		public
205 		returns (bool)
206 	{
207 		require(value <= _allowed[from][msg.sender]);
208 
209 		_allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
210 		_transfer(from, to, value);
211 		return true;
212 	}
213 
214 	/**
215 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
216 	 * approve should be called when allowed_[_spender] == 0. To increment
217 	 * allowed value is better to use this function to avoid 2 calls (and wait until
218 	 * the first transaction is mined)
219 	 * From MonolithDAO Token.sol
220 	 * @param spender The address which will spend the funds.
221 	 * @param addedValue The amount of tokens to increase the allowance by.
222 	 */
223 	function increaseAllowance(
224 		address spender,
225 		uint256 addedValue
226 	)
227 		public
228 		returns (bool)
229 	{
230 		require(spender != address(0));
231 
232 		_allowed[msg.sender][spender] = (
233 			_allowed[msg.sender][spender].add(addedValue));
234 		emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
235 		return true;
236 	}
237 
238 	/**
239 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
240 	 * approve should be called when allowed_[_spender] == 0. To decrement
241 	 * allowed value is better to use this function to avoid 2 calls (and wait until
242 	 * the first transaction is mined)
243 	 * From MonolithDAO Token.sol
244 	 * @param spender The address which will spend the funds.
245 	 * @param subtractedValue The amount of tokens to decrease the allowance by.
246 	 */
247 	function decreaseAllowance(
248 		address spender,
249 		uint256 subtractedValue
250 	)
251 		public
252 		returns (bool)
253 	{
254 		require(spender != address(0));
255 
256 		_allowed[msg.sender][spender] = (
257 			_allowed[msg.sender][spender].sub(subtractedValue));
258 		emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
259 		return true;
260 	}
261 
262 	/**
263 	* @dev Transfer token for a specified addresses
264 	* @param from The address to transfer from.
265 	* @param to The address to transfer to.
266 	* @param value The amount to be transferred.
267 	*/
268 	function _transfer(address from, address to, uint256 value) internal {
269 		require(value <= _balances[from]);
270 		require(to != address(0));
271 
272 		_balances[from] = _balances[from].sub(value);
273 		_balances[to] = _balances[to].add(value);
274 		emit Transfer(from, to, value);
275 	}
276 
277 	/**
278 	 * @dev Internal function that mints an amount of the token and assigns it to
279 	 * an account. This encapsulates the modification of balances such that the
280 	 * proper events are emitted.
281 	 * @param account The account that will receive the created tokens.
282 	 * @param value The amount that will be created.
283 	 */
284 	function _mint(address account, uint256 value) internal {
285 		require(account != address(0));
286 		_totalSupply = _totalSupply.add(value);
287 		_balances[account] = _balances[account].add(value);
288 		emit Transfer(address(0), account, value);
289 	}
290 
291 	/**
292 	 * @dev Internal function that burns an amount of the token of a given
293 	 * account.
294 	 * @param account The account whose tokens will be burnt.
295 	 * @param value The amount that will be burnt.
296 	 */
297 	function _burn(address account, uint256 value) internal {
298 		require(account != address(0));
299 		require(value <= _balances[account]);
300 
301 		_totalSupply = _totalSupply.sub(value);
302 		_balances[account] = _balances[account].sub(value);
303 		emit Transfer(account, address(0), value);
304 	}
305 
306 	/**
307 	 * @dev Internal function that burns an amount of the token of a given
308 	 * account, deducting from the sender's allowance for said account. Uses the
309 	 * internal burn function.
310 	 * @param account The account whose tokens will be burnt.
311 	 * @param value The amount that will be burnt.
312 	 */
313 	function _burnFrom(address account, uint256 value) internal {
314 		require(value <= _allowed[account][msg.sender]);
315 
316 		// Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
317 		// this function needs to emit an event with the updated approval.
318 		_allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
319 			value);
320 		_burn(account, value);
321 	}
322 }
323 
324 contract ERC20Burnable is ERC20 {
325 
326 	/**
327 	 * @dev Burns a specific amount of tokens.
328 	 * @param value The amount of token to be burned.
329 	 */
330 	function burn(uint256 value) public {
331 		_burn(msg.sender, value);
332 	}
333 
334 	/**
335 	 * @dev Burns a specific amount of tokens from the target address and decrements allowance
336 	 * @param from address The address which you want to send tokens from
337 	 * @param value uint256 The amount of token to be burned
338 	 */
339 	function burnFrom(address from, uint256 value) public {
340 		_burnFrom(from, value);
341 	}
342 }
343 
344 
345 interface IOldManager {
346     function released(address investor) external view returns (uint256);
347 }
348 
349 
350 contract Manager is Owned {
351     using SafeMath for uint256;
352 
353     event InvestorVerified(address investor);
354     event VerificationRevoked(address investor);
355 
356     mapping (address => bool) public verifiedInvestors;
357     mapping (address => uint256) public released;
358 
359     IOldManager public oldManager;
360     ERC20Burnable public oldToken;
361     IERC20 public presaleToken;
362     IERC20 public newToken;
363 
364     modifier onlyVerifiedInvestor {
365         require(verifiedInvestors[msg.sender]);
366         _;
367     }
368 
369     constructor(IOldManager _oldManager, ERC20Burnable _oldToken, IERC20 _presaleToken, IERC20 _newToken) public {
370         oldManager = _oldManager;
371         oldToken = _oldToken;
372         presaleToken = _presaleToken;
373         newToken = _newToken;
374     }
375 
376     function updateVerificationStatus(address investor, bool is_verified) public onlyOwner {
377         require(verifiedInvestors[investor] != is_verified);
378 
379         verifiedInvestors[investor] = is_verified;
380         if (is_verified) emit InvestorVerified(investor);
381         if (!is_verified) emit VerificationRevoked(investor);
382     }
383 
384     function migrate() public onlyVerifiedInvestor {
385         uint256 tokensToTransfer = oldToken.allowance(msg.sender, address(this));
386         require(tokensToTransfer > 0);
387         require(oldToken.transferFrom(msg.sender, address(this), tokensToTransfer));
388         oldToken.burn(tokensToTransfer);
389         _transferTokens(msg.sender, tokensToTransfer);
390     }
391 
392     function release() public onlyVerifiedInvestor {
393         uint256 presaleTokens = presaleToken.balanceOf(msg.sender);
394         uint256 tokensToRelease = presaleTokens - totalReleased(msg.sender);
395         require(tokensToRelease > 0);
396         _transferTokens(msg.sender, tokensToRelease);
397         released[msg.sender] = tokensToRelease;
398     }
399 
400     function totalReleased(address investor) public view returns (uint256) {
401         return released[investor] + oldManager.released(investor);
402     }
403 
404     function _transferTokens(address recipient, uint256 amount) internal {
405         uint256 initialBalance = newToken.balanceOf(recipient);
406         require(newToken.transfer(recipient, amount));
407         assert(newToken.balanceOf(recipient) == initialBalance + amount);
408     }
409 }