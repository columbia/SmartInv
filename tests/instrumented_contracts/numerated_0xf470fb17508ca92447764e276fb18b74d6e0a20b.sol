1 /**
2 pragma solidity ^0.4.23;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender)
122     public view returns (uint256);
123 
124   function transferFrom(address from, address to, uint256 value)
125     public returns (bool);
126 
127   function approve(address spender, uint256 value) public returns (bool);
128   event Approval(
129     address indexed owner,
130     address indexed spender,
131     uint256 value
132   );
133 }
134 
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20, BasicToken {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(
155     address _from,
156     address _to,
157     uint256 _value
158   )
159     public
160     returns (bool)
161   {
162     require(_to != address(0));
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     emit Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     emit Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(
196     address _owner,
197     address _spender
198    )
199     public
200     view
201     returns (uint256)
202   {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    *
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(
240     address _spender,
241     uint _subtractedValue
242   )
243     public
244     returns (bool)
245   {
246     uint oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue > oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 
259 
260 /**
261  * @title Ownable
262  * @dev The Ownable contract has an owner address, and provides basic authorization control
263  * functions, this simplifies the implementation of "user permissions".
264  */
265 contract Ownable {
266   address public owner;
267 
268 
269   event OwnershipRenounced(address indexed previousOwner);
270   event OwnershipTransferred(
271     address indexed previousOwner,
272     address indexed newOwner
273   );
274 
275 
276   /**
277    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
278    * account.
279    */
280   constructor() public {
281     owner = msg.sender;
282   }
283 
284   /**
285    * @dev Throws if called by any account other than the owner.
286    */
287   modifier onlyOwner() {
288     require(msg.sender == owner);
289     _;
290   }
291 
292   /**
293    * @dev Allows the current owner to relinquish control of the contract.
294    */
295   function renounceOwnership() public onlyOwner {
296     emit OwnershipRenounced(owner);
297     owner = address(0);
298   }
299 
300   /**
301    * @dev Allows the current owner to transfer control of the contract to a newOwner.
302    * @param _newOwner The address to transfer ownership to.
303    */
304   function transferOwnership(address _newOwner) public onlyOwner {
305     _transferOwnership(_newOwner);
306   }
307 
308   /**
309    * @dev Transfers control of the contract to a newOwner.
310    * @param _newOwner The address to transfer ownership to.
311    */
312   function _transferOwnership(address _newOwner) internal {
313     require(_newOwner != address(0));
314     emit OwnershipTransferred(owner, _newOwner);
315     owner = _newOwner;
316   }
317 }
318 
319 
320 /**
321  * @title Mintable token
322  * @dev Simple ERC20 Token example, with mintable token creation
323  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
324  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
325  */
326 contract MintableToken is StandardToken, Ownable {
327   event Mint(address indexed to, uint256 amount);
328   event MintFinished();
329 
330   bool public mintingFinished = false;
331 
332 
333   modifier canMint() {
334     require(!mintingFinished);
335     _;
336   }
337 
338   modifier hasMintPermission() {
339     require(msg.sender == owner);
340     _;
341   }
342 
343   /**
344    * @dev Function to mint tokens
345    * @param _to The address that will receive the minted tokens.
346    * @param _amount The amount of tokens to mint.
347    * @return A boolean that indicates if the operation was successful.
348    */
349   function mint(
350     address _to,
351     uint256 _amount
352   )
353     hasMintPermission
354     canMint
355     public
356     returns (bool)
357   {
358     totalSupply_ = totalSupply_.add(_amount);
359     balances[_to] = balances[_to].add(_amount);
360     emit Mint(_to, _amount);
361     emit Transfer(address(0), _to, _amount);
362     return true;
363   }
364 
365   /**
366    * @dev Function to stop minting new tokens.
367    * @return True if the operation was successful.
368    */
369   function finishMinting() onlyOwner canMint public returns (bool) {
370     mintingFinished = true;
371     emit MintFinished();
372     return true;
373   }
374 }
375 
376 
377 contract FreezableToken is StandardToken {
378     // freezing chains
379     mapping (bytes32 => uint64) internal chains;
380     // freezing amounts for each chain
381     mapping (bytes32 => uint) internal freezings;
382     // total freezing balance per address
383     mapping (address => uint) internal freezingBalance;
384 
385     event Freezed(address indexed to, uint64 release, uint amount);
386     event Released(address indexed owner, uint amount);
387 
388     /**
389      * @dev Gets the balance of the specified address include freezing tokens.
390      * @param _owner The address to query the the balance of.
391      * @return An uint256 representing the amount owned by the passed address.
392      */
393     function balanceOf(address _owner) public view returns (uint256 balance) {
394         return super.balanceOf(_owner) + freezingBalance[_owner];
395     }
396 
397     /**
398      * @dev Gets the balance of the specified address without freezing tokens.
399      * @param _owner The address to query the the balance of.
400      * @return An uint256 representing the amount owned by the passed address.
401      */
402     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
403         return super.balanceOf(_owner);
404     }
405 
406     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
407         return freezingBalance[_owner];
408     }
409 
410     /**
411      * @dev gets freezing count
412      * @param _addr Address of freeze tokens owner.
413      */
414     function freezingCount(address _addr) public view returns (uint count) {
415         uint64 release = chains[toKey(_addr, 0)];
416         while (release != 0) {
417             count++;
418             release = chains[toKey(_addr, release)];
419         }
420     }
421 
422     /**
423      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
424      * @param _addr Address of freeze tokens owner.
425      * @param _index Freezing portion index. It ordered by release date descending.
426      */
427     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
428         for (uint i = 0; i < _index + 1; i++) {
429             _release = chains[toKey(_addr, _release)];
430             if (_release == 0) {
431                 return;
432             }
433         }
434         _balance = freezings[toKey(_addr, _release)];
435     }
436 
437     /**
438      * @dev freeze your tokens to the specified address.
439      *      Be careful, gas usage is not deterministic,
440      *      and depends on how many freezes _to address already has.
441      * @param _to Address to which token will be freeze.
442      * @param _amount Amount of token to freeze.
443      * @param _until Release date, must be in future.
444      */
445     function freezeTo(address _to, uint _amount, uint64 _until) public {
446         require(_to != address(0));
447         require(_amount <= balances[msg.sender]);
448 
449         balances[msg.sender] = balances[msg.sender].sub(_amount);
450 
451         bytes32 currentKey = toKey(_to, _until);
452         freezings[currentKey] = freezings[currentKey].add(_amount);
453         freezingBalance[_to] = freezingBalance[_to].add(_amount);
454 
455         freeze(_to, _until);
456         emit Transfer(msg.sender, _to, _amount);
457         emit Freezed(_to, _until, _amount);
458     }
459 
460     /**
461      * @dev release first available freezing tokens.
462      */
463     function releaseOnce() public {
464         bytes32 headKey = toKey(msg.sender, 0);
465         uint64 head = chains[headKey];
466         require(head != 0);
467         require(uint64(block.timestamp) > head);
468         bytes32 currentKey = toKey(msg.sender, head);
469 
470         uint64 next = chains[currentKey];
471 
472         uint amount = freezings[currentKey];
473         delete freezings[currentKey];
474 
475         balances[msg.sender] = balances[msg.sender].add(amount);
476         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
477 
478         if (next == 0) {
479             delete chains[headKey];
480         } else {
481             chains[headKey] = next;
482             delete chains[currentKey];
483         }
484         emit Released(msg.sender, amount);
485     }
486 
487     /**
488      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
489      * @return how many tokens was released
490      */
491     function releaseAll() public returns (uint tokens) {
492         uint release;
493         uint balance;
494         (release, balance) = getFreezing(msg.sender, 0);
495         while (release != 0 && block.timestamp > release) {
496             releaseOnce();
497             tokens += balance;
498             (release, balance) = getFreezing(msg.sender, 0);
499         }
500     }
501 
502     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
503         // WISH masc to increase entropy
504         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
505         assembly {
506             result := or(result, mul(_addr, 0x10000000000000000))
507             result := or(result, _release)
508         }
509     }
510 
511     function freeze(address _to, uint64 _until) internal {
512         require(_until > block.timestamp);
513         bytes32 key = toKey(_to, _until);
514         bytes32 parentKey = toKey(_to, uint64(0));
515         uint64 next = chains[parentKey];
516 
517         if (next == 0) {
518             chains[parentKey] = _until;
519             return;
520         }
521 
522         bytes32 nextKey = toKey(_to, next);
523         uint parent;
524 
525         while (next != 0 && _until > next) {
526             parent = next;
527             parentKey = nextKey;
528 
529             next = chains[nextKey];
530             nextKey = toKey(_to, next);
531         }
532 
533         if (_until == next) {
534             return;
535         }
536 
537         if (next != 0) {
538             chains[key] = next;
539         }
540 
541         chains[parentKey] = _until;
542     }
543 }
544 
545 
546 /**
547  * @title Burnable Token
548  * @dev Token that can be irreversibly burned (destroyed).
549  */
550 contract BurnableToken is BasicToken {
551 
552   event Burn(address indexed burner, uint256 value);
553 
554   /**
555    * @dev Burns a specific amount of tokens.
556    * @param _value The amount of token to be burned.
557    */
558   function burn(uint256 _value) public {
559     _burn(msg.sender, _value);
560   }
561 
562   function _burn(address _who, uint256 _value) internal {
563     require(_value <= balances[_who]);
564     // no need to require value <= totalSupply, since that would imply the
565     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
566 
567     balances[_who] = balances[_who].sub(_value);
568     totalSupply_ = totalSupply_.sub(_value);
569     emit Burn(_who, _value);
570     emit Transfer(_who, address(0), _value);
571   }
572 }
573 
574 
575 
576 /**
577  * @title Pausable
578  * @dev Base contract which allows children to implement an emergency stop mechanism.
579  */
580 contract Pausable is Ownable {
581   event Pause();
582   event Unpause();
583 
584   bool public paused = false;
585 
586 
587   /**
588    * @dev Modifier to make a function callable only when the contract is not paused.
589    */
590   modifier whenNotPaused() {
591     require(!paused);
592     _;
593   }
594 
595   /**
596    * @dev Modifier to make a function callable only when the contract is paused.
597    */
598   modifier whenPaused() {
599     require(paused);
600     _;
601   }
602 
603   /**
604    * @dev called by the owner to pause, triggers stopped state
605    */
606   function pause() onlyOwner whenNotPaused public {
607     paused = true;
608     emit Pause();
609   }
610 
611   /**
612    * @dev called by the owner to unpause, returns to normal state
613    */
614   function unpause() onlyOwner whenPaused public {
615     paused = false;
616     emit Unpause();
617   }
618 }
619 
620 
621 contract FreezableMintableToken is FreezableToken, MintableToken {
622     /**
623      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
624      *      Be careful, gas usage is not deterministic,
625      *      and depends on how many freezes _to address already has.
626      * @param _to Address to which token will be freeze.
627      * @param _amount Amount of token to mint and freeze.
628      * @param _until Release date, must be in future.
629      * @return A boolean that indicates if the operation was successful.
630      */
631     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
632         totalSupply_ = totalSupply_.add(_amount);
633 
634         bytes32 currentKey = toKey(_to, _until);
635         freezings[currentKey] = freezings[currentKey].add(_amount);
636         freezingBalance[_to] = freezingBalance[_to].add(_amount);
637 
638         freeze(_to, _until);
639         emit Mint(_to, _amount);
640         emit Freezed(_to, _until, _amount);
641         emit Transfer(msg.sender, _to, _amount);
642         return true;
643     }
644 }
645 
646 
647 
648 contract Consts {
649     uint public constant TOKEN_DECIMALS = 18;
650     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
651     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
652 
653     string public constant TOKEN_NAME = "EQUOS";
654     string public constant TOKEN_SYMBOL = "eQUOS";
655     bool public constant PAUSED = false;
656     address public constant TARGET_USER = 0x3B09e1C048961566c700C0DA407A142eA29D50a6;
657     
658     bool public constant CONTINUE_MINTING = true;
659 }
660 
661 
662 
663 
664 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
665     
666 {
667     
668     event Initialized();
669     bool public initialized = false;
670 
671     constructor() public {
672         init();
673         transferOwnership(TARGET_USER);
674     }
675     
676 
677     function name() public pure returns (string _name) {
678         return TOKEN_NAME;
679     }
680 
681     function symbol() public pure returns (string _symbol) {
682         return TOKEN_SYMBOL;
683     }
684 
685     function decimals() public pure returns (uint8 _decimals) {
686         return TOKEN_DECIMALS_UINT8;
687     }
688 
689     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
690         require(!paused);
691         return super.transferFrom(_from, _to, _value);
692     }
693 
694     function transfer(address _to, uint256 _value) public returns (bool _success) {
695         require(!paused);
696         return super.transfer(_to, _value);
697     }
698 
699     
700     function init() private {
701         require(!initialized);
702         initialized = true;
703 
704         if (PAUSED) {
705             pause();
706         }
707 
708         
709         address[1] memory addresses = [address(0x3b09e1c048961566c700c0da407a142ea29d50a6)];
710         uint[1] memory amounts = [uint(51000000000000000000000000)];
711         uint64[1] memory freezes = [uint64(0)];
712 
713         for (uint i = 0; i < addresses.length; i++) {
714             if (freezes[i] == 0) {
715                 mint(addresses[i], amounts[i]);
716             } else {
717                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
718             }
719         }
720         
721 
722         if (!CONTINUE_MINTING) {
723             finishMinting();
724         }
725 
726         emit Initialized();
727     }
728     
729 }