1 // SPDX-License-Identifier: MIT
2 /*
3   ______           _         ____  _         _     
4  |  ____|         | |       |  _ \(_)       | |    
5  | |__   __ _ _ __| |_   _  | |_) |_ _ __ __| |___ 
6  |  __| / _` | '__| | | | | |  _ <| | '__/ _` / __|
7  | |___| (_| | |  | | |_| | | |_) | | | | (_| \__ \
8  |______\__,_|_|  |_|\__, | |____/|_|_|  \__,_|___/
9                       __/ |                        
10                      |___/      
11               By Devko.dev#7286
12 */
13 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
14 
15 
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
36     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             uint256 c = a + b;
39             if (c < a) return (false, 0);
40             return (true, c);
41         }
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b > a) return (false, 0);
52             return (true, a - b);
53         }
54     }
55 
56     /**
57      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64             // benefit is lost if 'b' is also tested.
65             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66             if (a == 0) return (true, 0);
67             uint256 c = a * b;
68             if (c / a != b) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     /**
74      * @dev Returns the division of two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a / b);
82         }
83     }
84 
85     /**
86      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b == 0) return (false, 0);
93             return (true, a % b);
94         }
95     }
96 
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a + b;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a - b;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a * b;
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers, reverting on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator.
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a / b;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * reverting when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a % b;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * CAUTION: This function is deprecated because it requires allocating memory for the error
174      * message unnecessarily. For custom revert reasons use {trySub}.
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(
183         uint256 a,
184         uint256 b,
185         string memory errorMessage
186     ) internal pure returns (uint256) {
187         unchecked {
188             require(b <= a, errorMessage);
189             return a - b;
190         }
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(
206         uint256 a,
207         uint256 b,
208         string memory errorMessage
209     ) internal pure returns (uint256) {
210         unchecked {
211             require(b > 0, errorMessage);
212             return a / b;
213         }
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * reverting with custom message when dividing by zero.
219      *
220      * CAUTION: This function is deprecated because it requires allocating memory for the error
221      * message unnecessarily. For custom revert reasons use {tryMod}.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         unchecked {
237             require(b > 0, errorMessage);
238             return a % b;
239         }
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Context.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Provides information about the current execution context, including the
252  * sender of the transaction and its data. While these are generally available
253  * via msg.sender and msg.data, they should not be accessed in such a direct
254  * manner, since when dealing with meta-transactions the account sending and
255  * paying for execution may not be the actual sender (as far as an application
256  * is concerned).
257  *
258  * This contract is only required for intermediate, library-like contracts.
259  */
260 abstract contract Context {
261     function _msgSender() internal view virtual returns (address) {
262         return msg.sender;
263     }
264 
265     function _msgData() internal view virtual returns (bytes calldata) {
266         return msg.data;
267     }
268 }
269 
270 // File: @openzeppelin/contracts/access/Ownable.sol
271 
272 
273 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 
278 /**
279  * @dev Contract module which provides a basic access control mechanism, where
280  * there is an account (an owner) that can be granted exclusive access to
281  * specific functions.
282  *
283  * By default, the owner account will be the one that deploys the contract. This
284  * can later be changed with {transferOwnership}.
285  *
286  * This module is used through inheritance. It will make available the modifier
287  * `onlyOwner`, which can be applied to your functions to restrict their use to
288  * the owner.
289  */
290 abstract contract Ownable is Context {
291     address private _owner;
292 
293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294 
295     /**
296      * @dev Initializes the contract setting the deployer as the initial owner.
297      */
298     constructor() {
299         _transferOwnership(_msgSender());
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         _checkOwner();
307         _;
308     }
309 
310     /**
311      * @dev Returns the address of the current owner.
312      */
313     function owner() public view virtual returns (address) {
314         return _owner;
315     }
316 
317     /**
318      * @dev Throws if the sender is not the owner.
319      */
320     function _checkOwner() internal view virtual {
321         require(owner() == _msgSender(), "Ownable: caller is not the owner");
322     }
323 
324     /**
325      * @dev Leaves the contract without owner. It will not be possible to call
326      * `onlyOwner` functions anymore. Can only be called by the current owner.
327      *
328      * NOTE: Renouncing ownership will leave the contract without an owner,
329      * thereby removing any functionality that is only available to the owner.
330      */
331     function renounceOwnership() public virtual onlyOwner {
332         _transferOwnership(address(0));
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      * Can only be called by the current owner.
338      */
339     function transferOwnership(address newOwner) public virtual onlyOwner {
340         require(newOwner != address(0), "Ownable: new owner is the zero address");
341         _transferOwnership(newOwner);
342     }
343 
344     /**
345      * @dev Transfers ownership of the contract to a new account (`newOwner`).
346      * Internal function without access restriction.
347      */
348     function _transferOwnership(address newOwner) internal virtual {
349         address oldOwner = _owner;
350         _owner = newOwner;
351         emit OwnershipTransferred(oldOwner, newOwner);
352     }
353 }
354 
355 // File: contract.sol
356 
357 
358 pragma solidity ^0.8.7;
359 
360 
361 
362 interface IEB {
363     function transferFrom(
364         address from,
365         address to,
366         uint256 tokenId
367     ) external;
368 
369     function ownerOf(uint256 tokenId) external view returns (address owner);
370 
371     function balanceOf(address owner) external view returns (uint256 balance);
372 }
373 
374 contract EarlyBirds_Staking is Ownable {
375     using SafeMath for uint256;
376 
377     IEB public EB_Contract = IEB(0x3D84cbDC126B1d9DCA50bfFe0c7bb1940A4D029D);
378 
379     struct token {
380         uint256 stakeDate;
381         address stakerAddress;
382         uint256 tierId;
383         uint256 collected;
384         uint256 boost;
385     }
386     mapping(uint256 => token) public stakedTokens;
387     mapping(address => uint256) public stakedTokensCount;
388     mapping(uint256 => uint256) public tiersRate;
389     mapping(uint256 => uint256) public tiersDays;
390 
391 
392     constructor() {
393         tiersRate[1] = 0.0000578703703 ether;
394         tiersRate[2] = 0.0001157407406 ether;
395         tiersRate[3] = 0.0002314814812 ether;
396 
397         tiersDays[1] = 14 days;
398         tiersDays[2] = 90 days;
399         tiersDays[3] = 365 days;
400     }
401 
402     modifier notContract() {
403         require(
404             (!_isContract(msg.sender)) && (msg.sender == tx.origin),
405             "Contracts not allowed"
406         );
407         _;
408     }
409 
410     function _isContract(address addr) internal view returns (bool) {
411         uint256 size;
412         assembly {
413             size := extcodesize(addr)
414         }
415         return size > 0;
416     }
417 
418     function stake(uint256[] calldata tokenIds, uint256 tierId)
419         external
420         notContract
421     {
422         require(tiersRate[tierId] > 0, "TIER_NOT_VALID");
423 
424         for (uint256 index = 0; index < tokenIds.length; index++) {
425             if (EB_Contract.ownerOf(tokenIds[index]) == msg.sender) {
426                 EB_Contract.transferFrom(
427                     msg.sender,
428                     address(this),
429                     tokenIds[index]
430                 );
431 
432                 stakedTokens[tokenIds[index]].stakeDate = block.timestamp;
433                 stakedTokens[tokenIds[index]].tierId = tierId;
434                 stakedTokens[tokenIds[index]].stakerAddress = msg.sender;
435 
436                 stakedTokensCount[msg.sender]++;
437             }
438         }
439     }
440 
441     function unstake(uint256[] calldata tokenIds) external notContract {
442         for (uint256 index = 0; index < tokenIds.length; index++) {
443             if (
444                 stakedTokens[tokenIds[index]].stakerAddress == msg.sender &&
445                 (stakedTokens[tokenIds[index]].stakeDate +
446                     tiersDays[stakedTokens[tokenIds[index]].tierId]) <
447                 block.timestamp
448             ) {
449                 EB_Contract.transferFrom(
450                     address(this),
451                     msg.sender,
452                     tokenIds[index]
453                 );
454                 stakedTokens[tokenIds[index]].collected = this
455                     .claimableWormsForId(tokenIds[index]);
456                 stakedTokens[tokenIds[index]].stakeDate = 0;
457                 stakedTokens[tokenIds[index]].tierId = 0;
458                 stakedTokens[tokenIds[index]].stakerAddress = address(0);
459 
460                 stakedTokensCount[msg.sender]--;
461             }
462         }
463     }
464 
465     function changeBoostsBulk(uint256[] memory tokenIds, uint256 boost)
466         external
467         onlyOwner
468     {
469         for (uint256 index = 0; index < tokenIds.length; index++) {
470             stakedTokens[tokenIds[index]].boost = boost;
471         }
472     }
473 
474     function changeBoosts(uint256[] memory tokenIds, uint256[] memory boosts)
475         external
476         onlyOwner
477     {
478         require(tokenIds.length == boosts.length, "LENGTH_NOT_MATCHED");
479 
480         for (uint256 index = 0; index < tokenIds.length; index++) {
481             stakedTokens[tokenIds[index]].boost = boosts[index];
482         }
483     }
484 
485     function claimableWormsFor(uint256[] memory tokenIds)
486         external
487         view
488         returns (uint256)
489     {
490         uint256 totalClaimable = 0;
491         for (uint256 index = 0; index < tokenIds.length; index++) {
492             uint256 timePassed = block.timestamp -
493                 stakedTokens[tokenIds[index]].stakeDate;
494 
495             uint256 noBoostAmount;
496             if (timePassed > tiersDays[stakedTokens[tokenIds[index]].tierId]) {
497                 noBoostAmount =
498                     tiersDays[stakedTokens[tokenIds[index]].tierId] *
499                     tiersRate[stakedTokens[tokenIds[index]].tierId];
500             } else {
501                 noBoostAmount =
502                     timePassed *
503                     tiersRate[stakedTokens[tokenIds[index]].tierId];
504             }
505 
506             if (stakedTokens[tokenIds[index]].boost == 0) {
507                 totalClaimable +=
508                     stakedTokens[tokenIds[index]].collected +
509                     noBoostAmount;
510             } else {
511                 totalClaimable +=
512                     stakedTokens[tokenIds[index]].collected +
513                     noBoostAmount +
514                     ((noBoostAmount * stakedTokens[tokenIds[index]].boost) /
515                         1000);
516             }
517         }
518         return totalClaimable;
519     }
520 
521     function claimableWormsForId(uint256 tokenId)
522         external
523         view
524         returns (uint256)
525     {
526         uint256 timePassed = block.timestamp - stakedTokens[tokenId].stakeDate;
527         uint256 noBoostAmount;
528         if (timePassed > tiersDays[stakedTokens[tokenId].tierId]) {
529             noBoostAmount =
530                 tiersDays[stakedTokens[tokenId].tierId] *
531                 tiersRate[stakedTokens[tokenId].tierId];
532         } else {
533             noBoostAmount =
534                 timePassed *
535                 tiersRate[stakedTokens[tokenId].tierId];
536         }
537 
538         if (stakedTokens[tokenId].boost == 0) {
539             return stakedTokens[tokenId].collected + noBoostAmount;
540         } else {
541             return
542                 stakedTokens[tokenId].collected +
543                 noBoostAmount +
544                 ((noBoostAmount * stakedTokens[tokenId].boost) / 1000);
545         }
546     }
547 
548     function tokensDetails(uint256[] memory tokens)
549         external
550         view
551         returns (token[] memory)
552     {
553         token[] memory tokensList = new token[](tokens.length);
554 
555         for (uint256 index = 0; index < tokens.length; index++) {
556             tokensList[index] = stakedTokens[tokens[index]];
557         }
558         return tokensList;
559     }
560 
561     function tokensOwnedBy(address owner)
562         external
563         view
564         returns (uint256[] memory)
565     {
566         uint256[] memory tokensList = new uint256[](
567             EB_Contract.balanceOf(owner)
568         );
569         uint256 currentIndex;
570         for (uint256 index = 1; index <= 1420; index++) {
571             try EB_Contract.ownerOf(index) {
572                 if (EB_Contract.ownerOf(index) == owner) {
573                     tokensList[currentIndex] = uint256(index);
574                     currentIndex++;
575                 }
576             } catch {}
577         }
578         return tokensList;
579     }
580 
581     function tokensStakedBy(address owner)
582         external
583         view
584         returns (uint256[] memory)
585     {
586         uint256[] memory tokensList = new uint256[](stakedTokensCount[owner]);
587         uint256 currentIndex = 0;
588         for (uint256 tokenId = 1; tokenId <= 1420; tokenId++) {
589             if (stakedTokens[tokenId].stakerAddress == owner) {
590                 tokensList[currentIndex] = uint256(tokenId);
591                 currentIndex++;
592             }
593         }
594         return tokensList;
595     }
596 }