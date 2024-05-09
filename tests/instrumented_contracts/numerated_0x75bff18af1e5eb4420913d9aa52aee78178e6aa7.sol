1 pragma solidity ^0.4.24;
2 
3 // File: solidity-shared-lib/contracts/ERC20Interface.sol
4 
5 /**
6 * Copyright 2017–2018, LaborX PTY
7 * Licensed under the AGPL Version 3 license.
8 */
9 
10 pragma solidity ^0.4.23;
11 
12 
13 /// @title Defines an interface for EIP20 token smart contract
14 contract ERC20Interface {
15     
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed from, address indexed spender, uint256 value);
18 
19     string public symbol;
20 
21     function decimals() public view returns (uint8);
22     function totalSupply() public view returns (uint256 supply);
23 
24     function balanceOf(address _owner) public view returns (uint256 balance);
25     function transfer(address _to, uint256 _value) public returns (bool success);
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27     function approve(address _spender, uint256 _value) public returns (bool success);
28     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
29 }
30 
31 // File: solidity-shared-lib/contracts/Owned.sol
32 
33 /**
34 * Copyright 2017–2018, LaborX PTY
35 * Licensed under the AGPL Version 3 license.
36 */
37 
38 pragma solidity ^0.4.23;
39 
40 
41 
42 /// @title Owned contract with safe ownership pass.
43 ///
44 /// Note: all the non constant functions return false instead of throwing in case if state change
45 /// didn't happen yet.
46 contract Owned {
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     address public contractOwner;
51     address public pendingContractOwner;
52 
53     modifier onlyContractOwner {
54         if (msg.sender == contractOwner) {
55             _;
56         }
57     }
58 
59     constructor()
60     public
61     {
62         contractOwner = msg.sender;
63     }
64 
65     /// @notice Prepares ownership pass.
66     /// Can only be called by current owner.
67     /// @param _to address of the next owner.
68     /// @return success.
69     function changeContractOwnership(address _to)
70     public
71     onlyContractOwner
72     returns (bool)
73     {
74         if (_to == 0x0) {
75             return false;
76         }
77         pendingContractOwner = _to;
78         return true;
79     }
80 
81     /// @notice Finalize ownership pass.
82     /// Can only be called by pending owner.
83     /// @return success.
84     function claimContractOwnership()
85     public
86     returns (bool)
87     {
88         if (msg.sender != pendingContractOwner) {
89             return false;
90         }
91 
92         emit OwnershipTransferred(contractOwner, pendingContractOwner);
93         contractOwner = pendingContractOwner;
94         delete pendingContractOwner;
95         return true;
96     }
97 
98     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
99     /// @param newOwner The address to transfer ownership to.
100     function transferOwnership(address newOwner)
101     public
102     onlyContractOwner
103     returns (bool)
104     {
105         if (newOwner == 0x0) {
106             return false;
107         }
108 
109         emit OwnershipTransferred(contractOwner, newOwner);
110         contractOwner = newOwner;
111         delete pendingContractOwner;
112         return true;
113     }
114 
115     /// @notice Withdraw given tokens from contract to owner.
116     /// This method is only allowed for contact owner.
117     function withdrawTokens(address[] tokens)
118     public
119     onlyContractOwner
120     {
121         address _contractOwner = contractOwner;
122         for (uint i = 0; i < tokens.length; i++) {
123             ERC20Interface token = ERC20Interface(tokens[i]);
124             uint balance = token.balanceOf(this);
125             if (balance > 0) {
126                 token.transfer(_contractOwner, balance);
127             }
128         }
129     }
130 
131     /// @notice Withdraw ether from contract to owner.
132     /// This method is only allowed for contact owner.
133     function withdrawEther()
134     public
135     onlyContractOwner
136     {
137         uint balance = address(this).balance;
138         if (balance > 0)  {
139             contractOwner.transfer(balance);
140         }
141     }
142 
143     /// @notice Transfers ether to another address.
144     /// Allowed only for contract owners.
145     /// @param _to recepient address
146     /// @param _value wei to transfer; must be less or equal to total balance on the contract
147     function transferEther(address _to, uint256 _value) 
148     public 
149     onlyContractOwner 
150     {
151         require(_to != 0x0, "INVALID_ETHER_RECEPIENT_ADDRESS");
152         if (_value > address(this).balance) {
153             revert("INVALID_VALUE_TO_TRANSFER_ETHER");
154         }
155         
156         _to.transfer(_value);
157     }
158 }
159 
160 // File: openzeppelin-solidity/contracts/access/Roles.sol
161 
162 /**
163  * @title Roles
164  * @dev Library for managing addresses assigned to a Role.
165  */
166 library Roles {
167   struct Role {
168     mapping (address => bool) bearer;
169   }
170 
171   /**
172    * @dev give an account access to this role
173    */
174   function add(Role storage role, address account) internal {
175     require(account != address(0));
176     role.bearer[account] = true;
177   }
178 
179   /**
180    * @dev remove an account's access to this role
181    */
182   function remove(Role storage role, address account) internal {
183     require(account != address(0));
184     role.bearer[account] = false;
185   }
186 
187   /**
188    * @dev check if an account has this role
189    * @return bool
190    */
191   function has(Role storage role, address account)
192     internal
193     view
194     returns (bool)
195   {
196     require(account != address(0));
197     return role.bearer[account];
198   }
199 }
200 
201 // File: openzeppelin-solidity/contracts/access/roles/SignerRole.sol
202 
203 contract SignerRole {
204   using Roles for Roles.Role;
205 
206   event SignerAdded(address indexed account);
207   event SignerRemoved(address indexed account);
208 
209   Roles.Role private signers;
210 
211   constructor() public {
212     _addSigner(msg.sender);
213   }
214 
215   modifier onlySigner() {
216     require(isSigner(msg.sender));
217     _;
218   }
219 
220   function isSigner(address account) public view returns (bool) {
221     return signers.has(account);
222   }
223 
224   function addSigner(address account) public onlySigner {
225     _addSigner(account);
226   }
227 
228   function renounceSigner() public {
229     _removeSigner(msg.sender);
230   }
231 
232   function _addSigner(address account) internal {
233     signers.add(account);
234     emit SignerAdded(account);
235   }
236 
237   function _removeSigner(address account) internal {
238     signers.remove(account);
239     emit SignerRemoved(account);
240   }
241 }
242 
243 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
244 
245 contract PauserRole {
246   using Roles for Roles.Role;
247 
248   event PauserAdded(address indexed account);
249   event PauserRemoved(address indexed account);
250 
251   Roles.Role private pausers;
252 
253   constructor() public {
254     _addPauser(msg.sender);
255   }
256 
257   modifier onlyPauser() {
258     require(isPauser(msg.sender));
259     _;
260   }
261 
262   function isPauser(address account) public view returns (bool) {
263     return pausers.has(account);
264   }
265 
266   function addPauser(address account) public onlyPauser {
267     _addPauser(account);
268   }
269 
270   function renouncePauser() public {
271     _removePauser(msg.sender);
272   }
273 
274   function _addPauser(address account) internal {
275     pausers.add(account);
276     emit PauserAdded(account);
277   }
278 
279   function _removePauser(address account) internal {
280     pausers.remove(account);
281     emit PauserRemoved(account);
282   }
283 }
284 
285 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
286 
287 /**
288  * @title Pausable
289  * @dev Base contract which allows children to implement an emergency stop mechanism.
290  */
291 contract Pausable is PauserRole {
292   event Paused();
293   event Unpaused();
294 
295   bool private _paused = false;
296 
297 
298   /**
299    * @return true if the contract is paused, false otherwise.
300    */
301   function paused() public view returns(bool) {
302     return _paused;
303   }
304 
305   /**
306    * @dev Modifier to make a function callable only when the contract is not paused.
307    */
308   modifier whenNotPaused() {
309     require(!_paused);
310     _;
311   }
312 
313   /**
314    * @dev Modifier to make a function callable only when the contract is paused.
315    */
316   modifier whenPaused() {
317     require(_paused);
318     _;
319   }
320 
321   /**
322    * @dev called by the owner to pause, triggers stopped state
323    */
324   function pause() public onlyPauser whenNotPaused {
325     _paused = true;
326     emit Paused();
327   }
328 
329   /**
330    * @dev called by the owner to unpause, returns to normal state
331    */
332   function unpause() public onlyPauser whenPaused {
333     _paused = false;
334     emit Unpaused();
335   }
336 }
337 
338 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
339 
340 /**
341  * @title ERC20 interface
342  * @dev see https://github.com/ethereum/EIPs/issues/20
343  */
344 interface IERC20 {
345   function totalSupply() external view returns (uint256);
346 
347   function balanceOf(address who) external view returns (uint256);
348 
349   function allowance(address owner, address spender)
350     external view returns (uint256);
351 
352   function transfer(address to, uint256 value) external returns (bool);
353 
354   function approve(address spender, uint256 value)
355     external returns (bool);
356 
357   function transferFrom(address from, address to, uint256 value)
358     external returns (bool);
359 
360   event Transfer(
361     address indexed from,
362     address indexed to,
363     uint256 value
364   );
365 
366   event Approval(
367     address indexed owner,
368     address indexed spender,
369     uint256 value
370   );
371 }
372 
373 // File: @laborx/airdrop/contracts/ERC223ReceivingContract.sol
374 
375 /**
376  * @title Contract that will work with ERC223 tokens.
377  */
378 
379 interface ERC223ReceivingContract {
380 /**
381  * @dev Standard ERC223 function that will handle incoming token transfers.
382  *
383  * @param _from  Token sender address.
384  * @param _value Amount of tokens.
385  * @param _data  Transaction metadata.
386  */
387     function tokenFallback(address _from, uint _value, bytes _data) external;
388 }
389 
390 // File: @laborx/airdrop/contracts/Airdrop.sol
391 
392 /// @title Airdrop contract based on Merkle tree and merkle proof of addresses and amount of tokens to withdraw.
393 ///     Contract requires that merkle tree was built on leafs keccak256(position, recepient address, amount)
394 ///     Supports ERC223 token standard that allows to receive/not receive tokens that allowed (supported) by smart
395 ///     contracts, so no dummy or mistyped token transfers.
396 contract Airdrop is Owned, SignerRole, Pausable, ERC223ReceivingContract {
397 
398     uint constant OK = 1;
399 
400     /// @dev Log when airdrop
401     event LogAirdropClaimed(address indexed initiator, bytes32 operationId, uint amount);
402     /// @dev Log when merkle root will be updated
403     event LogMerkleRootUpdated(bytes32 to, address by);
404 
405     /// @dev Version of the contract. Allows to distinguish between releases.
406     bytes32 public version = "0.2.0";
407     /// @dev Token to airdrop to.
408     IERC20 public token;
409     /// @dev Merkle root of the airdrop
410     bytes32 public merkleRoot;
411     /// @dev (operation id => completed)
412     mapping(bytes32 => bool) public completedAirdrops;
413 
414     /// @notice Creates airdrop contract. Fails if token `_token` is 0x0.
415     /// @param _token token address to airdrop; supports ERC223 token contracts
416     constructor(address _token)
417     public
418     {
419         require(_token != 0x0, "AIRDROP_INVALID_TOKEN_ADDRESS");
420         token = IERC20(_token);
421     }
422 
423     /// @notice Updates merkle root after changes in airdrop records.
424     ///     Emits 'LogMerkleRootUpdated' event.
425     ///     Only signer allowed to call.
426     /// @param _updatedMerkleRoot new merkle root hash calculated on updated airdrop records.
427     ///     Could be set empty if you need to stop withraws.
428     function setMerkleRoot(bytes32 _updatedMerkleRoot)
429     external
430     onlySigner
431     returns (uint)
432     {
433         merkleRoot = _updatedMerkleRoot;
434 
435         emit LogMerkleRootUpdated(_updatedMerkleRoot, msg.sender);
436         return OK;
437     }
438 
439     /// @notice Claim tokens held by airdrop contract based on proof provided
440     ///     by sender `msg.sender` based on position `_position` in airdrop list.
441     ///     Emits 'LogAirdropClaimed' event when withdraw claim is successful.
442     /// @param _proof merkle proof list of hashes
443     /// @param _operationId unique withrawal operation ID
444     /// @param _position position of airdrop record that is included in proof calculations
445     /// @param _amount amount of tokens to withdraw
446     /// @return result code of an operation. OK (1) if all went good.
447     function claimTokensByMerkleProof(
448         bytes32[] _proof,
449         bytes32 _operationId,
450         uint _position,
451         uint _amount
452     )
453     external
454     whenNotPaused
455     returns (uint)
456     {
457         bytes32 leaf = _calculateMerkleLeaf(_operationId, _position, msg.sender, _amount);
458 
459         require(completedAirdrops[_operationId] == false, "AIRDROP_ALREADY_CLAIMED");
460         require(checkMerkleProof(merkleRoot, _proof, _position, leaf), "AIRDROP_INVALID_PROOF");
461         require(token.transfer(msg.sender, _amount), "AIRDROP_TRANSFER_FAILURE");
462 
463         // Mark operation as completed
464         completedAirdrops[_operationId] = true;
465 
466         emit LogAirdropClaimed(msg.sender, _operationId, _amount);
467         return OK;
468     }
469 
470     /// @notice Checks merkle proof based on the latest merkle root set up.
471     /// @param _merkleRoot merkle root hash to compare result with
472     /// @param _proof merkle proof list of hashes
473     /// @param _position position of airdrop record that is included in proof calculations
474     /// @param _leaf leaf hash that should be tested for containment in merkle tree
475     /// @return true if leaf `_leaf` is included in merkle tree, false otherwise
476     function checkMerkleProof(
477         bytes32 _merkleRoot,
478         bytes32[] _proof,
479         uint _position,
480         bytes32 _leaf
481     )
482     public
483     pure
484     returns (bool)
485     {
486         bytes32 _computedHash = _leaf;
487         uint _checkedPosition = _position;
488 
489         for (uint i = 0; i < _proof.length; i += 1) {
490             bytes32 _proofElement = _proof[i];
491 
492             if (_checkedPosition % 2 == 0) {
493                 _computedHash = keccak256(abi.encodePacked(_computedHash, _proofElement));
494             } else {
495                 _computedHash = keccak256(abi.encodePacked(_proofElement, _computedHash));
496             }
497 
498             _checkedPosition /= 2;
499         }
500 
501         return _computedHash == _merkleRoot;
502     }
503 
504     /*
505         ERC223 token
506 
507         https://github.com/ethereum/EIPs/issues/223
508     */
509 
510     /// @notice Guards smart contract from accepting non-allowed tokens (if they support ERC223 interface)
511     function tokenFallback(address /*_from*/, uint /*_value*/, bytes /*_data*/)
512     external
513     whenNotPaused
514     {
515         require(msg.sender == address(token), "AIRDROP_TOKEN_NOT_SUPPORTED");
516     }
517 
518     /* PRIVATE */
519 
520     /// @notice Gets merkle leaf based on index `_index`, destination address `_address` and
521     ///     amount of tokens to transfer `_amount`
522     function _calculateMerkleLeaf(bytes32 _operationId, uint _index, address _address, uint _amount)
523     private
524     pure
525     returns (bytes32)
526     {
527         return keccak256(abi.encodePacked(_operationId, _index, _address, _amount));
528     }
529 }
530 
531 // File: contracts/Import.sol
532 
533 /**
534 * Copyright 2017–2018, LaborX PTY
535 * Licensed under the AGPL Version 3 license.
536 */
537 
538 pragma solidity ^0.4.24;