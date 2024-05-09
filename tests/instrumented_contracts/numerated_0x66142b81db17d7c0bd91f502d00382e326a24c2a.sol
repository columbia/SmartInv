1 /*
2 @GLOBEX TOKEN
3  */
4 pragma solidity ^0.4.23;
5 
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (a == 0) {
35       return 0;
36     }
37 
38     c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     // uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return a / b;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   /**
85   * @dev total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender)
124     public view returns (uint256);
125 
126   function transferFrom(address from, address to, uint256 value)
127     public returns (bool);
128 
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(
131     address indexed owner,
132     address indexed spender,
133     uint256 value
134   );
135 }
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(
219     address _spender,
220     uint _addedValue
221   )
222     public
223     returns (bool)
224   {
225     allowed[msg.sender][_spender] = (
226       allowed[msg.sender][_spender].add(_addedValue));
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 
261 
262 /**
263  * @title Ownable
264  * @dev The Ownable contract has an owner address, and provides basic authorization control
265  * functions, this simplifies the implementation of "user permissions".
266  */
267 contract Ownable {
268   address public owner;
269 
270 
271   event OwnershipRenounced(address indexed previousOwner);
272   event OwnershipTransferred(
273     address indexed previousOwner,
274     address indexed newOwner
275   );
276 
277 
278   /**
279    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
280    * account.
281    */
282   constructor() public {
283     owner = msg.sender;
284   }
285 
286   /**
287    * @dev Throws if called by any account other than the owner.
288    */
289   modifier onlyOwner() {
290     require(msg.sender == owner);
291     _;
292   }
293 
294   /**
295    * @dev Allows the current owner to relinquish control of the contract.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 
322 /**
323  * @title Mintable token
324  * @dev Simple ERC20 Token example, with mintable token creation
325  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     hasMintPermission
356     canMint
357     public
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() onlyOwner canMint public returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 
379 contract FreezableToken is StandardToken {
380     // freezing chains
381     mapping (bytes32 => uint64) internal chains;
382     // freezing amounts for each chain
383     mapping (bytes32 => uint) internal freezings;
384     // total freezing balance per address
385     mapping (address => uint) internal freezingBalance;
386 
387     event Freezed(address indexed to, uint64 release, uint amount);
388     event Released(address indexed owner, uint amount);
389 
390     /**
391      * @dev Gets the balance of the specified address include freezing tokens.
392      * @param _owner The address to query the the balance of.
393      * @return An uint256 representing the amount owned by the passed address.
394      */
395     function balanceOf(address _owner) public view returns (uint256 balance) {
396         return super.balanceOf(_owner) + freezingBalance[_owner];
397     }
398 
399     /**
400      * @dev Gets the balance of the specified address without freezing tokens.
401      * @param _owner The address to query the the balance of.
402      * @return An uint256 representing the amount owned by the passed address.
403      */
404     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
405         return super.balanceOf(_owner);
406     }
407 
408     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
409         return freezingBalance[_owner];
410     }
411 
412     /**
413      * @dev gets freezing count
414      * @param _addr Address of freeze tokens owner.
415      */
416     function freezingCount(address _addr) public view returns (uint count) {
417         uint64 release = chains[toKey(_addr, 0)];
418         while (release != 0) {
419             count++;
420             release = chains[toKey(_addr, release)];
421         }
422     }
423 
424     /**
425      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
426      * @param _addr Address of freeze tokens owner.
427      * @param _index Freezing portion index. It ordered by release date descending.
428      */
429     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
430         for (uint i = 0; i < _index + 1; i++) {
431             _release = chains[toKey(_addr, _release)];
432             if (_release == 0) {
433                 return;
434             }
435         }
436         _balance = freezings[toKey(_addr, _release)];
437     }
438 
439     /**
440      * @dev freeze your tokens to the specified address.
441      *      Be careful, gas usage is not deterministic,
442      *      and depends on how many freezes _to address already has.
443      * @param _to Address to which token will be freeze.
444      * @param _amount Amount of token to freeze.
445      * @param _until Release date, must be in future.
446      */
447     function freezeTo(address _to, uint _amount, uint64 _until) public {
448         require(_to != address(0));
449         require(_amount <= balances[msg.sender]);
450 
451         balances[msg.sender] = balances[msg.sender].sub(_amount);
452 
453         bytes32 currentKey = toKey(_to, _until);
454         freezings[currentKey] = freezings[currentKey].add(_amount);
455         freezingBalance[_to] = freezingBalance[_to].add(_amount);
456 
457         freeze(_to, _until);
458         emit Transfer(msg.sender, _to, _amount);
459         emit Freezed(_to, _until, _amount);
460     }
461 
462     /**
463      * @dev release first available freezing tokens.
464      */
465     function releaseOnce() public {
466         bytes32 headKey = toKey(msg.sender, 0);
467         uint64 head = chains[headKey];
468         require(head != 0);
469         require(uint64(block.timestamp) > head);
470         bytes32 currentKey = toKey(msg.sender, head);
471 
472         uint64 next = chains[currentKey];
473 
474         uint amount = freezings[currentKey];
475         delete freezings[currentKey];
476 
477         balances[msg.sender] = balances[msg.sender].add(amount);
478         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
479 
480         if (next == 0) {
481             delete chains[headKey];
482         } else {
483             chains[headKey] = next;
484             delete chains[currentKey];
485         }
486         emit Released(msg.sender, amount);
487     }
488 
489     /**
490      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
491      * @return how many tokens was released
492      */
493     function releaseAll() public returns (uint tokens) {
494         uint release;
495         uint balance;
496         (release, balance) = getFreezing(msg.sender, 0);
497         while (release != 0 && block.timestamp > release) {
498             releaseOnce();
499             tokens += balance;
500             (release, balance) = getFreezing(msg.sender, 0);
501         }
502     }
503 
504     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
505         // WISH masc to increase entropy
506         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
507         assembly {
508             result := or(result, mul(_addr, 0x10000000000000000))
509             result := or(result, _release)
510         }
511     }
512 
513     function freeze(address _to, uint64 _until) internal {
514         require(_until > block.timestamp);
515         bytes32 key = toKey(_to, _until);
516         bytes32 parentKey = toKey(_to, uint64(0));
517         uint64 next = chains[parentKey];
518 
519         if (next == 0) {
520             chains[parentKey] = _until;
521             return;
522         }
523 
524         bytes32 nextKey = toKey(_to, next);
525         uint parent;
526 
527         while (next != 0 && _until > next) {
528             parent = next;
529             parentKey = nextKey;
530 
531             next = chains[nextKey];
532             nextKey = toKey(_to, next);
533         }
534 
535         if (_until == next) {
536             return;
537         }
538 
539         if (next != 0) {
540             chains[key] = next;
541         }
542 
543         chains[parentKey] = _until;
544     }
545 }
546 
547 
548 /**
549  * @title Burnable Token
550  * @dev Token that can be irreversibly burned (destroyed).
551  */
552 contract BurnableToken is BasicToken {
553 
554   event Burn(address indexed burner, uint256 value);
555 
556   /**
557    * @dev Burns a specific amount of tokens.
558    * @param _value The amount of token to be burned.
559    */
560   function burn(uint256 _value) public {
561     _burn(msg.sender, _value);
562   }
563 
564   function _burn(address _who, uint256 _value) internal {
565     require(_value <= balances[_who]);
566     // no need to require value <= totalSupply, since that would imply the
567     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
568 
569     balances[_who] = balances[_who].sub(_value);
570     totalSupply_ = totalSupply_.sub(_value);
571     emit Burn(_who, _value);
572     emit Transfer(_who, address(0), _value);
573   }
574 }
575 
576 
577 
578 /**
579  * @title Pausable
580  * @dev Base contract which allows children to implement an emergency stop mechanism.
581  */
582 contract Pausable is Ownable {
583   event Pause();
584   event Unpause();
585 
586   bool public paused = false;
587 
588 
589   /**
590    * @dev Modifier to make a function callable only when the contract is not paused.
591    */
592   modifier whenNotPaused() {
593     require(!paused);
594     _;
595   }
596 
597   /**
598    * @dev Modifier to make a function callable only when the contract is paused.
599    */
600   modifier whenPaused() {
601     require(paused);
602     _;
603   }
604 
605   /**
606    * @dev called by the owner to pause, triggers stopped state
607    */
608   function pause() onlyOwner whenNotPaused public {
609     paused = true;
610     emit Pause();
611   }
612 
613   /**
614    * @dev called by the owner to unpause, returns to normal state
615    */
616   function unpause() onlyOwner whenPaused public {
617     paused = false;
618     emit Unpause();
619   }
620 }
621 
622 
623 contract FreezableMintableToken is FreezableToken, MintableToken {
624     /**
625      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
626      *      Be careful, gas usage is not deterministic,
627      *      and depends on how many freezes _to address already has.
628      * @param _to Address to which token will be freeze.
629      * @param _amount Amount of token to mint and freeze.
630      * @param _until Release date, must be in future.
631      * @return A boolean that indicates if the operation was successful.
632      */
633     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
634         totalSupply_ = totalSupply_.add(_amount);
635 
636         bytes32 currentKey = toKey(_to, _until);
637         freezings[currentKey] = freezings[currentKey].add(_amount);
638         freezingBalance[_to] = freezingBalance[_to].add(_amount);
639 
640         freeze(_to, _until);
641         emit Mint(_to, _amount);
642         emit Freezed(_to, _until, _amount);
643         emit Transfer(msg.sender, _to, _amount);
644         return true;
645     }
646 }
647 
648 
649 
650 contract Consts {
651     uint public constant TOKEN_DECIMALS = 8;
652     uint8 public constant TOKEN_DECIMALS_UINT8 = 8;
653     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
654 
655     string public constant TOKEN_NAME = "GLOBEX";
656     string public constant TOKEN_SYMBOL = "GEX";
657     bool public constant PAUSED = true;
658     address public constant TARGET_USER = 0xFB3F321f4BC12640a05a710b11Ec86FF55dA2699;
659     
660     uint public constant START_TIME = 1540476000;
661     
662     bool public constant CONTINUE_MINTING = false;
663 }
664 
665 
666 
667 
668 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
669     
670 {
671     
672 
673     function name() public pure returns (string _name) {
674         return TOKEN_NAME;
675     }
676 
677     function symbol() public pure returns (string _symbol) {
678         return TOKEN_SYMBOL;
679     }
680 
681     function decimals() public pure returns (uint8 _decimals) {
682         return TOKEN_DECIMALS_UINT8;
683     }
684 
685     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
686         require(!paused);
687         return super.transferFrom(_from, _to, _value);
688     }
689 
690     function transfer(address _to, uint256 _value) public returns (bool _success) {
691         require(!paused);
692         return super.transfer(_to, _value);
693     }
694 
695     
696 }