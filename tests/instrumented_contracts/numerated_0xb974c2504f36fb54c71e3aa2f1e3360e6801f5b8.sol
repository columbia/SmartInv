1 pragma solidity ^0.4.24;
2 /**
3 * @title SafeMath
4 * @dev Math operations with safety checks that revert on error
5 */
6 library SafeMath {
7 /**
8 * @dev Multiplies two numbers, reverts on overflow.
9 */
10 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12 // benefit is lost if 'b' is also tested.
13 // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14 if (a == 0) {
15 return 0;
16 }
17 uint256 c = a * b;
18 require(c / a == b);
19 return c;
20 }
21 /**
22 * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
23 */
24 function div(uint256 a, uint256 b) internal pure returns (uint256) {
25 require(b > 0); // Solidity only automatically asserts when dividing by 0
26 uint256 c = a / b;
27 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 return c;
29 }
30 /**
31 * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
32 */
33 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34 require(b <= a);
35 uint256 c = a - b;
36 return c;
37 }
38 /**
39 * @dev Adds two numbers, reverts on overflow.
40 */
41 function add(uint256 a, uint256 b) internal pure returns (uint256) {
42 uint256 c = a + b;
43 require(c >= a);
44 return c;
45 }
46 /**
47 * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
48 * reverts when dividing by zero.
49 */
50 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51 require(b != 0);
52 return a % b;
53 }
54 }
55 /**
56 * @title Ownable
57 * @dev The Ownable contract has an owner address, and provides basic authorization control
58 * functions, this simplifies the implementation of \"user permissions\".
59 */
60 contract Ownable {
61 address private _owner;
62 event OwnershipTransferred(
63 address indexed previousOwner,
64 address indexed newOwner
65 );
66 /**
67 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68 * account.
69 */
70 constructor() internal {
71 _owner = msg.sender;
72 emit OwnershipTransferred(address(0), _owner);
73 }
74 /**
75 * @return the address of the owner.
76 */
77 function owner() public view returns(address) {
78 return _owner;
79 }
80 /**
81 * @dev Throws if called by any account other than the owner.
82 */
83 modifier onlyOwner() {
84 require(isOwner());
85 _;
86 }
87 /**
88 * @return true if `msg.sender` is the owner of the contract.
89 */
90 function isOwner() public view returns(bool) {
91 return msg.sender == _owner;
92 }
93 /**
94 * @dev Allows the current owner to relinquish control of the contract.
95 * @notice Renouncing to ownership will leave the contract without an owner.
96 * It will not be possible to call the functions with the `onlyOwner`
97 * modifier anymore.
98 */
99 function renounceOwnership() public onlyOwner {
100 emit OwnershipTransferred(_owner, address(0));
101 _owner = address(0);
102 }
103 /**
104 * @dev Allows the current owner to transfer control of the contract to a newOwner.
105 * @param newOwner The address to transfer ownership to.
106 */
107 function transferOwnership(address newOwner) public onlyOwner {
108 _transferOwnership(newOwner);
109 }
110 /**
111 * @dev Transfers control of the contract to a newOwner.
112 * @param newOwner The address to transfer ownership to.
113 */
114 function _transferOwnership(address newOwner) internal {
115 require(newOwner != address(0));
116 emit OwnershipTransferred(_owner, newOwner);
117 _owner = newOwner;
118 }
119 }
120 /**
121 * @title ERC20 interface
122 * @dev see https://github.com/ethereum/EIPs/issues/20
123 */
124 interface IERC20 {
125 function totalSupply() external view returns (uint256);
126 function balanceOf(address who) external view returns (uint256);
127 function allowance(address owner, address spender)
128 external view returns (uint256);
129 function transfer(address to, uint256 value) external returns (bool);
130 function approve(address spender, uint256 value)
131 external returns (bool);
132 function transferFrom(address from, address to, uint256 value)
133 external returns (bool);
134 event Transfer(
135 address indexed from,
136 address indexed to,
137 uint256 value
138 );
139 event Approval(
140 address indexed owner,
141 address indexed spender,
142 uint256 value
143 );
144 }
145 /**
146 * @title Standard ERC20 token
147 *
148 * @dev Implementation of the basic standard token.
149 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
150 * 
151 */
152 contract Uptherium is IERC20, Ownable {
153 
154 using SafeMath for uint256;
155 mapping (address => uint256) private _balances;
156 mapping (address => mapping (address => uint256)) private _allowed;
157 
158 mapping (address => bool) public allowedAddresses;
159 
160 uint256 private _totalSupply;
161 string private _name = "Uptherium";
162 string private _symbol = "UPZT";
163 uint8 private _decimals = 18;
164 bool private _poolsSetted;
165 bool private _burningAllowed;
166 
167 event Burn(address indexed owner,
168 uint256 value
169 );
170 
171 modifier checkTransfer() {
172 require(allowedAddresses[msg.sender] == true);
173 _;
174 }
175 constructor() public {
176 _poolsSetted = false;
177 _burningAllowed = false;
178 allowedAddresses[msg.sender] = true;
179 
180 }
181 
182 /**
183 * @dev Function for adding address to the whitelist.
184 */
185 function addAddress(address newAddress) public onlyOwner {
186 allowedAddresses[newAddress] = true;
187 }
188 
189 /**
190 * @dev Function for removing address from whitelist.
191 */
192 function removeAddress(address oldAddress) public onlyOwner {
193 allowedAddresses[oldAddress] = false;
194 }
195 
196 /**
197 * @dev Function for initial token minting.
198 */
199 function initialMint(address icoPool, address bountyPool, address teamPool, uint256 icoValue, uint256 bountyValue, uint256 teamValue) public onlyOwner {
200 require(!_poolsSetted);
201 _mint(icoPool, icoValue);
202 _mint(bountyPool, bountyValue);
203 _mint(teamPool, teamValue);
204 _poolsSetted = true;
205 }
206 
207 /**
208 * @return the name of the token.
209 */
210 function name() public view returns(string) {
211 return _name;
212 }
213 /**
214 * @return the symbol of the token.
215 */
216 function symbol() public view returns(string) {
217 return _symbol;
218 }
219 /**
220 * @return the number of decimals of the token.
221 */
222 function decimals() public view returns(uint8) {
223 return _decimals;
224 }
225 /**
226 * @dev Total number of tokens in existence
227 */
228 function totalSupply() public view returns (uint256) {
229 return _totalSupply;
230 }
231 /**
232 * @dev Gets the balance of the specified address.
233 * @param owner The address to query the balance of.
234 * @return An uint256 representing the amount owned by the passed address.
235 */
236 function balanceOf(address owner) public view returns (uint256) {
237 return _balances[owner];
238 }
239 /**
240 * @dev Function to check the amount of tokens that an owner allowed to a spender.
241 * @param owner address The address which owns the funds.
242 * @param spender address The address which will spend the funds.
243 * @return A uint256 specifying the amount of tokens still available for the spender.
244 */
245 function allowance(
246 address owner,
247 address spender
248 )
249 public
250 view
251 returns (uint256)
252 {
253 return _allowed[owner][spender];
254 }
255 /**
256 * @dev Transfer token for a specified address
257 * @param to The address to transfer to.
258 * @param value The amount to be transferred.
259 */
260 function transfer(address to, uint256 value) public checkTransfer returns (bool) {
261 _transfer(msg.sender, to, value);
262 return true;
263 }
264 /**
265 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
266 * Beware that changing an allowance with this method brings the risk that someone may use both the old
267 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
268 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
269 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270 * @param spender The address which will spend the funds.
271 * @param value The amount of tokens to be spent.
272 */
273 function approve(address spender, uint256 value) public returns (bool) {
274 require(spender != address(0));
275 _allowed[msg.sender][spender] = value;
276 emit Approval(msg.sender, spender, value);
277 return true;
278 }
279 /**
280 * @dev Transfer tokens from one address to another
281 * @param from address The address which you want to send tokens from
282 * @param to address The address which you want to transfer to
283 * @param value uint256 the amount of tokens to be transferred
284 */
285 function transferFrom(address from, address to, uint256 value) public checkTransfer returns (bool) {
286 _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
287 _transfer(from, to, value);
288 return true;
289 }
290 /**
291 * @dev Increase the amount of tokens that an owner allowed to a spender.
292 * approve should be called when allowed_[_spender] == 0. To increment
293 * allowed value is better to use this function to avoid 2 calls (and wait until
294 * the first transaction is mined)
295 * From MonolithDAO Token.sol
296 * @param spender The address which will spend the funds.
297 * @param addedValue The amount of tokens to increase the allowance by.
298 */
299 function increaseAllowance(
300 address spender,
301 uint256 addedValue
302 )
303 public
304 returns (bool)
305 {
306 require(spender != address(0));
307 _allowed[msg.sender][spender] = (
308 _allowed[msg.sender][spender].add(addedValue));
309 emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
310 return true;
311 }
312 /**
313 * @dev Decrease the amount of tokens that an owner allowed to a spender.
314 * approve should be called when allowed_[_spender] == 0. To decrement
315 * allowed value is better to use this function to avoid 2 calls (and wait until
316 * the first transaction is mined)
317 * From MonolithDAO Token.sol
318 * @param spender The address which will spend the funds.
319 * @param subtractedValue The amount of tokens to decrease the allowance by.
320 */
321 function decreaseAllowance(
322 address spender,
323 uint256 subtractedValue
324 )
325 public
326 returns (bool)
327 {
328 require(spender != address(0));
329 _allowed[msg.sender][spender] = (
330 _allowed[msg.sender][spender].sub(subtractedValue));
331 emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
332 return true;
333 }
334 /**
335 * @dev Transfer token for a specified addresses
336 * @param from The address to transfer from.
337 * @param to The address to transfer to.
338 * @param value The amount to be transferred.
339 */
340 function _transfer(address from, address to, uint256 value) internal {
341 require(to != address(0));
342 _balances[from] = _balances[from].sub(value);
343 _balances[to] = _balances[to].add(value);
344 emit Transfer(from, to, value);
345 }
346 /**
347 * @dev Internal function that mints an amount of the token and assigns it to
348 * an account. This encapsulates the modification of balances such that the
349 * proper events are emitted.
350 * @param account The account that will receive the created tokens.
351 * @param value The amount that will be created.
352 */
353 function _mint(address account, uint256 value) internal {
354 require(account != address(0));
355 _totalSupply = _totalSupply.add(value);
356 _balances[account] = _balances[account].add(value);
357 emit Transfer(address(0), account, value);
358 }
359 
360 /**
361 * @dev Public function that allows burning an amount of the token.
362 */
363 function allowBurning() public onlyOwner returns(bool) {
364 _burningAllowed = true;
365 return _burningAllowed;
366 }
367 
368 /**
369 * @dev Public function that burns an amount of the token and assigns it to
370 * an account. This encapsulates the modification of balances such that the
371 * proper events are emitted.
372 * @param value The amount that will be burned.
373 */
374 function burn(uint256 value) public {
375 require(_burningAllowed);  
376 require(msg.sender != address(0));
377 require(_balances[msg.sender] >= value);
378 _totalSupply = _totalSupply.sub(value);
379 _balances[msg.sender] = _balances[msg.sender].sub(value);
380 emit Burn(address(msg.sender), value);
381 }
382 }