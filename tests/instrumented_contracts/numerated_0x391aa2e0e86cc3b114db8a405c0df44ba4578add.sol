1 /**
2  *Submitted for verification at BscScan.com on 2022-08-30
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2022-08-30
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: @openzeppelin/contracts/utils/Context.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/access/Ownable.sol
39 
40 
41 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Contract module that helps prevent reentrant calls to a function.
125  *
126  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
127  * available, which can be applied to functions to make sure there are no nested
128  * (reentrant) calls to them.
129  *
130  * Note that because there is a single `nonReentrant` guard, functions marked as
131  * `nonReentrant` may not call one another. This can be worked around by making
132  * those functions `private`, and then adding `external` `nonReentrant` entry
133  * points to them.
134  *
135  * TIP: If you would like to learn more about reentrancy and alternative ways
136  * to protect against it, check out our blog post
137  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
138  */
139 abstract contract ReentrancyGuard {
140     // Booleans are more expensive than uint256 or any type that takes up a full
141     // word because each write operation emits an extra SLOAD to first read the
142     // slot's contents, replace the bits taken up by the boolean, and then write
143     // back. This is the compiler's defense against contract upgrades and
144     // pointer aliasing, and it cannot be disabled.
145 
146     // The values being non-zero value makes deployment a bit more expensive,
147     // but in exchange the refund on every call to nonReentrant will be lower in
148     // amount. Since refunds are capped to a percentage of the total
149     // transaction's gas, it is best to keep them low in cases like this one, to
150     // increase the likelihood of the full refund coming into effect.
151     uint256 private constant _NOT_ENTERED = 1;
152     uint256 private constant _ENTERED = 2;
153 
154     uint256 private _status;
155 
156     constructor() {
157         _status = _NOT_ENTERED;
158     }
159 
160     /**
161      * @dev Prevents a contract from calling itself, directly or indirectly.
162      * Calling a `nonReentrant` function from another `nonReentrant`
163      * function is not supported. It is possible to prevent this from happening
164      * by making the `nonReentrant` function external, and making it call a
165      * `private` function that does the actual work.
166      */
167     modifier nonReentrant() {
168         // On the first call to nonReentrant, _notEntered will be true
169         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
170 
171         // Any calls to nonReentrant after this point will fail
172         _status = _ENTERED;
173 
174         _;
175 
176         // By storing the original value once again, a refund is triggered (see
177         // https://eips.ethereum.org/EIPS/eip-2200)
178         _status = _NOT_ENTERED;
179     }
180 }
181 
182 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Interface of the ERC165 standard, as defined in the
191  * https://eips.ethereum.org/EIPS/eip-165[EIP].
192  *
193  * Implementers can declare support of contract interfaces, which can then be
194  * queried by others ({ERC165Checker}).
195  *
196  * For an implementation, see {ERC165}.
197  */
198 interface IERC165 {
199     /**
200      * @dev Returns true if this contract implements the interface defined by
201      * `interfaceId`. See the corresponding
202      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
203      * to learn more about how these ids are created.
204      *
205      * This function call must use less than 30 000 gas.
206      */
207     function supportsInterface(bytes4 interfaceId) external view returns (bool);
208 }
209 
210 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
211 
212 
213 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 
218 /**
219  * @dev Required interface of an ERC721 compliant contract.
220  */
221 interface IERC721 is IERC165 {
222     /**
223      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
226 
227     /**
228      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
229      */
230     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
231 
232     /**
233      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
234      */
235     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
236 
237     /**
238      * @dev Returns the number of tokens in ``owner``'s account.
239      */
240     function balanceOf(address owner) external view returns (uint256 balance);
241 
242     /**
243      * @dev Returns the owner of the `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function ownerOf(uint256 tokenId) external view returns (address owner);
250 
251     /**
252      * @dev Safely transfers `tokenId` token from `from` to `to`.
253      *
254      * Requirements:
255      *
256      * - `from` cannot be the zero address.
257      * - `to` cannot be the zero address.
258      * - `tokenId` token must exist and be owned by `from`.
259      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
260      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
261      *
262      * Emits a {Transfer} event.
263      */
264     function safeTransferFrom(
265         address from,
266         address to,
267         uint256 tokenId,
268         bytes calldata data
269     ) external;
270 
271     /**
272      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
273      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
274      *
275      * Requirements:
276      *
277      * - `from` cannot be the zero address.
278      * - `to` cannot be the zero address.
279      * - `tokenId` token must exist and be owned by `from`.
280      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
281      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
282      *
283      * Emits a {Transfer} event.
284      */
285     function safeTransferFrom(
286         address from,
287         address to,
288         uint256 tokenId
289     ) external;
290 
291     /**
292      * @dev Transfers `tokenId` token from `from` to `to`.
293      *
294      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
295      *
296      * Requirements:
297      *
298      * - `from` cannot be the zero address.
299      * - `to` cannot be the zero address.
300      * - `tokenId` token must be owned by `from`.
301      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
302      *
303      * Emits a {Transfer} event.
304      */
305     function transferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) external;
310 
311     /**
312      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
313      * The approval is cleared when the token is transferred.
314      *
315      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
316      *
317      * Requirements:
318      *
319      * - The caller must own the token or be an approved operator.
320      * - `tokenId` must exist.
321      *
322      * Emits an {Approval} event.
323      */
324     function approve(address to, uint256 tokenId) external;
325 
326     /**
327      * @dev Approve or remove `operator` as an operator for the caller.
328      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
329      *
330      * Requirements:
331      *
332      * - The `operator` cannot be the caller.
333      *
334      * Emits an {ApprovalForAll} event.
335      */
336     function setApprovalForAll(address operator, bool _approved) external;
337 
338     /**
339      * @dev Returns the account approved for `tokenId` token.
340      *
341      * Requirements:
342      *
343      * - `tokenId` must exist.
344      */
345     function getApproved(uint256 tokenId) external view returns (address operator);
346 
347     /**
348      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
349      *
350      * See {setApprovalForAll}
351      */
352     function isApprovedForAll(address owner, address operator) external view returns (bool);
353 }
354 
355 // File: @openzeppelin/contracts/interfaces/IERC721.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 
363 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
364 
365 
366 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Interface of the ERC20 standard as defined in the EIP.
372  */
373 interface IERC20 {
374     /**
375      * @dev Emitted when `value` tokens are moved from one account (`from`) to
376      * another (`to`).
377      *
378      * Note that `value` may be zero.
379      */
380     event Transfer(address indexed from, address indexed to, uint256 value);
381 
382     /**
383      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
384      * a call to {approve}. `value` is the new allowance.
385      */
386     event Approval(address indexed owner, address indexed spender, uint256 value);
387 
388     /**
389      * @dev Returns the amount of tokens in existence.
390      */
391     function totalSupply() external view returns (uint256);
392 
393     /**
394      * @dev Returns the amount of tokens owned by `account`.
395      */
396     function balanceOf(address account) external view returns (uint256);
397 
398     /**
399      * @dev Moves `amount` tokens from the caller's account to `to`.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transfer(address to, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Returns the remaining number of tokens that `spender` will be
409      * allowed to spend on behalf of `owner` through {transferFrom}. This is
410      * zero by default.
411      *
412      * This value changes when {approve} or {transferFrom} are called.
413      */
414     function allowance(address owner, address spender) external view returns (uint256);
415 
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
418      *
419      * Returns a boolean value indicating whether the operation succeeded.
420      *
421      * IMPORTANT: Beware that changing an allowance with this method brings the risk
422      * that someone may use both the old and the new allowance by unfortunate
423      * transaction ordering. One possible solution to mitigate this race
424      * condition is to first reduce the spender's allowance to 0 and set the
425      * desired value afterwards:
426      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
427      *
428      * Emits an {Approval} event.
429      */
430     function approve(address spender, uint256 amount) external returns (bool);
431 
432     /**
433      * @dev Moves `amount` tokens from `from` to `to` using the
434      * allowance mechanism. `amount` is then deducted from the caller's
435      * allowance.
436      *
437      * Returns a boolean value indicating whether the operation succeeded.
438      *
439      * Emits a {Transfer} event.
440      */
441     function transferFrom(
442         address from,
443         address to,
444         uint256 amount
445     ) external returns (bool);
446 }
447 
448 // File: @openzeppelin/contracts/interfaces/IERC20.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 
456 
457 pragma solidity  ^0.8.1;
458 
459 
460     
461 contract WolfpupsMinter is Ownable, ReentrancyGuard {
462      
463      address public nftaddress; 
464      bool public claimenabled = false; 
465      address public wolf = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
466      uint256 public wolflimit;
467      uint256 public redeemstarttingrange;
468      uint256 public redeemendrange;
469      uint256 public claimIndex;
470      address public nftAdmin = 0x8fFAeBAcbc3bA0869098Fc0D20cA292dC1e94a73;
471      uint256 public price;
472      mapping (address => uint256) public userinvested;
473      address[] public investors;
474      mapping (address => bool) public existinguser;
475      mapping (address => bool) public iswhitelist;
476      uint256 public maxInvestment;   
477      uint public icoTarget;
478      uint public receivedFund=0;
479      enum Round {Whitelistround, PublicRound}
480      Round public round;
481 
482      event Claim(address indexed user, uint256 indexed tokenid);
483    
484    
485     function getRound() external view returns(Round) {
486         return round;
487     }
488 
489    function startWhitelistinground() external onlyOwner {
490         round = Round.Whitelistround;
491     }
492 
493    function startPublicround() external onlyOwner {
494         round = Round.PublicRound;
495     }
496 
497     function trade(uint _noofnfts) public payable nonReentrant {
498         
499         require (claimenabled == true, "Claim not enabled");   
500         require (_noofnfts>0, "nonzero value not accepted");
501 
502         if (round == Round.Whitelistround) {
503            require(iswhitelist[msg.sender], "not whitelised");
504         }
505          uint256 _amount = price * _noofnfts;
506           
507          require(_amount == msg.value, "incorrect amount");
508            
509           // check wolf balance 
510           require (IERC20(wolf).balanceOf(msg.sender) >= wolflimit, "Hold wolf to Participate");
511     
512           //check for hard cap
513           require(icoTarget >= receivedFund + _amount, "Target Achieved. Investment not accepted");
514      
515           //  require(_amount > 0 , "min Investment not zero");
516           uint256 checkamount = userinvested[msg.sender] + _amount;
517      
518           //check maximum investment        
519            require(checkamount <= maxInvestment, "Already max Invested"); 
520      
521           // check for existinguser
522           if (!existinguser[msg.sender]) {
523             existinguser[msg.sender] = true;
524             investors.push(msg.sender);
525           }
526      
527            userinvested[msg.sender] += _amount; 
528            receivedFund = receivedFund + _amount;
529              
530            IERC721 nft = IERC721(nftaddress); 
531            
532            uint256 nftidstart = redeemstarttingrange + claimIndex;  
533            uint nftidend = nftidstart + _noofnfts;       
534            assert (nftidend <= redeemendrange);   
535            claimIndex += _noofnfts;
536 
537            for ( uint i = nftidstart; i < nftidend; i++ ) {   
538                nft.safeTransferFrom(nftAdmin, msg.sender, i);
539                emit Claim(msg.sender,i);
540            }
541      }
542 
543     function remainigContribution(address _owner) public view returns (uint256) {
544         uint256 remaining = maxInvestment - userinvested[_owner];
545         return remaining;
546     }
547      
548     function withdarw(address payable _admin) public onlyOwner{
549        uint256 raisedamount = address(this).balance;
550        (bool sent,) = _admin.call{value: raisedamount}("");
551        require(sent, "ETH Transfer Failed: ");
552     }
553     
554     function setclaimStatus(bool _status) external onlyOwner {
555        claimenabled = _status;
556     }
557     
558     function setwolflimit(uint256 _newlimit) public onlyOwner {
559         wolflimit = _newlimit;   
560     }
561               
562     function changenftadmin(address _add) public onlyOwner  {
563         nftAdmin = _add; 
564     }
565     
566     function changeIcotarget(uint256 _newvalue) public onlyOwner {
567         icoTarget = _newvalue; 
568     }
569     
570     function changeredeemeendlimit(uint256 _newvalue) public onlyOwner {
571         redeemendrange = _newvalue; 
572     }
573     
574     function changeredeemstartlimit(uint256 _newvalue) public onlyOwner {
575         redeemstarttingrange = _newvalue; 
576     }
577     
578     function changenftaddress(address _add) public onlyOwner {
579         nftaddress = _add;
580     }
581        
582     function changetokenaddress(address _add) public onlyOwner {
583         wolf = _add;
584     }
585 
586     function changeMaxInvestment(uint _newmax) external onlyOwner {
587         require (icoTarget > _newmax, "Incorrect maxinvestment value");
588         require (_newmax > maxInvestment, "Incorrect maxinvestment value");
589         maxInvestment = _newmax;
590     }
591        
592     function resetICO() public onlyOwner {
593         
594          for (uint256 i = 0; i < investors.length; i++) {
595             if (existinguser[investors[i]]==true)
596             {
597                   existinguser[investors[i]]=false;
598                   userinvested[investors[i]] = 0;
599             }
600         }
601         
602         icoTarget = 0;
603         receivedFund = 0;
604         maxInvestment = 0;
605         nftaddress =   0x0000000000000000000000000000000000000000;
606         claimenabled = false;
607         redeemstarttingrange = 0;
608         redeemendrange = 0;
609         claimIndex = 0;
610         price = 0 ; 
611         delete investors;
612     }
613 
614     function changePrice(uint _newprice) external onlyOwner {
615         price = _newprice;
616     }
617 
618     function Whitelist(address _add, bool _value ) external onlyOwner {
619         iswhitelist[_add] = _value;
620     }
621 
622     function addMultipleWhitelist(address[] memory _add) external onlyOwner {
623         require (_add.length <=100, "too many users");
624         for (uint i=0; i<_add.length; i++) {
625             iswhitelist[_add[i]] = true;
626         }
627     }     
628     
629     function initializeICO(uint256 _price, address _nftaddress, uint256 _icotarget, uint256 _maxinvestment, uint256 _nftstartingrange, uint256 _nftendrange) public onlyOwner 
630     {
631         require (_nftendrange>_nftstartingrange, "incorrect range") ;  
632         nftaddress = _nftaddress;
633         icoTarget = _icotarget;
634         redeemstarttingrange = _nftstartingrange;
635         redeemendrange = _nftendrange;
636         price  =_price;
637         require (icoTarget > _maxinvestment, "Incorrect maxinvestment value");
638         maxInvestment = _maxinvestment;
639     }
640 }