1 /**
2 * @title ERC20Basic
3 * @dev Simpler version of ERC20 interface
4 * @dev see https://github.com/ethereum/EIPs/issues/179
5 */
6 contract ERC20Basic {
7     function totalSupply() public view returns (uint256);
8 
9     function balanceOf(address who) public view returns (uint256);
10 
11     function transfer(address to, uint256 value) public returns (bool);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 /**
16 * @title ERC20 interface
17 * @dev see https://github.com/ethereum/EIPs/issues/20
18 */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender) public view returns (uint256);
21 
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23 
24     function approve(address spender, uint256 value) public returns (bool);
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 /**
30 * @title Basic token
31 * @dev Basic version of StandardToken, with no allowances.
32 */
33 contract BasicToken is ERC20Basic {
34     using SafeMath for uint256;
35     mapping(address => uint256) balances;
36     uint256 totalSupply_;
37     /**
38     * @dev total number of tokens in existence
39     */
40     function totalSupply() public view returns (uint256) {
41         return totalSupply_;
42     }
43     /**
44     * @dev transfer token for a specified address
45     * @param _to The address to transfer to.
46     * @param _value The amount to be transferred.
47     */
48     function transfer(address _to, uint256 _value) public returns (bool) {
49         require(_to != address(0));
50         require(_value <= balances[msg.sender]);
51         // SafeMath.sub will throw if there is not enough balance.
52         balances[msg.sender] = balances[msg.sender].sub(_value);
53         balances[_to] = balances[_to].add(_value);
54         Transfer(msg.sender, _to, _value);
55         return true;
56     }
57     /**
58     * @dev Gets the balance of the specified address.
59     * @param _owner The address to query the the balance of.
60     * @return An uint256 representing the amount owned by the passed address.
61     */
62     function balanceOf(address _owner) public view returns (uint256 balance) {
63         return balances[_owner];
64     }
65 }
66 /**
67 * @title Standard ERC20 token
68 *
69 * @dev Implementation of the basic standard token.
70 * @dev https://github.com/ethereum/EIPs/issues/20
71 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
72 */
73 contract StandardToken is ERC20, BasicToken {
74     mapping(address => mapping(address => uint256)) internal allowed;
75     /**
76     * @dev Transfer tokens from one address to another
77     * @param _from address The address which you want to send tokens from
78     * @param _to address The address which you want to transfer to
79     * @param _value uint256 the amount of tokens to be transferred
80     */
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[_from]);
84         require(_value <= allowed[_from][msg.sender]);
85         balances[_from] = balances[_from].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         Transfer(_from, _to, _value);
89         return true;
90     }
91     /**
92     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
93     *
94     * Beware that changing an allowance with this method brings the risk that someone may use both the old
95     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
96     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
97     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98     * @param _spender The address which will spend the funds.
99     * @param _value The amount of tokens to be spent.
100     */
101     function approve(address _spender, uint256 _value) public returns (bool) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106     /**
107     * @dev Function to check the amount of tokens that an owner allowed to a spender.
108     * @param _owner address The address which owns the funds.
109     * @param _spender address The address which will spend the funds.
110     * @return A uint256 specifying the amount of tokens still available for the spender.
111     */
112     function allowance(address _owner, address _spender) public view returns (uint256) {
113         return allowed[_owner][_spender];
114     }
115     /**
116     * @dev Increase the amount of tokens that an owner allowed to a spender.
117     *
118     * approve should be called when allowed[_spender] == 0. To increment
119     * allowed value is better to use this function to avoid 2 calls (and wait until
120     * the first transaction is mined)
121     * From MonolithDAO Token.sol
122     * @param _spender The address which will spend the funds.
123     * @param _addedValue The amount of tokens to increase the allowance by.
124     */
125     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
126         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
127         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128         return true;
129     }
130     /**
131     * @dev Decrease the amount of tokens that an owner allowed to a spender.
132     *
133     * approve should be called when allowed[_spender] == 0. To decrement
134     * allowed value is better to use this function to avoid 2 calls (and wait until
135     * the first transaction is mined)
136     * From MonolithDAO Token.sol
137     * @param _spender The address which will spend the funds.
138     * @param _subtractedValue The amount of tokens to decrease the allowance by.
139     */
140     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
141         uint oldValue = allowed[msg.sender][_spender];
142         if (_subtractedValue > oldValue) {
143             allowed[msg.sender][_spender] = 0;
144         }
145         else {
146             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147         }
148         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149         return true;
150     }
151 }
152 
153 /**
154 * @title Ownable
155 * @dev The Ownable contract has an owner address, and provides basic authorization control
156 * functions, this simplifies the implementation of "user permissions".
157 */
158 contract Ownable {
159     address public owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162     /**
163     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164     * account.
165     */
166     function Ownable() public {
167         owner = msg.sender;
168     }
169     /**
170     * @dev Throws if called by any account other than the owner.
171     */
172     modifier onlyOwner() {
173         require(msg.sender == owner);
174         _;
175     }
176     /**
177     * @dev Allows the current owner to transfer control of the contract to a newOwner.
178     * @param newOwner The address to transfer ownership to.
179     */
180     function transferOwnership(address newOwner) public onlyOwner {
181         require(newOwner != address(0));
182         OwnershipTransferred(owner, newOwner);
183         owner = newOwner;
184     }
185 }
186 
187 /**
188 * @title Pausable
189 * @dev Base contract which allows children to implement an emergency stop mechanism.
190 */
191 contract Pausable is Ownable {
192     event Pause();
193     event Unpause();
194 
195     bool public paused = false;
196     /**
197     * @dev Modifier to make a function callable only when the contract is not paused.
198     */
199     modifier whenNotPaused() {
200         require(!paused);
201         _;
202     }
203     /**
204     * @dev Modifier to make a function callable only when the contract is paused.
205     */
206     modifier whenPaused() {
207         require(paused);
208         _;
209     }
210     /**
211     * @dev called by the owner to pause, triggers stopped state
212     */
213     function pause() onlyOwner whenNotPaused public
214     {paused = true;
215         Pause();
216     }
217     /**
218     * @dev called by the owner to unpause, returns to normal state
219     */
220     function unpause() onlyOwner whenPaused public {
221         paused = false;
222         Unpause();
223     }
224 }
225 
226 /**
227 * @title Pausable token
228 * @dev StandardToken modified with pausable transfers.
229 **/
230 contract PausableToken is StandardToken, Pausable {
231     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
232         return super.transfer(_to, _value);
233     }
234 
235     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
236         return super.transferFrom(_from, _to, _value);
237     }
238 
239     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool){
240         return super.approve(_spender, _value);
241     }
242 
243     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
244         return super.increaseApproval(_spender, _addedValue);
245     }
246 
247     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success)
248     {
249         return super.decreaseApproval(_spender, _subtractedValue);
250     }
251 }
252 
253 /**
254 * @title Mintable token
255 * @dev Simple ERC20 Token example, with mintable token creation
256 * @dev Issue:
257 * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
258 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
259 */
260 contract MintableToken is StandardToken, Ownable {event Mint(address indexed to, uint256 amount);
261     event MintFinished();
262 
263     bool public mintingFinished = false;
264     modifier canMint() {require(!mintingFinished);
265         _;
266     }
267     /**
268     * @dev Function to mint tokens
269     * @param _to The address that will receive the minted tokens.
270     * @param _amount The amount of tokens to mint.
271     * @return A boolean that indicates if the operation was successful.
272     */
273     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {totalSupply_ = totalSupply_.add(_amount);
274         balances[_to] = balances[_to].add(_amount);
275         Mint(_to, _amount);
276         Transfer(address(0), _to, _amount);
277         return true;
278     }
279     /**
280     * @dev Function to stop minting new tokens.
281     * @return True if the operation was successful.
282     */
283     function finishMinting() onlyOwner canMint public returns (bool) {mintingFinished = true;
284         MintFinished();
285         return true;}
286 }
287 
288 
289 
290 /**
291 * @title SafeERC20
292 * @dev Wrappers around ERC20 operations that throw on failure.
293 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
294 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
295 */
296 library SafeERC20 {
297     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
298         assert(token.transfer(to, value));
299     }
300 
301     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
302         assert(token.transferFrom(from, to, value));
303     }
304 
305     function safeApprove(ERC20 token, address spender, uint256 value) internal {
306         assert(token.approve(spender, value));
307     }
308 }
309 /**
310 * @title SafeMath
311 * @dev Math operations with safety checks that throw on error
312 */
313 library SafeMath {
314     /**
315     * @dev Multiplies two numbers, throws on overflow.
316     */
317     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
318         if (a == 0) {
319             return 0;
320         }
321         uint256 c = a * b;
322         assert(c / a == b);
323         return c;
324     }
325     /**
326     * @dev Integer division of two numbers, truncating the quotient.
327     */
328     function div(uint256 a, uint256 b) internal pure returns (uint256)
329     {
330         // assert(b > 0);
331         // Solidity automatically throws when dividing by 0
332         uint256 c = a / b;
333         // assert(a == b * c + a % b);
334         // There is no case in which this doesn't hold
335         return c;
336     }
337     /**
338     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
339     */
340     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
341         assert(b <= a);
342         return a - b;
343     }
344     /**
345     * @dev Adds two numbers, throws on overflow.
346     */
347     function add(uint256 a, uint256 b) internal pure returns (uint256) {
348         uint256 c = a + b;
349         assert(c >= a);
350         return c;
351     }
352 }
353 /**
354 * @title SimpleToken
355 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
356 * Note they can later distribute these tokens as they wish using `transfer` and other
357 * `StandardToken` functions.
358 */
359 contract SimpleToken is StandardToken {
360     string public constant name = "SimpleToken";
361     // solium-disable-line uppercase
362     string public constant symbol = "SIM";
363     // solium-disable-line uppercase
364     uint8 public constant decimals = 18;
365     // solium-disable-line uppercase
366     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
367     /**
368     * @dev Constructor that gives msg.sender all of existing tokens.
369     */
370     function SimpleToken() public {
371         totalSupply_ = INITIAL_SUPPLY;
372         balances[msg.sender] = INITIAL_SUPPLY;
373         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
374     }
375 }
376 
377 /**
378 * @title BiometricLock
379 * @dev BiometricLock in which only unlocked users can execute methods
380 */
381 contract BiometricLockable is Ownable {
382     event BiometricLocked(address beneficiary, bytes32 sha);
383     event BiometricUnlocked(address beneficiary);
384 
385     address BOPS;
386     mapping(address => bool) biometricLock;
387     mapping(bytes32 => bool) biometricCompleted;
388     mapping(bytes32 => uint256) biometricNow;
389     /**
390     * @dev Locks msg.sender address
391     */
392     function bioLock() external {
393         uint rightNow = now;
394         bytes32 sha = keccak256("bioLock", msg.sender, rightNow);
395         biometricLock[msg.sender] = true;
396         biometricNow[sha] = rightNow;
397         BiometricLocked(msg.sender, sha);
398     }
399     /**
400     * @dev Unlocks msg.sender single address.  v,r,s is the sign(sha) by BOPS
401     */
402     function bioUnlock(bytes32 sha, uint8 v, bytes32 r, bytes32 s) external {
403         require(biometricLock[msg.sender]);
404         require(!biometricCompleted[sha]);
405         bytes32 bioLockSha = keccak256("bioLock", msg.sender, biometricNow[sha]);
406         require(sha == bioLockSha);
407         require(verify(sha, v, r, s) == true);
408         biometricLock[msg.sender] = false;
409         BiometricUnlocked(msg.sender);
410         biometricCompleted[sha] = true;
411     }
412 
413     function isSenderBiometricLocked() external view returns (bool) {
414         return biometricLock[msg.sender];
415     }
416 
417     function isBiometricLocked(address _beneficiary) internal view returns (bool){
418         return biometricLock[_beneficiary];
419     }
420 
421     function isBiometricLockedOnlyOwner(address _beneficiary) external onlyOwner view returns (bool){
422         return biometricLock[_beneficiary];
423     }
424     /**
425     * @dev BOPS Address setter.  BOPS signs biometric authentications to ensure user's identity
426     *
427     */
428     function setBOPSAddress(address _BOPS) external onlyOwner {
429         require(_BOPS != address(0));
430         BOPS = _BOPS;
431     }
432 
433     function verify(bytes32 sha, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
434         require(BOPS != address(0));
435         return ecrecover(sha, v, r, s) == BOPS;
436     }
437 
438     function isBiometricCompleted(bytes32 sha) external view returns (bool) {
439         return biometricCompleted[sha];
440     }
441 }
442 
443 /**
444 * @title BiometricToken
445 * @dev BiometricToken is a token contract that can enable Biometric features for ERC20 functions
446 */
447 contract BiometricToken is Ownable, MintableToken, BiometricLockable {
448     event BiometricTransferRequest(address from, address to, uint256 amount, bytes32 sha);
449     event BiometricApprovalRequest(address indexed owner, address indexed spender, uint256 value, bytes32 sha);
450     // Transfer related methods variables
451     mapping(bytes32 => address) biometricFrom;
452     mapping(bytes32 => address) biometricAllowee;
453     mapping(bytes32 => address) biometricTo;
454     mapping(bytes32 => uint256) biometricAmount;
455 
456     function transfer(address _to, uint256 _value) public returns (bool) {
457         if (isBiometricLocked(msg.sender)) {
458             require(_value <= balances[msg.sender]);
459             require(_to != address(0));
460             require(_value > 0);
461             uint rightNow = now;
462             bytes32 sha = keccak256("transfer", msg.sender, _to, _value, rightNow);
463             biometricFrom[sha] = msg.sender;
464             biometricTo[sha] = _to;
465             biometricAmount[sha] = _value;
466             biometricNow[sha] = rightNow;
467             BiometricTransferRequest(msg.sender, _to, _value, sha);
468             return true;
469         }
470         else {
471             return super.transfer(_to, _value);
472         }
473     }
474 
475     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
476         if (isBiometricLocked(_from)) {
477             require(_value <= balances[_from]);
478             require(_value <= allowed[_from][msg.sender]);
479             require(_to != address(0));
480             require(_from != address(0));
481             require(_value > 0);
482             uint rightNow = now;
483             bytes32 sha = keccak256("transferFrom", _from, _to, _value, rightNow);
484             biometricAllowee[sha] = msg.sender;
485             biometricFrom[sha] = _from;
486             biometricTo[sha] = _to;
487             biometricAmount[sha] = _value;
488             biometricNow[sha] = rightNow;
489             BiometricTransferRequest(_from, _to, _value, sha);
490             return true;
491         }
492         else {
493             return super.transferFrom(_from, _to, _value);
494         }
495     }
496 
497     function approve(address _spender, uint256 _value) public returns (bool) {
498         if (isBiometricLocked(msg.sender)) {
499             uint rightNow = now;
500             bytes32 sha = keccak256("approve", msg.sender, _spender, _value, rightNow);
501             biometricFrom[sha] = msg.sender;
502             biometricTo[sha] = _spender;
503             biometricAmount[sha] = _value;
504             biometricNow[sha] = rightNow;
505             BiometricApprovalRequest(msg.sender, _spender, _value, sha);
506             return true;
507         }
508         else {
509             return super.approve(_spender, _value);
510         }
511     }
512 
513     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
514         if (isBiometricLocked(msg.sender)) {
515             uint newValue = allowed[msg.sender][_spender].add(_addedValue);
516             uint rightNow = now;
517             bytes32 sha = keccak256("increaseApproval", msg.sender, _spender, newValue, rightNow);
518             biometricFrom[sha] = msg.sender;
519             biometricTo[sha] = _spender;
520             biometricAmount[sha] = newValue;
521             biometricNow[sha] = rightNow;
522             BiometricApprovalRequest(msg.sender, _spender, newValue, sha);
523             return true;
524         }
525         else {
526             return super.increaseApproval(_spender, _addedValue);
527         }
528     }
529 
530     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
531         if (isBiometricLocked(msg.sender)) {
532             uint oldValue = allowed[msg.sender][_spender];
533             uint newValue;
534             if (_subtractedValue > oldValue) {
535                 newValue = 0;
536             }
537             else {
538                 newValue = oldValue.sub(_subtractedValue);
539             }
540             uint rightNow = now;
541             bytes32 sha = keccak256("decreaseApproval", msg.sender, _spender, newValue, rightNow);
542             biometricFrom[sha] = msg.sender;
543             biometricTo[sha] = _spender;
544             biometricAmount[sha] = newValue;
545             biometricNow[sha] = rightNow;
546             BiometricApprovalRequest(msg.sender, _spender, newValue, sha);
547             return true;
548         }
549         else {
550             return super.decreaseApproval(_spender, _subtractedValue);
551         }
552     }
553     /**
554     * @notice Complete pending transfer, can only be called by msg.sender if it is the originator of Transfer
555     */
556     function releaseTransfer(bytes32 sha, uint8 v, bytes32 r, bytes32 s) public returns (bool){
557         require(msg.sender == biometricFrom[sha]);
558         require(!biometricCompleted[sha]);
559         bytes32 transferFromSha = keccak256("transferFrom", biometricFrom[sha], biometricTo[sha], biometricAmount[sha], biometricNow[sha]);
560         bytes32 transferSha = keccak256("transfer", biometricFrom[sha], biometricTo[sha], biometricAmount[sha], biometricNow[sha]);
561         require(sha == transferSha || sha == transferFromSha);
562         require(verify(sha, v, r, s) == true);
563         if (transferFromSha == sha) {
564             address _spender = biometricAllowee[sha];
565             address _from = biometricFrom[sha];
566             address _to = biometricTo[sha];
567             uint256 _value = biometricAmount[sha];
568             require(_to != address(0));
569             require(_value <= balances[_from]);
570             require(_value <= allowed[_from][_spender]);
571             balances[_from] = balances[_from].sub(_value);
572             balances[_to] = balances[_to].add(_value);
573             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_value);
574             Transfer(_from, _to, _value);
575         }
576         if (transferSha == sha) {
577             super.transfer(biometricTo[sha], biometricAmount[sha]);
578         }
579         biometricCompleted[sha] = true;
580         return true;
581     }
582     /**
583     * @notice Cancel pending transfer, can only be called by msg.sender == biometricFrom[sha]
584     */
585     function cancelTransfer(bytes32 sha) public returns (bool){
586         require(msg.sender == biometricFrom[sha]);
587         require(!biometricCompleted[sha]);
588         biometricCompleted[sha] = true;
589         return true;
590     }
591     /**
592     * @notice Complete pending Approval, can only be called by msg.sender if it is the originator of Approval
593     */
594     function releaseApprove(bytes32 sha, uint8 v, bytes32 r, bytes32 s) public returns (bool){
595         require(msg.sender == biometricFrom[sha]);
596         require(!biometricCompleted[sha]);
597         bytes32 approveSha = keccak256("approve", biometricFrom[sha], biometricTo[sha], biometricAmount[sha], biometricNow[sha]);
598         bytes32 increaseApprovalSha = keccak256("increaseApproval", biometricFrom[sha], biometricTo[sha], biometricAmount[sha], biometricNow[sha]);
599         bytes32 decreaseApprovalSha = keccak256("decreaseApproval", biometricFrom[sha], biometricTo[sha], biometricAmount[sha], biometricNow[sha]);
600         require(approveSha == sha || increaseApprovalSha == sha || decreaseApprovalSha == sha);
601         require(verify(sha, v, r, s) == true);
602         super.approve(biometricTo[sha], biometricAmount[sha]);
603         biometricCompleted[sha] = true;
604         return true;
605     }
606     /**
607     * @notice Cancel pending Approval, can only be called by msg.sender == biometricFrom[sha]
608     */
609     function cancelApprove(bytes32 sha) public returns (bool){
610         require(msg.sender == biometricFrom[sha]);
611         require(!biometricCompleted[sha]);
612         biometricCompleted[sha] = true;
613         return true;
614     }
615 }
616 
617 contract CompliantToken is BiometricToken {
618     //list of praticipants that have purchased during the presale period
619     mapping(address => bool) presaleHolder;
620     //list of presale participants and date when their tokens are unlocked
621     mapping(address => uint256) presaleHolderUnlockDate;
622     //list of participants from the United States
623     mapping(address => bool) utilityHolder;
624     //list of Hoyos Integrity Corp addresses that accept RSN as payment for service
625     mapping(address => bool) allowedHICAddress;
626     //list of addresses that can add to presale address list (i.e. crowdsale contract)
627     mapping(address => bool) privilegeAddress;
628 
629     function transfer(address _to, uint256 _value) public returns (bool) {
630         if (presaleHolder[msg.sender]) {
631             if (now >= presaleHolderUnlockDate[msg.sender]) {
632                 return super.transfer(_to, _value);
633             }
634             else {
635                 require(allowedHICAddress[_to]);
636                 return super.transfer(_to, _value);
637             }
638         }
639         if (utilityHolder[msg.sender]) {
640             require(allowedHICAddress[_to]);
641             return super.transfer(_to, _value);
642         }
643         else {
644             return super.transfer(_to, _value);
645         }
646     }
647 
648     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
649         if (presaleHolder[_from]) {
650             if (now >= presaleHolderUnlockDate[_from]) {
651                 return super.transferFrom(_from, _to, _value);
652             }
653             else {
654                 require(allowedHICAddress[_to]);
655                 return super.transferFrom(_from, _to, _value);
656             }
657         }
658         if (utilityHolder[_from]) {
659             require(allowedHICAddress[_to]);
660             return super.transferFrom(_from, _to, _value);
661         }
662         else {
663             return super.transferFrom(_from, _to, _value);
664         }
665     }
666     // Allowed HIC addresses to methods: set, remove, is
667     function addAllowedHICAddress(address _beneficiary) onlyOwner public {
668         allowedHICAddress[_beneficiary] = true;
669     }
670 
671     function removeAllowedHICAddress(address _beneficiary) onlyOwner public {
672         allowedHICAddress[_beneficiary] = false;
673     }
674 
675     function isAllowedHICAddress(address _beneficiary) onlyOwner public view returns (bool){
676         return allowedHICAddress[_beneficiary];
677     }
678     // Utility Holders methods: set, remove, is
679     function addUtilityHolder(address _beneficiary) public {
680         require(privilegeAddress[msg.sender]);
681         utilityHolder[_beneficiary] = true;}
682 
683     function removeUtilityHolder(address _beneficiary) onlyOwner public {
684         utilityHolder[_beneficiary] = false;
685     }
686 
687     function isUtilityHolder(address _beneficiary) onlyOwner public view returns (bool){
688         return utilityHolder[_beneficiary];
689     }
690     // Presale Holders methods: set, remove, is
691     function addPresaleHolder(address _beneficiary) public {
692         require(privilegeAddress[msg.sender]);
693         presaleHolder[_beneficiary] = true;
694         presaleHolderUnlockDate[_beneficiary] = now + 1 years;
695     }
696 
697     function removePresaleHolder(address _beneficiary) onlyOwner public {
698         presaleHolder[_beneficiary] = false;
699         presaleHolderUnlockDate[_beneficiary] = now;
700     }
701 
702     function isPresaleHolder(address _beneficiary) onlyOwner public view returns (bool){
703         return presaleHolder[_beneficiary];
704     }
705     // Presale Priviledge Addresses methods: set, remove, is
706     function addPrivilegeAddress(address _beneficiary) onlyOwner public {
707         privilegeAddress[_beneficiary] = true;
708     }
709 
710     function removePrivilegeAddress(address _beneficiary) onlyOwner public {
711         privilegeAddress[_beneficiary] = false;
712     }
713 
714     function isPrivilegeAddress(address _beneficiary) onlyOwner public view returns (bool){
715         return privilegeAddress[_beneficiary];
716     }
717 }
718 
719 contract RISENCoin is CompliantToken, PausableToken {
720     string public name = "RISEN";
721     string public symbol = "RSN";
722     uint8 public decimals = 18;
723 }