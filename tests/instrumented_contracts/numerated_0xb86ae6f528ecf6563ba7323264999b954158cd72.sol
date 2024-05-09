1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC165 standard, as defined in the
122  * https://eips.ethereum.org/EIPS/eip-165[EIP].
123  *
124  * Implementers can declare support of contract interfaces, which can then be
125  * queried by others ({ERC165Checker}).
126  *
127  * For an implementation, see {ERC165}.
128  */
129 interface IERC165 {
130     /**
131      * @dev Returns true if this contract implements the interface defined by
132      * `interfaceId`. See the corresponding
133      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
134      * to learn more about how these ids are created.
135      *
136      * This function call must use less than 30 000 gas.
137      */
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 
141 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
142 // SPDX-License-Identifier: MIT
143 
144 pragma solidity ^0.8.0;
145 
146 
147 /**
148  * @dev Required interface of an ERC1155 compliant contract, as defined in the
149  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
150  *
151  * _Available since v3.1._
152  */
153 interface IERC1155 is IERC165 {
154     /**
155      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
156      */
157     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
158 
159     /**
160      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
161      * transfers.
162      */
163     event TransferBatch(
164         address indexed operator,
165         address indexed from,
166         address indexed to,
167         uint256[] ids,
168         uint256[] values
169     );
170 
171     /**
172      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
173      * `approved`.
174      */
175     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
176 
177     /**
178      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
179      *
180      * If an {URI} event was emitted for `id`, the standard
181      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
182      * returned by {IERC1155MetadataURI-uri}.
183      */
184     event URI(string value, uint256 indexed id);
185 
186     /**
187      * @dev Returns the amount of tokens of token type `id` owned by `account`.
188      *
189      * Requirements:
190      *
191      * - `account` cannot be the zero address.
192      */
193     function balanceOf(address account, uint256 id) external view returns (uint256);
194 
195     /**
196      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
197      *
198      * Requirements:
199      *
200      * - `accounts` and `ids` must have the same length.
201      */
202     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
203         external
204         view
205         returns (uint256[] memory);
206 
207     /**
208      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
209      *
210      * Emits an {ApprovalForAll} event.
211      *
212      * Requirements:
213      *
214      * - `operator` cannot be the caller.
215      */
216     function setApprovalForAll(address operator, bool approved) external;
217 
218     /**
219      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
220      *
221      * See {setApprovalForAll}.
222      */
223     function isApprovedForAll(address account, address operator) external view returns (bool);
224 
225     /**
226      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
227      *
228      * Emits a {TransferSingle} event.
229      *
230      * Requirements:
231      *
232      * - `to` cannot be the zero address.
233      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
234      * - `from` must have a balance of tokens of type `id` of at least `amount`.
235      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
236      * acceptance magic value.
237      */
238     function safeTransferFrom(
239         address from,
240         address to,
241         uint256 id,
242         uint256 amount,
243         bytes calldata data
244     ) external;
245 
246     /**
247      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
248      *
249      * Emits a {TransferBatch} event.
250      *
251      * Requirements:
252      *
253      * - `ids` and `amounts` must have the same length.
254      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
255      * acceptance magic value.
256      */
257     function safeBatchTransferFrom(
258         address from,
259         address to,
260         uint256[] calldata ids,
261         uint256[] calldata amounts,
262         bytes calldata data
263     ) external;
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
267 
268 
269 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 
274 /**
275  * @dev Required interface of an ERC721 compliant contract.
276  */
277 interface IERC721 is IERC165 {
278     /**
279      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
280      */
281     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
282 
283     /**
284      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
285      */
286     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
287 
288     /**
289      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
290      */
291     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
292 
293     /**
294      * @dev Returns the number of tokens in ``owner``'s account.
295      */
296     function balanceOf(address owner) external view returns (uint256 balance);
297 
298     /**
299      * @dev Returns the owner of the `tokenId` token.
300      *
301      * Requirements:
302      *
303      * - `tokenId` must exist.
304      */
305     function ownerOf(uint256 tokenId) external view returns (address owner);
306 
307     /**
308      * @dev Safely transfers `tokenId` token from `from` to `to`.
309      *
310      * Requirements:
311      *
312      * - `from` cannot be the zero address.
313      * - `to` cannot be the zero address.
314      * - `tokenId` token must exist and be owned by `from`.
315      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
316      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
317      *
318      * Emits a {Transfer} event.
319      */
320     function safeTransferFrom(
321         address from,
322         address to,
323         uint256 tokenId,
324         bytes calldata data
325     ) external;
326 
327     /**
328      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
329      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
330      *
331      * Requirements:
332      *
333      * - `from` cannot be the zero address.
334      * - `to` cannot be the zero address.
335      * - `tokenId` token must exist and be owned by `from`.
336      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
337      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
338      *
339      * Emits a {Transfer} event.
340      */
341     function safeTransferFrom(
342         address from,
343         address to,
344         uint256 tokenId
345     ) external;
346 
347     /**
348      * @dev Transfers `tokenId` token from `from` to `to`.
349      *
350      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
351      *
352      * Requirements:
353      *
354      * - `from` cannot be the zero address.
355      * - `to` cannot be the zero address.
356      * - `tokenId` token must be owned by `from`.
357      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transferFrom(
362         address from,
363         address to,
364         uint256 tokenId
365     ) external;
366 
367     /**
368      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
369      * The approval is cleared when the token is transferred.
370      *
371      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
372      *
373      * Requirements:
374      *
375      * - The caller must own the token or be an approved operator.
376      * - `tokenId` must exist.
377      *
378      * Emits an {Approval} event.
379      */
380     function approve(address to, uint256 tokenId) external;
381 
382     /**
383      * @dev Approve or remove `operator` as an operator for the caller.
384      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
385      *
386      * Requirements:
387      *
388      * - The `operator` cannot be the caller.
389      *
390      * Emits an {ApprovalForAll} event.
391      */
392     function setApprovalForAll(address operator, bool _approved) external;
393 
394     /**
395      * @dev Returns the account approved for `tokenId` token.
396      *
397      * Requirements:
398      *
399      * - `tokenId` must exist.
400      */
401     function getApproved(uint256 tokenId) external view returns (address operator);
402 
403     /**
404      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
405      *
406      * See {setApprovalForAll}
407      */
408     function isApprovedForAll(address owner, address operator) external view returns (bool);
409 }
410 
411 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @dev Interface of the ERC20 standard as defined in the EIP.
420  */
421 interface IERC20 {
422     /**
423      * @dev Emitted when `value` tokens are moved from one account (`from`) to
424      * another (`to`).
425      *
426      * Note that `value` may be zero.
427      */
428     event Transfer(address indexed from, address indexed to, uint256 value);
429 
430     /**
431      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
432      * a call to {approve}. `value` is the new allowance.
433      */
434     event Approval(address indexed owner, address indexed spender, uint256 value);
435 
436     /**
437      * @dev Returns the amount of tokens in existence.
438      */
439     function totalSupply() external view returns (uint256);
440 
441     /**
442      * @dev Returns the amount of tokens owned by `account`.
443      */
444     function balanceOf(address account) external view returns (uint256);
445 
446     /**
447      * @dev Moves `amount` tokens from the caller's account to `to`.
448      *
449      * Returns a boolean value indicating whether the operation succeeded.
450      *
451      * Emits a {Transfer} event.
452      */
453     function transfer(address to, uint256 amount) external returns (bool);
454 
455     /**
456      * @dev Returns the remaining number of tokens that `spender` will be
457      * allowed to spend on behalf of `owner` through {transferFrom}. This is
458      * zero by default.
459      *
460      * This value changes when {approve} or {transferFrom} are called.
461      */
462     function allowance(address owner, address spender) external view returns (uint256);
463 
464     /**
465      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
466      *
467      * Returns a boolean value indicating whether the operation succeeded.
468      *
469      * IMPORTANT: Beware that changing an allowance with this method brings the risk
470      * that someone may use both the old and the new allowance by unfortunate
471      * transaction ordering. One possible solution to mitigate this race
472      * condition is to first reduce the spender's allowance to 0 and set the
473      * desired value afterwards:
474      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
475      *
476      * Emits an {Approval} event.
477      */
478     function approve(address spender, uint256 amount) external returns (bool);
479 
480     /**
481      * @dev Moves `amount` tokens from `from` to `to` using the
482      * allowance mechanism. `amount` is then deducted from the caller's
483      * allowance.
484      *
485      * Returns a boolean value indicating whether the operation succeeded.
486      *
487      * Emits a {Transfer} event.
488      */
489     function transferFrom(
490         address from,
491         address to,
492         uint256 amount
493     ) external returns (bool);
494 }
495 
496 // File: contracts/MonsterHole.sol
497 
498 
499 pragma solidity ^0.8.0;
500 
501 
502 
503 
504 
505 interface ICheck {
506 
507     function checkTorch(address _address, uint256 _amount, string memory signedMessage) external view returns (bool);
508 
509     function checkEth(address _address, uint256 _amount, string memory signedMessage) external view returns (bool);
510 
511     function checkStakeMonster(address _address,uint256[] memory _tokenId,string memory signedMessage) external view returns (bool);
512 
513     function checkGetProp(address _address,uint256[] memory _tokenId,uint256[] memory _amounts,string memory signedMessage) external view returns (bool);
514 }
515 
516 contract MonsterBattle is Ownable{
517     IERC721 public Monster;
518     IERC1155 public Storage;
519     IERC20 public Torch;
520     ICheck private Check;
521 
522     bool public _isActiveRecharge = true;
523     bool public _isActiveWithdrawal = true;
524     bool public _isActiveStake = true;
525     bool public _isActiveExtract = true;
526     bool public _isActiveWithdrawalETH = true;
527     bool public _isActiveReceive = true; 
528 
529     uint256 maxWithdrawETH = 0.2 ether;
530     uint256 maxWithdrawTorch = 100000000 ether;
531     uint256 withdrawTimes = 3600;
532     
533 
534     address public receiver = 0xDAC226421Fe37a1B00A469Cf03Ba5629ef5a3db6;
535     address public HoleAddress = 0xB63B32CaD8510572210987f489eD6F7547c0b0b1;
536 
537     mapping(address => uint256) private Signature;
538     mapping(address => uint256) private SignatureETH;
539     mapping(address => uint256[]) public StakingNumber; 
540 
541     event rechargeTorchEvent(address indexed from,uint256 indexed _amount,uint256 indexed _timestamp); 
542     event withdrawTorchEvent(address indexed to,uint256 indexed _amount,uint256 indexed _timestamp); 
543     event withdrawETHEvent(address indexed to,uint256 indexed _amount,uint256 indexed _timestamp); 
544     event Synthesis(address indexed from,uint256 indexed _tokenId, uint256 indexed  _amount);
545 
546     constructor(address _monster, address _token, address _check,address _storage) {
547         Monster = IERC721(_monster);
548         Torch = IERC20(_token);
549         Check = ICheck(_check);
550         Storage = IERC1155(_storage);
551     }
552 
553     function rechargeTorch(uint256 _amount) public {
554         require(
555             _isActiveRecharge,
556             "Recharge must be active"
557         );
558 
559         require(
560             _amount > 0,
561             "Recharge torch must be greater than 0"
562         );
563 
564         Torch.transferFrom(msg.sender, address(this), _amount);
565 
566         emit rechargeTorchEvent(msg.sender, _amount, block.timestamp);
567     }
568     
569 
570     function withdrawTorch(uint256 _amount, string memory _signature) public {
571         require(
572             _isActiveWithdrawal,
573             "Withdraw must be active"
574         );
575 
576         require(
577             _amount > 0,
578             "Withdraw torch must be greater than 0"
579         );
580 
581         require(
582             _amount <= maxWithdrawTorch,
583             "Withdraw torch must  be less than max withdraw torch at 1 time"
584         );
585 
586         require(
587             Signature[msg.sender] + withdrawTimes <= block.timestamp,
588             "Can only withdraw 1 times at 1 hour"
589         );
590 
591         require(
592             Check.checkTorch(msg.sender, _amount, _signature) == true,
593             "Audit error"
594         );
595 
596         require(
597             Torch.balanceOf(address(this)) >= _amount,
598             "Torch credit is running low"
599         );
600 
601         Signature[msg.sender] = block.timestamp;
602 
603         Torch.transfer( msg.sender, _amount);
604 
605         emit withdrawTorchEvent(msg.sender, _amount, block.timestamp);
606     }
607 
608     function withdrawETH(uint256 _amount, string memory _signature) public {
609         require(
610             _isActiveWithdrawalETH,
611             "Withdraw must be active"
612         );
613 
614          require(
615             _amount > 0,
616             "Withdraw torch must be greater than 0"
617         );
618 
619         require(
620             _amount <= maxWithdrawETH,
621             "Withdraw ETH must be less than max withdraw ETH at 1 time"
622         );
623 
624         require(
625             SignatureETH[msg.sender] + withdrawTimes <= block.timestamp,
626             "Can only withdraw 1 times at 1 hour"
627         );
628 
629         require(
630             Check.checkEth(msg.sender, _amount, _signature) == true,
631             "Audit error"
632         );
633 
634         require(
635             address(this).balance >= _amount,
636             "ETH credit is running low"
637         );
638 
639         SignatureETH[msg.sender] = block.timestamp;
640 
641         payable(msg.sender).transfer(_amount);
642 
643         emit withdrawETHEvent(msg.sender, _amount, block.timestamp);
644     }
645 
646     function stake(uint256[] memory _tokenId) public {
647         require(
648             _isActiveStake,
649             "Stake must be active"
650         );
651 
652         uint256  tokenIdLength  = _tokenId.length;
653         require(tokenIdLength > 0, "Tokens must be greater than 0");
654 
655         for(uint i = 0;i < tokenIdLength;i++){
656             require(Monster.ownerOf(_tokenId[i]) ==  msg.sender, "Insufficient balance");
657 
658             Monster.transferFrom(msg.sender,address(this),_tokenId[i]);
659             StakingNumber[msg.sender].push(_tokenId[i]);
660         }
661     
662 
663     }
664 
665    
666     function withdrawStake(uint256[] memory _tokenId, string memory _signature) public {
667         require(
668             _isActiveExtract,
669             "Withdraw staking must be active"
670         );
671 
672         require(
673             Check.checkStakeMonster(msg.sender, _tokenId, _signature) == true,
674             "Audit error"
675         );
676 
677  
678         uint256  tokenIdLength  = _tokenId.length;
679     
680         for(uint i = 0;i < tokenIdLength;i++){
681             require(getAddressStakingNumberbool(_tokenId[i]), "No collateral found");
682 
683             Monster.transferFrom(address(this), msg.sender, _tokenId[i]);
684 
685             (bool respond, uint256 _num)  = getAddressStakingNumberkey(_tokenId[i]);
686             if(respond == true)
687                 deleteAddressStakingNumber(_num);
688         }
689 
690     }
691 
692     
693     function receiveStorage(uint256[] memory _tokenIds,uint256[] memory _amounts,string memory _signature) public{
694         require(_isActiveReceive, "Receive storage must be active");
695 
696         require(
697             Check.checkGetProp(msg.sender, _tokenIds, _amounts, _signature) == true,
698             "Audit error"
699         );   
700 
701         Storage.safeBatchTransferFrom(HoleAddress, msg.sender, _tokenIds, _amounts, "0x00");
702 
703         uint256  tokenIdLength  = _tokenIds.length;
704 
705         for(uint i = 0;i < tokenIdLength;i++){
706             emit Synthesis(HoleAddress,_tokenIds[i], _amounts[i]);
707         }
708 
709     }
710 
711     function getAddressStakingNumberlength(address _addr) public view returns(uint256){
712         return StakingNumber[_addr].length;
713     }
714 
715     function getAddressStakingNumberbool(uint256 _tokenId) public view returns(bool){
716         uint256 popNum = getAddressStakingNumberlength(msg.sender);
717         for(uint i = 0; i < popNum; i++){
718             if(StakingNumber[msg.sender][i] == _tokenId){
719                 return true;
720             }
721         }
722         return false;
723     }
724 
725     function deleteAddressStakingNumber(uint256 _num) private {
726         uint256 popNum = getAddressStakingNumberlength(msg.sender) -1;
727         StakingNumber[msg.sender][_num] = StakingNumber[msg.sender][popNum];
728         StakingNumber[msg.sender].pop();
729     }
730 
731     function getAddressStakingNumberkey(uint256 _tokenId) private view returns(bool,uint){
732         uint256 popNum = getAddressStakingNumberlength(msg.sender);
733         for(uint i = 0; i < popNum; i++){
734             if(StakingNumber[msg.sender][i] == _tokenId){
735                 return (true,i);
736             }
737         }
738         return (false,0);
739     }
740 
741     function getStakeTokenIds(address _addr) public view returns(uint256[] memory){
742         return StakingNumber[_addr];
743     }
744 
745     function setActiveRecharge() public onlyOwner {
746         _isActiveRecharge = !_isActiveRecharge;
747     }
748 
749     function setActiveWithdrawal() public onlyOwner {
750         _isActiveWithdrawal = !_isActiveWithdrawal;
751     }
752 
753     function setActiveStake() public onlyOwner {
754         _isActiveStake = !_isActiveStake;
755     }
756 
757     function setActiveExtract() public onlyOwner {
758         _isActiveExtract = !_isActiveExtract;
759     }
760 
761     function setActiveWithdrawalETH() public onlyOwner {
762         _isActiveWithdrawalETH = !_isActiveWithdrawalETH;
763     }
764 
765     function setActiveReceive() public onlyOwner {
766         _isActiveReceive = !_isActiveReceive;
767     }
768 
769     function setReceiver(address _addr) public onlyOwner{
770         receiver = _addr;
771     }
772 
773     function setHoleAddress(address _addr) public onlyOwner{
774         HoleAddress = _addr;
775     }
776 
777     function setTorchContract(address _addr) public onlyOwner{  
778         Torch = IERC20(_addr);
779     }
780 
781     function setCheckContract(address _addr) public onlyOwner{
782         Check = ICheck(_addr);
783     }
784 
785     function setMonsterContract(address _addr) public onlyOwner{
786          Monster = IERC721(_addr);
787     }
788 
789     function setStorageContract(address _addr) public onlyOwner{
790         Storage = IERC1155(_addr);
791     }
792 
793     function setMaxWithdrawETH(uint256 _amount) public onlyOwner{
794         maxWithdrawETH = _amount;
795     }
796 
797     function setMaxWithdrawTorch(uint256 _amount) public onlyOwner{
798         maxWithdrawTorch = _amount;
799     }
800 
801     function setWithdrawTimes(uint256 _timestamp) public onlyOwner{
802         withdrawTimes = _timestamp;
803     }
804 
805     function withdrawTorch(uint256 _amount) public onlyOwner {
806         Torch.transfer(receiver, _amount);
807     }
808 
809     function withdrawEth() public onlyOwner {
810         uint256 amount = address(this).balance;
811         payable(receiver).transfer(amount);
812     }
813 
814 }