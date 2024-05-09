1 pragma solidity 0.4.23;
2 
3 /**
4  * @title Access Control List (Lightweight version)
5  *
6  * @dev Access control smart contract provides an API to check
7  *      if specific operation is permitted globally and
8  *      if particular user has a permission to execute it.
9  * @dev This smart contract is designed to be inherited by other
10  *      smart contracts which require access control management capabilities.
11  *
12  * @author Basil Gorin
13  */
14 contract AccessControlLight {
15   /// @notice Role manager is responsible for assigning the roles
16   /// @dev Role ROLE_ROLE_MANAGER allows modifying operator roles
17   uint256 private constant ROLE_ROLE_MANAGER = 0x10000000;
18 
19   /// @notice Feature manager is responsible for enabling/disabling
20   ///      global features of the smart contract
21   /// @dev Role ROLE_FEATURE_MANAGER allows modifying global features
22   uint256 private constant ROLE_FEATURE_MANAGER = 0x20000000;
23 
24   /// @dev Bitmask representing all the possible permissions (super admin role)
25   uint256 private constant FULL_PRIVILEGES_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
26 
27   /// @dev A bitmask of globally enabled features
28   uint256 public features;
29 
30   /// @notice Privileged addresses with defined roles/permissions
31   /// @notice In the context of ERC20/ERC721 tokens these can be permissions to
32   ///      allow minting tokens, transferring on behalf and so on
33   /// @dev Maps an address to the permissions bitmask (role), where each bit
34   ///      represents a permission
35   /// @dev Bitmask 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
36   ///      represents all possible permissions
37   mapping(address => uint256) public userRoles;
38 
39   /// @dev Fired in updateFeatures()
40   event FeaturesUpdated(address indexed _by, uint256 _requested, uint256 _actual);
41 
42   /// @dev Fired in updateRole()
43   event RoleUpdated(address indexed _by, address indexed _to, uint256 _requested, uint256 _actual);
44 
45   /**
46    * @dev Creates an access control instance,
47    *      setting contract creator to have full privileges
48    */
49   constructor() public {
50     // contract creator has full privileges
51     userRoles[msg.sender] = FULL_PRIVILEGES_MASK;
52   }
53 
54   /**
55    * @dev Updates set of the globally enabled features (`features`),
56    *      taking into account sender's permissions.=
57    * @dev Requires transaction sender to have `ROLE_FEATURE_MANAGER` permission.
58    * @param mask bitmask representing a set of features to enable/disable
59    */
60   function updateFeatures(uint256 mask) public {
61     // caller must have a permission to update global features
62     require(isSenderInRole(ROLE_FEATURE_MANAGER));
63 
64     // evaluate new features set and assign them
65     features = evaluateBy(msg.sender, features, mask);
66 
67     // fire an event
68     emit FeaturesUpdated(msg.sender, mask, features);
69   }
70 
71   /**
72    * @dev Updates set of permissions (role) for a given operator,
73    *      taking into account sender's permissions.
74    * @dev Setting role to zero is equivalent to removing an operator.
75    * @dev Setting role to `FULL_PRIVILEGES_MASK` is equivalent to
76    *      copying senders permissions (role) to an operator.
77    * @dev Requires transaction sender to have `ROLE_ROLE_MANAGER` permission.
78    * @param operator address of an operator to alter permissions for
79    * @param role bitmask representing a set of permissions to
80    *      enable/disable for an operator specified
81    */
82   function updateRole(address operator, uint256 role) public {
83     // caller must have a permission to update user roles
84     require(isSenderInRole(ROLE_ROLE_MANAGER));
85 
86     // evaluate the role and reassign it
87     userRoles[operator] = evaluateBy(msg.sender, userRoles[operator], role);
88 
89     // fire an event
90     emit RoleUpdated(msg.sender, operator, role, userRoles[operator]);
91   }
92 
93   /**
94    * @dev Based on the actual role provided (set of permissions), operator address,
95    *      and role required (set of permissions), calculate the resulting
96    *      set of permissions (role).
97    * @dev If operator is super admin and has full permissions (FULL_PRIVILEGES_MASK),
98    *      the function will always return `required` regardless of the `actual`.
99    * @dev In contrast, if operator has no permissions at all (zero mask),
100    *      the function will always return `actual` regardless of the `required`.
101    * @param operator address of the contract operator to use permissions of
102    * @param actual input set of permissions to modify
103    * @param required desired set of permissions operator would like to have
104    * @return resulting set of permissions this operator can set
105    */
106   function evaluateBy(address operator, uint256 actual, uint256 required) public constant returns(uint256) {
107     // read operator's permissions
108     uint256 p = userRoles[operator];
109 
110     // taking into account operator's permissions,
111     // 1) enable permissions requested on the `current`
112     actual |= p & required;
113     // 2) disable permissions requested on the `current`
114     actual &= FULL_PRIVILEGES_MASK ^ (p & (FULL_PRIVILEGES_MASK ^ required));
115 
116     // return calculated result (actual is not modified)
117     return actual;
118   }
119 
120   /**
121    * @dev Checks if requested set of features is enabled globally on the contract
122    * @param required set of features to check
123    * @return true if all the features requested are enabled, false otherwise
124    */
125   function isFeatureEnabled(uint256 required) public constant returns(bool) {
126     // delegate call to `__hasRole`, passing `features` property
127     return __hasRole(features, required);
128   }
129 
130   /**
131    * @dev Checks if transaction sender `msg.sender` has all the permissions (role) required
132    * @param required set of permissions (role) to check
133    * @return true if all the permissions requested are enabled, false otherwise
134    */
135   function isSenderInRole(uint256 required) public constant returns(bool) {
136     // delegate call to `isOperatorInRole`, passing transaction sender
137     return isOperatorInRole(msg.sender, required);
138   }
139 
140   /**
141    * @dev Checks if operator `operator` has all the permissions (role) required
142    * @param required set of permissions (role) to check
143    * @return true if all the permissions requested are enabled, false otherwise
144    */
145   function isOperatorInRole(address operator, uint256 required) public constant returns(bool) {
146     // delegate call to `__hasRole`, passing operator's permissions (role)
147     return __hasRole(userRoles[operator], required);
148   }
149 
150   /// @dev Checks if role `actual` contains all the permissions required `required`
151   function __hasRole(uint256 actual, uint256 required) internal pure returns(bool) {
152     // check the bitmask for the role required and return the result
153     return actual & required == required;
154   }
155 }
156 
157 /**
158  * @title Address Utils
159  *
160  * @dev Utility library of inline functions on addresses
161  */
162 library AddressUtils {
163 
164   /**
165    * @notice Checks if the target address is a contract
166    * @dev This function will return false if invoked during the constructor of a contract,
167    *      as the code is not actually created until after the constructor finishes.
168    * @param addr address to check
169    * @return whether the target address is a contract
170    */
171   function isContract(address addr) internal view returns (bool) {
172     // a variable to load `extcodesize` to
173     uint256 size = 0;
174 
175     // XXX Currently there is no better way to check if there is a contract in an address
176     // than to check the size of the code at that address.
177     // See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.
178     // TODO: Check this again before the Serenity release, because all addresses will be contracts.
179     // solium-disable-next-line security/no-inline-assembly
180     assembly {
181       // retrieve the size of the code at address `addr`
182       size := extcodesize(addr)
183     }
184 
185     // positive size indicates a smart contract address
186     return size > 0;
187   }
188 
189 }
190 
191 /**
192  * @title ERC20 token receiver interface
193  *
194  * @dev Interface for any contract that wants to support safe transfers
195  *      from ERC20 token smart contracts.
196  * @dev Inspired by ERC721 and ERC223 token standards
197  *
198  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
199  * @dev See https://github.com/ethereum/EIPs/issues/223
200  *
201  * @author Basil Gorin
202  */
203 interface ERC20Receiver {
204   /**
205    * @notice Handle the receipt of a ERC20 token(s)
206    * @dev The ERC20 smart contract calls this function on the recipient
207    *      after a successful transfer (`safeTransferFrom`).
208    *      This function MAY throw to revert and reject the transfer.
209    *      Return of other than the magic value MUST result in the transaction being reverted.
210    * @notice The contract address is always the message sender.
211    *      A wallet/broker/auction application MUST implement the wallet interface
212    *      if it will accept safe transfers.
213    * @param _operator The address which called `safeTransferFrom` function
214    * @param _from The address which previously owned the token
215    * @param _value amount of tokens which is being transferred
216    * @param _data additional data with no specified format
217    * @return `bytes4(keccak256("onERC20Received(address,address,uint256,bytes)"))` unless throwing
218    */
219   function onERC20Received(address _operator, address _from, uint256 _value, bytes _data) external returns(bytes4);
220 }
221 
222 /**
223  * @title Gold Smart Contract
224  *
225  * @notice Gold is a transferable fungible entity (ERC20 token)
226  *      used to "pay" for in game services like gem upgrades, etc.
227  * @notice Gold is a part of Gold/Silver system, which allows to
228  *      upgrade gems (level, grade, etc.)
229  *
230  * @dev Gold is mintable and burnable entity,
231  *      meaning it can be created or destroyed by the authorized addresses
232  * @dev An address authorized can mint/burn its own tokens (own balance) as well
233  *      as tokens owned by another address (additional permission level required)
234  *
235  * @author Basil Gorin
236  */
237 contract GoldERC20 is AccessControlLight {
238   /**
239    * @dev Smart contract version
240    * @dev Should be incremented manually in this source code
241    *      each time smart contact source code is changed and deployed
242    * @dev To distinguish from other tokens must be multiple of 0x100
243    */
244   uint32 public constant TOKEN_VERSION = 0x300;
245 
246   /**
247    * @notice ERC20 symbol of that token (short name)
248    */
249   string public constant symbol = "GLD";
250 
251   /**
252    * @notice ERC20 name of the token (long name)
253    */
254   string public constant name = "GOLD - CryptoMiner World";
255 
256   /**
257    * @notice ERC20 decimals (number of digits to draw after the dot
258    *    in the UI applications (like MetaMask, other wallets and so on)
259    */
260   uint8 public constant decimals = 3;
261 
262   /**
263    * @notice Based on the value of decimals above, one token unit
264    *      represents native number of tokens which is displayed
265    *      in the UI applications as one (1 or 1.0, 1.00, etc.)
266    */
267   uint256 public constant ONE_UNIT = uint256(10) ** decimals;
268 
269   /**
270    * @notice A record of all the players token balances
271    * @dev This mapping keeps record of all token owners
272    */
273   mapping(address => uint256) private tokenBalances;
274 
275   /**
276    * @notice Total amount of tokens tracked by this smart contract
277    * @dev Equal to sum of all token balances `tokenBalances`
278    */
279   uint256 private tokensTotal;
280 
281   /**
282    * @notice A record of all the allowances to spend tokens on behalf
283    * @dev Maps token owner address to an address approved to spend
284    *      some tokens on behalf, maps approved address to that amount
285    */
286   mapping(address => mapping(address => uint256)) private transferAllowances;
287 
288   /**
289    * @notice Enables ERC20 transfers of the tokens
290    *      (transfer by the token owner himself)
291    * @dev Feature FEATURE_TRANSFERS must be enabled to
292    *      call `transfer()` function
293    */
294   uint32 public constant FEATURE_TRANSFERS = 0x00000001;
295 
296   /**
297    * @notice Enables ERC20 transfers on behalf
298    *      (transfer by someone else on behalf of token owner)
299    * @dev Feature FEATURE_TRANSFERS_ON_BEHALF must be enabled to
300    *      call `transferFrom()` function
301    * @dev Token owner must call `approve()` first to authorize
302    *      the transfer on behalf
303    */
304   uint32 public constant FEATURE_TRANSFERS_ON_BEHALF = 0x00000002;
305 
306   /**
307    * @notice Token creator is responsible for creating (minting)
308    *      tokens to some player address
309    * @dev Role ROLE_TOKEN_CREATOR allows minting tokens
310    *      (calling `mint` and `mintTo` functions)
311    */
312   uint32 public constant ROLE_TOKEN_CREATOR = 0x00000001;
313 
314   /**
315    * @notice Token destroyer is responsible for destroying (burning)
316    *      tokens owned by some player address
317    * @dev Role ROLE_TOKEN_DESTROYER allows burning tokens
318    *      (calling `burn` and `burnFrom` functions)
319    */
320   uint32 public constant ROLE_TOKEN_DESTROYER = 0x00000002;
321 
322   /**
323    * @dev Magic value to be returned by ERC20Receiver upon successful reception of token(s)
324    * @dev Equal to `bytes4(keccak256("onERC20Received(address,address,uint256,bytes)"))`,
325    *      which can be also obtained as `ERC20Receiver(0).onERC20Received.selector`
326    */
327   bytes4 private constant ERC20_RECEIVED = 0x4fc35859;
328 
329   /**
330    * @dev Fired in transfer() and transferFrom() functions
331    * @param _from an address which performed the transfer
332    * @param _to an address tokens were sent to
333    * @param _value number of tokens transferred
334    */
335   event Transfer(address indexed _from, address indexed _to, uint256 _value);
336 
337   /**
338    * @dev Fired in approve() function
339    * @param _owner an address which granted a permission to transfer
340    *      tokens on its behalf
341    * @param _spender an address which received a permission to transfer
342    *      tokens on behalf of the owner `_owner`
343    */
344   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
345 
346   /**
347    * @dev Fired in mint() function
348    * @param _by an address which minted some tokens (transaction sender)
349    * @param _to an address the tokens were minted to
350    * @param _value an amount of tokens minted
351    */
352   event Minted(address indexed _by, address indexed _to, uint256 _value);
353 
354   /**
355    * @dev Fired in burn() function
356    * @param _by an address which burned some tokens (transaction sender)
357    * @param _from an address the tokens were burnt from
358    * @param _value an amount of tokens burnt
359    */
360   event Burnt(address indexed _by, address indexed _from, uint256 _value);
361 
362   /**
363    * @notice Total number of tokens tracked by this smart contract
364    * @dev Equal to sum of all token balances
365    * @return total number of tokens
366    */
367   function totalSupply() public constant returns (uint256) {
368     // read total tokens value and return
369     return tokensTotal;
370   }
371 
372   /**
373    * @notice Gets the balance of particular address
374    * @dev Gets the balance of the specified address
375    * @param _owner the address to query the the balance for
376    * @return an amount of tokens owned by the address specified
377    */
378   function balanceOf(address _owner) public constant returns (uint256) {
379     // read the balance from storage and return
380     return tokenBalances[_owner];
381   }
382 
383   /**
384    * @dev A function to check an amount of tokens owner approved
385    *      to transfer on its behalf by some other address called "spender"
386    * @param _owner an address which approves transferring some tokens on its behalf
387    * @param _spender an address approved to transfer some tokens on behalf
388    * @return an amount of tokens approved address `_spender` can transfer on behalf
389    *      of token owner `_owner`
390    */
391   function allowance(address _owner, address _spender) public constant returns (uint256) {
392     // read the value from storage and return
393     return transferAllowances[_owner][_spender];
394   }
395 
396   /**
397    * @notice Transfers some tokens to an address `_to`
398    * @dev Called by token owner (an address which has a
399    *      positive token balance tracked by this smart contract)
400    * @dev Throws on any error like
401    *      * incorrect `_value` (zero) or
402    *      * insufficient token balance or
403    *      * incorrect `_to` address:
404    *          * zero address or
405    *          * self address or
406    *          * smart contract which doesn't support ERC20
407    * @param _to an address to transfer tokens to,
408    *      must be either an external address or a smart contract,
409    *      compliant with the ERC20 standard
410    * @param _value amount of tokens to be transferred, must
411    *      be greater than zero
412    * @return true on success, throws otherwise
413    */
414   function transfer(address _to, uint256 _value) public returns (bool) {
415     // just delegate call to `transferFrom`,
416     // `FEATURE_TRANSFERS` is verified inside it
417     return transferFrom(msg.sender, _to, _value);
418   }
419 
420   /**
421    * @notice Transfers some tokens on behalf of address `_from' (token owner)
422    *      to some other address `_to`
423    * @dev Called by token owner on his own or approved address,
424    *      an address approved earlier by token owner to
425    *      transfer some amount of tokens on its behalf
426    * @dev Throws on any error like
427    *      * incorrect `_value` (zero) or
428    *      * insufficient token balance or
429    *      * incorrect `_to` address:
430    *          * zero address or
431    *          * same as `_from` address (self transfer)
432    *          * smart contract which doesn't support ERC20
433    * @param _from token owner which approved caller (transaction sender)
434    *      to transfer `_value` of tokens on its behalf
435    * @param _to an address to transfer tokens to,
436    *      must be either an external address or a smart contract,
437    *      compliant with the ERC20 standard
438    * @param _value amount of tokens to be transferred, must
439    *      be greater than zero
440    * @return true on success, throws otherwise
441    */
442   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
443     // just delegate call to `safeTransferFrom`, passing empty `_data`,
444     // `FEATURE_TRANSFERS` is verified inside it
445     safeTransferFrom(_from, _to, _value, "");
446 
447     // `safeTransferFrom` throws of any error, so
448     // if we're here - it means operation successful,
449     // just return true
450     return true;
451   }
452 
453   /**
454    * @notice Transfers some tokens on behalf of address `_from' (token owner)
455    *      to some other address `_to`
456    * @dev Inspired by ERC721 safeTransferFrom, this function allows to
457    *      send arbitrary data to the receiver on successful token transfer
458    * @dev Called by token owner on his own or approved address,
459    *      an address approved earlier by token owner to
460    *      transfer some amount of tokens on its behalf
461    * @dev Throws on any error like
462    *      * incorrect `_value` (zero) or
463    *      * insufficient token balance or
464    *      * incorrect `_to` address:
465    *          * zero address or
466    *          * same as `_from` address (self transfer)
467    *          * smart contract which doesn't support ERC20Receiver interface
468    * @param _from token owner which approved caller (transaction sender)
469    *      to transfer `_value` of tokens on its behalf
470    * @param _to an address to transfer tokens to,
471    *      must be either an external address or a smart contract,
472    *      compliant with the ERC20 standard
473    * @param _value amount of tokens to be transferred, must
474    *      be greater than zero
475    * @param _data [optional] additional data with no specified format,
476    *      sent in onERC20Received call to `_to` in case if its a smart contract
477    * @return true on success, throws otherwise
478    */
479   function safeTransferFrom(address _from, address _to, uint256 _value, bytes _data) public {
480     // first delegate call to `unsafeTransferFrom`
481     // to perform the unsafe token(s) transfer
482     unsafeTransferFrom(_from, _to, _value);
483 
484     // after the successful transfer – check if receiver supports
485     // ERC20Receiver and execute a callback handler `onERC20Received`,
486     // reverting whole transaction on any error:
487     // check if receiver `_to` supports ERC20Receiver interface
488     if (AddressUtils.isContract(_to)) {
489       // if `_to` is a contract – execute onERC20Received
490       bytes4 response = ERC20Receiver(_to).onERC20Received(msg.sender, _from, _value, _data);
491 
492       // expected response is ERC20_RECEIVED
493       require(response == ERC20_RECEIVED);
494     }
495   }
496 
497   /**
498    * @notice Transfers some tokens on behalf of address `_from' (token owner)
499    *      to some other address `_to`
500    * @dev In contrast to `safeTransferFrom` doesn't check recipient
501    *      smart contract to support ERC20 tokens (ERC20Receiver)
502    * @dev Designed to be used by developers when the receiver is known
503    *      to support ERC20 tokens but doesn't implement ERC20Receiver interface
504    * @dev Called by token owner on his own or approved address,
505    *      an address approved earlier by token owner to
506    *      transfer some amount of tokens on its behalf
507    * @dev Throws on any error like
508    *      * incorrect `_value` (zero) or
509    *      * insufficient token balance or
510    *      * incorrect `_to` address:
511    *          * zero address or
512    *          * same as `_from` address (self transfer)
513    * @param _from token owner which approved caller (transaction sender)
514    *      to transfer `_value` of tokens on its behalf
515    * @param _to an address to transfer tokens to,
516    *      must be either an external address or a smart contract,
517    *      compliant with the ERC20 standard
518    * @param _value amount of tokens to be transferred, must
519    *      be greater than zero
520    * @return true on success, throws otherwise
521    */
522   function unsafeTransferFrom(address _from, address _to, uint256 _value) public {
523     // if `_from` is equal to sender, require transfers feature to be enabled
524     // otherwise require transfers on behalf feature to be enabled
525     require(_from == msg.sender && isFeatureEnabled(FEATURE_TRANSFERS)
526          || _from != msg.sender && isFeatureEnabled(FEATURE_TRANSFERS_ON_BEHALF));
527 
528     // non-zero to address check
529     require(_to != address(0));
530 
531     // sender and recipient cannot be the same
532     require(_from != _to);
533 
534     // zero value transfer check
535     require(_value != 0);
536 
537     // by design of mint() -
538     // - no need to make arithmetic overflow check on the _value
539 
540     // in case of transfer on behalf
541     if(_from != msg.sender) {
542       // verify sender has an allowance to transfer amount of tokens requested
543       require(transferAllowances[_from][msg.sender] >= _value);
544 
545       // decrease the amount of tokens allowed to transfer
546       transferAllowances[_from][msg.sender] -= _value;
547     }
548 
549     // verify sender has enough tokens to transfer on behalf
550     require(tokenBalances[_from] >= _value);
551 
552     // perform the transfer:
553     // decrease token owner (sender) balance
554     tokenBalances[_from] -= _value;
555 
556     // increase `_to` address (receiver) balance
557     tokenBalances[_to] += _value;
558 
559     // emit an ERC20 transfer event
560     emit Transfer(_from, _to, _value);
561   }
562 
563   /**
564    * @notice Approves address called "spender" to transfer some amount
565    *      of tokens on behalf of the owner
566    * @dev Caller must not necessarily own any tokens to grant the permission
567    * @param _spender an address approved by the caller (token owner)
568    *      to spend some tokens on its behalf
569    * @param _value an amount of tokens spender `_spender` is allowed to
570    *      transfer on behalf of the token owner
571    * @return true on success, throws otherwise
572    */
573   function approve(address _spender, uint256 _value) public returns (bool) {
574     // perform an operation: write value requested into the storage
575     transferAllowances[msg.sender][_spender] = _value;
576 
577     // emit an event
578     emit Approval(msg.sender, _spender, _value);
579 
580     // operation successful, return true
581     return true;
582   }
583 
584   /**
585    * @dev Mints (creates) some tokens to address specified
586    * @dev The value passed is treated as number of units (see `ONE_UNIT`)
587    *      to achieve natural impression on token quantity
588    * @dev Requires sender to have `ROLE_TOKEN_CREATOR` permission
589    * @param _to an address to mint tokens to
590    * @param _value an amount of tokens to mint (create)
591    */
592   function mint(address _to, uint256 _value) public {
593     // calculate native value, taking into account `decimals`
594     uint256 value = _value * ONE_UNIT;
595 
596     // arithmetic overflow and non-zero value check
597     require(value > _value);
598 
599     // delegate call to native `mintNative`
600     mintNative(_to, value);
601   }
602 
603   /**
604    * @dev Mints (creates) some tokens to address specified
605    * @dev The value specified is treated as is without taking
606    *      into account what `decimals` value is
607    * @dev Requires sender to have `ROLE_TOKEN_CREATOR` permission
608    * @param _to an address to mint tokens to
609    * @param _value an amount of tokens to mint (create)
610    */
611   function mintNative(address _to, uint256 _value) public {
612     // check if caller has sufficient permissions to mint tokens
613     require(isSenderInRole(ROLE_TOKEN_CREATOR));
614 
615     // non-zero recipient address check
616     require(_to != address(0));
617 
618     // non-zero _value and arithmetic overflow check on the total supply
619     // this check automatically secures arithmetic overflow on the individual balance
620     require(tokensTotal + _value > tokensTotal);
621 
622     // increase `_to` address balance
623     tokenBalances[_to] += _value;
624 
625     // increase total amount of tokens value
626     tokensTotal += _value;
627 
628     // fire ERC20 compliant transfer event
629     emit Transfer(address(0), _to, _value);
630 
631     // fire a mint event
632     emit Minted(msg.sender, _to, _value);
633   }
634 
635   /**
636    * @dev Burns (destroys) some tokens from the address specified
637    * @dev The value passed is treated as number of units (see `ONE_UNIT`)
638    *      to achieve natural impression on token quantity
639    * @dev Requires sender to have `ROLE_TOKEN_DESTROYER` permission
640    * @param _from an address to burn some tokens from
641    * @param _value an amount of tokens to burn (destroy)
642    */
643   function burn(address _from, uint256 _value) public {
644     // calculate native value, taking into account `decimals`
645     uint256 value = _value * ONE_UNIT;
646 
647     // arithmetic overflow and non-zero value check
648     require(value > _value);
649 
650     // delegate call to native `burnNative`
651     burnNative(_from, value);
652   }
653 
654   /**
655    * @dev Burns (destroys) some tokens from the address specified
656    * @dev The value specified is treated as is without taking
657    *      into account what `decimals` value is
658    * @dev Requires sender to have `ROLE_TOKEN_DESTROYER` permission
659    * @param _from an address to burn some tokens from
660    * @param _value an amount of tokens to burn (destroy)
661    */
662   function burnNative(address _from, uint256 _value) public {
663     // check if caller has sufficient permissions to burn tokens
664     require(isSenderInRole(ROLE_TOKEN_DESTROYER));
665 
666     // non-zero burn value check
667     require(_value != 0);
668 
669     // verify `_from` address has enough tokens to destroy
670     // (basically this is a arithmetic overflow check)
671     require(tokenBalances[_from] >= _value);
672 
673     // decrease `_from` address balance
674     tokenBalances[_from] -= _value;
675 
676     // decrease total amount of tokens value
677     tokensTotal -= _value;
678 
679     // fire ERC20 compliant transfer event
680     emit Transfer(_from, address(0), _value);
681 
682     // fire a burn event
683     emit Burnt(msg.sender, _from, _value);
684   }
685 
686 }
687 
688 
689 /**
690  * @title Silver Smart Contract
691  *
692  * @notice Silver is a transferable fungible entity (ERC20 token)
693  *      used to "pay" for in game services like gem upgrades, etc.
694  * @notice Silver is a part of Gold/Silver system, which allows to
695  *      upgrade gems (level, grade, etc.)
696  *
697  * @dev Silver is mintable and burnable entity,
698  *      meaning it can be created or destroyed by the authorized addresses
699  * @dev An address authorized can mint/burn its own tokens (own balance) as well
700  *      as tokens owned by another address (additional permission level required)
701  *
702  * @author Basil Gorin
703  */
704 contract SilverERC20 is GoldERC20 {
705   /**
706    * @dev Smart contract version
707    * @dev Should be incremented manually in this source code
708    *      each time smart contact source code is changed
709    * @dev To distinguish from other tokens must be multiple of 0x10
710    */
711   uint32 public constant TOKEN_VERSION = 0x30;
712 
713   /**
714    * @notice ERC20 symbol of that token (short name)
715    */
716   string public constant symbol = "SLV";
717 
718   /**
719    * @notice ERC20 name of the token (long name)
720    */
721   string public constant name = "SILVER - CryptoMiner World";
722 
723 }