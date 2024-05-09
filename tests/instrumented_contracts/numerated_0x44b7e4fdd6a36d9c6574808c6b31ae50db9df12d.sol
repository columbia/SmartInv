1 /*
2 
3  * CMQA is Reward Token from Crypto Point Hindi 
4  * India's First Reward Token that you can redeem for so many goodies. 
5 * Thanks a Lot for Your Love & Support -  Sandeep B (CPH)
6 
7  */
8 pragma solidity ^0.4.23;
9 
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
35     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (a == 0) {
39       return 0;
40     }
41 
42     c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return a / b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69     c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
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
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender)
128     public view returns (uint256);
129 
130   function transferFrom(address from, address to, uint256 value)
131     public returns (bool);
132 
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(
135     address indexed owner,
136     address indexed spender,
137     uint256 value
138   );
139 }
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151   mapping (address => mapping (address => uint256)) internal allowed;
152 
153 
154   /**
155    * @dev Transfer tokens from one address to another
156    * @param _from address The address which you want to send tokens from
157    * @param _to address The address which you want to transfer to
158    * @param _value uint256 the amount of tokens to be transferred
159    */
160   function transferFrom(
161     address _from,
162     address _to,
163     uint256 _value
164   )
165     public
166     returns (bool)
167   {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     emit Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     emit Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(
202     address _owner,
203     address _spender
204    )
205     public
206     view
207     returns (uint256)
208   {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(
223     address _spender,
224     uint _addedValue
225   )
226     public
227     returns (bool)
228   {
229     allowed[msg.sender][_spender] = (
230       allowed[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(
246     address _spender,
247     uint _subtractedValue
248   )
249     public
250     returns (bool)
251   {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 
265 
266 /**
267  * @title Ownable
268  * @dev The Ownable contract has an owner address, and provides basic authorization control
269  * functions, this simplifies the implementation of "user permissions".
270  */
271 contract Ownable {
272   address public owner;
273 
274 
275   event OwnershipRenounced(address indexed previousOwner);
276   event OwnershipTransferred(
277     address indexed previousOwner,
278     address indexed newOwner
279   );
280 
281 
282   /**
283    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
284    * account.
285    */
286   constructor() public {
287     owner = msg.sender;
288   }
289 
290   /**
291    * @dev Throws if called by any account other than the owner.
292    */
293   modifier onlyOwner() {
294     require(msg.sender == owner);
295     _;
296   }
297 
298   /**
299    * @dev Allows the current owner to relinquish control of the contract.
300    */
301   function renounceOwnership() public onlyOwner {
302     emit OwnershipRenounced(owner);
303     owner = address(0);
304   }
305 
306   /**
307    * @dev Allows the current owner to transfer control of the contract to a newOwner.
308    * @param _newOwner The address to transfer ownership to.
309    */
310   function transferOwnership(address _newOwner) public onlyOwner {
311     _transferOwnership(_newOwner);
312   }
313 
314   /**
315    * @dev Transfers control of the contract to a newOwner.
316    * @param _newOwner The address to transfer ownership to.
317    */
318   function _transferOwnership(address _newOwner) internal {
319     require(_newOwner != address(0));
320     emit OwnershipTransferred(owner, _newOwner);
321     owner = _newOwner;
322   }
323 }
324 
325 
326 /**
327  * @title Mintable token
328  * @dev Simple ERC20 Token example, with mintable token creation
329  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
330  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
331  */
332 contract MintableToken is StandardToken, Ownable {
333   event Mint(address indexed to, uint256 amount);
334   event MintFinished();
335 
336   bool public mintingFinished = false;
337 
338 
339   modifier canMint() {
340     require(!mintingFinished);
341     _;
342   }
343 
344   modifier hasMintPermission() {
345     require(msg.sender == owner);
346     _;
347   }
348 
349   /**
350    * @dev Function to mint tokens
351    * @param _to The address that will receive the minted tokens.
352    * @param _amount The amount of tokens to mint.
353    * @return A boolean that indicates if the operation was successful.
354    */
355   function mint(
356     address _to,
357     uint256 _amount
358   )
359     hasMintPermission
360     canMint
361     public
362     returns (bool)
363   {
364     totalSupply_ = totalSupply_.add(_amount);
365     balances[_to] = balances[_to].add(_amount);
366     emit Mint(_to, _amount);
367     emit Transfer(address(0), _to, _amount);
368     return true;
369   }
370 
371   /**
372    * @dev Function to stop minting new tokens.
373    * @return True if the operation was successful.
374    */
375   function finishMinting() onlyOwner canMint public returns (bool) {
376     mintingFinished = true;
377     emit MintFinished();
378     return true;
379   }
380 }
381 
382 
383 contract FreezableToken is StandardToken {
384     // freezing chains
385     mapping (bytes32 => uint64) internal chains;
386     // freezing amounts for each chain
387     mapping (bytes32 => uint) internal freezings;
388     // total freezing balance per address
389     mapping (address => uint) internal freezingBalance;
390 
391     event Freezed(address indexed to, uint64 release, uint amount);
392     event Released(address indexed owner, uint amount);
393 
394     /**
395      * @dev Gets the balance of the specified address include freezing tokens.
396      * @param _owner The address to query the the balance of.
397      * @return An uint256 representing the amount owned by the passed address.
398      */
399     function balanceOf(address _owner) public view returns (uint256 balance) {
400         return super.balanceOf(_owner) + freezingBalance[_owner];
401     }
402 
403     /**
404      * @dev Gets the balance of the specified address without freezing tokens.
405      * @param _owner The address to query the the balance of.
406      * @return An uint256 representing the amount owned by the passed address.
407      */
408     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
409         return super.balanceOf(_owner);
410     }
411 
412     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
413         return freezingBalance[_owner];
414     }
415 
416     /**
417      * @dev gets freezing count
418      * @param _addr Address of freeze tokens owner.
419      */
420     function freezingCount(address _addr) public view returns (uint count) {
421         uint64 release = chains[toKey(_addr, 0)];
422         while (release != 0) {
423             count++;
424             release = chains[toKey(_addr, release)];
425         }
426     }
427 
428     /**
429      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
430      * @param _addr Address of freeze tokens owner.
431      * @param _index Freezing portion index. It ordered by release date descending.
432      */
433     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
434         for (uint i = 0; i < _index + 1; i++) {
435             _release = chains[toKey(_addr, _release)];
436             if (_release == 0) {
437                 return;
438             }
439         }
440         _balance = freezings[toKey(_addr, _release)];
441     }
442 
443     /**
444      * @dev freeze your tokens to the specified address.
445      *      Be careful, gas usage is not deterministic,
446      *      and depends on how many freezes _to address already has.
447      * @param _to Address to which token will be freeze.
448      * @param _amount Amount of token to freeze.
449      * @param _until Release date, must be in future.
450      */
451     function freezeTo(address _to, uint _amount, uint64 _until) public {
452         require(_to != address(0));
453         require(_amount <= balances[msg.sender]);
454 
455         balances[msg.sender] = balances[msg.sender].sub(_amount);
456 
457         bytes32 currentKey = toKey(_to, _until);
458         freezings[currentKey] = freezings[currentKey].add(_amount);
459         freezingBalance[_to] = freezingBalance[_to].add(_amount);
460 
461         freeze(_to, _until);
462         emit Transfer(msg.sender, _to, _amount);
463         emit Freezed(_to, _until, _amount);
464     }
465 
466     /**
467      * @dev release first available freezing tokens.
468      */
469     function releaseOnce() public {
470         bytes32 headKey = toKey(msg.sender, 0);
471         uint64 head = chains[headKey];
472         require(head != 0);
473         require(uint64(block.timestamp) > head);
474         bytes32 currentKey = toKey(msg.sender, head);
475 
476         uint64 next = chains[currentKey];
477 
478         uint amount = freezings[currentKey];
479         delete freezings[currentKey];
480 
481         balances[msg.sender] = balances[msg.sender].add(amount);
482         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
483 
484         if (next == 0) {
485             delete chains[headKey];
486         } else {
487             chains[headKey] = next;
488             delete chains[currentKey];
489         }
490         emit Released(msg.sender, amount);
491     }
492 
493     /**
494      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
495      * @return how many tokens was released
496      */
497     function releaseAll() public returns (uint tokens) {
498         uint release;
499         uint balance;
500         (release, balance) = getFreezing(msg.sender, 0);
501         while (release != 0 && block.timestamp > release) {
502             releaseOnce();
503             tokens += balance;
504             (release, balance) = getFreezing(msg.sender, 0);
505         }
506     }
507 
508     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
509         // WISH masc to increase entropy
510         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
511         assembly {
512             result := or(result, mul(_addr, 0x10000000000000000))
513             result := or(result, _release)
514         }
515     }
516 
517     function freeze(address _to, uint64 _until) internal {
518         require(_until > block.timestamp);
519         bytes32 key = toKey(_to, _until);
520         bytes32 parentKey = toKey(_to, uint64(0));
521         uint64 next = chains[parentKey];
522 
523         if (next == 0) {
524             chains[parentKey] = _until;
525             return;
526         }
527 
528         bytes32 nextKey = toKey(_to, next);
529         uint parent;
530 
531         while (next != 0 && _until > next) {
532             parent = next;
533             parentKey = nextKey;
534 
535             next = chains[nextKey];
536             nextKey = toKey(_to, next);
537         }
538 
539         if (_until == next) {
540             return;
541         }
542 
543         if (next != 0) {
544             chains[key] = next;
545         }
546 
547         chains[parentKey] = _until;
548     }
549 }
550 
551 
552 /**
553  * @title Burnable Token
554  * @dev Token that can be irreversibly burned (destroyed).
555  */
556 contract BurnableToken is BasicToken {
557 
558   event Burn(address indexed burner, uint256 value);
559 
560   /**
561    * @dev Burns a specific amount of tokens.
562    * @param _value The amount of token to be burned.
563    */
564   function burn(uint256 _value) public {
565     _burn(msg.sender, _value);
566   }
567 
568   function _burn(address _who, uint256 _value) internal {
569     require(_value <= balances[_who]);
570     // no need to require value <= totalSupply, since that would imply the
571     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
572 
573     balances[_who] = balances[_who].sub(_value);
574     totalSupply_ = totalSupply_.sub(_value);
575     emit Burn(_who, _value);
576     emit Transfer(_who, address(0), _value);
577   }
578 }
579 
580 
581 
582 /**
583  * @title Pausable
584  * @dev Base contract which allows children to implement an emergency stop mechanism.
585  */
586 contract Pausable is Ownable {
587   event Pause();
588   event Unpause();
589 
590   bool public paused = false;
591 
592 
593   /**
594    * @dev Modifier to make a function callable only when the contract is not paused.
595    */
596   modifier whenNotPaused() {
597     require(!paused);
598     _;
599   }
600 
601   /**
602    * @dev Modifier to make a function callable only when the contract is paused.
603    */
604   modifier whenPaused() {
605     require(paused);
606     _;
607   }
608 
609   /**
610    * @dev called by the owner to pause, triggers stopped state
611    */
612   function pause() onlyOwner whenNotPaused public {
613     paused = true;
614     emit Pause();
615   }
616 
617   /**
618    * @dev called by the owner to unpause, returns to normal state
619    */
620   function unpause() onlyOwner whenPaused public {
621     paused = false;
622     emit Unpause();
623   }
624 }
625 
626 
627 contract FreezableMintableToken is FreezableToken, MintableToken {
628     /**
629      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
630      *      Be careful, gas usage is not deterministic,
631      *      and depends on how many freezes _to address already has.
632      * @param _to Address to which token will be freeze.
633      * @param _amount Amount of token to mint and freeze.
634      * @param _until Release date, must be in future.
635      * @return A boolean that indicates if the operation was successful.
636      */
637     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
638         totalSupply_ = totalSupply_.add(_amount);
639 
640         bytes32 currentKey = toKey(_to, _until);
641         freezings[currentKey] = freezings[currentKey].add(_amount);
642         freezingBalance[_to] = freezingBalance[_to].add(_amount);
643 
644         freeze(_to, _until);
645         emit Mint(_to, _amount);
646         emit Freezed(_to, _until, _amount);
647         emit Transfer(msg.sender, _to, _amount);
648         return true;
649     }
650 }
651 
652 
653 
654 contract Consts {
655     uint public constant TOKEN_DECIMALS = 4;
656     uint8 public constant TOKEN_DECIMALS_UINT8 = 4;
657     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
658 
659     string public constant TOKEN_NAME = "CPH MQA";
660     string public constant TOKEN_SYMBOL = "CMQA";
661     bool public constant PAUSED = false;
662     address public constant TARGET_USER = 0x3ebe8A051dE462Effd29d485b7a7dA2B5C918106;
663     
664     bool public constant CONTINUE_MINTING = false;
665 }
666 
667 
668 
669 
670 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
671     
672 {
673     
674     event Initialized();
675     bool public initialized = false;
676 
677     constructor() public {
678         init();
679         transferOwnership(TARGET_USER);
680     }
681     
682 
683     function name() public pure returns (string _name) {
684         return TOKEN_NAME;
685     }
686 
687     function symbol() public pure returns (string _symbol) {
688         return TOKEN_SYMBOL;
689     }
690 
691     function decimals() public pure returns (uint8 _decimals) {
692         return TOKEN_DECIMALS_UINT8;
693     }
694 
695     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
696         require(!paused);
697         return super.transferFrom(_from, _to, _value);
698     }
699 
700     function transfer(address _to, uint256 _value) public returns (bool _success) {
701         require(!paused);
702         return super.transfer(_to, _value);
703     }
704 
705     
706     function init() private {
707         require(!initialized);
708         initialized = true;
709 
710         if (PAUSED) {
711             pause();
712         }
713 
714         
715         address[1] memory addresses = [address(0x3ebe8a051de462effd29d485b7a7da2b5c918106)];
716         uint[1] memory amounts = [uint(1000000000000)];
717         uint64[1] memory freezes = [uint64(0)];
718 
719         for (uint i = 0; i < addresses.length; i++) {
720             if (freezes[i] == 0) {
721                 mint(addresses[i], amounts[i]);
722             } else {
723                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
724             }
725         }
726         
727 
728         if (!CONTINUE_MINTING) {
729             finishMinting();
730         }
731 
732         emit Initialized();
733     }
734     
735 }