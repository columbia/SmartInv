1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender)
119     public view returns (uint256);
120 
121   function transferFrom(address from, address to, uint256 value)
122     public returns (bool);
123 
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(
126     address indexed owner,
127     address indexed spender,
128     uint256 value
129   );
130 }
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(
152     address _from,
153     address _to,
154     uint256 _value
155   )
156     public
157     returns (bool)
158   {
159     require(_to != address(0));
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     emit Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     emit Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192   function allowance(
193     address _owner,
194     address _spender
195    )
196     public
197     view
198     returns (uint256)
199   {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(
214     address _spender,
215     uint _addedValue
216   )
217     public
218     returns (bool)
219   {
220     allowed[msg.sender][_spender] = (
221       allowed[msg.sender][_spender].add(_addedValue));
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseApproval(
237     address _spender,
238     uint _subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     uint oldValue = allowed[msg.sender][_spender];
244     if (_subtractedValue > oldValue) {
245       allowed[msg.sender][_spender] = 0;
246     } else {
247       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248     }
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253 }
254 
255 
256 /**
257  * @title Ownable
258  * @dev The Ownable contract has an owner address, and provides basic authorization control
259  * functions, this simplifies the implementation of "user permissions".
260  */
261 contract Ownable {
262   address public owner;
263 
264 
265   event OwnershipRenounced(address indexed previousOwner);
266   event OwnershipTransferred(
267     address indexed previousOwner,
268     address indexed newOwner
269   );
270 
271 
272   /**
273    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
274    * account.
275    */
276   constructor() public {
277     owner = msg.sender;
278   }
279 
280   /**
281    * @dev Throws if called by any account other than the owner.
282    */
283   modifier onlyOwner() {
284     require(msg.sender == owner);
285     _;
286   }
287 
288   /**
289    * @dev Allows the current owner to relinquish control of the contract.
290    */
291   function renounceOwnership() public onlyOwner {
292     emit OwnershipRenounced(owner);
293     owner = address(0);
294   }
295 
296   /**
297    * @dev Allows the current owner to transfer control of the contract to a newOwner.
298    * @param _newOwner The address to transfer ownership to.
299    */
300   function transferOwnership(address _newOwner) public onlyOwner {
301     _transferOwnership(_newOwner);
302   }
303 
304   /**
305    * @dev Transfers control of the contract to a newOwner.
306    * @param _newOwner The address to transfer ownership to.
307    */
308   function _transferOwnership(address _newOwner) internal {
309     require(_newOwner != address(0));
310     emit OwnershipTransferred(owner, _newOwner);
311     owner = _newOwner;
312   }
313 }
314 
315 
316 /**
317  * @title Pausable
318  * @dev Base contract which allows children to implement an emergency stop mechanism.
319  */
320 contract Pausable is Ownable {
321   event Pause();
322   event Unpause();
323 
324   bool public paused = false;
325 
326 
327   /**
328    * @dev Modifier to make a function callable only when the contract is not paused.
329    */
330   modifier whenNotPaused() {
331     require(!paused);
332     _;
333   }
334 
335   /**
336    * @dev Modifier to make a function callable only when the contract is paused.
337    */
338   modifier whenPaused() {
339     require(paused);
340     _;
341   }
342 
343   /**
344    * @dev called by the owner to pause, triggers stopped state
345    */
346   function pause() onlyOwner whenNotPaused public {
347     paused = true;
348     emit Pause();
349   }
350 
351   /**
352    * @dev called by the owner to unpause, returns to normal state
353    */
354   function unpause() onlyOwner whenPaused public {
355     paused = false;
356     emit Unpause();
357   }
358 }
359 
360 
361 /**
362  * @title Pausable token
363  * @dev StandardToken modified with pausable transfers.
364  **/
365 contract PausableToken is StandardToken, Pausable {
366 
367   function transfer(
368     address _to,
369     uint256 _value
370   )
371     public
372     whenNotPaused
373     returns (bool)
374   {
375     return super.transfer(_to, _value);
376   }
377 
378   function transferFrom(
379     address _from,
380     address _to,
381     uint256 _value
382   )
383     public
384     whenNotPaused
385     returns (bool)
386   {
387     return super.transferFrom(_from, _to, _value);
388   }
389 
390   function approve(
391     address _spender,
392     uint256 _value
393   )
394     public
395     whenNotPaused
396     returns (bool)
397   {
398     return super.approve(_spender, _value);
399   }
400 
401   function increaseApproval(
402     address _spender,
403     uint _addedValue
404   )
405     public
406     whenNotPaused
407     returns (bool success)
408   {
409     return super.increaseApproval(_spender, _addedValue);
410   }
411 
412   function decreaseApproval(
413     address _spender,
414     uint _subtractedValue
415   )
416     public
417     whenNotPaused
418     returns (bool success)
419   {
420     return super.decreaseApproval(_spender, _subtractedValue);
421   }
422 }
423 
424 
425 contract SphinxToken is PausableToken {
426   string public constant name = "SphinxToken";
427   string public constant symbol = "SPX";
428   uint8 public constant decimals = 18;
429   
430   constructor(uint256 initialSupply) public {
431     totalSupply_ = initialSupply;
432     balances[msg.sender] = totalSupply_;
433   }
434 }