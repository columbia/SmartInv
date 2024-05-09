1 pragma solidity 0.4.24;
2 
3 // File: contracts/generic/Restricted.sol
4 
5 /*
6     Generic contract to authorise calls to certain functions only from a given address.
7     The address authorised must be a contract (multisig or not, depending on the permission), except for local test
8 
9     deployment works as:
10            1. contract deployer account deploys contracts
11            2. constructor grants "PermissionGranter" permission to deployer account
12            3. deployer account executes initial setup (no multiSig)
13            4. deployer account grants PermissionGranter permission for the MultiSig contract
14                 (e.g. StabilityBoardProxy or PreTokenProxy)
15            5. deployer account revokes its own PermissionGranter permission
16 */
17 
18 pragma solidity 0.4.24;
19 
20 
21 contract Restricted {
22 
23     // NB: using bytes32 rather than the string type because it's cheaper gas-wise:
24     mapping (address => mapping (bytes32 => bool)) public permissions;
25 
26     event PermissionGranted(address indexed agent, bytes32 grantedPermission);
27     event PermissionRevoked(address indexed agent, bytes32 revokedPermission);
28 
29     modifier restrict(bytes32 requiredPermission) {
30         require(permissions[msg.sender][requiredPermission], "msg.sender must have permission");
31         _;
32     }
33 
34     constructor(address permissionGranterContract) public {
35         require(permissionGranterContract != address(0), "permissionGranterContract must be set");
36         permissions[permissionGranterContract]["PermissionGranter"] = true;
37         emit PermissionGranted(permissionGranterContract, "PermissionGranter");
38     }
39 
40     function grantPermission(address agent, bytes32 requiredPermission) public {
41         require(permissions[msg.sender]["PermissionGranter"],
42             "msg.sender must have PermissionGranter permission");
43         permissions[agent][requiredPermission] = true;
44         emit PermissionGranted(agent, requiredPermission);
45     }
46 
47     function grantMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
48         require(permissions[msg.sender]["PermissionGranter"],
49             "msg.sender must have PermissionGranter permission");
50         uint256 length = requiredPermissions.length;
51         for (uint256 i = 0; i < length; i++) {
52             grantPermission(agent, requiredPermissions[i]);
53         }
54     }
55 
56     function revokePermission(address agent, bytes32 requiredPermission) public {
57         require(permissions[msg.sender]["PermissionGranter"],
58             "msg.sender must have PermissionGranter permission");
59         permissions[agent][requiredPermission] = false;
60         emit PermissionRevoked(agent, requiredPermission);
61     }
62 
63     function revokeMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
64         uint256 length = requiredPermissions.length;
65         for (uint256 i = 0; i < length; i++) {
66             revokePermission(agent, requiredPermissions[i]);
67         }
68     }
69 
70 }
71 
72 // File: contracts/generic/SafeMath.sol
73 
74 /**
75 * @title SafeMath
76 * @dev Math operations with safety checks that throw on error
77 
78     TODO: check against ds-math: https://blog.dapphub.com/ds-math/
79     TODO: move roundedDiv to a sep lib? (eg. Math.sol)
80     TODO: more unit tests!
81 */
82 pragma solidity 0.4.24;
83 
84 
85 library SafeMath {
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a * b;
88         require(a == 0 || c / a == b, "mul overflow");
89         return c;
90     }
91 
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
94         uint256 c = a / b;
95         // require(a == b * c + a % b); // There is no case in which this doesn't hold
96         return c;
97     }
98 
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a, "sub underflow");
101         return a - b;
102     }
103 
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "add overflow");
107         return c;
108     }
109 
110     // Division, round to nearest integer, round half up
111     function roundedDiv(uint256 a, uint256 b) internal pure returns (uint256) {
112         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
113         uint256 halfB = (b % 2 == 0) ? (b / 2) : (b / 2 + 1);
114         return (a % b >= halfB) ? (a / b + 1) : (a / b);
115     }
116 
117     // Division, always rounds up
118     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
120         return (a % b != 0) ? (a / b + 1) : (a / b);
121     }
122 
123     function min(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a < b ? a : b;
125     }
126 
127     function max(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a < b ? b : a;
129     }    
130 }
131 
132 // File: contracts/interfaces/TransferFeeInterface.sol
133 
134 /*
135  *  transfer fee calculation interface
136  *
137  */
138 pragma solidity 0.4.24;
139 
140 
141 interface TransferFeeInterface {
142     function calculateTransferFee(address from, address to, uint amount) external view returns (uint256 fee);
143 }
144 
145 // File: contracts/interfaces/ERC20Interface.sol
146 
147 /*
148  * ERC20 interface
149  * see https://github.com/ethereum/EIPs/issues/20
150  */
151 pragma solidity 0.4.24;
152 
153 
154 interface ERC20Interface {
155     event Approval(address indexed _owner, address indexed _spender, uint _value);
156     event Transfer(address indexed from, address indexed to, uint amount);
157 
158     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
159     function transferFrom(address from, address to, uint value) external returns (bool);
160     function approve(address spender, uint value) external returns (bool);
161     function balanceOf(address who) external view returns (uint);
162     function allowance(address _owner, address _spender) external view returns (uint remaining);
163 
164 }
165 
166 // File: contracts/interfaces/TokenReceiver.sol
167 
168 /*
169  *  receiver contract interface
170  * see https://github.com/ethereum/EIPs/issues/677
171  */
172 pragma solidity 0.4.24;
173 
174 
175 interface TokenReceiver {
176     function transferNotification(address from, uint256 amount, uint data) external;
177 }
178 
179 // File: contracts/interfaces/AugmintTokenInterface.sol
180 
181 /* Augmint Token interface (abstract contract)
182 
183 TODO: overload transfer() & transferFrom() instead of transferWithNarrative() & transferFromWithNarrative()
184       when this fix available in web3& truffle also uses that web3: https://github.com/ethereum/web3.js/pull/1185
185 TODO: shall we use bytes for narrative?
186  */
187 pragma solidity 0.4.24;
188 
189 
190 
191 
192 
193 
194 
195 contract AugmintTokenInterface is Restricted, ERC20Interface {
196     using SafeMath for uint256;
197 
198     string public name;
199     string public symbol;
200     bytes32 public peggedSymbol;
201     uint8 public decimals;
202 
203     uint public totalSupply;
204     mapping(address => uint256) public balances; // Balances for each account
205     mapping(address => mapping (address => uint256)) public allowed; // allowances added with approve()
206 
207     TransferFeeInterface public feeAccount;
208     mapping(bytes32 => bool) public delegatedTxHashesUsed; // record txHashes used by delegatedTransfer
209 
210     event TransferFeesChanged(uint transferFeePt, uint transferFeeMin, uint transferFeeMax);
211     event Transfer(address indexed from, address indexed to, uint amount);
212     event AugmintTransfer(address indexed from, address indexed to, uint amount, string narrative, uint fee);
213     event TokenIssued(uint amount);
214     event TokenBurned(uint amount);
215     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
216 
217     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
218     function transferFrom(address from, address to, uint value) external returns (bool);
219     function approve(address spender, uint value) external returns (bool);
220 
221     function delegatedTransfer(address from, address to, uint amount, string narrative,
222                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
223                                     bytes32 nonce, /* random nonce generated by client */
224                                     /* ^^^^ end of signed data ^^^^ */
225                                     bytes signature,
226                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
227                                 ) external;
228 
229     function delegatedTransferAndNotify(address from, TokenReceiver target, uint amount, uint data,
230                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
231                                     bytes32 nonce, /* random nonce generated by client */
232                                     /* ^^^^ end of signed data ^^^^ */
233                                     bytes signature,
234                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
235                                 ) external;
236 
237     function increaseApproval(address spender, uint addedValue) external;
238     function decreaseApproval(address spender, uint subtractedValue) external;
239 
240     function issueTo(address to, uint amount) external; // restrict it to "MonetarySupervisor" in impl.;
241     function burn(uint amount) external;
242 
243     function transferAndNotify(TokenReceiver target, uint amount, uint data) external;
244 
245     function transferWithNarrative(address to, uint256 amount, string narrative) external;
246     function transferFromWithNarrative(address from, address to, uint256 amount, string narrative) external;
247 
248     function setName(string _name) external;
249     function setSymbol(string _symbol) external;
250 
251     function allowance(address owner, address spender) external view returns (uint256 remaining);
252 
253     function balanceOf(address who) external view returns (uint);
254 
255 
256 }
257 
258 // File: contracts/generic/ECRecovery.sol
259 
260 /**
261  * @title Eliptic curve signature operations
262  *
263  * @dev Based on https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ECRecovery.sol
264  *
265  * TODO Remove this library once solidity supports passing a signature to ecrecover.
266  * See https://github.com/ethereum/solidity/issues/864
267  *
268  */
269 
270 library ECRecovery {
271 
272   /**
273    * @dev Recover signer address from a message by using their signature
274    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
275    * @param sig bytes signature, the signature is generated using web3.eth.sign()
276    */
277   function recover(bytes32 hash, bytes sig)
278     internal
279     pure
280     returns (address)
281   {
282     bytes32 r;
283     bytes32 s;
284     uint8 v;
285 
286     // Check the signature length
287     if (sig.length != 65) {
288       return (address(0));
289     }
290 
291     // Divide the signature in r, s and v variables
292     // ecrecover takes the signature parameters, and the only way to get them
293     // currently is to use assembly.
294     // solium-disable-next-line security/no-inline-assembly
295     assembly {
296       r := mload(add(sig, 32))
297       s := mload(add(sig, 64))
298       v := byte(0, mload(add(sig, 96)))
299     }
300 
301     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
302     if (v < 27) {
303       v += 27;
304     }
305 
306     // If the version is correct return the signer address
307     if (v != 27 && v != 28) {
308       return (address(0));
309     } else {
310       // solium-disable-next-line arg-overflow
311       return ecrecover(hash, v, r, s);
312     }
313   }
314 
315   /**
316    * toEthSignedMessageHash
317    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
318    * @dev and hash the result
319    */
320   function toEthSignedMessageHash(bytes32 hash)
321     internal
322     pure
323     returns (bytes32)
324   {
325     // 32 is the length in bytes of hash,
326     // enforced by the type signature above
327     return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
328   }
329 }
330 
331 // File: contracts/generic/AugmintToken.sol
332 
333 /* Generic Augmint Token implementation (ERC20 token)
334     This contract manages:
335         * Balances of Augmint holders and transactions between them
336         * Issues/burns tokens
337 
338     TODO:
339         - reconsider delegatedTransfer and how to structure it
340         - shall we allow change of txDelegator?
341         - consider generic bytes arg instead of uint for transferAndNotify
342         - consider separate transfer fee params and calculation to separate contract (to feeAccount?)
343 */
344 pragma solidity 0.4.24;
345 
346 
347 
348 
349 
350 
351 contract AugmintToken is AugmintTokenInterface {
352 
353     event FeeAccountChanged(TransferFeeInterface newFeeAccount);
354 
355     constructor(address permissionGranterContract, string _name, string _symbol, bytes32 _peggedSymbol, uint8 _decimals, TransferFeeInterface _feeAccount)
356     public Restricted(permissionGranterContract) {
357         require(_feeAccount != address(0), "feeAccount must be set");
358         require(bytes(_name).length > 0, "name must be set");
359         require(bytes(_symbol).length > 0, "symbol must be set");
360 
361         name = _name;
362         symbol = _symbol;
363         peggedSymbol = _peggedSymbol;
364         decimals = _decimals;
365 
366         feeAccount = _feeAccount;
367 
368     }
369 
370     function transfer(address to, uint256 amount) external returns (bool) {
371         _transfer(msg.sender, to, amount, "");
372         return true;
373     }
374 
375     /* Transfers based on an offline signed transfer instruction. */
376     function delegatedTransfer(address from, address to, uint amount, string narrative,
377                                      uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
378                                      bytes32 nonce, /* random nonce generated by client */
379                                      /* ^^^^ end of signed data ^^^^ */
380                                      bytes signature,
381                                      uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
382                                      )
383     external {
384         bytes32 txHash = keccak256(abi.encodePacked(this, from, to, amount, narrative, maxExecutorFeeInToken, nonce));
385 
386         _checkHashAndTransferExecutorFee(txHash, signature, from, maxExecutorFeeInToken, requestedExecutorFeeInToken);
387 
388         _transfer(from, to, amount, narrative);
389     }
390 
391     function approve(address _spender, uint256 amount) external returns (bool) {
392         require(_spender != 0x0, "spender must be set");
393         allowed[msg.sender][_spender] = amount;
394         emit Approval(msg.sender, _spender, amount);
395         return true;
396     }
397 
398     /**
399      ERC20 transferFrom attack protection: https://github.com/DecentLabs/dcm-poc/issues/57
400      approve should be called when allowed[_spender] == 0. To increment allowed value is better
401      to use this function to avoid 2 calls (and wait until the first transaction is mined)
402      Based on MonolithDAO Token.sol */
403     function increaseApproval(address _spender, uint _addedValue) external {
404         require(_spender != 0x0, "spender must be set");
405         mapping (address => uint256) allowances = allowed[msg.sender];
406         uint newValue = allowances[_spender].add(_addedValue);
407         allowances[_spender] = newValue;
408         emit Approval(msg.sender, _spender, newValue);
409     }
410 
411     function decreaseApproval(address _spender, uint _subtractedValue) external {
412         require(_spender != 0x0, "spender must be set");
413         uint oldValue = allowed[msg.sender][_spender];
414         if (_subtractedValue > oldValue) {
415             allowed[msg.sender][_spender] = 0;
416         } else {
417             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
418         }
419         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
420     }
421 
422     function transferFrom(address from, address to, uint256 amount) external returns (bool) {
423         _transferFrom(from, to, amount, "");
424         return true;
425     }
426 
427     // Issue tokens. See MonetarySupervisor but as a rule of thumb issueTo is only allowed:
428     //      - on new loan (by trusted Lender contracts)
429     //      - when converting old tokens using MonetarySupervisor
430     //      - strictly to reserve by Stability Board (via MonetarySupervisor)
431     function issueTo(address to, uint amount) external restrict("MonetarySupervisor") {
432         balances[to] = balances[to].add(amount);
433         totalSupply = totalSupply.add(amount);
434         emit Transfer(0x0, to, amount);
435         emit AugmintTransfer(0x0, to, amount, "", 0);
436     }
437 
438     // Burn tokens. Anyone can burn from its own account. YOLO.
439     // Used by to burn from Augmint reserve or by Lender contract after loan repayment
440     function burn(uint amount) external {
441         require(balances[msg.sender] >= amount, "balance must be >= amount");
442         balances[msg.sender] = balances[msg.sender].sub(amount);
443         totalSupply = totalSupply.sub(amount);
444         emit Transfer(msg.sender, 0x0, amount);
445         emit AugmintTransfer(msg.sender, 0x0, amount, "", 0);
446     }
447 
448     /* to upgrade feeAccount (eg. for fee calculation changes) */
449     function setFeeAccount(TransferFeeInterface newFeeAccount) external restrict("StabilityBoard") {
450         feeAccount = newFeeAccount;
451         emit FeeAccountChanged(newFeeAccount);
452     }
453 
454     /*  transferAndNotify can be used by contracts which require tokens to have only 1 tx (instead of approve + call)
455         Eg. repay loan, lock funds, token sell order on exchange
456         Reverts on failue:
457             - transfer fails
458             - if transferNotification fails (callee must revert on failure)
459             - if targetContract is an account or targetContract doesn't have neither transferNotification or fallback fx
460         TODO: make data param generic bytes (see receiver code attempt in Locker.transferNotification)
461     */
462     function transferAndNotify(TokenReceiver target, uint amount, uint data) external {
463         _transfer(msg.sender, target, amount, "");
464 
465         target.transferNotification(msg.sender, amount, data);
466     }
467 
468     /* transferAndNotify based on an  instruction signed offline  */
469     function delegatedTransferAndNotify(address from, TokenReceiver target, uint amount, uint data,
470                                      uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
471                                      bytes32 nonce, /* random nonce generated by client */
472                                      /* ^^^^ end of signed data ^^^^ */
473                                      bytes signature,
474                                      uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
475                                      )
476     external {
477         bytes32 txHash = keccak256(abi.encodePacked(this, from, target, amount, data, maxExecutorFeeInToken, nonce));
478 
479         _checkHashAndTransferExecutorFee(txHash, signature, from, maxExecutorFeeInToken, requestedExecutorFeeInToken);
480 
481         _transfer(from, target, amount, "");
482         target.transferNotification(from, amount, data);
483     }
484 
485 
486     function transferWithNarrative(address to, uint256 amount, string narrative) external {
487         _transfer(msg.sender, to, amount, narrative);
488     }
489 
490     function transferFromWithNarrative(address from, address to, uint256 amount, string narrative) external {
491         _transferFrom(from, to, amount, narrative);
492     }
493 
494     /* Allow Stability Board to change the name when a new token contract version
495        is deployed and ready for production use. So that older token contracts
496        are identifiable in 3rd party apps. */
497     function setName(string _name) external restrict("StabilityBoard") {
498         name = _name;
499     }
500 
501     /* Allow Stability Board to change the symbol when a new token contract version
502        is deployed and ready for production use. So that older token contracts
503        are identifiable in 3rd party apps. */
504     function setSymbol(string _symbol) external restrict("StabilityBoard") {
505         symbol = _symbol;
506     }
507 
508     function balanceOf(address _owner) external view returns (uint256 balance) {
509         return balances[_owner];
510     }
511 
512     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
513         return allowed[_owner][_spender];
514     }
515 
516     function _checkHashAndTransferExecutorFee(bytes32 txHash, bytes signature, address signer,
517                                                 uint maxExecutorFeeInToken, uint requestedExecutorFeeInToken) private {
518         require(requestedExecutorFeeInToken <= maxExecutorFeeInToken, "requestedExecutorFee must be <= maxExecutorFee");
519         require(!delegatedTxHashesUsed[txHash], "txHash already used");
520         delegatedTxHashesUsed[txHash] = true;
521 
522         address recovered = ECRecovery.recover(ECRecovery.toEthSignedMessageHash(txHash), signature);
523         require(recovered == signer, "invalid signature");
524 
525         _transfer(signer, msg.sender, requestedExecutorFeeInToken, "Delegated transfer fee", 0);
526     }
527 
528     function _transferFrom(address from, address to, uint256 amount, string narrative) private {
529         uint fee = feeAccount.calculateTransferFee(from, to, amount);
530         uint amountWithFee = amount.add(fee);
531 
532         /* NB: fee is deducted from owner, so transferFrom could fail
533             if amount + fee is not available on owner balance, or allowance */
534         require(balances[from] >= amountWithFee, "balance must be >= amount + fee");
535         require(allowed[from][msg.sender] >= amountWithFee, "allowance must be >= amount + fee");
536 
537         _transfer(from, to, amount, narrative, fee);
538 
539         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amountWithFee);
540     }
541 
542     function _transfer(address from, address to, uint transferAmount, string narrative) private {
543         uint fee = feeAccount.calculateTransferFee(from, to, transferAmount);
544         _transfer(from, to, transferAmount, narrative, fee);
545     }
546 
547     function _transfer(address from, address to, uint transferAmount, string narrative, uint fee) private {
548         require(to != 0x0, "to must be set");
549         uint amountWithFee = transferAmount.add(fee);
550         // to emit proper reason instead of failing on from.sub()
551         require(balances[from] >= amountWithFee, "balance must be >= amount + transfer fee");
552 
553         balances[from] = balances[from].sub(amountWithFee);
554         balances[to] = balances[to].add(transferAmount);
555 
556         emit Transfer(from, to, transferAmount);
557 
558         if (fee > 0) {
559             balances[feeAccount] = balances[feeAccount].add(fee);
560             emit Transfer(from, feeAccount, fee);
561         }
562 
563         emit AugmintTransfer(from, to, transferAmount, narrative, fee);
564     }
565 }
566 
567 // File: contracts/generic/SystemAccount.sol
568 
569 /* Contract to collect fees from system */
570 pragma solidity 0.4.24;
571 
572 
573 
574 
575 contract SystemAccount is Restricted {
576     event WithdrawFromSystemAccount(address tokenAddress, address to, uint tokenAmount, uint weiAmount,
577                                     string narrative);
578 
579     constructor(address permissionGranterContract)
580     public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
581 
582     function withdraw(AugmintToken tokenAddress, address to, uint tokenAmount, uint weiAmount, string narrative)
583     external restrict("StabilityBoard") {
584         tokenAddress.transferWithNarrative(to, tokenAmount, narrative);
585         if (weiAmount > 0) {
586             to.transfer(weiAmount);
587         }
588         emit WithdrawFromSystemAccount(tokenAddress, to, tokenAmount, weiAmount, narrative);
589     }
590 }
591 
592 // File: contracts/AugmintReserves.sol
593 
594 /* Contract to hold Augmint reserves (ETH & Token)
595     - ETH as regular ETH balance of the contract
596     - ERC20 token reserve (stored as regular Token balance under the contract address)
597 
598 NB: reserves are held under the contract address, therefore any transaction on the reserve is limited to the
599     tx-s defined here (i.e. transfer is not allowed even by the contract owner or StabilityBoard or MonetarySupervisor)
600 
601  */
602 
603 pragma solidity 0.4.24;
604 
605 
606 
607 
608 contract AugmintReserves is Restricted {
609 
610     event ReserveMigration(address to, uint weiAmount);
611 
612     constructor(address permissionGranterContract)
613     public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
614 
615     function () external payable { // solhint-disable-line no-empty-blocks
616         // to accept ETH sent into reserve (from defaulted loan's collateral )
617     }
618 
619     function burn(AugmintTokenInterface augmintToken, uint amount)
620     external restrict("MonetarySupervisor") {
621         augmintToken.burn(amount);
622     }
623 
624     function migrate(address to, uint weiAmount)
625     external restrict("StabilityBoard") {
626         if (weiAmount > 0) {
627             to.transfer(weiAmount);
628         }
629         emit ReserveMigration(to, weiAmount);
630     }
631 }
632 
633 // File: contracts/InterestEarnedAccount.sol
634 
635 /* Contract to hold earned interest from loans repaid
636    premiums for locks are being accrued (i.e. transferred) to Locker */
637 
638 pragma solidity 0.4.24;
639 
640 
641 
642 
643 contract InterestEarnedAccount is SystemAccount {
644 
645     constructor(address permissionGranterContract) public SystemAccount(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
646 
647     function transferInterest(AugmintTokenInterface augmintToken, address locker, uint interestAmount)
648     external restrict("MonetarySupervisor") {
649         augmintToken.transfer(locker, interestAmount);
650     }
651 
652 }
653 
654 // File: contracts/MonetarySupervisor.sol
655 
656 /* MonetarySupervisor
657     - maintains system wide KPIs (eg totalLockAmount, totalLoanAmount)
658     - holds system wide parameters/limits
659     - enforces system wide limits
660     - burns and issues to AugmintReserves
661     - Send funds from reserve to exchange when intervening (not implemented yet)
662     - Converts older versions of AugmintTokens in 1:1 to new
663 */
664 
665 pragma solidity 0.4.24;
666 
667 
668 
669 
670 
671 
672 
673 
674 contract MonetarySupervisor is Restricted, TokenReceiver { // solhint-disable-line no-empty-blocks
675     using SafeMath for uint256;
676 
677     uint public constant PERCENT_100 = 1000000;
678 
679     AugmintTokenInterface public augmintToken;
680     InterestEarnedAccount public interestEarnedAccount;
681     AugmintReserves public augmintReserves;
682 
683     uint public issuedByStabilityBoard; // token issued by Stability Board
684     uint public burnedByStabilityBoard; // token burned by Stability Board
685 
686     uint public totalLoanAmount; // total amount of all loans without interest, in token
687     uint public totalLockedAmount; // total amount of all locks without premium, in token
688 
689     /**********
690         Parameters to ensure totalLoanAmount or totalLockedAmount difference is within limits and system also works
691         when total loan or lock amounts are low.
692             for test calculations: https://docs.google.com/spreadsheets/d/1MeWYPYZRIm1n9lzpvbq8kLfQg1hhvk5oJY6NrR401S0
693     **********/
694     struct LtdParams {
695         uint  lockDifferenceLimit; /* only allow a new lock if Loan To Deposit ratio would stay above
696                                             (1 - lockDifferenceLimit) with new lock. Stored as parts per million */
697         uint  loanDifferenceLimit; /* only allow a new loan if Loan To Deposit ratio would stay above
698                                             (1 + loanDifferenceLimit) with new loan. Stored as parts per million */
699         /* allowedDifferenceAmount param is to ensure the system is not "freezing" when totalLoanAmount or
700             totalLockAmount is low.
701         It allows a new loan or lock (up to an amount to reach this difference) even if LTD will go below / above
702             lockDifferenceLimit / loanDifferenceLimit with the new lock/loan */
703         uint  allowedDifferenceAmount;
704     }
705 
706     LtdParams public ltdParams;
707 
708     /* Previously deployed AugmintTokens which are accepted for conversion (see transferNotification() )
709         NB: it's not iterable so old version addresses needs to be added for UI manually after each deploy */
710     mapping(address => bool) public acceptedLegacyAugmintTokens;
711 
712     event LtdParamsChanged(uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount);
713 
714     event AcceptedLegacyAugmintTokenChanged(address augmintTokenAddress, bool newAcceptedState);
715 
716     event LegacyTokenConverted(address oldTokenAddress, address account, uint amount);
717 
718     event KPIsAdjusted(uint totalLoanAmountAdjustment, uint totalLockedAmountAdjustment);
719 
720     event SystemContractsChanged(InterestEarnedAccount newInterestEarnedAccount, AugmintReserves newAugmintReserves);
721 
722     constructor(address permissionGranterContract, AugmintTokenInterface _augmintToken,
723         AugmintReserves _augmintReserves, InterestEarnedAccount _interestEarnedAccount,
724         uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount)
725     public Restricted(permissionGranterContract) {
726         augmintToken = _augmintToken;
727         augmintReserves = _augmintReserves;
728         interestEarnedAccount = _interestEarnedAccount;
729 
730         ltdParams = LtdParams(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
731     }
732 
733     function issueToReserve(uint amount) external restrict("StabilityBoard") {
734         issuedByStabilityBoard = issuedByStabilityBoard.add(amount);
735         augmintToken.issueTo(augmintReserves, amount);
736     }
737 
738     function burnFromReserve(uint amount) external restrict("StabilityBoard") {
739         burnedByStabilityBoard = burnedByStabilityBoard.add(amount);
740         augmintReserves.burn(augmintToken, amount);
741     }
742 
743     /* Locker requesting interest when locking funds. Enforcing LTD to stay within range allowed by LTD params
744         NB: it does not know about min loan amount, it's the loan contract's responsibility to enforce it  */
745     function requestInterest(uint amountToLock, uint interestAmount) external {
746         // only whitelisted Locker
747         require(permissions[msg.sender]["Locker"], "msg.sender must have Locker permission");
748         require(amountToLock <= getMaxLockAmountAllowedByLtd(), "amountToLock must be <= maxLockAmountAllowedByLtd");
749 
750         totalLockedAmount = totalLockedAmount.add(amountToLock);
751         // next line would revert but require to emit reason:
752         require(augmintToken.balanceOf(address(interestEarnedAccount)) >= interestAmount,
753             "interestEarnedAccount balance must be >= interestAmount");
754         interestEarnedAccount.transferInterest(augmintToken, msg.sender, interestAmount); // transfer interest to Locker
755     }
756 
757     // Locker notifying when releasing funds to update KPIs
758     function releaseFundsNotification(uint lockedAmount) external {
759         // only whitelisted Locker
760         require(permissions[msg.sender]["Locker"], "msg.sender must have Locker permission");
761         totalLockedAmount = totalLockedAmount.sub(lockedAmount);
762     }
763 
764     /* Issue loan if LTD stays within range allowed by LTD params
765         NB: it does not know about min loan amount, it's the loan contract's responsibility to enforce it */
766     function issueLoan(address borrower, uint loanAmount) external {
767          // only whitelisted LoanManager contracts
768         require(permissions[msg.sender]["LoanManager"],
769             "msg.sender must have LoanManager permission");
770         require(loanAmount <= getMaxLoanAmountAllowedByLtd(), "loanAmount must be <= maxLoanAmountAllowedByLtd");
771         totalLoanAmount = totalLoanAmount.add(loanAmount);
772         augmintToken.issueTo(borrower, loanAmount);
773     }
774 
775     function loanRepaymentNotification(uint loanAmount) external {
776         // only whitelisted LoanManager contracts
777         require(permissions[msg.sender]["LoanManager"],
778             "msg.sender must have LoanManager permission");
779         totalLoanAmount = totalLoanAmount.sub(loanAmount);
780     }
781 
782     // NB: this is called by Lender contract with the sum of all loans collected in batch
783     function loanCollectionNotification(uint totalLoanAmountCollected) external {
784         // only whitelisted LoanManager contracts
785         require(permissions[msg.sender]["LoanManager"],
786             "msg.sender must have LoanManager permission");
787         totalLoanAmount = totalLoanAmount.sub(totalLoanAmountCollected);
788     }
789 
790     function setAcceptedLegacyAugmintToken(address legacyAugmintTokenAddress, bool newAcceptedState)
791     external restrict("StabilityBoard") {
792         acceptedLegacyAugmintTokens[legacyAugmintTokenAddress] = newAcceptedState;
793         emit AcceptedLegacyAugmintTokenChanged(legacyAugmintTokenAddress, newAcceptedState);
794     }
795 
796     function setLtdParams(uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount)
797     external restrict("StabilityBoard") {
798         ltdParams = LtdParams(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
799         emit LtdParamsChanged(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
800     }
801 
802     /* function to migrate old totalLoanAmount and totalLockedAmount from old monetarySupervisor contract
803         when it's upgraded.
804         Set new monetarySupervisor contract in all locker and loanManager contracts before executing this */
805     function adjustKPIs(uint totalLoanAmountAdjustment, uint totalLockedAmountAdjustment)
806     external restrict("StabilityBoard") {
807         totalLoanAmount = totalLoanAmount.add(totalLoanAmountAdjustment);
808         totalLockedAmount = totalLockedAmount.add(totalLockedAmountAdjustment);
809         emit KPIsAdjusted(totalLoanAmountAdjustment, totalLockedAmountAdjustment);
810     }
811 
812     /* to allow upgrades of InterestEarnedAccount and AugmintReserves contracts. */
813     function setSystemContracts(InterestEarnedAccount newInterestEarnedAccount, AugmintReserves newAugmintReserves)
814     external restrict("StabilityBoard") {
815         interestEarnedAccount = newInterestEarnedAccount;
816         augmintReserves = newAugmintReserves;
817         emit SystemContractsChanged(newInterestEarnedAccount, newAugmintReserves);
818     }
819 
820     /* User can request to convert their tokens from older AugmintToken versions in 1:1
821       transferNotification is called from AugmintToken's transferAndNotify
822      Flow for converting old tokens:
823         1) user calls old token contract's transferAndNotify with the amount to convert,
824                 addressing the new MonetarySupervisor Contract
825         2) transferAndNotify transfers user's old tokens to the current MonetarySupervisor contract's address
826         3) transferAndNotify calls MonetarySupervisor.transferNotification
827         4) MonetarySupervisor checks if old AugmintToken is permitted
828         5) MonetarySupervisor issues new tokens to user's account in current AugmintToken
829         6) MonetarySupervisor burns old tokens from own balance
830     */
831     function transferNotification(address from, uint amount, uint /* data, not used */ ) external {
832         AugmintTokenInterface legacyToken = AugmintTokenInterface(msg.sender);
833         require(acceptedLegacyAugmintTokens[legacyToken], "msg.sender must be allowed in acceptedLegacyAugmintTokens");
834 
835         legacyToken.burn(amount);
836         augmintToken.issueTo(from, amount);
837         emit LegacyTokenConverted(msg.sender, from, amount);
838     }
839 
840     /* Helper function for UI.
841         Returns max lock amount based on minLockAmount, interestPt, using LTD params & interestEarnedAccount balance */
842     function getMaxLockAmount(uint minLockAmount, uint interestPt) external view returns (uint maxLock) {
843         uint allowedByEarning = augmintToken.balanceOf(address(interestEarnedAccount)).mul(PERCENT_100).div(interestPt);
844         uint allowedByLtd = getMaxLockAmountAllowedByLtd();
845         maxLock = allowedByEarning < allowedByLtd ? allowedByEarning : allowedByLtd;
846         maxLock = maxLock < minLockAmount ? 0 : maxLock;
847     }
848 
849     /* Helper function for UI.
850         Returns max loan amount based on minLoanAmont using LTD params */
851     function getMaxLoanAmount(uint minLoanAmount) external view returns (uint maxLoan) {
852         uint allowedByLtd = getMaxLoanAmountAllowedByLtd();
853         maxLoan = allowedByLtd < minLoanAmount ? 0 : allowedByLtd;
854     }
855 
856     /* returns maximum lockable token amount allowed by LTD params. */
857     function getMaxLockAmountAllowedByLtd() public view returns(uint maxLockByLtd) {
858         uint allowedByLtdDifferencePt = totalLoanAmount.mul(PERCENT_100).div(PERCENT_100
859                                             .sub(ltdParams.lockDifferenceLimit));
860         allowedByLtdDifferencePt = totalLockedAmount >= allowedByLtdDifferencePt ?
861                                         0 : allowedByLtdDifferencePt.sub(totalLockedAmount);
862 
863         uint allowedByLtdDifferenceAmount =
864             totalLockedAmount >= totalLoanAmount.add(ltdParams.allowedDifferenceAmount) ?
865                 0 : totalLoanAmount.add(ltdParams.allowedDifferenceAmount).sub(totalLockedAmount);
866 
867         maxLockByLtd = allowedByLtdDifferencePt > allowedByLtdDifferenceAmount ?
868                                         allowedByLtdDifferencePt : allowedByLtdDifferenceAmount;
869     }
870 
871     /* returns maximum borrowable token amount allowed by LTD params */
872     function getMaxLoanAmountAllowedByLtd() public view returns(uint maxLoanByLtd) {
873         uint allowedByLtdDifferencePt = totalLockedAmount.mul(ltdParams.loanDifferenceLimit.add(PERCENT_100))
874                                             .div(PERCENT_100);
875         allowedByLtdDifferencePt = totalLoanAmount >= allowedByLtdDifferencePt ?
876                                         0 : allowedByLtdDifferencePt.sub(totalLoanAmount);
877 
878         uint allowedByLtdDifferenceAmount =
879             totalLoanAmount >= totalLockedAmount.add(ltdParams.allowedDifferenceAmount) ?
880                 0 : totalLockedAmount.add(ltdParams.allowedDifferenceAmount).sub(totalLoanAmount);
881 
882         maxLoanByLtd = allowedByLtdDifferencePt > allowedByLtdDifferenceAmount ?
883                                         allowedByLtdDifferencePt : allowedByLtdDifferenceAmount;
884     }
885 }
886 
887 // File: contracts/Rates.sol
888 
889 /*
890  Generic symbol / WEI rates contract.
891  only callable by trusted price oracles.
892  Being regularly called by a price oracle
893     TODO: trustless/decentrilezed price Oracle
894     TODO: shall we use blockNumber instead of now for lastUpdated?
895     TODO: consider if we need storing rates with variable decimals instead of fixed 4
896     TODO: could we emit 1 RateChanged event from setMultipleRates (symbols and newrates arrays)?
897 */
898 pragma solidity 0.4.24;
899 
900 
901 
902 
903 contract Rates is Restricted {
904     using SafeMath for uint256;
905 
906     struct RateInfo {
907         uint rate; // how much 1 WEI worth 1 unit , i.e. symbol/ETH rate
908                     // 0 rate means no rate info available
909         uint lastUpdated;
910     }
911 
912     // mapping currency symbol => rate. all rates are stored with 2 decimals. i.e. EUR/ETH = 989.12 then rate = 98912
913     mapping(bytes32 => RateInfo) public rates;
914 
915     event RateChanged(bytes32 symbol, uint newRate);
916 
917     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
918 
919     function setRate(bytes32 symbol, uint newRate) external restrict("RatesFeeder") {
920         rates[symbol] = RateInfo(newRate, now);
921         emit RateChanged(symbol, newRate);
922     }
923 
924     function setMultipleRates(bytes32[] symbols, uint[] newRates) external restrict("RatesFeeder") {
925         require(symbols.length == newRates.length, "symobls and newRates lengths must be equal");
926         for (uint256 i = 0; i < symbols.length; i++) {
927             rates[symbols[i]] = RateInfo(newRates[i], now);
928             emit RateChanged(symbols[i], newRates[i]);
929         }
930     }
931 
932     function convertFromWei(bytes32 bSymbol, uint weiValue) external view returns(uint value) {
933         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
934         return weiValue.mul(rates[bSymbol].rate).roundedDiv(1000000000000000000);
935     }
936 
937     function convertToWei(bytes32 bSymbol, uint value) external view returns(uint weiValue) {
938         // next line would revert with div by zero but require to emit reason
939         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
940         /* TODO: can we make this not loosing max scale? */
941         return value.mul(1000000000000000000).roundedDiv(rates[bSymbol].rate);
942     }
943 
944 }
945 
946 // File: contracts/LoanManager.sol
947 
948 /*
949     Contract to manage Augmint token loan contracts backed by ETH
950     For flows see: https://github.com/Augmint/augmint-contracts/blob/master/docs/loanFlow.png
951 
952     TODO:
953         - create MonetarySupervisor interface and use it instead?
954         - make data arg generic bytes?
955         - make collect() run as long as gas provided allows
956 */
957 pragma solidity 0.4.24;
958 
959 
960 
961 
962 
963 
964 
965 contract LoanManager is Restricted, TokenReceiver {
966     using SafeMath for uint256;
967 
968     enum LoanState { Open, Repaid, Defaulted, Collected } // NB: Defaulted state is not stored, only getters calculate
969 
970     struct LoanProduct {
971         uint minDisbursedAmount; // 0: with decimals set in AugmintToken.decimals
972         uint32 term;            // 1
973         uint32 discountRate;    // 2: discountRate in parts per million , ie. 10,000 = 1%
974         uint32 collateralRatio; // 3: loan token amount / colleteral pegged ccy value
975                                 //      in parts per million , ie. 10,000 = 1%
976         uint32 defaultingFeePt; // 4: % of collateral in parts per million , ie. 50,000 = 5%
977         bool isActive;          // 5
978     }
979 
980     /* NB: we don't need to store loan parameters because loan products can't be altered (only disabled/enabled) */
981     struct LoanData {
982         uint collateralAmount; // 0
983         uint repaymentAmount; // 1
984         address borrower; // 2
985         uint32 productId; // 3
986         LoanState state; // 4
987         uint40 maturity; // 5
988     }
989 
990     LoanProduct[] public products;
991 
992     LoanData[] public loans;
993     mapping(address => uint[]) public accountLoans;  // owner account address =>  array of loan Ids
994 
995     Rates public rates; // instance of ETH/pegged currency rate provider contract
996     AugmintTokenInterface public augmintToken; // instance of token contract
997     MonetarySupervisor public monetarySupervisor;
998 
999     event NewLoan(uint32 productId, uint loanId, address indexed borrower, uint collateralAmount, uint loanAmount,
1000         uint repaymentAmount, uint40 maturity);
1001 
1002     event LoanProductActiveStateChanged(uint32 productId, bool newState);
1003 
1004     event LoanProductAdded(uint32 productId);
1005 
1006     event LoanRepayed(uint loanId, address borrower);
1007 
1008     event LoanCollected(uint loanId, address indexed borrower, uint collectedCollateral,
1009         uint releasedCollateral, uint defaultingFee);
1010 
1011     event SystemContractsChanged(Rates newRatesContract, MonetarySupervisor newMonetarySupervisor);
1012 
1013     constructor(address permissionGranterContract, AugmintTokenInterface _augmintToken,
1014                     MonetarySupervisor _monetarySupervisor, Rates _rates)
1015     public Restricted(permissionGranterContract) {
1016         augmintToken = _augmintToken;
1017         monetarySupervisor = _monetarySupervisor;
1018         rates = _rates;
1019     }
1020 
1021     function addLoanProduct(uint32 term, uint32 discountRate, uint32 collateralRatio, uint minDisbursedAmount,
1022                                 uint32 defaultingFeePt, bool isActive)
1023     external restrict("StabilityBoard") {
1024 
1025         uint _newProductId = products.push(
1026             LoanProduct(minDisbursedAmount, term, discountRate, collateralRatio, defaultingFeePt, isActive)
1027         ) - 1;
1028 
1029         uint32 newProductId = uint32(_newProductId);
1030         require(newProductId == _newProductId, "productId overflow");
1031 
1032         emit LoanProductAdded(newProductId);
1033     }
1034 
1035     function setLoanProductActiveState(uint32 productId, bool newState)
1036     external restrict ("StabilityBoard") {
1037         require(productId < products.length, "invalid productId"); // next line would revert but require to emit reason
1038         products[productId].isActive = newState;
1039         emit LoanProductActiveStateChanged(productId, newState);
1040     }
1041 
1042     function newEthBackedLoan(uint32 productId) external payable {
1043         require(productId < products.length, "invalid productId"); // next line would revert but require to emit reason
1044         LoanProduct storage product = products[productId];
1045         require(product.isActive, "product must be in active state"); // valid product
1046 
1047 
1048         // calculate loan values based on ETH sent in with Tx
1049         uint tokenValue = rates.convertFromWei(augmintToken.peggedSymbol(), msg.value);
1050         uint repaymentAmount = tokenValue.mul(product.collateralRatio).div(1000000);
1051 
1052         uint loanAmount;
1053         (loanAmount, ) = calculateLoanValues(product, repaymentAmount);
1054 
1055         require(loanAmount >= product.minDisbursedAmount, "loanAmount must be >= minDisbursedAmount");
1056 
1057         uint expiration = now.add(product.term);
1058         uint40 maturity = uint40(expiration);
1059         require(maturity == expiration, "maturity overflow");
1060 
1061         // Create new loan
1062         uint loanId = loans.push(LoanData(msg.value, repaymentAmount, msg.sender,
1063                                             productId, LoanState.Open, maturity)) - 1;
1064 
1065         // Store ref to new loan
1066         accountLoans[msg.sender].push(loanId);
1067 
1068         // Issue tokens and send to borrower
1069         monetarySupervisor.issueLoan(msg.sender, loanAmount);
1070 
1071         emit NewLoan(productId, loanId, msg.sender, msg.value, loanAmount, repaymentAmount, maturity);
1072     }
1073 
1074     /* repay loan, called from AugmintToken's transferAndNotify
1075      Flow for repaying loan:
1076         1) user calls token contract's transferAndNotify loanId passed in data arg
1077         2) transferAndNotify transfers tokens to the Lender contract
1078         3) transferAndNotify calls Lender.transferNotification with lockProductId
1079     */
1080     // from arg is not used as we allow anyone to repay a loan:
1081     function transferNotification(address, uint repaymentAmount, uint loanId) external {
1082         require(msg.sender == address(augmintToken), "msg.sender must be augmintToken");
1083 
1084         _repayLoan(loanId, repaymentAmount);
1085     }
1086 
1087     function collect(uint[] loanIds) external {
1088         /* when there are a lots of loans to be collected then
1089              the client need to call it in batches to make sure tx won't exceed block gas limit.
1090          Anyone can call it - can't cause harm as it only allows to collect loans which they are defaulted
1091          TODO: optimise defaulting fee calculations
1092         */
1093         uint totalLoanAmountCollected;
1094         uint totalCollateralToCollect;
1095         uint totalDefaultingFee;
1096         for (uint i = 0; i < loanIds.length; i++) {
1097             require(loanIds[i] < loans.length, "invalid loanId"); // next line would revert but require to emit reason
1098             LoanData storage loan = loans[loanIds[i]];
1099             require(loan.state == LoanState.Open, "loan state must be Open");
1100             require(now >= loan.maturity, "current time must be later than maturity");
1101             LoanProduct storage product = products[loan.productId];
1102 
1103             uint loanAmount;
1104             (loanAmount, ) = calculateLoanValues(product, loan.repaymentAmount);
1105 
1106             totalLoanAmountCollected = totalLoanAmountCollected.add(loanAmount);
1107 
1108             loan.state = LoanState.Collected;
1109 
1110             // send ETH collateral to augmintToken reserve
1111             uint defaultingFeeInToken = loan.repaymentAmount.mul(product.defaultingFeePt).div(1000000);
1112             uint defaultingFee = rates.convertToWei(augmintToken.peggedSymbol(), defaultingFeeInToken);
1113             uint targetCollection = rates.convertToWei(augmintToken.peggedSymbol(),
1114                     loan.repaymentAmount).add(defaultingFee);
1115 
1116             uint releasedCollateral;
1117             if (targetCollection < loan.collateralAmount) {
1118                 releasedCollateral = loan.collateralAmount.sub(targetCollection);
1119                 loan.borrower.transfer(releasedCollateral);
1120             }
1121             uint collateralToCollect = loan.collateralAmount.sub(releasedCollateral);
1122             if (defaultingFee >= collateralToCollect) {
1123                 defaultingFee = collateralToCollect;
1124                 collateralToCollect = 0;
1125             } else {
1126                 collateralToCollect = collateralToCollect.sub(defaultingFee);
1127             }
1128             totalDefaultingFee = totalDefaultingFee.add(defaultingFee);
1129 
1130             totalCollateralToCollect = totalCollateralToCollect.add(collateralToCollect);
1131 
1132             emit LoanCollected(loanIds[i], loan.borrower, collateralToCollect.add(defaultingFee),
1133                     releasedCollateral, defaultingFee);
1134         }
1135 
1136         if (totalCollateralToCollect > 0) {
1137             address(monetarySupervisor.augmintReserves()).transfer(totalCollateralToCollect);
1138         }
1139 
1140         if (totalDefaultingFee > 0) {
1141             address(augmintToken.feeAccount()).transfer(totalDefaultingFee);
1142         }
1143 
1144         monetarySupervisor.loanCollectionNotification(totalLoanAmountCollected);// update KPIs
1145 
1146     }
1147 
1148     /* to allow upgrade of Rates and MonetarySupervisor contracts */
1149     function setSystemContracts(Rates newRatesContract, MonetarySupervisor newMonetarySupervisor)
1150     external restrict("StabilityBoard") {
1151         rates = newRatesContract;
1152         monetarySupervisor = newMonetarySupervisor;
1153         emit SystemContractsChanged(newRatesContract, newMonetarySupervisor);
1154     }
1155 
1156     function getProductCount() external view returns (uint) {
1157         return products.length;
1158     }
1159 
1160     // returns <chunkSize> loan products starting from some <offset>:
1161     // [ productId, minDisbursedAmount, term, discountRate, collateralRatio, defaultingFeePt, maxLoanAmount, isActive ]
1162     function getProducts(uint offset, uint16 chunkSize)
1163     external view returns (uint[8][]) {
1164         uint limit = SafeMath.min(offset.add(chunkSize), products.length);
1165         uint[8][] memory response = new uint[8][](limit.sub(offset));
1166 
1167         for (uint i = offset; i < limit; i++) {
1168             LoanProduct storage product = products[i];
1169             response[i - offset] = [i, product.minDisbursedAmount, product.term, product.discountRate,
1170                     product.collateralRatio, product.defaultingFeePt,
1171                     monetarySupervisor.getMaxLoanAmount(product.minDisbursedAmount), product.isActive ? 1 : 0 ];
1172         }
1173         return response;
1174     }
1175 
1176     function getLoanCount() external view returns (uint) {
1177         return loans.length;
1178     }
1179 
1180     /* returns <chunkSize> loans starting from some <offset>. Loans data encoded as:
1181         [loanId, collateralAmount, repaymentAmount, borrower, productId,
1182               state, maturity, disbursementTime, loanAmount, interestAmount] */
1183     function getLoans(uint offset, uint16 chunkSize)
1184     external view returns (uint[10][]) {
1185         uint limit = SafeMath.min(offset.add(chunkSize), loans.length);
1186         uint[10][] memory response = new uint[10][](limit.sub(offset));
1187 
1188         for (uint i = offset; i < limit; i++) {
1189             response[i - offset] = getLoanTuple(i);
1190         }
1191         return response;
1192     }
1193 
1194     function getLoanCountForAddress(address borrower) external view returns (uint) {
1195         return accountLoans[borrower].length;
1196     }
1197 
1198     /* returns <chunkSize> loans of a given account, starting from some <offset>. Loans data encoded as:
1199         [loanId, collateralAmount, repaymentAmount, borrower, productId, state, maturity, disbursementTime,
1200                                                                                     loanAmount, interestAmount ] */
1201     function getLoansForAddress(address borrower, uint offset, uint16 chunkSize)
1202     external view returns (uint[10][]) {
1203         uint[] storage loansForAddress = accountLoans[borrower];
1204         uint limit = SafeMath.min(offset.add(chunkSize), loansForAddress.length);
1205         uint[10][] memory response = new uint[10][](limit.sub(offset));
1206 
1207         for (uint i = offset; i < limit; i++) {
1208             response[i - offset] = getLoanTuple(loansForAddress[i]);
1209         }
1210         return response;
1211     }
1212 
1213     function getLoanTuple(uint loanId) public view returns (uint[10] result) {
1214         require(loanId < loans.length, "invalid loanId"); // next line would revert but require to emit reason
1215         LoanData storage loan = loans[loanId];
1216         LoanProduct storage product = products[loan.productId];
1217 
1218         uint loanAmount;
1219         uint interestAmount;
1220         (loanAmount, interestAmount) = calculateLoanValues(product, loan.repaymentAmount);
1221         uint disbursementTime = loan.maturity - product.term;
1222 
1223         LoanState loanState =
1224                 loan.state == LoanState.Open && now >= loan.maturity ? LoanState.Defaulted : loan.state;
1225 
1226         result = [loanId, loan.collateralAmount, loan.repaymentAmount, uint(loan.borrower),
1227                 loan.productId, uint(loanState), loan.maturity, disbursementTime, loanAmount, interestAmount];
1228     }
1229 
1230     function calculateLoanValues(LoanProduct storage product, uint repaymentAmount)
1231     internal view returns (uint loanAmount, uint interestAmount) {
1232         // calculate loan values based on repayment amount
1233         loanAmount = repaymentAmount.mul(product.discountRate).div(1000000);
1234         interestAmount = loanAmount > repaymentAmount ? 0 : repaymentAmount.sub(loanAmount);
1235     }
1236 
1237     /* internal function, assuming repayment amount already transfered  */
1238     function _repayLoan(uint loanId, uint repaymentAmount) internal {
1239         require(loanId < loans.length, "invalid loanId"); // next line would revert but require to emit reason
1240         LoanData storage loan = loans[loanId];
1241         require(loan.state == LoanState.Open, "loan state must be Open");
1242         require(repaymentAmount == loan.repaymentAmount, "repaymentAmount must be equal to tokens sent");
1243         require(now <= loan.maturity, "current time must be earlier than maturity");
1244 
1245         LoanProduct storage product = products[loan.productId];
1246         uint loanAmount;
1247         uint interestAmount;
1248         (loanAmount, interestAmount) = calculateLoanValues(product, loan.repaymentAmount);
1249 
1250         loans[loanId].state = LoanState.Repaid;
1251 
1252         if (interestAmount > 0) {
1253             augmintToken.transfer(monetarySupervisor.interestEarnedAccount(), interestAmount);
1254             augmintToken.burn(loanAmount);
1255         } else {
1256             // negative or zero interest (i.e. discountRate >= 0)
1257             augmintToken.burn(repaymentAmount);
1258         }
1259 
1260         monetarySupervisor.loanRepaymentNotification(loanAmount); // update KPIs
1261 
1262         loan.borrower.transfer(loan.collateralAmount); // send back ETH collateral
1263 
1264         emit LoanRepayed(loanId, loan.borrower);
1265     }
1266 }