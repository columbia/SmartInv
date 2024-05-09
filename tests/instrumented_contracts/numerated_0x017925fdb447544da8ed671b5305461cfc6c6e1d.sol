1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 contract SigningLogicInterface {
45   function recoverSigner(bytes32 _hash, bytes _sig) external pure returns (address);
46   function generateRequestAttestationSchemaHash(
47     address _subject,
48     address _attester,
49     address _requester,
50     bytes32 _dataHash,
51     uint256[] _typeIds,
52     bytes32 _nonce
53     ) external view returns (bytes32);
54   function generateAttestForDelegationSchemaHash(
55     address _subject,
56     address _requester,
57     uint256 _reward,
58     bytes32 _paymentNonce,
59     bytes32 _dataHash,
60     uint256[] _typeIds,
61     bytes32 _requestNonce
62     ) external view returns (bytes32);
63   function generateContestForDelegationSchemaHash(
64     address _requester,
65     uint256 _reward,
66     bytes32 _paymentNonce
67   ) external view returns (bytes32);
68   function generateStakeForDelegationSchemaHash(
69     address _subject,
70     uint256 _value,
71     bytes32 _paymentNonce,
72     bytes32 _dataHash,
73     uint256[] _typeIds,
74     bytes32 _requestNonce,
75     uint256 _stakeDuration
76     ) external view returns (bytes32);
77   function generateRevokeStakeForDelegationSchemaHash(
78     uint256 _subjectId,
79     uint256 _attestationId
80     ) external view returns (bytes32);
81   function generateAddAddressSchemaHash(
82     address _senderAddress,
83     bytes32 _nonce
84     ) external view returns (bytes32);
85   function generateVoteForDelegationSchemaHash(
86     uint16 _choice,
87     address _voter,
88     bytes32 _nonce,
89     address _poll
90     ) external view returns (bytes32);
91   function generateReleaseTokensSchemaHash(
92     address _sender,
93     address _receiver,
94     uint256 _amount,
95     bytes32 _uuid
96     ) external view returns (bytes32);
97   function generateLockupTokensDelegationSchemaHash(
98     address _sender,
99     uint256 _amount,
100     bytes32 _nonce
101     ) external view returns (bytes32);
102 }
103 
104 interface AccountRegistryInterface {
105   function accountIdForAddress(address _address) public view returns (uint256);
106   function addressBelongsToAccount(address _address) public view returns (bool);
107   function createNewAccount(address _newUser) external;
108   function addAddressToAccount(
109     address _newAddress,
110     address _sender
111     ) external;
112   function removeAddressFromAccount(address _addressToRemove) external;
113 }
114 
115 /**
116  * @title Bloom account registry
117  * @notice Account Registry Logic provides a public interface for Bloom and users to 
118  * create and control their Bloom Ids.
119  * Users can associate create and accept invites and associate additional addresses with their BloomId.
120  * As the Bloom protocol matures, this contract can be upgraded to enable new capabilities
121  * without needing to migrate the underlying Account Registry storage contract.
122  *
123  * In order to invite someone, a user must generate a new public key private key pair
124  * and sign their own ethereum address. The user provides this signature to the
125  * `createInvite` function where the public key is recovered and the invite is created.
126  * The inviter should then share the one-time-use private key out of band with the recipient.
127  * The recipient accepts the invite by signing their own address and passing that signature
128  * to the `acceptInvite` function. The contract should recover the same public key, demonstrating
129  * that the recipient knows the secret and is likely the person intended to receive the invite.
130  *
131  * @dev This invite model is supposed to aid usability by not requiring the inviting user to know
132  *   the Ethereum address of the recipient. If the one-time-use private key is leaked then anyone
133  *   else can accept the invite. This is an intentional tradeoff of this invite system. A well built
134  *   dApp should generate the private key on the backend and sign the user's address for them. Likewise,
135  *   the signing should also happen on the backend (not visible to the user) for signing an address to
136  *   accept an invite. This reduces the private key exposure so that the dApp can still require traditional
137  *   checks like verifying an associated email address before finally signing the user's Ethereum address.
138  *
139  * @dev The private key generated for this invite system should NEVER be used for an Ethereum address.
140  *   The private key should be used only for the invite flow and then it should effectively be discarded.
141  *
142  * @dev If a user DOES know the address of the person they are inviting then they can still use this
143  *   invite system. All they have to do then is sign the address of the user being invited and share the
144  *   signature with them.
145  */
146 contract AccountRegistryLogic is Ownable{
147 
148   SigningLogicInterface public signingLogic;
149   AccountRegistryInterface public registry;
150   address public registryAdmin;
151 
152   /**
153    * @notice The AccountRegistry constructor configures the signing logic implementation
154    *  and creates an account for the user who deployed the contract.
155    * @dev The owner is also set as the original registryAdmin, who has the privilege to
156    *  create accounts outside of the normal invitation flow.
157    * @param _signingLogic The address of the deployed SigningLogic contract
158    * @param _registry The address of the deployed account registry
159    */
160   constructor(
161     SigningLogicInterface _signingLogic,
162     AccountRegistryInterface _registry
163     ) public {
164     signingLogic = _signingLogic;
165     registry = _registry;
166     registryAdmin = owner;
167   }
168 
169   event AccountCreated(uint256 indexed accountId, address indexed newUser);
170   event InviteCreated(address indexed inviter, address indexed inviteAddress);
171   event InviteAccepted(address recipient, address indexed inviteAddress);
172   event AddressAdded(uint256 indexed accountId, address indexed newAddress);
173   event AddressRemoved(uint256 indexed accountId, address indexed oldAddress);
174   event RegistryAdminChanged(address oldRegistryAdmin, address newRegistryAdmin);
175   event SigningLogicChanged(address oldSigningLogic, address newSigningLogic);
176   event AccountRegistryChanged(address oldRegistry, address newRegistry);
177 
178   /**
179    * @dev Addresses with Bloom accounts already are not allowed
180    */
181   modifier onlyNonUser {
182     require(!registry.addressBelongsToAccount(msg.sender));
183     _;
184   }
185 
186   /**
187    * @dev Addresses without Bloom accounts already are not allowed
188    */
189   modifier onlyUser {
190     require(registry.addressBelongsToAccount(msg.sender));
191     _;
192   }
193 
194   /**
195    * @dev Zero address not allowed
196    */
197   modifier nonZero(address _address) {
198     require(_address != 0);
199     _;
200   }
201 
202   /**
203    * @dev Restricted to registryAdmin
204    */
205   modifier onlyRegistryAdmin {
206     require(msg.sender == registryAdmin);
207     _;
208   }
209 
210   // Signatures contain a nonce to make them unique. usedSignatures tracks which signatures
211   //  have been used so they can't be replayed
212   mapping (bytes32 => bool) public usedSignatures;
213 
214   // Mapping of public keys as Ethereum addresses to invite information
215   // NOTE: the address keys here are NOT Ethereum addresses, we just happen
216   // to work with the public keys in terms of Ethereum address strings because
217   // this is what `ecrecover` produces when working with signed text.
218   mapping(address => bool) public pendingInvites;
219 
220   /**
221    * @notice Change the implementation of the SigningLogic contract by setting a new address
222    * @dev Restricted to AccountRegistry owner and new implementation address cannot be 0x0
223    * @param _newSigningLogic Address of new SigningLogic implementation
224    */
225   function setSigningLogic(SigningLogicInterface _newSigningLogic) public nonZero(_newSigningLogic) onlyOwner {
226     address oldSigningLogic = signingLogic;
227     signingLogic = _newSigningLogic;
228     emit SigningLogicChanged(oldSigningLogic, signingLogic);
229   }
230 
231   /**
232    * @notice Change the address of the registryAdmin, who has the privilege to create new accounts
233    * @dev Restricted to AccountRegistry owner and new admin address cannot be 0x0
234    * @param _newRegistryAdmin Address of new registryAdmin
235    */
236   function setRegistryAdmin(address _newRegistryAdmin) public onlyOwner nonZero(_newRegistryAdmin) {
237     address _oldRegistryAdmin = registryAdmin;
238     registryAdmin = _newRegistryAdmin;
239     emit RegistryAdminChanged(_oldRegistryAdmin, registryAdmin);
240   }
241 
242   /**
243    * @notice Change the address of AccountRegistry, which enables authorization of subject comments
244    * @dev Restricted to owner and new address cannot be 0x0
245    * @param _newRegistry Address of new Account Registry contract
246    */
247   function setAccountRegistry(AccountRegistryInterface _newRegistry) public nonZero(_newRegistry) onlyOwner {
248     address oldRegistry = registry;
249     registry = _newRegistry;
250     emit AccountRegistryChanged(oldRegistry, registry);
251   }
252 
253   /**
254    * @notice Create an invite using the signing model described in the contract description
255    * @dev Recovers public key of invitation key pair using 
256    * @param _sig Signature of one-time-use keypair generated for invite
257    */
258   function createInvite(bytes _sig) public onlyUser {
259     address inviteAddress = signingLogic.recoverSigner(keccak256(abi.encodePacked(msg.sender)), _sig);
260     require(!pendingInvites[inviteAddress]);
261     pendingInvites[inviteAddress] = true;
262     emit InviteCreated(msg.sender, inviteAddress);
263   }
264 
265   /**
266    * @notice Accept an invite using the signing model described in the contract description
267    * @dev Recovers public key of invitation key pair
268    * Assumes signed message matches format described in recoverSigner
269    * Restricted to addresses that are not already registered by a user
270    * Invite is accepted by setting recipient to nonzero address for invite associated with recovered public key
271    * and creating an account for the sender
272    * @param _sig Signature for `msg.sender` via the same key that issued the initial invite
273    */
274   function acceptInvite(bytes _sig) public onlyNonUser {
275     address inviteAddress = signingLogic.recoverSigner(keccak256(abi.encodePacked(msg.sender)), _sig);
276     require(pendingInvites[inviteAddress]);
277     pendingInvites[inviteAddress] = false;
278     createAccountForUser(msg.sender);
279     emit InviteAccepted(msg.sender, inviteAddress);
280   }
281 
282   /**
283    * @notice Create an account instantly without an invitation
284    * @dev Restricted to the "invite admin" which is managed by the Bloom team
285    * @param _newUser Address of the user receiving an account
286    */
287   function createAccount(address _newUser) public onlyRegistryAdmin {
288     createAccountForUser(_newUser);
289   }
290 
291   /**
292    * @notice Create an account for a user and emit an event
293    * @dev Records address as taken so it cannot be used to sign up for another account
294    *  accountId is a unique ID across all users generated by calculating the length of the accounts array
295    *  addressId is the position in the unordered list of addresses associated with a user account 
296    *  AccountInfo is a struct containing accountId and addressId so all addresses can be found for a user
297    * new Login structs represent user accounts. The first one is pushed onto the array associated with a user's accountID
298    * To push a new account onto the same Id, accounts array should be addressed accounts[_accountID - 1].push
299    * @param _newUser Address of the new user
300    */
301   function createAccountForUser(address _newUser) internal nonZero(_newUser) {
302     registry.createNewAccount(_newUser);
303     uint256 _accountId = registry.accountIdForAddress(_newUser);
304     emit AccountCreated(_accountId, _newUser);
305   }
306 
307   /**
308    * @notice Add an address to an existing id on behalf of a user to pay the gas costs
309    * @param _newAddress Address to add to account
310    * @param _newAddressSig Signed message from new address confirming ownership by the sender
311    * @param _senderSig Signed message from address currently associated with account confirming intention
312    * @param _sender User requesting this action
313    * @param _nonce uuid used when generating sigs to make them one time use
314    */
315   function addAddressToAccountFor(
316     address _newAddress,
317     bytes _newAddressSig,
318     bytes _senderSig,
319     address _sender,
320     bytes32 _nonce
321     ) public onlyRegistryAdmin {
322     addAddressToAccountForUser(_newAddress, _newAddressSig, _senderSig, _sender, _nonce);
323   }
324 
325   /**
326    * @notice Add an address to an existing id by a user
327    * @dev Wrapper for addAddressTooAccountForUser with msg.sender as sender
328    * @param _newAddress Address to add to account
329    * @param _newAddressSig Signed message from new address confirming ownership by the sender
330    * @param _senderSig Signed message from msg.sender confirming intention by the sender
331    * @param _nonce uuid used when generating sigs to make them one time use
332    */
333   function addAddressToAccount(
334     address _newAddress,
335     bytes _newAddressSig,
336     bytes _senderSig,
337     bytes32 _nonce
338     ) public onlyUser {
339     addAddressToAccountForUser(_newAddress, _newAddressSig, _senderSig, msg.sender, _nonce);
340   }
341 
342   /**
343    * @notice Add an address to an existing id 
344    * @dev Checks that new address signed _sig 
345    * @param _newAddress Address to add to account
346    * @param _newAddressSig Signed message from new address confirming ownership by the sender
347    * @param _senderSig Signed message from new address confirming ownership by the sender
348    * @param _sender User requesting this action
349    * @param _nonce uuid used when generating sigs to make them one time use
350    */
351   function addAddressToAccountForUser(
352     address _newAddress,
353     bytes _newAddressSig,
354     bytes _senderSig,
355     address _sender,
356     bytes32 _nonce
357     ) private nonZero(_newAddress) {
358 
359     require(!usedSignatures[keccak256(abi.encodePacked(_newAddressSig))], "Signature not unique");
360     require(!usedSignatures[keccak256(abi.encodePacked(_senderSig))], "Signature not unique");
361 
362     usedSignatures[keccak256(abi.encodePacked(_newAddressSig))] = true;
363     usedSignatures[keccak256(abi.encodePacked(_senderSig))] = true;
364 
365     // Confirm new address is signed by current address
366     bytes32 _currentAddressDigest = signingLogic.generateAddAddressSchemaHash(_newAddress, _nonce);
367     require(_sender == signingLogic.recoverSigner(_currentAddressDigest, _senderSig));
368 
369     // Confirm current address is signed by new address
370     bytes32 _newAddressDigest = signingLogic.generateAddAddressSchemaHash(_sender, _nonce);
371     require(_newAddress == signingLogic.recoverSigner(_newAddressDigest, _newAddressSig));
372 
373     registry.addAddressToAccount(_newAddress, _sender);
374     uint256 _accountId = registry.accountIdForAddress(_newAddress);
375     emit AddressAdded(_accountId, _newAddress);
376   }
377 
378   /**
379    * @notice Remove an address from an account for a user
380    * @dev Restricted to admin
381    * @param _addressToRemove Address to remove from account
382    */
383   function removeAddressFromAccountFor(
384     address _addressToRemove
385   ) public onlyRegistryAdmin {
386     uint256 _accountId = registry.accountIdForAddress(_addressToRemove);
387     registry.removeAddressFromAccount(_addressToRemove);
388     emit AddressRemoved(_accountId, _addressToRemove);
389   }
390 }