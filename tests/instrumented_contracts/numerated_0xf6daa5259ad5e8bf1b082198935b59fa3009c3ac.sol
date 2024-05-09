1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that revert on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, reverts on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     uint256 c = a * b;
95     require(c / a == b);
96 
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     require(b > 0); // Solidity only automatically asserts when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108     return c;
109   }
110 
111   /**
112   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     require(b <= a);
116     uint256 c = a - b;
117 
118     return c;
119   }
120 
121   /**
122   * @dev Adds two numbers, reverts on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     require(c >= a);
127 
128     return c;
129   }
130 
131   /**
132   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
133   * reverts when dividing by zero.
134   */
135   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136     require(b != 0);
137     return a % b;
138   }
139 }
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 interface IERC20 {
146   function totalSupply() external view returns (uint256);
147 
148   function balanceOf(address who) external view returns (uint256);
149 
150   function allowance(address owner, address spender)
151     external view returns (uint256);
152 
153   function transfer(address to, uint256 value) external returns (bool);
154 
155   function approve(address spender, uint256 value)
156     external returns (bool);
157 
158   function transferFrom(address from, address to, uint256 value)
159     external returns (bool);
160 
161   event Transfer(
162     address indexed from,
163     address indexed to,
164     uint256 value
165   );
166 
167   event Approval(
168     address indexed owner,
169     address indexed spender,
170     uint256 value
171   );
172 }
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
179  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
180  */
181 contract ERC20 is IERC20 {
182   using SafeMath for uint256;
183 
184   mapping (address => uint256) private _balances;
185 
186   mapping (address => mapping (address => uint256)) private _allowed;
187 
188   uint256 private _totalSupply;
189 
190   /**
191   * @dev Total number of tokens in existence
192   */
193   function totalSupply() public view returns (uint256) {
194     return _totalSupply;
195   }
196 
197   /**
198   * @dev Gets the balance of the specified address.
199   * @param owner The address to query the balance of.
200   * @return An uint256 representing the amount owned by the passed address.
201   */
202   function balanceOf(address owner) public view returns (uint256) {
203     return _balances[owner];
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param owner address The address which owns the funds.
209    * @param spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(
213     address owner,
214     address spender
215    )
216     public
217     view
218     returns (uint256)
219   {
220     return _allowed[owner][spender];
221   }
222 
223   /**
224   * @dev Transfer token for a specified address
225   * @param to The address to transfer to.
226   * @param value The amount to be transferred.
227   */
228   function transfer(address to, uint256 value) public returns (bool) {
229     _transfer(msg.sender, to, value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param spender The address which will spend the funds.
240    * @param value The amount of tokens to be spent.
241    */
242   function approve(address spender, uint256 value) public returns (bool) {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = value;
246     emit Approval(msg.sender, spender, value);
247     return true;
248   }
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param from address The address which you want to send tokens from
253    * @param to address The address which you want to transfer to
254    * @param value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(
257     address from,
258     address to,
259     uint256 value
260   )
261     public
262     returns (bool)
263   {
264     require(value <= _allowed[from][msg.sender]);
265 
266     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
267     _transfer(from, to, value);
268     return true;
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed_[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param spender The address which will spend the funds.
278    * @param addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseAllowance(
281     address spender,
282     uint256 addedValue
283   )
284     public
285     returns (bool)
286   {
287     require(spender != address(0));
288 
289     _allowed[msg.sender][spender] = (
290       _allowed[msg.sender][spender].add(addedValue));
291     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
292     return true;
293   }
294 
295   /**
296    * @dev Decrease the amount of tokens that an owner allowed to a spender.
297    * approve should be called when allowed_[_spender] == 0. To decrement
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param spender The address which will spend the funds.
302    * @param subtractedValue The amount of tokens to decrease the allowance by.
303    */
304   function decreaseAllowance(
305     address spender,
306     uint256 subtractedValue
307   )
308     public
309     returns (bool)
310   {
311     require(spender != address(0));
312 
313     _allowed[msg.sender][spender] = (
314       _allowed[msg.sender][spender].sub(subtractedValue));
315     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
316     return true;
317   }
318 
319   /**
320   * @dev Transfer token for a specified addresses
321   * @param from The address to transfer from.
322   * @param to The address to transfer to.
323   * @param value The amount to be transferred.
324   */
325   function _transfer(address from, address to, uint256 value) internal {
326     require(value <= _balances[from]);
327     require(to != address(0));
328 
329     _balances[from] = _balances[from].sub(value);
330     _balances[to] = _balances[to].add(value);
331     emit Transfer(from, to, value);
332   }
333 
334   /**
335    * @dev Internal function that mints an amount of the token and assigns it to
336    * an account. This encapsulates the modification of balances such that the
337    * proper events are emitted.
338    * @param account The account that will receive the created tokens.
339    * @param value The amount that will be created.
340    */
341   function _mint(address account, uint256 value) internal {
342     require(account != 0);
343     _totalSupply = _totalSupply.add(value);
344     _balances[account] = _balances[account].add(value);
345     emit Transfer(address(0), account, value);
346   }
347 
348   /**
349    * @dev Internal function that burns an amount of the token of a given
350    * account.
351    * @param account The account whose tokens will be burnt.
352    * @param value The amount that will be burnt.
353    */
354   function _burn(address account, uint256 value) internal {
355     require(account != 0);
356     require(value <= _balances[account]);
357 
358     _totalSupply = _totalSupply.sub(value);
359     _balances[account] = _balances[account].sub(value);
360     emit Transfer(account, address(0), value);
361   }
362 
363   /**
364    * @dev Internal function that burns an amount of the token of a given
365    * account, deducting from the sender's allowance for said account. Uses the
366    * internal burn function.
367    * @param account The account whose tokens will be burnt.
368    * @param value The amount that will be burnt.
369    */
370   function _burnFrom(address account, uint256 value) internal {
371     require(value <= _allowed[account][msg.sender]);
372 
373     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
374     // this function needs to emit an event with the updated approval.
375     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
376       value);
377     _burn(account, value);
378   }
379 }
380 
381 /**
382  * @title FKXAirdrops
383  * @dev Smart contract used to distribute FKX Airdrop tokens to multiple Ethereum addresses.
384  */
385 contract FKXAirdrops is Ownable {
386     using SafeMath for uint256;
387     ERC20 private token = ERC20(0x009e864923b49263c7F10D19B7f8Ab7a9A5AAd33);
388     //ERC20 private token = ERC20(0x6cA586ce6d0f6029b098D3C0E2131dE8028306f7);
389 
390     function airdrops(address[] dests, uint256[] values) external onlyOwner returns (bool) {
391         require(dests.length > 0);
392         require(dests.length == values.length);
393         for (uint i = 0; i < dests.length; i++) {
394            assert(token.transfer(dests[i], values[i]));
395         }
396         return true;
397     }
398 
399     function claim() public onlyOwner {
400         uint256 amount = token.balanceOf(address(this));
401         require(amount > 0);
402         assert(token.transfer(msg.sender, amount));
403     }
404 }