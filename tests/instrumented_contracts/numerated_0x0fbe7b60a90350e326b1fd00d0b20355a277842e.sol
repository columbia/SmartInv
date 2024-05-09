1 pragma solidity 0.5.7;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * FUNCTIONS, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10     address public newOwner;
11 
12     // MODIFIERS
13 
14     /// @dev Throws if called by any account other than the owner.
15     modifier onlyOwner() {
16         require(msg.sender == owner, "Only Owner");
17         _;
18     }
19 
20     /// @dev Throws if called by any account other than the new owner.
21     modifier onlyNewOwner() {
22         require(msg.sender == newOwner, "Only New Owner");
23         _;
24     }
25 
26     modifier notNull(address _address) {
27         require(_address != address(0), "Address is Null");
28         _;
29     }
30 
31     // CONSTRUCTOR
32 
33     /**
34     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35     * account.
36     */
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
42     /// @param _newOwner The address to transfer ownership to.
43     
44     function transferOwnership(address _newOwner) public notNull(_newOwner) onlyOwner {
45         newOwner = _newOwner;
46     }
47 
48     /// @dev Allow the new owner to claim ownership and so proving that the newOwner is valid.
49     function acceptOwnership() public onlyNewOwner {
50         address oldOwner = owner;
51         owner = newOwner;
52         newOwner = address(0);
53         emit OwnershipTransferred(oldOwner, owner);
54     }
55 
56     // EVENTS
57     
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 }
60 
61 
62 /**
63  * @title Pausable
64  * @dev Base contract which allows children to implement an emergency stop mechanism.
65  */
66 contract Pausable is Ownable {
67 
68     bool public paused = false;
69 
70     // MODIFIERS
71 
72     /**
73     * @dev Modifier to make a function callable only when the contract is not paused.
74     */
75     modifier whenNotPaused() {
76         require(!paused, "only when not paused");
77         _;
78     }
79 
80     /**
81     * @dev Modifier to make a function callable only when the contract is paused.
82     */
83     modifier whenPaused() {
84         require(paused, "only when paused");
85         _;
86     }
87 
88     /**
89     * @dev called by the owner to pause, triggers stopped state
90     */
91     function pause() public onlyOwner whenNotPaused {
92         paused = true;
93         emit Pause();
94     }
95 
96     /**
97     * @dev called by the owner to unpause, returns to normal state
98     */
99     function unpause() public onlyOwner whenPaused {
100         paused = false;
101         emit Unpause();
102     }
103 
104     // EVENTS
105 
106     event Pause();
107 
108     event Unpause();
109 }
110 
111 
112 // Abstract contract for the full ERC 20 Token standard
113 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114 
115 contract ERC20Interface {
116     /// total amount of tokens
117     function totalSupply() public view returns(uint256 supply);
118 
119     /// @param _owner The address from which the balance will be retrieved
120     /// @return The balance
121     function balanceOf(address _owner) public view returns (uint256 balance);
122 
123     /// @notice send `_value` token to `_to` from `msg.sender`
124     /// @param _to The address of the recipient
125     /// @param _value The amount of token to be transferred
126     /// @return Whether the transfer was successful or not
127     function transfer(address _to, uint256 _value) public returns (bool success);
128 
129     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
130     /// @param _from The address of the sender
131     /// @param _to The address of the recipient
132     /// @param _value The amount of token to be transferred
133     /// @return Whether the transfer was successful or not
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
135 
136     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
137     /// @param _spender The address of the account able to transfer the tokens
138     /// @param _value The amount of tokens to be approved for transfer
139     /// @return Whether the approval was successful or not
140     function approve(address _spender, uint256 _value) public returns (bool success);
141 
142     /// @param _owner The address of the account owning tokens
143     /// @param _spender The address of the account able to transfer the tokens
144     /// @return Amount of remaining tokens allowed to spent
145     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
146 
147     // EVENTS
148     
149     // solhint-disable-next-line no-simple-event-func-name
150     event Transfer(address indexed _from, address indexed _to, uint256 _value);
151     
152     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
153 }
154 
155 /**
156  * @title SafeMath
157  * @dev Math operations with safety checks that throw on error
158  */
159 library SafeMath {
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         uint256 c = a * b;
162         require(a == 0 || c / a == b);
163         return c;
164     }
165 
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // require(b > 0); // Solidity automatically throws when dividing by 0
168         uint256 c = a / b;
169         // require(a == b * c + a % b); // There is no case in which this doesn't hold
170         return c;
171     }
172 
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         require(b <= a);
175         return a - b;
176     }
177 
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a + b;
180         require(c >= a);
181         return c;
182     }
183 }
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract ERC20Token is Ownable, ERC20Interface {
193 
194     using SafeMath for uint256;
195 
196     mapping(address => uint256) internal balances;
197     mapping (address => mapping (address => uint256)) internal allowed;
198 
199     uint256 internal _totalSupply;
200     
201     // CONSTRUCTOR
202 
203     constructor(uint256 initialAmount) public {
204         if (initialAmount == 0)
205             return;
206         balances[msg.sender] = initialAmount;
207         _totalSupply = initialAmount;
208         emit Transfer(address(0), msg.sender, initialAmount);
209     }
210 
211     // EXTERNAL FUNCTIONS
212 
213     // PUBLIC FUNCTIONS
214 
215     function totalSupply() public view returns(uint256 supply)
216     {
217         return _totalSupply;
218     }
219 
220     /// @notice send `_value` token to `_to` from `msg.sender`
221     /// @param _to The address of the recipient
222     /// @param _value The amount of token to be transferred
223     /// @return Whether the transfer was successful or not
224     function transfer(address _to, uint256 _value) public returns (bool success) {
225 
226         return transferInternal(msg.sender, _to, _value);
227     }
228 
229     /* ALLOW FUNCTIONS */
230 
231     /**
232     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233     *
234     * Beware that changing an allowance with this method brings the risk that someone may use both the old
235     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238     */
239    
240     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens   
241     /// @param _spender The address of the account able to transfer the tokens
242     /// @param _value The amount of tokens to be approved for transfer
243     /// @return Whether the approval was successful or not
244     function approve(address _spender, uint256 _value) public notNull(_spender) returns (bool success) {
245         allowed[msg.sender][_spender] = _value;
246         emit Approval(msg.sender, _spender, _value);
247         return true;
248     }
249 
250     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
251     /// @param _from The address of the sender
252     /// @param _to The address of the recipient
253     /// @param _value The amount of token to be transferred
254     /// @return Whether the transfer was successful or not
255     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
256         require(_value <= allowed[_from][msg.sender], "insufficient tokens");
257 
258         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259         return transferInternal(_from, _to, _value);
260     }
261 
262     /**
263      * @dev Returns balance of the `_owner`.
264      *
265      * @param _owner   The address whose balance will be returned.
266      * @return balance Balance of the `_owner`.
267      */
268     function balanceOf(address _owner) public view returns (uint256) {
269         return balances[_owner];
270     }
271 
272     /// @param _owner The address of the account owning tokens
273     /// @param _spender The address of the account able to transfer the tokens
274     /// @return Amount of remaining tokens allowed to spent
275     function allowance(address _owner, address _spender) public view returns (uint256) {
276         return allowed[_owner][_spender];
277     }
278 
279     // INTERNAL FUNCTIONS
280 
281     /// @notice internal send `_value` token to `_to` from `_from`
282     /// @param _from The address of the sender
283     /// @param _to The address of the recipient
284     /// @param _value The amount of token to be transferred
285     /// @return Whether the transfer was successful or not
286     function transferInternal(address _from, address _to, uint256 _value) internal notNull(_from) notNull(_to) returns (bool) {
287         balances[_from] = balances[_from].sub(_value);
288         balances[_to] = balances[_to].add(_value);
289         emit Transfer(_from, _to, _value);
290         return true;
291     }   
292 
293     // PRIVATE FUNCTIONS
294 }
295 
296 /**
297  * @title Pausable token
298  *
299  * @dev StandardToken modified with pausable transfers.
300  **/
301 
302 contract PausableToken is ERC20Token, Pausable {
303 
304     /// @notice send `_value` token to `_to` from `msg.sender`
305     /// @param _to The address of the recipient
306     /// @param _value The amount of token to be transferred
307     /// @return Whether the transfer was successful or not
308     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
309         return super.transfer(_to, _value);
310     }
311 
312     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
313     /// @param _from The address of the sender
314     /// @param _to The address of the recipient
315     /// @param _value The amount of token to be transferred
316     /// @return Whether the transfer was successful or not
317     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
318         return super.transferFrom(_from, _to, _value);
319     }
320 
321     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
322     /// @param _spender The address of the account able to transfer the tokens
323     /// @param _value The amount of tokens to be approved for transfer
324     /// @return Whether the approval was successful or not
325     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
326         return super.approve(_spender, _value);
327     }
328 }
329 
330 
331 // module handling minting and burning of tokens and administration of minters
332 
333 contract MintableToken is PausableToken
334 {
335     using SafeMath for uint256;
336 
337     mapping(address => bool) internal minters; // list of allowed minters
338 
339     // MODIFIERS
340 
341     modifier onlyMinter {
342         require(minters[msg.sender], "Caller not minter");
343         _; 
344     }
345 
346     // CONSTRUCTOR
347 
348     constructor() public {
349         addMinter(msg.sender);   // Set the owner as minter
350     }
351 
352     // EXTERNAL FUNCTIONS
353 
354     // PUBLIC FUNCTIONS
355 
356     /// @dev  mint tokens to address
357     /// @notice mint `_value` token to `_to`
358     /// @param _to The address of the recipient
359     /// @param _value The amount of token to be minted
360     function mint(address _to, uint256 _value) public onlyMinter {
361         mintInternal(_to, _value);
362     }
363 
364     /// @dev add minter
365     /// @notice add minter address `_newMinter`
366     /// @param _newMinter The address of the minter to add
367     function addMinter(address _newMinter) public notNull(_newMinter) onlyOwner {
368         if (minters[_newMinter])
369             return;
370         minters[_newMinter] = true;
371         emit AddMinter(_newMinter);
372     }
373 
374     /// @dev remove minter 
375     /// @notice remove minter address  `_oldMinter`
376     /// @param _oldMinter The address of the minter to remove
377     function removeMinter(address _oldMinter) public notNull(_oldMinter) onlyOwner {
378         if (!minters[_oldMinter])
379             return;
380         minters[_oldMinter] = false;
381         emit RemoveMinter(_oldMinter);
382     }
383 
384     /// @dev check minter
385     /// @notice is address `_minter` a inter
386     /// @param _minter The address of the minter to check
387     function isMinter(address _minter) public notNull(_minter) view returns(bool)  {
388         return minters[_minter];
389     }
390 
391     // INTERNAL FUNCTIONS
392 
393     /// @dev  mint tokens to address
394     /// @notice mint `_value` token to `_to`
395     /// @param _to The address of the recipient
396     /// @param _value The amount of token to be _totalSupply
397     function mintInternal(address _to, uint256 _value) internal notNull(_to) {
398         balances[_to] = balances[_to].add(_value);
399         _totalSupply = _totalSupply.add(_value);
400         emit Transfer(address(0), _to, _value);
401     }
402 
403     /// @dev burn tokens, e.g. when migrating
404     /// @notice burn `_value` token from `_from`
405     /// @param _from The address of the recipient
406     /// @param _value The amount of token to be _totalSupply from the callers account
407     function burn(address _from, uint256 _value) internal notNull(_from) {
408         balances[_from] = balances[_from].sub(_value);
409         _totalSupply = _totalSupply.sub(_value);
410         emit Transfer(_from, address(0), _value);
411     }
412 
413 
414     // PRIVATE FUNCTIONS
415 
416     // EVENTS
417     
418     event AddMinter(address indexed newMinter);
419     
420     event RemoveMinter(address indexed oldMinter);
421 }
422 
423 /// @dev Migration Agent Base
424 contract MigrationAgent is Ownable, Pausable {
425 
426     address public migrationToContract; // the contract to migrate to
427     address public migrationFromContract; // the conttactto migate from
428 
429     // MODIFIERS
430     
431     modifier onlyMigrationFromContract() {
432         require(msg.sender == migrationFromContract, "Only from migration contract");
433         _;
434     }
435     // EXTERNAL FUNCTIONS
436 
437     // PUBLIC FUNCTIONS
438 
439     /// @dev set contract to migrate to 
440     /// @param _toContract Then contract address to migrate to
441     function startMigrateToContract(address _toContract) public onlyOwner whenPaused {
442         migrationToContract = _toContract;
443         require(MigrationAgent(migrationToContract).isMigrationAgent(), "not a migratable contract");
444         emit StartMigrateToContract(address(this), _toContract);
445     }
446 
447     /// @dev set contract to migrate from
448     /// @param _fromContract Then contract address to migrate from
449     function startMigrateFromContract(address _fromContract) public onlyOwner whenPaused {
450         migrationFromContract = _fromContract;
451         require(MigrationAgent(migrationFromContract).isMigrationAgent(), "not a migratable contract");
452         emit StartMigrateFromContract(_fromContract, address(this));
453     }
454 
455     /// @dev Each user calls the migrate function on the original contract to migrate the users’ tokens to the migration agent migrateFrom on the `migrationToContract` contract
456     function migrate() public;   
457 
458     /// @dev migrageFrom is called from the migrating contract `migrationFromContract`
459     /// @param _from The account to be migrated into new contract
460     /// @param _value The token balance to be migrated
461     function migrateFrom(address _from, uint256 _value) public returns(bool);
462 
463     /// @dev is a valid migration agent
464     /// @return true if contract is a migratable contract
465     function isMigrationAgent() public pure returns(bool) {
466         return true;
467     }
468 
469     // INTERNAL FUNCTIONS
470 
471     // PRIVATE FUNCTIONS
472 
473     // EVENTS
474 
475     event StartMigrateToContract(address indexed fromContract, address indexed toContract);
476 
477     event StartMigrateFromContract(address indexed fromContract, address indexed toContract);
478 
479     event MigratedTo(address indexed owner, address indexed _contract, uint256 value);
480 
481     event MigratedFrom(address indexed owner, address indexed _contract, uint256 value);
482 }
483 
484 
485 contract ActiveBitcoinEtherCertificate is MintableToken, MigrationAgent {
486 
487     using SafeMath for uint256;
488 
489     string constant public name = "Active Bitcoin Ether Certificate";
490     string constant public symbol = "ABEC";
491     uint8 constant public decimals = 5;
492     string constant public version = "1.0.0.0";
493 
494     address public redeemAddress;
495     string public description;
496 
497     // CONSTRUCTOR
498 
499     constructor(address _redeemAddress) ERC20Token(0) notNull(_redeemAddress) public {
500         redeemAddress = _redeemAddress;
501     }
502 
503     // EXTERNAL FUNCTIONS
504 
505     /// @notice update contract description to  `_text` 
506     /// @param _text The new description
507     function updateDescription(string calldata _text) external onlyMinter {
508         description = _text;
509     }
510 
511     // PUBLIC FUNCTIONS
512 
513     /*
514         MIGRATE FUNCTIONS
515      */
516     // safe migrate function
517     /// @dev migrageFrom is called from the migrating contract `migrationFromContract`
518     /// @param _from The account to be migrated into new contract
519     /// @param _value The token balance to be migrated
520     function migrateFrom(address _from, uint256 _value) public onlyMigrationFromContract whenNotPaused returns(bool) {
521         mintInternal(_from, _value);
522 
523         emit MigratedFrom(_from, migrationFromContract, _value);
524         return true;
525     }
526 
527     /// @dev Each user calls the migrate function on the original contract to migrate the users’ tokens to the migration agent migrateFrom on the `migrationToContract` contract
528     function migrate() public whenNotPaused {
529         require(migrationToContract != address(0), "not in migration mode"); // revert if not in migrate mode
530         uint256 value = balanceOf(msg.sender);
531         require (value > 0, "no balance"); // revert if not value left to transfer
532         burn(msg.sender, value);
533         require(MigrationAgent(migrationToContract).migrateFrom(msg.sender, value)==true, "migrateFrom must return true");
534         emit MigratedTo(msg.sender, migrationToContract, value);
535     }
536 
537     /*
538         Helper FUNCTIONS
539     */
540 
541     /// @dev helper function to return foreign tokens accidental send to contract address
542     /// @param _tokenaddress Address of foreign ERC20 contract
543     /// @param _to Address to send foreign tokens to
544     function refundForeignTokens(address _tokenaddress,address _to) public notNull(_to) onlyMinter {
545         require(_tokenaddress != address(this), "Must not be self");
546         ERC20Interface token = ERC20Interface(_tokenaddress);
547 
548         // transfer current balance for this contract to _to  in token contract
549         // solhint-disable-next-line avoid-low-level-calls
550         (bool success, bytes memory returndata) = address(token).call(abi.encodeWithSelector(token.transfer.selector, _to, token.balanceOf(address(this))));
551         require(success);
552 
553         if (returndata.length > 0) { // Return data is optional
554             require(abi.decode(returndata, (bool)));
555         }        
556     }
557 
558     /// @notice minter transfer account tokens from one address `_from` to new token owner address `_to`. If `_to` is the redeem address then tokens will be burned 
559     /// @param _from The address of the original token owner
560     /// @param _to The address of the new token owner
561     /// @return Whether the transfer was successful or not
562     function transferAccount(address _from, address _to) public onlyMinter returns (bool result) {
563         uint256 balance = balanceOf(_from);
564         if(_to == redeemAddress) {
565             result = transferInternal(_from, _to, balance);
566         } else {
567             result = super.transferInternal(_from, _to, balance);
568         }
569         emit TransferAccount(_from, _to);
570     }
571 
572     // INTERNAL FUNCTIONS
573 
574     /// @notice internal send `_value` token to `_to` from `_from` 
575     /// @param _from The address of the sender
576     /// @param _to The address of the recipient
577     /// @param _value The amount of token to be transferred 
578     /// @return Whether the transfer was successful or not
579     function transferInternal(address _from, address _to, uint256 _value) internal notNull(_from) returns (bool) {
580         require(_to == redeemAddress, "Wrong destination address");
581         // burn _value
582         balances[_from] = balances[_from].sub(_value);
583         _totalSupply = _totalSupply.sub(_value);
584         // report as transfer + burn 
585         emit Transfer(_from, _to, _value);
586         emit Transfer(_to, address(0), _value);
587         return true;
588     }
589 
590     // PRIVATE FUNCTIONS
591 
592     event TransferAccount(address indexed _from, address indexed _to);
593 }