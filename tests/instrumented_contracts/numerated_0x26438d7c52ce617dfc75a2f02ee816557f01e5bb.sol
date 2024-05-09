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
41 
42     // Always rounds up
43     function ceilDiv(uint a, uint b) internal pure returns (uint256) {
44         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
45         uint256 z = a / b;
46         if (a % b != 0) {
47             z++;  // no need for safe add b/c it can happen only if we divided the input
48         }
49         return z;
50     }
51 }
52 
53 /*
54     Generic contract to authorise calls to certain functions only from a given address.
55     The address authorised must be a contract (multisig or not, depending on the permission), except for local test
56 
57     deployment works as:
58            1. contract deployer account deploys contracts
59            2. constructor grants "PermissionGranter" permission to deployer account
60            3. deployer account executes initial setup (no multiSig)
61            4. deployer account grants PermissionGranter permission for the MultiSig contract
62                 (e.g. StabilityBoardProxy or PreTokenProxy)
63            5. deployer account revokes its own PermissionGranter permission
64 */
65 
66 contract Restricted {
67 
68     // NB: using bytes32 rather than the string type because it's cheaper gas-wise:
69     mapping (address => mapping (bytes32 => bool)) public permissions;
70 
71     event PermissionGranted(address indexed agent, bytes32 grantedPermission);
72     event PermissionRevoked(address indexed agent, bytes32 revokedPermission);
73 
74     modifier restrict(bytes32 requiredPermission) {
75         require(permissions[msg.sender][requiredPermission], "msg.sender must have permission");
76         _;
77     }
78 
79     constructor(address permissionGranterContract) public {
80         require(permissionGranterContract != address(0), "permissionGranterContract must be set");
81         permissions[permissionGranterContract]["PermissionGranter"] = true;
82         emit PermissionGranted(permissionGranterContract, "PermissionGranter");
83     }
84 
85     function grantPermission(address agent, bytes32 requiredPermission) public {
86         require(permissions[msg.sender]["PermissionGranter"],
87             "msg.sender must have PermissionGranter permission");
88         permissions[agent][requiredPermission] = true;
89         emit PermissionGranted(agent, requiredPermission);
90     }
91 
92     function grantMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
93         require(permissions[msg.sender]["PermissionGranter"],
94             "msg.sender must have PermissionGranter permission");
95         uint256 length = requiredPermissions.length;
96         for (uint256 i = 0; i < length; i++) {
97             grantPermission(agent, requiredPermissions[i]);
98         }
99     }
100 
101     function revokePermission(address agent, bytes32 requiredPermission) public {
102         require(permissions[msg.sender]["PermissionGranter"],
103             "msg.sender must have PermissionGranter permission");
104         permissions[agent][requiredPermission] = false;
105         emit PermissionRevoked(agent, requiredPermission);
106     }
107 
108     function revokeMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
109         uint256 length = requiredPermissions.length;
110         for (uint256 i = 0; i < length; i++) {
111             revokePermission(agent, requiredPermissions[i]);
112         }
113     }
114 
115 }
116 
117 
118 /**
119  * @title Eliptic curve signature operations
120  *
121  * @dev Based on https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ECRecovery.sol
122  *
123  * TODO Remove this library once solidity supports passing a signature to ecrecover.
124  * See https://github.com/ethereum/solidity/issues/864
125  *
126  */
127 
128 library ECRecovery {
129 
130   /**
131    * @dev Recover signer address from a message by using their signature
132    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
133    * @param sig bytes signature, the signature is generated using web3.eth.sign()
134    */
135   function recover(bytes32 hash, bytes sig)
136     internal
137     pure
138     returns (address)
139   {
140     bytes32 r;
141     bytes32 s;
142     uint8 v;
143 
144     // Check the signature length
145     if (sig.length != 65) {
146       return (address(0));
147     }
148 
149     // Divide the signature in r, s and v variables
150     // ecrecover takes the signature parameters, and the only way to get them
151     // currently is to use assembly.
152     // solium-disable-next-line security/no-inline-assembly
153     assembly {
154       r := mload(add(sig, 32))
155       s := mload(add(sig, 64))
156       v := byte(0, mload(add(sig, 96)))
157     }
158 
159     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
160     if (v < 27) {
161       v += 27;
162     }
163 
164     // If the version is correct return the signer address
165     if (v != 27 && v != 28) {
166       return (address(0));
167     } else {
168       // solium-disable-next-line arg-overflow
169       return ecrecover(hash, v, r, s);
170     }
171   }
172 
173   /**
174    * toEthSignedMessageHash
175    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
176    * @dev and hash the result
177    */
178   function toEthSignedMessageHash(bytes32 hash)
179     internal
180     pure
181     returns (bytes32)
182   {
183     // 32 is the length in bytes of hash,
184     // enforced by the type signature above
185     return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
186   }
187 }
188 
189 
190 interface ERC20Interface {
191     event Approval(address indexed _owner, address indexed _spender, uint _value);
192     event Transfer(address indexed from, address indexed to, uint amount);
193 
194     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
195     function transferFrom(address from, address to, uint value) external returns (bool);
196     function approve(address spender, uint value) external returns (bool);
197     function balanceOf(address who) external view returns (uint);
198     function allowance(address _owner, address _spender) external view returns (uint remaining);
199 
200 }
201 
202 interface TokenReceiver {
203     function transferNotification(address from, uint256 amount, uint data) external;
204 }
205 
206 
207 contract AugmintTokenInterface is Restricted, ERC20Interface {
208     using SafeMath for uint256;
209 
210     string public name;
211     string public symbol;
212     bytes32 public peggedSymbol;
213     uint8 public decimals;
214 
215     uint public totalSupply;
216     mapping(address => uint256) public balances; // Balances for each account
217     mapping(address => mapping (address => uint256)) public allowed; // allowances added with approve()
218 
219     address public stabilityBoardProxy;
220     TransferFeeInterface public feeAccount;
221     mapping(bytes32 => bool) public delegatedTxHashesUsed; // record txHashes used by delegatedTransfer
222 
223     event TransferFeesChanged(uint transferFeePt, uint transferFeeMin, uint transferFeeMax);
224     event Transfer(address indexed from, address indexed to, uint amount);
225     event AugmintTransfer(address indexed from, address indexed to, uint amount, string narrative, uint fee);
226     event TokenIssued(uint amount);
227     event TokenBurned(uint amount);
228     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
229 
230     function transfer(address to, uint value) external returns (bool); // solhint-disable-line no-simple-event-func-name
231     function transferFrom(address from, address to, uint value) external returns (bool);
232     function approve(address spender, uint value) external returns (bool);
233 
234     function delegatedTransfer(address from, address to, uint amount, string narrative,
235                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
236                                     bytes32 nonce, /* random nonce generated by client */
237                                     /* ^^^^ end of signed data ^^^^ */
238                                     bytes signature,
239                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
240                                 ) external;
241 
242     function delegatedTransferAndNotify(address from, TokenReceiver target, uint amount, uint data,
243                                     uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
244                                     bytes32 nonce, /* random nonce generated by client */
245                                     /* ^^^^ end of signed data ^^^^ */
246                                     bytes signature,
247                                     uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
248                                 ) external;
249 
250     function increaseApproval(address spender, uint addedValue) external returns (bool);
251     function decreaseApproval(address spender, uint subtractedValue) external returns (bool);
252 
253     function issueTo(address to, uint amount) external; // restrict it to "MonetarySupervisor" in impl.;
254     function burn(uint amount) external;
255 
256     function transferAndNotify(TokenReceiver target, uint amount, uint data) external;
257 
258     function transferWithNarrative(address to, uint256 amount, string narrative) external;
259     function transferFromWithNarrative(address from, address to, uint256 amount, string narrative) external;
260 
261     function allowance(address owner, address spender) external view returns (uint256 remaining);
262 
263     function balanceOf(address who) external view returns (uint);
264 
265 
266 }
267 
268 interface TransferFeeInterface {
269     function calculateTransferFee(address from, address to, uint amount) external view returns (uint256 fee);
270 }
271 
272 
273 contract AugmintToken is AugmintTokenInterface {
274 
275     event FeeAccountChanged(TransferFeeInterface newFeeAccount);
276 
277     constructor(address permissionGranterContract, string _name, string _symbol, bytes32 _peggedSymbol, uint8 _decimals, TransferFeeInterface _feeAccount)
278     public Restricted(permissionGranterContract) {
279         require(_feeAccount != address(0), "feeAccount must be set");
280         require(bytes(_name).length > 0, "name must be set");
281         require(bytes(_symbol).length > 0, "symbol must be set");
282 
283         name = _name;
284         symbol = _symbol;
285         peggedSymbol = _peggedSymbol;
286         decimals = _decimals;
287 
288         feeAccount = _feeAccount;
289 
290     }
291     function transfer(address to, uint256 amount) external returns (bool) {
292         _transfer(msg.sender, to, amount, "");
293         return true;
294     }
295 
296     /* Transfers based on an offline signed transfer instruction. */
297     function delegatedTransfer(address from, address to, uint amount, string narrative,
298                                      uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
299                                      bytes32 nonce, /* random nonce generated by client */
300                                      /* ^^^^ end of signed data ^^^^ */
301                                      bytes signature,
302                                      uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
303                                      )
304     external {
305         bytes32 txHash = keccak256(abi.encodePacked(this, from, to, amount, narrative, maxExecutorFeeInToken, nonce));
306 
307         _checkHashAndTransferExecutorFee(txHash, signature, from, maxExecutorFeeInToken, requestedExecutorFeeInToken);
308 
309         _transfer(from, to, amount, narrative);
310     }
311 
312     function approve(address _spender, uint256 amount) external returns (bool) {
313         require(_spender != 0x0, "spender must be set");
314         allowed[msg.sender][_spender] = amount;
315         emit Approval(msg.sender, _spender, amount);
316         return true;
317     }
318 
319     /**
320      ERC20 transferFrom attack protection: https://github.com/DecentLabs/dcm-poc/issues/57
321      approve should be called when allowed[_spender] == 0. To increment allowed value is better
322      to use this function to avoid 2 calls (and wait until the first transaction is mined)
323      Based on MonolithDAO Token.sol */
324     function increaseApproval(address _spender, uint _addedValue) external returns (bool) {
325         return _increaseApproval(msg.sender, _spender, _addedValue);
326     }
327 
328     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
329         uint oldValue = allowed[msg.sender][_spender];
330         if (_subtractedValue > oldValue) {
331             allowed[msg.sender][_spender] = 0;
332         } else {
333             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
334         }
335         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336         return true;
337     }
338 
339     function transferFrom(address from, address to, uint256 amount) external returns (bool) {
340         _transferFrom(from, to, amount, "");
341         return true;
342     }
343 
344     // Issue tokens. See MonetarySupervisor but as a rule of thumb issueTo is only allowed:
345     //      - on new loan (by trusted Lender contracts)
346     //      - when converting old tokens using MonetarySupervisor
347     //      - strictly to reserve by Stability Board (via MonetarySupervisor)
348     function issueTo(address to, uint amount) external restrict("MonetarySupervisor") {
349         balances[to] = balances[to].add(amount);
350         totalSupply = totalSupply.add(amount);
351         emit Transfer(0x0, to, amount);
352         emit AugmintTransfer(0x0, to, amount, "", 0);
353     }
354 
355     // Burn tokens. Anyone can burn from its own account. YOLO.
356     // Used by to burn from Augmint reserve or by Lender contract after loan repayment
357     function burn(uint amount) external {
358         require(balances[msg.sender] >= amount, "balance must be >= amount");
359         balances[msg.sender] = balances[msg.sender].sub(amount);
360         totalSupply = totalSupply.sub(amount);
361         emit Transfer(msg.sender, 0x0, amount);
362         emit AugmintTransfer(msg.sender, 0x0, amount, "", 0);
363     }
364 
365     /* to upgrade feeAccount (eg. for fee calculation changes) */
366     function setFeeAccount(TransferFeeInterface newFeeAccount) external restrict("StabilityBoard") {
367         feeAccount = newFeeAccount;
368         emit FeeAccountChanged(newFeeAccount);
369     }
370 
371     /*  transferAndNotify can be used by contracts which require tokens to have only 1 tx (instead of approve + call)
372         Eg. repay loan, lock funds, token sell order on exchange
373         Reverts on failue:
374             - transfer fails
375             - if transferNotification fails (callee must revert on failure)
376             - if targetContract is an account or targetContract doesn't have neither transferNotification or fallback fx
377         TODO: make data param generic bytes (see receiver code attempt in Locker.transferNotification)
378     */
379     function transferAndNotify(TokenReceiver target, uint amount, uint data) external {
380         _transfer(msg.sender, target, amount, "");
381 
382         target.transferNotification(msg.sender, amount, data);
383     }
384 
385     /* transferAndNotify based on an  instruction signed offline  */
386     function delegatedTransferAndNotify(address from, TokenReceiver target, uint amount, uint data,
387                                      uint maxExecutorFeeInToken, /* client provided max fee for executing the tx */
388                                      bytes32 nonce, /* random nonce generated by client */
389                                      /* ^^^^ end of signed data ^^^^ */
390                                      bytes signature,
391                                      uint requestedExecutorFeeInToken /* the executor can decide to request lower fee */
392                                      )
393     external {
394         bytes32 txHash = keccak256(abi.encodePacked(this, from, target, amount, data, maxExecutorFeeInToken, nonce));
395 
396         _checkHashAndTransferExecutorFee(txHash, signature, from, maxExecutorFeeInToken, requestedExecutorFeeInToken);
397 
398         _transfer(from, target, amount, "");
399         target.transferNotification(from, amount, data);
400     }
401 
402 
403     function transferWithNarrative(address to, uint256 amount, string narrative) external {
404         _transfer(msg.sender, to, amount, narrative);
405     }
406 
407     function transferFromWithNarrative(address from, address to, uint256 amount, string narrative) external {
408         _transferFrom(from, to, amount, narrative);
409     }
410 
411     function balanceOf(address _owner) external view returns (uint256 balance) {
412         return balances[_owner];
413     }
414 
415     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
416         return allowed[_owner][_spender];
417     }
418 
419     function _checkHashAndTransferExecutorFee(bytes32 txHash, bytes signature, address signer,
420                                                 uint maxExecutorFeeInToken, uint requestedExecutorFeeInToken) private {
421         require(requestedExecutorFeeInToken <= maxExecutorFeeInToken, "requestedExecutorFee must be <= maxExecutorFee");
422         require(!delegatedTxHashesUsed[txHash], "txHash already used");
423         delegatedTxHashesUsed[txHash] = true;
424 
425         address recovered = ECRecovery.recover(ECRecovery.toEthSignedMessageHash(txHash), signature);
426         require(recovered == signer, "invalid signature");
427 
428         _transfer(signer, msg.sender, requestedExecutorFeeInToken, "Delegated transfer fee", 0);
429     }
430 
431     function _increaseApproval(address _approver, address _spender, uint _addedValue) private returns (bool) {
432         allowed[_approver][_spender] = allowed[_approver][_spender].add(_addedValue);
433         emit Approval(_approver, _spender, allowed[_approver][_spender]);
434     }
435 
436     function _transferFrom(address from, address to, uint256 amount, string narrative) private {
437         require(balances[from] >= amount, "balance must >= amount");
438         require(allowed[from][msg.sender] >= amount, "allowance must be >= amount");
439         // don't allow 0 transferFrom if no approval:
440         require(allowed[from][msg.sender] > 0, "allowance must be >= 0 even with 0 amount");
441 
442         /* NB: fee is deducted from owner. It can result that transferFrom of amount x to fail
443                 when x + fee is not availale on owner balance */
444         _transfer(from, to, amount, narrative);
445 
446         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
447     }
448 
449     function _transfer(address from, address to, uint transferAmount, string narrative) private {
450         uint fee = feeAccount.calculateTransferFee(from, to, transferAmount);
451 
452         _transfer(from, to, transferAmount, narrative, fee);
453     }
454 
455     function _transfer(address from, address to, uint transferAmount, string narrative, uint fee) private {
456         require(to != 0x0, "to must be set");
457         uint amountWithFee = transferAmount.add(fee);
458         // to emit proper reason instead of failing on from.sub()
459         require(balances[from] >= amountWithFee, "balance must be >= amount + transfer fee");
460 
461         if (fee > 0) {
462             balances[feeAccount] = balances[feeAccount].add(fee);
463             emit Transfer(from, feeAccount, fee);
464         }
465 
466         balances[from] = balances[from].sub(amountWithFee);
467         balances[to] = balances[to].add(transferAmount);
468 
469         emit Transfer(from, to, transferAmount);
470         emit AugmintTransfer(from, to, transferAmount, narrative, fee);
471     }
472 
473 }
474 
475 contract SystemAccount is Restricted {
476     event WithdrawFromSystemAccount(address tokenAddress, address to, uint tokenAmount, uint weiAmount,
477                                     string narrative);
478 
479     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
480 
481     /* TODO: this is only for first pilots to avoid funds stuck in contract due to bugs.
482       remove this function for higher volume pilots */
483     function withdraw(AugmintToken tokenAddress, address to, uint tokenAmount, uint weiAmount, string narrative)
484     external restrict("StabilityBoard") {
485         tokenAddress.transferWithNarrative(to, tokenAmount, narrative);
486         if (weiAmount > 0) {
487             to.transfer(weiAmount);
488         }
489 
490         emit WithdrawFromSystemAccount(tokenAddress, to, tokenAmount, weiAmount, narrative);
491     }
492 
493 }
494 
495 /* Contract to hold Augmint reserves (ETH & Token)
496     - ETH as regular ETH balance of the contract
497     - ERC20 token reserve (stored as regular Token balance under the contract address)
498 
499 NB: reserves are held under the contract address, therefore any transaction on the reserve is limited to the
500     tx-s defined here (i.e. transfer is not allowed even by the contract owner or StabilityBoard or MonetarySupervisor)
501 
502  */
503 contract AugmintReserves is SystemAccount {
504 
505     function () public payable { // solhint-disable-line no-empty-blocks
506         // to accept ETH sent into reserve (from defaulted loan's collateral )
507     }
508 
509     constructor(address permissionGranterContract) public SystemAccount(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
510 
511     function burn(AugmintTokenInterface augmintToken, uint amount) external restrict("MonetarySupervisor") {
512         augmintToken.burn(amount);
513     }
514 
515 }
516 
517 /* Contract to hold earned interest from loans repaid
518    premiums for locks are being accrued (i.e. transferred) to Locker */
519 contract InterestEarnedAccount is SystemAccount {
520 
521     constructor(address permissionGranterContract) public SystemAccount(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
522 
523     function transferInterest(AugmintTokenInterface augmintToken, address locker, uint interestAmount)
524     external restrict("MonetarySupervisor") {
525         augmintToken.transfer(locker, interestAmount);
526     }
527 
528 }
529 
530 
531 /* MonetarySupervisor
532     - maintains system wide KPIs (eg totalLockAmount, totalLoanAmount)
533     - holds system wide parameters/limits
534     - enforces system wide limits
535     - burns and issues to AugmintReserves
536     - Send funds from reserve to exchange when intervening (not implemented yet)
537     - Converts older versions of AugmintTokens in 1:1 to new
538 */
539 contract MonetarySupervisor is Restricted, TokenReceiver { // solhint-disable-line no-empty-blocks
540     using SafeMath for uint256;
541 
542     uint public constant PERCENT_100 = 1000000;
543 
544     AugmintTokenInterface public augmintToken;
545     InterestEarnedAccount public interestEarnedAccount;
546     AugmintReserves public augmintReserves;
547 
548     uint public issuedByStabilityBoard; // token issued  by Stability Board
549 
550     uint public totalLoanAmount; // total amount of all loans without interest, in token
551     uint public totalLockedAmount; // total amount of all locks without premium, in token
552 
553     /**********
554         Parameters to ensure totalLoanAmount or totalLockedAmount difference is within limits and system also works
555         when total loan or lock amounts are low.
556             for test calculations: https://docs.google.com/spreadsheets/d/1MeWYPYZRIm1n9lzpvbq8kLfQg1hhvk5oJY6NrR401S0
557     **********/
558     struct LtdParams {
559         uint  lockDifferenceLimit; /* only allow a new lock if Loan To Deposit ratio would stay above
560                                             (1 - lockDifferenceLimit) with new lock. Stored as parts per million */
561         uint  loanDifferenceLimit; /* only allow a new loan if Loan To Deposit ratio would stay above
562                                             (1 + loanDifferenceLimit) with new loan. Stored as parts per million */
563         /* allowedDifferenceAmount param is to ensure the system is not "freezing" when totalLoanAmount or
564             totalLockAmount is low.
565         It allows a new loan or lock (up to an amount to reach this difference) even if LTD will go below / above
566             lockDifferenceLimit / loanDifferenceLimit with the new lock/loan */
567         uint  allowedDifferenceAmount;
568     }
569 
570     LtdParams public ltdParams;
571 
572     /* Previously deployed AugmintTokens which are accepted for conversion (see transferNotification() )
573         NB: it's not iterable so old version addresses needs to be added for UI manually after each deploy */
574     mapping(address => bool) public acceptedLegacyAugmintTokens;
575 
576     event LtdParamsChanged(uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount);
577 
578     event AcceptedLegacyAugmintTokenChanged(address augmintTokenAddress, bool newAcceptedState);
579 
580     event LegacyTokenConverted(address oldTokenAddress, address account, uint amount);
581 
582     event KPIsAdjusted(uint totalLoanAmountAdjustment, uint totalLockedAmountAdjustment);
583 
584     event SystemContractsChanged(InterestEarnedAccount newInterestEarnedAccount, AugmintReserves newAugmintReserves);
585 
586     constructor(address permissionGranterContract, AugmintTokenInterface _augmintToken, AugmintReserves _augmintReserves,
587         InterestEarnedAccount _interestEarnedAccount,
588         uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount)
589     public Restricted(permissionGranterContract) {
590         augmintToken = _augmintToken;
591         augmintReserves = _augmintReserves;
592         interestEarnedAccount = _interestEarnedAccount;
593 
594         ltdParams = LtdParams(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
595     }
596 
597     function issueToReserve(uint amount) external restrict("StabilityBoard") {
598         issuedByStabilityBoard = issuedByStabilityBoard.add(amount);
599         augmintToken.issueTo(augmintReserves, amount);
600     }
601 
602     function burnFromReserve(uint amount) external restrict("StabilityBoard") {
603         issuedByStabilityBoard = issuedByStabilityBoard.sub(amount);
604         augmintReserves.burn(augmintToken, amount);
605     }
606 
607     /* Locker requesting interest when locking funds. Enforcing LTD to stay within range allowed by LTD params
608         NB: it does not know about min loan amount, it's the loan contract's responsibility to enforce it  */
609     function requestInterest(uint amountToLock, uint interestAmount) external {
610         // only whitelisted Locker
611         require(permissions[msg.sender]["Locker"], "msg.sender must have Locker permission");
612         require(amountToLock <= getMaxLockAmountAllowedByLtd(), "amountToLock must be <= maxLockAmountAllowedByLtd");
613 
614         totalLockedAmount = totalLockedAmount.add(amountToLock);
615         // next line would revert but require to emit reason:
616         require(augmintToken.balanceOf(address(interestEarnedAccount)) >= interestAmount,
617             "interestEarnedAccount balance must be >= interestAmount");
618         interestEarnedAccount.transferInterest(augmintToken, msg.sender, interestAmount); // transfer interest to Locker
619     }
620 
621     // Locker notifying when releasing funds to update KPIs
622     function releaseFundsNotification(uint lockedAmount) external {
623         // only whitelisted Locker
624         require(permissions[msg.sender]["Locker"], "msg.sender must have Locker permission");
625         totalLockedAmount = totalLockedAmount.sub(lockedAmount);
626     }
627 
628     /* Issue loan if LTD stays within range allowed by LTD params
629         NB: it does not know about min loan amount, it's the loan contract's responsibility to enforce it */
630     function issueLoan(address borrower, uint loanAmount) external {
631          // only whitelisted LoanManager contracts
632         require(permissions[msg.sender]["LoanManager"],
633             "msg.sender must have LoanManager permission");
634         require(loanAmount <= getMaxLoanAmountAllowedByLtd(), "loanAmount must be <= maxLoanAmountAllowedByLtd");
635         totalLoanAmount = totalLoanAmount.add(loanAmount);
636         augmintToken.issueTo(borrower, loanAmount);
637     }
638 
639     function loanRepaymentNotification(uint loanAmount) external {
640         // only whitelisted LoanManager contracts
641        require(permissions[msg.sender]["LoanManager"],
642            "msg.sender must have LoanManager permission");
643         totalLoanAmount = totalLoanAmount.sub(loanAmount);
644     }
645 
646     // NB: this is called by Lender contract with the sum of all loans collected in batch
647     function loanCollectionNotification(uint totalLoanAmountCollected) external {
648         // only whitelisted LoanManager contracts
649        require(permissions[msg.sender]["LoanManager"],
650            "msg.sender must have LoanManager permission");
651         totalLoanAmount = totalLoanAmount.sub(totalLoanAmountCollected);
652     }
653 
654     function setAcceptedLegacyAugmintToken(address legacyAugmintTokenAddress, bool newAcceptedState)
655     external restrict("StabilityBoard") {
656         acceptedLegacyAugmintTokens[legacyAugmintTokenAddress] = newAcceptedState;
657         emit AcceptedLegacyAugmintTokenChanged(legacyAugmintTokenAddress, newAcceptedState);
658     }
659 
660     function setLtdParams(uint lockDifferenceLimit, uint loanDifferenceLimit, uint allowedDifferenceAmount)
661     external restrict("StabilityBoard") {
662         ltdParams = LtdParams(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
663 
664         emit LtdParamsChanged(lockDifferenceLimit, loanDifferenceLimit, allowedDifferenceAmount);
665     }
666 
667     /* function to migrate old totalLoanAmount and totalLockedAmount from old monetarySupervisor contract
668         when it's upgraded.
669         Set new monetarySupervisor contract in all locker and loanManager contracts before executing this */
670     function adjustKPIs(uint totalLoanAmountAdjustment, uint totalLockedAmountAdjustment)
671     external restrict("StabilityBoard") {
672         totalLoanAmount = totalLoanAmount.add(totalLoanAmountAdjustment);
673         totalLockedAmount = totalLockedAmount.add(totalLockedAmountAdjustment);
674 
675         emit KPIsAdjusted(totalLoanAmountAdjustment, totalLockedAmountAdjustment);
676     }
677 
678     /* to allow upgrades of InterestEarnedAccount and AugmintReserves contracts. */
679     function setSystemContracts(InterestEarnedAccount newInterestEarnedAccount, AugmintReserves newAugmintReserves)
680     external restrict("StabilityBoard") {
681         interestEarnedAccount = newInterestEarnedAccount;
682         augmintReserves = newAugmintReserves;
683         emit SystemContractsChanged(newInterestEarnedAccount, newAugmintReserves);
684     }
685 
686     /* User can request to convert their tokens from older AugmintToken versions in 1:1
687       transferNotification is called from AugmintToken's transferAndNotify
688      Flow for converting old tokens:
689         1) user calls old token contract's transferAndNotify with the amount to convert,
690                 addressing the new MonetarySupervisor Contract
691         2) transferAndNotify transfers user's old tokens to the current MonetarySupervisor contract's address
692         3) transferAndNotify calls MonetarySupervisor.transferNotification
693         4) MonetarySupervisor checks if old AugmintToken is permitted
694         5) MonetarySupervisor issues new tokens to user's account in current AugmintToken
695         6) MonetarySupervisor burns old tokens from own balance
696     */
697     function transferNotification(address from, uint amount, uint /* data, not used */ ) external {
698         AugmintTokenInterface legacyToken = AugmintTokenInterface(msg.sender);
699         require(acceptedLegacyAugmintTokens[legacyToken], "msg.sender must be allowed in acceptedLegacyAugmintTokens");
700 
701         legacyToken.burn(amount);
702         augmintToken.issueTo(from, amount);
703         emit LegacyTokenConverted(msg.sender, from, amount);
704     }
705 
706     function getLoanToDepositRatio() external view returns (uint loanToDepositRatio) {
707         loanToDepositRatio = totalLockedAmount == 0 ? 0 : totalLockedAmount.mul(PERCENT_100).div(totalLoanAmount);
708     }
709 
710     /* Helper function for UI.
711         Returns max lock amount based on minLockAmount, interestPt, using LTD params & interestEarnedAccount balance */
712     function getMaxLockAmount(uint minLockAmount, uint interestPt) external view returns (uint maxLock) {
713         uint allowedByEarning = augmintToken.balanceOf(address(interestEarnedAccount)).mul(PERCENT_100).div(interestPt);
714         uint allowedByLtd = getMaxLockAmountAllowedByLtd();
715         maxLock = allowedByEarning < allowedByLtd ? allowedByEarning : allowedByLtd;
716         maxLock = maxLock < minLockAmount ? 0 : maxLock;
717     }
718 
719     /* Helper function for UI.
720         Returns max loan amount based on minLoanAmont using LTD params */
721     function getMaxLoanAmount(uint minLoanAmount) external view returns (uint maxLoan) {
722         uint allowedByLtd = getMaxLoanAmountAllowedByLtd();
723         maxLoan = allowedByLtd < minLoanAmount ? 0 : allowedByLtd;
724     }
725 
726     /* returns maximum lockable token amount allowed by LTD params. */
727     function getMaxLockAmountAllowedByLtd() public view returns(uint maxLockByLtd) {
728         uint allowedByLtdDifferencePt = totalLoanAmount.mul(PERCENT_100).div(PERCENT_100
729                                             .sub(ltdParams.lockDifferenceLimit));
730         allowedByLtdDifferencePt = totalLockedAmount >= allowedByLtdDifferencePt ?
731                                         0 : allowedByLtdDifferencePt.sub(totalLockedAmount);
732 
733         uint allowedByLtdDifferenceAmount =
734             totalLockedAmount >= totalLoanAmount.add(ltdParams.allowedDifferenceAmount) ?
735                 0 : totalLoanAmount.add(ltdParams.allowedDifferenceAmount).sub(totalLockedAmount);
736 
737         maxLockByLtd = allowedByLtdDifferencePt > allowedByLtdDifferenceAmount ?
738                                         allowedByLtdDifferencePt : allowedByLtdDifferenceAmount;
739     }
740 
741     /* returns maximum borrowable token amount allowed by LTD params */
742     function getMaxLoanAmountAllowedByLtd() public view returns(uint maxLoanByLtd) {
743         uint allowedByLtdDifferencePt = totalLockedAmount.mul(ltdParams.loanDifferenceLimit.add(PERCENT_100))
744                                             .div(PERCENT_100);
745         allowedByLtdDifferencePt = totalLoanAmount >= allowedByLtdDifferencePt ?
746                                         0 : allowedByLtdDifferencePt.sub(totalLoanAmount);
747 
748         uint allowedByLtdDifferenceAmount =
749             totalLoanAmount >= totalLockedAmount.add(ltdParams.allowedDifferenceAmount) ?
750                 0 : totalLockedAmount.add(ltdParams.allowedDifferenceAmount).sub(totalLoanAmount);
751 
752         maxLoanByLtd = allowedByLtdDifferencePt > allowedByLtdDifferenceAmount ?
753                                         allowedByLtdDifferencePt : allowedByLtdDifferenceAmount;
754     }
755 
756 }
757 
758 /* contract for tracking locked funds
759 
760  requirements
761   -> lock funds
762   -> unlock funds
763   -> index locks by address
764 
765  For flows see: https://github.com/Augmint/augmint-contracts/blob/master/docs/lockFlow.png
766 
767  TODO / think about:
768   -> self-destruct function?
769 
770 */
771 
772 contract Locker is Restricted, TokenReceiver {
773 
774     using SafeMath for uint256;
775 
776     uint public constant CHUNK_SIZE = 100;
777 
778     event NewLockProduct(uint32 indexed lockProductId, uint32 perTermInterest, uint32 durationInSecs,
779                             uint32 minimumLockAmount, bool isActive);
780 
781     event LockProductActiveChange(uint32 indexed lockProductId, bool newActiveState);
782 
783     // NB: amountLocked includes the original amount, plus interest
784     event NewLock(address indexed lockOwner, uint lockId, uint amountLocked, uint interestEarned,
785                     uint40 lockedUntil, uint32 perTermInterest, uint32 durationInSecs);
786 
787     event LockReleased(address indexed lockOwner, uint lockId);
788 
789     event MonetarySupervisorChanged(MonetarySupervisor newMonetarySupervisor);
790 
791     struct LockProduct {
792         // perTermInterest is in millionths (i.e. 1,000,000 = 100%):
793         uint32 perTermInterest;
794         uint32 durationInSecs;
795         uint32 minimumLockAmount;
796         bool isActive;
797     }
798 
799     /* NB: we don't need to store lock parameters because lockProducts can't be altered (only disabled/enabled) */
800     struct Lock {
801         uint amountLocked;
802         address owner;
803         uint32 productId;
804         uint40 lockedUntil;
805         bool isActive;
806     }
807 
808     AugmintTokenInterface public augmintToken;
809     MonetarySupervisor public monetarySupervisor;
810 
811     LockProduct[] public lockProducts;
812 
813     Lock[] public locks;
814 
815     // lock ids for an account
816     mapping(address => uint[]) public accountLocks;
817 
818     constructor(address permissionGranterContract, AugmintTokenInterface _augmintToken,
819                     MonetarySupervisor _monetarySupervisor)
820     public Restricted(permissionGranterContract) {
821         augmintToken = _augmintToken;
822         monetarySupervisor = _monetarySupervisor;
823 
824     }
825 
826     function addLockProduct(uint32 perTermInterest, uint32 durationInSecs, uint32 minimumLockAmount, bool isActive)
827     external restrict("StabilityBoard") {
828 
829         uint _newLockProductId = lockProducts.push(
830                                     LockProduct(perTermInterest, durationInSecs, minimumLockAmount, isActive)) - 1;
831         uint32 newLockProductId = uint32(_newLockProductId);
832         require(newLockProductId == _newLockProductId, "lockProduct overflow");
833         emit NewLockProduct(newLockProductId, perTermInterest, durationInSecs, minimumLockAmount, isActive);
834 
835     }
836 
837     function setLockProductActiveState(uint32 lockProductId, bool isActive) external restrict("StabilityBoard") {
838         // next line would revert but require to emit reason:
839         require(lockProductId < lockProducts.length, "invalid lockProductId");
840 
841         lockProducts[lockProductId].isActive = isActive;
842         emit LockProductActiveChange(lockProductId, isActive);
843 
844     }
845 
846     /* lock funds, called from AugmintToken's transferAndNotify
847      Flow for locking tokens:
848         1) user calls token contract's transferAndNotify lockProductId passed in data arg
849         2) transferAndNotify transfers tokens to the Lock contract
850         3) transferAndNotify calls Lock.transferNotification with lockProductId
851     */
852     function transferNotification(address from, uint256 amountToLock, uint _lockProductId) external {
853         require(msg.sender == address(augmintToken), "msg.sender must be augmintToken");
854         // next line would revert but require to emit reason:
855         require(lockProductId < lockProducts.length, "invalid lockProductId");
856         uint32 lockProductId = uint32(_lockProductId);
857         require(lockProductId == _lockProductId, "lockProductId overflow");
858         /* TODO: make data arg generic bytes
859             uint productId;
860             assembly { // solhint-disable-line no-inline-assembly
861                 productId := mload(data)
862         } */
863         _createLock(lockProductId, from, amountToLock);
864     }
865 
866     function releaseFunds(uint lockId) external {
867         // next line would revert but require to emit reason:
868         require(lockId < locks.length, "invalid lockId");
869         Lock storage lock = locks[lockId];
870         LockProduct storage lockProduct = lockProducts[lock.productId];
871 
872         require(lock.isActive, "lock must be in active state");
873         require(now >= lock.lockedUntil, "current time must be later than lockedUntil");
874 
875         lock.isActive = false;
876 
877         uint interestEarned = calculateInterest(lockProduct.perTermInterest, lock.amountLocked);
878 
879         monetarySupervisor.releaseFundsNotification(lock.amountLocked); // to maintain totalLockAmount
880         augmintToken.transferWithNarrative(lock.owner, lock.amountLocked.add(interestEarned),
881                                                                                 "Funds released from lock");
882 
883         emit LockReleased(lock.owner, lockId);
884     }
885 
886     function setMonetarySupervisor(MonetarySupervisor newMonetarySupervisor) external restrict("StabilityBoard") {
887         monetarySupervisor = newMonetarySupervisor;
888         emit MonetarySupervisorChanged(newMonetarySupervisor);
889     }
890 
891     function getLockProductCount() external view returns (uint) {
892 
893         return lockProducts.length;
894 
895     }
896 
897     // returns 20 lock products starting from some offset
898     // lock products are encoded as [ perTermInterest, durationInSecs, minimumLockAmount, maxLockAmount, isActive ]
899     function getLockProducts(uint offset) external view returns (uint[5][CHUNK_SIZE] response) {
900         for (uint8 i = 0; i < CHUNK_SIZE; i++) {
901 
902             if (offset + i >= lockProducts.length) { break; }
903 
904             LockProduct storage lockProduct = lockProducts[offset + i];
905 
906             response[i] = [ lockProduct.perTermInterest, lockProduct.durationInSecs, lockProduct.minimumLockAmount,
907                         monetarySupervisor.getMaxLockAmount(lockProduct.minimumLockAmount, lockProduct.perTermInterest),
908                         lockProduct.isActive ? 1 : 0 ];
909         }
910     }
911 
912     function getLockCount() external view returns (uint) {
913         return locks.length;
914     }
915 
916     function getLockCountForAddress(address lockOwner) external view returns (uint) {
917         return accountLocks[lockOwner].length;
918     }
919 
920     // returns CHUNK_SIZE locks starting from some offset
921     // lock products are encoded as
922     //       [lockId, owner, amountLocked, interestEarned, lockedUntil, perTermInterest, durationInSecs, isActive ]
923     // NB: perTermInterest is in millionths (i.e. 1,000,000 = 100%):
924     function getLocks(uint offset) external view returns (uint[8][CHUNK_SIZE] response) {
925 
926         for (uint16 i = 0; i < CHUNK_SIZE; i++) {
927 
928             if (offset + i >= locks.length) { break; }
929 
930             Lock storage lock = locks[offset + i];
931             LockProduct storage lockProduct = lockProducts[lock.productId];
932 
933             uint interestEarned = calculateInterest(lockProduct.perTermInterest, lock.amountLocked);
934 
935             response[i] = [uint(offset + i), uint(lock.owner), lock.amountLocked, interestEarned, lock.lockedUntil,
936                                 lockProduct.perTermInterest, lockProduct.durationInSecs, lock.isActive ? 1 : 0];
937         }
938     }
939 
940     // returns CHUNK_SIZE locks of a given account, starting from some offset
941     // lock products are encoded as
942     //             [lockId, amountLocked, interestEarned, lockedUntil, perTermInterest, durationInSecs, isActive ]
943     function getLocksForAddress(address lockOwner, uint offset) external view returns (uint[7][CHUNK_SIZE] response) {
944 
945         uint[] storage locksForAddress = accountLocks[lockOwner];
946 
947         for (uint16 i = 0; i < CHUNK_SIZE; i++) {
948 
949             if (offset + i >= locksForAddress.length) { break; }
950 
951             Lock storage lock = locks[locksForAddress[offset + i]];
952             LockProduct storage lockProduct = lockProducts[lock.productId];
953 
954             uint interestEarned = calculateInterest(lockProduct.perTermInterest, lock.amountLocked);
955 
956             response[i] = [ locksForAddress[offset + i], lock.amountLocked, interestEarned, lock.lockedUntil,
957                                 lockProduct.perTermInterest, lockProduct.durationInSecs, lock.isActive ? 1 : 0 ];
958         }
959     }
960 
961     function calculateInterest(uint32 perTermInterest, uint amountToLock) public pure returns (uint interestEarned) {
962         interestEarned = amountToLock.mul(perTermInterest).ceilDiv(1000000);
963     }
964 
965     // Internal function. assumes amountToLock is already transferred to this Lock contract
966     function _createLock(uint32 lockProductId, address lockOwner, uint amountToLock) internal returns(uint lockId) {
967         LockProduct storage lockProduct = lockProducts[lockProductId];
968         require(lockProduct.isActive, "lockProduct must be in active state");
969         require(amountToLock >= lockProduct.minimumLockAmount, "amountToLock must be >= minimumLockAmount");
970 
971         uint interestEarned = calculateInterest(lockProduct.perTermInterest, amountToLock);
972         uint expiration = now.add(lockProduct.durationInSecs);
973         uint40 lockedUntil = uint40(expiration);
974         require(lockedUntil == expiration, "lockedUntil overflow");
975 
976         lockId = locks.push(Lock(amountToLock, lockOwner, lockProductId, lockedUntil, true)) - 1;
977         accountLocks[lockOwner].push(lockId);
978 
979         monetarySupervisor.requestInterest(amountToLock, interestEarned); // update KPIs & transfer interest here
980 
981         emit NewLock(lockOwner, lockId, amountToLock, interestEarned, lockedUntil, lockProduct.perTermInterest,
982                     lockProduct.durationInSecs);
983     }
984 
985 }