1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.23;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.23;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
125 
126 pragma solidity ^0.4.23;
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender)
136     public view returns (uint256);
137 
138   function transferFrom(address from, address to, uint256 value)
139     public returns (bool);
140 
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
150 
151 pragma solidity ^0.4.23;
152 
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    *
196    * Beware that changing an allowance with this method brings the risk that someone may use both the old
197    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200    * @param _spender The address which will spend the funds.
201    * @param _value The amount of tokens to be spent.
202    */
203   function approve(address _spender, uint256 _value) public returns (bool) {
204     allowed[msg.sender][_spender] = _value;
205     emit Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(
216     address _owner,
217     address _spender
218    )
219     public
220     view
221     returns (uint256)
222   {
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
236   function increaseApproval(
237     address _spender,
238     uint _addedValue
239   )
240     public
241     returns (bool)
242   {
243     allowed[msg.sender][_spender] = (
244       allowed[msg.sender][_spender].add(_addedValue));
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To decrement
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _subtractedValue The amount of tokens to decrease the allowance by.
258    */
259   function decreaseApproval(
260     address _spender,
261     uint _subtractedValue
262   )
263     public
264     returns (bool)
265   {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 // File: contracts/Ownable.sol
279 
280 pragma solidity ^0.4.23;
281 
282 
283 /**
284  * @title Ownable
285  * @dev The Ownable contract has an owner address, and provides basic authorization control
286  * functions, this simplifies the implementation of 'user permissions'.
287  */
288 
289 /// @title Ownable
290 /// @author Applicature
291 /// @notice helper mixed to other contracts to link contract on an owner
292 /// @dev Base class
293 contract Ownable {
294     //Variables
295     address public owner;
296     address public newOwner;
297 
298     //    Modifiers
299     /**
300      * @dev Throws if called by any account other than the owner.
301      */
302     modifier onlyOwner() {
303         require(msg.sender == owner);
304         _;
305     }
306 
307     /**
308      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
309      * account.
310      */
311     constructor() public {
312         owner = msg.sender;
313     }
314 
315     /**
316      * @dev Allows the current owner to transfer control of the contract to a newOwner.
317      * @param _newOwner The address to transfer ownership to.
318      */
319     function transferOwnership(address _newOwner) public onlyOwner {
320         require(_newOwner != address(0));
321         newOwner = _newOwner;
322 
323     }
324 
325     function acceptOwnership() public {
326         if (msg.sender == newOwner) {
327             owner = newOwner;
328         }
329     }
330 }
331 
332 // File: contracts/token/erc20/openzeppelin/OpenZeppelinERC20.sol
333 
334 pragma solidity ^0.4.23;
335 
336 
337 
338 
339 /// @title OpenZeppelinERC20
340 /// @author Applicature
341 /// @notice Open Zeppelin implementation of standart ERC20
342 /// @dev Base class
343 contract OpenZeppelinERC20 is StandardToken, Ownable {
344     using SafeMath for uint256;
345 
346     uint8 public decimals;
347     string public name;
348     string public symbol;
349     string public standard;
350 
351     constructor(
352         uint256 _totalSupply,
353         string _tokenName,
354         uint8 _decimals,
355         string _tokenSymbol,
356         bool _transferAllSupplyToOwner
357     ) public {
358         standard = 'ERC20 0.1';
359         totalSupply_ = _totalSupply;
360 
361         if (_transferAllSupplyToOwner) {
362             balances[msg.sender] = _totalSupply;
363         } else {
364             balances[this] = _totalSupply;
365         }
366 
367         name = _tokenName;
368         // Set the name for display purposes
369         symbol = _tokenSymbol;
370         // Set the symbol for display purposes
371         decimals = _decimals;
372     }
373 
374 }
375 
376 // File: contracts/token/erc20/MintableToken.sol
377 
378 pragma solidity ^0.4.23;
379 
380 
381 
382 
383 
384 /// @title MintableToken
385 /// @author Applicature
386 /// @notice allow to mint tokens
387 /// @dev Base class
388 contract MintableToken is BasicToken, Ownable {
389 
390     using SafeMath for uint256;
391 
392     uint256 public maxSupply;
393     bool public allowedMinting;
394     mapping(address => bool) public mintingAgents;
395     mapping(address => bool) public stateChangeAgents;
396 
397     event Mint(address indexed holder, uint256 tokens);
398 
399     modifier onlyMintingAgents () {
400         require(mintingAgents[msg.sender]);
401         _;
402     }
403 
404     modifier onlyStateChangeAgents () {
405         require(stateChangeAgents[msg.sender]);
406         _;
407     }
408 
409     constructor(uint256 _maxSupply, uint256 _mintedSupply, bool _allowedMinting) public {
410         maxSupply = _maxSupply;
411         totalSupply_ = totalSupply_.add(_mintedSupply);
412         allowedMinting = _allowedMinting;
413         mintingAgents[msg.sender] = true;
414     }
415 
416     /// @notice allow to mint tokens
417     function mint(address _holder, uint256 _tokens) public onlyMintingAgents() {
418         require(allowedMinting == true && totalSupply_.add(_tokens) <= maxSupply);
419 
420         totalSupply_ = totalSupply_.add(_tokens);
421 
422         balances[_holder] = balanceOf(_holder).add(_tokens);
423 
424         if (totalSupply_ == maxSupply) {
425             allowedMinting = false;
426         }
427         emit Mint(_holder, _tokens);
428         emit Transfer(address(0), _holder, _tokens);
429     }
430 
431     /// @notice update allowedMinting flat
432     function disableMinting() public onlyStateChangeAgents() {
433         allowedMinting = false;
434     }
435 
436     /// @notice update minting agent
437     function updateMintingAgent(address _agent, bool _status) public onlyOwner {
438         mintingAgents[_agent] = _status;
439     }
440 
441     /// @notice update state change agent
442     function updateStateChangeAgent(address _agent, bool _status) public onlyOwner {
443         stateChangeAgents[_agent] = _status;
444     }
445 
446     /// @return available tokens
447     function availableTokens() public view returns (uint256 tokens) {
448         return maxSupply.sub(totalSupply_);
449     }
450 }
451 
452 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
453 
454 pragma solidity ^0.4.23;
455 
456 
457 
458 /**
459  * @title Burnable Token
460  * @dev Token that can be irreversibly burned (destroyed).
461  */
462 contract BurnableToken is BasicToken {
463 
464   event Burn(address indexed burner, uint256 value);
465 
466   /**
467    * @dev Burns a specific amount of tokens.
468    * @param _value The amount of token to be burned.
469    */
470   function burn(uint256 _value) public {
471     _burn(msg.sender, _value);
472   }
473 
474   function _burn(address _who, uint256 _value) internal {
475     require(_value <= balances[_who]);
476     // no need to require value <= totalSupply, since that would imply the
477     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
478 
479     balances[_who] = balances[_who].sub(_value);
480     totalSupply_ = totalSupply_.sub(_value);
481     emit Burn(_who, _value);
482     emit Transfer(_who, address(0), _value);
483   }
484 }
485 
486 // File: contracts/token/erc20/MintableBurnableToken.sol
487 
488 pragma solidity ^0.4.23;
489 
490 
491 
492 
493 /// @title MintableBurnableToken
494 /// @author Applicature
495 /// @notice helper mixed to other contracts to burn tokens
496 /// @dev implementation
497 contract MintableBurnableToken is MintableToken, BurnableToken {
498 
499     mapping (address => bool) public burnAgents;
500 
501     modifier onlyBurnAgents () {
502         require(burnAgents[msg.sender]);
503         _;
504     }
505 
506     event Burn(address indexed burner, uint256 value);
507 
508     constructor(
509         uint256 _maxSupply,
510         uint256 _mintedSupply,
511         bool _allowedMinting
512     ) public MintableToken(
513         _maxSupply,
514         _mintedSupply,
515         _allowedMinting
516     ) {
517 
518     }
519 
520     /// @notice update minting agent
521     function updateBurnAgent(address _agent, bool _status) public onlyOwner {
522         burnAgents[_agent] = _status;
523     }
524 
525     function burnByAgent(address _holder, uint256 _tokensToBurn) public onlyBurnAgents() returns (uint256) {
526         if (_tokensToBurn == 0) {
527             _tokensToBurn = balanceOf(_holder);
528         }
529         _burn(_holder, _tokensToBurn);
530 
531         return _tokensToBurn;
532     }
533 
534     function _burn(address _who, uint256 _value) internal {
535         require(_value <= balances[_who]);
536         // no need to require value <= totalSupply, since that would imply the
537         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
538 
539         balances[_who] = balances[_who].sub(_value);
540         totalSupply_ = totalSupply_.sub(_value);
541         maxSupply = maxSupply.sub(_value);
542         emit Burn(_who, _value);
543         emit Transfer(_who, address(0), _value);
544     }
545 }
546 
547 // File: contracts/TimeLocked.sol
548 
549 pragma solidity ^0.4.23;
550 
551 /// @title TimeLocked
552 /// @author Applicature
553 /// @notice helper mixed to other contracts to lock contract on a timestamp
554 /// @dev Base class
555 contract TimeLocked {
556     uint256 public time;
557     mapping(address => bool) public excludedAddresses;
558 
559     modifier isTimeLocked(address _holder, bool _timeLocked) {
560         bool locked = (block.timestamp < time);
561         require(excludedAddresses[_holder] == true || locked == _timeLocked);
562         _;
563     }
564 
565     constructor(uint256 _time) public {
566         time = _time;
567     }
568 
569     function updateExcludedAddress(address _address, bool _status) public;
570 }
571 
572 // File: contracts/token/erc20/TimeLockedToken.sol
573 
574 pragma solidity ^0.4.23;
575 
576 
577 
578 
579 /// @title TimeLockedToken
580 /// @author Applicature
581 /// @notice helper mixed to other contracts to lock contract on a timestamp
582 /// @dev Base class
583 contract TimeLockedToken is TimeLocked, StandardToken {
584 
585     constructor(uint256 _time) public TimeLocked(_time) {}
586 
587     function transfer(address _to, uint256 _tokens) public isTimeLocked(msg.sender, false) returns (bool) {
588         return super.transfer(_to, _tokens);
589     }
590 
591     function transferFrom(
592         address _holder,
593         address _to,
594         uint256 _tokens
595     ) public isTimeLocked(_holder, false) returns (bool) {
596         return super.transferFrom(_holder, _to, _tokens);
597     }
598 }
599 
600 // File: contracts/Howdoo.sol
601 
602 pragma solidity 0.4.24;
603 
604 
605 
606 
607 
608 contract Howdoo is OpenZeppelinERC20, MintableBurnableToken, TimeLockedToken {
609 
610     uint256 public amendCount = 113;
611 
612     constructor(uint256 _unlockTokensTime) public
613     OpenZeppelinERC20(0, 'uDOO', 18, 'uDOO', false)
614     MintableBurnableToken(888888888e18, 0, true)
615     TimeLockedToken(_unlockTokensTime) {
616 
617     }
618 
619     function updateExcludedAddress(address _address, bool _status) public onlyOwner {
620         excludedAddresses[_address] = _status;
621     }
622 
623     function setUnlockTime(uint256 _unlockTokensTime) public onlyStateChangeAgents {
624         time = _unlockTokensTime;
625     }
626 
627     function transfer(address _to, uint256 _tokens) public returns (bool) {
628         return super.transfer(_to, _tokens);
629     }
630 
631     function transferFrom(address _holder, address _to, uint256 _tokens) public returns (bool) {
632         return super.transferFrom(_holder, _to, _tokens);
633     }
634 
635     function migrateBalances(Howdoo _token, address[] _holders) public onlyOwner {
636         uint256 amount;
637 
638         for (uint256 i = 0; i < _holders.length; i++) {
639             amount = _token.balanceOf(_holders[i]);
640 
641             mint(_holders[i], amount);
642         }
643     }
644 
645     function amendBalances(address[] _holders) public onlyOwner {
646         uint256 amount = 302074971158267328898484;
647         for (uint256 i = 0; i < _holders.length; i++) {
648             require(amendCount > 0);
649             amendCount--;
650             totalSupply_ = totalSupply_.sub(amount);
651             balances[_holders[i]] = balances[_holders[i]].sub(amount);
652             emit Transfer(_holders[i], address(0), amount);
653 
654         }
655     }
656 
657 }