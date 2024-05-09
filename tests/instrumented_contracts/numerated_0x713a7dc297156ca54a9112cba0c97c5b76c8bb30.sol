1 pragma solidity ^0.4.20;
2 
3 
4 
5 contract ERC20Basic {
6   uint256 public totalSupply;
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   /**
59   * @dev transfer token for a specified address
60   * @param _to The address to transfer to.
61   * @param _value The amount to be transferred.
62   */
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) public view returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public view returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    */
162   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
163     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
169     uint oldValue = allowed[msg.sender][_spender];
170     if (_subtractedValue > oldValue) {
171       allowed[msg.sender][_spender] = 0;
172     } else {
173       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174     }
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179 }
180 
181 
182 
183 /**
184  * @title Ownable
185  * @dev The Ownable contract has an owner address, and provides basic authorization control
186  * functions, this simplifies the implementation of "user permissions".
187  */
188 contract Ownable {
189   address public owner;
190 
191 
192   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   function Ownable() public {
200     owner = msg.sender;
201   }
202 
203 
204   /**
205    * @dev Throws if called by any account other than the owner.
206    */
207   modifier onlyOwner() {
208     require(msg.sender == owner);
209     _;
210   }
211 
212 
213   /**
214    * @dev Allows the current owner to transfer control of the contract to a newOwner.
215    * @param newOwner The address to transfer ownership to.
216    */
217   function transferOwnership(address newOwner) public onlyOwner {
218     require(newOwner != address(0));
219     OwnershipTransferred(owner, newOwner);
220     owner = newOwner;
221   }
222 
223 }
224 
225 
226 
227 /**
228  * @title Mintable token
229  * @dev Simple ERC20 Token example, with mintable token creation
230  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
231  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
232  */
233 
234 contract MintableToken is StandardToken, Ownable {
235   event Mint(address indexed to, uint256 amount);
236   event MintFinished();
237 
238   bool public mintingFinished = false;
239 
240 
241   modifier canMint() {
242     require(!mintingFinished);
243     _;
244   }
245 
246   /**
247    * @dev Function to mint tokens
248    * @param _to The address that will receive the minted tokens.
249    * @param _amount The amount of tokens to mint.
250    * @return A boolean that indicates if the operation was successful.
251    */
252   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
253     totalSupply = totalSupply.add(_amount);
254     balances[_to] = balances[_to].add(_amount);
255     Mint(_to, _amount);
256     Transfer(address(0), _to, _amount);
257     return true;
258   }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264   function finishMinting() onlyOwner canMint public returns (bool) {
265     mintingFinished = true;
266     MintFinished();
267     return true;
268   }
269 }
270 
271 
272 
273 contract FreezableToken is StandardToken {
274     // freezing chains
275     mapping (bytes32 => uint64) internal chains;
276     // freezing amounts for each chain
277     mapping (bytes32 => uint) internal freezings;
278     // total freezing balance per address
279     mapping (address => uint) internal freezingBalance;
280 
281     event Freezed(address indexed to, uint64 release, uint amount);
282     event Released(address indexed owner, uint amount);
283 
284 
285     /**
286      * @dev Gets the balance of the specified address include freezing tokens.
287      * @param _owner The address to query the the balance of.
288      * @return An uint256 representing the amount owned by the passed address.
289      */
290     function balanceOf(address _owner) public view returns (uint256 balance) {
291         return super.balanceOf(_owner) + freezingBalance[_owner];
292     }
293 
294     /**
295      * @dev Gets the balance of the specified address without freezing tokens.
296      * @param _owner The address to query the the balance of.
297      * @return An uint256 representing the amount owned by the passed address.
298      */
299     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
300         return super.balanceOf(_owner);
301     }
302 
303     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
304         return freezingBalance[_owner];
305     }
306 
307     /**
308      * @dev gets freezing count
309      * @param _addr Address of freeze tokens owner.
310      */
311     function freezingCount(address _addr) public view returns (uint count) {
312         uint64 release = chains[toKey(_addr, 0)];
313         while (release != 0) {
314             count ++;
315             release = chains[toKey(_addr, release)];
316         }
317     }
318 
319     /**
320      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
321      * @param _addr Address of freeze tokens owner.
322      * @param _index Freezing portion index. It ordered by release date descending.
323      */
324     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
325         for (uint i = 0; i < _index + 1; i ++) {
326             _release = chains[toKey(_addr, _release)];
327             if (_release == 0) {
328                 return;
329             }
330         }
331         _balance = freezings[toKey(_addr, _release)];
332     }
333 
334     /**
335      * @dev freeze your tokens to the specified address.
336      *      Be careful, gas usage is not deterministic,
337      *      and depends on how many freezes _to address already has.
338      * @param _to Address to which token will be freeze.
339      * @param _amount Amount of token to freeze.
340      * @param _until Release date, must be in future.
341      */
342     function freezeTo(address _to, uint _amount, uint64 _until) public {
343         require(_to != address(0));
344         require(_amount <= balances[msg.sender]);
345 
346         balances[msg.sender] = balances[msg.sender].sub(_amount);
347 
348         bytes32 currentKey = toKey(_to, _until);
349         freezings[currentKey] = freezings[currentKey].add(_amount);
350         freezingBalance[_to] = freezingBalance[_to].add(_amount);
351 
352         freeze(_to, _until);
353         Freezed(_to, _until, _amount);
354     }
355 
356     /**
357      * @dev release first available freezing tokens.
358      */
359     function releaseOnce() public {
360         bytes32 headKey = toKey(msg.sender, 0);
361         uint64 head = chains[headKey];
362         require(head != 0);
363         require(uint64(block.timestamp) > head);
364         bytes32 currentKey = toKey(msg.sender, head);
365 
366         uint64 next = chains[currentKey];
367 
368         uint amount = freezings[currentKey];
369         delete freezings[currentKey];
370 
371         balances[msg.sender] = balances[msg.sender].add(amount);
372         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
373 
374         if (next == 0) {
375             delete chains[headKey];
376         }
377         else {
378             chains[headKey] = next;
379             delete chains[currentKey];
380         }
381         Released(msg.sender, amount);
382     }
383 
384     /**
385      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
386      * @return how many tokens was released
387      */
388     function releaseAll() public returns (uint tokens) {
389         uint release;
390         uint balance;
391         (release, balance) = getFreezing(msg.sender, 0);
392         while (release != 0 && block.timestamp > release) {
393             releaseOnce();
394             tokens += balance;
395             (release, balance) = getFreezing(msg.sender, 0);
396         }
397     }
398 
399     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
400         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
401         assembly {
402             result := or(result, mul(_addr, 0x10000000000000000))
403             result := or(result, _release)
404         }
405     }
406 
407     function freeze(address _to, uint64 _until) internal {
408         require(_until > block.timestamp);
409         bytes32 key = toKey(_to, _until);
410         bytes32 parentKey = toKey(_to, uint64(0));
411         uint64 next = chains[parentKey];
412 
413         if (next == 0) {
414             chains[parentKey] = _until;
415             return;
416         }
417 
418         bytes32 nextKey = toKey(_to, next);
419         uint parent;
420 
421         while (next != 0 && _until > next) {
422             parent = next;
423             parentKey = nextKey;
424 
425             next = chains[nextKey];
426             nextKey = toKey(_to, next);
427         }
428 
429         if (_until == next) {
430             return;
431         }
432 
433         if (next != 0) {
434             chains[key] = next;
435         }
436 
437         chains[parentKey] = _until;
438     }
439 }
440 
441 /**
442 * @title Contract that will work with ERC223 tokens.
443 */
444 
445 contract ERC223Receiver {
446     /**
447      * @dev Standard ERC223 function that will handle incoming token transfers.
448      *
449      * @param _from  Token sender address.
450      * @param _value Amount of tokens.
451      * @param _data  Transaction metadata.
452      */
453     function tokenFallback(address _from, uint _value, bytes _data) public;
454 }
455 
456 contract ERC223Basic is ERC20Basic {
457     function transfer(address to, uint value, bytes data) public returns (bool);
458     event Transfer(address indexed from, address indexed to, uint value, bytes data);
459 }
460 
461 
462 contract SuccessfulERC223Receiver is ERC223Receiver {
463     event Invoked(address from, uint value, bytes data);
464 
465     function tokenFallback(address _from, uint _value, bytes _data) public {
466         Invoked(_from, _value, _data);
467     }
468 }
469 
470 contract FailingERC223Receiver is ERC223Receiver {
471     function tokenFallback(address, uint, bytes) public {
472         revert();
473     }
474 }
475 
476 contract ERC223ReceiverWithoutTokenFallback {
477 }
478 
479 /**
480  * @title Burnable Token
481  * @dev Token that can be irreversibly burned (destroyed).
482  */
483 contract BurnableToken is StandardToken {
484 
485     event Burn(address indexed burner, uint256 value);
486 
487     /**
488      * @dev Burns a specific amount of tokens.
489      * @param _value The amount of token to be burned.
490      */
491     function burn(uint256 _value) public {
492         require(_value > 0);
493         require(_value <= balances[msg.sender]);
494         // no need to require value <= totalSupply, since that would imply the
495         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
496 
497         address burner = msg.sender;
498         balances[burner] = balances[burner].sub(_value);
499         totalSupply = totalSupply.sub(_value);
500         Burn(burner, _value);
501     }
502 }
503 
504 
505 
506 /**
507  * @title Pausable
508  * @dev Base contract which allows children to implement an emergency stop mechanism.
509  */
510 contract Pausable is Ownable {
511   event Pause();
512   event Unpause();
513 
514   bool public paused = false;
515 
516 
517   /**
518    * @dev Modifier to make a function callable only when the contract is not paused.
519    */
520   modifier whenNotPaused() {
521     require(!paused);
522     _;
523   }
524 
525   /**
526    * @dev Modifier to make a function callable only when the contract is paused.
527    */
528   modifier whenPaused() {
529     require(paused);
530     _;
531   }
532 
533   /**
534    * @dev called by the owner to pause, triggers stopped state
535    */
536   function pause() onlyOwner whenNotPaused public {
537     paused = true;
538     Pause();
539   }
540 
541   /**
542    * @dev called by the owner to unpause, returns to normal state
543    */
544   function unpause() onlyOwner whenPaused public {
545     paused = false;
546     Unpause();
547   }
548 }
549 
550 
551 
552 contract FreezableMintableToken is FreezableToken, MintableToken {
553     /**
554      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
555      *      Be careful, gas usage is not deterministic,
556      *      and depends on how many freezes _to address already has.
557      * @param _to Address to which token will be freeze.
558      * @param _amount Amount of token to mint and freeze.
559      * @param _until Release date, must be in future.
560      * @return A boolean that indicates if the operation was successful.
561      */
562     function mintAndFreeze(address _to, uint _amount, uint64 _until) onlyOwner canMint public returns (bool) {
563         totalSupply = totalSupply.add(_amount);
564 
565         bytes32 currentKey = toKey(_to, _until);
566         freezings[currentKey] = freezings[currentKey].add(_amount);
567         freezingBalance[_to] = freezingBalance[_to].add(_amount);
568 
569         freeze(_to, _until);
570         Mint(_to, _amount);
571         Freezed(_to, _until, _amount);
572         return true;
573     }
574 }
575 
576 contract Consts {
577     uint constant TOKEN_DECIMALS = 18;
578     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
579     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
580 
581     string constant TOKEN_NAME = "Box Of Data";
582     string constant TOKEN_SYMBOL = "BOD";
583     bool constant PAUSED = false;
584     address constant TARGET_USER = 0xC4a79A1FfD198cdD8828A1dfa6e65C614eDc8cc8;
585     
586     bool constant CONTINUE_MINTING = false;
587 }
588 
589 
590 
591 
592 /**
593  * @title Reference implementation of the ERC223 standard token.
594  */
595 contract ERC223Token is ERC223Basic, BasicToken, FailingERC223Receiver {
596     using SafeMath for uint;
597 
598     /**
599      * @dev Transfer the specified amount of tokens to the specified address.
600      *      Invokes the `tokenFallback` function if the recipient is a contract.
601      *      The token transfer fails if the recipient is a contract
602      *      but does not implement the `tokenFallback` function
603      *      or the fallback function to receive funds.
604      *
605      * @param _to    Receiver address.
606      * @param _value Amount of tokens that will be transferred.
607      * @param _data  Transaction metadata.
608      */
609     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
610         // Standard function transfer similar to ERC20 transfer with no _data .
611         // Added due to backwards compatibility reasons .
612         uint codeLength;
613 
614         assembly {
615             // Retrieve the size of the code on target address, this needs assembly.
616             codeLength := extcodesize(_to)
617         }
618 
619         balances[msg.sender] = balances[msg.sender].sub(_value);
620         balances[_to] = balances[_to].add(_value);
621         if(codeLength > 0) {
622             ERC223Receiver receiver = ERC223Receiver(_to);
623             receiver.tokenFallback(msg.sender, _value, _data);
624         }
625         Transfer(msg.sender, _to, _value, _data);
626         return true;
627     }
628 
629     /**
630      * @dev Transfer the specified amount of tokens to the specified address.
631      *      This function works the same with the previous one
632      *      but doesn't contain `_data` param.
633      *      Added due to backwards compatibility reasons.
634      *
635      * @param _to    Receiver address.
636      * @param _value Amount of tokens that will be transferred.
637      */
638     function transfer(address _to, uint256 _value) public returns (bool) {
639         bytes memory empty;
640         return transfer(_to, _value, empty);
641     }
642 }
643 
644 
645 contract BOXOFDATA is Consts, FreezableMintableToken, BurnableToken, Pausable
646     
647 {
648     
649     event Initialized();
650     bool public initialized = false;
651 
652     function MainToken() public {
653         init();
654         transferOwnership(TARGET_USER);
655     }
656 
657     function init() private {
658         require(!initialized);
659         initialized = true;
660 
661         if (PAUSED) {
662             pause();
663         }
664 
665         
666         address[1] memory addresses = [address(0xC4a79A1FfD198cdD8828A1dfa6e65C614eDc8cc8)];
667         uint[1] memory amounts = [uint(650000000000000000000000000)];
668         uint64[1] memory freezes = [uint64(0)];
669 
670         for (uint i = 0; i < addresses.length; i++) {
671             if (freezes[i] == 0) {
672                 mint(addresses[i], amounts[i]);
673             } else {
674                 mintAndFreeze(addresses[i], amounts[i], freezes[i]);
675             }
676         }
677         
678 
679         if (!CONTINUE_MINTING) {
680             finishMinting();
681         }
682 
683         Initialized();
684     }
685     
686 
687     function name() pure public returns (string _name) {
688         return TOKEN_NAME;
689     }
690 
691     function symbol() pure public returns (string _symbol) {
692         return TOKEN_SYMBOL;
693     }
694 
695     function decimals() pure public returns (uint8 _decimals) {
696         return TOKEN_DECIMALS_UINT8;
697     }
698 
699     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
700         require(!paused);
701         return super.transferFrom(_from, _to, _value);
702     }
703 
704     function transfer(address _to, uint256 _value) public returns (bool _success) {
705         require(!paused);
706         return super.transfer(_to, _value);
707     }
708 }