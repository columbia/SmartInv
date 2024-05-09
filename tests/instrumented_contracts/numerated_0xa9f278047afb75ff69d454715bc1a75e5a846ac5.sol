1 pragma solidity ^0.4.23;
2 
3 // File: contracts/grapevine/crowdsale/GrapevineWhitelistInterface.sol
4 
5 /**
6  * @title Grapevine Whitelist extends the zeppelin Whitelist and adding off-chain signing capabilities.
7  * @dev Grapevine Crowdsale
8  **/
9 contract GrapevineWhitelistInterface {
10 
11   /**
12    * @dev Function to check if an address is whitelisted or not
13    * @param _address address The address to be checked.
14    */
15   function whitelist(address _address) view external returns (bool);
16 
17  
18   /**
19    * @dev Handles the off-chain whitelisting.
20    * @param _addr Address of the sender.
21    * @param _sig signed message provided by the sender.
22    */
23   function handleOffchainWhitelisted(address _addr, bytes _sig) external returns (bool);
24 }
25 
26 // File: openzeppelin-solidity/contracts/ECRecovery.sol
27 
28 /**
29  * @title Eliptic curve signature operations
30  *
31  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
32  *
33  * TODO Remove this library once solidity supports passing a signature to ecrecover.
34  * See https://github.com/ethereum/solidity/issues/864
35  *
36  */
37 
38 library ECRecovery {
39 
40   /**
41    * @dev Recover signer address from a message by using their signature
42    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
43    * @param sig bytes signature, the signature is generated using web3.eth.sign()
44    */
45   function recover(bytes32 hash, bytes sig)
46     internal
47     pure
48     returns (address)
49   {
50     bytes32 r;
51     bytes32 s;
52     uint8 v;
53 
54     // Check the signature length
55     if (sig.length != 65) {
56       return (address(0));
57     }
58 
59     // Divide the signature in r, s and v variables
60     // ecrecover takes the signature parameters, and the only way to get them
61     // currently is to use assembly.
62     // solium-disable-next-line security/no-inline-assembly
63     assembly {
64       r := mload(add(sig, 32))
65       s := mload(add(sig, 64))
66       v := byte(0, mload(add(sig, 96)))
67     }
68 
69     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
70     if (v < 27) {
71       v += 27;
72     }
73 
74     // If the version is correct return the signer address
75     if (v != 27 && v != 28) {
76       return (address(0));
77     } else {
78       // solium-disable-next-line arg-overflow
79       return ecrecover(hash, v, r, s);
80     }
81   }
82 
83   /**
84    * toEthSignedMessageHash
85    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
86    * @dev and hash the result
87    */
88   function toEthSignedMessageHash(bytes32 hash)
89     internal
90     pure
91     returns (bytes32)
92   {
93     // 32 is the length in bytes of hash,
94     // enforced by the type signature above
95     return keccak256(
96       "\x19Ethereum Signed Message:\n32",
97       hash
98     );
99   }
100 }
101 
102 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
103 
104 /**
105  * @title Ownable
106  * @dev The Ownable contract has an owner address, and provides basic authorization control
107  * functions, this simplifies the implementation of "user permissions".
108  */
109 contract Ownable {
110   address public owner;
111 
112 
113   event OwnershipRenounced(address indexed previousOwner);
114   event OwnershipTransferred(
115     address indexed previousOwner,
116     address indexed newOwner
117   );
118 
119 
120   /**
121    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
122    * account.
123    */
124   constructor() public {
125     owner = msg.sender;
126   }
127 
128   /**
129    * @dev Throws if called by any account other than the owner.
130    */
131   modifier onlyOwner() {
132     require(msg.sender == owner);
133     _;
134   }
135 
136   /**
137    * @dev Allows the current owner to relinquish control of the contract.
138    */
139   function renounceOwnership() public onlyOwner {
140     emit OwnershipRenounced(owner);
141     owner = address(0);
142   }
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param _newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address _newOwner) public onlyOwner {
149     _transferOwnership(_newOwner);
150   }
151 
152   /**
153    * @dev Transfers control of the contract to a newOwner.
154    * @param _newOwner The address to transfer ownership to.
155    */
156   function _transferOwnership(address _newOwner) internal {
157     require(_newOwner != address(0));
158     emit OwnershipTransferred(owner, _newOwner);
159     owner = _newOwner;
160   }
161 }
162 
163 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
164 
165 /**
166  * @title Roles
167  * @author Francisco Giordano (@frangio)
168  * @dev Library for managing addresses assigned to a Role.
169  *      See RBAC.sol for example usage.
170  */
171 library Roles {
172   struct Role {
173     mapping (address => bool) bearer;
174   }
175 
176   /**
177    * @dev give an address access to this role
178    */
179   function add(Role storage role, address addr)
180     internal
181   {
182     role.bearer[addr] = true;
183   }
184 
185   /**
186    * @dev remove an address' access to this role
187    */
188   function remove(Role storage role, address addr)
189     internal
190   {
191     role.bearer[addr] = false;
192   }
193 
194   /**
195    * @dev check if an address has this role
196    * // reverts
197    */
198   function check(Role storage role, address addr)
199     view
200     internal
201   {
202     require(has(role, addr));
203   }
204 
205   /**
206    * @dev check if an address has this role
207    * @return bool
208    */
209   function has(Role storage role, address addr)
210     view
211     internal
212     returns (bool)
213   {
214     return role.bearer[addr];
215   }
216 }
217 
218 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
219 
220 /**
221  * @title RBAC (Role-Based Access Control)
222  * @author Matt Condon (@Shrugs)
223  * @dev Stores and provides setters and getters for roles and addresses.
224  * @dev Supports unlimited numbers of roles and addresses.
225  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
226  * This RBAC method uses strings to key roles. It may be beneficial
227  *  for you to write your own implementation of this interface using Enums or similar.
228  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
229  *  to avoid typos.
230  */
231 contract RBAC {
232   using Roles for Roles.Role;
233 
234   mapping (string => Roles.Role) private roles;
235 
236   event RoleAdded(address addr, string roleName);
237   event RoleRemoved(address addr, string roleName);
238 
239   /**
240    * @dev reverts if addr does not have role
241    * @param addr address
242    * @param roleName the name of the role
243    * // reverts
244    */
245   function checkRole(address addr, string roleName)
246     view
247     public
248   {
249     roles[roleName].check(addr);
250   }
251 
252   /**
253    * @dev determine if addr has role
254    * @param addr address
255    * @param roleName the name of the role
256    * @return bool
257    */
258   function hasRole(address addr, string roleName)
259     view
260     public
261     returns (bool)
262   {
263     return roles[roleName].has(addr);
264   }
265 
266   /**
267    * @dev add a role to an address
268    * @param addr address
269    * @param roleName the name of the role
270    */
271   function addRole(address addr, string roleName)
272     internal
273   {
274     roles[roleName].add(addr);
275     emit RoleAdded(addr, roleName);
276   }
277 
278   /**
279    * @dev remove a role from an address
280    * @param addr address
281    * @param roleName the name of the role
282    */
283   function removeRole(address addr, string roleName)
284     internal
285   {
286     roles[roleName].remove(addr);
287     emit RoleRemoved(addr, roleName);
288   }
289 
290   /**
291    * @dev modifier to scope access to a single role (uses msg.sender as addr)
292    * @param roleName the name of the role
293    * // reverts
294    */
295   modifier onlyRole(string roleName)
296   {
297     checkRole(msg.sender, roleName);
298     _;
299   }
300 
301   /**
302    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
303    * @param roleNames the names of the roles to scope access to
304    * // reverts
305    *
306    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
307    *  see: https://github.com/ethereum/solidity/issues/2467
308    */
309   // modifier onlyRoles(string[] roleNames) {
310   //     bool hasAnyRole = false;
311   //     for (uint8 i = 0; i < roleNames.length; i++) {
312   //         if (hasRole(msg.sender, roleNames[i])) {
313   //             hasAnyRole = true;
314   //             break;
315   //         }
316   //     }
317 
318   //     require(hasAnyRole);
319 
320   //     _;
321   // }
322 }
323 
324 // File: openzeppelin-solidity/contracts/access/SignatureBouncer.sol
325 
326 /**
327  * @title SignatureBouncer
328  * @author PhABC and Shrugs
329  * @dev Bouncer allows users to submit a signature as a permission to do an action.
330  * If the signature is from one of the authorized bouncer addresses, the signature
331  * is valid. The owner of the contract adds/removes bouncers.
332  * Bouncer addresses can be individual servers signing grants or different
333  * users within a decentralized club that have permission to invite other members.
334  * 
335  * This technique is useful for whitelists and airdrops; instead of putting all
336  * valid addresses on-chain, simply sign a grant of the form
337  * keccak256(`:contractAddress` + `:granteeAddress`) using a valid bouncer address.
338  * Then restrict access to your crowdsale/whitelist/airdrop using the
339  * `onlyValidSignature` modifier (or implement your own using isValidSignature).
340  * 
341  * See the tests Bouncer.test.js for specific usage examples.
342  */
343 contract SignatureBouncer is Ownable, RBAC {
344   using ECRecovery for bytes32;
345 
346   string public constant ROLE_BOUNCER = "bouncer";
347 
348   /**
349    * @dev requires that a valid signature of a bouncer was provided
350    */
351   modifier onlyValidSignature(bytes _sig)
352   {
353     require(isValidSignature(msg.sender, _sig));
354     _;
355   }
356 
357   /**
358    * @dev allows the owner to add additional bouncer addresses
359    */
360   function addBouncer(address _bouncer)
361     onlyOwner
362     public
363   {
364     require(_bouncer != address(0));
365     addRole(_bouncer, ROLE_BOUNCER);
366   }
367 
368   /**
369    * @dev allows the owner to remove bouncer addresses
370    */
371   function removeBouncer(address _bouncer)
372     onlyOwner
373     public
374   {
375     require(_bouncer != address(0));
376     removeRole(_bouncer, ROLE_BOUNCER);
377   }
378 
379   /**
380    * @dev is the signature of `this + sender` from a bouncer?
381    * @return bool
382    */
383   function isValidSignature(address _address, bytes _sig)
384     internal
385     view
386     returns (bool)
387   {
388     return isValidDataHash(
389       keccak256(address(this), _address),
390       _sig
391     );
392   }
393 
394   /**
395    * @dev internal function to convert a hash to an eth signed message
396    * @dev and then recover the signature and check it against the bouncer role
397    * @return bool
398    */
399   function isValidDataHash(bytes32 hash, bytes _sig)
400     internal
401     view
402     returns (bool)
403   {
404     address signer = hash
405       .toEthSignedMessageHash()
406       .recover(_sig);
407     return hasRole(signer, ROLE_BOUNCER);
408   }
409 }
410 
411 // File: contracts/grapevine/crowdsale/GrapevineWhitelist.sol
412 
413 /**
414  * @title Grapevine Whitelist extends the zeppelin Whitelist and adding off-chain signing capabilities.
415  * @dev Grapevine Crowdsale
416  **/
417 contract GrapevineWhitelist is SignatureBouncer, GrapevineWhitelistInterface {
418 
419   event WhitelistedAddressAdded(address addr);
420   event WhitelistedAddressRemoved(address addr);
421   event UselessEvent(address addr, bytes sign, bool ret);
422 
423   mapping(address => bool) public whitelist;
424 
425   address crowdsale;
426 
427   constructor(address _signer) public {
428     require(_signer != address(0));
429     addBouncer(_signer);
430   }
431 
432   modifier onlyOwnerOrCrowdsale() {
433     require(msg.sender == owner || msg.sender == crowdsale);
434     _;
435   }
436 
437   /**
438    * @dev Function to check if an address is whitelisted
439    * @param _address address The address to be checked.
440    */
441   function whitelist(address _address) view external returns (bool) {
442     return whitelist[_address];
443   }
444   
445   /**
446    * @dev Function to set the crowdsale address
447    * @param _crowdsale address The address of the crowdsale.
448    */
449   function setCrowdsale(address _crowdsale) external onlyOwner {
450     require(_crowdsale != address(0));
451     crowdsale = _crowdsale;
452   }
453 
454   /**
455    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
456    * @param _beneficiaries Addresses to be added to the whitelist
457    */
458   function addAddressesToWhitelist(address[] _beneficiaries) external onlyOwnerOrCrowdsale {
459     for (uint256 i = 0; i < _beneficiaries.length; i++) {
460       addAddressToWhitelist(_beneficiaries[i]);
461     }
462   }
463 
464   /**
465    * @dev Removes single address from whitelist.
466    * @param _beneficiary Address to be removed to the whitelist
467    */
468   function removeAddressFromWhitelist(address _beneficiary) external onlyOwnerOrCrowdsale {
469     whitelist[_beneficiary] = false;
470     emit WhitelistedAddressRemoved(_beneficiary);
471   }
472 
473   /**
474    * @dev Handles the off-chain whitelisting.
475    * @param _addr Address of the sender.
476    * @param _sig signed message provided by the sender.
477    */
478   function handleOffchainWhitelisted(address _addr, bytes _sig) external onlyOwnerOrCrowdsale returns (bool) {
479     bool valid;
480     // no need for consuming gas when the address is already whitelisted 
481     if (whitelist[_addr]) {
482       valid = true;
483     } else {
484       valid = isValidSignature(_addr, _sig);
485       if (valid) {
486         // no need for consuming gas again if the address calls the contract again. 
487         addAddressToWhitelist(_addr);
488       }
489     }
490     return valid;
491   }
492 
493   /**
494    * @dev Adds single address to whitelist.
495    * @param _beneficiary Address to be added to the whitelist
496    */
497   function addAddressToWhitelist(address _beneficiary) public onlyOwnerOrCrowdsale {
498     whitelist[_beneficiary] = true;
499     emit WhitelistedAddressAdded(_beneficiary);
500   }
501 }