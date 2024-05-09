1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/math/SafeMath.sol
99 
100 // SPDX-License-Identifier: MIT
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
261 
262 // SPDX-License-Identifier: MIT
263 
264 pragma solidity ^0.6.0;
265 
266 /**
267  * @dev Interface of the ERC20 standard as defined in the EIP.
268  */
269 interface IERC20 {
270     /**
271      * @dev Returns the amount of tokens in existence.
272      */
273     function totalSupply() external view returns (uint256);
274 
275     /**
276      * @dev Returns the amount of tokens owned by `account`.
277      */
278     function balanceOf(address account) external view returns (uint256);
279 
280     /**
281      * @dev Moves `amount` tokens from the caller's account to `recipient`.
282      *
283      * Returns a boolean value indicating whether the operation succeeded.
284      *
285      * Emits a {Transfer} event.
286      */
287     function transfer(address recipient, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Returns the remaining number of tokens that `spender` will be
291      * allowed to spend on behalf of `owner` through {transferFrom}. This is
292      * zero by default.
293      *
294      * This value changes when {approve} or {transferFrom} are called.
295      */
296     function allowance(address owner, address spender) external view returns (uint256);
297 
298     /**
299      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * IMPORTANT: Beware that changing an allowance with this method brings the risk
304      * that someone may use both the old and the new allowance by unfortunate
305      * transaction ordering. One possible solution to mitigate this race
306      * condition is to first reduce the spender's allowance to 0 and set the
307      * desired value afterwards:
308      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309      *
310      * Emits an {Approval} event.
311      */
312     function approve(address spender, uint256 amount) external returns (bool);
313 
314     /**
315      * @dev Moves `amount` tokens from `sender` to `recipient` using the
316      * allowance mechanism. `amount` is then deducted from the caller's
317      * allowance.
318      *
319      * Returns a boolean value indicating whether the operation succeeded.
320      *
321      * Emits a {Transfer} event.
322      */
323     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
324 
325     /**
326      * @dev Emitted when `value` tokens are moved from one account (`from`) to
327      * another (`to`).
328      *
329      * Note that `value` may be zero.
330      */
331     event Transfer(address indexed from, address indexed to, uint256 value);
332 
333     /**
334      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
335      * a call to {approve}. `value` is the new allowance.
336      */
337     event Approval(address indexed owner, address indexed spender, uint256 value);
338 }
339 
340 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
341 
342 // SPDX-License-Identifier: MIT
343 
344 pragma solidity ^0.6.0;
345 
346 /**
347  * @dev Contract module that helps prevent reentrant calls to a function.
348  *
349  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
350  * available, which can be applied to functions to make sure there are no nested
351  * (reentrant) calls to them.
352  *
353  * Note that because there is a single `nonReentrant` guard, functions marked as
354  * `nonReentrant` may not call one another. This can be worked around by making
355  * those functions `private`, and then adding `external` `nonReentrant` entry
356  * points to them.
357  *
358  * TIP: If you would like to learn more about reentrancy and alternative ways
359  * to protect against it, check out our blog post
360  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
361  */
362 contract ReentrancyGuard {
363     // Booleans are more expensive than uint256 or any type that takes up a full
364     // word because each write operation emits an extra SLOAD to first read the
365     // slot's contents, replace the bits taken up by the boolean, and then write
366     // back. This is the compiler's defense against contract upgrades and
367     // pointer aliasing, and it cannot be disabled.
368 
369     // The values being non-zero value makes deployment a bit more expensive,
370     // but in exchange the refund on every call to nonReentrant will be lower in
371     // amount. Since refunds are capped to a percentage of the total
372     // transaction's gas, it is best to keep them low in cases like this one, to
373     // increase the likelihood of the full refund coming into effect.
374     uint256 private constant _NOT_ENTERED = 1;
375     uint256 private constant _ENTERED = 2;
376 
377     uint256 private _status;
378 
379     constructor () internal {
380         _status = _NOT_ENTERED;
381     }
382 
383     /**
384      * @dev Prevents a contract from calling itself, directly or indirectly.
385      * Calling a `nonReentrant` function from another `nonReentrant`
386      * function is not supported. It is possible to prevent this from happening
387      * by making the `nonReentrant` function external, and make it call a
388      * `private` function that does the actual work.
389      */
390     modifier nonReentrant() {
391         // On the first call to nonReentrant, _notEntered will be true
392         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
393 
394         // Any calls to nonReentrant after this point will fail
395         _status = _ENTERED;
396 
397         _;
398 
399         // By storing the original value once again, a refund is triggered (see
400         // https://eips.ethereum.org/EIPS/eip-2200)
401         _status = _NOT_ENTERED;
402     }
403 }
404 
405 // File: contracts/IAlohaNFT.sol
406 
407 pragma solidity ^0.6.0;
408 
409 interface IAlohaNFT {
410     function awardItem(
411         address wallet,
412         uint256 tokenImage,
413         uint256 tokenRarity,
414         uint256 tokenBackground
415     ) external returns (uint256);
416 }
417 
418 // File: contracts/AlohaStaking.sol
419 
420 pragma solidity 0.6.5;
421 pragma experimental ABIEncoderV2;
422 
423 
424 
425 
426 
427 
428 contract AlohaStaking is Ownable, ReentrancyGuard {
429     using SafeMath for uint256;
430     using SafeMath for uint8;
431 
432     /* Events */
433     event SettedPool(
434         uint256 indexed alohaAmount,
435         uint256 indexed erc20Amount,
436         uint256 duration,
437         uint256 rarity,
438         uint256 date
439     );
440     event Staked(
441         address indexed wallet,
442         address indexed erc20Address,
443         uint256 rarity,
444         uint256 endDate,
445         uint256 tokenImage,
446         uint256 tokenBackground,
447         uint256 alohaAmount,
448         uint256 erc20Amount,
449         uint256 date
450     );
451     event Withdrawal(
452         address indexed wallet,
453         address indexed erc20Address,
454         uint256 rarity,
455         uint256 originalAlohaAmount,
456         uint256 originalErc20Amount,
457         uint256 receivedAlohaAmount,
458         uint256 receivedErc20Amount,
459         uint256 erc721Id,
460         uint256 date
461     );
462     event Transfered(
463         address indexed wallet,
464         address indexed erc20Address,
465         uint256 amount,
466         uint256 date
467     );
468 
469     /* Vars */
470     uint256 public fee;
471     address public alohaERC20;
472     address public alohaERC721;
473     uint256 public backgrounds;
474     address[] public feesDestinators;
475     uint256[] public feesPercentages;
476 
477     struct Pool {
478         uint256 alohaAmount;
479         uint256 erc20Amount; // 0 when is not a PairPool
480         uint256 duration;
481         uint256 rarity;
482     }
483     struct Stake {
484         uint256 endDate;
485         uint256 tokenImage;
486         uint256 tokenBackground;
487         uint256 alohaAmount;
488         uint256 erc20Amount;  // 0 when is not a PairPool
489     }
490 
491     // image => rarity
492     mapping (uint256 => uint256) public rewardsMap;
493     // rarity => [image]
494     mapping (uint256 => uint256[]) public rarityByImages;
495     // rarity => totalImages
496     mapping (uint256 => uint256) public rarityByImagesTotal;
497     // erc20Address => rarity => Pool
498     mapping (address => mapping(uint256 => Pool)) public poolsMap;
499     // userAddress => erc20Address => rarity => Stake 
500     mapping (address => mapping(address => mapping(uint256 => Stake))) public stakingsMap;
501     // erc20Address => totalStaked 
502     mapping (address => uint256) public totalStaked;
503 
504     /* Modifiers */
505     modifier imageNotExists(uint256 _image) {
506         require(
507             !_existsReward(_image),
508             "AlohaStaking: Image for reward already exists"
509         );
510         _;
511     }
512     modifier validRarity(uint256 _rarity) {
513         require(
514             _rarity >= 1 && _rarity <= 3,
515             "AlohaStaking: Rarity must be 1, 2 or 3"
516         );
517         _;
518     }
519     modifier poolExists(address _erc20, uint256 _rarity) {
520         require(
521             _existsPool(_erc20, _rarity),
522             "AlohaStaking: Pool for ERC20 Token and rarity not exists"
523         );
524         _;
525     }
526     modifier rarityAvailable(uint256 _rarity) {
527         require(
528             !(rarityByImagesTotal[_rarity] == 0),
529             "AlohaStaking: Rarity not available"
530         );
531         _;
532     }
533     modifier addressNotInStake(address _userAddress, address _erc20, uint256 _rarity) {
534         require(
535             (stakingsMap[msg.sender][_erc20][_rarity].endDate == 0),
536             "AlohaStaking: Address already stakes in this pool"
537         );
538         _;
539     }
540     modifier addressInStake(address _userAddress, address _erc20, uint256 _rarity) {
541         require(
542             !(stakingsMap[msg.sender][_erc20][_rarity].endDate == 0),
543             "AlohaStaking: Address not stakes in this pool"
544         );
545         _;
546     }
547     modifier stakeEnded(address _userAddress, address _erc20, uint256 _rarity) {
548         require(
549             (_getTime() > stakingsMap[msg.sender][_erc20][_rarity].endDate),
550             "AlohaStaking: Stake duration has not ended yet"
551         );
552         _;
553     }
554 
555     /* Public Functions */
556     constructor(
557         address _alohaERC20,
558         address _alohaERC721,
559         uint256 _backgrounds,
560         uint256 _fee
561     ) public {
562         require(address(_alohaERC20) != address(0)); 
563         require(address(_alohaERC721) != address(0));
564 
565         alohaERC20 = _alohaERC20;
566         alohaERC721 = _alohaERC721;
567         backgrounds = _backgrounds;
568         fee = _fee;
569     }
570 
571     /**
572     * @dev Stake ALOHA to get a random token of the selected rarity
573     */
574     function simpleStake(
575         uint256 _tokenRarity
576     )
577         public
578     {
579         pairStake(alohaERC20, _tokenRarity);
580     }
581 
582     /**
583     * @dev Stake ALOHA/TOKEN to get a random token of the selected rarity
584     */
585     function pairStake(
586         address _erc20Token,
587         uint256 _tokenRarity
588     )
589         public
590         rarityAvailable(_tokenRarity)
591         poolExists(_erc20Token, _tokenRarity)
592         addressNotInStake(msg.sender, _erc20Token, _tokenRarity)
593     {
594         uint256 randomImage = rarityByImages[_tokenRarity][_randomA(rarityByImagesTotal[_tokenRarity]) - 1];
595         uint256 _endDate = _getTime() + poolsMap[_erc20Token][_tokenRarity].duration;
596         uint256 randomBackground = _randomB(backgrounds);
597 
598         uint256 alohaAmount = poolsMap[_erc20Token][_tokenRarity].alohaAmount;
599         uint256 erc20Amount = poolsMap[_erc20Token][_tokenRarity].erc20Amount;
600 
601         _transferStake(msg.sender, alohaERC20, alohaAmount);
602         totalStaked[alohaERC20] += alohaAmount;
603         
604         if (_erc20Token != alohaERC20) {
605             _transferStake(msg.sender, _erc20Token, erc20Amount);
606             totalStaked[_erc20Token] += erc20Amount;
607         }
608 
609         stakingsMap[msg.sender][_erc20Token][_tokenRarity] = Stake({
610             endDate: _endDate,
611             tokenImage: randomImage,
612             tokenBackground: randomBackground,
613             alohaAmount: alohaAmount,
614             erc20Amount: erc20Amount
615         });
616 
617         emit Staked(
618             msg.sender,
619             _erc20Token,
620             _tokenRarity,
621             _endDate,
622             randomImage,
623             randomBackground,
624             alohaAmount,
625             erc20Amount,
626             _getTime()
627         );
628     }
629 
630     /**
631     * @dev Withdraw ALOHA and claim your random NFT for the selected rarity
632     */
633     function simpleWithdraw(
634         uint256 _tokenRarity
635     )
636         public
637     {
638         pairWithdraw(alohaERC20, _tokenRarity);
639     }
640 
641     /**
642     * @dev Withdraw ALOHA/TOKEN and claim your random NFT for the selected rarity
643     */
644     function pairWithdraw(
645         address _erc20Token,
646         uint256 _tokenRarity
647     )
648         public
649         nonReentrant()
650         addressInStake(msg.sender, _erc20Token, _tokenRarity)
651         stakeEnded(msg.sender, _erc20Token, _tokenRarity)
652     {
653         _withdraw(_erc20Token, _tokenRarity, true);
654     }
655 
656     /**
657     * @dev Withdra ALOHA without generating your NFT. This can be done before release time is reached.
658     */
659     function forceSimpleWithdraw(
660         uint256 _tokenRarity
661     )
662         public
663     {
664         forcePairWithdraw(alohaERC20, _tokenRarity);
665     }
666 
667     /**
668     * @dev Withdraw ALOHA/TOKEN without generating your NFT. This can be done before release time is reached.
669     */
670     function forcePairWithdraw(
671         address _erc20Token,
672         uint256 _tokenRarity
673     )
674         public
675         nonReentrant()
676         addressInStake(msg.sender, _erc20Token, _tokenRarity)
677     {
678         _withdraw(_erc20Token, _tokenRarity, false);
679     }
680 
681     /**
682     * @dev Returns how many fees we collected from withdraws of one token.
683     */
684     function getAcumulatedFees(address _erc20Token) public returns (uint256) {
685         uint256 balance = IERC20(_erc20Token).balanceOf(address(this));
686 
687         if (balance > 0) {
688             return balance.sub(totalStaked[_erc20Token]);
689         }
690 
691         return 0; 
692     } 
693 
694     /**
695     * @dev Send all the acumulated fees for one token to the fee destinators.
696     */
697     function withdrawAcumulatedFees(address _erc20Token) public {
698         uint256 total = getAcumulatedFees(_erc20Token);
699         
700         for (uint8 i = 0; i < feesDestinators.length; i++) {
701             IERC20(_erc20Token).transfer(
702                 feesDestinators[i],
703                 total.mul(feesPercentages[i]).div(100)
704             );
705         }
706     }
707 
708     /* Governance Functions */
709 
710     /**
711     * @dev Sets the fee for every withdraw.
712     */
713     function setFee(uint256 _fee) public onlyOwner() {
714         fee = _fee;
715     }
716 
717     /**
718     * @dev Adds a new NFT to the pools, so users can stake for it.
719     */
720     function createReward(
721         uint256 _tokenImage,
722         uint256 _tokenRarity
723     )
724         public
725         onlyOwner()
726         imageNotExists(_tokenImage)
727         validRarity(_tokenRarity)
728     {
729         rewardsMap[_tokenImage] = _tokenRarity;
730         rarityByImages[_tokenRarity].push(_tokenImage);
731         rarityByImagesTotal[_tokenRarity] += 1;
732     }
733 
734     /**
735     * @dev Configure staking time and amount in ALOHA pool for one rarity.
736     */
737     function setSimplePool(
738         uint256 _alohaAmount,
739         uint256 _duration,
740         uint256 _tokenRarity
741     )
742         public
743         onlyOwner()
744         rarityAvailable(_tokenRarity)
745     {
746         poolsMap[alohaERC20][_tokenRarity] = Pool({
747             alohaAmount: _alohaAmount,
748             erc20Amount: 0,
749             duration: _duration,
750             rarity: _tokenRarity
751         });
752 
753         emit SettedPool(
754             _alohaAmount,
755             0,
756             _duration,
757             _tokenRarity,
758             _getTime()
759         );
760     }
761 
762     /**
763     * @dev Configure staking time and amount in ALOHA/TOKEN pool for one rarity.
764     */
765     function setPairPool(
766         uint256 _alohaAmount,
767         address _erc20Address,
768         uint256 _erc20Amount,
769         uint256 _duration,
770         uint256 _tokenRarity
771     )
772         public
773         onlyOwner()
774         rarityAvailable(_tokenRarity)
775     {
776         require(address(_erc20Address) != address(0));
777 
778         poolsMap[_erc20Address][_tokenRarity] = Pool({
779             alohaAmount: _alohaAmount,
780             erc20Amount: _erc20Amount,
781             duration: _duration,
782             rarity: _tokenRarity
783         });
784 
785         emit SettedPool(
786             _alohaAmount,
787             _erc20Amount,
788             _duration,
789             _tokenRarity,
790             _getTime()
791         );
792     }
793 
794     /**
795     * @dev Creates a new background for NFTs. New stakers could get this background.
796     */
797     function addBackground(uint8 increase)
798         public
799         onlyOwner()
800     {
801         backgrounds += increase;
802     }
803 
804     /**
805     * @dev Configure how to distribute the fees for user's withdraws.
806     */
807     function setFeesDestinatorsWithPercentages(
808         address[] memory _destinators,
809         uint256[] memory _percentages
810     )
811         public
812         onlyOwner()
813     {
814         require(_destinators.length <= 3, "AlohaStaking: Destinators lenght more then 3");
815         require(_percentages.length <= 3, "AlohaStaking: Percentages lenght more then 3");
816         require(_destinators.length == _percentages.length, "AlohaStaking: Destinators and percentageslenght are not equals");
817 
818         uint256 total = 0;
819         for (uint8 i = 0; i < _percentages.length; i++) {
820             total += _percentages[i];
821         }
822         require(total == 100, "AlohaStaking: Percentages sum must be 100");
823 
824         feesDestinators = _destinators;
825         feesPercentages = _percentages;
826     }
827 
828     /* Internal functions */
829     function _existsReward(uint256 _tokenImage) internal view returns (bool) {
830         return rewardsMap[_tokenImage] != 0;
831     }
832 
833     function _existsPool(address _erc20Token, uint256 _rarity) internal view returns (bool) {
834         return poolsMap[_erc20Token][_rarity].duration != 0;
835     }
836 
837     function _getTime() internal view returns (uint256) {
838         return block.timestamp;
839     }
840 
841     /**
842     * @dev Apply withdraw fees to the amounts.
843     */
844     function _applyStakeFees(
845         address _erc20Token,
846         uint256 _tokenRarity
847     ) internal view returns (
848         uint256 _alohaAmountAfterFees,
849         uint256 _erc20AmountAfterFees
850     ) {
851         uint256 alohaAmount = poolsMap[_erc20Token][_tokenRarity].alohaAmount;
852         uint256 alohaAmountAfterFees = alohaAmount.sub(alohaAmount.mul(fee).div(10000));
853         uint256 erc20AmountAfterFees = 0;
854 
855         if (_erc20Token != alohaERC20) {
856             uint256 erc20Amount = poolsMap[_erc20Token][_tokenRarity].erc20Amount;
857             erc20AmountAfterFees = erc20Amount.sub(erc20Amount.mul(fee).div(10000));
858         }
859 
860         return (alohaAmountAfterFees, erc20AmountAfterFees);
861     }
862 
863     /**
864     * @dev Transfers erc20 tokens to this contract.
865     */
866     function _transferStake(
867         address _wallet,
868         address _erc20,
869         uint256 _amount
870     ) internal {
871         require(IERC20(_erc20).transferFrom(_wallet, address(this), _amount), "Must approve the ERC20 first");
872 
873         emit Transfered(_wallet, _erc20, _amount, _getTime());
874     }
875 
876     /**
877     * @dev Transfers erc20 tokens from this contract to the wallet.
878     */
879     function _transferWithdrawRewards(
880         address _wallet,
881         address _erc20,
882         uint256 _amount
883     ) internal {
884         require(IERC20(_erc20).transfer(_wallet, _amount), "Must approve the ERC20 first");
885 
886         emit Transfered(_wallet, _erc20, _amount, _getTime());
887     }
888 
889     /**
890     * @dev Clear the stake state for a wallet and a rarity.
891     */
892     function _clearStake(address wallet, address _erc20Token, uint256 _tokenRarity) internal {
893         stakingsMap[wallet][_erc20Token][_tokenRarity].endDate = 0;
894         stakingsMap[wallet][_erc20Token][_tokenRarity].tokenImage = 0;
895         stakingsMap[wallet][_erc20Token][_tokenRarity].tokenBackground = 0;
896         stakingsMap[wallet][_erc20Token][_tokenRarity].alohaAmount = 0;
897         stakingsMap[wallet][_erc20Token][_tokenRarity].erc20Amount = 0;
898     }
899 
900     /**
901     * @dev Withdraw tokens and mints the NFT if claimed.
902     */
903     function _withdraw(address _erc20Token, uint256 _tokenRarity, bool claimReward) internal {
904         uint256 alohaAmount = poolsMap[_erc20Token][_tokenRarity].alohaAmount;
905         uint256 erc20Amount = poolsMap[_erc20Token][_tokenRarity].erc20Amount;
906         uint256 alohaAmountAfterFees;
907         uint256 erc20AmountAfterFees;
908     
909         if (!claimReward) {
910             alohaAmountAfterFees = alohaAmount;
911             erc20AmountAfterFees = erc20Amount;
912         } else {
913             (alohaAmountAfterFees, erc20AmountAfterFees) = _applyStakeFees(_erc20Token, _tokenRarity);
914         }
915 
916         _transferWithdrawRewards(msg.sender, alohaERC20, alohaAmountAfterFees);
917         totalStaked[alohaERC20] -= alohaAmount;
918 
919         if (_erc20Token != alohaERC20) {
920             _transferWithdrawRewards(msg.sender, _erc20Token, erc20AmountAfterFees);
921             totalStaked[_erc20Token] -= erc20Amount;
922         }
923 
924         uint256 tokenId = 0;
925         if (claimReward) {
926             uint256 image = stakingsMap[msg.sender][_erc20Token][_tokenRarity].tokenImage;
927             uint256 brackground = stakingsMap[msg.sender][_erc20Token][_tokenRarity].tokenBackground;
928 
929             tokenId = IAlohaNFT(alohaERC721).awardItem(msg.sender, image, _tokenRarity, brackground);
930         }
931 
932         emit Withdrawal(
933             msg.sender,
934             _erc20Token,
935             _tokenRarity,
936             alohaAmount,
937             erc20Amount,
938             alohaAmountAfterFees,
939             erc20AmountAfterFees,
940             tokenId,
941             _getTime()
942         );
943 
944         _clearStake(msg.sender, _erc20Token, _tokenRarity);
945     }
946 
947     /**
948     * @dev Generates a "random" number using the numbers of backgrounds that we have.
949     */
950     function _randomA(uint256 _limit) internal view returns (uint8) {
951         uint256 _gasleft = gasleft();
952         bytes32 _blockhash = blockhash(block.number-1);
953         bytes32 _structHash = keccak256(
954             abi.encode(
955                 _blockhash,
956                 backgrounds,
957                 _gasleft,
958                 _limit
959             )
960         );
961         uint256 _randomNumber  = uint256(_structHash);
962         assembly {_randomNumber := add(mod(_randomNumber, _limit),1)}
963         return uint8(_randomNumber);
964     }
965 
966     /**
967     * @dev Generates a "random" number using the current block timestamp.
968     */
969     function _randomB(uint256 _limit) internal view returns (uint256) {
970         uint256 _gasleft = gasleft();
971         bytes32 _blockhash = blockhash(block.number-1);
972         bytes32 _structHash = keccak256(
973             abi.encode(
974                 _blockhash,
975                 _getTime(),
976                 _gasleft,
977                 _limit
978             )
979         );
980         uint256 _randomNumber  = uint256(_structHash);
981         assembly {_randomNumber := add(mod(_randomNumber, _limit),1)}
982         return uint8(_randomNumber);
983     }
984 
985 }