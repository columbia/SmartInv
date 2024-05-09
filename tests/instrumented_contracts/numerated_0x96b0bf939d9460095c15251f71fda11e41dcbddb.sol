1 /*
2  * This program is free software: you can redistribute it and/or modify
3  * it under the terms of the GNU Lesser General Public License as published by
4  * the Free Software Foundation, either version 3 of the License, or
5  * (at your option) any later version.
6  *
7  * This program is distributed in the hope that it will be useful,
8  * but WITHOUT ANY WARRANTY; without even the implied warranty of
9  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
10  * GNU Lesser General Public License for more details.
11  *
12  * You should have received a copy of the GNU Lesser General Public License
13  * along with this program. If not, see <http://www.gnu.org/licenses/>.
14  */
15 pragma solidity ^0.4.23;
16 
17 
18 /**
19  * @title ERC20Basic
20  * @dev Simpler version of ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/179
22  */
23 contract ERC20Basic {
24   function totalSupply() public view returns (uint256);
25   function balanceOf(address who) public view returns (uint256);
26   function transfer(address to, uint256 value) public returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, throws on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (a == 0) {
46       return 0;
47     }
48 
49     c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     // uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return a / b;
62   }
63 
64   /**
65   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   uint256 totalSupply_;
94 
95   /**
96   * @dev total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[msg.sender]);
110 
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender)
135     public view returns (uint256);
136 
137   function transferFrom(address from, address to, uint256 value)
138     public returns (bool);
139 
140   function approve(address spender, uint256 value) public returns (bool);
141   event Approval(
142     address indexed owner,
143     address indexed spender,
144     uint256 value
145   );
146 }
147 
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(
168     address _from,
169     address _to,
170     uint256 _value
171   )
172     public
173     returns (bool)
174   {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     allowed[msg.sender][_spender] = _value;
198     emit Approval(msg.sender, _spender, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(
209     address _owner,
210     address _spender
211    )
212     public
213     view
214     returns (uint256)
215   {
216     return allowed[_owner][_spender];
217   }
218 
219   /**
220    * @dev Increase the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _addedValue The amount of tokens to increase the allowance by.
228    */
229   function increaseApproval(
230     address _spender,
231     uint _addedValue
232   )
233     public
234     returns (bool)
235   {
236     allowed[msg.sender][_spender] = (
237       allowed[msg.sender][_spender].add(_addedValue));
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(
253     address _spender,
254     uint _subtractedValue
255   )
256     public
257     returns (bool)
258   {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 
272 
273 /**
274  * @title Ownable
275  * @dev The Ownable contract has an owner address, and provides basic authorization control
276  * functions, this simplifies the implementation of "user permissions".
277  */
278 contract Ownable {
279   address public owner;
280 
281 
282   event OwnershipRenounced(address indexed previousOwner);
283   event OwnershipTransferred(
284     address indexed previousOwner,
285     address indexed newOwner
286   );
287 
288 
289   /**
290    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
291    * account.
292    */
293   constructor() public {
294     owner = msg.sender;
295   }
296 
297   /**
298    * @dev Throws if called by any account other than the owner.
299    */
300   modifier onlyOwner() {
301     require(msg.sender == owner);
302     _;
303   }
304 
305   /**
306    * @dev Allows the current owner to relinquish control of the contract.
307    */
308   function renounceOwnership() public onlyOwner {
309     emit OwnershipRenounced(owner);
310     owner = address(0);
311   }
312 
313   /**
314    * @dev Allows the current owner to transfer control of the contract to a newOwner.
315    * @param _newOwner The address to transfer ownership to.
316    */
317   function transferOwnership(address _newOwner) public onlyOwner {
318     _transferOwnership(_newOwner);
319   }
320 
321   /**
322    * @dev Transfers control of the contract to a newOwner.
323    * @param _newOwner The address to transfer ownership to.
324    */
325   function _transferOwnership(address _newOwner) internal {
326     require(_newOwner != address(0));
327     emit OwnershipTransferred(owner, _newOwner);
328     owner = _newOwner;
329   }
330 }
331 
332 
333 /**
334  * @title Mintable token
335  * @dev Simple ERC20 Token example, with mintable token creation
336  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
337  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
338  */
339 contract MintableToken is StandardToken, Ownable {
340   event Mint(address indexed to, uint256 amount);
341   event MintFinished();
342 
343   bool public mintingFinished = false;
344 
345 
346   modifier canMint() {
347     require(!mintingFinished);
348     _;
349   }
350 
351   modifier hasMintPermission() {
352     require(msg.sender == owner);
353     _;
354   }
355 
356   /**
357    * @dev Function to mint tokens
358    * @param _to The address that will receive the minted tokens.
359    * @param _amount The amount of tokens to mint.
360    * @return A boolean that indicates if the operation was successful.
361    */
362   function mint(
363     address _to,
364     uint256 _amount
365   )
366     hasMintPermission
367     canMint
368     public
369     returns (bool)
370   {
371     totalSupply_ = totalSupply_.add(_amount);
372     balances[_to] = balances[_to].add(_amount);
373     emit Mint(_to, _amount);
374     emit Transfer(address(0), _to, _amount);
375     return true;
376   }
377 
378   /**
379    * @dev Function to stop minting new tokens.
380    * @return True if the operation was successful.
381    */
382   function finishMinting() onlyOwner canMint public returns (bool) {
383     mintingFinished = true;
384     emit MintFinished();
385     return true;
386   }
387 }
388 
389 
390 contract FreezableToken is StandardToken {
391     // freezing chains
392     mapping (bytes32 => uint64) internal chains;
393     // freezing amounts for each chain
394     mapping (bytes32 => uint) internal freezings;
395     // total freezing balance per address
396     mapping (address => uint) internal freezingBalance;
397 
398     event Freezed(address indexed to, uint64 release, uint amount);
399     event Released(address indexed owner, uint amount);
400 
401     /**
402      * @dev Gets the balance of the specified address include freezing tokens.
403      * @param _owner The address to query the the balance of.
404      * @return An uint256 representing the amount owned by the passed address.
405      */
406     function balanceOf(address _owner) public view returns (uint256 balance) {
407         return super.balanceOf(_owner) + freezingBalance[_owner];
408     }
409 
410     /**
411      * @dev Gets the balance of the specified address without freezing tokens.
412      * @param _owner The address to query the the balance of.
413      * @return An uint256 representing the amount owned by the passed address.
414      */
415     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
416         return super.balanceOf(_owner);
417     }
418 
419     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
420         return freezingBalance[_owner];
421     }
422 
423     /**
424      * @dev gets freezing count
425      * @param _addr Address of freeze tokens owner.
426      */
427     function freezingCount(address _addr) public view returns (uint count) {
428         uint64 release = chains[toKey(_addr, 0)];
429         while (release != 0) {
430             count++;
431             release = chains[toKey(_addr, release)];
432         }
433     }
434 
435     /**
436      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
437      * @param _addr Address of freeze tokens owner.
438      * @param _index Freezing portion index. It ordered by release date descending.
439      */
440     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
441         for (uint i = 0; i < _index + 1; i++) {
442             _release = chains[toKey(_addr, _release)];
443             if (_release == 0) {
444                 return;
445             }
446         }
447         _balance = freezings[toKey(_addr, _release)];
448     }
449 
450     /**
451      * @dev freeze your tokens to the specified address.
452      *      Be careful, gas usage is not deterministic,
453      *      and depends on how many freezes _to address already has.
454      * @param _to Address to which token will be freeze.
455      * @param _amount Amount of token to freeze.
456      * @param _until Release date, must be in future.
457      */
458     function freezeTo(address _to, uint _amount, uint64 _until) public {
459         require(_to != address(0));
460         require(_amount <= balances[msg.sender]);
461 
462         balances[msg.sender] = balances[msg.sender].sub(_amount);
463 
464         bytes32 currentKey = toKey(_to, _until);
465         freezings[currentKey] = freezings[currentKey].add(_amount);
466         freezingBalance[_to] = freezingBalance[_to].add(_amount);
467 
468         freeze(_to, _until);
469         emit Transfer(msg.sender, _to, _amount);
470         emit Freezed(_to, _until, _amount);
471     }
472 
473     /**
474      * @dev release first available freezing tokens.
475      */
476     function releaseOnce() public {
477         bytes32 headKey = toKey(msg.sender, 0);
478         uint64 head = chains[headKey];
479         require(head != 0);
480         require(uint64(block.timestamp) > head);
481         bytes32 currentKey = toKey(msg.sender, head);
482 
483         uint64 next = chains[currentKey];
484 
485         uint amount = freezings[currentKey];
486         delete freezings[currentKey];
487 
488         balances[msg.sender] = balances[msg.sender].add(amount);
489         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
490 
491         if (next == 0) {
492             delete chains[headKey];
493         } else {
494             chains[headKey] = next;
495             delete chains[currentKey];
496         }
497         emit Released(msg.sender, amount);
498     }
499 
500     /**
501      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
502      * @return how many tokens was released
503      */
504     function releaseAll() public returns (uint tokens) {
505         uint release;
506         uint balance;
507         (release, balance) = getFreezing(msg.sender, 0);
508         while (release != 0 && block.timestamp > release) {
509             releaseOnce();
510             tokens += balance;
511             (release, balance) = getFreezing(msg.sender, 0);
512         }
513     }
514 
515     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
516         // WISH masc to increase entropy
517         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
518         assembly {
519             result := or(result, mul(_addr, 0x10000000000000000))
520             result := or(result, _release)
521         }
522     }
523 
524     function freeze(address _to, uint64 _until) internal {
525         require(_until > block.timestamp);
526         bytes32 key = toKey(_to, _until);
527         bytes32 parentKey = toKey(_to, uint64(0));
528         uint64 next = chains[parentKey];
529 
530         if (next == 0) {
531             chains[parentKey] = _until;
532             return;
533         }
534 
535         bytes32 nextKey = toKey(_to, next);
536         uint parent;
537 
538         while (next != 0 && _until > next) {
539             parent = next;
540             parentKey = nextKey;
541 
542             next = chains[nextKey];
543             nextKey = toKey(_to, next);
544         }
545 
546         if (_until == next) {
547             return;
548         }
549 
550         if (next != 0) {
551             chains[key] = next;
552         }
553 
554         chains[parentKey] = _until;
555     }
556 }
557 
558 
559 /**
560  * @title Burnable Token
561  * @dev Token that can be irreversibly burned (destroyed).
562  */
563 contract BurnableToken is BasicToken {
564 
565   event Burn(address indexed burner, uint256 value);
566 
567   /**
568    * @dev Burns a specific amount of tokens.
569    * @param _value The amount of token to be burned.
570    */
571   function burn(uint256 _value) public {
572     _burn(msg.sender, _value);
573   }
574 
575   function _burn(address _who, uint256 _value) internal {
576     require(_value <= balances[_who]);
577     // no need to require value <= totalSupply, since that would imply the
578     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
579 
580     balances[_who] = balances[_who].sub(_value);
581     totalSupply_ = totalSupply_.sub(_value);
582     emit Burn(_who, _value);
583     emit Transfer(_who, address(0), _value);
584   }
585 }
586 
587 
588 
589 /**
590  * @title Pausable
591  * @dev Base contract which allows children to implement an emergency stop mechanism.
592  */
593 contract Pausable is Ownable {
594   event Pause();
595   event Unpause();
596 
597   bool public paused = false;
598 
599 
600   /**
601    * @dev Modifier to make a function callable only when the contract is not paused.
602    */
603   modifier whenNotPaused() {
604     require(!paused);
605     _;
606   }
607 
608   /**
609    * @dev Modifier to make a function callable only when the contract is paused.
610    */
611   modifier whenPaused() {
612     require(paused);
613     _;
614   }
615 
616   /**
617    * @dev called by the owner to pause, triggers stopped state
618    */
619   function pause() onlyOwner whenNotPaused public {
620     paused = true;
621     emit Pause();
622   }
623 
624   /**
625    * @dev called by the owner to unpause, returns to normal state
626    */
627   function unpause() onlyOwner whenPaused public {
628     paused = false;
629     emit Unpause();
630   }
631 }
632 
633 
634 contract FreezableMintableToken is FreezableToken, MintableToken {
635     /**
636      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
637      *      Be careful, gas usage is not deterministic,
638      *      and depends on how many freezes _to address already has.
639      * @param _to Address to which token will be freeze.
640      * @param _amount Amount of token to mint and freeze.
641      * @param _until Release date, must be in future.
642      * @return A boolean that indicates if the operation was successful.
643      */
644     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
645         totalSupply_ = totalSupply_.add(_amount);
646 
647         bytes32 currentKey = toKey(_to, _until);
648         freezings[currentKey] = freezings[currentKey].add(_amount);
649         freezingBalance[_to] = freezingBalance[_to].add(_amount);
650 
651         freeze(_to, _until);
652         emit Mint(_to, _amount);
653         emit Freezed(_to, _until, _amount);
654         emit Transfer(msg.sender, _to, _amount);
655         return true;
656     }
657 }
658 
659 
660 
661 contract Consts {
662     uint public constant TOKEN_DECIMALS = 18;
663     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
664     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
665 
666     string public constant TOKEN_NAME = "Sharpay";
667     string public constant TOKEN_SYMBOL = "S";
668     bool public constant PAUSED = false;
669     address public constant TARGET_USER = 0x625B05c9a1d1148D28D44354950013492124094d;
670     
671     bool public constant CONTINUE_MINTING = true;
672 }
673 
674 
675 
676 
677 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
678     
679 {
680     
681     event Initialized();
682     bool public initialized = false;
683 
684     constructor() public {
685         init();
686         transferOwnership(TARGET_USER);
687     }
688     
689 
690     function name() public pure returns (string _name) {
691         return TOKEN_NAME;
692     }
693 
694     function symbol() public pure returns (string _symbol) {
695         return TOKEN_SYMBOL;
696     }
697 
698     function decimals() public pure returns (uint8 _decimals) {
699         return TOKEN_DECIMALS_UINT8;
700     }
701 
702     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
703         require(!paused);
704         return super.transferFrom(_from, _to, _value);
705     }
706 
707     function transfer(address _to, uint256 _value) public returns (bool _success) {
708         require(!paused);
709         return super.transfer(_to, _value);
710     }
711 
712     
713     function init() private {
714         require(!initialized);
715         initialized = true;
716 
717         if (PAUSED) {
718             pause();
719         }
720 
721         
722         address[5] memory addresses = [address(0xa77273cba38b587c05defac6ac564f910472900e),address(0xa77273cba38b587c05defac6ac564f910472900e),address(0xa77273cba38b587c05defac6ac564f910472900e),address(0x973a0d5a68081497769e4794e58ca64b020dc164),address(0x7dddf3bc31dd30526fc72d0c73e99528c1a4a011)];
723         uint[5] memory amounts = [uint(621000000000000000000000000),uint(496800000000000000000000000),uint(124200000000000000000000000),uint(100000000000000000000000000),uint(1778000000000000000000000000)];
724         uint64[5] memory freezes = [uint64(1609441201),uint64(1577818801),uint64(1546282801),uint64(0),uint64(0)];
725 
726         for (uint i = 0; i < addresses.length; i++) {
727             if (freezes[i] == 0) {
728                 mint(addresses[i], amounts[i]);
729             } else {
730                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
731             }
732         }
733         
734 
735         if (!CONTINUE_MINTING) {
736             finishMinting();
737         }
738 
739         emit Initialized();
740     }
741     
742 }