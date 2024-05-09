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
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * See https://github.com/ethereum/EIPs/issues/179
69  */
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender)
83     public view returns (uint256);
84 
85   function transferFrom(address from, address to, uint256 value)
86     public returns (bool);
87 
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(
90     address indexed owner,
91     address indexed spender,
92     uint256 value
93   );
94 }
95 
96 /**
97  * @title Contracts that should not own Ether
98  * @author Remco Bloemen <remco@2π.com>
99  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
100  * in the contract, it will allow the owner to reclaim this ether.
101  * @notice Ether can still be sent to this contract by:
102  * calling functions labeled `payable`
103  * `selfdestruct(contract_address)`
104  * mining directly to the contract address
105  */
106 contract HasNoEther is Ownable {
107 
108   /**
109   * @dev Constructor that rejects incoming Ether
110   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
111   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
112   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
113   * we could use assembly to access msg.value.
114   */
115   constructor() public payable {
116     require(msg.value == 0);
117   }
118 
119   /**
120    * @dev Disallows direct send by settings a default function without the `payable` flag.
121    */
122   function() external {
123   }
124 
125   /**
126    * @dev Transfer all Ether held by the contract to the owner.
127    */
128   function reclaimEther() external onlyOwner {
129     owner.transfer(address(this).balance);
130   }
131 }
132 
133 /**
134  * @title SafeERC20
135  * @dev Wrappers around ERC20 operations that throw on failure.
136  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
137  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
138  */
139 library SafeERC20 {
140   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
141     require(token.transfer(to, value));
142   }
143 
144   function safeTransferFrom(
145     ERC20 token,
146     address from,
147     address to,
148     uint256 value
149   )
150     internal
151   {
152     require(token.transferFrom(from, to, value));
153   }
154 
155   function safeApprove(ERC20 token, address spender, uint256 value) internal {
156     require(token.approve(spender, value));
157   }
158 }
159 
160 /**
161  * @title Contracts that should be able to recover tokens
162  * @author SylTi
163  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
164  * This will prevent any accidental loss of tokens.
165  */
166 contract CanReclaimToken is Ownable {
167   using SafeERC20 for ERC20Basic;
168 
169   /**
170    * @dev Reclaim all ERC20Basic compatible tokens
171    * @param token ERC20Basic The address of the token contract
172    */
173   function reclaimToken(ERC20Basic token) external onlyOwner {
174     uint256 balance = token.balanceOf(this);
175     token.safeTransfer(owner, balance);
176   }
177 
178 }
179 
180 /**
181  * @title Contracts that should not own Tokens
182  * @author Remco Bloemen <remco@2π.com>
183  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
184  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
185  * owner to reclaim the tokens.
186  */
187 contract HasNoTokens is CanReclaimToken {
188 
189  /**
190   * @dev Reject all ERC223 compatible tokens
191   * @param from_ address The address that is transferring the tokens
192   * @param value_ uint256 the amount of the specified token
193   * @param data_ Bytes The data passed from the caller.
194   */
195   function tokenFallback(address from_, uint256 value_, bytes data_) external {
196     from_;
197     value_;
198     data_;
199     revert();
200   }
201 
202 }
203 
204 /**
205  * @title Contracts that should not own Contracts
206  * @author Remco Bloemen <remco@2π.com>
207  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
208  * of this contract to reclaim ownership of the contracts.
209  */
210 contract HasNoContracts is Ownable {
211 
212   /**
213    * @dev Reclaim ownership of Ownable contracts
214    * @param contractAddr The address of the Ownable to be reclaimed.
215    */
216   function reclaimContract(address contractAddr) external onlyOwner {
217     Ownable contractInst = Ownable(contractAddr);
218     contractInst.transferOwnership(owner);
219   }
220 }
221 
222 /**
223  * @title Base contract for contracts that should not own things.
224  * @author Remco Bloemen <remco@2π.com>
225  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
226  * Owned contracts. See respective base contracts for details.
227  */
228 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
229 }
230 
231 /*
232  * @title MerkleProof
233  * @dev Merkle proof verification based on
234  * https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
235  */
236 library MerkleProof {
237   /*
238    * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
239    * and each pair of pre-images is sorted.
240    * @param _proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
241    * @param _root Merkle root
242    * @param _leaf Leaf of Merkle tree
243    */
244   function verifyProof(
245     bytes32[] _proof,
246     bytes32 _root,
247     bytes32 _leaf
248   )
249     internal
250     pure
251     returns (bool)
252   {
253     bytes32 computedHash = _leaf;
254 
255     for (uint256 i = 0; i < _proof.length; i++) {
256       bytes32 proofElement = _proof[i];
257 
258       if (computedHash < proofElement) {
259         // Hash(current computed hash + current element of the proof)
260         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
261       } else {
262         // Hash(current element of the proof + current computed hash)
263         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
264       }
265     }
266 
267     // Check if the computed hash (root) is equal to the provided root
268     return computedHash == _root;
269   }
270 }
271 
272 /**
273  * @title Pausable
274  * @dev Base contract which allows children to implement an emergency stop mechanism.
275  */
276 contract Pausable is Ownable {
277   event Pause();
278   event Unpause();
279 
280   bool public paused = false;
281 
282 
283   /**
284    * @dev Modifier to make a function callable only when the contract is not paused.
285    */
286   modifier whenNotPaused() {
287     require(!paused);
288     _;
289   }
290 
291   /**
292    * @dev Modifier to make a function callable only when the contract is paused.
293    */
294   modifier whenPaused() {
295     require(paused);
296     _;
297   }
298 
299   /**
300    * @dev called by the owner to pause, triggers stopped state
301    */
302   function pause() onlyOwner whenNotPaused public {
303     paused = true;
304     emit Pause();
305   }
306 
307   /**
308    * @dev called by the owner to unpause, returns to normal state
309    */
310   function unpause() onlyOwner whenPaused public {
311     paused = false;
312     emit Unpause();
313   }
314 }
315 
316 /**
317  * @title Roles
318  * @author Francisco Giordano (@frangio)
319  * @dev Library for managing addresses assigned to a Role.
320  * See RBAC.sol for example usage.
321  */
322 library Roles {
323   struct Role {
324     mapping (address => bool) bearer;
325   }
326 
327   /**
328    * @dev give an address access to this role
329    */
330   function add(Role storage role, address addr)
331     internal
332   {
333     role.bearer[addr] = true;
334   }
335 
336   /**
337    * @dev remove an address' access to this role
338    */
339   function remove(Role storage role, address addr)
340     internal
341   {
342     role.bearer[addr] = false;
343   }
344 
345   /**
346    * @dev check if an address has this role
347    * // reverts
348    */
349   function check(Role storage role, address addr)
350     view
351     internal
352   {
353     require(has(role, addr));
354   }
355 
356   /**
357    * @dev check if an address has this role
358    * @return bool
359    */
360   function has(Role storage role, address addr)
361     view
362     internal
363     returns (bool)
364   {
365     return role.bearer[addr];
366   }
367 }
368 
369 /**
370  * @title RBAC (Role-Based Access Control)
371  * @author Matt Condon (@Shrugs)
372  * @dev Stores and provides setters and getters for roles and addresses.
373  * Supports unlimited numbers of roles and addresses.
374  * See //contracts/mocks/RBACMock.sol for an example of usage.
375  * This RBAC method uses strings to key roles. It may be beneficial
376  * for you to write your own implementation of this interface using Enums or similar.
377  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
378  * to avoid typos.
379  */
380 contract RBAC {
381   using Roles for Roles.Role;
382 
383   mapping (string => Roles.Role) private roles;
384 
385   event RoleAdded(address indexed operator, string role);
386   event RoleRemoved(address indexed operator, string role);
387 
388   /**
389    * @dev reverts if addr does not have role
390    * @param _operator address
391    * @param _role the name of the role
392    * // reverts
393    */
394   function checkRole(address _operator, string _role)
395     view
396     public
397   {
398     roles[_role].check(_operator);
399   }
400 
401   /**
402    * @dev determine if addr has role
403    * @param _operator address
404    * @param _role the name of the role
405    * @return bool
406    */
407   function hasRole(address _operator, string _role)
408     view
409     public
410     returns (bool)
411   {
412     return roles[_role].has(_operator);
413   }
414 
415   /**
416    * @dev add a role to an address
417    * @param _operator address
418    * @param _role the name of the role
419    */
420   function addRole(address _operator, string _role)
421     internal
422   {
423     roles[_role].add(_operator);
424     emit RoleAdded(_operator, _role);
425   }
426 
427   /**
428    * @dev remove a role from an address
429    * @param _operator address
430    * @param _role the name of the role
431    */
432   function removeRole(address _operator, string _role)
433     internal
434   {
435     roles[_role].remove(_operator);
436     emit RoleRemoved(_operator, _role);
437   }
438 
439   /**
440    * @dev modifier to scope access to a single role (uses msg.sender as addr)
441    * @param _role the name of the role
442    * // reverts
443    */
444   modifier onlyRole(string _role)
445   {
446     checkRole(msg.sender, _role);
447     _;
448   }
449 
450   /**
451    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
452    * @param _roles the names of the roles to scope access to
453    * // reverts
454    *
455    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
456    *  see: https://github.com/ethereum/solidity/issues/2467
457    */
458   // modifier onlyRoles(string[] _roles) {
459   //     bool hasAnyRole = false;
460   //     for (uint8 i = 0; i < _roles.length; i++) {
461   //         if (hasRole(msg.sender, _roles[i])) {
462   //             hasAnyRole = true;
463   //             break;
464   //         }
465   //     }
466 
467   //     require(hasAnyRole);
468 
469   //     _;
470   // }
471 }
472 
473 /**
474  * @title Whitelist
475  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
476  * This simplifies the implementation of "user permissions".
477  */
478 contract Whitelist is Ownable, RBAC {
479   string public constant ROLE_WHITELISTED = "whitelist";
480 
481   /**
482    * @dev Throws if operator is not whitelisted.
483    * @param _operator address
484    */
485   modifier onlyIfWhitelisted(address _operator) {
486     checkRole(_operator, ROLE_WHITELISTED);
487     _;
488   }
489 
490   /**
491    * @dev add an address to the whitelist
492    * @param _operator address
493    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
494    */
495   function addAddressToWhitelist(address _operator)
496     onlyOwner
497     public
498   {
499     addRole(_operator, ROLE_WHITELISTED);
500   }
501 
502   /**
503    * @dev getter to determine if address is in whitelist
504    */
505   function whitelist(address _operator)
506     public
507     view
508     returns (bool)
509   {
510     return hasRole(_operator, ROLE_WHITELISTED);
511   }
512 
513   /**
514    * @dev add addresses to the whitelist
515    * @param _operators addresses
516    * @return true if at least one address was added to the whitelist,
517    * false if all addresses were already in the whitelist
518    */
519   function addAddressesToWhitelist(address[] _operators)
520     onlyOwner
521     public
522   {
523     for (uint256 i = 0; i < _operators.length; i++) {
524       addAddressToWhitelist(_operators[i]);
525     }
526   }
527 
528   /**
529    * @dev remove an address from the whitelist
530    * @param _operator address
531    * @return true if the address was removed from the whitelist,
532    * false if the address wasn't in the whitelist in the first place
533    */
534   function removeAddressFromWhitelist(address _operator)
535     onlyOwner
536     public
537   {
538     removeRole(_operator, ROLE_WHITELISTED);
539   }
540 
541   /**
542    * @dev remove addresses from the whitelist
543    * @param _operators addresses
544    * @return true if at least one address was removed from the whitelist,
545    * false if all addresses weren't in the whitelist in the first place
546    */
547   function removeAddressesFromWhitelist(address[] _operators)
548     onlyOwner
549     public
550   {
551     for (uint256 i = 0; i < _operators.length; i++) {
552       removeAddressFromWhitelist(_operators[i]);
553     }
554   }
555 
556 }
557 
558 contract MerkleDrops is Pausable, Whitelist {
559 
560   bytes32 public rootHash;
561   ERC20 public token;
562   mapping(bytes32 => bool) public redeemed;
563 
564   constructor(bytes32 _rootHash, address _tokenAddress) {
565     rootHash = _rootHash;
566     token = ERC20(_tokenAddress);
567     super.addAddressToWhitelist(msg.sender);
568   }
569 
570   function constructLeaf(uint256 index, address recipient, uint256 amount) constant returns(bytes32) {
571     bytes32 node = keccak256(abi.encodePacked(index, recipient, amount));
572     return node;
573   }
574 
575   function isProofValid(bytes32[] _proof, bytes32 _node) public constant returns(bool){
576     bool isValid = MerkleProof.verifyProof(_proof, rootHash, _node);
577     return isValid;
578   }
579 
580   function redeemTokens(uint256 index , uint256 amount, bytes32[] _proof) whenNotPaused public returns(bool) {
581     bytes32 node = constructLeaf(index, msg.sender, amount);
582     require(!redeemed[node]);
583     require(isProofValid(_proof, node));
584     redeemed[node] = true;
585     token.transfer(msg.sender, amount);
586   }
587 
588   function withdrawTokens(ERC20 _token) public onlyIfWhitelisted(msg.sender) {
589     token.transfer(msg.sender, _token.balanceOf(this));
590   }
591 
592   function changeRoot(bytes32 _rootHash) public onlyIfWhitelisted(msg.sender) {
593     rootHash = _rootHash;
594   }
595 }