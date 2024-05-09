1 /**
2  * Die THE STONE COIN AG sichert zu, dass die von ihr im Rahmen der Token-Ausgabe netto (=nach Abzug ihrer Kosten/Steuern) 
3  * vereinnahmten Mittel in den Aufbau und dauerhaften Betrieb eines europäischen Immobilienportfolios – unter Berücksichtigung 
4  * internationaler Chancen – investiert werden (REAL SHIELD).
5  * 
6  * The THE STONE COIN AG assures that the net funds (= after their costs and taxes) raised by the initial STONE COIN sales 
7  * will be invested in the creation and permanent operation of a European real estate portfolio (REAL SHIELD) – taking into 
8  * consideration international opportunites.
9  */
10 
11 
12 
13 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
14 pragma solidity ^0.4.21;
15 
16 
17 /**
18  * @title ERC20Basic
19  * @dev Simpler version of ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/179
21  */
22 contract ERC20Basic {
23   function totalSupply() public view returns (uint256);
24   function balanceOf(address who) public view returns (uint256);
25   function transfer(address to, uint256 value) public returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
30 pragma solidity ^0.4.21;
31 
32 
33 
34 
35 /**
36  * @title ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/20
38  */
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 //File: node_modules/openzeppelin-solidity/contracts/token/ERC827/ERC827.sol
47 pragma solidity ^0.4.21;
48 
49 
50 
51 
52 
53 /**
54  * @title ERC827 interface, an extension of ERC20 token standard
55  *
56  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
57  * @dev methods to transfer value and data and execute calls in transfers and
58  * @dev approvals.
59  */
60 contract ERC827 is ERC20 {
61   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
62   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
63   function transferFromAndCall(
64     address _from,
65     address _to,
66     uint256 _value,
67     bytes _data
68   )
69     public
70     payable
71     returns (bool);
72 }
73 
74 //File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
75 pragma solidity ^0.4.21;
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, throws on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88     if (a == 0) {
89       return 0;
90     }
91     c = a * b;
92     assert(c / a == b);
93     return c;
94   }
95 
96   /**
97   * @dev Integer division of two numbers, truncating the quotient.
98   */
99   function div(uint256 a, uint256 b) internal pure returns (uint256) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     // uint256 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return a / b;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118     c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
125 pragma solidity ^0.4.21;
126 
127 
128 
129 
130 
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
177 pragma solidity ^0.4.21;
178 
179 
180 
181 
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/20
188  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191 
192   mapping (address => mapping (address => uint256)) internal allowed;
193 
194 
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[_from]);
204     require(_value <= allowed[_from][msg.sender]);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     emit Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifying the amount of tokens still available for the spender.
234    */
235   function allowance(address _owner, address _spender) public view returns (uint256) {
236     return allowed[_owner][_spender];
237   }
238 
239   /**
240    * @dev Increase the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
250     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Decrease the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 //File: node_modules/openzeppelin-solidity/contracts/token/ERC827/ERC827Token.sol
279 /* solium-disable security/no-low-level-calls */
280 
281 pragma solidity ^0.4.21;
282 
283 
284 
285 
286 
287 /**
288  * @title ERC827, an extension of ERC20 token standard
289  *
290  * @dev Implementation the ERC827, following the ERC20 standard with extra
291  * @dev methods to transfer value and data and execute calls in transfers and
292  * @dev approvals.
293  *
294  * @dev Uses OpenZeppelin StandardToken.
295  */
296 contract ERC827Token is ERC827, StandardToken {
297 
298   /**
299    * @dev Addition to ERC20 token methods. It allows to
300    * @dev approve the transfer of value and execute a call with the sent data.
301    *
302    * @dev Beware that changing an allowance with this method brings the risk that
303    * @dev someone may use both the old and the new allowance by unfortunate
304    * @dev transaction ordering. One possible solution to mitigate this race condition
305    * @dev is to first reduce the spender's allowance to 0 and set the desired value
306    * @dev afterwards:
307    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308    *
309    * @param _spender The address that will spend the funds.
310    * @param _value The amount of tokens to be spent.
311    * @param _data ABI-encoded contract call to call `_to` address.
312    *
313    * @return true if the call function was executed successfully
314    */
315   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
316     require(_spender != address(this));
317 
318     super.approve(_spender, _value);
319 
320     // solium-disable-next-line security/no-call-value
321     require(_spender.call.value(msg.value)(_data));
322 
323     return true;
324   }
325 
326   /**
327    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
328    * @dev address and execute a call with the sent data on the same transaction
329    *
330    * @param _to address The address which you want to transfer to
331    * @param _value uint256 the amout of tokens to be transfered
332    * @param _data ABI-encoded contract call to call `_to` address.
333    *
334    * @return true if the call function was executed successfully
335    */
336   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
337     require(_to != address(this));
338 
339     super.transfer(_to, _value);
340 
341     // solium-disable-next-line security/no-call-value
342     require(_to.call.value(msg.value)(_data));
343     return true;
344   }
345 
346   /**
347    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
348    * @dev another and make a contract call on the same transaction
349    *
350    * @param _from The address which you want to send tokens from
351    * @param _to The address which you want to transfer to
352    * @param _value The amout of tokens to be transferred
353    * @param _data ABI-encoded contract call to call `_to` address.
354    *
355    * @return true if the call function was executed successfully
356    */
357   function transferFromAndCall(
358     address _from,
359     address _to,
360     uint256 _value,
361     bytes _data
362   )
363     public payable returns (bool)
364   {
365     require(_to != address(this));
366 
367     super.transferFrom(_from, _to, _value);
368 
369     // solium-disable-next-line security/no-call-value
370     require(_to.call.value(msg.value)(_data));
371     return true;
372   }
373 
374   /**
375    * @dev Addition to StandardToken methods. Increase the amount of tokens that
376    * @dev an owner allowed to a spender and execute a call with the sent data.
377    *
378    * @dev approve should be called when allowed[_spender] == 0. To increment
379    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
380    * @dev the first transaction is mined)
381    * @dev From MonolithDAO Token.sol
382    *
383    * @param _spender The address which will spend the funds.
384    * @param _addedValue The amount of tokens to increase the allowance by.
385    * @param _data ABI-encoded contract call to call `_spender` address.
386    */
387   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
388     require(_spender != address(this));
389 
390     super.increaseApproval(_spender, _addedValue);
391 
392     // solium-disable-next-line security/no-call-value
393     require(_spender.call.value(msg.value)(_data));
394 
395     return true;
396   }
397 
398   /**
399    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
400    * @dev an owner allowed to a spender and execute a call with the sent data.
401    *
402    * @dev approve should be called when allowed[_spender] == 0. To decrement
403    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
404    * @dev the first transaction is mined)
405    * @dev From MonolithDAO Token.sol
406    *
407    * @param _spender The address which will spend the funds.
408    * @param _subtractedValue The amount of tokens to decrease the allowance by.
409    * @param _data ABI-encoded contract call to call `_spender` address.
410    */
411   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
412     require(_spender != address(this));
413 
414     super.decreaseApproval(_spender, _subtractedValue);
415 
416     // solium-disable-next-line security/no-call-value
417     require(_spender.call.value(msg.value)(_data));
418 
419     return true;
420   }
421 
422 }
423 
424 //File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
425 pragma solidity ^0.4.21;
426 
427 
428 /**
429  * @title Ownable
430  * @dev The Ownable contract has an owner address, and provides basic authorization control
431  * functions, this simplifies the implementation of "user permissions".
432  */
433 contract Ownable {
434   address public owner;
435 
436 
437   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
438 
439 
440   /**
441    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
442    * account.
443    */
444   function Ownable() public {
445     owner = msg.sender;
446   }
447 
448   /**
449    * @dev Throws if called by any account other than the owner.
450    */
451   modifier onlyOwner() {
452     require(msg.sender == owner);
453     _;
454   }
455 
456   /**
457    * @dev Allows the current owner to transfer control of the contract to a newOwner.
458    * @param newOwner The address to transfer ownership to.
459    */
460   function transferOwnership(address newOwner) public onlyOwner {
461     require(newOwner != address(0));
462     emit OwnershipTransferred(owner, newOwner);
463     owner = newOwner;
464   }
465 
466 }
467 
468 //File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
469 pragma solidity ^0.4.21;
470 
471 
472 
473 
474 
475 /**
476  * @title Pausable
477  * @dev Base contract which allows children to implement an emergency stop mechanism.
478  */
479 contract Pausable is Ownable {
480   event Pause();
481   event Unpause();
482 
483   bool public paused = false;
484 
485 
486   /**
487    * @dev Modifier to make a function callable only when the contract is not paused.
488    */
489   modifier whenNotPaused() {
490     require(!paused);
491     _;
492   }
493 
494   /**
495    * @dev Modifier to make a function callable only when the contract is paused.
496    */
497   modifier whenPaused() {
498     require(paused);
499     _;
500   }
501 
502   /**
503    * @dev called by the owner to pause, triggers stopped state
504    */
505   function pause() onlyOwner whenNotPaused public {
506     paused = true;
507     emit Pause();
508   }
509 
510   /**
511    * @dev called by the owner to unpause, returns to normal state
512    */
513   function unpause() onlyOwner whenPaused public {
514     paused = false;
515     emit Unpause();
516   }
517 }
518 
519 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
520 pragma solidity ^0.4.21;
521 
522 
523 
524 
525 
526 /**
527  * @title Pausable token
528  * @dev StandardToken modified with pausable transfers.
529  **/
530 contract PausableToken is StandardToken, Pausable {
531 
532   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
533     return super.transfer(_to, _value);
534   }
535 
536   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
537     return super.transferFrom(_from, _to, _value);
538   }
539 
540   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
541     return super.approve(_spender, _value);
542   }
543 
544   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
545     return super.increaseApproval(_spender, _addedValue);
546   }
547 
548   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
549     return super.decreaseApproval(_spender, _subtractedValue);
550   }
551 }
552 
553 //File: contracts/ico/StoToken.sol
554 /**
555  * @title Stone Coin
556  *
557  * @version 1.0
558  * @author Validity Labs AG <info@validitylabs.org>
559  */
560 
561 pragma solidity ^0.4.21;
562 
563 
564 
565 
566 /**
567  * @dev Constructor of StoToken that instantiates a new PausableToken
568  */
569 contract StoToken is PausableToken, ERC827Token {
570     string public constant name = "Stone Coin";
571     string public constant symbol = "STO";
572     uint8 public constant decimals = 18;
573     uint256 public constant INITIAL_BALANCE = 10**9 * 10**uint256(decimals);     // 1 billion STO tokens
574 
575     function StoToken(address _owner, address initialAccount) public {
576         require(_owner != address(0) && initialAccount != address(0) && _owner != initialAccount);
577         owner = _owner;
578         balances[initialAccount] = INITIAL_BALANCE;
579         totalSupply_ = INITIAL_BALANCE;
580         emit Transfer(address(0), initialAccount, INITIAL_BALANCE);
581     }
582 }