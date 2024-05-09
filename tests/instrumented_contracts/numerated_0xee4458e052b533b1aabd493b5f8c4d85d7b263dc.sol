1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   uint256 totalSupply_;
66 
67   /**
68   * @dev total number of tokens in existence
69   */
70   function totalSupply() public view returns (uint256) {
71     return totalSupply_;
72   }
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     require(_value <= balances[msg.sender]);
82 
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     emit Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public view returns (uint256) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implementation of the basic standard token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is ERC20, BasicToken {
123 
124   mapping (address => mapping (address => uint256)) internal allowed;
125 
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     emit Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     emit Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address _owner, address _spender) public view returns (uint256) {
168     return allowed[_owner][_spender];
169   }
170 
171   /**
172    * @dev Increase the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _addedValue The amount of tokens to increase the allowance by.
180    */
181   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
182     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187   /**
188    * @dev Decrease the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To decrement
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _subtractedValue The amount of tokens to decrease the allowance by.
196    */
197   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
198     uint oldValue = allowed[msg.sender][_spender];
199     if (_subtractedValue > oldValue) {
200       allowed[msg.sender][_spender] = 0;
201     } else {
202       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
203     }
204     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208 }
209 
210 
211 
212 
213 
214 
215 
216 /**
217  * @title Pausable
218  * @dev Base contract which allows children to implement an emergency stop mechanism.
219  */
220 contract Pausable is Ownable {
221   event Pause();
222   event Unpause();
223 
224   bool public paused = false;
225 
226 
227   /**
228    * @dev Modifier to make a function callable only when the contract is not paused.
229    */
230   modifier whenNotPaused() {
231     require(!paused);
232     _;
233   }
234 
235   /**
236    * @dev Modifier to make a function callable only when the contract is paused.
237    */
238   modifier whenPaused() {
239     require(paused);
240     _;
241   }
242 
243   /**
244    * @dev called by the owner to pause, triggers stopped state
245    */
246   function pause() onlyOwner whenNotPaused public {
247     paused = true;
248     emit Pause();
249   }
250 
251   /**
252    * @dev called by the owner to unpause, returns to normal state
253    */
254   function unpause() onlyOwner whenPaused public {
255     paused = false;
256     emit Unpause();
257   }
258 }
259 
260 
261 
262 /**
263  * @title Pausable token
264  * @dev StandardToken modified with pausable transfers.
265  **/
266 contract PausableToken is StandardToken, Pausable {
267 
268   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
269     return super.transfer(_to, _value);
270   }
271 
272   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
273     return super.transferFrom(_from, _to, _value);
274   }
275 
276   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
277     return super.approve(_spender, _value);
278   }
279 
280   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
281     return super.increaseApproval(_spender, _addedValue);
282   }
283 
284   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
285     return super.decreaseApproval(_spender, _subtractedValue);
286   }
287 }
288 
289 
290 
291 
292 
293 
294 
295 /**
296  * @title Mintable token
297  * @dev Simple ERC20 Token example, with mintable token creation
298  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
299  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
300  */
301 contract MintableToken is StandardToken, Ownable {
302   event Mint(address indexed to, uint256 amount);
303   event MintFinished();
304 
305   bool public mintingFinished = false;
306 
307 
308   modifier canMint() {
309     require(!mintingFinished);
310     _;
311   }
312 
313   /**
314    * @dev Function to mint tokens
315    * @param _to The address that will receive the minted tokens.
316    * @param _amount The amount of tokens to mint.
317    * @return A boolean that indicates if the operation was successful.
318    */
319   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
320     totalSupply_ = totalSupply_.add(_amount);
321     balances[_to] = balances[_to].add(_amount);
322     emit Mint(_to, _amount);
323     emit Transfer(address(0), _to, _amount);
324     return true;
325   }
326 
327   /**
328    * @dev Function to stop minting new tokens.
329    * @return True if the operation was successful.
330    */
331   function finishMinting() onlyOwner canMint public returns (bool) {
332     mintingFinished = true;
333     emit MintFinished();
334     return true;
335   }
336 }
337 
338 
339 
340 
341 
342 
343 
344 
345 
346 
347 
348 
349 contract DetailedERC20 is ERC20 {
350   string public name;
351   string public symbol;
352   uint8 public decimals;
353 
354   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
355     name = _name;
356     symbol = _symbol;
357     decimals = _decimals;
358   }
359 }
360 
361 
362 
363 
364 
365 
366 
367 
368 
369 
370 
371 
372 
373 
374 /**
375  * @title Burnable Token
376  * @dev Token that can be irreversibly burned (destroyed).
377  */
378 contract BurnableToken is BasicToken {
379 
380   event Burn(address indexed burner, uint256 value);
381 
382   /**
383    * @dev Burns a specific amount of tokens.
384    * @param _value The amount of token to be burned.
385    */
386   function burn(uint256 _value) public {
387     _burn(msg.sender, _value);
388   }
389 
390   function _burn(address _who, uint256 _value) internal {
391     require(_value <= balances[_who]);
392     // no need to require value <= totalSupply, since that would imply the
393     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
394 
395     balances[_who] = balances[_who].sub(_value);
396     totalSupply_ = totalSupply_.sub(_value);
397     emit Burn(_who, _value);
398     emit Transfer(_who, address(0), _value);
399   }
400 }
401 
402 
403 
404 
405 
406 
407 
408 /**
409  * @title Whitelist
410  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
411  * @dev This simplifies the implementation of "user permissions".
412  */
413 contract Whitelist is Ownable {
414   mapping(address => bool) public whitelist;
415 
416   event WhitelistedAddressAdded(address addr);
417   event WhitelistedAddressRemoved(address addr);
418 
419   /**
420    * @dev Throws if called by any account that's not whitelisted.
421    */
422   modifier onlyWhitelisted() {
423     require(whitelist[msg.sender]);
424     _;
425   }
426 
427   /**
428    * @dev add an address to the whitelist
429    * @param addr address
430    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
431    */
432   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
433     if (!whitelist[addr]) {
434       whitelist[addr] = true;
435       emit WhitelistedAddressAdded(addr);
436       success = true;
437     }
438   }
439 
440   /**
441    * @dev add addresses to the whitelist
442    * @param addrs addresses
443    * @return true if at least one address was added to the whitelist,
444    * false if all addresses were already in the whitelist
445    */
446   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
447     for (uint256 i = 0; i < addrs.length; i++) {
448       if (addAddressToWhitelist(addrs[i])) {
449         success = true;
450       }
451     }
452   }
453 
454   /**
455    * @dev remove an address from the whitelist
456    * @param addr address
457    * @return true if the address was removed from the whitelist,
458    * false if the address wasn't in the whitelist in the first place
459    */
460   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
461     if (whitelist[addr]) {
462       whitelist[addr] = false;
463       emit WhitelistedAddressRemoved(addr);
464       success = true;
465     }
466   }
467 
468   /**
469    * @dev remove addresses from the whitelist
470    * @param addrs addresses
471    * @return true if at least one address was removed from the whitelist,
472    * false if all addresses weren't in the whitelist in the first place
473    */
474   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
475     for (uint256 i = 0; i < addrs.length; i++) {
476       if (removeAddressFromWhitelist(addrs[i])) {
477         success = true;
478       }
479     }
480   }
481 
482 }
483 
484 
485 
486 
487 /**
488  * @title SafeMath
489  * @dev Math operations with safety checks that throw on error
490  */
491 library SafeMath {
492 
493   /**
494   * @dev Multiplies two numbers, throws on overflow.
495   */
496   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
497     if (a == 0) {
498       return 0;
499     }
500     c = a * b;
501     assert(c / a == b);
502     return c;
503   }
504 
505   /**
506   * @dev Integer division of two numbers, truncating the quotient.
507   */
508   function div(uint256 a, uint256 b) internal pure returns (uint256) {
509     // assert(b > 0); // Solidity automatically throws when dividing by 0
510     // uint256 c = a / b;
511     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
512     return a / b;
513   }
514 
515   /**
516   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
517   */
518   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
519     assert(b <= a);
520     return a - b;
521   }
522 
523   /**
524   * @dev Adds two numbers, throws on overflow.
525   */
526   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
527     c = a + b;
528     assert(c >= a);
529     return c;
530   }
531 }
532 
533 
534 
535 contract Operable is Pausable {
536     mapping (address => bool) operators;
537 
538     constructor()
539     {
540     }
541 
542     modifier isOwnerOrOperator() {
543         require(msg.sender == owner || operators[msg.sender] == true);
544         _;
545     }
546 
547     event OperatorAdded(address operatorAddr);
548     event OperatorUpdated(address operatorAddr);
549     event OperatorRemoved(address operatorAddr);
550 
551     // Only add if msg is not operator
552     function addOperator(address operatorAddr) onlyOwner {
553         require(operators[operatorAddr] == false);
554         operators[operatorAddr] = true;
555         emit OperatorAdded(operatorAddr);
556     }
557     // Only remove if msg is operator
558     function removeOperator(address operatorAddr) onlyOwner {
559         require(operators[operatorAddr] == true);
560         delete operators[operatorAddr];
561         emit OperatorRemoved(operatorAddr);
562     }
563 
564     function checkOperator(address addr) view returns (bool) {
565         return operators[addr];
566     }
567 
568     function checkPause() view returns (bool){
569         return paused;
570     }
571 }
572 
573 contract Pass1 is DetailedERC20, PausableToken, BurnableToken, MintableToken, Operable, Whitelist
574 {
575 
576     using SafeMath for uint256;
577 
578     MintableToken public newToken = MintableToken(0x0);
579 
580     /*
581     * @dev will be triggered every time a user mints his current token to the upgraded one
582     * @param beneficiary receiving address
583     * amount amount of token to be minted
584     */
585     event LogMint(address beneficiary, uint256 amount);
586 
587     /*
588     * @dev checks if an upgraded version of Pass token contract is available
589     * @return true new upgrade token is setup
590     * exception otherwise
591     */
592     modifier hasUpgrade() {
593         require(newToken != MintableToken(0x0));
594         _;
595     }
596 
597     /*
598     * @dev initialize default attributes for the Pass token contract
599     */
600     constructor()
601         DetailedERC20 ("Blockpass","PASS",6)
602     {
603         owner = msg.sender;
604         emit OwnershipTransferred(address(0x0), owner);
605         // initial token amount is 10^9 (1 billion), divisible to 6 decimals
606         totalSupply_ = 1000000000000000;
607         balances[owner] = totalSupply_;
608         emit Transfer(address(0x0), owner, 1000000000000000);
609         whitelist[owner] = true;
610         emit WhitelistedAddressAdded(owner);
611     }
612 
613     /*
614     * @dev assign address of the new Pass token contract, can only be triggered by owner address
615     * @param _newToken address of the new Token contract
616     * @return none
617     */
618     function upgrade(MintableToken _newToken)
619         onlyOwner
620         public
621     {
622         newToken = _newToken;
623     }
624 
625     /*
626     * @dev override from BurnableToken
627     * @param _value amount of token to burn
628     * @return exception to prevent calling directly to Pass1 token
629     */
630     function burn(uint256 _value)
631         public
632     {
633         revert();
634         _value = _value; // to silence compiler warning
635     }
636 
637     /*
638     * @dev override from MintableToken
639     * @param _to address of receivers
640     * _amount amount of token to redeem to
641     * @return exception to prevent calling directly to Pass1 token
642     */
643     function mint(address _to, uint256 _amount)
644         onlyOwner
645         canMint
646         public
647         returns (bool)
648     {
649         revert();
650         return true;
651     }
652 
653     /*
654     * @dev allow whitelisted user to redeem his Pass1 token to a newer version of the token
655     * can only be triggered if there's a newer version of Pass token, and when the contract is pause
656     * @param none
657     * @return none
658     */
659     function mintTo()
660         hasUpgrade
661         whenPaused
662         onlyWhitelisted
663         public
664     {
665         uint256 balance = balanceOf(msg.sender);
666 
667         // burn the tokens in this token smart contract
668         super.burn(balance);
669 
670         // mint tokens in the new token smart contract
671         require(newToken.mint(msg.sender, balance));
672         emit LogMint(msg.sender, balance);
673     }
674 
675     /*
676     * @dev transfer ownership of token between whitelisted accounts
677     * can only be triggered when contract is not paused
678     * @param _to address of receiver
679     * _value amount to token to transfer
680     * @return true if transfer succeeds
681     * false if not enough gas is provided, or if _value is larger than current user balance
682     */
683     function transfer(address _to, uint256 _value)
684         whenNotPaused
685         onlyWhitelisted
686         public
687         returns (bool success)
688     {
689         return super.transfer(_to, _value);
690     }
691 
692     /*
693     * @dev transfer ownership of token on behalf of one whitelisted account address to another
694     * can only be triggered when contract is not paused
695     * @param _from sending address
696     * _to receiving address
697     * _value amount of token to transfer
698     * @return true if transfer succeeds
699     * false if not enough gas is provided, or if _value is larger than maximum allowance / user balance
700     */
701     function transferFrom(address _from, address _to, uint256 _value)
702         whenNotPaused
703         public
704         returns (bool success)
705     {
706         require(whitelist[_from] == true);
707         return super.transferFrom(_from, _to, _value);
708     }
709 
710     /*
711     * @dev check if the specified address is in the contract whitelist
712     * @param _addr user address
713     * @return true if user address is in whitelist
714     * false otherwise
715     */
716     function checkUserWhiteList(address addr)
717         view
718         public
719         returns (bool)
720     {
721         return whitelist[addr];
722     }
723 
724     /*
725     * @dev add an user address to the contract whitelist
726     * override from WhiteList contract to allow calling from owner or operators addresses
727     * @param addr address to be added
728     * @return true if address is successfully added
729     * false if address is already in the whitelist
730     */
731     function addAddressToWhitelist(address addr)
732         isOwnerOrOperator
733         public
734         returns(bool)
735     {
736         if (!whitelist[addr]) {
737             whitelist[addr] = true;
738             emit WhitelistedAddressAdded(addr);
739             return true;
740         }
741         return false;
742     }
743 
744     /**
745     * @dev add addresses to the whitelist
746     * override from WhiteList contract to allow calling from owner or operators addresses
747     * @param addrs addresses
748     * @return true if at least one address was added to the whitelist,
749     * false if all addresses were already in the whitelist
750     */
751     function addAddressesToWhitelist(address[] addrs)
752         isOwnerOrOperator
753         public
754         returns(bool success)
755     {
756         for (uint256 i = 0; i < addrs.length; i++) {
757             if (addAddressToWhitelist(addrs[i])) {
758                 success = true;
759             }
760         }
761     }
762 
763     /**
764     * @dev remove an address from the whitelist
765     * override from WhiteList contract to allow calling from owner or operators addresses
766     * @param addr address
767     * @return true if the address was removed from the whitelist,
768     * false if the address wasn't in the whitelist in the first place
769     */
770     function removeAddressFromWhitelist(address addr)
771         isOwnerOrOperator
772         public
773         returns(bool success)
774     {
775         require(addr != owner);
776         if (whitelist[addr]) {
777             whitelist[addr] = false;
778             emit WhitelistedAddressRemoved(addr);
779             success = true;
780         }
781     }
782 
783     /**
784     * @dev remove addresses from the whitelist
785     * override from WhiteList contract to allow calling from owner or operators addresses
786     * @param addrs addresses
787     * @return true if at least one address was removed from the whitelist,
788     * false if all addresses weren't in the whitelist in the first place
789     */
790     function removeAddressesFromWhitelist(address[] addrs)
791         isOwnerOrOperator
792         public
793         returns(bool success)
794     {
795         for (uint256 i = 0; i < addrs.length; i++) {
796             if (removeAddressFromWhitelist(addrs[i])) {
797                 success = true;
798             }
799         }
800     }
801 }