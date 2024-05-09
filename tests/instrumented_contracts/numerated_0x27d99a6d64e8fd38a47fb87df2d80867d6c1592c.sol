1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 // File: contracts\utils\SafeMath.sol
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51 
52   /**
53   * @dev Multiplies two numbers, throws on overflow.
54   */
55   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     if (a == 0) {
57       return 0;
58     }
59     c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     // uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return a / b;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
86     c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) balances;
113 
114   uint256 totalSupply_;
115 
116   /**
117   * @dev total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return totalSupply_;
121   }
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender]);
131 
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     emit Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender)
156     public view returns (uint256);
157 
158   function transferFrom(address from, address to, uint256 value)
159     public returns (bool);
160 
161   function approve(address spender, uint256 value) public returns (bool);
162   event Approval(
163     address indexed owner,
164     address indexed spender,
165     uint256 value
166   );
167 }
168 
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190     require(_value <= balances[_from]);
191     require(_value <= allowed[_from][msg.sender]);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    *
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     allowed[msg.sender][_spender] = _value;
212     emit Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(address _owner, address _spender) public view returns (uint256) {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 
266 contract AtomicSwappableToken is StandardToken {
267   struct HashLockContract {
268     address sender;
269     address receiver;
270     uint amount;
271     bytes32 hashlock;
272     uint timelock;
273     bytes32 secret;
274     States state;
275   }
276 
277   enum States {
278     INVALID,
279     OPEN,
280     CLOSED,
281     REFUNDED
282   }
283 
284   mapping (bytes32 => HashLockContract) private contracts;
285 
286   modifier futureTimelock(uint _time) {
287     // only requirement is the timelock time is after the last blocktime (now).
288     // probably want something a bit further in the future then this.
289     // but this is still a useful sanity check:
290     require(_time > now);
291     _;
292 }
293 
294   modifier contractExists(bytes32 _contractId) {
295     require(_contractExists(_contractId));
296     _;
297   }
298 
299   modifier hashlockMatches(bytes32 _contractId, bytes32 _secret) {
300     require(contracts[_contractId].hashlock == keccak256(_secret));
301     _;
302   }
303 
304   modifier closable(bytes32 _contractId) {
305     require(contracts[_contractId].state == States.OPEN);
306     require(contracts[_contractId].timelock > now);
307     _;
308   }
309 
310   modifier refundable(bytes32 _contractId) {
311     require(contracts[_contractId].state == States.OPEN);
312     require(contracts[_contractId].timelock <= now);
313     _;
314   }
315 
316   event NewHashLockContract (
317     bytes32 indexed contractId,
318     address indexed sender,
319     address indexed receiver,
320     uint amount,
321     bytes32 hashlock,
322     uint timelock
323   );
324 
325   event SwapClosed(bytes32 indexed contractId);
326   event SwapRefunded(bytes32 indexed contractId);
327 
328 
329   function open (
330     address _receiver,
331     bytes32 _hashlock,
332     uint _timelock,
333     uint _amount
334   ) public
335     futureTimelock(_timelock)
336     returns (bytes32 contractId)
337   {
338     contractId = keccak256 (
339       msg.sender,
340       _receiver,
341       _amount,
342       _hashlock,
343       _timelock
344     );
345 
346     // the new contract must not exist
347     require(!_contractExists(contractId));
348 
349     // transfer token to this contract
350     require(transfer(address(this), _amount));
351 
352     contracts[contractId] = HashLockContract(
353       msg.sender,
354       _receiver,
355       _amount,
356       _hashlock,
357       _timelock,
358       0x0,
359       States.OPEN
360     );
361 
362     emit NewHashLockContract(contractId, msg.sender, _receiver, _amount, _hashlock, _timelock);
363   }
364 
365   function close(bytes32 _contractId, bytes32 _secret)
366     public
367     contractExists(_contractId)
368     hashlockMatches(_contractId, _secret)
369     closable(_contractId)
370     returns (bool)
371   {
372     HashLockContract storage c = contracts[_contractId];
373     c.secret = _secret;
374     c.state = States.CLOSED;
375     require(this.transfer(c.receiver, c.amount));
376     emit SwapClosed(_contractId);
377     return true;
378   }
379 
380   function refund(bytes32 _contractId)
381     public
382     contractExists(_contractId)
383     refundable(_contractId)
384     returns (bool)
385   {
386     HashLockContract storage c = contracts[_contractId];
387     c.state = States.REFUNDED;
388     require(this.transfer(c.sender, c.amount));
389     emit SwapRefunded(_contractId);
390     return true;
391   }
392 
393   function _contractExists(bytes32 _contractId) internal view returns (bool exists) {
394     exists = (contracts[_contractId].sender != address(0));
395   }
396 
397   function checkContract(bytes32 _contractId)
398     public
399     view
400     contractExists(_contractId)
401     returns (
402       address sender,
403       address receiver,
404       uint amount,
405       bytes32 hashlock,
406       uint timelock,
407       bytes32 secret
408     )
409   {
410     HashLockContract memory c = contracts[_contractId];
411     return (
412       c.sender,
413       c.receiver,
414       c.amount,
415       c.hashlock,
416       c.timelock,
417       c.secret
418     );
419   }
420 
421 }
422 
423 
424 contract TokenReceiver {
425   function receiveApproval(address from, uint amount, address tokenAddress, bytes data) public;
426 }
427 
428 
429 
430 contract MagicKeys is AtomicSwappableToken, Ownable {
431 
432   string public name;                //The shoes name: e.g. MB
433   string public symbol;              //The shoes symbol: e.g. MB
434   uint8 public decimals;             //Number of decimals of the smallest unit
435 
436   constructor (
437     string _name,
438     string _symbol
439   ) public {
440     name = _name;
441     symbol = _symbol;
442     decimals = 18;  // set as default
443   }
444 
445 
446   function _mint(address _to, uint _amount) internal returns (bool) {
447     totalSupply_ = totalSupply_.add(_amount);
448     balances[_to] = balances[_to].add(_amount);
449     emit Transfer(address(0), _to, _amount);
450   }
451 
452   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
453     _mint(_to, _amount);
454     return true;
455   }
456 
457   function approveAndCall(address _spender, uint _amount, bytes _data) public {
458     if(approve(_spender, _amount)) {
459       TokenReceiver(_spender).receiveApproval(msg.sender, _amount, address(this), _data);
460     }
461   }
462 
463 }