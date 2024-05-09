1 /*
2  *J4M3584P7157
3  *
4  * You should have received a copy of the GNU Lesser General Public License
5  * along with this program. If not, see <http://www.gnu.org/licenses/>.
6  */
7 pragma solidity ^0.4.23;
8 
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16   function totalSupply() public view returns (uint256);
17   function balanceOf(address who) public view returns (uint256);
18   function transfer(address to, uint256 value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
35     // benefit is lost if 'b' is also tested.
36     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37     if (a == 0) {
38       return 0;
39     }
40 
41     c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     // uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return a / b;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender)
127     public view returns (uint256);
128 
129   function transferFrom(address from, address to, uint256 value)
130     public returns (bool);
131 
132   function approve(address spender, uint256 value) public returns (bool);
133   event Approval(
134     address indexed owner,
135     address indexed spender,
136     uint256 value
137   );
138 }
139 
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) internal allowed;
151 
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amount of tokens to be transferred
158    */
159   function transferFrom(
160     address _from,
161     address _to,
162     uint256 _value
163   )
164     public
165     returns (bool)
166   {
167     require(_to != address(0));
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     emit Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(
201     address _owner,
202     address _spender
203    )
204     public
205     view
206     returns (uint256)
207   {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _addedValue The amount of tokens to increase the allowance by.
220    */
221   function increaseApproval(
222     address _spender,
223     uint _addedValue
224   )
225     public
226     returns (bool)
227   {
228     allowed[msg.sender][_spender] = (
229       allowed[msg.sender][_spender].add(_addedValue));
230     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234   /**
235    * @dev Decrease the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(
245     address _spender,
246     uint _subtractedValue
247   )
248     public
249     returns (bool)
250   {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 
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
299    */
300   function renounceOwnership() public onlyOwner {
301     emit OwnershipRenounced(owner);
302     owner = address(0);
303   }
304 
305   /**
306    * @dev Allows the current owner to transfer control of the contract to a newOwner.
307    * @param _newOwner The address to transfer ownership to.
308    */
309   function transferOwnership(address _newOwner) public onlyOwner {
310     _transferOwnership(_newOwner);
311   }
312 
313   /**
314    * @dev Transfers control of the contract to a newOwner.
315    * @param _newOwner The address to transfer ownership to.
316    */
317   function _transferOwnership(address _newOwner) internal {
318     require(_newOwner != address(0));
319     emit OwnershipTransferred(owner, _newOwner);
320     owner = _newOwner;
321   }
322 }
323 
324 
325 /**
326  * @title Mintable token
327  * @dev Simple ERC20 Token example, with mintable token creation
328  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
329  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
330  */
331 contract MintableToken is StandardToken, Ownable {
332   event Mint(address indexed to, uint256 amount);
333   event MintFinished();
334 
335   bool public mintingFinished = false;
336 
337 
338   modifier canMint() {
339     require(!mintingFinished);
340     _;
341   }
342 
343   modifier hasMintPermission() {
344     require(msg.sender == owner);
345     _;
346   }
347 
348   /**
349    * @dev Function to mint tokens
350    * @param _to The address that will receive the minted tokens.
351    * @param _amount The amount of tokens to mint.
352    * @return A boolean that indicates if the operation was successful.
353    */
354   function mint(
355     address _to,
356     uint256 _amount
357   )
358     hasMintPermission
359     canMint
360     public
361     returns (bool)
362   {
363     totalSupply_ = totalSupply_.add(_amount);
364     balances[_to] = balances[_to].add(_amount);
365     emit Mint(_to, _amount);
366     emit Transfer(address(0), _to, _amount);
367     return true;
368   }
369 
370   /**
371    * @dev Function to stop minting new tokens.
372    * @return True if the operation was successful.
373    */
374   function finishMinting() onlyOwner canMint public returns (bool) {
375     mintingFinished = true;
376     emit MintFinished();
377     return true;
378   }
379 }
380 
381 
382 contract FreezableToken is StandardToken {
383     // freezing chains
384     mapping (bytes32 => uint64) internal chains;
385     // freezing amounts for each chain
386     mapping (bytes32 => uint) internal freezings;
387     // total freezing balance per address
388     mapping (address => uint) internal freezingBalance;
389 
390     event Freezed(address indexed to, uint64 release, uint amount);
391     event Released(address indexed owner, uint amount);
392 
393     /**
394      * @dev Gets the balance of the specified address include freezing tokens.
395      * @param _owner The address to query the the balance of.
396      * @return An uint256 representing the amount owned by the passed address.
397      */
398     function balanceOf(address _owner) public view returns (uint256 balance) {
399         return super.balanceOf(_owner) + freezingBalance[_owner];
400     }
401 
402     /**
403      * @dev Gets the balance of the specified address without freezing tokens.
404      * @param _owner The address to query the the balance of.
405      * @return An uint256 representing the amount owned by the passed address.
406      */
407     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
408         return super.balanceOf(_owner);
409     }
410 
411     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
412         return freezingBalance[_owner];
413     }
414 
415     /**
416      * @dev gets freezing count
417      * @param _addr Address of freeze tokens owner.
418      */
419     function freezingCount(address _addr) public view returns (uint count) {
420         uint64 release = chains[toKey(_addr, 0)];
421         while (release != 0) {
422             count++;
423             release = chains[toKey(_addr, release)];
424         }
425     }
426 
427     /**
428      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
429      * @param _addr Address of freeze tokens owner.
430      * @param _index Freezing portion index. It ordered by release date descending.
431      */
432     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
433         for (uint i = 0; i < _index + 1; i++) {
434             _release = chains[toKey(_addr, _release)];
435             if (_release == 0) {
436                 return;
437             }
438         }
439         _balance = freezings[toKey(_addr, _release)];
440     }
441 
442     /**
443      * @dev freeze your tokens to the specified address.
444      *      Be careful, gas usage is not deterministic,
445      *      and depends on how many freezes _to address already has.
446      * @param _to Address to which token will be freeze.
447      * @param _amount Amount of token to freeze.
448      * @param _until Release date, must be in future.
449      */
450     function freezeTo(address _to, uint _amount, uint64 _until) public {
451         require(_to != address(0));
452         require(_amount <= balances[msg.sender]);
453 
454         balances[msg.sender] = balances[msg.sender].sub(_amount);
455 
456         bytes32 currentKey = toKey(_to, _until);
457         freezings[currentKey] = freezings[currentKey].add(_amount);
458         freezingBalance[_to] = freezingBalance[_to].add(_amount);
459 
460         freeze(_to, _until);
461         emit Transfer(msg.sender, _to, _amount);
462         emit Freezed(_to, _until, _amount);
463     }
464 
465     /**
466      * @dev release first available freezing tokens.
467      */
468     function releaseOnce() public {
469         bytes32 headKey = toKey(msg.sender, 0);
470         uint64 head = chains[headKey];
471         require(head != 0);
472         require(uint64(block.timestamp) > head);
473         bytes32 currentKey = toKey(msg.sender, head);
474 
475         uint64 next = chains[currentKey];
476 
477         uint amount = freezings[currentKey];
478         delete freezings[currentKey];
479 
480         balances[msg.sender] = balances[msg.sender].add(amount);
481         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
482 
483         if (next == 0) {
484             delete chains[headKey];
485         } else {
486             chains[headKey] = next;
487             delete chains[currentKey];
488         }
489         emit Released(msg.sender, amount);
490     }
491 
492     /**
493      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
494      * @return how many tokens was released
495      */
496     function releaseAll() public returns (uint tokens) {
497         uint release;
498         uint balance;
499         (release, balance) = getFreezing(msg.sender, 0);
500         while (release != 0 && block.timestamp > release) {
501             releaseOnce();
502             tokens += balance;
503             (release, balance) = getFreezing(msg.sender, 0);
504         }
505     }
506 
507     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
508         // WISH masc to increase entropy
509         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
510         assembly {
511             result := or(result, mul(_addr, 0x10000000000000000))
512             result := or(result, _release)
513         }
514     }
515 
516     function freeze(address _to, uint64 _until) internal {
517         require(_until > block.timestamp);
518         bytes32 key = toKey(_to, _until);
519         bytes32 parentKey = toKey(_to, uint64(0));
520         uint64 next = chains[parentKey];
521 
522         if (next == 0) {
523             chains[parentKey] = _until;
524             return;
525         }
526 
527         bytes32 nextKey = toKey(_to, next);
528         uint parent;
529 
530         while (next != 0 && _until > next) {
531             parent = next;
532             parentKey = nextKey;
533 
534             next = chains[nextKey];
535             nextKey = toKey(_to, next);
536         }
537 
538         if (_until == next) {
539             return;
540         }
541 
542         if (next != 0) {
543             chains[key] = next;
544         }
545 
546         chains[parentKey] = _until;
547     }
548 }
549 
550 
551 /**
552  * @title Burnable Token
553  * @dev Token that can be irreversibly burned (destroyed).
554  */
555 contract BurnableToken is BasicToken {
556 
557   event Burn(address indexed burner, uint256 value);
558 
559   /**
560    * @dev Burns a specific amount of tokens.
561    * @param _value The amount of token to be burned.
562    */
563   function burn(uint256 _value) public {
564     _burn(msg.sender, _value);
565   }
566 
567   function _burn(address _who, uint256 _value) internal {
568     require(_value <= balances[_who]);
569     // no need to require value <= totalSupply, since that would imply the
570     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
571 
572     balances[_who] = balances[_who].sub(_value);
573     totalSupply_ = totalSupply_.sub(_value);
574     emit Burn(_who, _value);
575     emit Transfer(_who, address(0), _value);
576   }
577 }
578 
579 
580 
581 /**
582  * @title Pausable
583  * @dev Base contract which allows children to implement an emergency stop mechanism.
584  */
585 contract Pausable is Ownable {
586   event Pause();
587   event Unpause();
588 
589   bool public paused = false;
590 
591 
592   /**
593    * @dev Modifier to make a function callable only when the contract is not paused.
594    */
595   modifier whenNotPaused() {
596     require(!paused);
597     _;
598   }
599 
600   /**
601    * @dev Modifier to make a function callable only when the contract is paused.
602    */
603   modifier whenPaused() {
604     require(paused);
605     _;
606   }
607 
608   /**
609    * @dev called by the owner to pause, triggers stopped state
610    */
611   function pause() onlyOwner whenNotPaused public {
612     paused = true;
613     emit Pause();
614   }
615 
616   /**
617    * @dev called by the owner to unpause, returns to normal state
618    */
619   function unpause() onlyOwner whenPaused public {
620     paused = false;
621     emit Unpause();
622   }
623 }
624 
625 
626 contract FreezableMintableToken is FreezableToken, MintableToken {
627     /**
628      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
629      *      Be careful, gas usage is not deterministic,
630      *      and depends on how many freezes _to address already has.
631      * @param _to Address to which token will be freeze.
632      * @param _amount Amount of token to mint and freeze.
633      * @param _until Release date, must be in future.
634      * @return A boolean that indicates if the operation was successful.
635      */
636     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
637         totalSupply_ = totalSupply_.add(_amount);
638 
639         bytes32 currentKey = toKey(_to, _until);
640         freezings[currentKey] = freezings[currentKey].add(_amount);
641         freezingBalance[_to] = freezingBalance[_to].add(_amount);
642 
643         freeze(_to, _until);
644         emit Mint(_to, _amount);
645         emit Freezed(_to, _until, _amount);
646         emit Transfer(msg.sender, _to, _amount);
647         return true;
648     }
649 }
650 
651 
652 
653 contract Consts {
654     uint public constant TOKEN_DECIMALS = 18;
655     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
656     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
657 
658     string public constant TOKEN_NAME = "NIOX";
659     string public constant TOKEN_SYMBOL = "NIOX";
660     bool public constant PAUSED = false;
661     address public constant TARGET_USER = 0xc900AD4141b51b104dB0F2Ec6fD5FAF611575Bee;
662     
663     bool public constant CONTINUE_MINTING = true;
664 }
665 
666 
667 
668 
669 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
670     
671 {
672     
673     event Initialized();
674     bool public initialized = false;
675 
676     constructor() public {
677         init();
678         transferOwnership(TARGET_USER);
679     }
680     
681 
682     function name() public pure returns (string _name) {
683         return TOKEN_NAME;
684     }
685 
686     function symbol() public pure returns (string _symbol) {
687         return TOKEN_SYMBOL;
688     }
689 
690     function decimals() public pure returns (uint8 _decimals) {
691         return TOKEN_DECIMALS_UINT8;
692     }
693 
694     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
695         require(!paused);
696         return super.transferFrom(_from, _to, _value);
697     }
698 
699     function transfer(address _to, uint256 _value) public returns (bool _success) {
700         require(!paused);
701         return super.transfer(_to, _value);
702     }
703 
704     
705     function init() private {
706         require(!initialized);
707         initialized = true;
708 
709         if (PAUSED) {
710             pause();
711         }
712 
713         
714         address[1] memory addresses = [address(0xc900AD4141b51b104dB0F2Ec6fD5FAF611575Bee)];
715         uint[1] memory amounts = [uint(1000000000000000000000000000)];
716         uint64[1] memory freezes = [uint64(0)];
717 
718         for (uint i = 0; i < addresses.length; i++) {
719             if (freezes[i] == 0) {
720                 mint(addresses[i], amounts[i]);
721             } else {
722                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
723             }
724         }
725         
726 
727         if (!CONTINUE_MINTING) {
728             finishMinting();
729         }
730 
731         emit Initialized();
732     }
733     
734 }