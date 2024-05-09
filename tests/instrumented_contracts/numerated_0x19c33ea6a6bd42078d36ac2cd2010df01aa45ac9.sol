1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address private _owner;
76 
77   event OwnershipTransferred(
78     address indexed previousOwner,
79     address indexed newOwner
80   );
81 
82   /**
83    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84    * account.
85    */
86   constructor() internal {
87     _owner = msg.sender;
88     emit OwnershipTransferred(address(0), _owner);
89   }
90 
91   /**
92    * @return the address of the owner.
93    */
94   function owner() public view returns(address) {
95     return _owner;
96   }
97 
98   /**
99    * @dev Throws if called by any account other than the owner.
100    */
101   modifier onlyOwner() {
102     require(isOwner());
103     _;
104   }
105 
106   /**
107    * @return true if `msg.sender` is the owner of the contract.
108    */
109   function isOwner() public view returns(bool) {
110     return msg.sender == _owner;
111   }
112 
113   /**
114    * @dev Allows the current owner to relinquish control of the contract.
115    * @notice Renouncing to ownership will leave the contract without an owner.
116    * It will not be possible to call the functions with the `onlyOwner`
117    * modifier anymore.
118    */
119   function renounceOwnership() public onlyOwner {
120     emit OwnershipTransferred(_owner, address(0));
121     _owner = address(0);
122   }
123 
124   /**
125    * @dev Allows the current owner to transfer control of the contract to a newOwner.
126    * @param newOwner The address to transfer ownership to.
127    */
128   function transferOwnership(address newOwner) public onlyOwner {
129     _transferOwnership(newOwner);
130   }
131 
132   /**
133    * @dev Transfers control of the contract to a newOwner.
134    * @param newOwner The address to transfer ownership to.
135    */
136   function _transferOwnership(address newOwner) internal {
137     require(newOwner != address(0));
138     emit OwnershipTransferred(_owner, newOwner);
139     _owner = newOwner;
140   }
141 }
142 
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 interface IERC20 {
149   function totalSupply() external view returns (uint256);
150 
151   function balanceOf(address who) external view returns (uint256);
152 
153   function allowance(address owner, address spender)
154     external view returns (uint256);
155 
156   function transfer(address to, uint256 value) external returns (bool);
157 
158   function approve(address spender, uint256 value)
159     external returns (bool);
160 
161   function transferFrom(address from, address to, uint256 value)
162     external returns (bool);
163 
164   event Transfer(
165     address indexed from,
166     address indexed to,
167     uint256 value
168   );
169 
170   event Approval(
171     address indexed owner,
172     address indexed spender,
173     uint256 value
174   );
175 }
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
183  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract ERC20 is IERC20 {
186   using SafeMath for uint256;
187 
188   mapping (address => uint256) private _balances;
189 
190   mapping (address => mapping (address => uint256)) private _allowed;
191 
192   uint256 private _totalSupply;
193 
194   /**
195   * @dev Total number of tokens in existence
196   */
197   function totalSupply() public view returns (uint256) {
198     return _totalSupply;
199   }
200 
201   /**
202   * @dev Gets the balance of the specified address.
203   * @param owner The address to query the balance of.
204   * @return An uint256 representing the amount owned by the passed address.
205   */
206   function balanceOf(address owner) public view returns (uint256) {
207     return _balances[owner];
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param owner address The address which owns the funds.
213    * @param spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(
217     address owner,
218     address spender
219    )
220     public
221     view
222     returns (uint256)
223   {
224     return _allowed[owner][spender];
225   }
226 
227   /**
228   * @dev Transfer token for a specified address
229   * @param to The address to transfer to.
230   * @param value The amount to be transferred.
231   */
232   function transfer(address to, uint256 value) public returns (bool) {
233     _transfer(msg.sender, to, value);
234     return true;
235   }
236 
237   /**
238    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param spender The address which will spend the funds.
244    * @param value The amount of tokens to be spent.
245    */
246   function approve(address spender, uint256 value) public returns (bool) {
247     require(spender != address(0));
248 
249     _allowed[msg.sender][spender] = value;
250     emit Approval(msg.sender, spender, value);
251     return true;
252   }
253 
254   /**
255    * @dev Transfer tokens from one address to another
256    * @param from address The address which you want to send tokens from
257    * @param to address The address which you want to transfer to
258    * @param value uint256 the amount of tokens to be transferred
259    */
260   function transferFrom(
261     address from,
262     address to,
263     uint256 value
264   )
265     public
266     returns (bool)
267   {
268     require(value <= _allowed[from][msg.sender]);
269 
270     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
271     _transfer(from, to, value);
272     return true;
273   }
274 
275   /**
276    * @dev Increase the amount of tokens that an owner allowed to a spender.
277    * approve should be called when allowed_[_spender] == 0. To increment
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param spender The address which will spend the funds.
282    * @param addedValue The amount of tokens to increase the allowance by.
283    */
284   function increaseAllowance(
285     address spender,
286     uint256 addedValue
287   )
288     public
289     returns (bool)
290   {
291     require(spender != address(0));
292 
293     _allowed[msg.sender][spender] = (
294       _allowed[msg.sender][spender].add(addedValue));
295     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
296     return true;
297   }
298 
299   /**
300    * @dev Decrease the amount of tokens that an owner allowed to a spender.
301    * approve should be called when allowed_[_spender] == 0. To decrement
302    * allowed value is better to use this function to avoid 2 calls (and wait until
303    * the first transaction is mined)
304    * From MonolithDAO Token.sol
305    * @param spender The address which will spend the funds.
306    * @param subtractedValue The amount of tokens to decrease the allowance by.
307    */
308   function decreaseAllowance(
309     address spender,
310     uint256 subtractedValue
311   )
312     public
313     returns (bool)
314   {
315     require(spender != address(0));
316 
317     _allowed[msg.sender][spender] = (
318       _allowed[msg.sender][spender].sub(subtractedValue));
319     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
320     return true;
321   }
322 
323   /**
324   * @dev Transfer token for a specified addresses
325   * @param from The address to transfer from.
326   * @param to The address to transfer to.
327   * @param value The amount to be transferred.
328   */
329   function _transfer(address from, address to, uint256 value) internal {
330     require(value <= _balances[from]);
331     require(to != address(0));
332 
333     _balances[from] = _balances[from].sub(value);
334     _balances[to] = _balances[to].add(value);
335     emit Transfer(from, to, value);
336   }
337 
338   /**
339    * @dev Internal function that mints an amount of the token and assigns it to
340    * an account. This encapsulates the modification of balances such that the
341    * proper events are emitted.
342    * @param account The account that will receive the created tokens.
343    * @param value The amount that will be created.
344    */
345   function _mint(address account, uint256 value) internal {
346     require(account != address(0));
347     _totalSupply = _totalSupply.add(value);
348     _balances[account] = _balances[account].add(value);
349     emit Transfer(address(0), account, value);
350   }
351 
352   /**
353    * @dev Internal function that burns an amount of the token of a given
354    * account.
355    * @param account The account whose tokens will be burnt.
356    * @param value The amount that will be burnt.
357    */
358   function _burn(address account, uint256 value) internal {
359     require(account != address(0));
360     require(value <= _balances[account]);
361 
362     _totalSupply = _totalSupply.sub(value);
363     _balances[account] = _balances[account].sub(value);
364     emit Transfer(account, address(0), value);
365   }
366 
367   /**
368    * @dev Internal function that burns an amount of the token of a given
369    * account, deducting from the sender's allowance for said account. Uses the
370    * internal burn function.
371    * @param account The account whose tokens will be burnt.
372    * @param value The amount that will be burnt.
373    */
374   function _burnFrom(address account, uint256 value) internal {
375     require(value <= _allowed[account][msg.sender]);
376 
377     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
378     // this function needs to emit an event with the updated approval.
379     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
380       value);
381     _burn(account, value);
382   }
383 }
384 
385 
386 /**
387  * @title Burnable Token
388  * @dev Token that can be irreversibly burned (destroyed).
389  */
390 contract ERC20Burnable is ERC20 {
391 
392   /**
393    * @dev Burns a specific amount of tokens.
394    * @param value The amount of token to be burned.
395    */
396   function burn(uint256 value) public {
397     _burn(msg.sender, value);
398   }
399 
400   /**
401    * @dev Burns a specific amount of tokens from the target address and decrements allowance
402    * @param from address The address which you want to send tokens from
403    * @param value uint256 The amount of token to be burned
404    */
405   function burnFrom(address from, uint256 value) public {
406     _burnFrom(from, value);
407   }
408 }
409 
410 
411 
412 /**
413  * @title CustomToken
414  * @dev Custom ERC20 token
415  */
416 contract PetGold is ERC20Burnable, Ownable {
417 
418   string public constant name = "PetGold";
419   string public constant symbol = "PETG";
420   uint8 public constant decimals = 18;
421 
422   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
423 
424   /**
425    * @dev Constructor that gives owner all of existing tokens.
426    */
427   constructor() public {
428     _mint(owner(), INITIAL_SUPPLY);
429   }
430 }