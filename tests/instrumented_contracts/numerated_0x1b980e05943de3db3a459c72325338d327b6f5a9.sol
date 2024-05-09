1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-12
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   function totalSupply() public view returns (uint256);
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (a == 0) {
36       return 0;
37     }
38 
39     c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     // uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return a / b;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   uint256 totalSupply_;
84 
85   /**
86   * @dev total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     emit Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public view returns (uint256) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender)
125     public view returns (uint256);
126 
127   function transferFrom(address from, address to, uint256 value)
128     public returns (bool);
129 
130   function approve(address spender, uint256 value) public returns (bool);
131   event Approval(
132     address indexed owner,
133     address indexed spender,
134     uint256 value
135   );
136 }
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(
158     address _from,
159     address _to,
160     uint256 _value
161   )
162     public
163     returns (bool)
164   {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     emit Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     emit Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(
199     address _owner,
200     address _spender
201    )
202     public
203     view
204     returns (uint256)
205   {
206     return allowed[_owner][_spender];
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(
220     address _spender,
221     uint _addedValue
222   )
223     public
224     returns (bool)
225   {
226     allowed[msg.sender][_spender] = (
227       allowed[msg.sender][_spender].add(_addedValue));
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232   /**
233    * @dev Decrease the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To decrement
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _subtractedValue The amount of tokens to decrease the allowance by.
241    */
242   function decreaseApproval(
243     address _spender,
244     uint _subtractedValue
245   )
246     public
247     returns (bool)
248   {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 
262 
263 /**
264  * @title Ownable
265  * @dev The Ownable contract has an owner address, and provides basic authorization control
266  * functions, this simplifies the implementation of "user permissions".
267  */
268 contract Ownable {
269   address public owner;
270 
271 
272   event OwnershipRenounced(address indexed previousOwner);
273   event OwnershipTransferred(
274     address indexed previousOwner,
275     address indexed newOwner
276   );
277 
278 
279   /**
280    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281    * account.
282    */
283   constructor() public {
284     owner = msg.sender;
285   }
286 
287   /**
288    * @dev Throws if called by any account other than the owner.
289    */
290   modifier onlyOwner() {
291     require(msg.sender == owner);
292     _;
293   }
294 
295   /**
296    * @dev Allows the current owner to relinquish control of the contract.
297    */
298   function renounceOwnership() public onlyOwner {
299     emit OwnershipRenounced(owner);
300     owner = address(0);
301   }
302 
303   /**
304    * @dev Allows the current owner to transfer control of the contract to a newOwner.
305    * @param _newOwner The address to transfer ownership to.
306    */
307   function transferOwnership(address _newOwner) public onlyOwner {
308     _transferOwnership(_newOwner);
309   }
310 
311   /**
312    * @dev Transfers control of the contract to a newOwner.
313    * @param _newOwner The address to transfer ownership to.
314    */
315   function _transferOwnership(address _newOwner) internal {
316     require(_newOwner != address(0));
317     emit OwnershipTransferred(owner, _newOwner);
318     owner = _newOwner;
319   }
320 }
321 
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   modifier hasMintPermission() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     hasMintPermission
357     canMint
358     public
359     returns (bool)
360   {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     emit Mint(_to, _amount);
364     emit Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() onlyOwner canMint public returns (bool) {
373     mintingFinished = true;
374     emit MintFinished();
375     return true;
376   }
377 }
378 
379 
380 contract FreezableToken is StandardToken {
381     // freezing chains
382     mapping (bytes32 => uint64) internal chains;
383     // freezing amounts for each chain
384     mapping (bytes32 => uint) internal freezings;
385     // total freezing balance per address
386     mapping (address => uint) internal freezingBalance;
387 
388     event Freezed(address indexed to, uint64 release, uint amount);
389     event Released(address indexed owner, uint amount);
390 
391     /**
392      * @dev Gets the balance of the specified address include freezing tokens.
393      * @param _owner The address to query the the balance of.
394      * @return An uint256 representing the amount owned by the passed address.
395      */
396     function balanceOf(address _owner) public view returns (uint256 balance) {
397         return super.balanceOf(_owner) + freezingBalance[_owner];
398     }
399 
400     /**
401      * @dev Gets the balance of the specified address without freezing tokens.
402      * @param _owner The address to query the the balance of.
403      * @return An uint256 representing the amount owned by the passed address.
404      */
405     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
406         return super.balanceOf(_owner);
407     }
408 
409     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
410         return freezingBalance[_owner];
411     }
412 
413     /**
414      * @dev gets freezing count
415      * @param _addr Address of freeze tokens owner.
416      */
417     function freezingCount(address _addr) public view returns (uint count) {
418         uint64 release = chains[toKey(_addr, 0)];
419         while (release != 0) {
420             count++;
421             release = chains[toKey(_addr, release)];
422         }
423     }
424 
425     /**
426      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
427      * @param _addr Address of freeze tokens owner.
428      * @param _index Freezing portion index. It ordered by release date descending.
429      */
430     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
431         for (uint i = 0; i < _index + 1; i++) {
432             _release = chains[toKey(_addr, _release)];
433             if (_release == 0) {
434                 return;
435             }
436         }
437         _balance = freezings[toKey(_addr, _release)];
438     }
439 
440     /**
441      * @dev freeze your tokens to the specified address.
442      *      Be careful, gas usage is not deterministic,
443      *      and depends on how many freezes _to address already has.
444      * @param _to Address to which token will be freeze.
445      * @param _amount Amount of token to freeze.
446      * @param _until Release date, must be in future.
447      */
448     function freezeTo(address _to, uint _amount, uint64 _until) public {
449         require(_to != address(0));
450         require(_amount <= balances[msg.sender]);
451 
452         balances[msg.sender] = balances[msg.sender].sub(_amount);
453 
454         bytes32 currentKey = toKey(_to, _until);
455         freezings[currentKey] = freezings[currentKey].add(_amount);
456         freezingBalance[_to] = freezingBalance[_to].add(_amount);
457 
458         freeze(_to, _until);
459         emit Transfer(msg.sender, _to, _amount);
460         emit Freezed(_to, _until, _amount);
461     }
462 
463     /**
464      * @dev release first available freezing tokens.
465      */
466     function releaseOnce() public {
467         bytes32 headKey = toKey(msg.sender, 0);
468         uint64 head = chains[headKey];
469         require(head != 0);
470         require(uint64(block.timestamp) > head);
471         bytes32 currentKey = toKey(msg.sender, head);
472 
473         uint64 next = chains[currentKey];
474 
475         uint amount = freezings[currentKey];
476         delete freezings[currentKey];
477 
478         balances[msg.sender] = balances[msg.sender].add(amount);
479         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
480 
481         if (next == 0) {
482             delete chains[headKey];
483         } else {
484             chains[headKey] = next;
485             delete chains[currentKey];
486         }
487         emit Released(msg.sender, amount);
488     }
489 
490     /**
491      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
492      * @return how many tokens was released
493      */
494     function releaseAll() public returns (uint tokens) {
495         uint release;
496         uint balance;
497         (release, balance) = getFreezing(msg.sender, 0);
498         while (release != 0 && block.timestamp > release) {
499             releaseOnce();
500             tokens += balance;
501             (release, balance) = getFreezing(msg.sender, 0);
502         }
503     }
504 
505     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
506         // WISH masc to increase entropy
507         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
508         assembly {
509             result := or(result, mul(_addr, 0x10000000000000000))
510             result := or(result, _release)
511         }
512     }
513 
514     function freeze(address _to, uint64 _until) internal {
515         require(_until > block.timestamp);
516         bytes32 key = toKey(_to, _until);
517         bytes32 parentKey = toKey(_to, uint64(0));
518         uint64 next = chains[parentKey];
519 
520         if (next == 0) {
521             chains[parentKey] = _until;
522             return;
523         }
524 
525         bytes32 nextKey = toKey(_to, next);
526         uint parent;
527 
528         while (next != 0 && _until > next) {
529             parent = next;
530             parentKey = nextKey;
531 
532             next = chains[nextKey];
533             nextKey = toKey(_to, next);
534         }
535 
536         if (_until == next) {
537             return;
538         }
539 
540         if (next != 0) {
541             chains[key] = next;
542         }
543 
544         chains[parentKey] = _until;
545     }
546 }
547 
548 
549 /**
550  * @title Burnable Token
551  * @dev Token that can be irreversibly burned (destroyed).
552  */
553 contract BurnableToken is BasicToken {
554 
555   event Burn(address indexed burner, uint256 value);
556 
557   /**
558    * @dev Burns a specific amount of tokens.
559    * @param _value The amount of token to be burned.
560    */
561   function burn(uint256 _value) public {
562     _burn(msg.sender, _value);
563   }
564 
565   function _burn(address _who, uint256 _value) internal {
566     require(_value <= balances[_who]);
567     // no need to require value <= totalSupply, since that would imply the
568     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
569 
570     balances[_who] = balances[_who].sub(_value);
571     totalSupply_ = totalSupply_.sub(_value);
572     emit Burn(_who, _value);
573     emit Transfer(_who, address(0), _value);
574   }
575 }
576 
577 
578 
579 /**
580  * @title Pausable
581  * @dev Base contract which allows children to implement an emergency stop mechanism.
582  */
583 contract Pausable is Ownable {
584   event Pause();
585   event Unpause();
586 
587   bool public paused = false;
588 
589 
590   /**
591    * @dev Modifier to make a function callable only when the contract is not paused.
592    */
593   modifier whenNotPaused() {
594     require(!paused);
595     _;
596   }
597 
598   /**
599    * @dev Modifier to make a function callable only when the contract is paused.
600    */
601   modifier whenPaused() {
602     require(paused);
603     _;
604   }
605 
606   /**
607    * @dev called by the owner to pause, triggers stopped state
608    */
609   function pause() onlyOwner whenNotPaused public {
610     paused = true;
611     emit Pause();
612   }
613 
614   /**
615    * @dev called by the owner to unpause, returns to normal state
616    */
617   function unpause() onlyOwner whenPaused public {
618     paused = false;
619     emit Unpause();
620   }
621 }
622 
623 
624 contract FreezableMintableToken is FreezableToken, MintableToken {
625     /**
626      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
627      *      Be careful, gas usage is not deterministic,
628      *      and depends on how many freezes _to address already has.
629      * @param _to Address to which token will be freeze.
630      * @param _amount Amount of token to mint and freeze.
631      * @param _until Release date, must be in future.
632      * @return A boolean that indicates if the operation was successful.
633      */
634     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
635         totalSupply_ = totalSupply_.add(_amount);
636 
637         bytes32 currentKey = toKey(_to, _until);
638         freezings[currentKey] = freezings[currentKey].add(_amount);
639         freezingBalance[_to] = freezingBalance[_to].add(_amount);
640 
641         freeze(_to, _until);
642         emit Mint(_to, _amount);
643         emit Freezed(_to, _until, _amount);
644         emit Transfer(msg.sender, _to, _amount);
645         return true;
646     }
647 }
648 
649 
650 
651 contract Consts {
652     uint public constant TOKEN_DECIMALS = 18;
653     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
654     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
655 
656     string public constant TOKEN_NAME = "Bitgear";
657     string public constant TOKEN_SYMBOL = "GEAR";
658     bool public constant PAUSED = false;
659     address public constant TARGET_USER = 0x787526C380F432e327b6653bB0e1513DF792Fb9B;
660     
661     bool public constant CONTINUE_MINTING = true;
662 }
663 
664 
665 
666 
667 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
668     
669 {
670     
671     event Initialized();
672     bool public initialized = false;
673 
674     constructor() public {
675         init();
676         transferOwnership(TARGET_USER);
677     }
678     
679 
680     function name() public pure returns (string _name) {
681         return TOKEN_NAME;
682     }
683 
684     function symbol() public pure returns (string _symbol) {
685         return TOKEN_SYMBOL;
686     }
687 
688     function decimals() public pure returns (uint8 _decimals) {
689         return TOKEN_DECIMALS_UINT8;
690     }
691 
692     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
693         require(!paused);
694         return super.transferFrom(_from, _to, _value);
695     }
696 
697     function transfer(address _to, uint256 _value) public returns (bool _success) {
698         require(!paused);
699         return super.transfer(_to, _value);
700     }
701 
702     
703     function init() private {
704         require(!initialized);
705         initialized = true;
706 
707         if (PAUSED) {
708             pause();
709         }
710 
711         
712         address[2] memory addresses = [address(0x444d9d3e82bf3f1f918d0fb89d8b6dc573c9115d),address(0x444d9d3e82bf3f1f918d0fb89d8b6dc573c9115d)];
713         uint[2] memory amounts = [uint(48000000000000000000000000),uint(6000000000000000000000000)];
714         uint64[2] memory freezes = [uint64(0),uint64(0)];
715 
716         for (uint i = 0; i < addresses.length; i++) {
717             if (freezes[i] == 0) {
718                 mint(addresses[i], amounts[i]);
719             } else {
720                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
721             }
722         }
723         
724 
725         if (!CONTINUE_MINTING) {
726             finishMinting();
727         }
728 
729         emit Initialized();
730     }
731     
732 }