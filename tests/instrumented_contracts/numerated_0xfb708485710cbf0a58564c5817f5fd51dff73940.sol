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
12 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
13 pragma solidity ^0.4.21;
14 
15 
16 /**
17  * @title ERC20Basic
18  * @dev Simpler version of ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/179
20  */
21 contract ERC20Basic {
22   function totalSupply() public view returns (uint256);
23   function balanceOf(address who) public view returns (uint256);
24   function transfer(address to, uint256 value) public returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
29 pragma solidity ^0.4.21;
30 
31 
32 
33 
34 /**
35  * @title ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20 is ERC20Basic {
39   function allowance(address owner, address spender) public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 //File: node_modules/openzeppelin-solidity/contracts/token/ERC827/ERC827.sol
46 pragma solidity ^0.4.21;
47 
48 
49 
50 
51 
52 /**
53  * @title ERC827 interface, an extension of ERC20 token standard
54  *
55  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
56  * @dev methods to transfer value and data and execute calls in transfers and
57  * @dev approvals.
58  */
59 contract ERC827 is ERC20 {
60   function approveAndCall( address _spender, uint256 _value, bytes _data) public payable returns (bool);
61   function transferAndCall( address _to, uint256 _value, bytes _data) public payable returns (bool);
62   function transferFromAndCall(
63     address _from,
64     address _to,
65     uint256 _value,
66     bytes _data
67   )
68     public
69     payable
70     returns (bool);
71 }
72 
73 //File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
74 pragma solidity ^0.4.21;
75 
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     if (a == 0) {
88       return 0;
89     }
90     c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     // uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return a / b;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
124 pragma solidity ^0.4.21;
125 
126 
127 
128 
129 
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   uint256 totalSupply_;
141 
142   /**
143   * @dev total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return totalSupply_;
147   }
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     emit Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public view returns (uint256) {
170     return balances[_owner];
171   }
172 
173 }
174 
175 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
176 pragma solidity ^0.4.21;
177 
178 
179 
180 
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * @dev https://github.com/ethereum/EIPs/issues/20
187  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) internal allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208     emit Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214    *
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param _spender The address which will spend the funds.
220    * @param _value The amount of tokens to be spent.
221    */
222   function approve(address _spender, uint256 _value) public returns (bool) {
223     allowed[msg.sender][_spender] = _value;
224     emit Approval(msg.sender, _spender, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifying the amount of tokens still available for the spender.
233    */
234   function allowance(address _owner, address _spender) public view returns (uint256) {
235     return allowed[_owner][_spender];
236   }
237 
238   /**
239    * @dev Increase the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _addedValue The amount of tokens to increase the allowance by.
247    */
248   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
249     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To decrement
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _subtractedValue The amount of tokens to decrease the allowance by.
263    */
264   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 //File: node_modules/openzeppelin-solidity/contracts/token/ERC827/ERC827Token.sol
278 /* solium-disable security/no-low-level-calls */
279 
280 pragma solidity ^0.4.21;
281 
282 
283 
284 
285 
286 /**
287  * @title ERC827, an extension of ERC20 token standard
288  *
289  * @dev Implementation the ERC827, following the ERC20 standard with extra
290  * @dev methods to transfer value and data and execute calls in transfers and
291  * @dev approvals.
292  *
293  * @dev Uses OpenZeppelin StandardToken.
294  */
295 contract ERC827Token is ERC827, StandardToken {
296 
297   /**
298    * @dev Addition to ERC20 token methods. It allows to
299    * @dev approve the transfer of value and execute a call with the sent data.
300    *
301    * @dev Beware that changing an allowance with this method brings the risk that
302    * @dev someone may use both the old and the new allowance by unfortunate
303    * @dev transaction ordering. One possible solution to mitigate this race condition
304    * @dev is to first reduce the spender's allowance to 0 and set the desired value
305    * @dev afterwards:
306    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307    *
308    * @param _spender The address that will spend the funds.
309    * @param _value The amount of tokens to be spent.
310    * @param _data ABI-encoded contract call to call `_to` address.
311    *
312    * @return true if the call function was executed successfully
313    */
314   function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
315     require(_spender != address(this));
316 
317     super.approve(_spender, _value);
318 
319     // solium-disable-next-line security/no-call-value
320     require(_spender.call.value(msg.value)(_data));
321 
322     return true;
323   }
324 
325   /**
326    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
327    * @dev address and execute a call with the sent data on the same transaction
328    *
329    * @param _to address The address which you want to transfer to
330    * @param _value uint256 the amout of tokens to be transfered
331    * @param _data ABI-encoded contract call to call `_to` address.
332    *
333    * @return true if the call function was executed successfully
334    */
335   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
336     require(_to != address(this));
337 
338     super.transfer(_to, _value);
339 
340     // solium-disable-next-line security/no-call-value
341     require(_to.call.value(msg.value)(_data));
342     return true;
343   }
344 
345   /**
346    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
347    * @dev another and make a contract call on the same transaction
348    *
349    * @param _from The address which you want to send tokens from
350    * @param _to The address which you want to transfer to
351    * @param _value The amout of tokens to be transferred
352    * @param _data ABI-encoded contract call to call `_to` address.
353    *
354    * @return true if the call function was executed successfully
355    */
356   function transferFromAndCall(
357     address _from,
358     address _to,
359     uint256 _value,
360     bytes _data
361   )
362     public payable returns (bool)
363   {
364     require(_to != address(this));
365 
366     super.transferFrom(_from, _to, _value);
367 
368     // solium-disable-next-line security/no-call-value
369     require(_to.call.value(msg.value)(_data));
370     return true;
371   }
372 
373   /**
374    * @dev Addition to StandardToken methods. Increase the amount of tokens that
375    * @dev an owner allowed to a spender and execute a call with the sent data.
376    *
377    * @dev approve should be called when allowed[_spender] == 0. To increment
378    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
379    * @dev the first transaction is mined)
380    * @dev From MonolithDAO Token.sol
381    *
382    * @param _spender The address which will spend the funds.
383    * @param _addedValue The amount of tokens to increase the allowance by.
384    * @param _data ABI-encoded contract call to call `_spender` address.
385    */
386   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
387     require(_spender != address(this));
388 
389     super.increaseApproval(_spender, _addedValue);
390 
391     // solium-disable-next-line security/no-call-value
392     require(_spender.call.value(msg.value)(_data));
393 
394     return true;
395   }
396 
397   /**
398    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
399    * @dev an owner allowed to a spender and execute a call with the sent data.
400    *
401    * @dev approve should be called when allowed[_spender] == 0. To decrement
402    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
403    * @dev the first transaction is mined)
404    * @dev From MonolithDAO Token.sol
405    *
406    * @param _spender The address which will spend the funds.
407    * @param _subtractedValue The amount of tokens to decrease the allowance by.
408    * @param _data ABI-encoded contract call to call `_spender` address.
409    */
410   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
411     require(_spender != address(this));
412 
413     super.decreaseApproval(_spender, _subtractedValue);
414 
415     // solium-disable-next-line security/no-call-value
416     require(_spender.call.value(msg.value)(_data));
417 
418     return true;
419   }
420 
421 }
422 
423 //File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
424 pragma solidity ^0.4.21;
425 
426 
427 /**
428  * @title Ownable
429  * @dev The Ownable contract has an owner address, and provides basic authorization control
430  * functions, this simplifies the implementation of "user permissions".
431  */
432 contract Ownable {
433   address public owner;
434 
435 
436   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438 
439   /**
440    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
441    * account.
442    */
443   function Ownable() public {
444     owner = msg.sender;
445   }
446 
447   /**
448    * @dev Throws if called by any account other than the owner.
449    */
450   modifier onlyOwner() {
451     require(msg.sender == owner);
452     _;
453   }
454 
455   /**
456    * @dev Allows the current owner to transfer control of the contract to a newOwner.
457    * @param newOwner The address to transfer ownership to.
458    */
459   function transferOwnership(address newOwner) public onlyOwner {
460     require(newOwner != address(0));
461     emit OwnershipTransferred(owner, newOwner);
462     owner = newOwner;
463   }
464 
465 }
466 
467 //File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
468 pragma solidity ^0.4.21;
469 
470 
471 
472 
473 
474 /**
475  * @title Pausable
476  * @dev Base contract which allows children to implement an emergency stop mechanism.
477  */
478 contract Pausable is Ownable {
479   event Pause();
480   event Unpause();
481 
482   bool public paused = false;
483 
484 
485   /**
486    * @dev Modifier to make a function callable only when the contract is not paused.
487    */
488   modifier whenNotPaused() {
489     require(!paused);
490     _;
491   }
492 
493   /**
494    * @dev Modifier to make a function callable only when the contract is paused.
495    */
496   modifier whenPaused() {
497     require(paused);
498     _;
499   }
500 
501   /**
502    * @dev called by the owner to pause, triggers stopped state
503    */
504   function pause() onlyOwner whenNotPaused public {
505     paused = true;
506     emit Pause();
507   }
508 
509   /**
510    * @dev called by the owner to unpause, returns to normal state
511    */
512   function unpause() onlyOwner whenPaused public {
513     paused = false;
514     emit Unpause();
515   }
516 }
517 
518 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
519 pragma solidity ^0.4.21;
520 
521 
522 
523 
524 
525 /**
526  * @title Pausable token
527  * @dev StandardToken modified with pausable transfers.
528  **/
529 contract PausableToken is StandardToken, Pausable {
530 
531   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
532     return super.transfer(_to, _value);
533   }
534 
535   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
536     return super.transferFrom(_from, _to, _value);
537   }
538 
539   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
540     return super.approve(_spender, _value);
541   }
542 
543   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
544     return super.increaseApproval(_spender, _addedValue);
545   }
546 
547   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
548     return super.decreaseApproval(_spender, _subtractedValue);
549   }
550 }
551 
552 //File: contracts/ico/StoToken.sol
553 /**
554  * @title Stone Coin
555  *
556  * @version 1.0
557  * @author Validity Labs AG <info@validitylabs.org>
558  */
559 
560 pragma solidity ^0.4.21;
561 
562 
563 
564 
565 /**
566  * @dev Constructor of StoToken that instantiates a new PausableToken
567  */
568 contract StoToken is PausableToken, ERC827Token {
569     string public constant name = "Stone Coin";
570     string public constant symbol = "STO";
571     uint8 public constant decimals = 18;
572     uint256 public constant INITIAL_BALANCE = 10**6 * 10**uint256(decimals);     // 1 million STO tokens
573 
574     function StoToken(address _owner, address initialAccount) public {
575         require(_owner != address(0) && initialAccount != address(0) && _owner != initialAccount);
576         owner = _owner;
577         balances[initialAccount] = INITIAL_BALANCE;
578         totalSupply_ = INITIAL_BALANCE;
579         emit Transfer(address(0), initialAccount, INITIAL_BALANCE);
580     }
581 }