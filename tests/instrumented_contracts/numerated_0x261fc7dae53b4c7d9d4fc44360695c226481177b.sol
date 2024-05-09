1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev String operations.
27  */
28 library Strings {
29     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
33      */
34     function toString(uint256 value) internal pure returns (string memory) {
35         // Inspired by OraclizeAPI's implementation - MIT licence
36         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
58      */
59     function toHexString(uint256 value) internal pure returns (string memory) {
60         if (value == 0) {
61             return "0x00";
62         }
63         uint256 temp = value;
64         uint256 length = 0;
65         while (temp != 0) {
66             length++;
67             temp >>= 8;
68         }
69         return toHexString(value, length);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
74      */
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 }
87 
88 /**
89  * @dev Interface of the ERC165 standard, as defined in the
90  * https://eips.ethereum.org/EIPS/eip-165[EIP].
91  *
92  * Implementers can declare support of contract interfaces, which can then be
93  * queried by others ({ERC165Checker}).
94  *
95  * For an implementation, see {ERC165}.
96  */
97 interface IERC165 {
98     /**
99      * @dev Returns true if this contract implements the interface defined by
100      * `interfaceId`. See the corresponding
101      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
102      * to learn more about how these ids are created.
103      *
104      * This function call must use less than 30 000 gas.
105      */
106     function supportsInterface(bytes4 interfaceId) external view returns (bool);
107 }
108 
109 
110 /**
111  * @dev Implementation of the {IERC165} interface.
112  *
113  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
114  * for the additional interface id that will be supported. For example:
115  *
116  * ```solidity
117  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
118  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
119  * }
120  * ```
121  *
122  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
123  */
124 abstract contract ERC165 is IERC165 {
125     /**
126      * @dev See {IERC165-supportsInterface}.
127      */
128     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
129         return interfaceId == type(IERC165).interfaceId;
130     }
131 }
132 
133 
134 /**
135  * @dev External interface of AccessControl declared to support ERC165 detection.
136  */
137 interface IAccessControl {
138     function hasRole(bytes32 role, address account) external view returns (bool);
139 
140     function getRoleAdmin(bytes32 role) external view returns (bytes32);
141 
142     function grantRole(bytes32 role, address account) external;
143 
144     function revokeRole(bytes32 role, address account) external;
145 
146     function renounceRole(bytes32 role, address account) external;
147 }
148 
149 /**
150  * @dev Contract module that allows children to implement role-based access
151  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
152  * members except through off-chain means by accessing the contract event logs. Some
153  * applications may benefit from on-chain enumerability, for those cases see
154  * {AccessControlEnumerable}.
155  *
156  * Roles are referred to by their `bytes32` identifier. These should be exposed
157  * in the external API and be unique. The best way to achieve this is by
158  * using `public constant` hash digests:
159  *
160  * ```
161  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
162  * ```
163  *
164  * Roles can be used to represent a set of permissions. To restrict access to a
165  * function call, use {hasRole}:
166  *
167  * ```
168  * function foo() public {
169  *     require(hasRole(MY_ROLE, msg.sender));
170  *     ...
171  * }
172  * ```
173  *
174  * Roles can be granted and revoked dynamically via the {grantRole} and
175  * {revokeRole} functions. Each role has an associated admin role, and only
176  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
177  *
178  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
179  * that only accounts with this role will be able to grant or revoke other
180  * roles. More complex role relationships can be created by using
181  * {_setRoleAdmin}.
182  *
183  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
184  * grant and revoke this role. Extra precautions should be taken to secure
185  * accounts that have been granted it.
186  */
187 abstract contract AccessControl is Context, IAccessControl, ERC165 {
188     struct RoleData {
189         mapping(address => bool) members;
190         bytes32 adminRole;
191     }
192 
193     mapping(bytes32 => RoleData) private _roles;
194 
195     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
196 
197     /**
198      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
199      *
200      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
201      * {RoleAdminChanged} not being emitted signaling this.
202      *
203      * _Available since v3.1._
204      */
205     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
206 
207     /**
208      * @dev Emitted when `account` is granted `role`.
209      *
210      * `sender` is the account that originated the contract call, an admin role
211      * bearer except when using {_setupRole}.
212      */
213     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
214 
215     /**
216      * @dev Emitted when `account` is revoked `role`.
217      *
218      * `sender` is the account that originated the contract call:
219      *   - if using `revokeRole`, it is the admin role bearer
220      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
221      */
222     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
223 
224     /**
225      * @dev Modifier that checks that an account has a specific role. Reverts
226      * with a standardized message including the required role.
227      *
228      * The format of the revert reason is given by the following regular expression:
229      *
230      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
231      *
232      * _Available since v4.1._
233      */
234     modifier onlyRole(bytes32 role) {
235         _checkRole(role, _msgSender());
236         _;
237     }
238 
239     /**
240      * @dev See {IERC165-supportsInterface}.
241      */
242     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
243         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
244     }
245 
246     /**
247      * @dev Returns `true` if `account` has been granted `role`.
248      */
249     function hasRole(bytes32 role, address account) public view override returns (bool) {
250         return _roles[role].members[account];
251     }
252 
253     /**
254      * @dev Revert with a standard message if `account` is missing `role`.
255      *
256      * The format of the revert reason is given by the following regular expression:
257      *
258      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
259      */
260     function _checkRole(bytes32 role, address account) internal view {
261         if (!hasRole(role, account)) {
262             revert(
263                 string(
264                     abi.encodePacked(
265                         "AccessControl: account ",
266                         Strings.toHexString(uint160(account), 20),
267                         " is missing role ",
268                         Strings.toHexString(uint256(role), 32)
269                     )
270                 )
271             );
272         }
273     }
274 
275     /**
276      * @dev Returns the admin role that controls `role`. See {grantRole} and
277      * {revokeRole}.
278      *
279      * To change a role's admin, use {_setRoleAdmin}.
280      */
281     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
282         return _roles[role].adminRole;
283     }
284 
285     /**
286      * @dev Grants `role` to `account`.
287      *
288      * If `account` had not been already granted `role`, emits a {RoleGranted}
289      * event.
290      *
291      * Requirements:
292      *
293      * - the caller must have ``role``'s admin role.
294      */
295     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
296         _grantRole(role, account);
297     }
298 
299     /**
300      * @dev Revokes `role` from `account`.
301      *
302      * If `account` had been granted `role`, emits a {RoleRevoked} event.
303      *
304      * Requirements:
305      *
306      * - the caller must have ``role``'s admin role.
307      */
308     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
309         _revokeRole(role, account);
310     }
311 
312     /**
313      * @dev Revokes `role` from the calling account.
314      *
315      * Roles are often managed via {grantRole} and {revokeRole}: this function's
316      * purpose is to provide a mechanism for accounts to lose their privileges
317      * if they are compromised (such as when a trusted device is misplaced).
318      *
319      * If the calling account had been granted `role`, emits a {RoleRevoked}
320      * event.
321      *
322      * Requirements:
323      *
324      * - the caller must be `account`.
325      */
326     function renounceRole(bytes32 role, address account) public virtual override {
327         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
328 
329         _revokeRole(role, account);
330     }
331 
332     /**
333      * @dev Grants `role` to `account`.
334      *
335      * If `account` had not been already granted `role`, emits a {RoleGranted}
336      * event. Note that unlike {grantRole}, this function doesn't perform any
337      * checks on the calling account.
338      *
339      * [WARNING]
340      * ====
341      * This function should only be called from the constructor when setting
342      * up the initial roles for the system.
343      *
344      * Using this function in any other way is effectively circumventing the admin
345      * system imposed by {AccessControl}.
346      * ====
347      */
348     function _setupRole(bytes32 role, address account) internal virtual {
349         _grantRole(role, account);
350     }
351 
352     /**
353      * @dev Sets `adminRole` as ``role``'s admin role.
354      *
355      * Emits a {RoleAdminChanged} event.
356      */
357     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
358         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
359         _roles[role].adminRole = adminRole;
360     }
361 
362     function _grantRole(bytes32 role, address account) private {
363         if (!hasRole(role, account)) {
364             _roles[role].members[account] = true;
365             emit RoleGranted(role, account, _msgSender());
366         }
367     }
368 
369     function _revokeRole(bytes32 role, address account) private {
370         if (hasRole(role, account)) {
371             _roles[role].members[account] = false;
372             emit RoleRevoked(role, account, _msgSender());
373         }
374     }
375 }
376 
377 interface CrazyBunnyIF {
378     function mintNextToken(address _mintTo) external returns (bool);
379     function mint(address _mintTo, uint256 _tokenId) external returns (bool);
380     function getCurrentTokenId() external view returns (uint256);
381     function totalSupply() external view returns (uint256);
382     function cap() external view returns (uint256);
383 }
384  
385  
386 contract CrazyBunnyDistributor is AccessControl {
387     
388     CrazyBunnyIF cbToken;
389 
390     uint256 public tokenPrice = uint256(6 * 10**16); // = 0.06 ETH
391     address public withdrawWallet;
392 
393     bytes32 public constant TOGGLE_MINTING_ROLE = keccak256("TOGGLE_MINTING_ROLE");
394     bool public _mintingPaused = false;
395 
396     address public upgradedToAddress = address(0);
397 
398     mapping(address => bool) public whiteList;
399     bool public whitelistOnly = true;
400 
401     mapping(address => uint256) public totalMintsPerAddress;
402 
403     
404 
405     constructor(CrazyBunnyIF _cbToken) {
406         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
407         _setupRole(TOGGLE_MINTING_ROLE, msg.sender);
408 
409         withdrawWallet = msg.sender;
410 
411         cbToken = _cbToken;
412     }
413 
414     function upgrade(address _upgradedToAddress) public {
415         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
416         
417         upgradedToAddress = _upgradedToAddress;
418     }
419 
420     function mint(uint256 _num) public payable returns (bool) {
421         require(address(0) == upgradedToAddress, "Contract has been upgraded to a new address");
422         require(whiteList[msg.sender] || !whitelistOnly, "ONLY WHITELIST"); //either on whitelist or whitelist is false
423 
424         require(whitelistOnly || (!whitelistOnly && _num <= 20), "You can mint a maximum of 20 at once");//whitelist is false, and you can max mint 20 at a time
425         require(!whitelistOnly || (whitelistOnly && totalMintsPerAddress[msg.sender] + _num <= 10), "You can mint a maximum of 10 when whitelist enabled");//whitelist is true, and you can max mint 20 per address
426         
427         require(msg.value >= (tokenPrice * _num), "Insufficient amount provided");
428         require(!_mintingPaused, "Minting paused");
429 
430         uint256 tokenId = cbToken.getCurrentTokenId();
431         require(tokenId + _num < 10000, "Maximum cap of 10k mints reached");
432 
433         totalMintsPerAddress[msg.sender] += _num; //log the total mints per address
434 
435         for(uint256 i; i < _num; i++){
436             cbToken.mintNextToken(msg.sender);//, tokenId + i + 1
437         }
438         return true;
439     }
440 
441 
442     function giveAway(address _to, uint256 _amount) external {
443         require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Caller is not a admin");
444 
445         uint256 supply = cbToken.totalSupply();
446 
447         require( supply + _amount <= cbToken.cap(), "Cap reached, maximum 10000 mints possible");
448 
449         for(uint256 i; i < _amount; i++){
450             cbToken.mintNextToken(_to);
451         }
452     }
453 
454     fallback() external payable {}
455     receive() external payable {}
456 
457 
458     // admin functions
459     function withdrawAll() public {
460         uint256 _each = address(this).balance;
461         require(payable(withdrawWallet).send(_each));
462     }
463 
464     function updateWithdrawWallet(address _newWallet) public {
465         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");
466 
467         withdrawWallet = _newWallet;
468     }
469 
470     function togglePause(bool _pause) public {
471         require(hasRole(TOGGLE_MINTING_ROLE, msg.sender), "Caller is not TOGGLE_MINTING_ROLE");
472         require(_mintingPaused != _pause, "Already in desired pause state");
473 
474         _mintingPaused = _pause;
475     }
476 
477     function updatePrice(uint256 _newPrice) public {
478         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");
479 
480         tokenPrice = _newPrice;
481     }
482 
483     //whitelist
484     function addToWhiteList(address[] calldata entries) external {
485         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");
486 
487         for(uint256 i = 0; i < entries.length; i++) {
488             address entry = entries[i];
489             require(entry != address(0), "Cannot add zero address");
490             require(!whiteList[entry], "Cannot add duplicate address");
491 
492             whiteList[entry] = true;
493         }   
494     }
495 
496     function removeFromWhiteList(address[] calldata entries) external {
497         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");
498 
499         for(uint256 i = 0; i < entries.length; i++) {
500             address entry = entries[i];
501             require(entry != address(0), "Cannot remove zero address");
502             
503             whiteList[entry] = false;
504         }
505     }
506 
507     function toggleWhiteListOnly(bool _whitelistOnly) external {
508         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not admin");
509 
510         whitelistOnly = _whitelistOnly;
511     }
512     
513     function isOnWhiteList(address addr) external view returns (bool) {
514         return whiteList[addr];
515     }
516 
517 
518 
519     
520 
521 }