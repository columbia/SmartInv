1 pragma solidity ^0.4.24;
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
58  * See https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79 
80   /**
81   * @dev Total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev Transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[msg.sender]);
95 
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     emit Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256) {
108     return balances[_owner];
109   }
110 
111 }
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
137  * https://github.com/ethereum/EIPs/issues/20
138  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(
192     address _owner,
193     address _spender
194    )
195     public
196     view
197     returns (uint256)
198   {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * @dev Increase the amount of tokens that an owner allowed to a spender.
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(
212     address _spender,
213     uint256 _addedValue
214   )
215     public
216     returns (bool)
217   {
218     allowed[msg.sender][_spender] = (
219       allowed[msg.sender][_spender].add(_addedValue));
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224   /**
225    * @dev Decrease the amount of tokens that an owner allowed to a spender.
226    * approve should be called when allowed[_spender] == 0. To decrement
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _subtractedValue The amount of tokens to decrease the allowance by.
232    */
233   function decreaseApproval(
234     address _spender,
235     uint256 _subtractedValue
236   )
237     public
238     returns (bool)
239   {
240     uint256 oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 
253 /**
254  * @title Ownable
255  * @dev The Ownable contract has an owner address, and provides basic authorization control
256  * functions, this simplifies the implementation of "user permissions".
257  */
258 contract Ownable {
259   address public owner;
260 
261   event OwnershipTransferred(
262     address indexed previousOwner,
263     address indexed newOwner
264   );
265 
266 
267   /**
268    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
269    * account.
270    */
271   constructor() public {
272     owner = msg.sender;
273   }
274 
275   /**
276    * @dev Throws if called by any account other than the owner.
277    */
278   modifier onlyOwner() {
279     require(msg.sender == owner);
280     _;
281   }
282 
283   /**
284    * @dev Allows the current owner to transfer control of the contract to a newOwner.
285    * @param _newOwner The address to transfer ownership to.
286    */
287   function transferOwnership(address _newOwner) public onlyOwner {
288     _transferOwnership(_newOwner);
289   }
290 
291   /**
292    * @dev Transfers control of the contract to a newOwner.
293    * @param _newOwner The address to transfer ownership to.
294    */
295   function _transferOwnership(address _newOwner) internal {
296     require(_newOwner != address(0));
297     emit OwnershipTransferred(owner, _newOwner);
298     owner = _newOwner;
299   }
300 }
301 
302 
303 /**
304  * @title Pausable
305  * @dev Base contract which allows children to implement an emergency stop mechanism.
306  */
307 contract Pausable is Ownable {
308   event Pause();
309   event Unpause();
310 
311   bool public paused = false;
312 
313 
314   /**
315    * @dev Modifier to make a function callable only when the contract is not paused.
316    */
317   modifier whenNotPaused() {
318     require(!paused);
319     _;
320   }
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is paused.
324    */
325   modifier whenPaused() {
326     require(paused);
327     _;
328   }
329 
330   /**
331    * @dev called by the owner to pause, triggers stopped state
332    */
333   function pause() onlyOwner whenNotPaused public {
334     paused = true;
335     emit Pause();
336   }
337 
338   /**
339    * @dev called by the owner to unpause, returns to normal state
340    */
341   function unpause() onlyOwner whenPaused public {
342     paused = false;
343     emit Unpause();
344   }
345 }
346 
347 /**
348  * @title Pausable token
349  * @dev StandardToken modified with pausable transfers.
350  **/
351 contract PausableToken is StandardToken, Pausable {
352 
353   function transfer(
354     address _to,
355     uint256 _value
356   )
357     public
358     whenNotPaused
359     returns (bool)
360   {
361     return super.transfer(_to, _value);
362   }
363 
364   function transferFrom(
365     address _from,
366     address _to,
367     uint256 _value
368   )
369     public
370     whenNotPaused
371     returns (bool)
372   {
373     return super.transferFrom(_from, _to, _value);
374   }
375 
376   function approve(
377     address _spender,
378     uint256 _value
379   )
380     public
381     whenNotPaused
382     returns (bool)
383   {
384     return super.approve(_spender, _value);
385   }
386 
387   function increaseApproval(
388     address _spender,
389     uint _addedValue
390   )
391     public
392     whenNotPaused
393     returns (bool success)
394   {
395     return super.increaseApproval(_spender, _addedValue);
396   }
397 
398   function decreaseApproval(
399     address _spender,
400     uint _subtractedValue
401   )
402     public
403     whenNotPaused
404     returns (bool success)
405   {
406     return super.decreaseApproval(_spender, _subtractedValue);
407   }
408   
409 }
410 
411 
412 contract MPCToken is PausableToken {
413 
414     string public name = "Miner Pass Card";
415     string public symbol = "MPC";
416     uint8 public decimals = 18;
417 
418     constructor() public {
419         totalSupply_ = 2000000000 * (10 ** uint256(decimals));
420         balances[msg.sender] = totalSupply_;
421         emit Transfer(address(0), msg.sender, totalSupply_);
422     }
423 
424     function batchTransfer(address[] _to, uint256[] value) public whenNotPaused returns(bool success){
425         require(_to.length == value.length);
426         for( uint256 i = 0; i < _to.length; i++ ){
427             transfer(_to[i],value[i]);
428         }
429         return true;
430     }
431 
432 }