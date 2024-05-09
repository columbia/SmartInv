1 pragma solidity >=0.5.0 <0.7.0;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
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
67 // File: contracts/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: contracts/ERC20Basic.sol
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 // File: contracts/SafeMath.sol
128 
129 /**
130  * @title SafeMath
131  * @dev Math operations with safety checks that throw on error
132  */
133 library SafeMath {
134 
135   /**
136   * @dev Multiplies two numbers, throws on overflow.
137   */
138   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
139     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
140     // benefit is lost if 'b' is also tested.
141     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142     if (a == 0) {
143       return 0;
144     }
145 
146     c = a * b;
147     assert(c / a == b);
148     return c;
149   }
150 
151   /**
152   * @dev Integer division of two numbers, truncating the quotient.
153   */
154   function div(uint256 a, uint256 b) internal pure returns (uint256) {
155     // assert(b > 0); // Solidity automatically throws when dividing by 0
156     // uint256 c = a / b;
157     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158     return a / b;
159   }
160 
161   /**
162   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
163   */
164   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165     assert(b <= a);
166     return a - b;
167   }
168 
169   /**
170   * @dev Adds two numbers, throws on overflow.
171   */
172   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
173     c = a + b;
174     assert(c >= a);
175     return c;
176   }
177 }
178 
179 // File: contracts/BasicToken.sol
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances.
184  */
185 contract BasicToken is ERC20Basic {
186   using SafeMath for uint256;
187 
188   mapping(address => uint256) balances;
189 
190   uint256 totalSupply_;
191 
192   /**
193   * @dev Total number of tokens in existence
194   */
195   function totalSupply() public view returns (uint256) {
196     return totalSupply_;
197   }
198 
199   /**
200   * @dev Transfer token for a specified address
201   * @param _to The address to transfer to.
202   * @param _value The amount to be transferred.
203   */
204   function transfer(address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[msg.sender]);
207 
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     emit Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 /**
214   * @dev Gets the balance of the specified address.
215   * @param _owner The address to query the the balance of.
216   * @return An uint256 representing the amount owned by the passed address.
217   */
218   function balanceOf(address _owner) public view returns (uint256) {
219     return balances[_owner];
220   }
221 
222 }
223 
224 // File: contracts/ERC20.sol
225 
226 /**
227  * @title ERC20 interface
228  * @dev see https://github.com/ethereum/EIPs/issues/20
229  */
230 contract ERC20 is ERC20Basic {
231   function allowance(address owner, address spender)
232     public view returns (uint256);
233 
234   function transferFrom(address from, address to, uint256 value)
235     public returns (bool);
236 
237   function approve(address spender, uint256 value) public returns (bool);
238   event Approval(
239     address indexed owner,
240     address indexed spender,
241     uint256 value
242   );
243 }
244 
245 // File: contracts/StandardToken.sol
246 
247 /**
248  * @title Standard ERC20 token
249  *
250  * @dev Implementation of the basic standard token.
251  * @dev https://github.com/ethereum/EIPs/issues/20
252  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
253  */
254 contract StandardToken is ERC20, BasicToken {
255 
256   mapping (address => mapping (address => uint256)) internal allowed;
257   
258 /**
259   * @dev Transfer token for a specified address
260   * @param _from The address  transfer from.
261   * @param _to The address to transfer to.
262   * @param _value The amount to be transferred.
263   */
264   function transferTo(
265       address _from,
266       address _to, 
267       uint256 _value
268       ) 
269       public 
270       returns (bool) 
271   {
272     require(_to != address(0));
273     require(_value <= balances[_from]);
274     balances[_from] = balances[_from].sub(_value);
275     balances[_to] = balances[_to].add(_value);
276     emit Transfer(_from, _to, _value);
277     return true;
278   }
279 
280 
281   /**
282    * @dev Transfer tokens from one address to another
283    * @param _from address The address which you want to send tokens from
284    * @param _to address The address which you want to transfer to
285    * @param _value uint256 the amount of tokens to be transferred
286    */
287   function transferFrom(
288     address _from,
289     address _to,
290     uint256 _value
291   )
292     public
293     returns (bool)
294   {
295     require(_to != address(0));
296     require(_value <= balances[_from]);
297     require(_value <= allowed[_from][msg.sender]);
298 
299     balances[_from] = balances[_from].sub(_value);
300     balances[_to] = balances[_to].add(_value);
301     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
302     emit Transfer(_from, _to, _value);
303     return true;
304   }
305 
306   /**
307    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
308    *
309    * Beware that changing an allowance with this method brings the risk that someone may use both the old
310    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
311    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
312    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
313    * @param _spender The address which will spend the funds.
314    * @param _value The amount of tokens to be spent.
315    */
316   function approve(address _spender, uint256 _value) public returns (bool) {
317     allowed[msg.sender][_spender] = _value;
318     emit Approval(msg.sender, _spender, _value);
319     return true;
320   }
321 
322   /**
323    * @dev Function to check the amount of tokens that an owner allowed to a spender.
324    * @param _owner address The address which owns the funds.
325    * @param _spender address The address which will spend the funds.
326    * @return A uint256 specifying the amount of tokens still available for the spender.
327    */
328   function allowance(
329     address _owner,
330     address _spender
331    )
332     public
333     view
334     returns (uint256)
335   {
336     return allowed[_owner][_spender];
337   }
338 
339   /**
340    * @dev Increase the amount of tokens that an owner allowed to a spender.
341    *
342    * approve should be called when allowed[_spender] == 0. To increment
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _addedValue The amount of tokens to increase the allowance by.
348    */
349   function increaseApproval(
350     address _spender,
351     uint _addedValue
352   )
353     public
354     returns (bool)
355   {
356     allowed[msg.sender][_spender] = (
357       allowed[msg.sender][_spender].add(_addedValue));
358     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359     return true;
360   }
361 
362   /**
363    * @dev Decrease the amount of tokens that an owner allowed to a spender.
364    *
365    * approve should be called when allowed[_spender] == 0. To decrement
366    * allowed value is better to use this function to avoid 2 calls (and wait until
367    * the first transaction is mined)
368    * From MonolithDAO Token.sol
369    * @param _spender The address which will spend the funds.
370    * @param _subtractedValue The amount of tokens to decrease the allowance by.
371    */
372   function decreaseApproval(
373     address _spender,
374     uint _subtractedValue
375   )
376     public
377     returns (bool)
378   {
379     uint oldValue = allowed[msg.sender][_spender];
380     if (_subtractedValue > oldValue) {
381       allowed[msg.sender][_spender] = 0;
382     } else {
383       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
384     }
385     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
386     return true;
387   }
388 
389 }
390 
391 // File: contracts/PausableToken.sol
392 
393 /**
394  * @title Pausable token
395  * @dev StandardToken modified with pausable transfers.
396  **/
397 contract PausableToken is StandardToken, Pausable {
398 
399   function transfer(
400     address _to,
401     uint256 _value
402   )
403     public
404     whenNotPaused
405     returns (bool)
406   {
407     return super.transfer(_to, _value);
408   }
409   function transferTo(
410     address _from,
411     address _to,
412     uint256 _value
413   )
414     public
415     whenNotPaused
416     returns (bool)
417   {
418     return super.transferTo(_from, _to, _value);
419   }
420 
421   function transferFrom(
422     address _from,
423     address _to,
424     uint256 _value
425   )
426     public
427     whenNotPaused
428     returns (bool)
429   {
430     return super.transferFrom(_from, _to, _value);
431   }
432 
433   function approve(
434     address _spender,
435     uint256 _value
436   )
437     public
438     whenNotPaused
439     returns (bool)
440   {
441     return super.approve(_spender, _value);
442   }
443 
444   function increaseApproval(
445     address _spender,
446     uint _addedValue
447   )
448     public
449     whenNotPaused
450     returns (bool success)
451   {
452     return super.increaseApproval(_spender, _addedValue);
453   }
454 
455   function decreaseApproval(
456     address _spender,
457     uint _subtractedValue
458   )
459     public
460     whenNotPaused
461     returns (bool success)
462   {
463     return super.decreaseApproval(_spender, _subtractedValue);
464   }
465 }
466 
467 // File: contracts/IndieToken.sol
468 
469 /**
470 * ERC20 compliant token for IndieOn Utility token.
471 * Inital total supply is 10 billion token
472 */
473 contract IndieToken is PausableToken {
474 
475   string public constant name = "indieOn Token";
476   string public constant symbol = "NDI";
477   uint8 public constant decimals = 18;
478 
479   using SafeMath for uint256;
480   uint256 public constant TOTAL_SUPPLY = 9000000000 * (10 ** uint256(decimals));
481   //@dev Constructor that gives msg.sender all of existing tokens.
482 
483   constructor() public {
484     totalSupply_ = TOTAL_SUPPLY;
485     balances[msg.sender] = TOTAL_SUPPLY; //msg.sender will be address of IndieOnCrowdsale contract
486     emit Transfer(address(0x0), msg.sender, TOTAL_SUPPLY);
487   }
488 }