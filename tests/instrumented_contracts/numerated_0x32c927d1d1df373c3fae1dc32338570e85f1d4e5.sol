1 /**
2 * @title Ownable
3 * @dev The Ownable contract has an owner address, and provides basic authorization control
4 * functions, this simplifies the implementation of "user permissions".
5 */
6 contract Ownable {
7     address private _owner;
8 
9     event OwnershipTransferred(
10         address indexed previousOwner,
11         address indexed newOwner
12     );
13 
14     /**
15     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16     * account.
17     */
18     constructor() public {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24     * @return the address of the owner.
25     */
26     function owner() public view returns(address) {
27         return _owner;
28     }
29 
30     /**
31     * @dev Throws if called by any account other than the owner.
32     */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39     * @return true if `msg.sender` is the owner of the contract.
40     */
41     function isOwner() public view returns(bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46     * @dev Allows the current owner to relinquish control of the contract.
47     * @notice Renouncing to ownership will leave the contract without an owner.
48     * It will not be possible to call the functions with the `onlyOwner`
49     * modifier anymore.
50     */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57     * @dev Allows the current owner to transfer control of the contract to a newOwner.
58     * @param newOwner The address to transfer ownership to.
59     */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65     * @dev Transfers control of the contract to a newOwner.
66     * @param newOwner The address to transfer ownership to.
67     */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 /**
76 * @title SafeMath
77 * @dev Math operations with safety checks that revert on error
78 */
79 library SafeMath {
80 
81     /**
82     * @dev Multiplies two numbers, reverts on overflow.
83     */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b);
94 
95         return c;
96     }
97 
98     /**
99     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
100     */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b > 0); // Solidity only automatically asserts when dividing by 0
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111     */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120     * @dev Adds two numbers, reverts on overflow.
121     */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a);
125 
126         return c;
127     }
128 
129     /**
130     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
131     * reverts when dividing by zero.
132     */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0);
135         return a % b;
136     }
137 }
138 
139 interface HydroInterface {
140     function balances(address) external view returns (uint);
141     function allowed(address, address) external view returns (uint);
142     function transfer(address _to, uint256 _amount) external returns (bool success);
143     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success);
144     function balanceOf(address _owner) external view returns (uint256 balance);
145     function approve(address _spender, uint256 _amount) external returns (bool success);
146     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
147         external returns (bool success);
148     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
149     function totalSupply() external view returns (uint);
150 
151     function authenticate(uint _value, uint _challenge, uint _partnerId) external;
152 }
153 
154 interface SnowflakeResolverInterface {
155     function callOnAddition() external view returns (bool);
156     function callOnRemoval() external view returns (bool);
157     function onAddition(uint ein, uint allowance, bytes calldata extraData) external returns (bool);
158     function onRemoval(uint ein, bytes calldata extraData) external returns (bool);
159 }
160 
161 interface SnowflakeViaInterface {
162     function snowflakeCall(address resolver, uint einFrom, uint einTo, uint amount, bytes calldata snowflakeCallBytes)
163         external;
164     function snowflakeCall(
165         address resolver, uint einFrom, address payable to, uint amount, bytes calldata snowflakeCallBytes
166     ) external;
167     function snowflakeCall(address resolver, uint einTo, uint amount, bytes calldata snowflakeCallBytes) external;
168     function snowflakeCall(address resolver, address payable to, uint amount, bytes calldata snowflakeCallBytes)
169         external;
170 }
171 
172 interface IdentityRegistryInterface {
173     function isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
174         external pure returns (bool);
175 
176     // Identity View Functions /////////////////////////////////////////////////////////////////////////////////////////
177     function identityExists(uint ein) external view returns (bool);
178     function hasIdentity(address _address) external view returns (bool);
179     function getEIN(address _address) external view returns (uint ein);
180     function isAssociatedAddressFor(uint ein, address _address) external view returns (bool);
181     function isProviderFor(uint ein, address provider) external view returns (bool);
182     function isResolverFor(uint ein, address resolver) external view returns (bool);
183     function getIdentity(uint ein) external view returns (
184         address recoveryAddress,
185         address[] memory associatedAddresses, address[] memory providers, address[] memory resolvers
186     );
187 
188     // Identity Management Functions ///////////////////////////////////////////////////////////////////////////////////
189     function createIdentity(address recoveryAddress, address[] calldata providers, address[] calldata resolvers)
190         external returns (uint ein);
191     function createIdentityDelegated(
192         address recoveryAddress, address associatedAddress, address[] calldata providers, address[] calldata resolvers,
193         uint8 v, bytes32 r, bytes32 s, uint timestamp
194     ) external returns (uint ein);
195     function addAssociatedAddress(
196         address approvingAddress, address addressToAdd, uint8 v, bytes32 r, bytes32 s, uint timestamp
197     ) external;
198     function addAssociatedAddressDelegated(
199         address approvingAddress, address addressToAdd,
200         uint8[2] calldata v, bytes32[2] calldata r, bytes32[2] calldata s, uint[2] calldata timestamp
201     ) external;
202     function removeAssociatedAddress() external;
203     function removeAssociatedAddressDelegated(address addressToRemove, uint8 v, bytes32 r, bytes32 s, uint timestamp)
204         external;
205     function addProviders(address[] calldata providers) external;
206     function addProvidersFor(uint ein, address[] calldata providers) external;
207     function removeProviders(address[] calldata providers) external;
208     function removeProvidersFor(uint ein, address[] calldata providers) external;
209     function addResolvers(address[] calldata resolvers) external;
210     function addResolversFor(uint ein, address[] calldata resolvers) external;
211     function removeResolvers(address[] calldata resolvers) external;
212     function removeResolversFor(uint ein, address[] calldata resolvers) external;
213 
214     // Recovery Management Functions ///////////////////////////////////////////////////////////////////////////////////
215     function triggerRecoveryAddressChange(address newRecoveryAddress) external;
216     function triggerRecoveryAddressChangeFor(uint ein, address newRecoveryAddress) external;
217     function triggerRecovery(uint ein, address newAssociatedAddress, uint8 v, bytes32 r, bytes32 s, uint timestamp)
218         external;
219     function triggerDestruction(
220         uint ein, address[] calldata firstChunk, address[] calldata lastChunk, bool resetResolvers
221     ) external;
222 }
223 
224 interface ClientRaindropInterface {
225     function hydroStakeUser() external returns (uint);
226     function hydroStakeDelegatedUser() external returns (uint);
227 
228     function setSnowflakeAddress(address _snowflakeAddress) external;
229     function setStakes(uint _hydroStakeUser, uint _hydroStakeDelegatedUser) external;
230 
231     function signUp(address _address, string calldata casedHydroId) external;
232 
233     function hydroIDAvailable(string calldata uncasedHydroID) external view returns (bool available);
234     function hydroIDDestroyed(string calldata uncasedHydroID) external view returns (bool destroyed);
235     function hydroIDActive(string calldata uncasedHydroID) external view returns (bool active);
236 
237     function getDetails(string calldata uncasedHydroID) external view
238         returns (uint ein, address _address, string memory casedHydroID);
239     function getDetails(uint ein) external view returns (address _address, string memory casedHydroID);
240     function getDetails(address _address) external view returns (uint ein, string memory casedHydroID);
241 }
242 
243 contract Snowflake is Ownable {
244     using SafeMath for uint;
245 
246     // mapping of EIN to hydro token deposits
247     mapping (uint => uint) public deposits;
248     // mapping from EIN to resolver to allowance
249     mapping (uint => mapping (address => uint)) public resolverAllowances;
250 
251     // SC variables
252     address public identityRegistryAddress;
253     IdentityRegistryInterface private identityRegistry;
254     address public hydroTokenAddress;
255     HydroInterface private hydroToken;
256     address public clientRaindropAddress;
257     ClientRaindropInterface private clientRaindrop;
258 
259     // signature variables
260     uint public signatureTimeout = 1 days;
261     mapping (uint => uint) public signatureNonce;
262 
263     constructor (address _identityRegistryAddress, address _hydroTokenAddress) public {
264         setAddresses(_identityRegistryAddress, _hydroTokenAddress);
265     }
266 
267     // enforces that a particular EIN exists
268     modifier identityExists(uint ein, bool check) {
269         require(identityRegistry.identityExists(ein) == check, "The EIN does not exist.");
270         _;
271     }
272 
273     // enforces signature timeouts
274     modifier ensureSignatureTimeValid(uint timestamp) {
275         require(
276             // solium-disable-next-line security/no-block-members
277             block.timestamp >= timestamp && block.timestamp < timestamp + signatureTimeout, "Timestamp is not valid."
278         );
279         _;
280     }
281 
282 
283     // set the hydro token and identity registry addresses
284     function setAddresses(address _identityRegistryAddress, address _hydroTokenAddress) public onlyOwner {
285         identityRegistryAddress = _identityRegistryAddress;
286         identityRegistry = IdentityRegistryInterface(identityRegistryAddress);
287 
288         hydroTokenAddress = _hydroTokenAddress;
289         hydroToken = HydroInterface(hydroTokenAddress);
290     }
291 
292     function setClientRaindropAddress(address _clientRaindropAddress) public onlyOwner {
293         clientRaindropAddress = _clientRaindropAddress;
294         clientRaindrop = ClientRaindropInterface(clientRaindropAddress);
295     }
296 
297     // wrap createIdentityDelegated and initialize the client raindrop resolver
298     function createIdentityDelegated(
299         address recoveryAddress, address associatedAddress, address[] memory providers, string memory casedHydroId,
300         uint8 v, bytes32 r, bytes32 s, uint timestamp
301     )
302         public returns (uint ein)
303     {
304         address[] memory _providers = new address[](providers.length + 1);
305         _providers[0] = address(this);
306         for (uint i; i < providers.length; i++) {
307             _providers[i + 1] = providers[i];
308         }
309 
310         uint _ein = identityRegistry.createIdentityDelegated(
311             recoveryAddress, associatedAddress, _providers, new address[](0), v, r, s, timestamp
312         );
313 
314         _addResolver(_ein, clientRaindropAddress, true, 0, abi.encode(associatedAddress, casedHydroId));
315 
316         return _ein;
317     }
318 
319     // permission addProvidersFor by signature
320     function addProvidersFor(
321         address approvingAddress, address[] memory providers, uint8 v, bytes32 r, bytes32 s, uint timestamp
322     )
323         public ensureSignatureTimeValid(timestamp)
324     {
325         uint ein = identityRegistry.getEIN(approvingAddress);
326         require(
327             identityRegistry.isSigned(
328                 approvingAddress,
329                 keccak256(
330                     abi.encodePacked(
331                         byte(0x19), byte(0), address(this),
332                         "I authorize that these Providers be added to my Identity.",
333                         ein, providers, timestamp
334                     )
335                 ),
336                 v, r, s
337             ),
338             "Permission denied."
339         );
340 
341         identityRegistry.addProvidersFor(ein, providers);
342     }
343 
344     // permission removeProvidersFor by signature
345     function removeProvidersFor(
346         address approvingAddress, address[] memory providers, uint8 v, bytes32 r, bytes32 s, uint timestamp
347     )
348         public ensureSignatureTimeValid(timestamp)
349     {
350         uint ein = identityRegistry.getEIN(approvingAddress);
351         require(
352             identityRegistry.isSigned(
353                 approvingAddress,
354                 keccak256(
355                     abi.encodePacked(
356                         byte(0x19), byte(0), address(this),
357                         "I authorize that these Providers be removed from my Identity.",
358                         ein, providers, timestamp
359                     )
360                 ),
361                 v, r, s
362             ),
363             "Permission denied."
364         );
365 
366         identityRegistry.removeProvidersFor(ein, providers);
367     }
368 
369     // permissioned addProvidersFor and removeProvidersFor by signature
370     function upgradeProvidersFor(
371         address approvingAddress, address[] memory newProviders, address[] memory oldProviders,
372         uint8[2] memory v, bytes32[2] memory r, bytes32[2] memory s, uint[2] memory timestamp
373     )
374         public
375     {
376         addProvidersFor(approvingAddress, newProviders, v[0], r[0], s[0], timestamp[0]);
377         removeProvidersFor(approvingAddress, oldProviders, v[1], r[1], s[1], timestamp[1]);
378         uint ein = identityRegistry.getEIN(approvingAddress);
379         emit SnowflakeProvidersUpgraded(ein, newProviders, oldProviders, approvingAddress);
380     }
381 
382     // permission adding a resolver for identity of msg.sender
383     function addResolver(address resolver, bool isSnowflake, uint withdrawAllowance, bytes memory extraData) public {
384         _addResolver(identityRegistry.getEIN(msg.sender), resolver, isSnowflake, withdrawAllowance, extraData);
385     }
386 
387     // permission adding a resolver for identity passed by a provider
388     function addResolverAsProvider(
389         uint ein, address resolver, bool isSnowflake, uint withdrawAllowance, bytes memory extraData
390     )
391         public
392     {
393         require(identityRegistry.isProviderFor(ein, msg.sender), "The msg.sender is not a Provider for the passed EIN");
394         _addResolver(ein, resolver, isSnowflake, withdrawAllowance, extraData);
395     }
396 
397     // permission addResolversFor by signature
398     function addResolverFor(
399         address approvingAddress, address resolver, bool isSnowflake, uint withdrawAllowance, bytes memory extraData,
400         uint8 v, bytes32 r, bytes32 s, uint timestamp
401     )
402         public
403     {
404         uint ein = identityRegistry.getEIN(approvingAddress);
405 
406         validateAddResolverForSignature(
407             approvingAddress, ein, resolver, isSnowflake, withdrawAllowance, extraData, v, r, s, timestamp
408         );
409 
410         _addResolver(ein, resolver, isSnowflake, withdrawAllowance, extraData);
411     }
412 
413     function validateAddResolverForSignature(
414         address approvingAddress, uint ein,
415         address resolver, bool isSnowflake, uint withdrawAllowance, bytes memory extraData,
416         uint8 v, bytes32 r, bytes32 s, uint timestamp
417     )
418         private view ensureSignatureTimeValid(timestamp)
419     {
420         require(
421             identityRegistry.isSigned(
422                 approvingAddress,
423                 keccak256(
424                     abi.encodePacked(
425                         byte(0x19), byte(0), address(this),
426                         "I authorize that this resolver be added to my Identity.",
427                         ein, resolver, isSnowflake, withdrawAllowance, extraData, timestamp
428                     )
429                 ),
430                 v, r, s
431             ),
432             "Permission denied."
433         );
434     }
435 
436     // common logic for adding resolvers
437     function _addResolver(uint ein, address resolver, bool isSnowflake, uint withdrawAllowance, bytes memory extraData)
438         private
439     {
440         require(!identityRegistry.isResolverFor(ein, resolver), "Identity has already set this resolver.");
441 
442         address[] memory resolvers = new address[](1);
443         resolvers[0] = resolver;
444         identityRegistry.addResolversFor(ein, resolvers);
445 
446         if (isSnowflake) {
447             resolverAllowances[ein][resolver] = withdrawAllowance;
448             SnowflakeResolverInterface snowflakeResolver = SnowflakeResolverInterface(resolver);
449             if (snowflakeResolver.callOnAddition())
450                 require(snowflakeResolver.onAddition(ein, withdrawAllowance, extraData), "Sign up failure.");
451             emit SnowflakeResolverAdded(ein, resolver, withdrawAllowance);
452         }
453     }
454 
455     // permission changing resolver allowances for identity of msg.sender
456     function changeResolverAllowances(address[] memory resolvers, uint[] memory withdrawAllowances) public {
457         changeResolverAllowances(identityRegistry.getEIN(msg.sender), resolvers, withdrawAllowances);
458     }
459 
460     // change resolver allowances delegated
461     function changeResolverAllowancesDelegated(
462         address approvingAddress, address[] memory resolvers, uint[] memory withdrawAllowances,
463         uint8 v, bytes32 r, bytes32 s
464     )
465         public
466     {
467         uint ein = identityRegistry.getEIN(approvingAddress);
468 
469         uint nonce = signatureNonce[ein]++;
470         require(
471             identityRegistry.isSigned(
472                 approvingAddress,
473                 keccak256(
474                     abi.encodePacked(
475                         byte(0x19), byte(0), address(this),
476                         "I authorize this change in Resolver allowances.",
477                         ein, resolvers, withdrawAllowances, nonce
478                     )
479                 ),
480                 v, r, s
481             ),
482             "Permission denied."
483         );
484 
485         changeResolverAllowances(ein, resolvers, withdrawAllowances);
486     }
487 
488     // common logic to change resolver allowances
489     function changeResolverAllowances(uint ein, address[] memory resolvers, uint[] memory withdrawAllowances) private {
490         require(resolvers.length == withdrawAllowances.length, "Malformed inputs.");
491 
492         for (uint i; i < resolvers.length; i++) {
493             require(identityRegistry.isResolverFor(ein, resolvers[i]), "Identity has not set this resolver.");
494             resolverAllowances[ein][resolvers[i]] = withdrawAllowances[i];
495             emit SnowflakeResolverAllowanceChanged(ein, resolvers[i], withdrawAllowances[i]);
496         }
497     }
498 
499     // permission removing a resolver for identity of msg.sender
500     function removeResolver(address resolver, bool isSnowflake, bytes memory extraData) public {
501         removeResolver(identityRegistry.getEIN(msg.sender), resolver, isSnowflake, extraData);
502     }
503 
504     // permission removeResolverFor by signature
505     function removeResolverFor(
506         address approvingAddress, address resolver, bool isSnowflake, bytes memory extraData,
507         uint8 v, bytes32 r, bytes32 s, uint timestamp
508     )
509         public ensureSignatureTimeValid(timestamp)
510     {
511         uint ein = identityRegistry.getEIN(approvingAddress);
512 
513         validateRemoveResolverForSignature(approvingAddress, ein, resolver, isSnowflake, extraData, v, r, s, timestamp);
514 
515         removeResolver(ein, resolver, isSnowflake, extraData);
516     }
517 
518     function validateRemoveResolverForSignature(
519         address approvingAddress, uint ein, address resolver, bool isSnowflake, bytes memory extraData,
520         uint8 v, bytes32 r, bytes32 s, uint timestamp
521     )
522         private view
523     {
524         require(
525             identityRegistry.isSigned(
526                 approvingAddress,
527                 keccak256(
528                     abi.encodePacked(
529                         byte(0x19), byte(0), address(this),
530                         "I authorize that these Resolvers be removed from my Identity.",
531                         ein, resolver, isSnowflake, extraData, timestamp
532                     )
533                 ),
534                 v, r, s
535             ),
536             "Permission denied."
537         );
538     }
539 
540     // common logic to remove resolvers
541     function removeResolver(uint ein, address resolver, bool isSnowflake, bytes memory extraData) private {
542         require(identityRegistry.isResolverFor(ein, resolver), "Identity has not yet set this resolver.");
543     
544         delete resolverAllowances[ein][resolver];
545     
546         if (isSnowflake) {
547             SnowflakeResolverInterface snowflakeResolver = SnowflakeResolverInterface(resolver);
548             if (snowflakeResolver.callOnRemoval())
549                 require(snowflakeResolver.onRemoval(ein, extraData), "Removal failure.");
550             emit SnowflakeResolverRemoved(ein, resolver);
551         }
552 
553         address[] memory resolvers = new address[](1);
554         resolvers[0] = resolver;
555         identityRegistry.removeResolversFor(ein, resolvers);
556     }
557 
558     function triggerRecoveryAddressChangeFor(
559         address approvingAddress, address newRecoveryAddress, uint8 v, bytes32 r, bytes32 s
560     )
561         public
562     {
563         uint ein = identityRegistry.getEIN(approvingAddress);
564         uint nonce = signatureNonce[ein]++;
565         require(
566             identityRegistry.isSigned(
567                 approvingAddress,
568                 keccak256(
569                     abi.encodePacked(
570                         byte(0x19), byte(0), address(this),
571                         "I authorize this change of Recovery Address.",
572                         ein, newRecoveryAddress, nonce
573                     )
574                 ),
575                 v, r, s
576             ),
577             "Permission denied."
578         );
579 
580         identityRegistry.triggerRecoveryAddressChangeFor(ein, newRecoveryAddress);
581     }
582 
583     // allow contract to receive HYDRO tokens
584     function receiveApproval(address sender, uint amount, address _tokenAddress, bytes memory _bytes) public {
585         require(msg.sender == _tokenAddress, "Malformed inputs.");
586         require(_tokenAddress == hydroTokenAddress, "Sender is not the HYDRO token smart contract.");
587 
588         // depositing to an EIN
589         if (_bytes.length <= 32) {
590             require(hydroToken.transferFrom(sender, address(this), amount), "Unable to transfer token ownership.");
591             uint recipient;
592             if (_bytes.length < 32) {
593                 recipient = identityRegistry.getEIN(sender);
594             }
595             else {
596                 recipient = abi.decode(_bytes, (uint));
597                 require(identityRegistry.identityExists(recipient), "The recipient EIN does not exist.");
598             }
599             deposits[recipient] = deposits[recipient].add(amount);
600             emit SnowflakeDeposit(sender, recipient, amount);
601         }
602         // transferring to a via
603         else {
604             (
605                 bool isTransfer, address resolver, address via, uint to, bytes memory snowflakeCallBytes
606             ) = abi.decode(_bytes, (bool, address, address, uint, bytes));
607             
608             require(hydroToken.transferFrom(sender, via, amount), "Unable to transfer token ownership.");
609 
610             SnowflakeViaInterface viaContract = SnowflakeViaInterface(via);
611             if (isTransfer) {
612                 viaContract.snowflakeCall(resolver, to, amount, snowflakeCallBytes);
613                 emit SnowflakeTransferToVia(resolver, via, to, amount);
614             } else {
615                 address payable payableTo = address(to);
616                 viaContract.snowflakeCall(resolver, payableTo, amount, snowflakeCallBytes);
617                 emit SnowflakeWithdrawToVia(resolver, via, address(to), amount);
618             }
619         }
620     }
621 
622     // transfer snowflake balance from one snowflake holder to another
623     function transferSnowflakeBalance(uint einTo, uint amount) public {
624         _transfer(identityRegistry.getEIN(msg.sender), einTo, amount);
625     }
626 
627     // withdraw Snowflake balance to an external address
628     function withdrawSnowflakeBalance(address to, uint amount) public {
629         _withdraw(identityRegistry.getEIN(msg.sender), to, amount);
630     }
631 
632     // allows resolvers to transfer allowance amounts to other snowflakes (throws if unsuccessful)
633     function transferSnowflakeBalanceFrom(uint einFrom, uint einTo, uint amount) public {
634         handleAllowance(einFrom, amount);
635         _transfer(einFrom, einTo, amount);
636         emit SnowflakeTransferFrom(msg.sender);
637     }
638 
639     // allows resolvers to withdraw allowance amounts to external addresses (throws if unsuccessful)
640     function withdrawSnowflakeBalanceFrom(uint einFrom, address to, uint amount) public {
641         handleAllowance(einFrom, amount);
642         _withdraw(einFrom, to, amount);
643         emit SnowflakeWithdrawFrom(msg.sender);
644     }
645 
646     // allows resolvers to send withdrawal amounts to arbitrary smart contracts 'to' identities (throws if unsuccessful)
647     function transferSnowflakeBalanceFromVia(uint einFrom, address via, uint einTo, uint amount, bytes memory _bytes)
648         public
649     {
650         handleAllowance(einFrom, amount);
651         _withdraw(einFrom, via, amount);
652         SnowflakeViaInterface viaContract = SnowflakeViaInterface(via);
653         viaContract.snowflakeCall(msg.sender, einFrom, einTo, amount, _bytes);
654         emit SnowflakeTransferFromVia(msg.sender, einTo);
655     }
656 
657     // allows resolvers to send withdrawal amounts 'to' addresses via arbitrary smart contracts
658     function withdrawSnowflakeBalanceFromVia(
659         uint einFrom, address via, address payable to, uint amount, bytes memory _bytes
660     )
661         public
662     {
663         handleAllowance(einFrom, amount);
664         _withdraw(einFrom, via, amount);
665         SnowflakeViaInterface viaContract = SnowflakeViaInterface(via);
666         viaContract.snowflakeCall(msg.sender, einFrom, to, amount, _bytes);
667         emit SnowflakeWithdrawFromVia(msg.sender, to);
668     }
669 
670     function _transfer(uint einFrom, uint einTo, uint amount) private identityExists(einTo, true) returns (bool) {
671         require(deposits[einFrom] >= amount, "Cannot withdraw more than the current deposit balance.");
672         deposits[einFrom] = deposits[einFrom].sub(amount);
673         deposits[einTo] = deposits[einTo].add(amount);
674 
675         emit SnowflakeTransfer(einFrom, einTo, amount);
676     }
677 
678     function _withdraw(uint einFrom, address to, uint amount) internal {
679         require(to != address(this), "Cannot transfer to the Snowflake smart contract itself.");
680 
681         require(deposits[einFrom] >= amount, "Cannot withdraw more than the current deposit balance.");
682         deposits[einFrom] = deposits[einFrom].sub(amount);
683         require(hydroToken.transfer(to, amount), "Transfer was unsuccessful");
684 
685         emit SnowflakeWithdraw(einFrom, to, amount);
686     }
687 
688     function handleAllowance(uint einFrom, uint amount) internal {
689         // check that resolver-related details are correct
690         require(identityRegistry.isResolverFor(einFrom, msg.sender), "Resolver has not been set by from tokenholder.");
691 
692         if (resolverAllowances[einFrom][msg.sender] < amount) {
693             emit SnowflakeInsufficientAllowance(einFrom, msg.sender, resolverAllowances[einFrom][msg.sender], amount);
694             revert("Insufficient Allowance");
695         }
696 
697         resolverAllowances[einFrom][msg.sender] = resolverAllowances[einFrom][msg.sender].sub(amount);
698     }
699 
700     // allowAndCall from msg.sender
701     function allowAndCall(address destination, uint amount, bytes memory data)
702         public returns (bytes memory returnData)
703     {
704         return allowAndCall(identityRegistry.getEIN(msg.sender), amount, destination, data);
705     }
706 
707     // allowAndCall from approvingAddress with meta-transaction
708     function allowAndCallDelegated(
709         address destination, uint amount, bytes memory data, address approvingAddress, uint8 v, bytes32 r, bytes32 s
710     )
711         public returns (bytes memory returnData)
712     {
713         uint ein = identityRegistry.getEIN(approvingAddress);
714         uint nonce = signatureNonce[ein]++;
715         validateAllowAndCallDelegatedSignature(approvingAddress, ein, destination, amount, data, nonce, v, r, s);
716 
717         return allowAndCall(ein, amount, destination, data);
718     }
719 
720     function validateAllowAndCallDelegatedSignature(
721         address approvingAddress, uint ein, address destination, uint amount, bytes memory data, uint nonce,
722         uint8 v, bytes32 r, bytes32 s
723     )
724         private view
725     {
726         require(
727             identityRegistry.isSigned(
728                 approvingAddress,
729                 keccak256(
730                     abi.encodePacked(
731                         byte(0x19), byte(0), address(this),
732                         "I authorize this allow and call.", ein, destination, amount, data, nonce
733                     )
734                 ),
735                 v, r, s
736             ),
737             "Permission denied."
738         );
739     }
740 
741     // internal logic for allowAndCall
742     function allowAndCall(uint ein, uint amount, address destination, bytes memory data)
743         private returns (bytes memory returnData)
744     {
745         // check that resolver-related details are correct
746         require(identityRegistry.isResolverFor(ein, destination), "Destination has not been set by from tokenholder.");
747         if (amount != 0) {
748             resolverAllowances[ein][destination] = resolverAllowances[ein][destination].add(amount);
749         }
750 
751         // solium-disable-next-line security/no-low-level-calls
752         (bool success, bytes memory _returnData) = destination.call(data);
753         require(success, "Call was not successful.");
754         return _returnData;
755     }
756 
757     // events
758     event SnowflakeProvidersUpgraded(uint indexed ein, address[] newProviders, address[] oldProviders, address approvingAddress);
759 
760     event SnowflakeResolverAdded(uint indexed ein, address indexed resolver, uint withdrawAllowance);
761     event SnowflakeResolverAllowanceChanged(uint indexed ein, address indexed resolver, uint withdrawAllowance);
762     event SnowflakeResolverRemoved(uint indexed ein, address indexed resolver);
763 
764     event SnowflakeDeposit(address indexed from, uint indexed einTo, uint amount);
765     event SnowflakeTransfer(uint indexed einFrom, uint indexed einTo, uint amount);
766     event SnowflakeWithdraw(uint indexed einFrom, address indexed to, uint amount);
767 
768     event SnowflakeTransferFrom(address indexed resolverFrom);
769     event SnowflakeWithdrawFrom(address indexed resolverFrom);
770     event SnowflakeTransferFromVia(address indexed resolverFrom, uint indexed einTo);
771     event SnowflakeWithdrawFromVia(address indexed resolverFrom, address indexed to);
772     event SnowflakeTransferToVia(address indexed resolverFrom, address indexed via, uint indexed einTo, uint amount);
773     event SnowflakeWithdrawToVia(address indexed resolverFrom, address indexed via, address indexed to, uint amount);
774 
775     event SnowflakeInsufficientAllowance(
776         uint indexed ein, address indexed resolver, uint currentAllowance, uint requestedWithdraw
777     );
778 }