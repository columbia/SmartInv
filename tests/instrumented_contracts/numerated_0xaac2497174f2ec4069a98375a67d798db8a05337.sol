1 pragma solidity ^0.5.15;
2 
3 contract Context {
4     // Empty internal constructor, to prevent people from mistakenly deploying
5     // an instance of this contract, which should be used via inheritance.
6     constructor () internal { }
7     // solhint-disable-previous-line no-empty-blocks
8 
9     function _msgSender() internal view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 library Counters {
20     using SafeMath for uint256;
21 
22     struct Counter {
23         // This variable should never be directly accessed by users of the library: interactions must be restricted to
24         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
25         // this feature: see https://github.com/ethereum/solidity/issues/4637
26         uint256 _value; // default: 0
27     }
28 
29     function current(Counter storage counter) internal view returns (uint256) {
30         return counter._value;
31     }
32 
33     function increment(Counter storage counter) internal {
34         // The {SafeMath} overflow check can be skipped here, see the comment at the top
35         counter._value += 1;
36     }
37 
38     function decrement(Counter storage counter) internal {
39         counter._value = counter._value.sub(1);
40     }
41 }
42 
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 contract ERC165 is IERC165 {
56     /*
57      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
58      */
59     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
60 
61     /**
62      * @dev Mapping of interface ids to whether or not it's supported.
63      */
64     mapping(bytes4 => bool) private _supportedInterfaces;
65 
66     constructor () internal {
67         // Derived contracts need only register support for their own interfaces,
68         // we register support for ERC165 itself here
69         _registerInterface(_INTERFACE_ID_ERC165);
70     }
71 
72     /**
73      * @dev See {IERC165-supportsInterface}.
74      *
75      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
76      */
77     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
78         return _supportedInterfaces[interfaceId];
79     }
80 
81     /**
82      * @dev Registers the contract as an implementer of the interface defined by
83      * `interfaceId`. Support of the actual ERC165 interface is automatic and
84      * registering its interface id is not required.
85      *
86      * See {IERC165-supportsInterface}.
87      *
88      * Requirements:
89      *
90      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
91      */
92     function _registerInterface(bytes4 interfaceId) internal {
93         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
94         _supportedInterfaces[interfaceId] = true;
95     }
96 }
97 
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      * - Subtraction cannot overflow.
136      *
137      * _Available since v2.4.0._
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      * - The divisor cannot be zero.
194      *
195      * _Available since v2.4.0._
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         // Solidity only automatically asserts when dividing by 0
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      * - The divisor cannot be zero.
231      *
232      * _Available since v2.4.0._
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 contract IERC721 is IERC165 {
241     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
242     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
243     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
244 
245     /**
246      * @dev Returns the number of NFTs in `owner`'s account.
247      */
248     function balanceOf(address owner) public view returns (uint256 balance);
249 
250     /**
251      * @dev Returns the owner of the NFT specified by `tokenId`.
252      */
253     function ownerOf(uint256 tokenId) public view returns (address owner);
254 
255     /**
256      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
257      * another (`to`).
258      *
259      *
260      *
261      * Requirements:
262      * - `from`, `to` cannot be zero.
263      * - `tokenId` must be owned by `from`.
264      * - If the caller is not `from`, it must be have been allowed to move this
265      * NFT by either {approve} or {setApprovalForAll}.
266      */
267     function safeTransferFrom(address from, address to, uint256 tokenId) public;
268     /**
269      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
270      * another (`to`).
271      *
272      * Requirements:
273      * - If the caller is not `from`, it must be approved to move this NFT by
274      * either {approve} or {setApprovalForAll}.
275      */
276     function transferFrom(address from, address to, uint256 tokenId) public;
277     function approve(address to, uint256 tokenId) public;
278     function getApproved(uint256 tokenId) public view returns (address operator);
279 
280     function setApprovalForAll(address operator, bool _approved) public;
281     function isApprovedForAll(address owner, address operator) public view returns (bool);
282 
283 
284     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
285 }
286 
287 contract ERC721 is Context, ERC165, IERC721 {
288     using SafeMath for uint256;
289     using Address for address;
290     using Counters for Counters.Counter;
291 
292     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
293     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
294     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
295 
296     // Mapping from token ID to owner
297     mapping (uint256 => address) private _tokenOwner;
298 
299     // Mapping from token ID to approved address
300     mapping (uint256 => address) private _tokenApprovals;
301 
302     // Mapping from owner to number of owned token
303     mapping (address => Counters.Counter) private _ownedTokensCount;
304 
305     // Mapping from owner to operator approvals
306     mapping (address => mapping (address => bool)) private _operatorApprovals;
307 
308     /*
309      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
310      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
311      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
312      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
313      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
314      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
315      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
316      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
317      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
318      *
319      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
320      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
321      */
322     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
323 
324     constructor () public {
325         // register the supported interfaces to conform to ERC721 via ERC165
326         _registerInterface(_INTERFACE_ID_ERC721);
327     }
328 
329     /**
330      * @dev Gets the balance of the specified address.
331      * @param owner address to query the balance of
332      * @return uint256 representing the amount owned by the passed address
333      */
334     function balanceOf(address owner) public view returns (uint256) {
335         require(owner != address(0), "ERC721: balance query for the zero address");
336 
337         return _ownedTokensCount[owner].current();
338     }
339 
340     /**
341      * @dev Gets the owner of the specified token ID.
342      * @param tokenId uint256 ID of the token to query the owner of
343      * @return address currently marked as the owner of the given token ID
344      */
345     function ownerOf(uint256 tokenId) public view returns (address) {
346         address owner = _tokenOwner[tokenId];
347         require(owner != address(0), "ERC721: owner query for nonexistent token");
348 
349         return owner;
350     }
351 
352     /**
353      * @dev Approves another address to transfer the given token ID
354      * The zero address indicates there is no approved address.
355      * There can only be one approved address per token at a given time.
356      * Can only be called by the token owner or an approved operator.
357      * @param to address to be approved for the given token ID
358      * @param tokenId uint256 ID of the token to be approved
359      */
360     function approve(address to, uint256 tokenId) public {
361         address owner = ownerOf(tokenId);
362         require(to != owner, "ERC721: approval to current owner");
363 
364         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
365             "ERC721: approve caller is not owner nor approved for all"
366         );
367 
368         _tokenApprovals[tokenId] = to;
369         emit Approval(owner, to, tokenId);
370     }
371 
372     /**
373      * @dev Gets the approved address for a token ID, or zero if no address set
374      * Reverts if the token ID does not exist.
375      * @param tokenId uint256 ID of the token to query the approval of
376      * @return address currently approved for the given token ID
377      */
378     function getApproved(uint256 tokenId) public view returns (address) {
379         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
380 
381         return _tokenApprovals[tokenId];
382     }
383 
384     /**
385      * @dev Sets or unsets the approval of a given operator
386      * An operator is allowed to transfer all tokens of the sender on their behalf.
387      * @param to operator address to set the approval
388      * @param approved representing the status of the approval to be set
389      */
390     function setApprovalForAll(address to, bool approved) public {
391         require(to != _msgSender(), "ERC721: approve to caller");
392 
393         _operatorApprovals[_msgSender()][to] = approved;
394         emit ApprovalForAll(_msgSender(), to, approved);
395     }
396 
397     /**
398      * @dev Tells whether an operator is approved by a given owner.
399      * @param owner owner address which you want to query the approval of
400      * @param operator operator address which you want to query the approval of
401      * @return bool whether the given operator is approved by the given owner
402      */
403     function isApprovedForAll(address owner, address operator) public view returns (bool) {
404         return _operatorApprovals[owner][operator];
405     }
406 
407     /**
408      * @dev Transfers the ownership of a given token ID to another address.
409      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
410      * Requires the msg.sender to be the owner, approved, or operator.
411      * @param from current owner of the token
412      * @param to address to receive the ownership of the given token ID
413      * @param tokenId uint256 ID of the token to be transferred
414      */
415     function transferFrom(address from, address to, uint256 tokenId) public {
416         //solhint-disable-next-line max-line-length
417         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
418 
419         _transferFrom(from, to, tokenId);
420     }
421 
422     /**
423      * @dev Safely transfers the ownership of a given token ID to another address
424      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
425      * which is called upon a safe transfer, and return the magic value
426      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
427      * the transfer is reverted.
428      * Requires the msg.sender to be the owner, approved, or operator
429      * @param from current owner of the token
430      * @param to address to receive the ownership of the given token ID
431      * @param tokenId uint256 ID of the token to be transferred
432      */
433     function safeTransferFrom(address from, address to, uint256 tokenId) public {
434         safeTransferFrom(from, to, tokenId, "");
435     }
436 
437     /**
438      * @dev Safely transfers the ownership of a given token ID to another address
439      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
440      * which is called upon a safe transfer, and return the magic value
441      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
442      * the transfer is reverted.
443      * Requires the _msgSender() to be the owner, approved, or operator
444      * @param from current owner of the token
445      * @param to address to receive the ownership of the given token ID
446      * @param tokenId uint256 ID of the token to be transferred
447      * @param _data bytes data to send along with a safe transfer check
448      */
449     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
450         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
451         _safeTransferFrom(from, to, tokenId, _data);
452     }
453 
454     /**
455      * @dev Safely transfers the ownership of a given token ID to another address
456      * If the target address is a contract, it must implement `onERC721Received`,
457      * which is called upon a safe transfer, and return the magic value
458      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
459      * the transfer is reverted.
460      * Requires the msg.sender to be the owner, approved, or operator
461      * @param from current owner of the token
462      * @param to address to receive the ownership of the given token ID
463      * @param tokenId uint256 ID of the token to be transferred
464      * @param _data bytes data to send along with a safe transfer check
465      */
466     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
467         _transferFrom(from, to, tokenId);
468         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
469     }
470 
471     /**
472      * @dev Returns whether the specified token exists.
473      * @param tokenId uint256 ID of the token to query the existence of
474      * @return bool whether the token exists
475      */
476     function _exists(uint256 tokenId) internal view returns (bool) {
477         address owner = _tokenOwner[tokenId];
478         return owner != address(0);
479     }
480 
481     /**
482      * @dev Returns whether the given spender can transfer a given token ID.
483      * @param spender address of the spender to query
484      * @param tokenId uint256 ID of the token to be transferred
485      * @return bool whether the msg.sender is approved for the given token ID,
486      * is an operator of the owner, or is the owner of the token
487      */
488     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
489         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
490         address owner = ownerOf(tokenId);
491         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
492     }
493 
494     /**
495      * @dev Internal function to safely mint a new token.
496      * Reverts if the given token ID already exists.
497      * If the target address is a contract, it must implement `onERC721Received`,
498      * which is called upon a safe transfer, and return the magic value
499      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
500      * the transfer is reverted.
501      * @param to The address that will own the minted token
502      * @param tokenId uint256 ID of the token to be minted
503      */
504     function _safeMint(address to, uint256 tokenId) internal {
505         _safeMint(to, tokenId, "");
506     }
507 
508     /**
509      * @dev Internal function to safely mint a new token.
510      * Reverts if the given token ID already exists.
511      * If the target address is a contract, it must implement `onERC721Received`,
512      * which is called upon a safe transfer, and return the magic value
513      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
514      * the transfer is reverted.
515      * @param to The address that will own the minted token
516      * @param tokenId uint256 ID of the token to be minted
517      * @param _data bytes data to send along with a safe transfer check
518      */
519     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
520         _mint(to, tokenId);
521         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
522     }
523 
524     /**
525      * @dev Internal function to mint a new token.
526      * Reverts if the given token ID already exists.
527      * @param to The address that will own the minted token
528      * @param tokenId uint256 ID of the token to be minted
529      */
530     function _mint(address to, uint256 tokenId) internal {
531         require(to != address(0), "ERC721: mint to the zero address");
532         require(!_exists(tokenId), "ERC721: token already minted");
533 
534         _tokenOwner[tokenId] = to;
535         _ownedTokensCount[to].increment();
536 
537         emit Transfer(address(0), to, tokenId);
538     }
539 
540     /**
541      * @dev Internal function to burn a specific token.
542      * Reverts if the token does not exist.
543      * Deprecated, use {_burn} instead.
544      * @param owner owner of the token to burn
545      * @param tokenId uint256 ID of the token being burned
546      */
547     function _burn(address owner, uint256 tokenId) internal {
548         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
549 
550         _clearApproval(tokenId);
551 
552         _ownedTokensCount[owner].decrement();
553         _tokenOwner[tokenId] = address(0);
554 
555         emit Transfer(owner, address(0), tokenId);
556     }
557 
558     /**
559      * @dev Internal function to burn a specific token.
560      * Reverts if the token does not exist.
561      * @param tokenId uint256 ID of the token being burned
562      */
563     function _burn(uint256 tokenId) internal {
564         _burn(ownerOf(tokenId), tokenId);
565     }
566 
567     /**
568      * @dev Internal function to transfer ownership of a given token ID to another address.
569      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
570      * @param from current owner of the token
571      * @param to address to receive the ownership of the given token ID
572      * @param tokenId uint256 ID of the token to be transferred
573      */
574     function _transferFrom(address from, address to, uint256 tokenId) internal {
575         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
576         require(to != address(0), "ERC721: transfer to the zero address");
577 
578         _clearApproval(tokenId);
579 
580         _ownedTokensCount[from].decrement();
581         _ownedTokensCount[to].increment();
582 
583         _tokenOwner[tokenId] = to;
584 
585         emit Transfer(from, to, tokenId);
586     }
587 
588     /**
589      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
590      * The call is not executed if the target address is not a contract.
591      *
592      * This is an internal detail of the `ERC721` contract and its use is deprecated.
593      * @param from address representing the previous owner of the given token ID
594      * @param to target address that will receive the tokens
595      * @param tokenId uint256 ID of the token to be transferred
596      * @param _data bytes optional data to send along with the call
597      * @return bool whether the call correctly returned the expected magic value
598      */
599     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
600         internal returns (bool)
601     {
602         if (!to.isContract()) {
603             return true;
604         }
605         // solhint-disable-next-line avoid-low-level-calls
606         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
607             IERC721Receiver(to).onERC721Received.selector,
608             _msgSender(),
609             from,
610             tokenId,
611             _data
612         ));
613         if (!success) {
614             if (returndata.length > 0) {
615                 // solhint-disable-next-line no-inline-assembly
616                 assembly {
617                     let returndata_size := mload(returndata)
618                     revert(add(32, returndata), returndata_size)
619                 }
620             } else {
621                 revert("ERC721: transfer to non ERC721Receiver implementer");
622             }
623         } else {
624             bytes4 retval = abi.decode(returndata, (bytes4));
625             return (retval == _ERC721_RECEIVED);
626         }
627     }
628 
629     /**
630      * @dev Private function to clear current approval of a given token ID.
631      * @param tokenId uint256 ID of the token to be transferred
632      */
633     function _clearApproval(uint256 tokenId) private {
634         if (_tokenApprovals[tokenId] != address(0)) {
635             _tokenApprovals[tokenId] = address(0);
636         }
637     }
638 }
639 
640 contract IERC721Receiver {
641     /**
642      * @notice Handle the receipt of an NFT
643      * @dev The ERC721 smart contract calls this function on the recipient
644      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
645      * otherwise the caller will revert the transaction. The selector to be
646      * returned can be obtained as `this.onERC721Received.selector`. This
647      * function MAY throw to revert and reject the transfer.
648      * Note: the ERC721 contract address is always the message sender.
649      * @param operator The address which called `safeTransferFrom` function
650      * @param from The address which previously owned the token
651      * @param tokenId The NFT identifier which is being transferred
652      * @param data Additional data with no specified format
653      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
654      */
655     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
656     public returns (bytes4);
657 }
658 
659 library Address {
660     /**
661      * @dev Returns true if `account` is a contract.
662      *
663      * [IMPORTANT]
664      * ====
665      * It is unsafe to assume that an address for which this function returns
666      * false is an externally-owned account (EOA) and not a contract.
667      *
668      * Among others, `isContract` will return false for the following 
669      * types of addresses:
670      *
671      *  - an externally-owned account
672      *  - a contract in construction
673      *  - an address where a contract will be created
674      *  - an address where a contract lived, but was destroyed
675      * ====
676      */
677     function isContract(address account) internal view returns (bool) {
678         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
679         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
680         // for accounts without code, i.e. `keccak256('')`
681         bytes32 codehash;
682         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
683         // solhint-disable-next-line no-inline-assembly
684         assembly { codehash := extcodehash(account) }
685         return (codehash != accountHash && codehash != 0x0);
686     }
687 
688     /**
689      * @dev Converts an `address` into `address payable`. Note that this is
690      * simply a type cast: the actual underlying value is not changed.
691      *
692      * _Available since v2.4.0._
693      */
694     function toPayable(address account) internal pure returns (address payable) {
695         return address(uint160(account));
696     }
697 
698     /**
699      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
700      * `recipient`, forwarding all available gas and reverting on errors.
701      *
702      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
703      * of certain opcodes, possibly making contracts go over the 2300 gas limit
704      * imposed by `transfer`, making them unable to receive funds via
705      * `transfer`. {sendValue} removes this limitation.
706      *
707      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
708      *
709      * IMPORTANT: because control is transferred to `recipient`, care must be
710      * taken to not create reentrancy vulnerabilities. Consider using
711      * {ReentrancyGuard} or the
712      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
713      *
714      * _Available since v2.4.0._
715      */
716     function sendValue(address payable recipient, uint256 amount) internal {
717         require(address(this).balance >= amount, "Address: insufficient balance");
718 
719         // solhint-disable-next-line avoid-call-value
720         (bool success, ) = recipient.call.value(amount)("");
721         require(success, "Address: unable to send value, recipient may have reverted");
722     }
723 }
724 
725 contract Poap is ERC721 {
726     event EventToken(uint256 eventId, uint256 tokenId);
727 
728     // Last Used id (used to generate new ids)
729     uint256 private lastId;
730 
731     // EventId for each token
732     mapping(uint256 => uint256) private _tokenEvent;
733 
734     /**
735      * @dev Function to mint tokens
736      * @param eventId EventId for the new token
737      * @param tokenId The token id to mint.
738      * @param to The address that will receive the minted tokens.
739      * @return A boolean that indicates if the operation was successful.
740      */
741     function _mintToken(uint256 eventId, uint256 tokenId, address to) internal returns (bool) {
742         _mint(to, tokenId);
743         _tokenEvent[tokenId] = eventId;
744         emit EventToken(eventId, tokenId);
745         return true;
746     }
747 
748     /**
749      * @dev Function to mint tokens
750      * @param eventId EventId for the new token
751      * @param to The address that will receive the minted tokens.
752      * @return A boolean that indicates if the operation was successful.
753      */
754     function mintToken(uint256 eventId, address to) public returns (bool) {
755         lastId += 1;
756         return _mintToken(eventId, lastId, to);
757     }
758 }
759 
760 contract PoapDelegatedMint {
761 
762     event VerifiedSignature(
763         bytes _signedMessage
764     );
765 
766     string public name = "POAP Delegated Mint";
767 
768     // POAP Contract - Only Mint Token function
769     Poap POAPToken;
770 
771     // Contract creator
772     address public owner;
773 
774     // POAP valid token minter
775     address public validSigner;
776 
777     // Processed signatures
778     mapping(bytes => bool) public processed;
779 
780     constructor (address _poapContractAddress, address _validSigner) public{
781         validSigner = _validSigner;
782         POAPToken = Poap(_poapContractAddress);
783         owner = msg.sender;
784     }
785 
786     function _recoverSigner(bytes32 message, bytes memory signature) private pure returns (address) {
787         uint8 v;
788         bytes32 r;
789         bytes32 s;
790 
791         (v, r, s) = _splitSignature(signature);
792         return ecrecover(message, v, r, s);
793     }
794 
795     function _splitSignature(bytes memory signature) private pure returns (uint8, bytes32, bytes32) {
796         require(signature.length == 65);
797 
798         bytes32 r;
799         bytes32 s;
800         uint8 v;
801 
802         assembly {
803         // first 32 bytes, after the length prefix
804             r := mload(add(signature, 32))
805         // second 32 bytes
806             s := mload(add(signature, 64))
807         // final byte (first byte of the next 32 bytes)
808             v := byte(0, mload(add(signature, 96)))
809         }
810 
811         return (v, r, s);
812     }
813 
814     function _isValidData(uint256 _event_id, address _receiver, bytes memory _signed_message) private view returns(bool) {
815         bytes32 message = keccak256(abi.encodePacked(_event_id, _receiver));
816         return (_recoverSigner(message, _signed_message) == validSigner);
817     }
818 
819     function mintToken(uint256 event_id, address receiver, bytes memory signedMessage) public returns (bool) {
820         // Check that the signature is valid
821         require(_isValidData(event_id, receiver, signedMessage), "Invalid signed message");
822         // Check that the signature was not already processed
823         require(processed[signedMessage] == false, "Signature already processed");
824 
825         processed[signedMessage] = true;
826         emit VerifiedSignature(signedMessage);
827         return POAPToken.mintToken(event_id, receiver);
828     }
829 }