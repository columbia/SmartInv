1 // File: contracts/zeppelin/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/zeppelin/token/ERC20/ERC20Detailed.sol
81 
82 pragma solidity ^0.5.0;
83 
84 
85 /**
86  * @dev Optional functions from the ERC20 standard.
87  */
88 contract ERC20Detailed is IERC20 {
89     string private _name;
90     string private _symbol;
91     uint8 private _decimals;
92 
93     /**
94      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
95      * these values are immutable: they can only be set once during
96      * construction.
97      */
98     constructor (string memory name, string memory symbol, uint8 decimals) public {
99         _name = name;
100         _symbol = symbol;
101         _decimals = decimals;
102     }
103 
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() public view returns (string memory) {
108         return _name;
109     }
110 
111     /**
112      * @dev Returns the symbol of the token, usually a shorter version of the
113      * name.
114      */
115     function symbol() public view returns (string memory) {
116         return _symbol;
117     }
118 
119     /**
120      * @dev Returns the number of decimals used to get its user representation.
121      * For example, if `decimals` equals `2`, a balance of `505` tokens should
122      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
123      *
124      * Tokens usually opt for a value of 18, imitating the relationship between
125      * Ether and Wei.
126      *
127      * NOTE: This information is only used for _display_ purposes: it in
128      * no way affects any of the arithmetic of the contract, including
129      * {IERC20-balanceOf} and {IERC20-transfer}.
130      */
131     function decimals() public view returns (uint8) {
132         return _decimals;
133     }
134 }
135 
136 // File: contracts/IBridge.sol
137 
138 pragma solidity ^0.5.0;
139 
140 
141 interface IBridge {
142     function version() external pure returns (string memory);
143 
144     function getFeePercentage() external view returns(uint);
145 
146     function calcMaxWithdraw() external view returns (uint);
147 
148     /**
149      * ERC-20 tokens approve and transferFrom pattern
150      * See https://eips.ethereum.org/EIPS/eip-20#transferfrom
151      */
152     function receiveTokens(address tokenToUse, uint256 amount) external returns(bool);
153 
154     /**
155      * ERC-20 tokens approve and transferFrom pattern
156      * See https://eips.ethereum.org/EIPS/eip-20#transferfrom
157      */
158     function receiveTokensAt(
159         address tokenToUse,
160         uint256 amount,
161         address receiver,
162         bytes calldata extraData
163     ) external returns(bool);
164 
165     /**
166      * ERC-777 tokensReceived hook allows to send tokens to a contract and notify it in a single transaction
167      * See https://eips.ethereum.org/EIPS/eip-777#motivation for details
168      */
169     function tokensReceived (
170         address operator,
171         address from,
172         address to,
173         uint amount,
174         bytes calldata userData,
175         bytes calldata operatorData
176     ) external;
177 
178     /**
179      * Accepts the transaction from the other chain that was voted and sent by the federation contract
180      */
181     function acceptTransfer(
182         address originalTokenAddress,
183         address receiver,
184         uint256 amount,
185         string calldata symbol,
186         bytes32 blockHash,
187         bytes32 transactionHash,
188         uint32 logIndex,
189         uint8 decimals,
190         uint256 granularity
191     ) external returns(bool);
192 
193     function acceptTransferAt(
194         address originalTokenAddress,
195         address receiver,
196         uint256 amount,
197         string calldata symbol,
198         bytes32 blockHash,
199         bytes32 transactionHash,
200         uint32 logIndex,
201         uint8 decimals,
202         uint256 granularity,
203         bytes calldata userData
204     ) external returns(bool);
205 
206     event Cross(address indexed _tokenAddress, address indexed _to, uint256 _amount, string _symbol, bytes _userData,
207         uint8 _decimals, uint256 _granularity);
208     event NewSideToken(address indexed _newSideTokenAddress, address indexed _originalTokenAddress, string _newSymbol, uint256 _granularity);
209     event AcceptedCrossTransfer(address indexed _tokenAddress, address indexed _to, uint256 _amount, uint8 _decimals, uint256 _granularity,
210         uint256 _formattedAmount, uint8 _calculatedDecimals, uint256 _calculatedGranularity, bytes _userData);
211     event FeePercentageChanged(uint256 _amount);
212     event ErrorTokenReceiver(bytes _errorData);
213 }
214 
215 // File: contracts/zeppelin/GSN/Context.sol
216 
217 pragma solidity ^0.5.0;
218 
219 /*
220  * @dev Provides information about the current execution context, including the
221  * sender of the transaction and its data. While these are generally available
222  * via msg.sender and msg.data, they should not be accessed in such a direct
223  * manner, since when dealing with GSN meta-transactions the account sending and
224  * paying for execution may not be the actual sender (as far as an application
225  * is concerned).
226  *
227  * This contract is only required for intermediate, library-like contracts.
228  */
229 contract Context {
230     // Empty internal constructor, to prevent people from mistakenly deploying
231     // an instance of this contract, which should be used via inheritance.
232     constructor () internal { }
233     // solhint-disable-previous-line no-empty-blocks
234 
235     function _msgSender() internal view returns (address payable) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view returns (bytes memory) {
240         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
241         return msg.data;
242     }
243 }
244 
245 // File: contracts/zeppelin/ownership/Ownable.sol
246 
247 pragma solidity ^0.5.0;
248 
249 /**
250  * @dev Contract module which provides a basic access control mechanism, where
251  * there is an account (an owner) that can be granted exclusive access to
252  * specific functions.
253  *
254  * This module is used through inheritance. It will make available the modifier
255  * `onlyOwner`, which can be applied to your functions to restrict their use to
256  * the owner.
257  */
258 contract Ownable is Context {
259     address private _owner;
260 
261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263     /**
264      * @dev Initializes the contract setting the deployer as the initial owner.
265      */
266     constructor () internal {
267         _owner = _msgSender();
268         emit OwnershipTransferred(address(0), _owner);
269     }
270 
271     /**
272      * @dev Returns the address of the current owner.
273      */
274     function owner() public view returns (address) {
275         return _owner;
276     }
277 
278     /**
279      * @dev Throws if called by any account other than the owner.
280      */
281     modifier onlyOwner() {
282         require(isOwner(), "Ownable: caller is not the owner");
283         _;
284     }
285 
286     /**
287      * @dev Returns true if the caller is the current owner.
288      */
289     function isOwner() public view returns (bool) {
290         return _msgSender() == _owner;
291     }
292 
293     /**
294      * @dev Leaves the contract without owner. It will not be possible to call
295      * `onlyOwner` functions anymore. Can only be called by the current owner.
296      *
297      * NOTE: Renouncing ownership will leave the contract without an owner,
298      * thereby removing any functionality that is only available to the owner.
299      */
300     function renounceOwnership() public onlyOwner {
301         emit OwnershipTransferred(_owner, address(0));
302         _owner = address(0);
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Can only be called by the current owner.
308      */
309     function transferOwnership(address newOwner) public onlyOwner {
310         _transferOwnership(newOwner);
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      */
316     function _transferOwnership(address newOwner) internal {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         emit OwnershipTransferred(_owner, newOwner);
319         _owner = newOwner;
320     }
321 }
322 
323 // File: contracts/Federation.sol
324 
325 pragma solidity ^0.5.0;
326 
327 
328 
329 contract Federation is Ownable {
330     uint constant public MAX_MEMBER_COUNT = 50;
331     address constant private NULL_ADDRESS = address(0);
332 
333     IBridge public bridge;
334     address[] public members;
335     uint public required;
336 
337     mapping (address => bool) public isMember;
338     mapping (bytes32 => mapping (address => bool)) public votes;
339     mapping(bytes32 => bool) public processed;
340     // solium-disable-next-line max-len
341     event Voted(address indexed sender, bytes32 indexed transactionId, address originalTokenAddress, address receiver, uint256 amount, string symbol, bytes32 blockHash, bytes32 indexed transactionHash, uint32 logIndex, uint8 decimals, uint256 granularity);
342     event Executed(bytes32 indexed transactionId);
343     event MemberAddition(address indexed member);
344     event MemberRemoval(address indexed member);
345     event RequirementChange(uint required);
346     event BridgeChanged(address bridge);
347 
348     modifier onlyMember() {
349         require(isMember[_msgSender()], "Federation: Caller not a Federator");
350         _;
351     }
352 
353     modifier validRequirement(uint membersCount, uint _required) {
354         // solium-disable-next-line max-len
355         require(_required <= membersCount && _required != 0 && membersCount != 0, "Federation: Invalid requirements");
356         _;
357     }
358 
359     constructor(address[] memory _members, uint _required) public validRequirement(_members.length, _required) {
360         require(_members.length <= MAX_MEMBER_COUNT, "Federation: Members larger than max allowed");
361         members = _members;
362         for (uint i = 0; i < _members.length; i++) {
363             require(!isMember[_members[i]] && _members[i] != NULL_ADDRESS, "Federation: Invalid members");
364             isMember[_members[i]] = true;
365             emit MemberAddition(_members[i]);
366         }
367         required = _required;
368         emit RequirementChange(required);
369     }
370 
371     function setBridge(address _bridge) external onlyOwner {
372         require(_bridge != NULL_ADDRESS, "Federation: Empty bridge");
373         bridge = IBridge(_bridge);
374         emit BridgeChanged(_bridge);
375     }
376 
377     function voteTransaction(
378         address originalTokenAddress,
379         address receiver,
380         uint256 amount,
381         string calldata symbol,
382         bytes32 blockHash,
383         bytes32 transactionHash,
384         uint32 logIndex,
385         uint8 decimals,
386         uint256 granularity)
387     external returns(bool)
388     {
389         return _voteTransaction(originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity, "");
390     }
391 
392     function voteTransactionAt(
393         address originalTokenAddress,
394         address receiver,
395         uint256 amount,
396         string calldata symbol,
397         bytes32 blockHash,
398         bytes32 transactionHash,
399         uint32 logIndex,
400         uint8 decimals,
401         uint256 granularity,
402         bytes calldata userData)
403     external returns(bool)
404     {
405         return _voteTransaction(originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity, userData);
406     }
407 
408     function _voteTransaction(
409         address originalTokenAddress,
410         address receiver,
411         uint256 amount,
412         string memory symbol,
413         bytes32 blockHash,
414         bytes32 transactionHash,
415         uint32 logIndex,
416         uint8 decimals,
417         uint256 granularity,
418         bytes memory userData
419     ) internal onlyMember returns(bool) {
420         // solium-disable-next-line max-len
421         bytes32 transactionId = getTransactionId(originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity);
422         if (processed[transactionId])
423             return true;
424 
425         if (votes[transactionId][_msgSender()])
426             return true;
427 
428         votes[transactionId][_msgSender()] = true;
429         // solium-disable-next-line max-len
430         emit Voted(_msgSender(), transactionId, originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity);
431 
432         uint transactionCount = getTransactionCount(transactionId);
433         if (transactionCount >= required && transactionCount >= members.length / 2 + 1) {
434             processed[transactionId] = true;
435             bool acceptTransfer = bridge.acceptTransferAt(
436                 originalTokenAddress,
437                 receiver,
438                 amount,
439                 symbol,
440                 blockHash,
441                 transactionHash,
442                 logIndex,
443                 decimals,
444                 granularity,
445                 userData
446             );
447             require(acceptTransfer, "Federation: Bridge acceptTransfer error");
448             emit Executed(transactionId);
449             return true;
450         }
451 
452         return true;
453     }
454 
455     function getTransactionCount(bytes32 transactionId) public view returns(uint) {
456         uint count = 0;
457         for (uint i = 0; i < members.length; i++) {
458             if (votes[transactionId][members[i]])
459                 count += 1;
460         }
461         return count;
462     }
463 
464     function hasVoted(bytes32 transactionId) external view returns(bool)
465     {
466         return votes[transactionId][_msgSender()];
467     }
468 
469     function transactionWasProcessed(bytes32 transactionId) external view returns(bool)
470     {
471         return processed[transactionId];
472     }
473 
474     function getTransactionId(
475         address originalTokenAddress,
476         address receiver,
477         uint256 amount,
478         string memory symbol,
479         bytes32 blockHash,
480         bytes32 transactionHash,
481         uint32 logIndex,
482         uint8 decimals,
483         uint256 granularity)
484     public pure returns(bytes32)
485     {
486         // solium-disable-next-line max-len
487         return keccak256(abi.encodePacked(originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity));
488     }
489 
490     function addMember(address _newMember) external onlyOwner
491     {
492         require(_newMember != NULL_ADDRESS, "Federation: Empty member");
493         require(!isMember[_newMember], "Federation: Member already exists");
494         require(members.length < MAX_MEMBER_COUNT, "Federation: Max members reached");
495 
496         isMember[_newMember] = true;
497         members.push(_newMember);
498         emit MemberAddition(_newMember);
499     }
500 
501     function removeMember(address _oldMember) external onlyOwner
502     {
503         require(_oldMember != NULL_ADDRESS, "Federation: Empty member");
504         require(isMember[_oldMember], "Federation: Member doesn't exists");
505         require(members.length > 1, "Federation: Can't remove all the members");
506         require(members.length - 1 >= required, "Federation: Can't have less than required members");
507 
508         isMember[_oldMember] = false;
509         for (uint i = 0; i < members.length - 1; i++) {
510             if (members[i] == _oldMember) {
511                 members[i] = members[members.length - 1];
512                 break;
513             }
514         }
515         members.length -= 1;
516         emit MemberRemoval(_oldMember);
517     }
518 
519     function getMembers() external view returns (address[] memory)
520     {
521         return members;
522     }
523 
524     function changeRequirement(uint _required) external onlyOwner validRequirement(members.length, _required)
525     {
526         require(_required >= 2, "Federation: Requires at least 2");
527         required = _required;
528         emit RequirementChange(_required);
529     }
530 
531 }