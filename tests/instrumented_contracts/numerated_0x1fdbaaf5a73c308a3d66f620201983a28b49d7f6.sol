1 // SPDX-License-Identifier: MIT
2 /*
3  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
4 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
5 ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
6 ▐░▌       ▐░▌     ▐░▌     ▐░▌          
7 ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░▌          
8 ▐░░░░░░░░░░░▌     ▐░▌     ▐░▌          
9 ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░▌          
10 ▐░▌       ▐░▌     ▐░▌     ▐░▌          
11 ▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ 
12 ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
13  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ 
14            By Devko.dev#7286
15 */
16 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 // CAUTION
21 // This version of SafeMath should only be used with Solidity 0.8 or later,
22 // because it relies on the compiler's built in overflow checks.
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations.
26  *
27  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
28  * now has built in overflow checking.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function tryAdd(uint256 a, uint256 b)
37         internal
38         pure
39         returns (bool, uint256)
40     {
41         unchecked {
42             uint256 c = a + b;
43             if (c < a) return (false, 0);
44             return (true, c);
45         }
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function trySub(uint256 a, uint256 b)
54         internal
55         pure
56         returns (bool, uint256)
57     {
58         unchecked {
59             if (b > a) return (false, 0);
60             return (true, a - b);
61         }
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryMul(uint256 a, uint256 b)
70         internal
71         pure
72         returns (bool, uint256)
73     {
74         unchecked {
75             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76             // benefit is lost if 'b' is also tested.
77             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78             if (a == 0) return (true, 0);
79             uint256 c = a * b;
80             if (c / a != b) return (false, 0);
81             return (true, c);
82         }
83     }
84 
85     /**
86      * @dev Returns the division of two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryDiv(uint256 a, uint256 b)
91         internal
92         pure
93         returns (bool, uint256)
94     {
95         unchecked {
96             if (b == 0) return (false, 0);
97             return (true, a / b);
98         }
99     }
100 
101     /**
102      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryMod(uint256 a, uint256 b)
107         internal
108         pure
109         returns (bool, uint256)
110     {
111         unchecked {
112             if (b == 0) return (false, 0);
113             return (true, a % b);
114         }
115     }
116 
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a + b;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a - b;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a * b;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers, reverting on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator.
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a / b;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * reverting when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186         return a % b;
187     }
188 
189     /**
190      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
191      * overflow (when the result is negative).
192      *
193      * CAUTION: This function is deprecated because it requires allocating memory for the error
194      * message unnecessarily. For custom revert reasons use {trySub}.
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      *
200      * - Subtraction cannot overflow.
201      */
202     function sub(
203         uint256 a,
204         uint256 b,
205         string memory errorMessage
206     ) internal pure returns (uint256) {
207         unchecked {
208             require(b <= a, errorMessage);
209             return a - b;
210         }
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a / b;
233         }
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * reverting with custom message when dividing by zero.
239      *
240      * CAUTION: This function is deprecated because it requires allocating memory for the error
241      * message unnecessarily. For custom revert reasons use {tryMod}.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(
252         uint256 a,
253         uint256 b,
254         string memory errorMessage
255     ) internal pure returns (uint256) {
256         unchecked {
257             require(b > 0, errorMessage);
258             return a % b;
259         }
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Context.sol
264 
265 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Provides information about the current execution context, including the
271  * sender of the transaction and its data. While these are generally available
272  * via msg.sender and msg.data, they should not be accessed in such a direct
273  * manner, since when dealing with meta-transactions the account sending and
274  * paying for execution may not be the actual sender (as far as an application
275  * is concerned).
276  *
277  * This contract is only required for intermediate, library-like contracts.
278  */
279 abstract contract Context {
280     function _msgSender() internal view virtual returns (address) {
281         return msg.sender;
282     }
283 
284     function _msgData() internal view virtual returns (bytes calldata) {
285         return msg.data;
286     }
287 }
288 
289 // File: @openzeppelin/contracts/access/Ownable.sol
290 
291 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Contract module which provides a basic access control mechanism, where
297  * there is an account (an owner) that can be granted exclusive access to
298  * specific functions.
299  *
300  * By default, the owner account will be the one that deploys the contract. This
301  * can later be changed with {transferOwnership}.
302  *
303  * This module is used through inheritance. It will make available the modifier
304  * `onlyOwner`, which can be applied to your functions to restrict their use to
305  * the owner.
306  */
307 abstract contract Ownable is Context {
308     address private _owner;
309 
310     event OwnershipTransferred(
311         address indexed previousOwner,
312         address indexed newOwner
313     );
314 
315     /**
316      * @dev Initializes the contract setting the deployer as the initial owner.
317      */
318     constructor() {
319         _transferOwnership(_msgSender());
320     }
321 
322     /**
323      * @dev Returns the address of the current owner.
324      */
325     function owner() public view virtual returns (address) {
326         return _owner;
327     }
328 
329     /**
330      * @dev Throws if called by any account other than the owner.
331      */
332     modifier onlyOwner() {
333         require(owner() == _msgSender(), "Ownable: caller is not the owner");
334         _;
335     }
336 
337     /**
338      * @dev Leaves the contract without owner. It will not be possible to call
339      * `onlyOwner` functions anymore. Can only be called by the current owner.
340      *
341      * NOTE: Renouncing ownership will leave the contract without an owner,
342      * thereby removing any functionality that is only available to the owner.
343      */
344     function renounceOwnership() public virtual onlyOwner {
345         _transferOwnership(address(0));
346     }
347 
348     /**
349      * @dev Transfers ownership of the contract to a new account (`newOwner`).
350      * Can only be called by the current owner.
351      */
352     function transferOwnership(address newOwner) public virtual onlyOwner {
353         require(
354             newOwner != address(0),
355             "Ownable: new owner is the zero address"
356         );
357         _transferOwnership(newOwner);
358     }
359 
360     /**
361      * @dev Transfers ownership of the contract to a new account (`newOwner`).
362      * Internal function without access restriction.
363      */
364     function _transferOwnership(address newOwner) internal virtual {
365         address oldOwner = _owner;
366         _owner = newOwner;
367         emit OwnershipTransferred(oldOwner, newOwner);
368     }
369 }
370 
371 pragma solidity ^0.8.7;
372 
373 interface IAIC {
374     function transferFrom(address from, address to, uint256 tokenId) external;
375     function ownerOf(uint256 tokenId) external view returns (address owner);
376     function balanceOf(address owner) external view returns (uint256 balance);
377 }
378 
379 contract AIC_Staking is Ownable {
380     using SafeMath for uint256;
381     uint256 public currentSeasonStartTime;
382     IAIC public AIC_Contract = IAIC(0xB78f1A96F6359Ef871f594Acb26900e02bFc8D00);
383     struct token {
384         uint256 stakeDate;
385         address stakerAddress;
386     }
387     mapping(uint256 => token) public stakedTokens;
388     constructor() {
389         currentSeasonStartTime = block.timestamp;
390     }
391 
392     modifier notContract() {
393         require((!_isContract(msg.sender)) && (msg.sender == tx.origin), "Contracts not allowed");
394         _;
395     }
396 
397     function _isContract(address addr) internal view returns (bool) {
398         uint256 size;
399         assembly {
400             size := extcodesize(addr)
401         }
402         return size > 0;
403     }
404 
405     function stake(uint256[] calldata tokenIds) external notContract {
406         for (uint256 index = 0; index < tokenIds.length; index++) {
407             if (AIC_Contract.ownerOf(tokenIds[index]) == msg.sender) {
408                 AIC_Contract.transferFrom(
409                     msg.sender,
410                     address(this),
411                     tokenIds[index]
412                 );
413                 stakedTokens[tokenIds[index]].stakeDate = block.timestamp;
414                 stakedTokens[tokenIds[index]].stakerAddress = msg.sender;
415             }
416         }
417     }
418 
419     function unstake(uint256[] calldata tokenIds) external notContract {
420         for (uint256 index = 0; index < tokenIds.length; index++) {
421             if (stakedTokens[tokenIds[index]].stakerAddress == msg.sender) {    
422                 AIC_Contract.transferFrom(
423                     address(this),
424                     msg.sender,
425                     tokenIds[index]
426                 );
427                 stakedTokens[tokenIds[index]].stakeDate = 0;
428                 stakedTokens[tokenIds[index]].stakerAddress = address(0);
429             }
430         }
431     }
432 
433     function checkStakeTierOfToken(uint256 tokenId) external view returns (uint256 tierId, uint256 stakeDate, uint256 passedTime) {
434         if (stakedTokens[tokenId].stakeDate >= currentSeasonStartTime && stakedTokens[tokenId].stakeDate != 0) {
435             uint256 sPassedTime = block.timestamp - stakedTokens[tokenId].stakeDate;
436             if (stakedTokens[tokenId].stakeDate + 30 days <= block.timestamp) {
437                 return (3, stakedTokens[tokenId].stakeDate, sPassedTime);
438             }
439             if (stakedTokens[tokenId].stakeDate + 15 days <= block.timestamp) {
440                 return (2, stakedTokens[tokenId].stakeDate, sPassedTime);
441             }
442             if (stakedTokens[tokenId].stakeDate + 5 days <= block.timestamp) {
443                 return (1, stakedTokens[tokenId].stakeDate, sPassedTime);
444             } else {
445                 return (0, stakedTokens[tokenId].stakeDate, sPassedTime);
446             }
447         } else {
448             if (stakedTokens[tokenId].stakeDate != 0 && block.timestamp > currentSeasonStartTime) {
449                 uint256 csPassedTime = block.timestamp - currentSeasonStartTime;
450                 if (csPassedTime >= 30 days) {
451                     return (3, currentSeasonStartTime, csPassedTime);
452                 }
453                 if (csPassedTime >= 15 days) {
454                     return (2, currentSeasonStartTime, csPassedTime);
455                 }
456                 if (csPassedTime >= 5 days) {
457                     return (1, currentSeasonStartTime, csPassedTime);
458                 } else {
459                     return (0, currentSeasonStartTime, csPassedTime);
460                 }
461             } else {
462                 return (0, 0, 0);
463             }
464         }
465     }
466 
467     function tokensOwnedBy(address owner) external view returns (uint256[] memory) {
468         uint256[] memory tokensList = new uint256[](AIC_Contract.balanceOf(owner));
469         uint256 currentIndex;
470         for (uint256 index = 1; index <= 314; index++) {
471             if (AIC_Contract.ownerOf(index) == owner) {
472                 tokensList[currentIndex++] = uint256(index);
473             }
474         }
475         return tokensList;
476     }
477 
478     function tokensStakedBy(address owner) external view returns (bool[] memory) {
479         bool[] memory tokensList = new bool[](314);
480         for (uint256 tokenId = 1; tokenId <= 314; tokenId++) {
481             if (stakedTokens[tokenId].stakerAddress == owner) {
482                 tokensList[tokenId - 1] = true;
483             }
484         }
485         return tokensList;
486     }
487 
488     function setNewSeason(uint256 seasonStartTime) external onlyOwner {
489         currentSeasonStartTime = seasonStartTime;
490     }
491 }