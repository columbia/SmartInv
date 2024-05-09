1 pragma solidity 0.4.23;
2 
3 //////////////////////////////
4 ///// ERC20Basic
5 //////////////////////////////
6 
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   function totalSupply() public view returns (uint256);
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 
21 
22 //////////////////////////////
23 ///// ERC20 Interface
24 //////////////////////////////
25 
26 /**
27  * @title ERC20 interface
28  * @dev see https://github.com/ethereum/EIPs/issues/20
29  */
30 contract ERC20 is ERC20Basic {
31   function allowance(address owner, address spender) public view returns (uint256);
32   function transferFrom(address from, address to, uint256 value) public returns (bool);
33   function approve(address spender, uint256 value) public returns (bool);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 //////////////////////////////
38 ///// ERC20 Basic
39 //////////////////////////////
40 
41 /**
42  * @title Basic token
43  * @dev Basic version of StandardToken, with no allowances.
44  */
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   uint256 totalSupply_;
51 
52   /**
53   * @dev total number of tokens in existence
54   */
55   function totalSupply() public view returns (uint256) {
56     return totalSupply_;
57   }
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 
88 //////////////////////////////
89 ///// DetailedERC20
90 //////////////////////////////
91 
92 contract DetailedERC20 is ERC20 {
93   string public name;
94   string public symbol;
95   uint8 public decimals;
96 
97   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
98     name = _name;
99     symbol = _symbol;
100     decimals = _decimals;
101   }
102 }
103 
104 //////////////////////////////
105 ///// Standard Token
106 //////////////////////////////
107 
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * @dev https://github.com/ethereum/EIPs/issues/20
114  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is ERC20, BasicToken {
117 
118   mapping (address => mapping (address => uint256)) internal allowed;
119 
120 
121   /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * @param _value uint256 the amount of tokens to be transferred
126    */
127   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[_from]);
130     require(_value <= allowed[_from][msg.sender]);
131 
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    *
142    * Beware that changing an allowance with this method brings the risk that someone may use both the old
143    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    * @param _spender The address which will spend the funds.
147    * @param _value The amount of tokens to be spent.
148    */
149   function approve(address _spender, uint256 _value) public returns (bool) {
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Function to check the amount of tokens that an owner allowed to a spender.
157    * @param _owner address The address which owns the funds.
158    * @param _spender address The address which will spend the funds.
159    * @return A uint256 specifying the amount of tokens still available for the spender.
160    */
161   function allowance(address _owner, address _spender) public view returns (uint256) {
162     return allowed[_owner][_spender];
163   }
164 
165   /**
166    * @dev Increase the amount of tokens that an owner allowed to a spender.
167    *
168    * approve should be called when allowed[_spender] == 0. To increment
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _addedValue The amount of tokens to increase the allowance by.
174    */
175   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
176     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181   /**
182    * @dev Decrease the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To decrement
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _subtractedValue The amount of tokens to decrease the allowance by.
190    */
191   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
192     uint oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195     } else {
196       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197     }
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202 }
203 
204 
205 
206 //////////////////////////////
207 ///// SafeMath
208 //////////////////////////////
209 
210 
211 /**
212  * @title SafeMath
213  * @dev Math operations with safety checks that throw on error
214  */
215 library SafeMath {
216 
217   /**
218   * @dev Multiplies two numbers, throws on overflow.
219   */
220   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
221     if (a == 0) {
222       return 0;
223     }
224     uint256 c = a * b;
225     assert(c / a == b);
226     return c;
227   }
228 
229   /**
230   * @dev Integer division of two numbers, truncating the quotient.
231   */
232   function div(uint256 a, uint256 b) internal pure returns (uint256) {
233     // assert(b > 0); // Solidity automatically throws when dividing by 0
234     uint256 c = a / b;
235     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236     return c;
237   }
238 
239   /**
240   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
241   */
242   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243     assert(b <= a);
244     return a - b;
245   }
246 
247   /**
248   * @dev Adds two numbers, throws on overflow.
249   */
250   function add(uint256 a, uint256 b) internal pure returns (uint256) {
251     uint256 c = a + b;
252     assert(c >= a);
253     return c;
254   }
255 }
256 
257 
258 //////////////////////////////
259 ///// AddressArrayUtil
260 //////////////////////////////
261 
262 /**
263  * @title AddressArrayUtil
264  */
265 library AddressArrayUtils {
266   function hasValue(address[] addresses, address value) internal returns (bool) {
267     for (uint i = 0; i < addresses.length; i++) {
268       if (addresses[i] == value) {
269         return true;
270       }
271     }
272 
273     return false;
274   }
275 
276   function removeByIndex(address[] storage a, uint256 index) internal returns (uint256) {
277     a[index] = a[a.length - 1];
278     a.length -= 1;
279   }
280 }
281 
282 
283 //////////////////////////////
284 ///// Set Interface
285 //////////////////////////////
286 
287 /**
288  * @title Set interface
289  */
290 contract SetInterface {
291 
292   /**
293    * @dev Function to convert component into {Set} Tokens
294    *
295    * Please note that the user's ERC20 component must be approved by
296    * their ERC20 contract to transfer their components to this contract.
297    *
298    * @param _quantity uint The quantity of Sets desired to issue in Wei as a multiple of naturalUnit
299    */
300   function issue(uint _quantity) public returns (bool success);
301   
302   /**
303    * @dev Function to convert {Set} Tokens into underlying components
304    *
305    * The ERC20 components do not need to be approved to call this function
306    *
307    * @param _quantity uint The quantity of Sets desired to redeem in Wei as a multiple of naturalUnit
308    */
309   function redeem(uint _quantity) public returns (bool success);
310 
311   event LogIssuance(
312     address indexed _sender,
313     uint _quantity
314   );
315 
316   event LogRedemption(
317     address indexed _sender,
318     uint _quantity
319   );
320 }
321 
322 
323 
324 /**
325  * @title {Set}
326  * @author Felix Feng
327  * @dev Implementation of the basic {Set} token.
328  */
329 contract SetToken is StandardToken, DetailedERC20("EthereumX May 2018 Set", "ETHX-5-18", 18), SetInterface {
330   using SafeMath for uint256;
331   using AddressArrayUtils for address[];
332 
333   ///////////////////////////////////////////////////////////
334   /// Data Structures
335   ///////////////////////////////////////////////////////////
336   struct Component {
337     address address_;
338     uint unit_;
339   }
340 
341   ///////////////////////////////////////////////////////////
342   /// States
343   ///////////////////////////////////////////////////////////
344   uint public naturalUnit;
345   Component[] public components;
346 
347   // Mapping of componentHash to isComponent
348   mapping(bytes32 => bool) internal isComponent;
349   // Mapping of index of component -> user address -> balance
350   mapping(uint => mapping(address => uint)) internal unredeemedBalances;
351 
352 
353   ///////////////////////////////////////////////////////////
354   /// Events
355   ///////////////////////////////////////////////////////////
356   event LogPartialRedemption(
357     address indexed _sender,
358     uint _quantity,
359     bytes32 _excludedComponents
360   );
361 
362   event LogRedeemExcluded(
363     address indexed _sender,
364     bytes32 _components
365   );
366 
367   ///////////////////////////////////////////////////////////
368   /// Modifiers
369   ///////////////////////////////////////////////////////////
370   modifier hasSufficientBalance(uint quantity) {
371     // Check that the sender has sufficient components
372     // Since the component length is defined ahead of time, this is not
373     // an unbounded loop
374     require(balances[msg.sender] >= quantity, "User does not have sufficient balance");
375     _;
376   }
377 
378   modifier validDestination(address _to) {
379     require(_to != address(0));
380     require(_to != address(this));
381     _;
382   }
383 
384   modifier isMultipleOfNaturalUnit(uint _quantity) {
385     require((_quantity % naturalUnit) == 0);
386     _;
387   }
388 
389   modifier isNonZero(uint _quantity) {
390     require(_quantity > 0);
391     _;
392   }
393 
394   /**
395    * @dev Constructor Function for the issuance of an {Set} token
396    * @param _components address[] A list of component address which you want to include
397    * @param _units uint[] A list of quantities in gWei of each component (corresponds to the {Set} of _components)
398    */
399   constructor(address[] _components, uint[] _units, uint _naturalUnit)
400     isNonZero(_naturalUnit)
401     public {
402     // There must be component present
403     require(_components.length > 0, "Component length needs to be great than 0");
404 
405     // There must be an array of units
406     require(_units.length > 0, "Units must be greater than 0");
407 
408     // The number of components must equal the number of units
409     require(_components.length == _units.length, "Component and unit lengths must be the same");
410 
411     naturalUnit = _naturalUnit;
412 
413     // As looping operations are expensive, checking for duplicates will be
414     // on the onus of the application developer
415 
416     // NOTE: It will be the onus of developers to check whether the addressExists
417     // are in fact ERC20 addresses
418     for (uint16 i = 0; i < _units.length; i++) {
419       // Check that all units are non-zero. Negative numbers will underflow
420       uint currentUnits = _units[i];
421       require(currentUnits > 0, "Unit declarations must be non-zero");
422 
423       // Check that all addresses are non-zero
424       address currentComponent = _components[i];
425       require(currentComponent != address(0), "Components must have non-zero address");
426 
427       // Check the component has not already been added
428       require(!tokenIsComponent(currentComponent));
429 
430       // add component to isComponent mapping
431       isComponent[keccak256(currentComponent)] = true;
432 
433       components.push(Component({
434         address_: currentComponent,
435         unit_: currentUnits
436       }));
437     }
438   }
439 
440   ///////////////////////////////////////////////////////////
441   /// Set Functions
442   ///////////////////////////////////////////////////////////
443 
444   /**
445    * @dev Function to convert component into {Set} Tokens
446    *
447    * Please note that the user's ERC20 component must be approved by
448    * their ERC20 contract to transfer their components to this contract.
449    *
450    * @param _quantity uint The quantity of Sets desired to issue in Wei as a multiple of naturalUnit
451    */
452   function issue(uint _quantity)
453     isMultipleOfNaturalUnit(_quantity)
454     isNonZero(_quantity)
455     public returns (bool success) {
456     // Transfers the sender's components to the contract
457     // Since the component length is defined ahead of time, this is not
458     // an unbounded loop
459     for (uint16 i = 0; i < components.length; i++) {
460       address currentComponent = components[i].address_;
461       uint currentUnits = components[i].unit_;
462 
463       uint preTransferBalance = ERC20(currentComponent).balanceOf(this);
464 
465       uint transferValue = calculateTransferValue(currentUnits, _quantity);
466       require(ERC20(currentComponent).transferFrom(msg.sender, this, transferValue));
467 
468       // Check that preTransferBalance + transfer value is the same as postTransferBalance
469       uint postTransferBalance = ERC20(currentComponent).balanceOf(this);
470       assert(preTransferBalance.add(transferValue) == postTransferBalance);
471     }
472 
473     mint(_quantity);
474 
475     emit LogIssuance(msg.sender, _quantity);
476 
477     return true;
478   }
479 
480   /**
481    * @dev Function to convert {Set} Tokens into underlying components
482    *
483    * The ERC20 components do not need to be approved to call this function
484    *
485    * @param _quantity uint The quantity of Sets desired to redeem in Wei as a multiple of naturalUnit
486    */
487   function redeem(uint _quantity)
488     public
489     isMultipleOfNaturalUnit(_quantity)
490     hasSufficientBalance(_quantity)
491     isNonZero(_quantity)
492     returns (bool success)
493   {
494     burn(_quantity);
495 
496     for (uint16 i = 0; i < components.length; i++) {
497       address currentComponent = components[i].address_;
498       uint currentUnits = components[i].unit_;
499 
500       uint preTransferBalance = ERC20(currentComponent).balanceOf(this);
501 
502       uint transferValue = calculateTransferValue(currentUnits, _quantity);
503       require(ERC20(currentComponent).transfer(msg.sender, transferValue));
504 
505       // Check that preTransferBalance + transfer value is the same as postTransferBalance
506       uint postTransferBalance = ERC20(currentComponent).balanceOf(this);
507       assert(preTransferBalance.sub(transferValue) == postTransferBalance);
508     }
509 
510     emit LogRedemption(msg.sender, _quantity);
511 
512     return true;
513   }
514 
515   /**
516    * @dev Function to withdraw a portion of the component tokens of a Set
517    *
518    * This function should be used in the event that a component token has been
519    * paused for transfer temporarily or permanently. This allows users a
520    * method to withdraw tokens in the event that one token has been frozen.
521    *
522    * The mask can be computed by summing the powers of 2 of indexes of components to exclude.
523    * For example, to exclude the 0th, 1st, and 3rd components, we pass in the hex of
524    * 1 + 2 + 8 = 11, padded to length 32 i.e. 0x000000000000000000000000000000000000000000000000000000000000000b
525    *
526    * @param _quantity uint The quantity of Sets desired to redeem in Wei
527    * @param _componentsToExclude bytes32 Hex of bitmask of components to exclude
528    */
529   function partialRedeem(uint _quantity, bytes32 _componentsToExclude)
530     public
531     isMultipleOfNaturalUnit(_quantity)
532     isNonZero(_quantity)
533     hasSufficientBalance(_quantity)
534     returns (bool success)
535   {
536     // Excluded tokens should be less than the number of components
537     // Otherwise, use the normal redeem function
538     require(_componentsToExclude > 0, "Excluded components must be non-zero");
539 
540     burn(_quantity);
541 
542     for (uint16 i = 0; i < components.length; i++) {
543       uint transferValue = calculateTransferValue(components[i].unit_, _quantity);
544 
545       // Exclude tokens if 2 raised to the power of their indexes in the components
546       // array results in a non zero value following a bitwise AND
547       if (_componentsToExclude & bytes32(2 ** i) > 0) {
548         unredeemedBalances[i][msg.sender] += transferValue;
549       } else {
550         uint preTransferBalance = ERC20(components[i].address_).balanceOf(this);
551 
552         require(ERC20(components[i].address_).transfer(msg.sender, transferValue));
553 
554         // Check that preTransferBalance + transfer value is the same as postTransferBalance
555         uint postTransferBalance = ERC20(components[i].address_).balanceOf(this);
556         assert(preTransferBalance.sub(transferValue) == postTransferBalance);
557       }
558     }
559 
560     emit LogPartialRedemption(msg.sender, _quantity, _componentsToExclude);
561 
562     return true;
563   }
564 
565   /**
566    * @dev Function to withdraw tokens that have previously been excluded when calling
567    * the partialRedeem method
568 
569    * The mask can be computed by summing the powers of 2 of indexes of components to redeem.
570    * For example, to redeem the 0th, 1st, and 3rd components, we pass in the hex of
571    * 1 + 2 + 8 = 11, padded to length 32 i.e. 0x000000000000000000000000000000000000000000000000000000000000000b
572    *
573    * @param _componentsToRedeem bytes32 Hex of bitmask of components to redeem
574    */
575   function redeemExcluded(bytes32 _componentsToRedeem)
576     public
577     returns (bool success)
578   {
579     require(_componentsToRedeem > 0, "Components to redeem must be non-zero");
580 
581     for (uint16 i = 0; i < components.length; i++) {
582       if (_componentsToRedeem & bytes32(2 ** i) > 0) {
583         address currentComponent = components[i].address_;
584         uint remainingBalance = unredeemedBalances[i][msg.sender];
585 
586         // To prevent re-entrancy attacks, decrement the user's Set balance
587         unredeemedBalances[i][msg.sender] = 0;
588 
589         require(ERC20(currentComponent).transfer(msg.sender, remainingBalance));
590       }
591     }
592 
593     emit LogRedeemExcluded(msg.sender, _componentsToRedeem);
594 
595     return true;
596   }
597 
598   ///////////////////////////////////////////////////////////
599   /// Getters
600   ///////////////////////////////////////////////////////////
601   function getComponents() public view returns(address[]) {
602     address[] memory componentAddresses = new address[](components.length);
603     for (uint16 i = 0; i < components.length; i++) {
604         componentAddresses[i] = components[i].address_;
605     }
606     return componentAddresses;
607   }
608 
609   function getUnits() public view returns(uint[]) {
610     uint[] memory units = new uint[](components.length);
611     for (uint16 i = 0; i < components.length; i++) {
612         units[i] = components[i].unit_;
613     }
614     return units;
615   }
616 
617   function getUnredeemedBalance(address _componentAddress, address _userAddress) public view returns (uint256) {
618     require(tokenIsComponent(_componentAddress));
619 
620     uint componentIndex;
621 
622     for (uint i = 0; i < components.length; i++) {
623       if (components[i].address_ == _componentAddress) {
624         componentIndex = i;
625       }
626     }
627 
628     return unredeemedBalances[componentIndex][_userAddress];
629   }
630 
631   ///////////////////////////////////////////////////////////
632   /// Transfer Updates
633   ///////////////////////////////////////////////////////////
634   function transfer(address _to, uint256 _value) validDestination(_to) public returns (bool) {
635     return super.transfer(_to, _value);
636   }
637 
638   function transferFrom(address _from, address _to, uint256 _value) validDestination(_to) public returns (bool) {
639     return super.transferFrom(_from, _to, _value);
640   }
641 
642   ///////////////////////////////////////////////////////////
643   /// Private Function
644   ///////////////////////////////////////////////////////////
645 
646   function tokenIsComponent(address _tokenAddress) view internal returns (bool) {
647     return isComponent[keccak256(_tokenAddress)];
648   }
649 
650   function calculateTransferValue(uint componentUnits, uint quantity) view internal returns(uint) {
651     return quantity.div(naturalUnit).mul(componentUnits);
652   }
653 
654   function mint(uint quantity) internal {
655     balances[msg.sender] = balances[msg.sender].add(quantity);
656     totalSupply_ = totalSupply_.add(quantity);
657     emit Transfer(address(0), msg.sender, quantity);
658   }
659 
660   function burn(uint quantity) internal {
661     balances[msg.sender] = balances[msg.sender].sub(quantity);
662     totalSupply_ = totalSupply_.sub(quantity);
663     emit Transfer(msg.sender, address(0), quantity);
664   }
665 }