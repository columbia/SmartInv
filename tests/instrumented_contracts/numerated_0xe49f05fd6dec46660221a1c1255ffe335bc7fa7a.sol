1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * Utility library of inline functions on addresses
6  */
7 library AddressUtils {
8 
9   /**
10    * @notice Checks if the target address is a contract
11    * @dev This function will return false if invoked during the constructor of a contract,
12    *      as the code is not actually created until after the constructor finishes.
13    * @param addr address to check
14    * @return whether the target address is a contract
15    */
16   function isContract(address addr) internal view returns (bool) {
17     // a variable to load `extcodesize` to
18     uint256 size = 0;
19 
20     // XXX Currently there is no better way to check if there is a contract in an address
21     // than to check the size of the code at that address.
22     // See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
23     // TODO: Check this again before the Serenity release, because all addresses will be contracts.
24     // solium-disable-next-line security/no-inline-assembly
25     assembly {
26       // retrieve the size of the code at address `addr`
27       size := extcodesize(addr)
28     }
29 
30     // positive size indicates a smart contract address
31     return size > 0;
32   }
33 
34 }
35 
36 
37 /**
38  * Library for working with strings, primarily converting
39  * between strings and integer types
40  */
41 library StringUtils {
42   /**
43    * @dev Converts a string to unsigned integer using the specified `base`
44    * @dev Throws on invalid input
45    *      (wrong characters for a given `base`)
46    * @dev Throws if given `base` is not supported
47    * @param a string to convert
48    * @param base number base, one of 2, 8, 10, 16
49    * @return a number representing given string
50    */
51   function atoi(string a, uint8 base) internal pure returns (uint256 i) {
52     // check if the base is valid
53     require(base == 2 || base == 8 || base == 10 || base == 16);
54 
55     // convert string into bytes for convenient iteration
56     bytes memory buf = bytes(a);
57 
58     // iterate over the string (bytes buffer)
59     for(uint256 p = 0; p < buf.length; p++) {
60       // extract the digit
61       uint8 digit = uint8(buf[p]) - 0x30;
62 
63       // if digit is greater then 10 – mind the gap
64       // see `itoa` function for more details
65       if(digit > 10) {
66         // remove the gap
67         digit -= 7;
68       }
69 
70       // check if digit meets the base
71       require(digit < base);
72 
73       // move to the next digit slot
74       i *= base;
75 
76       // add digit to the result
77       i += digit;
78     }
79 
80     // return the result
81     return i;
82   }
83 
84   /**
85    * @dev Converts a integer to a string using the specified `base`
86    * @dev Throws if given `base` is not supported
87    * @param i integer to convert
88    * @param base number base, one of 2, 8, 10, 16
89    * @return a string representing given integer
90    */
91   function itoa(uint256 i, uint8 base) internal pure returns (string a) {
92     // check if the base is valid
93     require(base == 2 || base == 8 || base == 10 || base == 16);
94 
95     // for zero input the result is "0" string for any base
96     if (i == 0) {
97       return "0";
98     }
99 
100     // bytes buffer to put ASCII characters into
101     bytes memory buf = new bytes(256);
102 
103     // position within a buffer to be used in cycle
104     uint256 p = 0;
105 
106     // extract digits one by one in a cycle
107     while (i > 0) {
108       // extract current digit
109       uint8 digit = uint8(i % base);
110 
111       // convert it to an ASCII code
112       // 0x20 is " "
113       // 0x30-0x39 is "0"-"9"
114       // 0x41-0x5A is "A"-"Z"
115       // 0x61-0x7A is "a"-"z" ("A"-"Z" XOR " ")
116       uint8 ascii = digit + 0x30;
117 
118       // if digit is greater then 10,
119       // fix the 0x3A-0x40 gap of punctuation marks
120       // (7 characters in ASCII table)
121       if(digit > 10) {
122         // jump through the gap
123         ascii += 7;
124       }
125 
126       // write character into the buffer
127       buf[p++] = byte(ascii);
128 
129       // move to the next digit
130       i /= base;
131     }
132 
133     // `p` contains real length of the buffer now, save it
134     uint256 length = p;
135 
136     // reverse the buffer
137     for(p = 0; p < length / 2; p++) {
138       // swap elements at position `p` from the beginning and end using XOR:
139       // https://en.wikipedia.org/wiki/XOR_swap_algorithm
140       buf[p] ^= buf[length - 1 - p];
141       buf[length - 1 - p] ^= buf[p];
142       buf[p] ^= buf[length - 1 - p];
143     }
144 
145     // construct string and return
146     return string(buf);
147   }
148 
149   /**
150    * @dev Concatenates two strings `s1` and `s2`, for example, if
151    *      `s1` == `foo` and `s2` == `bar`, the result `s` == `foobar`
152    * @param s1 first string
153    * @param s2 second string
154    * @return concatenation result s1 + s2
155    */
156   function concat(string s1, string s2) internal pure returns (string s) {
157     // convert s1 into buffer 1
158     bytes memory buf1 = bytes(s1);
159     // convert s2 into buffer 2
160     bytes memory buf2 = bytes(s2);
161     // create a buffer for concatenation result
162     bytes memory buf = new bytes(buf1.length + buf2.length);
163 
164     // copy buffer 1 into buffer
165     for(uint256 i = 0; i < buf1.length; i++) {
166       buf[i] = buf1[i];
167     }
168 
169     // copy buffer 2 into buffer
170     for(uint256 j = buf1.length; j < buf2.length; j++) {
171       buf[j] = buf2[j - buf1.length];
172     }
173 
174     // construct string and return
175     return string(buf);
176   }
177 }
178 
179 
180 /**
181  * @dev Access control module provides an API to check
182  *      if specific operation is permitted globally and
183  *      if particular user's has a permission to execute it
184  */
185 contract AccessControl {
186   /// @notice Role manager is responsible for assigning the roles
187   /// @dev Role ROLE_ROLE_MANAGER allows executing addOperator/removeOperator
188   uint256 private constant ROLE_ROLE_MANAGER = 0x10000000;
189 
190   /// @notice Feature manager is responsible for enabling/disabling
191   ///      global features of the smart contract
192   /// @dev Role ROLE_FEATURE_MANAGER allows enabling/disabling global features
193   uint256 private constant ROLE_FEATURE_MANAGER = 0x20000000;
194 
195   /// @dev Bitmask representing all the possible permissions (super admin role)
196   uint256 private constant FULL_PRIVILEGES_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
197 
198   /// @dev A bitmask of globally enabled features
199   uint256 public features;
200 
201   /// @notice Privileged addresses with defined roles/permissions
202   /// @notice In the context of ERC20/ERC721 tokens these can be permissions to
203   ///      allow minting tokens, transferring on behalf and so on
204   /// @dev Maps an address to the permissions bitmask (role), where each bit
205   ///      represents a permission
206   /// @dev Bitmask 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
207   ///      represents all possible permissions
208   mapping(address => uint256) public userRoles;
209 
210   /// @dev Fired in updateFeatures()
211   event FeaturesUpdated(address indexed _by, uint256 _requested, uint256 _actual);
212 
213   /// @dev Fired in addOperator(), removeOperator(), addRole(), removeRole()
214   event RoleUpdated(address indexed _by, address indexed _to, uint256 _role);
215 
216   /**
217    * @dev Creates an access controlled instance
218    */
219   constructor() public {
220     // contract creator has full privileges
221     userRoles[msg.sender] = FULL_PRIVILEGES_MASK;
222   }
223 
224   /**
225    * @dev Updates set of the globally enabled features (`f`),
226    *      taking into account sender's permissions.
227    * @dev Requires sender to have `ROLE_FEATURE_MANAGER` permission.
228    * @param mask bitmask representing a set of features to enable/disable
229    */
230   function updateFeatures(uint256 mask) public {
231     // call sender nicely - caller
232     address caller = msg.sender;
233     // read caller's permissions
234     uint256 p = userRoles[caller];
235 
236     // caller should have a permission to update global features
237     require(__hasRole(p, ROLE_FEATURE_MANAGER));
238 
239     // taking into account caller's permissions,
240     // 1) enable features requested
241     features |= p & mask;
242     // 2) disable features requested
243     features &= FULL_PRIVILEGES_MASK ^ (p & (FULL_PRIVILEGES_MASK ^ mask));
244 
245     // fire an event
246     emit FeaturesUpdated(caller, mask, features);
247   }
248 
249   /**
250    * @dev Adds a new `operator` - an address which has
251    *      some extended privileges over the smart contract,
252    *      for example token minting, transferring on behalf, etc.
253    * @dev Newly added `operator` cannot have any permissions which
254    *      transaction sender doesn't have.
255    * @dev Requires transaction sender to have `ROLE_ROLE_MANAGER` permission.
256    * @dev Cannot update existing operator. Throws if `operator` already exists.
257    * @param operator address of the operator to add
258    * @param role bitmask representing a set of permissions which
259    *      newly created operator will have
260    */
261   function addOperator(address operator, uint256 role) public {
262     // call sender gracefully - `manager`
263     address manager = msg.sender;
264 
265     // read manager's permissions (role)
266     uint256 permissions = userRoles[manager];
267 
268     // check that `operator` doesn't exist
269     require(userRoles[operator] == 0);
270 
271     // manager must have a ROLE_ROLE_MANAGER role
272     require(__hasRole(permissions, ROLE_ROLE_MANAGER));
273 
274     // recalculate permissions (role) to set:
275     // we cannot create an operator more powerful then calling `manager`
276     uint256 r = role & permissions;
277 
278     // check if we still have some permissions (role) to set
279     require(r != 0);
280 
281     // create an operator by persisting his permissions (roles) to storage
282     userRoles[operator] = r;
283 
284     // fire an event
285     emit RoleUpdated(manager, operator, userRoles[operator]);
286   }
287 
288   /**
289    * @dev Deletes an existing `operator`.
290    * @dev Requires sender to have `ROLE_ROLE_MANAGER` permission.
291    * @param operator address of the operator to delete
292    */
293   function removeOperator(address operator) public {
294     // call sender gracefully - `manager`
295     address manager = msg.sender;
296 
297     // check if an `operator` exists
298     require(userRoles[operator] != 0);
299 
300     // do not allow transaction sender to remove himself
301     // protects from an accidental removal of all the operators
302     require(operator != manager);
303 
304     // manager must have a ROLE_ROLE_MANAGER role
305     // and he must have all the permissions operator has
306     require(__hasRole(userRoles[manager], ROLE_ROLE_MANAGER | userRoles[operator]));
307 
308     // perform operator deletion
309     delete userRoles[operator];
310 
311     // fire an event
312     emit RoleUpdated(manager, operator, 0);
313   }
314 
315   /**
316    * @dev Updates an existing `operator`, adding a specified role to it.
317    * @dev Note that `operator` cannot receive permission which
318    *      transaction sender doesn't have.
319    * @dev Requires transaction sender to have `ROLE_ROLE_MANAGER` permission.
320    * @dev Cannot create a new operator. Throws if `operator` doesn't exist.
321    * @dev Existing permissions of the `operator` are preserved
322    * @param operator address of the operator to update
323    * @param role bitmask representing a set of permissions which
324    *      `operator` will have
325    */
326   function addRole(address operator, uint256 role) public {
327     // call sender gracefully - `manager`
328     address manager = msg.sender;
329 
330     // read manager's permissions (role)
331     uint256 permissions = userRoles[manager];
332 
333     // check that `operator` exists
334     require(userRoles[operator] != 0);
335 
336     // manager must have a ROLE_ROLE_MANAGER role
337     require(__hasRole(permissions, ROLE_ROLE_MANAGER));
338 
339     // recalculate permissions (role) to add:
340     // we cannot make an operator more powerful then calling `manager`
341     uint256 r = role & permissions;
342 
343     // check if we still have some permissions (role) to add
344     require(r != 0);
345 
346     // update operator's permissions (roles) in the storage
347     userRoles[operator] |= r;
348 
349     // fire an event
350     emit RoleUpdated(manager, operator, userRoles[operator]);
351   }
352 
353   /**
354    * @dev Updates an existing `operator`, removing a specified role from it.
355    * @dev Note that  permissions which transaction sender doesn't have
356    *      cannot be removed.
357    * @dev Requires transaction sender to have `ROLE_ROLE_MANAGER` permission.
358    * @dev Cannot remove all permissions. Throws on such an attempt.
359    * @param operator address of the operator to update
360    * @param role bitmask representing a set of permissions which
361    *      will be removed from the `operator`
362    */
363   function removeRole(address operator, uint256 role) public {
364     // call sender gracefully - `manager`
365     address manager = msg.sender;
366 
367     // read manager's permissions (role)
368     uint256 permissions = userRoles[manager];
369 
370     // check that we're not removing all the `operator`s permissions
371     // this is not really required and just causes inconveniences is function use
372     //require(userRoles[operator] ^ role != 0);
373 
374     // manager must have a ROLE_ROLE_MANAGER role
375     require(__hasRole(permissions, ROLE_ROLE_MANAGER));
376 
377     // recalculate permissions (role) to remove:
378     // we cannot revoke permissions which calling `manager` doesn't have
379     uint256 r = role & permissions;
380 
381     // check if we still have some permissions (role) to revoke
382     require(r != 0);
383 
384     // update operator's permissions (roles) in the storage
385     userRoles[operator] &= FULL_PRIVILEGES_MASK ^ r;
386 
387     // fire an event
388     emit RoleUpdated(manager, operator, userRoles[operator]);
389   }
390 
391   /// @dev Checks if requested feature is enabled globally on the contract
392   function __isFeatureEnabled(uint256 featureRequired) internal constant returns(bool) {
393     // delegate call to `__hasRole`
394     return __hasRole(features, featureRequired);
395   }
396 
397   /// @dev Checks if transaction sender `msg.sender` has all the required permissions `roleRequired`
398   function __isSenderInRole(uint256 roleRequired) internal constant returns(bool) {
399     // read sender's permissions (role)
400     uint256 userRole = userRoles[msg.sender];
401 
402     // delegate call to `__hasRole`
403     return __hasRole(userRole, roleRequired);
404   }
405 
406   /// @dev Checks if user role `userRole` contain all the permissions required `roleRequired`
407   function __hasRole(uint256 userRole, uint256 roleRequired) internal pure returns(bool) {
408     // check the bitmask for the role required and return the result
409     return userRole & roleRequired == roleRequired;
410   }
411 }
412 
413 
414 /**
415  * @title ERC721 token receiver interface
416  * @dev Interface for any contract that wants to support safe transfers
417  *      from ERC721 asset contracts.
418  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
419  */
420 interface ERC721Receiver {
421   /**
422    * @notice Handle the receipt of an NFT
423    * @dev The ERC721 smart contract calls this function on the recipient after a `transfer`.
424    *      This function MAY throw to revert and reject the transfer.
425    *      Return of other than the magic value MUST result in the transaction being reverted.
426    * @notice The contract address is always the message sender.
427    *      A wallet/broker/auction application MUST implement the wallet interface
428    *      if it will accept safe transfers.
429    * @param _operator The address which called `safeTransferFrom` function
430    * @param _from The address which previously owned the token
431    * @param _tokenId The NFT identifier which is being transferred
432    * @param _data Additional data with no specified format
433    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing
434    */
435   function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
436 }
437 
438 
439 /**
440  * @title ERC165
441  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
442  */
443 contract ERC165 {
444   /**
445    * 0x01ffc9a7 == bytes4(keccak256('supportsInterface(bytes4)'))
446    */
447   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
448 
449   /**
450    * @dev a mapping of interface id to whether or not it's supported
451    */
452   mapping(bytes4 => bool) internal supportedInterfaces;
453 
454   /**
455    * @dev A contract implementing SupportsInterfaceWithLookup
456    * implement ERC165 itself
457    */
458   constructor() public {
459     // register itself in a lookup table
460     _registerInterface(InterfaceId_ERC165);
461   }
462 
463 
464 
465   /**
466    * @notice Query if a contract implements an interface
467    * @dev Interface identification is specified in ERC-165.
468    *      This function uses less than 30,000 gas.
469    * @param _interfaceId The interface identifier, as specified in ERC-165
470    * @return `true` if the contract implements `interfaceID` and
471    *      `interfaceID` is not 0xffffffff, `false` otherwise
472    */
473   function supportsInterface(bytes4 _interfaceId) public constant returns (bool) {
474     // find if interface is supported using a lookup table
475     return supportedInterfaces[_interfaceId];
476   }
477 
478   /**
479    * @dev private method for registering an interface
480    */
481   function _registerInterface(bytes4 _interfaceId) internal {
482     require(_interfaceId != 0xffffffff);
483     supportedInterfaces[_interfaceId] = true;
484   }
485 }
486 
487 
488 /**
489  * @notice Library for working with fractions.
490  * @notice A fraction is represented by two numbers - nominator and denominator.
491  * @dev A fraction is represented as uint16,
492  *      higher 8 bits representing nominator
493  *      and lower 8 bits representing denominator
494  */
495 library Fractions16 {
496   /**
497    * @dev Creates proper fraction with nominator < denominator
498    * @dev Throws if nominator is equal or greater then denominator
499    * @dev Throws if denominator is zero
500    * @param n fraction nominator
501    * @param d fraction denominator
502    * @return fraction with nominator and denominator specified
503    */
504   function createProperFraction16(uint8 n, uint8 d) internal pure returns (uint16) {
505     // denominator cannot be zero by the definition of division
506     require(d != 0);
507 
508     // fraction has to be proper
509     require(n < d);
510 
511     // construct fraction and return
512     return uint16(n) << 8 | d;
513   }
514 
515   /**
516    * @dev Converts a proper fraction to its percent representation,
517    *      rounding down the value. For example,
518    *        toPercent(1/10) is 10,
519    *        toPercent(37/100) is 37,
520    *        toPercent(37/1000) is 3
521    *        toPercent(19/37) is 51
522    * @dev Supports proper fractions and 'one' (nominator equal to denominator),
523    *      which is equal to 100%
524    * @dev Throws if nominator is bigger than denominator
525    * @param f positive proper fraction
526    * @return a value in a range [0..100]
527    */
528   function toPercent(uint16 f) internal pure returns(uint8) {
529     // extract nominator and denominator
530     uint8 nominator = getNominator(f);
531     uint8 denominator = getDenominator(f);
532 
533     // for a fraction representing one just return 100%
534     if(nominator == denominator) {
535       // one is 100%
536       return 100;
537     }
538 
539     // next section of code is for proper fractions only
540     require(nominator < denominator);
541 
542     // since fraction is proper one it safe to perform straight forward calculation
543     // the only thing to worry - possible arithmetic overflow
544     return uint8(100 * uint16(nominator) / denominator);
545   }
546 
547   /**
548    * @dev Checks if a fraction represents zero (nominator is zero)
549    * @param f a fraction
550    * @return true if fraction is zero (nominator is zero), false otherwise
551    */
552   function isZero(uint16 f) internal pure returns(bool) {
553     // just check if the nominator is zero
554     return getNominator(f) == 0;
555   }
556 
557   /**
558    * @dev Checks if a fraction represents one (nominator is equal to denominator)
559    * @param f a fraction
560    * @return true if fraction is one (nominator is equal to denominator), false otherwise
561    */
562   function isOne(uint16 f) internal pure returns(bool) {
563     // just check if the nominator is equal to denominator
564     return getNominator(f) == getDenominator(f);
565   }
566 
567   /**
568    * @dev Checks if a fraction is proper (nominator is less than denominator)
569    * @param f a fraction
570    * @return true if fraction is proper (nominator is less than denominator), false otherwise
571    */
572   function isProper(uint16 f) internal pure returns(bool) {
573     // just check that nominator is less than denominator
574     // this automatically ensures denominator is not zero
575     return getNominator(f) < getDenominator(f);
576   }
577 
578   /**
579    * @dev Extracts fraction nominator
580    * @param f a fraction
581    * @return nominator
582    */
583   function getNominator(uint16 f) internal pure returns(uint8) {
584     return uint8(f >> 8);
585   }
586 
587   /**
588    * @dev Extracts fraction denominator
589    * @param f a fraction
590    * @return denominator
591    */
592   function getDenominator(uint16 f) internal pure returns(uint8) {
593     return uint8(f);
594   }
595 
596   /**
597    * @dev Multiplies a proper fraction by integer, the resulting integer is rounded down
598    * @param f a fraction
599    * @param by an integer to multiply fraction by
600    * @return result of multiplication `f * by`
601    */
602   function multiplyByInteger(uint16 f, uint256 by) internal pure returns(uint256) {
603     // extract nominator and denominator
604     uint8 nominator = getNominator(f);
605     uint8 denominator = getDenominator(f);
606 
607     // for a fraction representing one just return `by`
608     if(nominator == denominator) {
609       // the result of multiplication by one is the value itself
610       return by;
611     }
612 
613     // next section of code is for proper fractions only
614     require(nominator < denominator);
615 
616     // for values small enough multiplication is straight forward
617     if(by == uint240(by)) {
618       // ensure the maximum precision of calculation
619       return by * nominator / denominator;
620     }
621 
622     // for big values we perform division first, loosing the precision
623     return by / denominator * nominator;
624   }
625 }
626 
627 
628 /**
629  * @notice Country is unique tradable entity. Non-fungible.
630  * @dev A country is an ERC721 non-fungible token, which maps Token ID,
631  *      a 8 bit number in range [1, 192] to a set of country properties -
632  *      number of plots and owner's tax rate.
633  * @dev Country token supports only minting of predefined countries,
634  *      its not possible to destroy a country.
635  * @dev Up to 192 countries are defined during contract deployment and initialization.
636  */
637 contract CountryERC721 is AccessControl, ERC165 {
638   /// @dev Using library Fractions for fraction math
639   using Fractions16 for uint16;
640 
641   /// @dev Smart contract version
642   /// @dev Should be incremented manually in this source code
643   ///      each time smart contact source code is changed
644   uint32 public constant TOKEN_VERSION = 0x1;
645 
646   /// @dev ERC20 compliant token symbol
647   string public constant symbol = "CTY";
648   /// @dev ERC20 compliant token name
649   string public constant name = "Country – CryptoMiner World";
650   /// @dev ERC20 compliant token decimals
651   /// @dev this can be only zero, since ERC721 token is non-fungible
652   uint8 public constant decimals = 0;
653 
654   /// @dev Country data structure
655   /// @dev Occupies 1 storage slot (240 bits)
656   struct Country {
657     /// @dev Unique country ID ∈ [1, 192]
658     uint8 id;
659 
660     /// @dev Number of land plots country has,
661     ///      proportional to the country area
662     uint16 plots;
663 
664     /// @dev Percentage country owner receives from each sale
665     uint16 tax;
666 
667     /// @dev Tax modified time - unix timestamp
668     uint32 taxModified;
669 
670     /// @dev Country index within an owner's collection of countries
671     uint8 index;
672 
673     /// @dev Country owner, initialized upon country creation
674     address owner;
675   }
676 
677   /// @dev Country data array contains number of plots each country contains
678   uint16[] public countryData;
679 
680   /// @notice All the existing countries
681   /// @dev Core of the Country as ERC721 token
682   /// @dev Maps Country ID => Country Data Structure
683   mapping(uint256 => Country) public countries;
684 
685   /// @dev Mapping from a token ID to an address approved to
686   ///      transfer ownership rights for this token
687   mapping(uint256 => address) public approvals;
688 
689   /// @dev Mapping from owner to operator approvals
690   ///      token owner => approved token operator => is approved
691   mapping(address => mapping(address => bool)) public approvedOperators;
692 
693   /// @notice Storage for a collections of tokens
694   /// @notice A collection of tokens is an unordered list of token IDs,
695   ///      owned by a particular address (owner)
696   /// @dev A mapping from owner to a collection of his tokens (IDs)
697   /// @dev ERC20 compliant structure for balances can be derived
698   ///      as a length of each collection in the mapping
699   /// @dev ERC20 balances[owner] is equal to collections[owner].length
700   mapping(address => uint8[]) public collections;
701 
702   /// @dev Array with all token ids, used for enumeration
703   /// @dev ERC20 compliant structure for totalSupply can be derived
704   ///      as a length of this collection
705   /// @dev ERC20 totalSupply() is equal to allTokens.length
706   uint8[] public allTokens;
707 
708   /// @dev Total number of countries this smart contract holds
709   uint8 private _totalSupply;
710 
711   /// @dev Token bitmap – bitmap of 192 elements indicating existing (minted) tokens
712   /// @dev For any i ∈ [0, 191] - tokenMap[i] (which is tokenMap >> i & 0x1)
713   ///      is equal to one if token with ID i exists and to zero if it doesn't
714   uint192 public tokenMap;
715 
716   /// @notice The maximum frequency at which tax rate for a token can be changed
717   /// @dev Tax rate cannot be changed more frequently than once per `MAX_TAX_CHANGE_FREQ` seconds
718   uint32 public maxTaxChangeFreq = 86400; // seconds
719 
720   /// @dev Maximum tokens allowed should comply with the `tokenMap` type
721   /// @dev This setting is used only in contract constructor, actual
722   ///      maximum supply is defined by `countryData` array length
723   uint8 public constant TOTAL_SUPPLY_MAX = 192;
724 
725   /// @notice Maximum tax rate that can be set on the country
726   /// @dev This is an inverted value of the maximum tax:
727   ///      `MAX_TAX_RATE = 1 / MAX_TAX_INV`
728   uint8 public constant MAX_TAX_INV = 5; // 1/5 or 20%
729 
730   /// @notice Default tax rate that is assigned to each country
731   /// @dev This tax rate is set on each country when minting its token
732   uint16 public constant DEFAULT_TAX_RATE = 0x010A; // 1/10 or 10%
733 
734   /// @dev Enables ERC721 transfers of the tokens
735   uint32 public constant FEATURE_TRANSFERS = 0x00000001;
736 
737   /// @dev Enables ERC721 transfers on behalf
738   uint32 public constant FEATURE_TRANSFERS_ON_BEHALF = 0x00000002;
739 
740   /// @dev Allows owners to update tax value
741   uint32 public constant FEATURE_ALLOW_TAX_UPDATE = 0x00000004;
742 
743   /// @notice Tax manager is responsible for updating maximum
744   ///     allowed frequency of tax rate change
745   /// @dev Role ROLE_TAX_MANAGER allows updating `maxTaxChangeFreq`
746   uint32 public constant ROLE_TAX_MANAGER = 0x00020000;
747 
748   /// @notice Token creator is responsible for creating tokens
749   /// @dev Role ROLE_TOKEN_CREATOR allows minting tokens
750   uint32 public constant ROLE_TOKEN_CREATOR = 0x00040000;
751 
752   /// @dev Magic value to be returned upon successful reception of an NFT
753   /// @dev Equal to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
754   ///      which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
755   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
756 
757   /**
758    * Supported interfaces section
759    */
760 
761   /**
762    * ERC721 interface definition in terms of ERC165
763    *
764    * 0x80ac58cd ==
765    *   bytes4(keccak256('balanceOf(address)')) ^
766    *   bytes4(keccak256('ownerOf(uint256)')) ^
767    *   bytes4(keccak256('approve(address,uint256)')) ^
768    *   bytes4(keccak256('getApproved(uint256)')) ^
769    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
770    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
771    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
772    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
773    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
774    */
775   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
776 
777   /**
778    * ERC721 interface extension – exists(uint256)
779    *
780    * 0x4f558e79 == bytes4(keccak256('exists(uint256)'))
781    */
782   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
783 
784   /**
785    * ERC721 interface extension - ERC721Enumerable
786    *
787    * 0x780e9d63 ==
788    *   bytes4(keccak256('totalSupply()')) ^
789    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
790    *   bytes4(keccak256('tokenByIndex(uint256)'))
791    */
792   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
793 
794   /**
795    * ERC721 interface extension - ERC721Metadata
796    *
797    * 0x5b5e139f ==
798    *   bytes4(keccak256('name()')) ^
799    *   bytes4(keccak256('symbol()')) ^
800    *   bytes4(keccak256('tokenURI(uint256)'))
801    */
802   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
803 
804   /// @dev Event names are self-explanatory:
805   /// @dev Fired in mint()
806   /// @dev Address `_by` allows to track who created a token
807   event Minted(address indexed _by, address indexed _to, uint8 indexed _tokenId);
808 
809   /// @dev Fired in transfer(), transferFor(), mint()
810   /// @dev When minting a token, address `_from` is zero
811   /// @dev ERC20/ERC721 compliant event
812   event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId, uint256 _value);
813 
814   /// @dev Fired in approve()
815   /// @dev ERC721 compliant event
816   event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
817 
818   /// @dev Fired in setApprovalForAll()
819   /// @dev ERC721 compliant event
820   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _value);
821 
822   /// @dev Fired in updateTaxRate()
823   event TaxRateUpdated(address indexed _owner, uint256 indexed _tokenId, uint16 tax, uint16 oldTax);
824 
825   /**
826    * @dev Creates a Country ERC721 instance,
827    * @dev Registers a ERC721 interface using ERC165
828    * @dev Initializes the contract with the country data provided
829    * @param _countryData array of packed data structures containing
830    *        number of plots for each country
831    */
832   constructor(uint16[] _countryData) public {
833     // register the supported interfaces to conform to ERC721 via ERC165
834     _registerInterface(InterfaceId_ERC721);
835     _registerInterface(InterfaceId_ERC721Exists);
836     _registerInterface(InterfaceId_ERC721Enumerable);
837     _registerInterface(InterfaceId_ERC721Metadata);
838 
839     // maximum of 192 countries allowed
840     require(_countryData.length <= TOTAL_SUPPLY_MAX);
841 
842     // init country data array
843     countryData = _countryData;
844   }
845 
846   /**
847    * @notice Number of countries this contract can have
848    * @dev Maximum number of tokens that contract can mint
849    * @return length of country data array
850    */
851   function getNumberOfCountries() public constant returns(uint8) {
852     // read country data array length and return
853     return uint8(countryData.length);
854   }
855 
856   /**
857    * @dev Calculates cumulative number of plots all the countries have in total
858    * @return sum of the countries number of plots
859    */
860   function getTotalNumberOfPlots() public constant returns(uint32) {
861     // variable to accumulate result into
862     uint32 result = 0;
863 
864     // iterate over all the tokens and accumulate the result
865     for(uint i = 0; i < countryData.length; i++) {
866       // accumulate the result
867       result += countryData[i];
868     }
869 
870     // return the result
871     return result;
872   }
873 
874   /**
875    * @dev Calculates cumulative number of plots
876    *      all the countries belonging to given owner have in total
877    * @param owner address of the owner to query countries for
878    * @return sum of the countries number of plots owned by given address
879    */
880   function getNumberOfPlotsByCountryOwner(address owner) public constant returns(uint32) {
881     // variable to accumulate result into
882     uint32 result = 0;
883 
884     // iterate over all owner's tokens and accumulate the result
885     for(uint i = 0; i < collections[owner].length; i++) {
886       // accumulate the result
887       result += countries[collections[owner][i]].plots;
888     }
889 
890     // return the result
891     return result;
892   }
893 
894   /**
895    * @dev Gets a country by ID, representing it as a single 32-bit integer.
896    *      The integer is tightly packed with the country data:
897    *        number of plots
898    *        tax nominator
899    *        tax denominator
900    * @dev Throws if country doesn't exist
901    * @param _tokenId ID of the country to fetch
902    * @return country as 32-bit unsigned integer
903    */
904   function getPacked(uint256 _tokenId) public constant returns(uint32) {
905     // validate country existence
906     require(exists(_tokenId));
907 
908     // load country from storage
909     Country memory country = countries[_tokenId];
910 
911     // pack the data and return
912     return uint32(country.plots) << 16 | country.tax;
913   }
914 
915   /**
916    * @notice Retrieves a collection of tokens owned by a particular address
917    * @notice An order of token IDs is not guaranteed and may change
918    *      when a token from the list is transferred
919    * @param owner an address to query a collection for
920    * @return an unordered list of token IDs owned by given address
921    */
922   function getCollection(address owner) public constant returns(uint8[]) {
923     // read a collection from mapping and return
924     return collections[owner];
925   }
926 
927   /**
928    * @dev Allows to fetch collection of tokens, including internal token data
929    *      in a single function, useful when connecting to external node like INFURA
930    * @dev Each element of the array returned is a tightly packed integer, containing
931    *        token ID
932    *        number of plots
933    *        tax nominator
934    *        tax denominator
935    * @param owner an address to query a collection for
936    * @return an unordered list of country packed data owned by give address
937    */
938   function getPackedCollection(address owner) public constant returns(uint40[]) {
939     // get the list of token IDs the owner owns
940     uint8[] memory ids = getCollection(owner);
941 
942     // allocate correspondent array for packed data
943     uint40[] memory packedCollection = new uint40[](ids.length);
944 
945     // fetch token info one by one and pack it into the structure
946     for(uint i = 0; i < ids.length; i++) {
947       // token ID
948       uint8 tokenId = ids[i];
949 
950       // packed token data
951       uint32 packedData = getPacked(tokenId);
952 
953       // pack the data and save it into result array
954       packedCollection[i] = uint40(tokenId) << 32 | packedData;
955     }
956 
957     // return the result (it can be empty array as well)
958     return packedCollection;
959   }
960 
961   /**
962    * @notice Returns number of plots for the given country, defined by `_tokenId`
963    * @param _tokenId country id to query number of plots for
964    * @return number of plots given country has
965    */
966   function getNumberOfPlots(uint256 _tokenId) public constant returns(uint16) {
967     // validate token existence
968     require(exists(_tokenId));
969 
970     // obtain token's number of plots from storage and return
971     return countries[_tokenId].plots;
972   }
973 
974   /**
975    * @notice Returns tax as a proper fraction for the given country, defined by `_tokenId`
976    * @param _tokenId country id to query tax for
977    * @return tax as a proper fraction (tuple containing nominator and denominator)
978    */
979   function getTax(uint256 _tokenId) public constant returns(uint8, uint8) {
980     // obtain token's tax as packed fraction
981     uint16 tax = getTaxPacked(_tokenId);
982 
983     // return tax as a proper fraction
984     return (tax.getNominator(), tax.getDenominator());
985   }
986 
987   /**
988    * @notice Returns tax as a proper fraction for the given country, defined by `_tokenId`
989    * @param _tokenId country id to query tax for
990    * @return tax as a proper fraction packed into uint16
991    */
992   function getTaxPacked(uint256 _tokenId) public constant returns(uint16) {
993     // validate token existence
994     require(exists(_tokenId));
995 
996     // obtain token's tax from storage and return tax
997     return countries[_tokenId].tax;
998   }
999 
1000   /**
1001    * @notice Returns tax percent for the given country, defined by `_tokenId`
1002    * @dev Converts 16-bit fraction structure into 8-bit [0, 100] percent value
1003    * @param _tokenId country id to query tax for
1004    * @return tax percent value, [0, 100]
1005    */
1006   function getTaxPercent(uint256 _tokenId) public constant returns (uint8) {
1007     // validate token existence
1008     require(exists(_tokenId));
1009 
1010     // obtain token's tax percent from storage and return
1011     return countries[_tokenId].tax.toPercent();
1012   }
1013 
1014   /**
1015    * @notice Calculates tax value for the given token and value
1016    * @param _tokenId token id to use tax rate from
1017    * @param _value an amount to apply tax to
1018    * @return calculated tax value based on the tokens tax rate and value
1019    */
1020   function calculateTaxValueFor(uint256 _tokenId, uint256 _value) public constant returns (uint256) {
1021     // validate token existence
1022     require(exists(_tokenId));
1023 
1024     // obtain token's tax percent from storage, multiply by value and return
1025     return countries[_tokenId].tax.multiplyByInteger(_value);
1026   }
1027 
1028   /**
1029    * @notice Allows token owner to update tax rate of the country this token represents
1030    * @dev Requires tax update feature to be enabled on the contract
1031    * @dev Requires message sender to be owner of the token
1032    * @dev Requires previous tax change to be more then `maxTaxChangeFreq` blocks ago
1033    * @param _tokenId country id to update tax for
1034    * @param nominator tax rate nominator
1035    * @param denominator tax rate denominator
1036    */
1037   function updateTaxRate(uint256 _tokenId, uint8 nominator, uint8 denominator) public {
1038     // check if tax updating is enabled
1039     require(__isFeatureEnabled(FEATURE_ALLOW_TAX_UPDATE));
1040 
1041     // check that sender is token owner, ensures also that token exists
1042     require(msg.sender == ownerOf(_tokenId));
1043 
1044     // check that tax rate doesn't exceed MAX_TAX_RATE
1045     require(nominator <= denominator / MAX_TAX_INV);
1046 
1047     // check that enough time has passed since last tax update
1048     require(countries[_tokenId].taxModified + maxTaxChangeFreq <= now);
1049 
1050     // save old tax value to log
1051     uint16 oldTax = countries[_tokenId].tax;
1052 
1053     // update the tax rate
1054     countries[_tokenId].tax = Fractions16.createProperFraction16(nominator, denominator);
1055 
1056     // update tax rate updated timestamp
1057     countries[_tokenId].taxModified = uint32(now);
1058 
1059     // emit an event
1060     emit TaxRateUpdated(msg.sender, _tokenId, countries[_tokenId].tax, oldTax);
1061   }
1062 
1063   /**
1064    * @dev Allows setting the `maxTaxChangeFreq` parameter of the contract,
1065    *      which specifies how frequently the tax rate can be changed
1066    * @dev Requires sender to have `ROLE_TAX_MANAGER` permission.
1067    * @param _maxTaxChangeFreq a value to set `maxTaxChangeFreq` to
1068    */
1069   function updateMaxTaxChangeFreq(uint32 _maxTaxChangeFreq) public {
1070     // check if caller has sufficient permissions to update tax change frequency
1071     require(__isSenderInRole(ROLE_TAX_MANAGER));
1072 
1073     // update the tax change frequency
1074     maxTaxChangeFreq = _maxTaxChangeFreq;
1075   }
1076 
1077 
1078   /**
1079    * @dev Creates new token with `tokenId` ID specified and
1080    *      assigns an ownership `to` for that token
1081    * @dev Initial token's properties are predefined by its ID
1082    * @param to an address to assign created token ownership to
1083    * @param tokenId ID of the token to create
1084    */
1085   function mint(address to, uint8 tokenId) public {
1086     // validate destination address
1087     require(to != address(0));
1088     require(to != address(this));
1089 
1090     // check if caller has sufficient permissions to mint a token
1091     require(__isSenderInRole(ROLE_TOKEN_CREATOR));
1092 
1093     // delegate call to `__mint`
1094     __mint(to, tokenId);
1095 
1096     // fire Minted event
1097     emit Minted(msg.sender, to, tokenId);
1098 
1099     // fire ERC20/ERC721 transfer event
1100     emit Transfer(address(0), to, tokenId, 1);
1101   }
1102 
1103 
1104   /**
1105    * @notice Total number of existing tokens (tracked by this contract)
1106    * @return A count of valid tokens tracked by this contract,
1107    *    where each one of them has an assigned and
1108    *    queryable owner not equal to the zero address
1109    */
1110   function totalSupply() public constant returns (uint256) {
1111     // read the length of the `allTokens` collection
1112     return allTokens.length;
1113   }
1114 
1115   /**
1116    * @notice Enumerate valid tokens
1117    * @dev Throws if `_index` >= `totalSupply()`.
1118    * @param _index a counter less than `totalSupply()`
1119    * @return The token ID for the `_index`th token, unsorted
1120    */
1121   function tokenByIndex(uint256 _index) public constant returns (uint256) {
1122     // out of bounds check
1123     require(_index < allTokens.length);
1124 
1125     // get the token ID and return
1126     return allTokens[_index];
1127   }
1128 
1129   /**
1130    * @notice Enumerate tokens assigned to an owner
1131    * @dev Throws if `_index` >= `balanceOf(_owner)`.
1132    * @param _owner an address of the owner to query token from
1133    * @param _index a counter less than `balanceOf(_owner)`
1134    * @return the token ID for the `_index`th token assigned to `_owner`, unsorted
1135    */
1136   function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint256) {
1137     // out of bounds check
1138     require(_index < collections[_owner].length);
1139 
1140     // get the token ID from owner collection and return
1141     return collections[_owner][_index];
1142   }
1143 
1144   /**
1145    * @notice Gets an amount of token owned by the given address
1146    * @dev Gets the balance of the specified address
1147    * @param _owner address to query the balance for
1148    * @return an amount owned by the address passed as an input parameter
1149    */
1150   function balanceOf(address _owner) public constant returns (uint256) {
1151     // validate an owner address
1152     require(_owner != address(0));
1153 
1154     // read the length of the `who`s collection of tokens
1155     return collections[_owner].length;
1156   }
1157 
1158   /**
1159    * @notice Checks if specified token exists
1160    * @dev Returns whether the specified token ID exists
1161    * @param _tokenId ID of the token to query the existence for
1162    * @return whether the token exists (true - exists)
1163    */
1164   function exists(uint256 _tokenId) public constant returns (bool) {
1165     // check if this token exists (owner is not zero)
1166     return countries[_tokenId].owner != address(0);
1167   }
1168 
1169   /**
1170    * @notice Finds an owner address for a token specified
1171    * @dev Gets the owner of the specified token from the `countries` mapping
1172    * @dev Throws if a token with the ID specified doesn't exist
1173    * @param _tokenId ID of the token to query the owner for
1174    * @return owner address currently marked as the owner of the given token
1175    */
1176   function ownerOf(uint256 _tokenId) public constant returns (address) {
1177     // check if this token exists
1178     require(exists(_tokenId));
1179 
1180     // return owner's address
1181     return countries[_tokenId].owner;
1182   }
1183 
1184   /**
1185    * @notice Transfers ownership rights of a token defined
1186    *      by the `tokenId` to a new owner specified by address `to`
1187    * @dev Requires the sender of the transaction to be an owner
1188    *      of the token specified (`tokenId`)
1189    * @param to new owner address
1190    * @param _tokenId ID of the token to transfer ownership rights for
1191    */
1192   function transfer(address to, uint256 _tokenId) public {
1193     // check if token transfers feature is enabled
1194     require(__isFeatureEnabled(FEATURE_TRANSFERS));
1195 
1196     // call sender gracefully - `from`
1197     address from = msg.sender;
1198 
1199     // delegate call to unsafe `__transfer`
1200     __transfer(from, to, _tokenId);
1201   }
1202 
1203   /**
1204    * @notice A.k.a "transfer a token on behalf"
1205    * @notice Transfers ownership rights of a token defined
1206    *      by the `tokenId` to a new owner specified by address `to`
1207    * @notice Allows transferring ownership rights by a trading operator
1208    *      on behalf of token owner. Allows building an exchange of tokens.
1209    * @dev Transfers the ownership of a given token ID to another address
1210    * @dev Requires the transaction sender to be one of:
1211    *      owner of a token - then its just a usual `transfer`
1212    *      approved – an address explicitly approved earlier by
1213    *        the owner of a token to transfer this particular token `tokenId`
1214    *      operator - an address explicitly approved earlier by
1215    *        the owner to transfer all his tokens on behalf
1216    * @param _from current owner of the token
1217    * @param _to address to receive the ownership of the token
1218    * @param _tokenId ID of the token to be transferred
1219    */
1220   function transferFrom(address _from, address _to, uint256 _tokenId) public {
1221     // if `_from` is equal to sender, require transfers feature to be enabled
1222     // otherwise require transfers on behalf feature to be enabled
1223     require(_from == msg.sender && __isFeatureEnabled(FEATURE_TRANSFERS)
1224       || _from != msg.sender && __isFeatureEnabled(FEATURE_TRANSFERS_ON_BEHALF));
1225 
1226     // call sender gracefully - `operator`
1227     address operator = msg.sender;
1228 
1229     // find if an approved address exists for this token
1230     address approved = approvals[_tokenId];
1231 
1232     // we assume `from` is an owner of the token,
1233     // this will be explicitly checked in `__transfer`
1234 
1235     // fetch how much approvals left for an operator
1236     bool approvedOperator = approvedOperators[_from][operator];
1237 
1238     // operator must have an approval to transfer this particular token
1239     // or operator must be approved to transfer all the tokens
1240     // or, if nothing satisfies, this is equal to regular transfer,
1241     // where `from` is basically a transaction sender and owner of the token
1242     if(operator != approved && !approvedOperator) {
1243       // transaction sender doesn't have any special permissions
1244       // we will treat him as a token owner and sender and try to perform
1245       // a regular transfer:
1246       // check `from` to be `operator` (transaction sender):
1247       require(_from == operator);
1248     }
1249 
1250     // delegate call to unsafe `__transfer`
1251     __transfer(_from, _to, _tokenId);
1252   }
1253 
1254   /**
1255    * @notice A.k.a "safe transfer a token on behalf"
1256    * @notice Transfers ownership rights of a token defined
1257    *      by the `tokenId` to a new owner specified by address `to`
1258    * @notice Allows transferring ownership rights by a trading operator
1259    *      on behalf of token owner. Allows building an exchange of tokens.
1260    * @dev Safely transfers the ownership of a given token ID to another address
1261    * @dev Requires the transaction sender to be the owner, approved, or operator
1262    * @dev When transfer is complete, this function
1263    *      checks if `_to` is a smart contract (code size > 0). If so, it calls
1264    *      `onERC721Received` on `_to` and throws if the return value is not
1265    *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
1266    * @param _from current owner of the token
1267    * @param _to address to receive the ownership of the token
1268    * @param _tokenId ID of the token to be transferred
1269    * @param _data Additional data with no specified format, sent in call to `_to`
1270    */
1271   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public {
1272     // delegate call to usual (unsafe) `transferFrom`
1273     transferFrom(_from, _to, _tokenId);
1274 
1275     // check if receiver `_to` supports ERC721 interface
1276     if (AddressUtils.isContract(_to)) {
1277       // if `_to` is a contract – execute onERC721Received
1278       bytes4 response = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
1279 
1280       // expected response is ERC721_RECEIVED
1281       require(response == ERC721_RECEIVED);
1282     }
1283   }
1284 
1285   /**
1286    * @notice A.k.a "safe transfer a token on behalf"
1287    * @notice Transfers ownership rights of a token defined
1288    *      by the `tokenId` to a new owner specified by address `to`
1289    * @notice Allows transferring ownership rights by a trading operator
1290    *      on behalf of token owner. Allows building an exchange of tokens.
1291    * @dev Safely transfers the ownership of a given token ID to another address
1292    * @dev Requires the transaction sender to be the owner, approved, or operator
1293    * @dev Requires from to be an owner of the token
1294    * @dev If the target address is a contract, it must implement `onERC721Received`,
1295    *      which is called upon a safe transfer, and return the magic value
1296    *      `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`;
1297    *      otherwise the transfer is reverted.
1298    * @dev This works identically to the other function with an extra data parameter,
1299    *      except this function just sets data to "".
1300    * @param _from current owner of the token
1301    * @param _to address to receive the ownership of the token
1302    * @param _tokenId ID of the token to be transferred
1303    */
1304   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
1305     // delegate call to overloaded `safeTransferFrom`, set data to ""
1306     safeTransferFrom(_from, _to, _tokenId, "");
1307   }
1308 
1309   /**
1310    * @notice Approves an address to transfer the given token on behalf of its owner
1311    *      Can also be used to revoke an approval by setting `to` address to zero
1312    * @dev The zero `to` address revokes an approval for a given token
1313    * @dev There can only be one approved address per token at a given time
1314    * @dev This function can only be called by the token owner
1315    * @param _approved address to be approved to transfer the token on behalf of its owner
1316    * @param _tokenId ID of the token to be approved for transfer on behalf
1317    */
1318   function approve(address _approved, uint256 _tokenId) public {
1319     // call sender nicely - `from`
1320     address from = msg.sender;
1321 
1322     // get token owner address (also ensures that token exists)
1323     address owner = ownerOf(_tokenId);
1324 
1325     // caller must own this token
1326     require(from == owner);
1327     // approval for owner himself is pointless, do not allow
1328     require(_approved != owner);
1329     // either we're removing approval, or setting it
1330     require(approvals[_tokenId] != address(0) || _approved != address(0));
1331 
1332     // set an approval (deletes an approval if to == 0)
1333     approvals[_tokenId] = _approved;
1334 
1335     // emit an ERC721 event
1336     emit Approval(from, _approved, _tokenId);
1337   }
1338 
1339   /**
1340    * @notice Removes an approved address, which was previously added by `approve`
1341    *      for the given token. Equivalent to calling approve(0, tokenId)
1342    * @dev Same as calling approve(0, tokenId)
1343    * @param _tokenId ID of the token to remove approved address for
1344    */
1345   function revokeApproval(uint256 _tokenId) public {
1346     // delegate call to `approve`
1347     approve(address(0), _tokenId);
1348   }
1349 
1350   /**
1351    * @dev Sets or unsets the approval of a given operator
1352    * @dev An operator is allowed to transfer *all* tokens of the sender on their behalf
1353    * @param to operator address to set the approval for
1354    * @param approved representing the status of the approval to be set
1355    */
1356   function setApprovalForAll(address to, bool approved) public {
1357     // call sender nicely - `from`
1358     address from = msg.sender;
1359 
1360     // validate destination address
1361     require(to != address(0));
1362 
1363     // approval for owner himself is pointless, do not allow
1364     require(to != from);
1365 
1366     // set an approval
1367     approvedOperators[from][to] = approved;
1368 
1369     // emit an ERC721 compliant event
1370     emit ApprovalForAll(from, to, approved);
1371   }
1372 
1373   /**
1374    * @notice Get the approved address for a single token
1375    * @dev Throws if `_tokenId` is not a valid token ID.
1376    * @param _tokenId ID of the token to find the approved address for
1377    * @return the approved address for this token, or the zero address if there is none
1378    */
1379   function getApproved(uint256 _tokenId) public constant returns (address) {
1380     // validate token existence
1381     require(exists(_tokenId));
1382 
1383     // find approved address and return
1384     return approvals[_tokenId];
1385   }
1386 
1387   /**
1388    * @notice Query if an address is an authorized operator for another address
1389    * @param _owner the address that owns at least one token
1390    * @param _operator the address that acts on behalf of the owner
1391    * @return true if `_operator` is an approved operator for `_owner`, false otherwise
1392    */
1393   function isApprovedForAll(address _owner, address _operator) public constant returns (bool) {
1394     // is there a positive amount of approvals left
1395     return approvedOperators[_owner][_operator];
1396   }
1397 
1398   /**
1399    * @notice A distinct Uniform Resource Identifier (URI) for a given asset.
1400    * @dev Throws if `_tokenId` is not a valid token ID.
1401    *      URIs are defined in RFC 3986.
1402    * @param _tokenId uint256 ID of the token to query
1403    * @return token URI
1404    */
1405   function tokenURI(uint256 _tokenId) public constant returns (string) {
1406     // validate token existence
1407     require(exists(_tokenId));
1408 
1409     // token URL consists of base URL part (domain) and token ID
1410     return StringUtils.concat("http://cryptominerworld.com/country/", StringUtils.itoa(_tokenId, 10));
1411   }
1412 
1413   /// @dev Performs a transfer of a token `tokenId` from address `from` to address `to`
1414   /// @dev Unsafe: doesn't check if caller has enough permissions to execute the call;
1415   ///      checks only for token existence and that ownership belongs to `from`
1416   /// @dev Is save to call from `transfer(to, tokenId)` since it doesn't need any additional checks
1417   /// @dev Must be kept private at all times
1418   function __transfer(address from, address to, uint256 _tokenId) private {
1419     // validate source and destination address
1420     require(to != address(0));
1421     require(to != from);
1422     // impossible by design of transfer(), transferFrom(),
1423     // approveToken() and approve()
1424     assert(from != address(0));
1425 
1426     // validate token existence
1427     require(exists(_tokenId));
1428 
1429     // validate token ownership
1430     require(ownerOf(_tokenId) == from);
1431 
1432     // clear approved address for this particular token + emit event
1433     __clearApprovalFor(_tokenId);
1434 
1435     // move token ownership,
1436     // update old and new owner's token collections accordingly
1437     __move(from, to, _tokenId);
1438 
1439     // fire ERC20/ERC721 transfer event
1440     emit Transfer(from, to, _tokenId, 1);
1441   }
1442 
1443   /// @dev Clears approved address for a particular token
1444   function __clearApprovalFor(uint256 _tokenId) private {
1445     // check if approval exists - we don't want to fire an event in vain
1446     if(approvals[_tokenId] != address(0)) {
1447       // clear approval
1448       delete approvals[_tokenId];
1449 
1450       // emit an ERC721 event
1451       emit Approval(msg.sender, address(0), _tokenId);
1452     }
1453   }
1454 
1455   /// @dev Move `country` from owner `from` to a new owner `to`
1456   /// @dev Unsafe, doesn't check for consistence
1457   /// @dev Must be kept private at all times
1458   function __move(address from, address to, uint256 _tokenId) private {
1459     // cast token ID to uint32 space
1460     uint8 tokenId = uint8(_tokenId);
1461 
1462     // overflow check, failure impossible by design of mint()
1463     assert(tokenId == _tokenId);
1464 
1465     // get the country pointer to the storage
1466     Country storage country = countries[_tokenId];
1467 
1468     // get a reference to the collection where country is now
1469     uint8[] storage source = collections[from];
1470 
1471     // get a reference to the collection where country goes to
1472     uint8[] storage destination = collections[to];
1473 
1474     // collection `source` cannot be empty, if it is - it's a bug
1475     assert(source.length != 0);
1476 
1477     // index of the country within collection `source`
1478     uint8 i = country.index;
1479 
1480     // we put the last country in the collection `source` to the position released
1481     // get an ID of the last country in `source`
1482     uint8 sourceId = source[source.length - 1];
1483 
1484     // update country index to point to proper place in the collection `source`
1485     countries[sourceId].index = i;
1486 
1487     // put it into the position i within `source`
1488     source[i] = sourceId;
1489 
1490     // trim the collection `source` by removing last element
1491     source.length--;
1492 
1493     // update country index according to position in new collection `destination`
1494     country.index = uint8(destination.length);
1495 
1496     // update country owner
1497     country.owner = to;
1498 
1499     // push country into collection
1500     destination.push(tokenId);
1501   }
1502 
1503   /// @dev Creates new token with `tokenId` ID specified and
1504   ///      assigns an ownership `to` for this token
1505   /// @dev Unsafe: doesn't check if caller has enough permissions to execute the call
1506   ///      checks only that the token doesn't exist yet
1507   /// @dev Must be kept private at all times
1508   function __mint(address to, uint8 tokenId) private {
1509     // check that `tokenId` is inside valid bounds
1510     require(tokenId > 0 && tokenId <= countryData.length);
1511 
1512     // ensure that token with such ID doesn't exist
1513     require(!exists(tokenId));
1514 
1515     // create new country in memory
1516     Country memory country = Country({
1517       id: tokenId,
1518       plots: countryData[tokenId - 1],
1519       tax: DEFAULT_TAX_RATE,
1520       taxModified: 0,
1521       index: uint8(collections[to].length),
1522       owner: to
1523     });
1524 
1525     // push newly created `tokenId` to the owner's collection of tokens
1526     collections[to].push(tokenId);
1527 
1528     // persist country to the storage
1529     countries[tokenId] = country;
1530 
1531     // add token ID to the `allTokens` collection,
1532     // automatically updates total supply
1533     allTokens.push(tokenId);
1534 
1535     // update token bitmap
1536     tokenMap |= uint192(1 << uint256(tokenId - 1));
1537   }
1538 
1539 }