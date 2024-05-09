1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
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
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   /**
63   * @dev transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[msg.sender]);
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public view returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 
186 
187 /**
188  * @title Ownable
189  * @dev The Ownable contract has an owner address, and provides basic authorization control
190  * functions, this simplifies the implementation of "user permissions".
191  */
192 contract Ownable {
193   address public owner;
194 
195 
196   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198 
199   /**
200    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
201    * account.
202    */
203   function Ownable() public {
204     owner = msg.sender;
205   }
206 
207 
208   /**
209    * @dev Throws if called by any account other than the owner.
210    */
211   modifier onlyOwner() {
212     require(msg.sender == owner);
213     _;
214   }
215 
216 
217   /**
218    * @dev Allows the current owner to transfer control of the contract to a newOwner.
219    * @param newOwner The address to transfer ownership to.
220    */
221   function transferOwnership(address newOwner) public onlyOwner {
222     require(newOwner != address(0));
223     OwnershipTransferred(owner, newOwner);
224     owner = newOwner;
225   }
226 
227 }
228 
229 
230 
231 /**
232  * @title Mintable token
233  * @dev Simple ERC20 Token example, with mintable token creation
234  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
235  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
236  */
237 
238 contract MintableToken is StandardToken, Ownable {
239   event Mint(address indexed to, uint256 amount);
240   event MintFinished();
241 
242   bool public mintingFinished = false;
243 
244 
245   modifier canMint() {
246     require(!mintingFinished);
247     _;
248   }
249 
250   /**
251    * @dev Function to mint tokens
252    * @param _to The address that will receive the minted tokens.
253    * @param _amount The amount of tokens to mint.
254    * @return A boolean that indicates if the operation was successful.
255    */
256   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
257     totalSupply = totalSupply.add(_amount);
258     balances[_to] = balances[_to].add(_amount);
259     Mint(_to, _amount);
260     Transfer(address(0), _to, _amount);
261     return true;
262   }
263 
264   /**
265    * @dev Function to stop minting new tokens.
266    * @return True if the operation was successful.
267    */
268   function finishMinting() onlyOwner canMint public returns (bool) {
269     mintingFinished = true;
270     MintFinished();
271     return true;
272   }
273 }
274 
275 
276 
277 contract FreezableToken is StandardToken {
278     // freezing chains
279     mapping (bytes32 => uint64) internal chains;
280     // freezing amounts for each chain
281     mapping (bytes32 => uint) internal freezings;
282     // total freezing balance per address
283     mapping (address => uint) internal freezingBalance;
284 
285     event Freezed(address indexed to, uint64 release, uint amount);
286     event Released(address indexed owner, uint amount);
287 
288 
289     /**
290      * @dev Gets the balance of the specified address include freezing tokens.
291      * @param _owner The address to query the the balance of.
292      * @return An uint256 representing the amount owned by the passed address.
293      */
294     function balanceOf(address _owner) public view returns (uint256 balance) {
295         return super.balanceOf(_owner) + freezingBalance[_owner];
296     }
297 
298     /**
299      * @dev Gets the balance of the specified address without freezing tokens.
300      * @param _owner The address to query the the balance of.
301      * @return An uint256 representing the amount owned by the passed address.
302      */
303     function actualBalanceOf(address _owner) public view returns (uint256 balance) {
304         return super.balanceOf(_owner);
305     }
306 
307     function freezingBalanceOf(address _owner) public view returns (uint256 balance) {
308         return freezingBalance[_owner];
309     }
310 
311     /**
312      * @dev gets freezing count
313      * @param _addr Address of freeze tokens owner.
314      */
315     function freezingCount(address _addr) public view returns (uint count) {
316         uint64 release = chains[toKey(_addr, 0)];
317         while (release != 0) {
318             count ++;
319             release = chains[toKey(_addr, release)];
320         }
321     }
322 
323     /**
324      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
325      * @param _addr Address of freeze tokens owner.
326      * @param _index Freezing portion index. It ordered by release date descending.
327      */
328     function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {
329         for (uint i = 0; i < _index + 1; i ++) {
330             _release = chains[toKey(_addr, _release)];
331             if (_release == 0) {
332                 return;
333             }
334         }
335         _balance = freezings[toKey(_addr, _release)];
336     }
337 
338     /**
339      * @dev freeze your tokens to the specified address.
340      *      Be careful, gas usage is not deterministic,
341      *      and depends on how many freezes _to address already has.
342      * @param _to Address to which token will be freeze.
343      * @param _amount Amount of token to freeze.
344      * @param _until Release date, must be in future.
345      */
346     function freezeTo(address _to, uint _amount, uint64 _until) public {
347         require(_to != address(0));
348         require(_amount <= balances[msg.sender]);
349 
350         balances[msg.sender] = balances[msg.sender].sub(_amount);
351 
352         bytes32 currentKey = toKey(_to, _until);
353         freezings[currentKey] = freezings[currentKey].add(_amount);
354         freezingBalance[_to] = freezingBalance[_to].add(_amount);
355 
356         freeze(_to, _until);
357         Transfer(msg.sender, _to, _amount);
358         Freezed(_to, _until, _amount);
359     }
360 
361     /**
362      * @dev release first available freezing tokens.
363      */
364     function releaseOnce() public {
365         bytes32 headKey = toKey(msg.sender, 0);
366         uint64 head = chains[headKey];
367         require(head != 0);
368         require(uint64(block.timestamp) > head);
369         bytes32 currentKey = toKey(msg.sender, head);
370 
371         uint64 next = chains[currentKey];
372 
373         uint amount = freezings[currentKey];
374         delete freezings[currentKey];
375 
376         balances[msg.sender] = balances[msg.sender].add(amount);
377         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
378 
379         if (next == 0) {
380             delete chains[headKey];
381         }
382         else {
383             chains[headKey] = next;
384             delete chains[currentKey];
385         }
386         Released(msg.sender, amount);
387     }
388 
389     /**
390      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
391      * @return how many tokens was released
392      */
393     function releaseAll() public returns (uint tokens) {
394         uint release;
395         uint balance;
396         (release, balance) = getFreezing(msg.sender, 0);
397         while (release != 0 && block.timestamp > release) {
398             releaseOnce();
399             tokens += balance;
400             (release, balance) = getFreezing(msg.sender, 0);
401         }
402     }
403 
404     function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {
405         // WISH masc to increase entropy
406         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
407         assembly {
408             result := or(result, mul(_addr, 0x10000000000000000))
409             result := or(result, _release)
410         }
411     }
412 
413     function freeze(address _to, uint64 _until) internal {
414         require(_until > block.timestamp);
415         bytes32 key = toKey(_to, _until);
416         bytes32 parentKey = toKey(_to, uint64(0));
417         uint64 next = chains[parentKey];
418 
419         if (next == 0) {
420             chains[parentKey] = _until;
421             return;
422         }
423 
424         bytes32 nextKey = toKey(_to, next);
425         uint parent;
426 
427         while (next != 0 && _until > next) {
428             parent = next;
429             parentKey = nextKey;
430 
431             next = chains[nextKey];
432             nextKey = toKey(_to, next);
433         }
434 
435         if (_until == next) {
436             return;
437         }
438 
439         if (next != 0) {
440             chains[key] = next;
441         }
442 
443         chains[parentKey] = _until;
444     }
445 }
446 
447 /**
448 * @title Contract that will work with ERC223 tokens.
449 */
450 
451 contract ERC223Receiver {
452     /**
453      * @dev Standard ERC223 function that will handle incoming token transfers.
454      *
455      * @param _from  Token sender address.
456      * @param _value Amount of tokens.
457      * @param _data  Transaction metadata.
458      */
459     function tokenFallback(address _from, uint _value, bytes _data) public;
460 }
461 
462 contract ERC223Basic is ERC20Basic {
463     function transfer(address to, uint value, bytes data) public returns (bool);
464     event Transfer(address indexed from, address indexed to, uint value, bytes data);
465 }
466 
467 
468 contract SuccessfulERC223Receiver is ERC223Receiver {
469     event Invoked(address from, uint value, bytes data);
470 
471     function tokenFallback(address _from, uint _value, bytes _data) public {
472         Invoked(_from, _value, _data);
473     }
474 }
475 
476 contract FailingERC223Receiver is ERC223Receiver {
477     function tokenFallback(address, uint, bytes) public {
478         revert();
479     }
480 }
481 
482 contract ERC223ReceiverWithoutTokenFallback {
483 }
484 
485 /**
486  * @title Burnable Token
487  * @dev Token that can be irreversibly burned (destroyed).
488  */
489 contract BurnableToken is StandardToken {
490 
491     event Burn(address indexed burner, uint256 value);
492 
493     /**
494      * @dev Burns a specific amount of tokens.
495      * @param _value The amount of token to be burned.
496      */
497     function burn(uint256 _value) public {
498         require(_value > 0);
499         require(_value <= balances[msg.sender]);
500         // no need to require value <= totalSupply, since that would imply the
501         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
502 
503         address burner = msg.sender;
504         balances[burner] = balances[burner].sub(_value);
505         totalSupply = totalSupply.sub(_value);
506         Burn(burner, _value);
507     }
508 }
509 
510 
511 
512 /**
513  * @title Pausable
514  * @dev Base contract which allows children to implement an emergency stop mechanism.
515  */
516 contract Pausable is Ownable {
517   event Pause();
518   event Unpause();
519 
520   bool public paused = false;
521 
522 
523   /**
524    * @dev Modifier to make a function callable only when the contract is not paused.
525    */
526   modifier whenNotPaused() {
527     require(!paused);
528     _;
529   }
530 
531   /**
532    * @dev Modifier to make a function callable only when the contract is paused.
533    */
534   modifier whenPaused() {
535     require(paused);
536     _;
537   }
538 
539   /**
540    * @dev called by the owner to pause, triggers stopped state
541    */
542   function pause() onlyOwner whenNotPaused public {
543     paused = true;
544     Pause();
545   }
546 
547   /**
548    * @dev called by the owner to unpause, returns to normal state
549    */
550   function unpause() onlyOwner whenPaused public {
551     paused = false;
552     Unpause();
553   }
554 }
555 
556 
557 
558 contract FreezableMintableToken is FreezableToken, MintableToken {
559     /**
560      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
561      *      Be careful, gas usage is not deterministic,
562      *      and depends on how many freezes _to address already has.
563      * @param _to Address to which token will be freeze.
564      * @param _amount Amount of token to mint and freeze.
565      * @param _until Release date, must be in future.
566      * @return A boolean that indicates if the operation was successful.
567      */
568     function mintAndFreeze(address _to, uint _amount, uint64 _until) onlyOwner canMint public returns (bool) {
569         totalSupply = totalSupply.add(_amount);
570 
571         bytes32 currentKey = toKey(_to, _until);
572         freezings[currentKey] = freezings[currentKey].add(_amount);
573         freezingBalance[_to] = freezingBalance[_to].add(_amount);
574 
575         freeze(_to, _until);
576         Mint(_to, _amount);
577         Freezed(_to, _until, _amount);
578         Transfer(msg.sender, _to, _amount);
579         return true;
580     }
581 }
582 
583 contract Consts {
584     uint constant TOKEN_DECIMALS = 18;
585     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
586     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
587 
588     string constant TOKEN_NAME = "ArgusNodeToken";
589     string constant TOKEN_SYMBOL = "ArNT";
590     bool constant PAUSED = false;
591     address constant TARGET_USER = 0x504FB379a29654A604FDe7B95972C74BFE07C118;
592     
593     uint constant START_TIME = 1527818400;
594     
595     bool constant CONTINUE_MINTING = false;
596 }
597 
598 
599 
600 
601 /**
602  * @title Reference implementation of the ERC223 standard token.
603  */
604 contract ERC223Token is ERC223Basic, BasicToken, FailingERC223Receiver {
605     using SafeMath for uint;
606 
607     /**
608      * @dev Transfer the specified amount of tokens to the specified address.
609      *      Invokes the `tokenFallback` function if the recipient is a contract.
610      *      The token transfer fails if the recipient is a contract
611      *      but does not implement the `tokenFallback` function
612      *      or the fallback function to receive funds.
613      *
614      * @param _to    Receiver address.
615      * @param _value Amount of tokens that will be transferred.
616      * @param _data  Transaction metadata.
617      */
618     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
619         // Standard function transfer similar to ERC20 transfer with no _data .
620         // Added due to backwards compatibility reasons .
621         uint codeLength;
622 
623         assembly {
624             // Retrieve the size of the code on target address, this needs assembly.
625             codeLength := extcodesize(_to)
626         }
627 
628         balances[msg.sender] = balances[msg.sender].sub(_value);
629         balances[_to] = balances[_to].add(_value);
630         if(codeLength > 0) {
631             ERC223Receiver receiver = ERC223Receiver(_to);
632             receiver.tokenFallback(msg.sender, _value, _data);
633         }
634         Transfer(msg.sender, _to, _value, _data);
635         return true;
636     }
637 
638     /**
639      * @dev Transfer the specified amount of tokens to the specified address.
640      *      This function works the same with the previous one
641      *      but doesn't contain `_data` param.
642      *      Added due to backwards compatibility reasons.
643      *
644      * @param _to    Receiver address.
645      * @param _value Amount of tokens that will be transferred.
646      */
647     function transfer(address _to, uint256 _value) public returns (bool) {
648         bytes memory empty;
649         return transfer(_to, _value, empty);
650     }
651 }
652 
653 
654 contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable
655     
656 {
657     
658 
659     function name() pure public returns (string _name) {
660         return TOKEN_NAME;
661     }
662 
663     function symbol() pure public returns (string _symbol) {
664         return TOKEN_SYMBOL;
665     }
666 
667     function decimals() pure public returns (uint8 _decimals) {
668         return TOKEN_DECIMALS_UINT8;
669     }
670 
671     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
672         require(!paused);
673         return super.transferFrom(_from, _to, _value);
674     }
675 
676     function transfer(address _to, uint256 _value) public returns (bool _success) {
677         require(!paused);
678         return super.transfer(_to, _value);
679     }
680 }