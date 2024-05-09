1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 
72     /**
73      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
74      * `nonReentrant` function in the call stack.
75      */
76     function _reentrancyGuardEntered() internal view returns (bool) {
77         return _status == _ENTERED;
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/security/Pausable.sol
109 
110 
111 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 
116 /**
117  * @dev Contract module which allows children to implement an emergency stop
118  * mechanism that can be triggered by an authorized account.
119  *
120  * This module is used through inheritance. It will make available the
121  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
122  * the functions of your contract. Note that they will not be pausable by
123  * simply including this module, only once the modifiers are put in place.
124  */
125 abstract contract Pausable is Context {
126     /**
127      * @dev Emitted when the pause is triggered by `account`.
128      */
129     event Paused(address account);
130 
131     /**
132      * @dev Emitted when the pause is lifted by `account`.
133      */
134     event Unpaused(address account);
135 
136     bool private _paused;
137 
138     /**
139      * @dev Initializes the contract in unpaused state.
140      */
141     constructor() {
142         _paused = false;
143     }
144 
145     /**
146      * @dev Modifier to make a function callable only when the contract is not paused.
147      *
148      * Requirements:
149      *
150      * - The contract must not be paused.
151      */
152     modifier whenNotPaused() {
153         _requireNotPaused();
154         _;
155     }
156 
157     /**
158      * @dev Modifier to make a function callable only when the contract is paused.
159      *
160      * Requirements:
161      *
162      * - The contract must be paused.
163      */
164     modifier whenPaused() {
165         _requirePaused();
166         _;
167     }
168 
169     /**
170      * @dev Returns true if the contract is paused, and false otherwise.
171      */
172     function paused() public view virtual returns (bool) {
173         return _paused;
174     }
175 
176     /**
177      * @dev Throws if the contract is paused.
178      */
179     function _requireNotPaused() internal view virtual {
180         require(!paused(), "Pausable: paused");
181     }
182 
183     /**
184      * @dev Throws if the contract is not paused.
185      */
186     function _requirePaused() internal view virtual {
187         require(paused(), "Pausable: not paused");
188     }
189 
190     /**
191      * @dev Triggers stopped state.
192      *
193      * Requirements:
194      *
195      * - The contract must not be paused.
196      */
197     function _pause() internal virtual whenNotPaused {
198         _paused = true;
199         emit Paused(_msgSender());
200     }
201 
202     /**
203      * @dev Returns to normal state.
204      *
205      * Requirements:
206      *
207      * - The contract must be paused.
208      */
209     function _unpause() internal virtual whenPaused {
210         _paused = false;
211         emit Unpaused(_msgSender());
212     }
213 }
214 
215 // File: @openzeppelin/contracts/access/Ownable.sol
216 
217 
218 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 
223 /**
224  * @dev Contract module which provides a basic access control mechanism, where
225  * there is an account (an owner) that can be granted exclusive access to
226  * specific functions.
227  *
228  * By default, the owner account will be the one that deploys the contract. This
229  * can later be changed with {transferOwnership}.
230  *
231  * This module is used through inheritance. It will make available the modifier
232  * `onlyOwner`, which can be applied to your functions to restrict their use to
233  * the owner.
234  */
235 abstract contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor() {
244         _transferOwnership(_msgSender());
245     }
246 
247     /**
248      * @dev Throws if called by any account other than the owner.
249      */
250     modifier onlyOwner() {
251         _checkOwner();
252         _;
253     }
254 
255     /**
256      * @dev Returns the address of the current owner.
257      */
258     function owner() public view virtual returns (address) {
259         return _owner;
260     }
261 
262     /**
263      * @dev Throws if the sender is not the owner.
264      */
265     function _checkOwner() internal view virtual {
266         require(owner() == _msgSender(), "Ownable: caller is not the owner");
267     }
268 
269     /**
270      * @dev Leaves the contract without owner. It will not be possible to call
271      * `onlyOwner` functions anymore. Can only be called by the current owner.
272      *
273      * NOTE: Renouncing ownership will leave the contract without an owner,
274      * thereby removing any functionality that is only available to the owner.
275      */
276     function renounceOwnership() public virtual onlyOwner {
277         _transferOwnership(address(0));
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         _transferOwnership(newOwner);
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      * Internal function without access restriction.
292      */
293     function _transferOwnership(address newOwner) internal virtual {
294         address oldOwner = _owner;
295         _owner = newOwner;
296         emit OwnershipTransferred(oldOwner, newOwner);
297     }
298 }
299 
300 // File: contracts/Claim_Funds/ClaimFunds.sol
301 
302 
303 
304 pragma solidity 0.8.19;
305 
306 
307 
308 
309 
310 /**
311  * @title ClaimFunds
312  * @dev ClaimFunds for the addresses
313  */
314 contract ClaimFunds is Ownable, Pausable, ReentrancyGuard  {
315 
316     // Mapping to hold user and amount
317     mapping(address => uint256) private userToAmounts;
318     // Mapping to hold user and claimed status
319     mapping(address => bool) private claimed;
320     event FundsAdded(address indexed owner, uint _amount);
321     event Claimed(address indexed _claimer, uint _amount);
322     event EmergencyPullFunds(address indexed owner, uint _amount);
323 
324      receive() external payable {
325          emit FundsAdded(msg.sender, msg.value);
326      }
327 
328     modifier notContract() {
329         require(!isContract(msg.sender), "ClaimFunds: Contract is not allowed");
330     _;
331     }
332 
333     modifier noProxy() {
334         require(msg.sender == tx.origin, "ClaimFunds: No proxy is allowed");
335     _;
336     }
337 
338     modifier isClaimer() {
339         require(userToAmounts[msg.sender] > 0 && claimed[msg.sender] != true, "ClaimFunds: User is not present");
340     _;
341     }
342      modifier onlyClaimer() {
343         require(userToAmounts[msg.sender] > 0, "ClaimFunds: User is not present");
344     _;
345     }
346 
347     function isContract(address addr) internal view returns (bool) {
348         uint size;
349         assembly { size := extcodesize(addr) }
350         return size > 0;
351     }
352 
353      function setUsersToAmounts(address[] calldata _users, uint256[] calldata _amounts) external onlyOwner {
354          require(_users.length == _amounts.length, "ClaimFunds: The data is not correct");
355          uint counter = _users.length;
356          for(uint i=0; i<counter; i++) {
357              require(userToAmounts[_users[i]] == 0, "ClaimFunds: Please remove the duplicate set operations");
358              userToAmounts[_users[i]] = _amounts[i];
359          }
360 
361      }
362 
363      function updateUserToAmount(address _user, uint256 _amount) external onlyOwner {
364          require(userToAmounts[_user] > 0 && claimed[_user] != true, "ClaimFunds: User not set or already claimed");
365          userToAmounts[_user] = _amount;
366 
367      }
368 
369      function claim() external nonReentrant whenNotPaused notContract noProxy isClaimer {
370          uint _amount = userToAmounts[msg.sender];
371          claimed[msg.sender] = true;
372          (bool success,) = msg.sender.call{value: _amount}("");
373          require(success, "ClaimFunds: Failed to claim");
374          emit Claimed(msg.sender, _amount);
375      }
376 
377      function emergencyPullAllFunds() external onlyOwner {
378          uint256 _amount = address(this).balance;
379          pullFunds(_amount);
380         }
381 
382      function emergencyPullFunds(uint256 _amount) external onlyOwner {
383          require(_amount>0, "ClaimFunds: Amount cannot be zero");
384          pullFunds(_amount);
385      }
386 
387      function pullFunds(uint256 _amount) private {
388          (bool success,) = msg.sender.call{value: _amount}("");
389          require(success, "ClaimFunds: Failed to claim");
390          emit EmergencyPullFunds(msg.sender, _amount);
391      }
392 
393      function pause() external onlyOwner {
394          _pause();
395      }
396 
397      function unpause() external onlyOwner {
398          _unpause();
399      }
400 
401      function checkIfClaimed(address user) external view returns(bool) {
402          require(userToAmounts[user] > 0, "ClaimFunds: User does not exist");
403          return claimed[user];
404      }
405      
406        
407     
408 }