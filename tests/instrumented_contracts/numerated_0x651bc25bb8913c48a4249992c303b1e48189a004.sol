1 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
19 
20 pragma solidity ^0.4.23;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender)
30     public view returns (uint256);
31 
32   function transferFrom(address from, address to, uint256 value)
33     public returns (bool);
34 
35   function approve(address spender, uint256 value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: openzeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
44 
45 pragma solidity ^0.4.23;
46 
47 
48 
49 /**
50  * @title DetailedERC20 token
51  * @dev The decimals are only for visualization purposes.
52  * All the operations are done using the smallest and indivisible token unit,
53  * just as on Ethereum all the operations are done in wei.
54  */
55 contract DetailedERC20 is ERC20 {
56   string public name;
57   string public symbol;
58   uint8 public decimals;
59 
60   constructor(string _name, string _symbol, uint8 _decimals) public {
61     name = _name;
62     symbol = _symbol;
63     decimals = _decimals;
64   }
65 }
66 
67 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
68 
69 pragma solidity ^0.4.23;
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, throws on overflow.
80   */
81   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
82     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
83     // benefit is lost if 'b' is also tested.
84     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85     if (a == 0) {
86       return 0;
87     }
88 
89     c = a * b;
90     assert(c / a == b);
91     return c;
92   }
93 
94   /**
95   * @dev Integer division of two numbers, truncating the quotient.
96   */
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     // assert(b > 0); // Solidity automatically throws when dividing by 0
99     // uint256 c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101     return a / b;
102   }
103 
104   /**
105   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
106   */
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   /**
113   * @dev Adds two numbers, throws on overflow.
114   */
115   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
116     c = a + b;
117     assert(c >= a);
118     return c;
119   }
120 }
121 
122 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
123 
124 pragma solidity ^0.4.23;
125 
126 
127 
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is ERC20Basic {
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) balances;
137 
138   uint256 totalSupply_;
139 
140   /**
141   * @dev total number of tokens in existence
142   */
143   function totalSupply() public view returns (uint256) {
144     return totalSupply_;
145   }
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154     require(_value <= balances[msg.sender]);
155 
156     balances[msg.sender] = balances[msg.sender].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     emit Transfer(msg.sender, _to, _value);
159     return true;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address _owner) public view returns (uint256) {
168     return balances[_owner];
169   }
170 
171 }
172 
173 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
174 
175 pragma solidity ^0.4.23;
176 
177 
178 
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) internal allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(
199     address _from,
200     address _to,
201     uint256 _value
202   )
203     public
204     returns (bool)
205   {
206     require(_to != address(0));
207     require(_value <= balances[_from]);
208     require(_value <= allowed[_from][msg.sender]);
209 
210     balances[_from] = balances[_from].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213     emit Transfer(_from, _to, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219    *
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param _spender The address which will spend the funds.
225    * @param _value The amount of tokens to be spent.
226    */
227   function approve(address _spender, uint256 _value) public returns (bool) {
228     allowed[msg.sender][_spender] = _value;
229     emit Approval(msg.sender, _spender, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(
240     address _owner,
241     address _spender
242    )
243     public
244     view
245     returns (uint256)
246   {
247     return allowed[_owner][_spender];
248   }
249 
250   /**
251    * @dev Increase the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _addedValue The amount of tokens to increase the allowance by.
259    */
260   function increaseApproval(
261     address _spender,
262     uint _addedValue
263   )
264     public
265     returns (bool)
266   {
267     allowed[msg.sender][_spender] = (
268       allowed[msg.sender][_spender].add(_addedValue));
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(
284     address _spender,
285     uint _subtractedValue
286   )
287     public
288     returns (bool)
289   {
290     uint oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 
302 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
303 
304 pragma solidity ^0.4.23;
305 
306 
307 /**
308  * @title Ownable
309  * @dev The Ownable contract has an owner address, and provides basic authorization control
310  * functions, this simplifies the implementation of "user permissions".
311  */
312 contract Ownable {
313   address public owner;
314 
315 
316   event OwnershipRenounced(address indexed previousOwner);
317   event OwnershipTransferred(
318     address indexed previousOwner,
319     address indexed newOwner
320   );
321 
322 
323   /**
324    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
325    * account.
326    */
327   constructor() public {
328     owner = msg.sender;
329   }
330 
331   /**
332    * @dev Throws if called by any account other than the owner.
333    */
334   modifier onlyOwner() {
335     require(msg.sender == owner);
336     _;
337   }
338 
339   /**
340    * @dev Allows the current owner to relinquish control of the contract.
341    */
342   function renounceOwnership() public onlyOwner {
343     emit OwnershipRenounced(owner);
344     owner = address(0);
345   }
346 
347   /**
348    * @dev Allows the current owner to transfer control of the contract to a newOwner.
349    * @param _newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address _newOwner) public onlyOwner {
352     _transferOwnership(_newOwner);
353   }
354 
355   /**
356    * @dev Transfers control of the contract to a newOwner.
357    * @param _newOwner The address to transfer ownership to.
358    */
359   function _transferOwnership(address _newOwner) internal {
360     require(_newOwner != address(0));
361     emit OwnershipTransferred(owner, _newOwner);
362     owner = _newOwner;
363   }
364 }
365 
366 
367 // File: node_modules\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
368 
369 pragma solidity ^0.4.23;
370 
371 
372 
373 /**
374  * @title Pausable
375  * @dev Base contract which allows children to implement an emergency stop mechanism.
376  */
377 contract Pausable is Ownable {
378   event Pause();
379   event Unpause();
380 
381   bool public paused = false;
382 
383 
384   /**
385    * @dev Modifier to make a function callable only when the contract is not paused.
386    */
387   modifier whenNotPaused() {
388     require(!paused);
389     _;
390   }
391 
392   /**
393    * @dev Modifier to make a function callable only when the contract is paused.
394    */
395   modifier whenPaused() {
396     require(paused);
397     _;
398   }
399 
400   /**
401    * @dev called by the owner to pause, triggers stopped state
402    */
403   function pause() onlyOwner whenNotPaused public {
404     paused = true;
405     emit Pause();
406   }
407 
408   /**
409    * @dev called by the owner to unpause, returns to normal state
410    */
411   function unpause() onlyOwner whenPaused public {
412     paused = false;
413     emit Unpause();
414   }
415 }
416 
417 // File: openzeppelin-solidity\contracts\token\ERC20\PausableToken.sol
418 
419 pragma solidity ^0.4.23;
420 
421 
422 
423 
424 /**
425  * @title Pausable token
426  * @dev StandardToken modified with pausable transfers.
427  **/
428 contract PausableToken is StandardToken, Pausable {
429 
430   function transfer(
431     address _to,
432     uint256 _value
433   )
434     public
435     whenNotPaused
436     returns (bool)
437   {
438     return super.transfer(_to, _value);
439   }
440 
441   function transferFrom(
442     address _from,
443     address _to,
444     uint256 _value
445   )
446     public
447     whenNotPaused
448     returns (bool)
449   {
450     return super.transferFrom(_from, _to, _value);
451   }
452 
453   function approve(
454     address _spender,
455     uint256 _value
456   )
457     public
458     whenNotPaused
459     returns (bool)
460   {
461     return super.approve(_spender, _value);
462   }
463 
464   function increaseApproval(
465     address _spender,
466     uint _addedValue
467   )
468     public
469     whenNotPaused
470     returns (bool success)
471   {
472     return super.increaseApproval(_spender, _addedValue);
473   }
474 
475   function decreaseApproval(
476     address _spender,
477     uint _subtractedValue
478   )
479     public
480     whenNotPaused
481     returns (bool success)
482   {
483     return super.decreaseApproval(_spender, _subtractedValue);
484   }
485 }
486 
487 // File: contracts\DappToken.sol
488 
489 pragma solidity 0.4.24;
490 
491 contract DappToken is Ownable, PausableToken, DetailedERC20 {
492     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply)
493         DetailedERC20(_name, _symbol, _decimals)
494         public
495     {
496       totalSupply_ = _totalSupply;
497       balances[msg.sender] = totalSupply_;
498     }
499 
500     function setName(string _name) public onlyOwner {
501       name = _name;
502     }
503     function setSymbol(string _symbol) public onlyOwner {
504       symbol = _symbol;
505     }
506 }