1 pragma solidity 0.4.24;
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
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address _who) public view returns (uint256);
61   function transfer(address _to, uint256 _value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) internal balances;
73 
74   uint256 internal totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_value <= balances[msg.sender]);
90     require(_to != address(0));
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
114   function allowance(address _owner, address _spender)
115     public view returns (uint256);
116 
117   function transferFrom(address _from, address _to, uint256 _value)
118     public returns (bool);
119 
120   function approve(address _spender, uint256 _value) public returns (bool);
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
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156     require(_to != address(0));
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
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue >= oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title DetailedERC20 token
249  * @dev The decimals are only for visualization purposes.
250  * All the operations are done using the smallest and indivisible token unit,
251  * just as on Ethereum all the operations are done in wei.
252  */
253 contract DetailedERC20 is ERC20 {
254   string public name;
255   string public symbol;
256   uint8 public decimals;
257 
258   constructor(string _name, string _symbol, uint8 _decimals) public {
259     name = _name;
260     symbol = _symbol;
261     decimals = _decimals;
262   }
263 }
264 
265 /**
266  * @title Ownable
267  * @dev The Ownable contract has an owner address, and provides basic authorization control
268  * functions, this simplifies the implementation of "user permissions".
269  */
270 contract Ownable {
271   address public owner;
272 
273 
274   event OwnershipRenounced(address indexed previousOwner);
275   event OwnershipTransferred(
276     address indexed previousOwner,
277     address indexed newOwner
278   );
279 
280 
281   /**
282    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
283    * account.
284    */
285   constructor() public {
286     owner = msg.sender;
287   }
288 
289   /**
290    * @dev Throws if called by any account other than the owner.
291    */
292   modifier onlyOwner() {
293     require(msg.sender == owner);
294     _;
295   }
296 
297   /**
298    * @dev Allows the current owner to relinquish control of the contract.
299    * @notice Renouncing to ownership will leave the contract without an owner.
300    * It will not be possible to call the functions with the `onlyOwner`
301    * modifier anymore.
302    */
303   function renounceOwnership() public onlyOwner {
304     emit OwnershipRenounced(owner);
305     owner = address(0);
306   }
307 
308   /**
309    * @dev Allows the current owner to transfer control of the contract to a newOwner.
310    * @param _newOwner The address to transfer ownership to.
311    */
312   function transferOwnership(address _newOwner) public onlyOwner {
313     _transferOwnership(_newOwner);
314   }
315 
316   /**
317    * @dev Transfers control of the contract to a newOwner.
318    * @param _newOwner The address to transfer ownership to.
319    */
320   function _transferOwnership(address _newOwner) internal {
321     require(_newOwner != address(0));
322     emit OwnershipTransferred(owner, _newOwner);
323     owner = _newOwner;
324   }
325 }
326 
327 /**
328  * @title Pausable
329  * @dev Base contract which allows children to implement an emergency stop mechanism.
330  */
331 contract Pausable is Ownable {
332   event Pause();
333   event Unpause();
334 
335   bool public paused = false;
336 
337 
338   /**
339    * @dev Modifier to make a function callable only when the contract is not paused.
340    */
341   modifier whenNotPaused() {
342     require(!paused);
343     _;
344   }
345 
346   /**
347    * @dev Modifier to make a function callable only when the contract is paused.
348    */
349   modifier whenPaused() {
350     require(paused);
351     _;
352   }
353 
354   /**
355    * @dev called by the owner to pause, triggers stopped state
356    */
357   function pause() public onlyOwner whenNotPaused {
358     paused = true;
359     emit Pause();
360   }
361 
362   /**
363    * @dev called by the owner to unpause, returns to normal state
364    */
365   function unpause() public onlyOwner whenPaused {
366     paused = false;
367     emit Unpause();
368   }
369 }
370 
371 /**
372  * @title Pausable token
373  * @dev StandardToken modified with pausable transfers.
374  **/
375 contract PausableToken is StandardToken, Pausable {
376 
377   function transfer(
378     address _to,
379     uint256 _value
380   )
381     public
382     whenNotPaused
383     returns (bool)
384   {
385     return super.transfer(_to, _value);
386   }
387 
388   function transferFrom(
389     address _from,
390     address _to,
391     uint256 _value
392   )
393     public
394     whenNotPaused
395     returns (bool)
396   {
397     return super.transferFrom(_from, _to, _value);
398   }
399 
400   function approve(
401     address _spender,
402     uint256 _value
403   )
404     public
405     whenNotPaused
406     returns (bool)
407   {
408     return super.approve(_spender, _value);
409   }
410 
411   function increaseApproval(
412     address _spender,
413     uint _addedValue
414   )
415     public
416     whenNotPaused
417     returns (bool success)
418   {
419     return super.increaseApproval(_spender, _addedValue);
420   }
421 
422   function decreaseApproval(
423     address _spender,
424     uint _subtractedValue
425   )
426     public
427     whenNotPaused
428     returns (bool success)
429   {
430     return super.decreaseApproval(_spender, _subtractedValue);
431   }
432 }
433 
434 /**
435  * @title Mintable token
436  * @dev Simple ERC20 Token example, with mintable token creation
437  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
438  */
439 contract MintableToken is StandardToken, Ownable {
440   event Mint(address indexed to, uint256 amount);
441   event MintFinished();
442 
443   bool public mintingFinished = false;
444 
445 
446   modifier canMint() {
447     require(!mintingFinished);
448     _;
449   }
450 
451   modifier hasMintPermission() {
452     require(msg.sender == owner);
453     _;
454   }
455 
456   /**
457    * @dev Function to mint tokens
458    * @param _to The address that will receive the minted tokens.
459    * @param _amount The amount of tokens to mint.
460    * @return A boolean that indicates if the operation was successful.
461    */
462   function mint(
463     address _to,
464     uint256 _amount
465   )
466     public
467     hasMintPermission
468     canMint
469     returns (bool)
470   {
471     totalSupply_ = totalSupply_.add(_amount);
472     balances[_to] = balances[_to].add(_amount);
473     emit Mint(_to, _amount);
474     emit Transfer(address(0), _to, _amount);
475     return true;
476   }
477 
478   /**
479    * @dev Function to stop minting new tokens.
480    * @return True if the operation was successful.
481    */
482   function finishMinting() public onlyOwner canMint returns (bool) {
483     mintingFinished = true;
484     emit MintFinished();
485     return true;
486   }
487 }
488 
489 /**
490  * @title Capped token
491  * @dev Mintable token with a token cap.
492  */
493 contract CappedToken is MintableToken {
494 
495   uint256 public cap;
496 
497   constructor(uint256 _cap) public {
498     require(_cap > 0);
499     cap = _cap;
500   }
501 
502   /**
503    * @dev Function to mint tokens
504    * @param _to The address that will receive the minted tokens.
505    * @param _amount The amount of tokens to mint.
506    * @return A boolean that indicates if the operation was successful.
507    */
508   function mint(
509     address _to,
510     uint256 _amount
511   )
512     public
513     returns (bool)
514   {
515     require(totalSupply_.add(_amount) <= cap);
516 
517     return super.mint(_to, _amount);
518   }
519 
520 }
521 
522 /**
523  * @title Burnable Token
524  * @dev Token that can be irreversibly burned (destroyed).
525  */
526 contract BurnableToken is BasicToken {
527 
528   event Burn(address indexed burner, uint256 value);
529 
530   /**
531    * @dev Burns a specific amount of tokens.
532    * @param _value The amount of token to be burned.
533    */
534   function burn(uint256 _value) public {
535     _burn(msg.sender, _value);
536   }
537 
538   function _burn(address _who, uint256 _value) internal {
539     require(_value <= balances[_who]);
540     // no need to require value <= totalSupply, since that would imply the
541     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
542 
543     balances[_who] = balances[_who].sub(_value);
544     totalSupply_ = totalSupply_.sub(_value);
545     emit Burn(_who, _value);
546     emit Transfer(_who, address(0), _value);
547   }
548 }
549 
550 contract MatterToken is DetailedERC20, StandardToken, PausableToken, CappedToken, BurnableToken {
551   using SafeMath for uint256;
552 
553   event MintApprovalChanged(address indexed minter, uint256 newValue);
554   event MintWithData(address indexed to, uint256 amount, bytes data);
555 
556   mapping (address => uint256) mintApprovals;
557 
558   // Override modifier from parent MintableToken contract. We allow anyone
559   // to mint, but explicitly check approval in the function code.
560   modifier hasMintPermission() {
561     _;
562   }
563 
564   constructor(uint256 _cap, address[] _holders, uint256[] _amounts)
565     DetailedERC20("Matter", "MTR", 18)
566     CappedToken(_cap)
567     public
568   {
569     require(
570       _holders.length == _amounts.length,
571       "_holers and _amounts contain different number of items"
572     );
573 
574     for (uint256 i = 0; i < _holders.length; ++i) {
575       address holder = _holders[i];
576       uint256 amount = _amounts[i];
577       totalSupply_ = totalSupply_.add(amount);
578       balances[holder] = balances[holder].add(amount);
579       emit Mint(holder, amount);
580       emit Transfer(address(0), holder, amount);
581     }
582 
583     require(totalSupply_ <= _cap, "initial total supply is more than cap");
584   }
585 
586   function burn(uint256 _value) public whenNotPaused {
587     super.burn(_value);
588   }
589 
590   function batchTransfer(address[] _to, uint256[] _amounts) public whenNotPaused {
591     require(_to.length == _amounts.length, "_to and _amounts contain different number of items");
592 
593     for (uint256 i = 0; i < _to.length; ++i) {
594       transfer(_to[i], _amounts[i]);
595     }
596   }
597 
598   function batchMint(address[] _to, uint256[] _amounts) public whenNotPaused {
599     require(_to.length == _amounts.length, "_to and _amounts contain different number of items");
600 
601     uint256 totalAmount = 0;
602 
603     for (uint256 i = 0; i < _to.length; ++i) {
604       totalAmount = totalAmount.add(_amounts[i]);
605       super.mint(_to[i], _amounts[i]);
606     }
607 
608     _decreaseMintApprovalAfterMint(msg.sender, totalAmount);
609   }
610 
611   function batchMintWithData(address[] _to, uint256[] _amounts, bytes _data) public whenNotPaused {
612     require(_to.length == _amounts.length, "_to and _amounts contain different number of items");
613 
614     uint256 totalAmount = 0;
615 
616     for (uint256 i = 0; i < _to.length; ++i) {
617       emit MintWithData(_to[i], _amounts[i], _data);
618       totalAmount = totalAmount.add(_amounts[i]);
619       super.mint(_to[i], _amounts[i]);
620     }
621 
622     _decreaseMintApprovalAfterMint(msg.sender, totalAmount);
623   }
624 
625   function mint(address _to, uint256 _amount)
626     public
627     whenNotPaused
628     returns (bool)
629   {
630     _decreaseMintApprovalAfterMint(msg.sender, _amount);
631     return super.mint(_to, _amount);
632   }
633 
634   function mintWithData(address _to, uint256 _amount, bytes _data)
635     public
636     whenNotPaused
637     returns (bool)
638   {
639     _decreaseMintApprovalAfterMint(msg.sender, _amount);
640     emit MintWithData(_to, _amount, _data);
641     return super.mint(_to, _amount);
642   }
643 
644   function _decreaseMintApprovalAfterMint(address _minter, uint256 _mintedAmount) internal {
645     if (_minter != owner) {
646       uint256 approval = mintApprovals[_minter];
647       require(approval >= _mintedAmount, "mint approval is insufficient to mint this amount");
648       mintApprovals[_minter] = approval.sub(_mintedAmount);
649     }
650   }
651 
652   function increaseMintApproval(address _minter, uint256 _addedValue)
653     public
654     whenNotPaused
655     onlyOwner
656   {
657     require(_minter != owner, "cannot set mint approval for owner");
658     mintApprovals[_minter] = mintApprovals[_minter].add(_addedValue);
659     emit MintApprovalChanged(_minter, mintApprovals[_minter]);
660   }
661 
662   function decreaseMintApproval(address _minter, uint256 _subtractedValue)
663     public
664     whenNotPaused
665     onlyOwner
666   {
667     require(_minter != owner, "cannot set mint approval for owner");
668     uint256 approval = mintApprovals[_minter];
669     if (_subtractedValue >= approval) {
670       mintApprovals[_minter] = 0;
671     } else {
672       mintApprovals[_minter] = approval.sub(_subtractedValue);
673     }
674     emit MintApprovalChanged(_minter, mintApprovals[_minter]);
675   }
676 
677   function getMintApproval(address _minter) public view returns (uint256) {
678     return mintApprovals[_minter];
679   }
680 
681   function getMintLimit(address _minter) public view returns (uint256) {
682     uint256 capLeft = cap.sub(totalSupply_);
683 
684     if (_minter == owner) {
685       return capLeft;
686     }
687 
688     uint256 approval = mintApprovals[_minter];
689     return approval < capLeft ? approval : capLeft;
690   }
691 }