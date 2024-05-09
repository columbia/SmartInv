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
567 // File: contracts/TokenAEur.sol
568 
569 /* Augmint Euro token (A-EUR) implementation */
570 pragma solidity 0.4.24;
571 
572 
573 
574 
575 contract TokenAEur is AugmintToken {
576     constructor(address _permissionGranterContract, TransferFeeInterface _feeAccount)
577     public AugmintToken(_permissionGranterContract, "Augmint Euro", "AEUR", "EUR", 2, _feeAccount)
578     {} // solhint-disable-line no-empty-blocks
579 
580 }