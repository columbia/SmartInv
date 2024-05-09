1 pragma solidity ^0.4.18;
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
230 /**
231  * @title SafeERC20
232  * @dev Wrappers around ERC20 operations that throw on failure.
233  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
234  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
235  */
236 library SafeERC20 {
237   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
238     assert(token.transfer(to, value));
239   }
240 
241   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
242     assert(token.transferFrom(from, to, value));
243   }
244 
245   function safeApprove(ERC20 token, address spender, uint256 value) internal {
246     assert(token.approve(spender, value));
247   }
248 }
249 
250 
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 
259 contract MintableToken is StandardToken, Ownable {
260   event Mint(address indexed to, uint256 amount);
261   event MintFinished();
262 
263   bool public mintingFinished = false;
264 
265 
266   modifier canMint() {
267     require(!mintingFinished);
268     _;
269   }
270 
271   /**
272    * @dev Function to mint tokens
273    * @param _to The address that will receive the minted tokens.
274    * @param _amount The amount of tokens to mint.
275    * @return A boolean that indicates if the operation was successful.
276    */
277   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
278     totalSupply = totalSupply.add(_amount);
279     balances[_to] = balances[_to].add(_amount);
280     Mint(_to, _amount);
281     Transfer(address(0), _to, _amount);
282     return true;
283   }
284 
285   /**
286    * @dev Function to stop minting new tokens.
287    * @return True if the operation was successful.
288    */
289   function finishMinting() onlyOwner canMint public returns (bool) {
290     mintingFinished = true;
291     MintFinished();
292     return true;
293   }
294 }
295 
296 
297 
298 contract FreezableToken is StandardToken {
299     mapping (address => uint64) internal roots;
300 
301     mapping (bytes32 => uint64) internal chains;
302 
303     event Freezed(address indexed to, uint64 release, uint amount);
304     event Released(address indexed owner, uint amount);
305 
306     /**
307      * @dev gets summary information about all freeze tokens for the specified address.
308      * @param _addr Address of freeze tokens owner.
309      */
310     function getFreezingSummaryOf(address _addr) public constant returns (uint tokenAmount, uint freezingCount) {
311         uint count;
312         uint total;
313         uint64 release = roots[_addr];
314         while (release != 0) {
315             count ++;
316             total += balanceOf(address(keccak256(toKey(_addr, release))));
317             release = chains[toKey(_addr, release)];
318         }
319 
320         return (total, count);
321     }
322 
323     /**
324      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
325      * @param _addr Address of freeze tokens owner.
326      * @param _index Freezing portion index. It ordered by release date descending.
327      */
328     function getFreezing(address _addr, uint _index) public constant returns (uint64 _release, uint _balance) {
329         uint64 release = roots[_addr];
330         for (uint i = 0; i < _index; i ++) {
331             release = chains[toKey(_addr, release)];
332         }
333         return (release, balanceOf(address(keccak256(toKey(_addr, release)))));
334     }
335 
336     /**
337      * @dev freeze your tokens to the specified address.
338      *      Be careful, gas usage is not deterministic,
339      *      and depends on how many freezes _to address already has.
340      * @param _to Address to which token will be freeze.
341      * @param _amount Amount of token to freeze.
342      * @param _until Release date, must be in future.
343      */
344     function freezeTo(address _to, uint _amount, uint64 _until) public {
345         bytes32 currentKey = toKey(_to, _until);
346         transfer(address(keccak256(currentKey)), _amount);
347 
348         freeze(_to, _until);
349         Freezed(_to, _until, _amount);
350     }
351 
352     /**
353      * @dev release first available freezing tokens.
354      */
355     function releaseOnce() public {
356         uint64 head = roots[msg.sender];
357         require(head != 0);
358         require(uint64(block.timestamp) > head);
359         bytes32 currentKey = toKey(msg.sender, head);
360 
361         uint64 next = chains[currentKey];
362 
363         address currentAddress = address(keccak256(currentKey));
364         uint amount = balances[currentAddress];
365         delete balances[currentAddress];
366 
367         balances[msg.sender] += amount;
368 
369         if (next == 0) {
370             delete roots[msg.sender];
371         }
372         else {
373             roots[msg.sender] = next;
374         }
375         Released(msg.sender, amount);
376     }
377 
378     /**
379      * @dev release all available for release freezing tokens. Gas usage is not deterministic!
380      * @return how many tokens was released
381      */
382     function releaseAll() public returns (uint tokens) {
383         uint release;
384         uint balance;
385         (release, balance) = getFreezing(msg.sender, 0);
386         while (release != 0 && block.timestamp > release) {
387             releaseOnce();
388             tokens += balance;
389             (release, balance) = getFreezing(msg.sender, 0);
390         }
391     }
392 
393     function toKey(address _addr, uint _release) internal constant returns (bytes32 result) {
394         // WISH masc to increase entropy
395         result = 0x5749534800000000000000000000000000000000000000000000000000000000;
396         assembly {
397             result := or(result, mul(_addr, 0x10000000000000000))
398             result := or(result, _release)
399         }
400     }
401 
402     function freeze(address _to, uint64 _until) internal {
403         require(_until > block.timestamp);
404         uint64 head = roots[_to];
405 
406         if (head == 0) {
407             roots[_to] = _until;
408             return;
409         }
410 
411         bytes32 headKey = toKey(_to, head);
412         uint parent;
413         bytes32 parentKey;
414 
415         while (head != 0 && _until > head) {
416             parent = head;
417             parentKey = headKey;
418 
419             head = chains[headKey];
420             headKey = toKey(_to, head);
421         }
422 
423         if (_until == head) {
424             return;
425         }
426 
427         if (head != 0) {
428             chains[toKey(_to, _until)] = head;
429         }
430 
431         if (parent == 0) {
432             roots[_to] = _until;
433         }
434         else {
435             chains[parentKey] = _until;
436         }
437     }
438 }
439 
440 /**
441  * @title Burnable Token
442  * @dev Token that can be irreversibly burned (destroyed).
443  */
444 contract BurnableToken is StandardToken {
445 
446     event Burn(address indexed burner, uint256 value);
447 
448     /**
449      * @dev Burns a specific amount of tokens.
450      * @param _value The amount of token to be burned.
451      */
452     function burn(uint256 _value) public {
453         require(_value > 0);
454         require(_value <= balances[msg.sender]);
455         // no need to require value <= totalSupply, since that would imply the
456         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
457 
458         address burner = msg.sender;
459         balances[burner] = balances[burner].sub(_value);
460         totalSupply = totalSupply.sub(_value);
461         Burn(burner, _value);
462     }
463 }
464 
465 
466 
467 /**
468  * @title Pausable
469  * @dev Base contract which allows children to implement an emergency stop mechanism.
470  */
471 contract Pausable is Ownable {
472   event Pause();
473   event Unpause();
474 
475   bool public paused = false;
476 
477 
478   /**
479    * @dev Modifier to make a function callable only when the contract is not paused.
480    */
481   modifier whenNotPaused() {
482     require(!paused);
483     _;
484   }
485 
486   /**
487    * @dev Modifier to make a function callable only when the contract is paused.
488    */
489   modifier whenPaused() {
490     require(paused);
491     _;
492   }
493 
494   /**
495    * @dev called by the owner to pause, triggers stopped state
496    */
497   function pause() onlyOwner whenNotPaused public {
498     paused = true;
499     Pause();
500   }
501 
502   /**
503    * @dev called by the owner to unpause, returns to normal state
504    */
505   function unpause() onlyOwner whenPaused public {
506     paused = false;
507     Unpause();
508   }
509 }
510 
511 
512 
513 /**
514  * @title TokenTimelock
515  * @dev TokenTimelock is a token holder contract that will allow a
516  * beneficiary to extract the tokens after a given release time
517  */
518 contract TokenTimelock {
519   using SafeERC20 for ERC20Basic;
520 
521   // ERC20 basic token contract being held
522   ERC20Basic public token;
523 
524   // beneficiary of tokens after they are released
525   address public beneficiary;
526 
527   // timestamp when token release is enabled
528   uint64 public releaseTime;
529 
530   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
531     require(_releaseTime > now);
532     token = _token;
533     beneficiary = _beneficiary;
534     releaseTime = _releaseTime;
535   }
536 
537   /**
538    * @notice Transfers tokens held by timelock to beneficiary.
539    */
540   function release() public {
541     require(now >= releaseTime);
542 
543     uint256 amount = token.balanceOf(this);
544     require(amount > 0);
545 
546     token.safeTransfer(beneficiary, amount);
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
560      */
561     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner {
562         bytes32 currentKey = toKey(_to, _until);
563         mint(address(keccak256(currentKey)), _amount);
564 
565         freeze(_to, _until);
566         Freezed(_to, _until, _amount);
567     }
568 }
569 
570 contract usingConsts {
571     uint constant TOKEN_DECIMALS = 18;
572     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
573     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
574 
575     string constant TOKEN_NAME = "PandroytyToken";
576     string constant TOKEN_SYMBOL = "PDRY";
577     bool constant PAUSED = true;
578     address constant TARGET_USER = 0x8f302c391b2b6fd064ae8257d09a13d9fedde207;
579     uint constant START_TIME = 1520730000;
580     bool constant CONTINUE_MINTING = true;
581 }
582 
583 
584 
585 contract MainToken is usingConsts, FreezableMintableToken, BurnableToken, Pausable {
586     function MainToken() {
587     }
588 
589     function name() constant public returns (string _name) {
590         return TOKEN_NAME;
591     }
592 
593     function symbol() constant public returns (string _symbol) {
594         return TOKEN_SYMBOL;
595     }
596 
597     function decimals() constant public returns (uint8 _decimals) {
598         return TOKEN_DECIMALS_UINT8;
599     }
600 
601     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
602         require(!paused);
603         return super.transferFrom(_from, _to, _value);
604     }
605 
606     function transfer(address _to, uint256 _value) returns (bool _success) {
607         require(!paused);
608         return super.transfer(_to, _value);
609     }
610 }