1 pragma solidity ^0.4.20;
2 
3 /**
4  * 使用安全计算法进行加减乘除运算
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath
9 {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256)
15   {
16     if (a == 0)
17     {
18       return 0;
19     }
20     uint256 c = a * b;
21     require(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256)
29   {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256)
40   {
41     require(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256)
49   {
50     uint256 c = a + b;
51     require(c >= a);
52     return c;
53   }
54 }
55 
56 contract Ownable
57 {
58   address public owner;
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public
66   {
67     owner = msg.sender;
68   }
69 
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner
85   {
86     if (newOwner != address(0))
87     {
88       owner = newOwner;
89     }
90   }
91 
92 }
93 
94 /**
95  * 合约管理员可以在紧急情况下暂停合约，停止转账行为
96  * @title Pausable
97  * @dev Base contract which allows children to implement an emergency stop mechanism.
98  */
99 contract Pausable is Ownable
100 {
101   event Pause();
102   event Unpause();
103 
104   bool public paused = false;
105 
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is not paused.
109    */
110   modifier whenNotPaused() {
111     require(!paused);
112     _;
113   }
114 
115   /**
116    * @dev Modifier to make a function callable only when the contract is paused.
117    */
118   modifier whenPaused() {
119     require(paused);
120     _;
121   }
122 
123   /**
124    * @dev called by the owner to pause, triggers stopped state
125    */
126   function pause() onlyOwner whenNotPaused public
127   {
128     paused = true;
129     emit Pause();
130   }
131 
132   /**
133    * @dev called by the owner to unpause, returns to normal state
134    */
135   function unpause() onlyOwner whenPaused public
136   {
137     paused = false;
138     emit Unpause();
139   }
140 
141 }
142 
143 /**
144  * @title ERC20Basic
145  * @dev Simpler version of ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/179
147  */
148 contract ERC20Basic
149 {
150   function totalSupply() public view returns (uint256);
151   function balanceOf(address who) public view returns (uint256);
152   function transfer(address to, uint256 value) public returns (bool);
153   event Transfer(address indexed from, address indexed to, uint256 value);
154 }
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic
161 {
162   function allowance(address owner, address spender) public view returns (uint256);
163   function transferFrom(address from, address to, uint256 value) public returns (bool);
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances.
171  */
172 contract BasicToken is ERC20Basic
173 {
174   using SafeMath for uint256;
175 
176   mapping(address => uint256) balances;
177 
178   uint256 totalSupply_;
179 
180   string public name;
181 
182   string public symbol;
183 
184   /**
185   * @dev total number of tokens in existence
186   */
187   function totalSupply() public view returns (uint256)
188   {
189     return totalSupply_;
190   }
191 
192   /**
193   * @dev transfer token for a specified address
194   * @param _to The address to transfer to.
195   * @param _value The amount to be transferred.
196   */
197   function transfer(address _to, uint256 _value) public returns (bool)
198   {
199     require(_to != address(0));
200     require(_value <= balances[msg.sender]);
201 
202     balances[msg.sender] -= _value;
203     balances[_to] += _value;
204     emit Transfer(msg.sender, _to, _value);
205     return true;
206   }
207 
208   /**
209   * @dev Gets the balance of the specified address.
210   * @param _owner The address to query the the balance of.
211   * @return An uint256 representing the amount owned by the passed address.
212   */
213   function balanceOf(address _owner) public view returns (uint256 balance)
214   {
215     return balances[_owner];
216   }
217 
218 }
219 
220 /**
221  * @title Standard ERC20 token
222  *
223  * @dev Implementation of the basic standard token.
224  * @dev https://github.com/ethereum/EIPs/issues/20
225  */
226 contract StandardToken is ERC20, BasicToken
227 {
228 
229   mapping (address => mapping (address => uint256)) internal allowed;
230 
231 
232   /**
233    * 方法调用者将from账户中的代币转入to账户中
234    * @dev Transfer tokens from one address to another
235    * @param _from address The address which you want to send tokens from
236    * @param _to address The address which you want to transfer to
237    * @param _value uint256 the amount of tokens to be transferred
238    */
239   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
240   {
241     require(_to != address(0));
242     require(_value <= balances[_from]);
243     require(_value <= allowed[_from][msg.sender]);
244 
245     balances[_from] = balances[_from].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248     emit Transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253    * 方法调用者允许spender操作自己账户中value数量的代币
254    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255    *
256    * Beware that changing an allowance with this method brings the risk that someone may use both the old
257    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
258    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
259    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260    * @param _spender The address which will spend the funds.
261    * @param _value The amount of tokens to be spent.
262    */
263   function approve(address _spender, uint256 _value) public returns (bool)
264   {
265     allowed[msg.sender][_spender] = _value;
266     emit Approval(msg.sender, _spender, _value);
267     return true;
268   }
269 
270   /**
271    * 查看spender还可以操作owner代币的数量是多少
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param _owner address The address which owns the funds.
274    * @param _spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(address _owner, address _spender) public view returns (uint256)
278   {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * 调用者增加spender可操作的代币数量
284    * @dev Increase the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _addedValue The amount of tokens to increase the allowance by.
292    */
293   function increaseApproval(address _spender, uint _addedValue) public returns (bool)
294   {
295     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300   /**
301    * 调用者减少spender可操作的代币数量
302    * @dev Decrease the amount of tokens that an owner allowed to a spender.
303    *
304    * approve should be called when allowed[_spender] == 0. To decrement
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    * @param _spender The address which will spend the funds.
309    * @param _subtractedValue The amount of tokens to decrease the allowance by.
310    */
311   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool)
312   {
313     uint oldValue = allowed[msg.sender][_spender];
314     if (_subtractedValue > oldValue)
315     {
316       allowed[msg.sender][_spender] = 0;
317     }
318     else
319     {
320       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
321     }
322     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326 }
327 
328 /**
329  * 一个可增发的代币。包含增发及结束增发的方法
330  * @title Mintable token
331  * @dev Simple ERC20 Token example, with mintable token creation
332  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
333  */
334 contract MintableToken is StandardToken, Ownable
335 {
336   event Mint(address indexed to, uint256 amount);
337   event MintFinished();
338 
339   bool public mintingFinished = false;
340 
341 
342   modifier canMint() {
343     require(!mintingFinished);
344     _;
345   }
346 
347   /**
348    * @dev Function to mint tokens
349    * @param _to The address that will receive the minted tokens.
350    * @param _amount The amount of tokens to mint.
351    * @return A boolean that indicates if the operation was successful.
352    */
353   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool)
354   {
355     totalSupply_ = totalSupply_.add(_amount);
356     balances[_to] = balances[_to].add(_amount);
357     emit Mint(_to, _amount);
358     emit Transfer(address(0), _to, _amount);
359     return true;
360   }
361 
362   /**
363    * @dev Function to stop minting new tokens.
364    * @return True if the operation was successful.
365    */
366   function finishMinting() onlyOwner canMint public returns (bool)
367   {
368     mintingFinished = true;
369     emit MintFinished();
370     return true;
371   }
372 }
373 
374 /**
375  * 设置增发的上限
376  * @title Capped token
377  * @dev Mintable token with a token cap.
378  */
379 contract CappedToken is MintableToken {
380 
381   uint256 public cap;
382 
383   constructor(uint256 _cap) public
384   {
385     require(_cap > 0);
386     cap = _cap;
387   }
388 
389   /**
390    * @dev Function to mint tokens
391    * @param _to The address that will receive the minted tokens.
392    * @param _amount The amount of tokens to mint.
393    * @return A boolean that indicates if the operation was successful.
394    */
395   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool)
396   {
397     require(totalSupply_.add(_amount) <= cap);
398 
399     return super.mint(_to, _amount);
400   }
401 
402 }
403 
404 // 暂停合约会影响以下方法的调用
405 contract PausableToken is StandardToken, Pausable
406 {
407 
408   function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool)
409   {
410     return super.transfer(_to, _value);
411   }
412 
413   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool)
414   {
415     return super.transferFrom(_from, _to, _value);
416   }
417 
418   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool)
419   {
420     return super.approve(_spender, _value);
421   }
422 
423   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success)
424   {
425     return super.increaseApproval(_spender, _addedValue);
426   }
427 
428   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success)
429   {
430     return super.decreaseApproval(_spender, _subtractedValue);
431   }
432 
433   // 批量转账
434   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool)
435   {
436     uint receiverCount = _receivers.length;
437     uint256 amount = _value.mul(uint256(receiverCount));
438     /* require(receiverCount > 0 && receiverCount <= 20); */
439     require(receiverCount > 0);
440     require(_value > 0 && balances[msg.sender] >= amount);
441 
442     balances[msg.sender] = balances[msg.sender].sub(amount);
443     for (uint i = 0; i < receiverCount; i++)
444     {
445         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
446         emit Transfer(msg.sender, _receivers[i], _value);
447     }
448     return true;
449   }
450 }
451 
452 /**
453  * 调用者销毁手中的代币，代币总量也会相应减少，此方法是不可逆的
454  * @title Burnable Token
455  * @dev Token that can be irreversibly burned (destroyed).
456  */
457 contract BurnableToken is BasicToken {
458 
459   event Burn(address indexed burner, uint256 value);
460 
461   /**
462    * @dev Burns a specific amount of tokens.
463    * @param _value The amount of token to be burned.
464    */
465   function burn(uint256 _value) public {
466     require(_value <= balances[msg.sender]);
467     // no need to require value <= totalSupply, since that would imply the
468     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
469 
470     address burner = msg.sender;
471     balances[burner] = balances[burner].sub(_value);
472     totalSupply_ = totalSupply_.sub(_value);
473     emit Burn(burner, _value);
474     emit Transfer(burner, address(0), _value);
475   }
476 }
477 
478 contract AIMToken is CappedToken,PausableToken,BurnableToken {
479 
480     uint8 public constant decimals = 18;
481 
482     uint256 private TOKEN_INITIAL;
483 
484    /**
485     * CappedToken基类构造函数的参数依赖于派生合约,作为派生合约构造函数定义头的一部分
486     */
487    constructor(string _name,string _symbol,uint256 _TOKEN_CAP,uint256 _TOKEN_INITIAL) public CappedToken(_TOKEN_CAP * (10 ** uint256(decimals)))
488    {
489       require(_TOKEN_INITIAL > 0);
490       require(_TOKEN_CAP >= _TOKEN_INITIAL);
491 
492       TOKEN_INITIAL = _TOKEN_INITIAL * (10 ** uint256(decimals));
493 
494       totalSupply_ = TOKEN_INITIAL;
495 
496       name = _name;
497 
498       symbol = _symbol;
499 
500       balances[msg.sender] = TOKEN_INITIAL;
501 
502       emit Transfer(address(0), msg.sender, TOKEN_INITIAL);
503 
504   }
505 }