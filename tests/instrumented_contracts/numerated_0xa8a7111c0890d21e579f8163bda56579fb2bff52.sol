1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _transferOwnership(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _transferOwnership(newOwner);
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Internal function without access restriction.
164      */
165     function _transferOwnership(address newOwner) internal virtual {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 // CAUTION
180 // This version of SafeMath should only be used with Solidity 0.8 or later,
181 // because it relies on the compiler's built in overflow checks.
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations.
185  *
186  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
187  * now has built in overflow checking.
188  */
189 library SafeMath {
190     /**
191      * @dev Returns the addition of two unsigned integers, with an overflow flag.
192      *
193      * _Available since v3.4._
194      */
195     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
196         unchecked {
197             uint256 c = a + b;
198             if (c < a) return (false, 0);
199             return (true, c);
200         }
201     }
202 
203     /**
204      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
205      *
206      * _Available since v3.4._
207      */
208     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
209         unchecked {
210             if (b > a) return (false, 0);
211             return (true, a - b);
212         }
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
217      *
218      * _Available since v3.4._
219      */
220     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         unchecked {
222             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223             // benefit is lost if 'b' is also tested.
224             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
225             if (a == 0) return (true, 0);
226             uint256 c = a * b;
227             if (c / a != b) return (false, 0);
228             return (true, c);
229         }
230     }
231 
232     /**
233      * @dev Returns the division of two unsigned integers, with a division by zero flag.
234      *
235      * _Available since v3.4._
236      */
237     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
238         unchecked {
239             if (b == 0) return (false, 0);
240             return (true, a / b);
241         }
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
246      *
247      * _Available since v3.4._
248      */
249     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b == 0) return (false, 0);
252             return (true, a % b);
253         }
254     }
255 
256     /**
257      * @dev Returns the addition of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `+` operator.
261      *
262      * Requirements:
263      *
264      * - Addition cannot overflow.
265      */
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a + b;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting on
272      * overflow (when the result is negative).
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      *
278      * - Subtraction cannot overflow.
279      */
280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the multiplication of two unsigned integers, reverting on
286      * overflow.
287      *
288      * Counterpart to Solidity's `*` operator.
289      *
290      * Requirements:
291      *
292      * - Multiplication cannot overflow.
293      */
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a * b;
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers, reverting on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `/` operator.
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a / b;
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * reverting when dividing by zero.
315      *
316      * Counterpart to Solidity's `%` operator. This function uses a `revert`
317      * opcode (which leaves remaining gas untouched) while Solidity uses an
318      * invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a % b;
326     }
327 
328     /**
329      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
330      * overflow (when the result is negative).
331      *
332      * CAUTION: This function is deprecated because it requires allocating memory for the error
333      * message unnecessarily. For custom revert reasons use {trySub}.
334      *
335      * Counterpart to Solidity's `-` operator.
336      *
337      * Requirements:
338      *
339      * - Subtraction cannot overflow.
340      */
341     function sub(
342         uint256 a,
343         uint256 b,
344         string memory errorMessage
345     ) internal pure returns (uint256) {
346         unchecked {
347             require(b <= a, errorMessage);
348             return a - b;
349         }
350     }
351 
352     /**
353      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
354      * division by zero. The result is rounded towards zero.
355      *
356      * Counterpart to Solidity's `/` operator. Note: this function uses a
357      * `revert` opcode (which leaves remaining gas untouched) while Solidity
358      * uses an invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      *
362      * - The divisor cannot be zero.
363      */
364     function div(
365         uint256 a,
366         uint256 b,
367         string memory errorMessage
368     ) internal pure returns (uint256) {
369         unchecked {
370             require(b > 0, errorMessage);
371             return a / b;
372         }
373     }
374 
375     /**
376      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
377      * reverting with custom message when dividing by zero.
378      *
379      * CAUTION: This function is deprecated because it requires allocating memory for the error
380      * message unnecessarily. For custom revert reasons use {tryMod}.
381      *
382      * Counterpart to Solidity's `%` operator. This function uses a `revert`
383      * opcode (which leaves remaining gas untouched) while Solidity uses an
384      * invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function mod(
391         uint256 a,
392         uint256 b,
393         string memory errorMessage
394     ) internal pure returns (uint256) {
395         unchecked {
396             require(b > 0, errorMessage);
397             return a % b;
398         }
399     }
400 }
401 
402 // File: FRCKSale.sol
403 
404 //SPDX-License-Identifier: Unlicense
405 pragma solidity 0.8.12;
406 
407 
408 
409 
410 interface FRCKCollection {
411     function batchMint(uint _amount, address _recipient) external;
412     function mintVip(uint _amount, address _recipient) external;
413     function vipMinted() external view returns(uint);
414     function totalSupply() external view returns(uint);
415 } 
416 
417 interface FRCKWhiteListSale {
418     function whiteListed(address sender) external view returns(bool);
419 }
420 
421 /**
422     @title This contract is used for the public sale of the FRCK collection
423  */
424 contract FRCKSale is Ownable, ReentrancyGuard {
425     using SafeMath for uint256;
426 
427     // Max amount of whitelisted mints per wallet
428     bool public saleActive = false;
429     bool public saleIsPublic = false;
430 
431     uint public public_fee = 0.125 * 10 ** 18 wei; // 0.125 ETH
432     uint public whitelisted_fee = 0.1 * 10 ** 18 wei; // 0.1 ETH
433 
434     address public FRCKCollectionAddress;
435     address public FRCKWhiteListSaleAddress;
436 
437     mapping(address => bool) public whiteListed;
438 
439     uint public maxSupply;
440     uint private maxVipSupply;
441 
442     mapping(address => uint) public amountMinted;
443     uint public maxMints;
444 
445     constructor(address _FRCKCollectionAddress, address _FRCKWhiteListSaleAddress, uint _maxVipSupply, uint _maxSupply, uint _maxMints){
446         FRCKCollectionAddress = _FRCKCollectionAddress;
447         FRCKWhiteListSaleAddress = _FRCKWhiteListSaleAddress;
448         maxVipSupply = _maxVipSupply;
449         maxSupply = _maxSupply;
450         maxMints = _maxMints;
451     }
452 
453     modifier validOrder(uint amount) {
454         uint supply = FRCKCollection(FRCKCollectionAddress).totalSupply();
455         require(supply.add(amount) <= maxSupply, "Sale: Purchase would exceed the total supply");
456         require(saleActive == true, "Sale: Sale is not yet active.");
457         require(amountMinted[msg.sender].add(amount) <= maxMints, "Sale: This order would exceed the max amount of mints for a wallet.");
458         if(!saleIsPublic){
459             require(isWhitelisted(msg.sender), "Sale: Wallet is not in the white list.");
460             require(msg.value == (amount.mul(whitelisted_fee)), "Sale: The amount sent is incorrect.");
461         } else {
462             if(isWhitelisted(msg.sender)){
463                 require(msg.value == (amount.mul(whitelisted_fee)), "Sale: The amount sent is incorrect.");
464             }
465             else {
466                 require(msg.value == amount.mul(public_fee), "Sale: The amount sent is incorrect.");
467             } 
468         }
469         _;
470     }
471 
472     /**
473         @dev Flips the sale state, active -> inactive or inactive -> active
474     */
475     function flipSaleState() external onlyOwner {
476         saleActive = !saleActive;
477     }
478 
479     /**
480         @dev Flips the sale state, active -> inactive or inactive -> active
481     */
482     function flipPublicSale() external onlyOwner {
483         saleIsPublic = !saleIsPublic;
484     }
485 
486     /**
487         @dev This function updates the max amount of allowed whitelisted mints
488      */
489     function updateMaxMints(uint _maxMints) external onlyOwner {
490         maxMints = _maxMints;
491     }
492 
493     /**
494         @dev This function gets amount of tokens minted for a address
495      */
496     function mintsDuringSale(address wallet) public view returns(uint){
497         return amountMinted[wallet];
498     }
499 
500     /**
501         @dev function used to withdraw contract funds to the owner
502      */
503     function withdrawMoney() external onlyOwner nonReentrant {
504         (bool success, ) = msg.sender.call{value: address(this).balance}("");
505         require(success, "Transfer failed.");
506     }
507 
508     /**
509        @dev Add addresses to whitelist
510      */
511     function addToWhitelist(address[] memory addresses) public onlyOwner {
512         for(uint i=0; i < addresses.length; i++){
513             whiteListed[addresses[i]] = true;
514         }
515     }
516 
517     function isWhitelisted(address caller) public view returns( bool ){
518         if(whiteListed[caller]) return true;
519         return FRCKWhiteListSale(FRCKWhiteListSaleAddress).whiteListed(caller);
520     }
521 
522     /**
523         @dev Function determined the method used for mint
524      */
525     function _lowIndexAmount(uint amount) internal view returns(uint lowIndexMints) {
526         uint vipMinted = FRCKCollection(FRCKCollectionAddress).vipMinted();
527         uint amountLeft = maxVipSupply.sub(vipMinted);
528         if(amountLeft == 0){ return 0; }
529         else if(amount >= amountLeft){ return amount.sub(amount.sub(amountLeft)); }
530         else{ return amount; }
531     } 
532 
533     /**
534         @dev This function is used for buying NFTs during the presale.
535      */
536     function mint(uint amount) external payable validOrder(amount) nonReentrant() {
537         require(amount > 0, "Mint amount must be more than 0");
538         uint lowIndexMints = _lowIndexAmount(amount);
539         uint highIndexMints = amount.sub(lowIndexMints);
540         if(lowIndexMints > 0){
541             FRCKCollection(FRCKCollectionAddress).mintVip(lowIndexMints, msg.sender);
542             amountMinted[msg.sender] = amountMinted[msg.sender].add(lowIndexMints);
543         }
544         if(highIndexMints > 0){
545             FRCKCollection(FRCKCollectionAddress).batchMint(highIndexMints, msg.sender);
546             amountMinted[msg.sender] = amountMinted[msg.sender].add(highIndexMints);
547         }
548     }
549 }