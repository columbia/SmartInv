1 pragma solidity ^0.4.24;
2 pragma experimental ABIEncoderV2;
3 
4 // ----------------------------------------------------------------------------
5 // Devery Contracts - The Monolithic Registry
6 //
7 // Deployed to Ropsten Testnet at 0x654f4a3e3B7573D6b4bB7201AB70d718961765CD
8 //
9 // Enjoy.
10 //
11 // (c) BokkyPooBah / Bok Consulting Pty Ltd for Devery 2017. The MIT Licence.
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // ERC Token Standard #20 Interface
17 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
18 // ----------------------------------------------------------------------------
19 contract ERC20Interface {
20     function totalSupply() public constant returns (uint);
21     function balanceOf(address tokenOwner) public constant returns (uint balance);
22     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
23     function transfer(address to, uint tokens) public returns (bool success);
24     function approve(address spender, uint tokens) public returns (bool success);
25     function transferFrom(address from, address to, uint tokens) public returns (bool success);
26 
27     event Transfer(address indexed from, address indexed to, uint tokens);
28     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // Owned contract
34 // ----------------------------------------------------------------------------
35 contract Owned {
36 
37     address public owner;
38     address public newOwner;
39 
40     event OwnershipTransferred(address indexed _from, address indexed _to);
41 
42     modifier onlyOwner {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function Owned() public {
48         owner = msg.sender;
49     }
50     function transferOwnership(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = 0x0;
58     }
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Administrators
64 // ----------------------------------------------------------------------------
65 contract Admined is Owned {
66 
67     mapping (address => bool) public admins;
68 
69     event AdminAdded(address addr);
70     event AdminRemoved(address addr);
71 
72     modifier onlyAdmin() {
73         require(isAdmin(msg.sender));
74         _;
75     }
76 
77     function isAdmin(address addr) public constant returns (bool) {
78         return (admins[addr] || owner == addr);
79     }
80     function addAdmin(address addr) public onlyOwner {
81         require(!admins[addr] && addr != owner);
82         admins[addr] = true;
83         AdminAdded(addr);
84     }
85     function removeAdmin(address addr) public onlyOwner {
86         require(admins[addr]);
87         delete admins[addr];
88         AdminRemoved(addr);
89     }
90 }
91 
92 
93 // ----------------------------------------------------------------------------
94 // Devery Registry
95 // ----------------------------------------------------------------------------
96 contract DeveryRegistry is Admined {
97 
98     struct App {
99         address appAccount;
100         string appName;
101         address feeAccount;
102         uint fee;
103         bool active;
104     }
105     struct Brand {
106         address brandAccount;
107         address appAccount;
108         string brandName;
109         bool active;
110     }
111     struct Product {
112         address productAccount;
113         address brandAccount;
114         string description;
115         string details;
116         uint year;
117         string origin;
118         bool active;
119     }
120 
121     ERC20Interface public token;
122     address public feeAccount;
123     uint public fee;
124     mapping(address => App) public apps;
125     mapping(address => Brand) public brands;
126     mapping(address => Product) public products;
127     mapping(address => mapping(address => bool)) permissions;
128     mapping(bytes32 => address) markings;
129     address[] public appAccounts;
130     address[] public brandAccounts;
131     address[] public productAccounts;
132 
133     event TokenUpdated(address indexed oldToken, address indexed newToken);
134     event FeeUpdated(address indexed oldFeeAccount, address indexed newFeeAccount, uint oldFee, uint newFee);
135     event AppAdded(address indexed appAccount, string appName, address feeAccount, uint fee, bool active);
136     event AppUpdated(address indexed appAccount, string appName, address feeAccount, uint fee, bool active);
137     event BrandAdded(address indexed brandAccount, address indexed appAccount, string brandName, bool active);
138     event BrandUpdated(address indexed brandAccount, address indexed appAccount, string brandName, bool active);
139     event ProductAdded(address indexed productAccount, address indexed brandAccount, address indexed appAccount, string description, bool active);
140     event ProductUpdated(address indexed productAccount, address indexed brandAccount, address indexed appAccount, string description, bool active);
141     event Permissioned(address indexed marker, address indexed brandAccount, bool permission);
142     event Marked(address indexed marker, address indexed productAccount, address appFeeAccount, address feeAccount, uint appFee, uint fee, bytes32 itemHash);
143 
144 
145     // ------------------------------------------------------------------------
146     // Token, fee account and fee
147     // ------------------------------------------------------------------------
148     function setToken(address _token) public onlyAdmin {
149         TokenUpdated(address(token), _token);
150         token = ERC20Interface(_token);
151     }
152     function setFee(address _feeAccount, uint _fee) public onlyAdmin {
153         FeeUpdated(feeAccount, _feeAccount, fee, _fee);
154         feeAccount = _feeAccount;
155         fee = _fee;
156     }
157 
158     // ------------------------------------------------------------------------
159     // Account can add itself as an App account
160     // ------------------------------------------------------------------------
161     function addApp(string appName, address _feeAccount, uint _fee) public {
162         App storage e = apps[msg.sender];
163         require(e.appAccount == address(0));
164         apps[msg.sender] = App({
165             appAccount: msg.sender,
166             appName: appName,
167             feeAccount: _feeAccount,
168             fee: _fee,
169             active: true
170         });
171         appAccounts.push(msg.sender);
172         AppAdded(msg.sender, appName, _feeAccount, _fee, true);
173     }
174     function updateApp(string appName, address _feeAccount, uint _fee, bool active) public {
175         App storage e = apps[msg.sender];
176         require(msg.sender == e.appAccount);
177         e.appName = appName;
178         e.feeAccount = _feeAccount;
179         e.fee = _fee;
180         e.active = active;
181         AppUpdated(msg.sender, appName, _feeAccount, _fee, active);
182     }
183     function getApp(address appAccount) public constant returns (App app) {
184         app = apps[appAccount];
185     }
186     function getAppData(address appAccount) public constant returns (address _feeAccount, uint _fee, bool active) {
187         App storage e = apps[appAccount];
188         _feeAccount = e.feeAccount;
189         _fee = e.fee;
190         active = e.active;
191     }
192     function appAccountsLength() public constant returns (uint) {
193         return appAccounts.length;
194     }
195 
196     // ------------------------------------------------------------------------
197     // App account can add Brand account
198     // ------------------------------------------------------------------------
199     function addBrand(address brandAccount, string brandName) public {
200         App storage app = apps[msg.sender];
201         require(app.appAccount != address(0));
202         Brand storage brand = brands[brandAccount];
203         require(brand.brandAccount == address(0));
204         brands[brandAccount] = Brand({
205             brandAccount: brandAccount,
206             appAccount: msg.sender,
207             brandName: brandName,
208             active: true
209         });
210         brandAccounts.push(brandAccount);
211         BrandAdded(brandAccount, msg.sender, brandName, true);
212     }
213     function updateBrand(address brandAccount, string brandName, bool active) public {
214         Brand storage brand = brands[brandAccount];
215         require(brand.appAccount == msg.sender);
216         brand.brandName = brandName;
217         brand.active = active;
218 
219         BrandUpdated(brandAccount, msg.sender, brandName, active);
220     }
221     function getBrand(address brandAccount) public constant returns (Brand brand) {
222         brand = brands[brandAccount];
223     }
224     function getBrandData(address brandAccount) public constant returns (address appAccount, address appFeeAccount, bool active) {
225         Brand storage brand = brands[brandAccount];
226         require(brand.appAccount != address(0));
227         App storage app = apps[brand.appAccount];
228         require(app.appAccount != address(0));
229         appAccount = app.appAccount;
230         appFeeAccount = app.feeAccount;
231         active = app.active && brand.active;
232     }
233     function brandAccountsLength() public constant returns (uint) {
234         return brandAccounts.length;
235     }
236 
237     // ------------------------------------------------------------------------
238     // Brand account can add Product account
239     // ------------------------------------------------------------------------
240     function addProduct(address productAccount, string description, string details, uint year, string origin) public {
241         Brand storage brand = brands[msg.sender];
242         require(brand.brandAccount != address(0));
243         App storage app = apps[brand.appAccount];
244         require(app.appAccount != address(0));
245         Product storage product = products[productAccount];
246         require(product.productAccount == address(0));
247         products[productAccount] = Product({
248             productAccount: productAccount,
249             brandAccount: msg.sender,
250             description: description,
251             details: details,
252             year: year,
253             origin: origin,
254             active: true
255         });
256         productAccounts.push(productAccount);
257         ProductAdded(productAccount, msg.sender, app.appAccount, description, true);
258     }
259     function updateProduct(address productAccount, string description, string details, uint year, string origin, bool active) public {
260         Product storage product = products[productAccount];
261         require(product.brandAccount == msg.sender);
262         Brand storage brand = brands[msg.sender];
263         require(brand.brandAccount == msg.sender);
264         App storage app = apps[brand.appAccount];
265         product.description = description;
266         product.details = details;
267         product.year = year;
268         product.origin = origin;
269         product.active = active;
270         ProductUpdated(productAccount, product.brandAccount, app.appAccount, description, active);
271     }
272     function getProduct(address productAccount) public constant returns (Product product) {
273         product = products[productAccount];
274     }
275     function getProductData(address productAccount) public constant returns (address brandAccount, address appAccount, address appFeeAccount, bool active) {
276         Product storage product = products[productAccount];
277         require(product.brandAccount != address(0));
278         Brand storage brand = brands[brandAccount];
279         require(brand.appAccount != address(0));
280         App storage app = apps[brand.appAccount];
281         require(app.appAccount != address(0));
282         brandAccount = product.brandAccount;
283         appAccount = app.appAccount;
284         appFeeAccount = app.feeAccount;
285         active = app.active && brand.active && brand.active;
286     }
287     function productAccountsLength() public constant returns (uint) {
288         return productAccounts.length;
289     }
290 
291     // ------------------------------------------------------------------------
292     // Brand account can permission accounts as markers
293     // ------------------------------------------------------------------------
294     function permissionMarker(address marker, bool permission) public {
295         Brand storage brand = brands[msg.sender];
296         require(brand.brandAccount != address(0));
297         permissions[marker][msg.sender] = permission;
298         Permissioned(marker, msg.sender, permission);
299     }
300 
301     // ------------------------------------------------------------------------
302     // Compute item hash from the public key
303     // ------------------------------------------------------------------------
304     function addressHash(address item) public pure returns (bytes32 hash) {
305         hash = keccak256(item);
306     }
307 
308     // ------------------------------------------------------------------------
309     // Markers can add [productAccount, sha3(itemPublicKey)]
310     // ------------------------------------------------------------------------
311     function mark(address productAccount, bytes32 itemHash) public {
312         Product storage product = products[productAccount];
313         require(product.brandAccount != address(0) && product.active);
314         Brand storage brand = brands[product.brandAccount];
315         require(brand.brandAccount != address(0) && brand.active);
316         App storage app = apps[brand.appAccount];
317         require(app.appAccount != address(0) && app.active);
318         bool permissioned = permissions[msg.sender][brand.brandAccount];
319         require(permissioned);
320         markings[itemHash] = productAccount;
321         Marked(msg.sender, productAccount, app.feeAccount, feeAccount, app.fee, fee, itemHash);
322         if (app.fee > 0) {
323             token.transferFrom(brand.brandAccount, app.feeAccount, app.fee);
324         }
325         if (fee > 0) {
326             token.transferFrom(brand.brandAccount, feeAccount, fee);
327         }
328     }
329 
330     // ------------------------------------------------------------------------
331     // Check itemPublicKey has been registered
332     // ------------------------------------------------------------------------
333     function check(address item) public constant returns (address productAccount, address brandAccount, address appAccount) {
334         bytes32 hash = keccak256(item);
335         productAccount = markings[hash];
336         // require(productAccount != address(0));
337         Product storage product = products[productAccount];
338         // require(product.brandAccount != address(0));
339         Brand storage brand = brands[product.brandAccount];
340         // require(brand.brandAccount != address(0));
341         brandAccount = product.brandAccount;
342         appAccount = brand.appAccount;
343     }
344 }
345 
346 /**
347  * @title SafeMath
348  * @dev Math operations with safety checks that revert on error
349  */
350 library SafeMath {
351     /**
352     * @dev Multiplies two numbers, reverts on overflow.
353     */
354     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
355         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
356         // benefit is lost if 'b' is also tested.
357         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
358         if (a == 0) {
359             return 0;
360         }
361 
362         uint256 c = a * b;
363         require(c / a == b);
364 
365         return c;
366     }
367 
368     /**
369     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
370     */
371     function div(uint256 a, uint256 b) internal pure returns (uint256) {
372         // Solidity only automatically asserts when dividing by 0
373         require(b > 0);
374         uint256 c = a / b;
375         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
376 
377         return c;
378     }
379 
380     /**
381     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
382     */
383     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
384         require(b <= a);
385         uint256 c = a - b;
386 
387         return c;
388     }
389 
390     /**
391     * @dev Adds two numbers, reverts on overflow.
392     */
393     function add(uint256 a, uint256 b) internal pure returns (uint256) {
394         uint256 c = a + b;
395         require(c >= a);
396 
397         return c;
398     }
399 
400     /**
401     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
402     * reverts when dividing by zero.
403     */
404     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
405         require(b != 0);
406         return a % b;
407     }
408 }
409 
410 
411 
412 
413 
414 
415 /**
416  * @title ERC165
417  * @author Matt Condon (@shrugs)
418  * @dev Implements ERC165 using a lookup table.
419  */
420 contract ERC165 {
421     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
422     /**
423      * 0x01ffc9a7 ===
424      *     bytes4(keccak256('supportsInterface(bytes4)'))
425      */
426 
427     /**
428      * @dev a mapping of interface id to whether or not it's supported
429      */
430     mapping(bytes4 => bool) private _supportedInterfaces;
431 
432     /**
433      * @dev A contract implementing SupportsInterfaceWithLookup
434      * implement ERC165 itself
435      */
436     constructor () internal {
437         _registerInterface(_InterfaceId_ERC165);
438     }
439 
440     /**
441      * @dev implement supportsInterface(bytes4) using a lookup table
442      */
443     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
444         return _supportedInterfaces[interfaceId];
445     }
446 
447     /**
448      * @dev internal method for registering an interface
449      */
450     function _registerInterface(bytes4 interfaceId) internal {
451         require(interfaceId != 0xffffffff);
452         _supportedInterfaces[interfaceId] = true;
453     }
454 }
455 
456 /**
457  * @title ERC721 token receiver interface
458  * @dev Interface for any contract that wants to support safeTransfers
459  * from ERC721 asset contracts.
460  */
461 contract IERC721Receiver {
462     /**
463      * @notice Handle the receipt of an NFT
464      * @dev The ERC721 smart contract calls this function on the recipient
465      * after a `safeTransfer`. This function MUST return the function selector,
466      * otherwise the caller will revert the transaction. The selector to be
467      * returned can be obtained as `this.onERC721Received.selector`. This
468      * function MAY throw to revert and reject the transfer.
469      * Note: the ERC721 contract address is always the message sender.
470      * @param operator The address which called `safeTransferFrom` function
471      * @param from The address which previously owned the token
472      * @param tokenId The NFT identifier which is being transferred
473      * @param data Additional data with no specified format
474      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
475      */
476     function onERC721Received(address operator, address from, uint256 tokenId, bytes data) public returns (bytes4);
477 }
478 
479 
480 /**
481  * Utility library of inline functions on addresses
482  */
483 library Address {
484     /**
485      * Returns whether the target address is a contract
486      * @dev This function will return false if invoked during the constructor of a contract,
487      * as the code is not actually created until after the constructor finishes.
488      * @param account address of the account to check
489      * @return whether the target address is a contract
490      */
491     function isContract(address account) internal view returns (bool) {
492         uint256 size;
493         // XXX Currently there is no better way to check if there is a contract in an address
494         // than to check the size of the code at that address.
495         // See https://ethereum.stackexchange.com/a/14016/36603
496         // for more details about how this works.
497         // TODO Check this again before the Serenity release, because all addresses will be
498         // contracts then.
499         // solium-disable-next-line security/no-inline-assembly
500         assembly { size := extcodesize(account) }
501         return size > 0;
502     }
503 }
504 
505 
506 /**
507  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
508  * @dev See https://eips.ethereum.org/EIPS/eip-721
509  */
510 contract IERC721Enumerable {
511     function totalSupply() public view returns (uint256);
512     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
513 
514     function tokenByIndex(uint256 index) public view returns (uint256);
515 }
516 
517 
518 /**
519  * @title Counters
520  * @author Matt Condon (@shrugs)
521  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
522  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
523  *
524  * Include with `using Counters for Counters.Counter;`
525  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
526  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
527  * directly accessed.
528  */
529 library Counters {
530     using SafeMath for uint256;
531 
532     struct Counter {
533         // This variable should never be directly accessed by users of the library: interactions must be restricted to
534         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
535         // this feature: see https://github.com/ethereum/solidity/issues/4637
536         uint256 _value; // default: 0
537     }
538 
539     function current(Counter storage counter) internal view returns (uint256) {
540         return counter._value;
541     }
542 
543     function increment(Counter storage counter) internal {
544         counter._value += 1;
545     }
546 
547     function decrement(Counter storage counter) internal {
548         counter._value = counter._value.sub(1);
549     }
550 }
551 
552 /**
553  * @title ERC721 Non-Fungible Token Standard basic implementation
554  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
555  */
556 contract ERC721 is ERC165 {
557 
558     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
559     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
560     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
561 
562     using SafeMath for uint256;
563     using Address for address;
564     using Counters for Counters.Counter;
565 
566     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
567     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
568     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
569 
570     // Mapping from token ID to owner
571     mapping (uint256 => address) private _tokenOwner;
572 
573     // Mapping from token ID to approved address
574     mapping (uint256 => address) private _tokenApprovals;
575 
576     // Mapping from owner to number of owned token
577     mapping (address => Counters.Counter) private _ownedTokensCount;
578 
579     // Mapping from owner to operator approvals
580     mapping (address => mapping (address => bool)) private _operatorApprovals;
581 
582     /*
583      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
584      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
585      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
586      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
587      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
588      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
589      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
590      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
591      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
592      *
593      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
594      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
595      */
596     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
597 
598     constructor () public {
599         // register the supported interfaces to conform to ERC721 via ERC165
600         _registerInterface(_INTERFACE_ID_ERC721);
601     }
602 
603     /**
604      * @dev Gets the balance of the specified address.
605      * @param owner address to query the balance of
606      * @return uint256 representing the amount owned by the passed address
607      */
608     function balanceOf(address owner) public view returns (uint256) {
609         require(owner != address(0), "ERC721: balance query for the zero address");
610 
611         return _ownedTokensCount[owner].current();
612     }
613 
614     /**
615      * @dev Gets the owner of the specified token ID.
616      * @param tokenId uint256 ID of the token to query the owner of
617      * @return address currently marked as the owner of the given token ID
618      */
619     function ownerOf(uint256 tokenId) public view returns (address) {
620         address owner = _tokenOwner[tokenId];
621         require(owner != address(0), "ERC721: owner query for nonexistent token");
622 
623         return owner;
624     }
625 
626     /**
627      * @dev Approves another address to transfer the given token ID
628      * The zero address indicates there is no approved address.
629      * There can only be one approved address per token at a given time.
630      * Can only be called by the token owner or an approved operator.
631      * @param to address to be approved for the given token ID
632      * @param tokenId uint256 ID of the token to be approved
633      */
634     function approve(address to, uint256 tokenId) public {
635         address owner = ownerOf(tokenId);
636         require(to != owner, "ERC721: approval to current owner");
637 
638         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
639             "ERC721: approve caller is not owner nor approved for all"
640         );
641 
642         _tokenApprovals[tokenId] = to;
643         emit Approval(owner, to, tokenId);
644     }
645 
646     /**
647      * @dev Gets the approved address for a token ID, or zero if no address set
648      * Reverts if the token ID does not exist.
649      * @param tokenId uint256 ID of the token to query the approval of
650      * @return address currently approved for the given token ID
651      */
652     function getApproved(uint256 tokenId) public view returns (address) {
653         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
654 
655         return _tokenApprovals[tokenId];
656     }
657 
658     /**
659      * @dev Sets or unsets the approval of a given operator
660      * An operator is allowed to transfer all tokens of the sender on their behalf.
661      * @param to operator address to set the approval
662      * @param approved representing the status of the approval to be set
663      */
664     function setApprovalForAll(address to, bool approved) public {
665         require(to != msg.sender, "ERC721: approve to caller");
666 
667         _operatorApprovals[msg.sender][to] = approved;
668         emit ApprovalForAll(msg.sender, to, approved);
669     }
670 
671     /**
672      * @dev Tells whether an operator is approved by a given owner.
673      * @param owner owner address which you want to query the approval of
674      * @param operator operator address which you want to query the approval of
675      * @return bool whether the given operator is approved by the given owner
676      */
677     function isApprovedForAll(address owner, address operator) public view returns (bool) {
678         return _operatorApprovals[owner][operator];
679     }
680 
681     /**
682      * @dev Transfers the ownership of a given token ID to another address.
683      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
684      * Requires the msg.sender to be the owner, approved, or operator.
685      * @param from current owner of the token
686      * @param to address to receive the ownership of the given token ID
687      * @param tokenId uint256 ID of the token to be transferred
688      */
689     function transferFrom(address from, address to, uint256 tokenId) public {
690         //solhint-disable-next-line max-line-length
691         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
692 
693         _transferFrom(from, to, tokenId);
694     }
695 
696     /**
697      * @dev Safely transfers the ownership of a given token ID to another address
698      * If the target address is a contract, it must implement `onERC721Received`,
699      * which is called upon a safe transfer, and return the magic value
700      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
701      * the transfer is reverted.
702      * Requires the msg.sender to be the owner, approved, or operator
703      * @param from current owner of the token
704      * @param to address to receive the ownership of the given token ID
705      * @param tokenId uint256 ID of the token to be transferred
706      */
707     function safeTransferFrom(address from, address to, uint256 tokenId) public {
708         safeTransferFrom(from, to, tokenId, "");
709     }
710 
711     /**
712      * @dev Safely transfers the ownership of a given token ID to another address
713      * If the target address is a contract, it must implement `onERC721Received`,
714      * which is called upon a safe transfer, and return the magic value
715      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
716      * the transfer is reverted.
717      * Requires the msg.sender to be the owner, approved, or operator
718      * @param from current owner of the token
719      * @param to address to receive the ownership of the given token ID
720      * @param tokenId uint256 ID of the token to be transferred
721      * @param _data bytes data to send along with a safe transfer check
722      */
723     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
724         transferFrom(from, to, tokenId);
725         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
726     }
727 
728     /**
729      * @dev Returns whether the specified token exists.
730      * @param tokenId uint256 ID of the token to query the existence of
731      * @return bool whether the token exists
732      */
733     function _exists(uint256 tokenId) internal view returns (bool) {
734         address owner = _tokenOwner[tokenId];
735         return owner != address(0);
736     }
737 
738     /**
739      * @dev Returns whether the given spender can transfer a given token ID.
740      * @param spender address of the spender to query
741      * @param tokenId uint256 ID of the token to be transferred
742      * @return bool whether the msg.sender is approved for the given token ID,
743      * is an operator of the owner, or is the owner of the token
744      */
745     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
746         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
747         address owner = ownerOf(tokenId);
748         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
749     }
750 
751     /**
752      * @dev Internal function to mint a new token.
753      * Reverts if the given token ID already exists.
754      * @param to The address that will own the minted token
755      * @param tokenId uint256 ID of the token to be minted
756      */
757     function _mint(address to, uint256 tokenId) internal {
758         require(to != address(0), "ERC721: mint to the zero address");
759         require(!_exists(tokenId), "ERC721: token already minted");
760 
761         _tokenOwner[tokenId] = to;
762         _ownedTokensCount[to].increment();
763 
764         emit Transfer(address(0), to, tokenId);
765     }
766 
767     /**
768      * @dev Internal function to burn a specific token.
769      * Reverts if the token does not exist.
770      * Deprecated, use _burn(uint256) instead.
771      * @param owner owner of the token to burn
772      * @param tokenId uint256 ID of the token being burned
773      */
774     function _burn(address owner, uint256 tokenId) internal {
775         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
776 
777         _clearApproval(tokenId);
778 
779         _ownedTokensCount[owner].decrement();
780         _tokenOwner[tokenId] = address(0);
781 
782         emit Transfer(owner, address(0), tokenId);
783     }
784 
785     /**
786      * @dev Internal function to burn a specific token.
787      * Reverts if the token does not exist.
788      * @param tokenId uint256 ID of the token being burned
789      */
790     function _burn(uint256 tokenId) internal {
791         _burn(ownerOf(tokenId), tokenId);
792     }
793 
794     /**
795      * @dev Internal function to transfer ownership of a given token ID to another address.
796      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
797      * @param from current owner of the token
798      * @param to address to receive the ownership of the given token ID
799      * @param tokenId uint256 ID of the token to be transferred
800      */
801     function _transferFrom(address from, address to, uint256 tokenId) internal {
802         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
803         require(to != address(0), "ERC721: transfer to the zero address");
804 
805         _clearApproval(tokenId);
806 
807         _ownedTokensCount[from].decrement();
808         _ownedTokensCount[to].increment();
809 
810         _tokenOwner[tokenId] = to;
811 
812         emit Transfer(from, to, tokenId);
813     }
814 
815     /**
816      * @dev Internal function to invoke `onERC721Received` on a target address.
817      * The call is not executed if the target address is not a contract.
818      * @param from address representing the previous owner of the given token ID
819      * @param to target address that will receive the tokens
820      * @param tokenId uint256 ID of the token to be transferred
821      * @param _data bytes optional data to send along with the call
822      * @return bool whether the call correctly returned the expected magic value
823      */
824     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
825     internal returns (bool)
826     {
827         if (!to.isContract()) {
828             return true;
829         }
830 
831         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
832         return (retval == _ERC721_RECEIVED);
833     }
834 
835     /**
836      * @dev Private function to clear current approval of a given token ID.
837      * @param tokenId uint256 ID of the token to be transferred
838      */
839     function _clearApproval(uint256 tokenId) private {
840         if (_tokenApprovals[tokenId] != address(0)) {
841             _tokenApprovals[tokenId] = address(0);
842         }
843     }
844 }
845 
846 
847 
848 
849 
850 /**
851  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
852  * @dev See https://eips.ethereum.org/EIPS/eip-721
853  */
854 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
855     // Mapping from owner to list of owned token IDs
856     mapping(address => uint256[]) private _ownedTokens;
857 
858     // Mapping from token ID to index of the owner tokens list
859     mapping(uint256 => uint256) private _ownedTokensIndex;
860 
861     // Array with all token ids, used for enumeration
862     uint256[] private _allTokens;
863 
864     // Mapping from token id to position in the allTokens array
865     mapping(uint256 => uint256) private _allTokensIndex;
866 
867     /*
868      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
869      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
870      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
871      *
872      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
873      */
874     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
875 
876     /**
877      * @dev Constructor function.
878      */
879     constructor () public {
880         // register the supported interface to conform to ERC721Enumerable via ERC165
881         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
882     }
883 
884     /**
885      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
886      * @param owner address owning the tokens list to be accessed
887      * @param index uint256 representing the index to be accessed of the requested tokens list
888      * @return uint256 token ID at the given index of the tokens list owned by the requested address
889      */
890     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
891         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
892         return _ownedTokens[owner][index];
893     }
894 
895     /**
896      * @dev Gets the total amount of tokens stored by the contract.
897      * @return uint256 representing the total amount of tokens
898      */
899     function totalSupply() public view returns (uint256) {
900         return _allTokens.length;
901     }
902 
903     /**
904      * @dev Gets the token ID at a given index of all the tokens in this contract
905      * Reverts if the index is greater or equal to the total number of tokens.
906      * @param index uint256 representing the index to be accessed of the tokens list
907      * @return uint256 token ID at the given index of the tokens list
908      */
909     function tokenByIndex(uint256 index) public view returns (uint256) {
910         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
911         return _allTokens[index];
912     }
913 
914     /**
915      * @dev Internal function to transfer ownership of a given token ID to another address.
916      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
917      * @param from current owner of the token
918      * @param to address to receive the ownership of the given token ID
919      * @param tokenId uint256 ID of the token to be transferred
920      */
921     function _transferFrom(address from, address to, uint256 tokenId) internal {
922         super._transferFrom(from, to, tokenId);
923 
924         _removeTokenFromOwnerEnumeration(from, tokenId);
925 
926         _addTokenToOwnerEnumeration(to, tokenId);
927     }
928 
929     /**
930      * @dev Internal function to mint a new token.
931      * Reverts if the given token ID already exists.
932      * @param to address the beneficiary that will own the minted token
933      * @param tokenId uint256 ID of the token to be minted
934      */
935     function _mint(address to, uint256 tokenId) internal {
936         super._mint(to, tokenId);
937 
938         _addTokenToOwnerEnumeration(to, tokenId);
939 
940         _addTokenToAllTokensEnumeration(tokenId);
941     }
942 
943     /**
944      * @dev Internal function to burn a specific token.
945      * Reverts if the token does not exist.
946      * Deprecated, use _burn(uint256) instead.
947      * @param owner owner of the token to burn
948      * @param tokenId uint256 ID of the token being burned
949      */
950     function _burn(address owner, uint256 tokenId) internal {
951         super._burn(owner, tokenId);
952 
953         _removeTokenFromOwnerEnumeration(owner, tokenId);
954         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
955         _ownedTokensIndex[tokenId] = 0;
956 
957         _removeTokenFromAllTokensEnumeration(tokenId);
958     }
959 
960     /**
961      * @dev Gets the list of token IDs of the requested owner.
962      * @param owner address owning the tokens
963      * @return uint256[] List of token IDs owned by the requested address
964      */
965     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
966         return _ownedTokens[owner];
967     }
968 
969     /**
970      * @dev Private function to add a token to this extension's ownership-tracking data structures.
971      * @param to address representing the new owner of the given token ID
972      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
973      */
974     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
975         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
976         _ownedTokens[to].push(tokenId);
977     }
978 
979     /**
980      * @dev Private function to add a token to this extension's token tracking data structures.
981      * @param tokenId uint256 ID of the token to be added to the tokens list
982      */
983     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
984         _allTokensIndex[tokenId] = _allTokens.length;
985         _allTokens.push(tokenId);
986     }
987 
988     /**
989      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
990      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
991      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
992      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
993      * @param from address representing the previous owner of the given token ID
994      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
995      */
996     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
997         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
998         // then delete the last slot (swap and pop).
999 
1000         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1001         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1002 
1003         // When the token to delete is the last token, the swap operation is unnecessary
1004         if (tokenIndex != lastTokenIndex) {
1005             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1006 
1007             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1008             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1009         }
1010 
1011         // This also deletes the contents at the last position of the array
1012         _ownedTokens[from].length--;
1013 
1014         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1015         // lastTokenId, or just over the end of the array if the token was the last one).
1016     }
1017 
1018     /**
1019      * @dev Private function to remove a token from this extension's token tracking data structures.
1020      * This has O(1) time complexity, but alters the order of the _allTokens array.
1021      * @param tokenId uint256 ID of the token to be removed from the tokens list
1022      */
1023     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1024         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1025         // then delete the last slot (swap and pop).
1026 
1027         uint256 lastTokenIndex = _allTokens.length.sub(1);
1028         uint256 tokenIndex = _allTokensIndex[tokenId];
1029 
1030         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1031         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1032         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1033         uint256 lastTokenId = _allTokens[lastTokenIndex];
1034 
1035         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1036         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1037 
1038         // This also deletes the contents at the last position of the array
1039         _allTokens.length--;
1040         _allTokensIndex[tokenId] = 0;
1041     }
1042 }
1043 
1044 
1045 /**
1046  * @dev Manages Devery specific ERC721 functionality. We are going to control the ownership of products through the
1047  * ERC721 specification, so every product ownership can be represented as a non fungible token. Brands
1048  * might choose to create, mark and mint a ERC721 for every physical unit of a product or create and mark a single
1049  * product and then mint multiple units of it. This flexibility will make the process of marking low ticket items
1050  * expenentially cheaper without compromise the security that you get by creating and marking every single product in case
1051  * of higher ticket items
1052  *
1053  * @title DeveryERC721Token
1054  * @author victor eloy
1055  */
1056 contract DeveryERC721Token is ERC721Enumerable,Admined {
1057 
1058 
1059     address[] public tokenIdToProduct;
1060     mapping(address => uint) public totalAllowedProducts;
1061     mapping(address => uint) public totalMintedProducts;
1062     DeveryRegistry deveryRegistry;
1063     ERC20Interface public token;
1064     
1065     event TokenUpdated(address indexed oldToken, address indexed newToken);
1066 
1067 
1068     function setToken(address _token) public onlyAdmin {
1069         TokenUpdated(address(token), _token);
1070         token = ERC20Interface(_token);
1071     }
1072 
1073     /**
1074       * @dev modifier to enforce that only the brand that created a given product can change it
1075       * this modifier will check the core devery registry to fetch the brand address.
1076       */
1077     modifier brandOwnerOnly(address _productAddress){
1078         address productBrandAddress;
1079         (,productBrandAddress,,,,,) = deveryRegistry.products(_productAddress);
1080         require(productBrandAddress == msg.sender);
1081         _;
1082     }
1083 
1084     /**
1085       * @dev Allow contract admins to set the address of Core Devery Registry contract
1086       */
1087     function setDeveryRegistryAddress(address _deveryRegistryAddress) external onlyAdmin {
1088         deveryRegistry = DeveryRegistry(_deveryRegistryAddress);
1089     }
1090 
1091     /**
1092       * @dev adjusts the maximum mintable amount of a certain product
1093       */
1094     function setMaximumMintableQuantity(address _productAddress, uint _quantity) external payable brandOwnerOnly(_productAddress){
1095         require(_quantity >= totalMintedProducts[_productAddress] || _quantity == 0);
1096         totalAllowedProducts[_productAddress] = _quantity;
1097     }
1098 
1099     /**
1100       * @dev mint a new ERC721 token for a given product and assing it to the original product brand;
1101       */
1102     function claimProduct(address _productAddress,uint _quantity) external payable  brandOwnerOnly(_productAddress) {
1103         require(totalAllowedProducts[_productAddress] == 0 || totalAllowedProducts[_productAddress] >= totalMintedProducts[_productAddress] + _quantity);
1104         //********************************************************************charges the fee****************************************
1105         address productBrandAddress;
1106         address appAccountAddress;
1107         address appFeeAccount;
1108         address deveryFeeAccount;
1109         uint appFee;
1110         uint deveryFee;
1111         (,productBrandAddress,,,,,) = deveryRegistry.products(_productAddress);
1112         (,appAccountAddress,,) = deveryRegistry.brands(productBrandAddress);
1113         (,,appFeeAccount,appFee,) = deveryRegistry.apps(appAccountAddress);
1114         deveryFee = deveryRegistry.fee();
1115         deveryFeeAccount = deveryRegistry.feeAccount();
1116         if (appFee > 0) {
1117             token.transferFrom(productBrandAddress, appFeeAccount, appFee*_quantity);
1118         }
1119         if (deveryFee > 0) {
1120             token.transferFrom(productBrandAddress, deveryFeeAccount, deveryFee*_quantity);
1121         }
1122         //********************************************************************charges the fee****************************************
1123         for(uint i = 0;i<_quantity;i++){
1124             uint nextId = tokenIdToProduct.push(_productAddress) - 1;
1125             _mint(msg.sender,nextId);
1126         }
1127         
1128         totalMintedProducts[_productAddress]+=_quantity;
1129     }
1130 
1131     /**
1132       * @dev returns the products owned by a given ethereum address
1133       */
1134     function getProductsByOwner(address _owner) external view returns (address[]){
1135         address[] memory products = new address[](balanceOf(_owner));
1136         uint counter = 0;
1137         for(uint i = 0; i < tokenIdToProduct.length;i++){
1138             if(ownerOf(i) == _owner){
1139                 products[counter] = tokenIdToProduct[i];
1140                 counter++;
1141             }
1142         }
1143         return products;
1144     }
1145 }