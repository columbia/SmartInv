1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
27     if (_a == 0) {
28       return 0;
29     }
30 
31     c = _a * _b;
32     assert(c / _a == _b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     // assert(_b > 0); // Solidity automatically throws when dividing by 0
41     // uint256 c = _a / _b;
42     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
43     return _a / _b;
44   }
45 
46   /**
47   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     assert(_b <= _a);
51     return _a - _b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
58     c = _a + _b;
59     assert(c >= _a);
60     return c;
61   }
62 }
63 
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) internal balances;
73 
74   uint256 internal totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_value <= balances[msg.sender]);
90     require(_to != address(0));
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address _owner, address _spender)
116     public view returns (uint256);
117 
118   function transferFrom(address _from, address _to, uint256 _value)
119     public returns (bool);
120 
121   function approve(address _spender, uint256 _value) public returns (bool);
122   event Approval(
123     address indexed owner,
124     address indexed spender,
125     uint256 value
126   );
127 }
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * https://github.com/ethereum/EIPs/issues/20
135  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amount of tokens to be transferred
147    */
148   function transferFrom(
149     address _from,
150     address _to,
151     uint256 _value
152   )
153     public
154     returns (bool)
155   {
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158     require(_to != address(0));
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     emit Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(
189     address _owner,
190     address _spender
191    )
192     public
193     view
194     returns (uint256)
195   {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint256 _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(
231     address _spender,
232     uint256 _subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     uint256 oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue >= oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247 }
248 
249 
250 /**
251  * @title Ownable
252  * @dev The Ownable contract has an owner address, and provides basic authorization control
253  * functions, this simplifies the implementation of "user permissions".
254  */
255 contract Ownable {
256   address public owner;
257 
258 
259   event OwnershipRenounced(address indexed previousOwner);
260   event OwnershipTransferred(
261     address indexed previousOwner,
262     address indexed newOwner
263   );
264 
265 
266   /**
267    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
268    * account.
269    */
270   constructor() public {
271     owner = msg.sender;
272   }
273 
274   /**
275    * @dev Throws if called by any account other than the owner.
276    */
277   modifier onlyOwner() {
278     require(msg.sender == owner);
279     _;
280   }
281 
282   /**
283    * @dev Allows the current owner to relinquish control of the contract.
284    * @notice Renouncing to ownership will leave the contract without an owner.
285    * It will not be possible to call the functions with the `onlyOwner`
286    * modifier anymore.
287    */
288   function renounceOwnership() public onlyOwner {
289     emit OwnershipRenounced(owner);
290     owner = address(0);
291   }
292 
293   /**
294    * @dev Allows the current owner to transfer control of the contract to a newOwner.
295    * @param _newOwner The address to transfer ownership to.
296    */
297   function transferOwnership(address _newOwner) public onlyOwner {
298     _transferOwnership(_newOwner);
299   }
300 
301   /**
302    * @dev Transfers control of the contract to a newOwner.
303    * @param _newOwner The address to transfer ownership to.
304    */
305   function _transferOwnership(address _newOwner) internal {
306     require(_newOwner != address(0));
307     emit OwnershipTransferred(owner, _newOwner);
308     owner = _newOwner;
309   }
310 }
311 
312 
313 /**
314  * @title Pausable
315  * @dev Base contract which allows children to implement an emergency stop mechanism.
316  */
317 contract Pausable is Ownable {
318   event Pause();
319   event Unpause();
320 
321   bool public paused = false;
322 
323 
324   /**
325    * @dev Modifier to make a function callable only when the contract is not paused.
326    */
327   modifier whenNotPaused() {
328     require(!paused);
329     _;
330   }
331 
332   /**
333    * @dev Modifier to make a function callable only when the contract is paused.
334    */
335   modifier whenPaused() {
336     require(paused);
337     _;
338   }
339 
340   /**
341    * @dev called by the owner to pause, triggers stopped state
342    */
343   function pause() public onlyOwner whenNotPaused {
344     paused = true;
345     emit Pause();
346   }
347 
348   /**
349    * @dev called by the owner to unpause, returns to normal state
350    */
351   function unpause() public onlyOwner whenPaused {
352     paused = false;
353     emit Unpause();
354   }
355 }
356 
357 
358 /**
359  * @title Pausable token
360  * @dev StandardToken modified with pausable transfers.
361  **/
362 contract PausableToken is StandardToken, Pausable {
363 
364   function transfer(
365     address _to,
366     uint256 _value
367   )
368     public
369     whenNotPaused
370     returns (bool)
371   {
372     return super.transfer(_to, _value);
373   }
374 
375   function transferFrom(
376     address _from,
377     address _to,
378     uint256 _value
379   )
380     public
381     whenNotPaused
382     returns (bool)
383   {
384     return super.transferFrom(_from, _to, _value);
385   }
386 
387   function approve(
388     address _spender,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.approve(_spender, _value);
396   }
397 
398   function increaseApproval(
399     address _spender,
400     uint _addedValue
401   )
402     public
403     whenNotPaused
404     returns (bool success)
405   {
406     return super.increaseApproval(_spender, _addedValue);
407   }
408 
409   function decreaseApproval(
410     address _spender,
411     uint _subtractedValue
412   )
413     public
414     whenNotPaused
415     returns (bool success)
416   {
417     return super.decreaseApproval(_spender, _subtractedValue);
418   }
419 }
420 
421 
422 /**
423  * @title DetailedERC20 token
424  * @dev The decimals are only for visualization purposes.
425  * All the operations are done using the smallest and indivisible token unit,
426  * just as on Ethereum all the operations are done in wei.
427  */
428 contract DetailedERC20 is ERC20 {
429   string public name;
430   string public symbol;
431   uint8 public decimals;
432 
433   constructor(string _name, string _symbol, uint8 _decimals) public {
434     name = _name;
435     symbol = _symbol;
436     decimals = _decimals;
437   }
438 }
439 
440 // File: contracts/HonestToken.sol
441 
442 contract HonestToken is StandardToken, PausableToken 
443 {
444     string public constant name = "Honest";
445     string public constant symbol = "HNST";
446     uint8 public constant decimals = 18;
447 
448     uint256 public constant INITIAL_SUPPLY = 400000000 * (10 ** uint256(decimals));
449 
450   /**
451    * @dev Constructor that gives msg.sender all of existing tokens.
452    */
453     constructor() public {
454         totalSupply_ = INITIAL_SUPPLY;
455         balances[msg.sender] = INITIAL_SUPPLY;
456         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
457     }
458 }