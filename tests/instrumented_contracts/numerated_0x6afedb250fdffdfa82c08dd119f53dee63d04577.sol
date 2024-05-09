1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20 interface
5  */
6 contract ERC20 {
7   function totalSupply()
8     public view returns (uint256);
9 
10   function balanceOf(address who)
11     public view returns (uint256);
12 
13   function transfer(address to, uint256 value)
14     public returns (bool);
15 
16   function allowance(address owner, address spender)
17     public view returns (uint256);
18 
19   function transferFrom(address from, address to, uint256 value)
20     public returns (bool);
21 
22   function approve(address spender, uint256 value)
23     public returns (bool);
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 
31   event Transfer(
32     address indexed from,
33     address indexed to,
34     uint256 value);
35 }
36 
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47   event OwnershipTransferred(
48     address indexed previousOwner,
49     address indexed newOwner
50   );
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   constructor() public {
58     owner = msg.sender;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) public onlyOwner {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 /**
82  * @title ERC827 interface, an extension of ERC20 token standard
83  *
84  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
85  * @dev methods to transfer value and data and execute calls in transfers and
86  * @dev approvals.
87  */
88 contract ERC827 is ERC20 {
89   function approveAndCall(
90     address _spender,
91     uint256 _value,
92     bytes _data
93   )
94     public
95     payable
96     returns (bool);
97 
98   function transferAndCall(
99     address _to,
100     uint256 _value,
101     bytes _data
102   )
103     public
104     payable
105     returns (bool);
106 
107   function transferFromAndCall(
108     address _from,
109     address _to,
110     uint256 _value,
111     bytes _data
112   )
113     public
114     payable
115     returns (bool);
116 }
117 
118 /**
119  * @title SafeMath
120  * @dev Math operations with safety checks that throw on error
121  */
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, throws on overflow.
126   */
127   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
128     if (a == 0) {
129       return 0;
130     }
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
166  * @title Standard ERC20 token
167  *
168  */
169 contract ERC20Token is ERC20{
170 
171   using SafeMath for uint256;
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175   mapping(address => uint256) balances;
176 
177   uint256 totalSupply_;
178 
179   /**
180   * @dev total number of tokens in existence
181   */
182   function totalSupply() public view returns (uint256) {
183     return totalSupply_;
184   }
185 
186   /**
187   * @dev transfer token for a specified address
188   * @param _to The address to transfer to.
189   * @param _value The amount to be transferred.
190   */
191   function transfer(address _to, uint256 _value) public returns (bool) {
192     require(_to != address(0));
193     require(_value <= balances[msg.sender]);
194 
195     balances[msg.sender] = balances[msg.sender].sub(_value);
196     balances[_to] = balances[_to].add(_value);
197     emit Transfer(msg.sender, _to, _value);
198     return true;
199   }
200 
201   /**
202   * @dev Gets the balance of the specified address.
203   * @param _owner The address to query the the balance of.
204   * @return An uint256 representing the amount owned by the passed address.
205   */
206   function balanceOf(address _owner) public view returns (uint256) {
207     return balances[_owner];
208   }
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(
218     address _from,
219     address _to,
220     uint256 _value
221   )
222     public
223     returns (bool)
224   {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     emit Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(
252     address _owner,
253     address _spender
254    )
255     public
256     view
257     returns (uint256)
258   {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To increment
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _addedValue The amount of tokens to increase the allowance by.
271    */
272   function increaseApproval(
273     address _spender,
274     uint _addedValue
275   )
276     public
277     returns (bool)
278   {
279     allowed[msg.sender][_spender] = (
280       allowed[msg.sender][_spender].add(_addedValue));
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseApproval(
296     address _spender,
297     uint _subtractedValue
298   )
299     public
300     returns (bool)
301   {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312 }
313 
314 
315 
316 /**
317  * @title ERC827, an extension of ERC20 token standard
318  *
319  * @dev Implementation the ERC827, following the ERC20 standard with extra
320  * @dev methods to transfer value and data and execute calls in transfers and
321  * @dev approvals.
322  *
323  * @dev Uses OpenZeppelin StandardToken.
324  */
325 contract ERC827Token is ERC827, ERC20Token {
326 
327   /**
328    * @dev Addition to ERC20 token methods. It allows to
329    * @dev approve the transfer of value and execute a call with the sent data.
330    *
331    * @dev Beware that changing an allowance with this method brings the risk that
332    * @dev someone may use both the old and the new allowance by unfortunate
333    * @dev transaction ordering. One possible solution to mitigate this race condition
334    * @dev is to first reduce the spender's allowance to 0 and set the desired value
335    * @dev afterwards:
336    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
337    *
338    * @param _spender The address that will spend the funds.
339    * @param _value The amount of tokens to be spent.
340    * @param _data ABI-encoded contract call to call `_to` address.
341    *
342    * @return true if the call function was executed successfully
343    */
344   function approveAndCall(
345     address _spender,
346     uint256 _value,
347     bytes _data
348   )
349     public
350     payable
351     returns (bool)
352   {
353     require(_spender != address(this));
354 
355     super.approve(_spender, _value);
356 
357     // solium-disable-next-line security/no-call-value
358     require(_spender.call.value(msg.value)(_data));
359 
360     return true;
361   }
362 
363   /**
364    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
365    * @dev address and execute a call with the sent data on the same transaction
366    *
367    * @param _to address The address which you want to transfer to
368    * @param _value uint256 the amout of tokens to be transfered
369    * @param _data ABI-encoded contract call to call `_to` address.
370    *
371    * @return true if the call function was executed successfully
372    */
373   function transferAndCall(
374     address _to,
375     uint256 _value,
376     bytes _data
377   )
378     public
379     payable
380     returns (bool)
381   {
382     require(_to != address(this));
383 
384     super.transfer(_to, _value);
385 
386     require(_to.call.value(msg.value)(_data));
387     return true;
388   }
389 
390   /**
391    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
392    * @dev another and make a contract call on the same transaction
393    *
394    * @param _from The address which you want to send tokens from
395    * @param _to The address which you want to transfer to
396    * @param _value The amout of tokens to be transferred
397    * @param _data ABI-encoded contract call to call `_to` address.
398    *
399    * @return true if the call function was executed successfully
400    */
401   function transferFromAndCall(
402     address _from,
403     address _to,
404     uint256 _value,
405     bytes _data
406   )
407     public payable returns (bool)
408   {
409     require(_to != address(this));
410 
411     super.transferFrom(_from, _to, _value);
412 
413     require(_to.call.value(msg.value)(_data));
414     return true;
415   }
416 
417   /**
418    * @dev Addition to StandardToken methods. Increase the amount of tokens that
419    * @dev an owner allowed to a spender and execute a call with the sent data.
420    *
421    * @dev approve should be called when allowed[_spender] == 0. To increment
422    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
423    * @dev the first transaction is mined)
424    * @dev From MonolithDAO Token.sol
425    *
426    * @param _spender The address which will spend the funds.
427    * @param _addedValue The amount of tokens to increase the allowance by.
428    * @param _data ABI-encoded contract call to call `_spender` address.
429    */
430   function increaseApprovalAndCall(
431     address _spender,
432     uint _addedValue,
433     bytes _data
434   )
435     public
436     payable
437     returns (bool)
438   {
439     require(_spender != address(this));
440 
441     super.increaseApproval(_spender, _addedValue);
442 
443     require(_spender.call.value(msg.value)(_data));
444 
445     return true;
446   }
447 
448   /**
449    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
450    * @dev an owner allowed to a spender and execute a call with the sent data.
451    *
452    * @dev approve should be called when allowed[_spender] == 0. To decrement
453    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
454    * @dev the first transaction is mined)
455    * @dev From MonolithDAO Token.sol
456    *
457    * @param _spender The address which will spend the funds.
458    * @param _subtractedValue The amount of tokens to decrease the allowance by.
459    * @param _data ABI-encoded contract call to call `_spender` address.
460    */
461   function decreaseApprovalAndCall(
462     address _spender,
463     uint _subtractedValue,
464     bytes _data
465   )
466     public
467     payable
468     returns (bool)
469   {
470     require(_spender != address(this));
471 
472     super.decreaseApproval(_spender, _subtractedValue);
473 
474     require(_spender.call.value(msg.value)(_data));
475 
476     return true;
477   }
478 
479 }
480 
481 
482 
483 /**
484  * @title  Burnable and Pause Token
485  * @dev    StandardToken modified with pausable transfers.
486  **/
487 contract PauseBurnableERC827Token is ERC827Token, Ownable{
488   using SafeMath for uint256;
489 
490   event Pause();
491   event Unpause();
492   event PauseOperatorTransferred(address indexed previousOperator,address indexed newOperator);
493 
494 
495   event Burn(address indexed burner, uint256 value);
496 
497   bool    public paused = false;
498   address public pauseOperator;
499 
500   /**
501    * @dev Throws if called by any account other than the owner.
502    */
503   modifier onlyPauseOperator() {
504     require(msg.sender == pauseOperator || msg.sender == owner);
505     _;
506   }
507 
508   /**
509    * @dev Modifier to make a function callable only when the contract is not paused.
510    */
511   modifier whenNotPaused() {
512     require(!paused);
513     _;
514   }
515 
516   /**
517    * @dev Modifier to make a function callable only when the contract is paused.
518    */
519   modifier whenPaused() {
520     require(paused);
521     _;
522   }
523 
524   /**
525    * @dev The constructor sets the original `owner` of the contract to the sender
526    * account.
527    */
528   constructor() public {
529     pauseOperator = msg.sender;
530   }
531 
532     /**
533    * @dev called by the operator to set the new operator to pause the token
534    */
535   function transferPauseOperator(address newPauseOperator) onlyPauseOperator public {
536     require(newPauseOperator != address(0));
537     emit PauseOperatorTransferred(pauseOperator, newPauseOperator);
538     pauseOperator = newPauseOperator;
539   }
540 
541   /**
542    * @dev called by the owner to pause, triggers stopped state
543    */
544   function pause() onlyPauseOperator whenNotPaused public {
545     paused = true;
546     emit Pause();
547   }
548 
549   /**
550    * @dev called by the owner to unpause, returns to normal state
551    */
552   function unpause() onlyPauseOperator whenPaused public {
553     paused = false;
554     emit Unpause();
555   }
556 
557   function transfer(address _to,uint256 _value)
558     public
559     whenNotPaused
560     returns (bool)
561   {
562     return super.transfer(_to, _value);
563   }
564 
565   function transferFrom(address _from,address _to,uint256 _value)
566     public
567     whenNotPaused
568     returns (bool)
569   {
570     return super.transferFrom(_from, _to, _value);
571   }
572 
573   function approve(address _spender,uint256 _value)
574     public
575     whenNotPaused
576     returns (bool)
577   {
578     return super.approve(_spender, _value);
579   }
580 
581   function increaseApproval(address _spender,uint _addedValue)
582     public
583     whenNotPaused
584     returns (bool success)
585   {
586     return super.increaseApproval(_spender, _addedValue);
587   }
588 
589   function decreaseApproval(address _spender,uint _subtractedValue)
590     public
591     whenNotPaused
592     returns (bool success)
593   {
594     return super.decreaseApproval(_spender, _subtractedValue);
595   }
596 
597   /**
598   * @dev Burns a specific amount of tokens.
599   * @param _value The amount of token to be burned.
600   */
601   function burn(uint256 _value)
602     public whenNotPaused
603   {
604       _burn(msg.sender, _value);
605   }
606 
607   function _burn(address _who, uint256 _value) internal{
608       require(_value <= balances[_who]);
609       // no need to require value <= totalSupply, since that would imply the
610       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
611 
612       balances[_who] = balances[_who].sub(_value);                      // Subtract from the sender
613       totalSupply_ = totalSupply_.sub(_value);
614 
615       emit Burn(_who, _value);
616       emit Transfer(_who, address(0), _value);
617   }
618 
619   /**
620   * @dev Burns a specific amount of tokens from the target address and decrements allowance
621   * @param _from address The address which you want to send tokens from
622   * @param _value uint256 The amount of token to be burned
623   */
624   function burnFrom(address _from, uint256 _value)
625     public whenNotPaused
626   {
627       require(_value <= allowed[_from][msg.sender]);
628       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
629       _burn(_from, _value);
630   }
631 }
632 
633 contract ICOTH is PauseBurnableERC827Token {
634         string  public constant name     = "ICOTH";
635         string  public constant symbol   = "i";
636         uint8   public constant decimals = 18;
637         uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
638 
639         /**
640         * @dev Constructor that gives msg.sender all of existing tokens.
641         */
642         constructor() public {
643             totalSupply_ = INITIAL_SUPPLY;
644             balances[msg.sender] = INITIAL_SUPPLY;
645             emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
646         }
647 }