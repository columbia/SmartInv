1 pragma solidity ^0.4.0;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46     address public owner;
47 
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52     /**
53      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54      * account.
55      */
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function transferOwnership(address newOwner) public onlyOwner {
75         require(newOwner != address(0));
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 
80 }
81 
82 
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90     uint256 public totalSupply;
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102     function allowance(address owner, address spender) public view returns (uint256);
103     function transferFrom(address from, address to, uint256 value) public returns (bool);
104     function approve(address spender, uint256 value) public returns (bool);
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 /**
110  * @title Pausable
111  * @dev Base contract which allows children to implement an emergency stop mechanism.
112  */
113 contract Pausable is Ownable {
114     event Pause();
115     event Unpause();
116 
117     bool public paused = false;
118 
119 
120     /**
121      * @dev Modifier to make a function callable only when the contract is not paused.
122      */
123     modifier whenNotPaused() {
124         require(!paused);
125         _;
126     }
127 
128     /**
129      * @dev Modifier to make a function callable only when the contract is paused.
130      */
131     modifier whenPaused() {
132         require(paused);
133         _;
134     }
135 
136     /**
137      * @dev called by the owner to pause, triggers stopped state
138      */
139     function pause() onlyOwner whenNotPaused public {
140         paused = true;
141         Pause();
142     }
143 
144     /**
145      * @dev called by the owner to unpause, returns to normal state
146      */
147     function unpause() onlyOwner whenPaused public {
148         paused = false;
149         Unpause();
150     }
151 }
152 
153 
154 /**
155  * @title Basic token
156  * @dev Basic version of StandardToken, with no allowances.
157  */
158 contract BasicToken is ERC20Basic {
159     using SafeMath for uint256;
160 
161     mapping(address => uint256) balances;
162 
163     /**
164     * @dev transfer token for a specified address
165     * @param _to The address to transfer to.
166     * @param _value The amount to be transferred.
167     */
168     function transfer(address _to, uint256 _value) public returns (bool) {
169         require(_to != address(0));
170         require(_value <= balances[msg.sender]);
171 
172         // SafeMath.sub will throw if there is not enough balance.
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     /**
180     * @dev Gets the balance of the specified address.
181     * @param _owner The address to query the the balance of.
182     * @return An uint256 representing the amount owned by the passed address.
183     */
184     function balanceOf(address _owner) public view returns (uint256 balance) {
185         return balances[_owner];
186     }
187 
188 }
189 
190 
191 /**
192  * @title SafeERC20
193  * @dev Wrappers around ERC20 operations that throw on failure.
194  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
195  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
196  */
197 library SafeERC20 {
198     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
199         assert(token.transfer(to, value));
200     }
201 
202     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
203         assert(token.transferFrom(from, to, value));
204     }
205 
206     function safeApprove(ERC20 token, address spender, uint256 value) internal {
207         assert(token.approve(spender, value));
208     }
209 }
210 
211 
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BasicToken {
221 
222     mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225     /**
226      * @dev Transfer tokens from one address to another
227      * @param _from address The address which you want to send tokens from
228      * @param _to address The address which you want to transfer to
229      * @param _value uint256 the amount of tokens to be transferred
230      */
231     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232         require(_to != address(0));
233         require(_value <= balances[_from]);
234         require(_value <= allowed[_from][msg.sender]);
235 
236         balances[_from] = balances[_from].sub(_value);
237         balances[_to] = balances[_to].add(_value);
238         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239         Transfer(_from, _to, _value);
240         return true;
241     }
242 
243     /**
244      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245      *
246      * Beware that changing an allowance with this method brings the risk that someone may use both the old
247      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250      * @param _spender The address which will spend the funds.
251      * @param _value The amount of tokens to be spent.
252      */
253     function approve(address _spender, uint256 _value) public returns (bool) {
254         allowed[msg.sender][_spender] = _value;
255         Approval(msg.sender, _spender, _value);
256         return true;
257     }
258 
259     /**
260      * @dev Function to check the amount of tokens that an owner allowed to a spender.
261      * @param _owner address The address which owns the funds.
262      * @param _spender address The address which will spend the funds.
263      * @return A uint256 specifying the amount of tokens still available for the spender.
264      */
265     function allowance(address _owner, address _spender) public view returns (uint256) {
266         return allowed[_owner][_spender];
267     }
268 
269     /**
270      * approve should be called when allowed[_spender] == 0. To increment
271      * allowed value is better to use this function to avoid 2 calls (and wait until
272      * the first transaction is mined)
273      * From MonolithDAO Token.sol
274      */
275     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
276         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
277         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278         return true;
279     }
280 
281     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
282         uint oldValue = allowed[msg.sender][_spender];
283         if (_subtractedValue > oldValue) {
284             allowed[msg.sender][_spender] = 0;
285         } else {
286             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287         }
288         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289         return true;
290     }
291 
292 }
293 
294 
295 /**
296  * @title Burnable Token
297  * @dev Token that can be irreversibly burned (destroyed).
298  */
299 contract BurnableToken is StandardToken {
300 
301     event Burn(address indexed burner, uint256 value);
302 
303     /**
304      * @dev Burns a specific amount of tokens.
305      * @param _value The amount of token to be burned.
306      */
307     function burn(uint256 _value) public {
308         require(_value > 0);
309         require(_value <= balances[msg.sender]);
310         // no need to require value <= totalSupply, since that would imply the
311         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
312 
313         address burner = msg.sender;
314         balances[burner] = balances[burner].sub(_value);
315         totalSupply = totalSupply.sub(_value);
316         Burn(burner, _value);
317     }
318 }
319 
320 
321 
322 /**
323  * @title Mintable token
324  * @dev Simple ERC20 Token example, with mintable token creation
325  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 
329 contract MintableToken is StandardToken, Ownable {
330     event Mint(address indexed to, uint256 amount);
331     event MintFinished();
332 
333     bool public mintingFinished = false;
334 
335 
336     modifier canMint() {
337         require(!mintingFinished);
338         _;
339     }
340 
341     /**
342      * @dev Function to mint tokens
343      * @param _to The address that will receive the minted tokens.
344      * @param _amount The amount of tokens to mint.
345      * @return A boolean that indicates if the operation was successful.
346      */
347     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348         totalSupply = totalSupply.add(_amount);
349         balances[_to] = balances[_to].add(_amount);
350         Mint(_to, _amount);
351         Transfer(address(0), _to, _amount);
352         return true;
353     }
354 
355     /**
356      * @dev Function to stop minting new tokens.
357      * @return True if the operation was successful.
358      */
359     function finishMinting() onlyOwner canMint public returns (bool) {
360         mintingFinished = true;
361         MintFinished();
362         return true;
363     }
364 }
365 
366 
367 
368 /**
369  * @title TokenTimelock
370  * @dev TokenTimelock is a token holder contract that will allow a
371  * beneficiary to extract the tokens after a given release time
372  */
373 contract TokenTimelock {
374     using SafeERC20 for ERC20Basic;
375 
376     // ERC20 basic token contract being held
377     ERC20Basic public token;
378 
379     // beneficiary of tokens after they are released
380     address public beneficiary;
381 
382     // timestamp when token release is enabled
383     uint64 public releaseTime;
384 
385     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
386         require(_releaseTime > now);
387         token = _token;
388         beneficiary = _beneficiary;
389         releaseTime = _releaseTime;
390     }
391 
392     /**
393      * @notice Transfers tokens held by timelock to beneficiary.
394      */
395     function release() public {
396         require(now >= releaseTime);
397 
398         uint256 amount = token.balanceOf(this);
399         require(amount > 0);
400 
401         token.safeTransfer(beneficiary, amount);
402     }
403 }
404 
405 
406 contract usingConsts {
407     uint constant TOKEN_DECIMALS = 18;
408     uint8 constant TOKEN_DECIMALS_UINT8 = 18;
409     uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
410 
411     string constant TOKEN_NAME = "Cronos";
412     string constant TOKEN_SYMBOL = "CRS";
413     bool constant PAUSED = true;
414     address constant TARGET_USER = 0x216C619CB44BeEe746DC781740C215Bce23fA892;
415     uint constant START_TIME = 1518697500;
416     bool constant CONTINUE_MINTING = false;
417 }
418 
419 
420 contract FreezableToken is StandardToken {
421     mapping (address => uint64) internal roots;
422 
423     mapping (bytes32 => uint64) internal chains;
424 
425     event Freezed(address indexed to, uint64 release, uint amount);
426     event Released(address indexed owner, uint amount);
427 
428     /**
429      * @dev gets summary information about all freeze tokens for the specified address.
430      * @param _addr Address of freeze tokens owner.
431      */
432     function getFreezingSummaryOf(address _addr) public constant returns (uint tokenAmount, uint freezingCount) {
433         uint count;
434         uint total;
435         uint64 release = roots[_addr];
436         while (release != 0) {
437             count ++;
438             total += balanceOf(address(keccak256(toKey(_addr, release))));
439             release = chains[toKey(_addr, release)];
440         }
441 
442         return (total, count);
443     }
444 
445     /**
446      * @dev gets freezing end date and freezing balance for the freezing portion specified by index.
447      * @param _addr Address of freeze tokens owner.
448      * @param _index Freezing portion index. It ordered by release date descending.
449      */
450     function getFreezing(address _addr, uint _index) public constant returns (uint64 _release, uint _balance) {
451         uint64 release = roots[_addr];
452         for (uint i = 0; i < _index; i ++) {
453             release = chains[toKey(_addr, release)];
454         }
455         return (release, balanceOf(address(keccak256(toKey(_addr, release)))));
456     }
457 
458     /**
459      * @dev freeze your tokens to the specified address.
460      *      Be careful, gas usage is not deterministic,
461      *      and depends on how many freezes _to address already has.
462      * @param _to Address to which token will be freeze.
463      * @param _amount Amount of token to freeze.
464      * @param _until Release date, must be in future.
465      */
466     function freezeTo(address _to, uint _amount, uint64 _until) public {
467         bytes32 currentKey = toKey(_to, _until);
468         transfer(address(keccak256(currentKey)), _amount);
469 
470         freeze(_to, _until);
471         Freezed(_to, _until, _amount);
472     }
473 
474     /**
475      * @dev release first available freezing tokens.
476      */
477     function releaseOnce() public {
478         uint64 head = roots[msg.sender];
479         require(head != 0);
480         require(uint64(block.timestamp) > head);
481         bytes32 currentKey = toKey(msg.sender, head);
482 
483         uint64 next = chains[currentKey];
484 
485         address currentAddress = address(keccak256(currentKey));
486         uint amount = balances[currentAddress];
487         delete balances[currentAddress];
488 
489         balances[msg.sender] += amount;
490 
491         if (next == 0) {
492             delete roots[msg.sender];
493         }
494         else {
495             roots[msg.sender] = next;
496         }
497         Released(msg.sender, amount);
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
515     function toKey(address _addr, uint _release) internal constant returns (bytes32 result) {
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
526         uint64 head = roots[_to];
527 
528         if (head == 0) {
529             roots[_to] = _until;
530             return;
531         }
532 
533         bytes32 headKey = toKey(_to, head);
534         uint parent;
535         bytes32 parentKey;
536 
537         while (head != 0 && _until > head) {
538             parent = head;
539             parentKey = headKey;
540 
541             head = chains[headKey];
542             headKey = toKey(_to, head);
543         }
544 
545         if (_until == head) {
546             return;
547         }
548 
549         if (head != 0) {
550             chains[toKey(_to, _until)] = head;
551         }
552 
553         if (parent == 0) {
554             roots[_to] = _until;
555         }
556         else {
557             chains[parentKey] = _until;
558         }
559     }
560 }
561 
562 
563 
564 
565 contract FreezableMintableToken is FreezableToken, MintableToken {
566     /**
567      * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.
568      *      Be careful, gas usage is not deterministic,
569      *      and depends on how many freezes _to address already has.
570      * @param _to Address to which token will be freeze.
571      * @param _amount Amount of token to mint and freeze.
572      * @param _until Release date, must be in future.
573      */
574     function mintAndFreeze(address _to, uint _amount, uint64 _until) public onlyOwner {
575         bytes32 currentKey = toKey(_to, _until);
576         mint(address(keccak256(currentKey)), _amount);
577 
578         freeze(_to, _until);
579         Freezed(_to, _until, _amount);
580     }
581 }
582 
583 
584 
585 contract MainToken is usingConsts, FreezableMintableToken, BurnableToken, Pausable {
586     function MainToken() {
587         if (PAUSED) {
588             pause();
589         }
590     }
591 
592     function name() constant public returns (string _name) {
593         return TOKEN_NAME;
594     }
595 
596     function symbol() constant public returns (string _symbol) {
597         return TOKEN_SYMBOL;
598     }
599 
600     function decimals() constant public returns (uint8 _decimals) {
601         return TOKEN_DECIMALS_UINT8;
602     }
603 
604     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
605         require(!paused);
606         return super.transferFrom(_from, _to, _value);
607     }
608 
609     function transfer(address _to, uint256 _value) returns (bool _success) {
610         require(!paused);
611         return super.transfer(_to, _value);
612     }
613 }