1 pragma solidity ^0.4.24;
2 
3 //////////////////////////////////////////////////////////////////////////
4 //////////////////////////////////////////////////////////////////////////
5 //////////////////////////////////////////////////////////////////////////
6 //////////////////////////////////////////////////////////////////////////
7 //////////////////////////////////////////////////////////////////////////
8 
9 // - Mainnet WOLF: 0x18F3dB770cFd17eDb07f0d0C8a2494C5329498bF
10 // - Mainet SWM: 0xdfA581BD208810400b19CE1FF033EE102C9f47B9
11 // - Ropsten: 0x29712985CB073bAe74c81E879738f3B97768226F
12 
13 library SafeMath {
14   /**
15   * @dev Multiplies two numbers, reverts on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22       return 0;
23     }
24 
25     uint256 c = a * b;
26     require(c / a == b);
27 
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b > 0); // Solidity only automatically asserts when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39     return c;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     require(b <= a);
47     uint256 c = a - b;
48 
49     return c;
50   }
51 
52   /**
53   * @dev Adds two numbers, reverts on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     require(c >= a);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
64   * reverts when dividing by zero.
65   */
66   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b != 0);
68     return a % b;
69   }
70 }
71 
72 //////////////////////////////////////////////////////////////////////////
73 //////////////////////////////////////////////////////////////////////////
74 //////////////////////////////////////////////////////////////////////////
75 //////////////////////////////////////////////////////////////////////////
76 //////////////////////////////////////////////////////////////////////////
77 
78 interface IERC20 {
79   function totalSupply() external view returns (uint256);
80 
81   function balanceOf(address who) external view returns (uint256);
82 
83   function allowance(address owner, address spender)
84     external view returns (uint256);
85 
86   function transfer(address to, uint256 value) external returns (bool);
87 
88   function approve(address spender, uint256 value)
89     external returns (bool);
90 
91   function transferFrom(address from, address to, uint256 value)
92     external returns (bool);
93 
94   event Transfer(
95     address indexed from,
96     address indexed to,
97     uint256 value
98   );
99 
100   event Approval(
101     address indexed owner,
102     address indexed spender,
103     uint256 value
104   );
105 }
106 
107 //////////////////////////////////////////////////////////////////////////
108 //////////////////////////////////////////////////////////////////////////
109 //////////////////////////////////////////////////////////////////////////
110 //////////////////////////////////////////////////////////////////////////
111 //////////////////////////////////////////////////////////////////////////
112 
113 contract ERC20 is IERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private _balances;
117 
118   mapping (address => mapping (address => uint256)) private _allowed;
119 
120   uint256 private _totalSupply;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return _totalSupply;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param owner The address to query the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address owner) public view returns (uint256) {
135     return _balances[owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param owner address The address which owns the funds.
141    * @param spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address owner,
146     address spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return _allowed[owner][spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param to The address to transfer to.
158   * @param value The amount to be transferred.
159   */
160   function transfer(address to, uint256 value) public returns (bool) {
161     _transfer(msg.sender, to, value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176 
177     _allowed[msg.sender][spender] = value;
178     emit Approval(msg.sender, spender, value);
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param from address The address which you want to send tokens from
185    * @param to address The address which you want to transfer to
186    * @param value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address from,
190     address to,
191     uint256 value
192   )
193     public
194     returns (bool)
195   {
196     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
197     _transfer(from, to, value);
198     return true;
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    * approve should be called when allowed_[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param spender The address which will spend the funds.
208    * @param addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseAllowance(
211     address spender,
212     uint256 addedValue
213   )
214     public
215     returns (bool)
216   {
217     require(spender != address(0));
218 
219     _allowed[msg.sender][spender] = (
220       _allowed[msg.sender][spender].add(addedValue));
221     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed_[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param spender The address which will spend the funds.
232    * @param subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseAllowance(
235     address spender,
236     uint256 subtractedValue
237   )
238     public
239     returns (bool)
240   {
241     require(spender != address(0));
242 
243     _allowed[msg.sender][spender] = (
244       _allowed[msg.sender][spender].sub(subtractedValue));
245     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
246     return true;
247   }
248 
249   /**
250   * @dev Transfer token for a specified addresses
251   * @param from The address to transfer from.
252   * @param to The address to transfer to.
253   * @param value The amount to be transferred.
254   */
255   function _transfer(address from, address to, uint256 value) internal {
256     require(to != address(0));
257 
258     _balances[from] = _balances[from].sub(value);
259     _balances[to] = _balances[to].add(value);
260     emit Transfer(from, to, value);
261   }
262 
263   /**
264    * @dev Internal function that mints an amount of the token and assigns it to
265    * an account. This encapsulates the modification of balances such that the
266    * proper events are emitted.
267    * @param account The account that will receive the created tokens.
268    * @param value The amount that will be created.
269    */
270   function _mint(address account, uint256 value) internal {
271     require(account != address(0));
272 
273     _totalSupply = _totalSupply.add(value);
274     _balances[account] = _balances[account].add(value);
275     emit Transfer(address(0), account, value);
276   }
277 
278   /**
279    * @dev Internal function that burns an amount of the token of a given
280    * account.
281    * @param account The account whose tokens will be burnt.
282    * @param value The amount that will be burnt.
283    */
284   function _burn(address account, uint256 value) internal {
285     require(account != address(0));
286 
287     _totalSupply = _totalSupply.sub(value);
288     _balances[account] = _balances[account].sub(value);
289     emit Transfer(account, address(0), value);
290   }
291 
292   /**
293    * @dev Internal function that burns an amount of the token of a given
294    * account, deducting from the sender's allowance for said account. Uses the
295    * internal burn function.
296    * @param account The account whose tokens will be burnt.
297    * @param value The amount that will be burnt.
298    */
299   function _burnFrom(address account, uint256 value) internal {
300     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
301     // this function needs to emit an event with the updated approval.
302     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
303       value);
304     _burn(account, value);
305   }
306 }
307 
308 //////////////////////////////////////////////////////////////////////////
309 //////////////////////////////////////////////////////////////////////////
310 //////////////////////////////////////////////////////////////////////////
311 //////////////////////////////////////////////////////////////////////////
312 //////////////////////////////////////////////////////////////////////////
313 
314 contract ERC223Receiver {
315   /**
316    * @dev Standard ERC223 function that will handle incoming token transfers.
317    *
318    * @param _from  Token sender address.
319    * @param _value Amount of tokens.
320    * @param _data  Transaction metadata.
321    */
322   function tokenFallback(address _from, uint _value, bytes _data) public;
323 }
324 
325 //////////////////////////////////////////////////////////////////////////
326 //////////////////////////////////////////////////////////////////////////
327 //////////////////////////////////////////////////////////////////////////
328 //////////////////////////////////////////////////////////////////////////
329 //////////////////////////////////////////////////////////////////////////
330 
331 contract Ownable {
332   address private _owner;
333 
334   event OwnershipTransferred(
335     address indexed previousOwner,
336     address indexed newOwner
337   );
338 
339   /**
340    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
341    * account.
342    */
343   constructor() internal {
344     _owner = msg.sender;
345     emit OwnershipTransferred(address(0), _owner);
346   }
347 
348   /**
349    * @return the address of the owner.
350    */
351   function owner() public view returns(address) {
352     return _owner;
353   }
354 
355   /**
356    * @dev Throws if called by any account other than the owner.
357    */
358   modifier onlyOwner() {
359     require(isOwner());
360     _;
361   }
362 
363   /**
364    * @return true if `msg.sender` is the owner of the contract.
365    */
366   function isOwner() public view returns(bool) {
367     return msg.sender == _owner;
368   }
369 
370   /**
371    * @dev Allows the current owner to relinquish control of the contract.
372    * @notice Renouncing to ownership will leave the contract without an owner.
373    * It will not be possible to call the functions with the `onlyOwner`
374    * modifier anymore.
375    */
376   function renounceOwnership() public onlyOwner {
377     emit OwnershipTransferred(_owner, address(0));
378     _owner = address(0);
379   }
380 
381   /**
382    * @dev Allows the current owner to transfer control of the contract to a newOwner.
383    * @param newOwner The address to transfer ownership to.
384    */
385   function transferOwnership(address newOwner) public onlyOwner {
386     _transferOwnership(newOwner);
387   }
388 
389   /**
390    * @dev Transfers control of the contract to a newOwner.
391    * @param newOwner The address to transfer ownership to.
392    */
393   function _transferOwnership(address newOwner) internal {
394     require(newOwner != address(0));
395     emit OwnershipTransferred(_owner, newOwner);
396     _owner = newOwner;
397   }
398 }
399 
400 //////////////////////////////////////////////////////////////////////////
401 //////////////////////////////////////////////////////////////////////////
402 //////////////////////////////////////////////////////////////////////////
403 //////////////////////////////////////////////////////////////////////////
404 //////////////////////////////////////////////////////////////////////////
405 
406 contract airDrop is Ownable {
407     ERC20 public token;
408     uint public createdAt;
409     address public owner;
410     
411     constructor(address _target, ERC20 _token) public {
412         owner = _target;
413         token = _token;
414         createdAt = block.number;
415     }
416 
417     
418     function transfer(address[] _addresses, uint[] _amounts) external onlyOwner {
419         require(_addresses.length == _amounts.length);
420 
421         for (uint i = 0; i < _addresses.length; i ++) {
422             token.transfer(_addresses[i], _amounts[i]);
423         }
424         
425     }
426 
427     function transferFrom(address _from, address[] _addresses, uint[] _amounts) external onlyOwner {
428         require(_addresses.length == _amounts.length);
429 
430         for (uint i = 0; i < _addresses.length; i ++) {
431             token.transferFrom(_from, _addresses[i], _amounts[i]);
432         }
433     }
434 
435 
436     function tokenFallback(address, uint, bytes) public pure {
437         // receive tokens
438     }
439 
440     function withdraw(uint _value) public onlyOwner 
441     {
442        token.transfer(owner, _value);
443     }  
444 
445     function withdrawToken(address _token, uint _value) public onlyOwner {
446         ERC20(_token).transfer(owner, _value);
447     }
448 }