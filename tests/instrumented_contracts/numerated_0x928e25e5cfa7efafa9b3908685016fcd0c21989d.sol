1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(
232     address _spender,
233     uint _subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 contract ERC223ReceiverMixin {
251   function tokenFallback(address _from, uint256 _value, bytes memory _data) public;
252 }
253 
254 /// @title Custom implementation of ERC223 
255 contract ERC223Mixin is StandardToken {
256   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
257 
258   function transferFrom(
259     address _from,
260     address _to,
261     uint256 _value
262   ) public returns (bool) 
263   {
264     bytes memory empty;
265     return transferFrom(
266       _from, 
267       _to,
268       _value,
269       empty);
270   }
271 
272   function transferFrom(
273     address _from,
274     address _to,
275     uint256 _value,
276     bytes memory _data
277   ) public returns (bool)
278   {
279     require(_value <= allowed[_from][msg.sender], "Reached allowed value");
280     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
281     if (isContract(_to)) {
282       return transferToContract(
283         _from, 
284         _to, 
285         _value, 
286         _data);
287     } else {
288       return transferToAddress(
289         _from, 
290         _to, 
291         _value, 
292         _data); 
293     }
294   }
295 
296   function transfer(address _to, uint256 _value, bytes memory _data) public returns (bool success) {
297     if (isContract(_to)) {
298       return transferToContract(
299         msg.sender,
300         _to,
301         _value,
302         _data); 
303     } else {
304       return transferToAddress(
305         msg.sender,
306         _to,
307         _value,
308         _data);
309     }
310   }
311 
312   function transfer(address _to, uint256 _value) public returns (bool success) {
313     bytes memory empty;
314     return transfer(_to, _value, empty);
315   }
316 
317   function isContract(address _addr) internal view returns (bool) {
318     uint256 length;
319     // solium-disable-next-line security/no-inline-assembly
320     assembly {
321       //retrieve the size of the code on target address, this needs assembly
322       length := extcodesize(_addr)
323     }  
324     return (length>0);
325   }
326 
327   function moveTokens(address _from, address _to, uint256 _value) internal returns (bool success) {
328     if (balanceOf(_from) < _value) {
329       revert();
330     }
331     balances[_from] = balanceOf(_from).sub(_value);
332     balances[_to] = balanceOf(_to).add(_value);
333 
334     return true;
335   }
336 
337   function transferToAddress(
338     address _from,
339     address _to,
340     uint256 _value,
341     bytes memory _data
342   ) internal returns (bool success) 
343   {
344     require(moveTokens(_from, _to, _value), "Move is not successful");
345     emit Transfer(_from, _to, _value);
346     emit Transfer(_from, _to, _value, _data); // solium-disable-line arg-overflow
347     return true;
348   }
349   
350   //function that is called when transaction target is a contract
351   function transferToContract(
352     address _from,
353     address _to,
354     uint256 _value,
355     bytes memory _data
356   ) internal returns (bool success) 
357   {
358     require(moveTokens(_from, _to, _value), "Move is not successful");
359     ERC223ReceiverMixin(_to).tokenFallback(_from, _value, _data);
360     emit Transfer(_from, _to, _value);
361     emit Transfer(_from, _to, _value, _data); // solium-disable-line arg-overflow
362     return true;
363   }
364 }
365 
366 /// @title Role based access control mixin for Product Protocol Platform
367 /// @dev Ignore DRY approach to achieve readability
368 contract RBACMixin {
369   /// @notice Constant string message to throw on lack of access
370   string constant FORBIDDEN = "Doesn't have enough rights";
371   string constant DUPLICATE = "Requirement already satisfied";
372 
373   /// @notice Public owner
374   address public owner;
375 
376   /// @notice Public map of minters
377   mapping (address => bool) public minters;
378 
379   /// @notice The event indicates a set of a new owner
380   /// @param who is address of added owner
381   event SetOwner(address indexed who);
382 
383   /// @notice The event indicates the addition of a new minter
384   /// @param who is address of added minter
385   event AddMinter(address indexed who);
386   /// @notice The event indicates the deletion of a minter
387   /// @param who is address of deleted minter
388   event DeleteMinter(address indexed who);
389 
390   constructor () public {
391     _setOwner(msg.sender);
392   }
393 
394   /// @notice The functional modifier rejects the interaction of sender who is not an owner
395   modifier onlyOwner() {
396     require(isOwner(msg.sender), FORBIDDEN);
397     _;
398   }
399 
400   /// @notice Functional modifier for rejecting the interaction of senders that are not minters
401   modifier onlyMinter() {
402     require(isMinter(msg.sender), FORBIDDEN);
403     _;
404   }
405 
406   /// @notice Look up for the owner role on providen address
407   /// @param _who is address to look up
408   /// @return A boolean of owner role
409   function isOwner(address _who) public view returns (bool) {
410     return owner == _who;
411   }
412 
413   /// @notice Look up for the minter role on providen address
414   /// @param _who is address to look up
415   /// @return A boolean of minter role
416   function isMinter(address _who) public view returns (bool) {
417     return minters[_who];
418   }
419 
420   /// @notice Adds the owner role to provided address
421   /// @dev Requires owner role to interact
422   /// @param _who is address to add role
423   /// @return A boolean that indicates if the operation was successful.
424   function setOwner(address _who) public onlyOwner returns (bool) {
425     require(_who != address(0));
426     _setOwner(_who);
427   }
428 
429   /// @notice Adds the minter role to provided address
430   /// @dev Requires owner role to interact
431   /// @param _who is address to add role
432   /// @return A boolean that indicates if the operation was successful.
433   function addMinter(address _who) public onlyOwner returns (bool) {
434     _setMinter(_who, true);
435   }
436 
437   /// @notice Deletes the minter role to provided address
438   /// @dev Requires owner role to interact
439   /// @param _who is address to delete role
440   /// @return A boolean that indicates if the operation was successful.
441   function deleteMinter(address _who) public onlyOwner returns (bool) {
442     _setMinter(_who, false);
443   }
444 
445   /// @notice Changes the owner role to provided address
446   /// @param _who is address to change role
447   /// @param _flag is next role status after success
448   /// @return A boolean that indicates if the operation was successful.
449   function _setOwner(address _who) private returns (bool) {
450     require(owner != _who, DUPLICATE);
451     owner = _who;
452     emit SetOwner(_who);
453     return true;
454   }
455 
456   /// @notice Changes the minter role to provided address
457   /// @param _who is address to change role
458   /// @param _flag is next role status after success
459   /// @return A boolean that indicates if the operation was successful.
460   function _setMinter(address _who, bool _flag) private returns (bool) {
461     require(minters[_who] != _flag, DUPLICATE);
462     minters[_who] = _flag;
463     if (_flag) {
464       emit AddMinter(_who);
465     } else {
466       emit DeleteMinter(_who);
467     }
468     return true;
469   }
470 }
471 
472 contract RBACMintableTokenMixin is StandardToken, RBACMixin {
473   /// @notice Total issued tokens
474   uint256 totalIssued_;
475 
476   event Mint(address indexed to, uint256 amount);
477   event MintFinished();
478 
479   bool public mintingFinished = false;
480 
481   modifier canMint() {
482     require(!mintingFinished, "Minting is finished");
483     _;
484   }
485 
486   /**
487    * @dev Function to mint tokens
488    * @param _to The address that will receive the minted tokens.
489    * @param _amount The amount of tokens to mint.
490    * @return A boolean that indicates if the operation was successful.
491    */
492   function mint(
493     address _to,
494     uint256 _amount
495   )
496     onlyMinter
497     canMint
498     public
499     returns (bool)
500   {
501     totalIssued_ = totalIssued_.add(_amount);
502     totalSupply_ = totalSupply_.add(_amount);
503     balances[_to] = balances[_to].add(_amount);
504     emit Mint(_to, _amount);
505     emit Transfer(address(0), _to, _amount);
506     return true;
507   }
508 
509   /**
510    * @dev Function to stop minting new tokens.
511    * @return True if the operation was successful.
512    */
513   function finishMinting() onlyOwner canMint internal returns (bool) {
514     mintingFinished = true;
515     emit MintFinished();
516     return true;
517   }
518 }
519 
520 /// @title Role based token finalization mixin
521 contract RBACERC223TokenFinalization is ERC223Mixin, RBACMixin {
522   event Finalize();
523   /// @notice Public field inicates the finalization state of smart-contract
524   bool public finalized;
525 
526   /// @notice The functional modifier rejects the interaction if contract isn't finalized
527   modifier isFinalized() {
528     require(finalized);
529     _;
530   }
531 
532   /// @notice The functional modifier rejects the interaction if contract is finalized
533   modifier notFinalized() {
534     require(!finalized);
535     _;
536   }
537 
538   /// @notice Finalizes contract
539   /// @dev Requires owner role to interact
540   /// @return A boolean that indicates if the operation was successful.
541   function finalize() public notFinalized onlyOwner returns (bool) {
542     finalized = true;
543     emit Finalize();
544     return true;
545   }
546 
547   /// @dev Overrides ERC20 interface to prevent interaction before finalization
548   function transferFrom(address _from, address _to, uint256 _value) public isFinalized returns (bool) {
549     return super.transferFrom(_from, _to, _value);
550   }
551 
552   /// @dev Overrides ERC223 interface to prevent interaction before finalization
553   // solium-disable-next-line arg-overflow
554   function transferFrom(address _from, address _to, uint256 _value, bytes memory _data) public isFinalized returns (bool) {
555     return super.transferFrom(_from, _to, _value, _data); // solium-disable-line arg-overflow
556   }
557 
558   /// @dev Overrides ERC223 interface to prevent interaction before finalization
559   function transfer(address _to, uint256 _value, bytes memory _data) public isFinalized returns (bool) {
560     return super.transfer(_to, _value, _data);
561   }
562 
563   /// @dev Overrides ERC20 interface to prevent interaction before finalization
564   function transfer(address _to, uint256 _value) public isFinalized returns (bool) {
565     return super.transfer(_to, _value);
566   }
567 
568   /// @dev Overrides ERC20 interface to prevent interaction before finalization
569   function approve(address _spender, uint256 _value) public isFinalized returns (bool) {
570     return super.approve(_spender, _value);
571   }
572 
573   /// @dev Overrides ERC20 interface to prevent interaction before finalization
574   function increaseApproval(address _spender, uint256 _addedValue) public isFinalized returns (bool) {
575     return super.increaseApproval(_spender, _addedValue);
576   }
577 
578   /// @dev Overrides ERC20 interface to prevent interaction before finalization
579   function decreaseApproval(address _spender, uint256 _subtractedValue) public isFinalized returns (bool) {
580     return super.decreaseApproval(_spender, _subtractedValue);
581   }
582 }
583 
584 /**
585  * @title Burnable Token
586  * @dev Token that can be irreversibly burned (destroyed).
587  */
588 contract BurnableToken is BasicToken {
589 
590   event Burn(address indexed burner, uint256 value);
591 
592   /**
593    * @dev Burns a specific amount of tokens.
594    * @param _value The amount of token to be burned.
595    */
596   function burn(uint256 _value) public {
597     _burn(msg.sender, _value);
598   }
599 
600   function _burn(address _who, uint256 _value) internal {
601     require(_value <= balances[_who]);
602     // no need to require value <= totalSupply, since that would imply the
603     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
604 
605     balances[_who] = balances[_who].sub(_value);
606     totalSupply_ = totalSupply_.sub(_value);
607     emit Burn(_who, _value);
608     emit Transfer(_who, address(0), _value);
609   }
610 }
611 
612 /**
613  * @title Standard Burnable Token
614  * @dev Adds burnFrom method to ERC20 implementations
615  */
616 contract StandardBurnableToken is BurnableToken, StandardToken {
617 
618   /**
619    * @dev Burns a specific amount of tokens from the target address and decrements allowance
620    * @param _from address The address which you want to send tokens from
621    * @param _value uint256 The amount of token to be burned
622    */
623   function burnFrom(address _from, uint256 _value) public {
624     require(_value <= allowed[_from][msg.sender]);
625     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
626     // this function needs to emit an event with the updated approval.
627     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
628     _burn(_from, _value);
629   }
630 }
631 
632 /// @title Product Protocol token implementation
633 /// @dev Implements ERC20, ERC223 and MintableToken interfaces
634 contract ProductProtocolToken is StandardBurnableToken, ERC223Mixin, RBACERC223TokenFinalization, RBACMintableTokenMixin {
635   /// @notice Constant field with token full name
636   // solium-disable-next-line uppercase
637   string constant public name = "Product Protocol"; 
638   /// @notice Constant field with token symbol
639   string constant public symbol = "PPO"; // solium-disable-line uppercase
640   /// @notice Constant field with token precision depth
641   uint256 constant public decimals = 18; // solium-disable-line uppercase
642   /// @notice Constant field with token cap (total supply limit)
643   uint256 constant public cap = 40 * (10 ** 9) * (10 ** decimals); // solium-disable-line uppercase
644 
645   /// @notice Overrides original mint function from MintableToken to limit minting over cap
646   /// @param _to The address that will receive the minted tokens.
647   /// @param _amount The amount of tokens to mint.
648   /// @return A boolean that indicates if the operation was successful.
649   function mint(
650     address _to,
651     uint256 _amount
652   )
653     public
654     returns (bool) 
655   {
656     require(totalIssued_.add(_amount) <= cap, "Cap reached");
657     return super.mint(_to, _amount);
658   }
659 
660   /// @notice Overrides finalize function from RBACERC223TokenFinalization to prevent future minting after finalization
661   /// @return A boolean that indicates if the operation was successful.
662   function finalize() public returns (bool) {
663     require(super.finalize());
664     require(finishMinting());
665     return true;
666   }
667 
668   /// @notice Overrides finishMinting function from RBACMintableTokenMixin to prevent finishing minting before finalization
669   /// @return A boolean that indicates if the operation was successful.
670   function finishMinting() internal returns (bool) {
671     require(finalized == true);
672     require(super.finishMinting());
673     return true;
674   }
675 }