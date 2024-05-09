1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: contracts\Congress.sol
258 
259 //pragma solidity ^0.4.11;
260 pragma solidity ^0.4.24;
261 
262 
263 /**
264  * @title Congress
265  * @dev The Congress contract has an congress address, and provides basic authorization control
266  * At first,it is dictatorship. However, after the ICO, a congress of investors is created and the powers are transferred.
267  */
268 contract Congress {
269   address public congress;
270   event CongressTransferred(address indexed previousCongress, address indexed newCongress);
271 
272   /**
273    * @dev The Ownable constructor sets the original `congress` of the contract to the sender
274    * account.
275    */
276   constructor() public {
277     congress = msg.sender;
278   }
279 
280   /**
281    * @dev Throws if called by any account other than the congress.
282    */
283   modifier onlyDiscussable() {
284     require(msg.sender == congress);
285     _;
286   }
287 
288   /**
289    * @dev Allows the current congress to transfer control of the contract to a newCongress.
290    * @param newCongress The address to transfer congress to.
291    */
292   function transferCongress(address newCongress) public onlyDiscussable {
293     require(newCongress != address(0));      
294     emit CongressTransferred(congress, newCongress);
295     congress = newCongress;
296   }
297 
298 }
299 
300 // File: contracts\Ownable.sol
301 
302 //pragma solidity ^0.4.11;
303 pragma solidity ^0.4.24;
304 
305 
306 /**
307  * @title Ownable
308  * @dev The Ownable contract has an owner address, and provides basic authorization control
309  * functions, this simplifies the implementation of "user permissions".
310  */
311 contract Ownable {
312   address public owner;
313 
314 
315   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
316 
317 
318   /**
319    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
320    * account.
321    */
322   constructor() public {
323     owner = msg.sender;
324   }
325 
326 
327   /**
328    * @dev Throws if called by any account other than the owner.
329    */
330   modifier onlyOwner() {
331     require(msg.sender == owner);
332     _;
333   }
334 
335 
336   /**
337    * @dev Allows the current owner to transfer control of the contract to a newOwner.
338    * @param newOwner The address to transfer ownership to.
339    */
340   function transferOwnership(address newOwner) onlyOwner public {
341     require(newOwner != address(0));
342     emit OwnershipTransferred(owner, newOwner);
343     owner = newOwner;
344   }
345 
346 }
347 
348 // File: contracts\HarborToken.sol
349 
350 //pragma solidity ^0.4.11;
351 pragma solidity ^0.4.24;
352 
353 
354 
355 /**
356  * @title Harbor token
357  * @dev Simple ERC20 Token example, with mintable token creation
358  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
359  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
360  */
361 
362 contract HarborToken is StandardToken, Ownable, Congress {
363 
364   //define HarborToken
365   string public constant name = "HarborToken";
366   string public constant symbol = "HBR";
367   uint8 public constant decimals = 18;
368 
369    /** List of agents that are allowed to create new tokens */
370   mapping (address => bool) public mintAgents;
371 
372   event Mint(address indexed to, uint256 amount);
373   event MintOpened();
374   event MintFinished();
375   event MintingAgentChanged(address indexed addr, bool state  );
376   event BurnToken(address indexed addr,uint256 amount);
377   event WithdrowErc20Token (address indexed erc20, address indexed wallet, uint value);
378 
379   bool public mintingFinished = false;
380 
381   modifier canMint() {
382     require(!mintingFinished);
383     _;
384   }
385 
386   modifier onlyMintAgent() {
387     // Only specific addresses contracts are allowed to mint new tokens
388     require(mintAgents[msg.sender]);
389     _;
390   }
391 
392   constructor() public {
393     setMintAgent(msg.sender,true);
394   }
395 
396   /**
397    * Congress can regulate new token issuance by contract.
398    */
399   function setMintAgent(address addr, bool state) public onlyDiscussable {
400     mintAgents[addr] = state;
401     emit MintingAgentChanged(addr, state);
402   }
403 
404   /**
405    * @dev Function to mint tokens
406    * @param _to The address that will receive the minted tokens.
407    * @param _amount The amount of tokens to mint.
408    * @return A boolean that indicates if the operation was successful.
409    */
410   function mint(address _to, uint256 _amount) public onlyMintAgent canMint {
411     totalSupply_ = totalSupply_.add(_amount);
412     balances[_to] = balances[_to].add(_amount);
413     emit Mint(_to, _amount);
414     emit Transfer(address(0), _to, _amount);
415   }
416 
417   /**
418    * @dev Function to burn down tokens
419    * @param _addr The address that will burn the tokens.
420    * @param  _amount The amount of tokens to burn.
421    * @return A boolean that indicates if the burn up was successful.
422    */
423   function burn(address _addr,uint256 _amount) public onlyMintAgent canMint {
424     require(_addr != address(0));
425     require(_amount > 0);
426     require(balances[_addr] >= _amount);
427     totalSupply_ = totalSupply_.sub(_amount);
428     balances[_addr] = balances[_addr].sub(_amount);
429     emit BurnToken(_addr,_amount);
430     emit Transfer(_addr, address(0), _amount);
431   }
432 
433 
434 
435   /**
436    * @dev Function to resume minting new tokens.
437    * @return True if the operation was successful.
438    */
439   function openMinting() public onlyOwner returns (bool) {
440     mintingFinished = false;
441     emit MintOpened();
442      return true;
443   }
444 
445  /**
446    * @dev Function to stop minting new tokens.
447    * @return True if the operation was successful.
448    */
449   function finishMinting() public onlyOwner returns (bool) {
450     mintingFinished = true;
451     emit MintFinished();
452     return true;
453   }
454 
455 
456 /** pauseable**/
457 
458   event Pause();
459   event Unpause();
460 
461   bool public paused = false;
462   /**
463    * @dev Modifier to make a function callable only when the contract is not paused.
464    */
465   modifier whenNotPaused() {
466     require(!paused);
467     _;
468   }
469 
470   /**
471    * @dev Modifier to make a function callable only when the contract is paused.
472    */
473   modifier whenPaused() {
474     require(paused);
475     _;
476   }
477 
478   /**
479    * @dev called by the owner to pause, triggers stopped state
480    */
481   function pause() onlyOwner whenNotPaused public {
482     paused = true;
483     emit Pause();
484   }
485 
486   /**
487    * @dev called by the owner to unpause, returns to normal state
488    */
489   function unpause() onlyOwner whenPaused public {
490     paused = false;
491     emit Unpause();
492   }
493  function transfer(address _to, uint256 _value) public whenNotPaused  returns (bool) {
494     return super.transfer(_to, _value);
495   }
496 
497   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
498     return super.transferFrom(_from, _to, _value);
499   }
500 
501   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
502     return super.approve(_spender, _value);
503   }
504 
505   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
506     return super.increaseApproval(_spender, _addedValue);
507   }
508 
509   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
510     return super.decreaseApproval(_spender, _subtractedValue);
511   }
512 
513   //Owner can refund the wrong transfered erc20
514   function withdrowErc20(address _tokenAddr, address _to, uint _value) public onlyOwner {
515     ERC20 erc20 = ERC20(_tokenAddr);
516     erc20.transfer(_to, _value);
517     emit WithdrowErc20Token(_tokenAddr, _to, _value);
518   }
519 
520 }