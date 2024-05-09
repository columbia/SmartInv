1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface of the ERC165 standard, as defined in the
95  * https://eips.ethereum.org/EIPS/eip-165[EIP].
96  *
97  * Implementers can declare support of contract interfaces, which can then be
98  * queried by others ({ERC165Checker}).
99  *
100  * For an implementation, see {ERC165}.
101  */
102 interface IERC165 {
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Required interface of an ERC721 compliant contract.
124  */
125 interface IERC721 is IERC165 {
126     /**
127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
133      */
134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
138      */
139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
140 
141     /**
142      * @dev Returns the number of tokens in ``owner``'s account.
143      */
144     function balanceOf(address owner) external view returns (uint256 balance);
145 
146     /**
147      * @dev Returns the owner of the `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function ownerOf(uint256 tokenId) external view returns (address owner);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` token from `from` to `to`.
197      *
198      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
199      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
200      * understand this adds an external call which potentially creates a reentrancy vulnerability.
201      *
202      * Requirements:
203      *
204      * - `from` cannot be the zero address.
205      * - `to` cannot be the zero address.
206      * - `tokenId` token must be owned by `from`.
207      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external;
216 
217     /**
218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
219      * The approval is cleared when the token is transferred.
220      *
221      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
222      *
223      * Requirements:
224      *
225      * - The caller must own the token or be an approved operator.
226      * - `tokenId` must exist.
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address to, uint256 tokenId) external;
231 
232     /**
233      * @dev Approve or remove `operator` as an operator for the caller.
234      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
235      *
236      * Requirements:
237      *
238      * - The `operator` cannot be the caller.
239      *
240      * Emits an {ApprovalForAll} event.
241      */
242     function setApprovalForAll(address operator, bool _approved) external;
243 
244     /**
245      * @dev Returns the account approved for `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function getApproved(uint256 tokenId) external view returns (address operator);
252 
253     /**
254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
255      *
256      * See {setApprovalForAll}
257      */
258     function isApprovedForAll(address owner, address operator) external view returns (bool);
259 }
260 
261 // File: @openzeppelin/contracts/utils/Context.sol
262 
263 
264 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 /**
269  * @dev Provides information about the current execution context, including the
270  * sender of the transaction and its data. While these are generally available
271  * via msg.sender and msg.data, they should not be accessed in such a direct
272  * manner, since when dealing with meta-transactions the account sending and
273  * paying for execution may not be the actual sender (as far as an application
274  * is concerned).
275  *
276  * This contract is only required for intermediate, library-like contracts.
277  */
278 abstract contract Context {
279     function _msgSender() internal view virtual returns (address) {
280         return msg.sender;
281     }
282 
283     function _msgData() internal view virtual returns (bytes calldata) {
284         return msg.data;
285     }
286 }
287 
288 // File: @openzeppelin/contracts/access/Ownable.sol
289 
290 
291 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 
296 /**
297  * @dev Contract module which provides a basic access control mechanism, where
298  * there is an account (an owner) that can be granted exclusive access to
299  * specific functions.
300  *
301  * By default, the owner account will be the one that deploys the contract. This
302  * can later be changed with {transferOwnership}.
303  *
304  * This module is used through inheritance. It will make available the modifier
305  * `onlyOwner`, which can be applied to your functions to restrict their use to
306  * the owner.
307  */
308 abstract contract Ownable is Context {
309     address private _owner;
310 
311     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
312 
313     /**
314      * @dev Initializes the contract setting the deployer as the initial owner.
315      */
316     constructor() {
317         _transferOwnership(_msgSender());
318     }
319 
320     /**
321      * @dev Throws if called by any account other than the owner.
322      */
323     modifier onlyOwner() {
324         _checkOwner();
325         _;
326     }
327 
328     /**
329      * @dev Returns the address of the current owner.
330      */
331     function owner() public view virtual returns (address) {
332         return _owner;
333     }
334 
335     /**
336      * @dev Throws if the sender is not the owner.
337      */
338     function _checkOwner() internal view virtual {
339         require(owner() == _msgSender(), "Ownable: caller is not the owner");
340     }
341 
342     /**
343      * @dev Leaves the contract without owner. It will not be possible to call
344      * `onlyOwner` functions anymore. Can only be called by the current owner.
345      *
346      * NOTE: Renouncing ownership will leave the contract without an owner,
347      * thereby removing any functionality that is only available to the owner.
348      */
349     function renounceOwnership() public virtual onlyOwner {
350         _transferOwnership(address(0));
351     }
352 
353     /**
354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
355      * Can only be called by the current owner.
356      */
357     function transferOwnership(address newOwner) public virtual onlyOwner {
358         require(newOwner != address(0), "Ownable: new owner is the zero address");
359         _transferOwnership(newOwner);
360     }
361 
362     /**
363      * @dev Transfers ownership of the contract to a new account (`newOwner`).
364      * Internal function without access restriction.
365      */
366     function _transferOwnership(address newOwner) internal virtual {
367         address oldOwner = _owner;
368         _owner = newOwner;
369         emit OwnershipTransferred(oldOwner, newOwner);
370     }
371 }
372 
373 // File: contracts/Ogac/OgacReferalMintCrossMint.sol
374 
375 
376 pragma solidity ^0.8.7;
377 
378 
379 
380 
381 interface IOgac {
382 	function mintBreeding(address _address, uint256 _mintAmount) external;
383 }
384 
385 
386 contract OgacReferalMintCrossMint is  Ownable {
387   
388    
389     bool public paused = false;
390     bool public payReferal = true;
391     bool public mintWithErc20 = false;
392     uint256 public maxMintAmountPerTransaction = 15;
393     uint256 public maxSupply = 8420;
394     uint256 public currentSupply = 4422; 
395     uint256 public referalPayoutPerMint = 0.005 ether;
396     uint256 public price = 0.055 ether;
397     mapping(address => bool) public _allowedErc20;
398     mapping(address => uint256) public _erc20MintPrice;
399     mapping(address => bool) public _bridges;
400     address public ERC20FUNDWALLET = 0x4fdc1E3a6c0243a089D80E90D7bd0e060044E267;
401     address public crossmintAddress;
402     
403     IOgac public mintNft;
404     
405     
406     constructor(address  _ogac) {
407         mintNft = IOgac(_ogac);
408     }
409 
410 
411 function setCrossmintAddress(address _crossmintAddress) public onlyOwner {
412     crossmintAddress = _crossmintAddress;
413   }
414 
415   function crossmint(address _to, uint256 _amount) public payable {
416        require(!paused, "Contract is paused");
417         require((currentSupply + _amount) <= maxSupply, "Ogac Supply Passed");
418         require( _amount <= maxMintAmountPerTransaction, "Passed Mint limit per transaction");
419          require(msg.value >= (price * _amount), "Not enough Funds");
420     // NOTE THAT the address is different for ethereum, polygon, and mumbai
421     // ethereum (all)  = 0xdab1a1854214684ace522439684a145e62505233  
422     require(msg.sender == crossmintAddress, 
423       "This function is for Crossmint only."
424     );
425 
426    
427          if(_amount == 15){
428              _mint(_to, _amount + 5);
429               currentSupply += _amount + 5;
430          }else if (_amount >= 12){
431              _mint(_to, _amount + 4);
432               currentSupply += _amount + 4;
433          }else if(_amount >= 9) {
434              _mint(_to, _amount + 3);
435               currentSupply += _amount + 3;
436          }else if(_amount >= 6){
437              _mint(_to, _amount + 2);
438               currentSupply += _amount + 2;
439          }else if (_amount >= 3){
440                 _mint(_to, _amount + 1);
441                  currentSupply += _amount +1;
442          }else{
443               currentSupply += _amount;
444             _mint(_to, _amount);
445          }   
446     
447   }
448 
449     function mintOgac(uint256 _amount, address payable ref) payable external {
450         require(!paused, "Contract is paused");
451         require((currentSupply + _amount) <= maxSupply, "Ogac Supply Passed");
452         require( _amount <= maxMintAmountPerTransaction, "Passed Mint limit per transaction");
453         //check price 
454         if(msg.sender != owner()){
455              require(msg.value >= (price * _amount), "Not enough Funds");
456         }
457            if(_amount == 15){
458              _mint(msg.sender, _amount + 5);
459               currentSupply += _amount + 5;
460          }else if (_amount >= 12){
461              _mint(msg.sender, _amount + 4);
462               currentSupply += _amount + 4;
463          }else if(_amount >= 9) {
464              _mint(msg.sender, _amount + 3);
465               currentSupply += _amount + 3;
466          }else if(_amount >= 6){
467              _mint(msg.sender, _amount + 2);
468               currentSupply += _amount + 2;
469          }else if (_amount >= 3){
470                 _mint(msg.sender, _amount + 1);
471                  currentSupply += _amount +1;
472          }else{
473               currentSupply += _amount;
474             _mint(msg.sender, _amount);
475          }   
476 
477          if(ref != 0x0000000000000000000000000000000000000000 && payReferal){
478             (bool sent,) = ref.call{value: _amount * referalPayoutPerMint}("");
479             require(sent, "Failed to send to Referer");
480          }
481     }
482 
483     function mintOgacWithErc20(uint256 _amount, address _erc20) payable external {
484         require(!paused, "Contract is paused");
485         require(mintWithErc20, "ERC20 Payments Disabled");
486         require((currentSupply + _amount) <= maxSupply, "Ogac Supply Passed");
487         require( _amount <= maxMintAmountPerTransaction, "Passed Mint limit per transaction");
488             //check if erc20 contract is allowed
489             require(_allowedErc20[_erc20], "ERC20 is not allowed");
490             //check if erc20 price is not 0
491             require(_erc20MintPrice[_erc20] > 0, "ERC20 Mint price not set");
492             //check allowance 
493             require(IERC20(_erc20).allowance(msg.sender, address(this)) > (_erc20MintPrice[_erc20] * _amount), "Not enough Allowance");
494             IERC20(_erc20).transferFrom(msg.sender,ERC20FUNDWALLET,_erc20MintPrice[_erc20] * _amount);
495         
496          currentSupply += _amount;
497          if(_amount == 15){
498              _mint(msg.sender, _amount + 5);
499          }else if (_amount >= 12){
500              _mint(msg.sender, _amount + 4);
501          }else if(_amount >= 9) {
502              _mint(msg.sender, _amount + 3);
503          }else if(_amount >= 6){
504              _mint(msg.sender, _amount + 2);
505          }else if (_amount >= 3){
506                 _mint(msg.sender, _amount + 1);
507          }else{
508             _mint(msg.sender, _amount);
509          }   
510     }
511 
512     function setPause(bool _state) external  onlyOwner {
513         paused = _state;
514     }
515 
516     function setReferalPayout(uint256 _val) external onlyOwner {
517         referalPayoutPerMint = _val;
518     }
519 
520     function setErc20Paymentstate(bool _val) external onlyOwner{
521        mintWithErc20 = _val;
522     }
523 
524     function setReferalState(bool _val) external onlyOwner {
525             payReferal = _val;
526     }
527 
528     function setErc20ContractState(address _a, uint256 _p, bool _val) external onlyOwner{
529         _allowedErc20[_a] = _val;
530         _erc20MintPrice[_a] = _p;
531     }
532 
533     function setBridges(address _a, bool _val) external onlyOwner{
534         _bridges[_a] = _val;
535     }
536     
537     function setErc20FundAddress(address _a) external onlyOwner {
538         ERC20FUNDWALLET = _a;
539     }
540 
541     function setMaxSupply(uint256 _val) external onlyOwner {
542         maxSupply = _val;
543     }
544 
545      function setPrice(uint256 _val) external onlyOwner {
546         price = _val;
547     }
548 
549     function setCurrentSupply(uint256 _val) external onlyOwner {
550         currentSupply = _val;
551     }
552 
553 
554     function setMaxPerTransaction(uint256 _val) external onlyOwner{
555         maxMintAmountPerTransaction = _val;
556     }
557 
558     function _mint(address _user, uint256 _amount) internal {
559             mintNft.mintBreeding(_user, _amount);
560     }
561 
562      function mintExternal(address _address, uint256 _mintAmount) external {
563         require(
564             _bridges[msg.sender],
565             "Sorry you don't have permission to mint"
566         );
567         mintNft.mintBreeding(_address, _mintAmount);
568     }
569 
570      function gift(address _to, uint256 _mintAmount) public onlyOwner {
571         mintNft.mintBreeding(_to, _mintAmount);
572     }
573 
574      function withdraw() public payable onlyOwner {
575         (bool hq, ) = payable(owner()).call{value: address(this).balance}("");
576         require(hq);
577     }
578 
579    
580 }