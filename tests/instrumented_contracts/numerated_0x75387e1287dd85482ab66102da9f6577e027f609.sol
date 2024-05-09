1 pragma solidity >=0.5.12;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() external view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (a == 0) {
31       return 0;
32     }
33 
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   uint256 totalSupply_;
79 
80   /**
81   * @dev total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     _transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256) {
103     return balances[_owner];
104   }
105 
106   /**
107   * @dev Transfer token for a specified addresses
108   * @param _from The address to transfer from.
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function _transfer(address _from, address _to, uint256 _value) internal {
113       require(_to != address(0));
114       require(_value <= balances[_from]);
115   
116       balances[_from] = balances[_from].sub(_value);
117       balances[_to] = balances[_to].add(_value);
118       emit Transfer(_from, _to, _value);
119   }
120 }
121 
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender)
129     public view returns (uint256);
130 
131   function transferFrom(address from, address to, uint256 value)
132     public returns (bool);
133 
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(
136     address indexed owner,
137     address indexed spender,
138     uint256 value
139   );
140 }
141 
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, BasicToken {
151 
152   mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(
162     address _from,
163     address _to,
164     uint256 _value
165   )
166     public
167     returns (bool)
168   {
169     require(_to != address(0));
170     require(_value <= balances[_from]);
171     require(_value <= allowed[_from][msg.sender]);
172 
173     balances[_from] = balances[_from].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176     emit Transfer(_from, _to, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    *
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    * @param _spender The address which will spend the funds.
188    * @param _value The amount of tokens to be spent.
189    */
190   function approve(address _spender, uint256 _value) public returns (bool) {
191     allowed[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(
203     address _owner,
204     address _spender
205    )
206     public
207     view
208     returns (uint256)
209   {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(
224     address _spender,
225     uint _addedValue
226   )
227     public
228     returns (bool)
229   {
230     allowed[msg.sender][_spender] = (
231       allowed[msg.sender][_spender].add(_addedValue));
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(
247     address _spender,
248     uint _subtractedValue
249   )
250     public
251     returns (bool)
252   {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 
266 
267 /**
268  * @title Ownable
269  * @dev The Ownable contract has an owner address, and provides basic authorization control
270  * functions, this simplifies the implementation of "user permissions".
271  */
272 contract Ownable {
273   address public owner;
274 
275 
276   event OwnershipRenounced(address indexed previousOwner);
277   event OwnershipTransferred(
278     address indexed previousOwner,
279     address indexed newOwner
280   );
281 
282 
283   /**
284    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
285    * account.
286    */
287   constructor() public {
288     owner = msg.sender;
289   }
290 
291   /**
292    * @dev Throws if called by any account other than the owner.
293    */
294   modifier onlyOwner() {
295     require(msg.sender == owner);
296     _;
297   }
298 
299   /**
300    * @dev Allows the current owner to relinquish control of the contract.
301    */
302   function renounceOwnership() public onlyOwner {
303     emit OwnershipRenounced(owner);
304     owner = address(0);
305   }
306 
307   /**
308    * @dev Allows the current owner to transfer control of the contract to a newOwner.
309    * @param _newOwner The address to transfer ownership to.
310    */
311   function transferOwnership(address _newOwner) public onlyOwner {
312     _transferOwnership(_newOwner);
313   }
314 
315   /**
316    * @dev Transfers control of the contract to a newOwner.
317    * @param _newOwner The address to transfer ownership to.
318    */
319   function _transferOwnership(address _newOwner) internal {
320     require(_newOwner != address(0));
321     emit OwnershipTransferred(owner, _newOwner);
322     owner = _newOwner;
323   }
324 }
325 
326 
327 /**
328  * @title Mintable token
329  * @dev Simple ERC20 Token example, with mintable token creation
330  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
331  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
332  */
333 contract MintableToken is StandardToken, Ownable {
334   event Mint(address indexed to, uint256 amount);
335   event MintFinished();
336 
337   bool public mintingFinished = false;
338 
339 
340   modifier canMint() {
341     require(!mintingFinished);
342     _;
343   }
344 
345   modifier hasMintPermission() {
346     require(msg.sender == owner);
347     _;
348   }
349 
350   /**
351    * @dev Function to mint tokens
352    * @param _to The address that will receive the minted tokens.
353    * @param _amount The amount of tokens to mint.
354    * @return A boolean that indicates if the operation was successful.
355    */
356   function mint(
357     address _to,
358     uint256 _amount
359   )
360     hasMintPermission
361     canMint
362     internal
363     returns (bool)
364   {
365     totalSupply_ = totalSupply_.add(_amount);
366     balances[_to] = balances[_to].add(_amount);
367     emit Mint(_to, _amount);
368     emit Transfer(address(0), _to, _amount);
369     return true;
370   }
371 
372   /**
373    * @dev Function to stop minting new tokens.
374    * @return True if the operation was successful.
375    */
376   function finishMinting() onlyOwner canMint internal returns (bool) {
377     mintingFinished = true;
378     emit MintFinished();
379     return true;
380   }
381 }
382 
383 
384 contract FreezableToken is StandardToken, Ownable {
385     // freezing chains
386     mapping (bytes32 => uint64) internal chains;
387     // freezing amounts for each chain
388     mapping (bytes32 => uint) internal freezings;
389     // total freezing balance per address
390     mapping (address => uint) internal freezingBalance;
391 
392     // reducible freezing chains
393     mapping (bytes32 => uint64) internal reducibleChains;
394     // reducible freezing amounts for each chain
395     mapping (bytes32 => uint) internal reducibleFreezings;
396     // total reducible freezing balance per address
397     mapping (address => uint) internal reducibleFreezingBalance;
398 
399     event Freezed(address indexed to, uint64 release, uint amount);
400     event Released(address indexed owner, uint amount);
401     event FreezeReduced(address indexed owner, uint64 release, uint amount);
402 
403     modifier hasReleasePermission() {
404         require(msg.sender == owner, "Access denied");
405         _;
406     }
407 
408     /**
409      * @dev Gets the balance of the specified address include freezing tokens.
410      * @param _owner The address to query the the balance of.
411      * @return An uint256 representing the amount owned by the passed address.
412      */
413     function balanceOf(address _owner) public view returns (uint256 balance) {
414         return super.balanceOf(_owner) + freezingBalance[_owner] + reducibleFreezingBalance[_owner];
415     }
416 
417     /**
418      * @dev Gets the balance of the specified address without freezing tokens.
419      * @param _owner The address to query the the balance of.
420      * @return An uint256 representing the amount owned by the passed address.
421      */
422     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
423         return super.balanceOf(_owner);
424     }
425 
426     /**
427      * @dev Gets the freezed balance of the specified address.
428      * @param _owner The address to query the the balance of.
429      * @return An uint256 representing the amount owned by the passed address.
430      */
431     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
432         return freezingBalance[_owner];
433     }
434 
435     /**
436      * @dev Gets the reducible freezed balance of the specified address.
437      * @param _owner The address to query the the balance of.
438      * @return An uint256 representing the amount owned by the passed address.
439      */
440     function reducibleFreezingBalanceOf(address _owner) public view returns (uint256 balance) {
441         return reducibleFreezingBalance[_owner];
442     }
443 
444     /**
445      * @dev gets freezing count
446      * @param _addr Address of freeze tokens owner.
447      */
448     function freezingCount(address _addr) public view returns (uint count) {
449         uint64 release = chains[toKey(_addr, 0)];
450         while (release != 0) {
451             count++;
452             release = chains[toKey(_addr, release)];
453         }
454     }
455 
456     /**
457      * @dev gets reducible freezing count
458      * @param _addr Address of freeze tokens owner.
459      * @param _sender Address of frozen tokens sender.
460      */
461     function reducibleFreezingCount(address _addr, address _sender) public view returns (uint count) {
462         uint64 release = reducibleChains[toKey2(_addr, _sender, 0)];
463         while (release != 0) {
464             count++;
465             release = reducibleChains[toKey2(_addr, _sender, release)];
466         }
467     }
468 
469     /**
470      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
471      * @param _addr Address of freeze tokens owner.
472      * @param _index Freezing portion index. It ordered by release date descending.
473      */
474     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
475         for (uint i = 0; i < _index + 1; i++) {
476             _release = chains[toKey(_addr, _release)];
477             if (_release == 0) {
478                 return (0, 0);
479             }
480         }
481         _balance = freezings[toKey(_addr, _release)];
482     }
483 
484     /**
485      * @dev gets reducible freezing end date and reducible freezing balance for the freezing portion specified by index.
486      * @param _addr Address of freeze tokens owner.
487      * @param _sender Address of frozen tokens sender.
488      * @param _index Freezing portion index. It ordered by release date descending.
489      */
490     function getReducibleFreezing(address _addr, address _sender, uint _index) public view returns (uint64 _release, uint _balance) {
491         for (uint i = 0; i < _index + 1; i++) {
492             _release = reducibleChains[toKey2(_addr, _sender, _release)];
493             if (_release == 0) {
494                 return (0, 0);
495             }
496         }
497         _balance = reducibleFreezings[toKey2(_addr, _sender, _release)];
498     }
499 
500     /**
501      * @dev freeze your tokens to the specified address.
502      *      Be careful, gas usage is not deterministic,
503      *      and depends on how many freezes _to address already has.
504      * @param _to Address to which token will be freeze.
505      * @param _amount Amount of token to freeze.
506      * @param _until Release date, must be in future.
507      */
508     function freezeTo(address _to, uint _amount, uint64 _until) public {
509         _freezeTo(msg.sender, _to, _amount, _until);
510     }
511 
512     /**
513      * @dev freeze your tokens to the specified address.
514      *      Be careful, gas usage is not deterministic,
515      *      and depends on how many freezes _to address already has.
516      * @param _to Address to which token will be freeze.
517      * @param _amount Amount of token to freeze.
518      * @param _until Release date, must be in future.
519      */
520     function _freezeTo(address _from, address _to, uint _amount, uint64 _until) internal {
521         require(_to != address(0));
522         require(_amount <= balances[_from]);
523 
524         balances[_from] = balances[_from].sub(_amount);
525 
526         bytes32 currentKey = toKey(_to, _until);
527         freezings[currentKey] = freezings[currentKey].add(_amount);
528         freezingBalance[_to] = freezingBalance[_to].add(_amount);
529 
530         freeze(_to, _until);
531         emit Transfer(_from, _to, _amount);
532         emit Freezed(_to, _until, _amount);
533     }
534 
535     /**
536      * @dev freeze your tokens to the specified address with posibility to reduce freezing.
537      *      Be careful, gas usage is not deterministic,
538      *      and depends on how many freezes _to address already has.
539      * @param _to Address to which token will be freeze.
540      * @param _amount Amount of token to freeze.
541      * @param _until Release date, must be in future.
542      */
543     function reducibleFreezeTo(address _to, uint _amount, uint64 _until) public {
544         require(_to != address(0));
545         require(_amount <= balances[msg.sender]);
546         require(_until > block.timestamp);
547 
548         balances[msg.sender] = balances[msg.sender].sub(_amount);
549 
550         bytes32 currentKey = toKey2(_to, msg.sender, _until);
551         reducibleFreezings[currentKey] = reducibleFreezings[currentKey].add(_amount);
552         reducibleFreezingBalance[_to] = reducibleFreezingBalance[_to].add(_amount);
553 
554         reducibleFreeze(_to, _until);
555         emit Transfer(msg.sender, _to, _amount);
556         emit Freezed(_to, _until, _amount);
557     }
558 
559     /**
560      * @dev reduce freeze time for _amount of tokens for reducible freezing of address _to by frozen tokens sender.
561      *      Removes reducible freezing for _amount of tokens if _newUntil in the past
562      *      Be careful, gas usage is not deterministic,
563      *      and depends on how many freezes _to address already has.
564      * @param _to Address to which token will be freeze.
565      * @param _amount Amount of token to freeze.
566      * @param _until Release date, must be in future.
567      */
568     function reduceFreezingTo(address _to, uint _amount, uint64 _until, uint64 _newUntil) public {
569         require(_to != address(0));
570 
571         // Don't allow to move reducible freezing to the future
572         require(_newUntil < _until, "Attempt to move the freezing into the future");
573 
574         bytes32 currentKey = toKey2(_to, msg.sender, _until);
575         uint amount = reducibleFreezings[currentKey];
576         require(amount > 0, "Freezing not found");
577 
578         if (_amount >= amount) {
579             delete reducibleFreezings[currentKey];
580 
581             uint64 next = reducibleChains[currentKey];
582             bytes32 parent = toKey2(_to, msg.sender, uint64(0));
583             while (reducibleChains[parent] != _until) {
584                 parent = toKey2(_to, msg.sender, reducibleChains[parent]);
585             }
586 
587             if (next == 0) {
588                 delete reducibleChains[parent];
589             }
590             else {
591                 reducibleChains[parent] = next;
592             }
593 
594             if (_newUntil <= block.timestamp) {
595                 balances[_to] = balances[_to].add(amount);
596                 reducibleFreezingBalance[_to] = reducibleFreezingBalance[_to].sub(amount);
597 
598                 emit Released(_to, amount);
599             }
600             else {
601                 bytes32 newKey = toKey2(_to, msg.sender, _newUntil);
602                 reducibleFreezings[newKey] = reducibleFreezings[newKey].add(amount);
603 
604                 reducibleFreeze(_to, _newUntil);
605 
606                 emit FreezeReduced(_to, _newUntil, amount);
607             }
608         }
609         else {
610             reducibleFreezings[currentKey] = reducibleFreezings[currentKey].sub(_amount);
611             if (_newUntil <= block.timestamp) {
612                 balances[_to] = balances[_to].add(_amount);
613                 reducibleFreezingBalance[_to] = reducibleFreezingBalance[_to].sub(_amount);
614 
615                 emit Released(_to, _amount);
616             }
617             else {
618                 bytes32 newKey = toKey2(_to, msg.sender, _newUntil);
619                 reducibleFreezings[newKey] = reducibleFreezings[newKey].add(_amount);
620 
621                 reducibleFreeze(_to, _newUntil);
622 
623                 emit FreezeReduced(_to, _newUntil, _amount);
624             }
625         }
626     }
627 
628     /**
629      * @dev release first available freezing tokens.
630      */
631     function releaseOnce() public {
632         _releaseOnce(msg.sender);
633     }
634 
635     /**
636      * @dev release first available freezing tokens (support).
637      * @param _addr Address of frozen tokens owner.
638      */
639     function releaseOnceFor(address _addr) hasReleasePermission public {
640         _releaseOnce(_addr);
641     }
642 
643     /**
644      * @dev release first available freezing tokens.
645      * @param _addr Address of frozen tokens owner.
646      */
647     function _releaseOnce(address _addr) internal {
648         bytes32 headKey = toKey(_addr, 0);
649         uint64 head = chains[headKey];
650         require(head != 0, "Freezing not found");
651         require(uint64(block.timestamp) > head, "Premature release attempt");
652         bytes32 currentKey = toKey(_addr, head);
653 
654         uint64 next = chains[currentKey];
655 
656         uint amount = freezings[currentKey];
657         delete freezings[currentKey];
658 
659         balances[_addr] = balances[_addr].add(amount);
660         freezingBalance[_addr] = freezingBalance[_addr].sub(amount);
661 
662         if (next == 0) {
663             delete chains[headKey];
664         } else {
665             chains[headKey] = next;
666             delete chains[currentKey];
667         }
668         emit Released(_addr, amount);
669     }
670 
671     /**
672      * @dev release first available reducible freezing tokens.
673      * @param _sender Address of frozen tokens sender.
674      */
675     function releaseReducibleFreezingOnce(address _sender) public {
676         _releaseReducibleFreezingOnce(msg.sender, _sender);
677     }
678 
679     /**
680      * @dev release first available reducible freezing tokens for _addr.
681      * @param _addr Address of frozen tokens owner.
682      * @param _sender Address of frozen tokens sender.
683      */
684     function releaseReducibleFreezingOnceFor(address _addr, address _sender) hasReleasePermission public {
685         _releaseReducibleFreezingOnce(_addr, _sender);
686     }
687 
688     /**
689      * @dev release first available reducible freezing tokens.
690      * @param _addr Address of frozen tokens owner.
691      * @param _sender Address of frozen tokens sender.
692      */
693     function _releaseReducibleFreezingOnce(address _addr, address _sender) internal {
694         bytes32 headKey = toKey2(_addr, _sender, 0);
695         uint64 head = reducibleChains[headKey];
696         require(head != 0, "Freezing not found");
697         require(uint64(block.timestamp) > head, "Premature release attempt");
698         bytes32 currentKey = toKey2(_addr, _sender, head);
699 
700         uint64 next = reducibleChains[currentKey];
701 
702         uint amount = reducibleFreezings[currentKey];
703         delete reducibleFreezings[currentKey];
704 
705         balances[_addr] = balances[_addr].add(amount);
706         reducibleFreezingBalance[_addr] = reducibleFreezingBalance[_addr].sub(amount);
707 
708         if (next == 0) {
709             delete reducibleChains[headKey];
710         } else {
711             reducibleChains[headKey] = next;
712             delete reducibleChains[currentKey];
713         }
714         emit Released(_addr, amount);
715     }
716 
717     /**
718      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
719      * @return how many tokens was released
720      */
721     function releaseAll() public returns (uint tokens) {
722         tokens = _releaseAll(msg.sender);
723     }
724 
725     /**
726      * @dev release all available for release freezing tokens for address _addr. Gas usage is not deterministic!
727      * @param _addr Address of frozen tokens owner.
728      * @return how many tokens was released
729      */
730     function releaseAllFor(address _addr) hasReleasePermission public returns (uint tokens) {
731         tokens = _releaseAll(_addr);
732     }
733 
734     /**
735      * @dev release all available for release freezing tokens.
736      * @param _addr Address of frozen tokens owner.
737      * @return how many tokens was released
738      */
739     function _releaseAll(address _addr) internal returns (uint tokens) {
740         uint release;
741         uint balance;
742         (release, balance) = getFreezing(_addr, 0);
743         while (release != 0 && block.timestamp > release) {
744             _releaseOnce(_addr);
745             tokens += balance;
746             (release, balance) = getFreezing(_addr, 0);
747         }
748     }
749 
750     /**
751      * @dev release all available for release reducible freezing tokens sent by _sender. Gas usage is not deterministic!
752      * @param _sender Address of frozen tokens sender.
753      * @return how many tokens was released
754      */
755     function reducibleReleaseAll(address _sender) public returns (uint tokens) {
756         tokens = _reducibleReleaseAll(msg.sender, _sender);
757     }
758 
759     /**
760      * @dev release all available for release reducible freezing tokens sent by _sender to _addr. Gas usage is not deterministic!
761      * @param _addr Address of frozen tokens owner.
762      * @param _sender Address of frozen tokens sender.
763      * @return how many tokens was released
764      */
765     function reducibleReleaseAllFor(address _addr, address _sender) hasReleasePermission public returns (uint tokens) {
766         tokens = _reducibleReleaseAll(_addr, _sender);
767     }
768 
769 
770     /**
771      * @dev release all available for release reducible freezing tokens sent by _sender to _addr.
772      * @param _addr Address of frozen tokens owner.
773      * @param _sender Address of frozen tokens sender.
774      * @return how many tokens was released
775      */
776     function _reducibleReleaseAll(address _addr, address _sender) internal returns (uint tokens) {
777         uint release;
778         uint balance;
779         (release, balance) = getReducibleFreezing(_addr, _sender, 0);
780         while (release != 0 && block.timestamp > release) {
781             releaseReducibleFreezingOnce(_sender);
782             tokens += balance;
783             (release, balance) = getReducibleFreezing(_addr, _sender, 0);
784         }
785     }
786 
787     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
788         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
789         assembly {
790             result := or(result, mul(_addr, 0x10000000000000000))
791             result := or(result, _release)
792         }
793     }
794 
795     function toKey2(address _addr1, address _addr2, uint _release) internal pure returns (bytes32 result) {
796         bytes32 key1 = 0x5749534800000000000000000000000000000000000000000000000000000000;
797         bytes32 key2 = 0x8926457892347780720546870000000000000000000000000000000000000000;
798         assembly {
799             key1 := or(key1, mul(_addr1, 0x10000000000000000))
800             key1 := or(key1, _release)
801             key2 := or(key2, _addr2)
802         }
803         result = keccak256(abi.encodePacked(key1, key2));
804     }
805 
806     function freeze(address _to, uint64 _until) internal {
807         require(_until > block.timestamp);
808         bytes32 key = toKey(_to, _until);
809         bytes32 parentKey = toKey(_to, uint64(0));
810         uint64 next = chains[parentKey];
811 
812         if (next == 0) {
813             chains[parentKey] = _until;
814             return;
815         }
816 
817         bytes32 nextKey = toKey(_to, next);
818         uint parent;
819 
820         while (next != 0 && _until > next) {
821             parent = next;
822             parentKey = nextKey;
823 
824             next = chains[nextKey];
825             nextKey = toKey(_to, next);
826         }
827 
828         if (_until == next) {
829             return;
830         }
831 
832         if (next != 0) {
833             chains[key] = next;
834         }
835 
836         chains[parentKey] = _until;
837     }
838 
839     function reducibleFreeze(address _to, uint64 _until) internal {
840         require(_until > block.timestamp);
841         bytes32 key = toKey2(_to, msg.sender, _until);
842         bytes32 parentKey = toKey2(_to, msg.sender, uint64(0));
843         uint64 next = reducibleChains[parentKey];
844 
845         if (next == 0) {
846             reducibleChains[parentKey] = _until;
847             return;
848         }
849 
850         bytes32 nextKey = toKey2(_to, msg.sender, next);
851         uint parent;
852 
853         while (next != 0 && _until > next) {
854             parent = next;
855             parentKey = nextKey;
856 
857             next = reducibleChains[nextKey];
858             nextKey = toKey2(_to, msg.sender, next);
859         }
860 
861         if (_until == next) {
862             return;
863         }
864 
865         if (next != 0) {
866             reducibleChains[key] = next;
867         }
868 
869         reducibleChains[parentKey] = _until;
870     }
871 }
872 
873 
874 /**
875  * @title Burnable Token
876  * @dev Token that can be irreversibly burned (destroyed).
877  */
878 contract BurnableToken is BasicToken {
879 
880   event Burn(address indexed burner, uint256 value);
881 
882   /**
883    * @dev Burns a specific amount of tokens.
884    * @param _value The amount of token to be burned.
885    */
886   function burn(uint256 _value) public {
887     _burn(msg.sender, _value);
888   }
889 
890   function _burn(address _who, uint256 _value) internal {
891     require(_value <= balances[_who]);
892     // no need to require value <= totalSupply, since that would imply the
893     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
894 
895     balances[_who] = balances[_who].sub(_value);
896     totalSupply_ = totalSupply_.sub(_value);
897     emit Burn(_who, _value);
898     emit Transfer(_who, address(0), _value);
899   }
900 }
901 
902 
903 
904 /**
905  * @title Pausable
906  * @dev Base contract which allows children to implement an emergency stop mechanism.
907  */
908 contract Pausable is Ownable {
909   event Pause();
910   event Unpause();
911 
912   bool public paused = false;
913 
914 
915   /**
916    * @dev Modifier to make a function callable only when the contract is not paused.
917    */
918   modifier whenNotPaused() {
919     require(!paused);
920     _;
921   }
922 
923   /**
924    * @dev Modifier to make a function callable only when the contract is paused.
925    */
926   modifier whenPaused() {
927     require(paused);
928     _;
929   }
930 
931   /**
932    * @dev called by the owner to pause, triggers stopped state
933    */
934   function pause() onlyOwner whenNotPaused public {
935     paused = true;
936     emit Pause();
937   }
938 
939   /**
940    * @dev called by the owner to unpause, returns to normal state
941    */
942   function unpause() onlyOwner whenPaused public {
943     paused = false;
944     emit Unpause();
945   }
946 }
947 
948 
949 contract Consts {
950     uint public constant TOKEN_DECIMALS = 18;
951     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
952     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
953     string public constant TOKEN_NAME = "MindsyncAI";
954     string public constant TOKEN_SYMBOL = "MAI";
955     uint public constant INITIAL_SUPPLY = 150000000 * TOKEN_DECIMAL_MULTIPLIER;
956 }
957 
958 
959 contract MindsyncAIToken is Consts, BurnableToken, Pausable, MintableToken, FreezableToken
960 {
961     uint256 startdate;
962 
963     address beneficiary1;
964     address beneficiary2;
965     address beneficiary3;
966     address beneficiary4;
967     address beneficiary5;
968     address beneficiary6;
969 
970     event Initialized();
971     bool public initialized = false;
972 
973     constructor() public {
974         init();
975     }
976 
977     function name() public pure returns (string memory) {
978         return TOKEN_NAME;
979     }
980 
981     function symbol() public pure returns (string memory) {
982         return TOKEN_SYMBOL;
983     }
984 
985     function decimals() public pure returns (uint8) {
986         return TOKEN_DECIMALS_UINT8;
987     }
988 
989     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
990         require(!paused);
991         return super.transferFrom(_from, _to, _value);
992     }
993 
994     function transfer(address _to, uint256 _value) public returns (bool _success) {
995         require(!paused);
996         return super.transfer(_to, _value);
997     }
998 
999     function init() private {
1000         require(!initialized);
1001         initialized = true;
1002 
1003 
1004         // Total Supply
1005         uint256 amount = INITIAL_SUPPLY;
1006 
1007         // Mint all tokens
1008         mint(address(this), amount);
1009         finishMinting();
1010 
1011         // Start date is October 01, 2019
1012         startdate = 1569888000;
1013 
1014 
1015         beneficiary1 = 0x5E65Ae75eEE5f58Ee944372Fa0855BAbc8c035b1; // Public sale
1016         beneficiary2 = 0x5497c008CCa91CF8C3e597C47397f4643f7Be432; // Team 
1017         beneficiary3 = 0x7E2a22A39BDcf6188D5c06f156d2B377ab925EB6; // Advisors
1018         beneficiary4 = 0xB092548821D9432aFC720a4b1D9f052Ef2F5bB2e; // Bounty
1019         beneficiary5 = 0xD46a8CB0d6dB18D16423a215AC5Da73D08B629eA; // Reward pool
1020         beneficiary6 = 0xb801d1d91Ac6e85b17c80c04aC0c7E0E739fc853; // Foundation
1021 
1022         // Public sale (50%)
1023         _transfer(address(this), beneficiary1, totalSupply().mul(50).div(100));
1024 
1025         // Team tokens (15%) are frozen and will be unlocked every six months after 1 year.
1026         _freezeTo(address(this), beneficiary2, totalSupply().mul(15).div(100).div(4), uint64(startdate + 366 days));
1027         _freezeTo(address(this), beneficiary2, totalSupply().mul(15).div(100).div(4), uint64(startdate + 548 days));
1028         _freezeTo(address(this), beneficiary2, totalSupply().mul(15).div(100).div(4), uint64(startdate + 731 days));
1029         _freezeTo(address(this), beneficiary2, totalSupply().mul(15).div(100).div(4), uint64(startdate + 913 days));
1030 
1031         // Advisors tokens (5%) are frozen and will be unlocked quarterly after 1 year.
1032         _freezeTo(address(this), beneficiary3, totalSupply().mul(5).div(100).div(4), uint64(startdate + 366 days));
1033         _freezeTo(address(this), beneficiary3, totalSupply().mul(5).div(100).div(4), uint64(startdate + 458 days));
1034         _freezeTo(address(this), beneficiary3, totalSupply().mul(5).div(100).div(4), uint64(startdate + 548 days));
1035         _freezeTo(address(this), beneficiary3, totalSupply().mul(5).div(100).div(4), uint64(startdate + 639 days));
1036 
1037         // Bounty tokens (2%) will be frozen during the distribution process.
1038         _transfer(address(this), beneficiary4, totalSupply().mul(2).div(100));
1039 
1040         // Reward fund tokens (20%) will be stored on Mindsync reward pool smart-contract and frozen.
1041         // Please refer to Whitepaper for more infomation about this fund.
1042         _freezeTo(address(this), beneficiary5, totalSupply().mul(20).div(100).div(4), uint64(startdate + 183 days));
1043         _freezeTo(address(this), beneficiary5, totalSupply().mul(20).div(100).div(4), uint64(startdate + 366 days));
1044         _freezeTo(address(this), beneficiary5, totalSupply().mul(20).div(100).div(4), uint64(startdate + 548 days));
1045         _freezeTo(address(this), beneficiary5, totalSupply().mul(20).div(100).div(4), uint64(startdate + 731 days));
1046 
1047         // Foundation tokens (8%) will be frozen on Mindsync foundation smart-contract for 1 year.
1048         _freezeTo(address(this), beneficiary6, totalSupply().mul(8).div(100), uint64(startdate + 366 days));
1049 
1050         emit Initialized();
1051     }
1052 }