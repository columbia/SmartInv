1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 // File: @openzeppelin/contracts/access/Ownable.sol
26 
27 
28 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _transferOwnership(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _transferOwnership(newOwner);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Internal function without access restriction.
95      */
96     function _transferOwnership(address newOwner) internal virtual {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Interface of the ERC165 standard, as defined in the
112  * https://eips.ethereum.org/EIPS/eip-165[EIP].
113  *
114  * Implementers can declare support of contract interfaces, which can then be
115  * queried by others ({ERC165Checker}).
116  *
117  * For an implementation, see {ERC165}.
118  */
119 interface IERC165 {
120     /**
121      * @dev Returns true if this contract implements the interface defined by
122      * `interfaceId`. See the corresponding
123      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
124      * to learn more about how these ids are created.
125      *
126      * This function call must use less than 30 000 gas.
127      */
128     function supportsInterface(bytes4 interfaceId) external view returns (bool);
129 }
130 
131 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 
139 /**
140  * @dev Required interface of an ERC1155 compliant contract, as defined in the
141  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
142  *
143  * _Available since v3.1._
144  */
145 interface IERC1155 is IERC165 {
146     /**
147      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
148      */
149     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
150 
151     /**
152      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
153      * transfers.
154      */
155     event TransferBatch(
156         address indexed operator,
157         address indexed from,
158         address indexed to,
159         uint256[] ids,
160         uint256[] values
161     );
162 
163     /**
164      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
165      * `approved`.
166      */
167     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
168 
169     /**
170      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
171      *
172      * If an {URI} event was emitted for `id`, the standard
173      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
174      * returned by {IERC1155MetadataURI-uri}.
175      */
176     event URI(string value, uint256 indexed id);
177 
178     /**
179      * @dev Returns the amount of tokens of token type `id` owned by `account`.
180      *
181      * Requirements:
182      *
183      * - `account` cannot be the zero address.
184      */
185     function balanceOf(address account, uint256 id) external view returns (uint256);
186 
187     /**
188      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
189      *
190      * Requirements:
191      *
192      * - `accounts` and `ids` must have the same length.
193      */
194     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
195         external
196         view
197         returns (uint256[] memory);
198 
199     /**
200      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
201      *
202      * Emits an {ApprovalForAll} event.
203      *
204      * Requirements:
205      *
206      * - `operator` cannot be the caller.
207      */
208     function setApprovalForAll(address operator, bool approved) external;
209 
210     /**
211      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
212      *
213      * See {setApprovalForAll}.
214      */
215     function isApprovedForAll(address account, address operator) external view returns (bool);
216 
217     /**
218      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
219      *
220      * Emits a {TransferSingle} event.
221      *
222      * Requirements:
223      *
224      * - `to` cannot be the zero address.
225      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
226      * - `from` must have a balance of tokens of type `id` of at least `amount`.
227      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
228      * acceptance magic value.
229      */
230     function safeTransferFrom(
231         address from,
232         address to,
233         uint256 id,
234         uint256 amount,
235         bytes calldata data
236     ) external;
237 
238     /**
239      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
240      *
241      * Emits a {TransferBatch} event.
242      *
243      * Requirements:
244      *
245      * - `ids` and `amounts` must have the same length.
246      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
247      * acceptance magic value.
248      */
249     function safeBatchTransferFrom(
250         address from,
251         address to,
252         uint256[] calldata ids,
253         uint256[] calldata amounts,
254         bytes calldata data
255     ) external;
256 }
257 
258 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
259 
260 
261 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Interface of the ERC20 standard as defined in the EIP.
267  */
268 interface IERC20 {
269     /**
270      * @dev Emitted when `value` tokens are moved from one account (`from`) to
271      * another (`to`).
272      *
273      * Note that `value` may be zero.
274      */
275     event Transfer(address indexed from, address indexed to, uint256 value);
276 
277     /**
278      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
279      * a call to {approve}. `value` is the new allowance.
280      */
281     event Approval(address indexed owner, address indexed spender, uint256 value);
282 
283     /**
284      * @dev Returns the amount of tokens in existence.
285      */
286     function totalSupply() external view returns (uint256);
287 
288     /**
289      * @dev Returns the amount of tokens owned by `account`.
290      */
291     function balanceOf(address account) external view returns (uint256);
292 
293     /**
294      * @dev Moves `amount` tokens from the caller's account to `to`.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transfer(address to, uint256 amount) external returns (bool);
301 
302     /**
303      * @dev Returns the remaining number of tokens that `spender` will be
304      * allowed to spend on behalf of `owner` through {transferFrom}. This is
305      * zero by default.
306      *
307      * This value changes when {approve} or {transferFrom} are called.
308      */
309     function allowance(address owner, address spender) external view returns (uint256);
310 
311     /**
312      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * IMPORTANT: Beware that changing an allowance with this method brings the risk
317      * that someone may use both the old and the new allowance by unfortunate
318      * transaction ordering. One possible solution to mitigate this race
319      * condition is to first reduce the spender's allowance to 0 and set the
320      * desired value afterwards:
321      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322      *
323      * Emits an {Approval} event.
324      */
325     function approve(address spender, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Moves `amount` tokens from `from` to `to` using the
329      * allowance mechanism. `amount` is then deducted from the caller's
330      * allowance.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * Emits a {Transfer} event.
335      */
336     function transferFrom(
337         address from,
338         address to,
339         uint256 amount
340     ) external returns (bool);
341 }
342 
343 
344 
345 pragma solidity ^0.8.4;
346 
347 
348 
349 
350 
351 contract CaveShop is Ownable {
352 
353     IERC1155 public tokenA;
354     IERC20 public tokenB;
355 
356    
357     address public initial;
358 
359     address public DivideReceiver = 0xeE7513e1cFf5aE8b6f18F68Dd6Ef908e577CC68f;
360     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
361 
362     uint256 public DEADFee = 60;
363 
364     uint256[] private commodityTokenId; 
365     mapping(uint256 => uint256) private commodityPrice;  
366 
367     uint256[] private luxuryCommodityTokenId;  
368     mapping(uint256 => uint256) private luxuryCommodityPrice;  
369 
370     bool public _isCommonStore = true;
371     bool public _isCommonSynthesis = true;
372     bool public _isEquipmentSynthesis = true;
373     bool public _isTimesSwitch = true;
374 
375     uint256[2] private businessHours; 
376 
377     event Synthesis(address indexed from,uint256 indexed _tokenId, uint256 indexed  _amount, uint256  value);
378 
379     constructor(address _tokenA, address _tokenB) {
380         tokenA = IERC1155(_tokenA);
381         tokenB = IERC20(_tokenB);
382         initial = msg.sender;
383     }
384     
385     function commonStore(uint256[] memory _tokenId,uint256[] memory _amount) public{
386         require(_isCommonStore, "stoppage of business");
387 
388         uint commodityLength = _tokenId.length;
389         uint commodityAmount = _amount.length;
390         require(
391             commodityLength == commodityAmount,
392             "Quantity does not match"
393         );
394         uint256 priceCount = 0;
395         for(uint i = 0; i < commodityLength; i++){
396             require(
397             tokenA.balanceOf(initial,_tokenId[i]) >= _amount[i],
398             "Insufficient balance"
399             );
400             require(
401             commodityPrice[_tokenId[i]] > 0,
402             "no such product"
403             );
404             priceCount +=  commodityPrice[_tokenId[i]] * _amount[i];
405         }
406 
407         require(
408             tokenB.allowance(msg.sender,address(this)) >= priceCount,
409             "insufficient allowance"
410         );
411 
412         require(
413             tokenB.balanceOf(msg.sender) > priceCount,
414             "Not enough Torch send"
415         );
416 
417         uint256 DeadAmount = priceCount * DEADFee / 10 ** 2;
418         uint256 divideAmount = priceCount - DeadAmount;
419 
420         tokenB.transferFrom(msg.sender, DEAD, DeadAmount);
421         tokenB.transferFrom(msg.sender, DivideReceiver, divideAmount);  
422         
423         tokenA.safeBatchTransferFrom(initial, msg.sender, _tokenId, _amount, "0x00");
424 
425     }
426 
427     
428     function commonSynthesis(uint256[] memory _tokenId,uint256[] memory _amount,uint256 _monsterTokenid) public{
429         require(_isCommonSynthesis, "stoppage of business");
430 
431         uint commodityLength = _tokenId.length;
432         uint commodityAmount = _amount.length;
433         require(
434             commodityLength == commodityAmount,
435             "Quantity does not match"
436         );
437         uint256 priceCount = 0;
438         for(uint i = 0; i < commodityLength; i++){
439             require(
440             tokenA.balanceOf(initial,_tokenId[i]) >= _amount[i],
441             "Insufficient balance"
442             );
443             require(
444             commodityPrice[_tokenId[i]] > 0,
445             "no such product"
446             );
447             priceCount +=  commodityPrice[_tokenId[i]] * _amount[i];
448 
449             emit Synthesis(msg.sender, _tokenId[i], _amount[i],_monsterTokenid);
450         }
451 
452         require(
453             tokenB.allowance(msg.sender,address(this)) >= priceCount,
454             "insufficient allowance"
455         );
456 
457         require(
458             tokenB.balanceOf(msg.sender) > priceCount,
459             "Not enough Torch send"
460         );
461 
462         uint256 DeadAmount = priceCount * DEADFee / 10 ** 2;
463         uint256 divideAmount = priceCount - DeadAmount;
464 
465         tokenB.transferFrom(msg.sender, DEAD, DeadAmount);
466         tokenB.transferFrom(msg.sender, DivideReceiver, divideAmount);  
467         
468         tokenA.safeBatchTransferFrom(initial, DEAD, _tokenId, _amount, "0x00");
469 
470     }
471        
472     function luxuryStores(uint256[] memory _tokenId,uint256[] memory _amount) public{
473         uint commodityLength = _tokenId.length;
474         uint commodityAmount = _amount.length;
475         require(
476             commodityLength == commodityAmount,
477             "Quantity does not match"
478         );
479 
480         if(_isTimesSwitch){
481             require(
482                 businessHours[0] < block.timestamp  && businessHours[0] + businessHours[1] > block.timestamp,
483                 "Business hours have not yet come"
484             );
485         }
486 
487         uint256 priceCount = 0;
488         for(uint i = 0; i < commodityLength; i++){
489             require(
490             tokenA.balanceOf(initial,_tokenId[i]) >= _amount[i],
491             "Insufficient balance"
492             );
493             require(
494             luxuryCommodityPrice[_tokenId[i]] > 0,
495             "no such product"
496             );
497             priceCount +=  luxuryCommodityPrice[_tokenId[i]] * _amount[i];
498         }
499 
500         require(
501             tokenB.allowance(msg.sender,address(this)) >= priceCount,
502             "insufficient allowance"
503         );
504 
505         require(
506             tokenB.balanceOf(msg.sender) > priceCount,
507             "Not enough Torch send"
508         );
509 
510         uint256 DeadAmount = priceCount * DEADFee / 10 ** 2;
511         uint256 divideAmount = priceCount - DeadAmount;
512 
513         tokenB.transferFrom(msg.sender, DEAD, DeadAmount);
514         tokenB.transferFrom(msg.sender, DivideReceiver, divideAmount);  
515         
516         tokenA.safeBatchTransferFrom(initial, msg.sender, _tokenId, _amount, "0x00");
517 
518     }
519 
520     
521     function luxuryStoresSynthesis(uint256[] memory _tokenId,uint256[] memory _amount,uint256 _monsterTokenid) public{
522         uint commodityLength = _tokenId.length;
523         uint commodityAmount = _amount.length;
524         require(
525             commodityLength == commodityAmount,
526             "Quantity does not match"
527         );
528         if(_isTimesSwitch){
529             require(
530                 businessHours[0] < block.timestamp  && businessHours[0] + businessHours[1] > block.timestamp,
531                 "Business hours have not yet come"
532             );
533         }
534 
535         uint256 priceCount = 0;
536         for(uint i = 0; i < commodityLength; i++){
537             require(
538             tokenA.balanceOf(initial,_tokenId[i]) >= _amount[i],
539             "Insufficient balance"
540             );
541             require(
542             luxuryCommodityPrice[_tokenId[i]] > 0,
543             "no such product"
544             );
545             priceCount +=  luxuryCommodityPrice[_tokenId[i]] * _amount[i];
546             emit Synthesis(msg.sender, _tokenId[i], _amount[i],_monsterTokenid);
547         }
548 
549         require(
550             tokenB.allowance(msg.sender,address(this)) >= priceCount,
551             "insufficient allowance"
552         );
553 
554         require(
555             tokenB.balanceOf(msg.sender) > priceCount,
556             "Not enough Torch send"
557         );
558 
559         uint256 DeadAmount = priceCount * DEADFee / 10 ** 2;
560         uint256 divideAmount = priceCount - DeadAmount;
561 
562         tokenB.transferFrom(msg.sender, DEAD, DeadAmount);
563         tokenB.transferFrom(msg.sender, DivideReceiver, divideAmount);  
564         
565         tokenA.safeBatchTransferFrom(initial, DEAD, _tokenId, _amount, "0x00");
566 
567     }
568     
569     function equipmentSynthesis(uint256[] memory _tokenId,uint256[] memory _amount,uint256 _monsterTokenid) public{
570         require(_isEquipmentSynthesis, "stoppage of business");
571 
572         uint commodityLength = _tokenId.length;
573         uint commodityAmount = _amount.length;
574         require(
575             commodityLength == commodityAmount,
576             "Quantity does not match"
577         );
578         for(uint i = 0; i < commodityLength; i++){
579             require(
580             tokenA.balanceOf(msg.sender,_tokenId[i]) >= _amount[i],
581             "Insufficient balance"
582             );
583             emit Synthesis(msg.sender, _tokenId[i], _amount[i],_monsterTokenid);
584         }
585 
586         tokenA.safeBatchTransferFrom(msg.sender, DEAD, _tokenId, _amount, "0x00");
587 
588     }
589   
590     
591     function setUpCommodityPrice(uint256[] memory _tokenId,uint256[] memory _amount) public  onlyOwner {
592         uint commodityLength = _tokenId.length;
593         uint commodityAmount = _amount.length;
594         require(
595             commodityLength == commodityAmount,
596             "Quantity does not match"
597         );
598 
599         for(uint i = 0; i < commodityLength; i++){
600             commodityPrice[_tokenId[i]] = _amount[i];
601             if(!getIsCommodityTokenId(_tokenId[i])){
602                 commodityTokenId.push(_tokenId[i]);
603             }
604         }
605     }
606    
607     function getIsCommodityTokenId(uint256 _tokenId) public view returns(bool){
608         uint commodityLength = commodityTokenId.length;
609         for(uint i = 0; i < commodityLength; i++){
610             if(commodityTokenId[i] == _tokenId){
611                 return true;
612             }
613         }
614         return false;
615     }
616     
617     function getCommodityPriceList() public view returns(uint256[] memory,uint256[] memory){
618         uint commodityLength = commodityTokenId.length;
619         uint256[] memory allPrice = new uint[](commodityLength);
620         uint counter = 0;
621         for(uint i = 0; i < commodityLength;i++){
622             allPrice[counter] = commodityPrice[commodityTokenId[i]];
623             counter++;
624         }
625         return (commodityTokenId,allPrice);
626     }
627     
628     function setUpLuxuryCommodityPrice(uint256[] memory _tokenId,uint256[] memory _amount) public  onlyOwner {
629         uint commodityLength = _tokenId.length;
630         uint commodityAmount = _amount.length;
631         require(
632             commodityLength == commodityAmount,
633             "Quantity does not match"
634         );
635 
636         for(uint i = 0; i < commodityLength; i++){
637             luxuryCommodityPrice[_tokenId[i]] = _amount[i];
638             if(!getIsLuxuryCommodityTokenId(_tokenId[i])){
639                 luxuryCommodityTokenId.push(_tokenId[i]);
640             }
641         }
642     }
643     
644     function getIsLuxuryCommodityTokenId(uint256 _tokenId) public view  returns(bool){
645         uint luxuryCommodityLength = luxuryCommodityTokenId.length;
646         for(uint i = 0; i < luxuryCommodityLength; i++){
647             if(luxuryCommodityTokenId[i] == _tokenId){
648                 return true;
649             }
650         }
651         return false;
652     }
653     
654     function getLuxuryCommodityPriceList() public view returns(uint256[] memory,uint256[] memory){
655         uint luxuryCommodityLength = luxuryCommodityTokenId.length;
656         uint256[] memory allPrice = new uint[](luxuryCommodityLength);
657         uint counter = 0;
658         for(uint i = 0; i < luxuryCommodityLength;i++){
659             allPrice[counter] = luxuryCommodityPrice[luxuryCommodityTokenId[i]];
660             counter++;
661         }
662         return (luxuryCommodityTokenId,allPrice);
663     }
664      
665     function getGeneralStorePrice(uint256[] memory _tokenId,uint256[] memory _amount) public view returns(uint256){
666         uint commodityLength = _tokenId.length;
667         uint commodityAmount = _amount.length;
668         require(
669             commodityLength == commodityAmount,
670             "Quantity does not match"
671         );
672         uint256 count = 0;
673         for(uint i = 0; i < commodityLength; i++){
674             count +=  commodityPrice[_tokenId[i]] * _amount[i];
675         }
676         return count;
677     
678     }
679     
680     function getLuxuryGeneralStorePrice(uint256[] memory _tokenId,uint256[] memory _amount) public view returns(uint256){
681         uint commodityLength = _tokenId.length;
682         uint commodityAmount = _amount.length;
683         require(
684             commodityLength == commodityAmount,
685             "Quantity does not match"
686         );
687         uint256 count = 0;
688         for(uint i = 0; i < commodityLength; i++){
689             count +=  luxuryCommodityPrice[_tokenId[i]] * _amount[i];
690         }
691         return count;
692     
693     }
694     
695     function setUpBusinessHours(uint256[] memory _timeDeta) public  onlyOwner {
696         businessHours[0] = _timeDeta[0];
697         businessHours[1] = _timeDeta[1];
698     }  
699     
700     function getblocktimes() public view returns(uint256) {
701         return block.timestamp;
702     }   
703     
704     function flipisCommonStore() public onlyOwner {
705         _isCommonStore = !_isCommonStore;
706     }
707     
708     function flipisCommonSynthesis() public onlyOwner {
709         _isCommonSynthesis = !_isCommonSynthesis;
710     }
711     
712     function flipisEquipmentSynthesis() public onlyOwner {
713         _isEquipmentSynthesis = !_isEquipmentSynthesis;
714     }
715     
716     function flipisTimesSwitch() public onlyOwner {
717         _isTimesSwitch = !_isTimesSwitch;
718     }
719     
720     function getBusinessHours() public view returns(uint256[2] memory){
721         return businessHours;
722     }
723     
724 
725     function setTokenAContract(address _tokenA) public onlyOwner {
726         tokenA = IERC1155(_tokenA);
727     }
728 
729     function setTokenBContract(address _tokenB) public onlyOwner {
730         tokenB = IERC20(_tokenB);
731     }
732 
733     function setDivideReceiver(address _address) public onlyOwner {
734         DivideReceiver = _address;
735     }
736 
737    
738     function setDEADFee(uint256 _amount) public onlyOwner{
739         DEADFee = _amount;
740     }
741 
742 
743 
744 }