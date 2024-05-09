1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev Give an account access to this role.
14      */
15     function add(Role storage role, address account) internal {
16         require(!has(role, account), "Roles: account already has role");
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev Remove an account's access to this role.
22      */
23     function remove(Role storage role, address account) internal {
24         require(has(role, account), "Roles: account does not have role");
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev Check if an account has this role.
30      * @return bool
31      */
32     function has(Role storage role, address account) internal view returns (bool) {
33         require(account != address(0), "Roles: account is the zero address");
34         return role.bearer[account];
35     }
36 }
37 
38 // File: contracts/AdminRole.sol
39 
40 pragma solidity 0.5.17;
41 
42 
43 
44 
45 contract AdminRole {
46     using Roles for Roles.Role;
47 
48     event AdminAdded(address indexed account);
49     event AdminRemoved(address indexed account);
50 
51     Roles.Role private _admins;
52 
53     constructor () internal {
54         _addAdmin(msg.sender);
55     }
56 
57     modifier onlyAdmin() {
58         require(isAdmin(msg.sender), "AdminRole: caller does not have the Admin role");
59         _;
60     }
61 
62     function isAdmin(address account) public view returns (bool) {
63         return _admins.has(account);
64     }
65 
66     function addAdmin(address account) public onlyAdmin {
67         _addAdmin(account);
68     }
69 
70     function removeAdmin(address account) public onlyAdmin {
71         _removeAdmin(account);
72     }
73 
74     function _addAdmin(address account) internal {
75         _admins.add(account);
76         emit AdminAdded(account);
77     }
78 
79     function _removeAdmin(address account) internal {
80         _admins.remove(account);
81         emit AdminRemoved(account);
82     }
83 }
84 
85 // File: contracts/Initializable.sol
86 
87 pragma solidity 0.5.17;
88 
89 contract Initializable {
90     bool inited = false;
91 
92     modifier initializer() {
93         require(!inited, "already inited");
94         _;
95         inited = true;
96     }
97 }
98 
99 // File: contracts/EIP712Base.sol
100 
101 pragma solidity 0.5.17;
102 
103 
104 contract EIP712Base is Initializable {
105     struct EIP712Domain {
106         string name;
107         string version;
108         address verifyingContract;
109         bytes32 salt;
110     }
111 
112     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
113         bytes(
114             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
115         )
116     );
117     bytes32 internal domainSeperator;
118 
119     // supposed to be called once while initializing.
120     // one of the contractsa that inherits this contract follows proxy pattern
121     // so it is not possible to do this in a constructor
122     function _initializeEIP712(
123         string memory name,
124         string memory version
125     )
126         internal
127         initializer
128     {
129         _setDomainSeperator(name, version);
130     }
131 
132     function _setDomainSeperator(string memory name, string memory version) internal {
133         domainSeperator = keccak256(
134             abi.encode(
135                 EIP712_DOMAIN_TYPEHASH,
136                 keccak256(bytes(name)),
137                 keccak256(bytes(version)),
138                 address(this),
139                 bytes32(getChainId())
140             )
141         );
142     }
143 
144     function getDomainSeperator() public view returns (bytes32) {
145         return domainSeperator;
146     }
147 
148     function getChainId() public pure returns (uint256) {
149         uint256 id;
150         assembly {
151             id := chainid()
152         }
153         return id;
154     }
155 
156     /**
157      * Accept message hash and returns hash message in EIP712 compatible form
158      * So that it can be used to recover signer from signature signed using EIP712 formatted data
159      * https://eips.ethereum.org/EIPS/eip-712
160      * "\\x19" makes the encoding deterministic
161      * "\\x01" is the version byte to make it compatible to EIP-191
162      */
163     function toTypedMessageHash(bytes32 messageHash)
164         internal
165         view
166         returns (bytes32)
167     {
168         return
169             keccak256(
170                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
171             );
172     }
173 }
174 
175 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
176 
177 pragma solidity ^0.5.0;
178 
179 /**
180  * @dev Wrappers over Solidity's arithmetic operations with added overflow
181  * checks.
182  *
183  * Arithmetic operations in Solidity wrap on overflow. This can easily result
184  * in bugs, because programmers usually assume that an overflow raises an
185  * error, which is the standard behavior in high level programming languages.
186  * `SafeMath` restores this intuition by reverting the transaction when an
187  * operation overflows.
188  *
189  * Using this library instead of the unchecked operations eliminates an entire
190  * class of bugs, so it's recommended to use it always.
191  */
192 library SafeMath {
193     /**
194      * @dev Returns the addition of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `+` operator.
198      *
199      * Requirements:
200      * - Addition cannot overflow.
201      */
202     function add(uint256 a, uint256 b) internal pure returns (uint256) {
203         uint256 c = a + b;
204         require(c >= a, "SafeMath: addition overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      * - Subtraction cannot overflow.
217      */
218     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219         return sub(a, b, "SafeMath: subtraction overflow");
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      * - Subtraction cannot overflow.
230      *
231      * _Available since v2.4.0._
232      */
233     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b <= a, errorMessage);
235         uint256 c = a - b;
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the multiplication of two unsigned integers, reverting on
242      * overflow.
243      *
244      * Counterpart to Solidity's `*` operator.
245      *
246      * Requirements:
247      * - Multiplication cannot overflow.
248      */
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
251         // benefit is lost if 'b' is also tested.
252         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
253         if (a == 0) {
254             return 0;
255         }
256 
257         uint256 c = a * b;
258         require(c / a == b, "SafeMath: multiplication overflow");
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers. Reverts on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      * - The divisor cannot be zero.
273      */
274     function div(uint256 a, uint256 b) internal pure returns (uint256) {
275         return div(a, b, "SafeMath: division by zero");
276     }
277 
278     /**
279      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
280      * division by zero. The result is rounded towards zero.
281      *
282      * Counterpart to Solidity's `/` operator. Note: this function uses a
283      * `revert` opcode (which leaves remaining gas untouched) while Solidity
284      * uses an invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      * - The divisor cannot be zero.
288      *
289      * _Available since v2.4.0._
290      */
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         // Solidity only automatically asserts when dividing by 0
293         require(b > 0, errorMessage);
294         uint256 c = a / b;
295         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * Reverts when dividing by zero.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return mod(a, b, "SafeMath: modulo by zero");
313     }
314 
315     /**
316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317      * Reverts with custom message when dividing by zero.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      * - The divisor cannot be zero.
325      *
326      * _Available since v2.4.0._
327      */
328     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
329         require(b != 0, errorMessage);
330         return a % b;
331     }
332 }
333 
334 // File: contracts/EIP712MetaTransaction.sol
335 
336 pragma solidity 0.5.17;
337 
338 
339 
340 contract EIP712MetaTransaction is EIP712Base {
341     using SafeMath for uint256;
342     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
343         bytes(
344             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
345         )
346     );
347 
348     event MetaTransactionExecuted(
349         address userAddress,
350         address payable relayerAddress,
351         bytes functionSignature
352     );
353     mapping(address => uint256) nonces;
354 
355     /*
356      * Meta transaction structure.
357      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
358      * He should call the desired function directly in that case.
359      */
360     struct MetaTransaction {
361         uint256 nonce;
362         address from;
363         bytes functionSignature;
364     }
365 
366     function executeMetaTransaction(
367         address userAddress,
368         bytes memory functionSignature,
369         bytes32 sigR,
370         bytes32 sigS,
371         uint8 sigV
372     ) public payable returns (bytes memory) {
373         MetaTransaction memory metaTx = MetaTransaction({
374             nonce: nonces[userAddress],
375             from: userAddress,
376             functionSignature: functionSignature
377         });
378         require(
379             verify(userAddress, metaTx, sigR, sigS, sigV),
380             "Signer and signature do not match"
381         );
382 
383         nonces[userAddress] = nonces[userAddress].add(1);
384         emit MetaTransactionExecuted(
385             userAddress,
386             msg.sender,
387             functionSignature
388         );
389         // Append userAddress and relayer address at the end to extract it from calling context
390         (bool success, bytes memory returnData) = address(this).call(
391             abi.encodePacked(functionSignature, userAddress)
392         );
393 
394         require(success, "Function call not successfull");
395         
396         return returnData;
397     }
398 
399     function hashMetaTransaction(MetaTransaction memory metaTx)
400         internal
401         view
402         returns (bytes32)
403     {
404         return
405             keccak256(
406                 abi.encode(
407                     META_TRANSACTION_TYPEHASH,
408                     metaTx.nonce,
409                     metaTx.from,
410                     keccak256(metaTx.functionSignature)
411                 )
412             );
413     }
414 
415     function getNonce(address user) public view returns (uint256 nonce) {
416         nonce = nonces[user];
417     }
418 
419     function verify(
420         address signer,
421         MetaTransaction memory metaTx,
422         bytes32 sigR,
423         bytes32 sigS,
424         uint8 sigV
425     ) internal view returns (bool) {
426         return
427             signer ==
428             ecrecover(
429                 toTypedMessageHash(hashMetaTransaction(metaTx)),
430                 sigV,
431                 sigR,
432                 sigS
433             );
434     }
435 
436     function _msgSender() internal view returns (address payable sender) {
437         if(msg.sender == address(this)) {
438             bytes memory array = msg.data;
439             uint256 index = msg.data.length;
440             assembly {
441                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
442                 sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
443             }
444         } else {
445             sender = msg.sender;
446         }
447         return sender;
448     }
449 }
450 
451 // File: contracts/EthereumDeposit.sol
452 
453 pragma solidity 0.5.17;
454 
455 
456 
457 
458 contract EthereumDeposit is AdminRole, EIP712MetaTransaction {
459 
460     uint256 public maxLimit = 2 ether;
461 
462     address payable public wallet;
463     
464 
465     //Tells if a transaction has been claimed
466     mapping(bytes32 => bool) public txVsClaimed;
467 
468     event Deposit(uint256 amount);
469     event Withdraw(uint256 amount, bytes32 indexed txHash);
470     event Released(uint256 amount);
471 
472     constructor (address payable account) public {
473         wallet = account;
474         _initializeEIP712("BadBit.Games", "0.1");
475     }
476 
477     //This will be used for deposit
478     function () external payable {
479         require(msg.value <= maxLimit, "Value greater then max limit");
480         emit Deposit(msg.value);
481     }
482 
483     function withdraw(
484         bytes32 txHash,
485         address payable account,
486         uint256 amount
487     )
488         external
489         onlyAdmin
490     {
491         if (txVsClaimed[txHash] == true) {
492             //ignore the tx
493             return;
494         }
495         txVsClaimed[txHash] = true;
496         account.transfer(amount);
497         emit Withdraw(amount, txHash);
498     }
499 
500     function changeMaxLimit(uint256 newLimit) external onlyAdmin {
501         maxLimit = newLimit;
502     }
503 
504     function releaseFunds(uint256 amount) external onlyAdmin {
505         emit Released(amount);
506         wallet.transfer(amount);
507     }
508 }