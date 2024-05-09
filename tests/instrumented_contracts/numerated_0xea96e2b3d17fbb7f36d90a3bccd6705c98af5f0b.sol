1 pragma solidity ^0.4.24;
2 
3 // File: contracts/mixins/ERC223ReceiverMixin.sol
4 
5 contract ERC223ReceiverMixin {
6   function tokenFallback(address _from, uint256 _value, bytes _data) public;
7 }
8 
9 // File: zeppelin-solidity/contracts/math/SafeMath.sol
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, throws on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   function totalSupply() public view returns (uint256);
70   function balanceOf(address who) public view returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     emit Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender)
129     public view returns (uint256);
130 
131   function transferFrom(address from, address to, uint256 value)
132     public returns (bool);
133 
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(
136     address indexed owner,
137     address indexed spender,
138     uint256 value
139   );
140 }
141 
142 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(
163     address _from,
164     address _to,
165     uint256 _value
166   )
167     public
168     returns (bool)
169   {
170     require(_to != address(0));
171     require(_value <= balances[_from]);
172     require(_value <= allowed[_from][msg.sender]);
173 
174     balances[_from] = balances[_from].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177     emit Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    *
184    * Beware that changing an allowance with this method brings the risk that someone may use both the old
185    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
186    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
187    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188    * @param _spender The address which will spend the funds.
189    * @param _value The amount of tokens to be spent.
190    */
191   function approve(address _spender, uint256 _value) public returns (bool) {
192     allowed[msg.sender][_spender] = _value;
193     emit Approval(msg.sender, _spender, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifying the amount of tokens still available for the spender.
202    */
203   function allowance(
204     address _owner,
205     address _spender
206    )
207     public
208     view
209     returns (uint256)
210   {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(
225     address _spender,
226     uint _addedValue
227   )
228     public
229     returns (bool)
230   {
231     allowed[msg.sender][_spender] = (
232       allowed[msg.sender][_spender].add(_addedValue));
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To decrement
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _subtractedValue The amount of tokens to decrease the allowance by.
246    */
247   function decreaseApproval(
248     address _spender,
249     uint _subtractedValue
250   )
251     public
252     returns (bool)
253   {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264 }
265 
266 // File: contracts/mixins/ERC223Mixin.sol
267 
268 /// @title Custom implementation of ERC223 
269 /// @author Aler Denisov <aler.zampillo@gmail.com>
270 contract ERC223Mixin is StandardToken {
271   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
272 
273   function transferFrom(
274     address _from,
275     address _to,
276     uint256 _value
277   ) public returns (bool) 
278   {
279     bytes memory empty;
280     return transferFrom(
281       _from, 
282       _to,
283       _value,
284       empty);
285   }
286 
287   function transferFrom(
288     address _from,
289     address _to,
290     uint256 _value,
291     bytes _data
292   ) public returns (bool)
293   {
294     require(_value <= allowed[_from][msg.sender]);
295     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
296     if (isContract(_to)) {
297       return transferToContract(
298         _from, 
299         _to, 
300         _value, 
301         _data);
302     } else {
303       return transferToAddress(
304         _from, 
305         _to, 
306         _value, 
307         _data); 
308     }
309   }
310 
311   function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
312     if (isContract(_to)) {
313       return transferToContract(
314         msg.sender,
315         _to,
316         _value,
317         _data); 
318     } else {
319       return transferToAddress(
320         msg.sender,
321         _to,
322         _value,
323         _data);
324     }
325   }
326 
327   function transfer(address _to, uint256 _value) public returns (bool success) {
328     bytes memory empty;
329     return transfer(_to, _value, empty);
330   }
331 
332   function isContract(address _addr) internal view returns (bool) {
333     uint256 length;
334     // solium-disable-next-line security/no-inline-assembly
335     assembly {
336       //retrieve the size of the code on target address, this needs assembly
337       length := extcodesize(_addr)
338     }  
339     return (length>0);
340   }
341 
342   function moveTokens(address _from, address _to, uint256 _value) internal returns (bool success) {
343     if (balanceOf(_from) < _value) {
344       revert();
345     }
346     balances[_from] = balanceOf(_from).sub(_value);
347     balances[_to] = balanceOf(_to).add(_value);
348 
349     return true;
350   }
351 
352   function transferToAddress(
353     address _from,
354     address _to,
355     uint256 _value,
356     bytes _data
357   ) internal returns (bool success) 
358   {
359     require(moveTokens(_from, _to, _value));
360     emit Transfer(_from, _to, _value);
361     emit Transfer(_from, _to, _value, _data); // solium-disable-line arg-overflow
362     return true;
363   }
364   
365   //function that is called when transaction target is a contract
366   function transferToContract(
367     address _from,
368     address _to,
369     uint256 _value,
370     bytes _data
371   ) internal returns (bool success) 
372   {
373     require(moveTokens(_from, _to, _value));
374     ERC223ReceiverMixin(_to).tokenFallback(_from, _value, _data);
375     emit Transfer(_from, _to, _value);
376     emit Transfer(_from, _to, _value, _data); // solium-disable-line arg-overflow
377     return true;
378   }
379 }
380 
381 // File: contracts/mixins/RBACMixin.sol
382 
383 /// @title Role based access control mixin for MUST Platform
384 /// @author Aler Denisov <aler.zampillo@gmail.com>
385 /// @dev Ignore DRY approach to achieve readability
386 contract RBACMixin {
387   /// @notice Constant string message to throw on lack of access
388   string constant FORBIDDEN = "Haven't enough right to access";
389   /// @notice Public map of owners
390   mapping (address => bool) public owners;
391   /// @notice Public map of minters
392   mapping (address => bool) public minters;
393 
394   /// @notice The event indicates the addition of a new owner
395   /// @param who is address of added owner
396   event AddOwner(address indexed who);
397   /// @notice The event indicates the deletion of an owner
398   /// @param who is address of deleted owner
399   event DeleteOwner(address indexed who);
400 
401   /// @notice The event indicates the addition of a new minter
402   /// @param who is address of added minter
403   event AddMinter(address indexed who);
404   /// @notice The event indicates the deletion of a minter
405   /// @param who is address of deleted minter
406   event DeleteMinter(address indexed who);
407 
408   constructor () public {
409     _setOwner(msg.sender, true);
410   }
411 
412   /// @notice The functional modifier rejects the interaction of senders who are not owners
413   modifier onlyOwner() {
414     require(isOwner(msg.sender), FORBIDDEN);
415     _;
416   }
417 
418   /// @notice Functional modifier for rejecting the interaction of senders that are not minters
419   modifier onlyMinter() {
420     require(isMinter(msg.sender), FORBIDDEN);
421     _;
422   }
423 
424   /// @notice Look up for the owner role on providen address
425   /// @param _who is address to look up
426   /// @return A boolean of owner role
427   function isOwner(address _who) public view returns (bool) {
428     return owners[_who];
429   }
430 
431   /// @notice Look up for the minter role on providen address
432   /// @param _who is address to look up
433   /// @return A boolean of minter role
434   function isMinter(address _who) public view returns (bool) {
435     return minters[_who];
436   }
437 
438   /// @notice Adds the owner role to provided address
439   /// @dev Requires owner role to interact
440   /// @param _who is address to add role
441   /// @return A boolean that indicates if the operation was successful.
442   function addOwner(address _who) public onlyOwner returns (bool) {
443     _setOwner(_who, true);
444   }
445 
446   /// @notice Deletes the owner role to provided address
447   /// @dev Requires owner role to interact
448   /// @param _who is address to delete role
449   /// @return A boolean that indicates if the operation was successful.
450   function deleteOwner(address _who) public onlyOwner returns (bool) {
451     _setOwner(_who, false);
452   }
453 
454   /// @notice Adds the minter role to provided address
455   /// @dev Requires owner role to interact
456   /// @param _who is address to add role
457   /// @return A boolean that indicates if the operation was successful.
458   function addMinter(address _who) public onlyOwner returns (bool) {
459     _setMinter(_who, true);
460   }
461 
462   /// @notice Deletes the minter role to provided address
463   /// @dev Requires owner role to interact
464   /// @param _who is address to delete role
465   /// @return A boolean that indicates if the operation was successful.
466   function deleteMinter(address _who) public onlyOwner returns (bool) {
467     _setMinter(_who, false);
468   }
469 
470   /// @notice Changes the owner role to provided address
471   /// @param _who is address to change role
472   /// @param _flag is next role status after success
473   /// @return A boolean that indicates if the operation was successful.
474   function _setOwner(address _who, bool _flag) private returns (bool) {
475     require(owners[_who] != _flag);
476     owners[_who] = _flag;
477     if (_flag) {
478       emit AddOwner(_who);
479     } else {
480       emit DeleteOwner(_who);
481     }
482     return true;
483   }
484 
485   /// @notice Changes the minter role to provided address
486   /// @param _who is address to change role
487   /// @param _flag is next role status after success
488   /// @return A boolean that indicates if the operation was successful.
489   function _setMinter(address _who, bool _flag) private returns (bool) {
490     require(minters[_who] != _flag);
491     minters[_who] = _flag;
492     if (_flag) {
493       emit AddMinter(_who);
494     } else {
495       emit DeleteMinter(_who);
496     }
497     return true;
498   }
499 }
500 
501 // File: contracts/mixins/RBACERC223TokenFinalization.sol
502 
503 /// @title Role based token finalization mixin
504 /// @author Aler Denisov <aler.zampillo@gmail.com>
505 contract RBACERC223TokenFinalization is ERC223Mixin, RBACMixin {
506   event Finalize();
507   /// @notice Public field inicates the finalization state of smart-contract
508   bool public finalized;
509 
510   /// @notice The functional modifier rejects the interaction if contract isn't finalized
511   modifier isFinalized() {
512     require(finalized);
513     _;
514   }
515 
516   /// @notice The functional modifier rejects the interaction if contract is finalized
517   modifier notFinalized() {
518     require(!finalized);
519     _;
520   }
521 
522   /// @notice Finalizes contract
523   /// @dev Requires owner role to interact
524   /// @return A boolean that indicates if the operation was successful.
525   function finalize() public notFinalized onlyOwner returns (bool) {
526     finalized = true;
527     emit Finalize();
528     return true;
529   }
530 
531   /// @dev Overrides ERC20 interface to prevent interaction before finalization
532   function transferFrom(address _from, address _to, uint256 _value) public isFinalized returns (bool) {
533     return super.transferFrom(_from, _to, _value);
534   }
535 
536   /// @dev Overrides ERC223 interface to prevent interaction before finalization
537   // solium-disable-next-line arg-overflow
538   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public isFinalized returns (bool) {
539     return super.transferFrom(_from, _to, _value, _data); // solium-disable-line arg-overflow
540   }
541 
542   /// @dev Overrides ERC223 interface to prevent interaction before finalization
543   function transfer(address _to, uint256 _value, bytes _data) public isFinalized returns (bool) {
544     return super.transfer(_to, _value, _data);
545   }
546 
547   /// @dev Overrides ERC20 interface to prevent interaction before finalization
548   function transfer(address _to, uint256 _value) public isFinalized returns (bool) {
549     return super.transfer(_to, _value);
550   }
551 
552   /// @dev Overrides ERC20 interface to prevent interaction before finalization
553   function approve(address _spender, uint256 _value) public isFinalized returns (bool) {
554     return super.approve(_spender, _value);
555   }
556 
557   /// @dev Overrides ERC20 interface to prevent interaction before finalization
558   function increaseApproval(address _spender, uint256 _addedValue) public isFinalized returns (bool) {
559     return super.increaseApproval(_spender, _addedValue);
560   }
561 
562   /// @dev Overrides ERC20 interface to prevent interaction before finalization
563   function decreaseApproval(address _spender, uint256 _subtractedValue) public isFinalized returns (bool) {
564     return super.decreaseApproval(_spender, _subtractedValue);
565   }
566 }
567 
568 // File: contracts/mixins/RBACMintableTokenMixin.sol
569 
570 contract RBACMintableTokenMixin is StandardToken, RBACMixin {
571   event Mint(address indexed to, uint256 amount);
572   event MintFinished();
573 
574   bool public mintingFinished = false;
575 
576   modifier canMint() {
577     require(!mintingFinished);
578     _;
579   }
580 
581   /**
582    * @dev Function to mint tokens
583    * @param _to The address that will receive the minted tokens.
584    * @param _amount The amount of tokens to mint.
585    * @return A boolean that indicates if the operation was successful.
586    */
587   function mint(
588     address _to,
589     uint256 _amount
590   )
591     onlyMinter
592     canMint
593     public
594     returns (bool)
595   {
596     totalSupply_ = totalSupply_.add(_amount);
597     balances[_to] = balances[_to].add(_amount);
598     emit Mint(_to, _amount);
599     emit Transfer(address(0), _to, _amount);
600     return true;
601   }
602 
603   /**
604    * @dev Function to stop minting new tokens.
605    * @return True if the operation was successful.
606    */
607   function finishMinting() onlyOwner canMint internal returns (bool) {
608     mintingFinished = true;
609     emit MintFinished();
610     return true;
611   }
612 }
613 
614 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
615 
616 /**
617  * @title Burnable Token
618  * @dev Token that can be irreversibly burned (destroyed).
619  */
620 contract BurnableToken is BasicToken {
621 
622   event Burn(address indexed burner, uint256 value);
623 
624   /**
625    * @dev Burns a specific amount of tokens.
626    * @param _value The amount of token to be burned.
627    */
628   function burn(uint256 _value) public {
629     _burn(msg.sender, _value);
630   }
631 
632   function _burn(address _who, uint256 _value) internal {
633     require(_value <= balances[_who]);
634     // no need to require value <= totalSupply, since that would imply the
635     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
636 
637     balances[_who] = balances[_who].sub(_value);
638     totalSupply_ = totalSupply_.sub(_value);
639     emit Burn(_who, _value);
640     emit Transfer(_who, address(0), _value);
641   }
642 }
643 
644 // File: zeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
645 
646 /**
647  * @title Standard Burnable Token
648  * @dev Adds burnFrom method to ERC20 implementations
649  */
650 contract StandardBurnableToken is BurnableToken, StandardToken {
651 
652   /**
653    * @dev Burns a specific amount of tokens from the target address and decrements allowance
654    * @param _from address The address which you want to send tokens from
655    * @param _value uint256 The amount of token to be burned
656    */
657   function burnFrom(address _from, uint256 _value) public {
658     require(_value <= allowed[_from][msg.sender]);
659     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
660     // this function needs to emit an event with the updated approval.
661     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
662     _burn(_from, _value);
663   }
664 }
665 
666 // File: contracts/MustToken.sol
667 
668 /// @title MUST Platform token implementation
669 /// @author Aler Denisov <aler.zampillo@gmail.com>
670 /// @dev Implements ERC20, ERC223 and MintableToken interfaces as well as capped and finalization logic
671 contract MustToken is StandardBurnableToken, RBACERC223TokenFinalization, RBACMintableTokenMixin {
672   /// @notice Constant field with token full name
673   // solium-disable-next-line uppercase
674   string constant public name = "Main Universal Standard of Tokenization"; 
675   /// @notice Constant field with token symbol
676   string constant public symbol = "MUST"; // solium-disable-line uppercase
677   /// @notice Constant field with token precision depth
678   uint256 constant public decimals = 8; // solium-disable-line uppercase
679   /// @notice Constant field with token cap (total supply limit)
680   uint256 constant public cap = 5 * (10 ** 6) * (10 ** decimals); // solium-disable-line uppercase
681 
682   /// @notice Overrides original mint function from MintableToken to limit minting over cap
683   /// @param _to The address that will receive the minted tokens.
684   /// @param _amount The amount of tokens to mint.
685   /// @return A boolean that indicates if the operation was successful.
686   function mint(
687     address _to,
688     uint256 _amount
689   )
690     public
691     returns (bool) 
692   {
693     require(totalSupply().add(_amount) <= cap);
694     return super.mint(_to, _amount);
695   }
696 
697   /// @notice Overrides finalize function from RBACERC223TokenFinalization to prevent future minting after finalization
698   /// @return A boolean that indicates if the operation was successful.
699   function finalize() public returns (bool) {
700     require(super.finalize());
701     require(finishMinting());
702     return true;
703   }
704 
705   /// @notice Overrides finishMinting function from RBACMintableTokenMixin to prevent finishing minting before finalization
706   /// @return A boolean that indicates if the operation was successful.
707   function finishMinting() internal returns (bool) {
708     require(finalized == true);
709     require(super.finishMinting());
710     return true;
711   }
712 }