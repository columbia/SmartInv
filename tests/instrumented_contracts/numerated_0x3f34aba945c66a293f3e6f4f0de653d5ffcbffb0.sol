1 pragma solidity 0.5.2;
2 
3 
4 // @title Abstract ERC20 token interface
5 interface IERC20 {
6 	function balanceOf(address owner) external view returns (uint256 balance);
7 	function transfer(address to, uint256 value) external returns (bool success);
8 	function transferFrom(address from, address to, uint256 value) external returns (bool success);
9 	function approve(address spender, uint256 value) external returns (bool success);
10 	function allowance(address owner, address spender) external view returns (uint256 remaining);
11 
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 	event Approval(address indexed owner, address indexed spender, uint256 value);
14 	event Issuance(address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that revert on error
20  */
21 library SafeMath {
22 
23 	/**
24 	* @dev Multiplies two numbers, reverts on overflow.
25 	*/
26 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28 		// benefit is lost if 'b' is also tested.
29 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30 		if (a == 0) {
31 			return 0;
32 		}
33 
34 		uint256 c = a * b;
35 		require(c / a == b);
36 
37 		return c;
38 	}
39 
40 	/**
41 	* @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
42 	*/
43 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
44 		require(b > 0); // Solidity only automatically asserts when dividing by 0
45 		uint256 c = a / b;
46 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48 		return c;
49 	}
50 
51 	/**
52 	* @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53 	*/
54 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55 		require(b <= a);
56 		uint256 c = a - b;
57 
58 		return c;
59 	}
60 
61 	/**
62 	* @dev Adds two numbers, reverts on overflow.
63 	*/
64 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
65 		uint256 c = a + b;
66 		require(c >= a);
67 
68 		return c;
69 	}
70 
71 	/**
72 	* @dev Divides two numbers and returns the remainder (unsigned integer modulo),
73 	* reverts when dividing by zero.
74 	*/
75 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76 		require(b != 0);
77 		return a % b;
78 	}
79 }
80 
81 contract ERC20 is IERC20 {
82 	using SafeMath for uint256;
83 
84 	mapping (address => uint256) private _balances;
85 
86 	mapping (address => mapping (address => uint256)) private _allowed;
87 
88 	uint256 private _totalSupply;
89 
90 	/**
91 	* @dev Total number of tokens in existence
92 	*/
93 	function totalSupply() public view returns (uint256) {
94 		return _totalSupply;
95 	}
96 
97 	/**
98 	* @dev Gets the balance of the specified address.
99 	* @param owner The address to query the balance of.
100 	* @return An uint256 representing the amount owned by the passed address.
101 	*/
102 	function balanceOf(address owner) public view returns (uint256) {
103 		return _balances[owner];
104 	}
105 
106 	/**
107 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
108 	 * @param owner address The address which owns the funds.
109 	 * @param spender address The address which will spend the funds.
110 	 * @return A uint256 specifying the amount of tokens still available for the spender.
111 	 */
112 	function allowance(
113 		address owner,
114 		address spender
115 	 )
116 		public
117 		view
118 		returns (uint256)
119 	{
120 		return _allowed[owner][spender];
121 	}
122 
123 	/**
124 	* @dev Transfer token for a specified address
125 	* @param to The address to transfer to.
126 	* @param value The amount to be transferred.
127 	*/
128 	function transfer(address to, uint256 value) public returns (bool) {
129 		_transfer(msg.sender, to, value);
130 		return true;
131 	}
132 
133 	/**
134 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
136 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139 	 * @param spender The address which will spend the funds.
140 	 * @param value The amount of tokens to be spent.
141 	 */
142 	function approve(address spender, uint256 value) public returns (bool) {
143 		require(spender != address(0));
144 
145 		_allowed[msg.sender][spender] = value;
146 		emit Approval(msg.sender, spender, value);
147 		return true;
148 	}
149 
150 	/**
151 	 * @dev Transfer tokens from one address to another
152 	 * @param from address The address which you want to send tokens from
153 	 * @param to address The address which you want to transfer to
154 	 * @param value uint256 the amount of tokens to be transferred
155 	 */
156 	function transferFrom(
157 		address from,
158 		address to,
159 		uint256 value
160 	)
161 		public
162 		returns (bool)
163 	{
164 		require(value <= _allowed[from][msg.sender]);
165 
166 		_allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
167 		_transfer(from, to, value);
168 		return true;
169 	}
170 
171 	/**
172 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
173 	 * approve should be called when allowed_[_spender] == 0. To increment
174 	 * allowed value is better to use this function to avoid 2 calls (and wait until
175 	 * the first transaction is mined)
176 	 * From MonolithDAO Token.sol
177 	 * @param spender The address which will spend the funds.
178 	 * @param addedValue The amount of tokens to increase the allowance by.
179 	 */
180 	function increaseAllowance(
181 		address spender,
182 		uint256 addedValue
183 	)
184 		public
185 		returns (bool)
186 	{
187 		require(spender != address(0));
188 
189 		_allowed[msg.sender][spender] = (
190 			_allowed[msg.sender][spender].add(addedValue));
191 		emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
192 		return true;
193 	}
194 
195 	/**
196 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
197 	 * approve should be called when allowed_[_spender] == 0. To decrement
198 	 * allowed value is better to use this function to avoid 2 calls (and wait until
199 	 * the first transaction is mined)
200 	 * From MonolithDAO Token.sol
201 	 * @param spender The address which will spend the funds.
202 	 * @param subtractedValue The amount of tokens to decrease the allowance by.
203 	 */
204 	function decreaseAllowance(
205 		address spender,
206 		uint256 subtractedValue
207 	)
208 		public
209 		returns (bool)
210 	{
211 		require(spender != address(0));
212 
213 		_allowed[msg.sender][spender] = (
214 			_allowed[msg.sender][spender].sub(subtractedValue));
215 		emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
216 		return true;
217 	}
218 
219 	/**
220 	* @dev Transfer token for a specified addresses
221 	* @param from The address to transfer from.
222 	* @param to The address to transfer to.
223 	* @param value The amount to be transferred.
224 	*/
225 	function _transfer(address from, address to, uint256 value) internal {
226 		require(value <= _balances[from]);
227 		require(to != address(0));
228 
229 		_balances[from] = _balances[from].sub(value);
230 		_balances[to] = _balances[to].add(value);
231 		emit Transfer(from, to, value);
232 	}
233 
234 	/**
235 	 * @dev Internal function that mints an amount of the token and assigns it to
236 	 * an account. This encapsulates the modification of balances such that the
237 	 * proper events are emitted.
238 	 * @param account The account that will receive the created tokens.
239 	 * @param value The amount that will be created.
240 	 */
241 	function _mint(address account, uint256 value) internal {
242 		require(account != address(0));
243 		_totalSupply = _totalSupply.add(value);
244 		_balances[account] = _balances[account].add(value);
245 		emit Transfer(address(0), account, value);
246 	}
247 
248 	/**
249 	 * @dev Internal function that burns an amount of the token of a given
250 	 * account.
251 	 * @param account The account whose tokens will be burnt.
252 	 * @param value The amount that will be burnt.
253 	 */
254 	function _burn(address account, uint256 value) internal {
255 		require(account != address(0));
256 		require(value <= _balances[account]);
257 
258 		_totalSupply = _totalSupply.sub(value);
259 		_balances[account] = _balances[account].sub(value);
260 		emit Transfer(account, address(0), value);
261 	}
262 
263 	/**
264 	 * @dev Internal function that burns an amount of the token of a given
265 	 * account, deducting from the sender's allowance for said account. Uses the
266 	 * internal burn function.
267 	 * @param account The account whose tokens will be burnt.
268 	 * @param value The amount that will be burnt.
269 	 */
270 	function _burnFrom(address account, uint256 value) internal {
271 		require(value <= _allowed[account][msg.sender]);
272 
273 		// Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
274 		// this function needs to emit an event with the updated approval.
275 		_allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
276 			value);
277 		_burn(account, value);
278 	}
279 }
280 
281 contract ERC20Burnable is ERC20 {
282 
283 	/**
284 	 * @dev Burns a specific amount of tokens.
285 	 * @param value The amount of token to be burned.
286 	 */
287 	function burn(uint256 value) public {
288 		_burn(msg.sender, value);
289 	}
290 
291 	/**
292 	 * @dev Burns a specific amount of tokens from the target address and decrements allowance
293 	 * @param from address The address which you want to send tokens from
294 	 * @param value uint256 The amount of token to be burned
295 	 */
296 	function burnFrom(address from, uint256 value) public {
297 		_burnFrom(from, value);
298 	}
299 }
300 
301 contract Owned {
302 
303 	address public owner = msg.sender;
304 	address public potentialOwner;
305 
306 	modifier onlyOwner {
307 		require(msg.sender == owner);
308 		_;
309 	}
310 
311 	modifier onlyPotentialOwner {
312 		require(msg.sender == potentialOwner);
313 		_;
314 	}
315 
316 	event NewOwner(address old, address current);
317 	event NewPotentialOwner(address old, address potential);
318 
319 	function setOwner(address _new)
320 		public
321 		onlyOwner
322 	{
323 		emit NewPotentialOwner(owner, _new);
324 		potentialOwner = _new;
325 	}
326 
327 	function confirmOwnership()
328 		public
329 		onlyPotentialOwner
330 	{
331 		emit NewOwner(owner, potentialOwner);
332 		owner = potentialOwner;
333 		potentialOwner = address(0);
334 	}
335 }
336 
337 /// @title Token contract - Implements Standard ERC20 Token with additional features.
338 /// @author Zerion - <inbox@zerion.io>
339 contract Token is ERC20Burnable, Owned {
340 
341 	// Time of the contract creation
342 	uint256 public creationTime;
343 
344 	constructor() public {
345 		/* solium-disable-next-line security/no-block-members */
346 		creationTime = now;
347 	}
348 
349 	/// @dev Owner can transfer out any accidentally sent ERC20 tokens
350 	function transferERC20Token(IERC20 _token, address _to, uint256 _value)
351 		public
352 		onlyOwner
353 		returns (bool success)
354 	{
355 		require(_token.balanceOf(address(this)) >= _value);
356 		uint256 receiverBalance = _token.balanceOf(_to);
357 		require(_token.transfer(_to, _value));
358 
359 		uint256 receiverNewBalance = _token.balanceOf(_to);
360 		assert(receiverNewBalance == receiverBalance + _value);
361 
362 		return true;
363 	}
364 }
365 
366 contract FluenceToken is Token {
367 
368     string constant public name = 'Fluence Presale Token (Test)';
369     string constant public symbol = 'FPT-test';
370     uint8  constant public decimals = 18;
371 
372     uint256 constant public presaleTokens = 6000000e18;
373 
374     bool public isVestingEnabled = true;
375     mapping (address => uint256) public vestedTokens;
376 
377     // The moment when the crowdsale ends. The time of the first payout.
378     uint256 checkpoint;
379 
380     address crowdsaleManager;
381     address migrationManager;
382 
383     modifier onlyCrowdsaleManager {
384         require(msg.sender == crowdsaleManager);
385         _;
386     }
387 
388     modifier onlyDuringVestingPeriod {
389         require(isVestingEnabled);
390         _;
391     }
392 
393     function vest(uint256 amount) public onlyDuringVestingPeriod {
394         _transfer(msg.sender, address(this), amount);
395         vestedTokens[msg.sender] += amount;
396     }
397 
398     function unvest(uint256 amount) public {
399         require(onVesting(msg.sender) >= amount);
400         
401         uint256 tokens_to_unvest = (amount * 100) / (100 + _getBonus());
402         _transfer(address(this), msg.sender, tokens_to_unvest);
403         vestedTokens[msg.sender] -= tokens_to_unvest;
404         _mint(msg.sender, amount - tokens_to_unvest);
405     }
406 
407     function disableVesting() public onlyCrowdsaleManager {
408         isVestingEnabled = false;
409     }
410 
411     function payoutFirstBonus() public onlyCrowdsaleManager {
412         require(!isVestingEnabled && checkpoint == 0);  // can only be called once
413         checkpoint = now;
414     }
415 
416     function setCrowdsaleManager(address manager) public onlyOwner {
417         crowdsaleManager = manager;
418     }
419 
420     function setMigrationManager(address manager) public onlyOwner {
421         require(migrationManager == address(0));  // can only be called once
422         migrationManager = manager;
423         _mint(migrationManager, presaleTokens);
424     }
425 
426     function onVesting(address account) public view returns (uint256) {
427         return vestedTokens[account] * (100 + _getBonus()) / 100;
428     }
429 
430     function _getBonus() internal view returns (uint256) {
431         if (checkpoint == 0) {
432             return 0;
433         }
434         uint256 initialBonus = 5;
435         uint256 monthsPassed = (now - checkpoint) / (30 minutes);
436         uint256 additionalBonus = (monthsPassed > 4 ? 4: monthsPassed) * 5;  // 5% for every 30 days; no more than 20%
437         return initialBonus + additionalBonus;
438     }
439 }