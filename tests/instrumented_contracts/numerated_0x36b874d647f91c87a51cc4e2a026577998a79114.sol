1 pragma solidity ^0.4.24;
2 
3 //USATOZ.sol v1.0
4 
5 // Thank you to BokkyPooBah / Bok Consulting Pty Ltd 2018, Moritz Neto 
6 // Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
7 // MIT Licence.
8 
9 // Using OpenZeppelin Forked from OpenZeppelin/openzeppelin-solidity
10 // Start openzeppelin-solidity import IERC20, ERC20, Ownable, SafeMath
11 
12 // Multi file code previously used import function
13 // Flattened for use on Remix.Ethereum.org
14 
15 /**
16  * @title ERC20 interface IERC20.sol
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 interface IERC20 {
20   function totalSupply() external view returns (uint256);
21 
22   function balanceOf(address who) external view returns (uint256);
23 
24   function allowance(address owner, address spender)
25     external view returns (uint256);
26 
27   function transfer(address to, uint256 value) external returns (bool);
28 
29   function approve(address spender, uint256 value)
30     external returns (bool);
31 
32   function transferFrom(address from, address to, uint256 value)
33     external returns (bool);
34 
35   event Transfer(
36     address indexed from,
37     address indexed to,
38     uint256 value
39   );
40 
41   event Approval(
42     address indexed owner,
43     address indexed spender,
44     uint256 value
45   );
46 }
47 
48 // End import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
49 
50 /**
51  * @title SafeMath.sol
52  * @dev Math operations with safety checks that revert on error
53  */
54 library SafeMath {
55 
56   /**
57   * @dev Multiplies two numbers, reverts on overflow.
58   */
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61     // benefit is lost if 'b' is also tested.
62     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63     if (a == 0) {
64       return 0;
65     }
66 
67     uint256 c = a * b;
68     require(c / a == b);
69 
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     require(b > 0); // Solidity only automatically asserts when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81     return c;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     require(b <= a);
89     uint256 c = a - b;
90 
91     return c;
92   }
93 
94   /**
95   * @dev Adds two numbers, reverts on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     require(c >= a);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
106   * reverts when dividing by zero.
107   */
108   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109     require(b != 0);
110     return a % b;
111   }
112 }
113 // End import "openzeppelin-solidity/contracts/math/SafeMath.sol";
114 
115 /**
116  * @title Standard ERC20.sol token
117  *
118  * @dev Implementation of the basic standard token.
119  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
120  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract ERC20 is IERC20 {
123   using SafeMath for uint256;
124 
125   mapping (address => uint256) private _balances;
126 
127   mapping (address => mapping (address => uint256)) private _allowed;
128 
129   uint256 private _totalSupply;
130 
131   /**
132   * @dev Total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return _totalSupply;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param owner The address to query the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address owner) public view returns (uint256) {
144     return _balances[owner];
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param owner address The address which owns the funds.
150    * @param spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(
154     address owner,
155     address spender
156    )
157     public
158     view
159     returns (uint256)
160   {
161     return _allowed[owner][spender];
162   }
163 
164   /**
165   * @dev Transfer token for a specified address
166   * @param to The address to transfer to.
167   * @param value The amount to be transferred.
168   */
169   function transfer(address to, uint256 value) public returns (bool) {
170     require(value <= _balances[msg.sender]);
171     require(to != address(0));
172 
173     _balances[msg.sender] = _balances[msg.sender].sub(value);
174     _balances[to] = _balances[to].add(value);
175     emit Transfer(msg.sender, to, value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param spender The address which will spend the funds.
186    * @param value The amount of tokens to be spent.
187    */
188   function approve(address spender, uint256 value) public returns (bool) {
189     require(spender != address(0));
190 
191     _allowed[msg.sender][spender] = value;
192     emit Approval(msg.sender, spender, value);
193     return true;
194   }
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param from address The address which you want to send tokens from
199    * @param to address The address which you want to transfer to
200    * @param value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(
203     address from,
204     address to,
205     uint256 value
206   )
207     public
208     returns (bool)
209   {
210     require(value <= _balances[from]);
211     require(value <= _allowed[from][msg.sender]);
212     require(to != address(0));
213 
214     _balances[from] = _balances[from].sub(value);
215     _balances[to] = _balances[to].add(value);
216     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
217     emit Transfer(from, to, value);
218     return true;
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed_[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param spender The address which will spend the funds.
228    * @param addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseAllowance(
231     address spender,
232     uint256 addedValue
233   )
234     public
235     returns (bool)
236   {
237     require(spender != address(0));
238 
239     _allowed[msg.sender][spender] = (
240       _allowed[msg.sender][spender].add(addedValue));
241     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
242     return true;
243   }
244 
245   /**
246    * @dev Decrease the amount of tokens that an owner allowed to a spender.
247    * approve should be called when allowed_[_spender] == 0. To decrement
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param spender The address which will spend the funds.
252    * @param subtractedValue The amount of tokens to decrease the allowance by.
253    */
254   function decreaseAllowance(
255     address spender,
256     uint256 subtractedValue
257   )
258     public
259     returns (bool)
260   {
261     require(spender != address(0));
262 
263     _allowed[msg.sender][spender] = (
264       _allowed[msg.sender][spender].sub(subtractedValue));
265     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
266     return true;
267   }
268 
269   /**
270    * @dev Internal function that mints an amount of the token and assigns it to
271    * an account. This encapsulates the modification of balances such that the
272    * proper events are emitted.
273    * @param account The account that will receive the created tokens.
274    * @param amount The amount that will be created.
275    */
276   function _mint(address account, uint256 amount) internal {
277     require(account != 0);
278     _totalSupply = _totalSupply.add(amount);
279     _balances[account] = _balances[account].add(amount);
280     emit Transfer(address(0), account, amount);
281   }
282 
283   /**
284    * @dev Internal function that burns an amount of the token of a given
285    * account.
286    * @param account The account whose tokens will be burnt.
287    * @param amount The amount that will be burnt.
288    */
289   function _burn(address account, uint256 amount) internal {
290     require(account != 0);
291     require(amount <= _balances[account]);
292 
293     _totalSupply = _totalSupply.sub(amount);
294     _balances[account] = _balances[account].sub(amount);
295     emit Transfer(account, address(0), amount);
296   }
297 
298   /**
299    * @dev Internal function that burns an amount of the token of a given
300    * account, deducting from the sender's allowance for said account. Uses the
301    * internal burn function.
302    * @param account The account whose tokens will be burnt.
303    * @param amount The amount that will be burnt.
304    */
305   function _burnFrom(address account, uint256 amount) internal {
306     require(amount <= _allowed[account][msg.sender]);
307 
308     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
309     // this function needs to emit an event with the updated approval.
310     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
311       amount);
312     _burn(account, amount);
313   }
314 }
315 // End import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
316 
317 /**
318  * @title Ownable.sol
319  * @dev The Ownable contract has an owner address, and provides basic authorization control
320  * functions, this simplifies the implementation of "user permissions".
321  */
322 contract Ownable {
323   address private _owner;
324 
325   event OwnershipRenounced(address indexed previousOwner);
326   event OwnershipTransferred(
327     address indexed previousOwner,
328     address indexed newOwner
329   );
330 
331   /**
332    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
333    * account.
334    */
335   constructor() public {
336     _owner = msg.sender;
337   }
338 
339   /**
340    * @return the address of the owner.
341    */
342   function owner() public view returns(address) {
343     return _owner;
344   }
345 
346   /**
347    * @dev Throws if called by any account other than the owner.
348    */
349   modifier onlyOwner() {
350     require(isOwner());
351     _;
352   }
353 
354   /**
355    * @return true if `msg.sender` is the owner of the contract.
356    */
357   function isOwner() public view returns(bool) {
358     return msg.sender == _owner;
359   }
360 
361   /**
362    * @dev Allows the current owner to relinquish control of the contract.
363    * @notice Renouncing to ownership will leave the contract without an owner.
364    * It will not be possible to call the functions with the `onlyOwner`
365    * modifier anymore.
366    */
367   function renounceOwnership() public onlyOwner {
368     emit OwnershipRenounced(_owner);
369     _owner = address(0);
370   }
371 
372   /**
373    * @dev Allows the current owner to transfer control of the contract to a newOwner.
374    * @param newOwner The address to transfer ownership to.
375    */
376   function transferOwnership(address newOwner) public onlyOwner {
377     _transferOwnership(newOwner);
378   }
379 
380   /**
381    * @dev Transfers control of the contract to a newOwner.
382    * @param newOwner The address to transfer ownership to.
383    */
384   function _transferOwnership(address newOwner) internal {
385     require(newOwner != address(0));
386     emit OwnershipTransferred(_owner, newOwner);
387     _owner = newOwner;
388   }
389 }
390 
391 // End import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
392 
393 //Begin USATOZ Token
394 contract USATOZ is ERC20, Ownable {
395     string public constant name = "USAT.IO IP Platform";
396     string public constant symbol = "USAT";
397     uint8 public constant decimals = 18;
398 
399         constructor() public {
400              _mint(owner(), 1525000000000000000000000000);
401     }
402 }