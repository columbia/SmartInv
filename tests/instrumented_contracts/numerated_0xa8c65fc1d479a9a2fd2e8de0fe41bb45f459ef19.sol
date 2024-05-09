1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 interface IERC20 {
68 	function balanceOf(address owner) external view returns (uint256 balance);
69 	function transfer(address to, uint256 value) external returns (bool success);
70 	function transferFrom(address from, address to, uint256 value) external returns (bool success);
71 	function approve(address spender, uint256 value) external returns (bool success);
72 	function allowance(address owner, address spender) external view returns (uint256 remaining);
73 
74 	event Transfer(address indexed from, address indexed to, uint256 value);
75 	event Approval(address indexed owner, address indexed spender, uint256 value);
76 	event Issuance(address indexed to, uint256 value);
77 }
78 
79 contract ERC20 is IERC20 {
80   using SafeMath for uint256;
81 
82   mapping (address => uint256) private _balances;
83 
84   mapping (address => mapping (address => uint256)) private _allowed;
85 
86   uint256 private _totalSupply;
87 
88   /**
89   * @dev Total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return _totalSupply;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param owner The address to query the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address owner) public view returns (uint256) {
101     return _balances[owner];
102   }
103 
104   /**
105    * @dev Function to check the amount of tokens that an owner allowed to a spender.
106    * @param owner address The address which owns the funds.
107    * @param spender address The address which will spend the funds.
108    * @return A uint256 specifying the amount of tokens still available for the spender.
109    */
110   function allowance(
111     address owner,
112     address spender
113    )
114     public
115     view
116     returns (uint256)
117   {
118     return _allowed[owner][spender];
119   }
120 
121   /**
122   * @dev Transfer token for a specified address
123   * @param to The address to transfer to.
124   * @param value The amount to be transferred.
125   */
126   function transfer(address to, uint256 value) public returns (bool) {
127     _transfer(msg.sender, to, value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param spender The address which will spend the funds.
138    * @param value The amount of tokens to be spent.
139    */
140   function approve(address spender, uint256 value) public returns (bool) {
141     require(spender != address(0));
142 
143     _allowed[msg.sender][spender] = value;
144     emit Approval(msg.sender, spender, value);
145     return true;
146   }
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param from address The address which you want to send tokens from
151    * @param to address The address which you want to transfer to
152    * @param value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(
155     address from,
156     address to,
157     uint256 value
158   )
159     public
160     returns (bool)
161   {
162     require(value <= _allowed[from][msg.sender]);
163 
164     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
165     _transfer(from, to, value);
166     return true;
167   }
168 
169   /**
170    * @dev Increase the amount of tokens that an owner allowed to a spender.
171    * approve should be called when allowed_[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    * @param spender The address which will spend the funds.
176    * @param addedValue The amount of tokens to increase the allowance by.
177    */
178   function increaseAllowance(
179     address spender,
180     uint256 addedValue
181   )
182     public
183     returns (bool)
184   {
185     require(spender != address(0));
186 
187     _allowed[msg.sender][spender] = (
188       _allowed[msg.sender][spender].add(addedValue));
189     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed_[_spender] == 0. To decrement
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param spender The address which will spend the funds.
200    * @param subtractedValue The amount of tokens to decrease the allowance by.
201    */
202   function decreaseAllowance(
203     address spender,
204     uint256 subtractedValue
205   )
206     public
207     returns (bool)
208   {
209     require(spender != address(0));
210 
211     _allowed[msg.sender][spender] = (
212       _allowed[msg.sender][spender].sub(subtractedValue));
213     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
214     return true;
215   }
216 
217   /**
218   * @dev Transfer token for a specified addresses
219   * @param from The address to transfer from.
220   * @param to The address to transfer to.
221   * @param value The amount to be transferred.
222   */
223   function _transfer(address from, address to, uint256 value) internal {
224     require(value <= _balances[from]);
225     require(to != address(0));
226 
227     _balances[from] = _balances[from].sub(value);
228     _balances[to] = _balances[to].add(value);
229     emit Transfer(from, to, value);
230   }
231 
232   /**
233    * @dev Internal function that mints an amount of the token and assigns it to
234    * an account. This encapsulates the modification of balances such that the
235    * proper events are emitted.
236    * @param account The account that will receive the created tokens.
237    * @param value The amount that will be created.
238    */
239   function _mint(address account, uint256 value) internal {
240     require(account != 0);
241     _totalSupply = _totalSupply.add(value);
242     _balances[account] = _balances[account].add(value);
243     emit Transfer(address(0), account, value);
244   }
245 
246   /**
247    * @dev Internal function that burns an amount of the token of a given
248    * account.
249    * @param account The account whose tokens will be burnt.
250    * @param value The amount that will be burnt.
251    */
252   function _burn(address account, uint256 value) internal {
253     require(account != 0);
254     require(value <= _balances[account]);
255 
256     _totalSupply = _totalSupply.sub(value);
257     _balances[account] = _balances[account].sub(value);
258     emit Transfer(account, address(0), value);
259   }
260 
261   /**
262    * @dev Internal function that burns an amount of the token of a given
263    * account, deducting from the sender's allowance for said account. Uses the
264    * internal burn function.
265    * @param account The account whose tokens will be burnt.
266    * @param value The amount that will be burnt.
267    */
268   function _burnFrom(address account, uint256 value) internal {
269     require(value <= _allowed[account][msg.sender]);
270 
271     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
272     // this function needs to emit an event with the updated approval.
273     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
274       value);
275     _burn(account, value);
276   }
277 }
278 
279 contract ERC20Burnable is ERC20 {
280 
281   /**
282    * @dev Burns a specific amount of tokens.
283    * @param value The amount of token to be burned.
284    */
285   function burn(uint256 value) public {
286     _burn(msg.sender, value);
287   }
288 
289   /**
290    * @dev Burns a specific amount of tokens from the target address and decrements allowance
291    * @param from address The address which you want to send tokens from
292    * @param value uint256 The amount of token to be burned
293    */
294   function burnFrom(address from, uint256 value) public {
295     _burnFrom(from, value);
296   }
297 }
298 
299 contract Owned {
300 
301 	address public owner = msg.sender;
302 	address public potentialOwner;
303 
304 	modifier onlyOwner {
305 		require(msg.sender == owner);
306 		_;
307 	}
308 
309 	modifier onlyPotentialOwner {
310 		require(msg.sender == potentialOwner);
311 		_;
312 	}
313 
314 	event NewOwner(address old, address current);
315 	event NewPotentialOwner(address old, address potential);
316 
317 	function setOwner(address _new)
318 		public
319 		onlyOwner
320 	{
321 		emit NewPotentialOwner(owner, _new);
322 		potentialOwner = _new;
323 	}
324 
325 	function confirmOwnership()
326 		public
327 		onlyPotentialOwner
328 	{
329 		emit NewOwner(owner, potentialOwner);
330 		owner = potentialOwner;
331 		potentialOwner = address(0);
332 	}
333 }
334 
335 contract Token is ERC20Burnable, Owned {
336 
337 	// Time of the contract creation
338 	uint256 public creationTime;
339 
340 	constructor() public {
341 		/* solium-disable-next-line security/no-block-members */
342 		creationTime = now;
343 	}
344 
345 	/// @dev Owner can transfer out any accidentally sent ERC20 tokens
346 	function transferERC20Token(IERC20 _token, address _to, uint256 _value)
347 		public
348 		onlyOwner
349 		returns (bool success)
350 	{
351 		require(_token.balanceOf(address(this)) >= _value);
352 		uint256 receiverBalance = _token.balanceOf(_to);
353 		require(_token.transfer(_to, _value));
354 
355 		uint256 receiverNewBalance = _token.balanceOf(_to);
356 		assert(receiverNewBalance == receiverBalance + _value);
357 
358 		return true;
359 	}
360 }
361 
362 contract LockedTokenMock is Token {
363 
364     string constant public name = 'Fluence Presale Token Test';
365     string constant public symbol = 'FPT-Test';
366     uint8  constant public decimals = 18;
367 
368     function mint(address account, uint256 value) public {
369         _mint(account, value);
370     }
371 
372     function _transfer(address from, address to, uint256 value) internal {
373 	    require(false);
374 	}
375 }