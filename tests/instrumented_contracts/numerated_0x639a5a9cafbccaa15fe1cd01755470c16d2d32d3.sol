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
289         string name;
290         string uri;
291         bytes32 contentHash;
292     }
293 
294     mapping (string => Document) private documents;
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
316     function attachDocument(string calldata _name, string calldata _uri, bytes32 _contentHash) external {
317         require(bytes(_name).length > 0, "name of the document must not be empty");
318         require(bytes(_uri).length > 0, "external URI to the document must not be empty");
319         documents[_name] = Document(_name, _uri, _contentHash);
320     }
321    
322     function lookupDocument(string calldata _name) external view returns (string memory, bytes32) {
323         Document storage doc = documents[_name];
324         return (doc.uri, doc.contentHash);
325     }
326 
327     // Use status codes from:
328     // https://eips.ethereum.org/EIPS/eip-1066
329     byte private STATUS_ALLOWED = 0x11;
330 
331     function checkTransferAllowed(address, address, uint256) public view returns (byte) {
332         return STATUS_ALLOWED;
333     }
334    
335     function checkTransferFromAllowed(address, address, uint256) public view returns (byte) {
336         return STATUS_ALLOWED;
337     }
338    
339     function checkMintAllowed(address, uint256) public view returns (byte) {
340         return STATUS_ALLOWED;
341     }
342    
343     function checkBurnAllowed(address, uint256) public view returns (byte) {
344         return STATUS_ALLOWED;
345     }
346 }
347 
348 contract LockRequestable {
349 
350         // MEMBERS
351         /// @notice  the count of all invocations of `generateLockId`.
352         uint256 public lockRequestCount;
353 
354         constructor() public {
355                 lockRequestCount = 0;
356         }
357 
358         // FUNCTIONS
359         /** @notice  Returns a fresh unique identifier.
360             *
361             * @dev the generation scheme uses three components.
362             * First, the blockhash of the previous block.
363             * Second, the deployed address.
364             * Third, the next value of the counter.
365             * This ensure that identifiers are unique across all contracts
366             * following this scheme, and that future identifiers are
367             * unpredictable.
368             *
369             * @return a 32-byte unique identifier.
370             */
371         function generateLockId() internal returns (bytes32 lockId) {
372                 return keccak256(
373                 abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount)
374                 );
375         }
376 }
377 
378 contract CustodianUpgradeable is LockRequestable {
379 
380         // TYPES
381         /// @dev  The struct type for pending custodian changes.
382         struct CustodianChangeRequest {
383                 address proposedNew;
384         }
385 
386         // MEMBERS
387         /// @dev  The address of the account or contract that acts as the custodian.
388         address public custodian;
389 
390         /// @dev  The map of lock ids to pending custodian changes.
391         mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
392 
393         constructor(address _custodian) public LockRequestable() {
394                 custodian = _custodian;
395         }
396 
397         // MODIFIERS
398         modifier onlyCustodian {
399                 require(msg.sender == custodian);
400                 _;
401         }
402 
403         /** @notice  Requests a change of the custodian associated with this contract.
404             *
405             * @dev  Returns a unique lock id associated with the request.
406             * Anyone can call this function, but confirming the request is authorized
407             * by the custodian.
408             *
409             * @param  _proposedCustodian  The address of the new custodian.
410             * @return  lockId  A unique identifier for this request.
411             */
412         function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
413                 require(_proposedCustodian != address(0));
414 
415                 lockId = generateLockId();
416 
417                 custodianChangeReqs[lockId] = CustodianChangeRequest({
418                         proposedNew: _proposedCustodian
419                 });
420 
421                 emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
422         }
423 
424         /** @notice  Confirms a pending change of the custodian associated with this contract.
425             *
426             * @dev  When called by the current custodian with a lock id associated with a
427             * pending custodian change, the `address custodian` member will be updated with the
428             * requested address.
429             *
430             * @param  _lockId  The identifier of a pending change request.
431             */
432         function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
433                 custodian = getCustodianChangeReq(_lockId);
434 
435                 delete custodianChangeReqs[_lockId];
436 
437                 emit CustodianChangeConfirmed(_lockId, custodian);
438         }
439 
440         // PRIVATE FUNCTIONS
441         function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
442                 CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
443 
444                 // reject ‘null’ results from the map lookup
445                 // this can only be the case if an unknown `_lockId` is received
446                 require(changeRequest.proposedNew != address(0));
447 
448                 return changeRequest.proposedNew;
449         }
450 
451         /// @dev  Emitted by successful `requestCustodianChange` calls.
452         event CustodianChangeRequested(
453                 bytes32 _lockId,
454                 address _msgSender,
455                 address _proposedCustodian
456         );
457 
458         /// @dev Emitted by successful `confirmCustodianChange` calls.
459         event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
460 }
461 
462 interface ServiceRegistry {
463     function getService(string calldata _name) external view returns (address);
464 }
465 
466 contract ServiceDiscovery {
467     ServiceRegistry internal services;
468 
469     constructor(ServiceRegistry _services) public {
470         services = ServiceRegistry(_services);
471     }
472 }
473 
474 contract KnowYourCustomer is CustodianUpgradeable {
475 
476     enum Status {
477         none,
478         passed,
479         suspended
480     }
481 
482     struct Customer {
483         Status status;
484         mapping(string => string) fields;
485     }
486     
487     event ProviderAuthorized(address indexed _provider, string _name);
488     event ProviderRemoved(address indexed _provider, string _name);
489     event CustomerApproved(address indexed _customer, address indexed _provider);
490     event CustomerSuspended(address indexed _customer, address indexed _provider);
491     event CustomerFieldSet(address indexed _customer, address indexed _field, string _name);
492 
493     mapping(address => bool) private providers;
494     mapping(address => Customer) private customers;
495 
496     constructor(address _custodian) public CustodianUpgradeable(_custodian) {
497         customers[_custodian].status = Status.passed;
498         customers[_custodian].fields["type"] = "custodian";
499         emit CustomerApproved(_custodian, msg.sender);
500         emit CustomerFieldSet(_custodian, msg.sender, "type");
501     }
502 
503     function providerAuthorize(address _provider, string calldata name) external onlyCustodian {
504         require(providers[_provider] == false, "provider must not exist");
505         providers[_provider] = true;
506         // cc:II. Manage Providers#2;Provider becomes authorized in contract;1;
507         emit ProviderAuthorized(_provider, name);
508     }
509 
510     function providerRemove(address _provider, string calldata name) external onlyCustodian {
511         require(providers[_provider] == true, "provider must exist");
512         delete providers[_provider];
513         emit ProviderRemoved(_provider, name);
514     }
515 
516     function hasWritePermissions(address _provider) external view returns (bool) {
517         return _provider == custodian || providers[_provider] == true;
518     }
519 
520     function getCustomerStatus(address _customer) external view returns (Status) {
521         return customers[_customer].status;
522     }
523 
524     function getCustomerField(address _customer, string calldata _field) external view returns (string memory) {
525         return customers[_customer].fields[_field];
526     }
527 
528     function approveCustomer(address _customer) external onlyAuthorized {
529         Status status = customers[_customer].status;
530         require(status != Status.passed, "customer must not be approved before");
531         customers[_customer].status = Status.passed;
532         // cc:III. Manage Customers#2;Customer becomes approved in contract;1;
533         emit CustomerApproved(_customer, msg.sender);
534     }
535 
536     function setCustomerField(address _customer, string calldata _field, string calldata _value) external onlyAuthorized {
537         Status status = customers[_customer].status;
538         require(status != Status.none, "customer must have a set status");
539         customers[_customer].fields[_field] = _value;
540         emit CustomerFieldSet(_customer, msg.sender, _field);
541     }
542 
543     function suspendCustomer(address _customer) external onlyAuthorized {
544         Status status = customers[_customer].status;
545         require(status != Status.suspended, "customer must be not suspended");
546         customers[_customer].status = Status.suspended;
547         emit CustomerSuspended(_customer, msg.sender);
548     }
549 
550     modifier onlyAuthorized() {
551         require(msg.sender == custodian || providers[msg.sender] == true);
552         _;
553     }
554 }
555 
556 contract TokenSettingsInterface {
557 
558     // METHODS
559     function getTradeAllowed() public view returns (bool);
560     function getMintAllowed() public view returns (bool);
561     function getBurnAllowed() public view returns (bool);
562     
563     // EVENTS
564     event TradeAllowedLocked(bytes32 _lockId, bool _newValue);
565     event TradeAllowedConfirmed(bytes32 _lockId, bool _newValue);
566     event MintAllowedLocked(bytes32 _lockId, bool _newValue);
567     event MintAllowedConfirmed(bytes32 _lockId, bool _newValue);
568     event BurnAllowedLocked(bytes32 _lockId, bool _newValue);
569     event BurnAllowedConfirmed(bytes32 _lockId, bool _newValue);
570 
571     // MODIFIERS
572     modifier onlyCustodian {
573         _;
574     }
575 }
576 
577 
578 contract _BurnAllowed is TokenSettingsInterface, LockRequestable {
579     // cc:IV. BurnAllowed Setting#2;Burn Allowed Switch;1;
580     //
581     // SETTING: Burn Allowed Switch (bool)
582     // Boundary: true or false
583     //
584     // Enables or disables token minting ability globally (even for custodian).
585     //
586     bool private burnAllowed = false;
587 
588     function getBurnAllowed() public view returns (bool) {
589         return burnAllowed;
590     }
591 
592     // SETTING MANAGEMENT
593 
594     struct PendingBurnAllowed {
595         bool burnAllowed;
596         bool set;
597     }
598 
599     mapping (bytes32 => PendingBurnAllowed) public pendingBurnAllowedMap;
600 
601     function requestBurnAllowedChange(bool _burnAllowed) public returns (bytes32 lockId) {
602        require(_burnAllowed != burnAllowed);
603        
604        lockId = generateLockId();
605        pendingBurnAllowedMap[lockId] = PendingBurnAllowed({
606            burnAllowed: _burnAllowed,
607            set: true
608        });
609 
610        emit BurnAllowedLocked(lockId, _burnAllowed);
611     }
612 
613     function confirmBurnAllowedChange(bytes32 _lockId) public onlyCustodian {
614         PendingBurnAllowed storage value = pendingBurnAllowedMap[_lockId];
615         require(value.set == true);
616         burnAllowed = value.burnAllowed;
617         emit BurnAllowedConfirmed(_lockId, value.burnAllowed);
618         delete pendingBurnAllowedMap[_lockId];
619     }
620 }
621 
622 
623 contract _MintAllowed is TokenSettingsInterface, LockRequestable {
624     // cc:III. MintAllowed Setting#2;Mint Allowed Switch;1;
625     //
626     // SETTING: Mint Allowed Switch (bool)
627     // Boundary: true or false
628     //
629     // Enables or disables token minting ability globally (even for custodian).
630     //
631     bool private mintAllowed = false;
632 
633     function getMintAllowed() public view returns (bool) {
634         return mintAllowed;
635     }
636 
637     // SETTING MANAGEMENT
638 
639     struct PendingMintAllowed {
640         bool mintAllowed;
641         bool set;
642     }
643 
644     mapping (bytes32 => PendingMintAllowed) public pendingMintAllowedMap;
645 
646     function requestMintAllowedChange(bool _mintAllowed) public returns (bytes32 lockId) {
647        require(_mintAllowed != mintAllowed);
648        
649        lockId = generateLockId();
650        pendingMintAllowedMap[lockId] = PendingMintAllowed({
651            mintAllowed: _mintAllowed,
652            set: true
653        });
654 
655        emit MintAllowedLocked(lockId, _mintAllowed);
656     }
657 
658     function confirmMintAllowedChange(bytes32 _lockId) public onlyCustodian {
659         PendingMintAllowed storage value = pendingMintAllowedMap[_lockId];
660         require(value.set == true);
661         mintAllowed = value.mintAllowed;
662         emit MintAllowedConfirmed(_lockId, value.mintAllowed);
663         delete pendingMintAllowedMap[_lockId];
664     }
665 }
666 
667 
668 contract _TradeAllowed is TokenSettingsInterface, LockRequestable {
669     // cc:II. TradeAllowed Setting#2;Trade Allowed Switch;1;
670     //
671     // SETTING: Trade Allowed Switch (bool)
672     // Boundary: true or false
673     //
674     // Enables or disables all token transfers, between any recipients, except mint and burn operations.
675     //
676     bool private tradeAllowed = false;
677 
678     function getTradeAllowed() public view returns (bool) {
679         return tradeAllowed;
680     }
681 
682     // SETTING MANAGEMENT
683 
684     struct PendingTradeAllowed {
685         bool tradeAllowed;
686         bool set;
687     }
688 
689     mapping (bytes32 => PendingTradeAllowed) public pendingTradeAllowedMap;
690 
691     function requestTradeAllowedChange(bool _tradeAllowed) public returns (bytes32 lockId) {
692        require(_tradeAllowed != tradeAllowed);
693        
694        lockId = generateLockId();
695        pendingTradeAllowedMap[lockId] = PendingTradeAllowed({
696            tradeAllowed: _tradeAllowed,
697            set: true
698        });
699 
700        emit TradeAllowedLocked(lockId, _tradeAllowed);
701     }
702 
703     function confirmTradeAllowedChange(bytes32 _lockId) public onlyCustodian {
704         PendingTradeAllowed storage value = pendingTradeAllowedMap[_lockId];
705         require(value.set == true);
706         tradeAllowed = value.tradeAllowed;
707         emit TradeAllowedConfirmed(_lockId, value.tradeAllowed);
708         delete pendingTradeAllowedMap[_lockId];
709     }
710 }
711 
712 contract TokenSettings is TokenSettingsInterface, CustodianUpgradeable,
713 _TradeAllowed,
714 _MintAllowed,
715 _BurnAllowed
716     {
717     constructor(address _custodian) public CustodianUpgradeable(_custodian) {
718     }
719 }
720 
721 
722 /**
723  * @title TokenController implements restriction logic for BaseSecurityToken.
724  * @dev see https://eips.ethereum.org/EIPS/eip-1462
725  */
726 contract TokenController is CustodianUpgradeable, ServiceDiscovery {
727     constructor(address _custodian, ServiceRegistry _services) public
728     CustodianUpgradeable(_custodian) ServiceDiscovery(_services) {
729     }
730 
731     // Use status codes from:
732     // https://eips.ethereum.org/EIPS/eip-1066
733     byte private constant STATUS_ALLOWED = 0x11;
734 
735     function checkTransferAllowed(address _from, address _to, uint256) public view returns (byte) {
736         require(_settings().getTradeAllowed(), "global trade must be allowed");
737         require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "sender does not have valid KYC status");
738         require(_kyc().getCustomerStatus(_to) == KnowYourCustomer.Status.passed, "recipient does not have valid KYC status");
739 
740         // TODO:
741         // Check user's region
742         // Check amount for transfer limits
743 
744         return STATUS_ALLOWED;
745     }
746    
747     function checkTransferFromAllowed(address _from, address _to, uint256 _amount) external view returns (byte) {
748         return checkTransferAllowed(_from, _to, _amount);
749     }
750    
751     function checkMintAllowed(address _from, uint256) external view returns (byte) {
752         require(_settings().getMintAllowed(), "global mint must be allowed");
753         require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "recipient does not have valid KYC status");
754         
755         return STATUS_ALLOWED;
756     }
757    
758     function checkBurnAllowed(address _from, uint256) external view returns (byte) {
759         require(_settings().getBurnAllowed(), "global burn must be allowed");
760         require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "sender does not have valid KYC status");
761 
762         return STATUS_ALLOWED;
763     }
764 
765     function _settings() private view returns (TokenSettings) {
766         return TokenSettings(services.getService("token/settings"));
767     }
768 
769     function _kyc() private view returns (KnowYourCustomer) {
770         return KnowYourCustomer(services.getService("validators/kyc"));
771     }
772 }
773 
774 contract BaRA is BaseSecurityToken, CustodianUpgradeable, ServiceDiscovery {
775     
776     uint public limit = 400 * 1e6;
777     string public name = "Banksia BioPharm Security Token";
778     string public symbol = "BaRA";
779     uint8 public decimals = 0;
780 
781     constructor(address _custodian, ServiceRegistry _services,
782         string memory _name, string memory _symbol, uint _limit) public 
783         CustodianUpgradeable(_custodian) ServiceDiscovery(_services) {
784 
785         name = _name;
786         symbol = _symbol;
787         limit = _limit;
788     }
789 
790     function mint(address _to, uint _amount) public onlyCustodian {
791         require(_amount != 0, "check amount to mint");
792         require(super.totalSupply() + _amount <= limit, "check total supply after mint");
793         BaseSecurityToken._mint(_to, _amount);
794     }
795 
796     function checkTransferAllowed (address _from, address _to, uint256 _amount) public view returns (byte) {
797         return _controller().checkTransferAllowed(_from, _to, _amount);
798     }
799    
800     function checkTransferFromAllowed (address _from, address _to, uint256 _amount) public view returns (byte) {
801         return _controller().checkTransferFromAllowed(_from, _to, _amount);
802     }
803    
804     function checkMintAllowed (address _from, uint256 _amount) public view returns (byte) {
805         return _controller().checkMintAllowed(_from, _amount);
806     }
807    
808     function checkBurnAllowed (address _from, uint256 _amount) public view returns (byte) {
809         return _controller().checkBurnAllowed(_from, _amount);
810     }
811 
812     function _controller() private view returns (TokenController) {
813         return TokenController(services.getService("token/controller"));
814     }
815 }