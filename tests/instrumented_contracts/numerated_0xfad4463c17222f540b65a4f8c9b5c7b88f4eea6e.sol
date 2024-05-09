1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 
9 /**
10  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
11  *
12  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
13  */
14 
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66   function totalSupply() public view returns (uint256);
67   function balanceOf(address who) public view returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 
73 contract Recoverable is Ownable {
74 
75   /// @dev Empty constructor (for now)
76   function Recoverable() {
77   }
78 
79   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
80   /// @param token Token which will we rescue to the owner from the contract
81   function recoverTokens(ERC20Basic token) onlyOwner public {
82     token.transfer(owner, tokensToBeReturned(token));
83   }
84 
85   /// @dev Interface function, can be overwritten by the superclass
86   /// @param token Token which balance we will check and return
87   /// @return The amount of tokens (in smallest denominator) the contract owns
88   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
89     return token.balanceOf(this);
90   }
91 }
92 
93 /**
94  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
95  *
96  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
97  */
98 
99 
100 /**
101  * Safe unsigned safe math.
102  *
103  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
104  *
105  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
106  *
107  * Maintained here until merged to mainline zeppelin-solidity.
108  *
109  */
110 library SafeMathLib {
111 
112   function times(uint a, uint b) returns (uint) {
113     uint c = a * b;
114     assert(a == 0 || c / a == b);
115     return c;
116   }
117 
118   function minus(uint a, uint b) returns (uint) {
119     assert(b <= a);
120     return a - b;
121   }
122 
123   function plus(uint a, uint b) returns (uint) {
124     uint c = a + b;
125     assert(c>=a);
126     return c;
127   }
128 
129 }
130 
131 /**
132  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
133  *
134  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
135  */
136 
137 
138 
139 
140 
141 
142 
143 
144 /**
145  * @title SafeMath
146  * @dev Math operations with safety checks that throw on error
147  */
148 library SafeMath {
149 
150   /**
151   * @dev Multiplies two numbers, throws on overflow.
152   */
153   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154     if (a == 0) {
155       return 0;
156     }
157     uint256 c = a * b;
158     assert(c / a == b);
159     return c;
160   }
161 
162   /**
163   * @dev Integer division of two numbers, truncating the quotient.
164   */
165   function div(uint256 a, uint256 b) internal pure returns (uint256) {
166     // assert(b > 0); // Solidity automatically throws when dividing by 0
167     uint256 c = a / b;
168     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169     return c;
170   }
171 
172   /**
173   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
174   */
175   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176     assert(b <= a);
177     return a - b;
178   }
179 
180   /**
181   * @dev Adds two numbers, throws on overflow.
182   */
183   function add(uint256 a, uint256 b) internal pure returns (uint256) {
184     uint256 c = a + b;
185     assert(c >= a);
186     return c;
187   }
188 }
189 
190 
191 
192 /**
193  * @title Basic token
194  * @dev Basic version of StandardToken, with no allowances.
195  */
196 contract BasicToken is ERC20Basic {
197   using SafeMath for uint256;
198 
199   mapping(address => uint256) balances;
200 
201   uint256 totalSupply_;
202 
203   /**
204   * @dev total number of tokens in existence
205   */
206   function totalSupply() public view returns (uint256) {
207     return totalSupply_;
208   }
209 
210   /**
211   * @dev transfer token for a specified address
212   * @param _to The address to transfer to.
213   * @param _value The amount to be transferred.
214   */
215   function transfer(address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[msg.sender]);
218 
219     // SafeMath.sub will throw if there is not enough balance.
220     balances[msg.sender] = balances[msg.sender].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     Transfer(msg.sender, _to, _value);
223     return true;
224   }
225 
226   /**
227   * @dev Gets the balance of the specified address.
228   * @param _owner The address to query the the balance of.
229   * @return An uint256 representing the amount owned by the passed address.
230   */
231   function balanceOf(address _owner) public view returns (uint256 balance) {
232     return balances[_owner];
233   }
234 
235 }
236 
237 
238 
239 
240 
241 /**
242  * @title ERC20 interface
243  * @dev see https://github.com/ethereum/EIPs/issues/20
244  */
245 contract ERC20 is ERC20Basic {
246   function allowance(address owner, address spender) public view returns (uint256);
247   function transferFrom(address from, address to, uint256 value) public returns (bool);
248   function approve(address spender, uint256 value) public returns (bool);
249   event Approval(address indexed owner, address indexed spender, uint256 value);
250 }
251 
252 
253 
254 /**
255  * @title Standard ERC20 token
256  *
257  * @dev Implementation of the basic standard token.
258  * @dev https://github.com/ethereum/EIPs/issues/20
259  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
260  */
261 contract StandardToken is ERC20, BasicToken {
262 
263   mapping (address => mapping (address => uint256)) internal allowed;
264 
265 
266   /**
267    * @dev Transfer tokens from one address to another
268    * @param _from address The address which you want to send tokens from
269    * @param _to address The address which you want to transfer to
270    * @param _value uint256 the amount of tokens to be transferred
271    */
272   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
273     require(_to != address(0));
274     require(_value <= balances[_from]);
275     require(_value <= allowed[_from][msg.sender]);
276 
277     balances[_from] = balances[_from].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
280     Transfer(_from, _to, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286    *
287    * Beware that changing an allowance with this method brings the risk that someone may use both the old
288    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291    * @param _spender The address which will spend the funds.
292    * @param _value The amount of tokens to be spent.
293    */
294   function approve(address _spender, uint256 _value) public returns (bool) {
295     allowed[msg.sender][_spender] = _value;
296     Approval(msg.sender, _spender, _value);
297     return true;
298   }
299 
300   /**
301    * @dev Function to check the amount of tokens that an owner allowed to a spender.
302    * @param _owner address The address which owns the funds.
303    * @param _spender address The address which will spend the funds.
304    * @return A uint256 specifying the amount of tokens still available for the spender.
305    */
306   function allowance(address _owner, address _spender) public view returns (uint256) {
307     return allowed[_owner][_spender];
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    *
313    * approve should be called when allowed[_spender] == 0. To increment
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _addedValue The amount of tokens to increase the allowance by.
319    */
320   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
321     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
322     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326   /**
327    * @dev Decrease the amount of tokens that an owner allowed to a spender.
328    *
329    * approve should be called when allowed[_spender] == 0. To decrement
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _subtractedValue The amount of tokens to decrease the allowance by.
335    */
336   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
337     uint oldValue = allowed[msg.sender][_spender];
338     if (_subtractedValue > oldValue) {
339       allowed[msg.sender][_spender] = 0;
340     } else {
341       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
342     }
343     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
344     return true;
345   }
346 
347 }
348 
349 
350 
351 
352 
353 
354 
355 /**
356    @title ERC827 interface, an extension of ERC20 token standard
357 
358    Interface of a ERC827 token, following the ERC20 standard with extra
359    methods to transfer value and data and execute calls in transfers and
360    approvals.
361  */
362 contract ERC827 is ERC20 {
363 
364   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
365   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
366   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
367 
368 }
369 
370 
371 
372 /**
373    @title ERC827, an extension of ERC20 token standard
374 
375    Implementation the ERC827, following the ERC20 standard with extra
376    methods to transfer value and data and execute calls in transfers and
377    approvals.
378    Uses OpenZeppelin StandardToken.
379  */
380 contract ERC827Token is ERC827, StandardToken {
381 
382   /**
383      @dev Addition to ERC20 token methods. It allows to
384      approve the transfer of value and execute a call with the sent data.
385 
386      Beware that changing an allowance with this method brings the risk that
387      someone may use both the old and the new allowance by unfortunate
388      transaction ordering. One possible solution to mitigate this race condition
389      is to first reduce the spender's allowance to 0 and set the desired value
390      afterwards:
391      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
392 
393      @param _spender The address that will spend the funds.
394      @param _value The amount of tokens to be spent.
395      @param _data ABI-encoded contract call to call `_to` address.
396 
397      @return true if the call function was executed successfully
398    */
399   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
400     require(_spender != address(this));
401 
402     super.approve(_spender, _value);
403 
404     require(_spender.call(_data));
405 
406     return true;
407   }
408 
409   /**
410      @dev Addition to ERC20 token methods. Transfer tokens to a specified
411      address and execute a call with the sent data on the same transaction
412 
413      @param _to address The address which you want to transfer to
414      @param _value uint256 the amout of tokens to be transfered
415      @param _data ABI-encoded contract call to call `_to` address.
416 
417      @return true if the call function was executed successfully
418    */
419   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
420     require(_to != address(this));
421 
422     super.transfer(_to, _value);
423 
424     require(_to.call(_data));
425     return true;
426   }
427 
428   /**
429      @dev Addition to ERC20 token methods. Transfer tokens from one address to
430      another and make a contract call on the same transaction
431 
432      @param _from The address which you want to send tokens from
433      @param _to The address which you want to transfer to
434      @param _value The amout of tokens to be transferred
435      @param _data ABI-encoded contract call to call `_to` address.
436 
437      @return true if the call function was executed successfully
438    */
439   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
440     require(_to != address(this));
441 
442     super.transferFrom(_from, _to, _value);
443 
444     require(_to.call(_data));
445     return true;
446   }
447 
448   /**
449    * @dev Addition to StandardToken methods. Increase the amount of tokens that
450    * an owner allowed to a spender and execute a call with the sent data.
451    *
452    * approve should be called when allowed[_spender] == 0. To increment
453    * allowed value is better to use this function to avoid 2 calls (and wait until
454    * the first transaction is mined)
455    * From MonolithDAO Token.sol
456    * @param _spender The address which will spend the funds.
457    * @param _addedValue The amount of tokens to increase the allowance by.
458    * @param _data ABI-encoded contract call to call `_spender` address.
459    */
460   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
461     require(_spender != address(this));
462 
463     super.increaseApproval(_spender, _addedValue);
464 
465     require(_spender.call(_data));
466 
467     return true;
468   }
469 
470   /**
471    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
472    * an owner allowed to a spender and execute a call with the sent data.
473    *
474    * approve should be called when allowed[_spender] == 0. To decrement
475    * allowed value is better to use this function to avoid 2 calls (and wait until
476    * the first transaction is mined)
477    * From MonolithDAO Token.sol
478    * @param _spender The address which will spend the funds.
479    * @param _subtractedValue The amount of tokens to decrease the allowance by.
480    * @param _data ABI-encoded contract call to call `_spender` address.
481    */
482   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
483     require(_spender != address(this));
484 
485     super.decreaseApproval(_spender, _subtractedValue);
486 
487     require(_spender.call(_data));
488 
489     return true;
490   }
491 
492 }
493 
494 
495 
496 
497 /**
498  * Standard EIP-20 token with an interface marker.
499  *
500  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
501  *
502  */
503 contract StandardTokenExt is StandardToken, ERC827Token, Recoverable {
504 
505   /* Interface declaration */
506   function isToken() public constant returns (bool weAre) {
507     return true;
508   }
509 }
510 
511 
512 
513 /**
514  * Hold tokens for a group investor of investors until the unlock date.
515  *
516  * After the unlock date the investor can claim their tokens.
517  *
518  * Steps
519  *
520  * - Prepare a spreadsheet for token allocation
521  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
522  * - Call setInvestor for all investors from the owner account using a local script and CSV input
523  * - Move tokensToBeAllocated in this contract using StandardToken.transfer()
524  * - Call lock from the owner account
525  * - Wait until the freeze period is over
526  * - After the freeze time is over investors can call claim() from their address to get their tokens
527  *
528  */
529 contract TokenVault is Ownable, Recoverable {
530   using SafeMathLib for uint;
531 
532   /** How many investors we have now */
533   uint public investorCount;
534 
535   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
536   uint public tokensToBeAllocated;
537 
538   /** How many tokens investors have claimed so far */
539   uint public totalClaimed;
540 
541   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
542   uint public tokensAllocatedTotal;
543 
544   /** How much we have allocated to the investors invested */
545   mapping(address => uint) public balances;
546 
547   /** How many tokens investors have claimed */
548   mapping(address => uint) public claimed;
549 
550   /** When our claim freeze is over (UNIX timestamp) */
551   uint public freezeEndsAt;
552 
553   /** When this vault was locked (UNIX timestamp) */
554   uint public lockedAt;
555 
556   /** We can also define our own token, which will override the ICO one ***/
557   StandardTokenExt public token;
558 
559   /** What is our current state.
560    *
561    * Loading: Investor data is being loaded and contract not yet locked
562    * Holding: Holding tokens for investors
563    * Distributing: Freeze time is over, investors can claim their tokens
564    */
565   enum State{Unknown, Loading, Holding, Distributing}
566 
567   /** We allocated tokens for investor */
568   event Allocated(address investor, uint value);
569 
570   /** We distributed tokens to an investor */
571   event Distributed(address investors, uint count);
572 
573   event Locked();
574 
575   /**
576    * Create presale contract where lock up period is given days
577    *
578    * @param _owner Who can load investor data and lock
579    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
580    * @param _token Token contract address we are distributing
581    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
582    *
583    */
584   function TokenVault(address _owner, uint _freezeEndsAt, StandardTokenExt _token, uint _tokensToBeAllocated) {
585 
586     owner = _owner;
587 
588     // Invalid owenr
589     if(owner == 0) {
590       throw;
591     }
592 
593     token = _token;
594 
595     // Check the address looks like a token contract
596     if(!token.isToken()) {
597       throw;
598     }
599 
600     // Give argument
601     if(_freezeEndsAt == 0) {
602       throw;
603     }
604 
605     // Sanity check on _tokensToBeAllocated
606     if(_tokensToBeAllocated == 0) {
607       throw;
608     }
609 
610     freezeEndsAt = _freezeEndsAt;
611     tokensToBeAllocated = _tokensToBeAllocated;
612   }
613 
614   /// @dev Add a presale participating allocation
615   function setInvestor(address investor, uint amount) public onlyOwner {
616 
617     if(lockedAt > 0) {
618       // Cannot add new investors after the vault is locked
619       throw;
620     }
621 
622     if(amount == 0) throw; // No empty buys
623 
624     // Don't allow reset
625     if(balances[investor] > 0) {
626       throw;
627     }
628 
629     balances[investor] = amount;
630 
631     investorCount++;
632 
633     tokensAllocatedTotal += amount;
634 
635     Allocated(investor, amount);
636   }
637 
638   /// @dev Lock the vault
639   ///      - All balances have been loaded in correctly
640   ///      - Tokens are transferred on this vault correctly
641   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
642   function lock() onlyOwner {
643 
644     if(lockedAt > 0) {
645       throw; // Already locked
646     }
647 
648     // Spreadsheet sum does not match to what we have loaded to the investor data
649     if(tokensAllocatedTotal != tokensToBeAllocated) {
650       throw;
651     }
652 
653     // Do not lock the vault if the given tokens are not on this contract
654     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
655       throw;
656     }
657 
658     lockedAt = now;
659 
660     Locked();
661   }
662 
663   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
664   function recoverFailedLock() onlyOwner {
665     if(lockedAt > 0) {
666       throw;
667     }
668 
669     // Transfer all tokens on this contract back to the owner
670     token.transfer(owner, token.balanceOf(address(this)));
671   }
672 
673   /// @dev Get the current balance of tokens in the vault
674   /// @return uint How many tokens there are currently in vault
675   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
676     return token.balanceOf(address(this));
677   }
678 
679   /// @dev Claim N bought tokens to the investor as the msg sender
680   function claim() {
681 
682     address investor = msg.sender;
683 
684     if(lockedAt == 0) {
685       throw; // We were never locked
686     }
687 
688     if(now < freezeEndsAt) {
689       throw; // Trying to claim early
690     }
691 
692     if(balances[investor] == 0) {
693       // Not our investor
694       throw;
695     }
696 
697     if(claimed[investor] > 0) {
698       throw; // Already claimed
699     }
700 
701     uint amount = balances[investor];
702 
703     claimed[investor] = amount;
704 
705     totalClaimed += amount;
706 
707     token.transfer(investor, amount);
708 
709     Distributed(investor, amount);
710   }
711 
712   /// @dev This function is prototyped in Recoverable contract
713   function tokensToBeReturned(ERC20Basic tokenToClaim) public returns (uint) {
714     if (address(tokenToClaim) == address(token)) {
715       return getBalance().minus(tokensAllocatedTotal);
716     } else {
717       return tokenToClaim.balanceOf(this);
718     }
719   }
720 
721   /// @dev Resolve the contract umambigious state
722   function getState() public constant returns(State) {
723     if(lockedAt == 0) {
724       return State.Loading;
725     } else if(now > freezeEndsAt) {
726       return State.Distributing;
727     } else {
728       return State.Holding;
729     }
730   }
731 
732 }