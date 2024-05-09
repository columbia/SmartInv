1 pragma solidity ^0.4.22;
2 
3 
4 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
5 
6 contract BitGuildToken {
7     // Public variables of the token
8     string public name = "BitGuild PLAT";
9     string public symbol = "PLAT";
10     uint8 public decimals = 18;
11     uint256 public totalSupply = 10000000000 * 10 ** uint256(decimals); // 10 billion tokens;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constructor function
25      * Initializes contract with initial supply tokens to the creator of the contract
26      */
27     function BitGuildToken() public {
28         balanceOf[msg.sender] = totalSupply;
29     }
30 
31     /**
32      * Internal transfer, only can be called by this contract
33      */
34     function _transfer(address _from, address _to, uint _value) internal {
35         // Prevent transfer to 0x0 address. Use burn() instead
36         require(_to != 0x0);
37         // Check if the sender has enough
38         require(balanceOf[_from] >= _value);
39         // Check for overflows
40         require(balanceOf[_to] + _value > balanceOf[_to]);
41         // Save this for an assertion in the future
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43         // Subtract from the sender
44         balanceOf[_from] -= _value;
45         // Add the same to the recipient
46         balanceOf[_to] += _value;
47         Transfer(_from, _to, _value);
48         // Asserts are used to use static analysis to find bugs in your code. They should never fail
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
50     }
51 
52     /**
53      * Transfer tokens
54      *
55      * Send `_value` tokens to `_to` from your account
56      *
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     /**
65      * Transfer tokens from other address
66      *
67      * Send `_value` tokens to `_to` on behalf of `_from`
68      *
69      * @param _from The address of the sender
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         require(_value <= allowance[_from][msg.sender]);     // Check allowance
75         allowance[_from][msg.sender] -= _value;
76         _transfer(_from, _to, _value);
77         return true;
78     }
79 
80     /**
81      * Set allowance for other address
82      *
83      * Allows `_spender` to spend no more than `_value` tokens on your behalf
84      *
85      * @param _spender The address authorized to spend
86      * @param _value the max amount they can spend
87      */
88     function approve(address _spender, uint256 _value) public
89         returns (bool success) {
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address and notify
96      *
97      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      * @param _extraData some extra information to send to the approved contract
102      */
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
104         public
105         returns (bool success) {
106         tokenRecipient spender = tokenRecipient(_spender);
107         if (approve(_spender, _value)) {
108             spender.receiveApproval(msg.sender, _value, this, _extraData);
109             return true;
110         }
111     }
112 
113     /**
114      * Destroy tokens
115      *
116      * Remove `_value` tokens from the system irreversibly
117      *
118      * @param _value the amount of money to burn
119      */
120     function burn(uint256 _value) public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
122         balanceOf[msg.sender] -= _value;            // Subtract from the sender
123         totalSupply -= _value;                      // Updates totalSupply
124         Burn(msg.sender, _value);
125         return true;
126     }
127 
128     /**
129      * Destroy tokens from other account
130      *
131      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
132      *
133      * @param _from the address of the sender
134      * @param _value the amount of money to burn
135      */
136     function burnFrom(address _from, uint256 _value) public returns (bool success) {
137         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
138         require(_value <= allowance[_from][msg.sender]);    // Check allowance
139         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
140         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
141         totalSupply -= _value;                              // Update totalSupply
142         Burn(_from, _value);
143         return true;
144     }
145 }
146 
147 
148 /**
149  * @title BitGuildAccessAdmin
150  * @dev Allow two roles: 'owner' or 'operator'
151  *      - owner: admin/superuser (e.g. with financial rights)
152  *      - operator: can update configurations
153  */
154 contract BitGuildAccessAdmin {
155     address public owner;
156     address[] public operators;
157 
158     uint public MAX_OPS = 20; // Default maximum number of operators allowed
159 
160     mapping(address => bool) public isOperator;
161 
162     event OwnershipTransferred(
163         address indexed previousOwner,
164         address indexed newOwner
165     );
166     event OperatorAdded(address operator);
167     event OperatorRemoved(address operator);
168 
169     // @dev The BitGuildAccessAdmin constructor: sets owner to the sender account
170     constructor() public {
171         owner = msg.sender;
172     }
173 
174     // @dev Throws if called by any account other than the owner.
175     modifier onlyOwner() {
176         require(msg.sender == owner);
177         _;
178     }
179 
180     // @dev Throws if called by any non-operator account. Owner has all ops rights.
181     modifier onlyOperator() {
182         require(
183             isOperator[msg.sender] || msg.sender == owner,
184             "Permission denied. Must be an operator or the owner."
185         );
186         _;
187     }
188 
189     /**
190      * @dev Allows the current owner to transfer control of the contract to a newOwner.
191      * @param _newOwner The address to transfer ownership to.
192      */
193     function transferOwnership(address _newOwner) public onlyOwner {
194         require(
195             _newOwner != address(0),
196             "Invalid new owner address."
197         );
198         emit OwnershipTransferred(owner, _newOwner);
199         owner = _newOwner;
200     }
201 
202     /**
203      * @dev Allows the current owner or operators to add operators
204      * @param _newOperator New operator address
205      */
206     function addOperator(address _newOperator) public onlyOwner {
207         require(
208             _newOperator != address(0),
209             "Invalid new operator address."
210         );
211 
212         // Make sure no dups
213         require(
214             !isOperator[_newOperator],
215             "New operator exists."
216         );
217 
218         // Only allow so many ops
219         require(
220             operators.length < MAX_OPS,
221             "Overflow."
222         );
223 
224         operators.push(_newOperator);
225         isOperator[_newOperator] = true;
226 
227         emit OperatorAdded(_newOperator);
228     }
229 
230     /**
231      * @dev Allows the current owner or operators to remove operator
232      * @param _operator Address of the operator to be removed
233      */
234     function removeOperator(address _operator) public onlyOwner {
235         // Make sure operators array is not empty
236         require(
237             operators.length > 0,
238             "No operator."
239         );
240 
241         // Make sure the operator exists
242         require(
243             isOperator[_operator],
244             "Not an operator."
245         );
246 
247         // Manual array manipulation:
248         // - replace the _operator with last operator in array
249         // - remove the last item from array
250         address lastOperator = operators[operators.length - 1];
251         for (uint i = 0; i < operators.length; i++) {
252             if (operators[i] == _operator) {
253                 operators[i] = lastOperator;
254             }
255         }
256         operators.length -= 1; // remove the last element
257 
258         isOperator[_operator] = false;
259         emit OperatorRemoved(_operator);
260     }
261 
262     // @dev Remove ALL operators
263     function removeAllOps() public onlyOwner {
264         for (uint i = 0; i < operators.length; i++) {
265             isOperator[operators[i]] = false;
266         }
267         operators.length = 0;
268     }
269 }
270 
271 
272 /**
273  * @title BitGuildWhitelist
274  * @dev A small smart contract to provide whitelist functionality and storage
275  */
276 contract BitGuildWhitelist is BitGuildAccessAdmin {
277     uint public total = 0;
278     mapping (address => bool) public isWhitelisted;
279 
280     event AddressWhitelisted(address indexed addr, address operator);
281     event AddressRemovedFromWhitelist(address indexed addr, address operator);
282 
283     // @dev Throws if _address is not in whitelist.
284     modifier onlyWhitelisted(address _address) {
285         require(
286             isWhitelisted[_address],
287             "Address is not on the whitelist."
288         );
289         _;
290     }
291 
292     // Doesn't accept eth
293     function () external payable {
294         revert();
295     }
296 
297     /**
298      * @dev Allow operators to add whitelisted contracts
299      * @param _newAddr New whitelisted contract address
300      */
301     function addToWhitelist(address _newAddr) public onlyOperator {
302         require(
303             _newAddr != address(0),
304             "Invalid new address."
305         );
306 
307         // Make sure no dups
308         require(
309             !isWhitelisted[_newAddr],
310             "Address is already whitelisted."
311         );
312 
313         isWhitelisted[_newAddr] = true;
314         total++;
315         emit AddressWhitelisted(_newAddr, msg.sender);
316     }
317 
318     /**
319      * @dev Allow operators to remove a contract from the whitelist
320      * @param _addr Contract address to be removed
321      */
322     function removeFromWhitelist(address _addr) public onlyOperator {
323         require(
324             _addr != address(0),
325             "Invalid address."
326         );
327 
328         // Make sure the address is in whitelist
329         require(
330             isWhitelisted[_addr],
331             "Address not in whitelist."
332         );
333 
334         isWhitelisted[_addr] = false;
335         if (total > 0) {
336             total--;
337         }
338         emit AddressRemovedFromWhitelist(_addr, msg.sender);
339     }
340 
341     /**
342      * @dev Allow operators to update whitelist contracts in bulk
343      * @param _addresses Array of addresses to be processed
344      * @param _whitelisted Boolean value -- to add or remove from whitelist
345      */
346     function whitelistAddresses(address[] _addresses, bool _whitelisted) public onlyOperator {
347         for (uint i = 0; i < _addresses.length; i++) {
348             address addr = _addresses[i];
349             if (isWhitelisted[addr] == _whitelisted) continue;
350             if (_whitelisted) {
351                 addToWhitelist(addr);
352             } else {
353                 removeFromWhitelist(addr);
354             }
355         }
356     }
357 }
358 
359 /**
360  * @title BitGuildFeeProvider
361  * @dev Fee definition, supports custom fees by seller or buyer or token combinations
362  */
363 contract BitGuildFeeProvider is BitGuildAccessAdmin {
364     // @dev Since default uint value is zero, need to distinguish Default vs No Fee
365     uint constant NO_FEE = 10000;
366 
367     // @dev default % fee. Fixed is not supported. use percent * 100 to include 2 decimals
368     uint defaultPercentFee = 500; // default fee: 5%
369 
370     mapping(bytes32 => uint) public customFee;  // Allow buyer or seller or game discounts
371 
372     event LogFeeChanged(uint newPercentFee, uint oldPercentFee, address operator);
373     event LogCustomFeeChanged(uint newPercentFee, uint oldPercentFee, address buyer, address seller, address token, address operator);
374 
375     // Default
376     function () external payable {
377         revert();
378     }
379 
380     /**
381      * @dev Allow operators to update the fee for a custom combo
382      * @param _newFee New fee in percent x 100 (to support decimals)
383      */
384     function updateFee(uint _newFee) public onlyOperator {
385         require(_newFee >= 0 && _newFee <= 10000, "Invalid percent fee.");
386 
387         uint oldPercentFee = defaultPercentFee;
388         defaultPercentFee = _newFee;
389 
390         emit LogFeeChanged(_newFee, oldPercentFee, msg.sender);
391     }
392 
393     /**
394      * @dev Allow operators to update the fee for a custom combo
395      * @param _newFee New fee in percent x 100 (to support decimals)
396      *                enter zero for default, 10000 for No Fee
397      */
398     function updateCustomFee(uint _newFee, address _currency, address _buyer, address _seller, address _token) public onlyOperator {
399         require(_newFee >= 0 && _newFee <= 10000, "Invalid percent fee.");
400 
401         bytes32 key = _getHash(_currency, _buyer, _seller, _token);
402         uint oldPercentFee = customFee[key];
403         customFee[key] = _newFee;
404 
405         emit LogCustomFeeChanged(_newFee, oldPercentFee, _buyer, _seller, _token, msg.sender);
406     }
407 
408     /**
409      * @dev Calculate the custom fee based on buyer, seller, game token or combo of these
410      */
411     function getFee(uint _price, address _currency, address _buyer, address _seller, address _token) public view returns(uint percent, uint fee) {
412         bytes32 key = _getHash(_currency, _buyer, _seller, _token);
413         uint customPercentFee = customFee[key];
414         (percent, fee) = _getFee(_price, customPercentFee);
415     }
416 
417     function _getFee(uint _price, uint _percentFee) internal view returns(uint percent, uint fee) {
418         require(_price >= 0, "Invalid price.");
419 
420         percent = _percentFee;
421 
422         // No data, set it to default
423         if (_percentFee == 0) {
424             percent = defaultPercentFee;
425         }
426 
427         // Special value to set it to zero
428         if (_percentFee == NO_FEE) {
429             percent = 0;
430             fee = 0;
431         } else {
432             fee = _safeMul(_price, percent) / 10000; // adjust for percent and decimal. division always truncate
433         }
434     }
435 
436     // get custom fee hash
437     function _getHash(address _currency, address _buyer, address _seller, address _token) internal pure returns(bytes32 key) {
438         key = keccak256(abi.encodePacked(_currency, _buyer, _seller, _token));
439     }
440 
441     // safe multiplication
442     function _safeMul(uint a, uint b) internal pure returns (uint) {
443         if (a == 0) {
444             return 0;
445         }
446         uint c = a * b;
447         assert(c / a == b);
448         return c;
449     }
450 }
451 
452 pragma solidity ^0.4.24;
453 
454 interface ERC721 /* is ERC165 */ {
455     /// @dev This emits when ownership of any NFT changes by any mechanism.
456     ///  This event emits when NFTs are created (`from` == 0) and destroyed
457     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
458     ///  may be created and assigned without emitting Transfer. At the time of
459     ///  any transfer, the approved address for that NFT (if any) is reset to none.
460     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
461 
462     /// @dev This emits when the approved address for an NFT is changed or
463     ///  reaffirmed. The zero address indicates there is no approved address.
464     ///  When a Transfer event emits, this also indicates that the approved
465     ///  address for that NFT (if any) is reset to none.
466     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
467 
468     /// @dev This emits when an operator is enabled or disabled for an owner.
469     ///  The operator can manage all NFTs of the owner.
470     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
471 
472     /// @notice Count all NFTs assigned to an owner
473     /// @dev NFTs assigned to the zero address are considered invalid, and this
474     ///  function throws for queries about the zero address.
475     /// @param _owner An address for whom to query the balance
476     /// @return The number of NFTs owned by `_owner`, possibly zero
477     function balanceOf(address _owner) external view returns (uint256);
478 
479     /// @notice Find the owner of an NFT
480     /// @dev NFTs assigned to zero address are considered invalid, and queries
481     ///  about them do throw.
482     /// @param _tokenId The identifier for an NFT
483     /// @return The address of the owner of the NFT
484     function ownerOf(uint256 _tokenId) external view returns (address);
485 
486     /// @notice Transfers the ownership of an NFT from one address to another address
487     /// @dev Throws unless `msg.sender` is the current owner, an authorized
488     ///  operator, or the approved address for this NFT. Throws if `_from` is
489     ///  not the current owner. Throws if `_to` is the zero address. Throws if
490     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
491     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
492     ///  `onERC721Received` on `_to` and throws if the return value is not
493     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
494     /// @param _from The current owner of the NFT
495     /// @param _to The new owner
496     /// @param _tokenId The NFT to transfer
497     /// @param data Additional data with no specified format, sent in call to `_to`
498     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
499 
500     /// @notice Transfers the ownership of an NFT from one address to another address
501     /// @dev This works identically to the other function with an extra data parameter,
502     ///  except this function just sets data to "".
503     /// @param _from The current owner of the NFT
504     /// @param _to The new owner
505     /// @param _tokenId The NFT to transfer
506     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
507 
508     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
509     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
510     ///  THEY MAY BE PERMANENTLY LOST
511     /// @dev Throws unless `msg.sender` is the current owner, an authorized
512     ///  operator, or the approved address for this NFT. Throws if `_from` is
513     ///  not the current owner. Throws if `_to` is the zero address. Throws if
514     ///  `_tokenId` is not a valid NFT.
515     /// @param _from The current owner of the NFT
516     /// @param _to The new owner
517     /// @param _tokenId The NFT to transfer
518     function transferFrom(address _from, address _to, uint256 _tokenId) external;
519 
520     /// @notice Change or reaffirm the approved address for an NFT
521     /// @dev The zero address indicates there is no approved address.
522     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
523     ///  operator of the current owner.
524     /// @param _approved The new approved NFT controller
525     /// @param _tokenId The NFT to approve
526     function approve(address _approved, uint256 _tokenId) external;
527 
528     /// @notice Enable or disable approval for a third party ("operator") to manage
529     ///  all of `msg.sender`'s assets
530     /// @dev Emits the ApprovalForAll event. The contract MUST allow
531     ///  multiple operators per owner.
532     /// @param _operator Address to add to the set of authorized operators
533     /// @param _approved True if the operator is approved, false to revoke approval
534     function setApprovalForAll(address _operator, bool _approved) external;
535 
536     /// @notice Get the approved address for a single NFT
537     /// @dev Throws if `_tokenId` is not a valid NFT.
538     /// @param _tokenId The NFT to find the approved address for
539     /// @return The approved address for this NFT, or the zero address if there is none
540     function getApproved(uint256 _tokenId) external view returns (address);
541 
542     /// @notice Query if an address is an authorized operator for another address
543     /// @param _owner The address that owns the NFTs
544     /// @param _operator The address that acts on behalf of the owner
545     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
546     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
547 }
548 
549 // @title ERC-721 Non-Fungible Token Standard
550 // @dev Include interface for both new and old functions
551 interface ERC721TokenReceiver {
552 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
553 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes data) external returns(bytes4);
554 }
555 
556 /*
557  * @title BitGuildMarketplace
558  * @dev: Marketplace smart contract for BitGuild.com
559  */
560 contract BitGuildMarketplace is BitGuildAccessAdmin {
561     // Callback values from zepellin ERC721Receiver.sol
562     // Old ver: bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
563     bytes4 constant ERC721_RECEIVED_OLD = 0xf0b9e5ba;
564     // New ver w/ operator: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")) = 0xf0b9e5ba;
565     bytes4 constant ERC721_RECEIVED = 0x150b7a02;
566 
567     // BitGuild Contracts
568     BitGuildToken public PLAT = BitGuildToken(0x7E43581b19ab509BCF9397a2eFd1ab10233f27dE); // Main Net
569     BitGuildWhitelist public Whitelist = BitGuildWhitelist(0xA8CedD578fed14f07C3737bF42AD6f04FAAE3978); // Main Net
570     BitGuildFeeProvider public FeeProvider = BitGuildFeeProvider(0x58D36571250D91eF5CE90869E66Cd553785364a2); // Main Net
571     // BitGuildToken public PLAT = BitGuildToken(0x0F2698b7605fE937933538387b3d6Fec9211477d); // Rinkeby
572     // BitGuildWhitelist public Whitelist = BitGuildWhitelist(0x72b93A4943eF4f658648e27D64e9e3B8cDF520a6); // Rinkeby
573     // BitGuildFeeProvider public FeeProvider = BitGuildFeeProvider(0xf7AB04A47AA9F3c8Cb7FDD701CF6DC6F2eB330E2); // Rinkeby
574 
575     uint public defaultExpiry = 7 days;  // default expiry is 7 days
576 
577     enum Currency { PLAT, ETH }
578     struct Listing {
579         Currency currency;      // ETH or PLAT
580         address seller;         // seller address
581         address token;          // token contract
582         uint tokenId;           // token id
583         uint price;             // Big number in ETH or PLAT
584         uint createdAt;         // timestamp
585         uint expiry;            // createdAt + defaultExpiry
586     }
587 
588     mapping(bytes32 => Listing) public listings;
589 
590     event LogListingCreated(address _seller, address _contract, uint _tokenId, uint _createdAt, uint _expiry);
591     event LogListingExtended(address _seller, address _contract, uint _tokenId, uint _createdAt, uint _expiry);
592     event LogItemSold(address _buyer, address _seller, address _contract, uint _tokenId, uint _price, Currency _currency, uint _soldAt);
593     event LogItemWithdrawn(address _seller, address _contract, uint _tokenId, uint _withdrawnAt);
594     event LogItemExtended(address _contract, uint _tokenId, uint _modifiedAt, uint _expiry);
595 
596     modifier onlyWhitelisted(address _contract) {
597         require(Whitelist.isWhitelisted(_contract), "Contract not in whitelist.");
598         _;
599     }
600 
601     // @dev fall back function
602     function () external payable {
603         revert();
604     }
605 
606     // @dev Retrieve hashkey to view listing
607     function getHashKey(address _contract, uint _tokenId) public pure returns(bytes32 key) {
608         key = _getHashKey(_contract, _tokenId);
609     }
610 
611     // ===========================================
612     // Fee functions (from fee provider contract)
613     // ===========================================
614     // @dev get fees
615     function getFee(uint _price, address _currency, address _buyer, address _seller, address _token) public view returns(uint percent, uint fee) {
616         (percent, fee) = FeeProvider.getFee(_price, _currency, _buyer, _seller, _token);
617     }
618 
619     // ===========================================
620     // Seller Functions
621     // ===========================================
622     // Deposit Item
623     // @dev deprecated callback (did not handle operator). added to support older contracts
624     function onERC721Received(address _from, uint _tokenId, bytes _extraData) external returns(bytes4) {
625         _deposit(_from, msg.sender, _tokenId, _extraData);
626         return ERC721_RECEIVED_OLD;
627     }
628 
629     // @dev expected callback (include operator)
630     function onERC721Received(address _operator, address _from, uint _tokenId, bytes _extraData) external returns(bytes4) {
631         _deposit(_from, msg.sender, _tokenId, _extraData);
632         return ERC721_RECEIVED;
633     }
634 
635     // @dev Extend item listing: new expiry = current expiry + defaultExpiry
636     // @param _contract whitelisted contract
637     // @param _tokenId  tokenId
638     function extendItem(address _contract, uint _tokenId) public onlyWhitelisted(_contract) returns(bool) {
639         bytes32 key = _getHashKey(_contract, _tokenId);
640         address seller = listings[key].seller;
641 
642         require(seller == msg.sender, "Only seller can extend listing.");
643         require(listings[key].expiry > 0, "Item not listed.");
644 
645         listings[key].expiry = now + defaultExpiry;
646 
647         emit LogListingExtended(seller, _contract, _tokenId, listings[key].createdAt, listings[key].expiry);
648 
649         return true;
650     }
651 
652     // @dev Withdraw item from marketplace back to seller
653     // @param _contract whitelisted contract
654     // @param _tokenId  tokenId
655     function withdrawItem(address _contract, uint _tokenId) public onlyWhitelisted(_contract) {
656         bytes32 key = _getHashKey(_contract, _tokenId);
657         address seller = listings[key].seller;
658 
659         require(seller == msg.sender, "Only seller can withdraw listing.");
660 
661         // Transfer item back to the seller
662         ERC721 gameToken = ERC721(_contract);
663         gameToken.safeTransferFrom(this, seller, _tokenId);
664 
665         emit LogItemWithdrawn(seller, _contract, _tokenId, now);
666 
667         // remove listing
668         delete(listings[key]);
669     }
670 
671     // ===========================================
672     // Purchase Item
673     // ===========================================
674     // @dev Buy item with ETH. Take ETH from buyer, transfer token, transfer payment minus fee to seller
675     // @param _token  Token contract
676     // @param _tokenId   Token Id
677     function buyWithETH(address _token, uint _tokenId) public onlyWhitelisted(_token) payable {
678         _buy(_token, _tokenId, Currency.ETH, msg.value, msg.sender);
679     }
680 
681     // Buy with PLAT requires calling BitGuildToken contract, this is the callback
682     // call to approve already verified the token ownership, no checks required
683     // @param _buyer     buyer
684     // @param _value     PLAT amount (big number)
685     // @param _PLAT      BitGuild token address
686     // @param _extraData address _gameContract, uint _tokenId
687     function receiveApproval(address _buyer, uint _value, BitGuildToken _PLAT, bytes _extraData) public {
688         require(_extraData.length > 0, "No extraData provided.");
689         // We check msg.sender with our known PLAT address instead of the _PLAT param
690         require(msg.sender == address(PLAT), "Unauthorized PLAT contract address.");
691 
692         address token;
693         uint tokenId;
694         (token, tokenId) = _decodeBuyData(_extraData);
695 
696         _buy(token, tokenId, Currency.PLAT, _value, _buyer);
697     }
698 
699     // ===========================================
700     // Admin Functions
701     // ===========================================
702     // @dev Update fee provider contract
703     function updateFeeProvider(address _newAddr) public onlyOperator {
704         require(_newAddr != address(0), "Invalid contract address.");
705         FeeProvider = BitGuildFeeProvider(_newAddr);
706     }
707 
708     // @dev Update whitelist contract
709     function updateWhitelist(address _newAddr) public onlyOperator {
710         require(_newAddr != address(0), "Invalid contract address.");
711         Whitelist = BitGuildWhitelist(_newAddr);
712     }
713 
714     // @dev Update expiry date
715     function updateExpiry(uint _days) public onlyOperator {
716         require(_days > 0, "Invalid number of days.");
717         defaultExpiry = _days * 1 days;
718     }
719 
720     // @dev Admin function: withdraw ETH balance
721     function withdrawETH() public onlyOwner payable {
722         msg.sender.transfer(msg.value);
723     }
724 
725     // @dev Admin function: withdraw PLAT balance
726     function withdrawPLAT() public onlyOwner payable {
727         uint balance = PLAT.balanceOf(this);
728         PLAT.transfer(msg.sender, balance);
729     }
730 
731     // ===========================================
732     // Internal Functions
733     // ===========================================
734     function _getHashKey(address _contract, uint _tokenId) internal pure returns(bytes32 key) {
735         key = keccak256(abi.encodePacked(_contract, _tokenId));
736     }
737 
738     // @dev create new listing data
739     function _newListing(address _seller, address _contract, uint _tokenId, uint _price, Currency _currency) internal {
740         bytes32 key = _getHashKey(_contract, _tokenId);
741         uint createdAt = now;
742         uint expiry = now + defaultExpiry;
743         listings[key].currency = _currency;
744         listings[key].seller = _seller;
745         listings[key].token = _contract;
746         listings[key].tokenId = _tokenId;
747         listings[key].price = _price;
748         listings[key].createdAt = createdAt;
749         listings[key].expiry = expiry;
750 
751         emit LogListingCreated(_seller, _contract, _tokenId, createdAt, expiry);
752     }
753 
754     // @dev deposit unpacks _extraData and log listing info
755     // @param _extraData packed bytes of (uint _price, uint _currency)
756     function _deposit(address _seller, address _contract, uint _tokenId, bytes _extraData) internal onlyWhitelisted(_contract) {
757         uint price;
758         uint currencyUint;
759         (currencyUint, price) = _decodePriceData(_extraData);
760         Currency currency = Currency(currencyUint);
761 
762         require(price > 0, "Invalid price.");
763 
764         _newListing(_seller, _contract, _tokenId, price, currency);
765     }
766 
767     // @dev handles purchase logic for both PLAT and ETH
768     function _buy(address _token, uint _tokenId, Currency _currency, uint _price, address _buyer) internal {
769         bytes32 key = _getHashKey(_token, _tokenId);
770         Currency currency = listings[key].currency;
771         address seller = listings[key].seller;
772 
773         address currencyAddress = _currency == Currency.PLAT ? address(PLAT) : address(0);
774 
775         require(currency == _currency, "Wrong currency.");
776         require(_price > 0 && _price == listings[key].price, "Invalid price.");
777         require(listings[key].expiry > now, "Item expired.");
778 
779         ERC721 gameToken = ERC721(_token);
780         require(gameToken.ownerOf(_tokenId) == address(this), "Item is not available.");
781 
782         if (_currency == Currency.PLAT) {
783             // Transfer PLAT to marketplace contract
784             require(PLAT.transferFrom(_buyer, address(this), _price), "PLAT payment transfer failed.");
785         }
786 
787         // Transfer item token to buyer
788         gameToken.safeTransferFrom(this, _buyer, _tokenId);
789 
790         uint fee;
791         (,fee) = getFee(_price, currencyAddress, _buyer, seller, _token); // getFee returns percentFee and fee, we only need fee
792 
793         if (_currency == Currency.PLAT) {
794             PLAT.transfer(seller, _price - fee);
795         } else {
796             require(seller.send(_price - fee) == true, "Transfer to seller failed.");
797         }
798 
799         // Emit event
800         emit LogItemSold(_buyer, seller, _token, _tokenId, _price, currency, now);
801 
802         // delist item
803         delete(listings[key]);
804     }
805 
806     function _decodePriceData(bytes _extraData) internal pure returns(uint _currency, uint _price) {
807         // Deserialize _extraData
808         uint256 offset = 64;
809         _price = _bytesToUint256(offset, _extraData);
810         offset -= 32;
811         _currency = _bytesToUint256(offset, _extraData);
812     }
813 
814     function _decodeBuyData(bytes _extraData) internal pure returns(address _contract, uint _tokenId) {
815         // Deserialize _extraData
816         uint256 offset = 64;
817         _tokenId = _bytesToUint256(offset, _extraData);
818         offset -= 32;
819         _contract = _bytesToAddress(offset, _extraData);
820     }
821 
822     // @dev Decoding helper function from Seriality
823     function _bytesToUint256(uint _offst, bytes memory _input) internal pure returns (uint256 _output) {
824         assembly {
825             _output := mload(add(_input, _offst))
826         }
827     }
828 
829     // @dev Decoding helper functions from Seriality
830     function _bytesToAddress(uint _offst, bytes memory _input) internal pure returns (address _output) {
831         assembly {
832             _output := mload(add(_input, _offst))
833         }
834     }
835 }