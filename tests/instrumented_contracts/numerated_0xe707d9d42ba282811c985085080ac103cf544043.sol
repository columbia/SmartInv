1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
65 
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev called by the owner to pause, triggers stopped state
95    */
96   function pause() onlyOwner whenNotPaused public {
97     paused = true;
98     emit Pause();
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() onlyOwner whenPaused public {
105     paused = false;
106     emit Unpause();
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
125 
126 /**
127  * @title SafeMath
128  * @dev Math operations with safety checks that throw on error
129  */
130 library SafeMath {
131 
132   /**
133   * @dev Multiplies two numbers, throws on overflow.
134   */
135   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
136     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
137     // benefit is lost if 'b' is also tested.
138     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
139     if (a == 0) {
140       return 0;
141     }
142 
143     c = a * b;
144     assert(c / a == b);
145     return c;
146   }
147 
148   /**
149   * @dev Integer division of two numbers, truncating the quotient.
150   */
151   function div(uint256 a, uint256 b) internal pure returns (uint256) {
152     // assert(b > 0); // Solidity automatically throws when dividing by 0
153     // uint256 c = a / b;
154     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155     return a / b;
156   }
157 
158   /**
159   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
160   */
161   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162     assert(b <= a);
163     return a - b;
164   }
165 
166   /**
167   * @dev Adds two numbers, throws on overflow.
168   */
169   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
170     c = a + b;
171     assert(c >= a);
172     return c;
173   }
174 }
175 
176 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
190   * @dev total number of tokens in existence
191   */
192   function totalSupply() public view returns (uint256) {
193     return totalSupply_;
194   }
195 
196   /**
197   * @dev transfer token for a specified address
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
222 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
223 
224 /**
225  * @title ERC20 interface
226  * @dev see https://github.com/ethereum/EIPs/issues/20
227  */
228 contract ERC20 is ERC20Basic {
229   function allowance(address owner, address spender)
230     public view returns (uint256);
231 
232   function transferFrom(address from, address to, uint256 value)
233     public returns (bool);
234 
235   function approve(address spender, uint256 value) public returns (bool);
236   event Approval(
237     address indexed owner,
238     address indexed spender,
239     uint256 value
240   );
241 }
242 
243 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
244 
245 /**
246  * @title Standard ERC20 token
247  *
248  * @dev Implementation of the basic standard token.
249  * @dev https://github.com/ethereum/EIPs/issues/20
250  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
251  */
252 contract StandardToken is ERC20, BasicToken {
253 
254   mapping (address => mapping (address => uint256)) internal allowed;
255 
256 
257   /**
258    * @dev Transfer tokens from one address to another
259    * @param _from address The address which you want to send tokens from
260    * @param _to address The address which you want to transfer to
261    * @param _value uint256 the amount of tokens to be transferred
262    */
263   function transferFrom(
264     address _from,
265     address _to,
266     uint256 _value
267   )
268     public
269     returns (bool)
270   {
271     require(_to != address(0));
272     require(_value <= balances[_from]);
273     require(_value <= allowed[_from][msg.sender]);
274 
275     balances[_from] = balances[_from].sub(_value);
276     balances[_to] = balances[_to].add(_value);
277     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
278     emit Transfer(_from, _to, _value);
279     return true;
280   }
281 
282   /**
283    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
284    *
285    * Beware that changing an allowance with this method brings the risk that someone may use both the old
286    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
287    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
288    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289    * @param _spender The address which will spend the funds.
290    * @param _value The amount of tokens to be spent.
291    */
292   function approve(address _spender, uint256 _value) public returns (bool) {
293     allowed[msg.sender][_spender] = _value;
294     emit Approval(msg.sender, _spender, _value);
295     return true;
296   }
297 
298   /**
299    * @dev Function to check the amount of tokens that an owner allowed to a spender.
300    * @param _owner address The address which owns the funds.
301    * @param _spender address The address which will spend the funds.
302    * @return A uint256 specifying the amount of tokens still available for the spender.
303    */
304   function allowance(
305     address _owner,
306     address _spender
307    )
308     public
309     view
310     returns (uint256)
311   {
312     return allowed[_owner][_spender];
313   }
314 
315   /**
316    * @dev Increase the amount of tokens that an owner allowed to a spender.
317    *
318    * approve should be called when allowed[_spender] == 0. To increment
319    * allowed value is better to use this function to avoid 2 calls (and wait until
320    * the first transaction is mined)
321    * From MonolithDAO Token.sol
322    * @param _spender The address which will spend the funds.
323    * @param _addedValue The amount of tokens to increase the allowance by.
324    */
325   function increaseApproval(
326     address _spender,
327     uint _addedValue
328   )
329     public
330     returns (bool)
331   {
332     allowed[msg.sender][_spender] = (
333       allowed[msg.sender][_spender].add(_addedValue));
334     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338   /**
339    * @dev Decrease the amount of tokens that an owner allowed to a spender.
340    *
341    * approve should be called when allowed[_spender] == 0. To decrement
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _subtractedValue The amount of tokens to decrease the allowance by.
347    */
348   function decreaseApproval(
349     address _spender,
350     uint _subtractedValue
351   )
352     public
353     returns (bool)
354   {
355     uint oldValue = allowed[msg.sender][_spender];
356     if (_subtractedValue > oldValue) {
357       allowed[msg.sender][_spender] = 0;
358     } else {
359       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
360     }
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365 }
366 
367 // File: contracts/TESecurityToken.sol
368 
369 contract TESecurityToken is StandardToken, Pausable {
370     
371 	string public constant name = "Tokenestate Equity";
372 	string public constant symbol = "TEM";
373 	string public companyURI = "www.tokenestate.io";
374 
375 	uint8 public constant decimals = 0;
376 
377 	address public previousContract;
378 	address public nextContract = 0x0;
379 
380 	mapping(address => bool) public whitelist;
381 
382 	bool public transferNeedApproval = true;
383 
384 	event LogAddToWhitelist(address sender, address indexed beneficiary);
385 	event LogRemoveFromWhitelist(address sender, address indexed beneficiary);
386 	event LogSetTransferNeedApproval(address sender, bool value);
387     event LogTransferFromIssuer(address sender, address indexed from, address indexed to, uint256 value);
388     event LogProof(bytes32 indexed proof);
389     event LogProofOfExistance(bytes32 indexed p0, bytes32 indexed p1, bytes32 indexed p2, bytes data);
390     event LogSetNextContract(address sender, address indexed next);
391 
392 	modifier isWhitelisted(address investor) 
393 	{
394 		require(whitelist[investor] == true);
395 		_;
396 	}
397 
398 	modifier isActiveContract() 
399 	{
400 		require(nextContract == 0x0);
401 		_;
402 	}
403 
404 	constructor (address prev)
405 	public
406 	{
407 		previousContract = prev;
408 	}
409 
410 	function setNextContract(address next)
411 	whenNotPaused
412 	onlyOwner
413 	isActiveContract
414 	public
415 	{
416 		require (nextContract == 0x0);
417 		nextContract = next;
418 		LogSetNextContract(msg.sender, nextContract);
419 	}
420 
421 	function setTransferNeedApproval(bool value)
422 	onlyOwner
423 	isActiveContract
424 	public
425 	{
426 		require (transferNeedApproval != value);
427 		transferNeedApproval = value;
428 		emit LogSetTransferNeedApproval(msg.sender, value);
429 	}
430 
431 	function proofOfExistance(bytes32 p0, bytes32 p1, bytes32 p2, bytes32 docHash, bytes data) 
432 	isActiveContract
433 	public
434 	{
435 		emit LogProofOfExistance(p0, p1, p2, data);
436 		emit LogProof(docHash);
437 	}
438 
439 	function addToWhitelist(address investor, bytes32 docHash) 
440 	whenNotPaused
441 	onlyOwner
442 	isActiveContract	
443 	external 
444 	{
445 		require (investor != 0x0);
446 		require (whitelist[investor] == false);
447 
448 		whitelist[investor] = true;
449 
450 		emit LogAddToWhitelist(msg.sender, investor);
451 		emit LogProof(docHash);
452 	}
453 
454 	function removeFromWhitelist(address investor, bytes32 docHash)
455 	onlyOwner
456 	whenNotPaused	
457 	isActiveContract	
458 	external 
459 	{
460 		require (investor != 0x0);
461 		require (whitelist[investor] == true);
462 		whitelist[investor] = false;
463 		emit LogRemoveFromWhitelist(msg.sender, investor);
464 		emit LogProof(docHash);
465 	}
466 
467 	function burn(address holder, uint256 value, bytes32 docHash) 
468 	onlyOwner 
469 	whenNotPaused
470 	isActiveContract	
471 	public
472 	returns (bool)	
473 	{
474 		require(value <= balances[holder]);
475 		balances[holder] = balances[holder].sub(value);
476 		totalSupply_ = totalSupply_.sub(value);
477 		emit Transfer(holder, address(0), value);
478 		emit LogProof(docHash);
479 		return true;
480 	}
481 
482 	function mint(address to, uint256 value, bytes32 docHash)
483 	onlyOwner
484 	whenNotPaused
485 	isActiveContract	
486 	isWhitelisted(to)
487 	public
488 	returns (bool)
489 	{
490 	    totalSupply_ = totalSupply_.add(value);
491     	balances[to] = balances[to].add(value);
492 	    emit Transfer(address(0), to, value);
493 		emit LogProof(docHash);
494 		return true;
495 	}
496 
497 	function transferFromIssuer(address from, address to, uint256 value, bytes32 docHash)
498 	onlyOwner
499 	whenNotPaused
500 	isActiveContract	
501 	isWhitelisted(to)
502     public
503     returns (bool)
504 	{
505 	    require(value <= balances[from]);
506 	    require(docHash != 0x0);
507 
508 	    balances[from] = balances[from].sub(value);
509 	    balances[to] = balances[to].add(value);
510 	    emit Transfer(from, to, value);
511 	    emit LogTransferFromIssuer(msg.sender, from, to, value);
512 		emit LogProof(docHash);
513 	    return true;
514 	}
515 
516 	function transfer(address to, uint256 amount)
517 	public 
518 	whenNotPaused
519 	isActiveContract
520 	isWhitelisted(msg.sender)		
521 	isWhitelisted(to)	
522 	returns (bool)
523 	{
524 		require (transferNeedApproval == false);
525 		bool ret = super.transfer(to, amount);
526 		return ret;
527 	}
528 
529 	function transferFrom(address from, address to, uint256 value) 
530 	public 
531 	whenNotPaused
532 	isActiveContract	
533 	isWhitelisted(from)	
534 	isWhitelisted(to)
535 	returns (bool)
536 	{
537 		require (transferNeedApproval == false);
538 		bool ret = super.transferFrom(from, to, value);
539 		return ret;
540 	}
541 
542 	function setCompanyURI(string _companyURI) 
543 	onlyOwner 
544 	whenNotPaused
545 	isActiveContract	
546 	public
547 	{
548 		require(bytes(_companyURI).length > 0); 
549 		companyURI = _companyURI;
550 	}
551 }