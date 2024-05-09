1 // File: Marketplace_flat.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/Address.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Collection of functions related to the address type
13  */
14 library Address {
15     /**
16      * @dev Returns true if `account` is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, `isContract` will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      */
32     function isContract(address account) internal view returns (bool) {
33         // This method relies on extcodesize, which returns 0 for contracts in
34         // construction, since the code is only stored at the end of the
35         // constructor execution.
36 
37         uint256 size;
38         assembly {
39             size := extcodesize(account)
40         }
41         return size > 0;
42     }
43 
44     /**
45      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
46      * `recipient`, forwarding all available gas and reverting on errors.
47      *
48      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
49      * of certain opcodes, possibly making contracts go over the 2300 gas limit
50      * imposed by `transfer`, making them unable to receive funds via
51      * `transfer`. {sendValue} removes this limitation.
52      *
53      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
54      *
55      * IMPORTANT: because control is transferred to `recipient`, care must be
56      * taken to not create reentrancy vulnerabilities. Consider using
57      * {ReentrancyGuard} or the
58      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
59      */
60     function sendValue(address payable recipient, uint256 amount) internal {
61         require(address(this).balance >= amount, "Address: insufficient balance");
62 
63         (bool success, ) = recipient.call{value: amount}("");
64         require(success, "Address: unable to send value, recipient may have reverted");
65     }
66 
67     /**
68      * @dev Performs a Solidity function call using a low level `call`. A
69      * plain `call` is an unsafe replacement for a function call: use this
70      * function instead.
71      *
72      * If `target` reverts with a revert reason, it is bubbled up by this
73      * function (like regular Solidity function calls).
74      *
75      * Returns the raw returned data. To convert to the expected return value,
76      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
77      *
78      * Requirements:
79      *
80      * - `target` must be a contract.
81      * - calling `target` with `data` must not revert.
82      *
83      * _Available since v3.1._
84      */
85     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
86         return functionCall(target, data, "Address: low-level call failed");
87     }
88 
89     /**
90      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
91      * `errorMessage` as a fallback revert reason when `target` reverts.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(
96         address target,
97         bytes memory data,
98         string memory errorMessage
99     ) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
105      * but also transferring `value` wei to `target`.
106      *
107      * Requirements:
108      *
109      * - the calling contract must have an ETH balance of at least `value`.
110      * - the called Solidity function must be `payable`.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(
115         address target,
116         bytes memory data,
117         uint256 value
118     ) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
124      * with `errorMessage` as a fallback revert reason when `target` reverts.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(
129         address target,
130         bytes memory data,
131         uint256 value,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         require(address(this).balance >= value, "Address: insufficient balance for call");
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{value: value}(data);
138         return verifyCallResult(success, returndata, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         require(isContract(target), "Address: static call to non-contract");
163 
164         (bool success, bytes memory returndata) = target.staticcall(data);
165         return verifyCallResult(success, returndata, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but performing a delegate call.
171      *
172      * _Available since v3.4._
173      */
174     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
180      * but performing a delegate call.
181      *
182      * _Available since v3.4._
183      */
184     function functionDelegateCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         require(isContract(target), "Address: delegate call to non-contract");
190 
191         (bool success, bytes memory returndata) = target.delegatecall(data);
192         return verifyCallResult(success, returndata, errorMessage);
193     }
194 
195     /**
196      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
197      * revert reason using the provided one.
198      *
199      * _Available since v4.3._
200      */
201     function verifyCallResult(
202         bool success,
203         bytes memory returndata,
204         string memory errorMessage
205     ) internal pure returns (bytes memory) {
206         if (success) {
207             return returndata;
208         } else {
209             // Look for revert reason and bubble it up if present
210             if (returndata.length > 0) {
211                 // The easiest way to bubble the revert reason is using memory via assembly
212 
213                 assembly {
214                     let returndata_size := mload(returndata)
215                     revert(add(32, returndata), returndata_size)
216                 }
217             } else {
218                 revert(errorMessage);
219             }
220         }
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Context.sol
225 
226 
227 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 abstract contract Context {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes calldata) {
247         return msg.data;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/access/Ownable.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor() {
280         _transferOwnership(_msgSender());
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions anymore. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _transferOwnership(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         _transferOwnership(newOwner);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Internal function without access restriction.
321      */
322     function _transferOwnership(address newOwner) internal virtual {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Interface of the ERC20 standard as defined in the EIP.
338  */
339 interface IERC20 {
340     /**
341      * @dev Returns the amount of tokens in existence.
342      */
343     function totalSupply() external view returns (uint256);
344 
345     /**
346      * @dev Returns the amount of tokens owned by `account`.
347      */
348     function balanceOf(address account) external view returns (uint256);
349 
350     /**
351      * @dev Moves `amount` tokens from the caller's account to `recipient`.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transfer(address recipient, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Returns the remaining number of tokens that `spender` will be
361      * allowed to spend on behalf of `owner` through {transferFrom}. This is
362      * zero by default.
363      *
364      * This value changes when {approve} or {transferFrom} are called.
365      */
366     function allowance(address owner, address spender) external view returns (uint256);
367 
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * IMPORTANT: Beware that changing an allowance with this method brings the risk
374      * that someone may use both the old and the new allowance by unfortunate
375      * transaction ordering. One possible solution to mitigate this race
376      * condition is to first reduce the spender's allowance to 0 and set the
377      * desired value afterwards:
378      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
379      *
380      * Emits an {Approval} event.
381      */
382     function approve(address spender, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Moves `amount` tokens from `sender` to `recipient` using the
386      * allowance mechanism. `amount` is then deducted from the caller's
387      * allowance.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transferFrom(
394         address sender,
395         address recipient,
396         uint256 amount
397     ) external returns (bool);
398 
399     /**
400      * @dev Emitted when `value` tokens are moved from one account (`from`) to
401      * another (`to`).
402      *
403      * Note that `value` may be zero.
404      */
405     event Transfer(address indexed from, address indexed to, uint256 value);
406 
407     /**
408      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
409      * a call to {approve}. `value` is the new allowance.
410      */
411     event Approval(address indexed owner, address indexed spender, uint256 value);
412 }
413 
414 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
415 
416 
417 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 /**
422  * @dev Interface of the ERC165 standard, as defined in the
423  * https://eips.ethereum.org/EIPS/eip-165[EIP].
424  *
425  * Implementers can declare support of contract interfaces, which can then be
426  * queried by others ({ERC165Checker}).
427  *
428  * For an implementation, see {ERC165}.
429  */
430 interface IERC165 {
431     /**
432      * @dev Returns true if this contract implements the interface defined by
433      * `interfaceId`. See the corresponding
434      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
435      * to learn more about how these ids are created.
436      *
437      * This function call must use less than 30 000 gas.
438      */
439     function supportsInterface(bytes4 interfaceId) external view returns (bool);
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @dev Required interface of an ERC721 compliant contract.
452  */
453 interface IERC721 is IERC165 {
454     /**
455      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
456      */
457     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
458 
459     /**
460      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
461      */
462     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
463 
464     /**
465      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
466      */
467     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
468 
469     /**
470      * @dev Returns the number of tokens in ``owner``'s account.
471      */
472     function balanceOf(address owner) external view returns (uint256 balance);
473 
474     /**
475      * @dev Returns the owner of the `tokenId` token.
476      *
477      * Requirements:
478      *
479      * - `tokenId` must exist.
480      */
481     function ownerOf(uint256 tokenId) external view returns (address owner);
482 
483     /**
484      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
485      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must exist and be owned by `from`.
492      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
494      *
495      * Emits a {Transfer} event.
496      */
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     ) external;
502 
503     /**
504      * @dev Transfers `tokenId` token from `from` to `to`.
505      *
506      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must be owned by `from`.
513      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
514      *
515      * Emits a {Transfer} event.
516      */
517     function transferFrom(
518         address from,
519         address to,
520         uint256 tokenId
521     ) external;
522 
523     /**
524      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
525      * The approval is cleared when the token is transferred.
526      *
527      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
528      *
529      * Requirements:
530      *
531      * - The caller must own the token or be an approved operator.
532      * - `tokenId` must exist.
533      *
534      * Emits an {Approval} event.
535      */
536     function approve(address to, uint256 tokenId) external;
537 
538     /**
539      * @dev Returns the account approved for `tokenId` token.
540      *
541      * Requirements:
542      *
543      * - `tokenId` must exist.
544      */
545     function getApproved(uint256 tokenId) external view returns (address operator);
546 
547     /**
548      * @dev Approve or remove `operator` as an operator for the caller.
549      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
550      *
551      * Requirements:
552      *
553      * - The `operator` cannot be the caller.
554      *
555      * Emits an {ApprovalForAll} event.
556      */
557     function setApprovalForAll(address operator, bool _approved) external;
558 
559     /**
560      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
561      *
562      * See {setApprovalForAll}
563      */
564     function isApprovedForAll(address owner, address operator) external view returns (bool);
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`.
568      *
569      * Requirements:
570      *
571      * - `from` cannot be the zero address.
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must exist and be owned by `from`.
574      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
575      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
576      *
577      * Emits a {Transfer} event.
578      */
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId,
583         bytes calldata data
584     ) external;
585 }
586 
587 // File: contracts/Marketplace.sol
588 
589 //SPDX-License-Identifier: MIT
590 pragma solidity 0.8.7;
591 
592 /**
593  * @title Divine Wolves Market
594  * @author Decentralized Devs - Angelo
595  */
596 
597 
598 
599 
600 
601 contract DivineWolvesMarket is  Ownable {
602 
603     using Address for address;
604 
605        struct Lottery {
606             //winner
607            address winner;
608            //NFT Contract 
609            address nftcontract;
610            //ID of the NFT
611            uint64 nftID;
612            //Number of tickets 
613            uint64 ticketMaxSupply;
614            //Tickets purchased
615            uint64 ticketsPurchased;
616             // Lotter min cap 
617            uint64 lotteryCap;
618            //Ticket price 
619            uint256 price;
620            //Lottery Cap enabled
621            bool isLotteryCappped; 
622            //winner selected 
623            bool isWinnerSelected;
624            //lottery Active 
625            bool active;
626            //address pool
627            address[] addressPool;
628          }
629 
630         struct Whitelist {
631             bool active;
632             uint64 spots;
633             uint256 price;
634             bytes32 title;
635             address[] addressPool;
636 
637         }
638 
639     mapping(uint64 => Lottery) public lotteries; 
640     mapping(uint64 => Whitelist) public whitelists; 
641     mapping(address => bool) internal _depositers;
642     mapping(address => uint64) internal _depositedNFTS;
643 
644     address erc20Contract;
645 
646 
647     modifier lotteryIndexCheck(uint64 _index) {
648         require(_index >= 0 && _index <= _currentIndex, "Invalid Lottery Index");
649         _;
650     }
651 
652     modifier whitelistindexCheck(uint64 _index) {
653         require(_index > 0 && _index <= _currentWhitelistIndex, "Invalid Whitelist Index");
654         _;
655     }
656 
657     // The tokenId of the next lottery to be created.
658     uint256 public _currentIndex; 
659      uint256 public _currentWhitelistIndex; 
660     
661 
662      function totalSupply(bool _isLottery) public view returns (uint256) {
663         unchecked {
664             return _isLottery? _currentIndex:_currentWhitelistIndex;
665         }
666     }
667 
668     //User functions 
669     function buyTicket(uint64 _index, uint64 _amount) public payable  lotteryIndexCheck(_index) {
670         Lottery storage lottery = lotteries[_index];
671         require(lottery.active , "Lottery is not Active Yet");
672         require(!lottery.isWinnerSelected, "Lottery has ended");
673          uint256 balance = IERC20(erc20Contract).balanceOf(msg.sender);
674         require(balance >=  (lottery.price * _amount) , "Not enough Erc20 Tokens");
675         require(lottery.ticketsPurchased + _amount <= lottery.ticketMaxSupply, "Purchasing Tickets Exceeds max supply");
676         IERC20(erc20Contract).transferFrom(msg.sender, address(this), (lottery.price * _amount));
677         for(uint64 i = 0; i < _amount; i++){
678             lottery.addressPool.push(msg.sender);
679         }
680         //update purchased amount 
681         lottery.ticketsPurchased += _amount;
682     }
683 
684      function buyWl(uint64 _index) public   whitelistindexCheck(_index) {
685         Whitelist storage wl = whitelists[_index];
686         require(wl.active , "Whitelisting is not Active Yet");
687         require(wl.addressPool.length + 1 <= wl.spots, "WL Spots Maxxed out");
688         uint256 balance = IERC20(erc20Contract).balanceOf(msg.sender);
689         require(wl.price <= balance, "Insufficent ERC20 Tokens");
690         IERC20(erc20Contract).transferFrom(msg.sender, address(this), wl.price);
691         wl.addressPool.push(msg.sender);
692        
693     }
694 
695     function viewWinner(uint64 _index) public view  lotteryIndexCheck(_index) returns(address )  {
696          Lottery storage lottery = lotteries[_index];
697          return lottery.winner;
698     }
699     
700 
701 
702     //Admin functions 
703 
704      function setErc20(address _bAddress) public onlyOwner {
705         erc20Contract = _bAddress;
706     }
707 
708     function createWhitelist(
709        
710         uint64 _spots,
711         uint256 _price
712     )public onlyOwner{
713             uint256 newIndex = _currentWhitelistIndex + 1;
714             Whitelist storage wl = whitelists[uint64(newIndex)];
715            // wl.title =_title;
716             wl.spots = _spots;
717             wl.price = _price;
718 
719             _currentWhitelistIndex = newIndex;
720     }
721     function createLottery(
722         address _contract,
723         uint64 _nftID,
724         uint64 _ticketMaxSupply,
725         uint64 _lotteryCapAmount,
726         uint256 _price,
727         bool _isLotteryCapped 
728     ) public onlyOwner{
729         
730         //Transfer NFT to Openlottery 
731          IERC721(_contract).transferFrom(
732             msg.sender,
733             address(this),
734             _nftID
735         );
736 
737         //create Lottery
738         uint256 newIndex = _currentIndex + 1;
739         Lottery storage lottery = lotteries[uint64(newIndex)];
740         lottery.nftcontract = _contract;
741         lottery.nftID = _nftID;
742         lottery.ticketMaxSupply = _ticketMaxSupply;
743         lottery.isLotteryCappped = _isLotteryCapped;
744         lottery.lotteryCap =  _lotteryCapAmount;
745         lottery.price = _price;
746         lottery.active =  false;
747         //set new index
748         _currentIndex = newIndex;
749     }
750 
751     function getLottery(uint64 _index) public view lotteryIndexCheck(_index)  returns (Lottery memory)  {
752         return lotteries[_index];
753     }
754 
755 
756     function setLotteryTicketPrice(uint64 _index, uint256 _price) public onlyOwner lotteryIndexCheck(_index) {
757         require(_price > 0, "Price should be greater than 0");
758          Lottery storage lottery = lotteries[_index];
759          lottery.price = _price;
760     }
761 
762     function setWlPrice(uint64 _index, uint256 _price) public onlyOwner whitelistindexCheck(_index) {
763         require(_price > 0, "Price should be greater than 0");
764          Whitelist storage wl = whitelists[_index];
765          wl.price = _price;
766     }
767 
768     function setWlSpots(uint64 _index, uint64 _spots) public onlyOwner whitelistindexCheck(_index) {
769         require(_spots > 0, "Spots should be greater than 0");
770          Whitelist storage wl = whitelists[_index];
771          wl.spots = _spots;
772     }
773 
774      function setWlState(uint64 _index, bool _state) public onlyOwner whitelistindexCheck(_index) {
775          Whitelist storage wl = whitelists[_index];
776          wl.active = _state;
777     }
778 
779      function getWlAddresses(uint64 _index) public view  whitelistindexCheck(_index)  returns(address[] memory){
780          Whitelist storage wl = whitelists[_index];
781         return wl.addressPool;
782     }
783 
784     function setLotteryState(uint64 _index, bool _state )public onlyOwner lotteryIndexCheck(_index)  {
785          Lottery storage lottery = lotteries[_index];
786          lottery.active = _state;
787     }
788 
789 
790      function setLotteryNFT(uint64 _index, address _contract, uint64 _nftID )public onlyOwner lotteryIndexCheck(_index)  {
791          Lottery storage lottery = lotteries[_index];
792          lottery.nftcontract = _contract;
793          lottery.nftID = _nftID;
794     }
795 
796     function overideTransfer(address _contract, address _to, uint64 _nftId) public onlyOwner {
797          IERC721(_contract).transferFrom(
798             address(this),
799             _to,
800             _nftId
801         );
802     }
803 
804 
805     function drawLottery(uint64 _index) public  onlyOwner lotteryIndexCheck(_index) {
806          Lottery storage lottery = lotteries[_index];
807          require(lottery.active, "This lottery is not yet active");
808          require(!lottery.isWinnerSelected, "Winner already selected");
809          if(lottery.isLotteryCappped){
810              require(lottery.ticketsPurchased > lottery.lotteryCap, "Lottery cannot be drawn till it reaches it cap");
811          }
812          //select winner 
813          uint winnerIndex = _getRandom(uint64(lottery.addressPool.length));
814          lottery.winner = lottery.addressPool[winnerIndex];
815          lottery.isWinnerSelected = true;
816          //Transfer the NFT 
817 
818         //Transfer NFT to Openlottery 
819          IERC721(lottery.nftcontract).transferFrom(
820             address(this),
821             lottery.addressPool[winnerIndex],
822             lottery.nftID
823         );
824     }
825 
826     function _getRandom(uint64 _range) public view returns (uint) {
827        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _range))) % _range;
828     }
829 
830 
831     function withdraw() public payable onlyOwner  {
832         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
833         require(os);
834     }
835 
836      function burnFang(address _burnWallet) public payable onlyOwner  {
837      uint256 balance = IERC20(erc20Contract).balanceOf(address(this));
838        IERC20(erc20Contract).transferFrom(address(this), _burnWallet, balance);
839     }
840 
841     function fangBalance() public view onlyOwner returns(uint256){
842         uint256 balance = IERC20(erc20Contract).balanceOf(address(this));
843         return balance;
844     }
845     
846    
847     function getLotteryAddressPool(uint64 _index) public view  lotteryIndexCheck(_index) returns (address[] memory)  {
848          Lottery storage lottery = lotteries[_index];
849          return lottery.addressPool;
850     }
851 
852     function getWhitelistInfo(uint64 _index )public view onlyOwner whitelistindexCheck(_index)  returns(Whitelist memory) {
853          Whitelist storage wl = whitelists[_index];
854         return wl;
855     }
856 
857       function getWlPrice(uint64 _index )public view onlyOwner whitelistindexCheck(_index)  returns(uint256) {
858          Whitelist storage wl = whitelists[_index];
859         return wl.price;
860     }
861 
862 
863     
864 
865 }