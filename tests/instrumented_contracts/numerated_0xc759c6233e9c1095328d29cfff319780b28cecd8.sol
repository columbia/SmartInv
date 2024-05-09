1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.1;
3 
4 /**
5  * @title Linked to ILV Marker Interface
6  *
7  * @notice Marks smart contracts which are linked to IlluviumERC20 token instance upon construction,
8  *      all these smart contracts share a common ilv() address getter
9  *
10  * @notice Implementing smart contracts MUST verify that they get linked to real IlluviumERC20 instance
11  *      and that ilv() getter returns this very same instance address
12  *
13  * @author Basil Gorin
14  */
15 interface ILinkedToILV {
16   /**
17    * @notice Getter for a verified IlluviumERC20 instance address
18    *
19    * @return IlluviumERC20 token instance address smart contract is linked to
20    */
21   function ilv() external view returns (address);
22 }
23 
24 /**
25  * @title Illuvium Pool
26  *
27  * @notice An abstraction representing a pool, see IlluviumPoolBase for details
28  *
29  * @author Pedro Bergamini, reviewed by Basil Gorin
30  */
31 interface IPool is ILinkedToILV {
32   /**
33    * @dev Deposit is a key data structure used in staking,
34    *      it represents a unit of stake with its amount, weight and term (time interval)
35    */
36   struct Deposit {
37     // @dev token amount staked
38     uint256 tokenAmount;
39     // @dev stake weight
40     uint256 weight;
41     // @dev locking period - from
42     uint64 lockedFrom;
43     // @dev locking period - until
44     uint64 lockedUntil;
45     // @dev indicates if the stake was created as a yield reward
46     bool isYield;
47   }
48 
49   // for the rest of the functions see Soldoc in IlluviumPoolBase
50 
51   function silv() external view returns (address);
52 
53   function poolToken() external view returns (address);
54 
55   function isFlashPool() external view returns (bool);
56 
57   function weight() external view returns (uint32);
58 
59   function lastYieldDistribution() external view returns (uint64);
60 
61   function yieldRewardsPerWeight() external view returns (uint256);
62 
63   function usersLockingWeight() external view returns (uint256);
64 
65   function pendingYieldRewards(address _user) external view returns (uint256);
66 
67   function balanceOf(address _user) external view returns (uint256);
68 
69   function getDeposit(address _user, uint256 _depositId) external view returns (Deposit memory);
70 
71   function getDepositsLength(address _user) external view returns (uint256);
72 
73   function stake(
74     uint256 _amount,
75     uint64 _lockedUntil,
76     bool useSILV
77   ) external;
78 
79   function unstake(
80     uint256 _depositId,
81     uint256 _amount,
82     bool useSILV
83   ) external;
84 
85   function sync() external;
86 
87   function processRewards(bool useSILV) external;
88 
89   function setWeight(uint32 _weight) external;
90 }
91 
92 interface ICorePool is IPool {
93   function vaultRewardsPerToken() external view returns (uint256);
94 
95   function poolTokenReserve() external view returns (uint256);
96 
97   function stakeAsPool(address _staker, uint256 _amount) external;
98 
99   function receiveVaultRewards(uint256 _amount) external;
100 }
101 
102 /**
103  * @dev Contract module that helps prevent reentrant calls to a function.
104  *
105  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
106  * available, which can be applied to functions to make sure there are no nested
107  * (reentrant) calls to them.
108  *
109  * Note that because there is a single `nonReentrant` guard, functions marked as
110  * `nonReentrant` may not call one another. This can be worked around by making
111  * those functions `private`, and then adding `external` `nonReentrant` entry
112  * points to them.
113  *
114  * TIP: If you would like to learn more about reentrancy and alternative ways
115  * to protect against it, check out our blog post
116  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
117  */
118 abstract contract ReentrancyGuard {
119   // Booleans are more expensive than uint256 or any type that takes up a full
120   // word because each write operation emits an extra SLOAD to first read the
121   // slot's contents, replace the bits taken up by the boolean, and then write
122   // back. This is the compiler's defense against contract upgrades and
123   // pointer aliasing, and it cannot be disabled.
124 
125   // The values being non-zero value makes deployment a bit more expensive,
126   // but in exchange the refund on every call to nonReentrant will be lower in
127   // amount. Since refunds are capped to a percentage of the total
128   // transaction's gas, it is best to keep them low in cases like this one, to
129   // increase the likelihood of the full refund coming into effect.
130   uint256 private constant _NOT_ENTERED = 1;
131   uint256 private constant _ENTERED = 2;
132 
133   uint256 private _status;
134 
135   constructor () {
136     _status = _NOT_ENTERED;
137   }
138 
139   /**
140    * @dev Prevents a contract from calling itself, directly or indirectly.
141    * Calling a `nonReentrant` function from another `nonReentrant`
142    * function is not supported. It is possible to prevent this from happening
143    * by making the `nonReentrant` function external, and make it call a
144    * `private` function that does the actual work.
145    */
146   modifier nonReentrant() {
147     // On the first call to nonReentrant, _notEntered will be true
148     require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
149 
150     // Any calls to nonReentrant after this point will fail
151     _status = _ENTERED;
152 
153     _;
154 
155     // By storing the original value once again, a refund is triggered (see
156     // https://eips.ethereum.org/EIPS/eip-2200)
157     _status = _NOT_ENTERED;
158   }
159 }
160 
161 /**
162  * @dev Contract module which provides a basic access control mechanism, where
163  * there is an account (an owner) that can be granted exclusive access to
164  * specific functions.
165  *
166  * By default, the owner account will be the one that deploys the contract. This
167  * can later be changed with {transferOwnership}.
168  *
169  * This module is used through inheritance. It will make available the modifier
170  * `onlyOwner`, which can be applied to your functions to restrict their use to
171  * the owner.
172  */
173 abstract contract Ownable {
174   address private _owner;
175 
176   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178   /**
179    * @dev Initializes the contract setting the deployer as the initial owner.
180    */
181   constructor() {
182     address msgSender = msg.sender;
183     _owner = msgSender;
184     emit OwnershipTransferred(address(0), msgSender);
185   }
186 
187   /**
188    * @dev Returns the address of the current owner.
189    */
190   function owner() public view virtual returns (address) {
191     return _owner;
192   }
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(owner() == msg.sender, "Ownable: caller is not the owner");
199     _;
200   }
201 
202   /**
203    * @dev Leaves the contract without owner. It will not be possible to call
204    * `onlyOwner` functions anymore. Can only be called by the current owner.
205    *
206    * NOTE: Renouncing ownership will leave the contract without an owner,
207    * thereby removing any functionality that is only available to the owner.
208    */
209   function renounceOwnership() public virtual onlyOwner {
210     emit OwnershipTransferred(_owner, address(0));
211     _owner = address(0);
212   }
213 
214   /**
215    * @dev Transfers ownership of the contract to a new account (`newOwner`).
216    * Can only be called by the current owner.
217    */
218   function transferOwnership(address newOwner) public virtual onlyOwner {
219     require(newOwner != address(0), "Ownable: new owner is the zero address");
220     emit OwnershipTransferred(_owner, newOwner);
221     _owner = newOwner;
222   }
223 }
224 
225 /**
226  * @title Address Utils
227  *
228  * @dev Utility library of inline functions on addresses
229  *
230  * @author Basil Gorin
231  */
232 library AddressUtils {
233 
234   /**
235    * @notice Checks if the target address is a contract
236    * @dev This function will return false if invoked during the constructor of a contract,
237    *      as the code is not actually created until after the constructor finishes.
238    * @param addr address to check
239    * @return whether the target address is a contract
240    */
241   function isContract(address addr) internal view returns (bool) {
242     // a variable to load `extcodesize` to
243     uint256 size = 0;
244 
245     // XXX Currently there is no better way to check if there is a contract in an address
246     // than to check the size of the code at that address.
247     // See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
248     // TODO: Check this again before the Serenity release, because all addresses will be contracts.
249     // solium-disable-next-line security/no-inline-assembly
250     assembly {
251     // retrieve the size of the code at address `addr`
252       size := extcodesize(addr)
253     }
254 
255     // positive size indicates a smart contract address
256     return size > 0;
257   }
258 
259 }
260 
261 /**
262  * @title ERC20 token receiver interface
263  *
264  * @dev Interface for any contract that wants to support safe transfers
265  *      from ERC20 token smart contracts.
266  * @dev Inspired by ERC721 and ERC223 token standards
267  *
268  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
269  * @dev See https://github.com/ethereum/EIPs/issues/223
270  *
271  * @author Basil Gorin
272  */
273 interface ERC20Receiver {
274   /**
275    * @notice Handle the receipt of a ERC20 token(s)
276    * @dev The ERC20 smart contract calls this function on the recipient
277    *      after a successful transfer (`safeTransferFrom`).
278    *      This function MAY throw to revert and reject the transfer.
279    *      Return of other than the magic value MUST result in the transaction being reverted.
280    * @notice The contract address is always the message sender.
281    *      A wallet/broker/auction application MUST implement the wallet interface
282    *      if it will accept safe transfers.
283    * @param _operator The address which called `safeTransferFrom` function
284    * @param _from The address which previously owned the token
285    * @param _value amount of tokens which is being transferred
286    * @param _data additional data with no specified format
287    * @return `bytes4(keccak256("onERC20Received(address,address,uint256,bytes)"))` unless throwing
288    */
289   function onERC20Received(address _operator, address _from, uint256 _value, bytes calldata _data) external returns(bytes4);
290 }
291 
292 /**
293  * @title Access Control List
294  *
295  * @notice Access control smart contract provides an API to check
296  *      if specific operation is permitted globally and/or
297  *      if particular user has a permission to execute it.
298  *
299  * @notice It deals with two main entities: features and roles.
300  *
301  * @notice Features are designed to be used to enable/disable specific
302  *      functions (public functions) of the smart contract for everyone.
303  * @notice User roles are designed to restrict access to specific
304  *      functions (restricted functions) of the smart contract to some users.
305  *
306  * @notice Terms "role", "permissions" and "set of permissions" have equal meaning
307  *      in the documentation text and may be used interchangeably.
308  * @notice Terms "permission", "single permission" implies only one permission bit set.
309  *
310  * @dev This smart contract is designed to be inherited by other
311  *      smart contracts which require access control management capabilities.
312  *
313  * @author Basil Gorin
314  */
315 contract AccessControl {
316   /**
317    * @notice Access manager is responsible for assigning the roles to users,
318    *      enabling/disabling global features of the smart contract
319    * @notice Access manager can add, remove and update user roles,
320    *      remove and update global features
321    *
322    * @dev Role ROLE_ACCESS_MANAGER allows modifying user roles and global features
323    * @dev Role ROLE_ACCESS_MANAGER has single bit at position 255 enabled
324    */
325   uint256 public constant ROLE_ACCESS_MANAGER = 0x8000000000000000000000000000000000000000000000000000000000000000;
326 
327   /**
328    * @dev Bitmask representing all the possible permissions (super admin role)
329    * @dev Has all the bits are enabled (2^256 - 1 value)
330    */
331   uint256 private constant FULL_PRIVILEGES_MASK = type(uint256).max; // before 0.8.0: uint256(-1) overflows to 0xFFFF...
332 
333   /**
334    * @notice Privileged addresses with defined roles/permissions
335    * @notice In the context of ERC20/ERC721 tokens these can be permissions to
336    *      allow minting or burning tokens, transferring on behalf and so on
337    *
338    * @dev Maps user address to the permissions bitmask (role), where each bit
339    *      represents a permission
340    * @dev Bitmask 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
341    *      represents all possible permissions
342    * @dev Zero address mapping represents global features of the smart contract
343    */
344   mapping(address => uint256) public userRoles;
345 
346   /**
347    * @dev Fired in updateRole() and updateFeatures()
348    *
349    * @param _by operator which called the function
350    * @param _to address which was granted/revoked permissions
351    * @param _requested permissions requested
352    * @param _actual permissions effectively set
353    */
354   event RoleUpdated(address indexed _by, address indexed _to, uint256 _requested, uint256 _actual);
355 
356   /**
357    * @notice Creates an access control instance,
358    *      setting contract creator to have full privileges
359    */
360   constructor() {
361     // contract creator has full privileges
362     userRoles[msg.sender] = FULL_PRIVILEGES_MASK;
363   }
364 
365   /**
366    * @notice Retrieves globally set of features enabled
367    *
368    * @dev Auxiliary getter function to maintain compatibility with previous
369    *      versions of the Access Control List smart contract, where
370    *      features was a separate uint256 public field
371    *
372    * @return 256-bit bitmask of the features enabled
373    */
374   function features() public view returns(uint256) {
375     // according to new design features are stored in zero address
376     // mapping of `userRoles` structure
377     return userRoles[address(0)];
378   }
379 
380   /**
381    * @notice Updates set of the globally enabled features (`features`),
382    *      taking into account sender's permissions
383    *
384    * @dev Requires transaction sender to have `ROLE_ACCESS_MANAGER` permission
385    * @dev Function is left for backward compatibility with older versions
386    *
387    * @param _mask bitmask representing a set of features to enable/disable
388    */
389   function updateFeatures(uint256 _mask) public {
390     // delegate call to `updateRole`
391     updateRole(address(0), _mask);
392   }
393 
394   /**
395    * @notice Updates set of permissions (role) for a given user,
396    *      taking into account sender's permissions.
397    *
398    * @dev Setting role to zero is equivalent to removing an all permissions
399    * @dev Setting role to `FULL_PRIVILEGES_MASK` is equivalent to
400    *      copying senders' permissions (role) to the user
401    * @dev Requires transaction sender to have `ROLE_ACCESS_MANAGER` permission
402    *
403    * @param operator address of a user to alter permissions for or zero
404    *      to alter global features of the smart contract
405    * @param role bitmask representing a set of permissions to
406    *      enable/disable for a user specified
407    */
408   function updateRole(address operator, uint256 role) public {
409     // caller must have a permission to update user roles
410     require(isSenderInRole(ROLE_ACCESS_MANAGER), "insufficient privileges (ROLE_ACCESS_MANAGER required)");
411 
412     // evaluate the role and reassign it
413     userRoles[operator] = evaluateBy(msg.sender, userRoles[operator], role);
414 
415     // fire an event
416     emit RoleUpdated(msg.sender, operator, role, userRoles[operator]);
417   }
418 
419   /**
420    * @notice Determines the permission bitmask an operator can set on the
421    *      target permission set
422    * @notice Used to calculate the permission bitmask to be set when requested
423    *     in `updateRole` and `updateFeatures` functions
424    *
425    * @dev Calculated based on:
426    *      1) operator's own permission set read from userRoles[operator]
427    *      2) target permission set - what is already set on the target
428    *      3) desired permission set - what do we want set target to
429    *
430    * @dev Corner cases:
431    *      1) Operator is super admin and its permission set is `FULL_PRIVILEGES_MASK`:
432    *        `desired` bitset is returned regardless of the `target` permission set value
433    *        (what operator sets is what they get)
434    *      2) Operator with no permissions (zero bitset):
435    *        `target` bitset is returned regardless of the `desired` value
436    *        (operator has no authority and cannot modify anything)
437    *
438    * @dev Example:
439    *      Consider an operator with the permissions bitmask     00001111
440    *      is about to modify the target permission set          01010101
441    *      Operator wants to set that permission set to          00110011
442    *      Based on their role, an operator has the permissions
443    *      to update only lowest 4 bits on the target, meaning that
444    *      high 4 bits of the target set in this example is left
445    *      unchanged and low 4 bits get changed as desired:      01010011
446    *
447    * @param operator address of the contract operator which is about to set the permissions
448    * @param target input set of permissions to operator is going to modify
449    * @param desired desired set of permissions operator would like to set
450    * @return resulting set of permissions given operator will set
451    */
452   function evaluateBy(address operator, uint256 target, uint256 desired) public view returns(uint256) {
453     // read operator's permissions
454     uint256 p = userRoles[operator];
455 
456     // taking into account operator's permissions,
457     // 1) enable the permissions desired on the `target`
458     target |= p & desired;
459     // 2) disable the permissions desired on the `target`
460     target &= FULL_PRIVILEGES_MASK ^ (p & (FULL_PRIVILEGES_MASK ^ desired));
461 
462     // return calculated result
463     return target;
464   }
465 
466   /**
467    * @notice Checks if requested set of features is enabled globally on the contract
468    *
469    * @param required set of features to check against
470    * @return true if all the features requested are enabled, false otherwise
471    */
472   function isFeatureEnabled(uint256 required) public view returns(bool) {
473     // delegate call to `__hasRole`, passing `features` property
474     return __hasRole(features(), required);
475   }
476 
477   /**
478    * @notice Checks if transaction sender `msg.sender` has all the permissions required
479    *
480    * @param required set of permissions (role) to check against
481    * @return true if all the permissions requested are enabled, false otherwise
482    */
483   function isSenderInRole(uint256 required) public view returns(bool) {
484     // delegate call to `isOperatorInRole`, passing transaction sender
485     return isOperatorInRole(msg.sender, required);
486   }
487 
488   /**
489    * @notice Checks if operator has all the permissions (role) required
490    *
491    * @param operator address of the user to check role for
492    * @param required set of permissions (role) to check
493    * @return true if all the permissions requested are enabled, false otherwise
494    */
495   function isOperatorInRole(address operator, uint256 required) public view returns(bool) {
496     // delegate call to `__hasRole`, passing operator's permissions (role)
497     return __hasRole(userRoles[operator], required);
498   }
499 
500   /**
501    * @dev Checks if role `actual` contains all the permissions required `required`
502    *
503    * @param actual existent role
504    * @param required required role
505    * @return true if actual has required role (all permissions), false otherwise
506    */
507   function __hasRole(uint256 actual, uint256 required) internal pure returns(bool) {
508     // check the bitmask for the role required and return the result
509     return actual & required == required;
510   }
511 }
512 
513 /**
514  * @title Illuvium (ILV) ERC20 token
515  *
516  * @notice Illuvium is a core ERC20 token powering the game.
517  *      It serves as an in-game currency, is tradable on exchanges,
518  *      it powers up the governance protocol (Illuvium DAO) and participates in Yield Farming.
519  *
520  * @dev Token Summary:
521  *      - Symbol: ILV
522  *      - Name: Illuvium
523  *      - Decimals: 18
524  *      - Initial token supply: 7,000,000 ILV
525  *      - Maximum final token supply: 10,000,000 ILV
526  *          - Up to 3,000,000 ILV may get minted in 3 years period via yield farming
527  *      - Mintable: total supply may increase
528  *      - Burnable: total supply may decrease
529  *
530  * @dev Token balances and total supply are effectively 192 bits long, meaning that maximum
531  *      possible total supply smart contract is able to track is 2^192 (close to 10^40 tokens)
532  *
533  * @dev Smart contract doesn't use safe math. All arithmetic operations are overflow/underflow safe.
534  *      Additionally, Solidity 0.8.1 enforces overflow/underflow safety.
535  *
536  * @dev ERC20: reviewed according to https://eips.ethereum.org/EIPS/eip-20
537  *
538  * @dev ERC20: contract has passed OpenZeppelin ERC20 tests,
539  *      see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/test/token/ERC20/ERC20.behavior.js
540  *      see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/test/token/ERC20/ERC20.test.js
541  *      see adopted copies of these tests in the `test` folder
542  *
543  * @dev ERC223/ERC777: not supported;
544  *      send tokens via `safeTransferFrom` and implement `ERC20Receiver.onERC20Received` on the receiver instead
545  *
546  * @dev Multiple Withdrawal Attack on ERC20 Tokens (ISBN:978-1-7281-3027-9) - resolved
547  *      Related events and functions are marked with "ISBN:978-1-7281-3027-9" tag:
548  *        - event Transferred(address indexed _by, address indexed _from, address indexed _to, uint256 _value)
549  *        - event Approved(address indexed _owner, address indexed _spender, uint256 _oldValue, uint256 _value)
550  *        - function increaseAllowance(address _spender, uint256 _value) public returns (bool)
551  *        - function decreaseAllowance(address _spender, uint256 _value) public returns (bool)
552  *      See: https://ieeexplore.ieee.org/document/8802438
553  *      See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
554  *
555  * @author Basil Gorin
556  */
557 contract IlluviumERC20 is AccessControl {
558   /**
559    * @dev Smart contract unique identifier, a random number
560    * @dev Should be regenerated each time smart contact source code is changed
561    *      and changes smart contract itself is to be redeployed
562    * @dev Generated using https://www.random.org/bytes/
563    */
564   uint256 public constant TOKEN_UID = 0x83ecb176af7c4f35a45ff0018282e3a05a1018065da866182df12285866f5a2c;
565 
566   /**
567    * @notice Name of the token: Illuvium
568    *
569    * @notice ERC20 name of the token (long name)
570    *
571    * @dev ERC20 `function name() public view returns (string)`
572    *
573    * @dev Field is declared public: getter name() is created when compiled,
574    *      it returns the name of the token.
575    */
576   string public constant name = "Illuvium";
577 
578   /**
579    * @notice Symbol of the token: ILV
580    *
581    * @notice ERC20 symbol of that token (short name)
582    *
583    * @dev ERC20 `function symbol() public view returns (string)`
584    *
585    * @dev Field is declared public: getter symbol() is created when compiled,
586    *      it returns the symbol of the token
587    */
588   string public constant symbol = "ILV";
589 
590   /**
591    * @notice Decimals of the token: 18
592    *
593    * @dev ERC20 `function decimals() public view returns (uint8)`
594    *
595    * @dev Field is declared public: getter decimals() is created when compiled,
596    *      it returns the number of decimals used to get its user representation.
597    *      For example, if `decimals` equals `6`, a balance of `1,500,000` tokens should
598    *      be displayed to a user as `1,5` (`1,500,000 / 10 ** 6`).
599    *
600    * @dev NOTE: This information is only used for _display_ purposes: it in
601    *      no way affects any of the arithmetic of the contract, including balanceOf() and transfer().
602    */
603   uint8 public constant decimals = 18;
604 
605   /**
606    * @notice Total supply of the token: initially 7,000,000,
607    *      with the potential to grow up to 10,000,000 during yield farming period (3 years)
608    *
609    * @dev ERC20 `function totalSupply() public view returns (uint256)`
610    *
611    * @dev Field is declared public: getter totalSupply() is created when compiled,
612    *      it returns the amount of tokens in existence.
613    */
614   uint256 public totalSupply; // is set to 7 million * 10^18 in the constructor
615 
616   /**
617    * @dev A record of all the token balances
618    * @dev This mapping keeps record of all token owners:
619    *      owner => balance
620    */
621   mapping(address => uint256) public tokenBalances;
622 
623   /**
624    * @notice A record of each account's voting delegate
625    *
626    * @dev Auxiliary data structure used to sum up an account's voting power
627    *
628    * @dev This mapping keeps record of all voting power delegations:
629    *      voting delegator (token owner) => voting delegate
630    */
631   mapping(address => address) public votingDelegates;
632 
633   /**
634    * @notice A voting power record binds voting power of a delegate to a particular
635    *      block when the voting power delegation change happened
636    */
637   struct VotingPowerRecord {
638     /*
639      * @dev block.number when delegation has changed; starting from
640      *      that block voting power value is in effect
641      */
642     uint64 blockNumber;
643 
644     /*
645      * @dev cumulative voting power a delegate has obtained starting
646      *      from the block stored in blockNumber
647      */
648     uint192 votingPower;
649   }
650 
651   /**
652    * @notice A record of each account's voting power
653    *
654    * @dev Primarily data structure to store voting power for each account.
655    *      Voting power sums up from the account's token balance and delegated
656    *      balances.
657    *
658    * @dev Stores current value and entire history of its changes.
659    *      The changes are stored as an array of checkpoints.
660    *      Checkpoint is an auxiliary data structure containing voting
661    *      power (number of votes) and block number when the checkpoint is saved
662    *
663    * @dev Maps voting delegate => voting power record
664    */
665   mapping(address => VotingPowerRecord[]) public votingPowerHistory;
666 
667   /**
668    * @dev A record of nonces for signing/validating signatures in `delegateWithSig`
669    *      for every delegate, increases after successful validation
670    *
671    * @dev Maps delegate address => delegate nonce
672    */
673   mapping(address => uint256) public nonces;
674 
675   /**
676    * @notice A record of all the allowances to spend tokens on behalf
677    * @dev Maps token owner address to an address approved to spend
678    *      some tokens on behalf, maps approved address to that amount
679    * @dev owner => spender => value
680    */
681   mapping(address => mapping(address => uint256)) public transferAllowances;
682 
683   /**
684    * @notice Enables ERC20 transfers of the tokens
685    *      (transfer by the token owner himself)
686    * @dev Feature FEATURE_TRANSFERS must be enabled in order for
687    *      `transfer()` function to succeed
688    */
689   uint32 public constant FEATURE_TRANSFERS = 0x0000_0001;
690 
691   /**
692    * @notice Enables ERC20 transfers on behalf
693    *      (transfer by someone else on behalf of token owner)
694    * @dev Feature FEATURE_TRANSFERS_ON_BEHALF must be enabled in order for
695    *      `transferFrom()` function to succeed
696    * @dev Token owner must call `approve()` first to authorize
697    *      the transfer on behalf
698    */
699   uint32 public constant FEATURE_TRANSFERS_ON_BEHALF = 0x0000_0002;
700 
701   /**
702    * @dev Defines if the default behavior of `transfer` and `transferFrom`
703    *      checks if the receiver smart contract supports ERC20 tokens
704    * @dev When feature FEATURE_UNSAFE_TRANSFERS is enabled the transfers do not
705    *      check if the receiver smart contract supports ERC20 tokens,
706    *      i.e. `transfer` and `transferFrom` behave like `unsafeTransferFrom`
707    * @dev When feature FEATURE_UNSAFE_TRANSFERS is disabled (default) the transfers
708    *      check if the receiver smart contract supports ERC20 tokens,
709    *      i.e. `transfer` and `transferFrom` behave like `safeTransferFrom`
710    */
711   uint32 public constant FEATURE_UNSAFE_TRANSFERS = 0x0000_0004;
712 
713   /**
714    * @notice Enables token owners to burn their own tokens,
715    *      including locked tokens which are burnt first
716    * @dev Feature FEATURE_OWN_BURNS must be enabled in order for
717    *      `burn()` function to succeed when called by token owner
718    */
719   uint32 public constant FEATURE_OWN_BURNS = 0x0000_0008;
720 
721   /**
722    * @notice Enables approved operators to burn tokens on behalf of their owners,
723    *      including locked tokens which are burnt first
724    * @dev Feature FEATURE_OWN_BURNS must be enabled in order for
725    *      `burn()` function to succeed when called by approved operator
726    */
727   uint32 public constant FEATURE_BURNS_ON_BEHALF = 0x0000_0010;
728 
729   /**
730    * @notice Enables delegators to elect delegates
731    * @dev Feature FEATURE_DELEGATIONS must be enabled in order for
732    *      `delegate()` function to succeed
733    */
734   uint32 public constant FEATURE_DELEGATIONS = 0x0000_0020;
735 
736   /**
737    * @notice Enables delegators to elect delegates on behalf
738    *      (via an EIP712 signature)
739    * @dev Feature FEATURE_DELEGATIONS must be enabled in order for
740    *      `delegateWithSig()` function to succeed
741    */
742   uint32 public constant FEATURE_DELEGATIONS_ON_BEHALF = 0x0000_0040;
743 
744   /**
745    * @notice Token creator is responsible for creating (minting)
746    *      tokens to an arbitrary address
747    * @dev Role ROLE_TOKEN_CREATOR allows minting tokens
748    *      (calling `mint` function)
749    */
750   uint32 public constant ROLE_TOKEN_CREATOR = 0x0001_0000;
751 
752   /**
753    * @notice Token destroyer is responsible for destroying (burning)
754    *      tokens owned by an arbitrary address
755    * @dev Role ROLE_TOKEN_DESTROYER allows burning tokens
756    *      (calling `burn` function)
757    */
758   uint32 public constant ROLE_TOKEN_DESTROYER = 0x0002_0000;
759 
760   /**
761    * @notice ERC20 receivers are allowed to receive tokens without ERC20 safety checks,
762    *      which may be useful to simplify tokens transfers into "legacy" smart contracts
763    * @dev When `FEATURE_UNSAFE_TRANSFERS` is not enabled addresses having
764    *      `ROLE_ERC20_RECEIVER` permission are allowed to receive tokens
765    *      via `transfer` and `transferFrom` functions in the same way they
766    *      would via `unsafeTransferFrom` function
767    * @dev When `FEATURE_UNSAFE_TRANSFERS` is enabled `ROLE_ERC20_RECEIVER` permission
768    *      doesn't affect the transfer behaviour since
769    *      `transfer` and `transferFrom` behave like `unsafeTransferFrom` for any receiver
770    * @dev ROLE_ERC20_RECEIVER is a shortening for ROLE_UNSAFE_ERC20_RECEIVER
771    */
772   uint32 public constant ROLE_ERC20_RECEIVER = 0x0004_0000;
773 
774   /**
775    * @notice ERC20 senders are allowed to send tokens without ERC20 safety checks,
776    *      which may be useful to simplify tokens transfers into "legacy" smart contracts
777    * @dev When `FEATURE_UNSAFE_TRANSFERS` is not enabled senders having
778    *      `ROLE_ERC20_SENDER` permission are allowed to send tokens
779    *      via `transfer` and `transferFrom` functions in the same way they
780    *      would via `unsafeTransferFrom` function
781    * @dev When `FEATURE_UNSAFE_TRANSFERS` is enabled `ROLE_ERC20_SENDER` permission
782    *      doesn't affect the transfer behaviour since
783    *      `transfer` and `transferFrom` behave like `unsafeTransferFrom` for any receiver
784    * @dev ROLE_ERC20_SENDER is a shortening for ROLE_UNSAFE_ERC20_SENDER
785    */
786   uint32 public constant ROLE_ERC20_SENDER = 0x0008_0000;
787 
788   /**
789    * @dev Magic value to be returned by ERC20Receiver upon successful reception of token(s)
790    * @dev Equal to `bytes4(keccak256("onERC20Received(address,address,uint256,bytes)"))`,
791    *      which can be also obtained as `ERC20Receiver(address(0)).onERC20Received.selector`
792    */
793   bytes4 private constant ERC20_RECEIVED = 0x4fc35859;
794 
795   /**
796    * @notice EIP-712 contract's domain typeHash, see https://eips.ethereum.org/EIPS/eip-712#rationale-for-typehash
797    */
798   bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
799 
800   /**
801    * @notice EIP-712 delegation struct typeHash, see https://eips.ethereum.org/EIPS/eip-712#rationale-for-typehash
802    */
803   bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegate,uint256 nonce,uint256 expiry)");
804 
805   /**
806    * @dev Fired in transfer(), transferFrom() and some other (non-ERC20) functions
807    *
808    * @dev ERC20 `event Transfer(address indexed _from, address indexed _to, uint256 _value)`
809    *
810    * @param _from an address tokens were consumed from
811    * @param _to an address tokens were sent to
812    * @param _value number of tokens transferred
813    */
814   event Transfer(address indexed _from, address indexed _to, uint256 _value);
815 
816   /**
817    * @dev Fired in approve() and approveAtomic() functions
818    *
819    * @dev ERC20 `event Approval(address indexed _owner, address indexed _spender, uint256 _value)`
820    *
821    * @param _owner an address which granted a permission to transfer
822    *      tokens on its behalf
823    * @param _spender an address which received a permission to transfer
824    *      tokens on behalf of the owner `_owner`
825    * @param _value amount of tokens granted to transfer on behalf
826    */
827   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
828 
829   /**
830    * @dev Fired in mint() function
831    *
832    * @param _by an address which minted some tokens (transaction sender)
833    * @param _to an address the tokens were minted to
834    * @param _value an amount of tokens minted
835    */
836   event Minted(address indexed _by, address indexed _to, uint256 _value);
837 
838   /**
839    * @dev Fired in burn() function
840    *
841    * @param _by an address which burned some tokens (transaction sender)
842    * @param _from an address the tokens were burnt from
843    * @param _value an amount of tokens burnt
844    */
845   event Burnt(address indexed _by, address indexed _from, uint256 _value);
846 
847   /**
848    * @dev Resolution for the Multiple Withdrawal Attack on ERC20 Tokens (ISBN:978-1-7281-3027-9)
849    *
850    * @dev Similar to ERC20 Transfer event, but also logs an address which executed transfer
851    *
852    * @dev Fired in transfer(), transferFrom() and some other (non-ERC20) functions
853    *
854    * @param _by an address which performed the transfer
855    * @param _from an address tokens were consumed from
856    * @param _to an address tokens were sent to
857    * @param _value number of tokens transferred
858    */
859   event Transferred(address indexed _by, address indexed _from, address indexed _to, uint256 _value);
860 
861   /**
862    * @dev Resolution for the Multiple Withdrawal Attack on ERC20 Tokens (ISBN:978-1-7281-3027-9)
863    *
864    * @dev Similar to ERC20 Approve event, but also logs old approval value
865    *
866    * @dev Fired in approve() and approveAtomic() functions
867    *
868    * @param _owner an address which granted a permission to transfer
869    *      tokens on its behalf
870    * @param _spender an address which received a permission to transfer
871    *      tokens on behalf of the owner `_owner`
872    * @param _oldValue previously granted amount of tokens to transfer on behalf
873    * @param _value new granted amount of tokens to transfer on behalf
874    */
875   event Approved(address indexed _owner, address indexed _spender, uint256 _oldValue, uint256 _value);
876 
877   /**
878    * @dev Notifies that a key-value pair in `votingDelegates` mapping has changed,
879    *      i.e. a delegator address has changed its delegate address
880    *
881    * @param _of delegator address, a token owner
882    * @param _from old delegate, an address which delegate right is revoked
883    * @param _to new delegate, an address which received the voting power
884    */
885   event DelegateChanged(address indexed _of, address indexed _from, address indexed _to);
886 
887   /**
888    * @dev Notifies that a key-value pair in `votingPowerHistory` mapping has changed,
889    *      i.e. a delegate's voting power has changed.
890    *
891    * @param _of delegate whose voting power has changed
892    * @param _fromVal previous number of votes delegate had
893    * @param _toVal new number of votes delegate has
894    */
895   event VotingPowerChanged(address indexed _of, uint256 _fromVal, uint256 _toVal);
896 
897   /**
898    * @dev Deploys the token smart contract,
899    *      assigns initial token supply to the address specified
900    *
901    * @param _initialHolder owner of the initial token supply
902    */
903   constructor(address _initialHolder) {
904     // verify initial holder address non-zero (is set)
905     require(_initialHolder != address(0), "_initialHolder not set (zero address)");
906 
907     // mint initial supply
908     mint(_initialHolder, 7_000_000e18);
909   }
910 
911   // ===== Start: ERC20/ERC223/ERC777 functions =====
912 
913   /**
914    * @notice Gets the balance of a particular address
915    *
916    * @dev ERC20 `function balanceOf(address _owner) public view returns (uint256 balance)`
917    *
918    * @param _owner the address to query the the balance for
919    * @return balance an amount of tokens owned by the address specified
920    */
921   function balanceOf(address _owner) public view returns (uint256 balance) {
922     // read the balance and return
923     return tokenBalances[_owner];
924   }
925 
926   /**
927    * @notice Transfers some tokens to an external address or a smart contract
928    *
929    * @dev ERC20 `function transfer(address _to, uint256 _value) public returns (bool success)`
930    *
931    * @dev Called by token owner (an address which has a
932    *      positive token balance tracked by this smart contract)
933    * @dev Throws on any error like
934    *      * insufficient token balance or
935    *      * incorrect `_to` address:
936    *          * zero address or
937    *          * self address or
938    *          * smart contract which doesn't support ERC20
939    *
940    * @param _to an address to transfer tokens to,
941    *      must be either an external address or a smart contract,
942    *      compliant with the ERC20 standard
943    * @param _value amount of tokens to be transferred, must
944    *      be greater than zero
945    * @return success true on success, throws otherwise
946    */
947   function transfer(address _to, uint256 _value) public returns (bool success) {
948     // just delegate call to `transferFrom`,
949     // `FEATURE_TRANSFERS` is verified inside it
950     return transferFrom(msg.sender, _to, _value);
951   }
952 
953   /**
954    * @notice Transfers some tokens on behalf of address `_from' (token owner)
955    *      to some other address `_to`
956    *
957    * @dev ERC20 `function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)`
958    *
959    * @dev Called by token owner on his own or approved address,
960    *      an address approved earlier by token owner to
961    *      transfer some amount of tokens on its behalf
962    * @dev Throws on any error like
963    *      * insufficient token balance or
964    *      * incorrect `_to` address:
965    *          * zero address or
966    *          * same as `_from` address (self transfer)
967    *          * smart contract which doesn't support ERC20
968    *
969    * @param _from token owner which approved caller (transaction sender)
970    *      to transfer `_value` of tokens on its behalf
971    * @param _to an address to transfer tokens to,
972    *      must be either an external address or a smart contract,
973    *      compliant with the ERC20 standard
974    * @param _value amount of tokens to be transferred, must
975    *      be greater than zero
976    * @return success true on success, throws otherwise
977    */
978   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
979     // depending on `FEATURE_UNSAFE_TRANSFERS` we execute either safe (default)
980     // or unsafe transfer
981     // if `FEATURE_UNSAFE_TRANSFERS` is enabled
982     // or receiver has `ROLE_ERC20_RECEIVER` permission
983     // or sender has `ROLE_ERC20_SENDER` permission
984     if(isFeatureEnabled(FEATURE_UNSAFE_TRANSFERS)
985     || isOperatorInRole(_to, ROLE_ERC20_RECEIVER)
986       || isSenderInRole(ROLE_ERC20_SENDER)) {
987       // we execute unsafe transfer - delegate call to `unsafeTransferFrom`,
988       // `FEATURE_TRANSFERS` is verified inside it
989       unsafeTransferFrom(_from, _to, _value);
990     }
991     // otherwise - if `FEATURE_UNSAFE_TRANSFERS` is disabled
992     // and receiver doesn't have `ROLE_ERC20_RECEIVER` permission
993     else {
994       // we execute safe transfer - delegate call to `safeTransferFrom`, passing empty `_data`,
995       // `FEATURE_TRANSFERS` is verified inside it
996       safeTransferFrom(_from, _to, _value, "");
997     }
998 
999     // both `unsafeTransferFrom` and `safeTransferFrom` throw on any error, so
1000     // if we're here - it means operation successful,
1001     // just return true
1002     return true;
1003   }
1004 
1005   /**
1006    * @notice Transfers some tokens on behalf of address `_from' (token owner)
1007    *      to some other address `_to`
1008    *
1009    * @dev Inspired by ERC721 safeTransferFrom, this function allows to
1010    *      send arbitrary data to the receiver on successful token transfer
1011    * @dev Called by token owner on his own or approved address,
1012    *      an address approved earlier by token owner to
1013    *      transfer some amount of tokens on its behalf
1014    * @dev Throws on any error like
1015    *      * insufficient token balance or
1016    *      * incorrect `_to` address:
1017    *          * zero address or
1018    *          * same as `_from` address (self transfer)
1019    *          * smart contract which doesn't support ERC20Receiver interface
1020    * @dev Returns silently on success, throws otherwise
1021    *
1022    * @param _from token owner which approved caller (transaction sender)
1023    *      to transfer `_value` of tokens on its behalf
1024    * @param _to an address to transfer tokens to,
1025    *      must be either an external address or a smart contract,
1026    *      compliant with the ERC20 standard
1027    * @param _value amount of tokens to be transferred, must
1028    *      be greater than zero
1029    * @param _data [optional] additional data with no specified format,
1030    *      sent in onERC20Received call to `_to` in case if its a smart contract
1031    */
1032   function safeTransferFrom(address _from, address _to, uint256 _value, bytes memory _data) public {
1033     // first delegate call to `unsafeTransferFrom`
1034     // to perform the unsafe token(s) transfer
1035     unsafeTransferFrom(_from, _to, _value);
1036 
1037     // after the successful transfer - check if receiver supports
1038     // ERC20Receiver and execute a callback handler `onERC20Received`,
1039     // reverting whole transaction on any error:
1040     // check if receiver `_to` supports ERC20Receiver interface
1041     if(AddressUtils.isContract(_to)) {
1042       // if `_to` is a contract - execute onERC20Received
1043       bytes4 response = ERC20Receiver(_to).onERC20Received(msg.sender, _from, _value, _data);
1044 
1045       // expected response is ERC20_RECEIVED
1046       require(response == ERC20_RECEIVED, "invalid onERC20Received response");
1047     }
1048   }
1049 
1050   /**
1051    * @notice Transfers some tokens on behalf of address `_from' (token owner)
1052    *      to some other address `_to`
1053    *
1054    * @dev In contrast to `safeTransferFrom` doesn't check recipient
1055    *      smart contract to support ERC20 tokens (ERC20Receiver)
1056    * @dev Designed to be used by developers when the receiver is known
1057    *      to support ERC20 tokens but doesn't implement ERC20Receiver interface
1058    * @dev Called by token owner on his own or approved address,
1059    *      an address approved earlier by token owner to
1060    *      transfer some amount of tokens on its behalf
1061    * @dev Throws on any error like
1062    *      * insufficient token balance or
1063    *      * incorrect `_to` address:
1064    *          * zero address or
1065    *          * same as `_from` address (self transfer)
1066    * @dev Returns silently on success, throws otherwise
1067    *
1068    * @param _from token owner which approved caller (transaction sender)
1069    *      to transfer `_value` of tokens on its behalf
1070    * @param _to an address to transfer tokens to,
1071    *      must be either an external address or a smart contract,
1072    *      compliant with the ERC20 standard
1073    * @param _value amount of tokens to be transferred, must
1074    *      be greater than zero
1075    */
1076   function unsafeTransferFrom(address _from, address _to, uint256 _value) public {
1077     // if `_from` is equal to sender, require transfers feature to be enabled
1078     // otherwise require transfers on behalf feature to be enabled
1079     require(_from == msg.sender && isFeatureEnabled(FEATURE_TRANSFERS)
1080       || _from != msg.sender && isFeatureEnabled(FEATURE_TRANSFERS_ON_BEHALF),
1081       _from == msg.sender? "transfers are disabled": "transfers on behalf are disabled");
1082 
1083     // non-zero source address check - Zeppelin
1084     // obviously, zero source address is a client mistake
1085     // it's not part of ERC20 standard but it's reasonable to fail fast
1086     // since for zero value transfer transaction succeeds otherwise
1087     require(_from != address(0), "ERC20: transfer from the zero address"); // Zeppelin msg
1088 
1089     // non-zero recipient address check
1090     require(_to != address(0), "ERC20: transfer to the zero address"); // Zeppelin msg
1091 
1092     // sender and recipient cannot be the same
1093     require(_from != _to, "sender and recipient are the same (_from = _to)");
1094 
1095     // sending tokens to the token smart contract itself is a client mistake
1096     require(_to != address(this), "invalid recipient (transfer to the token smart contract itself)");
1097 
1098     // according to ERC-20 Token Standard, https://eips.ethereum.org/EIPS/eip-20
1099     // "Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event."
1100     if(_value == 0) {
1101       // emit an ERC20 transfer event
1102       emit Transfer(_from, _to, _value);
1103 
1104       // don't forget to return - we're done
1105       return;
1106     }
1107 
1108     // no need to make arithmetic overflow check on the _value - by design of mint()
1109 
1110     // in case of transfer on behalf
1111     if(_from != msg.sender) {
1112       // read allowance value - the amount of tokens allowed to transfer - into the stack
1113       uint256 _allowance = transferAllowances[_from][msg.sender];
1114 
1115       // verify sender has an allowance to transfer amount of tokens requested
1116       require(_allowance >= _value, "ERC20: transfer amount exceeds allowance"); // Zeppelin msg
1117 
1118       // update allowance value on the stack
1119       _allowance -= _value;
1120 
1121       // update the allowance value in storage
1122       transferAllowances[_from][msg.sender] = _allowance;
1123 
1124       // emit an improved atomic approve event
1125       emit Approved(_from, msg.sender, _allowance + _value, _allowance);
1126 
1127       // emit an ERC20 approval event to reflect the decrease
1128       emit Approval(_from, msg.sender, _allowance);
1129     }
1130 
1131     // verify sender has enough tokens to transfer on behalf
1132     require(tokenBalances[_from] >= _value, "ERC20: transfer amount exceeds balance"); // Zeppelin msg
1133 
1134     // perform the transfer:
1135     // decrease token owner (sender) balance
1136     tokenBalances[_from] -= _value;
1137 
1138     // increase `_to` address (receiver) balance
1139     tokenBalances[_to] += _value;
1140 
1141     // move voting power associated with the tokens transferred
1142     __moveVotingPower(votingDelegates[_from], votingDelegates[_to], _value);
1143 
1144     // emit an improved transfer event
1145     emit Transferred(msg.sender, _from, _to, _value);
1146 
1147     // emit an ERC20 transfer event
1148     emit Transfer(_from, _to, _value);
1149   }
1150 
1151   /**
1152    * @notice Approves address called `_spender` to transfer some amount
1153    *      of tokens on behalf of the owner
1154    *
1155    * @dev ERC20 `function approve(address _spender, uint256 _value) public returns (bool success)`
1156    *
1157    * @dev Caller must not necessarily own any tokens to grant the permission
1158    *
1159    * @param _spender an address approved by the caller (token owner)
1160    *      to spend some tokens on its behalf
1161    * @param _value an amount of tokens spender `_spender` is allowed to
1162    *      transfer on behalf of the token owner
1163    * @return success true on success, throws otherwise
1164    */
1165   function approve(address _spender, uint256 _value) public returns (bool success) {
1166     // non-zero spender address check - Zeppelin
1167     // obviously, zero spender address is a client mistake
1168     // it's not part of ERC20 standard but it's reasonable to fail fast
1169     require(_spender != address(0), "ERC20: approve to the zero address"); // Zeppelin msg
1170 
1171     // read old approval value to emmit an improved event (ISBN:978-1-7281-3027-9)
1172     uint256 _oldValue = transferAllowances[msg.sender][_spender];
1173 
1174     // perform an operation: write value requested into the storage
1175     transferAllowances[msg.sender][_spender] = _value;
1176 
1177     // emit an improved atomic approve event (ISBN:978-1-7281-3027-9)
1178     emit Approved(msg.sender, _spender, _oldValue, _value);
1179 
1180     // emit an ERC20 approval event
1181     emit Approval(msg.sender, _spender, _value);
1182 
1183     // operation successful, return true
1184     return true;
1185   }
1186 
1187   /**
1188    * @notice Returns the amount which _spender is still allowed to withdraw from _owner.
1189    *
1190    * @dev ERC20 `function allowance(address _owner, address _spender) public view returns (uint256 remaining)`
1191    *
1192    * @dev A function to check an amount of tokens owner approved
1193    *      to transfer on its behalf by some other address called "spender"
1194    *
1195    * @param _owner an address which approves transferring some tokens on its behalf
1196    * @param _spender an address approved to transfer some tokens on behalf
1197    * @return remaining an amount of tokens approved address `_spender` can transfer on behalf
1198    *      of token owner `_owner`
1199    */
1200   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
1201     // read the value from storage and return
1202     return transferAllowances[_owner][_spender];
1203   }
1204 
1205   // ===== End: ERC20/ERC223/ERC777 functions =====
1206 
1207   // ===== Start: Resolution for the Multiple Withdrawal Attack on ERC20 Tokens (ISBN:978-1-7281-3027-9) =====
1208 
1209   /**
1210    * @notice Increases the allowance granted to `spender` by the transaction sender
1211    *
1212    * @dev Resolution for the Multiple Withdrawal Attack on ERC20 Tokens (ISBN:978-1-7281-3027-9)
1213    *
1214    * @dev Throws if value to increase by is zero or too big and causes arithmetic overflow
1215    *
1216    * @param _spender an address approved by the caller (token owner)
1217    *      to spend some tokens on its behalf
1218    * @param _value an amount of tokens to increase by
1219    * @return success true on success, throws otherwise
1220    */
1221   function increaseAllowance(address _spender, uint256 _value) public virtual returns (bool) {
1222     // read current allowance value
1223     uint256 currentVal = transferAllowances[msg.sender][_spender];
1224 
1225     // non-zero _value and arithmetic overflow check on the allowance
1226     require(currentVal + _value > currentVal, "zero value approval increase or arithmetic overflow");
1227 
1228     // delegate call to `approve` with the new value
1229     return approve(_spender, currentVal + _value);
1230   }
1231 
1232   /**
1233    * @notice Decreases the allowance granted to `spender` by the caller.
1234    *
1235    * @dev Resolution for the Multiple Withdrawal Attack on ERC20 Tokens (ISBN:978-1-7281-3027-9)
1236    *
1237    * @dev Throws if value to decrease by is zero or is bigger than currently allowed value
1238    *
1239    * @param _spender an address approved by the caller (token owner)
1240    *      to spend some tokens on its behalf
1241    * @param _value an amount of tokens to decrease by
1242    * @return success true on success, throws otherwise
1243    */
1244   function decreaseAllowance(address _spender, uint256 _value) public virtual returns (bool) {
1245     // read current allowance value
1246     uint256 currentVal = transferAllowances[msg.sender][_spender];
1247 
1248     // non-zero _value check on the allowance
1249     require(_value > 0, "zero value approval decrease");
1250 
1251     // verify allowance decrease doesn't underflow
1252     require(currentVal >= _value, "ERC20: decreased allowance below zero");
1253 
1254     // delegate call to `approve` with the new value
1255     return approve(_spender, currentVal - _value);
1256   }
1257 
1258   // ===== End: Resolution for the Multiple Withdrawal Attack on ERC20 Tokens (ISBN:978-1-7281-3027-9) =====
1259 
1260   // ===== Start: Minting/burning extension =====
1261 
1262   /**
1263    * @dev Mints (creates) some tokens to address specified
1264    * @dev The value specified is treated as is without taking
1265    *      into account what `decimals` value is
1266    * @dev Behaves effectively as `mintTo` function, allowing
1267    *      to specify an address to mint tokens to
1268    * @dev Requires sender to have `ROLE_TOKEN_CREATOR` permission
1269    *
1270    * @dev Throws on overflow, if totalSupply + _value doesn't fit into uint256
1271    *
1272    * @param _to an address to mint tokens to
1273    * @param _value an amount of tokens to mint (create)
1274    */
1275   function mint(address _to, uint256 _value) public {
1276     // check if caller has sufficient permissions to mint tokens
1277     require(isSenderInRole(ROLE_TOKEN_CREATOR), "insufficient privileges (ROLE_TOKEN_CREATOR required)");
1278 
1279     // non-zero recipient address check
1280     require(_to != address(0), "ERC20: mint to the zero address"); // Zeppelin msg
1281 
1282     // non-zero _value and arithmetic overflow check on the total supply
1283     // this check automatically secures arithmetic overflow on the individual balance
1284     require(totalSupply + _value > totalSupply, "zero value mint or arithmetic overflow");
1285 
1286     // uint192 overflow check (required by voting delegation)
1287     require(totalSupply + _value <= type(uint192).max, "total supply overflow (uint192)");
1288 
1289     // perform mint:
1290     // increase total amount of tokens value
1291     totalSupply += _value;
1292 
1293     // increase `_to` address balance
1294     tokenBalances[_to] += _value;
1295 
1296     // create voting power associated with the tokens minted
1297     __moveVotingPower(address(0), votingDelegates[_to], _value);
1298 
1299     // fire a minted event
1300     emit Minted(msg.sender, _to, _value);
1301 
1302     // emit an improved transfer event
1303     emit Transferred(msg.sender, address(0), _to, _value);
1304 
1305     // fire ERC20 compliant transfer event
1306     emit Transfer(address(0), _to, _value);
1307   }
1308 
1309   /**
1310    * @dev Burns (destroys) some tokens from the address specified
1311    * @dev The value specified is treated as is without taking
1312    *      into account what `decimals` value is
1313    * @dev Behaves effectively as `burnFrom` function, allowing
1314    *      to specify an address to burn tokens from
1315    * @dev Requires sender to have `ROLE_TOKEN_DESTROYER` permission
1316    *
1317    * @param _from an address to burn some tokens from
1318    * @param _value an amount of tokens to burn (destroy)
1319    */
1320   function burn(address _from, uint256 _value) public {
1321     // check if caller has sufficient permissions to burn tokens
1322     // and if not - check for possibility to burn own tokens or to burn on behalf
1323     if(!isSenderInRole(ROLE_TOKEN_DESTROYER)) {
1324       // if `_from` is equal to sender, require own burns feature to be enabled
1325       // otherwise require burns on behalf feature to be enabled
1326       require(_from == msg.sender && isFeatureEnabled(FEATURE_OWN_BURNS)
1327         || _from != msg.sender && isFeatureEnabled(FEATURE_BURNS_ON_BEHALF),
1328         _from == msg.sender? "burns are disabled": "burns on behalf are disabled");
1329 
1330       // in case of burn on behalf
1331       if(_from != msg.sender) {
1332         // read allowance value - the amount of tokens allowed to be burnt - into the stack
1333         uint256 _allowance = transferAllowances[_from][msg.sender];
1334 
1335         // verify sender has an allowance to burn amount of tokens requested
1336         require(_allowance >= _value, "ERC20: burn amount exceeds allowance"); // Zeppelin msg
1337 
1338         // update allowance value on the stack
1339         _allowance -= _value;
1340 
1341         // update the allowance value in storage
1342         transferAllowances[_from][msg.sender] = _allowance;
1343 
1344         // emit an improved atomic approve event
1345         emit Approved(msg.sender, _from, _allowance + _value, _allowance);
1346 
1347         // emit an ERC20 approval event to reflect the decrease
1348         emit Approval(_from, msg.sender, _allowance);
1349       }
1350     }
1351 
1352     // at this point we know that either sender is ROLE_TOKEN_DESTROYER or
1353     // we burn own tokens or on behalf (in latest case we already checked and updated allowances)
1354     // we have left to execute balance checks and burning logic itself
1355 
1356     // non-zero burn value check
1357     require(_value != 0, "zero value burn");
1358 
1359     // non-zero source address check - Zeppelin
1360     require(_from != address(0), "ERC20: burn from the zero address"); // Zeppelin msg
1361 
1362     // verify `_from` address has enough tokens to destroy
1363     // (basically this is a arithmetic overflow check)
1364     require(tokenBalances[_from] >= _value, "ERC20: burn amount exceeds balance"); // Zeppelin msg
1365 
1366     // perform burn:
1367     // decrease `_from` address balance
1368     tokenBalances[_from] -= _value;
1369 
1370     // decrease total amount of tokens value
1371     totalSupply -= _value;
1372 
1373     // destroy voting power associated with the tokens burnt
1374     __moveVotingPower(votingDelegates[_from], address(0), _value);
1375 
1376     // fire a burnt event
1377     emit Burnt(msg.sender, _from, _value);
1378 
1379     // emit an improved transfer event
1380     emit Transferred(msg.sender, _from, address(0), _value);
1381 
1382     // fire ERC20 compliant transfer event
1383     emit Transfer(_from, address(0), _value);
1384   }
1385 
1386   // ===== End: Minting/burning extension =====
1387 
1388   // ===== Start: DAO Support (Compound-like voting delegation) =====
1389 
1390   /**
1391    * @notice Gets current voting power of the account `_of`
1392    * @param _of the address of account to get voting power of
1393    * @return current cumulative voting power of the account,
1394    *      sum of token balances of all its voting delegators
1395    */
1396   function getVotingPower(address _of) public view returns (uint256) {
1397     // get a link to an array of voting power history records for an address specified
1398     VotingPowerRecord[] storage history = votingPowerHistory[_of];
1399 
1400     // lookup the history and return latest element
1401     return history.length == 0? 0: history[history.length - 1].votingPower;
1402   }
1403 
1404   /**
1405    * @notice Gets past voting power of the account `_of` at some block `_blockNum`
1406    * @dev Throws if `_blockNum` is not in the past (not the finalized block)
1407    * @param _of the address of account to get voting power of
1408    * @param _blockNum block number to get the voting power at
1409    * @return past cumulative voting power of the account,
1410    *      sum of token balances of all its voting delegators at block number `_blockNum`
1411    */
1412   function getVotingPowerAt(address _of, uint256 _blockNum) public view returns (uint256) {
1413     // make sure block number is not in the past (not the finalized block)
1414     require(_blockNum < block.number, "not yet determined"); // Compound msg
1415 
1416     // get a link to an array of voting power history records for an address specified
1417     VotingPowerRecord[] storage history = votingPowerHistory[_of];
1418 
1419     // if voting power history for the account provided is empty
1420     if(history.length == 0) {
1421       // than voting power is zero - return the result
1422       return 0;
1423     }
1424 
1425     // check latest voting power history record block number:
1426     // if history was not updated after the block of interest
1427     if(history[history.length - 1].blockNumber <= _blockNum) {
1428       // we're done - return last voting power record
1429       return getVotingPower(_of);
1430     }
1431 
1432     // check first voting power history record block number:
1433     // if history was never updated before the block of interest
1434     if(history[0].blockNumber > _blockNum) {
1435       // we're done - voting power at the block num of interest was zero
1436       return 0;
1437     }
1438 
1439     // `votingPowerHistory[_of]` is an array ordered by `blockNumber`, ascending;
1440     // apply binary search on `votingPowerHistory[_of]` to find such an entry number `i`, that
1441     // `votingPowerHistory[_of][i].blockNumber <= _blockNum`, but in the same time
1442     // `votingPowerHistory[_of][i + 1].blockNumber > _blockNum`
1443     // return the result - voting power found at index `i`
1444     return history[__binaryLookup(_of, _blockNum)].votingPower;
1445   }
1446 
1447   /**
1448    * @dev Reads an entire voting power history array for the delegate specified
1449    *
1450    * @param _of delegate to query voting power history for
1451    * @return voting power history array for the delegate of interest
1452    */
1453   function getVotingPowerHistory(address _of) public view returns(VotingPowerRecord[] memory) {
1454     // return an entire array as memory
1455     return votingPowerHistory[_of];
1456   }
1457 
1458   /**
1459    * @dev Returns length of the voting power history array for the delegate specified;
1460    *      useful since reading an entire array just to get its length is expensive (gas cost)
1461    *
1462    * @param _of delegate to query voting power history length for
1463    * @return voting power history array length for the delegate of interest
1464    */
1465   function getVotingPowerHistoryLength(address _of) public view returns(uint256) {
1466     // read array length and return
1467     return votingPowerHistory[_of].length;
1468   }
1469 
1470   /**
1471    * @notice Delegates voting power of the delegator `msg.sender` to the delegate `_to`
1472    *
1473    * @dev Accepts zero value address to delegate voting power to, effectively
1474    *      removing the delegate in that case
1475    *
1476    * @param _to address to delegate voting power to
1477    */
1478   function delegate(address _to) public {
1479     // verify delegations are enabled
1480     require(isFeatureEnabled(FEATURE_DELEGATIONS), "delegations are disabled");
1481     // delegate call to `__delegate`
1482     __delegate(msg.sender, _to);
1483   }
1484 
1485   /**
1486    * @notice Delegates voting power of the delegator (represented by its signature) to the delegate `_to`
1487    *
1488    * @dev Accepts zero value address to delegate voting power to, effectively
1489    *      removing the delegate in that case
1490    *
1491    * @dev Compliant with EIP-712: Ethereum typed structured data hashing and signing,
1492    *      see https://eips.ethereum.org/EIPS/eip-712
1493    *
1494    * @param _to address to delegate voting power to
1495    * @param _nonce nonce used to construct the signature, and used to validate it;
1496    *      nonce is increased by one after successful signature validation and vote delegation
1497    * @param _exp signature expiration time
1498    * @param v the recovery byte of the signature
1499    * @param r half of the ECDSA signature pair
1500    * @param s half of the ECDSA signature pair
1501    */
1502   function delegateWithSig(address _to, uint256 _nonce, uint256 _exp, uint8 v, bytes32 r, bytes32 s) public {
1503     // verify delegations on behalf are enabled
1504     require(isFeatureEnabled(FEATURE_DELEGATIONS_ON_BEHALF), "delegations on behalf are disabled");
1505 
1506     // build the EIP-712 contract domain separator
1507     bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), block.chainid, address(this)));
1508 
1509     // build the EIP-712 hashStruct of the delegation message
1510     bytes32 hashStruct = keccak256(abi.encode(DELEGATION_TYPEHASH, _to, _nonce, _exp));
1511 
1512     // calculate the EIP-712 digest "\x19\x01" ‖ domainSeparator ‖ hashStruct(message)
1513     bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, hashStruct));
1514 
1515     // recover the address who signed the message with v, r, s
1516     address signer = ecrecover(digest, v, r, s);
1517 
1518     // perform message integrity and security validations
1519     require(signer != address(0), "invalid signature"); // Compound msg
1520     require(_nonce == nonces[signer], "invalid nonce"); // Compound msg
1521     require(block.timestamp < _exp, "signature expired"); // Compound msg
1522 
1523     // update the nonce for that particular signer to avoid replay attack
1524     nonces[signer]++;
1525 
1526     // delegate call to `__delegate` - execute the logic required
1527     __delegate(signer, _to);
1528   }
1529 
1530   /**
1531    * @dev Auxiliary function to delegate delegator's `_from` voting power to the delegate `_to`
1532    * @dev Writes to `votingDelegates` and `votingPowerHistory` mappings
1533    *
1534    * @param _from delegator who delegates his voting power
1535    * @param _to delegate who receives the voting power
1536    */
1537   function __delegate(address _from, address _to) private {
1538     // read current delegate to be replaced by a new one
1539     address _fromDelegate = votingDelegates[_from];
1540 
1541     // read current voting power (it is equal to token balance)
1542     uint256 _value = tokenBalances[_from];
1543 
1544     // reassign voting delegate to `_to`
1545     votingDelegates[_from] = _to;
1546 
1547     // update voting power for `_fromDelegate` and `_to`
1548     __moveVotingPower(_fromDelegate, _to, _value);
1549 
1550     // emit an event
1551     emit DelegateChanged(_from, _fromDelegate, _to);
1552   }
1553 
1554   /**
1555    * @dev Auxiliary function to move voting power `_value`
1556    *      from delegate `_from` to the delegate `_to`
1557    *
1558    * @dev Doesn't have any effect if `_from == _to`, or if `_value == 0`
1559    *
1560    * @param _from delegate to move voting power from
1561    * @param _to delegate to move voting power to
1562    * @param _value voting power to move from `_from` to `_to`
1563    */
1564   function __moveVotingPower(address _from, address _to, uint256 _value) private {
1565     // if there is no move (`_from == _to`) or there is nothing to move (`_value == 0`)
1566     if(_from == _to || _value == 0) {
1567       // return silently with no action
1568       return;
1569     }
1570 
1571     // if source address is not zero - decrease its voting power
1572     if(_from != address(0)) {
1573       // read current source address voting power
1574       uint256 _fromVal = getVotingPower(_from);
1575 
1576       // calculate decreased voting power
1577       // underflow is not possible by design:
1578       // voting power is limited by token balance which is checked by the callee
1579       uint256 _toVal = _fromVal - _value;
1580 
1581       // update source voting power from `_fromVal` to `_toVal`
1582       __updateVotingPower(_from, _fromVal, _toVal);
1583     }
1584 
1585     // if destination address is not zero - increase its voting power
1586     if(_to != address(0)) {
1587       // read current destination address voting power
1588       uint256 _fromVal = getVotingPower(_to);
1589 
1590       // calculate increased voting power
1591       // overflow is not possible by design:
1592       // max token supply limits the cumulative voting power
1593       uint256 _toVal = _fromVal + _value;
1594 
1595       // update destination voting power from `_fromVal` to `_toVal`
1596       __updateVotingPower(_to, _fromVal, _toVal);
1597     }
1598   }
1599 
1600   /**
1601    * @dev Auxiliary function to update voting power of the delegate `_of`
1602    *      from value `_fromVal` to value `_toVal`
1603    *
1604    * @param _of delegate to update its voting power
1605    * @param _fromVal old voting power of the delegate
1606    * @param _toVal new voting power of the delegate
1607    */
1608   function __updateVotingPower(address _of, uint256 _fromVal, uint256 _toVal) private {
1609     // get a link to an array of voting power history records for an address specified
1610     VotingPowerRecord[] storage history = votingPowerHistory[_of];
1611 
1612     // if there is an existing voting power value stored for current block
1613     if(history.length != 0 && history[history.length - 1].blockNumber == block.number) {
1614       // update voting power which is already stored in the current block
1615       history[history.length - 1].votingPower = uint192(_toVal);
1616     }
1617     // otherwise - if there is no value stored for current block
1618     else {
1619       // add new element into array representing the value for current block
1620       history.push(VotingPowerRecord(uint64(block.number), uint192(_toVal)));
1621     }
1622 
1623     // emit an event
1624     emit VotingPowerChanged(_of, _fromVal, _toVal);
1625   }
1626 
1627   /**
1628    * @dev Auxiliary function to lookup an element in a sorted (asc) array of elements
1629    *
1630    * @dev This function finds the closest element in an array to the value
1631    *      of interest (not exceeding that value) and returns its index within an array
1632    *
1633    * @dev An array to search in is `votingPowerHistory[_to][i].blockNumber`,
1634    *      it is sorted in ascending order (blockNumber increases)
1635    *
1636    * @param _to an address of the delegate to get an array for
1637    * @param n value of interest to look for
1638    * @return an index of the closest element in an array to the value
1639    *      of interest (not exceeding that value)
1640    */
1641   function __binaryLookup(address _to, uint256 n) private view returns(uint256) {
1642     // get a link to an array of voting power history records for an address specified
1643     VotingPowerRecord[] storage history = votingPowerHistory[_to];
1644 
1645     // left bound of the search interval, originally start of the array
1646     uint256 i = 0;
1647 
1648     // right bound of the search interval, originally end of the array
1649     uint256 j = history.length - 1;
1650 
1651     // the iteration process narrows down the bounds by
1652     // splitting the interval in a half oce per each iteration
1653     while(j > i) {
1654       // get an index in the middle of the interval [i, j]
1655       uint256 k = j - (j - i) / 2;
1656 
1657       // read an element to compare it with the value of interest
1658       VotingPowerRecord memory cp = history[k];
1659 
1660       // if we've got a strict equal - we're lucky and done
1661       if(cp.blockNumber == n) {
1662         // just return the result - index `k`
1663         return k;
1664       }
1665       // if the value of interest is bigger - move left bound to the middle
1666       else if (cp.blockNumber < n) {
1667         // move left bound `i` to the middle position `k`
1668         i = k;
1669       }
1670       // otherwise, when the value of interest is smaller - move right bound to the middle
1671       else {
1672         // move right bound `j` to the middle position `k - 1`:
1673         // element at position `k` is bigger and cannot be the result
1674         j = k - 1;
1675       }
1676     }
1677 
1678     // reaching that point means no exact match found
1679     // since we're interested in the element which is not bigger than the
1680     // element of interest, we return the lower bound `i`
1681     return i;
1682   }
1683 }
1684 
1685 // ===== End: DAO Support (Compound-like voting delegation) =====
1686 /**
1687  * @title Illuvium Aware
1688  *
1689  * @notice Helper smart contract to be inherited by other smart contracts requiring to
1690  *      be linked to verified IlluviumERC20 instance and performing some basic tasks on it
1691  *
1692  * @author Basil Gorin
1693  */
1694 abstract contract IlluviumAware is ILinkedToILV {
1695   /// @dev Link to ILV ERC20 Token IlluviumERC20 instance
1696   address public immutable override ilv;
1697 
1698   /**
1699    * @dev Creates IlluviumAware instance, requiring to supply deployed IlluviumERC20 instance address
1700    *
1701    * @param _ilv deployed IlluviumERC20 instance address
1702    */
1703   constructor(address _ilv) {
1704     // verify ILV address is set and is correct
1705     require(_ilv != address(0), "ILV address not set");
1706     require(IlluviumERC20(_ilv).TOKEN_UID() == 0x83ecb176af7c4f35a45ff0018282e3a05a1018065da866182df12285866f5a2c, "unexpected TOKEN_UID");
1707 
1708     // write ILV address
1709     ilv = _ilv;
1710   }
1711 
1712   /**
1713    * @dev Executes IlluviumERC20.safeTransferFrom(address(this), _to, _value, "")
1714    *      on the bound IlluviumERC20 instance
1715    *
1716    * @dev Reentrancy safe due to the IlluviumERC20 design
1717    */
1718   function transferIlv(address _to, uint256 _value) internal {
1719     // just delegate call to the target
1720     transferIlvFrom(address(this), _to, _value);
1721   }
1722 
1723   /**
1724    * @dev Executes IlluviumERC20.transferFrom(_from, _to, _value)
1725    *      on the bound IlluviumERC20 instance
1726    *
1727    * @dev Reentrancy safe due to the IlluviumERC20 design
1728    */
1729   function transferIlvFrom(address _from, address _to, uint256 _value) internal {
1730     // just delegate call to the target
1731     IlluviumERC20(ilv).transferFrom(_from, _to, _value);
1732   }
1733 
1734   /**
1735    * @dev Executes IlluviumERC20.mint(_to, _values)
1736    *      on the bound IlluviumERC20 instance
1737    *
1738    * @dev Reentrancy safe due to the IlluviumERC20 design
1739    */
1740   function mintIlv(address _to, uint256 _value) internal {
1741     // just delegate call to the target
1742     IlluviumERC20(ilv).mint(_to, _value);
1743   }
1744 
1745 }
1746 
1747 /**
1748  * @title Illuvium Pool Base
1749  *
1750  * @notice An abstract contract containing common logic for any pool,
1751  *      be it a flash pool (temporary pool like SNX) or a core pool (permanent pool like ILV/ETH or ILV pool)
1752  *
1753  * @dev Deployment and initialization.
1754  *      Any pool deployed must be bound to the deployed pool factory (IlluviumPoolFactory)
1755  *      Additionally, 3 token instance addresses must be defined on deployment:
1756  *          - ILV token address
1757  *          - sILV token address, used to mint sILV rewards
1758  *          - pool token address, it can be ILV token address, ILV/ETH pair address, and others
1759  *
1760  * @dev Pool weight defines the fraction of the yield current pool receives among the other pools,
1761  *      pool factory is responsible for the weight synchronization between the pools.
1762  * @dev The weight is logically 10% for ILV pool and 90% for ILV/ETH pool.
1763  *      Since Solidity doesn't support fractions the weight is defined by the division of
1764  *      pool weight by total pools weight (sum of all registered pools within the factory)
1765  * @dev For ILV Pool we use 100 as weight and for ILV/ETH pool - 900.
1766  *
1767  * @author Pedro Bergamini, reviewed by Basil Gorin
1768  */
1769 abstract contract IlluviumPoolBase is IPool, IlluviumAware, ReentrancyGuard {
1770   /// @dev Data structure representing token holder using a pool
1771   struct User {
1772     // @dev Total staked amount
1773     uint256 tokenAmount;
1774     // @dev Total weight
1775     uint256 totalWeight;
1776     // @dev Auxiliary variable for yield calculation
1777     uint256 subYieldRewards;
1778     // @dev Auxiliary variable for vault rewards calculation
1779     uint256 subVaultRewards;
1780     // @dev An array of holder's deposits
1781     Deposit[] deposits;
1782   }
1783 
1784   /// @dev Token holder storage, maps token holder address to their data record
1785   mapping(address => User) public users;
1786 
1787   /// @dev Link to sILV ERC20 Token EscrowedIlluviumERC20 instance
1788   address public immutable override silv;
1789 
1790   /// @dev Link to the pool factory IlluviumPoolFactory instance
1791   IlluviumPoolFactory public immutable factory;
1792 
1793   /// @dev Link to the pool token instance, for example ILV or ILV/ETH pair
1794   address public immutable override poolToken;
1795 
1796   /// @dev Pool weight, 100 for ILV pool or 900 for ILV/ETH
1797   uint32 public override weight;
1798 
1799   /// @dev Block number of the last yield distribution event
1800   uint64 public override lastYieldDistribution;
1801 
1802   /// @dev Used to calculate yield rewards
1803   /// @dev This value is different from "reward per token" used in locked pool
1804   /// @dev Note: stakes are different in duration and "weight" reflects that
1805   uint256 public override yieldRewardsPerWeight;
1806 
1807   /// @dev Used to calculate yield rewards, keeps track of the tokens weight locked in staking
1808   uint256 public override usersLockingWeight;
1809 
1810   /**
1811    * @dev Stake weight is proportional to deposit amount and time locked, precisely
1812    *      "deposit amount wei multiplied by (fraction of the year locked plus one)"
1813    * @dev To avoid significant precision loss due to multiplication by "fraction of the year" [0, 1],
1814    *      weight is stored multiplied by 1e6 constant, as an integer
1815    * @dev Corner case 1: if time locked is zero, weight is deposit amount multiplied by 1e6
1816    * @dev Corner case 2: if time locked is one year, fraction of the year locked is one, and
1817    *      weight is a deposit amount multiplied by 2 * 1e6
1818    */
1819   uint256 internal constant WEIGHT_MULTIPLIER = 1e6;
1820 
1821   /**
1822    * @dev When we know beforehand that staking is done for a year, and fraction of the year locked is one,
1823    *      we use simplified calculation and use the following constant instead previos one
1824    */
1825   uint256 internal constant YEAR_STAKE_WEIGHT_MULTIPLIER = 2 * WEIGHT_MULTIPLIER;
1826 
1827   /**
1828    * @dev Rewards per weight are stored multiplied by 1e12, as integers.
1829    */
1830   uint256 internal constant REWARD_PER_WEIGHT_MULTIPLIER = 1e12;
1831 
1832   /**
1833    * @dev Fired in _stake() and stake()
1834    *
1835    * @param _by an address which performed an operation, usually token holder
1836    * @param _from token holder address, the tokens will be returned to that address
1837    * @param amount amount of tokens staked
1838    */
1839   event Staked(address indexed _by, address indexed _from, uint256 amount);
1840 
1841   /**
1842    * @dev Fired in _updateStakeLock() and updateStakeLock()
1843    *
1844    * @param _by an address which performed an operation
1845    * @param depositId updated deposit ID
1846    * @param lockedFrom deposit locked from value
1847    * @param lockedUntil updated deposit locked until value
1848    */
1849   event StakeLockUpdated(address indexed _by, uint256 depositId, uint64 lockedFrom, uint64 lockedUntil);
1850 
1851   /**
1852    * @dev Fired in _unstake() and unstake()
1853    *
1854    * @param _by an address which performed an operation, usually token holder
1855    * @param _to an address which received the unstaked tokens, usually token holder
1856    * @param amount amount of tokens unstaked
1857    */
1858   event Unstaked(address indexed _by, address indexed _to, uint256 amount);
1859 
1860   /**
1861    * @dev Fired in _sync(), sync() and dependent functions (stake, unstake, etc.)
1862    *
1863    * @param _by an address which performed an operation
1864    * @param yieldRewardsPerWeight updated yield rewards per weight value
1865    * @param lastYieldDistribution usually, current block number
1866    */
1867   event Synchronized(address indexed _by, uint256 yieldRewardsPerWeight, uint64 lastYieldDistribution);
1868 
1869   /**
1870    * @dev Fired in _processRewards(), processRewards() and dependent functions (stake, unstake, etc.)
1871    *
1872    * @param _by an address which performed an operation
1873    * @param _to an address which claimed the yield reward
1874    * @param sIlv flag indicating if reward was paid (minted) in sILV
1875    * @param amount amount of yield paid
1876    */
1877   event YieldClaimed(address indexed _by, address indexed _to, bool sIlv, uint256 amount);
1878 
1879   /**
1880    * @dev Fired in setWeight()
1881    *
1882    * @param _by an address which performed an operation, always a factory
1883    * @param _fromVal old pool weight value
1884    * @param _toVal new pool weight value
1885    */
1886   event PoolWeightUpdated(address indexed _by, uint32 _fromVal, uint32 _toVal);
1887 
1888   /**
1889    * @dev Overridden in sub-contracts to construct the pool
1890    *
1891    * @param _ilv ILV ERC20 Token IlluviumERC20 address
1892    * @param _silv sILV ERC20 Token EscrowedIlluviumERC20 address
1893    * @param _factory Pool factory IlluviumPoolFactory instance/address
1894    * @param _poolToken token the pool operates on, for example ILV or ILV/ETH pair
1895    * @param _initBlock initial block used to calculate the rewards
1896    *      note: _initBlock can be set to the future effectively meaning _sync() calls will do nothing
1897    * @param _weight number representing a weight of the pool, actual weight fraction
1898    *      is calculated as that number divided by the total pools weight and doesn't exceed one
1899    */
1900   constructor(
1901     address _ilv,
1902     address _silv,
1903     IlluviumPoolFactory _factory,
1904     address _poolToken,
1905     uint64 _initBlock,
1906     uint32 _weight
1907   ) IlluviumAware(_ilv) {
1908     // verify the inputs are set
1909     require(_silv != address(0), "sILV address not set");
1910     require(address(_factory) != address(0), "ILV Pool fct address not set");
1911     require(_poolToken != address(0), "pool token address not set");
1912     require(_initBlock > 0, "init block not set");
1913     require(_weight > 0, "pool weight not set");
1914 
1915     // verify sILV instance supplied
1916     require(
1917       EscrowedIlluviumERC20(_silv).TOKEN_UID() ==
1918       0xac3051b8d4f50966afb632468a4f61483ae6a953b74e387a01ef94316d6b7d62,
1919       "unexpected sILV TOKEN_UID"
1920     );
1921     // verify IlluviumPoolFactory instance supplied
1922     require(
1923       _factory.FACTORY_UID() == 0xc5cfd88c6e4d7e5c8a03c255f03af23c0918d8e82cac196f57466af3fd4a5ec7,
1924       "unexpected FACTORY_UID"
1925     );
1926 
1927     // save the inputs into internal state variables
1928     silv = _silv;
1929     factory = _factory;
1930     poolToken = _poolToken;
1931     weight = _weight;
1932 
1933     // init the dependent internal state variables
1934     lastYieldDistribution = _initBlock;
1935   }
1936 
1937   /**
1938    * @notice Calculates current yield rewards value available for address specified
1939    *
1940    * @param _staker an address to calculate yield rewards value for
1941    * @return calculated yield reward value for the given address
1942    */
1943   function pendingYieldRewards(address _staker) external view override returns (uint256) {
1944     // `newYieldRewardsPerWeight` will store stored or recalculated value for `yieldRewardsPerWeight`
1945     uint256 newYieldRewardsPerWeight;
1946 
1947     // if smart contract state was not updated recently, `yieldRewardsPerWeight` value
1948     // is outdated and we need to recalculate it in order to calculate pending rewards correctly
1949     if (blockNumber() > lastYieldDistribution && usersLockingWeight != 0) {
1950       uint256 endBlock = factory.endBlock();
1951       uint256 multiplier =
1952       blockNumber() > endBlock ? endBlock - lastYieldDistribution : blockNumber() - lastYieldDistribution;
1953       uint256 ilvRewards = (multiplier * weight * factory.ilvPerBlock()) / factory.totalWeight();
1954 
1955       // recalculated value for `yieldRewardsPerWeight`
1956       newYieldRewardsPerWeight = rewardToWeight(ilvRewards, usersLockingWeight) + yieldRewardsPerWeight;
1957     } else {
1958       // if smart contract state is up to date, we don't recalculate
1959       newYieldRewardsPerWeight = yieldRewardsPerWeight;
1960     }
1961 
1962     // based on the rewards per weight value, calculate pending rewards;
1963     User memory user = users[_staker];
1964     uint256 pending = weightToReward(user.totalWeight, newYieldRewardsPerWeight) - user.subYieldRewards;
1965 
1966     return pending;
1967   }
1968 
1969   /**
1970    * @notice Returns total staked token balance for the given address
1971    *
1972    * @param _user an address to query balance for
1973    * @return total staked token balance
1974    */
1975   function balanceOf(address _user) external view override returns (uint256) {
1976     // read specified user token amount and return
1977     return users[_user].tokenAmount;
1978   }
1979 
1980   /**
1981    * @notice Returns information on the given deposit for the given address
1982    *
1983    * @dev See getDepositsLength
1984    *
1985    * @param _user an address to query deposit for
1986    * @param _depositId zero-indexed deposit ID for the address specified
1987    * @return deposit info as Deposit structure
1988    */
1989   function getDeposit(address _user, uint256 _depositId) external view override returns (Deposit memory) {
1990     // read deposit at specified index and return
1991     return users[_user].deposits[_depositId];
1992   }
1993 
1994   /**
1995    * @notice Returns number of deposits for the given address. Allows iteration over deposits.
1996    *
1997    * @dev See getDeposit
1998    *
1999    * @param _user an address to query deposit length for
2000    * @return number of deposits for the given address
2001    */
2002   function getDepositsLength(address _user) external view override returns (uint256) {
2003     // read deposits array length and return
2004     return users[_user].deposits.length;
2005   }
2006 
2007   /**
2008    * @notice Stakes specified amount of tokens for the specified amount of time,
2009    *      and pays pending yield rewards if any
2010    *
2011    * @dev Requires amount to stake to be greater than zero
2012    *
2013    * @param _amount amount of tokens to stake
2014    * @param _lockUntil stake period as unix timestamp; zero means no locking
2015    * @param _useSILV a flag indicating if previous reward to be paid as sILV
2016    */
2017   function stake(
2018     uint256 _amount,
2019     uint64 _lockUntil,
2020     bool _useSILV
2021   ) external override {
2022     // delegate call to an internal function
2023     _stake(msg.sender, _amount, _lockUntil, _useSILV, false);
2024   }
2025 
2026   /**
2027    * @notice Unstakes specified amount of tokens, and pays pending yield rewards if any
2028    *
2029    * @dev Requires amount to unstake to be greater than zero
2030    *
2031    * @param _depositId deposit ID to unstake from, zero-indexed
2032    * @param _amount amount of tokens to unstake
2033    * @param _useSILV a flag indicating if reward to be paid as sILV
2034    */
2035   function unstake(
2036     uint256 _depositId,
2037     uint256 _amount,
2038     bool _useSILV
2039   ) external override {
2040     // delegate call to an internal function
2041     _unstake(msg.sender, _depositId, _amount, _useSILV);
2042   }
2043 
2044   /**
2045    * @notice Extends locking period for a given deposit
2046    *
2047    * @dev Requires new lockedUntil value to be:
2048    *      higher than the current one, and
2049    *      in the future, but
2050    *      no more than 1 year in the future
2051    *
2052    * @param depositId updated deposit ID
2053    * @param lockedUntil updated deposit locked until value
2054    * @param useSILV used for _processRewards check if it should use ILV or sILV
2055    */
2056   function updateStakeLock(
2057     uint256 depositId,
2058     uint64 lockedUntil,
2059     bool useSILV
2060   ) external {
2061     // sync and call processRewards
2062     _sync();
2063     _processRewards(msg.sender, useSILV, false);
2064     // delegate call to an internal function
2065     _updateStakeLock(msg.sender, depositId, lockedUntil);
2066   }
2067 
2068   /**
2069    * @notice Service function to synchronize pool state with current time
2070    *
2071    * @dev Can be executed by anyone at any time, but has an effect only when
2072    *      at least one block passes between synchronizations
2073    * @dev Executed internally when staking, unstaking, processing rewards in order
2074    *      for calculations to be correct and to reflect state progress of the contract
2075    * @dev When timing conditions are not met (executed too frequently, or after factory
2076    *      end block), function doesn't throw and exits silently
2077    */
2078   function sync() external override {
2079     // delegate call to an internal function
2080     _sync();
2081   }
2082 
2083   /**
2084    * @notice Service function to calculate and pay pending yield rewards to the sender
2085    *
2086    * @dev Can be executed by anyone at any time, but has an effect only when
2087    *      executed by deposit holder and when at least one block passes from the
2088    *      previous reward processing
2089    * @dev Executed internally when staking and unstaking, executes sync() under the hood
2090    *      before making further calculations and payouts
2091    * @dev When timing conditions are not met (executed too frequently, or after factory
2092    *      end block), function doesn't throw and exits silently
2093    *
2094    * @param _useSILV flag indicating whether to mint sILV token as a reward or not;
2095    *      when set to true - sILV reward is minted immediately and sent to sender,
2096    *      when set to false - new ILV reward deposit gets created if pool is an ILV pool
2097    *      (poolToken is ILV token), or new pool deposit gets created together with sILV minted
2098    *      when pool is not an ILV pool (poolToken is not an ILV token)
2099    */
2100   function processRewards(bool _useSILV) external virtual override {
2101     // delegate call to an internal function
2102     _processRewards(msg.sender, _useSILV, true);
2103   }
2104 
2105   /**
2106    * @dev Executed by the factory to modify pool weight; the factory is expected
2107    *      to keep track of the total pools weight when updating
2108    *
2109    * @dev Set weight to zero to disable the pool
2110    *
2111    * @param _weight new weight to set for the pool
2112    */
2113   function setWeight(uint32 _weight) external override {
2114     // verify function is executed by the factory
2115     require(msg.sender == address(factory), "access denied");
2116 
2117     // emit an event logging old and new weight values
2118     emit PoolWeightUpdated(msg.sender, weight, _weight);
2119 
2120     // set the new weight value
2121     weight = _weight;
2122   }
2123 
2124   /**
2125    * @dev Similar to public pendingYieldRewards, but performs calculations based on
2126    *      current smart contract state only, not taking into account any additional
2127    *      time/blocks which might have passed
2128    *
2129    * @param _staker an address to calculate yield rewards value for
2130    * @return pending calculated yield reward value for the given address
2131    */
2132   function _pendingYieldRewards(address _staker) internal view returns (uint256 pending) {
2133     // read user data structure into memory
2134     User memory user = users[_staker];
2135 
2136     // and perform the calculation using the values read
2137     return weightToReward(user.totalWeight, yieldRewardsPerWeight) - user.subYieldRewards;
2138   }
2139 
2140   /**
2141    * @dev Used internally, mostly by children implementations, see stake()
2142    *
2143    * @param _staker an address which stakes tokens and which will receive them back
2144    * @param _amount amount of tokens to stake
2145    * @param _lockUntil stake period as unix timestamp; zero means no locking
2146    * @param _useSILV a flag indicating if previous reward to be paid as sILV
2147    * @param _isYield a flag indicating if that stake is created to store yield reward
2148    *      from the previously unstaked stake
2149    */
2150   function _stake(
2151     address _staker,
2152     uint256 _amount,
2153     uint64 _lockUntil,
2154     bool _useSILV,
2155     bool _isYield
2156   ) internal virtual {
2157     // validate the inputs
2158     require(_amount > 0, "zero amount");
2159     require(
2160       _lockUntil == 0 || (_lockUntil > now256() && _lockUntil - now256() <= 365 days),
2161       "invalid lock interval"
2162     );
2163 
2164     // update smart contract state
2165     _sync();
2166 
2167     // get a link to user data struct, we will write to it later
2168     User storage user = users[_staker];
2169     // process current pending rewards if any
2170     if (user.tokenAmount > 0) {
2171       _processRewards(_staker, _useSILV, false);
2172     }
2173 
2174     // in most of the cases added amount `addedAmount` is simply `_amount`
2175     // however for deflationary tokens this can be different
2176 
2177     // read the current balance
2178     uint256 previousBalance = IERC20(poolToken).balanceOf(address(this));
2179     // transfer `_amount`; note: some tokens may get burnt here
2180     transferPoolTokenFrom(address(msg.sender), address(this), _amount);
2181     // read new balance, usually this is just the difference `previousBalance - _amount`
2182     uint256 newBalance = IERC20(poolToken).balanceOf(address(this));
2183     // calculate real amount taking into account deflation
2184     uint256 addedAmount = newBalance - previousBalance;
2185 
2186     // set the `lockFrom` and `lockUntil` taking into account that
2187     // zero value for `_lockUntil` means "no locking" and leads to zero values
2188     // for both `lockFrom` and `lockUntil`
2189     uint64 lockFrom = _lockUntil > 0 ? uint64(now256()) : 0;
2190     uint64 lockUntil = _lockUntil;
2191 
2192     // stake weight formula rewards for locking
2193     uint256 stakeWeight =
2194     (((lockUntil - lockFrom) * WEIGHT_MULTIPLIER) / 365 days + WEIGHT_MULTIPLIER) * addedAmount;
2195 
2196     // makes sure stakeWeight is valid
2197     assert(stakeWeight > 0);
2198 
2199     // create and save the deposit (append it to deposits array)
2200     Deposit memory deposit =
2201     Deposit({
2202     tokenAmount: addedAmount,
2203     weight: stakeWeight,
2204     lockedFrom: lockFrom,
2205     lockedUntil: lockUntil,
2206     isYield: _isYield
2207     });
2208     // deposit ID is an index of the deposit in `deposits` array
2209     user.deposits.push(deposit);
2210 
2211     // update user record
2212     user.tokenAmount += addedAmount;
2213     user.totalWeight += stakeWeight;
2214     user.subYieldRewards = weightToReward(user.totalWeight, yieldRewardsPerWeight);
2215 
2216     // update global variable
2217     usersLockingWeight += stakeWeight;
2218 
2219     // emit an event
2220     emit Staked(msg.sender, _staker, _amount);
2221   }
2222 
2223   /**
2224    * @dev Used internally, mostly by children implementations, see unstake()
2225    *
2226    * @param _staker an address which unstakes tokens (which previously staked them)
2227    * @param _depositId deposit ID to unstake from, zero-indexed
2228    * @param _amount amount of tokens to unstake
2229    * @param _useSILV a flag indicating if reward to be paid as sILV
2230    */
2231   function _unstake(
2232     address _staker,
2233     uint256 _depositId,
2234     uint256 _amount,
2235     bool _useSILV
2236   ) internal virtual {
2237     // verify an amount is set
2238     require(_amount > 0, "zero amount");
2239 
2240     // get a link to user data struct, we will write to it later
2241     User storage user = users[_staker];
2242     // get a link to the corresponding deposit, we may write to it later
2243     Deposit storage stakeDeposit = user.deposits[_depositId];
2244     // deposit structure may get deleted, so we save isYield flag to be able to use it
2245     bool isYield = stakeDeposit.isYield;
2246 
2247     // verify available balance
2248     // if staker address ot deposit doesn't exist this check will fail as well
2249     require(stakeDeposit.tokenAmount >= _amount, "amount exceeds stake");
2250 
2251     // update smart contract state
2252     _sync();
2253     // and process current pending rewards if any
2254     _processRewards(_staker, _useSILV, false);
2255 
2256     // recalculate deposit weight
2257     uint256 previousWeight = stakeDeposit.weight;
2258     uint256 newWeight =
2259     (((stakeDeposit.lockedUntil - stakeDeposit.lockedFrom) * WEIGHT_MULTIPLIER) /
2260     365 days +
2261     WEIGHT_MULTIPLIER) * (stakeDeposit.tokenAmount - _amount);
2262 
2263     // update the deposit, or delete it if its depleted
2264     if (stakeDeposit.tokenAmount - _amount == 0) {
2265       delete user.deposits[_depositId];
2266     } else {
2267       stakeDeposit.tokenAmount -= _amount;
2268       stakeDeposit.weight = newWeight;
2269     }
2270 
2271     // update user record
2272     user.tokenAmount -= _amount;
2273     user.totalWeight = user.totalWeight - previousWeight + newWeight;
2274     user.subYieldRewards = weightToReward(user.totalWeight, yieldRewardsPerWeight);
2275 
2276     // update global variable
2277     usersLockingWeight = usersLockingWeight - previousWeight + newWeight;
2278 
2279     // if the deposit was created by the pool itself as a yield reward
2280     if (isYield) {
2281       // mint the yield via the factory
2282       factory.mintYieldTo(msg.sender, _amount);
2283     } else {
2284       // otherwise just return tokens back to holder
2285       transferPoolToken(msg.sender, _amount);
2286     }
2287 
2288     // emit an event
2289     emit Unstaked(msg.sender, _staker, _amount);
2290   }
2291 
2292   /**
2293    * @dev Used internally, mostly by children implementations, see sync()
2294    *
2295    * @dev Updates smart contract state (`yieldRewardsPerWeight`, `lastYieldDistribution`),
2296    *      updates factory state via `updateILVPerBlock`
2297    */
2298   function _sync() internal virtual {
2299     // update ILV per block value in factory if required
2300     if (factory.shouldUpdateRatio()) {
2301       factory.updateILVPerBlock();
2302     }
2303 
2304     // check bound conditions and if these are not met -
2305     // exit silently, without emitting an event
2306     uint256 endBlock = factory.endBlock();
2307     if (lastYieldDistribution >= endBlock) {
2308       return;
2309     }
2310     if (blockNumber() <= lastYieldDistribution) {
2311       return;
2312     }
2313     // if locking weight is zero - update only `lastYieldDistribution` and exit
2314     if (usersLockingWeight == 0) {
2315       lastYieldDistribution = uint64(blockNumber());
2316       return;
2317     }
2318 
2319     // to calculate the reward we need to know how many blocks passed, and reward per block
2320     uint256 currentBlock = blockNumber() > endBlock ? endBlock : blockNumber();
2321     uint256 blocksPassed = currentBlock - lastYieldDistribution;
2322     uint256 ilvPerBlock = factory.ilvPerBlock();
2323 
2324     // calculate the reward
2325     uint256 ilvReward = (blocksPassed * ilvPerBlock * weight) / factory.totalWeight();
2326 
2327     // update rewards per weight and `lastYieldDistribution`
2328     yieldRewardsPerWeight += rewardToWeight(ilvReward, usersLockingWeight);
2329     lastYieldDistribution = uint64(currentBlock);
2330 
2331     // emit an event
2332     emit Synchronized(msg.sender, yieldRewardsPerWeight, lastYieldDistribution);
2333   }
2334 
2335   /**
2336    * @dev Used internally, mostly by children implementations, see processRewards()
2337    *
2338    * @param _staker an address which receives the reward (which has staked some tokens earlier)
2339    * @param _useSILV flag indicating whether to mint sILV token as a reward or not, see processRewards()
2340    * @param _withUpdate flag allowing to disable synchronization (see sync()) if set to false
2341    * @return pendingYield the rewards calculated and optionally re-staked
2342    */
2343   function _processRewards(
2344     address _staker,
2345     bool _useSILV,
2346     bool _withUpdate
2347   ) internal virtual returns (uint256 pendingYield) {
2348     // update smart contract state if required
2349     if (_withUpdate) {
2350       _sync();
2351     }
2352 
2353     // calculate pending yield rewards, this value will be returned
2354     pendingYield = _pendingYieldRewards(_staker);
2355 
2356     // if pending yield is zero - just return silently
2357     if (pendingYield == 0) return 0;
2358 
2359     // get link to a user data structure, we will write into it later
2360     User storage user = users[_staker];
2361 
2362     // if sILV is requested
2363     if (_useSILV) {
2364       // - mint sILV
2365       mintSIlv(_staker, pendingYield);
2366     } else if (poolToken == ilv) {
2367       // calculate pending yield weight,
2368       // 2e6 is the bonus weight when staking for 1 year
2369       uint256 depositWeight = pendingYield * YEAR_STAKE_WEIGHT_MULTIPLIER;
2370 
2371       // if the pool is ILV Pool - create new ILV deposit
2372       // and save it - push it into deposits array
2373       Deposit memory newDeposit =
2374       Deposit({
2375       tokenAmount: pendingYield,
2376       lockedFrom: uint64(now256()),
2377       lockedUntil: uint64(now256() + 365 days), // staking yield for 1 year
2378       weight: depositWeight,
2379       isYield: true
2380       });
2381       user.deposits.push(newDeposit);
2382 
2383       // update user record
2384       user.tokenAmount += pendingYield;
2385       user.totalWeight += depositWeight;
2386 
2387       // update global variable
2388       usersLockingWeight += depositWeight;
2389     } else {
2390       // for other pools - stake as pool
2391       address ilvPool = factory.getPoolAddress(ilv);
2392       ICorePool(ilvPool).stakeAsPool(_staker, pendingYield);
2393     }
2394 
2395     // update users's record for `subYieldRewards` if requested
2396     if (_withUpdate) {
2397       user.subYieldRewards = weightToReward(user.totalWeight, yieldRewardsPerWeight);
2398     }
2399 
2400     // emit an event
2401     emit YieldClaimed(msg.sender, _staker, _useSILV, pendingYield);
2402   }
2403 
2404   /**
2405    * @dev See updateStakeLock()
2406    *
2407    * @param _staker an address to update stake lock
2408    * @param _depositId updated deposit ID
2409    * @param _lockedUntil updated deposit locked until value
2410    */
2411   function _updateStakeLock(
2412     address _staker,
2413     uint256 _depositId,
2414     uint64 _lockedUntil
2415   ) internal {
2416     // validate the input time
2417     require(_lockedUntil > now256(), "lock should be in the future");
2418 
2419     // get a link to user data struct, we will write to it later
2420     User storage user = users[_staker];
2421     // get a link to the corresponding deposit, we may write to it later
2422     Deposit storage stakeDeposit = user.deposits[_depositId];
2423 
2424     // validate the input against deposit structure
2425     require(_lockedUntil > stakeDeposit.lockedUntil, "invalid new lock");
2426 
2427     // verify locked from and locked until values
2428     if (stakeDeposit.lockedFrom == 0) {
2429       require(_lockedUntil - now256() <= 365 days, "max lock period is 365 days");
2430       stakeDeposit.lockedFrom = uint64(now256());
2431     } else {
2432       require(_lockedUntil - stakeDeposit.lockedFrom <= 365 days, "max lock period is 365 days");
2433     }
2434 
2435     // update locked until value, calculate new weight
2436     stakeDeposit.lockedUntil = _lockedUntil;
2437     uint256 newWeight =
2438     (((stakeDeposit.lockedUntil - stakeDeposit.lockedFrom) * WEIGHT_MULTIPLIER) /
2439     365 days +
2440     WEIGHT_MULTIPLIER) * stakeDeposit.tokenAmount;
2441 
2442     // save previous weight
2443     uint256 previousWeight = stakeDeposit.weight;
2444     // update weight
2445     stakeDeposit.weight = newWeight;
2446 
2447     // update user total weight and global locking weight
2448     user.totalWeight = user.totalWeight - previousWeight + newWeight;
2449     usersLockingWeight = usersLockingWeight - previousWeight + newWeight;
2450 
2451     // emit an event
2452     emit StakeLockUpdated(_staker, _depositId, stakeDeposit.lockedFrom, _lockedUntil);
2453   }
2454 
2455   /**
2456    * @dev Converts stake weight (not to be mixed with the pool weight) to
2457    *      ILV reward value, applying the 10^12 division on weight
2458    *
2459    * @param _weight stake weight
2460    * @param rewardPerWeight ILV reward per weight
2461    * @return reward value normalized to 10^12
2462    */
2463   function weightToReward(uint256 _weight, uint256 rewardPerWeight) public pure returns (uint256) {
2464     // apply the formula and return
2465     return (_weight * rewardPerWeight) / REWARD_PER_WEIGHT_MULTIPLIER;
2466   }
2467 
2468   /**
2469    * @dev Converts reward ILV value to stake weight (not to be mixed with the pool weight),
2470    *      applying the 10^12 multiplication on the reward
2471    *      - OR -
2472    * @dev Converts reward ILV value to reward/weight if stake weight is supplied as second
2473    *      function parameter instead of reward/weight
2474    *
2475    * @param reward yield reward
2476    * @param rewardPerWeight reward/weight (or stake weight)
2477    * @return stake weight (or reward/weight)
2478    */
2479   function rewardToWeight(uint256 reward, uint256 rewardPerWeight) public pure returns (uint256) {
2480     // apply the reverse formula and return
2481     return (reward * REWARD_PER_WEIGHT_MULTIPLIER) / rewardPerWeight;
2482   }
2483 
2484   /**
2485    * @dev Testing time-dependent functionality is difficult and the best way of
2486    *      doing it is to override block number in helper test smart contracts
2487    *
2488    * @return `block.number` in mainnet, custom values in testnets (if overridden)
2489    */
2490   function blockNumber() public view virtual returns (uint256) {
2491     // return current block number
2492     return block.number;
2493   }
2494 
2495   /**
2496    * @dev Testing time-dependent functionality is difficult and the best way of
2497    *      doing it is to override time in helper test smart contracts
2498    *
2499    * @return `block.timestamp` in mainnet, custom values in testnets (if overridden)
2500    */
2501   function now256() public view virtual returns (uint256) {
2502     // return current block timestamp
2503     return block.timestamp;
2504   }
2505 
2506   /**
2507    * @dev Executes EscrowedIlluviumERC20.mint(_to, _values)
2508    *      on the bound EscrowedIlluviumERC20 instance
2509    *
2510    * @dev Reentrancy safe due to the EscrowedIlluviumERC20 design
2511    */
2512   function mintSIlv(address _to, uint256 _value) private {
2513     // just delegate call to the target
2514     EscrowedIlluviumERC20(silv).mint(_to, _value);
2515   }
2516 
2517   /**
2518    * @dev Executes SafeERC20.safeTransfer on a pool token
2519    *
2520    * @dev Reentrancy safety enforced via `ReentrancyGuard.nonReentrant`
2521    */
2522   function transferPoolToken(address _to, uint256 _value) internal nonReentrant {
2523     // just delegate call to the target
2524     SafeERC20.safeTransfer(IERC20(poolToken), _to, _value);
2525   }
2526 
2527   /**
2528    * @dev Executes SafeERC20.safeTransferFrom on a pool token
2529    *
2530    * @dev Reentrancy safety enforced via `ReentrancyGuard.nonReentrant`
2531    */
2532   function transferPoolTokenFrom(
2533     address _from,
2534     address _to,
2535     uint256 _value
2536   ) internal nonReentrant {
2537     // just delegate call to the target
2538     SafeERC20.safeTransferFrom(IERC20(poolToken), _from, _to, _value);
2539   }
2540 }
2541 
2542 /**
2543  * @title Illuvium Core Pool
2544  *
2545  * @notice Core pools represent permanent pools like ILV or ILV/ETH Pair pool,
2546  *      core pools allow staking for arbitrary periods of time up to 1 year
2547  *
2548  * @dev See IlluviumPoolBase for more details
2549  *
2550  * @author Pedro Bergamini, reviewed by Basil Gorin
2551  */
2552 contract IlluviumCorePool is IlluviumPoolBase {
2553   /// @dev Flag indicating pool type, false means "core pool"
2554   bool public constant override isFlashPool = false;
2555 
2556   /// @dev Link to deployed IlluviumVault instance
2557   address public vault;
2558 
2559   /// @dev Used to calculate vault rewards
2560   /// @dev This value is different from "reward per token" used in locked pool
2561   /// @dev Note: stakes are different in duration and "weight" reflects that
2562   uint256 public vaultRewardsPerWeight;
2563 
2564   /// @dev Pool tokens value available in the pool;
2565   ///      pool token examples are ILV (ILV core pool) or ILV/ETH pair (LP core pool)
2566   /// @dev For LP core pool this value doesnt' count for ILV tokens received as Vault rewards
2567   ///      while for ILV core pool it does count for such tokens as well
2568   uint256 public poolTokenReserve;
2569 
2570   /**
2571    * @dev Fired in receiveVaultRewards()
2572    *
2573    * @param _by an address that sent the rewards, always a vault
2574    * @param amount amount of tokens received
2575    */
2576   event VaultRewardsReceived(address indexed _by, uint256 amount);
2577 
2578   /**
2579    * @dev Fired in _processVaultRewards() and dependent functions, like processRewards()
2580    *
2581    * @param _by an address which executed the function
2582    * @param _to an address which received a reward
2583    * @param amount amount of reward received
2584    */
2585   event VaultRewardsClaimed(address indexed _by, address indexed _to, uint256 amount);
2586 
2587   /**
2588    * @dev Fired in setVault()
2589    *
2590    * @param _by an address which executed the function, always a factory owner
2591    */
2592   event VaultUpdated(address indexed _by, address _fromVal, address _toVal);
2593 
2594   /**
2595    * @dev Creates/deploys an instance of the core pool
2596    *
2597    * @param _ilv ILV ERC20 Token IlluviumERC20 address
2598    * @param _silv sILV ERC20 Token EscrowedIlluviumERC20 address
2599    * @param _factory Pool factory IlluviumPoolFactory instance/address
2600    * @param _poolToken token the pool operates on, for example ILV or ILV/ETH pair
2601    * @param _initBlock initial block used to calculate the rewards
2602    * @param _weight number representing a weight of the pool, actual weight fraction
2603    *      is calculated as that number divided by the total pools weight and doesn't exceed one
2604    */
2605   constructor(
2606     address _ilv,
2607     address _silv,
2608     IlluviumPoolFactory _factory,
2609     address _poolToken,
2610     uint64 _initBlock,
2611     uint32 _weight
2612   ) IlluviumPoolBase(_ilv, _silv, _factory, _poolToken, _initBlock, _weight) {}
2613 
2614   /**
2615    * @notice Calculates current vault rewards value available for address specified
2616    *
2617    * @dev Performs calculations based on current smart contract state only,
2618    *      not taking into account any additional time/blocks which might have passed
2619    *
2620    * @param _staker an address to calculate vault rewards value for
2621    * @return pending calculated vault reward value for the given address
2622    */
2623   function pendingVaultRewards(address _staker) public view returns (uint256 pending) {
2624     User memory user = users[_staker];
2625 
2626     return weightToReward(user.totalWeight, vaultRewardsPerWeight) - user.subVaultRewards;
2627   }
2628 
2629   /**
2630    * @dev Executed only by the factory owner to Set the vault
2631    *
2632    * @param _vault an address of deployed IlluviumVault instance
2633    */
2634   function setVault(address _vault) external {
2635     // verify function is executed by the factory owner
2636     require(factory.owner() == msg.sender, "access denied");
2637 
2638     // verify input is set
2639     require(_vault != address(0), "zero input");
2640 
2641     // emit an event
2642     emit VaultUpdated(msg.sender, vault, _vault);
2643 
2644     // update vault address
2645     vault = _vault;
2646   }
2647 
2648   /**
2649    * @dev Executed by the vault to transfer vault rewards ILV from the vault
2650    *      into the pool
2651    *
2652    * @dev This function is executed only for ILV core pools
2653    *
2654    * @param _rewardsAmount amount of ILV rewards to transfer into the pool
2655    */
2656   function receiveVaultRewards(uint256 _rewardsAmount) external {
2657     require(msg.sender == vault, "access denied");
2658     // return silently if there is no reward to receive
2659     if (_rewardsAmount == 0) {
2660       return;
2661     }
2662     require(usersLockingWeight > 0, "zero locking weight");
2663 
2664     transferIlvFrom(msg.sender, address(this), _rewardsAmount);
2665 
2666     vaultRewardsPerWeight += rewardToWeight(_rewardsAmount, usersLockingWeight);
2667 
2668     // update `poolTokenReserve` only if this is a ILV Core Pool
2669     if (poolToken == ilv) {
2670       poolTokenReserve += _rewardsAmount;
2671     }
2672 
2673     emit VaultRewardsReceived(msg.sender, _rewardsAmount);
2674   }
2675 
2676   /**
2677    * @notice Service function to calculate and pay pending vault and yield rewards to the sender
2678    *
2679    * @dev Internally executes similar function `_processRewards` from the parent smart contract
2680    *      to calculate and pay yield rewards; adds vault rewards processing
2681    *
2682    * @dev Can be executed by anyone at any time, but has an effect only when
2683    *      executed by deposit holder and when at least one block passes from the
2684    *      previous reward processing
2685    * @dev Executed internally when "staking as a pool" (`stakeAsPool`)
2686    * @dev When timing conditions are not met (executed too frequently, or after factory
2687    *      end block), function doesn't throw and exits silently
2688    *
2689    * @dev _useSILV flag has a context of yield rewards only
2690    *
2691    * @param _useSILV flag indicating whether to mint sILV token as a reward or not;
2692    *      when set to true - sILV reward is minted immediately and sent to sender,
2693    *      when set to false - new ILV reward deposit gets created if pool is an ILV pool
2694    *      (poolToken is ILV token), or new pool deposit gets created together with sILV minted
2695    *      when pool is not an ILV pool (poolToken is not an ILV token)
2696    */
2697   function processRewards(bool _useSILV) external override {
2698     _processRewards(msg.sender, _useSILV, true);
2699   }
2700 
2701   /**
2702    * @dev Executed internally by the pool itself (from the parent `IlluviumPoolBase` smart contract)
2703    *      as part of yield rewards processing logic (`IlluviumPoolBase._processRewards` function)
2704    * @dev Executed when _useSILV is false and pool is not an ILV pool - see `IlluviumPoolBase._processRewards`
2705    *
2706    * @param _staker an address which stakes (the yield reward)
2707    * @param _amount amount to be staked (yield reward amount)
2708    */
2709   function stakeAsPool(address _staker, uint256 _amount) external {
2710     require(factory.poolExists(msg.sender), "access denied");
2711     _sync();
2712     User storage user = users[_staker];
2713     if (user.tokenAmount > 0) {
2714       _processRewards(_staker, true, false);
2715     }
2716     uint256 depositWeight = _amount * YEAR_STAKE_WEIGHT_MULTIPLIER;
2717     Deposit memory newDeposit =
2718     Deposit({
2719     tokenAmount: _amount,
2720     lockedFrom: uint64(now256()),
2721     lockedUntil: uint64(now256() + 365 days),
2722     weight: depositWeight,
2723     isYield: true
2724     });
2725     user.tokenAmount += _amount;
2726     user.totalWeight += depositWeight;
2727     user.deposits.push(newDeposit);
2728 
2729     usersLockingWeight += depositWeight;
2730 
2731     user.subYieldRewards = weightToReward(user.totalWeight, yieldRewardsPerWeight);
2732     user.subVaultRewards = weightToReward(user.totalWeight, vaultRewardsPerWeight);
2733 
2734     // update `poolTokenReserve` only if this is a LP Core Pool (stakeAsPool can be executed only for LP pool)
2735     poolTokenReserve += _amount;
2736   }
2737 
2738   /**
2739    * @inheritdoc IlluviumPoolBase
2740    *
2741    * @dev Additionally to the parent smart contract, updates vault rewards of the holder,
2742    *      and updates (increases) pool token reserve (pool tokens value available in the pool)
2743    */
2744   function _stake(
2745     address _staker,
2746     uint256 _amount,
2747     uint64 _lockedUntil,
2748     bool _useSILV,
2749     bool _isYield
2750   ) internal override {
2751     super._stake(_staker, _amount, _lockedUntil, _useSILV, _isYield);
2752     User storage user = users[_staker];
2753     user.subVaultRewards = weightToReward(user.totalWeight, vaultRewardsPerWeight);
2754 
2755     poolTokenReserve += _amount;
2756   }
2757 
2758   /**
2759    * @inheritdoc IlluviumPoolBase
2760    *
2761    * @dev Additionally to the parent smart contract, updates vault rewards of the holder,
2762    *      and updates (decreases) pool token reserve (pool tokens value available in the pool)
2763    */
2764   function _unstake(
2765     address _staker,
2766     uint256 _depositId,
2767     uint256 _amount,
2768     bool _useSILV
2769   ) internal override {
2770     User storage user = users[_staker];
2771     Deposit memory stakeDeposit = user.deposits[_depositId];
2772     require(stakeDeposit.lockedFrom == 0 || now256() > stakeDeposit.lockedUntil, "deposit not yet unlocked");
2773     poolTokenReserve -= _amount;
2774     super._unstake(_staker, _depositId, _amount, _useSILV);
2775     user.subVaultRewards = weightToReward(user.totalWeight, vaultRewardsPerWeight);
2776   }
2777 
2778   /**
2779    * @inheritdoc IlluviumPoolBase
2780    *
2781    * @dev Additionally to the parent smart contract, processes vault rewards of the holder,
2782    *      and for ILV pool updates (increases) pool token reserve (pool tokens value available in the pool)
2783    */
2784   function _processRewards(
2785     address _staker,
2786     bool _useSILV,
2787     bool _withUpdate
2788   ) internal override returns (uint256 pendingYield) {
2789     _processVaultRewards(_staker);
2790     pendingYield = super._processRewards(_staker, _useSILV, _withUpdate);
2791 
2792     // update `poolTokenReserve` only if this is a ILV Core Pool
2793     if (poolToken == ilv && !_useSILV) {
2794       poolTokenReserve += pendingYield;
2795     }
2796   }
2797 
2798   /**
2799    * @dev Used internally to process vault rewards for the staker
2800    *
2801    * @param _staker address of the user (staker) to process rewards for
2802    */
2803   function _processVaultRewards(address _staker) private {
2804     User storage user = users[_staker];
2805     uint256 pendingVaultClaim = pendingVaultRewards(_staker);
2806     if (pendingVaultClaim == 0) return;
2807     // read ILV token balance of the pool via standard ERC20 interface
2808     uint256 ilvBalance = IERC20(ilv).balanceOf(address(this));
2809     require(ilvBalance >= pendingVaultClaim, "contract ILV balance too low");
2810 
2811     // update `poolTokenReserve` only if this is a ILV Core Pool
2812     if (poolToken == ilv) {
2813       // protects against rounding errors
2814       poolTokenReserve -= pendingVaultClaim > poolTokenReserve ? poolTokenReserve : pendingVaultClaim;
2815     }
2816 
2817     user.subVaultRewards = weightToReward(user.totalWeight, vaultRewardsPerWeight);
2818 
2819     // transfer fails if pool ILV balance is not enough - which is a desired behavior
2820     transferIlv(_staker, pendingVaultClaim);
2821 
2822     emit VaultRewardsClaimed(msg.sender, _staker, pendingVaultClaim);
2823   }
2824 }
2825 
2826 /**
2827  * @title Illuvium Pool Factory
2828  *
2829  * @notice ILV Pool Factory manages Illuvium Yield farming pools, provides a single
2830  *      public interface to access the pools, provides an interface for the pools
2831  *      to mint yield rewards, access pool-related info, update weights, etc.
2832  *
2833  * @notice The factory is authorized (via its owner) to register new pools, change weights
2834  *      of the existing pools, removing the pools (by changing their weights to zero)
2835  *
2836  * @dev The factory requires ROLE_TOKEN_CREATOR permission on the ILV token to mint yield
2837  *      (see `mintYieldTo` function)
2838  *
2839  * @author Pedro Bergamini, reviewed by Basil Gorin
2840  */
2841 contract IlluviumPoolFactory is Ownable, IlluviumAware {
2842   /**
2843    * @dev Smart contract unique identifier, a random number
2844    * @dev Should be regenerated each time smart contact source code is changed
2845    *      and changes smart contract itself is to be redeployed
2846    * @dev Generated using https://www.random.org/bytes/
2847    */
2848   uint256 public constant FACTORY_UID = 0xc5cfd88c6e4d7e5c8a03c255f03af23c0918d8e82cac196f57466af3fd4a5ec7;
2849 
2850   /// @dev Auxiliary data structure used only in getPoolData() view function
2851   struct PoolData {
2852     // @dev pool token address (like ILV)
2853     address poolToken;
2854     // @dev pool address (like deployed core pool instance)
2855     address poolAddress;
2856     // @dev pool weight (200 for ILV pools, 800 for ILV/ETH pools - set during deployment)
2857     uint32 weight;
2858     // @dev flash pool flag
2859     bool isFlashPool;
2860   }
2861 
2862   /**
2863    * @dev ILV/block determines yield farming reward base
2864    *      used by the yield pools controlled by the factory
2865    */
2866   uint192 public ilvPerBlock;
2867 
2868   /**
2869    * @dev The yield is distributed proportionally to pool weights;
2870    *      total weight is here to help in determining the proportion
2871    */
2872   uint32 public totalWeight;
2873 
2874   /**
2875    * @dev ILV/block decreases by 3% every blocks/update (set to 91252 blocks during deployment);
2876    *      an update is triggered by executing `updateILVPerBlock` public function
2877    */
2878   uint32 public immutable blocksPerUpdate;
2879 
2880   /**
2881    * @dev End block is the last block when ILV/block can be decreased;
2882    *      it is implied that yield farming stops after that block
2883    */
2884   uint32 public endBlock;
2885 
2886   /**
2887    * @dev Each time the ILV/block ratio gets updated, the block number
2888    *      when the operation has occurred gets recorded into `lastRatioUpdate`
2889    * @dev This block number is then used to check if blocks/update `blocksPerUpdate`
2890    *      has passed when decreasing yield reward by 3%
2891    */
2892   uint32 public lastRatioUpdate;
2893 
2894   /// @dev sILV token address is used to create ILV core pool(s)
2895   address public immutable silv;
2896 
2897   /// @dev Maps pool token address (like ILV) -> pool address (like core pool instance)
2898   mapping(address => address) public pools;
2899 
2900   /// @dev Keeps track of registered pool addresses, maps pool address -> exists flag
2901   mapping(address => bool) public poolExists;
2902 
2903   /**
2904    * @dev Fired in createPool() and registerPool()
2905    *
2906    * @param _by an address which executed an action
2907    * @param poolToken pool token address (like ILV)
2908    * @param poolAddress deployed pool instance address
2909    * @param weight pool weight
2910    * @param isFlashPool flag indicating if pool is a flash pool
2911    */
2912   event PoolRegistered(
2913     address indexed _by,
2914     address indexed poolToken,
2915     address indexed poolAddress,
2916     uint64 weight,
2917     bool isFlashPool
2918   );
2919 
2920   /**
2921    * @dev Fired in changePoolWeight()
2922    *
2923    * @param _by an address which executed an action
2924    * @param poolAddress deployed pool instance address
2925    * @param weight new pool weight
2926    */
2927   event WeightUpdated(address indexed _by, address indexed poolAddress, uint32 weight);
2928 
2929   /**
2930    * @dev Fired in updateILVPerBlock()
2931    *
2932    * @param _by an address which executed an action
2933    * @param newIlvPerBlock new ILV/block value
2934    */
2935   event IlvRatioUpdated(address indexed _by, uint256 newIlvPerBlock);
2936 
2937   /**
2938    * @dev Creates/deploys a factory instance
2939    *
2940    * @param _ilv ILV ERC20 token address
2941    * @param _silv sILV ERC20 token address
2942    * @param _ilvPerBlock initial ILV/block value for rewards
2943    * @param _blocksPerUpdate how frequently the rewards gets updated (decreased by 3%), blocks
2944    * @param _initBlock block number to measure _blocksPerUpdate from
2945    * @param _endBlock block number when farming stops and rewards cannot be updated anymore
2946    */
2947   constructor(
2948     address _ilv,
2949     address _silv,
2950     uint192 _ilvPerBlock,
2951     uint32 _blocksPerUpdate,
2952     uint32 _initBlock,
2953     uint32 _endBlock
2954   ) IlluviumAware(_ilv) {
2955     // verify the inputs are set
2956     require(_silv != address(0), "sILV address not set");
2957     require(_ilvPerBlock > 0, "ILV/block not set");
2958     require(_blocksPerUpdate > 0, "blocks/update not set");
2959     require(_initBlock > 0, "init block not set");
2960     require(_endBlock > _initBlock, "invalid end block: must be greater than init block");
2961 
2962     // verify sILV instance supplied
2963     require(
2964       EscrowedIlluviumERC20(_silv).TOKEN_UID() ==
2965       0xac3051b8d4f50966afb632468a4f61483ae6a953b74e387a01ef94316d6b7d62,
2966       "unexpected sILV TOKEN_UID"
2967     );
2968 
2969     // save the inputs into internal state variables
2970     silv = _silv;
2971     ilvPerBlock = _ilvPerBlock;
2972     blocksPerUpdate = _blocksPerUpdate;
2973     lastRatioUpdate = _initBlock;
2974     endBlock = _endBlock;
2975   }
2976 
2977   /**
2978    * @notice Given a pool token retrieves corresponding pool address
2979    *
2980    * @dev A shortcut for `pools` mapping
2981    *
2982    * @param poolToken pool token address (like ILV) to query pool address for
2983    * @return pool address for the token specified
2984    */
2985   function getPoolAddress(address poolToken) external view returns (address) {
2986     // read the mapping and return
2987     return pools[poolToken];
2988   }
2989 
2990   /**
2991    * @notice Reads pool information for the pool defined by its pool token address,
2992    *      designed to simplify integration with the front ends
2993    *
2994    * @param _poolToken pool token address to query pool information for
2995    * @return pool information packed in a PoolData struct
2996    */
2997   function getPoolData(address _poolToken) public view returns (PoolData memory) {
2998     // get the pool address from the mapping
2999     address poolAddr = pools[_poolToken];
3000 
3001     // throw if there is no pool registered for the token specified
3002     require(poolAddr != address(0), "pool not found");
3003 
3004     // read pool information from the pool smart contract
3005     // via the pool interface (IPool)
3006     address poolToken = IPool(poolAddr).poolToken();
3007     bool isFlashPool = IPool(poolAddr).isFlashPool();
3008     uint32 weight = IPool(poolAddr).weight();
3009 
3010     // create the in-memory structure and return it
3011     return PoolData({ poolToken: poolToken, poolAddress: poolAddr, weight: weight, isFlashPool: isFlashPool });
3012   }
3013 
3014   /**
3015    * @dev Verifies if `blocksPerUpdate` has passed since last ILV/block
3016    *      ratio update and if ILV/block reward can be decreased by 3%
3017    *
3018    * @return true if enough time has passed and `updateILVPerBlock` can be executed
3019    */
3020   function shouldUpdateRatio() public view returns (bool) {
3021     // if yield farming period has ended
3022     if (blockNumber() > endBlock) {
3023       // ILV/block reward cannot be updated anymore
3024       return false;
3025     }
3026 
3027     // check if blocks/update (91252 blocks) have passed since last update
3028     return blockNumber() >= lastRatioUpdate + blocksPerUpdate;
3029   }
3030 
3031   /**
3032    * @dev Creates a core pool (IlluviumCorePool) and registers it within the factory
3033    *
3034    * @dev Can be executed by the pool factory owner only
3035    *
3036    * @param poolToken pool token address (like ILV, or ILV/ETH pair)
3037    * @param initBlock init block to be used for the pool created
3038    * @param weight weight of the pool to be created
3039    */
3040   function createPool(
3041     address poolToken,
3042     uint64 initBlock,
3043     uint32 weight
3044   ) external virtual onlyOwner {
3045     // create/deploy new core pool instance
3046     IPool pool = new IlluviumCorePool(ilv, silv, this, poolToken, initBlock, weight);
3047 
3048     // register it within a factory
3049     registerPool(address(pool));
3050   }
3051 
3052   /**
3053    * @dev Registers an already deployed pool instance within the factory
3054    *
3055    * @dev Can be executed by the pool factory owner only
3056    *
3057    * @param poolAddr address of the already deployed pool instance
3058    */
3059   function registerPool(address poolAddr) public onlyOwner {
3060     // read pool information from the pool smart contract
3061     // via the pool interface (IPool)
3062     address poolToken = IPool(poolAddr).poolToken();
3063     bool isFlashPool = IPool(poolAddr).isFlashPool();
3064     uint32 weight = IPool(poolAddr).weight();
3065 
3066     // ensure that the pool is not already registered within the factory
3067     require(pools[poolToken] == address(0), "this pool is already registered");
3068 
3069     // create pool structure, register it within the factory
3070     pools[poolToken] = poolAddr;
3071     poolExists[poolAddr] = true;
3072     // update total pool weight of the factory
3073     totalWeight += weight;
3074 
3075     // emit an event
3076     emit PoolRegistered(msg.sender, poolToken, poolAddr, weight, isFlashPool);
3077   }
3078 
3079   /**
3080    * @notice Decreases ILV/block reward by 3%, can be executed
3081    *      no more than once per `blocksPerUpdate` blocks
3082    */
3083   function updateILVPerBlock() external {
3084     // checks if ratio can be updated i.e. if blocks/update (91252 blocks) have passed
3085     require(shouldUpdateRatio(), "too frequent");
3086 
3087     // decreases ILV/block reward by 3%
3088     ilvPerBlock = (ilvPerBlock * 97) / 100;
3089 
3090     // set current block as the last ratio update block
3091     lastRatioUpdate = uint32(blockNumber());
3092 
3093     // emit an event
3094     emit IlvRatioUpdated(msg.sender, ilvPerBlock);
3095   }
3096 
3097   /**
3098    * @dev Mints ILV tokens; executed by ILV Pool only
3099    *
3100    * @dev Requires factory to have ROLE_TOKEN_CREATOR permission
3101    *      on the ILV ERC20 token instance
3102    *
3103    * @param _to an address to mint tokens to
3104    * @param _amount amount of ILV tokens to mint
3105    */
3106   function mintYieldTo(address _to, uint256 _amount) external {
3107     // verify that sender is a pool registered withing the factory
3108     require(poolExists[msg.sender], "access denied");
3109 
3110     // mint ILV tokens as required
3111     mintIlv(_to, _amount);
3112   }
3113 
3114   /**
3115    * @dev Changes the weight of the pool;
3116    *      executed by the pool itself or by the factory owner
3117    *
3118    * @param poolAddr address of the pool to change weight for
3119    * @param weight new weight value to set to
3120    */
3121   function changePoolWeight(address poolAddr, uint32 weight) external {
3122     // verify function is executed either by factory owner or by the pool itself
3123     require(msg.sender == owner() || poolExists[msg.sender]);
3124 
3125     // recalculate total weight
3126     totalWeight = totalWeight + weight - IPool(poolAddr).weight();
3127 
3128     // set the new pool weight
3129     IPool(poolAddr).setWeight(weight);
3130 
3131     // emit an event
3132     emit WeightUpdated(msg.sender, poolAddr, weight);
3133   }
3134 
3135   /**
3136    * @dev Testing time-dependent functionality is difficult and the best way of
3137    *      doing it is to override block number in helper test smart contracts
3138    *
3139    * @return `block.number` in mainnet, custom values in testnets (if overridden)
3140    */
3141   function blockNumber() public view virtual returns (uint256) {
3142     // return current block number
3143     return block.number;
3144   }
3145 }
3146 
3147 /**
3148  * @dev Interface of the ERC20 standard as defined in the EIP.
3149  */
3150 interface IERC20 {
3151   /**
3152    * @dev Returns the amount of tokens in existence.
3153    */
3154   function totalSupply() external view returns (uint256);
3155 
3156   /**
3157    * @dev Returns the amount of tokens owned by `account`.
3158    */
3159   function balanceOf(address account) external view returns (uint256);
3160 
3161   /**
3162    * @dev Moves `amount` tokens from the caller's account to `recipient`.
3163    *
3164    * Returns a boolean value indicating whether the operation succeeded.
3165    *
3166    * Emits a {Transfer} event.
3167    */
3168   function transfer(address recipient, uint256 amount) external returns (bool);
3169 
3170   /**
3171    * @dev Returns the remaining number of tokens that `spender` will be
3172    * allowed to spend on behalf of `owner` through {transferFrom}. This is
3173    * zero by default.
3174    *
3175    * This value changes when {approve} or {transferFrom} are called.
3176    */
3177   function allowance(address owner, address spender) external view returns (uint256);
3178 
3179   /**
3180    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
3181    *
3182    * Returns a boolean value indicating whether the operation succeeded.
3183    *
3184    * IMPORTANT: Beware that changing an allowance with this method brings the risk
3185    * that someone may use both the old and the new allowance by unfortunate
3186    * transaction ordering. One possible solution to mitigate this race
3187    * condition is to first reduce the spender's allowance to 0 and set the
3188    * desired value afterwards:
3189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
3190    *
3191    * Emits an {Approval} event.
3192    */
3193   function approve(address spender, uint256 amount) external returns (bool);
3194 
3195   /**
3196    * @dev Moves `amount` tokens from `sender` to `recipient` using the
3197    * allowance mechanism. `amount` is then deducted from the caller's
3198    * allowance.
3199    *
3200    * Returns a boolean value indicating whether the operation succeeded.
3201    *
3202    * Emits a {Transfer} event.
3203    */
3204   function transferFrom(
3205     address sender,
3206     address recipient,
3207     uint256 amount
3208   ) external returns (bool);
3209 
3210   /**
3211    * @dev Emitted when `value` tokens are moved from one account (`from`) to
3212    * another (`to`).
3213    *
3214    * Note that `value` may be zero.
3215    */
3216   event Transfer(address indexed from, address indexed to, uint256 value);
3217 
3218   /**
3219    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
3220    * a call to {approve}. `value` is the new allowance.
3221    */
3222   event Approval(address indexed owner, address indexed spender, uint256 value);
3223 }
3224 
3225 /**
3226  * @dev Collection of functions related to the address type
3227  */
3228 library Address {
3229   /**
3230    * @dev Returns true if `account` is a contract.
3231    *
3232    * [IMPORTANT]
3233    * ====
3234    * It is unsafe to assume that an address for which this function returns
3235    * false is an externally-owned account (EOA) and not a contract.
3236    *
3237    * Among others, `isContract` will return false for the following
3238    * types of addresses:
3239    *
3240    *  - an externally-owned account
3241    *  - a contract in construction
3242    *  - an address where a contract will be created
3243    *  - an address where a contract lived, but was destroyed
3244    * ====
3245    */
3246   function isContract(address account) internal view returns (bool) {
3247     // This method relies on extcodesize, which returns 0 for contracts in
3248     // construction, since the code is only stored at the end of the
3249     // constructor execution.
3250 
3251     uint256 size;
3252     // solhint-disable-next-line no-inline-assembly
3253     assembly {
3254       size := extcodesize(account)
3255     }
3256     return size > 0;
3257   }
3258 
3259   /**
3260    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
3261    * `recipient`, forwarding all available gas and reverting on errors.
3262    *
3263    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
3264    * of certain opcodes, possibly making contracts go over the 2300 gas limit
3265    * imposed by `transfer`, making them unable to receive funds via
3266    * `transfer`. {sendValue} removes this limitation.
3267    *
3268    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
3269    *
3270    * IMPORTANT: because control is transferred to `recipient`, care must be
3271    * taken to not create reentrancy vulnerabilities. Consider using
3272    * {ReentrancyGuard} or the
3273    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
3274    */
3275   function sendValue(address payable recipient, uint256 amount) internal {
3276     require(address(this).balance >= amount, "Address: insufficient balance");
3277 
3278     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
3279     (bool success, ) = recipient.call{ value: amount }("");
3280     require(success, "Address: unable to send value, recipient may have reverted");
3281   }
3282 
3283   /**
3284    * @dev Performs a Solidity function call using a low level `call`. A
3285    * plain`call` is an unsafe replacement for a function call: use this
3286    * function instead.
3287    *
3288    * If `target` reverts with a revert reason, it is bubbled up by this
3289    * function (like regular Solidity function calls).
3290    *
3291    * Returns the raw returned data. To convert to the expected return value,
3292    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
3293    *
3294    * Requirements:
3295    *
3296    * - `target` must be a contract.
3297    * - calling `target` with `data` must not revert.
3298    *
3299    * _Available since v3.1._
3300    */
3301   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
3302     return functionCall(target, data, "Address: low-level call failed");
3303   }
3304 
3305   /**
3306    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
3307    * `errorMessage` as a fallback revert reason when `target` reverts.
3308    *
3309    * _Available since v3.1._
3310    */
3311   function functionCall(
3312     address target,
3313     bytes memory data,
3314     string memory errorMessage
3315   ) internal returns (bytes memory) {
3316     return functionCallWithValue(target, data, 0, errorMessage);
3317   }
3318 
3319   /**
3320    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
3321    * but also transferring `value` wei to `target`.
3322    *
3323    * Requirements:
3324    *
3325    * - the calling contract must have an ETH balance of at least `value`.
3326    * - the called Solidity function must be `payable`.
3327    *
3328    * _Available since v3.1._
3329    */
3330   function functionCallWithValue(
3331     address target,
3332     bytes memory data,
3333     uint256 value
3334   ) internal returns (bytes memory) {
3335     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
3336   }
3337 
3338   /**
3339    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
3340    * with `errorMessage` as a fallback revert reason when `target` reverts.
3341    *
3342    * _Available since v3.1._
3343    */
3344   function functionCallWithValue(
3345     address target,
3346     bytes memory data,
3347     uint256 value,
3348     string memory errorMessage
3349   ) internal returns (bytes memory) {
3350     require(address(this).balance >= value, "Address: insufficient balance for call");
3351     require(isContract(target), "Address: call to non-contract");
3352 
3353     // solhint-disable-next-line avoid-low-level-calls
3354     (bool success, bytes memory returndata) = target.call{ value: value }(data);
3355     return _verifyCallResult(success, returndata, errorMessage);
3356   }
3357 
3358   /**
3359    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
3360    * but performing a static call.
3361    *
3362    * _Available since v3.3._
3363    */
3364   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
3365     return functionStaticCall(target, data, "Address: low-level static call failed");
3366   }
3367 
3368   /**
3369    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
3370    * but performing a static call.
3371    *
3372    * _Available since v3.3._
3373    */
3374   function functionStaticCall(
3375     address target,
3376     bytes memory data,
3377     string memory errorMessage
3378   ) internal view returns (bytes memory) {
3379     require(isContract(target), "Address: static call to non-contract");
3380 
3381     // solhint-disable-next-line avoid-low-level-calls
3382     (bool success, bytes memory returndata) = target.staticcall(data);
3383     return _verifyCallResult(success, returndata, errorMessage);
3384   }
3385 
3386   /**
3387    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
3388    * but performing a delegate call.
3389    *
3390    * _Available since v3.3._
3391    */
3392   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
3393     return functionDelegateCall(target, data, "Address: low-level delegate call failed");
3394   }
3395 
3396   /**
3397    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
3398    * but performing a delegate call.
3399    *
3400    * _Available since v3.3._
3401    */
3402   function functionDelegateCall(
3403     address target,
3404     bytes memory data,
3405     string memory errorMessage
3406   ) internal returns (bytes memory) {
3407     require(isContract(target), "Address: delegate call to non-contract");
3408 
3409     // solhint-disable-next-line avoid-low-level-calls
3410     (bool success, bytes memory returndata) = target.delegatecall(data);
3411     return _verifyCallResult(success, returndata, errorMessage);
3412   }
3413 
3414   function _verifyCallResult(
3415     bool success,
3416     bytes memory returndata,
3417     string memory errorMessage
3418   ) private pure returns (bytes memory) {
3419     if (success) {
3420       return returndata;
3421     } else {
3422       // Look for revert reason and bubble it up if present
3423       if (returndata.length > 0) {
3424         // The easiest way to bubble the revert reason is using memory via assembly
3425 
3426         // solhint-disable-next-line no-inline-assembly
3427         assembly {
3428           let returndata_size := mload(returndata)
3429           revert(add(32, returndata), returndata_size)
3430         }
3431       } else {
3432         revert(errorMessage);
3433       }
3434     }
3435   }
3436 }
3437 
3438 /**
3439  * @title SafeERC20
3440  * @dev Wrappers around ERC20 operations that throw on failure (when the token
3441  * contract returns false). Tokens that return no value (and instead revert or
3442  * throw on failure) are also supported, non-reverting calls are assumed to be
3443  * successful.
3444  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
3445  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
3446  */
3447 library SafeERC20 {
3448   using Address for address;
3449 
3450   function safeTransfer(
3451     IERC20 token,
3452     address to,
3453     uint256 value
3454   ) internal {
3455     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
3456   }
3457 
3458   function safeTransferFrom(
3459     IERC20 token,
3460     address from,
3461     address to,
3462     uint256 value
3463   ) internal {
3464     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
3465   }
3466 
3467   /**
3468    * @dev Deprecated. This function has issues similar to the ones found in
3469    * {IERC20-approve}, and its usage is discouraged.
3470    *
3471    * Whenever possible, use {safeIncreaseAllowance} and
3472    * {safeDecreaseAllowance} instead.
3473    */
3474   function safeApprove(
3475     IERC20 token,
3476     address spender,
3477     uint256 value
3478   ) internal {
3479     // safeApprove should only be called when setting an initial allowance,
3480     // or when resetting it to zero. To increase and decrease it, use
3481     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
3482     // solhint-disable-next-line max-line-length
3483     require(
3484       (value == 0) || (token.allowance(address(this), spender) == 0),
3485       "SafeERC20: approve from non-zero to non-zero allowance"
3486     );
3487     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
3488   }
3489 
3490   function safeIncreaseAllowance(
3491     IERC20 token,
3492     address spender,
3493     uint256 value
3494   ) internal {
3495     uint256 newAllowance = token.allowance(address(this), spender) + value;
3496     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
3497   }
3498 
3499   function safeDecreaseAllowance(
3500     IERC20 token,
3501     address spender,
3502     uint256 value
3503   ) internal {
3504     uint256 newAllowance = token.allowance(address(this), spender) - value;
3505     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
3506   }
3507 
3508   /**
3509    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
3510    * on the return value: the return value is optional (but if data is returned, it must not be false).
3511    * @param token The token targeted by the call.
3512    * @param data The call data (encoded using abi.encode or one of its variants).
3513    */
3514   function _callOptionalReturn(IERC20 token, bytes memory data) private {
3515     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
3516     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
3517     // the target address contains contract code and also asserts for success in the low-level call.
3518 
3519     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
3520     if (returndata.length > 0) {
3521       // Return data is optional
3522       // solhint-disable-next-line max-line-length
3523       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
3524     }
3525   }
3526 }
3527 
3528 /**
3529  * @dev Implementation of the {IERC20} interface.
3530  *
3531  * This implementation is agnostic to the way tokens are created. This means
3532  * that a supply mechanism has to be added in a derived contract using {_mint}.
3533  * For a generic mechanism see {ERC20PresetMinterPauser}.
3534  *
3535  * TIP: For a detailed writeup see our guide
3536  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
3537  * to implement supply mechanisms].
3538  *
3539  * We have followed general OpenZeppelin guidelines: functions revert instead
3540  * of returning `false` on failure. This behavior is nonetheless conventional
3541  * and does not conflict with the expectations of ERC20 applications.
3542  *
3543  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
3544  * This allows applications to reconstruct the allowance for all accounts just
3545  * by listening to said events. Other implementations of the EIP may not emit
3546  * these events, as it isn't required by the specification.
3547  *
3548  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
3549  * functions have been added to mitigate the well-known issues around setting
3550  * allowances. See {IERC20-approve}.
3551  */
3552 
3553 // Copied from Open Zeppelin
3554 
3555 contract ERC20 is IERC20 {
3556   mapping(address => uint256) private _balances;
3557 
3558   mapping(address => mapping(address => uint256)) private _allowances;
3559 
3560   uint256 private _totalSupply;
3561 
3562   string private _name;
3563   string private _symbol;
3564   uint8 private _decimals;
3565 
3566   /**
3567    * @notice Token creator is responsible for creating (minting)
3568    *      tokens to an arbitrary address
3569    * @dev Role ROLE_TOKEN_CREATOR allows minting tokens
3570    *      (calling `mint` function)
3571    */
3572   uint32 public constant ROLE_TOKEN_CREATOR = 0x0001_0000;
3573 
3574   /**
3575    * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
3576    * a default value of 18.
3577    *
3578    * To select a different value for {decimals}, use {_setupDecimals}.
3579    *
3580    * All three of these values are immutable: they can only be set once during
3581    * construction.
3582    */
3583   constructor(string memory name_, string memory symbol_) {
3584     _name = name_;
3585     _symbol = symbol_;
3586     _decimals = 18;
3587   }
3588 
3589   /**
3590    * @dev Returns the name of the token.
3591    */
3592   function name() public view virtual returns (string memory) {
3593     return _name;
3594   }
3595 
3596   /**
3597    * @dev Returns the symbol of the token, usually a shorter version of the
3598    * name.
3599    */
3600   function symbol() public view virtual returns (string memory) {
3601     return _symbol;
3602   }
3603 
3604   /**
3605    * @dev Returns the number of decimals used to get its user representation.
3606    * For example, if `decimals` equals `2`, a balance of `505` tokens should
3607    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
3608    *
3609    * Tokens usually opt for a value of 18, imitating the relationship between
3610    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
3611    * called.
3612    *
3613    * NOTE: This information is only used for _display_ purposes: it in
3614    * no way affects any of the arithmetic of the contract, including
3615    * {IERC20-balanceOf} and {IERC20-transfer}.
3616    */
3617   function decimals() public view virtual returns (uint8) {
3618     return _decimals;
3619   }
3620 
3621   /**
3622    * @dev See {IERC20-totalSupply}.
3623    */
3624   function totalSupply() public view virtual override returns (uint256) {
3625     return _totalSupply;
3626   }
3627 
3628   /**
3629    * @dev See {IERC20-balanceOf}.
3630    */
3631   function balanceOf(address account) public view virtual override returns (uint256) {
3632     return _balances[account];
3633   }
3634 
3635   /**
3636    * @dev See {IERC20-transfer}.
3637    *
3638    * Requirements:
3639    *
3640    * - `recipient` cannot be the zero address.
3641    * - the caller must have a balance of at least `amount`.
3642    */
3643   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
3644     _transfer(msg.sender, recipient, amount);
3645     return true;
3646   }
3647 
3648   /**
3649    * @dev See {IERC20-allowance}.
3650    */
3651   function allowance(address owner, address spender) public view virtual override returns (uint256) {
3652     return _allowances[owner][spender];
3653   }
3654 
3655   /**
3656    * @dev See {IERC20-approve}.
3657    *
3658    * Requirements:
3659    *
3660    * - `spender` cannot be the zero address.
3661    */
3662   function approve(address spender, uint256 amount) public virtual override returns (bool) {
3663     _approve(msg.sender, spender, amount);
3664     return true;
3665   }
3666 
3667   /**
3668    * @dev See {IERC20-transferFrom}.
3669    *
3670    * Emits an {Approval} event indicating the updated allowance. This is not
3671    * required by the EIP. See the note at the beginning of {ERC20}.
3672    *
3673    * Requirements:
3674    *
3675    * - `sender` and `recipient` cannot be the zero address.
3676    * - `sender` must have a balance of at least `amount`.
3677    * - the caller must have allowance for ``sender``'s tokens of at least
3678    * `amount`.
3679    */
3680   function transferFrom(
3681     address sender,
3682     address recipient,
3683     uint256 amount
3684   ) public virtual override returns (bool) {
3685     _transfer(sender, recipient, amount);
3686     _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
3687     return true;
3688   }
3689 
3690   /**
3691    * @dev Atomically increases the allowance granted to `spender` by the caller.
3692    *
3693    * This is an alternative to {approve} that can be used as a mitigation for
3694    * problems described in {IERC20-approve}.
3695    *
3696    * Emits an {Approval} event indicating the updated allowance.
3697    *
3698    * Requirements:
3699    *
3700    * - `spender` cannot be the zero address.
3701    */
3702   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
3703     _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
3704     return true;
3705   }
3706 
3707   /**
3708    * @dev Atomically decreases the allowance granted to `spender` by the caller.
3709    *
3710    * This is an alternative to {approve} that can be used as a mitigation for
3711    * problems described in {IERC20-approve}.
3712    *
3713    * Emits an {Approval} event indicating the updated allowance.
3714    *
3715    * Requirements:
3716    *
3717    * - `spender` cannot be the zero address.
3718    * - `spender` must have allowance for the caller of at least
3719    * `subtractedValue`.
3720    */
3721   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
3722     _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
3723     return true;
3724   }
3725 
3726   /**
3727    * @dev Moves tokens `amount` from `sender` to `recipient`.
3728    *
3729    * This is internal function is equivalent to {transfer}, and can be used to
3730    * e.g. implement automatic token fees, slashing mechanisms, etc.
3731    *
3732    * Emits a {Transfer} event.
3733    *
3734    * Requirements:
3735    *
3736    * - `sender` cannot be the zero address.
3737    * - `recipient` cannot be the zero address.
3738    * - `sender` must have a balance of at least `amount`.
3739    */
3740   function _transfer(
3741     address sender,
3742     address recipient,
3743     uint256 amount
3744   ) internal virtual {
3745     require(sender != address(0), "ERC20: transfer from the zero address");
3746     require(recipient != address(0), "ERC20: transfer to the zero address");
3747 
3748     _beforeTokenTransfer(sender, recipient, amount);
3749 
3750     _balances[sender] = _balances[sender] - amount;
3751     _balances[recipient] = _balances[recipient] + amount;
3752     emit Transfer(sender, recipient, amount);
3753   }
3754 
3755   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
3756    * the total supply.
3757    *
3758    * Emits a {Transfer} event with `from` set to the zero address.
3759    *
3760    * Requirements:
3761    *
3762    * - `to` cannot be the zero address.
3763    */
3764   function _mint(address account, uint256 amount) internal virtual {
3765     require(account != address(0), "ERC20: mint to the zero address");
3766 
3767     _beforeTokenTransfer(address(0), account, amount);
3768 
3769     _totalSupply = _totalSupply + amount;
3770     _balances[account] = _balances[account] + amount;
3771     emit Transfer(address(0), account, amount);
3772   }
3773 
3774   /**
3775    * @dev Destroys `amount` tokens from `account`, reducing the
3776    * total supply.
3777    *
3778    * Emits a {Transfer} event with `to` set to the zero address.
3779    *
3780    * Requirements:
3781    *
3782    * - `account` cannot be the zero address.
3783    * - `account` must have at least `amount` tokens.
3784    */
3785   function _burn(address account, uint256 amount) internal virtual {
3786     require(account != address(0), "ERC20: burn from the zero address");
3787 
3788     _beforeTokenTransfer(account, address(0), amount);
3789 
3790     _balances[account] = _balances[account] - amount;
3791     _totalSupply = _totalSupply - amount;
3792     emit Transfer(account, address(0), amount);
3793   }
3794 
3795   /**
3796    * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
3797    *
3798    * This internal function is equivalent to `approve`, and can be used to
3799    * e.g. set automatic allowances for certain subsystems, etc.
3800    *
3801    * Emits an {Approval} event.
3802    *
3803    * Requirements:
3804    *
3805    * - `owner` cannot be the zero address.
3806    * - `spender` cannot be the zero address.
3807    */
3808   function _approve(
3809     address owner,
3810     address spender,
3811     uint256 amount
3812   ) internal virtual {
3813     require(owner != address(0), "ERC20: approve from the zero address");
3814     require(spender != address(0), "ERC20: approve to the zero address");
3815 
3816     _allowances[owner][spender] = amount;
3817     emit Approval(owner, spender, amount);
3818   }
3819 
3820   /**
3821    * @dev Sets {decimals} to a value other than the default one of 18.
3822    *
3823    * WARNING: This function should only be called from the constructor. Most
3824    * applications that interact with token contracts will not expect
3825    * {decimals} to ever change, and may work incorrectly if it does.
3826    */
3827   function _setupDecimals(uint8 decimals_) internal virtual {
3828     _decimals = decimals_;
3829   }
3830 
3831   /**
3832    * @dev Hook that is called before any transfer of tokens. This includes
3833    * minting and burning.
3834    *
3835    * Calling conditions:
3836    *
3837    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3838    * will be to transferred to `to`.
3839    * - when `from` is zero, `amount` tokens will be minted for `to`.
3840    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
3841    * - `from` and `to` are never both zero.
3842    *
3843    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3844    */
3845   function _beforeTokenTransfer(
3846     address from,
3847     address to,
3848     uint256 amount
3849   ) internal virtual {}
3850 }
3851 
3852 contract EscrowedIlluviumERC20 is ERC20("Escrowed Illuvium", "sILV"), AccessControl {
3853   /**
3854    * @dev Smart contract unique identifier, a random number
3855    * @dev Should be regenerated each time smart contact source code is changed
3856    *      and changes smart contract itself is to be redeployed
3857    * @dev Generated using https://www.random.org/bytes/
3858    */
3859   uint256 public constant TOKEN_UID = 0xac3051b8d4f50966afb632468a4f61483ae6a953b74e387a01ef94316d6b7d62;
3860 
3861   /**
3862    * @notice Must be called by ROLE_TOKEN_CREATOR addresses.
3863    *
3864    * @param recipient address to receive the tokens.
3865    * @param amount number of tokens to be minted.
3866    */
3867   function mint(address recipient, uint256 amount) external {
3868     require(isSenderInRole(ROLE_TOKEN_CREATOR), "insufficient privileges (ROLE_TOKEN_CREATOR required)");
3869     _mint(recipient, amount);
3870   }
3871 
3872   /**
3873    * @param amount number of tokens to be burned.
3874    */
3875   function burn(uint256 amount) external {
3876     _burn(msg.sender, amount);
3877   }
3878 }
3879 
3880 /**
3881  * @title Flash Pool Base
3882  *
3883  * @notice An abstract contract containing logic for a new Flash Pool version.
3884  *         It fixes the REWARD_PER_WEIGHT_MULTIPLIER constant to allow bigger supply
3885  *         tokens flash pools.
3886  *
3887  * @dev Deployment and initialization.
3888  *      Any pool deployed must be bound to the deployed pool factory (IlluviumPoolFactory)
3889  *      Additionally, 3 token instance addresses must be defined on deployment:
3890  *          - ILV token address
3891  *          - sILV token address, used to mint sILV rewards
3892  *          - pool token address, it can be ILV token address, ILV/ETH pair address, and others
3893  *
3894  * @dev Pool weight defines the fraction of the yield current pool receives among the other pools,
3895  *      pool factory is responsible for the weight synchronization between the pools.
3896  * @dev The weight is logically 10% for ILV pool and 90% for ILV/ETH pool.
3897  *      Since Solidity doesn't support fractions the weight is defined by the division of
3898  *      pool weight by total pools weight (sum of all registered pools within the factory)
3899  * @dev For ILV Pool we use 200 as weight and for ILV/ETH pool 800.
3900  *
3901  * @author Pedro Bergamini, reviewed by Basil Gorin
3902  */
3903 abstract contract FlashPoolBase is IPool, IlluviumAware, ReentrancyGuard {
3904   /// @dev Data structure representing token holder using a pool
3905   struct User {
3906     // @dev Total staked amount
3907     uint256 tokenAmount;
3908     // @dev Total weight
3909     uint256 totalWeight;
3910     // @dev Auxiliary variable for yield calculation
3911     uint256 subYieldRewards;
3912     // @dev Auxiliary variable for vault rewards calculation
3913     uint256 subVaultRewards;
3914     // @dev An array of holder's deposits
3915     Deposit[] deposits;
3916   }
3917 
3918   /// @dev Token holder storage, maps token holder address to their data record
3919   mapping(address => User) public users;
3920 
3921   /// @dev Link to sILV ERC20 Token EscrowedIlluviumERC20 instance
3922   address public immutable override silv;
3923 
3924   /// @dev Link to the pool factory IlluviumPoolFactory instance
3925   IlluviumPoolFactory public immutable factory;
3926 
3927   /// @dev Link to the internal token instance, for example SNX or XYZ
3928   address public immutable internalToken;
3929 
3930   /// @dev Pool weight, 100 for ILV pool or 900 for ILV/ETH
3931   uint32 public override weight;
3932 
3933   /// @dev Block number of the last yield distribution event
3934   uint64 public override lastYieldDistribution;
3935 
3936   /// @dev Used to calculate yield rewards
3937   /// @dev This value is different from "reward per token" used in locked pool
3938   /// @dev Note: stakes are different in duration and "weight" reflects that
3939   uint256 public override yieldRewardsPerWeight;
3940 
3941   /// @dev Used to calculate yield rewards, keeps track of the tokens weight locked in staking
3942   uint256 public override usersLockingWeight;
3943 
3944   /**
3945    * @dev Stake weight is proportional to deposit amount and time locked, precisely
3946    *      "deposit amount wei multiplied by (fraction of the year locked plus one)"
3947    * @dev To avoid significant precision loss due to multiplication by "fraction of the year" [0, 1],
3948    *      weight is stored multiplied by 1e6 constant, as an integer
3949    * @dev Corner case 1: if time locked is zero, weight is deposit amount multiplied by 1e6
3950    * @dev Corner case 2: if time locked is one year, fraction of the year locked is one, and
3951    *      weight is a deposit amount multiplied by 2 * 1e6
3952    */
3953   uint256 internal constant WEIGHT_MULTIPLIER = 1e6;
3954 
3955   /**
3956    * @dev When we know beforehand that staking is done for a year, and fraction of the year locked is one,
3957    *      we use simplified calculation and use the following constant instead previos one
3958    */
3959   uint256 internal constant YEAR_STAKE_WEIGHT_MULTIPLIER = 2 * WEIGHT_MULTIPLIER;
3960 
3961   /**
3962    * @dev Rewards per weight are stored multiplied by 1e12, as integers.
3963    */
3964   uint256 internal constant REWARD_PER_WEIGHT_MULTIPLIER = 1e18;
3965 
3966   /**
3967    * @dev Fired in _stake() and stake()
3968    *
3969    * @param _by an address which performed an operation, usually token holder
3970    * @param _from token holder address, the tokens will be returned to that address
3971    * @param amount amount of tokens staked
3972    */
3973   event Staked(address indexed _by, address indexed _from, uint256 amount);
3974 
3975   /**
3976    * @dev Fired in _updateStakeLock() and updateStakeLock()
3977    *
3978    * @param _by an address which performed an operation
3979    * @param depositId updated deposit ID
3980    * @param lockedFrom deposit locked from value
3981    * @param lockedUntil updated deposit locked until value
3982    */
3983   event StakeLockUpdated(address indexed _by, uint256 depositId, uint64 lockedFrom, uint64 lockedUntil);
3984 
3985   /**
3986    * @dev Fired in _unstake() and unstake()
3987    *
3988    * @param _by an address which performed an operation, usually token holder
3989    * @param _to an address which received the unstaked tokens, usually token holder
3990    * @param amount amount of tokens unstaked
3991    */
3992   event Unstaked(address indexed _by, address indexed _to, uint256 amount);
3993 
3994   /**
3995    * @dev Fired in _sync(), sync() and dependent functions (stake, unstake, etc.)
3996    *
3997    * @param _by an address which performed an operation
3998    * @param yieldRewardsPerWeight updated yield rewards per weight value
3999    * @param lastYieldDistribution usually, current block number
4000    */
4001   event Synchronized(address indexed _by, uint256 yieldRewardsPerWeight, uint64 lastYieldDistribution);
4002 
4003   /**
4004    * @dev Fired in _processRewards(), processRewards() and dependent functions (stake, unstake, etc.)
4005    *
4006    * @param _by an address which performed an operation
4007    * @param _to an address which claimed the yield reward
4008    * @param sIlv flag indicating if reward was paid (minted) in sILV
4009    * @param amount amount of yield paid
4010    */
4011   event YieldClaimed(address indexed _by, address indexed _to, bool sIlv, uint256 amount);
4012 
4013   /**
4014    * @dev Fired in setWeight()
4015    *
4016    * @param _by an address which performed an operation, always a factory
4017    * @param _fromVal old pool weight value
4018    * @param _toVal new pool weight value
4019    */
4020   event PoolWeightUpdated(address indexed _by, uint32 _fromVal, uint32 _toVal);
4021 
4022   /**
4023    * @dev Overridden in sub-contracts to construct the pool
4024    *
4025    * @param _ilv ILV ERC20 Token IlluviumERC20 address
4026    * @param _silv sILV ERC20 Token EscrowedIlluviumERC20 address
4027    * @param _factory Pool factory IlluviumPoolFactory instance/address
4028    * @param _internalToken token the pool operates on
4029    * @param _initBlock initial block used to calculate the rewards
4030    *      note: _initBlock can be set to the future effectively meaning _sync() calls will do nothing
4031    * @param _weight number representing a weight of the pool, actual weight fraction
4032    *      is calculated as that number divided by the total pools weight and doesn't exceed one
4033    */
4034   constructor(
4035     address _ilv,
4036     address _silv,
4037     IlluviumPoolFactory _factory,
4038     address _internalToken,
4039     uint64 _initBlock,
4040     uint32 _weight
4041   ) IlluviumAware(_ilv) {
4042     // verify the inputs are set
4043     require(_silv != address(0), "sILV address not set");
4044     require(address(_factory) != address(0), "ILV Pool fct address not set");
4045     require(_internalToken != address(0), "token address not set");
4046     require(_initBlock > 0, "init block not set");
4047     require(_weight > 0, "pool weight not set");
4048 
4049     // verify sILV instance supplied
4050     require(
4051       EscrowedIlluviumERC20(_silv).TOKEN_UID() ==
4052       0xac3051b8d4f50966afb632468a4f61483ae6a953b74e387a01ef94316d6b7d62,
4053       "unexpected sILV TOKEN_UID"
4054     );
4055     // verify IlluviumPoolFactory instance supplied
4056     require(
4057       _factory.FACTORY_UID() == 0xc5cfd88c6e4d7e5c8a03c255f03af23c0918d8e82cac196f57466af3fd4a5ec7,
4058       "unexpected FACTORY_UID"
4059     );
4060 
4061     // save the inputs into internal state variables
4062     silv = _silv;
4063     factory = _factory;
4064     internalToken = _internalToken;
4065     weight = _weight;
4066 
4067     // init the dependent internal state variables
4068     lastYieldDistribution = _initBlock;
4069   }
4070 
4071   /**
4072    * @dev Faked link to the pool token instance
4073    */
4074   function poolToken() external view override returns(address) {
4075     return address(this);
4076   }
4077 
4078   /**
4079    * @notice Calculates current yield rewards value available for address specified
4080    *
4081    * @param _staker an address to calculate yield rewards value for
4082    * @return calculated yield reward value for the given address
4083    */
4084   function pendingYieldRewards(address _staker) external view override returns (uint256) {
4085     // `newYieldRewardsPerWeight` will store stored or recalculated value for `yieldRewardsPerWeight`
4086     uint256 newYieldRewardsPerWeight;
4087 
4088     // if smart contract state was not updated recently, `yieldRewardsPerWeight` value
4089     // is outdated and we need to recalculate it in order to calculate pending rewards correctly
4090     if (blockNumber() > lastYieldDistribution && usersLockingWeight != 0) {
4091       uint256 endBlock = factory.endBlock();
4092       uint256 multiplier =
4093       blockNumber() > endBlock ? endBlock - lastYieldDistribution : blockNumber() - lastYieldDistribution;
4094       uint256 ilvRewards = (multiplier * weight * factory.ilvPerBlock()) / factory.totalWeight();
4095 
4096       // recalculated value for `yieldRewardsPerWeight`
4097       newYieldRewardsPerWeight = rewardToWeight(ilvRewards, usersLockingWeight) + yieldRewardsPerWeight;
4098     } else {
4099       // if smart contract state is up to date, we don't recalculate
4100       newYieldRewardsPerWeight = yieldRewardsPerWeight;
4101     }
4102 
4103     // based on the rewards per weight value, calculate pending rewards;
4104     User memory user = users[_staker];
4105     uint256 pending = weightToReward(user.totalWeight, newYieldRewardsPerWeight) - user.subYieldRewards;
4106 
4107     return pending;
4108   }
4109 
4110   /**
4111    * @notice Returns total staked token balance for the given address
4112    *
4113    * @param _user an address to query balance for
4114    * @return total staked token balance
4115    */
4116   function balanceOf(address _user) external view override returns (uint256) {
4117     // read specified user token amount and return
4118     return users[_user].tokenAmount;
4119   }
4120 
4121   /**
4122    * @notice Returns information on the given deposit for the given address
4123    *
4124    * @dev See getDepositsLength
4125    *
4126    * @param _user an address to query deposit for
4127    * @param _depositId zero-indexed deposit ID for the address specified
4128    * @return deposit info as Deposit structure
4129    */
4130   function getDeposit(address _user, uint256 _depositId) external view override returns (Deposit memory) {
4131     // read deposit at specified index and return
4132     return users[_user].deposits[_depositId];
4133   }
4134 
4135   /**
4136    * @notice Returns number of deposits for the given address. Allows iteration over deposits.
4137    *
4138    * @dev See getDeposit
4139    *
4140    * @param _user an address to query deposit length for
4141    * @return number of deposits for the given address
4142    */
4143   function getDepositsLength(address _user) external view override returns (uint256) {
4144     // read deposits array length and return
4145     return users[_user].deposits.length;
4146   }
4147 
4148   /**
4149    * @notice Stakes specified amount of tokens for the specified amount of time,
4150    *      and pays pending yield rewards if any
4151    *
4152    * @dev Requires amount to stake to be greater than zero
4153    *
4154    * @param _amount amount of tokens to stake
4155    * @param _lockUntil stake period as unix timestamp; zero means no locking
4156    * @param _useSILV a flag indicating if previous reward to be paid as sILV
4157    */
4158   function stake(
4159     uint256 _amount,
4160     uint64 _lockUntil,
4161     bool _useSILV
4162   ) external override {
4163     // delegate call to an internal function
4164     _stake(msg.sender, _amount, _lockUntil, _useSILV, false);
4165   }
4166 
4167   /**
4168    * @notice Unstakes specified amount of tokens, and pays pending yield rewards if any
4169    *
4170    * @dev Requires amount to unstake to be greater than zero
4171    *
4172    * @param _depositId deposit ID to unstake from, zero-indexed
4173    * @param _amount amount of tokens to unstake
4174    * @param _useSILV a flag indicating if reward to be paid as sILV
4175    */
4176   function unstake(
4177     uint256 _depositId,
4178     uint256 _amount,
4179     bool _useSILV
4180   ) external override {
4181     // delegate call to an internal function
4182     _unstake(msg.sender, _depositId, _amount, _useSILV);
4183   }
4184 
4185   /**
4186    * @notice Extends locking period for a given deposit
4187    *
4188    * @dev Requires new lockedUntil value to be:
4189    *      higher than the current one, and
4190    *      in the future, but
4191    *      no more than 1 year in the future
4192    *
4193    * @param depositId updated deposit ID
4194    * @param lockedUntil updated deposit locked until value
4195    * @param useSILV used for _processRewards check if it should use ILV or sILV
4196    */
4197   function updateStakeLock(
4198     uint256 depositId,
4199     uint64 lockedUntil,
4200     bool useSILV
4201   ) external {
4202     // sync and call processRewards
4203     _sync();
4204     _processRewards(msg.sender, useSILV, false);
4205     // delegate call to an internal function
4206     _updateStakeLock(msg.sender, depositId, lockedUntil);
4207   }
4208 
4209   /**
4210    * @notice Service function to synchronize pool state with current time
4211    *
4212    * @dev Can be executed by anyone at any time, but has an effect only when
4213    *      at least one block passes between synchronizations
4214    * @dev Executed internally when staking, unstaking, processing rewards in order
4215    *      for calculations to be correct and to reflect state progress of the contract
4216    * @dev When timing conditions are not met (executed too frequently, or after factory
4217    *      end block), function doesn't throw and exits silently
4218    */
4219   function sync() external override {
4220     // delegate call to an internal function
4221     _sync();
4222   }
4223 
4224   /**
4225    * @notice Service function to calculate and pay pending yield rewards to the sender
4226    *
4227    * @dev Can be executed by anyone at any time, but has an effect only when
4228    *      executed by deposit holder and when at least one block passes from the
4229    *      previous reward processing
4230    * @dev Executed internally when staking and unstaking, executes sync() under the hood
4231    *      before making further calculations and payouts
4232    * @dev When timing conditions are not met (executed too frequently, or after factory
4233    *      end block), function doesn't throw and exits silently
4234    *
4235    * @param _useSILV flag indicating whether to mint sILV token as a reward or not;
4236    *      when set to true - sILV reward is minted immediately and sent to sender,
4237    *      when set to false - new pool deposit gets created together with sILV minted
4238    */
4239   function processRewards(bool _useSILV) external virtual override {
4240     // delegate call to an internal function
4241     _processRewards(msg.sender, _useSILV, true);
4242   }
4243 
4244   /**
4245    * @dev Executed by the factory to modify pool weight; the factory is expected
4246    *      to keep track of the total pools weight when updating
4247    *
4248    * @dev Set weight to zero to disable the pool
4249    *
4250    * @param _weight new weight to set for the pool
4251    */
4252   function setWeight(uint32 _weight) external override {
4253     // verify function is executed by the factory
4254     require(msg.sender == address(factory), "access denied");
4255 
4256     // emit an event logging old and new weight values
4257     emit PoolWeightUpdated(msg.sender, weight, _weight);
4258 
4259     // set the new weight value
4260     weight = _weight;
4261   }
4262 
4263   /**
4264    * @dev Similar to public pendingYieldRewards, but performs calculations based on
4265    *      current smart contract state only, not taking into account any additional
4266    *      time/blocks which might have passed
4267    *
4268    * @param _staker an address to calculate yield rewards value for
4269    * @return pending calculated yield reward value for the given address
4270    */
4271   function _pendingYieldRewards(address _staker) internal view returns (uint256 pending) {
4272     // read user data structure into memory
4273     User memory user = users[_staker];
4274 
4275     // and perform the calculation using the values read
4276     return weightToReward(user.totalWeight, yieldRewardsPerWeight) - user.subYieldRewards;
4277   }
4278 
4279   /**
4280    * @dev Used internally, mostly by children implementations, see stake()
4281    *
4282    * @param _staker an address which stakes tokens and which will receive them back
4283    * @param _amount amount of tokens to stake
4284    * @param _lockUntil stake period as unix timestamp; zero means no locking
4285    * @param _useSILV a flag indicating if previous reward to be paid as sILV
4286    * @param _isYield a flag indicating if that stake is created to store yield reward
4287    *      from the previously unstaked stake
4288    */
4289   function _stake(
4290     address _staker,
4291     uint256 _amount,
4292     uint64 _lockUntil,
4293     bool _useSILV,
4294     bool _isYield
4295   ) internal virtual {
4296     // validate the inputs
4297     require(_amount > 0, "zero amount");
4298     require(
4299       _lockUntil == 0 || (_lockUntil > now256() && _lockUntil - now256() <= 365 days),
4300       "invalid lock interval"
4301     );
4302 
4303     // update smart contract state
4304     _sync();
4305 
4306     // get a link to user data struct, we will write to it later
4307     User storage user = users[_staker];
4308     // process current pending rewards if any
4309     if (user.tokenAmount > 0) {
4310       _processRewards(_staker, _useSILV, false);
4311     }
4312 
4313     // in most of the cases added amount `addedAmount` is simply `_amount`
4314     // however for deflationary tokens this can be different
4315 
4316     // read the current balance
4317     uint256 previousBalance = IERC20(internalToken).balanceOf(address(this));
4318     // transfer `_amount`; note: some tokens may get burnt here
4319     transferPoolTokenFrom(address(msg.sender), address(this), _amount);
4320     // read new balance, usually this is just the difference `previousBalance - _amount`
4321     uint256 newBalance = IERC20(internalToken).balanceOf(address(this));
4322     // calculate real amount taking into account deflation
4323     uint256 addedAmount = newBalance - previousBalance;
4324 
4325     // set the `lockFrom` and `lockUntil` taking into account that
4326     // zero value for `_lockUntil` means "no locking" and leads to zero values
4327     // for both `lockFrom` and `lockUntil`
4328     uint64 lockFrom = _lockUntil > 0 ? uint64(now256()) : 0;
4329     uint64 lockUntil = _lockUntil;
4330 
4331     // stake weight formula rewards for locking
4332     uint256 stakeWeight =
4333     (((lockUntil - lockFrom) * WEIGHT_MULTIPLIER) / 365 days + WEIGHT_MULTIPLIER) * addedAmount;
4334 
4335     // makes sure stakeWeight is valid
4336     assert(stakeWeight > 0);
4337 
4338     // create and save the deposit (append it to deposits array)
4339     Deposit memory deposit =
4340     Deposit({
4341     tokenAmount: addedAmount,
4342     weight: stakeWeight,
4343     lockedFrom: lockFrom,
4344     lockedUntil: lockUntil,
4345     isYield: _isYield
4346     });
4347     // deposit ID is an index of the deposit in `deposits` array
4348     user.deposits.push(deposit);
4349 
4350     // update user record
4351     user.tokenAmount += addedAmount;
4352     user.totalWeight += stakeWeight;
4353     user.subYieldRewards = weightToReward(user.totalWeight, yieldRewardsPerWeight);
4354 
4355     // update global variable
4356     usersLockingWeight += stakeWeight;
4357 
4358     // emit an event
4359     emit Staked(msg.sender, _staker, _amount);
4360   }
4361 
4362   /**
4363    * @dev Used internally, mostly by children implementations, see unstake()
4364    *
4365    * @param _staker an address which unstakes tokens (which previously staked them)
4366    * @param _depositId deposit ID to unstake from, zero-indexed
4367    * @param _amount amount of tokens to unstake
4368    * @param _useSILV a flag indicating if reward to be paid as sILV
4369    */
4370   function _unstake(
4371     address _staker,
4372     uint256 _depositId,
4373     uint256 _amount,
4374     bool _useSILV
4375   ) internal virtual {
4376     // verify an amount is set
4377     require(_amount > 0, "zero amount");
4378 
4379     // get a link to user data struct, we will write to it later
4380     User storage user = users[_staker];
4381     // get a link to the corresponding deposit, we may write to it later
4382     Deposit storage stakeDeposit = user.deposits[_depositId];
4383     // deposit structure may get deleted, so we save isYield flag to be able to use it
4384     bool isYield = stakeDeposit.isYield;
4385 
4386     // verify available balance
4387     // if staker address ot deposit doesn't exist this check will fail as well
4388     require(stakeDeposit.tokenAmount >= _amount, "amount exceeds stake");
4389 
4390     // update smart contract state
4391     _sync();
4392     // and process current pending rewards if any
4393     _processRewards(_staker, _useSILV, false);
4394 
4395     // recalculate deposit weight
4396     uint256 previousWeight = stakeDeposit.weight;
4397     uint256 newWeight =
4398     (((stakeDeposit.lockedUntil - stakeDeposit.lockedFrom) * WEIGHT_MULTIPLIER) /
4399     365 days +
4400     WEIGHT_MULTIPLIER) * (stakeDeposit.tokenAmount - _amount);
4401 
4402     // update the deposit, or delete it if its depleted
4403     if (stakeDeposit.tokenAmount - _amount == 0) {
4404       delete user.deposits[_depositId];
4405     } else {
4406       stakeDeposit.tokenAmount -= _amount;
4407       stakeDeposit.weight = newWeight;
4408     }
4409 
4410     // update user record
4411     user.tokenAmount -= _amount;
4412     user.totalWeight = user.totalWeight - previousWeight + newWeight;
4413     user.subYieldRewards = weightToReward(user.totalWeight, yieldRewardsPerWeight);
4414 
4415     // update global variable
4416     usersLockingWeight = usersLockingWeight - previousWeight + newWeight;
4417 
4418     // if the deposit was created by the pool itself as a yield reward
4419     if (isYield) {
4420       // mint the yield via the factory
4421       factory.mintYieldTo(msg.sender, _amount);
4422     } else {
4423       // otherwise just return tokens back to holder
4424       transferPoolToken(msg.sender, _amount);
4425     }
4426 
4427     // emit an event
4428     emit Unstaked(msg.sender, _staker, _amount);
4429   }
4430 
4431   /**
4432    * @dev Used internally, mostly by children implementations, see sync()
4433    *
4434    * @dev Updates smart contract state (`yieldRewardsPerWeight`, `lastYieldDistribution`),
4435    *      updates factory state via `updateILVPerBlock`
4436    */
4437   function _sync() internal virtual {
4438     // update ILV per block value in factory if required
4439     if (factory.shouldUpdateRatio()) {
4440       factory.updateILVPerBlock();
4441     }
4442 
4443     // check bound conditions and if these are not met -
4444     // exit silently, without emitting an event
4445     uint256 endBlock = factory.endBlock();
4446     if (lastYieldDistribution >= endBlock) {
4447       return;
4448     }
4449     if (blockNumber() <= lastYieldDistribution) {
4450       return;
4451     }
4452     // if locking weight is zero - update only `lastYieldDistribution` and exit
4453     if (usersLockingWeight == 0) {
4454       lastYieldDistribution = uint64(blockNumber());
4455       return;
4456     }
4457 
4458     // to calculate the reward we need to know how many blocks passed, and reward per block
4459     uint256 currentBlock = blockNumber() > endBlock ? endBlock : blockNumber();
4460     uint256 blocksPassed = currentBlock - lastYieldDistribution;
4461     uint256 ilvPerBlock = factory.ilvPerBlock();
4462 
4463     // calculate the reward
4464     uint256 ilvReward = (blocksPassed * ilvPerBlock * weight) / factory.totalWeight();
4465 
4466     // update rewards per weight and `lastYieldDistribution`
4467     yieldRewardsPerWeight += rewardToWeight(ilvReward, usersLockingWeight);
4468     lastYieldDistribution = uint64(currentBlock);
4469 
4470     // emit an event
4471     emit Synchronized(msg.sender, yieldRewardsPerWeight, lastYieldDistribution);
4472   }
4473 
4474   /**
4475    * @dev Used internally, mostly by children implementations, see processRewards()
4476    *
4477    * @param _staker an address which receives the reward (which has staked some tokens earlier)
4478    * @param _useSILV flag indicating whether to mint sILV token as a reward or not, see processRewards()
4479    * @param _withUpdate flag allowing to disable synchronization (see sync()) if set to false
4480    * @return pendingYield the rewards calculated and optionally re-staked
4481    */
4482   function _processRewards(
4483     address _staker,
4484     bool _useSILV,
4485     bool _withUpdate
4486   ) internal virtual returns (uint256 pendingYield) {
4487     // update smart contract state if required
4488     if (_withUpdate) {
4489       _sync();
4490     }
4491 
4492     // calculate pending yield rewards, this value will be returned
4493     pendingYield = _pendingYieldRewards(_staker);
4494 
4495     // if pending yield is zero - just return silently
4496     if (pendingYield == 0) return 0;
4497 
4498     // get link to a user data structure, we will write into it later
4499     User storage user = users[_staker];
4500 
4501     // if sILV is requested
4502     if (_useSILV) {
4503       // - mint sILV
4504       mintSIlv(_staker, pendingYield);
4505     } else {
4506       // for other pools - stake as pool
4507       address ilvPool = factory.getPoolAddress(ilv);
4508       ICorePool(ilvPool).stakeAsPool(_staker, pendingYield);
4509     }
4510 
4511     // update users's record for `subYieldRewards` if requested
4512     if (_withUpdate) {
4513       user.subYieldRewards = weightToReward(user.totalWeight, yieldRewardsPerWeight);
4514     }
4515 
4516     // emit an event
4517     emit YieldClaimed(msg.sender, _staker, _useSILV, pendingYield);
4518   }
4519 
4520   /**
4521    * @dev See updateStakeLock()
4522    *
4523    * @param _staker an address to update stake lock
4524    * @param _depositId updated deposit ID
4525    * @param _lockedUntil updated deposit locked until value
4526    */
4527   function _updateStakeLock(
4528     address _staker,
4529     uint256 _depositId,
4530     uint64 _lockedUntil
4531   ) internal {
4532     // validate the input time
4533     require(_lockedUntil > now256(), "lock should be in the future");
4534 
4535     // get a link to user data struct, we will write to it later
4536     User storage user = users[_staker];
4537     // get a link to the corresponding deposit, we may write to it later
4538     Deposit storage stakeDeposit = user.deposits[_depositId];
4539 
4540     // validate the input against deposit structure
4541     require(_lockedUntil > stakeDeposit.lockedUntil, "invalid new lock");
4542 
4543     // verify locked from and locked until values
4544     if (stakeDeposit.lockedFrom == 0) {
4545       require(_lockedUntil - now256() <= 365 days, "max lock period is 365 days");
4546       stakeDeposit.lockedFrom = uint64(now256());
4547     } else {
4548       require(_lockedUntil - stakeDeposit.lockedFrom <= 365 days, "max lock period is 365 days");
4549     }
4550 
4551     // update locked until value, calculate new weight
4552     stakeDeposit.lockedUntil = _lockedUntil;
4553     uint256 newWeight =
4554     (((stakeDeposit.lockedUntil - stakeDeposit.lockedFrom) * WEIGHT_MULTIPLIER) /
4555     365 days +
4556     WEIGHT_MULTIPLIER) * stakeDeposit.tokenAmount;
4557 
4558     // save previous weight
4559     uint256 previousWeight = stakeDeposit.weight;
4560     // update weight
4561     stakeDeposit.weight = newWeight;
4562 
4563     // update user total weight and global locking weight
4564     user.totalWeight = user.totalWeight - previousWeight + newWeight;
4565     usersLockingWeight = usersLockingWeight - previousWeight + newWeight;
4566 
4567     // emit an event
4568     emit StakeLockUpdated(_staker, _depositId, stakeDeposit.lockedFrom, _lockedUntil);
4569   }
4570 
4571   /**
4572    * @dev Converts stake weight (not to be mixed with the pool weight) to
4573    *      ILV reward value, applying the 10^12 division on weight
4574    *
4575    * @param _weight stake weight
4576    * @param rewardPerWeight ILV reward per weight
4577    * @return reward value normalized to 10^12
4578    */
4579   function weightToReward(uint256 _weight, uint256 rewardPerWeight) public pure returns (uint256) {
4580     // apply the formula and return
4581     return (_weight * rewardPerWeight) / REWARD_PER_WEIGHT_MULTIPLIER;
4582   }
4583 
4584   /**
4585    * @dev Converts reward ILV value to stake weight (not to be mixed with the pool weight),
4586    *      applying the 10^12 multiplication on the reward
4587    *      - OR -
4588    * @dev Converts reward ILV value to reward/weight if stake weight is supplied as second
4589    *      function parameter instead of reward/weight
4590    *
4591    * @param reward yield reward
4592    * @param rewardPerWeight reward/weight (or stake weight)
4593    * @return stake weight (or reward/weight)
4594    */
4595   function rewardToWeight(uint256 reward, uint256 rewardPerWeight) public pure returns (uint256) {
4596     // apply the reverse formula and return
4597     return (reward * REWARD_PER_WEIGHT_MULTIPLIER) / rewardPerWeight;
4598   }
4599 
4600   /**
4601    * @dev Testing time-dependent functionality is difficult and the best way of
4602    *      doing it is to override block number in helper test smart contracts
4603    *
4604    * @return `block.number` in mainnet, custom values in testnets (if overridden)
4605    */
4606   function blockNumber() public view virtual returns (uint256) {
4607     // return current block number
4608     return block.number;
4609   }
4610 
4611   /**
4612    * @dev Testing time-dependent functionality is difficult and the best way of
4613    *      doing it is to override time in helper test smart contracts
4614    *
4615    * @return `block.timestamp` in mainnet, custom values in testnets (if overridden)
4616    */
4617   function now256() public view virtual returns (uint256) {
4618     // return current block timestamp
4619     return block.timestamp;
4620   }
4621 
4622   /**
4623    * @dev Executes EscrowedIlluviumERC20.mint(_to, _values)
4624    *      on the bound EscrowedIlluviumERC20 instance
4625    *
4626    * @dev Reentrancy safe due to the EscrowedIlluviumERC20 design
4627    */
4628   function mintSIlv(address _to, uint256 _value) private {
4629     // just delegate call to the target
4630     EscrowedIlluviumERC20(silv).mint(_to, _value);
4631   }
4632 
4633   /**
4634    * @dev Executes SafeERC20.safeTransfer on a pool token
4635    *
4636    * @dev Reentrancy safety enforced via `ReentrancyGuard.nonReentrant`
4637    */
4638   function transferPoolToken(address _to, uint256 _value) internal nonReentrant {
4639     // just delegate call to the target
4640     SafeERC20.safeTransfer(IERC20(internalToken), _to, _value);
4641   }
4642 
4643   /**
4644    * @dev Executes SafeERC20.safeTransferFrom on a pool token
4645    *
4646    * @dev Reentrancy safety enforced via `ReentrancyGuard.nonReentrant`
4647    */
4648   function transferPoolTokenFrom(
4649     address _from,
4650     address _to,
4651     uint256 _value
4652   ) internal nonReentrant {
4653     // just delegate call to the target
4654     SafeERC20.safeTransferFrom(IERC20(internalToken), _from, _to, _value);
4655   }
4656 }
4657 
4658 /**
4659  * @title Flash Pool V2
4660  *
4661  * @notice Flash pools represent temporary pools like SNX pool.
4662  *
4663  * @notice Flash pools doesn't lock tokens, staked tokens can be unstaked  at any time
4664  *
4665  * @dev See FlashPoolBase for more details
4666  *
4667  * @author Pedro Bergamini, reviewed by Basil Gorin
4668  */
4669 contract FlashPoolV2 is FlashPoolBase {
4670   /// @dev Pool expiration time, the pool considered to be disabled once end block is reached
4671   /// @dev Expired pools don't process any rewards, users are expected to withdraw staked tokens
4672   ///      from the flash pools once they expire
4673   uint64 public endBlock;
4674 
4675   /// @dev Flag indicating pool type, true means "flash pool"
4676   bool public constant override isFlashPool = true;
4677 
4678   /**
4679    * @dev Creates/deploys an instance of the flash pool
4680    *
4681    * @param _ilv ILV ERC20 Token IlluviumERC20 address
4682    * @param _silv sILV ERC20 Token EscrowedIlluviumERC20 address
4683    * @param _factory Pool factory IlluviumPoolFactory instance/address
4684    * @param _internalToken token the pool operates on, for example ILV or ILV/ETH pair
4685    * @param _initBlock initial block used to calculate the rewards
4686    * @param _weight number representing a weight of the pool, actual weight fraction
4687    *      is calculated as that number divided by the total pools weight and doesn't exceed one
4688    * @param _endBlock pool expiration time (as block number)
4689    */
4690   constructor(
4691     address _ilv,
4692     address _silv,
4693     IlluviumPoolFactory _factory,
4694     address _internalToken,
4695     uint64 _initBlock,
4696     uint32 _weight,
4697     uint64 _endBlock
4698   ) FlashPoolBase(_ilv, _silv, _factory, _internalToken, _initBlock, _weight) {
4699     // check the inputs which are not checked by the pool base
4700     require(_endBlock > _initBlock, "end block must be higher than init block");
4701 
4702     // assign the end block
4703     endBlock = _endBlock;
4704   }
4705 
4706   /**
4707    * @notice The function to check pool state. Flash pool is considered "disabled"
4708    *      once time reaches its "end block"
4709    *
4710    * @return true if pool is disabled (time has reached end block), false otherwise
4711    */
4712   function isPoolDisabled() public view returns (bool) {
4713     // verify the pool expiration condition and return the result
4714     return blockNumber() >= endBlock;
4715   }
4716 
4717   /**
4718    * @inheritdoc FlashPoolBase
4719    *
4720    * @dev Overrides the _stake() in base by setting the locked until value to 1 year in the future;
4721    *      locked until value has only locked weight effect and doesn't do any real token locking
4722    *
4723    * @param _lockedUntil not used, overridden with now + 1 year just to have correct calculation
4724    *      of the locking weights
4725    */
4726   function _stake(
4727     address _staker,
4728     uint256 _amount,
4729     uint64 _lockedUntil,
4730     bool useSILV,
4731     bool isYield
4732   ) internal override {
4733     // override the `_lockedUntil` and execute parent
4734     // we set "locked period" to 365 days only to have correct calculation of locking weights,
4735     // the tokens are not really locked since _unstake in the core pool doesn't check the "locked period"
4736     super._stake(_staker, _amount, uint64(now256() + 365 days), useSILV, isYield);
4737   }
4738 
4739   /**
4740    * @inheritdoc FlashPoolBase
4741    *
4742    * @dev In addition to regular sync() routine of the base, set the pool weight
4743    *      to zero, effectively disabling the pool in the factory
4744    * @dev If the pool is disabled regular sync() routine is ignored
4745    */
4746   function _sync() internal override {
4747     // if pool is disabled/expired
4748     if (isPoolDisabled()) {
4749       // if weight is not yet set
4750       if (weight != 0) {
4751         // set the pool weight (sets both factory and local values)
4752         factory.changePoolWeight(address(this), 0);
4753       }
4754       // and exit
4755       return;
4756     }
4757 
4758     // for enabled pools perform regular sync() routine
4759     super._sync();
4760   }
4761 }