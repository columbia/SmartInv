1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title RBAC (Role-Based Access Control)
5  * @author Matt Condon (@Shrugs)
6  * @dev Stores and provides setters and getters for roles and addresses.
7  * Supports unlimited numbers of roles and addresses.
8  * See //contracts/mocks/RBACMock.sol for an example of usage.
9  * This RBAC method uses strings to key roles. It may be beneficial
10  * for you to write your own implementation of this interface using Enums or similar.
11  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
12  * to avoid typos.
13  */
14 contract RBAC {
15   using Roles for Roles.Role;
16 
17   mapping (string => Roles.Role) private roles;
18 
19   event RoleAdded(address indexed operator, string role);
20   event RoleRemoved(address indexed operator, string role);
21 
22   /**
23    * @dev reverts if addr does not have role
24    * @param _operator address
25    * @param _role the name of the role
26    * // reverts
27    */
28   function checkRole(address _operator, string _role)
29     view
30     public
31   {
32     roles[_role].check(_operator);
33   }
34 
35   /**
36    * @dev determine if addr has role
37    * @param _operator address
38    * @param _role the name of the role
39    * @return bool
40    */
41   function hasRole(address _operator, string _role)
42     view
43     public
44     returns (bool)
45   {
46     return roles[_role].has(_operator);
47   }
48 
49   /**
50    * @dev add a role to an address
51    * @param _operator address
52    * @param _role the name of the role
53    */
54   function addRole(address _operator, string _role)
55     internal
56   {
57     roles[_role].add(_operator);
58     emit RoleAdded(_operator, _role);
59   }
60 
61   /**
62    * @dev remove a role from an address
63    * @param _operator address
64    * @param _role the name of the role
65    */
66   function removeRole(address _operator, string _role)
67     internal
68   {
69     roles[_role].remove(_operator);
70     emit RoleRemoved(_operator, _role);
71   }
72 
73   /**
74    * @dev modifier to scope access to a single role (uses msg.sender as addr)
75    * @param _role the name of the role
76    * // reverts
77    */
78   modifier onlyRole(string _role)
79   {
80     checkRole(msg.sender, _role);
81     _;
82   }
83 
84   /**
85    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
86    * @param _roles the names of the roles to scope access to
87    * // reverts
88    *
89    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
90    *  see: https://github.com/ethereum/solidity/issues/2467
91    */
92   // modifier onlyRoles(string[] _roles) {
93   //     bool hasAnyRole = false;
94   //     for (uint8 i = 0; i < _roles.length; i++) {
95   //         if (hasRole(msg.sender, _roles[i])) {
96   //             hasAnyRole = true;
97   //             break;
98   //         }
99   //     }
100 
101   //     require(hasAnyRole);
102 
103   //     _;
104   // }
105 }
106 
107 /**
108  * @title Roles
109  * @author Francisco Giordano (@frangio)
110  * @dev Library for managing addresses assigned to a Role.
111  * See RBAC.sol for example usage.
112  */
113 library Roles {
114   struct Role {
115     mapping (address => bool) bearer;
116   }
117 
118   /**
119    * @dev give an address access to this role
120    */
121   function add(Role storage role, address addr)
122     internal
123   {
124     role.bearer[addr] = true;
125   }
126 
127   /**
128    * @dev remove an address' access to this role
129    */
130   function remove(Role storage role, address addr)
131     internal
132   {
133     role.bearer[addr] = false;
134   }
135 
136   /**
137    * @dev check if an address has this role
138    * // reverts
139    */
140   function check(Role storage role, address addr)
141     view
142     internal
143   {
144     require(has(role, addr));
145   }
146 
147   /**
148    * @dev check if an address has this role
149    * @return bool
150    */
151   function has(Role storage role, address addr)
152     view
153     internal
154     returns (bool)
155   {
156     return role.bearer[addr];
157   }
158 }
159 
160 /**
161  * @title Ownable
162  * @dev The Ownable contract has an owner address, and provides basic authorization control
163  * functions, this simplifies the implementation of "user permissions".
164  */
165 contract Ownable {
166   address public owner;
167 
168 
169   event OwnershipRenounced(address indexed previousOwner);
170   event OwnershipTransferred(
171     address indexed previousOwner,
172     address indexed newOwner
173   );
174 
175 
176   /**
177    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
178    * account.
179    */
180   constructor() public {
181     owner = msg.sender;
182   }
183 
184   /**
185    * @dev Throws if called by any account other than the owner.
186    */
187   modifier onlyOwner() {
188     require(msg.sender == owner);
189     _;
190   }
191 
192   /**
193    * @dev Allows the current owner to relinquish control of the contract.
194    * @notice Renouncing to ownership will leave the contract without an owner.
195    * It will not be possible to call the functions with the `onlyOwner`
196    * modifier anymore.
197    */
198   function renounceOwnership() public onlyOwner {
199     emit OwnershipRenounced(owner);
200     owner = address(0);
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param _newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address _newOwner) public onlyOwner {
208     _transferOwnership(_newOwner);
209   }
210 
211   /**
212    * @dev Transfers control of the contract to a newOwner.
213    * @param _newOwner The address to transfer ownership to.
214    */
215   function _transferOwnership(address _newOwner) internal {
216     require(_newOwner != address(0));
217     emit OwnershipTransferred(owner, _newOwner);
218     owner = _newOwner;
219   }
220 }
221 
222 /**
223  * @title Whitelist
224  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
225  * This simplifies the implementation of "user permissions".
226  */
227 contract Whitelist is Ownable, RBAC {
228   string public constant ROLE_WHITELISTED = "whitelist";
229 
230   /**
231    * @dev Throws if operator is not whitelisted.
232    * @param _operator address
233    */
234   modifier onlyIfWhitelisted(address _operator) {
235     checkRole(_operator, ROLE_WHITELISTED);
236     _;
237   }
238 
239   /**
240    * @dev add an address to the whitelist
241    * @param _operator address
242    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
243    */
244   function addAddressToWhitelist(address _operator)
245     onlyOwner
246     public
247   {
248     addRole(_operator, ROLE_WHITELISTED);
249   }
250 
251   /**
252    * @dev getter to determine if address is in whitelist
253    */
254   function whitelist(address _operator)
255     public
256     view
257     returns (bool)
258   {
259     return hasRole(_operator, ROLE_WHITELISTED);
260   }
261 
262   /**
263    * @dev add addresses to the whitelist
264    * @param _operators addresses
265    * @return true if at least one address was added to the whitelist,
266    * false if all addresses were already in the whitelist
267    */
268   function addAddressesToWhitelist(address[] _operators)
269     onlyOwner
270     public
271   {
272     for (uint256 i = 0; i < _operators.length; i++) {
273       addAddressToWhitelist(_operators[i]);
274     }
275   }
276 
277   /**
278    * @dev remove an address from the whitelist
279    * @param _operator address
280    * @return true if the address was removed from the whitelist,
281    * false if the address wasn't in the whitelist in the first place
282    */
283   function removeAddressFromWhitelist(address _operator)
284     onlyOwner
285     public
286   {
287     removeRole(_operator, ROLE_WHITELISTED);
288   }
289 
290   /**
291    * @dev remove addresses from the whitelist
292    * @param _operators addresses
293    * @return true if at least one address was removed from the whitelist,
294    * false if all addresses weren't in the whitelist in the first place
295    */
296   function removeAddressesFromWhitelist(address[] _operators)
297     onlyOwner
298     public
299   {
300     for (uint256 i = 0; i < _operators.length; i++) {
301       removeAddressFromWhitelist(_operators[i]);
302     }
303   }
304 
305 }
306 
307 /**
308  * @title ERC20Basic
309  * @dev Simpler version of ERC20 interface
310  * See https://github.com/ethereum/EIPs/issues/179
311  */
312 contract ERC20Basic {
313   function totalSupply() public view returns (uint256);
314   function balanceOf(address who) public view returns (uint256);
315   function transfer(address to, uint256 value) public returns (bool);
316   event Transfer(address indexed from, address indexed to, uint256 value);
317 }
318 
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure.
322  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
323  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
324  */
325 library SafeERC20 {
326   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
327     require(token.transfer(to, value));
328   }
329 
330   function safeTransferFrom(
331     ERC20 token,
332     address from,
333     address to,
334     uint256 value
335   )
336     internal
337   {
338     require(token.transferFrom(from, to, value));
339   }
340 
341   function safeApprove(ERC20 token, address spender, uint256 value) internal {
342     require(token.approve(spender, value));
343   }
344 }
345 
346 /**
347  * @title ERC20 interface
348  * @dev see https://github.com/ethereum/EIPs/issues/20
349  */
350 contract ERC20 is ERC20Basic {
351   function allowance(address owner, address spender)
352     public view returns (uint256);
353 
354   function transferFrom(address from, address to, uint256 value)
355     public returns (bool);
356 
357   function approve(address spender, uint256 value) public returns (bool);
358   event Approval(
359     address indexed owner,
360     address indexed spender,
361     uint256 value
362   );
363 }
364 
365 contract HasNoContracts is Ownable {
366 
367   /**
368    * @dev Reclaim ownership of Ownable contracts
369    * @param contractAddr The address of the Ownable to be reclaimed.
370    */
371   function reclaimContract(address contractAddr) external onlyOwner {
372     Ownable contractInst = Ownable(contractAddr);
373     contractInst.transferOwnership(owner);
374   }
375 }
376 
377 /**
378  * @title Contracts that should be able to recover tokens
379  * @author SylTi
380  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
381  * This will prevent any accidental loss of tokens.
382  */
383 contract CanReclaimToken is Ownable {
384   using SafeERC20 for ERC20Basic;
385 
386   /**
387    * @dev Reclaim all ERC20Basic compatible tokens
388    * @param token ERC20Basic The address of the token contract
389    */
390   function reclaimToken(ERC20Basic token) external onlyOwner {
391     uint256 balance = token.balanceOf(this);
392     token.safeTransfer(owner, balance);
393   }
394 
395 }
396 
397 /**
398  * @title Contracts that should not own Ether
399  * @author Remco Bloemen <remco@2π.com>
400  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
401  * in the contract, it will allow the owner to reclaim this ether.
402  * @notice Ether can still be sent to this contract by:
403  * calling functions labeled `payable`
404  * `selfdestruct(contract_address)`
405  * mining directly to the contract address
406  */
407 contract HasNoEther is Ownable {
408 
409   /**
410   * @dev Constructor that rejects incoming Ether
411   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
412   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
413   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
414   * we could use assembly to access msg.value.
415   */
416   constructor() public payable {
417     require(msg.value == 0);
418   }
419 
420   /**
421    * @dev Disallows direct send by settings a default function without the `payable` flag.
422    */
423   function() external {
424   }
425 
426   /**
427    * @dev Transfer all Ether held by the contract to the owner.
428    */
429   function reclaimEther() external onlyOwner {
430     owner.transfer(address(this).balance);
431   }
432 }
433 
434 /**
435  * @title Contracts that should not own Tokens
436  * @author Remco Bloemen <remco@2π.com>
437  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
438  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
439  * owner to reclaim the tokens.
440  */
441 contract HasNoTokens is CanReclaimToken {
442 
443  /**
444   * @dev Reject all ERC223 compatible tokens
445   * @param from_ address The address that is transferring the tokens
446   * @param value_ uint256 the amount of the specified token
447   * @param data_ Bytes The data passed from the caller.
448   */
449   function tokenFallback(address from_, uint256 value_, bytes data_) external {
450     from_;
451     value_;
452     data_;
453     revert();
454   }
455 
456 }
457 
458 /**
459  * @title Base contract for contracts that should not own things.
460  * @author Remco Bloemen <remco@2π.com>
461  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
462  * Owned contracts. See respective base contracts for details.
463  */
464 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
465 }
466 
467 /**
468  * @title InAndOut
469  * @dev InAndOut est un contract simulant le processus de vente d'un bien immobilier.
470  * Le propriétaire du contrat (eg le notaire du vendeur) est chargé de signifier l'avancement du processus de vente
471  * ainsi que de whitelister les différents intervenants qui pourront ancrer les documents nécessaires à la vente.
472  * Chacun peut librement suivre l'avancement du processus.
473  */
474 contract InAndOut is Whitelist, NoOwner {
475 
476     /**
477      * Le propriétaire du contrat trace le processus de vente en incrémentant la variable `processStep` de 0 jusqu'à 6 selon la table suivante
478      * Step 0: Initialisation
479      * Step 1: Remise d'offres
480      * Step 2: Due diligence
481      * Step 3: Négociation
482      * Step 4: Période sous promesse
483      * Step 5: Vente du bien
484      * Step 6: Transaction terminée
485      */
486     uint8 public processStep;
487 
488     // Mapping utilisé pour ancrer l'empreinte de documents lors du processus de vente
489     mapping(bytes32 => bool) public anchors;
490 
491     // Évènement émis lors de l'ancrage de documents
492     event NewAnchor(bytes32 merkleRoot);
493 
494     /**
495      * @dev Fonction appelés par le propriétaire du contrat pour passer à l'étape suivante du processus de vente
496      */
497     function goToNextStep() onlyOwner public {
498         require(processStep < 6);
499         processStep++;
500     }
501 
502     /**
503      * @dev Vérifier si la vente est validée
504      * @return Vrai si et seulement si la vente est validée
505      */
506     function isClosedAndValid() public view returns (bool) {
507         return processStep == 6;
508     }
509 
510     /**
511      * @dev Sauvegarder un document ou un ensemble de documents identifié(s) par le hash de la racine de l'arbre de Merkle associé
512      * @param _merkleRoot bytes32 Empreinte à ancrer
513      */
514     function saveNewAnchor(bytes32 _merkleRoot) onlyIfWhitelisted(msg.sender) public {
515         require(processStep < 6);
516         anchors[_merkleRoot] = true;
517         emit NewAnchor(_merkleRoot);
518     }
519 }