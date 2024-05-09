1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     if (newOwner != address(0)) {
74       owner = newOwner;
75     }
76   }
77 
78 }
79 
80 /**
81  * @title Pausable
82  * @dev Base contract which allows children to implement an emergency stop mechanism.
83  */
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     emit Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused public {
119     paused = false;
120     emit Unpause();
121   }
122 
123 }
124 
125 /**
126  * @title ERC20Basic
127  * @dev Simpler version of ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/179
129  */
130 contract ERC20Basic {
131   function totalSupply() public view returns (uint256);
132   function balanceOf(address who) public view returns (uint256);
133   function transfer(address to, uint256 value) public returns (bool);
134   event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 /**
149  * @title Basic token
150  * @dev Basic version of StandardToken, with no allowances.
151  */
152 contract BasicToken is ERC20Basic {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   uint256 totalSupply_;
158 
159   /**
160   * @dev total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return totalSupply_;
164   }
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     emit Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   /**
182   * @dev Gets the balance of the specified address.
183   * @param _owner The address to query the the balance of.
184   * @return An uint256 representing the amount owned by the passed address.
185   */
186   function balanceOf(address _owner) public view returns (uint256 balance) {
187     return balances[_owner];
188   }
189 
190 }
191 
192 /**
193  * @title Standard ERC20 token
194  *
195  * @dev Implementation of the basic standard token.
196  * @dev https://github.com/ethereum/EIPs/issues/20
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
210     require(_to != address(0));
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     emit Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    *
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(address _owner, address _spender) public view returns (uint256) {
244     return allowed[_owner][_spender];
245   }
246 
247   /**
248    * @dev Increase the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To increment
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _addedValue The amount of tokens to increase the allowance by.
256    */
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
274     uint oldValue = allowed[msg.sender][_spender];
275     if (_subtractedValue > oldValue) {
276       allowed[msg.sender][_spender] = 0;
277     } else {
278       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279     }
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284 }
285 
286 /**
287  * @title Mintable token
288  * @dev Simple ERC20 Token example, with mintable token creation
289  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
290  */
291 contract MintableToken is StandardToken, Ownable {
292   event Mint(address indexed to, uint256 amount);
293   event MintFinished();
294 
295   bool public mintingFinished = false;
296 
297 
298   modifier canMint() {
299     require(!mintingFinished);
300     _;
301   }
302 
303   /**
304    * @dev Function to mint tokens
305    * @param _to The address that will receive the minted tokens.
306    * @param _amount The amount of tokens to mint.
307    * @return A boolean that indicates if the operation was successful.
308    */
309   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
310     totalSupply_ = totalSupply_.add(_amount);
311     balances[_to] = balances[_to].add(_amount);
312     emit Mint(_to, _amount);
313     emit Transfer(address(0), _to, _amount);
314     return true;
315   }
316 
317   /**
318    * @dev Function to stop minting new tokens.
319    * @return True if the operation was successful.
320    */
321   function finishMinting() onlyOwner canMint public returns (bool) {
322     mintingFinished = true;
323     emit MintFinished();
324     return true;
325   }
326 }
327 
328 /**
329  * @title Capped token
330  * @dev Mintable token with a token cap.
331  */
332 contract CappedToken is MintableToken {
333 
334   uint256 public cap;
335 
336   function CappedToken(uint256 _cap) public {
337     require(_cap > 0);
338     cap = _cap;
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348     require(totalSupply_.add(_amount) <= cap);
349 
350     return super.mint(_to, _amount);
351   }
352 
353 }
354 
355 contract PausableToken is StandardToken, Pausable {
356 
357   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
358     return super.transfer(_to, _value);
359   }
360 
361   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
362     return super.transferFrom(_from, _to, _value);
363   }
364 
365   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
366     return super.approve(_spender, _value);
367   }
368 
369   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
370     return super.increaseApproval(_spender, _addedValue);
371   }
372 
373   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
374     return super.decreaseApproval(_spender, _subtractedValue);
375   }
376 
377 function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
378     uint receiverCount = _receivers.length;
379     uint256 amount = _value.mul(uint256(receiverCount));
380     /* require(receiverCount > 0 && receiverCount <= 20); */
381     require(receiverCount > 0);
382     require(_value > 0 && balances[msg.sender] >= amount);
383 
384     balances[msg.sender] = balances[msg.sender].sub(amount);
385     for (uint i = 0; i < receiverCount; i++) {
386         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
387         Transfer(msg.sender, _receivers[i], _value);
388     }
389     return true;
390   }
391 }
392 
393 /**
394  * @title Burnable Token
395  * @dev Token that can be irreversibly burned (destroyed).
396  */
397 contract BurnableToken is BasicToken {
398 
399   event Burn(address indexed burner, uint256 value);
400 
401   /**
402    * @dev Burns a specific amount of tokens.
403    * @param _value The amount of token to be burned.
404    */
405   function burn(uint256 _value) public {
406     require(_value <= balances[msg.sender]);
407     // no need to require value <= totalSupply, since that would imply the
408     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
409 
410     address burner = msg.sender;
411     balances[burner] = balances[burner].sub(_value);
412     totalSupply_ = totalSupply_.sub(_value);
413     emit Burn(burner, _value);
414     emit Transfer(burner, address(0), _value);
415   }
416 }
417 
418 contract ChainCoin is CappedToken, PausableToken, BurnableToken {
419 
420     string public constant name = "Lian Jie Token";
421     string public constant symbol = "LET";
422     uint8 public constant decimals = 18;
423 
424     uint256 private constant TOKEN_CAP = 100000000 * (10 ** uint256(decimals));
425     uint256 private constant TOKEN_INITIAL = 100000000 * (10 ** uint256(decimals));
426 
427     function ChainCoin() public CappedToken(TOKEN_CAP) {
428       totalSupply_ = TOKEN_INITIAL;
429 
430       balances[msg.sender] = TOKEN_INITIAL;
431       emit Transfer(address(0), msg.sender, TOKEN_INITIAL);
432   }
433 }