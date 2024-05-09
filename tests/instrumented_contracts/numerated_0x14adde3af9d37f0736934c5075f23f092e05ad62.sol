1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that revert on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, reverts on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     uint256 c = a * b;
99     require(c / a == b);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b > 0); // Solidity only automatically asserts when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112     return c;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b <= a);
120     uint256 c = a - b;
121 
122     return c;
123   }
124 
125   /**
126   * @dev Adds two numbers, reverts on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     require(c >= a);
131 
132     return c;
133   }
134 
135   /**
136   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
137   * reverts when dividing by zero.
138   */
139   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140     require(b != 0);
141     return a % b;
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 interface IERC20 {
152   function totalSupply() external view returns (uint256);
153 
154   function balanceOf(address who) external view returns (uint256);
155 
156   function allowance(address owner, address spender)
157     external view returns (uint256);
158 
159   function transfer(address to, uint256 value) external returns (bool);
160 
161   function approve(address spender, uint256 value)
162     external returns (bool);
163 
164   function transferFrom(address from, address to, uint256 value)
165     external returns (bool);
166 
167   event Transfer(
168     address indexed from,
169     address indexed to,
170     uint256 value
171   );
172 
173   event Approval(
174     address indexed owner,
175     address indexed spender,
176     uint256 value
177   );
178 }
179 
180 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
187  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract ERC20 is IERC20 {
190   using SafeMath for uint256;
191 
192   mapping (address => uint256) private _balances;
193 
194   mapping (address => mapping (address => uint256)) private _allowed;
195 
196   uint256 private _totalSupply;
197 
198   /**
199   * @dev Total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return _totalSupply;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param owner The address to query the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address owner) public view returns (uint256) {
211     return _balances[owner];
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param owner address The address which owns the funds.
217    * @param spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(
221     address owner,
222     address spender
223    )
224     public
225     view
226     returns (uint256)
227   {
228     return _allowed[owner][spender];
229   }
230 
231   /**
232   * @dev Transfer token for a specified address
233   * @param to The address to transfer to.
234   * @param value The amount to be transferred.
235   */
236   function transfer(address to, uint256 value) public returns (bool) {
237     _transfer(msg.sender, to, value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param spender The address which will spend the funds.
248    * @param value The amount of tokens to be spent.
249    */
250   function approve(address spender, uint256 value) public returns (bool) {
251     require(spender != address(0));
252 
253     _allowed[msg.sender][spender] = value;
254     emit Approval(msg.sender, spender, value);
255     return true;
256   }
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param from address The address which you want to send tokens from
261    * @param to address The address which you want to transfer to
262    * @param value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address from,
266     address to,
267     uint256 value
268   )
269     public
270     returns (bool)
271   {
272     require(value <= _allowed[from][msg.sender]);
273 
274     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
275     _transfer(from, to, value);
276     return true;
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed_[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param spender The address which will spend the funds.
286    * @param addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseAllowance(
289     address spender,
290     uint256 addedValue
291   )
292     public
293     returns (bool)
294   {
295     require(spender != address(0));
296 
297     _allowed[msg.sender][spender] = (
298       _allowed[msg.sender][spender].add(addedValue));
299     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed_[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param spender The address which will spend the funds.
310    * @param subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseAllowance(
313     address spender,
314     uint256 subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     require(spender != address(0));
320 
321     _allowed[msg.sender][spender] = (
322       _allowed[msg.sender][spender].sub(subtractedValue));
323     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
324     return true;
325   }
326 
327   /**
328   * @dev Transfer token for a specified addresses
329   * @param from The address to transfer from.
330   * @param to The address to transfer to.
331   * @param value The amount to be transferred.
332   */
333   function _transfer(address from, address to, uint256 value) internal {
334     require(value <= _balances[from]);
335     require(to != address(0));
336 
337     _balances[from] = _balances[from].sub(value);
338     _balances[to] = _balances[to].add(value);
339     emit Transfer(from, to, value);
340   }
341 
342   /**
343    * @dev Internal function that mints an amount of the token and assigns it to
344    * an account. This encapsulates the modification of balances such that the
345    * proper events are emitted.
346    * @param account The account that will receive the created tokens.
347    * @param value The amount that will be created.
348    */
349   function _mint(address account, uint256 value) internal {
350     require(account != 0);
351     _totalSupply = _totalSupply.add(value);
352     _balances[account] = _balances[account].add(value);
353     emit Transfer(address(0), account, value);
354   }
355 
356   /**
357    * @dev Internal function that burns an amount of the token of a given
358    * account.
359    * @param account The account whose tokens will be burnt.
360    * @param value The amount that will be burnt.
361    */
362   function _burn(address account, uint256 value) internal {
363     require(account != 0);
364     require(value <= _balances[account]);
365 
366     _totalSupply = _totalSupply.sub(value);
367     _balances[account] = _balances[account].sub(value);
368     emit Transfer(account, address(0), value);
369   }
370 
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account, deducting from the sender's allowance for said account. Uses the
374    * internal burn function.
375    * @param account The account whose tokens will be burnt.
376    * @param value The amount that will be burnt.
377    */
378   function _burnFrom(address account, uint256 value) internal {
379     require(value <= _allowed[account][msg.sender]);
380 
381     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
382     // this function needs to emit an event with the updated approval.
383     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
384       value);
385     _burn(account, value);
386   }
387 }
388 
389 // File: contracts/IsraCoin.sol
390 
391 contract IsraCoin is ERC20, Ownable{
392 
393     string public name = "IsraCoin";
394     string public symbol = "ILSX";
395 
396     /** @dev basically like cents in USD
397      **      in the following comments will be referencing the smallest units as cents 
398      **/
399     uint public decimals = 2;
400 
401     /**
402      * @notice Create some tokens and assign them to the given address
403      *         can only be called by the smart contract owner
404      * @param _to Destination address
405      * @param _amount How many tokens to create, in cents
406      */
407     function mint(address _to, uint _amount)
408         external
409         onlyOwner
410     {
411         _mint(_to, _amount);
412     }
413 
414     /**
415      * @notice Burn the specified amount of tokens from any address
416      *         can only be called by the smart contract owner
417      * @param _where Owner of the tokens to be burned
418      * @param _amount How many tokens to burn, in cents
419      */
420     function burn(address _where, uint _amount)
421         external
422         onlyOwner
423     {
424         _burn(_where, _amount);
425     }
426 
427     /**
428      * @notice Transfer anyone's tokens to a different account
429      *         can only be called by the smart contract owner
430      * @param _from Source address
431      * @param _to Destination address
432      * @param _value How many tokens to transfer, in cents
433      */
434     function transferByForce(address _from, address _to, uint _value)
435         external
436         onlyOwner
437     {
438         _transfer(_from, _to, _value);
439     }
440 }