1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10 
11     function balanceOf(address who) public view returns (uint256);
12 
13     function transfer(address to, uint256 value) public returns (bool);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23     /**
24      * @dev Multiplies two numbers, throws on overflow.
25      */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     /**
40      * @dev Integer division of two numbers, truncating the quotient.
41      */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         // uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return a / b;
47     }
48 
49     /**
50      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51      */
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     /**
58      * @dev Adds two numbers, throws on overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61         c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72     using SafeMath for uint256;
73 
74     mapping(address => uint256) balances;
75 
76     uint256 totalSupply_;
77 
78     /**
79      * @dev total number of tokens in existence
80      */
81     function totalSupply() public view returns (uint256) {
82         return totalSupply_;
83     }
84 
85     /**
86      * @dev transfer token for a specified address
87      * @param _to The address to transfer to.
88      * @param _value The amount to be transferred.
89      */
90     function transfer(address _to, uint256 _value) public returns (bool) {
91         require(_to != address(0));
92         require(_value <= balances[msg.sender]);
93 
94         balances[msg.sender] = balances[msg.sender].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         emit Transfer(msg.sender, _to, _value);
97         return true;
98     }
99 
100     /**
101      * @dev Gets the balance of the specified address.
102      * @param _owner The address to query the the balance of.
103      * @return An uint256 representing the amount owned by the passed address.
104      */
105     function balanceOf(address _owner) public view returns (uint256) {
106         return balances[_owner];
107     }
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115     function allowance(address owner, address spender)
116         public
117         view
118         returns (uint256);
119 
120     function transferFrom(
121         address from,
122         address to,
123         uint256 value
124     ) public returns (bool);
125 
126     function approve(address spender, uint256 value) public returns (bool);
127 
128     event Approval(
129         address indexed owner,
130         address indexed spender,
131         uint256 value
132     );
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143     mapping(address => mapping(address => uint256)) internal allowed;
144 
145     /**
146      * @dev Transfer tokens from one address to another
147      * @param _from address The address which you want to send tokens from
148      * @param _to address The address which you want to transfer to
149      * @param _value uint256 the amount of tokens to be transferred
150      */
151     function transferFrom(
152         address _from,
153         address _to,
154         uint256 _value
155     ) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         emit Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169      *
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param _spender The address which will spend the funds.
175      * @param _value The amount of tokens to be spent.
176      */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param _owner address The address which owns the funds.
186      * @param _spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(address _owner, address _spender)
190         public
191         view
192         returns (uint256)
193     {
194         return allowed[_owner][_spender];
195     }
196 
197     /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      *
200      * approve should be called when allowed[_spender] == 0. To increment
201      * allowed value is better to use this function to avoid 2 calls (and wait until
202      * the first transaction is mined)
203      * From MonolithDAO Token.sol
204      * @param _spender The address which will spend the funds.
205      * @param _addedValue The amount of tokens to increase the allowance by.
206      */
207     function increaseApproval(address _spender, uint256 _addedValue)
208         public
209         returns (bool)
210     {
211         allowed[msg.sender][_spender] = (
212             allowed[msg.sender][_spender].add(_addedValue)
213         );
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     /**
219      * @dev Decrease the amount of tokens that an owner allowed to a spender.
220      *
221      * approve should be called when allowed[_spender] == 0. To decrement
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * @param _spender The address which will spend the funds.
226      * @param _subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseApproval(address _spender, uint256 _subtractedValue)
229         public
230         returns (bool)
231     {
232         uint256 oldValue = allowed[msg.sender][_spender];
233         if (_subtractedValue > oldValue) {
234             allowed[msg.sender][_spender] = 0;
235         } else {
236             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237         }
238         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 }
242 
243 /**
244  * @title Ownable
245  * @dev The Ownable contract has an owner address, and provides basic authorization control
246  * functions, this simplifies the implementation of "user permissions".
247  */
248 contract Ownable {
249     address public owner;
250 
251     event OwnershipRenounced(address indexed previousOwner);
252     event OwnershipTransferred(
253         address indexed previousOwner,
254         address indexed newOwner
255     );
256 
257     /**
258      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
259      * account.
260      */
261     constructor() public {
262         owner = msg.sender;
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         require(msg.sender == owner);
270         _;
271     }
272 
273     /**
274      * @dev Allows the current owner to relinquish control of the contract.
275      */
276     function renounceOwnership() public onlyOwner {
277         emit OwnershipRenounced(owner);
278         owner = address(0);
279     }
280 
281     /**
282      * @dev Allows the current owner to transfer control of the contract to a newOwner.
283      * @param _newOwner The address to transfer ownership to.
284      */
285     function transferOwnership(address _newOwner) public onlyOwner {
286         _transferOwnership(_newOwner);
287     }
288 
289     /**
290      * @dev Transfers control of the contract to a newOwner.
291      * @param _newOwner The address to transfer ownership to.
292      */
293     function _transferOwnership(address _newOwner) internal {
294         require(_newOwner != address(0));
295         emit OwnershipTransferred(owner, _newOwner);
296         owner = _newOwner;
297     }
298 }
299 
300 contract FreezableToken is StandardToken {
301     // freezing chains
302     mapping(bytes32 => uint64) internal chains;
303     // freezing amounts for each chain
304     mapping(bytes32 => uint256) internal freezings;
305     // total freezing balance per address
306     mapping(address => uint256) internal freezingBalance;
307 
308     event Freezed(address indexed to, uint64 release, uint256 amount);
309     event Released(address indexed owner, uint256 amount);
310 
311     /**
312      * @dev Gets the balance of the specified address include freezing tokens.
313      * @param _owner The address to query the the balance of.
314      * @return An uint256 representing the amount owned by the passed address.
315      */
316     function balanceOf(address _owner) public view returns (uint256 balance) {
317         return super.balanceOf(_owner) + freezingBalance[_owner];
318     }
319 
320     /**
321      * @dev Gets the balance of the specified address without freezing tokens.
322      * @param _owner The address to query the the balance of.
323      * @return An uint256 representing the amount owned by the passed address.
324      */
325     function actualBalanceOf(address _owner)
326         public
327         view
328         returns (uint256 balance)
329     {
330         return super.balanceOf(_owner);
331     }
332 
333     function freezingBalanceOf(address _owner)
334         public
335         view
336         returns (uint256 balance)
337     {
338         return freezingBalance[_owner];
339     }
340 
341     /**
342      * @dev gets freezing count
343      * @param _addr Address of freeze tokens owner.
344      */
345     function freezingCount(address _addr) public view returns (uint256 count) {
346         uint64 release = chains[toKey(_addr, 0)];
347         while (release != 0) {
348             count++;
349             release = chains[toKey(_addr, release)];
350         }
351     }
352 
353     /**
354      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
355      * @param _addr Address of freeze tokens owner.
356      * @param _index Freezing portion index. It ordered by release date descending.
357      */
358     function getFreezing(address _addr, uint256 _index)
359         public
360         view
361         returns (uint64 _release, uint256 _balance)
362     {
363         for (uint256 i = 0; i < _index + 1; i++) {
364             _release = chains[toKey(_addr, _release)];
365             if (_release == 0) {
366                 return;
367             }
368         }
369         _balance = freezings[toKey(_addr, _release)];
370     }
371 
372     /**
373      * @dev freeze your tokens to the specified address.
374      *      Be careful, gas usage is not deterministic,
375      *      and depends on how many freezes _to address already has.
376      * @param _to Address to which token will be freeze.
377      * @param _amount Amount of token to freeze.
378      * @param _until Release date, must be in future.
379      */
380     function freezeTo(
381         address _to,
382         uint256 _amount,
383         uint64 _until
384     ) public {
385         require(_to != address(0));
386         require(_amount <= balances[msg.sender]);
387 
388         balances[msg.sender] = balances[msg.sender].sub(_amount);
389 
390         bytes32 currentKey = toKey(_to, _until);
391         freezings[currentKey] = freezings[currentKey].add(_amount);
392         freezingBalance[_to] = freezingBalance[_to].add(_amount);
393 
394         freeze(_to, _until);
395         emit Transfer(msg.sender, _to, _amount);
396         emit Freezed(_to, _until, _amount);
397     }
398 
399     /**
400      * @dev release first available freezing tokens.
401      */
402     function releaseOnce() public {
403         bytes32 headKey = toKey(msg.sender, 0);
404         uint64 head = chains[headKey];
405         require(head != 0);
406         require(uint64(block.timestamp) > head);
407         bytes32 currentKey = toKey(msg.sender, head);
408 
409         uint64 next = chains[currentKey];
410 
411         uint256 amount = freezings[currentKey];
412         delete freezings[currentKey];
413 
414         balances[msg.sender] = balances[msg.sender].add(amount);
415         freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);
416 
417         if (next == 0) {
418             delete chains[headKey];
419         } else {
420             chains[headKey] = next;
421             delete chains[currentKey];
422         }
423         emit Released(msg.sender, amount);
424     }
425 
426     /**
427      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
428      * @return how many tokens was released
429      */
430     function releaseAll() public returns (uint256 tokens) {
431         uint256 release;
432         uint256 balance;
433         (release, balance) = getFreezing(msg.sender, 0);
434         while (release != 0 && block.timestamp > release) {
435             releaseOnce();
436             tokens += balance;
437             (release, balance) = getFreezing(msg.sender, 0);
438         }
439     }
440 
441     function toKey(address _addr, uint256 _release)
442         internal
443         pure
444         returns (bytes32 result)
445     {
446         // WISH masc to increase entropy
447         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
448         assembly {
449             result := or(result, mul(_addr, 0x10000000000000000))
450             result := or(result, and(_release, 0xffffffffffffffff))
451         }
452     }
453 
454     function freeze(address _to, uint64 _until) internal {
455         require(_until > block.timestamp);
456         bytes32 key = toKey(_to, _until);
457         bytes32 parentKey = toKey(_to, uint64(0));
458         uint64 next = chains[parentKey];
459 
460         if (next == 0) {
461             chains[parentKey] = _until;
462             return;
463         }
464 
465         bytes32 nextKey = toKey(_to, next);
466         uint256 parent;
467 
468         while (next != 0 && _until > next) {
469             parent = next;
470             parentKey = nextKey;
471 
472             next = chains[nextKey];
473             nextKey = toKey(_to, next);
474         }
475 
476         if (_until == next) {
477             return;
478         }
479 
480         if (next != 0) {
481             chains[key] = next;
482         }
483 
484         chains[parentKey] = _until;
485     }
486 }
487 
488 /**
489  * @title Burnable Token
490  * @dev Token that can be irreversibly burned (destroyed).
491  */
492 contract BurnableToken is BasicToken {
493     event Burn(address indexed burner, uint256 value);
494 
495     /**
496      * @dev Burns a specific amount of tokens.
497      * @param _value The amount of token to be burned.
498      */
499     function burn(uint256 _value) public {
500         _burn(msg.sender, _value);
501     }
502 
503     function _burn(address _who, uint256 _value) internal {
504         require(_value <= balances[_who]);
505         // no need to require value <= totalSupply, since that would imply the
506         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
507 
508         balances[_who] = balances[_who].sub(_value);
509         totalSupply_ = totalSupply_.sub(_value);
510         emit Burn(_who, _value);
511         emit Transfer(_who, address(0), _value);
512     }
513 }
514 
515 /**
516  * @title Pausable
517  * @dev Base contract which allows children to implement an emergency stop mechanism.
518  */
519 contract Pausable is Ownable {
520     event Pause();
521     event Unpause();
522 
523     bool public paused = false;
524 
525     /**
526      * @dev Modifier to make a function callable only when the contract is not paused.
527      */
528     modifier whenNotPaused() {
529         require(!paused);
530         _;
531     }
532 
533     /**
534      * @dev Modifier to make a function callable only when the contract is paused.
535      */
536     modifier whenPaused() {
537         require(paused);
538         _;
539     }
540 
541     /**
542      * @dev called by the owner to pause, triggers stopped state
543      */
544     function pause() public onlyOwner whenNotPaused {
545         paused = true;
546         emit Pause();
547     }
548 
549     /**
550      * @dev called by the owner to unpause, returns to normal state
551      */
552     function unpause() public onlyOwner whenPaused {
553         paused = false;
554         emit Unpause();
555     }
556 }
557 
558 contract Consts {
559     uint256 public constant TOKEN_DECIMALS = 18;
560     uint8 public constant TOKEN_DECIMALS_UINT8 = 18;
561     uint256 public constant TOKEN_DECIMAL_MULTIPLIER = 10**TOKEN_DECIMALS;
562 
563     string public constant TOKEN_NAME = "IQONIQ";
564     string public constant TOKEN_SYMBOL = "IQQ";
565     bool public constant PAUSED = false;
566     address public constant TARGET_USER =
567         0x6d1DAEA80bCce8423A0Fc703c3B48A8909E226Cd;
568 }
569 
570 contract IQONIQ is Consts, FreezableToken, BurnableToken, Pausable {
571     event Initialized();
572     bool public initialized = false;
573 
574     constructor() public {
575         init();
576         transferOwnership(TARGET_USER);
577     }
578 
579     function name() public pure returns (string _name) {
580         return TOKEN_NAME;
581     }
582 
583     function symbol() public pure returns (string _symbol) {
584         return TOKEN_SYMBOL;
585     }
586 
587     function decimals() public pure returns (uint8 _decimals) {
588         return TOKEN_DECIMALS_UINT8;
589     }
590 
591     function transferFrom(
592         address _from,
593         address _to,
594         uint256 _value
595     ) public returns (bool _success) {
596         require(!paused);
597         return super.transferFrom(_from, _to, _value);
598     }
599 
600     function transfer(address _to, uint256 _value)
601         public
602         returns (bool _success)
603     {
604         require(!paused);
605         return super.transfer(_to, _value);
606     }
607 
608     function init() private {
609         require(!initialized);
610         initialized = true;
611 
612         if (PAUSED) {
613             pause();
614         }
615 
616         address[1] memory addresses =
617             [address(0x88949d221A62EdAF3dE7407F488C921EcD56031f)];
618         uint256[1] memory amounts = [uint256(2500000000000000000000000000)];
619         uint64[1] memory freezes = [uint64(0)];
620 
621         for (uint256 i = 0; i < addresses.length; i++) {
622             if (freezes[i] == 0) {
623                 totalSupply_ = totalSupply_.add(amounts[i]);
624                 balances[addresses[i]] = balances[addresses[i]].add(amounts[i]);
625             } else {
626                 totalSupply_ = totalSupply_.add(amounts[i]);
627 
628                 bytes32 currentKey = toKey(addresses[i], freezes[i]);
629                 freezings[currentKey] = freezings[currentKey].add(amounts[i]);
630                 freezingBalance[addresses[i]] = freezingBalance[addresses[i]].add(amounts[i]);
631 
632                 freeze(addresses[i], freezes[i]);
633             }
634         }
635 
636         emit Initialized();
637     }
638 }