1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-06
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22       return 0;
23     }
24 
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * See https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender)
78     public view returns (uint256);
79 
80   function transferFrom(address from, address to, uint256 value)
81     public returns (bool);
82 
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   uint256 totalSupply_;
102 
103   /**
104   * @dev Total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109 
110   /**
111   * @dev Transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     emit Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public view returns (uint256) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 
137 /**
138  * @title Ownable
139  * @dev The Ownable contract has an owner address, and provides basic authorization control
140  * functions, this simplifies the implementation of "user permissions".
141  */
142 contract Ownable {
143   address public owner;
144 
145 
146   event OwnershipRenounced(address indexed previousOwner);
147   event OwnershipTransferred(
148     address indexed previousOwner,
149     address indexed newOwner
150   );
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   constructor() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to relinquish control of the contract.
171    * @notice Renouncing to ownership will leave the contract without an owner.
172    * It will not be possible to call the functions with the `onlyOwner`
173    * modifier anymore.
174    */
175   function renounceOwnership() public onlyOwner {
176     emit OwnershipRenounced(owner);
177     owner = address(0);
178   }
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param _newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address _newOwner) public onlyOwner {
185     _transferOwnership(_newOwner);
186   }
187 
188   /**
189    * @dev Transfers control of the contract to a newOwner.
190    * @param _newOwner The address to transfer ownership to.
191    */
192   function _transferOwnership(address _newOwner) internal {
193     require(_newOwner != address(0));
194     emit OwnershipTransferred(owner, _newOwner);
195     owner = _newOwner;
196   }
197 }
198 
199 
200 /**
201  * @title Pausable
202  * @dev Base contract which allows children to implement an emergency stop mechanism.
203  */
204 contract Pausable is Ownable {
205   event Pause();
206   event Unpause();
207 
208   bool public paused = false;
209 
210 
211   /**
212    * @dev Modifier to make a function callable only when the contract is not paused.
213    */
214   modifier whenNotPaused() {
215     require(!paused);
216     _;
217   }
218 
219   /**
220    * @dev Modifier to make a function callable only when the contract is paused.
221    */
222   modifier whenPaused() {
223     require(paused);
224     _;
225   }
226 
227   /**
228    * @dev called by the owner to pause, triggers stopped state
229    */
230   function pause() onlyOwner whenNotPaused public {
231     paused = true;
232     emit Pause();
233   }
234 
235   /**
236    * @dev called by the owner to unpause, returns to normal state
237    */
238   function unpause() onlyOwner whenPaused public {
239     paused = false;
240     emit Unpause();
241   }
242 }
243 
244 
245 /**
246  * @title Standard ERC20 token
247  *
248  * @dev Implementation of the basic standard token.
249  * https://github.com/ethereum/EIPs/issues/20
250  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
284    * Beware that changing an allowance with this method brings the risk that someone may use both the old
285    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
286    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
287    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288    * @param _spender The address which will spend the funds.
289    * @param _value The amount of tokens to be spent.
290    */
291   function approve(address _spender, uint256 _value) public returns (bool) {
292     allowed[msg.sender][_spender] = _value;
293     emit Approval(msg.sender, _spender, _value);
294     return true;
295   }
296 
297   /**
298    * @dev Function to check the amount of tokens that an owner allowed to a spender.
299    * @param _owner address The address which owns the funds.
300    * @param _spender address The address which will spend the funds.
301    * @return A uint256 specifying the amount of tokens still available for the spender.
302    */
303   function allowance(
304     address _owner,
305     address _spender
306    )
307     public
308     view
309     returns (uint256)
310   {
311     return allowed[_owner][_spender];
312   }
313 
314   /**
315    * @dev Increase the amount of tokens that an owner allowed to a spender.
316    * approve should be called when allowed[_spender] == 0. To increment
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param _spender The address which will spend the funds.
321    * @param _addedValue The amount of tokens to increase the allowance by.
322    */
323   function increaseApproval(
324     address _spender,
325     uint256 _addedValue
326   )
327     public
328     returns (bool)
329   {
330     allowed[msg.sender][_spender] = (
331       allowed[msg.sender][_spender].add(_addedValue));
332     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
333     return true;
334   }
335 
336   /**
337    * @dev Decrease the amount of tokens that an owner allowed to a spender.
338    * approve should be called when allowed[_spender] == 0. To decrement
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param _spender The address which will spend the funds.
343    * @param _subtractedValue The amount of tokens to decrease the allowance by.
344    */
345   function decreaseApproval(
346     address _spender,
347     uint256 _subtractedValue
348   )
349     public
350     returns (bool)
351   {
352     uint256 oldValue = allowed[msg.sender][_spender];
353     if (_subtractedValue > oldValue) {
354       allowed[msg.sender][_spender] = 0;
355     } else {
356       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
357     }
358     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359     return true;
360   }
361 
362 }
363 
364 
365 /**
366  * @title SuccinctWhitelist
367  * @dev The SuccinctWhitelist contract has a whitelist of addresses, and provides basic authorization control functions.
368  * Note: this is a succinct, straightforward and easy to understand implementation of openzeppelin-solidity's Whitelisted,
369  * but with full functionalities and APIs of openzeppelin-solidity's Whitelisted without inheriting RBAC.
370  */
371 contract SuccinctWhitelist is Ownable {
372   mapping(address => bool) public whitelisted;
373 
374   event WhitelistAdded(address indexed operator);
375   event WhitelistRemoved(address indexed operator);
376 
377   /**
378    * @dev Throws if operator is not whitelisted.
379    * @param _operator address
380    */
381   modifier onlyIfWhitelisted(address _operator) {
382     require(whitelisted[_operator]);
383     _;
384   }
385 
386   /**
387    * @dev add an address to the whitelist
388    * @param _operator address
389    * @return true if the address was added to the whitelist,
390    * or was already in the whitelist
391    */
392   function addAddressToWhitelist(address _operator)
393     onlyOwner
394     public
395     returns (bool)
396   {
397     whitelisted[_operator] = true;
398     emit WhitelistAdded(_operator);
399     return true;
400   }
401 
402   /**
403    * @dev getter to determine if address is in whitelist
404    */
405   function whitelist(address _operator)
406     public
407     view
408     returns (bool)
409   {
410     bool result = whitelisted[_operator];
411     return result;
412   }
413 
414   /**
415    * @dev add addresses to the whitelist
416    * @param _operators addresses
417    * @return true if all addresses was added to the whitelist,
418    * or were already in the whitelist
419    */
420   function addAddressesToWhitelist(address[] _operators)
421     onlyOwner
422     public
423     returns (bool)
424   {
425     for (uint256 i = 0; i < _operators.length; i++) {
426       require(addAddressToWhitelist(_operators[i]));
427     }
428     return true;
429   }
430 
431   /**
432    * @dev remove an address from the whitelist
433    * @param _operator address
434    * @return true if the address was removed from the whitelist,
435    * or the address wasn't in the whitelist in the first place
436    */
437   function removeAddressFromWhitelist(address _operator)
438     onlyOwner
439     public
440     returns (bool)
441   {
442     whitelisted[_operator] = false;
443     emit WhitelistRemoved(_operator);
444     return true;
445   }
446 
447   /**
448    * @dev remove addresses from the whitelist
449    * @param _operators addresses
450    * @return true if all addresses were removed from the whitelist,
451    * or weren't in the whitelist in the first place
452    */
453   function removeAddressesFromWhitelist(address[] _operators)
454     onlyOwner
455     public
456     returns (bool)
457   {
458     for (uint256 i = 0; i < _operators.length; i++) {
459       require(removeAddressFromWhitelist(_operators[i]));
460     }
461     return true;
462   }
463 
464 }
465 
466 
467 /**
468  * @title Pausable token
469  * @dev StandardToken modified with pausable transfers.
470  **/
471 contract PausableToken is StandardToken, Pausable {
472 
473   function transfer(
474     address _to,
475     uint256 _value
476   )
477     public
478     whenNotPaused
479     returns (bool)
480   {
481     return super.transfer(_to, _value);
482   }
483 
484   function transferFrom(
485     address _from,
486     address _to,
487     uint256 _value
488   )
489     public
490     whenNotPaused
491     returns (bool)
492   {
493     return super.transferFrom(_from, _to, _value);
494   }
495 
496   function approve(
497     address _spender,
498     uint256 _value
499   )
500     public
501     whenNotPaused
502     returns (bool)
503   {
504     return super.approve(_spender, _value);
505   }
506 
507   function increaseApproval(
508     address _spender,
509     uint _addedValue
510   )
511     public
512     whenNotPaused
513     returns (bool success)
514   {
515     return super.increaseApproval(_spender, _addedValue);
516   }
517 
518   function decreaseApproval(
519     address _spender,
520     uint _subtractedValue
521   )
522     public
523     whenNotPaused
524     returns (bool success)
525   {
526     return super.decreaseApproval(_spender, _subtractedValue);
527   }
528 }
529 
530 
531 /**
532  * @title MetToken
533  * @dev MET Network's token contract.
534  */
535 contract MetToken is PausableToken, SuccinctWhitelist {
536   string public constant name = "MetToken";
537   string public constant symbol = "MET";
538   uint256 public constant decimals = 18;
539 
540   // 8.6e7 tokens with 18 decimals
541   uint256 public constant INITIAL_SUPPLY = 8.6e25;
542 
543   // Indicate whether token transferability is opened to everyone
544   bool public transferOpened = false;
545 
546   modifier onlyIfTransferable() {
547     require(transferOpened || whitelisted[msg.sender] || msg.sender == owner);
548     _;
549   }
550 
551   modifier onlyValidReceiver(address _to) {
552     require(_to != address(this));
553     _;
554   }
555 
556   constructor() public {
557     totalSupply_ = INITIAL_SUPPLY;
558     balances[msg.sender] = INITIAL_SUPPLY;
559   }
560 
561   /** 
562    * @dev Extend parent behavior requiring transfer
563    * to respect transferability and receiver's validity.
564    */
565   function transfer(
566     address _to,
567     uint256 _value
568   )
569     public
570     onlyIfTransferable
571     onlyValidReceiver(_to)
572     returns (bool)
573   {
574     return super.transfer(_to, _value);
575   }
576 
577   /** 
578    * @dev Extend parent behavior requiring transferFrom
579    * to respect transferability and receiver's validity.
580    */
581   function transferFrom(
582     address _from,
583     address _to,
584     uint256 _value
585   )
586     public
587     onlyIfTransferable
588     onlyValidReceiver(_to)
589     returns (bool)
590   {
591     return super.transferFrom(_from, _to, _value);
592   }
593 
594   /** 
595    * @dev Open token transferability.
596    */
597   function openTransfer() external onlyOwner {
598     transferOpened = true;
599   }
600 }