1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4 	function transfer(address to, uint256 value) external returns (bool);
5 
6 	function approve(address spender, uint256 value) external returns (bool);
7 
8 	function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10 	function totalSupply() external view returns (uint256);
11 
12 	function balanceOf(address who) external view returns (uint256);
13 
14 	function allowance(address owner, address spender) external view returns (uint256);
15 
16 	event Transfer(address indexed from, address indexed to, uint256 value);
17 
18 	event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 /**
21  * @title SafeMath
22  * @dev Unsigned math operations with safety checks that revert on error
23  */
24 library SafeMath {
25 	/**
26      * @dev Multiplies two unsigned integers, reverts on overflow.
27      */
28 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30 		// benefit is lost if 'b' is also tested.
31 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32 		if (a == 0) {
33 			return 0;
34 		}
35 
36 		uint256 c = a * b;
37 		require(c / a == b);
38 
39 		return c;
40 	}
41 
42 	/**
43      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
44      */
45 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
46 		// Solidity only automatically asserts when dividing by 0
47 		require(b > 0);
48 		uint256 c = a / b;
49 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51 		return c;
52 	}
53 
54 	/**
55      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
56      */
57 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58 		require(b <= a);
59 		uint256 c = a - b;
60 
61 		return c;
62 	}
63 
64 	/**
65      * @dev Adds two unsigned integers, reverts on overflow.
66      */
67 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
68 		uint256 c = a + b;
69 		require(c >= a);
70 
71 		return c;
72 	}
73 
74 	/**
75      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
76      * reverts when dividing by zero.
77      */
78 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79 		require(b != 0);
80 		return a % b;
81 	}
82 }
83 
84 /**
85  * @title ERC20Detailed token
86  * @dev The decimals are only for visualization purposes.
87  * All the operations are done using the smallest and indivisible token unit,
88  * just as on Ethereum all the operations are done in wei.
89  */
90 contract ERC20Detailed is IERC20 {
91 	string private _name;
92 	string private _symbol;
93 	uint8 private _decimals;
94 
95 	constructor (string memory name, string memory symbol, uint8 decimals) public {
96 		_name = name;
97 		_symbol = symbol;
98 		_decimals = decimals;
99 	}
100 
101 	/**
102      * @return the name of the token.
103      */
104 	function name() public view returns (string memory) {
105 		return _name;
106 	}
107 
108 	/**
109      * @return the symbol of the token.
110      */
111 	function symbol() public view returns (string memory) {
112 		return _symbol;
113 	}
114 
115 	/**
116      * @return the number of decimals of the token.
117      */
118 	function decimals() public view returns (uint8) {
119 		return _decimals;
120 	}
121 }
122 
123 contract ERC20 is IERC20 {
124 	using SafeMath for uint256;
125 
126 	mapping (address => uint256) private _balances;
127 
128 	mapping (address => mapping (address => uint256)) private _allowed;
129 
130 	uint256 private _totalSupply;
131 
132 	/**
133      * @dev Total number of tokens in existence
134      */
135 	function totalSupply() public view returns (uint256) {
136 		return _totalSupply;
137 	}
138 
139 	/**
140      * @dev Gets the balance of the specified address.
141      * @param owner The address to query the balance of.
142      * @return A uint256 representing the amount owned by the passed address.
143      */
144 	function balanceOf(address owner) public view returns (uint256) {
145 		return _balances[owner];
146 	}
147 
148 	/**
149      * @dev Function to check the amount of tokens that an owner allowed to a spender.
150      * @param owner address The address which owns the funds.
151      * @param spender address The address which will spend the funds.
152      * @return A uint256 specifying the amount of tokens still available for the spender.
153      */
154 	function allowance(address owner, address spender) public view returns (uint256) {
155 		return _allowed[owner][spender];
156 	}
157 
158 	/**
159      * @dev Transfer token to a specified address
160      * @param to The address to transfer to.
161      * @param value The amount to be transferred.
162      */
163 	function transfer(address to, uint256 value) public returns (bool) {
164 		_transfer(msg.sender, to, value);
165 		return true;
166 	}
167 
168 	/**
169      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param spender The address which will spend the funds.
175      * @param value The amount of tokens to be spent.
176      */
177 	function approve(address spender, uint256 value) public returns (bool) {
178 		_approve(msg.sender, spender, value);
179 		return true;
180 	}
181 
182 	/**
183      * @dev Transfer tokens from one address to another.
184      * Note that while this function emits an Approval event, this is not required as per the specification,
185      * and other compliant implementations may not emit the event.
186      * @param from address The address which you want to send tokens from
187      * @param to address The address which you want to transfer to
188      * @param value uint256 the amount of tokens to be transferred
189      */
190 	function transferFrom(address from, address to, uint256 value) public returns (bool) {
191 		_transfer(from, to, value);
192 		_approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
193 		return true;
194 	}
195 
196 	/**
197      * @dev Increase the amount of tokens that an owner allowed to a spender.
198      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * Emits an Approval event.
203      * @param spender The address which will spend the funds.
204      * @param addedValue The amount of tokens to increase the allowance by.
205      */
206 	function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
207 		_approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
208 		return true;
209 	}
210 
211 	/**
212      * @dev Decrease the amount of tokens that an owner allowed to a spender.
213      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * Emits an Approval event.
218      * @param spender The address which will spend the funds.
219      * @param subtractedValue The amount of tokens to decrease the allowance by.
220      */
221 	function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
222 		_approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
223 		return true;
224 	}
225 
226 	/**
227      * @dev Transfer token for a specified addresses
228      * @param from The address to transfer from.
229      * @param to The address to transfer to.
230      * @param value The amount to be transferred.
231      */
232 	function _transfer(address from, address to, uint256 value) internal {
233 		require(to != address(0));
234 
235 		_balances[from] = _balances[from].sub(value);
236 		_balances[to] = _balances[to].add(value);
237 		emit Transfer(from, to, value);
238 	}
239 
240 	/**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247 	function _mint(address account, uint256 value) internal {
248 		require(account != address(0));
249 
250 		_totalSupply = _totalSupply.add(value);
251 		_balances[account] = _balances[account].add(value);
252 		emit Transfer(address(0), account, value);
253 	}
254 
255 	/**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261 	function _burn(address account, uint256 value) internal {
262 		require(account != address(0));
263 
264 		_totalSupply = _totalSupply.sub(value);
265 		_balances[account] = _balances[account].sub(value);
266 		emit Transfer(account, address(0), value);
267 	}
268 
269 	/**
270      * @dev Approve an address to spend another addresses' tokens.
271      * @param owner The address that owns the tokens.
272      * @param spender The address that will spend the tokens.
273      * @param value The number of tokens that can be spent.
274      */
275 	function _approve(address owner, address spender, uint256 value) internal {
276 		require(spender != address(0));
277 		require(owner != address(0));
278 
279 		_allowed[owner][spender] = value;
280 		emit Approval(owner, spender, value);
281 	}
282 
283 	/**
284      * @dev Internal function that burns an amount of the token of a given
285      * account, deducting from the sender's allowance for said account. Uses the
286      * internal burn function.
287      * Emits an Approval event (reflecting the reduced allowance).
288      * @param account The account whose tokens will be burnt.
289      * @param value The amount that will be burnt.
290      */
291 	function _burnFrom(address account, uint256 value) internal {
292 		_burn(account, value);
293 		_approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
294 	}
295 }
296 
297 pragma solidity ^0.5.0;
298 
299 contract CryptoMarketAdsToken is ERC20, ERC20Detailed {
300 
301 	uint256 private INITIAL_SUPPLY = 10000000000e18;
302 	constructor () public
303 	ERC20Detailed("CryptoMarketAdsToken", "CMA", 18)
304 	{
305 		_mint(msg.sender, INITIAL_SUPPLY);
306 	}
307 }