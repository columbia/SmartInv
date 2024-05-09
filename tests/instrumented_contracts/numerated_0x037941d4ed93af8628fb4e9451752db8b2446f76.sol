1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title Ownable
5 * @dev The Ownable contract has an owner address, and provides basic authorization control
6 * functions, this simplifies the implementation of "user permissions".
7 */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24     * @dev Throws if called by any account other than the owner.
25     */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 /**
44 * @title SafeMath
45 * @dev Math operations with safety checks that throw on error
46 */
47 library SafeMath {
48 
49     /**
50     * @dev Multiplies two numbers, throws on overflow.
51     */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53         if (a == 0) {
54             return 0;
55         }
56         c = a * b;
57         assert(c / a == b);
58         return c;
59     }
60     
61     /**
62     * @dev Integer division of two numbers, truncating the quotient.
63     */
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         // assert(b > 0); // Solidity automatically throws when dividing by 0
66         // uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68         return a / b;
69     }
70 
71     /**
72     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73     */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         assert(b <= a);
76         return a - b;
77     }
78 
79     /**
80     * @dev Adds two numbers, throws on overflow.
81     */
82     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
83         c = a + b;
84         assert(c >= a);
85         return c;
86     }
87 }
88 
89 library addressSet {
90     struct _addressSet {
91         address[] members;
92         mapping(address => uint) memberIndices;
93     }
94 
95     function insert(_addressSet storage self, address other) public {
96         if (!contains(self, other)) {
97             assert(length(self) < 2**256-1);
98             self.members.push(other);
99             self.memberIndices[other] = length(self);
100         }
101     }
102 
103     function remove(_addressSet storage self, address other) public {
104         if (contains(self, other)) {
105             uint replaceIndex = self.memberIndices[other];
106             address lastMember = self.members[length(self)-1];
107             // overwrite other with the last member and remove last member
108             self.members[replaceIndex-1] = lastMember;
109             self.members.length--;
110             // reflect this change in the indices
111             self.memberIndices[lastMember] = replaceIndex;
112             delete self.memberIndices[other];
113         }
114     }
115 
116     function contains(_addressSet storage self, address other) public view returns (bool) {
117         return self.memberIndices[other] > 0;
118     }
119 
120     function length(_addressSet storage self) public view returns (uint) {
121         return self.members.length;
122     }
123 }
124 
125 interface ERC20 {
126     function transfer(address to, uint256 value) external returns (bool);
127     function transferFrom(address from, address to, uint256 value) external returns (bool);
128 }
129 
130 interface SnowflakeResolver {
131     function callOnSignUp() external returns (bool);
132     function onSignUp(string hydroId, uint allowance) external returns (bool);
133     function callOnRemoval() external returns (bool);
134     function onRemoval(string hydroId) external returns(bool);
135 }
136 
137 interface ClientRaindrop {
138     function getUserByAddress(address _address) external view returns (string userName);
139     function isSigned(
140         address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s
141     ) external pure returns (bool);
142 }
143 
144 interface ViaContract {
145     function snowflakeCall(address resolver, string hydroIdFrom, string hydroIdTo, uint amount, bytes _bytes) external;
146     function snowflakeCall(address resolver, string hydroIdFrom, address to, uint amount, bytes _bytes) external;
147 }
148 
149 contract Snowflake is Ownable {
150     using SafeMath for uint;
151     using addressSet for addressSet._addressSet;
152 
153     // hydro token wrapper variable
154     mapping (string => uint) internal deposits;
155 
156     // signature variables
157     uint signatureTimeout;
158     mapping (bytes32 => bool) signatureLog;
159 
160     // lookup mappings -- accessible only by wrapper functions
161     mapping (string => Identity) internal directory;
162     mapping (address => string) internal addressDirectory;
163     mapping (bytes32 => string) internal initiatedAddressClaims;
164 
165     // admin/contract variables
166     address public clientRaindropAddress;
167     address public hydroTokenAddress;
168 
169     addressSet._addressSet resolverWhitelist;
170 
171     constructor() public {
172         setSignatureTimeout(7200);
173     }
174 
175     // identity structures
176     struct Identity {
177         address owner;
178         addressSet._addressSet addresses;
179         addressSet._addressSet resolvers;
180         mapping(address => uint) resolverAllowances;
181     }
182 
183     // checks whether the given address is owned by a token (does not throw)
184     function hasToken(address _address) public view returns (bool) {
185         return bytes(addressDirectory[_address]).length != 0;
186     }
187 
188     // enforces that a particular address has a token
189     modifier _hasToken(address _address, bool check) {
190         require(hasToken(_address) == check, "The transaction sender does not have a Snowflake.");
191         _;
192     }
193 
194     // gets the HydroID for an address (throws if address doesn't have a HydroID or doesn't have a snowflake)
195     function getHydroId(address _address) public view returns (string hydroId) {
196         require(hasToken(_address), "The address does not have a hydroId");
197         return addressDirectory[_address];
198     }
199 
200     // allows whitelisting of resolvers
201     function whitelistResolver(address resolver) public {
202         resolverWhitelist.insert(resolver);
203         emit ResolverWhitelisted(resolver);
204     }
205 
206     function isWhitelisted(address resolver) public view returns(bool) {
207         return resolverWhitelist.contains(resolver);
208     }
209 
210     function getWhitelistedResolvers() public view returns(address[]) {
211         return resolverWhitelist.members;
212     }
213 
214     // set the signature timeout
215     function setSignatureTimeout(uint newTimeout) public {
216         require(newTimeout >= 1800, "Timeout must be at least 30 minutes.");
217         require(newTimeout <= 604800, "Timeout must be less than a week.");
218         signatureTimeout = newTimeout;
219     }
220 
221     // set the raindrop and hydro token addresses
222     function setAddresses(address clientRaindrop, address hydroToken) public onlyOwner {
223         clientRaindropAddress = clientRaindrop;
224         hydroTokenAddress = hydroToken;
225     }
226 
227     // token minting
228     function mintIdentityToken() public _hasToken(msg.sender, false) {
229         _mintIdentityToken(msg.sender);
230     }
231 
232     function mintIdentityTokenDelegated(address _address, uint8 v, bytes32 r, bytes32 s)
233         public _hasToken(_address, false)
234     {
235         ClientRaindrop clientRaindrop = ClientRaindrop(clientRaindropAddress);
236         require(
237             clientRaindrop.isSigned(
238                 _address, keccak256(abi.encodePacked("Create Snowflake", _address)), v, r, s
239             ),
240             "Permission denied."
241         );
242         _mintIdentityToken(_address);
243     }
244 
245     function _mintIdentityToken(address _address) internal {
246         ClientRaindrop clientRaindrop = ClientRaindrop(clientRaindropAddress);
247         string memory hydroId = clientRaindrop.getUserByAddress(_address);
248 
249         Identity storage identity = directory[hydroId];
250 
251         identity.owner = _address;
252         identity.addresses.insert(_address);
253 
254         addressDirectory[_address] = hydroId;
255 
256         emit SnowflakeMinted(hydroId);
257     }
258 
259     // wrappers that enable modifying resolvers
260     function addResolvers(address[] resolvers, uint[] withdrawAllowances) public _hasToken(msg.sender, true) {
261         _addResolvers(addressDirectory[msg.sender], resolvers, withdrawAllowances);
262     }
263 
264     function addResolversDelegated(
265         string hydroId, address[] resolvers, uint[] withdrawAllowances, uint8 v, bytes32 r, bytes32 s, uint timestamp
266     ) public
267     {
268         require(directory[hydroId].owner != address(0), "Must initiate claim for a HydroID with a Snowflake");
269         // solium-disable-next-line security/no-block-members
270         require(timestamp.add(signatureTimeout) > block.timestamp, "Message was signed too long ago.");
271     
272         ClientRaindrop clientRaindrop = ClientRaindrop(clientRaindropAddress);
273         require(
274             clientRaindrop.isSigned(
275                 directory[hydroId].owner,
276                 keccak256(abi.encodePacked("Add Resolvers", resolvers, withdrawAllowances, timestamp)),
277                 v, r, s
278             ),
279             "Permission denied."
280         );
281 
282         _addResolvers(hydroId, resolvers, withdrawAllowances);
283     }
284 
285     function _addResolvers(
286         string hydroId, address[] resolvers, uint[] withdrawAllowances
287     ) internal {
288         require(resolvers.length == withdrawAllowances.length, "Malformed inputs.");
289         Identity storage identity = directory[hydroId];
290 
291         for (uint i; i < resolvers.length; i++) {
292             require(resolverWhitelist.contains(resolvers[i]), "The given resolver is not on the whitelist.");
293             require(!identity.resolvers.contains(resolvers[i]), "Snowflake has already set this resolver.");
294             SnowflakeResolver snowflakeResolver = SnowflakeResolver(resolvers[i]);
295             identity.resolvers.insert(resolvers[i]);
296             identity.resolverAllowances[resolvers[i]] = withdrawAllowances[i];
297             if (snowflakeResolver.callOnSignUp()) {
298                 require(
299                     snowflakeResolver.onSignUp(hydroId, withdrawAllowances[i]),
300                     "Sign up failure."
301                 );
302             }
303             emit ResolverAdded(hydroId, resolvers[i], withdrawAllowances[i]);
304         }
305     }
306 
307     function changeResolverAllowances(address[] resolvers, uint[] withdrawAllowances) 
308         public _hasToken(msg.sender, true)
309     {
310         _changeResolverAllowances(addressDirectory[msg.sender], resolvers, withdrawAllowances);
311     }
312 
313     function changeResolverAllowancesDelegated(
314         string hydroId, address[] resolvers, uint[] withdrawAllowances, uint8 v, bytes32 r, bytes32 s, uint timestamp
315     ) public
316     {
317         require(directory[hydroId].owner != address(0), "Must initiate claim for a HydroID with a Snowflake");
318 
319         bytes32 _hash = keccak256(
320             abi.encodePacked("Change Resolver Allowances", resolvers, withdrawAllowances, timestamp)
321         );
322 
323         require(signatureLog[_hash] == false, "Signature was already submitted");
324         signatureLog[_hash] = true;
325 
326         ClientRaindrop clientRaindrop = ClientRaindrop(clientRaindropAddress);
327         require(clientRaindrop.isSigned(directory[hydroId].owner, _hash, v, r, s), "Permission denied.");
328 
329         _changeResolverAllowances(hydroId, resolvers, withdrawAllowances);
330     }
331 
332     function _changeResolverAllowances(string hydroId, address[] resolvers, uint[] withdrawAllowances) internal {
333         require(resolvers.length == withdrawAllowances.length, "Malformed inputs.");
334 
335         Identity storage identity = directory[hydroId];
336 
337         for (uint i; i < resolvers.length; i++) {
338             require(identity.resolvers.contains(resolvers[i]), "Snowflake has not set this resolver.");
339             identity.resolverAllowances[resolvers[i]] = withdrawAllowances[i];
340             emit ResolverAllowanceChanged(hydroId, resolvers[i], withdrawAllowances[i]);
341         }
342     }
343 
344     function removeResolvers(address[] resolvers, bool force) public _hasToken(msg.sender, true) {
345         Identity storage identity = directory[addressDirectory[msg.sender]];
346 
347         for (uint i; i < resolvers.length; i++) {
348             require(identity.resolvers.contains(resolvers[i]), "Snowflake has not set this resolver.");
349             identity.resolvers.remove(resolvers[i]);
350             delete identity.resolverAllowances[resolvers[i]];
351             if (!force) {
352                 SnowflakeResolver snowflakeResolver = SnowflakeResolver(resolvers[i]);
353                 if (snowflakeResolver.callOnRemoval()) {
354                     require(
355                         snowflakeResolver.onRemoval(addressDirectory[msg.sender]),
356                         "Removal failure."
357                     );
358                 }
359             }
360             emit ResolverRemoved(addressDirectory[msg.sender], resolvers[i]);
361         }
362     }
363 
364     // functions to read token values (does not throw)
365     function getDetails(string hydroId) public view returns (
366         address owner,
367         address[] resolvers,
368         address[] ownedAddresses,
369         uint256 balance
370     ) {
371         Identity storage identity = directory[hydroId];
372         return (
373             identity.owner,
374             identity.resolvers.members,
375             identity.addresses.members,
376             deposits[hydroId]
377         );
378     }
379 
380     // check resolver membership (does not throw)
381     function hasResolver(string hydroId, address resolver) public view returns (bool) {
382         Identity storage identity = directory[hydroId];
383         return identity.resolvers.contains(resolver);
384     }
385 
386     // check address ownership (does not throw)
387     function ownsAddress(string hydroId, address _address) public view returns (bool) {
388         Identity storage identity = directory[hydroId];
389         return identity.addresses.contains(_address);
390     }
391 
392     // check resolver allowances (does not throw)
393     function getResolverAllowance(string hydroId, address resolver) public view returns (uint withdrawAllowance) {
394         Identity storage identity = directory[hydroId];
395         return identity.resolverAllowances[resolver];
396     }
397  
398     // allow contract to receive HYDRO tokens
399     function receiveApproval(address sender, uint amount, address _tokenAddress, bytes _bytes) public {
400         require(msg.sender == _tokenAddress, "Malformed inputs.");
401         require(_tokenAddress == hydroTokenAddress, "Sender is not the HYDRO token smart contract.");
402 
403         address recipient;
404         if (_bytes.length == 20) {
405             assembly { // solium-disable-line security/no-inline-assembly
406                 recipient := div(mload(add(add(_bytes, 0x20), 0)), 0x1000000000000000000000000)
407             }
408         } else {
409             recipient = sender;
410         }
411         require(hasToken(recipient), "Invalid token recipient");
412 
413         ERC20 hydro = ERC20(_tokenAddress);
414         require(hydro.transferFrom(sender, address(this), amount), "Unable to transfer token ownership.");
415 
416         deposits[addressDirectory[recipient]] = deposits[addressDirectory[recipient]].add(amount);
417 
418         emit SnowflakeDeposit(addressDirectory[recipient], sender, amount);
419     }
420 
421     function snowflakeBalance(string hydroId) public view returns (uint) {
422         return deposits[hydroId];
423     }
424 
425     // transfer snowflake balance from one snowflake holder to another
426     function transferSnowflakeBalance(string hydroIdTo, uint amount) public _hasToken(msg.sender, true) {
427         _transfer(addressDirectory[msg.sender], hydroIdTo, amount);
428     }
429 
430     // withdraw Snowflake balance to an external address
431     function withdrawSnowflakeBalance(address to, uint amount) public _hasToken(msg.sender, true) {
432         _withdraw(addressDirectory[msg.sender], to, amount);
433     }
434 
435     // allows resolvers to transfer allowance amounts to other snowflakes (throws if unsuccessful)
436     function transferSnowflakeBalanceFrom(string hydroIdFrom, string hydroIdTo, uint amount) public {
437         handleAllowance(hydroIdFrom, amount);
438         _transfer(hydroIdFrom, hydroIdTo, amount);
439     }
440 
441     // allows resolvers to withdraw allowance amounts to external addresses (throws if unsuccessful)
442     function withdrawSnowflakeBalanceFrom(string hydroIdFrom, address to, uint amount) public {
443         handleAllowance(hydroIdFrom, amount);
444         _withdraw(hydroIdFrom, to, amount);
445     }
446 
447     // allows resolvers to send withdrawal amounts to arbitrary smart contracts 'to' hydroIds (throws if unsuccessful)
448     function withdrawSnowflakeBalanceFromVia(
449         string hydroIdFrom, address via, string hydroIdTo, uint amount, bytes _bytes
450     ) public {
451         handleAllowance(hydroIdFrom, amount);
452         _withdraw(hydroIdFrom, via, amount);
453         ViaContract viaContract = ViaContract(via);
454         viaContract.snowflakeCall(msg.sender, hydroIdFrom, hydroIdTo, amount, _bytes);
455     }
456 
457     // allows resolvers to send withdrawal amounts 'to' addresses via arbitrary smart contracts 
458     function withdrawSnowflakeBalanceFromVia(
459         string hydroIdFrom, address via, address to, uint amount, bytes _bytes
460     ) public {
461         handleAllowance(hydroIdFrom, amount);
462         _withdraw(hydroIdFrom, via, amount);
463         ViaContract viaContract = ViaContract(via);
464         viaContract.snowflakeCall(msg.sender, hydroIdFrom, to, amount, _bytes);
465     }
466 
467     function _transfer(string hydroIdFrom, string hydroIdTo, uint amount) internal returns (bool) {
468         require(directory[hydroIdTo].owner != address(0), "Must transfer to an HydroID with a Snowflake");
469 
470         require(deposits[hydroIdFrom] >= amount, "Cannot withdraw more than the current deposit balance.");
471         deposits[hydroIdFrom] = deposits[hydroIdFrom].sub(amount);
472         deposits[hydroIdTo] = deposits[hydroIdTo].add(amount);
473 
474         emit SnowflakeTransfer(hydroIdFrom, hydroIdTo, amount);
475     }
476 
477     function _withdraw(string hydroIdFrom, address to, uint amount) internal {
478         require(to != address(this), "Cannot transfer to the Snowflake smart contract itself.");
479 
480         require(deposits[hydroIdFrom] >= amount, "Cannot withdraw more than the current deposit balance.");
481         deposits[hydroIdFrom] = deposits[hydroIdFrom].sub(amount);
482         ERC20 hydro = ERC20(hydroTokenAddress);
483         require(hydro.transfer(to, amount), "Transfer was unsuccessful");
484         emit SnowflakeWithdraw(to, amount);
485     }
486 
487     function handleAllowance(string hydroIdFrom, uint amount) internal {
488         Identity storage identity = directory[hydroIdFrom];
489         require(identity.owner != address(0), "Must withdraw from a HydroID with a Snowflake");
490 
491         // check that resolver-related details are correct
492         require(identity.resolvers.contains(msg.sender), "Resolver has not been set by from tokenholder.");
493         
494         if (identity.resolverAllowances[msg.sender] < amount) {
495             emit InsufficientAllowance(hydroIdFrom, msg.sender, identity.resolverAllowances[msg.sender], amount);
496             require(false, "Insufficient Allowance");
497         }
498 
499         identity.resolverAllowances[msg.sender] = identity.resolverAllowances[msg.sender].sub(amount);
500     }
501 
502     // address ownership functions
503     // to claim an address, users need to send a transaction from their snowflake address containing a sealed claim
504     // sealedClaims are: keccak256(abi.encodePacked(<address>, <secret>, <hydroId>)),
505     // where <address> is the address you'd like to claim, and <secret> is a SECRET bytes32 value.
506     function initiateClaimDelegated(string hydroId, bytes32 sealedClaim, uint8 v, bytes32 r, bytes32 s) public {
507         require(directory[hydroId].owner != address(0), "Must initiate claim for a HydroID with a Snowflake");
508 
509         ClientRaindrop clientRaindrop = ClientRaindrop(clientRaindropAddress);
510         require(
511             clientRaindrop.isSigned(
512                 directory[hydroId].owner, keccak256(abi.encodePacked("Initiate Claim", sealedClaim)), v, r, s
513             ),
514             "Permission denied."
515         );
516 
517         _initiateClaim(hydroId, sealedClaim);
518     }
519 
520     function initiateClaim(bytes32 sealedClaim) public _hasToken(msg.sender, true) {
521         _initiateClaim(addressDirectory[msg.sender], sealedClaim);
522     }
523 
524     function _initiateClaim(string hydroId, bytes32 sealedClaim) internal {
525         require(bytes(initiatedAddressClaims[sealedClaim]).length == 0, "This sealed claim has been submitted.");
526         initiatedAddressClaims[sealedClaim] = hydroId;
527     }
528 
529     function finalizeClaim(bytes32 secret, string hydroId) public {
530         bytes32 possibleSealedClaim = keccak256(abi.encodePacked(msg.sender, secret, hydroId));
531         require(
532             bytes(initiatedAddressClaims[possibleSealedClaim]).length != 0, "This sealed claim hasn't been submitted."
533         );
534 
535         // ensure that the claim wasn't stolen by another HydroID during initialization
536         require(
537             keccak256(abi.encodePacked(initiatedAddressClaims[possibleSealedClaim])) ==
538             keccak256(abi.encodePacked(hydroId)),
539             "Invalid signature."
540         );
541 
542         directory[hydroId].addresses.insert(msg.sender);
543         addressDirectory[msg.sender] = hydroId;
544 
545         emit AddressClaimed(msg.sender, hydroId);
546     }
547 
548     function unclaim(address[] addresses) public _hasToken(msg.sender, true) {
549         for (uint i; i < addresses.length; i++) {
550             require(addresses[i] != directory[addressDirectory[msg.sender]].owner, "Cannot unclaim owner address.");
551             directory[addressDirectory[msg.sender]].addresses.remove(addresses[i]);
552             delete addressDirectory[addresses[i]];
553             emit AddressUnclaimed(addresses[i], addressDirectory[msg.sender]);
554         }
555     }
556 
557     // events
558     event SnowflakeMinted(string hydroId);
559 
560     event ResolverWhitelisted(address indexed resolver);
561 
562     event ResolverAdded(string hydroId, address resolver, uint withdrawAllowance);
563     event ResolverAllowanceChanged(string hydroId, address resolver, uint withdrawAllowance);
564     event ResolverRemoved(string hydroId, address resolver);
565 
566     event SnowflakeDeposit(string hydroId, address from, uint amount);
567     event SnowflakeTransfer(string hydroIdFrom, string hydroIdTo, uint amount);
568     event SnowflakeWithdraw(address to, uint amount);
569     event InsufficientAllowance(
570         string hydroId, address indexed resolver, uint currentAllowance, uint requestedWithdraw
571     );
572 
573     event AddressClaimed(address indexed _address, string hydroId);
574     event AddressUnclaimed(address indexed _address, string hydroId);
575 }