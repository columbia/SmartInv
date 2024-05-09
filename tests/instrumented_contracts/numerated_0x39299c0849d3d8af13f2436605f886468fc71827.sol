1 /*
2 J4M3584P7157
3  *
4  * This program is free software: you can redistribute it and/or modify
5  * it under the terms of the GNU Lesser General Public License as published by
6  * the Free Software Foundation, either version 3 of the License, or
7  * (at your option) any later version.
8  *
9  * This program is distributed in the hope that it will be useful,
10  * but WITHOUT ANY WARRANTY; without even the implied warranty of
11  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12  * GNU Lesser General Public License for more details.
13  *
14  * You should have received a copy of the GNU Lesser General Public License
15  * along with this program. If not, see <http://www.gnu.org/licenses/>.
16  */
17 pragma solidity ^0.4.23;
18 
19 
20 /**
21  * @title ERC20Basic
22  * @dev Simpler version of ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/179
24  */
25 contract ERC20Basic {
26   function totalSupply() public view returns (uint256);
27   function balanceOf(address who) public view returns (uint256);
28   function transfer(address to, uint256 value) public returns (bool);
29   event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
45     // benefit is lost if 'b' is also tested.
46     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47     if (a == 0) {
48       return 0;
49     }
50 
51     c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     // uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return a / b;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
78     c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   uint256 totalSupply_;
96 
97   /**
98   * @dev total number of tokens in existence
99   */
100   function totalSupply() public view returns (uint256) {
101     return totalSupply_;
102   }
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[msg.sender]);
112 
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     emit Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender)
137     public view returns (uint256);
138 
139   function transferFrom(address from, address to, uint256 value)
140     public returns (bool);
141 
142   function approve(address spender, uint256 value) public returns (bool);
143   event Approval(
144     address indexed owner,
145     address indexed spender,
146     uint256 value
147   );
148 }
149 
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160   mapping (address => mapping (address => uint256)) internal allowed;
161 
162 
163   /**
164    * @dev Transfer tokens from one address to another
165    * @param _from address The address which you want to send tokens from
166    * @param _to address The address which you want to transfer to
167    * @param _value uint256 the amount of tokens to be transferred
168    */
169   function transferFrom(
170     address _from,
171     address _to,
172     uint256 _value
173   )
174     public
175     returns (bool)
176   {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     emit Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     emit Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(
211     address _owner,
212     address _spender
213    )
214     public
215     view
216     returns (uint256)
217   {
218     return allowed[_owner][_spender];
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To increment
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _addedValue The amount of tokens to increase the allowance by.
230    */
231   function increaseApproval(
232     address _spender,
233     uint _addedValue
234   )
235     public
236     returns (bool)
237   {
238     allowed[msg.sender][_spender] = (
239       allowed[msg.sender][_spender].add(_addedValue));
240     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244   /**
245    * @dev Decrease the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To decrement
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _subtractedValue The amount of tokens to decrease the allowance by.
253    */
254   function decreaseApproval(
255     address _spender,
256     uint _subtractedValue
257   )
258     public
259     returns (bool)
260   {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 
274 
275 /**
276  * @title Ownable
277  * @dev The Ownable contract has an owner address, and provides basic authorization control
278  * functions, this simplifies the implementation of "user permissions".
279  */
280 contract Ownable {
281   address public owner;
282 
283 
284   event OwnershipRenounced(address indexed previousOwner);
285   event OwnershipTransferred(
286     address indexed previousOwner,
287     address indexed newOwner
288   );
289 
290 
291   /**
292    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
293    * account.
294    */
295   constructor() public {
296     owner = msg.sender;
297   }
298 
299   /**
300    * @dev Throws if called by any account other than the owner.
301    */
302   modifier onlyOwner() {
303     require(msg.sender == owner);
304     _;
305   }
306 
307   /**
308    * @dev Allows the current owner to relinquish control of the contract.
309    */
310   function renounceOwnership() public onlyOwner {
311     emit OwnershipRenounced(owner);
312     owner = address(0);
313   }
314 
315   /**
316    * @dev Allows the current owner to transfer control of the contract to a newOwner.
317    * @param _newOwner The address to transfer ownership to.
318    */
319   function transferOwnership(address _newOwner) public onlyOwner {
320     _transferOwnership(_newOwner);
321   }
322 
323   /**
324    * @dev Transfers control of the contract to a newOwner.
325    * @param _newOwner The address to transfer ownership to.
326    */
327   function _transferOwnership(address _newOwner) internal {
328     require(_newOwner != address(0));
329     emit OwnershipTransferred(owner, _newOwner);
330     owner = _newOwner;
331   }
332 }
333 
334 
335 /**
336  * @title Mintable token
337  * @dev Simple ERC20 Token example, with mintable token creation
338  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
339  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
340  */
341 contract MintableToken is StandardToken, Ownable {
342   event Mint(address indexed to, uint256 amount);
343   event MintFinished();
344 
345   bool public mintingFinished = false;
346 
347 
348   modifier canMint() {
349     require(!mintingFinished);
350     _;
351   }
352 
353   modifier hasMintPermission() {
354     require(msg.sender == owner);
355     _;
356   }
357 
358   /**
359    * @dev Function to mint tokens
360    * @param _to The address that will receive the minted tokens.
361    * @param _amount The amount of tokens to mint.
362    * @return A boolean that indicates if the operation was successful.
363    */
364   function mint(
365     address _to,
366     uint256 _amount
367   )
368     hasMintPermission
369     canMint
370     public
371     returns (bool)
372   {
373     totalSupply_ = totalSupply_.add(_amount);
374     balances[_to] = balances[_to].add(_amount);
375     emit Mint(_to, _amount);
376     emit Transfer(address(0), _to, _amount);
377     return true;
378   }
379 
380   /**
381    * @dev Function to stop minting new tokens.
382    * @return True if the operation was successful.
383    */
384   function finishMinting() onlyOwner canMint public returns (bool) {
385     mintingFinished = true;
386     emit MintFinished();
387     return true;
388   }
389 }
390 
391 
392 contract FreezableToken is StandardToken {
393     // freezing chains
394     mapping (bytes32 => uint64) internal chains;
395     // freezing amounts for each chain
396     mapping (bytes32 => uint) internal freezings;
397     // total freezing balance per address
398     mapping (address => uint) internal freezingBalance;
399 
400     event Freezed(address indexed to, uint64 release, uint amount);
401     event Released(address indexed owner, uint amount);
402 
403     /**
404      * @dev Gets the balance of the specified address include freezing tokens.
405      * @param _owner The address to query the the balance of.
406      * @return An uint256 representing the amount owned by the passed address.
407      */
408     function balanceOf(address _owner) public view returns (uint256 balance) {
409         return super.balanceOf(_owner) + freezingBalance[_owner];
410     }
411 
412     /**
413      * @dev Gets the balance of the specified address without freezing tokens.
414      * @param _owner The address to query the the balance of.
415      * @return An uint256 representing the amount owned by the passed address.
416      */
417     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
418         return super.balanceOf(_owner);
419     }
420 
421     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
422         return freezingBalance[_owner];
423     }
424 
425     /**
426      * @dev gets freezing count
427      * @param _addr Address of freeze tokens owner.
428      */
429     function freezingCount(address _addr) public view returns (uint count) {
430         uint64 release = chains[toKey(_addr, 0)];
431         while (release != 0) {
432             count++;
433             release = chains[toKey(_addr, release)];
434         }
435     }
436 
437     /**
438      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
439      * @param _addr Address of freeze tokens owner.
440      * @param _index Freezing portion index. It ordered by release date descending.
441      */
442     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
443         for (uint i = 0; i < _index + 1; i++) {
444             _release = chains[toKey(_addr, _release)];
445             if (_release == 0) {
446                 return;
447             }
448         }
449         _balance = freezings[toKey(_addr, _release)];
450     }
451 
452     /**
453      * @dev freeze your tokens to the specified address.
454      *      Be careful, gas usage is not deterministic,
455      *      and depends on how many freezes _to address already has.
456      * @param _to Address to which token will be freeze.
457      * @param _amount Amount of token to freeze.
458      * @param _until Release date, must be in future.
459      */
460     function freezeTo(address _to, uint _amount, uint64 _until) public {
461         require(_to != address(0));
462         require(_amount <= balances[msg.sender]);
463 
464         balances[msg.sender] = balances[msg.sender].sub(_amount);
465 
466         bytes32 currentKey = toKey(_to, _until);
467         freezings[currentKey] = freezings[currentKey].add(_amount);
468         freezingBalance[_to] = freezingBalance[_to].add(_amount);
469 
470         freeze(_to, _until);
471         emit Transfer(msg.sender, _to, _amount);
472         emit Freezed(_to, _until, _amount);
473     }
474 
475     /**
476      * @dev release first available freezing tokens.
477      */
478     function releaseOnce() public {
479         bytes32 headKey = toKey(msg.sender, 0);
480         uint64 head = chains[headKey];
481         require(head != 0);
482         require(uint64(block.timestamp) > head);
483         bytes32 currentKey = toKey(msg.sender, head);
484 
485         uint64 next = chains[currentKey];
486 
487         uint amount = freezings[currentKey];
488         delete freezings[currentKey];
489 
490         balances[msg.sender] = balances[msg.sender].add(amount);
491         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
492 
493         if (next == 0) {
494             delete chains[headKey];
495         } else {
496             chains[headKey] = next;
497             delete chains[currentKey];
498         }
499         emit Released(msg.sender, amount);
500     }
501 
502     /**
503      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
504      * @return how many tokens was released
505      */
506     function releaseAll() public returns (uint tokens) {
507         uint release;
508         uint balance;
509         (release, balance) = getFreezing(msg.sender, 0);
510         while (release != 0 && block.timestamp > release) {
511             releaseOnce();
512             tokens += balance;
513             (release, balance) = getFreezing(msg.sender, 0);
514         }
515     }
516 
517     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
518         // WISH masc to increase entropy
519         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
520         assembly {
521             result := or(result, mul(_addr, 0x10000000000000000))
522             result := or(result, _release)
523         }
524     }
525 
526     function freeze(address _to, uint64 _until) internal {
527         require(_until > block.timestamp);
528         bytes32 key = toKey(_to, _until);
529         bytes32 parentKey = toKey(_to, uint64(0));
530         uint64 next = chains[parentKey];
531 
532         if (next == 0) {
533             chains[parentKey] = _until;
534             return;
535         }
536 
537         bytes32 nextKey = toKey(_to, next);
538         uint parent;
539 
540         while (next != 0 && _until > next) {
541             parent = next;
542             parentKey = nextKey;
543 
544             next = chains[nextKey];
545             nextKey = toKey(_to, next);
546         }
547 
548         if (_until == next) {
549             return;
550         }
551 
552         if (next != 0) {
553             chains[key] = next;
554         }
555 
556         chains[parentKey] = _until;
557     }
558 }
559 
560 
561 /**
562  * @title Burnable Token
563  * @dev Token that can be irreversibly burned (destroyed).
564  */
565 contract BurnableToken is BasicToken {
566 
567   event Burn(address indexed burner, uint256 value);
568 
569   /**
570    * @dev Burns a specific amount of tokens.
571    * @param _value The amount of token to be burned.
572    */
573   function burn(uint256 _value) public {
574     _burn(msg.sender, _value);
575   }
576 
577   function _burn(address _who, uint256 _value) internal {
578     require(_value <= balances[_who]);
579     // no need to require value <= totalSupply, since that would imply the
580     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
581 
582     balances[_who] = balances[_who].sub(_value);
583     totalSupply_ = totalSupply_.sub(_value);
584     emit Burn(_who, _value);
585     emit Transfer(_who, address(0), _value);
586   }
587 }
588 
589 
590 
591 /**
592  * @title Pausable
593  * @dev Base contract which allows children to implement an emergency stop mechanism.
594  */
595 contract Pausable is Ownable {
596   event Pause();
597   event Unpause();
598 
599   bool public paused = false;
600 
601 
602   /**
603    * @dev Modifier to make a function callable only when the contract is not paused.
604    */
605   modifier whenNotPaused() {
606     require(!paused);
607     _;
608   }
609 
610   /**
611    * @dev Modifier to make a function callable only when the contract is paused.
612    */
613   modifier whenPaused() {
614     require(paused);
615     _;
616   }
617 
618   /**
619    * @dev called by the owner to pause, triggers stopped state
620    */
621   function pause() onlyOwner whenNotPaused public {
622     paused = true;
623     emit Pause();
624   }
625 
626   /**
627    * @dev called by the owner to unpause, returns to normal state
628    */
629   function unpause() onlyOwner whenPaused public {
630     paused = false;
631     emit Unpause();
632   }
633 }
634 
635 
636 contract FreezableMintableToken is FreezableToken, MintableToken {
637     /**
638      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
639      *      Be careful, gas usage is not deterministic,
640      *      and depends on how many freezes _to address already has.
641      * @param _to Address to which token will be freeze.
642      * @param _amount Amount of token to mint and freeze.
643      * @param _until Release date, must be in future.
644      * @return A boolean that indicates if the operation was successful.
645      */
646     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
647         totalSupply_ = totalSupply_.add(_amount);
648 
649         bytes32 currentKey = toKey(_to, _until);
650         freezings[currentKey] = freezings[currentKey].add(_amount);
651         freezingBalance[_to] = freezingBalance[_to].add(_amount);
652 
653         freeze(_to, _until);
654         emit Mint(_to, _amount);
655         emit Freezed(_to, _until, _amount);
656         emit Transfer(msg.sender, _to, _amount);
657         return true;
658     }
659 }
660 
661 
662 
663 contract Consts {
664     uint public constant TOKEN_DECIMALS = 18;
665     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
666     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
667 
668     string public constant TOKEN_NAME = "N17R0X";
669     string public constant TOKEN_SYMBOL = "N17R0X";
670     bool public constant PAUSED = false;
671     address public constant TARGET_USER = 0xc900AD4141b51b104dB0F2Ec6fD5FAF611575Bee;
672     
673     bool public constant CONTINUE_MINTING = true;
674 }
675 
676 
677 
678 
679 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
680     
681 {
682     
683     event Initialized();
684     bool public initialized = false;
685 
686     constructor() public {
687         init();
688         transferOwnership(TARGET_USER);
689     }
690     
691 
692     function name() public pure returns (string _name) {
693         return TOKEN_NAME;
694     }
695 
696     function symbol() public pure returns (string _symbol) {
697         return TOKEN_SYMBOL;
698     }
699 
700     function decimals() public pure returns (uint8 _decimals) {
701         return TOKEN_DECIMALS_UINT8;
702     }
703 
704     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
705         require(!paused);
706         return super.transferFrom(_from, _to, _value);
707     }
708 
709     function transfer(address _to, uint256 _value) public returns (bool _success) {
710         require(!paused);
711         return super.transfer(_to, _value);
712     }
713 
714     
715     function init() private {
716         require(!initialized);
717         initialized = true;
718 
719         if (PAUSED) {
720             pause();
721         }
722 
723         
724         address[1] memory addresses = [address(0xc900ad4141b51b104db0f2ec6fd5faf611575bee)];
725         uint[1] memory amounts = [uint(1000000000000000000000000000)];
726         uint64[1] memory freezes = [uint64(0)];
727 
728         for (uint i = 0; i < addresses.length; i++) {
729             if (freezes[i] == 0) {
730                 mint(addresses[i], amounts[i]);
731             } else {
732                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
733             }
734         }
735         
736 
737         if (!CONTINUE_MINTING) {
738             finishMinting();
739         }
740 
741         emit Initialized();
742     }
743     
744 }