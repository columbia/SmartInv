1 pragma solidity 0.4.24;
2 
3 contract SigningLogicInterface {
4   function recoverSigner(bytes32 _hash, bytes _sig) external pure returns (address);
5   function generateRequestAttestationSchemaHash(
6     address _subject,
7     address _attester,
8     address _requester,
9     bytes32 _dataHash,
10     uint256[] _typeIds,
11     bytes32 _nonce
12     ) external view returns (bytes32);
13   function generateAttestForDelegationSchemaHash(
14     address _subject,
15     address _requester,
16     uint256 _reward,
17     bytes32 _paymentNonce,
18     bytes32 _dataHash,
19     uint256[] _typeIds,
20     bytes32 _requestNonce
21     ) external view returns (bytes32);
22   function generateContestForDelegationSchemaHash(
23     address _requester,
24     uint256 _reward,
25     bytes32 _paymentNonce
26   ) external view returns (bytes32);
27   function generateStakeForDelegationSchemaHash(
28     address _subject,
29     uint256 _value,
30     bytes32 _paymentNonce,
31     bytes32 _dataHash,
32     uint256[] _typeIds,
33     bytes32 _requestNonce,
34     uint256 _stakeDuration
35     ) external view returns (bytes32);
36   function generateRevokeStakeForDelegationSchemaHash(
37     uint256 _subjectId,
38     uint256 _attestationId
39     ) external view returns (bytes32);
40   function generateAddAddressSchemaHash(
41     address _senderAddress,
42     bytes32 _nonce
43     ) external view returns (bytes32);
44   function generateVoteForDelegationSchemaHash(
45     uint16 _choice,
46     address _voter,
47     bytes32 _nonce,
48     address _poll
49     ) external view returns (bytes32);
50   function generateReleaseTokensSchemaHash(
51     address _sender,
52     address _receiver,
53     uint256 _amount,
54     bytes32 _uuid
55     ) external view returns (bytes32);
56   function generateLockupTokensDelegationSchemaHash(
57     address _sender,
58     uint256 _amount,
59     bytes32 _nonce
60     ) external view returns (bytes32);
61 }
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() public {
80     owner = msg.sender;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) public onlyOwner {
96     require(newOwner != address(0));
97     emit OwnershipTransferred(owner, newOwner);
98     owner = newOwner;
99   }
100 
101 }
102 
103 interface AccountRegistryInterface {
104   function accountIdForAddress(address _address) public view returns (uint256);
105   function addressBelongsToAccount(address _address) public view returns (bool);
106   function createNewAccount(address _newUser) external;
107   function addAddressToAccount(
108     address _newAddress,
109     address _sender
110     ) external;
111   function removeAddressFromAccount(address _addressToRemove) external;
112 }
113 /**
114  * @title Bloom account registry
115  * @notice Account Registry Logic provides a public interface for Bloom and users to 
116  * create and control their Bloom Ids.
117  * Users can associate create and accept invites and associate additional addresses with their BloomId.
118  * As the Bloom protocol matures, this contract can be upgraded to enable new capabilities
119  * without needing to migrate the underlying Account Registry storage contract.
120  *
121  * In order to invite someone, a user must generate a new public key private key pair
122  * and sign their own ethereum address. The user provides this signature to the
123  * `createInvite` function where the public key is recovered and the invite is created.
124  * The inviter should then share the one-time-use private key out of band with the recipient.
125  * The recipient accepts the invite by signing their own address and passing that signature
126  * to the `acceptInvite` function. The contract should recover the same public key, demonstrating
127  * that the recipient knows the secret and is likely the person intended to receive the invite.
128  *
129  * @dev This invite model is supposed to aid usability by not requiring the inviting user to know
130  *   the Ethereum address of the recipient. If the one-time-use private key is leaked then anyone
131  *   else can accept the invite. This is an intentional tradeoff of this invite system. A well built
132  *   dApp should generate the private key on the backend and sign the user's address for them. Likewise,
133  *   the signing should also happen on the backend (not visible to the user) for signing an address to
134  *   accept an invite. This reduces the private key exposure so that the dApp can still require traditional
135  *   checks like verifying an associated email address before finally signing the user's Ethereum address.
136  *
137  * @dev The private key generated for this invite system should NEVER be used for an Ethereum address.
138  *   The private key should be used only for the invite flow and then it should effectively be discarded.
139  *
140  * @dev If a user DOES know the address of the person they are inviting then they can still use this
141  *   invite system. All they have to do then is sign the address of the user being invited and share the
142  *   signature with them.
143  */
144 contract AccountRegistryLogic is Ownable{
145 
146   SigningLogicInterface public signingLogic;
147   AccountRegistryInterface public registry;
148   address public registryAdmin;
149 
150   /**
151    * @notice The AccountRegistry constructor configures the signing logic implementation
152    *  and creates an account for the user who deployed the contract.
153    * @dev The owner is also set as the original registryAdmin, who has the privilege to
154    *  create accounts outside of the normal invitation flow.
155    * @param _signingLogic The address of the deployed SigningLogic contract
156    * @param _registry The address of the deployed account registry
157    */
158   constructor(
159     SigningLogicInterface _signingLogic,
160     AccountRegistryInterface _registry
161     ) public {
162     signingLogic = _signingLogic;
163     registry = _registry;
164     registryAdmin = owner;
165   }
166 
167   event AccountCreated(uint256 indexed accountId, address indexed newUser);
168   event InviteCreated(address indexed inviter, address indexed inviteAddress);
169   event InviteAccepted(address recipient, address indexed inviteAddress);
170   event AddressAdded(uint256 indexed accountId, address indexed newAddress);
171   event AddressRemoved(uint256 indexed accountId, address indexed oldAddress);
172   event RegistryAdminChanged(address oldRegistryAdmin, address newRegistryAdmin);
173   event SigningLogicChanged(address oldSigningLogic, address newSigningLogic);
174   event AccountRegistryChanged(address oldRegistry, address newRegistry);
175 
176   /**
177    * @dev Addresses with Bloom accounts already are not allowed
178    */
179   modifier onlyNonUser {
180     require(!registry.addressBelongsToAccount(msg.sender));
181     _;
182   }
183 
184   /**
185    * @dev Addresses without Bloom accounts already are not allowed
186    */
187   modifier onlyUser {
188     require(registry.addressBelongsToAccount(msg.sender));
189     _;
190   }
191 
192   /**
193    * @dev Zero address not allowed
194    */
195   modifier nonZero(address _address) {
196     require(_address != 0);
197     _;
198   }
199 
200   /**
201    * @dev Restricted to registryAdmin
202    */
203   modifier onlyRegistryAdmin {
204     require(msg.sender == registryAdmin);
205     _;
206   }
207 
208   // Signatures contain a nonce to make them unique. usedSignatures tracks which signatures
209   //  have been used so they can't be replayed
210   mapping (bytes32 => bool) public usedSignatures;
211 
212   // Mapping of public keys as Ethereum addresses to invite information
213   // NOTE: the address keys here are NOT Ethereum addresses, we just happen
214   // to work with the public keys in terms of Ethereum address strings because
215   // this is what `ecrecover` produces when working with signed text.
216   mapping(address => bool) public pendingInvites;
217 
218   /**
219    * @notice Change the implementation of the SigningLogic contract by setting a new address
220    * @dev Restricted to AccountRegistry owner and new implementation address cannot be 0x0
221    * @param _newSigningLogic Address of new SigningLogic implementation
222    */
223   function setSigningLogic(SigningLogicInterface _newSigningLogic) public nonZero(_newSigningLogic) onlyOwner {
224     address oldSigningLogic = signingLogic;
225     signingLogic = _newSigningLogic;
226     emit SigningLogicChanged(oldSigningLogic, signingLogic);
227   }
228 
229   /**
230    * @notice Change the address of the registryAdmin, who has the privilege to create new accounts
231    * @dev Restricted to AccountRegistry owner and new admin address cannot be 0x0
232    * @param _newRegistryAdmin Address of new registryAdmin
233    */
234   function setRegistryAdmin(address _newRegistryAdmin) public onlyOwner nonZero(_newRegistryAdmin) {
235     address _oldRegistryAdmin = registryAdmin;
236     registryAdmin = _newRegistryAdmin;
237     emit RegistryAdminChanged(_oldRegistryAdmin, registryAdmin);
238   }
239 
240   /**
241    * @notice Change the address of AccountRegistry, which enables authorization of subject comments
242    * @dev Restricted to owner and new address cannot be 0x0
243    * @param _newRegistry Address of new Account Registry contract
244    */
245   function setAccountRegistry(AccountRegistryInterface _newRegistry) public nonZero(_newRegistry) onlyOwner {
246     address oldRegistry = registry;
247     registry = _newRegistry;
248     emit AccountRegistryChanged(oldRegistry, registry);
249   }
250 
251   /**
252    * @notice Create an invite using the signing model described in the contract description
253    * @dev Recovers public key of invitation key pair using 
254    * @param _sig Signature of one-time-use keypair generated for invite
255    */
256   function createInvite(bytes _sig) public onlyUser {
257     address inviteAddress = signingLogic.recoverSigner(keccak256(abi.encodePacked(msg.sender)), _sig);
258     require(!pendingInvites[inviteAddress]);
259     pendingInvites[inviteAddress] = true;
260     emit InviteCreated(msg.sender, inviteAddress);
261   }
262 
263   /**
264    * @notice Accept an invite using the signing model described in the contract description
265    * @dev Recovers public key of invitation key pair
266    * Assumes signed message matches format described in recoverSigner
267    * Restricted to addresses that are not already registered by a user
268    * Invite is accepted by setting recipient to nonzero address for invite associated with recovered public key
269    * and creating an account for the sender
270    * @param _sig Signature for `msg.sender` via the same key that issued the initial invite
271    */
272   function acceptInvite(bytes _sig) public onlyNonUser {
273     address inviteAddress = signingLogic.recoverSigner(keccak256(abi.encodePacked(msg.sender)), _sig);
274     require(pendingInvites[inviteAddress]);
275     pendingInvites[inviteAddress] = false;
276     createAccountForUser(msg.sender);
277     emit InviteAccepted(msg.sender, inviteAddress);
278   }
279 
280   /**
281    * @notice Create an account instantly without an invitation
282    * @dev Restricted to the "invite admin" which is managed by the Bloom team
283    * @param _newUser Address of the user receiving an account
284    */
285   function createAccount(address _newUser) public onlyRegistryAdmin {
286     createAccountForUser(_newUser);
287   }
288 
289   /**
290    * @notice Create an account for a user and emit an event
291    * @dev Records address as taken so it cannot be used to sign up for another account
292    *  accountId is a unique ID across all users generated by calculating the length of the accounts array
293    *  addressId is the position in the unordered list of addresses associated with a user account 
294    *  AccountInfo is a struct containing accountId and addressId so all addresses can be found for a user
295    * new Login structs represent user accounts. The first one is pushed onto the array associated with a user's accountID
296    * To push a new account onto the same Id, accounts array should be addressed accounts[_accountID - 1].push
297    * @param _newUser Address of the new user
298    */
299   function createAccountForUser(address _newUser) internal nonZero(_newUser) {
300     registry.createNewAccount(_newUser);
301     uint256 _accountId = registry.accountIdForAddress(_newUser);
302     emit AccountCreated(_accountId, _newUser);
303   }
304 
305   /**
306    * @notice Add an address to an existing id on behalf of a user to pay the gas costs
307    * @param _newAddress Address to add to account
308    * @param _newAddressSig Signed message from new address confirming ownership by the sender
309    * @param _senderSig Signed message from address currently associated with account confirming intention
310    * @param _sender User requesting this action
311    * @param _nonce uuid used when generating sigs to make them one time use
312    */
313   function addAddressToAccountFor(
314     address _newAddress,
315     bytes _newAddressSig,
316     bytes _senderSig,
317     address _sender,
318     bytes32 _nonce
319     ) public onlyRegistryAdmin {
320     addAddressToAccountForUser(_newAddress, _newAddressSig, _senderSig, _sender, _nonce);
321   }
322 
323   /**
324    * @notice Add an address to an existing id by a user
325    * @dev Wrapper for addAddressTooAccountForUser with msg.sender as sender
326    * @param _newAddress Address to add to account
327    * @param _newAddressSig Signed message from new address confirming ownership by the sender
328    * @param _senderSig Signed message from msg.sender confirming intention by the sender
329    * @param _nonce uuid used when generating sigs to make them one time use
330    */
331   function addAddressToAccount(
332     address _newAddress,
333     bytes _newAddressSig,
334     bytes _senderSig,
335     bytes32 _nonce
336     ) public onlyUser {
337     addAddressToAccountForUser(_newAddress, _newAddressSig, _senderSig, msg.sender, _nonce);
338   }
339 
340   /**
341    * @notice Add an address to an existing id 
342    * @dev Checks that new address signed _sig 
343    * @param _newAddress Address to add to account
344    * @param _newAddressSig Signed message from new address confirming ownership by the sender
345    * @param _senderSig Signed message from new address confirming ownership by the sender
346    * @param _sender User requesting this action
347    * @param _nonce uuid used when generating sigs to make them one time use
348    */
349   function addAddressToAccountForUser(
350     address _newAddress,
351     bytes _newAddressSig,
352     bytes _senderSig,
353     address _sender,
354     bytes32 _nonce
355     ) private nonZero(_newAddress) {
356 
357     require(!usedSignatures[keccak256(abi.encodePacked(_newAddressSig))], "Signature not unique");
358     require(!usedSignatures[keccak256(abi.encodePacked(_senderSig))], "Signature not unique");
359 
360     usedSignatures[keccak256(abi.encodePacked(_newAddressSig))] = true;
361     usedSignatures[keccak256(abi.encodePacked(_senderSig))] = true;
362 
363     // Confirm new address is signed by current address
364     bytes32 _currentAddressDigest = signingLogic.generateAddAddressSchemaHash(_newAddress, _nonce);
365     require(_sender == signingLogic.recoverSigner(_currentAddressDigest, _senderSig));
366 
367     // Confirm current address is signed by new address
368     bytes32 _newAddressDigest = signingLogic.generateAddAddressSchemaHash(_sender, _nonce);
369     require(_newAddress == signingLogic.recoverSigner(_newAddressDigest, _newAddressSig));
370 
371     registry.addAddressToAccount(_newAddress, _sender);
372     uint256 _accountId = registry.accountIdForAddress(_newAddress);
373     emit AddressAdded(_accountId, _newAddress);
374   }
375 
376   /**
377    * @notice Remove an address from an account for a user
378    * @dev Restricted to admin
379    * @param _addressToRemove Address to remove from account
380    */
381   function removeAddressFromAccountFor(
382     address _addressToRemove
383   ) public onlyRegistryAdmin {
384     uint256 _accountId = registry.accountIdForAddress(_addressToRemove);
385     registry.removeAddressFromAccount(_addressToRemove);
386     emit AddressRemoved(_accountId, _addressToRemove);
387   }
388 }
389 
390 
391 contract AccountRegistryBatchAdmin is Ownable{
392 
393   AccountRegistryInterface public registry;
394   AccountRegistryLogic public logic;
395   address public registryAdmin;
396 
397   constructor(
398     AccountRegistryInterface _registry,
399     AccountRegistryLogic _logic
400     ) public {
401     registry = _registry;
402     logic = _logic;
403     registryAdmin = owner;
404   }
405 
406   event addressSkipped(address skippedAddress);
407 
408   /**
409    * @dev Restricted to registryAdmin
410    */
411   modifier onlyRegistryAdmin {
412     require(msg.sender == registryAdmin);
413     _;
414   }
415 
416   /**
417    * @notice Change the address of the registryAdmin, who has the privilege to create new accounts
418    * @dev Restricted to AccountRegistry owner and new admin address cannot be 0x0
419    * @param _newRegistryAdmin Address of new registryAdmin
420    */
421   function setRegistryAdmin(address _newRegistryAdmin) public onlyOwner {
422     address _oldRegistryAdmin = registryAdmin;
423     registryAdmin = _newRegistryAdmin;
424   }
425 
426   /**
427    * @notice Create an account instantly without an invitation
428    * @dev Restricted to the "invite admin" which is managed by the Bloom team
429    * @param _newUsers Address array of the users receiving an account
430    */
431   function batchCreateAccount(address[] _newUsers) public onlyRegistryAdmin {
432     for (uint256 i = 0; i < _newUsers.length; i++) {
433       if (registry.addressBelongsToAccount(_newUsers[i])) {
434         emit addressSkipped(_newUsers[i]);
435       } else {
436         logic.createAccount(_newUsers[i]);
437       }
438     }
439   }
440 }