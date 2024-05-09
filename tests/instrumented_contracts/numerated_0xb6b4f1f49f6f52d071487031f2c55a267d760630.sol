1 pragma solidity ^0.4.25;
2 
3 /// @title Role based access control mixin for Resale Platform
4 /// @author Mai Abha <maiabha82@gmail.com>
5 /// @dev Ignore DRY approach to achieve readability
6 contract RBACMixin {
7   /// @notice Constant string message to throw on lack of access
8   string constant FORBIDDEN = "Doesn't have enough rights to access";
9   /// @notice Public map of owners
10   mapping (address => bool) public owners;
11   /// @notice Public map of minters
12   mapping (address => bool) public minters;
13 
14   /// @notice The event indicates the addition of a new owner
15   /// @param who is address of added owner
16   event AddOwner(address indexed who);
17   /// @notice The event indicates the deletion of an owner
18   /// @param who is address of deleted owner
19   event DeleteOwner(address indexed who);
20 
21   /// @notice The event indicates the addition of a new minter
22   /// @param who is address of added minter
23   event AddMinter(address indexed who);
24   /// @notice The event indicates the deletion of a minter
25   /// @param who is address of deleted minter
26   event DeleteMinter(address indexed who);
27 
28   constructor () public {
29     _setOwner(msg.sender, true);
30   }
31 
32   /// @notice The functional modifier rejects the interaction of senders who are not owners
33   modifier onlyOwner() {
34     require(isOwner(msg.sender), FORBIDDEN);
35     _;
36   }
37 
38   /// @notice Functional modifier for rejecting the interaction of senders that are not minters
39   modifier onlyMinter() {
40     require(isMinter(msg.sender), FORBIDDEN);
41     _;
42   }
43 
44   /// @notice Look up for the owner role on providen address
45   /// @param _who is address to look up
46   /// @return A boolean of owner role
47   function isOwner(address _who) public view returns (bool) {
48     return owners[_who];
49   }
50 
51   /// @notice Look up for the minter role on providen address
52   /// @param _who is address to look up
53   /// @return A boolean of minter role
54   function isMinter(address _who) public view returns (bool) {
55     return minters[_who];
56   }
57 
58   /// @notice Adds the owner role to provided address
59   /// @dev Requires owner role to interact
60   /// @param _who is address to add role
61   /// @return A boolean that indicates if the operation was successful.
62   function addOwner(address _who) public onlyOwner returns (bool) {
63     _setOwner(_who, true);
64   }
65 
66   /// @notice Deletes the owner role to provided address
67   /// @dev Requires owner role to interact
68   /// @param _who is address to delete role
69   /// @return A boolean that indicates if the operation was successful.
70   function deleteOwner(address _who) public onlyOwner returns (bool) {
71     _setOwner(_who, false);
72   }
73 
74   /// @notice Adds the minter role to provided address
75   /// @dev Requires owner role to interact
76   /// @param _who is address to add role
77   /// @return A boolean that indicates if the operation was successful.
78   function addMinter(address _who) public onlyOwner returns (bool) {
79     _setMinter(_who, true);
80   }
81 
82   /// @notice Deletes the minter role to provided address
83   /// @dev Requires owner role to interact
84   /// @param _who is address to delete role
85   /// @return A boolean that indicates if the operation was successful.
86   function deleteMinter(address _who) public onlyOwner returns (bool) {
87     _setMinter(_who, false);
88   }
89 
90   /// @notice Changes the owner role to provided address
91   /// @param _who is address to change role
92   /// @param _flag is next role status after success
93   /// @return A boolean that indicates if the operation was successful.
94   function _setOwner(address _who, bool _flag) private returns (bool) {
95     require(owners[_who] != _flag);
96     owners[_who] = _flag;
97     if (_flag) {
98       emit AddOwner(_who);
99     } else {
100       emit DeleteOwner(_who);
101     }
102     return true;
103   }
104 
105   /// @notice Changes the minter role to provided address
106   /// @param _who is address to change role
107   /// @param _flag is next role status after success
108   /// @return A boolean that indicates if the operation was successful.
109   function _setMinter(address _who, bool _flag) private returns (bool) {
110     require(minters[_who] != _flag);
111     minters[_who] = _flag;
112     if (_flag) {
113       emit AddMinter(_who);
114     } else {
115       emit DeleteMinter(_who);
116     }
117     return true;
118   }
119 }
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address who) public view returns (uint256);
129   function transfer(address to, uint256 value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 /**
134  * @title SafeMath
135  * @dev Math operations with safety checks that throw on error
136  */
137 library SafeMath {
138 
139   /**
140   * @dev Multiplies two numbers, throws on overflow.
141   */
142   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
143     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
144     // benefit is lost if 'b' is also tested.
145     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
146     if (a == 0) {
147       return 0;
148     }
149 
150     c = a * b;
151     assert(c / a == b);
152     return c;
153   }
154 
155   /**
156   * @dev Integer division of two numbers, truncating the quotient.
157   */
158   function div(uint256 a, uint256 b) internal pure returns (uint256) {
159     // assert(b > 0); // Solidity automatically throws when dividing by 0
160     // uint256 c = a / b;
161     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162     return a / b;
163   }
164 
165   /**
166   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
167   */
168   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169     assert(b <= a);
170     return a - b;
171   }
172 
173   /**
174   * @dev Adds two numbers, throws on overflow.
175   */
176   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
177     c = a + b;
178     assert(c >= a);
179     return c;
180   }
181 }
182 
183 /**
184  * @title Basic token
185  * @dev Basic version of StandardToken, with no allowances.
186  */
187 contract BasicToken is ERC20Basic {
188   using SafeMath for uint256;
189 
190   mapping(address => uint256) balances;
191 
192   uint256 totalSupply_;
193 
194   /**
195   * @dev total number of tokens in existence
196   */
197   function totalSupply() public view returns (uint256) {
198     return totalSupply_;
199   }
200 
201   /**
202   * @dev transfer token for a specified address
203   * @param _to The address to transfer to.
204   * @param _value The amount to be transferred.
205   */
206   function transfer(address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208     require(_value <= balances[msg.sender]);
209 
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     emit Transfer(msg.sender, _to, _value);
213     return true;
214   }
215 
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param _owner The address to query the the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address _owner) public view returns (uint256) {
222     return balances[_owner];
223   }
224 
225 }
226 
227 /**
228  * @title ERC20 interface
229  * @dev see https://github.com/ethereum/EIPs/issues/20
230  */
231 contract ERC20 is ERC20Basic {
232   function allowance(address owner, address spender)
233     public view returns (uint256);
234 
235   function transferFrom(address from, address to, uint256 value)
236     public returns (bool);
237 
238   function approve(address spender, uint256 value) public returns (bool);
239   event Approval(
240     address indexed owner,
241     address indexed spender,
242     uint256 value
243   );
244 }
245 
246 /**
247  * @title Standard ERC20 token
248  *
249  * @dev Implementation of the basic standard token.
250  * @dev https://github.com/ethereum/EIPs/issues/20
251  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
252  */
253 contract StandardToken is ERC20, BasicToken {
254 
255   mapping (address => mapping (address => uint256)) internal allowed;
256 
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param _from address The address which you want to send tokens from
261    * @param _to address The address which you want to transfer to
262    * @param _value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address _from,
266     address _to,
267     uint256 _value
268   )
269     public
270     returns (bool)
271   {
272     require(_to != address(0));
273     require(_value <= balances[_from]);
274     require(_value <= allowed[_from][msg.sender]);
275 
276     balances[_from] = balances[_from].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279     emit Transfer(_from, _to, _value);
280     return true;
281   }
282 
283   /**
284    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
285    *
286    * Beware that changing an allowance with this method brings the risk that someone may use both the old
287    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
288    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
289    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290    * @param _spender The address which will spend the funds.
291    * @param _value The amount of tokens to be spent.
292    */
293   function approve(address _spender, uint256 _value) public returns (bool) {
294     allowed[msg.sender][_spender] = _value;
295     emit Approval(msg.sender, _spender, _value);
296     return true;
297   }
298 
299   /**
300    * @dev Function to check the amount of tokens that an owner allowed to a spender.
301    * @param _owner address The address which owns the funds.
302    * @param _spender address The address which will spend the funds.
303    * @return A uint256 specifying the amount of tokens still available for the spender.
304    */
305   function allowance(
306     address _owner,
307     address _spender
308    )
309     public
310     view
311     returns (uint256)
312   {
313     return allowed[_owner][_spender];
314   }
315 
316   /**
317    * @dev Increase the amount of tokens that an owner allowed to a spender.
318    *
319    * approve should be called when allowed[_spender] == 0. To increment
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _addedValue The amount of tokens to increase the allowance by.
325    */
326   function increaseApproval(
327     address _spender,
328     uint _addedValue
329   )
330     public
331     returns (bool)
332   {
333     allowed[msg.sender][_spender] = (
334       allowed[msg.sender][_spender].add(_addedValue));
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339   /**
340    * @dev Decrease the amount of tokens that an owner allowed to a spender.
341    *
342    * approve should be called when allowed[_spender] == 0. To decrement
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _subtractedValue The amount of tokens to decrease the allowance by.
348    */
349   function decreaseApproval(
350     address _spender,
351     uint _subtractedValue
352   )
353     public
354     returns (bool)
355   {
356     uint oldValue = allowed[msg.sender][_spender];
357     if (_subtractedValue > oldValue) {
358       allowed[msg.sender][_spender] = 0;
359     } else {
360       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
361     }
362     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363     return true;
364   }
365 
366 }
367 
368 contract RBACMintableTokenMixin is StandardToken, RBACMixin {
369   event Mint(address indexed to, uint256 amount);
370   event MintFinished();
371 
372   bool public mintingFinished = false;
373 
374   modifier canMint() {
375     require(!mintingFinished);
376     _;
377   }
378 
379   /**
380    * @dev Function to mint tokens
381    * @param _to The address that will receive the minted tokens.
382    * @param _amount The amount of tokens to mint.
383    * @return A boolean that indicates if the operation was successful.
384    */
385   function mint(
386     address _to,
387     uint256 _amount
388   )
389     onlyMinter
390     canMint
391     public
392     returns (bool)
393   {
394     totalSupply_ = totalSupply_.add(_amount);
395     balances[_to] = balances[_to].add(_amount);
396     emit Mint(_to, _amount);
397     emit Transfer(address(0), _to, _amount);
398     return true;
399   }
400 
401   /**
402    * @dev Function to stop minting new tokens.
403    * @return True if the operation was successful.
404    */
405   function finishMinting() onlyOwner canMint internal returns (bool) {
406     mintingFinished = true;
407     emit MintFinished();
408     return true;
409   }
410 }
411 
412 contract ERC223ReceiverMixin {
413   function tokenFallback(address _from, uint256 _value, bytes _data) public;
414 }
415 
416 /// @title Custom implementation of ERC223 
417 /// @author Mai Abha <maiabha82@gmail.com>
418 contract ERC223Mixin is StandardToken {
419   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
420 
421   function transferFrom(
422     address _from,
423     address _to,
424     uint256 _value
425   ) public returns (bool) 
426   {
427     bytes memory empty;
428     return transferFrom(
429       _from, 
430       _to,
431       _value,
432       empty);
433   }
434 
435   function transferFrom(
436     address _from,
437     address _to,
438     uint256 _value,
439     bytes _data
440   ) public returns (bool)
441   {
442     require(_value <= allowed[_from][msg.sender]);
443     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
444     if (isContract(_to)) {
445       return transferToContract(
446         _from, 
447         _to, 
448         _value, 
449         _data);
450     } else {
451       return transferToAddress(
452         _from, 
453         _to, 
454         _value, 
455         _data); 
456     }
457   }
458 
459   function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
460     if (isContract(_to)) {
461       return transferToContract(
462         msg.sender,
463         _to,
464         _value,
465         _data); 
466     } else {
467       return transferToAddress(
468         msg.sender,
469         _to,
470         _value,
471         _data);
472     }
473   }
474 
475   function transfer(address _to, uint256 _value) public returns (bool success) {
476     bytes memory empty;
477     return transfer(_to, _value, empty);
478   }
479 
480   function isContract(address _addr) internal view returns (bool) {
481     uint256 length;
482     // solium-disable-next-line security/no-inline-assembly
483     assembly {
484       //retrieve the size of the code on target address, this needs assembly
485       length := extcodesize(_addr)
486     }  
487     return (length>0);
488   }
489 
490   function moveTokens(address _from, address _to, uint256 _value) internal returns (bool success) {
491     if (balanceOf(_from) < _value) {
492       revert();
493     }
494     balances[_from] = balanceOf(_from).sub(_value);
495     balances[_to] = balanceOf(_to).add(_value);
496 
497     return true;
498   }
499 
500   function transferToAddress(
501     address _from,
502     address _to,
503     uint256 _value,
504     bytes _data
505   ) internal returns (bool success) 
506   {
507     require(moveTokens(_from, _to, _value));
508     emit Transfer(_from, _to, _value);
509     emit Transfer(_from, _to, _value, _data); // solium-disable-line arg-overflow
510     return true;
511   }
512   
513   //function that is called when transaction target is a contract
514   function transferToContract(
515     address _from,
516     address _to,
517     uint256 _value,
518     bytes _data
519   ) internal returns (bool success) 
520   {
521     require(moveTokens(_from, _to, _value));
522     ERC223ReceiverMixin(_to).tokenFallback(_from, _value, _data);
523     emit Transfer(_from, _to, _value);
524     emit Transfer(_from, _to, _value, _data); // solium-disable-line arg-overflow
525     return true;
526   }
527 }
528 
529 /// @title Role based token finalization mixin
530 /// @author Mai Abha <maiabha82@gmail.com>
531 contract RBACERC223TokenFinalization is ERC223Mixin, RBACMixin {
532   event Finalize();
533   /// @notice Public field inicates the finalization state of smart-contract
534   bool public finalized;
535 
536   /// @notice The functional modifier rejects the interaction if contract isn't finalized
537   modifier isFinalized() {
538     require(finalized);
539     _;
540   }
541 
542   /// @notice The functional modifier rejects the interaction if contract is finalized
543   modifier notFinalized() {
544     require(!finalized);
545     _;
546   }
547 
548   /// @notice Finalizes contract
549   /// @dev Requires owner role to interact
550   /// @return A boolean that indicates if the operation was successful.
551   function finalize() public notFinalized onlyOwner returns (bool) {
552     finalized = true;
553     emit Finalize();
554     return true;
555   }
556 
557   /// @dev Overrides ERC20 interface to prevent interaction before finalization
558   function transferFrom(address _from, address _to, uint256 _value) public isFinalized returns (bool) {
559     return super.transferFrom(_from, _to, _value);
560   }
561 
562   /// @dev Overrides ERC223 interface to prevent interaction before finalization
563   // solium-disable-next-line arg-overflow
564   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public isFinalized returns (bool) {
565     return super.transferFrom(_from, _to, _value, _data); // solium-disable-line arg-overflow
566   }
567 
568   /// @dev Overrides ERC223 interface to prevent interaction before finalization
569   function transfer(address _to, uint256 _value, bytes _data) public isFinalized returns (bool) {
570     return super.transfer(_to, _value, _data);
571   }
572 
573   /// @dev Overrides ERC20 interface to prevent interaction before finalization
574   function transfer(address _to, uint256 _value) public isFinalized returns (bool) {
575     return super.transfer(_to, _value);
576   }
577 
578   /// @dev Overrides ERC20 interface to prevent interaction before finalization
579   function approve(address _spender, uint256 _value) public isFinalized returns (bool) {
580     return super.approve(_spender, _value);
581   }
582 
583   /// @dev Overrides ERC20 interface to prevent interaction before finalization
584   function increaseApproval(address _spender, uint256 _addedValue) public isFinalized returns (bool) {
585     return super.increaseApproval(_spender, _addedValue);
586   }
587 
588   /// @dev Overrides ERC20 interface to prevent interaction before finalization
589   function decreaseApproval(address _spender, uint256 _subtractedValue) public isFinalized returns (bool) {
590     return super.decreaseApproval(_spender, _subtractedValue);
591   }
592 }
593 
594 /**
595  * @title Burnable Token
596  * @dev Token that can be irreversibly burned (destroyed).
597  */
598 contract BurnableToken is BasicToken {
599 
600   event Burn(address indexed burner, uint256 value);
601 
602   /**
603    * @dev Burns a specific amount of tokens.
604    * @param _value The amount of token to be burned.
605    */
606   function burn(uint256 _value) public {
607     _burn(msg.sender, _value);
608   }
609 
610   function _burn(address _who, uint256 _value) internal {
611     require(_value <= balances[_who]);
612     // no need to require value <= totalSupply, since that would imply the
613     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
614 
615     balances[_who] = balances[_who].sub(_value);
616     totalSupply_ = totalSupply_.sub(_value);
617     emit Burn(_who, _value);
618     emit Transfer(_who, address(0), _value);
619   }
620 }
621 
622 /**
623  * @title Standard Burnable Token
624  * @dev Adds burnFrom method to ERC20 implementations
625  */
626 contract StandardBurnableToken is BurnableToken, StandardToken {
627 
628   /**
629    * @dev Burns a specific amount of tokens from the target address and decrements allowance
630    * @param _from address The address which you want to send tokens from
631    * @param _value uint256 The amount of token to be burned
632    */
633   function burnFrom(address _from, uint256 _value) public {
634     require(_value <= allowed[_from][msg.sender]);
635     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
636     // this function needs to emit an event with the updated approval.
637     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
638     _burn(_from, _value);
639   }
640 }
641 
642 /// @title Resale token implementation
643 /// @author Mai Abha <maiabha82@gmail.com>
644 /// @dev Implements ERC20, ERC223 and MintableToken interfaces as well as capped and finalization logic
645 contract ResaleToken is StandardBurnableToken, RBACERC223TokenFinalization, RBACMintableTokenMixin {
646   /// @notice Constant field with token symbol
647   string constant public symbol = "RSL"; // solium-disable-line uppercase
648   /// @notice Constant field with token full name
649   // solium-disable-next-line uppercase
650   string constant public name = "Resale-TH.com"; 
651   /// @notice Constant field with token precision depth
652   uint256 constant public decimals = 18; // solium-disable-line uppercase
653   /// @notice Constant field with token cap (total supply limit)
654   uint256 constant public cap = 100 * (10 ** 6) * (10 ** decimals); // solium-disable-line uppercase
655 
656   /// @notice Overrides original mint function from MintableToken to limit minting over cap
657   /// @param _to The address that will receive the minted tokens.
658   /// @param _amount The amount of tokens to mint.
659   /// @return A boolean that indicates if the operation was successful.
660   function mint(
661     address _to,
662     uint256 _amount
663   )
664     public
665     returns (bool) 
666   {
667     require(totalSupply().add(_amount) <= cap);
668     return super.mint(_to, _amount);
669   }
670 
671   /// @notice Overrides finalize function from RBACERC223TokenFinalization to prevent future minting after finalization
672   /// @return A boolean that indicates if the operation was successful.
673   function finalize() public returns (bool) {
674     require(super.finalize());
675     require(finishMinting());
676     return true;
677   }
678 
679   /// @notice Overrides finishMinting function from RBACMintableTokenMixin to prevent finishing minting before finalization
680   /// @return A boolean that indicates if the operation was successful.
681   function finishMinting() internal returns (bool) {
682     require(finalized == true);
683     require(super.finishMinting());
684     return true;
685   }
686 }