1 /**
2  * This smart contract code is Copyright 2018 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 /**
15  * Deserialize bytes payloads.
16  *
17  * Values are in big-endian byte order.
18  *
19  */
20 library BytesDeserializer {
21 
22   /**
23    * Extract 256-bit worth of data from the bytes stream.
24    */
25   function slice32(bytes b, uint offset) constant returns (bytes32) {
26     bytes32 out;
27 
28     for (uint i = 0; i < 32; i++) {
29       out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
30     }
31     return out;
32   }
33 
34   /**
35    * Extract Ethereum address worth of data from the bytes stream.
36    */
37   function sliceAddress(bytes b, uint offset) constant returns (address) {
38     bytes32 out;
39 
40     for (uint i = 0; i < 20; i++) {
41       out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
42     }
43     return address(uint(out));
44   }
45 
46   /**
47    * Extract 128-bit worth of data from the bytes stream.
48    */
49   function slice16(bytes b, uint offset) constant returns (bytes16) {
50     bytes16 out;
51 
52     for (uint i = 0; i < 16; i++) {
53       out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
54     }
55     return out;
56   }
57 
58   /**
59    * Extract 32-bit worth of data from the bytes stream.
60    */
61   function slice4(bytes b, uint offset) constant returns (bytes4) {
62     bytes4 out;
63 
64     for (uint i = 0; i < 4; i++) {
65       out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
66     }
67     return out;
68   }
69 
70   /**
71    * Extract 16-bit worth of data from the bytes stream.
72    */
73   function slice2(bytes b, uint offset) constant returns (bytes2) {
74     bytes2 out;
75 
76     for (uint i = 0; i < 2; i++) {
77       out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
78     }
79     return out;
80   }
81 
82 
83 
84 }
85 
86 
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0) {
99       return 0;
100     }
101     uint256 c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   /**
117   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 
135 
136 
137 /**
138  * @title Roles
139  * @author Francisco Giordano (@frangio)
140  * @dev Library for managing addresses assigned to a Role.
141  *      See RBAC.sol for example usage.
142  */
143 library Roles {
144   struct Role {
145     mapping (address => bool) bearer;
146   }
147 
148   /**
149    * @dev give an address access to this role
150    */
151   function add(Role storage role, address addr)
152     internal
153   {
154     role.bearer[addr] = true;
155   }
156 
157   /**
158    * @dev remove an address' access to this role
159    */
160   function remove(Role storage role, address addr)
161     internal
162   {
163     role.bearer[addr] = false;
164   }
165 
166   /**
167    * @dev check if an address has this role
168    * // reverts
169    */
170   function check(Role storage role, address addr)
171     view
172     internal
173   {
174     require(has(role, addr));
175   }
176 
177   /**
178    * @dev check if an address has this role
179    * @return bool
180    */
181   function has(Role storage role, address addr)
182     view
183     internal
184     returns (bool)
185   {
186     return role.bearer[addr];
187   }
188 }
189 
190 
191 
192 /**
193  * @title RBAC (Role-Based Access Control)
194  * @author Matt Condon (@Shrugs)
195  * @dev Stores and provides setters and getters for roles and addresses.
196  *      Supports unlimited numbers of roles and addresses.
197  *      See //contracts/mocks/RBACMock.sol for an example of usage.
198  * This RBAC method uses strings to key roles. It may be beneficial
199  *  for you to write your own implementation of this interface using Enums or similar.
200  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
201  *  to avoid typos.
202  */
203 contract RBAC {
204   using Roles for Roles.Role;
205 
206   mapping (string => Roles.Role) private roles;
207 
208   event RoleAdded(address addr, string roleName);
209   event RoleRemoved(address addr, string roleName);
210 
211   /**
212    * A constant role name for indicating admins.
213    */
214   string public constant ROLE_ADMIN = "admin";
215 
216   /**
217    * @dev constructor. Sets msg.sender as admin by default
218    */
219   function RBAC()
220     public
221   {
222     addRole(msg.sender, ROLE_ADMIN);
223   }
224 
225   /**
226    * @dev reverts if addr does not have role
227    * @param addr address
228    * @param roleName the name of the role
229    * // reverts
230    */
231   function checkRole(address addr, string roleName)
232     view
233     public
234   {
235     roles[roleName].check(addr);
236   }
237 
238   /**
239    * @dev determine if addr has role
240    * @param addr address
241    * @param roleName the name of the role
242    * @return bool
243    */
244   function hasRole(address addr, string roleName)
245     view
246     public
247     returns (bool)
248   {
249     return roles[roleName].has(addr);
250   }
251 
252   /**
253    * @dev add a role to an address
254    * @param addr address
255    * @param roleName the name of the role
256    */
257   function adminAddRole(address addr, string roleName)
258     onlyAdmin
259     public
260   {
261     addRole(addr, roleName);
262   }
263 
264   /**
265    * @dev remove a role from an address
266    * @param addr address
267    * @param roleName the name of the role
268    */
269   function adminRemoveRole(address addr, string roleName)
270     onlyAdmin
271     public
272   {
273     removeRole(addr, roleName);
274   }
275 
276   /**
277    * @dev add a role to an address
278    * @param addr address
279    * @param roleName the name of the role
280    */
281   function addRole(address addr, string roleName)
282     internal
283   {
284     roles[roleName].add(addr);
285     RoleAdded(addr, roleName);
286   }
287 
288   /**
289    * @dev remove a role from an address
290    * @param addr address
291    * @param roleName the name of the role
292    */
293   function removeRole(address addr, string roleName)
294     internal
295   {
296     roles[roleName].remove(addr);
297     RoleRemoved(addr, roleName);
298   }
299 
300   /**
301    * @dev modifier to scope access to a single role (uses msg.sender as addr)
302    * @param roleName the name of the role
303    * // reverts
304    */
305   modifier onlyRole(string roleName)
306   {
307     checkRole(msg.sender, roleName);
308     _;
309   }
310 
311   /**
312    * @dev modifier to scope access to admins
313    * // reverts
314    */
315   modifier onlyAdmin()
316   {
317     checkRole(msg.sender, ROLE_ADMIN);
318     _;
319   }
320 
321   /**
322    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
323    * @param roleNames the names of the roles to scope access to
324    * // reverts
325    *
326    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
327    *  see: https://github.com/ethereum/solidity/issues/2467
328    */
329   // modifier onlyRoles(string[] roleNames) {
330   //     bool hasAnyRole = false;
331   //     for (uint8 i = 0; i < roleNames.length; i++) {
332   //         if (hasRole(msg.sender, roleNames[i])) {
333   //             hasAnyRole = true;
334   //             break;
335   //         }
336   //     }
337 
338   //     require(hasAnyRole);
339 
340   //     _;
341   // }
342 }
343 
344 
345 
346 
347 /**
348  * @title ERC20Basic
349  * @dev Simpler version of ERC20 interface
350  * @dev see https://github.com/ethereum/EIPs/issues/179
351  */
352 contract ERC20Basic {
353   function totalSupply() public view returns (uint256);
354   function balanceOf(address who) public view returns (uint256);
355   function transfer(address to, uint256 value) public returns (bool);
356   event Transfer(address indexed from, address indexed to, uint256 value);
357 }
358 
359 
360 
361 /**
362  * @title ERC20 interface
363  * @dev see https://github.com/ethereum/EIPs/issues/20
364  */
365 contract ERC20 is ERC20Basic {
366   function allowance(address owner, address spender) public view returns (uint256);
367   function transferFrom(address from, address to, uint256 value) public returns (bool);
368   function approve(address spender, uint256 value) public returns (bool);
369   event Approval(address indexed owner, address indexed spender, uint256 value);
370 }
371 
372 
373 interface InvestorToken {
374   function transferInvestorTokens(address, uint256);
375 }
376 
377 /// @title TokenMarket Exchange Smart Contract
378 /// @author TokenMarket Ltd. / Ville Sundell <ville at tokenmarket.net> and Rainer Koirikivi <rainer at tokenmarket.net>
379 contract Exchange is RBAC {
380     using SafeMath for uint256;
381     using BytesDeserializer for bytes;
382 
383     // Roles for Role Based Access Control, initially the deployer account will
384     // have all of these roles:
385     string public constant ROLE_FORCED = "forced";
386     string public constant ROLE_TRANSFER_TOKENS = "transfer tokens";
387     string public constant ROLE_TRANSFER_INVESTOR_TOKENS = "transfer investor tokens";
388     string public constant ROLE_CLAIM = "claim";
389     string public constant ROLE_WITHDRAW = "withdraw";
390     string public constant ROLE_TRADE = "trade";
391     string public constant ROLE_CHANGE_DELAY = "change delay";
392     string public constant ROLE_SET_FEEACCOUNT = "set feeaccount";
393     string public constant ROLE_TOKEN_WHITELIST = "token whitelist user";
394 
395 
396     /// @dev Is the withdrawal transfer (identified by the hash) executed:
397     mapping(bytes32 => bool) public withdrawn;
398     /// @dev Is the out-bound transfer (identified by the hash) executed:
399     mapping(bytes32 => bool) public transferred;
400     /// @dev Is the token whitelisted for deposit:
401     mapping(address => bool) public tokenWhitelist;
402     /// @dev Keeping account of the total supply per token we posses:
403     mapping(address => uint256) public tokensTotal;
404     /// @dev Keeping account what tokens the user owns, and how many:
405     mapping(address => mapping(address => uint256)) public balanceOf;
406     /// @dev How much of the order (identified by hash) has been filled:
407     mapping (bytes32 => uint256) public orderFilled;
408     /// @dev Account where fees should be deposited to:
409     address public feeAccount;
410     /// @dev This defines the delay in seconds between user initiang withdrawal
411     ///      by themselves with withdrawRequest(), and finalizing the withdrawal
412     ///      with withdrawUser():
413     uint256 public delay;
414 
415     /// @dev This is emitted when token is added or removed from the whitelist:
416     event TokenWhitelistUpdated(address token, bool status);
417     /// @dev This is emitted when fee account is changed
418     event FeeAccountChanged(address newFeeAccocunt);
419     /// @dev This is emitted when delay between the withdrawRequest() and withdrawUser() is changed:
420     event DelayChanged(uint256 newDelay);
421     /// @dev This is emitted when user deposits either ether (token 0x0) or tokens:
422     event Deposited(address token, address who, uint256 amount, uint256 balance);
423     /// @dev This is emitted when tokens are forcefully pushed back to user (for example because of contract update):
424     event Forced(address token, address who, uint256 amount);
425     /// @dev This is emitted when user is Withdrawing ethers (token 0x0) or tokens with withdrawUser():
426     event Withdrawn(address token, address who, uint256 amount, uint256 balance);
427     /// @dev This is emitted when user starts withdrawal process with withdrawRequest():
428     event Requested(address token, address who, uint256 amount, uint256 index);
429     /// @dev This is emitted when Investor Interaction Contract tokens are transferred:
430     event TransferredInvestorTokens(address, address, address, uint256);
431     /// @dev This is emitted when tokens are transferred inside this Exchange smart contract:
432     event TransferredTokens(address, address, address, uint256, uint256, uint256);
433     /// @dev This is emitted when order gets executed, one for each "side" (right and left):
434     event OrderExecuted(
435         bytes32 orderHash,
436         address maker,
437         address baseToken,
438         address quoteToken,
439         address feeToken,
440         uint256 baseAmountFilled,
441         uint256 quoteAmountFilled,
442         uint256 feePaid,
443         uint256 baseTokenBalance,
444         uint256 quoteTokenBalance,
445         uint256 feeTokenBalance
446     );
447 
448     /// @dev This struct will have information on withdrawals initiated with withdrawRequest()
449     struct Withdrawal {
450       address user;
451       address token;
452       uint256 amount;
453       uint256 createdAt;
454       bool executed;
455     }
456 
457     /// @dev This is a list of withdrawals initiated with withdrawRequest()
458     ///      and which can be finalized by withdrawUser(index).
459     Withdrawal[] withdrawals;
460 
461     enum OrderType {Buy, Sell}
462 
463     /// @dev This struct is containing all the relevant information from the
464     ///      initiating user which can be used as one "side" of each trade
465     ///      trade() needs two of these, once for each "side" (left and right).
466     struct Order {
467       OrderType orderType;
468       address maker;
469       address baseToken;
470       address quoteToken;
471       address feeToken;
472       uint256 amount;
473       uint256 priceNumerator;
474       uint256 priceDenominator;
475       uint256 feeNumerator;
476       uint256 feeDenominator;
477       uint256 expiresAt;
478       uint256 nonce;
479     }
480 
481     /// @dev Upon deployment, user withdrawal delay is set, and the initial roles
482     /// @param _delay Minimum delay in seconds between withdrawRequest() and withdrawUser()
483     function Exchange(uint256 _delay) {
484       delay = _delay;
485 
486       feeAccount = msg.sender;
487       addRole(msg.sender, ROLE_FORCED);
488       addRole(msg.sender, ROLE_TRANSFER_TOKENS);
489       addRole(msg.sender, ROLE_TRANSFER_INVESTOR_TOKENS);
490       addRole(msg.sender, ROLE_CLAIM);
491       addRole(msg.sender, ROLE_WITHDRAW);
492       addRole(msg.sender, ROLE_TRADE);
493       addRole(msg.sender, ROLE_CHANGE_DELAY);
494       addRole(msg.sender, ROLE_SET_FEEACCOUNT);
495       addRole(msg.sender, ROLE_TOKEN_WHITELIST);
496     }
497 
498     /// @dev Update token whitelist: only whitelisted tokens can be deposited
499     /// @param token The token whose whitelist status will be changed
500     /// @param status Is the token whitelisted or not
501     function updateTokenWhitelist(address token, bool status) external onlyRole(ROLE_TOKEN_WHITELIST) {
502       tokenWhitelist[token] = status;
503 
504       TokenWhitelistUpdated(token, status);
505     }
506 
507 
508     /// @dev Changing the fee account
509     /// @param _feeAccount Address of the new fee account
510     function setFeeAccount(address _feeAccount) external onlyRole(ROLE_SET_FEEACCOUNT) {
511       feeAccount = _feeAccount;
512 
513       FeeAccountChanged(feeAccount);
514     }
515 
516     /// @dev Set user withdrawal delay (must be less than 2 weeks)
517     /// @param _delay New delay
518     function setDelay(uint256 _delay) external onlyRole(ROLE_CHANGE_DELAY) {
519       require(_delay < 2 weeks);
520       delay = _delay;
521 
522       DelayChanged(delay);
523     }
524 
525     /// @dev This takes in user's tokens
526     ///      User must first call properly approve() on token contract
527     ///      The token must be whitelisted with updateTokenWhitelist() beforehand
528     /// @param token Token to fetch
529     /// @param amount Amount of tokens to fetch, in its smallest denominator
530     /// @return true if transfer is successful
531     function depositTokens(ERC20 token, uint256 amount) external returns(bool) {
532       depositInternal(token, amount);
533       require(token.transferFrom(msg.sender, this, amount));
534       return true;
535     }
536 
537     /// @dev This takes in user's ethers
538     ///      Ether deposit must be allowed with updateTokenWhitelist(address(0), true)
539     /// @return true if transfer is successful
540     function depositEthers() external payable returns(bool) {
541       depositInternal(address(0), msg.value);
542       return true;
543     }
544 
545     /// @dev By default, backend will provide the withdrawal functionality
546     /// @param token Address of the token
547     /// @param user Who is the sender (and signer) of this token transfer
548     /// @param amount Amount of tokens in its smallest denominator
549     /// @param fee Optional fee in the smallest denominator of the token
550     /// @param nonce Nonce to make this signed transfer unique
551     /// @param v V of the user's key which was used to sign this transfer
552     /// @param r R of the user's key which was used to sign this transfer
553     /// @param s S of the user's key which was used to sign this transfer
554     function withdrawAdmin(ERC20 token, address user, uint256 amount, uint256 fee, uint256 nonce, uint8 v, bytes32 r, bytes32 s) external onlyRole(ROLE_WITHDRAW) {
555       bytes32 hash = keccak256(this, token, user, amount, fee, nonce);
556       require(withdrawn[hash] == false);
557       require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user);
558       withdrawn[hash] = true;
559 
560       withdrawInternal(token, user, amount, fee);
561     }
562 
563     /// @dev Backend can force tokens out of the Exchange contract back to user's wallet
564     /// @param token Token that backend wants to push back to the user
565     /// @param user User whose funds we want to push back
566     /// @param amount Amount of tokens in its smallest denominator
567     function withdrawForced(ERC20 token, address user, uint256 amount) external onlyRole(ROLE_FORCED) {
568       Forced(token, user, amount);
569       withdrawInternal(token, user, amount, 0);
570     }
571 
572     /// @dev First part of the last-resort user withdrawal
573     /// @param token Token address that user wants to withdraw
574     /// @param amount Amount of tokens in its smallest denominator
575     /// @return ID number of the transfer to be passed to withdrawUser()
576     function withdrawRequest(ERC20 token, uint256 amount) external returns(uint256) {
577       uint256 index = withdrawals.length;
578       withdrawals.push(Withdrawal(msg.sender, address(token), amount, now, false));
579 
580       Requested(token, msg.sender, amount, index);
581       return index;
582     }
583 
584     /// @dev User can withdraw their tokens here as the last resort. User must call withdrawRequest() first
585     /// @param index Unique ID of the withdrawal passed by withdrawRequest()
586     function withdrawUser(uint256 index) external {
587       require((withdrawals[index].createdAt.add(delay)) < now);
588       require(withdrawals[index].executed == false);
589       require(withdrawals[index].user == msg.sender);
590 
591       withdrawals[index].executed = true;
592       withdrawInternal(withdrawals[index].token, withdrawals[index].user, withdrawals[index].amount, 0);
593     }
594 
595     /// @dev Token transfer inside the Exchange
596     /// @param token Address of the token
597     /// @param from Who is the sender (and signer) of this internal token transfer
598     /// @param to Who is the receiver of this internal token transfer
599     /// @param amount Amount of tokens in its smallest denominator
600     /// @param fee Optional fee in the smallest denominator of the token
601     /// @param nonce Nonce to make this signed transfer unique
602     /// @param expires Expiration of this transfer
603     /// @param v V of the user's key which was used to sign this transfer
604     /// @param r R of the user's key which was used to sign this transfer
605     /// @param s S of the user's key which was used to sign this transfer
606     function transferTokens(ERC20 token, address from, address to, uint256 amount, uint256 fee, uint256 nonce, uint256 expires, uint8 v, bytes32 r, bytes32 s) external onlyRole(ROLE_TRANSFER_TOKENS) {
607       bytes32 hash = keccak256(this, token, from, to, amount, fee, nonce, expires);
608       require(expires >= now);
609       require(transferred[hash] == false);
610       require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == from);
611 
612       balanceOf[address(token)][from] = balanceOf[address(token)][from].sub(amount.add(fee));
613       balanceOf[address(token)][feeAccount] = balanceOf[address(token)][feeAccount].add(fee);
614       balanceOf[address(token)][to] = balanceOf[address(token)][to].add(amount);
615       TransferredTokens(token, from, to, amount, fee, nonce);
616     }
617 
618     /// @dev This is used to interact with TokenMarket's Security Token Infrastructure
619     /// @param token Address of the Investor Interaction Contract
620     /// @param to Destination where those tokens should be transferred to
621     /// @param amount Amount of tokens in its smallest denominator
622     function transferInvestorTokens(InvestorToken token, address to, uint256 amount) external onlyRole(ROLE_TRANSFER_INVESTOR_TOKENS) {
623       token.transferInvestorTokens(to, amount);
624       TransferredInvestorTokens(msg.sender, token, to, amount);
625     }
626 
627     /// @dev This is used to rescue accidentally transfer()'d tokens
628     /// @param token Address of the EIP-20 compatible token'
629     function claimExtra(ERC20 token) external onlyRole(ROLE_CLAIM) {
630       uint256 totalBalance = token.balanceOf(this);
631       token.transfer(feeAccount, totalBalance.sub(tokensTotal[token]));
632     }
633 
634     /// @dev This is the entry point for trading, and will prepare structs for tradeInternal()
635     /// @param _left The binary blob where Order struct will be extracted from
636     /// @param leftV V of the user's key which was used to sign _left
637     /// @param leftR R of the user's key which was used to sign _left
638     /// @param leftS S of the user's key which was used to sign _left
639     /// @param _right The binary blob where Order struct will be extracted from
640     /// @param rightV V of the user's key which was used to sign _right
641     /// @param leftR R of the user's key which was used to sign _right
642     /// @param rightS S of the user's key which was used to sign _right
643     function trade(bytes _left, uint8 leftV, bytes32 leftR, bytes32 leftS, bytes _right, uint8 rightV, bytes32 rightR, bytes32 rightS) external {
644       checkRole(msg.sender, ROLE_TRADE); //If we use the onlyRole() modifier, we will get "stack too deep" error
645 
646       Order memory left;
647       Order memory right;
648 
649       left.maker = _left.sliceAddress(0);
650       left.baseToken = _left.sliceAddress(20);
651       left.quoteToken = _left.sliceAddress(40);
652       left.feeToken = _left.sliceAddress(60);
653       left.amount = uint256(_left.slice32(80));
654       left.priceNumerator = uint256(_left.slice32(112));
655       left.priceDenominator = uint256(_left.slice32(144));
656       left.feeNumerator = uint256(_left.slice32(176));
657       left.feeDenominator = uint256(_left.slice32(208));
658       left.expiresAt = uint256(_left.slice32(240));
659       left.nonce = uint256(_left.slice32(272));
660       if (_left.slice2(304) == 0) {
661           left.orderType = OrderType.Sell;
662       } else {
663           left.orderType = OrderType.Buy;
664       }
665 
666       right.maker = _right.sliceAddress(0);
667       right.baseToken = _right.sliceAddress(20);
668       right.quoteToken = _right.sliceAddress(40);
669       right.feeToken = _right.sliceAddress(60);
670       right.amount = uint256(_right.slice32(80));
671       right.priceNumerator = uint256(_right.slice32(112));
672       right.priceDenominator = uint256(_right.slice32(144));
673       right.feeNumerator = uint256(_right.slice32(176));
674       right.feeDenominator = uint256(_right.slice32(208));
675       right.expiresAt = uint256(_right.slice32(240));
676       right.nonce = uint256(_right.slice32(272));
677       if (_right.slice2(304) == 0) {
678           right.orderType = OrderType.Sell;
679       } else {
680           right.orderType = OrderType.Buy;
681       }
682 
683       bytes32 leftHash = getOrderHash(left);
684       bytes32 rightHash = getOrderHash(right);
685       address leftSigner = ecrecover(keccak256("\x19Ethereum Signed Message:\n32", leftHash), leftV, leftR, leftS);
686       address rightSigner = ecrecover(keccak256("\x19Ethereum Signed Message:\n32", rightHash), rightV, rightR, rightS);
687 
688       require(leftSigner == left.maker);
689       require(rightSigner == right.maker);
690 
691       tradeInternal(left, leftHash, right, rightHash);
692     }
693 
694     /// @dev Trading itself happens here
695     /// @param left Left side of the order pair
696     /// @param leftHash getOrderHash() of the left
697     /// @param right Right side of the order pair
698     /// @param rightHash getOrderHash() of the right
699     function tradeInternal(Order left, bytes32 leftHash, Order right, bytes32 rightHash) internal {
700       uint256 priceNumerator;
701       uint256 priceDenominator;
702       uint256 leftAmountRemaining;
703       uint256 rightAmountRemaining;
704       uint256 amountBaseFilled;
705       uint256 amountQuoteFilled;
706       uint256 leftFeePaid;
707       uint256 rightFeePaid;
708 
709       require(left.expiresAt > now);
710       require(right.expiresAt > now);
711 
712       require(left.baseToken == right.baseToken);
713       require(left.quoteToken == right.quoteToken);
714 
715       require(left.baseToken != left.quoteToken);
716 
717       require((left.orderType == OrderType.Sell && right.orderType == OrderType.Buy) || (left.orderType == OrderType.Buy && right.orderType == OrderType.Sell));
718 
719       require(left.amount > 0);
720       require(left.priceNumerator > 0);
721       require(left.priceDenominator > 0);
722       require(right.amount > 0);
723       require(right.priceNumerator > 0);
724       require(right.priceDenominator > 0);
725 
726       require(left.feeDenominator > 0);
727       require(right.feeDenominator > 0);
728 
729       require(left.amount % left.priceDenominator == 0);
730       require(left.amount % right.priceDenominator == 0);
731       require(right.amount % left.priceDenominator == 0);
732       require(right.amount % right.priceDenominator == 0);
733 
734       if (left.orderType == OrderType.Buy) {
735         require((left.priceNumerator.mul(right.priceDenominator)) >= (right.priceNumerator.mul(left.priceDenominator)));
736       } else {
737         require((left.priceNumerator.mul(right.priceDenominator)) <= (right.priceNumerator.mul(left.priceDenominator)));
738       }
739 
740       priceNumerator = left.priceNumerator;
741       priceDenominator = left.priceDenominator;
742 
743       leftAmountRemaining = left.amount.sub(orderFilled[leftHash]);
744       rightAmountRemaining = right.amount.sub(orderFilled[rightHash]);
745 
746       require(leftAmountRemaining > 0);
747       require(rightAmountRemaining > 0);
748 
749       if (leftAmountRemaining < rightAmountRemaining) {
750         amountBaseFilled = leftAmountRemaining;
751       } else {
752         amountBaseFilled = rightAmountRemaining;
753       }
754       amountQuoteFilled = amountBaseFilled.mul(priceNumerator).div(priceDenominator);
755 
756       leftFeePaid = calculateFee(amountQuoteFilled, left.feeNumerator, left.feeDenominator);
757       rightFeePaid = calculateFee(amountQuoteFilled, right.feeNumerator, right.feeDenominator);
758 
759       if (left.orderType == OrderType.Buy) {
760         checkBalances(left.maker, left.baseToken, left.quoteToken, left.feeToken, amountBaseFilled, amountQuoteFilled, leftFeePaid);
761         checkBalances(right.maker, right.quoteToken, right.baseToken, right.feeToken, amountQuoteFilled, amountBaseFilled, rightFeePaid);
762 
763         balanceOf[left.baseToken][left.maker] = balanceOf[left.baseToken][left.maker].add(amountBaseFilled);
764         balanceOf[left.quoteToken][left.maker] = balanceOf[left.quoteToken][left.maker].sub(amountQuoteFilled);
765         balanceOf[right.baseToken][right.maker] = balanceOf[right.baseToken][right.maker].sub(amountBaseFilled);
766         balanceOf[right.quoteToken][right.maker] = balanceOf[right.quoteToken][right.maker].add(amountQuoteFilled);
767       } else {
768         checkBalances(left.maker, left.quoteToken, left.baseToken, left.feeToken, amountQuoteFilled, amountBaseFilled, leftFeePaid);
769         checkBalances(right.maker, right.baseToken, right.quoteToken, right.feeToken, amountBaseFilled, amountQuoteFilled, rightFeePaid);
770 
771         balanceOf[left.baseToken][left.maker] = balanceOf[left.baseToken][left.maker].sub(amountBaseFilled);
772         balanceOf[left.quoteToken][left.maker] = balanceOf[left.quoteToken][left.maker].add(amountQuoteFilled);
773         balanceOf[right.baseToken][right.maker] = balanceOf[right.baseToken][right.maker].add(amountBaseFilled);
774         balanceOf[right.quoteToken][right.maker] = balanceOf[right.quoteToken][right.maker].sub(amountQuoteFilled);
775       }
776 
777       if (leftFeePaid > 0) {
778         balanceOf[left.feeToken][left.maker] = balanceOf[left.feeToken][left.maker].sub(leftFeePaid);
779         balanceOf[left.feeToken][feeAccount] = balanceOf[left.feeToken][feeAccount].add(leftFeePaid);
780       }
781 
782       if (rightFeePaid > 0) {
783         balanceOf[right.feeToken][right.maker] = balanceOf[right.feeToken][right.maker].sub(rightFeePaid);
784         balanceOf[right.feeToken][feeAccount] = balanceOf[right.feeToken][feeAccount].add(rightFeePaid);
785       }
786 
787       orderFilled[leftHash] = orderFilled[leftHash].add(amountBaseFilled);
788       orderFilled[rightHash] = orderFilled[rightHash].add(amountBaseFilled);
789 
790       emitOrderExecutedEvent(left, leftHash, amountBaseFilled, amountQuoteFilled, leftFeePaid);
791       emitOrderExecutedEvent(right, rightHash, amountBaseFilled, amountQuoteFilled, rightFeePaid);
792     }
793 
794     /// @dev Calculate the fee for an order
795     /// @param amountFilled How much of the order has been filled
796     /// @param feeNumerator Will multiply amountFilled with this
797     /// @param feeDenominator Will divide amountFilled * feeNumerator with this
798     /// @return Will return the fee
799     function calculateFee(uint256 amountFilled, uint256 feeNumerator, uint256 feeDenominator) public returns(uint256) {
800       return (amountFilled.mul(feeNumerator).div(feeDenominator));
801     }
802 
803     /// @dev This is the internal method shared by all withdrawal functions
804     /// @param token Address of the token withdrawn
805     /// @param user Address of the user making the withdrawal
806     /// @param amount Amount of token in its smallest denominator
807     /// @param fee Fee paid in this particular token
808     function withdrawInternal(address token, address user, uint256 amount, uint256 fee) internal {
809       require(amount > 0);
810       require(balanceOf[token][user] >= amount.add(fee));
811 
812       balanceOf[token][user] = balanceOf[token][user].sub(amount.add(fee));
813       balanceOf[token][feeAccount] = balanceOf[token][feeAccount].add(fee);
814       tokensTotal[token] = tokensTotal[token].sub(amount);
815 
816       if (token == address(0)) {
817           user.transfer(amount);
818       } else {
819           require(ERC20(token).transfer(user, amount));
820       }
821 
822       Withdrawn(token, user, amount, balanceOf[token][user]);
823     }
824 
825     /// @dev This is the internal method shared by all deposit functions
826     ///      The token must have been whitelisted with updateTokenWhitelist()
827     /// @param token Address of the token deposited
828     /// @param amount Amount of token in its smallest denominator
829     function depositInternal(address token, uint256 amount) internal {
830       require(tokenWhitelist[address(token)]);
831 
832       balanceOf[token][msg.sender] = balanceOf[token][msg.sender].add(amount);
833       tokensTotal[token] = tokensTotal[token].add(amount);
834 
835       Deposited(token, msg.sender, amount, balanceOf[token][msg.sender]);
836     }
837 
838     /// @dev This is for emitting OrderExecuted(), one per order
839     /// @param order The Order struct which is relevant for this event
840     /// @param orderHash Hash received from getOrderHash()
841     /// @param amountBaseFilled Amount of order.baseToken filled
842     /// @param amountQuoteFilled Amount of order.quoteToken filled
843     /// @param feePaid Amount in order.feeToken paid
844     function emitOrderExecutedEvent(
845       Order order,
846       bytes32 orderHash,
847       uint256 amountBaseFilled,
848       uint256 amountQuoteFilled,
849       uint256 feePaid
850     ) private {
851       uint256 baseTokenBalance = balanceOf[order.baseToken][order.maker];
852       uint256 quoteTokenBalance = balanceOf[order.quoteToken][order.maker];
853       uint256 feeTokenBalance = balanceOf[order.feeToken][order.maker];
854       OrderExecuted(
855           orderHash,
856           order.maker,
857           order.baseToken,
858           order.quoteToken,
859           order.feeToken,
860           amountBaseFilled,
861           amountQuoteFilled,
862           feePaid,
863           baseTokenBalance,
864           quoteTokenBalance,
865           feeTokenBalance
866       );
867     }
868 
869     /// @dev Order struct will be hashed here with keccak256
870     /// @param order The Order struct which will be hashed
871     /// @return The keccak256 hash in bytes32
872     function getOrderHash(Order order) private returns(bytes32) {
873         return keccak256(
874             this,
875             order.orderType,
876             order.maker,
877             order.baseToken,
878             order.quoteToken,
879             order.feeToken,
880             order.amount,
881             order.priceNumerator,
882             order.priceDenominator,
883             order.feeNumerator,
884             order.feeDenominator,
885             order.expiresAt,
886             order.nonce
887         );
888     }
889 
890     /// @dev This is used to check balances for a user upon trade, all in once
891     /// @param addr Address of the user
892     /// @param boughtToken The address of the token which is being bought
893     /// @param soldToken The address of the token which is being sold
894     /// @param feeToken The token which is used for fees
895     /// @param boughtAmount Amount in boughtToken
896     /// @param soldAmount Amount in soldTokens
897     /// @param feeAmount Amount in feeTokens
898     function checkBalances(address addr, address boughtToken, address soldToken, address feeToken, uint256 boughtAmount, uint256 soldAmount, uint256 feeAmount) private {
899       if (feeToken == soldToken) {
900         require (balanceOf[soldToken][addr] >= (soldAmount.add(feeAmount)));
901       } else {
902         if (feeToken == boughtToken) {
903           require (balanceOf[feeToken][addr].add(boughtAmount) >= feeAmount);
904         } else {
905           require (balanceOf[feeToken][addr] >= feeAmount);
906         }
907         require (balanceOf[soldToken][addr] >= soldAmount);
908       }
909     }
910 }