1 pragma solidity ^0.4.24;
2 
3 // File: contracts/Ownable.sol
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
22   constructor() public {
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
38     require(isOwner(msg.sender));
39     _;
40   }
41 
42   /**
43    * @return true if the account is the owner of the contract.
44    */
45   function isOwner(address account) public view returns(bool) {
46     return account == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner)
54     public
55     onlyOwner
56   {
57     _transferOwnership(newOwner);
58   }
59 
60   /**
61    * @dev Transfers control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function _transferOwnership(address newOwner)
65     internal
66   {
67     require(newOwner != address(0));
68     emit OwnershipTransferred(_owner, newOwner);
69     _owner = newOwner;
70   }
71 }
72 
73 // File: contracts/Pausable.sol
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Ownable {
80   event Paused();
81   event Unpaused();
82 
83   bool private _paused;
84 
85   constructor() public {
86     _paused = false;
87   }
88 
89   /**
90    * @return true if the contract is paused, false otherwise.
91    */
92   function paused() public view returns(bool) {
93     return _paused;
94   }
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is not paused.
98    */
99   modifier whenNotPaused() {
100     require(!_paused);
101     _;
102   }
103 
104   /**
105    * @dev Modifier to make a function callable only when the contract is paused.
106    */
107   modifier whenPaused() {
108     require(_paused);
109     _;
110   }
111 
112   /**
113    * @dev called by the owner to pause, triggers stopped state
114    */
115   function pause()
116     public
117     onlyOwner
118     whenNotPaused
119   {
120     _paused = true;
121     emit Paused();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause()
128     public
129     onlyOwner
130     whenPaused
131   {
132     _paused = false;
133     emit Unpaused();
134   }
135 }
136 
137 // File: contracts/Operable.sol
138 
139 /**
140  * @title Operable
141  * @dev Base contract that allows the owner to enforce access control over certain
142  * operations by adding or removing operator addresses.
143  */
144 contract Operable is Pausable {
145   event OperatorAdded(address indexed account);
146   event OperatorRemoved(address indexed account);
147 
148   mapping (address => bool) private _operators;
149 
150   constructor() public {
151     _addOperator(msg.sender);
152   }
153 
154   modifier onlyOperator() {
155     require(isOperator(msg.sender));
156     _;
157   }
158 
159   function isOperator(address account)
160     public
161     view
162     returns (bool) 
163   {
164     require(account != address(0));
165     return _operators[account];
166   }
167 
168   function addOperator(address account)
169     public
170     onlyOwner
171   {
172     _addOperator(account);
173   }
174 
175   function removeOperator(address account)
176     public
177     onlyOwner
178   {
179     _removeOperator(account);
180   }
181 
182   function _addOperator(address account)
183     internal
184   {
185     require(account != address(0));
186     _operators[account] = true;
187     emit OperatorAdded(account);
188   }
189 
190   function _removeOperator(address account)
191     internal
192   {
193     require(account != address(0));
194     _operators[account] = false;
195     emit OperatorRemoved(account);
196   }
197 }
198 
199 // File: contracts/SafeMath.sol
200 
201 /**
202  * @title SafeMath
203  * @dev Math operations with safety checks that revert on error
204  */
205 library SafeMath {
206 
207   /**
208   * @dev Multiplies two numbers, reverts on overflow.
209   */
210   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212     // benefit is lost if 'b' is also tested.
213     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
214     if (a == 0) {
215       return 0;
216     }
217 
218     uint256 c = a * b;
219     require(c / a == b);
220 
221     return c;
222   }
223 
224   /**
225   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
226   */
227   function div(uint256 a, uint256 b) internal pure returns (uint256) {
228     require(b > 0); // Solidity only automatically asserts when dividing by 0
229     uint256 c = a / b;
230     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232     return c;
233   }
234 
235   /**
236   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
237   */
238   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
239     require(b <= a);
240     uint256 c = a - b;
241 
242     return c;
243   }
244 
245   /**
246   * @dev Adds two numbers, reverts on overflow.
247   */
248   function add(uint256 a, uint256 b) internal pure returns (uint256) {
249     uint256 c = a + b;
250     require(c >= a);
251 
252     return c;
253   }
254 
255   /**
256   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
257   * reverts when dividing by zero.
258   */
259   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260     require(b != 0);
261     return a % b;
262   }
263 }
264 
265 // File: contracts/ManagedToken.sol
266 
267 contract ManagedToken is Operable {
268   using SafeMath for uint256;
269 
270   mapping (address => uint256) private _balances;
271   uint256 private _totalSupply;
272 
273   event Transfer(
274     address indexed from,
275     address indexed to,
276     uint256 value
277   );
278 
279   /**
280   * @dev Total number of tokens in existence
281   */
282   function totalSupply() public view returns (uint256) {
283     return _totalSupply;
284   }
285 
286   /**
287   * @dev Gets the balance of the specified address.
288   * @param account The address to query the balance of.
289   * @return An uint256 representing the amount owned by the passed address.
290   */
291   function balanceOf(address account) public view returns (uint256) {
292     return _balances[account];
293   }
294 
295   /**
296    * @dev Transfer tokens from one address to another
297    * @param from address The address which you want to send tokens from
298    * @param to address The address which you want to transfer to
299    * @param value uint256 the amount of tokens to be transferred
300    */
301   function transferFrom(address from, address to, uint256 value)
302     public
303     onlyOperator
304     whenNotPaused
305     returns (bool)
306   {
307     _transfer(from, to, value);
308     return true;
309   }
310 
311   /**
312    * @dev Specifically prohibits token transfers from msg.sender's address
313    * @param to address The address receiving the token transfer
314    * @param value uint256 the amount of tokens to be transferred
315    */
316   // function transfer(address to, uint256 value)
317   //   public
318   //   whenNotPaused
319   //   returns (bool)
320   // {
321   //   revert();
322   // }
323 
324   /**
325    * @dev Mints new tokens to the target address.
326    * @param to The address that will receive the minted tokens.
327    * @param value The amount of tokens to mint.
328    * @return A boolean that indicates if the operation was successful.
329    */
330   function mint(address to, uint256 value)
331     public
332     onlyOperator
333     whenNotPaused
334     returns (bool)
335   {
336     _mint(to, value);
337     return true;
338   }
339 
340   /**
341    * @dev Burns a specific amount of tokens from the target address and decrements allowance
342    * @param from address The address which you want to send tokens from
343    * @param value uint256 The amount of token to be burned
344    */
345   function burn(address from, uint256 value)
346     public
347     onlyOperator
348     whenNotPaused
349     returns (bool)
350   {
351     _burn(from, value);
352     return true;
353   }
354 
355   /**
356   * @dev Transfer token for a specified addresses
357   * @param from The address to transfer from.
358   * @param to The address to transfer to.
359   * @param value The amount to be transferred.
360   */
361   function _transfer(address from, address to, uint256 value) internal {
362     require(value <= _balances[from]);
363     require(to != address(0));
364 
365     _balances[from] = _balances[from].sub(value);
366     _balances[to] = _balances[to].add(value);
367     emit Transfer(from, to, value);
368   }
369 
370   /**
371    * @dev Internal function that mints an amount of the token and assigns it to
372    * an account. This encapsulates the modification of balances such that the
373    * proper events are emitted.
374    * @param account The account that will receive the created tokens.
375    * @param value The amount that will be created.
376    */
377   function _mint(address account, uint256 value) internal {
378     require(account != 0);
379     _totalSupply = _totalSupply.add(value);
380     _balances[account] = _balances[account].add(value);
381     emit Transfer(address(0), account, value);
382   }
383 
384   /**
385    * @dev Internal function that burns an amount of the token of a given
386    * account.
387    * @param account The account whose tokens will be burnt.
388    * @param value The amount that will be burnt.
389    */
390   function _burn(address account, uint256 value) internal {
391     require(account != 0);
392     require(value <= _balances[account]);
393 
394     _totalSupply = _totalSupply.sub(value);
395     _balances[account] = _balances[account].sub(value);
396     emit Transfer(account, address(0), value);
397   }
398 }
399 
400 // File: contracts/XFTToken.sol
401 
402 contract XFTToken is ManagedToken {
403   string public constant name = 'XFT Token';
404   string public constant symbol = 'XFT';
405   uint8 public constant decimals = 18;
406   string public constant version = '1.0';
407 }