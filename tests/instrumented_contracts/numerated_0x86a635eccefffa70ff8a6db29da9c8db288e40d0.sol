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
465 
466 /* Augmint Crypto Euro token (A-EUR) implementation */
467 
468 contract TokenAEur is AugmintToken {
469     constructor(address _permissionGranterContract, TransferFeeInterface _feeAccount)
470     public AugmintToken(_permissionGranterContract, "Augmint Crypto Euro", "AEUR", "EUR", 2, _feeAccount)
471     {} // solhint-disable-line no-empty-blocks
472 
473 }