1 /**
2  * @title TratataToken
3  * @dev see https://github.com/nerjs
4  */
5 
6 /* Ownable */
7 pragma solidity ^0.4.24;
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address private _owner;
16 
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() internal {
27     _owner = msg.sender;
28     emit OwnershipTransferred(address(0), _owner);
29   }
30 
31   /**
32    * @return the address of the owner.
33    */
34   function owner() public view returns(address) {
35     return _owner;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(isOwner());
43     _;
44   }
45 
46   /**
47    * @return true if `msg.sender` is the owner of the contract.
48    */
49   function isOwner() public view returns(bool) {
50     return msg.sender == _owner;
51   }
52 
53   /**
54    * @dev Allows the current owner to relinquish control of the contract.
55    * @notice Renouncing to ownership will leave the contract without an owner.
56    * It will not be possible to call the functions with the `onlyOwner`
57    * modifier anymore.
58    */
59   function renounceOwnership() public onlyOwner {
60     emit OwnershipTransferred(_owner, address(0));
61     _owner = address(0);
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     _transferOwnership(newOwner);
70   }
71 
72   /**
73    * @dev Transfers control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function _transferOwnership(address newOwner) internal {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(_owner, newOwner);
79     _owner = newOwner;
80   }
81 }      
82 
83 /* SafeMath */ 
84 pragma solidity ^0.4.24;
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that revert on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, reverts on overflow.
94   */
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97     // benefit is lost if 'b' is also tested.
98     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99     if (a == 0) {
100       return 0;
101     }
102 
103     uint256 c = a * b;
104     require(c / a == b);
105 
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     require(b > 0); // Solidity only automatically asserts when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117     return c;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     require(b <= a);
125     uint256 c = a - b;
126 
127     return c;
128   }
129 
130   /**
131   * @dev Adds two numbers, reverts on overflow.
132   */
133   function add(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a + b;
135     require(c >= a);
136 
137     return c;
138   }
139 
140   /**
141   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
142   * reverts when dividing by zero.
143   */
144   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145     require(b != 0);
146     return a % b;
147   }
148 }
149 
150 /* EIRC20 */
151 pragma solidity ^0.4.24;
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 interface IERC20 {
158   function totalSupply() external view returns (uint256);
159 
160   function balanceOf(address who) external view returns (uint256);
161 
162   function allowance(address owner, address spender)
163     external view returns (uint256);
164 
165   function transfer(address to, uint256 value) external returns (bool);
166 
167   function approve(address spender, uint256 value)
168     external returns (bool);
169 
170   function transferFrom(address from, address to, uint256 value)
171     external returns (bool);
172 
173   event Transfer(
174     address indexed from,
175     address indexed to,
176     uint256 value
177   );
178 
179   event Approval(
180     address indexed owner,
181     address indexed spender,
182     uint256 value
183   );
184 }
185 
186 /*ERC20*/
187 pragma solidity ^0.4.24;
188 
189 
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
196  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract ERC20 is IERC20 {
199   using SafeMath for uint256;
200 
201   mapping (address => uint256) private _balances;
202 
203   mapping (address => mapping (address => uint256)) private _allowed;
204 
205   uint256 private _totalSupply;
206 
207   /**
208   * @dev Total number of tokens in existence
209   */
210   function totalSupply() public view returns (uint256) {
211     return _totalSupply;
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param owner The address to query the balance of.
217   * @return An uint256 representing the amount owned by the passed address.
218   */
219   function balanceOf(address owner) public view returns (uint256) {
220     return _balances[owner];
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param owner address The address which owns the funds.
226    * @param spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(
230     address owner,
231     address spender
232    )
233     public
234     view
235     returns (uint256)
236   {
237     return _allowed[owner][spender];
238   }
239 
240   /**
241   * @dev Transfer token for a specified address
242   * @param to The address to transfer to.
243   * @param value The amount to be transferred.
244   */
245   function transfer(address to, uint256 value) public returns (bool) {
246     _transfer(msg.sender, to, value);
247     return true;
248   }
249 
250   /**
251    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param spender The address which will spend the funds.
257    * @param value The amount of tokens to be spent.
258    */
259   function approve(address spender, uint256 value) public returns (bool) {
260     require(spender != address(0));
261 
262     _allowed[msg.sender][spender] = value;
263     emit Approval(msg.sender, spender, value);
264     return true;
265   }
266 
267   /**
268    * @dev Transfer tokens from one address to another
269    * @param from address The address which you want to send tokens from
270    * @param to address The address which you want to transfer to
271    * @param value uint256 the amount of tokens to be transferred
272    */
273   function transferFrom(
274     address from,
275     address to,
276     uint256 value
277   )
278     public
279     returns (bool)
280   {
281     require(value <= _allowed[from][msg.sender]);
282 
283     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
284     _transfer(from, to, value);
285     return true;
286   }
287 
288   /**
289    * @dev Increase the amount of tokens that an owner allowed to a spender.
290    * approve should be called when allowed_[_spender] == 0. To increment
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param spender The address which will spend the funds.
295    * @param addedValue The amount of tokens to increase the allowance by.
296    */
297   function increaseAllowance(
298     address spender,
299     uint256 addedValue
300   )
301     public
302     returns (bool)
303   {
304     require(spender != address(0));
305 
306     _allowed[msg.sender][spender] = (
307       _allowed[msg.sender][spender].add(addedValue));
308     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
309     return true;
310   }
311 
312   /**
313    * @dev Decrease the amount of tokens that an owner allowed to a spender.
314    * approve should be called when allowed_[_spender] == 0. To decrement
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param spender The address which will spend the funds.
319    * @param subtractedValue The amount of tokens to decrease the allowance by.
320    */
321   function decreaseAllowance(
322     address spender,
323     uint256 subtractedValue
324   )
325     public
326     returns (bool)
327   {
328     require(spender != address(0));
329 
330     _allowed[msg.sender][spender] = (
331       _allowed[msg.sender][spender].sub(subtractedValue));
332     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
333     return true;
334   }
335 
336   /**
337   * @dev Transfer token for a specified addresses
338   * @param from The address to transfer from.
339   * @param to The address to transfer to.
340   * @param value The amount to be transferred.
341   */
342   function _transfer(address from, address to, uint256 value) internal {
343     require(value <= _balances[from]);
344     require(to != address(0));
345 
346     _balances[from] = _balances[from].sub(value);
347     _balances[to] = _balances[to].add(value);
348     emit Transfer(from, to, value);
349   }
350 
351   /**
352    * @dev Internal function that mints an amount of the token and assigns it to
353    * an account. This encapsulates the modification of balances such that the
354    * proper events are emitted.
355    * @param account The account that will receive the created tokens.
356    * @param value The amount that will be created.
357    */
358   function _mint(address account, uint256 value) internal {
359     require(account != 0);
360     _totalSupply = _totalSupply.add(value);
361     _balances[account] = _balances[account].add(value);
362     emit Transfer(address(0), account, value);
363   }
364 
365   /**
366    * @dev Internal function that burns an amount of the token of a given
367    * account.
368    * @param account The account whose tokens will be burnt.
369    * @param value The amount that will be burnt.
370    */
371   function _burn(address account, uint256 value) internal {
372     require(account != 0);
373     require(value <= _balances[account]);
374 
375     _totalSupply = _totalSupply.sub(value);
376     _balances[account] = _balances[account].sub(value);
377     emit Transfer(account, address(0), value);
378   }
379 
380   /**
381    * @dev Internal function that burns an amount of the token of a given
382    * account, deducting from the sender's allowance for said account. Uses the
383    * internal burn function.
384    * @param account The account whose tokens will be burnt.
385    * @param value The amount that will be burnt.
386    */
387   function _burnFrom(address account, uint256 value) internal {
388     require(value <= _allowed[account][msg.sender]);
389 
390     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
391     // this function needs to emit an event with the updated approval.
392     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
393       value);
394     _burn(account, value);
395   }
396 }
397 
398 /*TratataToken*/
399 pragma solidity ^0.4.24;
400 contract TratataToken is Ownable, ERC20 {
401     string public name;
402     string public symbol;
403     uint8 public decimals = 8;
404 
405 
406 
407     mapping (address => uint) private lastMiningTime;
408 
409 
410     constructor(string _name, string _symbol, uint8 _decimals, uint _supply) public {
411         name = _name;
412         symbol = _symbol;
413         decimals = _decimals;
414         _mint(msg.sender, _supply);
415     }
416 
417 }