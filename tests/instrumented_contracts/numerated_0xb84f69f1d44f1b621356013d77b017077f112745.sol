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
155      * ERC-777 tokensReceived hook allows to send tokens to a contract and notify it in a single transaction
156      * See https://eips.ethereum.org/EIPS/eip-777#motivation for details
157      */
158     function tokensReceived (
159         address operator,
160         address from,
161         address to,
162         uint amount,
163         bytes calldata userData,
164         bytes calldata operatorData
165     ) external;
166 
167     /**
168      * Accepts the transaction from the other chain that was voted and sent by the federation contract
169      */
170     function acceptTransfer(
171         address originalTokenAddress,
172         address receiver,
173         uint256 amount,
174         string calldata symbol,
175         bytes32 blockHash,
176         bytes32 transactionHash,
177         uint32 logIndex,
178         uint8 decimals,
179         uint256 granularity
180     ) external returns(bool);
181 
182     event Cross(address indexed _tokenAddress, address indexed _to, uint256 _amount, string _symbol, bytes _userData,
183         uint8 _decimals, uint256 _granularity);
184     event NewSideToken(address indexed _newSideTokenAddress, address indexed _originalTokenAddress, string _newSymbol, uint256 _granularity);
185     event AcceptedCrossTransfer(address indexed _tokenAddress, address indexed _to, uint256 _amount, uint8 _decimals, uint256 _granularity,
186         uint256 _formattedAmount, uint8 _calculatedDecimals, uint256 _calculatedGranularity);
187     event FeePercentageChanged(uint256 _amount);
188 }
189 
190 // File: contracts/zeppelin/GSN/Context.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /*
195  * @dev Provides information about the current execution context, including the
196  * sender of the transaction and its data. While these are generally available
197  * via msg.sender and msg.data, they should not be accessed in such a direct
198  * manner, since when dealing with GSN meta-transactions the account sending and
199  * paying for execution may not be the actual sender (as far as an application
200  * is concerned).
201  *
202  * This contract is only required for intermediate, library-like contracts.
203  */
204 contract Context {
205     // Empty internal constructor, to prevent people from mistakenly deploying
206     // an instance of this contract, which should be used via inheritance.
207     constructor () internal { }
208     // solhint-disable-previous-line no-empty-blocks
209 
210     function _msgSender() internal view returns (address payable) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view returns (bytes memory) {
215         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
216         return msg.data;
217     }
218 }
219 
220 // File: contracts/zeppelin/ownership/Ownable.sol
221 
222 pragma solidity ^0.5.0;
223 
224 /**
225  * @dev Contract module which provides a basic access control mechanism, where
226  * there is an account (an owner) that can be granted exclusive access to
227  * specific functions.
228  *
229  * This module is used through inheritance. It will make available the modifier
230  * `onlyOwner`, which can be applied to your functions to restrict their use to
231  * the owner.
232  */
233 contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor () internal {
242         _owner = _msgSender();
243         emit OwnershipTransferred(address(0), _owner);
244     }
245 
246     /**
247      * @dev Returns the address of the current owner.
248      */
249     function owner() public view returns (address) {
250         return _owner;
251     }
252 
253     /**
254      * @dev Throws if called by any account other than the owner.
255      */
256     modifier onlyOwner() {
257         require(isOwner(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     /**
262      * @dev Returns true if the caller is the current owner.
263      */
264     function isOwner() public view returns (bool) {
265         return _msgSender() == _owner;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public onlyOwner {
285         _transferOwnership(newOwner);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      */
291     function _transferOwnership(address newOwner) internal {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         emit OwnershipTransferred(_owner, newOwner);
294         _owner = newOwner;
295     }
296 }
297 
298 // File: contracts/Federation.sol
299 
300 pragma solidity ^0.5.0;
301 
302 
303 
304 contract Federation is Ownable {
305     uint constant public MAX_MEMBER_COUNT = 50;
306     address constant private NULL_ADDRESS = address(0);
307 
308     IBridge public bridge;
309     address[] public members;
310     uint public required;
311 
312     mapping (address => bool) public isMember;
313     mapping (bytes32 => mapping (address => bool)) public votes;
314     mapping(bytes32 => bool) public processed;
315     // solium-disable-next-line max-len
316     event Voted(address indexed sender, bytes32 indexed transactionId, address originalTokenAddress, address receiver, uint256 amount, string symbol, bytes32 blockHash, bytes32 indexed transactionHash, uint32 logIndex, uint8 decimals, uint256 granularity);
317     event Executed(bytes32 indexed transactionId);
318     event MemberAddition(address indexed member);
319     event MemberRemoval(address indexed member);
320     event RequirementChange(uint required);
321     event BridgeChanged(address bridge);
322 
323     modifier onlyMember() {
324         require(isMember[_msgSender()], "Federation: Caller not a Federator");
325         _;
326     }
327 
328     modifier validRequirement(uint membersCount, uint _required) {
329         // solium-disable-next-line max-len
330         require(_required <= membersCount && _required != 0 && membersCount != 0, "Federation: Invalid requirements");
331         _;
332     }
333 
334     constructor(address[] memory _members, uint _required) public validRequirement(_members.length, _required) {
335         require(_members.length <= MAX_MEMBER_COUNT, "Federation: Members larger than max allowed");
336         members = _members;
337         for (uint i = 0; i < _members.length; i++) {
338             require(!isMember[_members[i]] && _members[i] != NULL_ADDRESS, "Federation: Invalid members");
339             isMember[_members[i]] = true;
340             emit MemberAddition(_members[i]);
341         }
342         required = _required;
343         emit RequirementChange(required);
344     }
345 
346     function setBridge(address _bridge) external onlyOwner {
347         require(_bridge != NULL_ADDRESS, "Federation: Empty bridge");
348         bridge = IBridge(_bridge);
349         emit BridgeChanged(_bridge);
350     }
351 
352     function voteTransaction(
353         address originalTokenAddress,
354         address receiver,
355         uint256 amount,
356         string calldata symbol,
357         bytes32 blockHash,
358         bytes32 transactionHash,
359         uint32 logIndex,
360         uint8 decimals,
361         uint256 granularity)
362     external onlyMember returns(bool)
363     {
364         // solium-disable-next-line max-len
365         bytes32 transactionId = getTransactionId(originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity);
366         if (processed[transactionId])
367             return true;
368 
369         if (votes[transactionId][_msgSender()])
370             return true;
371 
372         votes[transactionId][_msgSender()] = true;
373         // solium-disable-next-line max-len
374         emit Voted(_msgSender(), transactionId, originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity);
375 
376         uint transactionCount = getTransactionCount(transactionId);
377         if (transactionCount >= required && transactionCount >= members.length / 2 + 1) {
378             processed[transactionId] = true;
379             bool acceptTransfer = bridge.acceptTransfer(originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity);
380             require(acceptTransfer, "Federation: Bridge acceptTransfer error");
381             emit Executed(transactionId);
382             return true;
383         }
384 
385         return true;
386     }
387 
388     function getTransactionCount(bytes32 transactionId) public view returns(uint) {
389         uint count = 0;
390         for (uint i = 0; i < members.length; i++) {
391             if (votes[transactionId][members[i]])
392                 count += 1;
393         }
394         return count;
395     }
396 
397     function hasVoted(bytes32 transactionId) external view returns(bool)
398     {
399         return votes[transactionId][_msgSender()];
400     }
401 
402     function transactionWasProcessed(bytes32 transactionId) external view returns(bool)
403     {
404         return processed[transactionId];
405     }
406 
407     function getTransactionId(
408         address originalTokenAddress,
409         address receiver,
410         uint256 amount,
411         string memory symbol,
412         bytes32 blockHash,
413         bytes32 transactionHash,
414         uint32 logIndex,
415         uint8 decimals,
416         uint256 granularity)
417     public pure returns(bytes32)
418     {
419         // solium-disable-next-line max-len
420         return keccak256(abi.encodePacked(originalTokenAddress, receiver, amount, symbol, blockHash, transactionHash, logIndex, decimals, granularity));
421     }
422 
423     function addMember(address _newMember) external onlyOwner
424     {
425         require(_newMember != NULL_ADDRESS, "Federation: Empty member");
426         require(!isMember[_newMember], "Federation: Member already exists");
427         require(members.length < MAX_MEMBER_COUNT, "Federation: Max members reached");
428 
429         isMember[_newMember] = true;
430         members.push(_newMember);
431         emit MemberAddition(_newMember);
432     }
433 
434     function removeMember(address _oldMember) external onlyOwner
435     {
436         require(_oldMember != NULL_ADDRESS, "Federation: Empty member");
437         require(isMember[_oldMember], "Federation: Member doesn't exists");
438         require(members.length > 1, "Federation: Can't remove all the members");
439         require(members.length - 1 >= required, "Federation: Can't have less than required members");
440 
441         isMember[_oldMember] = false;
442         for (uint i = 0; i < members.length - 1; i++) {
443             if (members[i] == _oldMember) {
444                 members[i] = members[members.length - 1];
445                 break;
446             }
447         }
448         members.length -= 1;
449         emit MemberRemoval(_oldMember);
450     }
451 
452     function getMembers() external view returns (address[] memory)
453     {
454         return members;
455     }
456 
457     function changeRequirement(uint _required) external onlyOwner validRequirement(members.length, _required)
458     {
459         require(_required >= 2, "Federation: Requires at least 2");
460         required = _required;
461         emit RequirementChange(_required);
462     }
463 
464 }