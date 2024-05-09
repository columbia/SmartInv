1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
29     // benefit is lost if 'b' is also tested.
30     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31     if (a == 0) {
32       return 0;
33     }
34 
35     c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     // uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return a / b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[msg.sender]);
96 
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender)
121     public view returns (uint256);
122 
123   function transferFrom(address from, address to, uint256 value)
124     public returns (bool);
125 
126   function approve(address spender, uint256 value) public returns (bool);
127   event Approval(
128     address indexed owner,
129     address indexed spender,
130     uint256 value
131   );
132 }
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(
154     address _from,
155     address _to,
156     uint256 _value
157   )
158     public
159     returns (bool)
160   {
161     require(_to != address(0));
162     require(_value <= balances[_from]);
163     require(_value <= allowed[_from][msg.sender]);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168     emit Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(
195     address _owner,
196     address _spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(
216     address _spender,
217     uint _addedValue
218   )
219     public
220     returns (bool)
221   {
222     allowed[msg.sender][_spender] = (
223       allowed[msg.sender][_spender].add(_addedValue));
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    */
294   function renounceOwnership() public onlyOwner {
295     emit OwnershipRenounced(owner);
296     owner = address(0);
297   }
298 
299   /**
300    * @dev Allows the current owner to transfer control of the contract to a newOwner.
301    * @param _newOwner The address to transfer ownership to.
302    */
303   function transferOwnership(address _newOwner) public onlyOwner {
304     _transferOwnership(_newOwner);
305   }
306 
307   /**
308    * @dev Transfers control of the contract to a newOwner.
309    * @param _newOwner The address to transfer ownership to.
310    */
311   function _transferOwnership(address _newOwner) internal {
312     require(_newOwner != address(0));
313     emit OwnershipTransferred(owner, _newOwner);
314     owner = _newOwner;
315   }
316 }
317 
318 
319 /**
320  * @title Mintable token
321  * @dev Simple ERC20 Token example, with mintable token creation
322  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
323  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
324  */
325 contract MintableToken is StandardToken, Ownable {
326   event Mint(address indexed to, uint256 amount);
327   event MintFinished();
328 
329   bool public mintingFinished = false;
330 
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337   modifier hasMintPermission() {
338     require(msg.sender == owner);
339     _;
340   }
341 
342   /**
343    * @dev Function to mint tokens
344    * @param _to The address that will receive the minted tokens.
345    * @param _amount The amount of tokens to mint.
346    * @return A boolean that indicates if the operation was successful.
347    */
348   function mint(
349     address _to,
350     uint256 _amount
351   )
352     hasMintPermission
353     canMint
354     public
355     returns (bool)
356   {
357     totalSupply_ = totalSupply_.add(_amount);
358     balances[_to] = balances[_to].add(_amount);
359     emit Mint(_to, _amount);
360     emit Transfer(address(0), _to, _amount);
361     return true;
362   }
363 
364   /**
365    * @dev Function to stop minting new tokens.
366    * @return True if the operation was successful.
367    */
368   function finishMinting() onlyOwner canMint public returns (bool) {
369     mintingFinished = true;
370     emit MintFinished();
371     return true;
372   }
373 }
374 
375 
376 contract FreezableToken is StandardToken {
377     // freezing chains
378     mapping (bytes32 => uint64) internal chains;
379     // freezing amounts for each chain
380     mapping (bytes32 => uint) internal freezings;
381     // total freezing balance per address
382     mapping (address => uint) internal freezingBalance;
383 
384     event Freezed(address indexed to, uint64 release, uint amount);
385     event Released(address indexed owner, uint amount);
386 
387     /**
388      * @dev Gets the balance of the specified address include freezing tokens.
389      * @param _owner The address to query the the balance of.
390      * @return An uint256 representing the amount owned by the passed address.
391      */
392     function balanceOf(address _owner) public view returns (uint256 balance) {
393         return super.balanceOf(_owner) + freezingBalance[_owner];
394     }
395 
396     /**
397      * @dev Gets the balance of the specified address without freezing tokens.
398      * @param _owner The address to query the the balance of.
399      * @return An uint256 representing the amount owned by the passed address.
400      */
401     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
402         return super.balanceOf(_owner);
403     }
404 
405     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
406         return freezingBalance[_owner];
407     }
408 
409     /**
410      * @dev gets freezing count
411      * @param _addr Address of freeze tokens owner.
412      */
413     function freezingCount(address _addr) public view returns (uint count) {
414         uint64 release = chains[toKey(_addr, 0)];
415         while (release != 0) {
416             count++;
417             release = chains[toKey(_addr, release)];
418         }
419     }
420 
421     /**
422      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
423      * @param _addr Address of freeze tokens owner.
424      * @param _index Freezing portion index. It ordered by release date descending.
425      */
426     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
427         for (uint i = 0; i < _index + 1; i++) {
428             _release = chains[toKey(_addr, _release)];
429             if (_release == 0) {
430                 return;
431             }
432         }
433         _balance = freezings[toKey(_addr, _release)];
434     }
435 
436     /**
437      * @dev freeze your tokens to the specified address.
438      *      Be careful, gas usage is not deterministic,
439      *      and depends on how many freezes _to address already has.
440      * @param _to Address to which token will be freeze.
441      * @param _amount Amount of token to freeze.
442      * @param _until Release date, must be in future.
443      */
444     function freezeTo(address _to, uint _amount, uint64 _until) public {
445         require(_to != address(0));
446         require(_amount <= balances[msg.sender]);
447 
448         balances[msg.sender] = balances[msg.sender].sub(_amount);
449 
450         bytes32 currentKey = toKey(_to, _until);
451         freezings[currentKey] = freezings[currentKey].add(_amount);
452         freezingBalance[_to] = freezingBalance[_to].add(_amount);
453 
454         freeze(_to, _until);
455         emit Transfer(msg.sender, _to, _amount);
456         emit Freezed(_to, _until, _amount);
457     }
458 
459     /**
460      * @dev release first available freezing tokens.
461      */
462     function releaseOnce() public {
463         bytes32 headKey = toKey(msg.sender, 0);
464         uint64 head = chains[headKey];
465         require(head != 0);
466         require(uint64(block.timestamp) > head);
467         bytes32 currentKey = toKey(msg.sender, head);
468 
469         uint64 next = chains[currentKey];
470 
471         uint amount = freezings[currentKey];
472         delete freezings[currentKey];
473 
474         balances[msg.sender] = balances[msg.sender].add(amount);
475         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
476 
477         if (next == 0) {
478             delete chains[headKey];
479         } else {
480             chains[headKey] = next;
481             delete chains[currentKey];
482         }
483         emit Released(msg.sender, amount);
484     }
485 
486     /**
487      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
488      * @return how many tokens was released
489      */
490     function releaseAll() public returns (uint tokens) {
491         uint release;
492         uint balance;
493         (release, balance) = getFreezing(msg.sender, 0);
494         while (release != 0 && block.timestamp > release) {
495             releaseOnce();
496             tokens += balance;
497             (release, balance) = getFreezing(msg.sender, 0);
498         }
499     }
500 
501     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
502         // WISH masc to increase entropy
503         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
504         assembly {
505             result := or(result, mul(_addr, 0x10000000000000000))
506             result := or(result, _release)
507         }
508     }
509 
510     function freeze(address _to, uint64 _until) internal {
511         require(_until > block.timestamp);
512         bytes32 key = toKey(_to, _until);
513         bytes32 parentKey = toKey(_to, uint64(0));
514         uint64 next = chains[parentKey];
515 
516         if (next == 0) {
517             chains[parentKey] = _until;
518             return;
519         }
520 
521         bytes32 nextKey = toKey(_to, next);
522         uint parent;
523 
524         while (next != 0 && _until > next) {
525             parent = next;
526             parentKey = nextKey;
527 
528             next = chains[nextKey];
529             nextKey = toKey(_to, next);
530         }
531 
532         if (_until == next) {
533             return;
534         }
535 
536         if (next != 0) {
537             chains[key] = next;
538         }
539 
540         chains[parentKey] = _until;
541     }
542 }
543 
544 
545 /**
546  * @title Burnable Token
547  * @dev Token that can be irreversibly burned (destroyed).
548  */
549 contract BurnableToken is BasicToken {
550 
551   event Burn(address indexed burner, uint256 value);
552 
553   /**
554    * @dev Burns a specific amount of tokens.
555    * @param _value The amount of token to be burned.
556    */
557   function burn(uint256 _value) public {
558     _burn(msg.sender, _value);
559   }
560 
561   function _burn(address _who, uint256 _value) internal {
562     require(_value <= balances[_who]);
563     // no need to require value <= totalSupply, since that would imply the
564     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
565 
566     balances[_who] = balances[_who].sub(_value);
567     totalSupply_ = totalSupply_.sub(_value);
568     emit Burn(_who, _value);
569     emit Transfer(_who, address(0), _value);
570   }
571 }
572 
573 
574 
575 /**
576  * @title Pausable
577  * @dev Base contract which allows children to implement an emergency stop mechanism.
578  */
579 contract Pausable is Ownable {
580   event Pause();
581   event Unpause();
582 
583   bool public paused = false;
584 
585 
586   /**
587    * @dev Modifier to make a function callable only when the contract is not paused.
588    */
589   modifier whenNotPaused() {
590     require(!paused);
591     _;
592   }
593 
594   /**
595    * @dev Modifier to make a function callable only when the contract is paused.
596    */
597   modifier whenPaused() {
598     require(paused);
599     _;
600   }
601 
602   /**
603    * @dev called by the owner to pause, triggers stopped state
604    */
605   function pause() onlyOwner whenNotPaused public {
606     paused = true;
607     emit Pause();
608   }
609 
610   /**
611    * @dev called by the owner to unpause, returns to normal state
612    */
613   function unpause() onlyOwner whenPaused public {
614     paused = false;
615     emit Unpause();
616   }
617 }
618 
619 
620 contract FreezableMintableToken is FreezableToken, MintableToken {
621     /**
622      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
623      *      Be careful, gas usage is not deterministic,
624      *      and depends on how many freezes _to address already has.
625      * @param _to Address to which token will be freeze.
626      * @param _amount Amount of token to mint and freeze.
627      * @param _until Release date, must be in future.
628      * @return A boolean that indicates if the operation was successful.
629      */
630     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
631         totalSupply_ = totalSupply_.add(_amount);
632 
633         bytes32 currentKey = toKey(_to, _until);
634         freezings[currentKey] = freezings[currentKey].add(_amount);
635         freezingBalance[_to] = freezingBalance[_to].add(_amount);
636 
637         freeze(_to, _until);
638         emit Mint(_to, _amount);
639         emit Freezed(_to, _until, _amount);
640         emit Transfer(msg.sender, _to, _amount);
641         return true;
642     }
643 }
644 
645 
646 
647 contract Consts {
648     uint public constant TOKEN_DECIMALS = 18;
649     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
650     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
651 
652     string public constant TOKEN_NAME = "OnyxToken";
653     string public constant TOKEN_SYMBOL = "ONX";
654     bool public constant PAUSED = false;
655     address public constant TARGET_USER = 0x8ed4A1742efa8126741E8c074727732F5c4246Dd;
656     
657     bool public constant CONTINUE_MINTING = true;
658 }
659 
660 
661 
662 
663 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
664     
665 {
666     
667     event Initialized();
668     bool public initialized = false;
669 
670     constructor() public {
671         init();
672         transferOwnership(TARGET_USER);
673     }
674     
675 
676     function name() public pure returns (string _name) {
677         return TOKEN_NAME;
678     }
679 
680     function symbol() public pure returns (string _symbol) {
681         return TOKEN_SYMBOL;
682     }
683 
684     function decimals() public pure returns (uint8 _decimals) {
685         return TOKEN_DECIMALS_UINT8;
686     }
687 
688     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
689         require(!paused);
690         return super.transferFrom(_from, _to, _value);
691     }
692 
693     function transfer(address _to, uint256 _value) public returns (bool _success) {
694         require(!paused);
695         return super.transfer(_to, _value);
696     }
697 
698     
699     function init() private {
700         require(!initialized);
701         initialized = true;
702 
703         if (PAUSED) {
704             pause();
705         }
706 
707         
708         address[1] memory addresses = [address(0xd14198cdc4ca84f0e24dbc410ffc7ab24d62d8a1)];
709         uint[1] memory amounts = [uint(10000000000000000000000000000)];
710         uint64[1] memory freezes = [uint64(0)];
711 
712         for (uint i = 0; i < addresses.length; i++) {
713             if (freezes[i] == 0) {
714                 mint(addresses[i], amounts[i]);
715             } else {
716                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
717             }
718         }
719         
720 
721         if (!CONTINUE_MINTING) {
722             finishMinting();
723         }
724 
725         emit Initialized();
726     }
727     
728 }