1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20Basic {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) public view returns (uint256);
43   function transferFrom(address from, address to, uint256 value) public returns (bool);
44   function approve(address spender, uint256 value) public returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   /**
60   * @dev total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99   address public owner;
100 
101   /**
102    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
103    * account.
104    */
105   function Ownable() public {
106     owner = msg.sender;
107   }
108 
109 
110   /**
111    * @dev Throws if called by any account other than the owner.
112    */
113   modifier onlyOwner() {
114     require(msg.sender == owner);
115     _;
116   }
117 
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) onlyOwner public {
124     require(newOwner != address(0));
125     owner = newOwner;
126   }
127 
128 }
129 
130 /**
131  * @title Pausable
132  * @dev Base contract which allows children to implement an emergency stop mechanism.
133  */
134 contract Pausable is Ownable {
135   event Pause();
136   event Unpause();
137 
138   bool public paused = false;
139 
140 
141   /**
142    * @dev Modifier to make a function callable only when the contract is not paused.
143    */
144   modifier whenNotPaused() {
145     require(!paused);
146     _;
147   }
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is paused.
151    */
152   modifier whenPaused() {
153     require(paused);
154     _;
155   }
156 
157   /**
158    * @dev called by the owner to pause, triggers stopped state
159    */
160   function pause() onlyOwner whenNotPaused public {
161     paused = true;
162     Pause();
163   }
164 
165   /**
166    * @dev called by the owner to unpause, returns to normal state
167    */
168   function unpause() onlyOwner whenPaused public {
169     paused = false;
170     Unpause();
171   }
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175   using SafeMath for uint256;
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(address _owner, address _spender) public view returns (uint256) {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 /**
263    @title ERC827 interface, an extension of ERC20 token standard
264    Interface of a ERC827 token, following the ERC20 standard with extra
265    methods to transfer value and data and execute calls in transfers and
266    approvals.
267  */
268 contract ERC827 is ERC20 {
269 
270   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
271   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
272   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
273 
274 }
275 
276 /**
277    @title ERC827, an extension of ERC20 token standard
278    Implementation the ERC827, following the ERC20 standard with extra
279    methods to transfer value and data and execute calls in transfers and
280    approvals.
281    Uses OpenZeppelin StandardToken.
282  */
283 contract ERC827Token is ERC827, StandardToken {
284 
285   /**
286      @dev Addition to ERC20 token methods. It allows to
287      approve the transfer of value and execute a call with the sent data.
288      Beware that changing an allowance with this method brings the risk that
289      someone may use both the old and the new allowance by unfortunate
290      transaction ordering. One possible solution to mitigate this race condition
291      is to first reduce the spender's allowance to 0 and set the desired value
292      afterwards:
293      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294      @param _spender The address that will spend the funds.
295      @param _value The amount of tokens to be spent.
296      @param _data ABI-encoded contract call to call `_to` address.
297      @return true if the call function was executed successfully
298    */
299   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
300     require(_spender != address(this));
301 
302     super.approve(_spender, _value);
303 
304     require(_spender.call(_data));
305 
306     return true;
307   }
308 
309   /**
310      @dev Addition to ERC20 token methods. Transfer tokens to a specified
311      address and execute a call with the sent data on the same transaction
312      @param _to address The address which you want to transfer to
313      @param _value uint256 the amout of tokens to be transfered
314      @param _data ABI-encoded contract call to call `_to` address.
315      @return true if the call function was executed successfully
316    */
317   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
318     require(_to != address(this));
319 
320     super.transfer(_to, _value);
321 
322     require(_to.call(_data));
323     return true;
324   }
325 
326   /**
327      @dev Addition to ERC20 token methods. Transfer tokens from one address to
328      another and make a contract call on the same transaction
329      @param _from The address which you want to send tokens from
330      @param _to The address which you want to transfer to
331      @param _value The amout of tokens to be transferred
332      @param _data ABI-encoded contract call to call `_to` address.
333      @return true if the call function was executed successfully
334    */
335   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
336     require(_to != address(this));
337 
338     super.transferFrom(_from, _to, _value);
339 
340     require(_to.call(_data));
341     return true;
342   }
343 
344   /**
345    * @dev Addition to StandardToken methods. Increase the amount of tokens that
346    * an owner allowed to a spender and execute a call with the sent data.
347    *
348    * approve should be called when allowed[_spender] == 0. To increment
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _addedValue The amount of tokens to increase the allowance by.
354    * @param _data ABI-encoded contract call to call `_spender` address.
355    */
356   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
357     require(_spender != address(this));
358 
359     super.increaseApproval(_spender, _addedValue);
360 
361     require(_spender.call(_data));
362 
363     return true;
364   }
365 
366   /**
367    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
368    * an owner allowed to a spender and execute a call with the sent data.
369    *
370    * approve should be called when allowed[_spender] == 0. To decrement
371    * allowed value is better to use this function to avoid 2 calls (and wait until
372    * the first transaction is mined)
373    * From MonolithDAO Token.sol
374    * @param _spender The address which will spend the funds.
375    * @param _subtractedValue The amount of tokens to decrease the allowance by.
376    * @param _data ABI-encoded contract call to call `_spender` address.
377    */
378   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
379     require(_spender != address(this));
380 
381     super.decreaseApproval(_spender, _subtractedValue);
382 
383     require(_spender.call(_data));
384 
385     return true;
386   }
387 
388 }
389 
390 
391 /**
392  * @title Pausable token
393  * @dev ERC827Token modified with pausable transfers.
394  **/
395 contract PausableToken is ERC827Token, Pausable {
396 
397   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
398     return super.transfer(_to, _value);
399   }
400 
401   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
402     return super.transferFrom(_from, _to, _value);
403   }
404 
405   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
406     return super.approve(_spender, _value);
407   }
408 
409   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
410     return super.increaseApproval(_spender, _addedValue);
411   }
412 
413   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
414     return super.decreaseApproval(_spender, _subtractedValue);
415   }
416   
417   function approve( address _spender, uint256 _value, bytes _data ) public whenNotPaused returns (bool){
418       return super.approve(_spender, _value, _data);
419   }
420   
421   function transfer( address _to, uint256 _value, bytes _data ) public whenNotPaused returns (bool){
422       return super.transfer(_to, _value, _data);
423   }
424   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public whenNotPaused returns (bool){
425       return super.transferFrom(_from, _to, _value, _data);
426   }
427 }
428 
429 
430 contract PlanEX is PausableToken {
431     string public constant name = "PlanEX Token";
432     string public constant symbol = "XPX";
433     uint8 public constant decimals = 18;
434     
435     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
436     
437     address public tokenWallet;
438     
439     /**
440     * @dev Constructor that gives msg.sender all of existing tokens.
441     */
442     function PlanEX() public {
443         totalSupply_ = INITIAL_SUPPLY;
444         balances[msg.sender] = INITIAL_SUPPLY;
445         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
446         tokenWallet = msg.sender;
447     }
448     
449     function sendTokens(address _to, uint _value) public onlyOwner {
450         require(_to != address(0));
451         require(_value <= balances[tokenWallet]);
452         balances[tokenWallet] = balances[tokenWallet].sub(_value);
453         balances[_to] = balances[_to].add(_value);
454         Transfer(tokenWallet, _to, _value);
455     }
456     
457 }