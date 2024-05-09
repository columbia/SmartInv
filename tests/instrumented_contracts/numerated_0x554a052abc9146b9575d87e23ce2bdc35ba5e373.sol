1 // File: openzeppelin-solidity/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
45 
46 pragma solidity ^0.5.2;
47 
48 
49 contract PauserRole {
50     using Roles for Roles.Role;
51 
52     event PauserAdded(address indexed account);
53     event PauserRemoved(address indexed account);
54 
55     Roles.Role private _pausers;
56 
57     constructor () internal {
58         _addPauser(msg.sender);
59     }
60 
61     modifier onlyPauser() {
62         require(isPauser(msg.sender));
63         _;
64     }
65 
66     function isPauser(address account) public view returns (bool) {
67         return _pausers.has(account);
68     }
69 
70     function addPauser(address account) public onlyPauser {
71         _addPauser(account);
72     }
73 
74     function renouncePauser() public {
75         _removePauser(msg.sender);
76     }
77 
78     function _addPauser(address account) internal {
79         _pausers.add(account);
80         emit PauserAdded(account);
81     }
82 
83     function _removePauser(address account) internal {
84         _pausers.remove(account);
85         emit PauserRemoved(account);
86     }
87 }
88 
89 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
90 
91 pragma solidity ^0.5.2;
92 
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is PauserRole {
99     event Paused(address account);
100     event Unpaused(address account);
101 
102     bool private _paused;
103 
104     constructor () internal {
105         _paused = false;
106     }
107 
108     /**
109      * @return true if the contract is paused, false otherwise.
110      */
111     function paused() public view returns (bool) {
112         return _paused;
113     }
114 
115     /**
116      * @dev Modifier to make a function callable only when the contract is not paused.
117      */
118     modifier whenNotPaused() {
119         require(!_paused);
120         _;
121     }
122 
123     /**
124      * @dev Modifier to make a function callable only when the contract is paused.
125      */
126     modifier whenPaused() {
127         require(_paused);
128         _;
129     }
130 
131     /**
132      * @dev called by the owner to pause, triggers stopped state
133      */
134     function pause() public onlyPauser whenNotPaused {
135         _paused = true;
136         emit Paused(msg.sender);
137     }
138 
139     /**
140      * @dev called by the owner to unpause, returns to normal state
141      */
142     function unpause() public onlyPauser whenPaused {
143         _paused = false;
144         emit Unpaused(msg.sender);
145     }
146 }
147 
148 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
149 
150 pragma solidity ^0.5.2;
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     address private _owner;
159 
160     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162     /**
163      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164      * account.
165      */
166     constructor () internal {
167         _owner = msg.sender;
168         emit OwnershipTransferred(address(0), _owner);
169     }
170 
171     /**
172      * @return the address of the owner.
173      */
174     function owner() public view returns (address) {
175         return _owner;
176     }
177 
178     /**
179      * @dev Throws if called by any account other than the owner.
180      */
181     modifier onlyOwner() {
182         require(isOwner());
183         _;
184     }
185 
186     /**
187      * @return true if `msg.sender` is the owner of the contract.
188      */
189     function isOwner() public view returns (bool) {
190         return msg.sender == _owner;
191     }
192 
193     /**
194      * @dev Allows the current owner to relinquish control of the contract.
195      * It will not be possible to call the functions with the `onlyOwner`
196      * modifier anymore.
197      * @notice Renouncing ownership will leave the contract without an owner,
198      * thereby removing any functionality that is only available to the owner.
199      */
200     function renounceOwnership() public onlyOwner {
201         emit OwnershipTransferred(_owner, address(0));
202         _owner = address(0);
203     }
204 
205     /**
206      * @dev Allows the current owner to transfer control of the contract to a newOwner.
207      * @param newOwner The address to transfer ownership to.
208      */
209     function transferOwnership(address newOwner) public onlyOwner {
210         _transferOwnership(newOwner);
211     }
212 
213     /**
214      * @dev Transfers control of the contract to a newOwner.
215      * @param newOwner The address to transfer ownership to.
216      */
217     function _transferOwnership(address newOwner) internal {
218         require(newOwner != address(0));
219         emit OwnershipTransferred(_owner, newOwner);
220         _owner = newOwner;
221     }
222 }
223 
224 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
225 
226 pragma solidity ^0.5.2;
227 
228 /**
229  * @title Helps contracts guard against reentrancy attacks.
230  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
231  * @dev If you mark a function `nonReentrant`, you should also
232  * mark it `external`.
233  */
234 contract ReentrancyGuard {
235     /// @dev counter to allow mutex lock with only one SSTORE operation
236     uint256 private _guardCounter;
237 
238     constructor () internal {
239         // The counter starts at one to prevent changing it from zero to a non-zero
240         // value, which is a more expensive operation.
241         _guardCounter = 1;
242     }
243 
244     /**
245      * @dev Prevents a contract from calling itself, directly or indirectly.
246      * Calling a `nonReentrant` function from another `nonReentrant`
247      * function is not supported. It is possible to prevent this from happening
248      * by making the `nonReentrant` function external, and make it call a
249      * `private` function that does the actual work.
250      */
251     modifier nonReentrant() {
252         _guardCounter += 1;
253         uint256 localCounter = _guardCounter;
254         _;
255         require(localCounter == _guardCounter);
256     }
257 }
258 
259 // File: contracts/interfaces/IIssuer.sol
260 
261 pragma solidity 0.5.4;
262 
263 
264 interface IIssuer {
265     event Issued(address indexed payee, uint amount);
266     event Claimed(address indexed payee, uint amount);
267     event FinishedIssuing(address indexed issuer);
268 
269     function issue(address payee, uint amount) external;
270     function claim() external;
271     function airdrop(address payee, uint amount) external;
272     function isRunning() external view returns (bool);
273 }
274 
275 // File: contracts/interfaces/IERC1594.sol
276 
277 pragma solidity 0.5.4;
278 
279 
280 /// @title IERC1594 Security Token Standard
281 /// @dev See https://github.com/SecurityTokenStandard/EIP-Spec
282 interface IERC1594 {
283     // Issuance / Redemption Events
284     event Issued(address indexed _operator, address indexed _to, uint256 _value, bytes _data);
285     event Redeemed(address indexed _operator, address indexed _from, uint256 _value, bytes _data);
286 
287     // Transfers
288     function transferWithData(address _to, uint256 _value, bytes calldata _data) external;
289     function transferFromWithData(address _from, address _to, uint256 _value, bytes calldata _data) external;
290 
291     // Token Redemption
292     function redeem(uint256 _value, bytes calldata _data) external;
293     function redeemFrom(address _tokenHolder, uint256 _value, bytes calldata _data) external;
294 
295     // Token Issuance
296     function issue(address _tokenHolder, uint256 _value, bytes calldata _data) external;
297     function isIssuable() external view returns (bool);
298 
299     // Transfer Validity
300     function canTransfer(address _to, uint256 _value, bytes calldata _data) external view returns (bool, byte, bytes32);
301     function canTransferFrom(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (bool, byte, bytes32);
302 }
303 
304 // File: contracts/interfaces/IHasIssuership.sol
305 
306 pragma solidity 0.5.4;
307 
308 
309 interface IHasIssuership {
310     event IssuershipTransferred(address indexed from, address indexed to);
311 
312     function transferIssuership(address newIssuer) external;
313 }
314 
315 // File: contracts/roles/IssuerStaffRole.sol
316 
317 pragma solidity 0.5.4;
318 
319 
320 
321 // @notice IssuerStaffs are capable of managing over the Issuer contract.
322 contract IssuerStaffRole {
323     using Roles for Roles.Role;
324 
325     event IssuerStaffAdded(address indexed account);
326     event IssuerStaffRemoved(address indexed account);
327 
328     Roles.Role internal _issuerStaffs;
329 
330     modifier onlyIssuerStaff() {
331         require(isIssuerStaff(msg.sender), "Only IssuerStaffs can execute this function.");
332         _;
333     }
334 
335     constructor() internal {
336         _addIssuerStaff(msg.sender);
337     }
338 
339     function isIssuerStaff(address account) public view returns (bool) {
340         return _issuerStaffs.has(account);
341     }
342 
343     function addIssuerStaff(address account) public onlyIssuerStaff {
344         _addIssuerStaff(account);
345     }
346 
347     function renounceIssuerStaff() public {
348         _removeIssuerStaff(msg.sender);
349     }
350 
351     function _addIssuerStaff(address account) internal {
352         _issuerStaffs.add(account);
353         emit IssuerStaffAdded(account);
354     }
355 
356     function _removeIssuerStaff(address account) internal {
357         _issuerStaffs.remove(account);
358         emit IssuerStaffRemoved(account);
359     }
360 }
361 
362 // File: contracts/issuance/Issuer.sol
363 
364 pragma solidity 0.5.4;
365 
366 
367 
368 
369 
370 
371 
372 
373 
374 /**
375  * @notice The Issuer issues claims for TENX tokens which users can claim to receive tokens.
376  */
377 contract Issuer is IIssuer, IHasIssuership, IssuerStaffRole, Ownable, Pausable, ReentrancyGuard {
378     struct Claim {
379         address issuer;
380         ClaimState status;
381         uint amount;
382     }
383 
384     enum ClaimState { NONE, ISSUED, CLAIMED }
385     mapping(address => Claim) public claims;
386 
387     bool public isRunning = true;
388     IERC1594 public token; // Mints tokens to payee's address
389 
390     event Issued(address indexed payee, address indexed issuer, uint amount);
391     event Claimed(address indexed payee, uint amount);
392 
393     /**
394     * @notice Modifier to check that the Issuer contract is currently running.
395     */
396     modifier whenRunning() {
397         require(isRunning, "Issuer contract has stopped running.");
398         _;
399     }    
400 
401     /**
402     * @notice Modifier to check the status of a claim.
403     * @param _payee Payee address
404     * @param _state Claim status    
405     */
406     modifier atState(address _payee, ClaimState _state) {
407         Claim storage c = claims[_payee];
408         require(c.status == _state, "Invalid claim source state.");
409         _;
410     }
411 
412     /**
413     * @notice Modifier to check the status of a claim.
414     * @param _payee Payee address
415     * @param _state Claim status
416     */
417     modifier notAtState(address _payee, ClaimState _state) {
418         Claim storage c = claims[_payee];
419         require(c.status != _state, "Invalid claim source state.");
420         _;
421     }
422 
423     constructor(IERC1594 _token) public {
424         token = _token;
425     }
426 
427     /**
428      * @notice Transfer the token's Issuer role from this contract to another address. Decommissions this Issuer contract.
429      */
430     function transferIssuership(address _newIssuer) 
431         external onlyOwner whenRunning 
432     {
433         require(_newIssuer != address(0), "New Issuer cannot be zero address.");
434         isRunning = false;
435         IHasIssuership t = IHasIssuership(address(token));
436         t.transferIssuership(_newIssuer);
437     }
438 
439     /**
440     * @notice Issue a new claim.
441     * @param _payee The address of the _payee.
442     * @param _amount The amount of tokens the payee will receive.
443     */
444     function issue(address _payee, uint _amount) 
445         external onlyIssuerStaff whenRunning whenNotPaused notAtState(_payee, ClaimState.CLAIMED) 
446     {
447         require(_payee != address(0), "Payee must not be a zero address.");
448         require(_payee != msg.sender, "Issuers cannot issue for themselves");
449         require(_amount > 0, "Claim amount must be positive.");
450         claims[_payee] = Claim({
451             status: ClaimState.ISSUED,
452             amount: _amount,
453             issuer: msg.sender
454         });
455         emit Issued(_payee, msg.sender, _amount);
456     }
457 
458     /**
459     * @notice Function for users to redeem a claim of tokens.
460     * @dev To claim, users must call this contract from their claim address. Tokens equal to the claim amount will be minted to the claim address.
461     */
462     function claim() 
463         external whenRunning whenNotPaused atState(msg.sender, ClaimState.ISSUED) 
464     {
465         address payee = msg.sender;
466         Claim storage c = claims[payee];
467         c.status = ClaimState.CLAIMED; // Marks claim as claimed
468         emit Claimed(payee, c.amount);
469 
470         token.issue(payee, c.amount, ""); // Mints tokens to payee's address
471     }
472 
473     /**
474     * @notice Function to mint tokens to users directly in a single step. Skips the issued state.
475     * @param _payee The address of the _payee.
476     * @param _amount The amount of tokens the payee will receive.    
477     */
478     function airdrop(address _payee, uint _amount) 
479         external onlyIssuerStaff whenRunning whenNotPaused atState(_payee, ClaimState.NONE) nonReentrant 
480     {
481         require(_payee != address(0), "Payee must not be a zero address.");
482         require(_payee != msg.sender, "Issuers cannot airdrop for themselves");
483         require(_amount > 0, "Claim amount must be positive.");
484         claims[_payee] = Claim({
485             status: ClaimState.CLAIMED,
486             amount: _amount,
487             issuer: msg.sender
488         });
489         emit Claimed(_payee, _amount);
490 
491         token.issue(_payee, _amount, ""); // Mints tokens to payee's address
492     }
493 }