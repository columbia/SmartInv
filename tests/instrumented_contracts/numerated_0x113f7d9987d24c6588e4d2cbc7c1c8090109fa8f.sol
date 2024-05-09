1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 // File: node_modules\zeppelin-solidity\contracts\lifecycle\TokenDestructible.sol
82 
83 /**
84  * @title TokenDestructible:
85  * @author Remco Bloemen <remco@2π.com>
86  * @dev Base contract that can be destroyed by owner. All funds in contract including
87  * listed tokens will be sent to the owner.
88  */
89 contract TokenDestructible is Ownable {
90 
91   constructor() public payable { }
92 
93   /**
94    * @notice Terminate contract and refund to owner
95    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
96    refund.
97    * @notice The called token contracts could try to re-enter this contract. Only
98    supply token contracts you trust.
99    */
100   function destroy(address[] tokens) onlyOwner public {
101 
102     // Transfer tokens to owner
103     for (uint256 i = 0; i < tokens.length; i++) {
104       ERC20Basic token = ERC20Basic(tokens[i]);
105       uint256 balance = token.balanceOf(this);
106       token.transfer(owner, balance);
107     }
108 
109     // Transfer Eth to owner and terminate contract
110     selfdestruct(owner);
111   }
112 }
113 
114 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, throws on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
126     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     c = a * b;
134     assert(c / a == b);
135     return c;
136   }
137 
138   /**
139   * @dev Integer division of two numbers, truncating the quotient.
140   */
141   function div(uint256 a, uint256 b) internal pure returns (uint256) {
142     // assert(b > 0); // Solidity automatically throws when dividing by 0
143     // uint256 c = a / b;
144     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145     return a / b;
146   }
147 
148   /**
149   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
150   */
151   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152     assert(b <= a);
153     return a - b;
154   }
155 
156   /**
157   * @dev Adds two numbers, throws on overflow.
158   */
159   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
160     c = a + b;
161     assert(c >= a);
162     return c;
163   }
164 }
165 
166 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances.
171  */
172 contract BasicToken is ERC20Basic {
173   using SafeMath for uint256;
174 
175   mapping(address => uint256) balances;
176 
177   uint256 totalSupply_;
178 
179   /**
180   * @dev Total number of tokens in existence
181   */
182   function totalSupply() public view returns (uint256) {
183     return totalSupply_;
184   }
185 
186   /**
187   * @dev Transfer token for a specified address
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
210 }
211 
212 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
213 
214 /**
215  * @title Burnable Token
216  * @dev Token that can be irreversibly burned (destroyed).
217  */
218 contract BurnableToken is BasicToken {
219 
220   event Burn(address indexed burner, uint256 value);
221 
222   /**
223    * @dev Burns a specific amount of tokens.
224    * @param _value The amount of token to be burned.
225    */
226   function burn(uint256 _value) public {
227     _burn(msg.sender, _value);
228   }
229 
230   function _burn(address _who, uint256 _value) internal {
231     require(_value <= balances[_who]);
232     // no need to require value <= totalSupply, since that would imply the
233     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
234 
235     balances[_who] = balances[_who].sub(_value);
236     totalSupply_ = totalSupply_.sub(_value);
237     emit Burn(_who, _value);
238     emit Transfer(_who, address(0), _value);
239   }
240 }
241 
242 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
243 
244 /**
245  * @title ERC20 interface
246  * @dev see https://github.com/ethereum/EIPs/issues/20
247  */
248 contract ERC20 is ERC20Basic {
249   function allowance(address owner, address spender)
250     public view returns (uint256);
251 
252   function transferFrom(address from, address to, uint256 value)
253     public returns (bool);
254 
255   function approve(address spender, uint256 value) public returns (bool);
256   event Approval(
257     address indexed owner,
258     address indexed spender,
259     uint256 value
260   );
261 }
262 
263 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
264 
265 /**
266  * @title Standard ERC20 token
267  *
268  * @dev Implementation of the basic standard token.
269  * https://github.com/ethereum/EIPs/issues/20
270  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
271  */
272 contract StandardToken is ERC20, BasicToken {
273 
274   mapping (address => mapping (address => uint256)) internal allowed;
275 
276 
277   /**
278    * @dev Transfer tokens from one address to another
279    * @param _from address The address which you want to send tokens from
280    * @param _to address The address which you want to transfer to
281    * @param _value uint256 the amount of tokens to be transferred
282    */
283   function transferFrom(
284     address _from,
285     address _to,
286     uint256 _value
287   )
288     public
289     returns (bool)
290   {
291     require(_to != address(0));
292     require(_value <= balances[_from]);
293     require(_value <= allowed[_from][msg.sender]);
294 
295     balances[_from] = balances[_from].sub(_value);
296     balances[_to] = balances[_to].add(_value);
297     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
298     emit Transfer(_from, _to, _value);
299     return true;
300   }
301 
302   /**
303    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
304    * Beware that changing an allowance with this method brings the risk that someone may use both the old
305    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
306    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
307    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308    * @param _spender The address which will spend the funds.
309    * @param _value The amount of tokens to be spent.
310    */
311   function approve(address _spender, uint256 _value) public returns (bool) {
312     allowed[msg.sender][_spender] = _value;
313     emit Approval(msg.sender, _spender, _value);
314     return true;
315   }
316 
317   /**
318    * @dev Function to check the amount of tokens that an owner allowed to a spender.
319    * @param _owner address The address which owns the funds.
320    * @param _spender address The address which will spend the funds.
321    * @return A uint256 specifying the amount of tokens still available for the spender.
322    */
323   function allowance(
324     address _owner,
325     address _spender
326    )
327     public
328     view
329     returns (uint256)
330   {
331     return allowed[_owner][_spender];
332   }
333 
334   /**
335    * @dev Increase the amount of tokens that an owner allowed to a spender.
336    * approve should be called when allowed[_spender] == 0. To increment
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param _spender The address which will spend the funds.
341    * @param _addedValue The amount of tokens to increase the allowance by.
342    */
343   function increaseApproval(
344     address _spender,
345     uint256 _addedValue
346   )
347     public
348     returns (bool)
349   {
350     allowed[msg.sender][_spender] = (
351       allowed[msg.sender][_spender].add(_addedValue));
352     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353     return true;
354   }
355 
356   /**
357    * @dev Decrease the amount of tokens that an owner allowed to a spender.
358    * approve should be called when allowed[_spender] == 0. To decrement
359    * allowed value is better to use this function to avoid 2 calls (and wait until
360    * the first transaction is mined)
361    * From MonolithDAO Token.sol
362    * @param _spender The address which will spend the funds.
363    * @param _subtractedValue The amount of tokens to decrease the allowance by.
364    */
365   function decreaseApproval(
366     address _spender,
367     uint256 _subtractedValue
368   )
369     public
370     returns (bool)
371   {
372     uint256 oldValue = allowed[msg.sender][_spender];
373     if (_subtractedValue > oldValue) {
374       allowed[msg.sender][_spender] = 0;
375     } else {
376       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
377     }
378     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
379     return true;
380   }
381 
382 }
383 
384 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
385 
386 /**
387  * @title Mintable token
388  * @dev Simple ERC20 Token example, with mintable token creation
389  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
390  */
391 contract MintableToken is StandardToken, Ownable {
392   event Mint(address indexed to, uint256 amount);
393   event MintFinished();
394 
395   bool public mintingFinished = false;
396 
397 
398   modifier canMint() {
399     require(!mintingFinished);
400     _;
401   }
402 
403   modifier hasMintPermission() {
404     require(msg.sender == owner);
405     _;
406   }
407 
408   /**
409    * @dev Function to mint tokens
410    * @param _to The address that will receive the minted tokens.
411    * @param _amount The amount of tokens to mint.
412    * @return A boolean that indicates if the operation was successful.
413    */
414   function mint(
415     address _to,
416     uint256 _amount
417   )
418     hasMintPermission
419     canMint
420     public
421     returns (bool)
422   {
423     totalSupply_ = totalSupply_.add(_amount);
424     balances[_to] = balances[_to].add(_amount);
425     emit Mint(_to, _amount);
426     emit Transfer(address(0), _to, _amount);
427     return true;
428   }
429 
430   /**
431    * @dev Function to stop minting new tokens.
432    * @return True if the operation was successful.
433    */
434   function finishMinting() onlyOwner canMint public returns (bool) {
435     mintingFinished = true;
436     emit MintFinished();
437     return true;
438   }
439 }
440 
441 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\CappedToken.sol
442 
443 /**
444  * @title Capped token
445  * @dev Mintable token with a token cap.
446  */
447 contract CappedToken is MintableToken {
448 
449   uint256 public cap;
450 
451   constructor(uint256 _cap) public {
452     require(_cap > 0);
453     cap = _cap;
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
467     returns (bool)
468   {
469     require(totalSupply_.add(_amount) <= cap);
470 
471     return super.mint(_to, _amount);
472   }
473 
474 }
475 
476 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\DetailedERC20.sol
477 
478 /**
479  * @title DetailedERC20 token
480  * @dev The decimals are only for visualization purposes.
481  * All the operations are done using the smallest and indivisible token unit,
482  * just as on Ethereum all the operations are done in wei.
483  */
484 contract DetailedERC20 is ERC20 {
485   string public name;
486   string public symbol;
487   uint8 public decimals;
488 
489   constructor(string _name, string _symbol, uint8 _decimals) public {
490     name = _name;
491     symbol = _symbol;
492     decimals = _decimals;
493   }
494 }
495 
496 // File: node_modules\zeppelin-solidity\contracts\lifecycle\Pausable.sol
497 
498 /**
499  * @title Pausable
500  * @dev Base contract which allows children to implement an emergency stop mechanism.
501  */
502 contract Pausable is Ownable {
503   event Pause();
504   event Unpause();
505 
506   bool public paused = false;
507 
508 
509   /**
510    * @dev Modifier to make a function callable only when the contract is not paused.
511    */
512   modifier whenNotPaused() {
513     require(!paused);
514     _;
515   }
516 
517   /**
518    * @dev Modifier to make a function callable only when the contract is paused.
519    */
520   modifier whenPaused() {
521     require(paused);
522     _;
523   }
524 
525   /**
526    * @dev called by the owner to pause, triggers stopped state
527    */
528   function pause() onlyOwner whenNotPaused public {
529     paused = true;
530     emit Pause();
531   }
532 
533   /**
534    * @dev called by the owner to unpause, returns to normal state
535    */
536   function unpause() onlyOwner whenPaused public {
537     paused = false;
538     emit Unpause();
539   }
540 }
541 
542 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\PausableToken.sol
543 
544 /**
545  * @title Pausable token
546  * @dev StandardToken modified with pausable transfers.
547  **/
548 contract PausableToken is StandardToken, Pausable {
549 
550   function transfer(
551     address _to,
552     uint256 _value
553   )
554     public
555     whenNotPaused
556     returns (bool)
557   {
558     return super.transfer(_to, _value);
559   }
560 
561   function transferFrom(
562     address _from,
563     address _to,
564     uint256 _value
565   )
566     public
567     whenNotPaused
568     returns (bool)
569   {
570     return super.transferFrom(_from, _to, _value);
571   }
572 
573   function approve(
574     address _spender,
575     uint256 _value
576   )
577     public
578     whenNotPaused
579     returns (bool)
580   {
581     return super.approve(_spender, _value);
582   }
583 
584   function increaseApproval(
585     address _spender,
586     uint _addedValue
587   )
588     public
589     whenNotPaused
590     returns (bool success)
591   {
592     return super.increaseApproval(_spender, _addedValue);
593   }
594 
595   function decreaseApproval(
596     address _spender,
597     uint _subtractedValue
598   )
599     public
600     whenNotPaused
601     returns (bool success)
602   {
603     return super.decreaseApproval(_spender, _subtractedValue);
604   }
605 }
606 
607 // File: contracts\TransferableToken.sol
608 
609 /**
610  * @title TransferableToken
611  * @dev Base contract which allows to implement transfer for token.
612  */
613 contract TransferableToken is Ownable {
614   event TransferOn();
615   event TransferOff();
616 
617   bool public transferable = false;
618 
619   /**
620    * @dev Modifier to make a function callable only when the contract is not transferable.
621    */
622   modifier whenNotTransferable() {
623     require(!transferable);
624     _;
625   }
626 
627   /**
628    * @dev Modifier to make a function callable only when the contract is transferable.
629    */
630   modifier whenTransferable() {
631     require(transferable);
632     _;
633   }
634 
635   /**
636    * @dev called by the owner to enable transfers
637    */
638   function transferOn() onlyOwner whenNotTransferable public {
639     transferable = true;
640     emit TransferOn();
641   }
642 
643   /**
644    * @dev called by the owner to disable transfers
645    */
646   function transferOff() onlyOwner whenTransferable public {
647     transferable = false;
648     emit TransferOff();
649   }
650 
651 }
652 
653 // File: contracts\ClinicAllToken.sol
654 
655 //PausableToken, TokenDestructible
656 contract ClinicAllToken is MintableToken, DetailedERC20, CappedToken, BurnableToken, TransferableToken {
657   constructor
658   (
659     string _name,
660     string _symbol,
661     uint8 _decimals,
662     uint256 _cap
663   )
664   DetailedERC20(_name, _symbol, _decimals)
665   CappedToken(_cap)
666   public
667   {
668 
669   }
670 
671   /*/
672   *  Refund event when ICO didn't pass soft cap and we refund ETH to investors + burn ERC-20 tokens from investors balances
673   /*/
674   function burnAfterRefund(address _who) public onlyOwner {
675     uint256 _value = balances[_who];
676     _burn(_who, _value);
677   }
678 
679   /*/
680   *  Allow transfers only if token is transferable
681   /*/
682   function transfer(
683     address _to,
684     uint256 _value
685   )
686   public
687   whenTransferable
688   returns (bool)
689   {
690     return super.transfer(_to, _value);
691   }
692 
693   /*/
694   *  Allow transfers only if token is transferable
695   /*/
696   function transferFrom(
697     address _from,
698     address _to,
699     uint256 _value
700   )
701   public
702   whenTransferable
703   returns (bool)
704   {
705     return super.transferFrom(_from, _to, _value);
706   }
707 
708   function transferToPrivateInvestor(
709     address _from,
710     address _to,
711     uint256 _value
712   )
713   public
714   onlyOwner
715   returns (bool)
716   {
717     require(_to != address(0));
718     require(_value <= balances[_from]);
719 
720     balances[_from] = balances[_from].sub(_value);
721     balances[_to] = balances[_to].add(_value);
722     emit Transfer(_from, _to, _value);
723     return true;
724   }
725 
726   function burnPrivateSale(address privateSaleWallet, uint256 _value) public onlyOwner {
727     _burn(privateSaleWallet, _value);
728   }
729 
730 }