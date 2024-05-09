1 /*
2  * 'BFCL L.L.C.' TOKEN contract
3  *
4  * Symbol      : BFCL
5  * Name        : Bolton
6  * Decimals    : 18
7  *
8  * Copyright (C) 2018 Raffaele Bini - 5esse Informatica (https://www.5esse.it)
9  *
10  * Made with passion with Bolton Team
11  *
12  * This program is free software: you can redistribute it and/or modify
13  * it under the terms of the GNU Lesser General Public License as published by
14  * the Free Software Foundation, either version 3 of the License, or
15  * (at your option) any later version.
16  *
17  * This program is distributed in the hope that it will be useful,
18  * but WITHOUT ANY WARRANTY; without even the implied warranty of
19  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
20  * GNU Lesser General Public License for more details.
21  *
22  * You should have received a copy of the GNU Lesser General Public License
23  * along with this program. If not, see <http://www.gnu.org/licenses/>.
24  */
25 pragma solidity ^0.4.23;
26 
27 
28 /**
29  * @title ERC20Basic
30  * @dev Simpler version of ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/179
32  */
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, throws on overflow.
50   */
51   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
53     // benefit is lost if 'b' is also tested.
54     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55     if (a == 0) {
56       return 0;
57     }
58 
59     c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     // uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return a / b;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
86     c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   uint256 totalSupply_;
104 
105   /**
106   * @dev total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     emit Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender)
145     public view returns (uint256);
146 
147   function transferFrom(address from, address to, uint256 value)
148     public returns (bool);
149 
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 value
155   );
156 }
157 
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(
178     address _from,
179     address _to,
180     uint256 _value
181   )
182     public
183     returns (bool)
184   {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     emit Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(
219     address _owner,
220     address _spender
221    )
222     public
223     view
224     returns (uint256)
225   {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * @dev Increase the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseApproval(
240     address _spender,
241     uint _addedValue
242   )
243     public
244     returns (bool)
245   {
246     allowed[msg.sender][_spender] = (
247       allowed[msg.sender][_spender].add(_addedValue));
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Decrease the amount of tokens that an owner allowed to a spender.
254    *
255    * approve should be called when allowed[_spender] == 0. To decrement
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _subtractedValue The amount of tokens to decrease the allowance by.
261    */
262   function decreaseApproval(
263     address _spender,
264     uint _subtractedValue
265   )
266     public
267     returns (bool)
268   {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 
282 
283 /**
284  * @title Ownable
285  * @dev The Ownable contract has an owner address, and provides basic authorization control
286  * functions, this simplifies the implementation of "user permissions".
287  */
288 contract Ownable {
289   address public owner;
290 
291 
292   event OwnershipRenounced(address indexed previousOwner);
293   event OwnershipTransferred(
294     address indexed previousOwner,
295     address indexed newOwner
296   );
297 
298 
299   /**
300    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
301    * account.
302    */
303   constructor() public {
304     owner = msg.sender;
305   }
306 
307   /**
308    * @dev Throws if called by any account other than the owner.
309    */
310   modifier onlyOwner() {
311     require(msg.sender == owner);
312     _;
313   }
314 
315   /**
316    * @dev Allows the current owner to relinquish control of the contract.
317    */
318   function renounceOwnership() public onlyOwner {
319     emit OwnershipRenounced(owner);
320     owner = address(0);
321   }
322 
323   /**
324    * @dev Allows the current owner to transfer control of the contract to a newOwner.
325    * @param _newOwner The address to transfer ownership to.
326    */
327   function transferOwnership(address _newOwner) public onlyOwner {
328     _transferOwnership(_newOwner);
329   }
330 
331   /**
332    * @dev Transfers control of the contract to a newOwner.
333    * @param _newOwner The address to transfer ownership to.
334    */
335   function _transferOwnership(address _newOwner) internal {
336     require(_newOwner != address(0));
337     emit OwnershipTransferred(owner, _newOwner);
338     owner = _newOwner;
339   }
340 }
341 
342 
343 /**
344  * @title Mintable token
345  * @dev Simple ERC20 Token example, with mintable token creation
346  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
347  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
348  */
349 contract MintableToken is StandardToken, Ownable {
350   event Mint(address indexed to, uint256 amount);
351   event MintFinished();
352 
353   bool public mintingFinished = false;
354 
355 
356   modifier canMint() {
357     require(!mintingFinished);
358     _;
359   }
360 
361   modifier hasMintPermission() {
362     require(msg.sender == owner);
363     _;
364   }
365 
366   /**
367    * @dev Function to mint tokens
368    * @param _to The address that will receive the minted tokens.
369    * @param _amount The amount of tokens to mint.
370    * @return A boolean that indicates if the operation was successful.
371    */
372   function mint(
373     address _to,
374     uint256 _amount
375   )
376     hasMintPermission
377     canMint
378     public
379     returns (bool)
380   {
381     totalSupply_ = totalSupply_.add(_amount);
382     balances[_to] = balances[_to].add(_amount);
383     emit Mint(_to, _amount);
384     emit Transfer(address(0), _to, _amount);
385     return true;
386   }
387 
388   /**
389    * @dev Function to stop minting new tokens.
390    * @return True if the operation was successful.
391    */
392   function finishMinting() onlyOwner canMint public returns (bool) {
393     mintingFinished = true;
394     emit MintFinished();
395     return true;
396   }
397 }
398 
399 
400 contract FreezableToken is StandardToken {
401     // freezing chains
402     mapping (bytes32 => uint64) internal chains;
403     // freezing amounts for each chain
404     mapping (bytes32 => uint) internal freezings;
405     // total freezing balance per address
406     mapping (address => uint) internal freezingBalance;
407 
408     event Freezed(address indexed to, uint64 release, uint amount);
409     event Released(address indexed owner, uint amount);
410 
411     /**
412      * @dev Gets the balance of the specified address include freezing tokens.
413      * @param _owner The address to query the the balance of.
414      * @return An uint256 representing the amount owned by the passed address.
415      */
416     function balanceOf(address _owner) public view returns (uint256 balance) {
417         return super.balanceOf(_owner) + freezingBalance[_owner];
418     }
419 
420     /**
421      * @dev Gets the balance of the specified address without freezing tokens.
422      * @param _owner The address to query the the balance of.
423      * @return An uint256 representing the amount owned by the passed address.
424      */
425     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
426         return super.balanceOf(_owner);
427     }
428 
429     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
430         return freezingBalance[_owner];
431     }
432 
433     /**
434      * @dev gets freezing count
435      * @param _addr Address of freeze tokens owner.
436      */
437     function freezingCount(address _addr) public view returns (uint count) {
438         uint64 release = chains[toKey(_addr, 0)];
439         while (release != 0) {
440             count++;
441             release = chains[toKey(_addr, release)];
442         }
443     }
444 
445     /**
446      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
447      * @param _addr Address of freeze tokens owner.
448      * @param _index Freezing portion index. It ordered by release date descending.
449      */
450     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
451         for (uint i = 0; i < _index + 1; i++) {
452             _release = chains[toKey(_addr, _release)];
453             if (_release == 0) {
454                 return;
455             }
456         }
457         _balance = freezings[toKey(_addr, _release)];
458     }
459 
460     /**
461      * @dev freeze your tokens to the specified address.
462      *      Be careful, gas usage is not deterministic,
463      *      and depends on how many freezes _to address already has.
464      * @param _to Address to which token will be freeze.
465      * @param _amount Amount of token to freeze.
466      * @param _until Release date, must be in future.
467      */
468     function freezeTo(address _to, uint _amount, uint64 _until) public {
469         require(_to != address(0));
470         require(_amount <= balances[msg.sender]);
471 
472         balances[msg.sender] = balances[msg.sender].sub(_amount);
473 
474         bytes32 currentKey = toKey(_to, _until);
475         freezings[currentKey] = freezings[currentKey].add(_amount);
476         freezingBalance[_to] = freezingBalance[_to].add(_amount);
477 
478         freeze(_to, _until);
479         emit Transfer(msg.sender, _to, _amount);
480         emit Freezed(_to, _until, _amount);
481     }
482 
483     /**
484      * @dev release first available freezing tokens.
485      */
486     function releaseOnce() public {
487         bytes32 headKey = toKey(msg.sender, 0);
488         uint64 head = chains[headKey];
489         require(head != 0);
490         require(uint64(block.timestamp) > head);
491         bytes32 currentKey = toKey(msg.sender, head);
492 
493         uint64 next = chains[currentKey];
494 
495         uint amount = freezings[currentKey];
496         delete freezings[currentKey];
497 
498         balances[msg.sender] = balances[msg.sender].add(amount);
499         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
500 
501         if (next == 0) {
502             delete chains[headKey];
503         } else {
504             chains[headKey] = next;
505             delete chains[currentKey];
506         }
507         emit Released(msg.sender, amount);
508     }
509 
510     /**
511      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
512      * @return how many tokens was released
513      */
514     function releaseAll() public returns (uint tokens) {
515         uint release;
516         uint balance;
517         (release, balance) = getFreezing(msg.sender, 0);
518         while (release != 0 && block.timestamp > release) {
519             releaseOnce();
520             tokens += balance;
521             (release, balance) = getFreezing(msg.sender, 0);
522         }
523     }
524 
525     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
526         // WISH masc to increase entropy
527         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
528         assembly {
529             result := or(result, mul(_addr, 0x10000000000000000))
530             result := or(result, _release)
531         }
532     }
533 
534     function freeze(address _to, uint64 _until) internal {
535         require(_until > block.timestamp);
536         bytes32 key = toKey(_to, _until);
537         bytes32 parentKey = toKey(_to, uint64(0));
538         uint64 next = chains[parentKey];
539 
540         if (next == 0) {
541             chains[parentKey] = _until;
542             return;
543         }
544 
545         bytes32 nextKey = toKey(_to, next);
546         uint parent;
547 
548         while (next != 0 && _until > next) {
549             parent = next;
550             parentKey = nextKey;
551 
552             next = chains[nextKey];
553             nextKey = toKey(_to, next);
554         }
555 
556         if (_until == next) {
557             return;
558         }
559 
560         if (next != 0) {
561             chains[key] = next;
562         }
563 
564         chains[parentKey] = _until;
565     }
566 }
567 
568 
569 /**
570  * @title Burnable Token
571  * @dev Token that can be irreversibly burned (destroyed).
572  */
573 contract BurnableToken is BasicToken {
574 
575   event Burn(address indexed burner, uint256 value);
576 
577   /**
578    * @dev Burns a specific amount of tokens.
579    * @param _value The amount of token to be burned.
580    */
581   function burn(uint256 _value) public {
582     _burn(msg.sender, _value);
583   }
584 
585   function _burn(address _who, uint256 _value) internal {
586     require(_value <= balances[_who]);
587     // no need to require value <= totalSupply, since that would imply the
588     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
589 
590     balances[_who] = balances[_who].sub(_value);
591     totalSupply_ = totalSupply_.sub(_value);
592     emit Burn(_who, _value);
593     emit Transfer(_who, address(0), _value);
594   }
595 }
596 
597 
598 
599 /**
600  * @title Pausable
601  * @dev Base contract which allows children to implement an emergency stop mechanism.
602  */
603 contract Pausable is Ownable {
604   event Pause();
605   event Unpause();
606 
607   bool public paused = false;
608 
609 
610   /**
611    * @dev Modifier to make a function callable only when the contract is not paused.
612    */
613   modifier whenNotPaused() {
614     require(!paused);
615     _;
616   }
617 
618   /**
619    * @dev Modifier to make a function callable only when the contract is paused.
620    */
621   modifier whenPaused() {
622     require(paused);
623     _;
624   }
625 
626   /**
627    * @dev called by the owner to pause, triggers stopped state
628    */
629   function pause() onlyOwner whenNotPaused public {
630     paused = true;
631     emit Pause();
632   }
633 
634   /**
635    * @dev called by the owner to unpause, returns to normal state
636    */
637   function unpause() onlyOwner whenPaused public {
638     paused = false;
639     emit Unpause();
640   }
641 }
642 
643 
644 contract FreezableMintableToken is FreezableToken, MintableToken {
645     /**
646      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
647      *      Be careful, gas usage is not deterministic,
648      *      and depends on how many freezes _to address already has.
649      * @param _to Address to which token will be freeze.
650      * @param _amount Amount of token to mint and freeze.
651      * @param _until Release date, must be in future.
652      * @return A boolean that indicates if the operation was successful.
653      */
654     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
655         totalSupply_ = totalSupply_.add(_amount);
656 
657         bytes32 currentKey = toKey(_to, _until);
658         freezings[currentKey] = freezings[currentKey].add(_amount);
659         freezingBalance[_to] = freezingBalance[_to].add(_amount);
660 
661         freeze(_to, _until);
662         emit Mint(_to, _amount);
663         emit Freezed(_to, _until, _amount);
664         emit Transfer(msg.sender, _to, _amount);
665         return true;
666     }
667 }
668 
669 
670 
671 contract Consts {
672     uint public constant TOKEN_DECIMALS = 18;
673     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
674     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
675 
676     string public constant TOKEN_NAME = "Bolton";
677     string public constant TOKEN_SYMBOL = "BFCL";
678     bool public constant PAUSED = false;
679     address public constant TARGET_USER = 0xd0997F80aeA911C01D5D8C7E34e7A937226a360c;
680     
681     uint public constant START_TIME = 1546340400;
682     
683     bool public constant CONTINUE_MINTING = true;
684 }
685 
686 
687 
688 
689 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
690     
691 {
692     
693 
694     function name() public pure returns (string _name) {
695         return TOKEN_NAME;
696     }
697 
698     function symbol() public pure returns (string _symbol) {
699         return TOKEN_SYMBOL;
700     }
701 
702     function decimals() public pure returns (uint8 _decimals) {
703         return TOKEN_DECIMALS_UINT8;
704     }
705 
706     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
707         require(!paused);
708         return super.transferFrom(_from, _to, _value);
709     }
710 
711     function transfer(address _to, uint256 _value) public returns (bool _success) {
712         require(!paused);
713         return super.transfer(_to, _value);
714     }
715 
716     
717 }