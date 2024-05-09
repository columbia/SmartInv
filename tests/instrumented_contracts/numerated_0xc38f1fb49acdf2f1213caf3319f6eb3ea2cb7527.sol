1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title Standard ERC20 token
38  *
39  * @dev Implementation of the basic standard token.
40  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
41  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
42  */
43 contract ERC20 is IERC20 {
44   using SafeMath for uint256;
45 
46   mapping (address => uint256) private _balances;
47 
48   mapping (address => mapping (address => uint256)) private _allowed;
49 
50   uint256 private _totalSupply;
51 
52   /**
53   * @dev Total number of tokens in existence
54   */
55   function totalSupply() public view returns (uint256) {
56     return _totalSupply;
57   }
58 
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param owner The address to query the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address owner) public view returns (uint256) {
65     return _balances[owner];
66   }
67 
68   /**
69    * @dev Function to check the amount of tokens that an owner allowed to a spender.
70    * @param owner address The address which owns the funds.
71    * @param spender address The address which will spend the funds.
72    * @return A uint256 specifying the amount of tokens still available for the spender.
73    */
74   function allowance(
75     address owner,
76     address spender
77    )
78     public
79     view
80     returns (uint256)
81   {
82     return _allowed[owner][spender];
83   }
84 
85   /**
86   * @dev Transfer token for a specified address
87   * @param to The address to transfer to.
88   * @param value The amount to be transferred.
89   */
90   function transfer(address to, uint256 value) public returns (bool) {
91     _transfer(msg.sender, to, value);
92     return true;
93   }
94 
95   /**
96    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    * Beware that changing an allowance with this method brings the risk that someone may use both the old
98    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
99    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
100    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101    * @param spender The address which will spend the funds.
102    * @param value The amount of tokens to be spent.
103    */
104   function approve(address spender, uint256 value) public returns (bool) {
105     require(spender != address(0));
106 
107     _allowed[msg.sender][spender] = value;
108     emit Approval(msg.sender, spender, value);
109     return true;
110   }
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param from address The address which you want to send tokens from
115    * @param to address The address which you want to transfer to
116    * @param value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(
119     address from,
120     address to,
121     uint256 value
122   )
123     public
124     returns (bool)
125   {
126     require(value <= _allowed[from][msg.sender]);
127 
128     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
129     _transfer(from, to, value);
130     return true;
131   }
132 
133   /**
134    * @dev Increase the amount of tokens that an owner allowed to a spender.
135    * approve should be called when allowed_[_spender] == 0. To increment
136    * allowed value is better to use this function to avoid 2 calls (and wait until
137    * the first transaction is mined)
138    * From MonolithDAO Token.sol
139    * @param spender The address which will spend the funds.
140    * @param addedValue The amount of tokens to increase the allowance by.
141    */
142   function increaseAllowance(
143     address spender,
144     uint256 addedValue
145   )
146     public
147     returns (bool)
148   {
149     require(spender != address(0));
150 
151     _allowed[msg.sender][spender] = (
152       _allowed[msg.sender][spender].add(addedValue));
153     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
154     return true;
155   }
156 
157   /**
158    * @dev Decrease the amount of tokens that an owner allowed to a spender.
159    * approve should be called when allowed_[_spender] == 0. To decrement
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * From MonolithDAO Token.sol
163    * @param spender The address which will spend the funds.
164    * @param subtractedValue The amount of tokens to decrease the allowance by.
165    */
166   function decreaseAllowance(
167     address spender,
168     uint256 subtractedValue
169   )
170     public
171     returns (bool)
172   {
173     require(spender != address(0));
174 
175     _allowed[msg.sender][spender] = (
176       _allowed[msg.sender][spender].sub(subtractedValue));
177     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178     return true;
179   }
180 
181   /**
182   * @dev Transfer token for a specified addresses
183   * @param from The address to transfer from.
184   * @param to The address to transfer to.
185   * @param value The amount to be transferred.
186   */
187   function _transfer(address from, address to, uint256 value) internal {
188     require(value <= _balances[from]);
189     require(to != address(0));
190 
191     _balances[from] = _balances[from].sub(value);
192     _balances[to] = _balances[to].add(value);
193     emit Transfer(from, to, value);
194   }
195 
196   /**
197    * @dev Internal function that mints an amount of the token and assigns it to
198    * an account. This encapsulates the modification of balances such that the
199    * proper events are emitted.
200    * @param account The account that will receive the created tokens.
201    * @param value The amount that will be created.
202    */
203   function _mint(address account, uint256 value) internal {
204     require(account != 0);
205     _totalSupply = _totalSupply.add(value);
206     _balances[account] = _balances[account].add(value);
207     emit Transfer(address(0), account, value);
208   }
209 
210   /**
211    * @dev Internal function that burns an amount of the token of a given
212    * account.
213    * @param account The account whose tokens will be burnt.
214    * @param value The amount that will be burnt.
215    */
216   function _burn(address account, uint256 value) internal {
217     require(account != 0);
218     require(value <= _balances[account]);
219 
220     _totalSupply = _totalSupply.sub(value);
221     _balances[account] = _balances[account].sub(value);
222     emit Transfer(account, address(0), value);
223   }
224 
225   /**
226    * @dev Internal function that burns an amount of the token of a given
227    * account, deducting from the sender's allowance for said account. Uses the
228    * internal burn function.
229    * @param account The account whose tokens will be burnt.
230    * @param value The amount that will be burnt.
231    */
232   function _burnFrom(address account, uint256 value) internal {
233     require(value <= _allowed[account][msg.sender]);
234 
235     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
236     // this function needs to emit an event with the updated approval.
237     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
238       value);
239     _burn(account, value);
240   }
241 }
242 
243 /**
244  * @title Ownable
245  * @dev The Ownable contract has an owner address, and provides basic authorization control
246  * functions, this simplifies the implementation of "user permissions".
247  */
248 contract Ownable {
249   address private _owner;
250 
251   event OwnershipTransferred(
252     address indexed previousOwner,
253     address indexed newOwner
254   );
255 
256   /**
257    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
258    * account.
259    */
260   constructor() internal {
261     _owner = msg.sender;
262     emit OwnershipTransferred(address(0), _owner);
263   }
264 
265   /**
266    * @return the address of the owner.
267    */
268   function owner() public view returns(address) {
269     return _owner;
270   }
271 
272   /**
273    * @dev Throws if called by any account other than the owner.
274    */
275   modifier onlyOwner() {
276     require(isOwner());
277     _;
278   }
279 
280   /**
281    * @return true if `msg.sender` is the owner of the contract.
282    */
283   function isOwner() public view returns(bool) {
284     return msg.sender == _owner;
285   }
286 
287   /**
288    * @dev Allows the current owner to relinquish control of the contract.
289    * @notice Renouncing to ownership will leave the contract without an owner.
290    * It will not be possible to call the functions with the `onlyOwner`
291    * modifier anymore.
292    */
293   function renounceOwnership() public onlyOwner {
294     emit OwnershipTransferred(_owner, address(0));
295     _owner = address(0);
296   }
297 
298   /**
299    * @dev Allows the current owner to transfer control of the contract to a newOwner.
300    * @param newOwner The address to transfer ownership to.
301    */
302   function transferOwnership(address newOwner) public onlyOwner {
303     _transferOwnership(newOwner);
304   }
305 
306   /**
307    * @dev Transfers control of the contract to a newOwner.
308    * @param newOwner The address to transfer ownership to.
309    */
310   function _transferOwnership(address newOwner) internal {
311     require(newOwner != address(0));
312     emit OwnershipTransferred(_owner, newOwner);
313     _owner = newOwner;
314   }
315 }
316 
317 /**
318  * @title SafeMath
319  * @dev Math operations with safety checks that revert on error
320  */
321 library SafeMath {
322 
323   /**
324   * @dev Multiplies two numbers, reverts on overflow.
325   */
326   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
327     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
328     // benefit is lost if 'b' is also tested.
329     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
330     if (a == 0) {
331       return 0;
332     }
333 
334     uint256 c = a * b;
335     require(c / a == b);
336 
337     return c;
338   }
339 
340   /**
341   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
342   */
343   function div(uint256 a, uint256 b) internal pure returns (uint256) {
344     require(b > 0); // Solidity only automatically asserts when dividing by 0
345     uint256 c = a / b;
346     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
347 
348     return c;
349   }
350 
351   /**
352   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
353   */
354   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
355     require(b <= a);
356     uint256 c = a - b;
357 
358     return c;
359   }
360 
361   /**
362   * @dev Adds two numbers, reverts on overflow.
363   */
364   function add(uint256 a, uint256 b) internal pure returns (uint256) {
365     uint256 c = a + b;
366     require(c >= a);
367 
368     return c;
369   }
370 
371   /**
372   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
373   * reverts when dividing by zero.
374   */
375   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
376     require(b != 0);
377     return a % b;
378   }
379 }
380 
381 contract BitcoinusToken is ERC20, Ownable {
382     using SafeMath for uint256;
383 
384     string public constant name = "Bitcoinus Token";
385     string public constant symbol = "BITS";
386     uint8 public constant decimals = 18;
387 
388     mapping (address => uint256) private balances;
389     mapping (address => mapping (address => uint256)) internal allowed;
390 
391     event Mint(address indexed to, uint256 amount);
392     event MintFinished();
393 
394     bool public mintingFinished = false;
395     uint256 private totalSupply_;
396 
397     /**
398     * @dev total number of tokens in existence
399     */
400     function totalSupply() public view returns (uint256) {
401         return totalSupply_;
402     }
403 
404     /**
405     * @dev transfer token for a specified address
406     * @param _to The address to transfer to.
407     * @param _value The amount to be transferred.
408     */
409     function transfer(address _to, uint256 _value) public returns (bool) {
410         require(_to != address(0));
411         require(_value <= balances[msg.sender]);
412 
413         // SafeMath.sub will throw if there is not enough balance.
414         balances[msg.sender] = balances[msg.sender].sub(_value);
415         balances[_to] = balances[_to].add(_value);
416         emit Transfer(msg.sender, _to, _value);
417         return true;
418     }
419 
420     /**
421     * @dev Gets the balance of the specified address.
422     * @param _owner The address to query the the balance of.
423     * @return An uint256 representing the amount owned by the passed address.
424     */
425     function balanceOf(address _owner) public view returns (uint256 balance) {
426         return balances[_owner];
427     }
428 
429     /**
430     * @dev Transfer tokens from one address to another
431     * @param _from address The address which you want to send tokens from
432     * @param _to address The address which you want to transfer to
433     * @param _value uint256 the amount of tokens to be transferred
434     */
435     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
436         require(_to != address(0));
437         require(_value <= balances[_from]);
438         require(_value <= allowed[_from][msg.sender]);
439 
440         balances[_from] = balances[_from].sub(_value);
441         balances[_to] = balances[_to].add(_value);
442         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
443         emit Transfer(_from, _to, _value);
444         return true;
445     }
446 
447     /**
448     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
449     *
450     * Beware that changing an allowance with this method brings the risk that someone may use both the old
451     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
452     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
453     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
454     * @param _spender The address which will spend the funds.
455     * @param _value The amount of tokens to be spent.
456     */
457     function approve(address _spender, uint256 _value) public returns (bool) {
458         allowed[msg.sender][_spender] = _value;
459         emit Approval(msg.sender, _spender, _value);
460         return true;
461     }
462 
463     /**
464     * @dev Function to check the amount of tokens that an owner allowed to a spender.
465     * @param _owner address The address which owns the funds.
466     * @param _spender address The address which will spend the funds.
467     * @return A uint256 specifying the amount of tokens still available for the spender.
468     */
469     function allowance(address _owner, address _spender) public view returns (uint256) {
470         return allowed[_owner][_spender];
471     }
472 
473     /**
474     * @dev Increase the amount of tokens that an owner allowed to a spender.
475     *
476     * approve should be called when allowed[_spender] == 0. To increment
477     * allowed value is better to use this function to avoid 2 calls (and wait until
478     * the first transaction is mined)
479     * From MonolithDAO Token.sol
480     * @param _spender The address which will spend the funds.
481     * @param _addedValue The amount of tokens to increase the allowance by.
482     */
483     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
484         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
485         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
486         return true;
487     }
488 
489     /**
490     * @dev Decrease the amount of tokens that an owner allowed to a spender.
491     *
492     * approve should be called when allowed[_spender] == 0. To decrement
493     * allowed value is better to use this function to avoid 2 calls (and wait until
494     * the first transaction is mined)
495     * From MonolithDAO Token.sol
496     * @param _spender The address which will spend the funds.
497     * @param _subtractedValue The amount of tokens to decrease the allowance by.
498     */
499     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
500         uint oldValue = allowed[msg.sender][_spender];
501         if (_subtractedValue > oldValue) {
502             allowed[msg.sender][_spender] = 0;
503         } else {
504             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
505         }
506         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
507         return true;
508     }
509 
510     modifier canMint() {
511         require(!mintingFinished);
512         _;
513     }
514 
515     /**
516     * @dev Function to mint tokens
517     * @param _to The address that will receive the minted tokens.
518     * @param _amount The amount of tokens to mint.
519     * @return A boolean that indicates if the operation was successful.
520     */
521     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
522         totalSupply_ = totalSupply_.add(_amount);
523         balances[_to] = balances[_to].add(_amount);
524         return true;
525     }
526 
527     function mintTokens(address[] _receivers, uint256[] _amounts) onlyOwner canMint external  {
528         require(_receivers.length > 0 && _receivers.length <= 100);
529         require(_receivers.length == _amounts.length);
530         for (uint256 i = 0; i < _receivers.length; i++) {
531             address receiver = _receivers[i];
532             uint256 amount = _amounts[i];
533 
534             require(receiver != address(0));
535             require(amount > 0);
536 
537             mint(receiver, amount);
538             emit Mint(receiver, amount);
539             emit Transfer(address(0), receiver, amount);
540         }
541     }
542 
543     /**
544     * @dev Function to stop minting new tokens.
545     * @return True if the operation was successful.
546     */
547     function finishMinting() public onlyOwner canMint returns (bool) {
548         mintingFinished = true;
549         emit MintFinished();
550         return true;
551     }
552 }