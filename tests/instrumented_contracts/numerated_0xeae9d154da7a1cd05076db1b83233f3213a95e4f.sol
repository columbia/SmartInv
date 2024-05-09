1 pragma solidity 0.4.23;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library AddressUtils {
7 
8   /**
9    * @notice Checks if the target address is a contract
10    * @dev This function will return false if invoked during the constructor of a contract,
11    *      as the code is not actually created until after the constructor finishes.
12    * @param addr address to check
13    * @return whether the target address is a contract
14    */
15   function isContract(address addr) internal view returns (bool) {
16     // a variable to load `extcodesize` to
17     uint256 size = 0;
18 
19     // XXX Currently there is no better way to check if there is a contract in an address
20     // than to check the size of the code at that address.
21     // See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
22     // TODO: Check this again before the Serenity release, because all addresses will be contracts.
23     // solium-disable-next-line security/no-inline-assembly
24     assembly {
25       // retrieve the size of the code at address `addr`
26       size := extcodesize(addr)
27     }
28 
29     // positive size indicates a smart contract address
30     return size > 0;
31   }
32 
33 }
34 
35 
36 /**
37  * Library for working with strings, primarily converting
38  * between strings and integer types
39  */
40 library StringUtils {
41   /**
42    * @dev Converts a string to unsigned integer using the specified `base`
43    * @dev Throws on invalid input
44    *      (wrong characters for a given `base`)
45    * @dev Throws if given `base` is not supported
46    * @param a string to convert
47    * @param base number base, one of 2, 8, 10, 16
48    * @return a number representing given string
49    */
50   function atoi(string a, uint8 base) internal pure returns (uint256 i) {
51     // check if the base is valid
52     require(base == 2 || base == 8 || base == 10 || base == 16);
53 
54     // convert string into bytes for convenient iteration
55     bytes memory buf = bytes(a);
56 
57     // iterate over the string (bytes buffer)
58     for(uint256 p = 0; p < buf.length; p++) {
59       // extract the digit
60       uint8 digit = uint8(buf[p]) - 0x30;
61 
62       // if digit is greater then 10 – mind the gap
63       // see `itoa` function for more details
64       if(digit > 10) {
65         // remove the gap
66         digit -= 7;
67       }
68 
69       // check if digit meets the base
70       require(digit < base);
71 
72       // move to the next digit slot
73       i *= base;
74 
75       // add digit to the result
76       i += digit;
77     }
78 
79     // return the result
80     return i;
81   }
82 
83   /**
84    * @dev Converts a integer to a string using the specified `base`
85    * @dev Throws if given `base` is not supported
86    * @param i integer to convert
87    * @param base number base, one of 2, 8, 10, 16
88    * @return a string representing given integer
89    */
90   function itoa(uint256 i, uint8 base) internal pure returns (string a) {
91     // check if the base is valid
92     require(base == 2 || base == 8 || base == 10 || base == 16);
93 
94     // for zero input the result is "0" string for any base
95     if (i == 0) {
96       return "0";
97     }
98 
99     // bytes buffer to put ASCII characters into
100     bytes memory buf = new bytes(256);
101 
102     // position within a buffer to be used in cycle
103     uint256 p = 0;
104 
105     // extract digits one by one in a cycle
106     while (i > 0) {
107       // extract current digit
108       uint8 digit = uint8(i % base);
109 
110       // convert it to an ASCII code
111       // 0x20 is " "
112       // 0x30-0x39 is "0"-"9"
113       // 0x41-0x5A is "A"-"Z"
114       // 0x61-0x7A is "a"-"z" ("A"-"Z" XOR " ")
115       uint8 ascii = digit + 0x30;
116 
117       // if digit is greater then 10,
118       // fix the 0x3A-0x40 gap of punctuation marks
119       // (7 characters in ASCII table)
120       if(digit > 10) {
121         // jump through the gap
122         ascii += 7;
123       }
124 
125       // write character into the buffer
126       buf[p++] = byte(ascii);
127 
128       // move to the next digit
129       i /= base;
130     }
131 
132     // `p` contains real length of the buffer now, save it
133     uint256 length = p;
134 
135     // reverse the buffer
136     for(p = 0; p < length / 2; p++) {
137       // swap elements at position `p` from the beginning and end using XOR:
138       // https://en.wikipedia.org/wiki/XOR_swap_algorithm
139       buf[p] ^= buf[length - 1 - p];
140       buf[length - 1 - p] ^= buf[p];
141       buf[p] ^= buf[length - 1 - p];
142     }
143 
144     // construct string and return
145     return string(buf);
146   }
147 
148   /**
149    * @dev Concatenates two strings `s1` and `s2`, for example, if
150    *      `s1` == `foo` and `s2` == `bar`, the result `s` == `foobar`
151    * @param s1 first string
152    * @param s2 second string
153    * @return concatenation result s1 + s2
154    */
155   function concat(string s1, string s2) internal pure returns (string s) {
156     // convert s1 into buffer 1
157     bytes memory buf1 = bytes(s1);
158     // convert s2 into buffer 2
159     bytes memory buf2 = bytes(s2);
160     // create a buffer for concatenation result
161     bytes memory buf = new bytes(buf1.length + buf2.length);
162 
163     // copy buffer 1 into buffer
164     for(uint256 i = 0; i < buf1.length; i++) {
165       buf[i] = buf1[i];
166     }
167 
168     // copy buffer 2 into buffer
169     for(uint256 j = buf1.length; j < buf2.length; j++) {
170       buf[j] = buf2[j - buf1.length];
171     }
172 
173     // construct string and return
174     return string(buf);
175   }
176 }
177 
178 
179 /**
180  * @dev Access control module provides an API to check
181  *      if specific operation is permitted globally and
182  *      if particular user's has a permission to execute it
183  */
184 contract AccessControl {
185   /// @notice Role manager is responsible for assigning the roles
186   /// @dev Role ROLE_ROLE_MANAGER allows executing addOperator/removeOperator
187   uint256 private constant ROLE_ROLE_MANAGER = 0x10000000;
188 
189   /// @notice Feature manager is responsible for enabling/disabling
190   ///      global features of the smart contract
191   /// @dev Role ROLE_FEATURE_MANAGER allows enabling/disabling global features
192   uint256 private constant ROLE_FEATURE_MANAGER = 0x20000000;
193 
194   /// @dev Bitmask representing all the possible permissions (super admin role)
195   uint256 private constant FULL_PRIVILEGES_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
196 
197   /// @dev A bitmask of globally enabled features
198   uint256 public features;
199 
200   /// @notice Privileged addresses with defined roles/permissions
201   /// @notice In the context of ERC20/ERC721 tokens these can be permissions to
202   ///      allow minting tokens, transferring on behalf and so on
203   /// @dev Maps an address to the permissions bitmask (role), where each bit
204   ///      represents a permission
205   /// @dev Bitmask 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
206   ///      represents all possible permissions
207   mapping(address => uint256) public userRoles;
208 
209   /// @dev Fired in updateFeatures()
210   event FeaturesUpdated(address indexed _by, uint256 _requested, uint256 _actual);
211 
212   /// @dev Fired in addOperator(), removeOperator(), addRole(), removeRole()
213   event RoleUpdated(address indexed _by, address indexed _to, uint256 _role);
214 
215   /**
216    * @dev Creates an access controlled instance
217    */
218   constructor() public {
219     // contract creator has full privileges
220     userRoles[msg.sender] = FULL_PRIVILEGES_MASK;
221   }
222 
223   /**
224    * @dev Updates set of the globally enabled features (`f`),
225    *      taking into account sender's permissions.
226    * @dev Requires sender to have `ROLE_FEATURE_MANAGER` permission.
227    * @param mask bitmask representing a set of features to enable/disable
228    */
229   function updateFeatures(uint256 mask) public {
230     // call sender nicely - caller
231     address caller = msg.sender;
232     // read caller's permissions
233     uint256 p = userRoles[caller];
234 
235     // caller should have a permission to update global features
236     require(__hasRole(p, ROLE_FEATURE_MANAGER));
237 
238     // taking into account caller's permissions,
239     // 1) enable features requested
240     features |= p & mask;
241     // 2) disable features requested
242     features &= FULL_PRIVILEGES_MASK ^ (p & (FULL_PRIVILEGES_MASK ^ mask));
243 
244     // fire an event
245     emit FeaturesUpdated(caller, mask, features);
246   }
247 
248   /**
249    * @dev Adds a new `operator` - an address which has
250    *      some extended privileges over the smart contract,
251    *      for example token minting, transferring on behalf, etc.
252    * @dev Newly added `operator` cannot have any permissions which
253    *      transaction sender doesn't have.
254    * @dev Requires transaction sender to have `ROLE_ROLE_MANAGER` permission.
255    * @dev Cannot update existing operator. Throws if `operator` already exists.
256    * @param operator address of the operator to add
257    * @param role bitmask representing a set of permissions which
258    *      newly created operator will have
259    */
260   function addOperator(address operator, uint256 role) public {
261     // call sender gracefully - `manager`
262     address manager = msg.sender;
263 
264     // read manager's permissions (role)
265     uint256 permissions = userRoles[manager];
266 
267     // check that `operator` doesn't exist
268     require(userRoles[operator] == 0);
269 
270     // manager must have a ROLE_ROLE_MANAGER role
271     require(__hasRole(permissions, ROLE_ROLE_MANAGER));
272 
273     // recalculate permissions (role) to set:
274     // we cannot create an operator more powerful then calling `manager`
275     uint256 r = role & permissions;
276 
277     // check if we still have some permissions (role) to set
278     require(r != 0);
279 
280     // create an operator by persisting his permissions (roles) to storage
281     userRoles[operator] = r;
282 
283     // fire an event
284     emit RoleUpdated(manager, operator, userRoles[operator]);
285   }
286 
287   /**
288    * @dev Deletes an existing `operator`.
289    * @dev Requires sender to have `ROLE_ROLE_MANAGER` permission.
290    * @param operator address of the operator to delete
291    */
292   function removeOperator(address operator) public {
293     // call sender gracefully - `manager`
294     address manager = msg.sender;
295 
296     // check if an `operator` exists
297     require(userRoles[operator] != 0);
298 
299     // do not allow transaction sender to remove himself
300     // protects from an accidental removal of all the operators
301     require(operator != manager);
302 
303     // manager must have a ROLE_ROLE_MANAGER role
304     // and he must have all the permissions operator has
305     require(__hasRole(userRoles[manager], ROLE_ROLE_MANAGER | userRoles[operator]));
306 
307     // perform operator deletion
308     delete userRoles[operator];
309 
310     // fire an event
311     emit RoleUpdated(manager, operator, 0);
312   }
313 
314   /**
315    * @dev Updates an existing `operator`, adding a specified role to it.
316    * @dev Note that `operator` cannot receive permission which
317    *      transaction sender doesn't have.
318    * @dev Requires transaction sender to have `ROLE_ROLE_MANAGER` permission.
319    * @dev Cannot create a new operator. Throws if `operator` doesn't exist.
320    * @dev Existing permissions of the `operator` are preserved
321    * @param operator address of the operator to update
322    * @param role bitmask representing a set of permissions which
323    *      `operator` will have
324    */
325   function addRole(address operator, uint256 role) public {
326     // call sender gracefully - `manager`
327     address manager = msg.sender;
328 
329     // read manager's permissions (role)
330     uint256 permissions = userRoles[manager];
331 
332     // check that `operator` exists
333     require(userRoles[operator] != 0);
334 
335     // manager must have a ROLE_ROLE_MANAGER role
336     require(__hasRole(permissions, ROLE_ROLE_MANAGER));
337 
338     // recalculate permissions (role) to add:
339     // we cannot make an operator more powerful then calling `manager`
340     uint256 r = role & permissions;
341 
342     // check if we still have some permissions (role) to add
343     require(r != 0);
344 
345     // update operator's permissions (roles) in the storage
346     userRoles[operator] |= r;
347 
348     // fire an event
349     emit RoleUpdated(manager, operator, userRoles[operator]);
350   }
351 
352   /**
353    * @dev Updates an existing `operator`, removing a specified role from it.
354    * @dev Note that  permissions which transaction sender doesn't have
355    *      cannot be removed.
356    * @dev Requires transaction sender to have `ROLE_ROLE_MANAGER` permission.
357    * @dev Cannot remove all permissions. Throws on such an attempt.
358    * @param operator address of the operator to update
359    * @param role bitmask representing a set of permissions which
360    *      will be removed from the `operator`
361    */
362   function removeRole(address operator, uint256 role) public {
363     // call sender gracefully - `manager`
364     address manager = msg.sender;
365 
366     // read manager's permissions (role)
367     uint256 permissions = userRoles[manager];
368 
369     // check that we're not removing all the `operator`s permissions
370     // this is not really required and just causes inconveniences is function use
371     //require(userRoles[operator] ^ role != 0);
372 
373     // manager must have a ROLE_ROLE_MANAGER role
374     require(__hasRole(permissions, ROLE_ROLE_MANAGER));
375 
376     // recalculate permissions (role) to remove:
377     // we cannot revoke permissions which calling `manager` doesn't have
378     uint256 r = role & permissions;
379 
380     // check if we still have some permissions (role) to revoke
381     require(r != 0);
382 
383     // update operator's permissions (roles) in the storage
384     userRoles[operator] &= FULL_PRIVILEGES_MASK ^ r;
385 
386     // fire an event
387     emit RoleUpdated(manager, operator, userRoles[operator]);
388   }
389 
390   /// @dev Checks if requested feature is enabled globally on the contract
391   function __isFeatureEnabled(uint256 featureRequired) internal constant returns(bool) {
392     // delegate call to `__hasRole`
393     return __hasRole(features, featureRequired);
394   }
395 
396   /// @dev Checks if transaction sender `msg.sender` has all the required permissions `roleRequired`
397   function __isSenderInRole(uint256 roleRequired) internal constant returns(bool) {
398     // read sender's permissions (role)
399     uint256 userRole = userRoles[msg.sender];
400 
401     // delegate call to `__hasRole`
402     return __hasRole(userRole, roleRequired);
403   }
404 
405   /// @dev Checks if user role `userRole` contain all the permissions required `roleRequired`
406   function __hasRole(uint256 userRole, uint256 roleRequired) internal pure returns(bool) {
407     // check the bitmask for the role required and return the result
408     return userRole & roleRequired == roleRequired;
409   }
410 }
411 
412 
413 /**
414  * @title ERC721 token receiver interface
415  * @dev Interface for any contract that wants to support safe transfers
416  *      from ERC721 asset contracts.
417  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
418  */
419 interface ERC721Receiver {
420   /**
421    * @notice Handle the receipt of an NFT
422    * @dev The ERC721 smart contract calls this function on the recipient after a `transfer`.
423    *      This function MAY throw to revert and reject the transfer.
424    *      Return of other than the magic value MUST result in the transaction being reverted.
425    * @notice The contract address is always the message sender.
426    *      A wallet/broker/auction application MUST implement the wallet interface
427    *      if it will accept safe transfers.
428    * @param _operator The address which called `safeTransferFrom` function
429    * @param _from The address which previously owned the token
430    * @param _tokenId The NFT identifier which is being transferred
431    * @param _data Additional data with no specified format
432    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing
433    */
434   function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
435 }
436 
437 
438 /**
439  * @title ERC165
440  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
441  */
442 contract ERC165 {
443   /**
444    * 0x01ffc9a7 == bytes4(keccak256('supportsInterface(bytes4)'))
445    */
446   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
447 
448   /**
449    * @dev a mapping of interface id to whether or not it's supported
450    */
451   mapping(bytes4 => bool) internal supportedInterfaces;
452 
453   /**
454    * @dev A contract implementing SupportsInterfaceWithLookup
455    * implement ERC165 itself
456    */
457   constructor() public {
458     // register itself in a lookup table
459     _registerInterface(InterfaceId_ERC165);
460   }
461 
462 
463 
464   /**
465    * @notice Query if a contract implements an interface
466    * @param _interfaceId The interface identifier, as specified in ERC-165
467    * @dev Interface identification is specified in ERC-165.
468    * @dev This function uses less than 30,000 gas.
469    */
470   function supportsInterface(bytes4 _interfaceId) public constant returns (bool) {
471     // find if interface is supported using a lookup table
472     return supportedInterfaces[_interfaceId];
473   }
474 
475   /**
476    * @dev private method for registering an interface
477    */
478   function _registerInterface(bytes4 _interfaceId) internal {
479     require(_interfaceId != 0xffffffff);
480     supportedInterfaces[_interfaceId] = true;
481   }
482 }
483 
484 
485 /**
486  * @notice Gem is unique tradable entity. Non-fungible.
487  * @dev A gem is an ERC721 non-fungible token, which maps Token ID,
488  *      a 32 bit number to a set of gem properties -
489  *      attributes (mostly immutable by their nature) and state variables (mutable)
490  * @dev A gem token supports only minting, it can be only created
491  */
492 contract GemERC721 is AccessControl, ERC165 {
493   /// @dev Smart contract version
494   /// @dev Should be incremented manually in this source code
495   ///      each time smart contact source code is changed
496   uint32 public constant TOKEN_VERSION = 0x3;
497 
498   /// @dev ERC20 compliant token symbol
499   string public constant symbol = "GEM";
500   /// @dev ERC20 compliant token name
501   string public constant name = "GEM – CryptoMiner World";
502   /// @dev ERC20 compliant token decimals
503   /// @dev this can be only zero, since ERC721 token is non-fungible
504   uint8 public constant decimals = 0;
505 
506   /// @dev A gem data structure
507   /// @dev Occupies 64 bytes of storage (512 bits)
508   struct Gem {
509     /// High 256 bits
510     /// @dev Where gem was found: land plot ID,
511     ///      land block within a plot,
512     ///      gem number (id) within a block of land, immutable
513     uint64 coordinates;
514 
515     /// @dev Gem color, one of 12 values, immutable
516     uint8 color;
517 
518     /// @dev Level modified time
519     /// @dev Stored as Ethereum Block Number of the transaction
520     ///      when the gem was created
521     uint32 levelModified;
522 
523     /// @dev Level value (mutable), one of 1, 2, 3, 4, 5
524     uint8 level;
525 
526     /// @dev Grade modified time
527     /// @dev Stored as Ethereum Block Number of the transaction
528     ///      when the gem was created
529     uint32 gradeModified;
530 
531     /// @dev High 8 bits store grade type and low 24 bits grade value
532     /// @dev Grade type is one of D (1), C (2), B (3), A (4), AA (5) and AAA (6)
533     uint32 grade;
534 
535     /// @dev Store state modified time
536     /// @dev Stored as Ethereum Block Number of the transaction
537     ///      when the gem was created
538     uint32 stateModified;
539 
540     /// @dev State value, mutable
541     uint48 state;
542 
543 
544     /// Low 256 bits
545     /// @dev Gem creation time, immutable, cannot be zero
546     /// @dev Stored as Ethereum Block Number of the transaction
547     ///      when the gem was created
548     uint32 creationTime;
549 
550     /// @dev Gem index within an owner's collection of gems, mutable
551     uint32 index;
552 
553     /// @dev Initially zero, changes when ownership is transferred
554     /// @dev Stored as Ethereum Block Number of the transaction
555     ///      when the gem's ownership was changed, mutable
556     uint32 ownershipModified;
557 
558     /// @dev Gem's owner, initialized upon gem creation, mutable
559     address owner;
560   }
561 
562   /// @notice All the emitted gems
563   /// @dev Core of the Gem as ERC721 token
564   /// @dev Maps Gem ID => Gem Data Structure
565   mapping(uint256 => Gem) public gems;
566 
567   /// @dev Mapping from a gem ID to an address approved to
568   ///      transfer ownership rights for this gem
569   mapping(uint256 => address) public approvals;
570 
571   /// @dev Mapping from owner to operator approvals
572   ///      token owner => approved token operator => is approved
573   mapping(address => mapping(address => bool)) public approvedOperators;
574 
575   /// @notice Storage for a collections of tokens
576   /// @notice A collection of tokens is an ordered list of token IDs,
577   ///      owned by a particular address (owner)
578   /// @dev A mapping from owner to a collection of his tokens (IDs)
579   /// @dev ERC20 compliant structure for balances can be derived
580   ///      as a length of each collection in the mapping
581   /// @dev ERC20 balances[owner] is equal to collections[owner].length
582   mapping(address => uint32[]) public collections;
583 
584   /// @dev Array with all token ids, used for enumeration
585   /// @dev ERC20 compliant structure for totalSupply can be derived
586   ///      as a length of this collection
587   /// @dev ERC20 totalSupply() is equal to allTokens.length
588   uint32[] public allTokens;
589 
590   /// @dev The data in token's state may contain lock(s)
591   ///      (ex.: is gem currently mining or not)
592   /// @dev A locked token cannot be transferred or upgraded
593   /// @dev The token is locked if it contains any bits
594   ///      from the `lockedBitmask` in its `state` set
595   uint64 public lockedBitmask = DEFAULT_MINING_BIT;
596 
597   /// @dev Enables ERC721 transfers of the tokens
598   uint32 public constant FEATURE_TRANSFERS = 0x00000001;
599 
600   /// @dev Enables ERC721 transfers on behalf
601   uint32 public constant FEATURE_TRANSFERS_ON_BEHALF = 0x00000002;
602 
603   /// @dev Enables partial support of ERC20 transfers of the tokens,
604   ///      allowing to transfer only all owned tokens at once
605   //uint32 public constant ERC20_TRANSFERS = 0x00000004;
606 
607   /// @dev Enables partial support of ERC20 transfers on behalf
608   ///      allowing to transfer only all owned tokens at once
609   //uint32 public constant ERC20_TRANSFERS_ON_BEHALF = 0x00000008;
610 
611   /// @dev Enables full support of ERC20 transfers of the tokens,
612   ///      allowing to transfer arbitrary amount of the tokens at once
613   //uint32 public constant ERC20_INSECURE_TRANSFERS = 0x00000010;
614 
615   /// @dev Default bitmask indicating that the gem is `mining`
616   /// @dev Consists of a single bit at position 1 – binary 1
617   /// @dev This bit is cleared by `miningComplete`
618   /// @dev The bit meaning in gem's `state` is as follows:
619   ///      0: not mining
620   ///      1: mining
621   uint64 public constant DEFAULT_MINING_BIT = 0x1; // bit number 1
622 
623   /// @notice Exchange is responsible for trading tokens on behalf of token holders
624   /// @dev Role ROLE_EXCHANGE allows executing transfer on behalf of token holders
625   /// @dev Not used
626   //uint32 public constant ROLE_EXCHANGE = 0x00010000;
627 
628   /// @notice Level provider is responsible for enabling the workshop
629   /// @dev Role ROLE_LEVEL_PROVIDER allows leveling up the gem
630   uint32 public constant ROLE_LEVEL_PROVIDER = 0x00100000;
631 
632   /// @notice Grade provider is responsible for enabling the workshop
633   /// @dev Role ROLE_GRADE_PROVIDER allows modifying gem's grade
634   uint32 public constant ROLE_GRADE_PROVIDER = 0x00200000;
635 
636   /// @notice Token state provider is responsible for enabling the mining protocol
637   /// @dev Role ROLE_STATE_PROVIDER allows modifying token's state
638   uint32 public constant ROLE_STATE_PROVIDER = 0x00400000;
639 
640   /// @notice Token state provider is responsible for enabling the mining protocol
641   /// @dev Role ROLE_STATE_LOCK_PROVIDER allows modifying token's locked bitmask
642   uint32 public constant ROLE_STATE_LOCK_PROVIDER = 0x00800000;
643 
644   /// @notice Token creator is responsible for creating tokens
645   /// @dev Role ROLE_TOKEN_CREATOR allows minting tokens
646   uint32 public constant ROLE_TOKEN_CREATOR = 0x00040000;
647 
648   /// @notice Token destroyer is responsible for destroying tokens
649   /// @dev Role ROLE_TOKEN_DESTROYER allows burning tokens
650   //uint32 public constant ROLE_TOKEN_DESTROYER = 0x00080000;
651 
652   /// @dev Magic value to be returned upon successful reception of an NFT
653   /// @dev Equal to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
654   ///      which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
655   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
656 
657   /**
658    * Supported interfaces section
659    */
660 
661   /**
662    * ERC721 interface definition in terms of ERC165
663    *
664    * 0x80ac58cd ==
665    *   bytes4(keccak256('balanceOf(address)')) ^
666    *   bytes4(keccak256('ownerOf(uint256)')) ^
667    *   bytes4(keccak256('approve(address,uint256)')) ^
668    *   bytes4(keccak256('getApproved(uint256)')) ^
669    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
670    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
671    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
672    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
673    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
674    */
675   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
676 
677   /**
678    * ERC721 interface extension – exists(uint256)
679    *
680    * 0x4f558e79 == bytes4(keccak256('exists(uint256)'))
681    */
682   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
683 
684   /**
685    * ERC721 interface extension - ERC721Enumerable
686    *
687    * 0x780e9d63 ==
688    *   bytes4(keccak256('totalSupply()')) ^
689    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
690    *   bytes4(keccak256('tokenByIndex(uint256)'))
691    */
692   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
693 
694   /**
695    * ERC721 interface extension - ERC721Metadata
696    *
697    * 0x5b5e139f ==
698    *   bytes4(keccak256('name()')) ^
699    *   bytes4(keccak256('symbol()')) ^
700    *   bytes4(keccak256('tokenURI(uint256)'))
701    */
702   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
703 
704   /// @dev Event names are self-explanatory:
705   /// @dev Fired in mint()
706   /// @dev Address `_by` allows to track who created a token
707   event Minted(address indexed _by, address indexed _to, uint32 indexed _tokenId);
708 
709   /// @dev Fired in burn()
710   /// @dev Address `_by` allows to track who destroyed a token
711   //event Burnt(address indexed _from, address _by, uint32 indexed _tokenId);
712 
713   /// @dev Fired in transfer(), transferFor(), mint()
714   /// @dev When minting a token, address `_from` is zero
715   /// @dev ERC20/ERC721 compliant event
716   event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId, uint256 _value);
717 
718   /// @dev Fired in approve()
719   /// @dev ERC721 compliant event
720   event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
721 
722   /// @dev Fired in setApprovalForAll()
723   /// @dev ERC721 compliant event
724   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _value);
725 
726   /// @dev Fired in levelUp()
727   event LevelUp(address indexed _by, address indexed _owner, uint256 indexed _tokenId, uint8 _levelReached);
728 
729   /// @dev Fired in upgradeGrade()
730   event UpgradeComplete(address indexed _by, address indexed _owner, uint256 indexed _tokenId, uint32 _gradeFrom, uint32 _gradeTo);
731 
732   /// @dev Fired in setState()
733   event StateModified(address indexed _by, address indexed _owner, uint256 indexed _tokenId, uint48 _stateFrom, uint48 _stateTo);
734 
735   /// @dev Creates a Gem ERC721 instance,
736   /// @dev Registers a ERC721 interface using ERC165
737   constructor() public {
738     // register the supported interfaces to conform to ERC721 via ERC165
739     _registerInterface(InterfaceId_ERC721);
740     _registerInterface(InterfaceId_ERC721Exists);
741     _registerInterface(InterfaceId_ERC721Enumerable);
742     _registerInterface(InterfaceId_ERC721Metadata);
743   }
744 
745   /**
746    * @dev Gets a gem by ID, representing it as two integers.
747    *      The two integers are tightly packed with a gem data:
748    *      First integer (high bits) contains (from higher to lower bits order):
749    *          coordinates:
750    *            plotId,
751    *            depth (block ID),
752    *            gemNum (gem ID within a block)
753    *          color,
754    *          levelModified,
755    *          level,
756    *          gradeModified,
757    *          grade,
758    *          stateModified,
759    *          state,
760    *      Second integer (low bits) contains (from higher to lower bits order):
761    *          creationTime,
762    *          index,
763    *          ownershipModified,
764    *          owner
765    * @dev Throws if gem doesn't exist
766    * @param _tokenId ID of the gem to fetch
767    */
768   function getPacked(uint256 _tokenId) public constant returns(uint256, uint256) {
769     // validate gem existence
770     require(exists(_tokenId));
771 
772     // load the gem from storage
773     Gem memory gem = gems[_tokenId];
774 
775     // pack high 256 bits of the result
776     uint256 high = uint256(gem.coordinates) << 192
777                  | uint192(gem.color) << 184
778                  | uint184(gem.levelModified) << 152
779                  | uint152(gem.level) << 144
780                  | uint144(gem.gradeModified) << 112
781                  | uint112(gem.grade) << 80
782                  | uint80(gem.stateModified) << 48
783                  | uint48(gem.state);
784 
785     // pack low 256 bits of the result
786     uint256 low  = uint256(gem.creationTime) << 224
787                  | uint224(gem.index) << 192
788                  | uint192(gem.ownershipModified) << 160
789                  | uint160(gem.owner);
790 
791     // return the whole 512 bits of result
792     return (high, low);
793   }
794 
795   /**
796    * @dev Allows to fetch collection of tokens, including internal token data
797    *       in a single function, useful when connecting to external node like INFURA
798    * @param owner an address to query a collection for
799    */
800   function getPackedCollection(address owner) public constant returns (uint80[]) {
801     // get an array of Gem IDs owned by an `owner` address
802     uint32[] memory tokenIds = getCollection(owner);
803 
804     // how many gems are there in a collection
805     uint32 balance = uint32(tokenIds.length);
806 
807     // data container to store the result
808     uint80[] memory result = new uint80[](balance);
809 
810     // fetch token info one by one and pack into structure
811     for(uint32 i = 0; i < balance; i++) {
812       // token ID to work with
813       uint32 tokenId = tokenIds[i];
814       // get the token properties and pack them together with tokenId
815       uint48 properties = getProperties(tokenId);
816 
817       // pack the data
818       result[i] = uint80(tokenId) << 48 | properties;
819     }
820 
821     // return the packed data structure
822     return result;
823   }
824 
825   /**
826    * @notice Retrieves a collection of tokens owned by a particular address
827    * @notice An order of token IDs is not guaranteed and may change
828    *      when a token from the list is transferred
829    * @param owner an address to query a collection for
830    * @return an ordered list of tokens
831    */
832   function getCollection(address owner) public constant returns(uint32[]) {
833     // read a collection from mapping and return
834     return collections[owner];
835   }
836 
837   /**
838    * @dev Allows setting the `lockedBitmask` parameter of the contract,
839    *      which is used to determine if a particular token is locked or not
840    * @dev A locked token cannot be transferred, upgraded or burnt
841    * @dev The token is locked if it contains any bits
842    *      from the `lockedBitmask` in its `state` set
843    * @dev Requires sender to have `ROLE_STATE_PROVIDER` permission.
844    * @param bitmask a value to set `lockedBitmask` to
845    */
846   function setLockedBitmask(uint64 bitmask) public {
847     // check that the call is made by a state lock provider
848     require(__isSenderInRole(ROLE_STATE_LOCK_PROVIDER));
849 
850     // update the locked bitmask
851     lockedBitmask = bitmask;
852   }
853 
854   /**
855    * @dev Gets the coordinates of a token
856    * @param _tokenId ID of the token to get coordinates for
857    * @return a token coordinates
858    */
859   function getCoordinates(uint256 _tokenId) public constant returns(uint64) {
860     // validate token existence
861     require(exists(_tokenId));
862 
863     // obtain token's coordinates from storage and return
864     return gems[_tokenId].coordinates;
865   }
866 
867   /**
868    * @dev Gets the land plot ID of a gem
869    * @param _tokenId ID of the gem to get land plot ID value for
870    * @return a token land plot ID
871    */
872   function getPlotId(uint256 _tokenId) public constant returns(uint32) {
873     // extract high 32 bits of the coordinates and return
874     return uint32(getCoordinates(_tokenId) >> 32);
875   }
876 
877   /**
878    * @dev Gets the depth (block ID) within plot of land of a gem
879    * @param _tokenId ID of the gem to get depth value for
880    * @return a token depth
881    */
882   function getDepth(uint256 _tokenId) public constant returns(uint16) {
883     // extract middle 16 bits of the coordinates and return
884     return uint16(getCoordinates(_tokenId) >> 16);
885   }
886 
887   /**
888    * @dev Gets the gem's number within land block
889    * @param _tokenId ID of the gem to get depth value for
890    * @return a gem number within a land block
891    */
892   function getGemNum(uint256 _tokenId) public constant returns(uint16) {
893     // extract low 16 bits of the coordinates and return
894     return uint16(getCoordinates(_tokenId));
895   }
896 
897   /**
898    * @dev Gets the gem's properties – color, level and
899    *      grade - as packed uint32 number
900    * @param _tokenId ID of the gem to get properties for
901    * @return gem's properties - color, level, grade as packed uint32
902    */
903   function getProperties(uint256 _tokenId) public constant returns(uint48) {
904     // validate token existence
905     require(exists(_tokenId));
906 
907     // read gem from storage
908     Gem memory gem = gems[_tokenId];
909 
910     // pack data structure and return
911     return uint48(gem.color) << 40 | uint40(gem.level) << 32 | gem.grade;
912   }
913 
914   /**
915    * @dev Gets the color of a token
916    * @param _tokenId ID of the token to get color for
917    * @return a token color
918    */
919   function getColor(uint256 _tokenId) public constant returns(uint8) {
920     // validate token existence
921     require(exists(_tokenId));
922 
923     // obtain token's color from storage and return
924     return gems[_tokenId].color;
925   }
926 
927   /**
928    * @dev Gets the level modified date of a token
929    * @param _tokenId ID of the token to get level modification date for
930    * @return a token level modification date
931    */
932   function getLevelModified(uint256 _tokenId) public constant returns(uint32) {
933     // validate token existence
934     require(exists(_tokenId));
935 
936     // obtain token's level modified date from storage and return
937     return gems[_tokenId].levelModified;
938   }
939 
940   /**
941    * @dev Gets the level of a token
942    * @param _tokenId ID of the token to get level for
943    * @return a token level
944    */
945   function getLevel(uint256 _tokenId) public constant returns(uint8) {
946     // validate token existence
947     require(exists(_tokenId));
948 
949     // obtain token's level from storage and return
950     return gems[_tokenId].level;
951   }
952 
953   /**
954    * @dev Levels up a gem
955    * @dev Requires sender to have `ROLE_STATE_PROVIDER` permission
956    * @param _tokenId ID of the gem to level up
957    */
958   function levelUp(uint256 _tokenId) public {
959     // check that the call is made by a level provider
960     require(__isSenderInRole(ROLE_LEVEL_PROVIDER));
961 
962     // check that token to set state for exists
963     require(exists(_tokenId));
964 
965     // update the level modified date
966     gems[_tokenId].levelModified = uint32(block.number);
967 
968     // increment the level required
969     gems[_tokenId].level++;
970 
971     // emit an event
972     emit LevelUp(msg.sender, ownerOf(_tokenId), _tokenId, gems[_tokenId].level);
973   }
974 
975   /**
976    * @dev Gets the grade modified date of a gem
977    * @param _tokenId ID of the gem to get grade modified date for
978    * @return a token grade modified date
979    */
980   function getGradeModified(uint256 _tokenId) public constant returns(uint32) {
981     // validate token existence
982     require(exists(_tokenId));
983 
984     // obtain token's grade modified date from storage and return
985     return gems[_tokenId].gradeModified;
986   }
987 
988   /**
989    * @dev Gets the grade of a gem
990    * @param _tokenId ID of the gem to get grade for
991    * @return a token grade
992    */
993   function getGrade(uint256 _tokenId) public constant returns(uint32) {
994     // validate token existence
995     require(exists(_tokenId));
996 
997     // obtain token's grade from storage and return
998     return gems[_tokenId].grade;
999   }
1000 
1001   /**
1002    * @dev Gets the grade type of a gem
1003    * @param _tokenId ID of the gem to get grade type for
1004    * @return a token grade type
1005    */
1006   function getGradeType(uint256 _tokenId) public constant returns(uint8) {
1007     // extract high 8 bits of the grade and return
1008     return uint8(getGrade(_tokenId) >> 24);
1009   }
1010 
1011   /**
1012    * @dev Gets the grade value of a gem
1013    * @param _tokenId ID of the gem to get grade value for
1014    * @return a token grade value
1015    */
1016   function getGradeValue(uint256 _tokenId) public constant returns(uint24) {
1017     // extract low 24 bits of the grade and return
1018     return uint24(getGrade(_tokenId));
1019   }
1020 
1021   /**
1022    * @dev Upgrades the grade of the gem
1023    * @dev Requires new grade to be higher than an old one
1024    * @dev Requires sender to have `ROLE_GRADE_PROVIDER` permission
1025    * @param _tokenId ID of the gem to modify the grade for
1026    * @param grade new grade to set for the token, should be higher then current state
1027    */
1028   function upgradeGrade(uint256 _tokenId, uint32 grade) public {
1029     // check that the call is made by a grade provider
1030     require(__isSenderInRole(ROLE_GRADE_PROVIDER));
1031 
1032     // check that token to set grade for exists
1033     require(exists(_tokenId));
1034 
1035     // check if we're not downgrading the gem
1036     require(gems[_tokenId].grade < grade);
1037 
1038     // emit an event
1039     emit UpgradeComplete(msg.sender, ownerOf(_tokenId), _tokenId, gems[_tokenId].grade, grade);
1040 
1041     // set the grade required
1042     gems[_tokenId].grade = grade;
1043 
1044     // update the grade modified date
1045     gems[_tokenId].gradeModified = uint32(block.number);
1046   }
1047 
1048   /**
1049    * @dev Gets the state modified date of a token
1050    * @param _tokenId ID of the token to get state modified date for
1051    * @return a token state modification date
1052    */
1053   function getStateModified(uint256 _tokenId) public constant returns(uint32) {
1054     // validate token existence
1055     require(exists(_tokenId));
1056 
1057     // obtain token's state modified date from storage and return
1058     return gems[_tokenId].stateModified;
1059   }
1060 
1061   /**
1062    * @dev Gets the state of a token
1063    * @param _tokenId ID of the token to get state for
1064    * @return a token state
1065    */
1066   function getState(uint256 _tokenId) public constant returns(uint48) {
1067     // validate token existence
1068     require(exists(_tokenId));
1069 
1070     // obtain token's state from storage and return
1071     return gems[_tokenId].state;
1072   }
1073 
1074   /**
1075    * @dev Sets the state of a token
1076    * @dev Requires sender to have `ROLE_STATE_PROVIDER` permission
1077    * @param _tokenId ID of the token to set state for
1078    * @param state new state to set for the token
1079    */
1080   function setState(uint256 _tokenId, uint48 state) public {
1081     // check that the call is made by a state provider
1082     require(__isSenderInRole(ROLE_STATE_PROVIDER));
1083 
1084     // check that token to set state for exists
1085     require(exists(_tokenId));
1086 
1087     // emit an event
1088     emit StateModified(msg.sender, ownerOf(_tokenId), _tokenId, gems[_tokenId].state, state);
1089 
1090     // set the state required
1091     gems[_tokenId].state = state;
1092 
1093     // update the state modified date
1094     gems[_tokenId].stateModified = uint32(block.number);
1095   }
1096 
1097   /**
1098    * @dev Gets the creation time of a token
1099    * @param _tokenId ID of the token to get creation time for
1100    * @return a token creation time
1101    */
1102   function getCreationTime(uint256 _tokenId) public constant returns(uint32) {
1103     // validate token existence
1104     require(exists(_tokenId));
1105 
1106     // obtain token's creation time from storage and return
1107     return gems[_tokenId].creationTime;
1108   }
1109 
1110   /**
1111    * @dev Gets the ownership modified time of a token
1112    * @param _tokenId ID of the token to get ownership modified time for
1113    * @return a token ownership modified time
1114    */
1115   function getOwnershipModified(uint256 _tokenId) public constant returns(uint32) {
1116     // validate token existence
1117     require(exists(_tokenId));
1118 
1119     // obtain token's ownership modified time from storage and return
1120     return gems[_tokenId].ownershipModified;
1121   }
1122 
1123   /**
1124    * @notice Total number of existing tokens (tracked by this contract)
1125    * @return A count of valid tokens tracked by this contract,
1126    *    where each one of them has an assigned and
1127    *    queryable owner not equal to the zero address
1128    */
1129   function totalSupply() public constant returns (uint256) {
1130     // read the length of the `allTokens` collection
1131     return allTokens.length;
1132   }
1133 
1134   /**
1135    * @notice Enumerate valid tokens
1136    * @dev Throws if `_index` >= `totalSupply()`.
1137    * @param _index a counter less than `totalSupply()`
1138    * @return The token ID for the `_index`th token, unsorted
1139    */
1140   function tokenByIndex(uint256 _index) public constant returns (uint256) {
1141     // out of bounds check
1142     require(_index < allTokens.length);
1143 
1144     // get the token ID and return
1145     return allTokens[_index];
1146   }
1147 
1148   /**
1149    * @notice Enumerate tokens assigned to an owner
1150    * @dev Throws if `_index` >= `balanceOf(_owner)`.
1151    * @param _owner an address of the owner to query token from
1152    * @param _index a counter less than `balanceOf(_owner)`
1153    * @return the token ID for the `_index`th token assigned to `_owner`, unsorted
1154    */
1155   function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint256) {
1156     // out of bounds check
1157     require(_index < collections[_owner].length);
1158 
1159     // get the token ID from owner collection and return
1160     return collections[_owner][_index];
1161   }
1162 
1163   /**
1164    * @notice Gets an amount of token owned by the given address
1165    * @dev Gets the balance of the specified address
1166    * @param _owner address to query the balance for
1167    * @return an amount owned by the address passed as an input parameter
1168    */
1169   function balanceOf(address _owner) public constant returns (uint256) {
1170     // read the length of the `who`s collection of tokens
1171     return collections[_owner].length;
1172   }
1173 
1174   /**
1175    * @notice Checks if specified token exists
1176    * @dev Returns whether the specified token ID exists
1177    * @param _tokenId ID of the token to query the existence for
1178    * @return whether the token exists (true - exists)
1179    */
1180   function exists(uint256 _tokenId) public constant returns (bool) {
1181     // check if this token exists (owner is not zero)
1182     return gems[_tokenId].owner != address(0);
1183   }
1184 
1185   /**
1186    * @notice Finds an owner address for a token specified
1187    * @dev Gets the owner of the specified token from the `gems` mapping
1188    * @dev Throws if a token with the ID specified doesn't exist
1189    * @param _tokenId ID of the token to query the owner for
1190    * @return owner address currently marked as the owner of the given token
1191    */
1192   function ownerOf(uint256 _tokenId) public constant returns (address) {
1193     // check if this token exists
1194     require(exists(_tokenId));
1195 
1196     // return owner's address
1197     return gems[_tokenId].owner;
1198   }
1199 
1200   /**
1201    * @dev Creates new token with `tokenId` ID specified and
1202    *      assigns an ownership `to` for that token
1203    * @dev Allows setting initial token's properties
1204    * @param to an address to assign created token ownership to
1205    * @param tokenId ID of the token to create
1206    */
1207   function mint(
1208     address to,
1209     uint32 tokenId,
1210     uint32 plotId,
1211     uint16 depth,
1212     uint16 gemNum,
1213     uint8 color,
1214     uint8 level,
1215     uint8 gradeType,
1216     uint24 gradeValue
1217   ) public {
1218     // validate destination address
1219     require(to != address(0));
1220     require(to != address(this));
1221 
1222     // check if caller has sufficient permissions to mint a token
1223     // and if feature is enabled globally
1224     require(__isSenderInRole(ROLE_TOKEN_CREATOR));
1225 
1226     // delegate call to `__mint`
1227     __mint(to, tokenId, plotId, depth, gemNum, color, level, gradeType, gradeValue);
1228 
1229     // fire ERC20 transfer event
1230     emit Transfer(address(0), to, tokenId, 1);
1231   }
1232 
1233   /**
1234    * @notice Transfers ownership rights of a token defined
1235    *      by the `tokenId` to a new owner specified by address `to`
1236    * @dev Requires the sender of the transaction to be an owner
1237    *      of the token specified (`tokenId`)
1238    * @param to new owner address
1239    * @param _tokenId ID of the token to transfer ownership rights for
1240    */
1241   function transfer(address to, uint256 _tokenId) public {
1242     // check if token transfers feature is enabled
1243     require(__isFeatureEnabled(FEATURE_TRANSFERS));
1244 
1245     // call sender gracefully - `from`
1246     address from = msg.sender;
1247 
1248     // delegate call to unsafe `__transfer`
1249     __transfer(from, to, _tokenId);
1250   }
1251 
1252   /**
1253    * @notice A.k.a "transfer a token on behalf"
1254    * @notice Transfers ownership rights of a token defined
1255    *      by the `tokenId` to a new owner specified by address `to`
1256    * @notice Allows transferring ownership rights by a trading operator
1257    *      on behalf of token owner. Allows building an exchange of tokens.
1258    * @dev Transfers the ownership of a given token ID to another address
1259    * @dev Requires the transaction sender to be one of:
1260    *      owner of a gem - then its just a usual `transfer`
1261    *      approved – an address explicitly approved earlier by
1262    *        the owner of a token to transfer this particular token `tokenId`
1263    *      operator - an address explicitly approved earlier by
1264    *        the owner to transfer all his tokens on behalf
1265    * @param from current owner of the token
1266    * @param to address to receive the ownership of the token
1267    * @param _tokenId ID of the token to be transferred
1268    */
1269   function transferFrom(address from, address to, uint256 _tokenId) public {
1270     // check if transfers on behalf feature is enabled
1271     require(__isFeatureEnabled(FEATURE_TRANSFERS_ON_BEHALF));
1272 
1273     // call sender gracefully - `operator`
1274     address operator = msg.sender;
1275 
1276     // find if an approved address exists for this token
1277     address approved = approvals[_tokenId];
1278 
1279     // we assume `from` is an owner of the token,
1280     // this will be explicitly checked in `__transfer`
1281 
1282     // fetch how much approvals left for an operator
1283     bool approvedOperator = approvedOperators[from][operator];
1284 
1285     // operator must have an approval to transfer this particular token
1286     // or operator must be approved to transfer all the tokens
1287     // or, if nothing satisfies, this is equal to regular transfer,
1288     // where `from` is basically a transaction sender and owner of the token
1289     if(operator != approved && !approvedOperator) {
1290       // transaction sender doesn't have any special permissions
1291       // we will treat him as a token owner and sender and try to perform
1292       // a regular transfer:
1293       // check `from` to be `operator` (transaction sender):
1294       require(from == operator);
1295 
1296       // additionally check if token transfers feature is enabled
1297       require(__isFeatureEnabled(FEATURE_TRANSFERS));
1298     }
1299 
1300     // delegate call to unsafe `__transfer`
1301     __transfer(from, to, _tokenId);
1302   }
1303 
1304   /**
1305    * @notice A.k.a "safe transfer a token on behalf"
1306    * @notice Transfers ownership rights of a token defined
1307    *      by the `tokenId` to a new owner specified by address `to`
1308    * @notice Allows transferring ownership rights by a trading operator
1309    *      on behalf of token owner. Allows building an exchange of tokens.
1310    * @dev Safely transfers the ownership of a given token ID to another address
1311    * @dev Requires the transaction sender to be the owner, approved, or operator
1312    * @dev When transfer is complete, this function
1313    *      checks if `_to` is a smart contract (code size > 0). If so, it calls
1314    *      `onERC721Received` on `_to` and throws if the return value is not
1315    *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
1316    * @param _from current owner of the token
1317    * @param _to address to receive the ownership of the token
1318    * @param _tokenId ID of the token to be transferred
1319    * @param _data Additional data with no specified format, sent in call to `_to`
1320    */
1321   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public {
1322     // delegate call to usual (unsafe) `transferFrom`
1323     transferFrom(_from, _to, _tokenId);
1324 
1325     // check if receiver `_to` supports ERC721 interface
1326     if (AddressUtils.isContract(_to)) {
1327       // if `_to` is a contract – execute onERC721Received
1328       bytes4 response = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
1329 
1330       // expected response is ERC721_RECEIVED
1331       require(response == ERC721_RECEIVED);
1332     }
1333   }
1334 
1335   /**
1336    * @notice A.k.a "safe transfer a token on behalf"
1337    * @notice Transfers ownership rights of a token defined
1338    *      by the `tokenId` to a new owner specified by address `to`
1339    * @notice Allows transferring ownership rights by a trading operator
1340    *      on behalf of token owner. Allows building an exchange of tokens.
1341    * @dev Safely transfers the ownership of a given token ID to another address
1342    * @dev Requires the transaction sender to be the owner, approved, or operator
1343    * @dev Requires from to be an owner of the token
1344    * @dev If the target address is a contract, it must implement `onERC721Received`,
1345    *      which is called upon a safe transfer, and return the magic value
1346    *      `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`;
1347    *      otherwise the transfer is reverted.
1348    * @dev This works identically to the other function with an extra data parameter,
1349    *      except this function just sets data to "".
1350    * @param _from current owner of the token
1351    * @param _to address to receive the ownership of the token
1352    * @param _tokenId ID of the token to be transferred
1353    */
1354   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
1355     // delegate call to overloaded `safeTransferFrom`, set data to ""
1356     safeTransferFrom(_from, _to, _tokenId, "");
1357   }
1358 
1359   /**
1360    * @notice Approves an address to transfer the given token on behalf of its owner
1361    *      Can also be used to revoke an approval by setting `to` address to zero
1362    * @dev The zero `to` address revokes an approval for a given token
1363    * @dev There can only be one approved address per token at a given time
1364    * @dev This function can only be called by the token owner
1365    * @param _approved address to be approved to transfer the token on behalf of its owner
1366    * @param _tokenId ID of the token to be approved for transfer on behalf
1367    */
1368   function approve(address _approved, uint256 _tokenId) public {
1369     // call sender nicely - `from`
1370     address from = msg.sender;
1371 
1372     // get token owner address (also ensures that token exists)
1373     address owner = ownerOf(_tokenId);
1374 
1375     // caller must own this token
1376     require(from == owner);
1377     // approval for owner himself is pointless, do not allow
1378     require(_approved != owner);
1379     // either we're removing approval, or setting it
1380     require(approvals[_tokenId] != address(0) || _approved != address(0));
1381 
1382     // set an approval (deletes an approval if to == 0)
1383     approvals[_tokenId] = _approved;
1384 
1385     // emit an ERC721 event
1386     emit Approval(from, _approved, _tokenId);
1387   }
1388 
1389   /**
1390    * @notice Removes an approved address, which was previously added by `approve`
1391    *      for the given token. Equivalent to calling approve(0, tokenId)
1392    * @dev Same as calling approve(0, tokenId)
1393    * @param _tokenId ID of the token to remove approved address for
1394    */
1395   function revokeApproval(uint256 _tokenId) public {
1396     // delegate call to `approve`
1397     approve(address(0), _tokenId);
1398   }
1399 
1400   /**
1401    * @dev Sets or unsets the approval of a given operator
1402    * @dev An operator is allowed to transfer *all* tokens of the sender on their behalf
1403    * @param to operator address to set the approval for
1404    * @param approved representing the status of the approval to be set
1405    */
1406   function setApprovalForAll(address to, bool approved) public {
1407     // call sender nicely - `from`
1408     address from = msg.sender;
1409 
1410     // validate destination address
1411     require(to != address(0));
1412 
1413     // approval for owner himself is pointless, do not allow
1414     require(to != from);
1415 
1416     // set an approval
1417     approvedOperators[from][to] = approved;
1418 
1419     // emit an ERC721 compliant event
1420     emit ApprovalForAll(from, to, approved);
1421   }
1422 
1423   /**
1424    * @notice Get the approved address for a single token
1425    * @dev Throws if `_tokenId` is not a valid token ID.
1426    * @param _tokenId ID of the token to find the approved address for
1427    * @return the approved address for this token, or the zero address if there is none
1428    */
1429   function getApproved(uint256 _tokenId) public constant returns (address) {
1430     // validate token existence
1431     require(exists(_tokenId));
1432 
1433     // find approved address and return
1434     return approvals[_tokenId];
1435   }
1436 
1437   /**
1438    * @notice Query if an address is an authorized operator for another address
1439    * @param _owner the address that owns at least one token
1440    * @param _operator the address that acts on behalf of the owner
1441    * @return true if `_operator` is an approved operator for `_owner`, false otherwise
1442    */
1443   function isApprovedForAll(address _owner, address _operator) public constant returns (bool) {
1444     // is there a positive amount of approvals left
1445     return approvedOperators[_owner][_operator];
1446   }
1447 
1448   /**
1449    * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
1450    * @dev Throws if `_tokenId` is not a valid token ID.
1451    *      URIs are defined in RFC 3986.
1452    * @param _tokenId uint256 ID of the token to query
1453    * @return token URI
1454    */
1455   function tokenURI(uint256 _tokenId) public constant returns (string) {
1456     // validate token existence
1457     require(exists(_tokenId));
1458 
1459     // token URL consists of base URL part (domain) and token ID
1460     return StringUtils.concat("http://cryptominerworld.com/gem/", StringUtils.itoa(_tokenId, 16));
1461   }
1462 
1463   /// @dev Creates new token with `tokenId` ID specified and
1464   ///      assigns an ownership `to` for this token
1465   /// @dev Unsafe: doesn't check if caller has enough permissions to execute the call
1466   ///      checks only that the token doesn't exist yet
1467   /// @dev Must be kept private at all times
1468   function __mint(
1469     address to,
1470     uint32 tokenId,
1471     uint32 plotId,
1472     uint16 depth,
1473     uint16 gemNum,
1474     uint8 color,
1475     uint8 level,
1476     uint8 gradeType,
1477     uint24 gradeValue
1478   ) private {
1479     // check that `tokenId` is inside valid bounds
1480     require(tokenId > 0);
1481 
1482     // ensure that token with such ID doesn't exist
1483     require(!exists(tokenId));
1484 
1485     // create new gem in memory
1486     Gem memory gem = Gem({
1487       coordinates: uint64(plotId) << 32 | uint32(depth) << 16 | gemNum,
1488       color: color,
1489       levelModified: 0,
1490       level: level,
1491       gradeModified: 0,
1492       grade: uint32(gradeType) << 24 | gradeValue,
1493       stateModified: 0,
1494       state: 0,
1495 
1496       creationTime: uint32(block.number),
1497       // token index within the owner's collection of token
1498       // points to the place where the token will be placed to
1499       index: uint32(collections[to].length),
1500       ownershipModified: 0,
1501       owner: to
1502     });
1503 
1504     // push newly created `tokenId` to the owner's collection of tokens
1505     collections[to].push(tokenId);
1506 
1507     // persist gem to the storage
1508     gems[tokenId] = gem;
1509 
1510     // add token ID to the `allTokens` collection,
1511     // automatically updates total supply
1512     allTokens.push(tokenId);
1513 
1514     // fire Minted event
1515     emit Minted(msg.sender, to, tokenId);
1516     // fire ERC20/ERC721 transfer event
1517     emit Transfer(address(0), to, tokenId, 1);
1518   }
1519 
1520   /// @dev Performs a transfer of a token `tokenId` from address `from` to address `to`
1521   /// @dev Unsafe: doesn't check if caller has enough permissions to execute the call;
1522   ///      checks only for token existence and that ownership belongs to `from`
1523   /// @dev Is save to call from `transfer(to, tokenId)` since it doesn't need any additional checks
1524   /// @dev Must be kept private at all times
1525   function __transfer(address from, address to, uint256 _tokenId) private {
1526     // validate source and destination address
1527     require(to != address(0));
1528     require(to != from);
1529     // impossible by design of transfer(), transferFrom(),
1530     // approveToken() and approve()
1531     assert(from != address(0));
1532 
1533     // validate token existence
1534     require(exists(_tokenId));
1535 
1536     // validate token ownership
1537     require(ownerOf(_tokenId) == from);
1538 
1539     // transfer is not allowed for a locked gem
1540     // (ex.: if ge is currently mining)
1541     require(getState(_tokenId) & lockedBitmask == 0);
1542 
1543     // clear approved address for this particular token + emit event
1544     __clearApprovalFor(_tokenId);
1545 
1546     // move gem ownership,
1547     // update old and new owner's gem collections accordingly
1548     __move(from, to, _tokenId);
1549 
1550     // fire ERC20/ERC721 transfer event
1551     emit Transfer(from, to, _tokenId, 1);
1552   }
1553 
1554   /// @dev Clears approved address for a particular token
1555   function __clearApprovalFor(uint256 _tokenId) private {
1556     // check if approval exists - we don't want to fire an event in vain
1557     if(approvals[_tokenId] != address(0)) {
1558       // clear approval
1559       delete approvals[_tokenId];
1560 
1561       // emit an ERC721 event
1562       emit Approval(msg.sender, address(0), _tokenId);
1563     }
1564   }
1565 
1566   /// @dev Move a `gem` from owner `from` to a new owner `to`
1567   /// @dev Unsafe, doesn't check for consistence
1568   /// @dev Must be kept private at all times
1569   function __move(address from, address to, uint256 _tokenId) private {
1570     // cast token ID to uint32 space
1571     uint32 tokenId = uint32(_tokenId);
1572 
1573     // overflow check, failure impossible by design of mint()
1574     assert(tokenId == _tokenId);
1575 
1576     // get the gem pointer to the storage
1577     Gem storage gem = gems[_tokenId];
1578 
1579     // get a reference to the collection where gem is now
1580     uint32[] storage source = collections[from];
1581 
1582     // get a reference to the collection where gem goes to
1583     uint32[] storage destination = collections[to];
1584 
1585     // collection `source` cannot be empty, if it is - it's a bug
1586     assert(source.length != 0);
1587 
1588     // index of the gem within collection `source`
1589     uint32 i = gem.index;
1590 
1591     // we put the last gem in the collection `source` to the position released
1592     // get an ID of the last gem in `source`
1593     uint32 sourceId = source[source.length - 1];
1594 
1595     // update gem index to point to proper place in the collection `source`
1596     gems[sourceId].index = i;
1597 
1598     // put it into the position i within `source`
1599     source[i] = sourceId;
1600 
1601     // trim the collection `source` by removing last element
1602     source.length--;
1603 
1604     // update gem index according to position in new collection `destination`
1605     gem.index = uint32(destination.length);
1606 
1607     // update gem owner
1608     gem.owner = to;
1609 
1610     // update ownership transfer date
1611     gem.ownershipModified = uint32(block.number);
1612 
1613     // push gem into collection
1614     destination.push(tokenId);
1615   }
1616 
1617 }