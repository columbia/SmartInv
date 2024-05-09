1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9   function balanceOf(address who) external view returns (uint256);
10   function allowance(address owner, address spender) external view returns (uint256);
11   function transfer(address to, uint256 value) external returns (bool);
12   function approve(address spender, uint256 value) external returns (bool);
13   function transferFrom(address from, address to, uint256 value) external returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that revert on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, reverts on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     uint256 c = a * b;
37     require(c / a == b);
38 
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     require(b > 0); // Solidity only automatically asserts when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 
50     return c;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b <= a);
58     uint256 c = a - b;
59 
60     return c;
61   }
62 
63   /**
64   * @dev Adds two numbers, reverts on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     require(c >= a);
69 
70     return c;
71   }
72 
73   /**
74   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
75   * reverts when dividing by zero.
76   */
77   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b != 0);
79     return a % b;
80   }
81 }
82 
83 /**
84  * @title Standard ERC20 token
85  *
86  * @dev Implementation of the basic standard token.
87  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
88  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  */
90 contract ERC20 is IERC20 {
91   using SafeMath for uint256;
92 
93   string private _name;
94   string private _symbol;
95   uint8 private _decimals;
96   uint256 private _totalSupply;
97   mapping (address => uint256) private _balances;
98   mapping (address => mapping (address => uint256)) private _allowed;
99   
100 
101   constructor(string name, string symbol, uint8 decimals) public {
102     _name = name;
103     _symbol = symbol;
104     _decimals = decimals;
105   }
106 
107   /**
108    * @return the name of the token.
109    */
110   function name() public view returns(string) {
111     return _name;
112   }
113 
114   /**
115    * @return the symbol of the token.
116    */
117   function symbol() public view returns(string) {
118     return _symbol;
119   }
120 
121   /**
122    * @return the number of decimals of the token.
123    */
124   function decimals() public view returns(uint8) {
125     return _decimals;
126   }
127 
128   /**
129   * @dev Total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return _totalSupply;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param owner The address to query the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address owner) public view returns (uint256) {
141     return _balances[owner];
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param owner address The address which owns the funds.
147    * @param spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address owner, address spender) public view returns (uint256) {
151     return _allowed[owner][spender];
152   }
153 
154   /**
155   * @dev Transfer token for a specified address
156   * @param to The address to transfer to.
157   * @param value The amount to be transferred.
158   */
159   function transfer(address to, uint256 value) public returns (bool) {
160     _transfer(msg.sender, to, value);
161     return true;
162   }
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param from address The address which you want to send tokens from
167    * @param to address The address which you want to transfer to
168    * @param value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(address from, address to, uint256 value) public returns (bool) {
171     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
172     _transfer(from, to, value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param spender The address which will spend the funds.
183    * @param value The amount of tokens to be spent.
184    */
185   function approve(address spender, uint256 value) public returns (bool) {
186     require(spender != address(0));
187 
188     _allowed[msg.sender][spender] = value;
189     emit Approval(msg.sender, spender, value);
190     return true;
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed_[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param spender The address which will spend the funds.
200    * @param addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
203     require(spender != address(0));
204 
205     _allowed[msg.sender][spender] = (
206       _allowed[msg.sender][spender].add(addedValue));
207     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    * approve should be called when allowed_[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param spender The address which will spend the funds.
218    * @param subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
221     require(spender != address(0));
222 
223     _allowed[msg.sender][spender] = (
224       _allowed[msg.sender][spender].sub(subtractedValue));
225     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
226     return true;
227   }
228 
229   /**
230   * @dev Transfer token for a specified addresses
231   * @param from The address to transfer from.
232   * @param to The address to transfer to.
233   * @param value The amount to be transferred.
234   */
235   function _transfer(address from, address to, uint256 value) internal {
236     require(to != address(0));
237 
238     _balances[from] = _balances[from].sub(value);
239     _balances[to] = _balances[to].add(value);
240     emit Transfer(from, to, value);
241   }
242 
243   /**
244    * @dev Internal function that mints an amount of the token and assigns it to
245    * an account. This encapsulates the modification of balances such that the
246    * proper events are emitted.
247    * @param account The account that will receive the created tokens.
248    * @param value The amount that will be created.
249    */
250   function _mint(address account, uint256 value) internal {
251     require(account != address(0));
252 
253     _totalSupply = _totalSupply.add(value);
254     _balances[account] = _balances[account].add(value);
255     emit Transfer(address(0), account, value);
256   }
257 
258   /**
259    * @dev Internal function that burns an amount of the token of a given
260    * account.
261    * @param account The account whose tokens will be burnt.
262    * @param value The amount that will be burnt.
263    */
264   function _burn(address account, uint256 value) internal {
265     require(account != address(0));
266 
267     _totalSupply = _totalSupply.sub(value);
268     _balances[account] = _balances[account].sub(value);
269     emit Transfer(account, address(0), value);
270   }
271 
272   /**
273    * @dev Internal function that burns an amount of the token of a given
274    * account, deducting from the sender's allowance for said account. Uses the
275    * internal burn function.
276    * @param account The account whose tokens will be burnt.
277    * @param value The amount that will be burnt.
278    */
279   function _burnFrom(address account, uint256 value) internal {
280     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
281     // this function needs to emit an event with the updated approval.
282     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
283     _burn(account, value);
284   }
285 }
286 
287 /**
288  * @title Ownable
289  * @dev The Ownable contract has an owner address, and provides basic authorization control
290  * functions, this simplifies the implementation of "user permissions".
291  */
292 contract Ownable {
293   address private _owner;
294   address private _admin;
295 
296   event OwnerTransferred(address indexed previousOwner, address indexed newOwner);
297   event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
298 
299   /**
300    * @dev The Ownable constructor sets the original owner and admin of the contract to the sender
301    * account.
302    */
303   constructor() internal {
304     _owner = msg.sender;
305     _admin = msg.sender;
306   }
307 
308   /**
309    * @return the address of the owner.
310    */
311   function owner() public view returns(address) {
312     return _owner;
313   }
314 
315   /**
316    * @dev Throws if called by any account other than the owner.
317    */
318   modifier onlyOwner() {
319     require(msg.sender == _owner);
320     _;
321   }
322 
323   /**
324    * @return the address of the Admin.
325    */
326   function admin() public view onlyOwner returns(address) {
327     return _admin;
328   }
329 
330   /**
331    * @dev Throws if called by any account other than the Admin.
332    */
333   modifier onlyAdmin() {
334     require(msg.sender == _admin);
335     _;
336   }
337 
338   /**
339    * @dev Allows the current owner to transfer control of the contract to a newOwner.
340    * @param newOwner The address to transfer ownership to.
341    */
342   function transferOwner(address newOwner) public onlyOwner {
343     _transferOwner(newOwner);
344   }
345 
346   /**
347    * @dev Transfers control of the contract to a newOwner.
348    * @param newOwner The address to transfer ownership to.
349    */
350   function _transferOwner(address newOwner) internal {
351     require(newOwner != address(0));
352     emit OwnerTransferred(_owner, newOwner);
353     _owner = newOwner;
354   }
355 
356   /**
357    * @dev Allows the current admin to transfer access of the contract mint, burn function to a newAdmin.
358    * @param newAdmin The address to transfer admin to.
359    */
360   function transferAdmin(address newAdmin) public onlyOwner {
361     _transferAdmin(newAdmin);
362   }
363 
364   /**
365    * @dev Transfers access of the contract mint, burn function to a newAdmin.
366    * @param newAdmin The address to transfer admin to.
367    */
368   function _transferAdmin(address newAdmin) internal {
369     require(newAdmin != address(0));
370     emit AdminTransferred(_admin, newAdmin);
371     _admin = newAdmin;
372   }
373 }
374 
375 /**
376  * @title LYZE Token
377  * @dev LYZE Token include minting, burning function
378  */
379 contract LYZEToken is ERC20, Ownable {
380 
381   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** 18);
382 
383   /**
384    * @dev Constructor that gives msg.sender all of existing tokens.
385    */
386   constructor() public ERC20("LYZE Token", "LZE", 18) Ownable() {
387     _mint(msg.sender, INITIAL_SUPPLY);
388   }
389 
390   
391   bool private _mintingFinished = false;
392 
393   event MintingFinished();
394 
395   modifier canMint() {
396     require(!_mintingFinished);
397     _;
398   }
399 
400   /**
401    * @dev Function to mint tokens
402    * @param to The address that will receive the minted tokens.
403    * @param value The amount of tokens to mint.
404    * @return A boolean that indicates if the operation was successful.
405    */
406   function mint(address to, uint256 value) public onlyAdmin canMint returns (bool) {
407     _mint(to, value);
408     return true;
409   }
410 
411   function finishMinting() public onlyAdmin canMint returns (bool) {
412     _mintingFinished = true;
413     emit MintingFinished();
414     return true;
415   }
416 
417   /**
418    * @dev Burns a specific amount of tokens.
419    * @param value The amount of token to be burned.
420    */
421   function burn(uint256 value) public onlyAdmin {
422     _burn(msg.sender, value);
423   }
424 
425   /**
426    * @dev Burns a specific amount of tokens from the target address and decrements allowance
427    * @param from address The address which you want to send tokens from
428    * @param value uint256 The amount of token to be burned
429    */
430   function burnFrom(address from, uint256 value) public onlyAdmin {
431     _burnFrom(from, value);
432   }
433 
434   /**
435   * @dev Transfer token for a specified address array
436   * @param tos The address array to transfer to.
437   * @param values The amount array to be transferred.
438   */
439   function multiTransfer(address[] tos, uint256[] values) public returns (bool) {
440     require(tos.length>0 && tos.length==values.length);
441     for (uint256 i = 0; i < tos.length; ++i) {
442       _transfer(msg.sender, tos[i], values[i]);
443     }
444     return true;
445   }
446 
447 }