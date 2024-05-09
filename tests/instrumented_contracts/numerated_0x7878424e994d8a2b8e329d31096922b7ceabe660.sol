1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // ImmVRse Token contract
5 // Symbol      : IMVR
6 // Name        : ImmVRse Token
7 // Decimals    : 18
8 // ----------------------------------------------------------------------------
9 
10 /**
11  * source code available at OpenZeppelin github repository
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public _owner;
18 
19 
20   event OwnershipRenounced(address indexed previousOwner);
21   event OwnershipTransferred(
22     address indexed previousOwner,
23     address indexed newOwner
24   );
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   constructor() public {
32     _owner = msg.sender;
33   }
34 
35   /**
36    * @return the address of the owner.
37    */
38   function owner() public view returns(address) {
39     return _owner;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(isOwner());
47     _;
48   }
49 
50   /**
51    * @return true if `msg.sender` is the owner of the contract.
52    */
53   function isOwner() public view returns(bool) {
54     return msg.sender == _owner;
55   }
56 
57   /**
58    * @dev Allows the current owner to relinquish control of the contract.
59    * @notice Renouncing to ownership will leave the contract without an owner.
60    * It will not be possible to call the functions with the `onlyOwner`
61    * modifier anymore.
62    */
63   function renounceOwnership() public onlyOwner {
64     emit OwnershipRenounced(_owner);
65     _owner = address(0);
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     _transferOwnership(newOwner);
74   }
75 
76   /**
77    * @dev Transfers control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function _transferOwnership(address newOwner) internal {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(_owner, newOwner);
83     _owner = newOwner;
84   }
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 interface IERC20 {
92   function totalSupply() external view returns (uint256);
93 
94   function balanceOf(address who) external view returns (uint256);
95 
96   function allowance(address owner, address spender)
97     external view returns (uint256);
98 
99   function transfer(address to, uint256 value) external returns (bool);
100 
101   function approve(address spender, uint256 value)
102     external returns (bool);
103 
104   function transferFrom(address from, address to, uint256 value)
105     external returns (bool);
106 
107   event Transfer(
108     address indexed from,
109     address indexed to,
110     uint256 value
111   );
112 
113   event Approval(
114     address indexed owner,
115     address indexed spender,
116     uint256 value
117   );
118 }
119 
120 /**
121  * @title SafeMath
122  * @dev Math operations with safety checks that revert on error
123  */
124 library SafeMath {
125 
126   /**
127   * @dev Multiplies two numbers, reverts on overflow.
128   */
129   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131     // benefit is lost if 'b' is also tested.
132     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
133     if (a == 0) {
134       return 0;
135     }
136 
137     uint256 c = a * b;
138     require(c / a == b);
139 
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     require(b > 0); // Solidity only automatically asserts when dividing by 0
148     uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151     return c;
152   }
153 
154   /**
155   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b <= a);
159     uint256 c = a - b;
160 
161     return c;
162   }
163 
164   /**
165   * @dev Adds two numbers, reverts on overflow.
166   */
167   function add(uint256 a, uint256 b) internal pure returns (uint256) {
168     uint256 c = a + b;
169     require(c >= a);
170 
171     return c;
172   }
173 
174   /**
175   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
176   * reverts when dividing by zero.
177   */
178   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179     require(b != 0);
180     return a % b;
181   }
182 }
183 
184 /**
185  * @title ERC20Detailed token
186  * @dev The decimals are only for visualization purposes.
187  * All the operations are done using the smallest and indivisible token unit,
188  * just as on Ethereum all the operations are done in wei.
189  */
190 contract ERC20Detailed is IERC20, Ownable {
191   string public _name;
192   string public _symbol;
193   uint8 public _decimals;
194 
195   constructor(string name, string symbol, uint8 decimals) public {
196     _name = name;
197     _symbol = symbol;
198     _decimals = decimals;
199   }
200 
201   /**
202    * @return the name of the token.
203    */
204   function name() public view returns(string) {
205     return _name;
206   }
207 
208   /**
209    * @return the symbol of the token.
210    */
211   function symbol() public view returns(string) {
212     return _symbol;
213   }
214 
215   /**
216    * @return the number of decimals of the token.
217    */
218   function decimals() public view returns(uint8) {
219     return _decimals;
220   }
221 }
222 
223 
224 /**
225  * @title Standard ERC20 token
226  *
227  * @dev Implementation of the basic standard token.
228  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
229  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
230  */
231 contract ERC20 is ERC20Detailed {
232   using SafeMath for uint256;
233 
234   mapping (address => uint256) public _balances;
235 
236   mapping (address => mapping (address => uint256)) public _allowed;
237 
238   uint256 public _totalSupply;
239 
240   /**
241   * @dev Total number of tokens in existence
242   */
243   function totalSupply() public view returns (uint256) {
244     return _totalSupply;
245   }
246 
247   /**
248   * @dev Gets the balance of the specified address.
249   * @param owner The address to query the balance of.
250   * @return An uint256 representing the amount owned by the passed address.
251   */
252   function balanceOf(address owner) public view returns (uint256) {
253     return _balances[owner];
254   }
255 
256   /**
257    * @dev Function to check the amount of tokens that an owner allowed to a spender.
258    * @param owner address The address which owns the funds.
259    * @param spender address The address which will spend the funds.
260    * @return A uint256 specifying the amount of tokens still available for the spender.
261    */
262   function allowance(
263     address owner,
264     address spender
265    )
266     public
267     view
268     returns (uint256)
269   {
270     return _allowed[owner][spender];
271   }
272 
273   /**
274   * @dev Transfer token for a specified address
275   * @param to The address to transfer to.
276   * @param value The amount to be transferred.
277   */
278   function transfer(address to, uint256 value) public returns (bool) {
279     require(value <= _balances[msg.sender]);
280     require(to != address(0));
281 
282     _balances[msg.sender] = _balances[msg.sender].sub(value);
283     _balances[to] = _balances[to].add(value);
284     emit Transfer(msg.sender, to, value);
285     return true;
286   }
287 
288   /**
289    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
290    * Beware that changing an allowance with this method brings the risk that someone may use both the old
291    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
292    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
293    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294    * @param spender The address which will spend the funds.
295    * @param value The amount of tokens to be spent.
296    */
297   function approve(address spender, uint256 value) public returns (bool) {
298     require(spender != address(0));
299 
300     _allowed[msg.sender][spender] = value;
301     emit Approval(msg.sender, spender, value);
302     return true;
303   }
304 
305   /**
306    * @dev Transfer tokens from one address to another
307    * @param from address The address which you want to send tokens from
308    * @param to address The address which you want to transfer to
309    * @param value uint256 the amount of tokens to be transferred
310    */
311   function transferFrom(
312     address from,
313     address to,
314     uint256 value
315   )
316     public
317     returns (bool)
318   {
319     require(value <= _balances[from]);
320     require(value <= _allowed[from][msg.sender]);
321     require(to != address(0));
322 
323     _balances[from] = _balances[from].sub(value);
324     _balances[to] = _balances[to].add(value);
325     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
326     emit Transfer(from, to, value);
327     return true;
328   }
329 
330   /**
331    * @dev Increase the amount of tokens that an owner allowed to a spender.
332    * approve should be called when allowed_[_spender] == 0. To increment
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param spender The address which will spend the funds.
337    * @param addedValue The amount of tokens to increase the allowance by.
338    */
339   function increaseAllowance(
340     address spender,
341     uint256 addedValue
342   )
343     public
344     returns (bool)
345   {
346     require(spender != address(0));
347 
348     _allowed[msg.sender][spender] = (
349       _allowed[msg.sender][spender].add(addedValue));
350     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
351     return true;
352   }
353 
354   /**
355    * @dev Decrease the amount of tokens that an owner allowed to a spender.
356    * approve should be called when allowed_[_spender] == 0. To decrement
357    * allowed value is better to use this function to avoid 2 calls (and wait until
358    * the first transaction is mined)
359    * From MonolithDAO Token.sol
360    * @param spender The address which will spend the funds.
361    * @param subtractedValue The amount of tokens to decrease the allowance by.
362    */
363   function decreaseAllowance(
364     address spender,
365     uint256 subtractedValue
366   )
367     public
368     returns (bool)
369   {
370     require(spender != address(0));
371 
372     _allowed[msg.sender][spender] = (
373       _allowed[msg.sender][spender].sub(subtractedValue));
374     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
375     return true;
376   }
377 
378   /**
379    * @dev Internal function that mints an amount of the token and assigns it to
380    * an account. This encapsulates the modification of balances such that the
381    * proper events are emitted.
382    * @param account The account that will receive the created tokens.
383    * @param amount The amount that will be created.
384    */
385   function _mint(address account, uint256 amount) internal {
386     require(account != 0);
387     _totalSupply = _totalSupply.add(amount);
388     _balances[account] = _balances[account].add(amount);
389     emit Transfer(address(0), account, amount);
390   }
391 
392   /**
393    * @dev Internal function that burns an amount of the token of a given
394    * account.
395    * @param account The account whose tokens will be burnt.
396    * @param amount The amount that will be burnt.
397    */
398   function _burn(address account, uint256 amount) internal {
399     require(account != 0);
400     require(amount <= _balances[account]);
401 
402     _totalSupply = _totalSupply.sub(amount);
403     _balances[account] = _balances[account].sub(amount);
404     emit Transfer(account, address(0), amount);
405   }
406 
407   /**
408    * @dev Internal function that burns an amount of the token of a given
409    * account, deducting from the sender's allowance for said account. Uses the
410    * internal burn function.
411    * @param account The account whose tokens will be burnt.
412    * @param amount The amount that will be burnt.
413    */
414   function _burnFrom(address account, uint256 amount) internal {
415     require(amount <= _allowed[account][msg.sender]);
416 
417     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
418     // this function needs to emit an event with the updated approval.
419     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
420       amount);
421     _burn(account, amount);
422   }
423 }
424 
425 /**
426  * @title Burnable Token
427  * @dev Token that can be irreversibly burned (destroyed).
428  */
429 contract ERC20Burnable is ERC20 {
430 
431   /**
432    * @dev Burns a specific amount of tokens.
433    * @param value The amount of token to be burned.
434    */
435   function burn(uint256 value) public {
436     _burn(msg.sender, value);
437   }
438 
439   /**
440    * @dev Burns a specific amount of tokens from the target address and decrements allowance
441    * @param from address The address which you want to send tokens from
442    * @param value uint256 The amount of token to be burned
443    */
444   function burnFrom(address from, uint256 value) public {
445     _burnFrom(from, value);
446   }
447 
448   /**
449    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
450    * an additional Burn event.
451    */
452   function _burn(address who, uint256 value) internal {
453     super._burn(who, value);
454   }
455 }
456 
457 
458 contract ImmVRseTokenContract is ERC20Burnable {
459 
460 
461     function ImmVRseTokenContract(
462         uint256 totalSupply
463     ) ERC20Detailed(
464         "ImmVRse Token",
465         "IMVR",
466         18
467     ) {
468         _totalSupply = totalSupply;
469         _balances[msg.sender] = totalSupply;
470     }
471 }