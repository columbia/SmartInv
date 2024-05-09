1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, May 21, 2019 
3  (UTC) by Atlantide Team*/
4 
5 pragma solidity ^0.4.18;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract Ownable {
54   address public owner;
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64 
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     if (newOwner != address(0)) {
81       owner = newOwner;
82     }
83   }
84 
85 }
86 
87 /**
88  * @title Pausable
89  * @dev Base contract which allows children to implement an emergency stop mechanism.
90  */
91 contract Pausable is Ownable {
92   event Pause();
93   event Unpause();
94 
95   bool public paused = false;
96 
97 
98   /**
99    * @dev Modifier to make a function callable only when the contract is not paused.
100    */
101   modifier whenNotPaused() {
102     require(!paused);
103     _;
104   }
105 
106   /**
107    * @dev Modifier to make a function callable only when the contract is paused.
108    */
109   modifier whenPaused() {
110     require(paused);
111     _;
112   }
113 
114   /**
115    * @dev called by the owner to pause, triggers stopped state
116    */
117   function pause() onlyOwner whenNotPaused public {
118     paused = true;
119     emit Pause();
120   }
121 
122   /**
123    * @dev called by the owner to unpause, returns to normal state
124    */
125   function unpause() onlyOwner whenPaused public {
126     paused = false;
127     emit Unpause();
128   }
129 
130 }
131 
132 /**
133  * @title ERC20Basic
134  * @dev Simpler version of ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/179
136  */
137 contract ERC20Basic {
138   function totalSupply() public view returns (uint256);
139   function balanceOf(address who) public view returns (uint256);
140   function transfer(address to, uint256 value) public returns (bool);
141   event Transfer(address indexed from, address indexed to, uint256 value);
142 }
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   uint256 totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  */
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) internal allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     emit Transfer(_from, _to, _value);
225     return true;
226   }
227 
228   /**
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
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(address _owner, address _spender) public view returns (uint256) {
251     return allowed[_owner][_spender];
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To increment
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _addedValue The amount of tokens to increase the allowance by.
263    */
264   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
265     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270   /**
271    * @dev Decrease the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To decrement
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _subtractedValue The amount of tokens to decrease the allowance by.
279    */
280   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
281     uint oldValue = allowed[msg.sender][_spender];
282     if (_subtractedValue > oldValue) {
283       allowed[msg.sender][_spender] = 0;
284     } else {
285       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
286     }
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291 }
292 
293 /**
294  * @title Mintable token
295  * @dev Simple ERC20 Token example, with mintable token creation
296  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
297  */
298 contract MintableToken is StandardToken, Ownable {
299   event Mint(address indexed to, uint256 amount);
300   event MintFinished();
301 
302   bool public mintingFinished = false;
303 
304 
305   modifier canMint() {
306     require(!mintingFinished);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
317     totalSupply_ = totalSupply_.add(_amount);
318     balances[_to] = balances[_to].add(_amount);
319     emit Mint(_to, _amount);
320     emit Transfer(address(0), _to, _amount);
321     return true;
322   }
323 
324   /**
325    * @dev Function to stop minting new tokens.
326    * @return True if the operation was successful.
327    */
328   function finishMinting() onlyOwner canMint public returns (bool) {
329     mintingFinished = true;
330     emit MintFinished();
331     return true;
332   }
333 }
334 
335 /**
336  * @title Capped token
337  * @dev Mintable token with a token cap.
338  */
339 contract CappedToken is MintableToken {
340 
341   uint256 public cap;
342 
343   function CappedToken(uint256 _cap) public {
344     require(_cap > 0);
345     cap = _cap;
346   }
347 
348   /**
349    * @dev Function to mint tokens
350    * @param _to The address that will receive the minted tokens.
351    * @param _amount The amount of tokens to mint.
352    * @return A boolean that indicates if the operation was successful.
353    */
354   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
355     require(totalSupply_.add(_amount) <= cap);
356 
357     return super.mint(_to, _amount);
358   }
359 
360 }
361 
362 contract PausableToken is StandardToken, Pausable {
363 
364   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
365     return super.transfer(_to, _value);
366   }
367 
368   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
369     return super.transferFrom(_from, _to, _value);
370   }
371 
372   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
373     return super.approve(_spender, _value);
374   }
375 
376   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
377     return super.increaseApproval(_spender, _addedValue);
378   }
379 
380   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
381     return super.decreaseApproval(_spender, _subtractedValue);
382   }
383 
384 
385 function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
386     uint receiverCount = _receivers.length;
387     uint256 amount = _value.mul(uint256(receiverCount));
388     /* require(receiverCount > 0 && receiverCount <= 20); */
389     require(receiverCount > 0);
390     require(_value > 0 && balances[msg.sender] >= amount);
391 
392     balances[msg.sender] = balances[msg.sender].sub(amount);
393     for (uint i = 0; i < receiverCount; i++) {
394         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
395         Transfer(msg.sender, _receivers[i], _value);
396     }
397     return true;
398   }
399 }
400 
401 /**
402  * @title Burnable Token
403  * @dev Token that can be irreversibly burned (destroyed).
404  */
405 contract BurnableToken is BasicToken {
406 
407   event Burn(address indexed burner, uint256 value);
408 
409   /**
410    * @dev Burns a specific amount of tokens.
411    * @param _value The amount of token to be burned.
412    */
413   function burn(uint256 _value) public {
414     require(_value <= balances[msg.sender]);
415     // no need to require value <= totalSupply, since that would imply the
416     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
417 
418     address burner = msg.sender;
419     balances[burner] = balances[burner].sub(_value);
420     totalSupply_ = totalSupply_.sub(_value);
421     emit Burn(burner, _value);
422     emit Transfer(burner, address(0), _value);
423   }
424 }
425 
426 contract AtlantideToken is CappedToken, PausableToken, BurnableToken {
427 
428     string public constant name = "Atlantide";
429     string public constant symbol = "AT";
430     uint8 public constant decimals = 18;
431 
432     uint256 private constant TOKEN_CAP = 100000000 * (10 ** uint256(decimals));
433     uint256 private constant TOKEN_INITIAL = 100000000 * (10 ** uint256(decimals));
434 
435     function AtlantideToken() public CappedToken(TOKEN_CAP) {
436       totalSupply_ = TOKEN_INITIAL;
437 
438       balances[msg.sender] = TOKEN_INITIAL;
439       emit Transfer(address(0), msg.sender, TOKEN_INITIAL);
440 
441       paused = true;
442   }
443 }