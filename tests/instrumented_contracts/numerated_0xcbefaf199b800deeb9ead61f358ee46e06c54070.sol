1 pragma solidity 0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b, "mul overflow");
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
17         uint256 c = a / b;
18         // require(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "sub underflow");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "add overflow");
30         return c;
31     }
32 
33     function roundedDiv(uint a, uint b) internal pure returns (uint256) {
34         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
35         uint256 z = a / b;
36         if (a % b >= b / 2) {
37             z++;  // no need for safe add b/c it can happen only if we divided the input
38         }
39         return z;
40     }
41 }
42 
43 /*
44     Generic contract to authorise calls to certain functions only from a given address.
45     The address authorised must be a contract (multisig or not, depending on the permission), except for local test
46 
47     deployment works as:
48            1. contract deployer account deploys contracts
49            2. constructor grants "PermissionGranter" permission to deployer account
50            3. deployer account executes initial setup (no multiSig)
51            4. deployer account grants PermissionGranter permission for the MultiSig contract
52                 (e.g. StabilityBoardProxy or PreTokenProxy)
53            5. deployer account revokes its own PermissionGranter permission
54 */
55 
56 contract Restricted {
57 
58     // NB: using bytes32 rather than the string type because it's cheaper gas-wise:
59     mapping (address => mapping (bytes32 => bool)) public permissions;
60 
61     event PermissionGranted(address indexed agent, bytes32 grantedPermission);
62     event PermissionRevoked(address indexed agent, bytes32 revokedPermission);
63 
64     modifier restrict(bytes32 requiredPermission) {
65         require(permissions[msg.sender][requiredPermission], "msg.sender must have permission");
66         _;
67     }
68 
69     constructor(address permissionGranterContract) public {
70         require(permissionGranterContract != address(0), "permissionGranterContract must be set");
71         permissions[permissionGranterContract]["PermissionGranter"] = true;
72         emit PermissionGranted(permissionGranterContract, "PermissionGranter");
73     }
74 
75     function grantPermission(address agent, bytes32 requiredPermission) public {
76         require(permissions[msg.sender]["PermissionGranter"],
77             "msg.sender must have PermissionGranter permission");
78         permissions[agent][requiredPermission] = true;
79         emit PermissionGranted(agent, requiredPermission);
80     }
81 
82     function grantMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
83         require(permissions[msg.sender]["PermissionGranter"],
84             "msg.sender must have PermissionGranter permission");
85         uint256 length = requiredPermissions.length;
86         for (uint256 i = 0; i < length; i++) {
87             grantPermission(agent, requiredPermissions[i]);
88         }
89     }
90 
91     function revokePermission(address agent, bytes32 requiredPermission) public {
92         require(permissions[msg.sender]["PermissionGranter"],
93             "msg.sender must have PermissionGranter permission");
94         permissions[agent][requiredPermission] = false;
95         emit PermissionRevoked(agent, requiredPermission);
96     }
97 
98     function revokeMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
99         uint256 length = requiredPermissions.length;
100         for (uint256 i = 0; i < length; i++) {
101             revokePermission(agent, requiredPermissions[i]);
102         }
103     }
104 
105 }
106 
107 
108 /**
109  * @title Eliptic curve signature operations
110  *
111  * @dev Based on https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ECRecovery.sol
112  *
113  * TODO Remove this library once solidity supports passing a signature to ecrecover.
114  * See https://github.com/ethereum/solidity/issues/864
115  *
116  */
117 
118 library ECRecovery {
119 
120   /**
121    * @dev Recover signer address from a message by using their signature
122    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
123    * @param sig bytes signature, the signature is generated using web3.eth.sign()
124    */
125   function recover(bytes32 hash, bytes sig)
126     internal
127     pure
128     returns (address)
129   {
130     bytes32 r;
131     bytes32 s;
132     uint8 v;
133 
134     // Check the signature length
135     if (sig.length != 65) {
136       return (address(0));
137     }
138 
139     // Divide the signature in r, s and v variables
140     // ecrecover takes the signature parameters, and the only way to get them
141     // currently is to use assembly.
142     // solium-disable-next-line security/no-inline-assembly
143     assembly {
144       r := mload(add(sig, 32))
145       s := mload(add(sig, 64))
146       v := byte(0, mload(add(sig, 96)))
147     }
148 
149     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
150     if (v < 27) {
151       v += 27;
152     }
153 
154     // If the version is correct return the signer address
155     if (v != 27 && v != 28) {
156       return (address(0));
157     } else {
158       // solium-disable-next-line arg-overflow
159       return ecrecover(hash, v, r, s);
160     }
161   }
162 
163   /**
164    * toEthSignedMessageHash
165    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
166    * @dev and hash the result
167    */
168   function toEthSignedMessageHash(bytes32 hash)
169     internal
170     pure
171     returns (bytes32)
172   {
173     // 32 is the length in bytes of hash,
174     // enforced by the type signature above
175     return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
176   }
177 }
178 
179 
180 interface ERC20Interface {
181     event Approval(address indexed _owner, address indexed _spender, uint _value);
182     event Transfer(address indexed from, address indexed to, uint amount);
183 
184     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
185     function transferFrom(address from, address to, uint value) external returns (bool);
186     function approve(address spender, uint value) external returns (bool);
187     function balanceOf(address who) external view returns (uint);
188     function allowance(address _owner, address _spender) external view returns (uint remaining);
189 
190 }
191 
192 interface TokenReceiver {
193     function transferNotification(address from, uint256 amount, uint data) external;
194 }
195 
196 
197 contract AugmintTokenInterface is Restricted, ERC20Interface {
198     using SafeMath for uint256;
199 
200     string public name;
201     string public symbol;
202     bytes32 public peggedSymbol;
203     uint8 public decimals;
204 
205     uint public totalSupply;
206     mapping(address => uint256) public balances; // Balances for each account
207     mapping(address => mapping (address => uint256)) public allowed; // allowances added with approve()
208 
209     address public stabilityBoardProxy;
210     TransferFeeInterface public feeAccount;
211     mapping(bytes32 => bool) public delegatedTxHashesUsed; // record txHashes used by delegatedTransfer
212 
213     event TransferFeesChanged(uint transferFeePt, uint transferFeeMin, uint transferFeeMax);
214     event Transfer(address indexed from, address indexed to, uint amount);
215     event AugmintTransfer(address indexed from, address indexed to, uint amount, string narrative, uint fee);
216     event TokenIssued(uint amount);
217     event TokenBurned(uint amount);
218     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
219 
220     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
221     function transferFrom(address from, address to, uint value) external returns (bool);
222     function approve(address spender, uint value) external returns (bool);
223 
224     function delegatedTransfer(address from, address to, uint amount, string narrative,
225                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
226                                     bytes32 nonce, /* random nonce generated by client */
227                                     /* ^^^^ end of signed data ^^^^ */
228                                     bytes signature,
229                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
230                                 ) external;
231 
232     function delegatedTransferAndNotify(address from, TokenReceiver target, uint amount, uint data,
233                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
234                                     bytes32 nonce, /* random nonce generated by client */
235                                     /* ^^^^ end of signed data ^^^^ */
236                                     bytes signature,
237                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
238                                 ) external;
239 
240     function increaseApproval(address spender, uint addedValue) external returns (bool);
241     function decreaseApproval(address spender, uint subtractedValue) external returns (bool);
242 
243     function issueTo(address to, uint amount) external; // restrict it to "MonetarySupervisor" in impl.;
244     function burn(uint amount) external;
245 
246     function transferAndNotify(TokenReceiver target, uint amount, uint data) external;
247 
248     function transferWithNarrative(address to, uint256 amount, string narrative) external;
249     function transferFromWithNarrative(address from, address to, uint256 amount, string narrative) external;
250 
251     function allowance(address owner, address spender) external view returns (uint256 remaining);
252 
253     function balanceOf(address who) external view returns (uint);
254 
255 
256 }
257 
258 interface TransferFeeInterface {
259     function calculateTransferFee(address from, address to, uint amount) external view returns (uint256 fee);
260 }
261 
262 
263 contract AugmintToken is AugmintTokenInterface {
264 
265     event FeeAccountChanged(TransferFeeInterface newFeeAccount);
266 
267     constructor(address permissionGranterContract, string _name, string _symbol, bytes32 _peggedSymbol, uint8 _decimals, TransferFeeInterface _feeAccount)
268     public Restricted(permissionGranterContract) {
269         require(_feeAccount != address(0), "feeAccount must be set");
270         require(bytes(_name).length > 0, "name must be set");
271         require(bytes(_symbol).length > 0, "symbol must be set");
272 
273         name = _name;
274         symbol = _symbol;
275         peggedSymbol = _peggedSymbol;
276         decimals = _decimals;
277 
278         feeAccount = _feeAccount;
279 
280     }
281     function transfer(address to, uint256 amount) external returns (bool) {
282         _transfer(msg.sender, to, amount, "");
283         return true;
284     }
285 
286     /* Transfers based on an offline signed transfer instruction. */
287     function delegatedTransfer(address from, address to, uint amount, string narrative,
288                                      uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
289                                      bytes32 nonce, /* random nonce generated by client */
290                                      /* ^^^^ end of signed data ^^^^ */
291                                      bytes signature,
292                                      uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
293                                      )
294     external {
295         bytes32 txHash = keccak256(abi.encodePacked(this, from, to, amount, narrative, maxExecutorFeeInToken, nonce));
296 
297         _checkHashAndTransferExecutorFee(txHash, signature, from, maxExecutorFeeInToken, requestedExecutorFeeInToken);
298 
299         _transfer(from, to, amount, narrative);
300     }
301 
302     function approve(address _spender, uint256 amount) external returns (bool) {
303         require(_spender != 0x0, "spender must be set");
304         allowed[msg.sender][_spender] = amount;
305         emit Approval(msg.sender, _spender, amount);
306         return true;
307     }
308 
309     /**
310      ERC20 transferFrom attack protection: https://github.com/DecentLabs/dcm-poc/issues/57
311      approve should be called when allowed[_spender] == 0. To increment allowed value is better
312      to use this function to avoid 2 calls (and wait until the first transaction is mined)
313      Based on MonolithDAO Token.sol */
314     function increaseApproval(address _spender, uint _addedValue) external returns (bool) {
315         return _increaseApproval(msg.sender, _spender, _addedValue);
316     }
317 
318     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
319         uint oldValue = allowed[msg.sender][_spender];
320         if (_subtractedValue > oldValue) {
321             allowed[msg.sender][_spender] = 0;
322         } else {
323             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324         }
325         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326         return true;
327     }
328 
329     function transferFrom(address from, address to, uint256 amount) external returns (bool) {
330         _transferFrom(from, to, amount, "");
331         return true;
332     }
333 
334     // Issue tokens. See MonetarySupervisor but as a rule of thumb issueTo is only allowed:
335     //      - on new loan (by trusted Lender contracts)
336     //      - when converting old tokens using MonetarySupervisor
337     //      - strictly to reserve by Stability Board (via MonetarySupervisor)
338     function issueTo(address to, uint amount) external restrict("MonetarySupervisor") {
339         balances[to] = balances[to].add(amount);
340         totalSupply = totalSupply.add(amount);
341         emit Transfer(0x0, to, amount);
342         emit AugmintTransfer(0x0, to, amount, "", 0);
343     }
344 
345     // Burn tokens. Anyone can burn from its own account. YOLO.
346     // Used by to burn from Augmint reserve or by Lender contract after loan repayment
347     function burn(uint amount) external {
348         require(balances[msg.sender] >= amount, "balance must be >= amount");
349         balances[msg.sender] = balances[msg.sender].sub(amount);
350         totalSupply = totalSupply.sub(amount);
351         emit Transfer(msg.sender, 0x0, amount);
352         emit AugmintTransfer(msg.sender, 0x0, amount, "", 0);
353     }
354 
355     /* to upgrade feeAccount (eg. for fee calculation changes) */
356     function setFeeAccount(TransferFeeInterface newFeeAccount) external restrict("StabilityBoard") {
357         feeAccount = newFeeAccount;
358         emit FeeAccountChanged(newFeeAccount);
359     }
360 
361     /*  transferAndNotify can be used by contracts which require tokens to have only 1 tx (instead of approve + call)
362         Eg. repay loan, lock funds, token sell order on exchange
363         Reverts on failue:
364             - transfer fails
365             - if transferNotification fails (callee must revert on failure)
366             - if targetContract is an account or targetContract doesn't have neither transferNotification or fallback fx
367         TODO: make data param generic bytes (see receiver code attempt in Locker.transferNotification)
368     */
369     function transferAndNotify(TokenReceiver target, uint amount, uint data) external {
370         _transfer(msg.sender, target, amount, "");
371 
372         target.transferNotification(msg.sender, amount, data);
373     }
374 
375     /* transferAndNotify based on an  instruction signed offline  */
376     function delegatedTransferAndNotify(address from, TokenReceiver target, uint amount, uint data,
377                                      uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
378                                      bytes32 nonce, /* random nonce generated by client */
379                                      /* ^^^^ end of signed data ^^^^ */
380                                      bytes signature,
381                                      uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
382                                      )
383     external {
384         bytes32 txHash = keccak256(abi.encodePacked(this, from, target, amount, data, maxExecutorFeeInToken, nonce));
385 
386         _checkHashAndTransferExecutorFee(txHash, signature, from, maxExecutorFeeInToken, requestedExecutorFeeInToken);
387 
388         _transfer(from, target, amount, "");
389         target.transferNotification(from, amount, data);
390     }
391 
392 
393     function transferWithNarrative(address to, uint256 amount, string narrative) external {
394         _transfer(msg.sender, to, amount, narrative);
395     }
396 
397     function transferFromWithNarrative(address from, address to, uint256 amount, string narrative) external {
398         _transferFrom(from, to, amount, narrative);
399     }
400 
401     function balanceOf(address _owner) external view returns (uint256 balance) {
402         return balances[_owner];
403     }
404 
405     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
406         return allowed[_owner][_spender];
407     }
408 
409     function _checkHashAndTransferExecutorFee(bytes32 txHash, bytes signature, address signer,
410                                                 uint maxExecutorFeeInToken, uint requestedExecutorFeeInToken) private {
411         require(requestedExecutorFeeInToken <= maxExecutorFeeInToken, "requestedExecutorFee must be <= maxExecutorFee");
412         require(!delegatedTxHashesUsed[txHash], "txHash already used");
413         delegatedTxHashesUsed[txHash] = true;
414 
415         address recovered = ECRecovery.recover(ECRecovery.toEthSignedMessageHash(txHash), signature);
416         require(recovered == signer, "invalid signature");
417 
418         _transfer(signer, msg.sender, requestedExecutorFeeInToken, "Delegated transfer fee", 0);
419     }
420 
421     function _increaseApproval(address _approver, address _spender, uint _addedValue) private returns (bool) {
422         allowed[_approver][_spender] = allowed[_approver][_spender].add(_addedValue);
423         emit Approval(_approver, _spender, allowed[_approver][_spender]);
424     }
425 
426     function _transferFrom(address from, address to, uint256 amount, string narrative) private {
427         require(balances[from] >= amount, "balance must >= amount");
428         require(allowed[from][msg.sender] >= amount, "allowance must be >= amount");
429         // don't allow 0 transferFrom if no approval:
430         require(allowed[from][msg.sender] > 0, "allowance must be >= 0 even with 0 amount");
431 
432         /* NB: fee is deducted from owner. It can result that transferFrom of amount x to fail
433                 when x + fee is not availale on owner balance */
434         _transfer(from, to, amount, narrative);
435 
436         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
437     }
438 
439     function _transfer(address from, address to, uint transferAmount, string narrative) private {
440         uint fee = feeAccount.calculateTransferFee(from, to, transferAmount);
441 
442         _transfer(from, to, transferAmount, narrative, fee);
443     }
444 
445     function _transfer(address from, address to, uint transferAmount, string narrative, uint fee) private {
446         require(to != 0x0, "to must be set");
447         uint amountWithFee = transferAmount.add(fee);
448         // to emit proper reason instead of failing on from.sub()
449         require(balances[from] >= amountWithFee, "balance must be >= amount + transfer fee");
450 
451         if (fee > 0) {
452             balances[feeAccount] = balances[feeAccount].add(fee);
453             emit Transfer(from, feeAccount, fee);
454         }
455 
456         balances[from] = balances[from].sub(amountWithFee);
457         balances[to] = balances[to].add(transferAmount);
458 
459         emit Transfer(from, to, transferAmount);
460         emit AugmintTransfer(from, to, transferAmount, narrative, fee);
461     }
462 
463 }
464 
465 contract SystemAccount is Restricted {
466     event WithdrawFromSystemAccount(address tokenAddress, address to, uint tokenAmount, uint weiAmount,
467                                     string narrative);
468 
469     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
470 
471     /* TODO: this is only for first pilots to avoid funds stuck in contract due to bugs.
472       remove this function for higher volume pilots */
473     function withdraw(AugmintToken tokenAddress, address to, uint tokenAmount, uint weiAmount, string narrative)
474     external restrict("StabilityBoard") {
475         tokenAddress.transferWithNarrative(to, tokenAmount, narrative);
476         if (weiAmount > 0) {
477             to.transfer(weiAmount);
478         }
479 
480         emit WithdrawFromSystemAccount(tokenAddress, to, tokenAmount, weiAmount, narrative);
481     }
482 
483 }
484 
485 /* Contract to hold Augmint reserves (ETH & Token)
486     - ETH as regular ETH balance of the contract
487     - ERC20 token reserve (stored as regular Token balance under the contract address)
488 
489 NB: reserves are held under the contract address, therefore any transaction on the reserve is limited to the
490     tx-s defined here (i.e. transfer is not allowed even by the contract owner or StabilityBoard or MonetarySupervisor)
491 
492  */
493 contract AugmintReserves is SystemAccount {
494 
495     function () public payable { // solhint-disable-line no-empty-blocks
496         // to accept ETH sent into reserve (from defaulted loan's collateral )
497     }
498 
499     constructor(address permissionGranterContract) public SystemAccount(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
500 
501     function burn(AugmintTokenInterface augmintToken, uint amount) external restrict("MonetarySupervisor") {
502         augmintToken.burn(amount);
503     }
504 
505 }
506 
507 /* Contract to hold earned interest from loans repaid
508    premiums for locks are being accrued (i.e. transferred) to Locker */
509 contract InterestEarnedAccount is SystemAccount {
510 
511     constructor(address permissionGranterContract) public SystemAccount(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
512 
513     function transferInterest(AugmintTokenInterface augmintToken, address locker, uint interestAmount)
514     external restrict("MonetarySupervisor") {
515         augmintToken.transfer(locker, interestAmount);
516     }
517 
518 }
519 
520 
521 /* MonetarySupervisor
522     - maintains system wide KPIs (eg totalLockAmount, totalLoanAmount)
523     - holds system wide parameters/limits
524     - enforces system wide limits
525     - burns and issues to AugmintReserves
526     - Send funds from reserve to exchange when intervening (not implemented yet)
527     - Converts older versions of AugmintTokens in 1:1 to new
528 */
529 contract MonetarySupervisor is Restricted, TokenReceiver { // solhint-disable-line no-empty-blocks
530     using SafeMath for uint256;
531 
532     uint public constant PERCENT_100 = 1000000;
533 
534     AugmintTokenInterface public augmintToken;
535     InterestEarnedAccount public interestEarnedAccount;
536     AugmintReserves public augmintReserves;
537 
538     uint public issuedByStabilityBoard; // token issued  by Stability Board
539 
540     uint public totalLoanAmount; // total amount of all loans without interest, in token
541     uint public totalLockedAmount; // total amount of all locks without premium, in token
542 
543     /**********
544         Parameters to ensure totalLoanAmount or totalLockedAmount difference is within limits and system also works
545         when total loan or lock amounts are low.
546             for test calculations: https://docs.google.com/spreadsheets/d/1MeWYPYZRIm1n9lzpvbq8kLfQg1hhvk5oJY6NrR401S0
547     **********/
548     struct LtdParams {
549         uint  lockDifferenceLimit; /* only allow a new lock if Loan To Deposit ratio would stay above
550                                             (1 - lockDifferenceLimit) with new lock. Stored as parts per million */
551         uint  loanDifferenceLimit; /* only allow a new loan if Loan To Deposit ratio would stay above
552                                             (1 + loanDifferenceLimit) with new loan. Stored as parts per million */
553         /* allowedDifferenceAmount param is to ensure the system is not "freezing" when totalLoanAmount or
554             totalLockAmount is low.
555         It allows a new loan or lock (up to an amount to reach this difference) even if LTD will go below / above
556             lockDifferenceLimit / loanDifferenceLimit with the new lock/loan */
557         uint  allowedDifferenceAmount;
558     }
559 
560     LtdParams public ltdParams;
561 
562     /* Previously deployed AugmintTokens which are accepted for conversion (see transferNotification() )
563         NB: it's not iterable so old version addresses needs to be added for UI manually after each deploy */
564     mapping(address => bool) public acceptedLegacyAugmintTokens;
565 
566     event LtdParamsChanged(uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount);
567 
568     event AcceptedLegacyAugmintTokenChanged(address augmintTokenAddress, bool newAcceptedState);
569 
570     event LegacyTokenConverted(address oldTokenAddress, address account, uint amount);
571 
572     event KPIsAdjusted(uint totalLoanAmountAdjustment, uint totalLockedAmountAdjustment);
573 
574     event SystemContractsChanged(InterestEarnedAccount newInterestEarnedAccount, AugmintReserves newAugmintReserves);
575 
576     constructor(address permissionGranterContract, AugmintTokenInterface _augmintToken, AugmintReserves _augmintReserves,
577         InterestEarnedAccount _interestEarnedAccount,
578         uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount)
579     public Restricted(permissionGranterContract) {
580         augmintToken = _augmintToken;
581         augmintReserves = _augmintReserves;
582         interestEarnedAccount = _interestEarnedAccount;
583 
584         ltdParams = LtdParams(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
585     }
586 
587     function issueToReserve(uint amount) external restrict("StabilityBoard") {
588         issuedByStabilityBoard = issuedByStabilityBoard.add(amount);
589         augmintToken.issueTo(augmintReserves, amount);
590     }
591 
592     function burnFromReserve(uint amount) external restrict("StabilityBoard") {
593         issuedByStabilityBoard = issuedByStabilityBoard.sub(amount);
594         augmintReserves.burn(augmintToken, amount);
595     }
596 
597     /* Locker requesting interest when locking funds. Enforcing LTD to stay within range allowed by LTD params
598         NB: it does not know about min loan amount, it's the loan contract's responsibility to enforce it  */
599     function requestInterest(uint amountToLock, uint interestAmount) external {
600         // only whitelisted Locker
601         require(permissions[msg.sender]["Locker"], "msg.sender must have Locker permission");
602         require(amountToLock <= getMaxLockAmountAllowedByLtd(), "amountToLock must be <= maxLockAmountAllowedByLtd");
603 
604         totalLockedAmount = totalLockedAmount.add(amountToLock);
605         // next line would revert but require to emit reason:
606         require(augmintToken.balanceOf(address(interestEarnedAccount)) >= interestAmount,
607             "interestEarnedAccount balance must be >= interestAmount");
608         interestEarnedAccount.transferInterest(augmintToken, msg.sender, interestAmount); // transfer interest to Locker
609     }
610 
611     // Locker notifying when releasing funds to update KPIs
612     function releaseFundsNotification(uint lockedAmount) external {
613         // only whitelisted Locker
614         require(permissions[msg.sender]["Locker"], "msg.sender must have Locker permission");
615         totalLockedAmount = totalLockedAmount.sub(lockedAmount);
616     }
617 
618     /* Issue loan if LTD stays within range allowed by LTD params
619         NB: it does not know about min loan amount, it's the loan contract's responsibility to enforce it */
620     function issueLoan(address borrower, uint loanAmount) external {
621          // only whitelisted LoanManager contracts
622         require(permissions[msg.sender]["LoanManager"],
623             "msg.sender must have LoanManager permission");
624         require(loanAmount <= getMaxLoanAmountAllowedByLtd(), "loanAmount must be <= maxLoanAmountAllowedByLtd");
625         totalLoanAmount = totalLoanAmount.add(loanAmount);
626         augmintToken.issueTo(borrower, loanAmount);
627     }
628 
629     function loanRepaymentNotification(uint loanAmount) external {
630         // only whitelisted LoanManager contracts
631        require(permissions[msg.sender]["LoanManager"],
632            "msg.sender must have LoanManager permission");
633         totalLoanAmount = totalLoanAmount.sub(loanAmount);
634     }
635 
636     // NB: this is called by Lender contract with the sum of all loans collected in batch
637     function loanCollectionNotification(uint totalLoanAmountCollected) external {
638         // only whitelisted LoanManager contracts
639        require(permissions[msg.sender]["LoanManager"],
640            "msg.sender must have LoanManager permission");
641         totalLoanAmount = totalLoanAmount.sub(totalLoanAmountCollected);
642     }
643 
644     function setAcceptedLegacyAugmintToken(address legacyAugmintTokenAddress, bool newAcceptedState)
645     external restrict("StabilityBoard") {
646         acceptedLegacyAugmintTokens[legacyAugmintTokenAddress] = newAcceptedState;
647         emit AcceptedLegacyAugmintTokenChanged(legacyAugmintTokenAddress, newAcceptedState);
648     }
649 
650     function setLtdParams(uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount)
651     external restrict("StabilityBoard") {
652         ltdParams = LtdParams(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
653 
654         emit LtdParamsChanged(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
655     }
656 
657     /* function to migrate old totalLoanAmount and totalLockedAmount from old monetarySupervisor contract
658         when it's upgraded.
659         Set new monetarySupervisor contract in all locker and loanManager contracts before executing this */
660     function adjustKPIs(uint totalLoanAmountAdjustment, uint totalLockedAmountAdjustment)
661     external restrict("StabilityBoard") {
662         totalLoanAmount = totalLoanAmount.add(totalLoanAmountAdjustment);
663         totalLockedAmount = totalLockedAmount.add(totalLockedAmountAdjustment);
664 
665         emit KPIsAdjusted(totalLoanAmountAdjustment, totalLockedAmountAdjustment);
666     }
667 
668     /* to allow upgrades of InterestEarnedAccount and AugmintReserves contracts. */
669     function setSystemContracts(InterestEarnedAccount newInterestEarnedAccount, AugmintReserves newAugmintReserves)
670     external restrict("StabilityBoard") {
671         interestEarnedAccount = newInterestEarnedAccount;
672         augmintReserves = newAugmintReserves;
673         emit SystemContractsChanged(newInterestEarnedAccount, newAugmintReserves);
674     }
675 
676     /* User can request to convert their tokens from older AugmintToken versions in 1:1
677       transferNotification is called from AugmintToken's transferAndNotify
678      Flow for converting old tokens:
679         1) user calls old token contract's transferAndNotify with the amount to convert,
680                 addressing the new MonetarySupervisor Contract
681         2) transferAndNotify transfers user's old tokens to the current MonetarySupervisor contract's address
682         3) transferAndNotify calls MonetarySupervisor.transferNotification
683         4) MonetarySupervisor checks if old AugmintToken is permitted
684         5) MonetarySupervisor issues new tokens to user's account in current AugmintToken
685         6) MonetarySupervisor burns old tokens from own balance
686     */
687     function transferNotification(address from, uint amount, uint /* data, not used */ ) external {
688         AugmintTokenInterface legacyToken = AugmintTokenInterface(msg.sender);
689         require(acceptedLegacyAugmintTokens[legacyToken], "msg.sender must be allowed in acceptedLegacyAugmintTokens");
690 
691         legacyToken.burn(amount);
692         augmintToken.issueTo(from, amount);
693         emit LegacyTokenConverted(msg.sender, from, amount);
694     }
695 
696     function getLoanToDepositRatio() external view returns (uint loanToDepositRatio) {
697         loanToDepositRatio = totalLockedAmount == 0 ? 0 : totalLockedAmount.mul(PERCENT_100).div(totalLoanAmount);
698     }
699 
700     /* Helper function for UI.
701         Returns max lock amount based on minLockAmount, interestPt, using LTD params & interestEarnedAccount balance */
702     function getMaxLockAmount(uint minLockAmount, uint interestPt) external view returns (uint maxLock) {
703         uint allowedByEarning = augmintToken.balanceOf(address(interestEarnedAccount)).mul(PERCENT_100).div(interestPt);
704         uint allowedByLtd = getMaxLockAmountAllowedByLtd();
705         maxLock = allowedByEarning < allowedByLtd ? allowedByEarning : allowedByLtd;
706         maxLock = maxLock < minLockAmount ? 0 : maxLock;
707     }
708 
709     /* Helper function for UI.
710         Returns max loan amount based on minLoanAmont using LTD params */
711     function getMaxLoanAmount(uint minLoanAmount) external view returns (uint maxLoan) {
712         uint allowedByLtd = getMaxLoanAmountAllowedByLtd();
713         maxLoan = allowedByLtd < minLoanAmount ? 0 : allowedByLtd;
714     }
715 
716     /* returns maximum lockable token amount allowed by LTD params. */
717     function getMaxLockAmountAllowedByLtd() public view returns(uint maxLockByLtd) {
718         uint allowedByLtdDifferencePt = totalLoanAmount.mul(PERCENT_100).div(PERCENT_100
719                                             .sub(ltdParams.lockDifferenceLimit));
720         allowedByLtdDifferencePt = totalLockedAmount >= allowedByLtdDifferencePt ?
721                                         0 : allowedByLtdDifferencePt.sub(totalLockedAmount);
722 
723         uint allowedByLtdDifferenceAmount =
724             totalLockedAmount >= totalLoanAmount.add(ltdParams.allowedDifferenceAmount) ?
725                 0 : totalLoanAmount.add(ltdParams.allowedDifferenceAmount).sub(totalLockedAmount);
726 
727         maxLockByLtd = allowedByLtdDifferencePt > allowedByLtdDifferenceAmount ?
728                                         allowedByLtdDifferencePt : allowedByLtdDifferenceAmount;
729     }
730 
731     /* returns maximum borrowable token amount allowed by LTD params */
732     function getMaxLoanAmountAllowedByLtd() public view returns(uint maxLoanByLtd) {
733         uint allowedByLtdDifferencePt = totalLockedAmount.mul(ltdParams.loanDifferenceLimit.add(PERCENT_100))
734                                             .div(PERCENT_100);
735         allowedByLtdDifferencePt = totalLoanAmount >= allowedByLtdDifferencePt ?
736                                         0 : allowedByLtdDifferencePt.sub(totalLoanAmount);
737 
738         uint allowedByLtdDifferenceAmount =
739             totalLoanAmount >= totalLockedAmount.add(ltdParams.allowedDifferenceAmount) ?
740                 0 : totalLockedAmount.add(ltdParams.allowedDifferenceAmount).sub(totalLoanAmount);
741 
742         maxLoanByLtd = allowedByLtdDifferencePt > allowedByLtdDifferenceAmount ?
743                                         allowedByLtdDifferencePt : allowedByLtdDifferenceAmount;
744     }
745 
746 }
747 
748 /*
749  Generic symbol / WEI rates contract.
750  only callable by trusted price oracles.
751  Being regularly called by a price oracle
752 
753 */
754 
755 contract Rates is Restricted {
756     using SafeMath for uint256;
757 
758     struct RateInfo {
759         uint rate; // how much 1 WEI worth 1 unit , i.e. symbol/ETH rate
760                     // 0 rate means no rate info available
761         uint lastUpdated;
762     }
763 
764     // mapping currency symbol => rate. all rates are stored with 4 decimals. i.e. ETH/EUR = 989.12 then rate = 989,1200
765     mapping(bytes32 => RateInfo) public rates;
766 
767     event RateChanged(bytes32 symbol, uint newRate);
768 
769     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
770 
771     function setRate(bytes32 symbol, uint newRate) external restrict("RatesFeeder") {
772         rates[symbol] = RateInfo(newRate, now);
773         emit RateChanged(symbol, newRate);
774     }
775 
776     function setMultipleRates(bytes32[] symbols, uint[] newRates) external restrict("RatesFeeder") {
777         require(symbols.length == newRates.length, "symobls and newRates lengths must be equal");
778         for (uint256 i = 0; i < symbols.length; i++) {
779             rates[symbols[i]] = RateInfo(newRates[i], now);
780             emit RateChanged(symbols[i], newRates[i]);
781         }
782     }
783 
784     function convertFromWei(bytes32 bSymbol, uint weiValue) external view returns(uint value) {
785         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
786         return weiValue.mul(rates[bSymbol].rate).roundedDiv(1000000000000000000);
787     }
788 
789     function convertToWei(bytes32 bSymbol, uint value) external view returns(uint weiValue) {
790         // next line would revert with div by zero but require to emit reason
791         require(rates[bSymbol].rate > 0, "rates[bSymbol] must be > 0");
792         /* TODO: can we make this not loosing max scale? */
793         return value.mul(1000000000000000000).roundedDiv(rates[bSymbol].rate);
794     }
795 
796 }
797 
798 
799 /*
800     Contract to manage Augmint token loan contracts backed by ETH
801     For flows see: https://github.com/Augmint/augmint-contracts/blob/master/docs/loanFlow.png
802 */
803 contract LoanManager is Restricted {
804     using SafeMath for uint256;
805 
806     uint16 public constant CHUNK_SIZE = 100;
807 
808     enum LoanState { Open, Repaid, Defaulted, Collected } // NB: Defaulted state is not stored, only getters calculate
809 
810     struct LoanProduct {
811         uint minDisbursedAmount; // 0: with decimals set in AugmintToken.decimals
812         uint32 term;            // 1
813         uint32 discountRate;    // 2: discountRate in parts per million , ie. 10,000 = 1%
814         uint32 collateralRatio; // 3: loan token amount / colleteral pegged ccy value
815                                 //      in parts per million , ie. 10,000 = 1%
816         uint32 defaultingFeePt; // 4: % of collateral in parts per million , ie. 50,000 = 5%
817         bool isActive;          // 5
818     }
819 
820     /* NB: we don't need to store loan parameters because loan products can't be altered (only disabled/enabled) */
821     struct LoanData {
822         uint collateralAmount; // 0
823         uint repaymentAmount; // 1
824         address borrower; // 2
825         uint32 productId; // 3
826         LoanState state; // 4
827         uint40 maturity; // 5
828     }
829 
830     LoanProduct[] public products;
831 
832     LoanData[] public loans;
833     mapping(address => uint[]) public accountLoans;  // owner account address =>  array of loan Ids
834 
835     Rates public rates; // instance of ETH/pegged currency rate provider contract
836     AugmintTokenInterface public augmintToken; // instance of token contract
837     MonetarySupervisor public monetarySupervisor;
838 
839     event NewLoan(uint32 productId, uint loanId, address indexed borrower, uint collateralAmount, uint loanAmount,
840         uint repaymentAmount, uint40 maturity);
841 
842     event LoanProductActiveStateChanged(uint32 productId, bool newState);
843 
844     event LoanProductAdded(uint32 productId);
845 
846     event LoanRepayed(uint loanId, address borrower);
847 
848     event LoanCollected(uint loanId, address indexed borrower, uint collectedCollateral,
849         uint releasedCollateral, uint defaultingFee);
850 
851     event SystemContractsChanged(Rates newRatesContract, MonetarySupervisor newMonetarySupervisor);
852 
853     constructor(address permissionGranterContract, AugmintTokenInterface _augmintToken,
854                     MonetarySupervisor _monetarySupervisor, Rates _rates)
855     public Restricted(permissionGranterContract) {
856         augmintToken = _augmintToken;
857         monetarySupervisor = _monetarySupervisor;
858         rates = _rates;
859     }
860 
861     function addLoanProduct(uint32 term, uint32 discountRate, uint32 collateralRatio, uint minDisbursedAmount,
862                                 uint32 defaultingFeePt, bool isActive)
863     external restrict("StabilityBoard") {
864 
865         uint _newProductId = products.push(
866             LoanProduct(minDisbursedAmount, term, discountRate, collateralRatio, defaultingFeePt, isActive)
867         ) - 1;
868 
869         uint32 newProductId = uint32(_newProductId);
870         require(newProductId == _newProductId, "productId overflow");
871 
872         emit LoanProductAdded(newProductId);
873     }
874 
875     function setLoanProductActiveState(uint32 productId, bool newState)
876     external restrict ("StabilityBoard") {
877         require(productId < products.length, "invalid productId"); // next line would revert but require to emit reason
878         products[productId].isActive = false;
879         emit LoanProductActiveStateChanged(productId, newState);
880     }
881 
882     function newEthBackedLoan(uint32 productId) external payable {
883         require(productId < products.length, "invalid productId"); // next line would revert but require to emit reason
884         LoanProduct storage product = products[productId];
885         require(product.isActive, "product must be in active state"); // valid product
886 
887 
888         // calculate loan values based on ETH sent in with Tx
889         uint tokenValue = rates.convertFromWei(augmintToken.peggedSymbol(), msg.value);
890         uint repaymentAmount = tokenValue.mul(product.collateralRatio).div(1000000);
891 
892         uint loanAmount;
893         (loanAmount, ) = calculateLoanValues(product, repaymentAmount);
894 
895         require(loanAmount >= product.minDisbursedAmount, "loanAmount must be >= minDisbursedAmount");
896 
897         uint expiration = now.add(product.term);
898         uint40 maturity = uint40(expiration);
899         require(maturity == expiration, "maturity overflow");
900 
901         // Create new loan
902         uint loanId = loans.push(LoanData(msg.value, repaymentAmount, msg.sender,
903                                             productId, LoanState.Open, maturity)) - 1;
904 
905         // Store ref to new loan
906         accountLoans[msg.sender].push(loanId);
907 
908         // Issue tokens and send to borrower
909         monetarySupervisor.issueLoan(msg.sender, loanAmount);
910 
911         emit NewLoan(productId, loanId, msg.sender, msg.value, loanAmount, repaymentAmount, maturity);
912     }
913 
914     /* repay loan, called from AugmintToken's transferAndNotify
915      Flow for repaying loan:
916         1) user calls token contract's transferAndNotify loanId passed in data arg
917         2) transferAndNotify transfers tokens to the Lender contract
918         3) transferAndNotify calls Lender.transferNotification with lockProductId
919     */
920     // from arg is not used as we allow anyone to repay a loan:
921     function transferNotification(address, uint repaymentAmount, uint loanId) external {
922         require(msg.sender == address(augmintToken), "msg.sender must be augmintToken");
923 
924         _repayLoan(loanId, repaymentAmount);
925     }
926 
927     function collect(uint[] loanIds) external {
928         /* when there are a lots of loans to be collected then
929              the client need to call it in batches to make sure tx won't exceed block gas limit.
930          Anyone can call it - can't cause harm as it only allows to collect loans which they are defaulted
931          TODO: optimise defaulting fee calculations
932         */
933         uint totalLoanAmountCollected;
934         uint totalCollateralToCollect;
935         uint totalDefaultingFee;
936         for (uint i = 0; i < loanIds.length; i++) {
937             require(i < loans.length, "invalid loanId"); // next line would revert but require to emit reason
938             LoanData storage loan = loans[loanIds[i]];
939             require(loan.state == LoanState.Open, "loan state must be Open");
940             require(now >= loan.maturity, "current time must be later than maturity");
941             LoanProduct storage product = products[loan.productId];
942 
943             uint loanAmount;
944             (loanAmount, ) = calculateLoanValues(product, loan.repaymentAmount);
945 
946             totalLoanAmountCollected = totalLoanAmountCollected.add(loanAmount);
947 
948             loan.state = LoanState.Collected;
949 
950             // send ETH collateral to augmintToken reserve
951             uint defaultingFeeInToken = loan.repaymentAmount.mul(product.defaultingFeePt).div(1000000);
952             uint defaultingFee = rates.convertToWei(augmintToken.peggedSymbol(), defaultingFeeInToken);
953             uint targetCollection = rates.convertToWei(augmintToken.peggedSymbol(),
954                                                             loan.repaymentAmount).add(defaultingFee);
955 
956             uint releasedCollateral;
957             if (targetCollection < loan.collateralAmount) {
958                 releasedCollateral = loan.collateralAmount.sub(targetCollection);
959                 loan.borrower.transfer(releasedCollateral);
960             }
961             uint collateralToCollect = loan.collateralAmount.sub(releasedCollateral);
962             if (defaultingFee >= collateralToCollect) {
963                 defaultingFee = collateralToCollect;
964                 collateralToCollect = 0;
965             } else {
966                 collateralToCollect = collateralToCollect.sub(defaultingFee);
967             }
968             totalDefaultingFee = totalDefaultingFee.add(defaultingFee);
969 
970             totalCollateralToCollect = totalCollateralToCollect.add(collateralToCollect);
971 
972             emit LoanCollected(loanIds[i], loan.borrower, collateralToCollect.add(defaultingFee), releasedCollateral, defaultingFee);
973         }
974 
975         if (totalCollateralToCollect > 0) {
976             address(monetarySupervisor.augmintReserves()).transfer(totalCollateralToCollect);
977         }
978 
979         if (totalDefaultingFee > 0){
980             address(augmintToken.feeAccount()).transfer(totalDefaultingFee);
981         }
982 
983         monetarySupervisor.loanCollectionNotification(totalLoanAmountCollected);// update KPIs
984 
985     }
986 
987     /* to allow upgrade of Rates and MonetarySupervisor contracts */
988     function setSystemContracts(Rates newRatesContract, MonetarySupervisor newMonetarySupervisor)
989     external restrict("StabilityBoard") {
990         rates = newRatesContract;
991         monetarySupervisor = newMonetarySupervisor;
992         emit SystemContractsChanged(newRatesContract, newMonetarySupervisor);
993     }
994 
995     function getProductCount() external view returns (uint ct) {
996         return products.length;
997     }
998 
999     // returns CHUNK_SIZE loan products starting from some offset:
1000     // [ productId, minDisbursedAmount, term, discountRate, collateralRatio, defaultingFeePt, maxLoanAmount, isActive ]
1001     function getProducts(uint offset) external view returns (uint[8][CHUNK_SIZE] response) {
1002 
1003         for (uint16 i = 0; i < CHUNK_SIZE; i++) {
1004 
1005             if (offset + i >= products.length) { break; }
1006 
1007             LoanProduct storage product = products[offset + i];
1008 
1009             response[i] = [offset + i, product.minDisbursedAmount, product.term, product.discountRate,
1010                             product.collateralRatio, product.defaultingFeePt,
1011                             monetarySupervisor.getMaxLoanAmount(product.minDisbursedAmount), product.isActive ? 1 : 0 ];
1012         }
1013     }
1014 
1015     function getLoanCount() external view returns (uint ct) {
1016         return loans.length;
1017     }
1018 
1019     /* returns CHUNK_SIZE loans starting from some offset. Loans data encoded as:
1020         [loanId, collateralAmount, repaymentAmount, borrower, productId, state, maturity, disbursementTime,
1021                                                                                     loanAmount, interestAmount ]   */
1022     function getLoans(uint offset) external view returns (uint[10][CHUNK_SIZE] response) {
1023 
1024         for (uint16 i = 0; i < CHUNK_SIZE; i++) {
1025 
1026             if (offset + i >= loans.length) { break; }
1027 
1028             response[i] = getLoanTuple(offset + i);
1029         }
1030     }
1031 
1032     function getLoanCountForAddress(address borrower) external view returns (uint) {
1033         return accountLoans[borrower].length;
1034     }
1035 
1036     /* returns CHUNK_SIZE loans of a given account, starting from some offset. Loans data encoded as:
1037         [loanId, collateralAmount, repaymentAmount, borrower, productId, state, maturity, disbursementTime,
1038                                                                                     loanAmount, interestAmount ] */
1039     function getLoansForAddress(address borrower, uint offset) external view returns (uint[10][CHUNK_SIZE] response) {
1040 
1041         uint[] storage loansForAddress = accountLoans[borrower];
1042 
1043         for (uint16 i = 0; i < CHUNK_SIZE; i++) {
1044 
1045             if (offset + i >= loansForAddress.length) { break; }
1046 
1047             response[i] = getLoanTuple(loansForAddress[offset + i]);
1048         }
1049     }
1050 
1051     function getLoanTuple(uint loanId) public view returns (uint[10] result) {
1052         require(loanId < loans.length, "invalid loanId"); // next line would revert but require to emit reason
1053         LoanData storage loan = loans[loanId];
1054         LoanProduct storage product = products[loan.productId];
1055 
1056         uint loanAmount;
1057         uint interestAmount;
1058         (loanAmount, interestAmount) = calculateLoanValues(product, loan.repaymentAmount);
1059         uint disbursementTime = loan.maturity - product.term;
1060 
1061         LoanState loanState =
1062                         loan.state == LoanState.Open && now >= loan.maturity ? LoanState.Defaulted : loan.state;
1063 
1064         result = [loanId, loan.collateralAmount, loan.repaymentAmount, uint(loan.borrower),
1065                     loan.productId, uint(loanState), loan.maturity, disbursementTime, loanAmount, interestAmount];
1066     }
1067 
1068     function calculateLoanValues(LoanProduct storage product, uint repaymentAmount)
1069     internal view returns (uint loanAmount, uint interestAmount) {
1070         // calculate loan values based on repayment amount
1071         loanAmount = repaymentAmount.mul(product.discountRate).div(1000000);
1072         interestAmount = loanAmount > repaymentAmount ? 0 : repaymentAmount.sub(loanAmount);
1073     }
1074 
1075     /* internal function, assuming repayment amount already transfered  */
1076     function _repayLoan(uint loanId, uint repaymentAmount) internal {
1077         require(loanId < loans.length, "invalid loanId"); // next line would revert but require to emit reason
1078         LoanData storage loan = loans[loanId];
1079         require(loan.state == LoanState.Open, "loan state must be Open");
1080         require(repaymentAmount == loan.repaymentAmount, "repaymentAmount must be equal to tokens sent");
1081         require(now <= loan.maturity, "current time must be earlier than maturity");
1082 
1083         LoanProduct storage product = products[loan.productId];
1084         uint loanAmount;
1085         uint interestAmount;
1086         (loanAmount, interestAmount) = calculateLoanValues(product, loan.repaymentAmount);
1087 
1088         loans[loanId].state = LoanState.Repaid;
1089 
1090         if (interestAmount > 0) {
1091             augmintToken.transfer(monetarySupervisor.interestEarnedAccount(), interestAmount);
1092             augmintToken.burn(loanAmount);
1093         } else {
1094             // negative or zero interest (i.e. discountRate >= 0)
1095             augmintToken.burn(repaymentAmount);
1096         }
1097 
1098         monetarySupervisor.loanRepaymentNotification(loanAmount); // update KPIs
1099 
1100         loan.borrower.transfer(loan.collateralAmount); // send back ETH collateral
1101 
1102         emit LoanRepayed(loanId, loan.borrower);
1103     }
1104 
1105 }