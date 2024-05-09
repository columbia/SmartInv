1 pragma solidity ^0.5.1;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(
17         address indexed from,
18         address indexed to,
19         uint256 value
20     );
21 
22     event Approval(
23         address indexed owner,
24         address indexed spender,
25         uint256 value
26     );
27 }
28 
29 library SafeMath {
30     /**
31     * @dev Multiplies two numbers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b, "");
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60     */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a, "");
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69     * @dev Adds two numbers, reverts on overflow.
70     */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "");
74 
75         return c;
76     }
77 
78     /**
79     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
80     * reverts when dividing by zero.
81     */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0, "");
84         return a % b;
85     }
86 }
87 
88 contract ERC20 is IERC20 {
89     using SafeMath for uint256;
90 
91     mapping (address => uint256) private _balances;
92 
93     mapping (address => mapping (address => uint256)) private _allowed;
94 
95     uint256 private _totalSupply;
96 
97     /**
98     * @dev Total number of tokens in existence
99     */
100     function totalSupply() public view returns (uint256) {
101         return _totalSupply;
102     }
103 
104     /**
105     * @dev Gets the balance of the specified address.
106     * @param owner The address to query the balance of.
107     * @return An uint256 representing the amount owned by the passed address.
108     */
109     function balanceOf(address owner) public view returns (uint256) {
110         return _balances[owner];
111     }
112 
113     /**
114      * @dev Function to check the amount of tokens that an owner allowed to a spender.
115      * @param owner address The address which owns the funds.
116      * @param spender address The address which will spend the funds.
117      * @return A uint256 specifying the amount of tokens still available for the spender.
118      */
119     function allowance(
120         address owner,
121         address spender
122     )
123         public
124         view
125         returns (uint256)
126     {
127         return _allowed[owner][spender];
128     }
129 
130     /**
131     * @dev Transfer token for a specified address
132     * @param to The address to transfer to.
133     * @param value The amount to be transferred.
134     */
135     function transfer(address to, uint256 value) public returns (bool) {
136         require(value <= _balances[msg.sender], "");
137         require(to != address(0), "");
138 
139         _balances[msg.sender] = _balances[msg.sender].sub(value);
140         _balances[to] = _balances[to].add(value);
141         emit Transfer(msg.sender, to, value);
142         return true;
143     }
144 
145     /**
146      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147      * Beware that changing an allowance with this method brings the risk that someone may use both the old
148      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      * @param spender The address which will spend the funds.
152      * @param value The amount of tokens to be spent.
153      */
154     function approve(address spender, uint256 value) public returns (bool) {
155         require(spender != address(0), "");
156 
157         _allowed[msg.sender][spender] = value;
158         emit Approval(msg.sender, spender, value);
159         return true;
160     }
161 
162     /**
163      * @dev Transfer tokens from one address to another
164      * @param from address The address which you want to send tokens from
165      * @param to address The address which you want to transfer to
166      * @param value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(
169         address from,
170         address to,
171         uint256 value
172     )
173         public
174         returns (bool)
175     {
176         require(value <= _balances[from], "");
177         require(value <= _allowed[from][msg.sender], "");
178         require(to != address(0), "");
179 
180         _balances[from] = _balances[from].sub(value);
181         _balances[to] = _balances[to].add(value);
182         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
183         emit Transfer(from, to, value);
184         return true;
185     }
186 
187     /**
188      * @dev Increase the amount of tokens that an owner allowed to a spender.
189      * approve should be called when allowed_[_spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(
197         address spender,
198         uint256 addedValue
199     )
200         public
201         returns (bool)
202     {
203         require(spender != address(0), "");
204 
205         _allowed[msg.sender][spender] = (
206             _allowed[msg.sender][spender].add(addedValue));
207         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
208         return true;
209     }
210 
211     /**
212      * @dev Decrease the amount of tokens that an owner allowed to a spender.
213      * approve should be called when allowed_[_spender] == 0. To decrement
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * @param spender The address which will spend the funds.
218      * @param subtractedValue The amount of tokens to decrease the allowance by.
219      */
220     function decreaseAllowance(
221         address spender,
222         uint256 subtractedValue
223     )
224         public
225         returns (bool)
226     {
227         require(spender != address(0), "");
228 
229         _allowed[msg.sender][spender] = (
230             _allowed[msg.sender][spender].sub(subtractedValue));
231         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
232         return true;
233     }
234 
235     /**
236      * @dev Internal function that mints an amount of the token and assigns it to
237      * an account. This encapsulates the modification of balances such that the
238      * proper events are emitted.
239      * @param account The account that will receive the created tokens.
240      * @param amount The amount that will be created.
241      */
242     function _mint(address account, uint256 amount) internal {
243         require(account != address(0), "");
244         _totalSupply = _totalSupply.add(amount);
245         _balances[account] = _balances[account].add(amount);
246         emit Transfer(address(0), account, amount);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param amount The amount that will be burnt.
254      */
255     function _burn(address account, uint256 amount) internal {
256         require(account != address(0), "");
257         require(amount <= _balances[account], "");
258 
259         _totalSupply = _totalSupply.sub(amount);
260         _balances[account] = _balances[account].sub(amount);
261         emit Transfer(account, address(0), amount);
262     }
263 
264     /**
265      * @dev Internal function that burns an amount of the token of a given
266      * account, deducting from the sender's allowance for said account. Uses the
267      * internal burn function.
268      * @param account The account whose tokens will be burnt.
269      * @param amount The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 amount) internal {
272         require(amount <= _allowed[account][msg.sender], "");
273 
274         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
275         // this function needs to emit an event with the updated approval.
276         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
277             amount);
278         _burn(account, amount);
279     }
280 }
281 
282 /**
283  * @title BaseSecurityToken implementation
284  * @dev see https://eips.ethereum.org/EIPS/eip-1462
285  */
286 contract BaseSecurityToken is ERC20 {
287     
288     struct Document {
289         bytes32 name;
290         string uri;
291         bytes32 contentHash;
292     }
293 
294     mapping (bytes32 => Document) private documents;
295 
296     function transfer(address to, uint256 value) public returns (bool) {
297         require(checkTransferAllowed(msg.sender, to, value) == STATUS_ALLOWED, "transfer must be allowed");
298         return ERC20.transfer(to, value);
299     }
300 
301     function transferFrom(address from, address to, uint256 value) public returns (bool) {
302         require(checkTransferFromAllowed(from, to, value) == STATUS_ALLOWED, "transfer must be allowed");
303         return ERC20.transferFrom(from, to, value);
304     }
305 
306     function _mint(address account, uint256 amount) internal {
307         require(checkMintAllowed(account, amount) == STATUS_ALLOWED, "mint must be allowed");
308         ERC20._mint(account, amount);
309     }
310 
311     function _burn(address account, uint256 amount) internal {
312         require(checkBurnAllowed(account, amount) == STATUS_ALLOWED, "burn must be allowed");
313         ERC20._burn(account, amount);
314     }
315 
316     function attachDocument(bytes32 _name, string calldata _uri, bytes32 _contentHash) external {
317         require(_name.length > 0, "name of the document must not be empty");
318         require(bytes(_uri).length > 0, "external URI to the document must not be empty");
319         require(_contentHash.length > 0, "content hash is required, use SHA-256 when in doubt");
320         require(documents[_name].name.length == 0, "document must not be existing under the same name");
321         documents[_name] = Document(_name, _uri, _contentHash);
322     }
323    
324     function lookupDocument(bytes32 _name) external view returns (string memory, bytes32) {
325         Document storage doc = documents[_name];
326         return (doc.uri, doc.contentHash);
327     }
328 
329     // Use status codes from:
330     // https://eips.ethereum.org/EIPS/eip-1066
331     byte private STATUS_ALLOWED = 0x11;
332 
333     function checkTransferAllowed(address, address, uint256) public view returns (byte) {
334         return STATUS_ALLOWED;
335     }
336    
337     function checkTransferFromAllowed(address, address, uint256) public view returns (byte) {
338         return STATUS_ALLOWED;
339     }
340    
341     function checkMintAllowed(address, uint256) public view returns (byte) {
342         return STATUS_ALLOWED;
343     }
344    
345     function checkBurnAllowed(address, uint256) public view returns (byte) {
346         return STATUS_ALLOWED;
347     }
348 }
349 
350 contract LockRequestable {
351 
352         // MEMBERS
353         /// @notice  the count of all invocations of `generateLockId`.
354         uint256 public lockRequestCount;
355 
356         constructor() public {
357                 lockRequestCount = 0;
358         }
359 
360         // FUNCTIONS
361         /** @notice  Returns a fresh unique identifier.
362             *
363             * @dev the generation scheme uses three components.
364             * First, the blockhash of the previous block.
365             * Second, the deployed address.
366             * Third, the next value of the counter.
367             * This ensure that identifiers are unique across all contracts
368             * following this scheme, and that future identifiers are
369             * unpredictable.
370             *
371             * @return a 32-byte unique identifier.
372             */
373         function generateLockId() internal returns (bytes32 lockId) {
374                 return keccak256(
375                 abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount)
376                 );
377         }
378 }
379 
380 contract CustodianUpgradeable is LockRequestable {
381 
382         // TYPES
383         /// @dev  The struct type for pending custodian changes.
384         struct CustodianChangeRequest {
385                 address proposedNew;
386         }
387 
388         // MEMBERS
389         /// @dev  The address of the account or contract that acts as the custodian.
390         address public custodian;
391 
392         /// @dev  The map of lock ids to pending custodian changes.
393         mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
394 
395         constructor(address _custodian) public LockRequestable() {
396                 custodian = _custodian;
397         }
398 
399         // MODIFIERS
400         modifier onlyCustodian {
401                 require(msg.sender == custodian);
402                 _;
403         }
404 
405         /** @notice  Requests a change of the custodian associated with this contract.
406             *
407             * @dev  Returns a unique lock id associated with the request.
408             * Anyone can call this function, but confirming the request is authorized
409             * by the custodian.
410             *
411             * @param  _proposedCustodian  The address of the new custodian.
412             * @return  lockId  A unique identifier for this request.
413             */
414         function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
415                 require(_proposedCustodian != address(0));
416 
417                 lockId = generateLockId();
418 
419                 custodianChangeReqs[lockId] = CustodianChangeRequest({
420                         proposedNew: _proposedCustodian
421                 });
422 
423                 emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
424         }
425 
426         /** @notice  Confirms a pending change of the custodian associated with this contract.
427             *
428             * @dev  When called by the current custodian with a lock id associated with a
429             * pending custodian change, the `address custodian` member will be updated with the
430             * requested address.
431             *
432             * @param  _lockId  The identifier of a pending change request.
433             */
434         function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
435                 custodian = getCustodianChangeReq(_lockId);
436 
437                 delete custodianChangeReqs[_lockId];
438 
439                 emit CustodianChangeConfirmed(_lockId, custodian);
440         }
441 
442         // PRIVATE FUNCTIONS
443         function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
444                 CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
445 
446                 // reject ‘null’ results from the map lookup
447                 // this can only be the case if an unknown `_lockId` is received
448                 require(changeRequest.proposedNew != address(0));
449 
450                 return changeRequest.proposedNew;
451         }
452 
453         /// @dev  Emitted by successful `requestCustodianChange` calls.
454         event CustodianChangeRequested(
455                 bytes32 _lockId,
456                 address _msgSender,
457                 address _proposedCustodian
458         );
459 
460         /// @dev Emitted by successful `confirmCustodianChange` calls.
461         event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
462 }
463 
464 interface ServiceRegistry {
465     function getService(string calldata _name) external view returns (address);
466 }
467 
468 contract ServiceDiscovery {
469     ServiceRegistry internal services;
470 
471     constructor(ServiceRegistry _services) public {
472         services = ServiceRegistry(_services);
473     }
474 }
475 
476 contract KnowYourCustomer is CustodianUpgradeable {
477 
478     enum Status {
479         none,
480         passed,
481         suspended
482     }
483 
484     struct Customer {
485         Status status;
486         mapping(string => string) fields;
487     }
488     
489     event ProviderAuthorized(address indexed _provider, string _name);
490     event ProviderRemoved(address indexed _provider, string _name);
491     event CustomerApproved(address indexed _customer, address indexed _provider);
492     event CustomerSuspended(address indexed _customer, address indexed _provider);
493     event CustomerFieldSet(address indexed _customer, address indexed _field, string _name);
494 
495     mapping(address => bool) private providers;
496     mapping(address => Customer) private customers;
497 
498     constructor(address _custodian) public CustodianUpgradeable(_custodian) {
499         customers[_custodian].status = Status.passed;
500         customers[_custodian].fields["type"] = "custodian";
501         emit CustomerApproved(_custodian, msg.sender);
502         emit CustomerFieldSet(_custodian, msg.sender, "type");
503     }
504 
505     function providerAuthorize(address _provider, string calldata name) external onlyCustodian {
506         require(providers[_provider] == false, "provider must not exist");
507         providers[_provider] = true;
508         // cc:II. Manage Providers#2;Provider becomes authorized in contract;1;
509         emit ProviderAuthorized(_provider, name);
510     }
511 
512     function providerRemove(address _provider, string calldata name) external onlyCustodian {
513         require(providers[_provider] == true, "provider must exist");
514         delete providers[_provider];
515         emit ProviderRemoved(_provider, name);
516     }
517 
518     function hasWritePermissions(address _provider) external view returns (bool) {
519         return _provider == custodian || providers[_provider] == true;
520     }
521 
522     function getCustomerStatus(address _customer) external view returns (Status) {
523         return customers[_customer].status;
524     }
525 
526     function getCustomerField(address _customer, string calldata _field) external view returns (string memory) {
527         return customers[_customer].fields[_field];
528     }
529 
530     function approveCustomer(address _customer) external onlyAuthorized {
531         Status status = customers[_customer].status;
532         require(status != Status.passed, "customer must not be approved before");
533         customers[_customer].status = Status.passed;
534         // cc:III. Manage Customers#2;Customer becomes approved in contract;1;
535         emit CustomerApproved(_customer, msg.sender);
536     }
537 
538     function setCustomerField(address _customer, string calldata _field, string calldata _value) external onlyAuthorized {
539         Status status = customers[_customer].status;
540         require(status != Status.none, "customer must have a set status");
541         customers[_customer].fields[_field] = _value;
542         emit CustomerFieldSet(_customer, msg.sender, _field);
543     }
544 
545     function suspendCustomer(address _customer) external onlyAuthorized {
546         Status status = customers[_customer].status;
547         require(status != Status.suspended, "customer must be not suspended");
548         customers[_customer].status = Status.suspended;
549         emit CustomerSuspended(_customer, msg.sender);
550     }
551 
552     modifier onlyAuthorized() {
553         require(msg.sender == custodian || providers[msg.sender] == true);
554         _;
555     }
556 }
557 
558 contract TokenSettingsInterface {
559 
560     // METHODS
561     function getTradeAllowed() public view returns (bool);
562     function getMintAllowed() public view returns (bool);
563     function getBurnAllowed() public view returns (bool);
564     
565     // EVENTS
566     event TradeAllowedLocked(bytes32 _lockId, bool _newValue);
567     event TradeAllowedConfirmed(bytes32 _lockId, bool _newValue);
568     event MintAllowedLocked(bytes32 _lockId, bool _newValue);
569     event MintAllowedConfirmed(bytes32 _lockId, bool _newValue);
570     event BurnAllowedLocked(bytes32 _lockId, bool _newValue);
571     event BurnAllowedConfirmed(bytes32 _lockId, bool _newValue);
572 
573     // MODIFIERS
574     modifier onlyCustodian {
575         _;
576     }
577 }
578 
579 
580 contract _BurnAllowed is TokenSettingsInterface, LockRequestable {
581     // cc:IV. BurnAllowed Setting#2;Burn Allowed Switch;1;
582     //
583     // SETTING: Burn Allowed Switch (bool)
584     // Boundary: true or false
585     //
586     // Enables or disables token minting ability globally (even for custodian).
587     //
588     bool private burnAllowed = false;
589 
590     function getBurnAllowed() public view returns (bool) {
591         return burnAllowed;
592     }
593 
594     // SETTING MANAGEMENT
595 
596     struct PendingBurnAllowed {
597         bool burnAllowed;
598         bool set;
599     }
600 
601     mapping (bytes32 => PendingBurnAllowed) public pendingBurnAllowedMap;
602 
603     function requestBurnAllowedChange(bool _burnAllowed) public returns (bytes32 lockId) {
604        require(_burnAllowed != burnAllowed);
605        
606        lockId = generateLockId();
607        pendingBurnAllowedMap[lockId] = PendingBurnAllowed({
608            burnAllowed: _burnAllowed,
609            set: true
610        });
611 
612        emit BurnAllowedLocked(lockId, _burnAllowed);
613     }
614 
615     function confirmBurnAllowedChange(bytes32 _lockId) public onlyCustodian {
616         PendingBurnAllowed storage value = pendingBurnAllowedMap[_lockId];
617         require(value.set == true);
618         burnAllowed = value.burnAllowed;
619         emit BurnAllowedConfirmed(_lockId, value.burnAllowed);
620         delete pendingBurnAllowedMap[_lockId];
621     }
622 }
623 
624 
625 contract _MintAllowed is TokenSettingsInterface, LockRequestable {
626     // cc:III. MintAllowed Setting#2;Mint Allowed Switch;1;
627     //
628     // SETTING: Mint Allowed Switch (bool)
629     // Boundary: true or false
630     //
631     // Enables or disables token minting ability globally (even for custodian).
632     //
633     bool private mintAllowed = false;
634 
635     function getMintAllowed() public view returns (bool) {
636         return mintAllowed;
637     }
638 
639     // SETTING MANAGEMENT
640 
641     struct PendingMintAllowed {
642         bool mintAllowed;
643         bool set;
644     }
645 
646     mapping (bytes32 => PendingMintAllowed) public pendingMintAllowedMap;
647 
648     function requestMintAllowedChange(bool _mintAllowed) public returns (bytes32 lockId) {
649        require(_mintAllowed != mintAllowed);
650        
651        lockId = generateLockId();
652        pendingMintAllowedMap[lockId] = PendingMintAllowed({
653            mintAllowed: _mintAllowed,
654            set: true
655        });
656 
657        emit MintAllowedLocked(lockId, _mintAllowed);
658     }
659 
660     function confirmMintAllowedChange(bytes32 _lockId) public onlyCustodian {
661         PendingMintAllowed storage value = pendingMintAllowedMap[_lockId];
662         require(value.set == true);
663         mintAllowed = value.mintAllowed;
664         emit MintAllowedConfirmed(_lockId, value.mintAllowed);
665         delete pendingMintAllowedMap[_lockId];
666     }
667 }
668 
669 
670 contract _TradeAllowed is TokenSettingsInterface, LockRequestable {
671     // cc:II. TradeAllowed Setting#2;Trade Allowed Switch;1;
672     //
673     // SETTING: Trade Allowed Switch (bool)
674     // Boundary: true or false
675     //
676     // Enables or disables all token transfers, between any recipients, except mint and burn operations.
677     //
678     bool private tradeAllowed = false;
679 
680     function getTradeAllowed() public view returns (bool) {
681         return tradeAllowed;
682     }
683 
684     // SETTING MANAGEMENT
685 
686     struct PendingTradeAllowed {
687         bool tradeAllowed;
688         bool set;
689     }
690 
691     mapping (bytes32 => PendingTradeAllowed) public pendingTradeAllowedMap;
692 
693     function requestTradeAllowedChange(bool _tradeAllowed) public returns (bytes32 lockId) {
694        require(_tradeAllowed != tradeAllowed);
695        
696        lockId = generateLockId();
697        pendingTradeAllowedMap[lockId] = PendingTradeAllowed({
698            tradeAllowed: _tradeAllowed,
699            set: true
700        });
701 
702        emit TradeAllowedLocked(lockId, _tradeAllowed);
703     }
704 
705     function confirmTradeAllowedChange(bytes32 _lockId) public onlyCustodian {
706         PendingTradeAllowed storage value = pendingTradeAllowedMap[_lockId];
707         require(value.set == true);
708         tradeAllowed = value.tradeAllowed;
709         emit TradeAllowedConfirmed(_lockId, value.tradeAllowed);
710         delete pendingTradeAllowedMap[_lockId];
711     }
712 }
713 
714 contract TokenSettings is TokenSettingsInterface, CustodianUpgradeable,
715 _TradeAllowed,
716 _MintAllowed,
717 _BurnAllowed
718     {
719     constructor(address _custodian) public CustodianUpgradeable(_custodian) {
720     }
721 }
722 
723 
724 /**
725  * @title TokenController implements restriction logic for BaseSecurityToken.
726  * @dev see https://eips.ethereum.org/EIPS/eip-1462
727  */
728 contract TokenController is CustodianUpgradeable, ServiceDiscovery {
729     constructor(address _custodian, ServiceRegistry _services) public
730     CustodianUpgradeable(_custodian) ServiceDiscovery(_services) {
731     }
732 
733     // Use status codes from:
734     // https://eips.ethereum.org/EIPS/eip-1066
735     byte private constant STATUS_ALLOWED = 0x11;
736 
737     function checkTransferAllowed(address _from, address _to, uint256) public view returns (byte) {
738         require(_settings().getTradeAllowed(), "global trade must be allowed");
739         require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "sender does not have valid KYC status");
740         require(_kyc().getCustomerStatus(_to) == KnowYourCustomer.Status.passed, "recipient does not have valid KYC status");
741 
742         // TODO:
743         // Check user's region
744         // Check amount for transfer limits
745 
746         return STATUS_ALLOWED;
747     }
748    
749     function checkTransferFromAllowed(address _from, address _to, uint256 _amount) external view returns (byte) {
750         return checkTransferAllowed(_from, _to, _amount);
751     }
752    
753     function checkMintAllowed(address _from, uint256) external view returns (byte) {
754         require(_settings().getMintAllowed(), "global mint must be allowed");
755         require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "recipient does not have valid KYC status");
756         
757         return STATUS_ALLOWED;
758     }
759    
760     function checkBurnAllowed(address _from, uint256) external view returns (byte) {
761         require(_settings().getBurnAllowed(), "global burn must be allowed");
762         require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "sender does not have valid KYC status");
763 
764         return STATUS_ALLOWED;
765     }
766 
767     function _settings() private view returns (TokenSettings) {
768         return TokenSettings(services.getService("token/settings"));
769     }
770 
771     function _kyc() private view returns (KnowYourCustomer) {
772         return KnowYourCustomer(services.getService("validators/kyc"));
773     }
774 }
775 
776 contract BaRA is BaseSecurityToken, CustodianUpgradeable, ServiceDiscovery {
777     
778     uint public limit = 400 * 1e6;
779     string public name = "Banksia BioPharm Security Token";
780     string public symbol = "BaRA";
781     uint8 public decimals = 0;
782 
783     constructor(address _custodian, ServiceRegistry _services,
784         string memory _name, string memory _symbol, uint _limit) public 
785         CustodianUpgradeable(_custodian) ServiceDiscovery(_services) {
786 
787         name = _name;
788         symbol = _symbol;
789         limit = _limit;
790     }
791 
792     function mint(address _to, uint _amount) public onlyCustodian {
793         require(_amount != 0, "check amount to mint");
794         require(super.totalSupply() + _amount <= limit, "check total supply after mint");
795         BaseSecurityToken._mint(_to, _amount);
796     }
797 
798     function checkTransferAllowed (address _from, address _to, uint256 _amount) public view returns (byte) {
799         return _controller().checkTransferAllowed(_from, _to, _amount);
800     }
801    
802     function checkTransferFromAllowed (address _from, address _to, uint256 _amount) public view returns (byte) {
803         return _controller().checkTransferFromAllowed(_from, _to, _amount);
804     }
805    
806     function checkMintAllowed (address _from, uint256 _amount) public view returns (byte) {
807         return _controller().checkMintAllowed(_from, _amount);
808     }
809    
810     function checkBurnAllowed (address _from, uint256 _amount) public view returns (byte) {
811         return _controller().checkBurnAllowed(_from, _amount);
812     }
813 
814     function _controller() private view returns (TokenController) {
815         return TokenController(services.getService("token/controller"));
816     }
817 }