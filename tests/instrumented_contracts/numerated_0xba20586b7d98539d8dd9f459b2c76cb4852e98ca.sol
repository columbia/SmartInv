1 pragma solidity ^0.4.24;
2 
3 // File: contracts/zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 /**
64  *  @title ERC223 interface
65  **/
66 contract ERC223Interface {
67     function transfer(address to, uint value, bytes data) public returns (bool);
68     event Transfer(address indexed from, address indexed to, uint value, bytes data);
69 }
70 
71 /**
72  * @title ERC223 token handler
73  **/
74 contract ERC223Receiver {
75     function tokenFallback(address _fromm, uint256 _value, bytes _data) public pure;
76 }
77 
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85 
86   address public owner;
87 
88   address public newOwner;
89 
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   constructor() public {
103     owner = msg.sender;
104   }
105 
106   /**
107    * @dev Allows the current owner to transfer control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address _newOwner) public onlyOwner {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115   
116   event OwnershipTransferred(address oldOwner, address newOwner);
117 }
118 
119 
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender)
127     public view returns (uint256);
128 
129   function transferFrom(address from, address to, uint256 value)
130     public returns (bool);
131 
132   function approve(address spender, uint256 value) public returns (bool);
133   event Approval(
134     address indexed owner,
135     address indexed spender,
136     uint256 value
137   );
138 }
139 
140 /**
141  * @title Basic token
142  * @dev Basic version of StandardToken, with no allowances.
143  */
144 contract BasicToken is ERC20Basic {
145   using SafeMath for uint256;
146 
147   mapping(address => uint256) balances;
148 
149   uint256 totalSupply_;
150 
151   /**
152   * @dev total number of tokens in existence
153   */
154   function totalSupply() public view returns (uint256) {
155     return totalSupply_;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param _owner The address to query the the balance of.
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address _owner) public view returns (uint256) {
164     return balances[_owner];
165   }
166 
167 }
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    *
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    * @param _spender The address which will spend the funds.
188    * @param _value The amount of tokens to be spent.
189    */
190   function approve(address _spender, uint256 _value) public returns (bool) {
191     allowed[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(
203     address _owner,
204     address _spender
205    )
206     public
207     view
208     returns (uint256)
209   {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(
224     address _spender,
225     uint _addedValue
226   )
227     public
228     returns (bool)
229   {
230     allowed[msg.sender][_spender] = (
231       allowed[msg.sender][_spender].add(_addedValue));
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(
247     address _spender,
248     uint _subtractedValue
249   )
250     public
251     returns (bool)
252   {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 }
263 
264 
265 /**
266  * @title Pausable
267  * @dev Base contract which allows children to implement an emergency stop mechanism.
268  * @dev Modified by function 'finalUnpause' 
269  */
270 contract Pausable is Ownable {
271   event Pause();
272   event Unpause();
273   event FinalUnpause();
274   
275   bool public paused = false;
276   // finalUnpaused always false, not sure its purpose
277   bool public finalUnpaused = false;
278 
279   /**
280    * @dev Modifier to make a function callable only when the contract is not paused.
281    */
282   modifier whenNotPaused() {
283     require(!paused);
284     _;
285   }
286 
287   /**
288    * @dev Modifier to make a function callable only when the contract is paused.
289    */
290   modifier whenPaused() {
291     require(paused);
292     _;
293   }
294 
295   /**
296    * @dev called by the owner to pause, triggers stopped state
297    */
298   function pause() onlyOwner whenNotPaused public {
299     require (!finalUnpaused);
300     paused = true;
301     emit Pause();
302   }
303 
304   /**
305    * @dev called by the owner to unpause, returns to normal state
306    */
307   function unpause() onlyOwner whenPaused public {
308     paused = false;
309     emit Unpause();
310   }
311 
312   /**
313   * func unpause and finalUnpause are doing same stuff except from event.
314   * didn't see any effect.
315   */  
316   function finalUnpause() onlyOwner public {
317     paused = false;
318     emit FinalUnpause();
319   }
320 }
321 
322 /**
323  * @title Burnable Token
324  * @dev Token that can be irreversibly burned (destroyed).
325  */
326 contract BurnableToken is BasicToken {
327 
328   event Burn(address indexed burner, uint256 value);
329 
330   /**
331    * @dev Burns a specific amount of tokens.
332    * @param _value The amount of token to be burned.
333    */
334   function burn(uint256 _value) public {
335     _burn(msg.sender, _value);
336   }
337 
338   function _burn(address _who, uint256 _value) internal {
339     // not required, sub method will take care of this.
340     // require(_value <= balances[_who]);
341     // no need to require value <= totalSupply, since that would imply the
342     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
343 
344     balances[_who] = balances[_who].sub(_value);
345     totalSupply_ = totalSupply_.sub(_value);
346     emit Burn(_who, _value);
347     emit Transfer(_who, address(0), _value);
348   }
349 }
350 
351 /**
352  * @title Tipcoin contract
353  **/
354 contract TipcoinToken is StandardToken, Pausable, BurnableToken, ERC223Interface {
355     
356   using SafeMath for uint256;
357   
358   string public constant name = "Tipcoin";
359   
360   string public constant symbol = "TIPC";
361   
362   uint8 public constant decimals = 18;
363   
364   uint256 public constant INITIAL_SUPPLY = 1000000000;
365   
366   constructor() public {
367     // owner is already initiated in ownable constructor.
368     // owner = msg.sender;   
369     totalSupply_ = INITIAL_SUPPLY * 10 ** 18;
370     balances[owner] = totalSupply_;
371     emit Transfer(address(0), owner, INITIAL_SUPPLY);
372   }    
373   
374   /**
375   * @dev transfer token for a specified address with call custom function external data
376   * @param _to The address to transfer to.
377   * @param _value The amount to be transferred.
378   * @param _data The data to call tokenFallback function.
379   * @param _fallback The function name and params to call external function
380   */
381   function transfer(address _to, uint256 _value, bytes _data, string _fallback) public whenNotPaused returns (bool) {
382     require( _to != address(0));
383     
384     if (isContract(_to)) {            
385       balances[msg.sender] = balances[msg.sender].sub(_value);
386       balances[_to] = balances[_to].add(_value);
387 
388       assert(_to.call.value(0)(bytes4(keccak256(abi.encodePacked(_fallback))), msg.sender, _value, _data));
389       
390       if (_data.length == 0) {
391         emit Transfer(msg.sender, _to, _value);
392       } else {
393         emit Transfer(msg.sender, _to, _value);
394         emit Transfer(msg.sender, _to, _value, _data);
395       }
396       return true;
397     } else {
398       return transferToAddress(msg.sender, _to, _value, _data);
399     }
400   }
401 
402   /**
403   * @dev transfer token for a specified address with external data
404   * @param _to The address to transfer to.
405   * @param _value The amount to be transferred.
406   * @param _data The data to call tokenFallback function 
407   */
408   function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
409     if (isContract(_to)) {
410       return transferToContract(msg.sender, _to, _value, _data);
411     } else {
412       return transferToAddress(msg.sender, _to, _value, _data);
413     }
414   }
415 
416   /**
417   * @dev transfer token for a specified address
418   * @param _to The address to transfer to.
419   * @param _value The amount to be transferred.
420   */
421   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
422       bytes memory empty;
423       if (isContract(_to)) {
424           return transferToContract(msg.sender, _to, _value, empty);
425       } else {
426           return transferToAddress(msg.sender, _to, _value, empty);
427       }
428   }
429 
430   /**
431   * @dev Transfer tokens from one address to another
432   * @param _from address The address which you want to send tokens from
433   * @param _to address The address which you want to transfer to
434   * @param _value uint256 the amount of tokens to be transferred
435   */
436   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){      
437     require( _to != address(0));
438     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
439 
440     bytes memory empty;
441 
442     if (isContract(_to)) {
443         return transferToContract(_from, _to, _value, empty);
444       } else {
445         return transferToAddress(_from, _to, _value, empty);
446       }
447   }
448 
449   //@dev internal part
450   function isContract(address _addr) internal view returns (bool) {
451     uint length;
452     
453     assembly {
454       length := extcodesize(_addr)
455     }
456     
457     return (length >0);
458   }
459   
460   function transferToAddress(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
461     
462     balances[_from] = balances[_from].sub(_value);
463     balances[_to] = balances[_to].add(_value);
464     if (_data.length == 0) {
465       emit Transfer(_from, _to, _value);
466     } else {
467       emit Transfer(_from, _to, _value);
468       emit Transfer(_from, _to, _value, _data);
469     }    
470     return true;
471   }
472   
473   function transferToContract(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
474     
475     balances[_from] = balances[_from].sub(_value);
476     balances[_to] = balances[_to].add(_value);
477     
478     ERC223Receiver receiver = ERC223Receiver(_to);
479     receiver.tokenFallback(_from, _value, _data);
480     if (_data.length == 0) {
481       emit Transfer(_from, _to, _value);
482     } else {
483       emit Transfer(_from, _to, _value);
484       emit Transfer(_from, _to, _value, _data);
485     }    
486     return true;   
487   }
488 }