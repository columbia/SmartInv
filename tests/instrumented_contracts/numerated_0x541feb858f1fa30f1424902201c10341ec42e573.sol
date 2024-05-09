1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-30
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2022-08-30
7 */
8 
9 /**
10  *Submitted for verification at BscScan.com on 2022-08-30
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 // File: @openzeppelin/contracts/utils/Context.sol
16 
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 // File: @openzeppelin/contracts/access/Ownable.sol
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 
50 /**
51  * @dev Contract module which provides a basic access control mechanism, where
52  * there is an account (an owner) that can be granted exclusive access to
53  * specific functions.
54  *
55  * By default, the owner account will be the one that deploys the contract. This
56  * can later be changed with {transferOwnership}.
57  *
58  * This module is used through inheritance. It will make available the modifier
59  * `onlyOwner`, which can be applied to your functions to restrict their use to
60  * the owner.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _transferOwnership(_msgSender());
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions anymore. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby removing any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119 
120 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev Contract module that helps prevent reentrant calls to a function.
129  *
130  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
131  * available, which can be applied to functions to make sure there are no nested
132  * (reentrant) calls to them.
133  *
134  * Note that because there is a single `nonReentrant` guard, functions marked as
135  * `nonReentrant` may not call one another. This can be worked around by making
136  * those functions `private`, and then adding `external` `nonReentrant` entry
137  * points to them.
138  *
139  * TIP: If you would like to learn more about reentrancy and alternative ways
140  * to protect against it, check out our blog post
141  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
142  */
143 abstract contract ReentrancyGuard {
144     // Booleans are more expensive than uint256 or any type that takes up a full
145     // word because each write operation emits an extra SLOAD to first read the
146     // slot's contents, replace the bits taken up by the boolean, and then write
147     // back. This is the compiler's defense against contract upgrades and
148     // pointer aliasing, and it cannot be disabled.
149 
150     // The values being non-zero value makes deployment a bit more expensive,
151     // but in exchange the refund on every call to nonReentrant will be lower in
152     // amount. Since refunds are capped to a percentage of the total
153     // transaction's gas, it is best to keep them low in cases like this one, to
154     // increase the likelihood of the full refund coming into effect.
155     uint256 private constant _NOT_ENTERED = 1;
156     uint256 private constant _ENTERED = 2;
157 
158     uint256 private _status;
159 
160     constructor() {
161         _status = _NOT_ENTERED;
162     }
163 
164     /**
165      * @dev Prevents a contract from calling itself, directly or indirectly.
166      * Calling a `nonReentrant` function from another `nonReentrant`
167      * function is not supported. It is possible to prevent this from happening
168      * by making the `nonReentrant` function external, and making it call a
169      * `private` function that does the actual work.
170      */
171     modifier nonReentrant() {
172         // On the first call to nonReentrant, _notEntered will be true
173         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
174 
175         // Any calls to nonReentrant after this point will fail
176         _status = _ENTERED;
177 
178         _;
179 
180         // By storing the original value once again, a refund is triggered (see
181         // https://eips.ethereum.org/EIPS/eip-2200)
182         _status = _NOT_ENTERED;
183     }
184 }
185 
186 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
187 
188 
189 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev Interface of the ERC165 standard, as defined in the
195  * https://eips.ethereum.org/EIPS/eip-165[EIP].
196  *
197  * Implementers can declare support of contract interfaces, which can then be
198  * queried by others ({ERC165Checker}).
199  *
200  * For an implementation, see {ERC165}.
201  */
202 interface IERC165 {
203     /**
204      * @dev Returns true if this contract implements the interface defined by
205      * `interfaceId`. See the corresponding
206      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
207      * to learn more about how these ids are created.
208      *
209      * This function call must use less than 30 000 gas.
210      */
211     function supportsInterface(bytes4 interfaceId) external view returns (bool);
212 }
213 
214 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
215 
216 
217 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 
222 /**
223  * @dev Required interface of an ERC721 compliant contract.
224  */
225 interface IERC721 is IERC165 {
226     /**
227      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
228      */
229     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
230 
231     /**
232      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
233      */
234     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
235 
236     /**
237      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
238      */
239     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
240 
241     /**
242      * @dev Returns the number of tokens in ``owner``'s account.
243      */
244     function balanceOf(address owner) external view returns (uint256 balance);
245 
246     /**
247      * @dev Returns the owner of the `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function ownerOf(uint256 tokenId) external view returns (address owner);
254 
255     /**
256      * @dev Safely transfers `tokenId` token from `from` to `to`.
257      *
258      * Requirements:
259      *
260      * - `from` cannot be the zero address.
261      * - `to` cannot be the zero address.
262      * - `tokenId` token must exist and be owned by `from`.
263      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
264      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
265      *
266      * Emits a {Transfer} event.
267      */
268     function safeTransferFrom(
269         address from,
270         address to,
271         uint256 tokenId,
272         bytes calldata data
273     ) external;
274 
275     /**
276      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
277      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
278      *
279      * Requirements:
280      *
281      * - `from` cannot be the zero address.
282      * - `to` cannot be the zero address.
283      * - `tokenId` token must exist and be owned by `from`.
284      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
285      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
286      *
287      * Emits a {Transfer} event.
288      */
289     function safeTransferFrom(
290         address from,
291         address to,
292         uint256 tokenId
293     ) external;
294 
295     /**
296      * @dev Transfers `tokenId` token from `from` to `to`.
297      *
298      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must be owned by `from`.
305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transferFrom(
310         address from,
311         address to,
312         uint256 tokenId
313     ) external;
314 
315     /**
316      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
317      * The approval is cleared when the token is transferred.
318      *
319      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
320      *
321      * Requirements:
322      *
323      * - The caller must own the token or be an approved operator.
324      * - `tokenId` must exist.
325      *
326      * Emits an {Approval} event.
327      */
328     function approve(address to, uint256 tokenId) external;
329 
330     /**
331      * @dev Approve or remove `operator` as an operator for the caller.
332      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
333      *
334      * Requirements:
335      *
336      * - The `operator` cannot be the caller.
337      *
338      * Emits an {ApprovalForAll} event.
339      */
340     function setApprovalForAll(address operator, bool _approved) external;
341 
342     /**
343      * @dev Returns the account approved for `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function getApproved(uint256 tokenId) external view returns (address operator);
350 
351     /**
352      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
353      *
354      * See {setApprovalForAll}
355      */
356     function isApprovedForAll(address owner, address operator) external view returns (bool);
357 }
358 
359 // File: @openzeppelin/contracts/interfaces/IERC721.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 
367 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
368 
369 
370 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Interface of the ERC20 standard as defined in the EIP.
376  */
377 interface IERC20 {
378     /**
379      * @dev Emitted when `value` tokens are moved from one account (`from`) to
380      * another (`to`).
381      *
382      * Note that `value` may be zero.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 value);
385 
386     /**
387      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
388      * a call to {approve}. `value` is the new allowance.
389      */
390     event Approval(address indexed owner, address indexed spender, uint256 value);
391 
392     /**
393      * @dev Returns the amount of tokens in existence.
394      */
395     function totalSupply() external view returns (uint256);
396 
397     /**
398      * @dev Returns the amount of tokens owned by `account`.
399      */
400     function balanceOf(address account) external view returns (uint256);
401 
402     /**
403      * @dev Moves `amount` tokens from the caller's account to `to`.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transfer(address to, uint256 amount) external returns (bool);
410 
411     /**
412      * @dev Returns the remaining number of tokens that `spender` will be
413      * allowed to spend on behalf of `owner` through {transferFrom}. This is
414      * zero by default.
415      *
416      * This value changes when {approve} or {transferFrom} are called.
417      */
418     function allowance(address owner, address spender) external view returns (uint256);
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * IMPORTANT: Beware that changing an allowance with this method brings the risk
426      * that someone may use both the old and the new allowance by unfortunate
427      * transaction ordering. One possible solution to mitigate this race
428      * condition is to first reduce the spender's allowance to 0 and set the
429      * desired value afterwards:
430      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
431      *
432      * Emits an {Approval} event.
433      */
434     function approve(address spender, uint256 amount) external returns (bool);
435 
436     /**
437      * @dev Moves `amount` tokens from `from` to `to` using the
438      * allowance mechanism. `amount` is then deducted from the caller's
439      * allowance.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transferFrom(
446         address from,
447         address to,
448         uint256 amount
449     ) external returns (bool);
450 }
451 
452 // File: @openzeppelin/contracts/interfaces/IERC20.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 
460 
461 pragma solidity  ^0.8.1;
462 
463 
464     
465 contract RecoveryPunkMinter is Ownable, ReentrancyGuard {
466      
467      address public nftaddress; 
468      address public specialNftadd1;
469      address public specialNftadd2;
470      bool public claimenabled = false; 
471      address public wolf = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
472      uint256 public wolflimit;
473      uint256 public redeemstarttingrange;
474      uint256 public redeemendrange;
475      uint256 public claimIndex;
476      address public nftAdmin;
477      uint256 public price;
478      mapping (address => uint256) public userinvested;
479      address[] public investors;
480      mapping (address => bool) public existinguser;
481      mapping (address => bool) public iswhitelist;
482      uint256 public maxInvestment;   
483      uint public icoTarget;
484      uint public receivedFund=0;
485      enum Round {Whitelistround, SpecialNftRound, PublicRound}
486      Round public round;
487 
488     constructor(address _nftAdmin) {
489        nftAdmin = _nftAdmin;
490     } 
491 
492      event Claim(address indexed user, uint256 indexed tokenid);
493    
494    
495     function getRound() external view returns(Round) {
496         return round;
497     }
498 
499     function startWhitelistinground() external onlyOwner {
500         round = Round.Whitelistround;
501     }
502 
503     function startSpecialNftround() external onlyOwner {
504         round = Round.SpecialNftRound;
505     }
506 
507     function startPublicround() external onlyOwner {
508         round = Round.PublicRound;
509     }
510 
511     function trade(uint _noofnfts) public payable nonReentrant {
512         
513         require (claimenabled == true, "Claim not enabled");   
514         require (_noofnfts>0, "nonzero value not accepted");
515 
516         if (round == Round.Whitelistround) {
517            require(iswhitelist[msg.sender], "not whitelised");
518         }
519 
520         if (round == Round.SpecialNftRound) {
521             require(checkSpecialNFT(msg.sender), "no special nft in wallet");
522         }
523 
524          uint256 _amount = price * _noofnfts;
525          require(_amount == msg.value, "incorrect amount");
526            
527           // check wolf balance 
528           require (IERC20(wolf).balanceOf(msg.sender) >= wolflimit, "Hold wolf to Participate");
529     
530           //check for hard cap
531           require(icoTarget >= receivedFund + _amount, "Target Achieved. Investment not accepted");
532      
533           //  require(_amount > 0 , "min Investment not zero");
534           uint256 checkamount = userinvested[msg.sender] + _amount;
535      
536           //check maximum investment        
537            require(checkamount <= maxInvestment, "Already max Invested"); 
538       
539           // check for existinguser
540           if (!existinguser[msg.sender]) {
541             existinguser[msg.sender] = true;
542             investors.push(msg.sender);
543           }
544      
545            userinvested[msg.sender] += _amount; 
546            receivedFund = receivedFund + _amount;
547              
548            IERC721 nft = IERC721(nftaddress); 
549            
550            uint256 nftidstart = redeemstarttingrange + claimIndex;  
551            uint nftidend = nftidstart + _noofnfts;       
552            assert (nftidend <= redeemendrange);   
553            claimIndex += _noofnfts;
554 
555            for ( uint i = nftidstart; i < nftidend; i++ ) {   
556                nft.safeTransferFrom(nftAdmin, msg.sender, i);
557                emit Claim(msg.sender,i);
558            }
559      }
560 
561     function remainigContribution(address _owner) public view returns (uint256) {
562         uint256 remaining = maxInvestment - userinvested[_owner];
563         return remaining;
564     }
565      
566     function withdarw(address payable _admin) public onlyOwner{
567        uint256 raisedamount = address(this).balance;
568        (bool sent,) = _admin.call{value: raisedamount}("");
569        require(sent, "ETH Transfer Failed: ");
570     }
571     
572     function setclaimStatus(bool _status) external onlyOwner {
573        claimenabled = _status;
574     }
575     
576     function setwolflimit(uint256 _newlimit) public onlyOwner {
577         wolflimit = _newlimit;   
578     }
579               
580     function changenftadmin(address _add) public onlyOwner  {
581         nftAdmin = _add; 
582     }
583     
584     function changeIcotarget(uint256 _newvalue) public onlyOwner {
585         icoTarget = _newvalue; 
586     }
587     
588     function changeredeemeendlimit(uint256 _newvalue) public onlyOwner {
589         redeemendrange = _newvalue; 
590     }
591     
592     function changeredeemstartlimit(uint256 _newvalue) public onlyOwner {
593         redeemstarttingrange = _newvalue; 
594     }
595     
596     function changenftaddress(address _add) public onlyOwner {
597         nftaddress = _add;
598     }
599        
600     function changetokenaddress(address _add) public onlyOwner {
601         wolf = _add;
602     }
603 
604     function changeMaxInvestment(uint _newmax) external onlyOwner {
605         require (icoTarget > _newmax, "Incorrect maxinvestment value");
606         require (_newmax > maxInvestment, "Incorrect maxinvestment value");
607         maxInvestment = _newmax;
608     }
609        
610     function resetICO() public onlyOwner {
611         
612          for (uint256 i = 0; i < investors.length; i++) {
613             if (existinguser[investors[i]]==true)
614             {
615                   existinguser[investors[i]]=false;
616                   userinvested[investors[i]] = 0;
617             }
618         }
619         
620         icoTarget = 0;
621         receivedFund = 0;
622         maxInvestment = 0;
623         nftaddress =   0x0000000000000000000000000000000000000000;
624         specialNftadd1 = 0x0000000000000000000000000000000000000000;
625         specialNftadd2 = 0x0000000000000000000000000000000000000000;
626         claimenabled = false;
627         redeemstarttingrange = 0;
628         redeemendrange = 0;
629         claimIndex = 0;
630         price = 0 ; 
631         delete investors;
632     }
633 
634     function changePrice(uint _newprice) external onlyOwner {
635         price = _newprice;
636     }
637 
638     function Whitelist(address _add, bool _value ) external onlyOwner {
639         iswhitelist[_add] = _value;
640     }
641 
642     function checkSpecialNFT(address _user) public view returns (bool) {
643        return (IERC721(specialNftadd1).balanceOf(_user) > 0 || IERC721(specialNftadd2).balanceOf(_user) > 0);
644     }
645 
646     function addMultipleWhitelist(address[] memory _add) external onlyOwner {
647         require (_add.length <=500, "too many users");
648         for (uint i=0; i<_add.length; i++) {
649             iswhitelist[_add[i]] = true;
650         }
651     }     
652     
653     function initializeICO(uint256 _price, address _nftaddress, address _specialnftadd1, address _specialnftadd2, uint256 _icotarget, uint256 _maxinvestment, uint256 _nftstartingrange, uint256 _nftendrange) public onlyOwner 
654     {
655         require (_nftendrange>_nftstartingrange, "incorrect range") ;  
656         nftaddress = _nftaddress;
657         specialNftadd1 = _specialnftadd1;
658         specialNftadd2 = _specialnftadd2;
659         icoTarget = _icotarget;
660         redeemstarttingrange = _nftstartingrange;
661         redeemendrange = _nftendrange;
662         price  =_price;
663         require (icoTarget > _maxinvestment, "Incorrect maxinvestment value");
664         maxInvestment = _maxinvestment;
665     }
666 }