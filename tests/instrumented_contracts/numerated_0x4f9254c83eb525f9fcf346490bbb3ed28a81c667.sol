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
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender)
74     public view returns (uint256);
75 
76   function transferFrom(address from, address to, uint256 value)
77     public returns (bool);
78 
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(
81     address indexed owner,
82     address indexed spender,
83     uint256 value
84   );
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   uint256 totalSupply_;
98 
99   /**
100   * @dev Total number of tokens in existence
101   */
102   function totalSupply() public view returns (uint256) {
103     return totalSupply_;
104   }
105 
106   /**
107   * @dev Transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[msg.sender]);
114 
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     emit Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public view returns (uint256) {
127     return balances[_owner];
128   }
129 
130 }
131 
132 
133 /**
134  * @title Ownable
135  * @dev The Ownable contract has an owner address, and provides basic authorization control
136  * functions, this simplifies the implementation of "user permissions".
137  */
138 contract Ownable {
139   address public owner;
140 
141 
142   event OwnershipRenounced(address indexed previousOwner);
143   event OwnershipTransferred(
144     address indexed previousOwner,
145     address indexed newOwner
146   );
147 
148 
149   /**
150    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
151    * account.
152    */
153   constructor() public {
154     owner = msg.sender;
155   }
156 
157   /**
158    * @dev Throws if called by any account other than the owner.
159    */
160   modifier onlyOwner() {
161     require(msg.sender == owner);
162     _;
163   }
164 
165   /**
166    * @dev Allows the current owner to relinquish control of the contract.
167    * @notice Renouncing to ownership will leave the contract without an owner.
168    * It will not be possible to call the functions with the `onlyOwner`
169    * modifier anymore.
170    */
171   function renounceOwnership() public onlyOwner {
172     emit OwnershipRenounced(owner);
173     owner = address(0);
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param _newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address _newOwner) public onlyOwner {
181     _transferOwnership(_newOwner);
182   }
183 
184   /**
185    * @dev Transfers control of the contract to a newOwner.
186    * @param _newOwner The address to transfer ownership to.
187    */
188   function _transferOwnership(address _newOwner) internal {
189     require(_newOwner != address(0));
190     emit OwnershipTransferred(owner, _newOwner);
191     owner = _newOwner;
192   }
193 }
194 
195 
196 /**
197  * @title Pausable
198  * @dev Base contract which allows children to implement an emergency stop mechanism.
199  */
200 contract Pausable is Ownable {
201   event Pause();
202   event Unpause();
203 
204   bool public paused = false;
205 
206 
207   /**
208    * @dev Modifier to make a function callable only when the contract is not paused.
209    */
210   modifier whenNotPaused() {
211     require(!paused);
212     _;
213   }
214 
215   /**
216    * @dev Modifier to make a function callable only when the contract is paused.
217    */
218   modifier whenPaused() {
219     require(paused);
220     _;
221   }
222 
223   /**
224    * @dev called by the owner to pause, triggers stopped state
225    */
226   function pause() onlyOwner whenNotPaused public {
227     paused = true;
228     emit Pause();
229   }
230 
231   /**
232    * @dev called by the owner to unpause, returns to normal state
233    */
234   function unpause() onlyOwner whenPaused public {
235     paused = false;
236     emit Unpause();
237   }
238 }
239 
240 
241 /**
242  * @title Standard ERC20 token
243  *
244  * @dev Implementation of the basic standard token.
245  * https://github.com/ethereum/EIPs/issues/20
246  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
247  */
248 contract StandardToken is ERC20, BasicToken {
249 
250   mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(
260     address _from,
261     address _to,
262     uint256 _value
263   )
264     public
265     returns (bool)
266   {
267     require(_to != address(0));
268     require(_value <= balances[_from]);
269     require(_value <= allowed[_from][msg.sender]);
270 
271     balances[_from] = balances[_from].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
274     emit Transfer(_from, _to, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
280    * Beware that changing an allowance with this method brings the risk that someone may use both the old
281    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
282    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
283    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284    * @param _spender The address which will spend the funds.
285    * @param _value The amount of tokens to be spent.
286    */
287   function approve(address _spender, uint256 _value) public returns (bool) {
288     allowed[msg.sender][_spender] = _value;
289     emit Approval(msg.sender, _spender, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Function to check the amount of tokens that an owner allowed to a spender.
295    * @param _owner address The address which owns the funds.
296    * @param _spender address The address which will spend the funds.
297    * @return A uint256 specifying the amount of tokens still available for the spender.
298    */
299   function allowance(
300     address _owner,
301     address _spender
302    )
303     public
304     view
305     returns (uint256)
306   {
307     return allowed[_owner][_spender];
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    * approve should be called when allowed[_spender] == 0. To increment
313    * allowed value is better to use this function to avoid 2 calls (and wait until
314    * the first transaction is mined)
315    * From MonolithDAO Token.sol
316    * @param _spender The address which will spend the funds.
317    * @param _addedValue The amount of tokens to increase the allowance by.
318    */
319   function increaseApproval(
320     address _spender,
321     uint256 _addedValue
322   )
323     public
324     returns (bool)
325   {
326     allowed[msg.sender][_spender] = (
327       allowed[msg.sender][_spender].add(_addedValue));
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332   /**
333    * @dev Decrease the amount of tokens that an owner allowed to a spender.
334    * approve should be called when allowed[_spender] == 0. To decrement
335    * allowed value is better to use this function to avoid 2 calls (and wait until
336    * the first transaction is mined)
337    * From MonolithDAO Token.sol
338    * @param _spender The address which will spend the funds.
339    * @param _subtractedValue The amount of tokens to decrease the allowance by.
340    */
341   function decreaseApproval(
342     address _spender,
343     uint256 _subtractedValue
344   )
345     public
346     returns (bool)
347   {
348     uint256 oldValue = allowed[msg.sender][_spender];
349     if (_subtractedValue > oldValue) {
350       allowed[msg.sender][_spender] = 0;
351     } else {
352       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
353     }
354     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355     return true;
356   }
357 
358 }
359 
360 
361 /**
362  * @title SuccinctWhitelist
363  * @dev The SuccinctWhitelist contract has a whitelist of addresses, and provides basic authorization control functions.
364  * Note: this is a succinct, straightforward and easy to understand implementation of openzeppelin-solidity's Whitelisted,
365  * but with full functionalities and APIs of openzeppelin-solidity's Whitelisted without inheriting RBAC.
366  */
367 contract SuccinctWhitelist is Ownable {
368   mapping(address => bool) public whitelisted;
369 
370   event WhitelistAdded(address indexed operator);
371   event WhitelistRemoved(address indexed operator);
372 
373   /**
374    * @dev Throws if operator is not whitelisted.
375    * @param _operator address
376    */
377   modifier onlyIfWhitelisted(address _operator) {
378     require(whitelisted[_operator]);
379     _;
380   }
381 
382   /**
383    * @dev add an address to the whitelist
384    * @param _operator address
385    * @return true if the address was added to the whitelist,
386    * or was already in the whitelist
387    */
388   function addAddressToWhitelist(address _operator)
389     onlyOwner
390     public
391     returns (bool)
392   {
393     whitelisted[_operator] = true;
394     emit WhitelistAdded(_operator);
395     return true;
396   }
397 
398   /**
399    * @dev getter to determine if address is in whitelist
400    */
401   function whitelist(address _operator)
402     public
403     view
404     returns (bool)
405   {
406     bool result = whitelisted[_operator];
407     return result;
408   }
409 
410   /**
411    * @dev add addresses to the whitelist
412    * @param _operators addresses
413    * @return true if all addresses was added to the whitelist,
414    * or were already in the whitelist
415    */
416   function addAddressesToWhitelist(address[] _operators)
417     onlyOwner
418     public
419     returns (bool)
420   {
421     for (uint256 i = 0; i < _operators.length; i++) {
422       require(addAddressToWhitelist(_operators[i]));
423     }
424     return true;
425   }
426 
427   /**
428    * @dev remove an address from the whitelist
429    * @param _operator address
430    * @return true if the address was removed from the whitelist,
431    * or the address wasn't in the whitelist in the first place
432    */
433   function removeAddressFromWhitelist(address _operator)
434     onlyOwner
435     public
436     returns (bool)
437   {
438     whitelisted[_operator] = false;
439     emit WhitelistRemoved(_operator);
440     return true;
441   }
442 
443   /**
444    * @dev remove addresses from the whitelist
445    * @param _operators addresses
446    * @return true if all addresses were removed from the whitelist,
447    * or weren't in the whitelist in the first place
448    */
449   function removeAddressesFromWhitelist(address[] _operators)
450     onlyOwner
451     public
452     returns (bool)
453   {
454     for (uint256 i = 0; i < _operators.length; i++) {
455       require(removeAddressFromWhitelist(_operators[i]));
456     }
457     return true;
458   }
459 
460 }
461 
462 
463 /**
464  * @title Pausable token
465  * @dev StandardToken modified with pausable transfers.
466  **/
467 contract PausableToken is StandardToken, Pausable {
468 
469   function transfer(
470     address _to,
471     uint256 _value
472   )
473     public
474     whenNotPaused
475     returns (bool)
476   {
477     return super.transfer(_to, _value);
478   }
479 
480   function transferFrom(
481     address _from,
482     address _to,
483     uint256 _value
484   )
485     public
486     whenNotPaused
487     returns (bool)
488   {
489     return super.transferFrom(_from, _to, _value);
490   }
491 
492   function approve(
493     address _spender,
494     uint256 _value
495   )
496     public
497     whenNotPaused
498     returns (bool)
499   {
500     return super.approve(_spender, _value);
501   }
502 
503   function increaseApproval(
504     address _spender,
505     uint _addedValue
506   )
507     public
508     whenNotPaused
509     returns (bool success)
510   {
511     return super.increaseApproval(_spender, _addedValue);
512   }
513 
514   function decreaseApproval(
515     address _spender,
516     uint _subtractedValue
517   )
518     public
519     whenNotPaused
520     returns (bool success)
521   {
522     return super.decreaseApproval(_spender, _subtractedValue);
523   }
524 }
525 
526 
527 /**
528  * @title CelerToken
529  * @dev Celer Network's token contract.
530  */
531 contract CelerToken is PausableToken, SuccinctWhitelist {
532   string public constant name = "CelerToken";
533   string public constant symbol = "CELR";
534   uint256 public constant decimals = 18;
535 
536   // 10 billion tokens with 18 decimals
537   uint256 public constant INITIAL_SUPPLY = 1e28;
538 
539   // Indicate whether token transferability is opened to everyone
540   bool public transferOpened = false;
541 
542   modifier onlyIfTransferable() {
543     require(transferOpened || whitelisted[msg.sender] || msg.sender == owner);
544     _;
545   }
546 
547   modifier onlyValidReceiver(address _to) {
548     require(_to != address(this));
549     _;
550   }
551 
552   constructor() public {
553     totalSupply_ = INITIAL_SUPPLY;
554     balances[msg.sender] = INITIAL_SUPPLY;
555   }
556 
557   /** 
558    * @dev Extend parent behavior requiring transfer
559    * to respect transferability and receiver's validity.
560    */
561   function transfer(
562     address _to,
563     uint256 _value
564   )
565     public
566     onlyIfTransferable
567     onlyValidReceiver(_to)
568     returns (bool)
569   {
570     return super.transfer(_to, _value);
571   }
572 
573   /** 
574    * @dev Extend parent behavior requiring transferFrom
575    * to respect transferability and receiver's validity.
576    */
577   function transferFrom(
578     address _from,
579     address _to,
580     uint256 _value
581   )
582     public
583     onlyIfTransferable
584     onlyValidReceiver(_to)
585     returns (bool)
586   {
587     return super.transferFrom(_from, _to, _value);
588   }
589 
590   /** 
591    * @dev Open token transferability.
592    */
593   function openTransfer() external onlyOwner {
594     transferOpened = true;
595   }
596 }