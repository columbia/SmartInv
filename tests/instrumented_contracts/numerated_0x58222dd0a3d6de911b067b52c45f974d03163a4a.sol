1 // File: zeppelin-solidity/contracts/math/SafeMath.sol
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title SafeMathUint256
51  * @dev Uint256 math operations with safety checks that throw on error
52  */
53 library SafeMathUint256 {
54     using SafeMath for uint256;
55 
56     function min(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a <= b) {
58             return a;
59         } else {
60             return b;
61         }
62     }
63 
64     function max(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a >= b) {
66             return a;
67         } else {
68             return b;
69         }
70     }
71 
72     function getUint256Min() internal pure returns (uint256) {
73         return 0;
74     }
75 
76     function getUint256Max() internal pure returns (uint256) {
77         return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
78     }
79 
80     function isMultipleOf(uint256 a, uint256 b) internal pure returns (bool) {
81         return a % b == 0;
82     }
83 
84     // Float [fixed point] Operations
85     function fxpMul(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
86         return a.mul(b).div(base);
87     }
88 
89     function fxpDiv(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {
90         return a.mul(base).div(b);
91     }
92 }
93 
94 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
95 
96 /**
97  * @title ERC20Basic
98  * @dev Simpler version of ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/179
100  */
101 contract ERC20Basic {
102   function totalSupply() public view returns (uint256);
103   function balanceOf(address who) public view returns (uint256);
104   function transfer(address to, uint256 value) public returns (bool);
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   uint256 totalSupply_;
133 
134   /**
135   * @dev total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     // SafeMath.sub will throw if there is not enough balance.
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256 balance) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190     require(_value <= balances[_from]);
191     require(_value <= allowed[_from][msg.sender]);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196     Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    *
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     allowed[msg.sender][_spender] = _value;
212     Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(address _owner, address _spender) public view returns (uint256) {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 contract DetailedERC20 is ERC20 {
266   string public name;
267   string public symbol;
268   uint8 public decimals;
269 
270   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
271     name = _name;
272     symbol = _symbol;
273     decimals = _decimals;
274   }
275 }
276 
277 /**
278  * @title Set interface
279  */
280 contract Set {
281   function issue(uint quantity) public returns (bool success);
282   function redeem(uint quantity) public returns (bool success);
283 
284   event LogIssuance(
285     address indexed _sender,
286     uint indexed _quantity
287   );
288 
289   event LogRedemption(
290     address indexed _sender,
291     uint indexed _quantity
292   );
293 }
294 
295 
296 /**
297  * @title {Set}
298  * @author Felix Feng
299  * @dev Implementation of the basic {Set} token.
300  */
301 contract SetToken is StandardToken, DetailedERC20("Decentralized Exchange", "DEX", 18), Set {
302   using SafeMathUint256 for uint256;
303 
304   ///////////////////////////////////////////////////////////
305   /// Data Structures
306   ///////////////////////////////////////////////////////////
307   struct Component {
308     address address_;
309     uint unit_;
310   }
311 
312   struct UnredeemedComponent {
313     uint balance;
314     bool isRedeemed;
315   }
316 
317   ///////////////////////////////////////////////////////////
318   /// States
319   ///////////////////////////////////////////////////////////
320   uint public naturalUnit;
321   Component[] public components;
322   mapping(address => bool) internal isComponent;
323   // Mapping of token address -> user address -> UnredeemedComponent
324   mapping(address => mapping(address => UnredeemedComponent)) public unredeemedComponents;
325 
326 
327   ///////////////////////////////////////////////////////////
328   /// Events
329   ///////////////////////////////////////////////////////////
330   event LogPartialRedemption(
331     address indexed _sender,
332     uint indexed _quantity,
333     address[] _excludedComponents
334   );
335 
336   event LogRedeemExcluded(
337     address indexed _sender,
338     address[] _components
339   );
340 
341   ///////////////////////////////////////////////////////////
342   /// Modifiers
343   ///////////////////////////////////////////////////////////
344   modifier hasSufficientBalance(uint quantity) {
345     // Check that the sender has sufficient components
346     // Since the component length is defined ahead of time, this is not
347     // an unbounded loop
348     require(balances[msg.sender] >= quantity, "User does not have sufficient balance");
349     _;
350   }
351 
352   modifier validDestination(address _to) {
353     require(_to != address(0));
354     require(_to != address(this));
355     _;
356   }
357 
358   modifier isMultipleOfNaturalUnit(uint _quantity) {
359     require((_quantity % naturalUnit) == 0);
360     _;
361   }
362 
363   modifier isNonZero(uint _quantity) {
364     require(_quantity > 0);
365     _;
366   }
367 
368   /**
369    * @dev Constructor Function for the issuance of an {Set} token
370    * @param _components address[] A list of component address which you want to include
371    * @param _units uint[] A list of quantities in gWei of each component (corresponds to the {Set} of _components)
372    */
373   constructor(address[] _components, uint[] _units, uint _naturalUnit) public {
374     // There must be component present
375     require(_components.length > 0, "Component length needs to be great than 0");
376 
377     // There must be an array of units
378     require(_units.length > 0, "Units must be greater than 0");
379 
380     // The number of components must equal the number of units
381     require(_components.length == _units.length, "Component and unit lengths must be the same");
382 
383     require(_naturalUnit > 0);
384     naturalUnit = _naturalUnit;
385 
386     // As looping operations are expensive, checking for duplicates will be
387     // on the onus of the application developer
388 
389     // NOTE: It will be the onus of developers to check whether the addressExists
390     // are in fact ERC20 addresses
391     for (uint i = 0; i < _units.length; i++) {
392       // Check that all units are non-zero. Negative numbers will underflow
393       uint currentUnits = _units[i];
394       require(currentUnits > 0, "Unit declarations must be non-zero");
395 
396       // Check that all addresses are non-zero
397       address currentComponent = _components[i];
398       require(currentComponent != address(0), "Components must have non-zero address");
399 
400       // add component to isComponent mapping
401       isComponent[currentComponent] = true;
402 
403       components.push(Component({
404         address_: currentComponent,
405         unit_: currentUnits
406       }));
407     }
408   }
409 
410   // Prevent Ether from being sent to the contract
411   function () payable {
412     revert();
413   }
414 
415   ///////////////////////////////////////////////////////////
416   /// Set Functions
417   ///////////////////////////////////////////////////////////
418 
419   /**
420    * @dev Function to convert component into {Set} Tokens
421    *
422    * Please note that the user's ERC20 component must be approved by
423    * their ERC20 contract to transfer their components to this contract.
424    *
425    * @param quantity uint The quantity of component desired to convert in Wei
426    */
427   function issue(uint quantity)
428     isMultipleOfNaturalUnit(quantity)
429     isNonZero(quantity)
430     public returns (bool success) {
431     // Transfers the sender's components to the contract
432     // Since the component length is defined ahead of time, this is not
433     // an unbounded loop
434     for (uint i = 0; i < components.length; i++) {
435       address currentComponent = components[i].address_;
436       uint currentUnits = components[i].unit_;
437 
438       uint transferValue = calculateTransferValue(currentUnits, quantity);
439 
440       assert(ERC20(currentComponent).transferFrom(msg.sender, this, transferValue));
441     }
442 
443     mint(quantity);
444 
445     emit LogIssuance(msg.sender, quantity);
446 
447     return true;
448   }
449 
450   /**
451    * @dev Function to convert {Set} Tokens into underlying components
452    *
453    * The ERC20 components do not need to be approved to call this function
454    *
455    * @param quantity uint The quantity of Sets desired to redeem in Wei
456    */
457   function redeem(uint quantity)
458     public
459     isMultipleOfNaturalUnit(quantity)
460     hasSufficientBalance(quantity)
461     isNonZero(quantity)
462     returns (bool success)
463   {
464     burn(quantity);
465 
466     for (uint i = 0; i < components.length; i++) {
467       address currentComponent = components[i].address_;
468       uint currentUnits = components[i].unit_;
469 
470       uint transferValue = calculateTransferValue(currentUnits, quantity);
471 
472       // The transaction will fail if any of the components fail to transfer
473       assert(ERC20(currentComponent).transfer(msg.sender, transferValue));
474     }
475 
476     emit LogRedemption(msg.sender, quantity);
477 
478     return true;
479   }
480 
481   /**
482    * @dev Function to withdraw a portion of the component tokens of a Set
483    *
484    * This function should be used in the event that a component token has been
485    * paused for transfer temporarily or permanently. This allows users a
486    * method to withdraw tokens in the event that one token has been frozen
487    *
488    * @param quantity uint The quantity of Sets desired to redeem in Wei
489    * @param excludedComponents address[] The list of tokens to exclude
490    */
491   function partialRedeem(uint quantity, address[] excludedComponents)
492     public
493     isMultipleOfNaturalUnit(quantity)
494     isNonZero(quantity)
495     hasSufficientBalance(quantity)
496     returns (bool success)
497   {
498     // Excluded tokens should be less than the number of components
499     // Otherwise, use the normal redeem function
500     require(
501       excludedComponents.length < components.length,
502       "Excluded component length must be less than component length"
503     );
504     require(excludedComponents.length > 0, "Excluded components must be non-zero");
505 
506     burn(quantity);
507 
508     for (uint i = 0; i < components.length; i++) {
509       bool isExcluded = false;
510 
511       uint transferValue = calculateTransferValue(components[i].unit_, quantity);
512 
513       // This is unideal to do a doubly nested loop, but the number of excludedComponents
514       // should generally be a small number
515       for (uint j = 0; j < excludedComponents.length; j++) {
516         address currentExcluded = excludedComponents[j];
517 
518         // Check that excluded token is indeed a component in this contract
519         assert(isComponent[currentExcluded]);
520 
521         // If the token is excluded, add to the user's unredeemed component value
522         if (components[i].address_ == currentExcluded) {
523           // Check whether component is already redeemed; Ensures duplicate excludedComponents
524           // has not been inputted.
525           bool currentIsRedeemed = unredeemedComponents[components[i].address_][msg.sender].isRedeemed;
526           assert(currentIsRedeemed == false);
527 
528           unredeemedComponents[components[i].address_][msg.sender].balance += transferValue;
529 
530           // Mark redeemed to ensure no duplicates
531           unredeemedComponents[components[i].address_][msg.sender].isRedeemed = true;
532 
533           isExcluded = true;
534         }
535       }
536 
537       if (!isExcluded) {
538         assert(ERC20(components[i].address_).transfer(msg.sender, transferValue));
539       }
540     }
541 
542     // Mark all excluded components not redeemed
543     for (uint k = 0; k < excludedComponents.length; k++) {
544       address currentExcludedToUnredeem = excludedComponents[k];
545       unredeemedComponents[currentExcludedToUnredeem][msg.sender].isRedeemed = false;
546     }
547 
548     emit LogPartialRedemption(msg.sender, quantity, excludedComponents);
549 
550     return true;
551   }
552 
553   /**
554    * @dev Function to withdraw tokens that have previously been excluded when calling
555    * the redeemExcluded method
556    *
557    * This function should be used to retrieve tokens that have previously excluded
558    * when calling the redeemExcluded function.
559    *
560    * @param componentsToRedeem address[] The list of tokens to redeem
561    * @param quantities uint[] The quantity of Sets desired to redeem in Wei
562    */
563   function redeemExcluded(address[] componentsToRedeem, uint[] quantities)
564     public
565     returns (bool success)
566   {
567     require(quantities.length > 0, "Quantities must be non-zero");
568     require(componentsToRedeem.length > 0, "Components redeemed must be non-zero");
569     require(quantities.length == componentsToRedeem.length, "Lengths must be the same");
570 
571     for (uint i = 0; i < quantities.length; i++) {
572       address currentComponent = componentsToRedeem[i];
573       uint currentQuantity = quantities[i];
574 
575       // Check there is enough balance
576       uint remainingBalance = unredeemedComponents[currentComponent][msg.sender].balance;
577       require(remainingBalance >= currentQuantity);
578 
579       // To prevent re-entrancy attacks, decrement the user's Set balance
580       unredeemedComponents[currentComponent][msg.sender].balance = remainingBalance.sub(currentQuantity);
581 
582       assert(ERC20(currentComponent).transfer(msg.sender, currentQuantity));
583     }
584 
585     emit LogRedeemExcluded(msg.sender, componentsToRedeem);
586 
587     return true;
588   }
589 
590   ///////////////////////////////////////////////////////////
591   /// Getters
592   ///////////////////////////////////////////////////////////
593 
594   function componentCount() public view returns(uint componentsLength) {
595     return components.length;
596   }
597 
598   function getComponents() public view returns(address[]) {
599     address[] memory componentAddresses = new address[](components.length);
600     for (uint i = 0; i < components.length; i++) {
601         componentAddresses[i] = components[i].address_;
602     }
603     return componentAddresses;
604   }
605 
606   function getUnits() public view returns(uint[]) {
607     uint[] memory units = new uint[](components.length);
608     for (uint i = 0; i < components.length; i++) {
609         units[i] = components[i].unit_;
610     }
611     return units;
612   }
613 
614   ///////////////////////////////////////////////////////////
615   /// Transfer Updates
616   ///////////////////////////////////////////////////////////
617   function transfer(address _to, uint256 _value) validDestination(_to) public returns (bool) {
618     return super.transfer(_to, _value);
619   }
620 
621   function transferFrom(address _from, address _to, uint256 _value) validDestination(_to) public returns (bool) {
622     return super.transferFrom(_from, _to, _value);
623   }
624 
625   ///////////////////////////////////////////////////////////
626   /// Private Function
627   ///////////////////////////////////////////////////////////
628 
629   function calculateTransferValue(uint componentUnits, uint quantity) internal returns(uint) {
630     return quantity.div(naturalUnit).mul(componentUnits);
631   }
632 
633   function mint(uint quantity) internal {
634     // If successful, increment the balance of the user’s {Set} token
635     balances[msg.sender] = balances[msg.sender].add(quantity);
636 
637     // Increment the total token supply
638     totalSupply_ = totalSupply_.add(quantity);
639   }
640 
641   function burn(uint quantity) internal {
642     balances[msg.sender] = balances[msg.sender].sub(quantity);
643     totalSupply_ = totalSupply_.sub(quantity);
644   }
645 }