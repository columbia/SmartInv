1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two numbers, reverts on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12       return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     require(b > 0); // Solidity only automatically asserts when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     require(b <= a);
37     uint256 c = a - b;
38 
39     return c;
40   }
41 
42   /**
43   * @dev Adds two numbers, reverts on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     require(c >= a);
48 
49     return c;
50   }
51 
52   /**
53   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
54   * reverts when dividing by zero.
55   */
56   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b != 0);
58     return a % b;
59   }
60 }
61 
62 //////////////////////////////////////////////////////////////////////////
63 //IERC20
64 //////////////////////////////////////////////////////////////////////////
65 
66 interface IERC20 {
67   function totalSupply() external view returns (uint256);
68 
69   function balanceOf(address who) external view returns (uint256);
70 
71   function allowance(address owner, address spender)
72     external view returns (uint256);
73 
74   function transfer(address to, uint256 value) external returns (bool);
75 
76   function approve(address spender, uint256 value)
77     external returns (bool);
78 
79   function transferFrom(address from, address to, uint256 value)
80     external returns (bool);
81 
82   event Transfer(
83     address indexed from,
84     address indexed to,
85     uint256 value
86   );
87 
88   event Approval(
89     address indexed owner,
90     address indexed spender,
91     uint256 value
92   );
93 }
94 
95 //////////////////////////////////////////////////////////////////////////
96 //ERC20
97 //////////////////////////////////////////////////////////////////////////
98 
99 contract ERC20 is IERC20 {
100   using SafeMath for uint256;
101 
102   mapping (address => uint256) private _balances;
103 
104   mapping (address => mapping (address => uint256)) private _allowed;
105 
106   uint256 private _totalSupply;
107 
108   /**
109   * @dev Total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return _totalSupply;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param owner The address to query the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address owner) public view returns (uint256) {
121     return _balances[owner];
122   }
123 
124   /**
125    * @dev Function to check the amount of tokens that an owner allowed to a spender.
126    * @param owner address The address which owns the funds.
127    * @param spender address The address which will spend the funds.
128    * @return A uint256 specifying the amount of tokens still available for the spender.
129    */
130   function allowance(
131     address owner,
132     address spender
133    )
134     public
135     view
136     returns (uint256)
137   {
138     return _allowed[owner][spender];
139   }
140 
141   /**
142   * @dev Transfer token for a specified address
143   * @param to The address to transfer to.
144   * @param value The amount to be transferred.
145   */
146   function transfer(address to, uint256 value) public returns (bool) {
147     _transfer(msg.sender, to, value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param spender The address which will spend the funds.
158    * @param value The amount of tokens to be spent.
159    */
160   function approve(address spender, uint256 value) public returns (bool) {
161     require(spender != address(0));
162 
163     _allowed[msg.sender][spender] = value;
164     emit Approval(msg.sender, spender, value);
165     return true;
166   }
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param from address The address which you want to send tokens from
171    * @param to address The address which you want to transfer to
172    * @param value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address from,
176     address to,
177     uint256 value
178   )
179     public
180     returns (bool)
181   {
182     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
183     _transfer(from, to, value);
184     return true;
185   }
186 
187   /**
188    * @dev Increase the amount of tokens that an owner allowed to a spender.
189    * approve should be called when allowed_[_spender] == 0. To increment
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param spender The address which will spend the funds.
194    * @param addedValue The amount of tokens to increase the allowance by.
195    */
196   function increaseAllowance(
197     address spender,
198     uint256 addedValue
199   )
200     public
201     returns (bool)
202   {
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
220   function decreaseAllowance(
221     address spender,
222     uint256 subtractedValue
223   )
224     public
225     returns (bool)
226   {
227     require(spender != address(0));
228 
229     _allowed[msg.sender][spender] = (
230       _allowed[msg.sender][spender].sub(subtractedValue));
231     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
232     return true;
233   }
234 
235   /**
236   * @dev Transfer token for a specified addresses
237   * @param from The address to transfer from.
238   * @param to The address to transfer to.
239   * @param value The amount to be transferred.
240   */
241   function _transfer(address from, address to, uint256 value) internal {
242     require(to != address(0));
243 
244     _balances[from] = _balances[from].sub(value);
245     _balances[to] = _balances[to].add(value);
246     emit Transfer(from, to, value);
247   }
248 
249   /**
250    * @dev Internal function that mints an amount of the token and assigns it to
251    * an account. This encapsulates the modification of balances such that the
252    * proper events are emitted.
253    * @param account The account that will receive the created tokens.
254    * @param value The amount that will be created.
255    */
256   function _mint(address account, uint256 value) internal {
257     require(account != address(0));
258 
259     _totalSupply = _totalSupply.add(value);
260     _balances[account] = _balances[account].add(value);
261     emit Transfer(address(0), account, value);
262   }
263 
264   /**
265    * @dev Internal function that burns an amount of the token of a given
266    * account.
267    * @param account The account whose tokens will be burnt.
268    * @param value The amount that will be burnt.
269    */
270   function _burn(address account, uint256 value) internal {
271     require(account != address(0));
272 
273     _totalSupply = _totalSupply.sub(value);
274     _balances[account] = _balances[account].sub(value);
275     emit Transfer(account, address(0), value);
276   }
277 
278   /**
279    * @dev Internal function that burns an amount of the token of a given
280    * account, deducting from the sender's allowance for said account. Uses the
281    * internal burn function.
282    * @param account The account whose tokens will be burnt.
283    * @param value The amount that will be burnt.
284    */
285   function _burnFrom(address account, uint256 value) internal {
286     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
287     // this function needs to emit an event with the updated approval.
288     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
289       value);
290     _burn(account, value);
291   }
292 }
293 
294 //////////////////////////////////////////////////////////////////////////
295 //ERC223Receiver
296 //////////////////////////////////////////////////////////////////////////
297 
298 
299 contract ERC223Receiver {
300   /**
301    * @dev Standard ERC223 function that will handle incoming token transfers.
302    *
303    * @param _from  Token sender address.
304    * @param _value Amount of tokens.
305    * @param _data  Transaction metadata.
306    */
307   function tokenFallback(address _from, uint _value, bytes _data) public;
308 }
309 
310 //////////////////////////////////////////////////////////////////////////
311 //Ownable
312 //////////////////////////////////////////////////////////////////////////
313 
314 
315 contract Ownable {
316   address private _owner;
317 
318   event OwnershipTransferred(
319     address indexed previousOwner,
320     address indexed newOwner
321   );
322 
323   /**
324    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
325    * account.
326    */
327   constructor() internal {
328     _owner = msg.sender;
329     emit OwnershipTransferred(address(0), _owner);
330   }
331 
332   /**
333    * @return the address of the owner.
334    */
335   function owner() public view returns(address) {
336     return _owner;
337   }
338 
339   /**
340    * @dev Throws if called by any account other than the owner.
341    */
342   modifier onlyOwner() {
343     require(isOwner());
344     _;
345   }
346 
347   /**
348    * @return true if `msg.sender` is the owner of the contract.
349    */
350   function isOwner() public view returns(bool) {
351     return msg.sender == _owner;
352   }
353 
354   /**
355    * @dev Allows the current owner to relinquish control of the contract.
356    * @notice Renouncing to ownership will leave the contract without an owner.
357    * It will not be possible to call the functions with the `onlyOwner`
358    * modifier anymore.
359    */
360   function renounceOwnership() public onlyOwner {
361     emit OwnershipTransferred(_owner, address(0));
362     _owner = address(0);
363   }
364 
365   /**
366    * @dev Allows the current owner to transfer control of the contract to a newOwner.
367    * @param newOwner The address to transfer ownership to.
368    */
369   function transferOwnership(address newOwner) public onlyOwner {
370     _transferOwnership(newOwner);
371   }
372 
373   /**
374    * @dev Transfers control of the contract to a newOwner.
375    * @param newOwner The address to transfer ownership to.
376    */
377   function _transferOwnership(address newOwner) internal {
378     require(newOwner != address(0));
379     emit OwnershipTransferred(_owner, newOwner);
380     _owner = newOwner;
381   }
382 }
383 
384 //////////////////////////////////////////////////////////////////////////
385 //airDrop
386 //////////////////////////////////////////////////////////////////////////
387 
388 contract airDrop is Ownable {
389     ERC20 public token;
390     uint public createdAt;
391     address public owner;
392     
393     constructor(address _target, ERC20 _token) public {
394         owner = _target;
395         token = _token;
396         createdAt = block.number;
397     }
398 
399     
400     function transfer(address[] _addresses, uint[] _amounts) external onlyOwner {
401         require(_addresses.length == _amounts.length);
402 
403         for (uint i = 0; i < _addresses.length; i ++) {
404             token.transfer(_addresses[i], _amounts[i]);
405         }
406         
407     }
408 
409     function transferFrom(address _from, address[] _addresses, uint[] _amounts) external onlyOwner {
410         require(_addresses.length == _amounts.length);
411 
412         for (uint i = 0; i < _addresses.length; i ++) {
413             token.transferFrom(_from, _addresses[i], _amounts[i]);
414         }
415     }
416 
417 
418     function tokenFallback(address, uint, bytes) public pure {
419         // receive tokens
420     }
421 
422     function withdraw(uint _value) public onlyOwner 
423     {
424        token.transfer(owner, _value);
425     }  
426 
427     function withdrawToken(address _token, uint _value) public onlyOwner {
428         ERC20(_token).transfer(owner, _value);
429     }
430 }