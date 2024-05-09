1 pragma solidity ^0.4.18;
2 
3 /**
4  * 使用安全计算法进行加减乘除运算
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract Ownable {
51   address public owner;
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() public {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     if (newOwner != address(0)) {
78       owner = newOwner;
79     }
80   }
81 
82 }
83 
84 /**
85  * 合约管理员可以在紧急情况下暂停合约，停止转账行为
86  * @title Pausable
87  * @dev Base contract which allows children to implement an emergency stop mechanism.
88  */
89 contract Pausable is Ownable {
90   event Pause();
91   event Unpause();
92 
93   bool public paused = false;
94 
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is not paused.
98    */
99   modifier whenNotPaused() {
100     require(!paused);
101     _;
102   }
103 
104   /**
105    * @dev Modifier to make a function callable only when the contract is paused.
106    */
107   modifier whenPaused() {
108     require(paused);
109     _;
110   }
111 
112   /**
113    * @dev called by the owner to pause, triggers stopped state
114    */
115   function pause() onlyOwner whenNotPaused public {
116     paused = true;
117     emit Pause();
118   }
119 
120   /**
121    * @dev called by the owner to unpause, returns to normal state
122    */
123   function unpause() onlyOwner whenPaused public {
124     paused = false;
125     emit Unpause();
126   }
127 
128 }
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   function totalSupply() public view returns (uint256);
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156  */
157 contract BasicToken is ERC20Basic {
158   using SafeMath for uint256;
159 
160   mapping(address => uint256) balances;
161 
162   uint256 totalSupply_;
163 
164   /**
165   * @dev total number of tokens in existence
166   */
167   function totalSupply() public view returns (uint256) {
168     return totalSupply_;
169   }
170 
171   /**
172   * @dev transfer token for a specified address
173   * @param _to The address to transfer to.
174   * @param _value The amount to be transferred.
175   */
176   function transfer(address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[msg.sender]);
179 
180     balances[msg.sender] = balances[msg.sender].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     emit Transfer(msg.sender, _to, _value);
183     return true;
184   }
185 
186   /**
187   * @dev Gets the balance of the specified address.
188   * @param _owner The address to query the the balance of.
189   * @return An uint256 representing the amount owned by the passed address.
190   */
191   function balanceOf(address _owner) public view returns (uint256 balance) {
192     return balances[_owner];
193   }
194 
195 }
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * @dev https://github.com/ethereum/EIPs/issues/20
202  */
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207 
208   /**
209    * 方法调用者将from账户中的代币转入to账户中
210    * @dev Transfer tokens from one address to another
211    * @param _from address The address which you want to send tokens from
212    * @param _to address The address which you want to transfer to
213    * @param _value uint256 the amount of tokens to be transferred
214    */
215   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * 方法调用者允许spender操作自己账户中value数量的代币
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    *
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * 查看spender还可以操作owner代币的数量是多少
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(address _owner, address _spender) public view returns (uint256) {
252     return allowed[_owner][_spender];
253   }
254 
255   /**
256    * 调用者增加spender可操作的代币数量
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
267     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272   /**
273    * 调用者减少spender可操作的代币数量
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 /**
297  * 一个可增发的代币。包含增发及结束增发的方法
298  * @title Mintable token
299  * @dev Simple ERC20 Token example, with mintable token creation
300  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
301  */
302 contract MintableToken is StandardToken, Ownable {
303   event Mint(address indexed to, uint256 amount);
304   event MintFinished();
305 
306   bool public mintingFinished = false;
307 
308 
309   modifier canMint() {
310     require(!mintingFinished);
311     _;
312   }
313 
314   /**
315    * @dev Function to mint tokens
316    * @param _to The address that will receive the minted tokens.
317    * @param _amount The amount of tokens to mint.
318    * @return A boolean that indicates if the operation was successful.
319    */
320   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
321     totalSupply_ = totalSupply_.add(_amount);
322     balances[_to] = balances[_to].add(_amount);
323     emit Mint(_to, _amount);
324     emit Transfer(address(0), _to, _amount);
325     return true;
326   }
327 
328   /**
329    * @dev Function to stop minting new tokens.
330    * @return True if the operation was successful.
331    */
332   function finishMinting() onlyOwner canMint public returns (bool) {
333     mintingFinished = true;
334     emit MintFinished();
335     return true;
336   }
337 }
338 
339 /**
340  * 设置增发的上限
341  * @title Capped token
342  * @dev Mintable token with a token cap.
343  */
344 contract CappedToken is MintableToken {
345 
346   uint256 public cap;
347 
348   function CappedToken(uint256 _cap) public {
349     require(_cap > 0);
350     cap = _cap;
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will receive the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
360     require(totalSupply_.add(_amount) <= cap);
361 
362     return super.mint(_to, _amount);
363   }
364 
365 }
366 
367 // 暂停合约会影响以下方法的调用
368 contract PausableToken is StandardToken, Pausable {
369 
370   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
371     return super.transfer(_to, _value);
372   }
373 
374   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
375     return super.transferFrom(_from, _to, _value);
376   }
377 
378   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
379     return super.approve(_spender, _value);
380   }
381 
382   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
383     return super.increaseApproval(_spender, _addedValue);
384   }
385 
386   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
387     return super.decreaseApproval(_spender, _subtractedValue);
388   }
389 
390 // 批量转账
391 function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
392     uint receiverCount = _receivers.length;
393     uint256 amount = _value.mul(uint256(receiverCount));
394     /* require(receiverCount > 0 && receiverCount <= 20); */
395     require(receiverCount > 0);
396     require(_value > 0 && balances[msg.sender] >= amount);
397 
398     balances[msg.sender] = balances[msg.sender].sub(amount);
399     for (uint i = 0; i < receiverCount; i++) {
400         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
401         Transfer(msg.sender, _receivers[i], _value);
402     }
403     return true;
404   }
405 }
406 
407 /**
408  * 调用者销毁手中的代币，代币总量也会相应减少，此方法是不可逆的
409  * @title Burnable Token
410  * @dev Token that can be irreversibly burned (destroyed).
411  */
412 contract BurnableToken is BasicToken {
413 
414   event Burn(address indexed burner, uint256 value);
415 
416   /**
417    * @dev Burns a specific amount of tokens.
418    * @param _value The amount of token to be burned.
419    */
420   function burn(uint256 _value) public {
421     require(_value <= balances[msg.sender]);
422     // no need to require value <= totalSupply, since that would imply the
423     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
424 
425     address burner = msg.sender;
426     balances[burner] = balances[burner].sub(_value);
427     totalSupply_ = totalSupply_.sub(_value);
428     emit Burn(burner, _value);
429     emit Transfer(burner, address(0), _value);
430   }
431 }
432 
433 contract CBCToken is CappedToken, PausableToken, BurnableToken {
434 
435     string public constant name = "CarBoxCoin";
436     string public constant symbol = "CBC";
437     uint8 public constant decimals = 18;
438 
439     uint256 private constant TOKEN_CAP = 300000000 * (10 ** uint256(decimals));
440     uint256 private constant TOKEN_INITIAL = 200000000 * (10 ** uint256(decimals));
441 
442     function CBCToken() public CappedToken(TOKEN_CAP) {
443       totalSupply_ = TOKEN_INITIAL;
444 
445       balances[msg.sender] = TOKEN_INITIAL;
446       emit Transfer(address(0), msg.sender, TOKEN_INITIAL);
447 
448       paused = true;
449   }
450 }