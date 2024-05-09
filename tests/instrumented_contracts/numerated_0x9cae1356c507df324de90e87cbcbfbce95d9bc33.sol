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
319 
320 /**
321  * Utility library of inline functions on addresses
322  */
323 library AddressUtils {
324 
325   /**
326    * Returns whether the target address is a contract
327    * @dev This function will return false if invoked during the constructor of a contract,
328    *  as the code is not actually created until after the constructor finishes.
329    * @param addr address to check
330    * @return whether the target address is a contract
331    */
332   function isContract(address addr) internal view returns (bool) {
333     uint256 size;
334     // XXX Currently there is no better way to check if there is a contract in an address
335     // than to check the size of the code at that address.
336     // See https://ethereum.stackexchange.com/a/14016/36603
337     // for more details about how this works.
338     // TODO Check this again before the Serenity release, because all addresses will be
339     // contracts then.
340     // solium-disable-next-line security/no-inline-assembly
341     assembly { size := extcodesize(addr) }
342     return size > 0;
343   }
344 
345 }
346 
347 
348 contract ERC223Basic is ERC20Basic {
349     function transfer(address to, uint value, bytes data) public returns (bool);
350     event Transfer(address indexed from, address indexed to, uint indexed value, bytes data);
351 }
352 
353 
354 
355 /**
356 * @title Contract that will work with ERC223 tokens.
357 */
358 contract ERC223Receiver {
359     /**
360      * @dev Standard ERC223 function that will handle incoming token transfers.
361      *
362      * @param _from  Token sender address.
363      * @param _value Amount of tokens.
364      * @param _data  Transaction metadata.
365      */
366     function tokenFallback(address _from, uint _value, bytes _data) public;
367 }
368 
369 
370 /**
371  * @title Mintable token
372  * @dev Simple ERC20 Token example, with mintable token creation
373  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
374  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
375  */
376 contract MintableToken is StandardToken, Ownable {
377   event Mint(address indexed to, uint256 amount);
378   event MintFinished();
379 
380   bool public mintingFinished = false;
381 
382 
383   modifier canMint() {
384     require(!mintingFinished);
385     _;
386   }
387 
388   modifier hasMintPermission() {
389     require(msg.sender == owner);
390     _;
391   }
392 
393   /**
394    * @dev Function to mint tokens
395    * @param _to The address that will receive the minted tokens.
396    * @param _amount The amount of tokens to mint.
397    * @return A boolean that indicates if the operation was successful.
398    */
399   function mint(
400     address _to,
401     uint256 _amount
402   )
403     hasMintPermission
404     canMint
405     public
406     returns (bool)
407   {
408     totalSupply_ = totalSupply_.add(_amount);
409     balances[_to] = balances[_to].add(_amount);
410     emit Mint(_to, _amount);
411     emit Transfer(address(0), _to, _amount);
412     return true;
413   }
414 
415   /**
416    * @dev Function to stop minting new tokens.
417    * @return True if the operation was successful.
418    */
419   function finishMinting() onlyOwner canMint public returns (bool) {
420     mintingFinished = true;
421     emit MintFinished();
422     return true;
423   }
424 }
425 
426 
427 /**
428  * @title Reference implementation of the ERC223 standard token.
429  */
430 contract ERC223Token is ERC223Basic, BasicToken, ERC223Receiver {
431     using SafeMath for uint;
432     using AddressUtils for address;
433 
434     /**
435      * @dev Token should not accept tokens
436      */
437     function tokenFallback(address, uint, bytes) public {
438         revert();
439     }
440 
441     /**
442      * @dev Transfer the specified amount of tokens to the specified address.
443      *      Invokes the `tokenFallback` function if the recipient is a contract.
444      *      The token transfer fails if the recipient is a contract
445      *      but does not implement the `tokenFallback` function
446      *      or the fallback function to receive funds.
447      *
448      * @param _to    Receiver address.
449      * @param _value Amount of tokens that will be transferred.
450      * @param _data  Transaction metadata.
451      */
452     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
453         // Standard function transfer similar to ERC20 transfer with no _data .
454         // Added due to backwards compatibility reasons .
455         balances[msg.sender] = balances[msg.sender].sub(_value);
456         balances[_to] = balances[_to].add(_value);
457         if (_to.isContract()) {
458             ERC223Receiver receiver = ERC223Receiver(_to);
459             receiver.tokenFallback(msg.sender, _value, _data);
460         }
461         emit Transfer(msg.sender, _to, _value, _data);
462         return true;
463     }
464 
465     /**
466      * @dev Transfer the specified amount of tokens to the specified address.
467      *      This function works the same with the previous one
468      *      but doesn't contain `_data` param.
469      *      Added due to backwards compatibility reasons.
470      *
471      * @param _to    Receiver address.
472      * @param _value Amount of tokens that will be transferred.
473      */
474     function transfer(address _to, uint256 _value) public returns (bool) {
475         bytes memory empty;
476         return transfer(_to, _value, empty);
477     }
478 }
479 
480 
481 contract FreezableToken is StandardToken {
482     // freezing chains
483     mapping (bytes32 => uint64) internal chains;
484     // freezing amounts for each chain
485     mapping (bytes32 => uint) internal freezings;
486     // total freezing balance per address
487     mapping (address => uint) internal freezingBalance;
488 
489     event Freezed(address indexed to, uint64 release, uint amount);
490     event Released(address indexed owner, uint amount);
491 
492     /**
493      * @dev Gets the balance of the specified address include freezing tokens.
494      * @param _owner The address to query the the balance of.
495      * @return An uint256 representing the amount owned by the passed address.
496      */
497     function balanceOf(address _owner) public view returns (uint256 balance) {
498         return super.balanceOf(_owner) + freezingBalance[_owner];
499     }
500 
501     /**
502      * @dev Gets the balance of the specified address without freezing tokens.
503      * @param _owner The address to query the the balance of.
504      * @return An uint256 representing the amount owned by the passed address.
505      */
506     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
507         return super.balanceOf(_owner);
508     }
509 
510     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
511         return freezingBalance[_owner];
512     }
513 
514     /**
515      * @dev gets freezing count
516      * @param _addr Address of freeze tokens owner.
517      */
518     function freezingCount(address _addr) public view returns (uint count) {
519         uint64 release = chains[toKey(_addr, 0)];
520         while (release != 0) {
521             count++;
522             release = chains[toKey(_addr, release)];
523         }
524     }
525 
526     /**
527      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
528      * @param _addr Address of freeze tokens owner.
529      * @param _index Freezing portion index. It ordered by release date descending.
530      */
531     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
532         for (uint i = 0; i < _index + 1; i++) {
533             _release = chains[toKey(_addr, _release)];
534             if (_release == 0) {
535                 return;
536             }
537         }
538         _balance = freezings[toKey(_addr, _release)];
539     }
540 
541     /**
542      * @dev freeze your tokens to the specified address.
543      *      Be careful, gas usage is not deterministic,
544      *      and depends on how many freezes _to address already has.
545      * @param _to Address to which token will be freeze.
546      * @param _amount Amount of token to freeze.
547      * @param _until Release date, must be in future.
548      */
549     function freezeTo(address _to, uint _amount, uint64 _until) public {
550         require(_to != address(0));
551         require(_amount <= balances[msg.sender]);
552 
553         balances[msg.sender] = balances[msg.sender].sub(_amount);
554 
555         bytes32 currentKey = toKey(_to, _until);
556         freezings[currentKey] = freezings[currentKey].add(_amount);
557         freezingBalance[_to] = freezingBalance[_to].add(_amount);
558 
559         freeze(_to, _until);
560         emit Transfer(msg.sender, _to, _amount);
561         emit Freezed(_to, _until, _amount);
562     }
563 
564     /**
565      * @dev release first available freezing tokens.
566      */
567     function releaseOnce() public {
568         bytes32 headKey = toKey(msg.sender, 0);
569         uint64 head = chains[headKey];
570         require(head != 0);
571         require(uint64(block.timestamp) > head);
572         bytes32 currentKey = toKey(msg.sender, head);
573 
574         uint64 next = chains[currentKey];
575 
576         uint amount = freezings[currentKey];
577         delete freezings[currentKey];
578 
579         balances[msg.sender] = balances[msg.sender].add(amount);
580         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
581 
582         if (next == 0) {
583             delete chains[headKey];
584         } else {
585             chains[headKey] = next;
586             delete chains[currentKey];
587         }
588         emit Released(msg.sender, amount);
589     }
590 
591     /**
592      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
593      * @return how many tokens was released
594      */
595     function releaseAll() public returns (uint tokens) {
596         uint release;
597         uint balance;
598         (release, balance) = getFreezing(msg.sender, 0);
599         while (release != 0 && block.timestamp > release) {
600             releaseOnce();
601             tokens += balance;
602             (release, balance) = getFreezing(msg.sender, 0);
603         }
604     }
605 
606     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
607         // WISH masc to increase entropy
608         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
609         assembly {
610             result := or(result, mul(_addr, 0x10000000000000000))
611             result := or(result, _release)
612         }
613     }
614 
615     function freeze(address _to, uint64 _until) internal {
616         require(_until > block.timestamp);
617         bytes32 key = toKey(_to, _until);
618         bytes32 parentKey = toKey(_to, uint64(0));
619         uint64 next = chains[parentKey];
620 
621         if (next == 0) {
622             chains[parentKey] = _until;
623             return;
624         }
625 
626         bytes32 nextKey = toKey(_to, next);
627         uint parent;
628 
629         while (next != 0 && _until > next) {
630             parent = next;
631             parentKey = nextKey;
632 
633             next = chains[nextKey];
634             nextKey = toKey(_to, next);
635         }
636 
637         if (_until == next) {
638             return;
639         }
640 
641         if (next != 0) {
642             chains[key] = next;
643         }
644 
645         chains[parentKey] = _until;
646     }
647 }
648 
649 
650 /**
651  * @title Burnable Token
652  * @dev Token that can be irreversibly burned (destroyed).
653  */
654 contract BurnableToken is BasicToken {
655 
656   event Burn(address indexed burner, uint256 value);
657 
658   /**
659    * @dev Burns a specific amount of tokens.
660    * @param _value The amount of token to be burned.
661    */
662   function burn(uint256 _value) public {
663     _burn(msg.sender, _value);
664   }
665 
666   function _burn(address _who, uint256 _value) internal {
667     require(_value <= balances[_who]);
668     // no need to require value <= totalSupply, since that would imply the
669     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
670 
671     balances[_who] = balances[_who].sub(_value);
672     totalSupply_ = totalSupply_.sub(_value);
673     emit Burn(_who, _value);
674     emit Transfer(_who, address(0), _value);
675   }
676 }
677 
678 
679 
680 /**
681  * @title Pausable
682  * @dev Base contract which allows children to implement an emergency stop mechanism.
683  */
684 contract Pausable is Ownable {
685   event Pause();
686   event Unpause();
687 
688   bool public paused = false;
689 
690 
691   /**
692    * @dev Modifier to make a function callable only when the contract is not paused.
693    */
694   modifier whenNotPaused() {
695     require(!paused);
696     _;
697   }
698 
699   /**
700    * @dev Modifier to make a function callable only when the contract is paused.
701    */
702   modifier whenPaused() {
703     require(paused);
704     _;
705   }
706 
707   /**
708    * @dev called by the owner to pause, triggers stopped state
709    */
710   function pause() onlyOwner whenNotPaused public {
711     paused = true;
712     emit Pause();
713   }
714 
715   /**
716    * @dev called by the owner to unpause, returns to normal state
717    */
718   function unpause() onlyOwner whenPaused public {
719     paused = false;
720     emit Unpause();
721   }
722 }
723 
724 
725 contract ERC223MintableToken is MintableToken, ERC223Token {
726     function mint(
727         address _to,
728         uint256 _amount
729     )
730         hasMintPermission
731         canMint
732         public
733         returns (bool)
734     {
735         bytes memory empty;
736         totalSupply_ = totalSupply_.add(_amount);
737         balances[_to] = balances[_to].add(_amount);
738         if (_to.isContract()) {
739             ERC223Receiver receiver = ERC223Receiver(_to);
740             receiver.tokenFallback(address(this), _amount, empty);
741         }
742         emit Mint(_to, _amount);
743         emit Transfer(msg.sender, _to, _amount, empty);
744         return true;
745     }
746 }
747 
748 
749 contract FreezableMintableToken is FreezableToken, MintableToken {
750     /**
751      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
752      *      Be careful, gas usage is not deterministic,
753      *      and depends on how many freezes _to address already has.
754      * @param _to Address to which token will be freeze.
755      * @param _amount Amount of token to mint and freeze.
756      * @param _until Release date, must be in future.
757      * @return A boolean that indicates if the operation was successful.
758      */
759     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
760         totalSupply_ = totalSupply_.add(_amount);
761 
762         bytes32 currentKey = toKey(_to, _until);
763         freezings[currentKey] = freezings[currentKey].add(_amount);
764         freezingBalance[_to] = freezingBalance[_to].add(_amount);
765 
766         freeze(_to, _until);
767         emit Mint(_to, _amount);
768         emit Freezed(_to, _until, _amount);
769         emit Transfer(msg.sender, _to, _amount);
770         return true;
771     }
772 }
773 
774 
775 
776 contract Consts {
777     uint public constant TOKEN_DECIMALS = 18;
778     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
779     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
780 
781     string public constant TOKEN_NAME = "Squirrex";
782     string public constant TOKEN_SYMBOL = "SQRX";
783     bool public constant PAUSED = false;
784     address public constant TARGET_USER = 0xb3938B5A09386a941C52E70C9B575C7b236805b7;
785     
786     bool public constant CONTINUE_MINTING = true;
787 }
788 
789 
790 
791 
792 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
793     
794     , ERC223MintableToken
795     
796 {
797     
798     event Initialized();
799     bool public initialized = false;
800 
801     constructor() public {
802         init();
803         transferOwnership(TARGET_USER);
804     }
805     
806 
807     function name() public pure returns (string _name) {
808         return TOKEN_NAME;
809     }
810 
811     function symbol() public pure returns (string _symbol) {
812         return TOKEN_SYMBOL;
813     }
814 
815     function decimals() public pure returns (uint8 _decimals) {
816         return TOKEN_DECIMALS_UINT8;
817     }
818 
819     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
820         require(!paused);
821         return super.transferFrom(_from, _to, _value);
822     }
823 
824     function transfer(address _to, uint256 _value) public returns (bool _success) {
825         require(!paused);
826         return super.transfer(_to, _value);
827     }
828 
829     
830     function init() private {
831         require(!initialized);
832         initialized = true;
833 
834         if (PAUSED) {
835             pause();
836         }
837 
838         
839         address[1] memory addresses = [address(0xb3938b5a09386a941c52e70c9b575c7b236805b7)];
840         uint[1] memory amounts = [uint(1000000000000000000000000000)];
841         uint64[1] memory freezes = [uint64(0)];
842 
843         for (uint i = 0; i < addresses.length; i++) {
844             if (freezes[i] == 0) {
845                 mint(addresses[i], amounts[i]);
846             } else {
847                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
848             }
849         }
850         
851 
852         if (!CONTINUE_MINTING) {
853             finishMinting();
854         }
855 
856         emit Initialized();
857     }
858     
859 }