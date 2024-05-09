1 /*
2  * Power By ENTONE
3  * The complete code By ENTONE
4  * Copyright (C) 2020 ENTONE
5  */
6 pragma solidity ^0.4.23;
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address who) public view returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     if (a == 0) {
34       return 0;
35     }
36 
37     c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return a / b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 
117 /**
118  * @title ERC20 interface
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
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(
153     address _from,
154     address _to,
155     uint256 _value
156   )
157     public
158     returns (bool)
159   {
160     require(_to != address(0));
161     require(_value <= balances[_from]);
162     require(_value <= allowed[_from][msg.sender]);
163 
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167     emit Transfer(_from, _to, _value);
168     return true;
169   }
170 
171 
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval(
205     address _spender,
206     uint _addedValue
207   )
208     public
209     returns (bool)
210   {
211     allowed[msg.sender][_spender] = (
212       allowed[msg.sender][_spender].add(_addedValue));
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To decrement
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(
227     address _spender,
228     uint _subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to relinquish control of the contract.
281    */
282   function renounceOwnership() public onlyOwner {
283     emit OwnershipRenounced(owner);
284     owner = address(0);
285   }
286 
287   /**
288    * @dev Allows the current owner to transfer control of the contract to a newOwner.
289    * @param _newOwner The address to transfer ownership to.
290    */
291   function transferOwnership(address _newOwner) public onlyOwner {
292     _transferOwnership(_newOwner);
293   }
294 
295   /**
296    * @dev Transfers control of the contract to a newOwner.
297    * @param _newOwner The address to transfer ownership to.
298    */
299   function _transferOwnership(address _newOwner) internal {
300     require(_newOwner != address(0));
301     emit OwnershipTransferred(owner, _newOwner);
302     owner = _newOwner;
303   }
304 }
305 
306 
307 /**
308  * @title Mintable token
309  * @dev Simple ERC20 Token example, with mintable token creation
310  */
311 contract MintableToken is StandardToken, Ownable {
312   event Mint(address indexed to, uint256 amount);
313   event MintFinished();
314 
315   bool public mintingFinished = false;
316 
317 
318   modifier canMint() {
319     require(!mintingFinished);
320     _;
321   }
322 
323   modifier hasMintPermission() {
324     require(msg.sender == owner);
325     _;
326   }
327 
328   /**
329    * @dev Function to mint tokens
330    * @param _to The address that will receive the minted tokens.
331    * @param _amount The amount of tokens to mint.
332    * @return A boolean that indicates if the operation was successful.
333    */
334   function mint(
335     address _to,
336     uint256 _amount
337   )
338     hasMintPermission
339     canMint
340     public
341     returns (bool)
342   {
343     totalSupply_ = totalSupply_.add(_amount);
344     balances[_to] = balances[_to].add(_amount);
345     emit Mint(_to, _amount);
346     emit Transfer(address(0), _to, _amount);
347     return true;
348   }
349 
350   /**
351    * @dev Function to stop minting new tokens.
352    * @return True if the operation was successful.
353    */
354   function finishMinting() onlyOwner canMint public returns (bool) {
355     mintingFinished = true;
356     emit MintFinished();
357     return true;
358   }
359 }
360 
361 
362 contract FreezableToken is StandardToken {
363     // freezing chains
364     mapping (bytes32 => uint64) internal chains;
365     // freezing amounts for each chain
366     mapping (bytes32 => uint) internal freezings;
367     // total freezing balance per address
368     mapping (address => uint) internal freezingBalance;
369 
370     event Freezed(address indexed to, uint64 release, uint amount);
371     event Released(address indexed owner, uint amount);
372 
373     /**
374      * @dev Gets the balance of the specified address include freezing tokens.
375      * @param _owner The address to query the the balance of.
376      * @return An uint256 representing the amount owned by the passed address.
377      */
378     function balanceOf(address _owner) public view returns (uint256 balance) {
379         return super.balanceOf(_owner) + freezingBalance[_owner];
380     }
381 
382     /**
383      * @dev Gets the balance of the specified address without freezing tokens.
384      * @param _owner The address to query the the balance of.
385      * @return An uint256 representing the amount owned by the passed address.
386      */
387     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
388         return super.balanceOf(_owner);
389     }
390 
391     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
392         return freezingBalance[_owner];
393     }
394 
395     /**
396      * @dev gets freezing count
397      * @param _addr Address of freeze tokens owner.
398      */
399     function freezingCount(address _addr) public view returns (uint count) {
400         uint64 release = chains[toKey(_addr, 0)];
401         while (release != 0) {
402             count++;
403             release = chains[toKey(_addr, release)];
404         }
405     }
406 
407     /**
408      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
409      * @param _addr Address of freeze tokens owner.
410      * @param _index Freezing portion index. It ordered by release date descending.
411      */
412     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
413         for (uint i = 0; i < _index + 1; i++) {
414             _release = chains[toKey(_addr, _release)];
415             if (_release == 0) {
416                 return;
417             }
418         }
419         _balance = freezings[toKey(_addr, _release)];
420     }
421 
422     /**
423      * @dev freeze your tokens to the specified address.
424      *      Be careful, gas usage is not deterministic,
425      *      and depends on how many freezes _to address already has.
426      * @param _to Address to which token will be freeze.
427      * @param _amount Amount of token to freeze.
428      * @param _until Release date, must be in future.
429      */
430     function freezeTo(address _to, uint _amount, uint64 _until) public {
431         require(_to != address(0));
432         require(_amount <= balances[msg.sender]);
433 
434         balances[msg.sender] = balances[msg.sender].sub(_amount);
435 
436         bytes32 currentKey = toKey(_to, _until);
437         freezings[currentKey] = freezings[currentKey].add(_amount);
438         freezingBalance[_to] = freezingBalance[_to].add(_amount);
439 
440         freeze(_to, _until);
441         emit Transfer(msg.sender, _to, _amount);
442         emit Freezed(_to, _until, _amount);
443     }
444 
445     /**
446      * @dev release first available freezing tokens.
447      */
448     function releaseOnce() public {
449         bytes32 headKey = toKey(msg.sender, 0);
450         uint64 head = chains[headKey];
451         require(head != 0);
452         require(uint64(block.timestamp) > head);
453         bytes32 currentKey = toKey(msg.sender, head);
454 
455         uint64 next = chains[currentKey];
456 
457         uint amount = freezings[currentKey];
458         delete freezings[currentKey];
459 
460         balances[msg.sender] = balances[msg.sender].add(amount);
461         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
462 
463         if (next == 0) {
464             delete chains[headKey];
465         } else {
466             chains[headKey] = next;
467             delete chains[currentKey];
468         }
469         emit Released(msg.sender, amount);
470     }
471 
472     /**
473      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
474      * @return how many tokens was released
475      */
476     function releaseAll() public returns (uint tokens) {
477         uint release;
478         uint balance;
479         (release, balance) = getFreezing(msg.sender, 0);
480         while (release != 0 && block.timestamp > release) {
481             releaseOnce();
482             tokens += balance;
483             (release, balance) = getFreezing(msg.sender, 0);
484         }
485     }
486 
487     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
488         // ENTONE masc to increase entropy
489         result = 0xb75e7cAdbF8BA30e50fAeeBeb0784d70c04c6d890000000000;
490         assembly {
491             result := or(result, mul(_addr, 0xb75e7cAdbF8BA30e50fAeeBeb0784d70c04c6d89))
492             result := or(result, _release)
493         }
494     }
495 
496     function freeze(address _to, uint64 _until) internal {
497         require(_until > block.timestamp);
498         bytes32 key = toKey(_to, _until);
499         bytes32 parentKey = toKey(_to, uint64(0));
500         uint64 next = chains[parentKey];
501 
502         if (next == 0) {
503             chains[parentKey] = _until;
504             return;
505         }
506 
507         bytes32 nextKey = toKey(_to, next);
508         uint parent;
509 
510         while (next != 0 && _until > next) {
511             parent = next;
512             parentKey = nextKey;
513 
514             next = chains[nextKey];
515             nextKey = toKey(_to, next);
516         }
517 
518         if (_until == next) {
519             return;
520         }
521 
522         if (next != 0) {
523             chains[key] = next;
524         }
525 
526         chains[parentKey] = _until;
527     }
528 }
529 
530 
531 /**
532  * @title Burnable Token
533  * @dev Token that can be irreversibly burned (destroyed).
534  */
535 contract BurnableToken is BasicToken {
536 
537   event Burn(address indexed burner, uint256 value);
538 
539   /**
540    * @dev Burns a specific amount of tokens.
541    * @param _value The amount of token to be burned.
542    */
543   function burn(uint256 _value) public {
544     _burn(msg.sender, _value);
545   }
546 
547   function _burn(address _who, uint256 _value) internal {
548     require(_value <= balances[_who]);
549     // no need to require value <= totalSupply, since that would imply the
550     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
551 
552     balances[_who] = balances[_who].sub(_value);
553     totalSupply_ = totalSupply_.sub(_value);
554     emit Burn(_who, _value);
555     emit Transfer(_who, address(0), _value);
556   }
557 }
558 
559 
560 
561 /**
562  * @title Pausable
563  * @dev Base contract which allows children to implement an emergency stop mechanism.
564  */
565 contract Pausable is Ownable {
566   event Pause();
567   event Unpause();
568 
569   bool public paused = false;
570 
571 
572   /**
573    * @dev Modifier to make a function callable only when the contract is not paused.
574    */
575   modifier whenNotPaused() {
576     require(!paused);
577     _;
578   }
579 
580   /**
581    * @dev Modifier to make a function callable only when the contract is paused.
582    */
583   modifier whenPaused() {
584     require(paused);
585     _;
586   }
587 
588   /**
589    * @dev called by the owner to pause, triggers stopped state
590    */
591   function pause() onlyOwner whenNotPaused public {
592     paused = true;
593     emit Pause();
594   }
595 
596   /**
597    * @dev called by the owner to unpause, returns to normal state
598    */
599   function unpause() onlyOwner whenPaused public {
600     paused = false;
601     emit Unpause();
602   }
603 }
604 
605 
606 contract FreezableMintableToken is FreezableToken, MintableToken {
607     /**
608      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
609      *      Be careful, gas usage is not deterministic,
610      *      and depends on how many freezes _to address already has.
611      * @param _to Address to which token will be freeze.
612      * @param _amount Amount of token to mint and freeze.
613      * @param _until Release date, must be in future.
614      * @return A boolean that indicates if the operation was successful.
615      */
616     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner canMint returns (bool) {
617         totalSupply_ = totalSupply_.add(_amount);
618 
619         bytes32 currentKey = toKey(_to, _until);
620         freezings[currentKey] = freezings[currentKey].add(_amount);
621         freezingBalance[_to] = freezingBalance[_to].add(_amount);
622 
623         freeze(_to, _until);
624         emit Mint(_to, _amount);
625         emit Freezed(_to, _until, _amount);
626         emit Transfer(msg.sender, _to, _amount);
627         return true;
628     }
629 }
630 
631 
632 
633 contract Consts {
634     uint public constant TOKEN_DECIMALS = 8;
635     uint8 public constant TOKEN_DECIMALS_UINT8 = 8;
636     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
637 
638     string public constant TOKEN_NAME = "ENTONE";
639     string public constant TOKEN_SYMBOL = "ENTONE";
640     bool public constant PAUSED = false;
641     address public constant TARGET_USER = 0x834C26ACff6a39B864dDda8EC7483496bF96479D;
642     
643     bool public constant CONTINUE_MINTING = true;
644 }
645 
646 
647 
648 
649 contract ENTONE is Consts, FreezableMintableToken, BurnableToken, Pausable
650     
651 {
652     
653     event Initialized();
654     bool public initialized = false;
655 
656     constructor() public {
657         init();
658         transferOwnership(TARGET_USER);
659     }
660     
661 
662     function name() public pure returns (string _name) {
663         return TOKEN_NAME;
664     }
665 
666     function symbol() public pure returns (string _symbol) {
667         return TOKEN_SYMBOL;
668     }
669 
670     function decimals() public pure returns (uint8 _decimals) {
671         return TOKEN_DECIMALS_UINT8;
672     }
673 
674     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
675         require(!paused);
676         return super.transferFrom(_from, _to, _value);
677     }
678 
679     function transfer(address _to, uint256 _value) public returns (bool _success) {
680         require(!paused);
681         return super.transfer(_to, _value);
682     }
683 
684     
685     function init() private {
686         require(!initialized);
687         initialized = true;
688 
689         if (PAUSED) {
690             pause();
691         }
692 
693         
694         address[1] memory addresses = [address(0xb75e7cAdbF8BA30e50fAeeBeb0784d70c04c6d89)];
695         uint[1] memory amounts = [uint(500000000000)];
696         uint64[1] memory freezes = [uint64(0)];
697 
698         for (uint i = 0; i < addresses.length; i++) {
699             if (freezes[i] == 0) {
700                 mint(addresses[i], amounts[i]);
701             } else {
702                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
703             }
704         }
705         
706 
707         if (!CONTINUE_MINTING) {
708             finishMinting();
709         }
710 
711         emit Initialized();
712     }
713     
714 }