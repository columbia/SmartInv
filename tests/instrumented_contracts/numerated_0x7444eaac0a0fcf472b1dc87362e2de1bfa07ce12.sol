1 pragma solidity ^0.4.23;
2 
3 /**
4  * SCANETCHAIN is the first commercial dApp built on the NEM platform
5  * Developed for Blockchain Commercialization.
6  */
7 
8  /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14   address public owner;
15 
16 
17   event OwnershipRenounced(address indexed previousOwner);
18   event OwnershipTransferred(
19     address indexed previousOwner,
20     address indexed newOwner
21   );
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   constructor() public {
29     owner = msg.sender;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to relinquish control of the contract.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 
68 /**
69  * @title Pausable
70  * @dev Base contract which allows children to implement an emergency stop mechanism.
71  */
72 contract Pausable is Ownable {
73   event Pause();
74   event Unpause();
75 
76   bool public paused = false;
77 
78 
79   /**
80    * @dev Modifier to make a function callable only when the contract is not paused.
81    */
82   modifier whenNotPaused() {
83     require(!paused);
84     _;
85   }
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is paused.
89    */
90   modifier whenPaused() {
91     require(paused);
92     _;
93   }
94 
95   /**
96    * @dev called by the owner to pause, triggers stopped state
97    */
98   function pause() onlyOwner whenNotPaused public {
99     paused = true;
100     emit Pause();
101   }
102 
103   /**
104    * @dev called by the owner to unpause, returns to normal state
105    */
106   function unpause() onlyOwner whenPaused public {
107     paused = false;
108     emit Unpause();
109   }
110 }
111 
112 
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that throw on error
117  */
118 library SafeMath {
119 
120   /**
121   * @dev Multiplies two numbers, throws on overflow.
122   */
123   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
124     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
125     // benefit is lost if 'b' is also tested.
126     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
127     if (a == 0) {
128       return 0;
129     }
130 
131     c = a * b;
132     assert(c / a == b);
133     return c;
134   }
135 
136   /**
137   * @dev Integer division of two numbers, truncating the quotient.
138   */
139   function div(uint256 a, uint256 b) internal pure returns (uint256) {
140     // assert(b > 0); // Solidity automatically throws when dividing by 0
141     // uint256 c = a / b;
142     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143     return a / b;
144   }
145 
146   /**
147   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
148   */
149   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150     assert(b <= a);
151     return a - b;
152   }
153 
154   /**
155   * @dev Adds two numbers, throws on overflow.
156   */
157   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
158     c = a + b;
159     assert(c >= a);
160     return c;
161   }
162 }
163 
164 
165 /**
166  * @title ERC20Basic
167  * @dev Simpler version of ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/179
169  */
170 contract ERC20Basic {
171   function totalSupply() public view returns (uint256);
172   function balanceOf(address who) public view returns (uint256);
173   function transfer(address to, uint256 value) public returns (bool);
174   event Transfer(address indexed from, address indexed to, uint256 value);
175 }
176 
177 
178 /**
179  * @title Basic token
180  * @dev Basic version of StandardToken, with no allowances.
181  */
182 contract BasicToken is ERC20Basic {
183   using SafeMath for uint256;
184 
185   mapping(address => uint256) balances;
186 
187   uint256 totalSupply_;
188 
189   /**
190   * @dev Total number of tokens in existence
191   */
192   function totalSupply() public view returns (uint256) {
193     return totalSupply_;
194   }
195 
196   /**
197   * @dev Transfer token for a specified address
198   * @param _to The address to transfer to.
199   * @param _value The amount to be transferred.
200   */
201   function transfer(address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[msg.sender]);
204 
205     balances[msg.sender] = balances[msg.sender].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     emit Transfer(msg.sender, _to, _value);
208     return true;
209   }
210 
211   /**
212   * @dev Gets the balance of the specified address.
213   * @param _owner The address to query the the balance of.
214   * @return An uint256 representing the amount owned by the passed address.
215   */
216   function balanceOf(address _owner) public view returns (uint256) {
217     return balances[_owner];
218   }
219 
220 }
221 
222 
223 /**
224  * @title ERC20 interface
225  * @dev see https://github.com/ethereum/EIPs/issues/20
226  */
227 contract ERC20 is ERC20Basic {
228   function allowance(address owner, address spender)
229     public view returns (uint256);
230 
231   function transferFrom(address from, address to, uint256 value)
232     public returns (bool);
233 
234   function approve(address spender, uint256 value) public returns (bool);
235   event Approval(
236     address indexed owner,
237     address indexed spender,
238     uint256 value
239   );
240 
241   function () public payable {
242          revert();
243      }
244 }
245 
246 /**
247  * @title Standard ERC20 token
248  *
249  * @dev Implementation of the basic standard token.
250  * @dev https://github.com/ethereum/EIPs/issues/20
251  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
252  */
253 contract StandardToken is ERC20, BasicToken {
254 
255   mapping (address => mapping (address => uint256)) internal allowed;
256 
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param _from address The address which you want to send tokens from
261    * @param _to address The address which you want to transfer to
262    * @param _value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address _from,
266     address _to,
267     uint256 _value
268   )
269     public
270 
271     returns (bool)
272   {
273     require(_to != address(0));
274     require(_value <= balances[_from]);
275     require(_value <= allowed[_from][msg.sender]);
276 
277     balances[_from] = balances[_from].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
280     emit Transfer(_from, _to, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286    *
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param _spender The address which will spend the funds.
292    * @param _value The amount of tokens to be spent.
293    */
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     allowed[msg.sender][_spender] = _value;
296     emit Approval(msg.sender, _spender, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Function to check the amount of tokens that an owner allowed to a spender.
302    * @param _owner address The address which owns the funds.
303    * @param _spender address The address which will spend the funds.
304    * @return A uint256 specifying the amount of tokens still available for the spender.
305    */
306   function allowance(
307     address _owner,
308     address _spender
309    )
310     public
311     view
312     returns (uint256)
313   {
314     return allowed[_owner][_spender];
315   }
316 
317   /**
318    * @dev Increase the amount of tokens that an owner allowed to a spender.
319    *
320    * approve should be called when allowed[_spender] == 0. To increment
321    * allowed value is better to use this function to avoid 2 calls (and wait until
322    * the first transaction is mined)
323    * From MonolithDAO Token.sol
324    * @param _spender The address which will spend the funds.
325    * @param _addedValue The amount of tokens to increase the allowance by.
326    */
327   function increaseApproval(
328     address _spender,
329     uint _addedValue
330   )
331     public
332     returns (bool)
333   {
334     allowed[msg.sender][_spender] = (
335       allowed[msg.sender][_spender].add(_addedValue));
336     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
337     return true;
338   }
339 
340   /**
341    * @dev Decrease the amount of tokens that an owner allowed to a spender.
342    *
343    * approve should be called when allowed[_spender] == 0. To decrement
344    * allowed value is better to use this function to avoid 2 calls (and wait until
345    * the first transaction is mined)
346    * From MonolithDAO Token.sol
347    * @param _spender The address which will spend the funds.
348    * @param _subtractedValue The amount of tokens to decrease the allowance by.
349    */
350   function decreaseApproval(
351     address _spender,
352     uint _subtractedValue
353   )
354     public
355     returns (bool)
356   {
357     uint oldValue = allowed[msg.sender][_spender];
358     if (_subtractedValue > oldValue) {
359       allowed[msg.sender][_spender] = 0;
360     } else {
361       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
362     }
363     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
364     return true;
365   }
366 
367 }
368 
369 
370 /**
371  * @title Pausable token
372  * @dev StandardToken modified with pausable transfers.
373  **/
374 contract PausableToken is StandardToken, Pausable {
375 
376   function transfer(
377     address _to,
378     uint256 _value
379   )
380     public
381     whenNotPaused
382     returns (bool)
383   {
384     return super.transfer(_to, _value);
385   }
386 
387   function transferFrom(
388     address _from,
389     address _to,
390     uint256 _value
391   )
392     public
393     whenNotPaused
394     returns (bool)
395   {
396     return super.transferFrom(_from, _to, _value);
397   }
398 
399   function approve(
400     address _spender,
401     uint256 _value
402   )
403     public
404     whenNotPaused
405     returns (bool)
406   {
407     return super.approve(_spender, _value);
408   }
409 
410   function increaseApproval(
411     address _spender,
412     uint _addedValue
413   )
414     public
415     whenNotPaused
416     returns (bool success)
417   {
418     return super.increaseApproval(_spender, _addedValue);
419   }
420 
421   function decreaseApproval(
422     address _spender,
423     uint _subtractedValue
424   )
425     public
426     whenNotPaused
427     returns (bool success)
428   {
429     return super.decreaseApproval(_spender, _subtractedValue);
430   }
431 }
432 
433 /**
434  * @title SimpleToken
435  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
436  * Note they can later distribute these tokens as they wish using `transfer` and other
437  * `StandardToken` functions.
438  */
439 contract Scanetchain is StandardToken, PausableToken {
440 
441   string public constant name = "Scanetchain"; 
442   string public constant symbol = "SWC";
443   uint8 public constant decimals = 18;
444 
445   uint256 public constant INITIAL_SUPPLY = 5000000000 * (10 ** uint256(decimals));
446 
447   /**
448    * @dev Constructor that gives msg.sender all of existing tokens.
449    */
450   constructor() public {
451     totalSupply_ = INITIAL_SUPPLY;
452     balances[msg.sender] = INITIAL_SUPPLY;
453     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
454   }
455 
456 }