1 pragma solidity ^0.5.0;
2 
3 // File: contracts/libraries/Address.sol
4 
5 /**
6  * Utility library of inline functions on addresses
7  */
8 library Address {
9   /**
10    * Returns whether the target address is a contract
11    * @dev This function will return false if invoked during the constructor of a contract,
12    * as the code is not actually created until after the constructor finishes.
13    * @param account address of the account to check
14    * @return whether the target address is a contract
15    */
16   function isContract(address account) internal view returns (bool) {
17       uint256 size;
18       // XXX Currently there is no better way to check if there is a contract in an address
19       // than to check the size of the code at that address.
20       // See https://ethereum.stackexchange.com/a/14016/36603
21       // for more details about how this works.
22       // TODO Check this again before the Serenity release, because all addresses will be
23       // contracts then.
24       // solhint-disable-next-line no-inline-assembly
25       assembly { size := extcodesize(account) }
26       return size > 0;
27   }
28 }
29 
30 // File: contracts/libraries/SafeMath.sol
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error.
35  */
36 library SafeMath {
37   /**
38    * @dev Multiplies two unsigned integers, reverts on overflow.
39    */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42       // benefit is lost if 'b' is also tested.
43       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44       if (a == 0) {
45           return 0;
46       }
47 
48       uint256 c = a * b;
49       require(c / a == b, "SafeMath: multiplication overflow");
50 
51       return c;
52   }
53 
54   /**
55    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
56    */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58       // Solidity only automatically asserts when dividing by 0
59       require(b > 0, "SafeMath: division by zero");
60       uint256 c = a / b;
61       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63       return c;
64   }
65 
66   /**
67    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68    */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70       require(b <= a, "SafeMath: subtraction overflow");
71       uint256 c = a - b;
72 
73       return c;
74   }
75 
76   /**
77    * @dev Adds two unsigned integers, reverts on overflow.
78    */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80       uint256 c = a + b;
81       require(c >= a, "SafeMath: addition overflow");
82 
83       return c;
84   }
85 
86   /**
87    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88    * reverts when dividing by zero.
89    */
90   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91       require(b != 0, "SafeMath: modulo by zero");
92       return a % b;
93   }
94 }
95 
96 // File: contracts/libraries/Counters.sol
97 
98 /**
99  * @title Counters
100  * @author Matt Condon (@shrugs)
101  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
102  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
103  *
104  * Include with `using Counters for Counters.Counter;`
105  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
106  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
107  * directly accessed.
108  */
109 library Counters {
110     using SafeMath for uint256;
111 
112     struct Counter {
113         // This variable should never be directly accessed by users of the library: interactions must be restricted to
114         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
115         // this feature: see https://github.com/ethereum/solidity/issues/4637
116         uint256 _value; // default: 0
117     }
118 
119     function current(Counter storage counter) internal view returns (uint256) {
120         return counter._value;
121     }
122 
123     function increment(Counter storage counter) internal {
124         counter._value += 1;
125     }
126 
127     function decrement(Counter storage counter) internal {
128         counter._value = counter._value.sub(1);
129     }
130 }
131 
132 // File: contracts/standards/IERC165.sol
133 
134 /**
135  * @title IERC165
136  * @dev https://eips.ethereum.org/EIPS/eip-165
137  */
138 interface IERC165 {
139     /**
140      * @notice Query if a contract implements an interface
141      * @param interfaceId The interface identifier, as specified in ERC-165
142      * @dev Interface identification is specified in ERC-165. This function
143      * uses less than 30,000 gas.
144      */
145     function supportsInterface(bytes4 interfaceId) external view returns (bool);
146 }
147 
148 // File: contracts/standards/ERC165.sol
149 
150 /**
151  * @title ERC165
152  * @author Matt Condon (@shrugs)
153  * @dev Implements ERC165 using a lookup table.
154  */
155 contract ERC165 is IERC165 {
156     /*
157      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
158      */
159     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
160 
161     /**
162      * @dev Mapping of interface ids to whether or not it's supported.
163      */
164     mapping(bytes4 => bool) private _supportedInterfaces;
165 
166     /**
167      * @dev A contract implementing SupportsInterfaceWithLookup
168      * implements ERC165 itself.
169      */
170     constructor () internal {
171         _registerInterface(_INTERFACE_ID_ERC165);
172     }
173 
174     /**
175      * @dev Implement supportsInterface(bytes4) using a lookup table.
176      */
177     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
178         return _supportedInterfaces[interfaceId];
179     }
180 
181     /**
182      * @dev Internal method for registering an interface.
183      */
184     function _registerInterface(bytes4 interfaceId) internal {
185         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
186         _supportedInterfaces[interfaceId] = true;
187     }
188 }
189 
190 // File: contracts/standards/IERC721.sol
191 
192 /**
193  * @title ERC721 Non-Fungible Token Standard basic interface
194  * @dev see https://eips.ethereum.org/EIPS/eip-721
195  */
196 contract IERC721 is IERC165 {
197     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
198     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
199     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
200 
201     function balanceOf(address owner) public view returns (uint256 balance);
202     function ownerOf(uint256 tokenId) public view returns (address owner);
203 
204     function approve(address to, uint256 tokenId) public;
205     function getApproved(uint256 tokenId) public view returns (address operator);
206 
207     function setApprovalForAll(address operator, bool _approved) public;
208     function isApprovedForAll(address owner, address operator) public view returns (bool);
209 
210     function transferFrom(address from, address to, uint256 tokenId) public;
211     function safeTransferFrom(address from, address to, uint256 tokenId) public;
212 
213     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
214 }
215 
216 // File: contracts/standards/IERC721Receiver.sol
217 
218 /**
219  * @title ERC721 token receiver interface
220  * @dev Interface for any contract that wants to support safeTransfers
221  * from ERC721 asset contracts.
222  */
223 contract IERC721Receiver {
224     /**
225      * @notice Handle the receipt of an NFT
226      * @dev The ERC721 smart contract calls this function on the recipient
227      * after a `safeTransfer`. This function MUST return the function selector,
228      * otherwise the caller will revert the transaction. The selector to be
229      * returned can be obtained as `this.onERC721Received.selector`. This
230      * function MAY throw to revert and reject the transfer.
231      * Note: the ERC721 contract address is always the message sender.
232      * @param operator The address which called `safeTransferFrom` function
233      * @param from The address which previously owned the token
234      * @param tokenId The NFT identifier which is being transferred
235      * @param data Additional data with no specified format
236      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
237      */
238     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
239     public returns (bytes4);
240 }
241 
242 // File: contracts/standards/ERC721.sol
243 
244 /**
245  * @title ERC721 Non-Fungible Token Standard basic implementation
246  * @dev see https://eips.ethereum.org/EIPS/eip-721
247  */
248 contract ERC721 is ERC165, IERC721 {
249     using SafeMath for uint256;
250     using Address for address;
251     using Counters for Counters.Counter;
252 
253     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
254     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
255     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
256 
257     // Mapping from token ID to owner
258     mapping (uint256 => address) private _tokenOwner;
259 
260     // Mapping from token ID to approved address
261     mapping (uint256 => address) private _tokenApprovals;
262 
263     // Mapping from owner to number of owned token
264     mapping (address => Counters.Counter) private _ownedTokensCount;
265 
266     // Mapping from owner to operator approvals
267     mapping (address => mapping (address => bool)) private _operatorApprovals;
268 
269     /*
270      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
271      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
272      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
273      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
274      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
275      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
276      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
277      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
278      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
279      *
280      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
281      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
282      */
283     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
284 
285     constructor () public {
286         // register the supported interfaces to conform to ERC721 via ERC165
287         _registerInterface(_INTERFACE_ID_ERC721);
288     }
289 
290     /**
291      * @dev Gets the balance of the specified address.
292      * @param owner address to query the balance of
293      * @return uint256 representing the amount owned by the passed address
294      */
295     function balanceOf(address owner) public view returns (uint256) {
296         require(owner != address(0), "ERC721: balance query for the zero address");
297 
298         return _ownedTokensCount[owner].current();
299     }
300 
301     /**
302      * @dev Gets the owner of the specified token ID.
303      * @param tokenId uint256 ID of the token to query the owner of
304      * @return address currently marked as the owner of the given token ID
305      */
306     function ownerOf(uint256 tokenId) public view returns (address) {
307         address owner = _tokenOwner[tokenId];
308         require(owner != address(0), "ERC721: owner query for nonexistent token");
309 
310         return owner;
311     }
312 
313     /**
314      * @dev Approves another address to transfer the given token ID
315      * The zero address indicates there is no approved address.
316      * There can only be one approved address per token at a given time.
317      * Can only be called by the token owner or an approved operator.
318      * @param to address to be approved for the given token ID
319      * @param tokenId uint256 ID of the token to be approved
320      */
321     function approve(address to, uint256 tokenId) public {
322         address owner = ownerOf(tokenId);
323         require(to != owner, "ERC721: approval to current owner");
324 
325         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
326             "ERC721: approve caller is not owner nor approved for all"
327         );
328 
329         _tokenApprovals[tokenId] = to;
330         emit Approval(owner, to, tokenId);
331     }
332 
333     /**
334      * @dev Gets the approved address for a token ID, or zero if no address set
335      * Reverts if the token ID does not exist.
336      * @param tokenId uint256 ID of the token to query the approval of
337      * @return address currently approved for the given token ID
338      */
339     function getApproved(uint256 tokenId) public view returns (address) {
340         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
341 
342         return _tokenApprovals[tokenId];
343     }
344 
345     /**
346      * @dev Sets or unsets the approval of a given operator
347      * An operator is allowed to transfer all tokens of the sender on their behalf.
348      * @param to operator address to set the approval
349      * @param approved representing the status of the approval to be set
350      */
351     function setApprovalForAll(address to, bool approved) public {
352         require(to != msg.sender, "ERC721: approve to caller");
353 
354         _operatorApprovals[msg.sender][to] = approved;
355         emit ApprovalForAll(msg.sender, to, approved);
356     }
357 
358     /**
359      * @dev Tells whether an operator is approved by a given owner.
360      * @param owner owner address which you want to query the approval of
361      * @param operator operator address which you want to query the approval of
362      * @return bool whether the given operator is approved by the given owner
363      */
364     function isApprovedForAll(address owner, address operator) public view returns (bool) {
365         return _operatorApprovals[owner][operator];
366     }
367 
368     /**
369      * @dev Transfers the ownership of a given token ID to another address.
370      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
371      * Requires the msg.sender to be the owner, approved, or operator.
372      * @param from current owner of the token
373      * @param to address to receive the ownership of the given token ID
374      * @param tokenId uint256 ID of the token to be transferred
375      */
376     function transferFrom(address from, address to, uint256 tokenId) public {
377         //solhint-disable-next-line max-line-length
378         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
379 
380         _transferFrom(from, to, tokenId);
381     }
382 
383     /**
384      * @dev Safely transfers the ownership of a given token ID to another address
385      * If the target address is a contract, it must implement `onERC721Received`,
386      * which is called upon a safe transfer, and return the magic value
387      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
388      * the transfer is reverted.
389      * Requires the msg.sender to be the owner, approved, or operator
390      * @param from current owner of the token
391      * @param to address to receive the ownership of the given token ID
392      * @param tokenId uint256 ID of the token to be transferred
393      */
394     function safeTransferFrom(address from, address to, uint256 tokenId) public {
395         safeTransferFrom(from, to, tokenId, "");
396     }
397 
398     /**
399      * @dev Safely transfers the ownership of a given token ID to another address
400      * If the target address is a contract, it must implement `onERC721Received`,
401      * which is called upon a safe transfer, and return the magic value
402      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
403      * the transfer is reverted.
404      * Requires the msg.sender to be the owner, approved, or operator
405      * @param from current owner of the token
406      * @param to address to receive the ownership of the given token ID
407      * @param tokenId uint256 ID of the token to be transferred
408      * @param _data bytes data to send along with a safe transfer check
409      */
410     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
411         transferFrom(from, to, tokenId);
412         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
413     }
414 
415     /**
416      * @dev Returns whether the specified token exists.
417      * @param tokenId uint256 ID of the token to query the existence of
418      * @return bool whether the token exists
419      */
420     function _exists(uint256 tokenId) internal view returns (bool) {
421         address owner = _tokenOwner[tokenId];
422         return owner != address(0);
423     }
424 
425     /**
426      * @dev Returns whether the given spender can transfer a given token ID.
427      * @param spender address of the spender to query
428      * @param tokenId uint256 ID of the token to be transferred
429      * @return bool whether the msg.sender is approved for the given token ID,
430      * is an operator of the owner, or is the owner of the token
431      */
432     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
433         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
434         address owner = ownerOf(tokenId);
435         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
436     }
437 
438     /**
439      * @dev Internal function to mint a new token.
440      * Reverts if the given token ID already exists.
441      * @param to The address that will own the minted token
442      * @param tokenId uint256 ID of the token to be minted
443      */
444     function _mint(address to, uint256 tokenId) internal {
445         require(to != address(0), "ERC721: mint to the zero address");
446         require(!_exists(tokenId), "ERC721: token already minted");
447 
448         _tokenOwner[tokenId] = to;
449         _ownedTokensCount[to].increment();
450 
451         emit Transfer(address(0), to, tokenId);
452     }
453 
454     /**
455      * @dev Internal function to burn a specific token.
456      * Reverts if the token does not exist.
457      * Deprecated, use _burn(uint256) instead.
458      * @param owner owner of the token to burn
459      * @param tokenId uint256 ID of the token being burned
460      */
461     function _burn(address owner, uint256 tokenId) internal {
462         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
463 
464         _clearApproval(tokenId);
465 
466         _ownedTokensCount[owner].decrement();
467         _tokenOwner[tokenId] = address(0);
468 
469         emit Transfer(owner, address(0), tokenId);
470     }
471 
472     /**
473      * @dev Internal function to burn a specific token.
474      * Reverts if the token does not exist.
475      * @param tokenId uint256 ID of the token being burned
476      */
477     function _burn(uint256 tokenId) internal {
478         _burn(ownerOf(tokenId), tokenId);
479     }
480 
481     /**
482      * @dev Internal function to transfer ownership of a given token ID to another address.
483      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
484      * @param from current owner of the token
485      * @param to address to receive the ownership of the given token ID
486      * @param tokenId uint256 ID of the token to be transferred
487      */
488     function _transferFrom(address from, address to, uint256 tokenId) internal {
489         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
490         require(to != address(0), "ERC721: transfer to the zero address");
491 
492         _clearApproval(tokenId);
493 
494         _ownedTokensCount[from].decrement();
495         _ownedTokensCount[to].increment();
496 
497         _tokenOwner[tokenId] = to;
498 
499         emit Transfer(from, to, tokenId);
500     }
501 
502     /**
503      * @dev Internal function to invoke `onERC721Received` on a target address.
504      * The call is not executed if the target address is not a contract.
505      * @param from address representing the previous owner of the given token ID
506      * @param to target address that will receive the tokens
507      * @param tokenId uint256 ID of the token to be transferred
508      * @param _data bytes optional data to send along with the call
509      * @return bool whether the call correctly returned the expected magic value
510      */
511     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
512         internal returns (bool)
513     {
514         if (!to.isContract()) {
515             return true;
516         }
517 
518         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
519         return (retval == _ERC721_RECEIVED);
520     }
521 
522     /**
523      * @dev Private function to clear current approval of a given token ID.
524      * @param tokenId uint256 ID of the token to be transferred
525      */
526     function _clearApproval(uint256 tokenId) private {
527         if (_tokenApprovals[tokenId] != address(0)) {
528             _tokenApprovals[tokenId] = address(0);
529         }
530     }
531 }
532 
533 // File: contracts/standards/Ownable.sol
534 
535 /**
536  * @title Ownable
537  * @dev The Ownable contract has an owner address, and provides basic authorization control
538  * functions, this simplifies the implementation of "user permissions".
539  */
540 contract Ownable {
541     address private _owner;
542 
543     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
544 
545     /**
546      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
547      * account.
548      */
549     constructor () internal {
550         _owner = msg.sender;
551         emit OwnershipTransferred(address(0), _owner);
552     }
553 
554     /**
555      * @return the address of the owner.
556      */
557     function owner() public view returns (address) {
558         return _owner;
559     }
560 
561     /**
562      * @dev Throws if called by any account other than the owner.
563      */
564     modifier onlyOwner() {
565         require(isOwner(), "Ownable: caller is not the owner");
566         _;
567     }
568 
569     /**
570      * @return true if `msg.sender` is the owner of the contract.
571      */
572     function isOwner() public view returns (bool) {
573         return msg.sender == _owner;
574     }
575 
576     /**
577      * @dev Allows the current owner to relinquish control of the contract.
578      * It will not be possible to call the functions with the `onlyOwner`
579      * modifier anymore.
580      * @notice Renouncing ownership will leave the contract without an owner,
581      * thereby removing any functionality that is only available to the owner.
582      */
583     function renounceOwnership() public onlyOwner {
584         emit OwnershipTransferred(_owner, address(0));
585         _owner = address(0);
586     }
587 
588     /**
589      * @dev Allows the current owner to transfer control of the contract to a newOwner.
590      * @param newOwner The address to transfer ownership to.
591      */
592     function transferOwnership(address newOwner) public onlyOwner {
593         _transferOwnership(newOwner);
594     }
595 
596     /**
597      * @dev Transfers control of the contract to a newOwner.
598      * @param newOwner The address to transfer ownership to.
599      */
600     function _transferOwnership(address newOwner) internal {
601         require(newOwner != address(0), "Ownable: new owner is the zero address");
602         emit OwnershipTransferred(_owner, newOwner);
603         _owner = newOwner;
604     }
605 }
606 
607 // File: contracts/SatoshiZero.sol
608 
609 contract SatoshiZero is ERC721, Ownable {
610     string public constant name = "Satoshi's Closet";
611     string public constant symbol = "STCL";
612     string public constant tokenName = "Tom's Shirt / The Proof of Concept";
613 
614     struct Item {
615         string itemName;
616         string itemType;
617         string size;
618         string color;
619         // price (in wei) of item
620         uint128 price;
621     }
622 
623     uint128 MAX_ITEMS = 1;
624     // array of items
625     Item[] items;
626 
627     function getItem( uint _itemId ) public view returns(string memory itemName, string memory itemType, string memory size, string memory color, uint128 price) {
628         Item memory _item = items[_itemId];
629 
630         itemName = _item.itemName;
631         itemType = _item.itemType;
632         size = _item.size;
633         color = _item.color;
634         price = _item.price;
635     }
636 
637     function totalSupply() public view returns (uint) {
638         return items.length;
639     }
640 
641     function createItem( string calldata _name, string calldata _itemType, string calldata _size, string calldata _color, uint128 _price) external onlyOwner returns (uint) {
642         require(MAX_ITEMS > totalSupply());
643 
644         Item memory _item = Item({
645             itemName: _name,
646             itemType: _itemType,
647             size: _size,
648             color: _color,
649             price: _price
650         });
651         uint itemId = items.push(_item);
652 
653         _mint(owner(), itemId);
654 
655         return itemId;
656     }
657 }