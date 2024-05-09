1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title IERC165
6  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
7  */
8 interface IERC165 {
9 
10   /**
11    * @notice Query if a contract implements an interface
12    * @param interfaceId The interface identifier, as specified in ERC-165
13    * @dev Interface identification is specified in ERC-165. This function
14    * uses less than 30,000 gas.
15    */
16   function supportsInterface(bytes4 interfaceId)
17     external
18     view
19     returns (bool);
20 }
21 
22 
23 /**
24  * @title ERC721 Non-Fungible Token Standard basic interface
25  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
26  */
27 contract IERC721 is IERC165 {
28 
29   event Transfer(
30     address indexed from,
31     address indexed to,
32     uint256 indexed tokenId
33   );
34   event Approval(
35     address indexed owner,
36     address indexed approved,
37     uint256 indexed tokenId
38   );
39   event ApprovalForAll(
40     address indexed owner,
41     address indexed operator,
42     bool approved
43   );
44 
45   function balanceOf(address owner) public view returns (uint256 balance);
46   function ownerOf(uint256 tokenId) public view returns (address owner);
47 
48   function approve(address to, uint256 tokenId) public;
49   function getApproved(uint256 tokenId)
50     public view returns (address operator);
51 
52   function setApprovalForAll(address operator, bool _approved) public;
53   function isApprovedForAll(address owner, address operator)
54     public view returns (bool);
55 
56   function transferFrom(address from, address to, uint256 tokenId) public;
57   function safeTransferFrom(address from, address to, uint256 tokenId)
58     public;
59 
60   function safeTransferFrom(
61     address from,
62     address to,
63     uint256 tokenId,
64     bytes data
65   )
66     public;
67 }
68 
69 /**
70  * @title ERC721 token receiver interface
71  * @dev Interface for any contract that wants to support safeTransfers
72  * from ERC721 asset contracts.
73  */
74 contract IERC721Receiver {
75   /**
76    * @notice Handle the receipt of an NFT
77    * @dev The ERC721 smart contract calls this function on the recipient
78    * after a `safeTransfer`. This function MUST return the function selector,
79    * otherwise the caller will revert the transaction. The selector to be
80    * returned can be obtained as `this.onERC721Received.selector`. This
81    * function MAY throw to revert and reject the transfer.
82    * Note: the ERC721 contract address is always the message sender.
83    * @param operator The address which called `safeTransferFrom` function
84    * @param from The address which previously owned the token
85    * @param tokenId The NFT identifier which is being transferred
86    * @param data Additional data with no specified format
87    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
88    */
89   function onERC721Received(
90     address operator,
91     address from,
92     uint256 tokenId,
93     bytes data
94   )
95     public
96     returns(bytes4);
97 }
98 
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that revert on error
103  */
104 library SafeMath {
105 
106   /**
107   * @dev Multiplies two numbers, reverts on overflow.
108   */
109   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111     // benefit is lost if 'b' is also tested.
112     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
113     if (a == 0) {
114       return 0;
115     }
116 
117     uint256 c = a * b;
118     require(c / a == b);
119 
120     return c;
121   }
122 
123   /**
124   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
125   */
126   function div(uint256 a, uint256 b) internal pure returns (uint256) {
127     require(b > 0); // Solidity only automatically asserts when dividing by 0
128     uint256 c = a / b;
129     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131     return c;
132   }
133 
134   /**
135   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
136   */
137   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     require(b <= a);
139     uint256 c = a - b;
140 
141     return c;
142   }
143 
144   /**
145   * @dev Adds two numbers, reverts on overflow.
146   */
147   function add(uint256 a, uint256 b) internal pure returns (uint256) {
148     uint256 c = a + b;
149     require(c >= a);
150 
151     return c;
152   }
153 
154   /**
155   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
156   * reverts when dividing by zero.
157   */
158   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159     require(b != 0);
160     return a % b;
161   }
162 }
163 
164 
165 
166 /**
167  * Utility library of inline functions on addresses
168  */
169 library Address {
170 
171   /**
172    * Returns whether the target address is a contract
173    * @dev This function will return false if invoked during the constructor of a contract,
174    * as the code is not actually created until after the constructor finishes.
175    * @param account address of the account to check
176    * @return whether the target address is a contract
177    */
178   function isContract(address account) internal view returns (bool) {
179     uint256 size;
180     // XXX Currently there is no better way to check if there is a contract in an address
181     // than to check the size of the code at that address.
182     // See https://ethereum.stackexchange.com/a/14016/36603
183     // for more details about how this works.
184     // TODO Check this again before the Serenity release, because all addresses will be
185     // contracts then.
186     // solium-disable-next-line security/no-inline-assembly
187     assembly { size := extcodesize(account) }
188     return size > 0;
189   }
190 }
191 
192 /**
193  * @title ERC165
194  * @author Matt Condon (@shrugs)
195  * @dev Implements ERC165 using a lookup table.
196  */
197 contract ERC165 is IERC165 {
198 
199   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
200   /**
201    * 0x01ffc9a7 ===
202    *   bytes4(keccak256('supportsInterface(bytes4)'))
203    */
204 
205   /**
206    * @dev a mapping of interface id to whether or not it's supported
207    */
208   mapping(bytes4 => bool) private _supportedInterfaces;
209 
210   /**
211    * @dev A contract implementing SupportsInterfaceWithLookup
212    * implement ERC165 itself
213    */
214   constructor()
215     internal
216   {
217     _registerInterface(_InterfaceId_ERC165);
218   }
219 
220   /**
221    * @dev implement supportsInterface(bytes4) using a lookup table
222    */
223   function supportsInterface(bytes4 interfaceId)
224     external
225     view
226     returns (bool)
227   {
228     return _supportedInterfaces[interfaceId];
229   }
230 
231   /**
232    * @dev internal method for registering an interface
233    */
234   function _registerInterface(bytes4 interfaceId)
235     internal
236   {
237     require(interfaceId != 0xffffffff);
238     _supportedInterfaces[interfaceId] = true;
239   }
240 }
241 
242 
243 /**
244  * @title ERC721 Non-Fungible Token Standard basic implementation
245  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
246  */
247 contract ERC721 is ERC165, IERC721 {
248 
249   using SafeMath for uint256;
250   using Address for address;
251   
252   string public constant name = "Summa Badges: Dutch Auction";
253   string public constant symbol = "SB:DA";
254   address public SummaAddr = 0xa2760FAE2b10c85D48951b0077AA9cd32954cB88;
255  
256  
257   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
258   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
259   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
260 
261   // Mapping from token ID to owner
262   mapping (uint256 => address) private _tokenOwner;
263 
264   // Mapping from token ID to approved address
265   mapping (uint256 => address) private _tokenApprovals;
266 
267   // Mapping from owner to number of owned token
268   mapping (address => uint256) private _ownedTokensCount;
269 
270   // Mapping from owner to operator approvals
271   mapping (address => mapping (address => bool)) private _operatorApprovals;
272 
273   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
274   /*
275    * 0x80ac58cd ===
276    *   bytes4(keccak256('balanceOf(address)')) ^
277    *   bytes4(keccak256('ownerOf(uint256)')) ^
278    *   bytes4(keccak256('approve(address,uint256)')) ^
279    *   bytes4(keccak256('getApproved(uint256)')) ^
280    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
281    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
282    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
283    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
284    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
285    */
286 
287   constructor() public {
288     // register the supported interfaces to conform to ERC721 via ERC165
289     _registerInterface(_InterfaceId_ERC721);
290     for (uint256 i = 0; i < 10; i++) {
291         _mint(SummaAddr, i);
292     }
293   }
294 
295   /**
296    * @dev Gets the balance of the specified address
297    * @param owner address to query the balance of
298    * @return uint256 representing the amount owned by the passed address
299    */
300   function balanceOf(address owner) public view returns (uint256) {
301     require(owner != address(0));
302     return _ownedTokensCount[owner];
303   }
304 
305   /**
306    * @dev Gets the owner of the specified token ID
307    * @param tokenId uint256 ID of the token to query the owner of
308    * @return owner address currently marked as the owner of the given token ID
309    */
310   function ownerOf(uint256 tokenId) public view returns (address) {
311     address owner = _tokenOwner[tokenId];
312     require(owner != address(0));
313     return owner;
314   }
315 
316   /**
317    * @dev Approves another address to transfer the given token ID
318    * The zero address indicates there is no approved address.
319    * There can only be one approved address per token at a given time.
320    * Can only be called by the token owner or an approved operator.
321    * @param to address to be approved for the given token ID
322    * @param tokenId uint256 ID of the token to be approved
323    */
324   function approve(address to, uint256 tokenId) public {
325     address owner = ownerOf(tokenId);
326     require(to != owner);
327     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
328 
329     _tokenApprovals[tokenId] = to;
330     emit Approval(owner, to, tokenId);
331   }
332 
333   /**
334    * @dev Gets the approved address for a token ID, or zero if no address set
335    * Reverts if the token ID does not exist.
336    * @param tokenId uint256 ID of the token to query the approval of
337    * @return address currently approved for the given token ID
338    */
339   function getApproved(uint256 tokenId) public view returns (address) {
340     require(_exists(tokenId));
341     return _tokenApprovals[tokenId];
342   }
343 
344   /**
345    * @dev Sets or unsets the approval of a given operator
346    * An operator is allowed to transfer all tokens of the sender on their behalf
347    * @param to operator address to set the approval
348    * @param approved representing the status of the approval to be set
349    */
350   function setApprovalForAll(address to, bool approved) public {
351     require(to != msg.sender);
352     _operatorApprovals[msg.sender][to] = approved;
353     emit ApprovalForAll(msg.sender, to, approved);
354   }
355 
356   /**
357    * @dev Tells whether an operator is approved by a given owner
358    * @param owner owner address which you want to query the approval of
359    * @param operator operator address which you want to query the approval of
360    * @return bool whether the given operator is approved by the given owner
361    */
362   function isApprovedForAll(
363     address owner,
364     address operator
365   )
366     public
367     view
368     returns (bool)
369   {
370     return _operatorApprovals[owner][operator];
371   }
372 
373   /**
374    * @dev Transfers the ownership of a given token ID to another address
375    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
376    * Requires the msg sender to be the owner, approved, or operator
377    * @param from current owner of the token
378    * @param to address to receive the ownership of the given token ID
379    * @param tokenId uint256 ID of the token to be transferred
380   */
381   function transferFrom(
382     address from,
383     address to,
384     uint256 tokenId
385   )
386     public
387   {
388     require(_isApprovedOrOwner(msg.sender, tokenId));
389     require(to != address(0));
390 
391     _clearApproval(from, tokenId);
392     _removeTokenFrom(from, tokenId);
393     _addTokenTo(to, tokenId);
394 
395     emit Transfer(from, to, tokenId);
396   }
397 
398   /**
399    * @dev Safely transfers the ownership of a given token ID to another address
400    * If the target address is a contract, it must implement `onERC721Received`,
401    * which is called upon a safe transfer, and return the magic value
402    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
403    * the transfer is reverted.
404    *
405    * Requires the msg sender to be the owner, approved, or operator
406    * @param from current owner of the token
407    * @param to address to receive the ownership of the given token ID
408    * @param tokenId uint256 ID of the token to be transferred
409   */
410   function safeTransferFrom(
411     address from,
412     address to,
413     uint256 tokenId
414   )
415     public
416   {
417     // solium-disable-next-line arg-overflow
418     safeTransferFrom(from, to, tokenId, "");
419   }
420 
421   /**
422    * @dev Safely transfers the ownership of a given token ID to another address
423    * If the target address is a contract, it must implement `onERC721Received`,
424    * which is called upon a safe transfer, and return the magic value
425    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
426    * the transfer is reverted.
427    * Requires the msg sender to be the owner, approved, or operator
428    * @param from current owner of the token
429    * @param to address to receive the ownership of the given token ID
430    * @param tokenId uint256 ID of the token to be transferred
431    * @param _data bytes data to send along with a safe transfer check
432    */
433   function safeTransferFrom(
434     address from,
435     address to,
436     uint256 tokenId,
437     bytes _data
438   )
439     public
440   {
441     transferFrom(from, to, tokenId);
442     // solium-disable-next-line arg-overflow
443     require(_checkOnERC721Received(from, to, tokenId, _data));
444   }
445 
446   /**
447    * @dev Returns whether the specified token exists
448    * @param tokenId uint256 ID of the token to query the existence of
449    * @return whether the token exists
450    */
451   function _exists(uint256 tokenId) internal view returns (bool) {
452     address owner = _tokenOwner[tokenId];
453     return owner != address(0);
454   }
455 
456   /**
457    * @dev Returns whether the given spender can transfer a given token ID
458    * @param spender address of the spender to query
459    * @param tokenId uint256 ID of the token to be transferred
460    * @return bool whether the msg.sender is approved for the given token ID,
461    *  is an operator of the owner, or is the owner of the token
462    */
463   function _isApprovedOrOwner(
464     address spender,
465     uint256 tokenId
466   )
467     internal
468     view
469     returns (bool)
470   {
471     address owner = ownerOf(tokenId);
472     // Disable solium check because of
473     // https://github.com/duaraghav8/Solium/issues/175
474     // solium-disable-next-line operator-whitespace
475     return (
476       spender == owner ||
477       getApproved(tokenId) == spender ||
478       isApprovedForAll(owner, spender)
479     );
480   }
481 
482   /**
483    * @dev Internal function to mint a new token
484    * Reverts if the given token ID already exists
485    * @param to The address that will own the minted token
486    * @param tokenId uint256 ID of the token to be minted by the msg.sender
487    */
488   function _mint(address to, uint256 tokenId) internal {
489     require(to != address(0));
490     _addTokenTo(to, tokenId);
491     emit Transfer(address(0), to, tokenId);
492   }
493 
494   /**
495    * @dev Internal function to burn a specific token
496    * Reverts if the token does not exist
497    * @param tokenId uint256 ID of the token being burned by the msg.sender
498    */
499   function _burn(address owner, uint256 tokenId) internal {
500     _clearApproval(owner, tokenId);
501     _removeTokenFrom(owner, tokenId);
502     emit Transfer(owner, address(0), tokenId);
503   }
504 
505   /**
506    * @dev Internal function to add a token ID to the list of a given address
507    * Note that this function is left internal to make ERC721Enumerable possible, but is not
508    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
509    * @param to address representing the new owner of the given token ID
510    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
511    */
512   function _addTokenTo(address to, uint256 tokenId) internal {
513     require(_tokenOwner[tokenId] == address(0));
514     _tokenOwner[tokenId] = to;
515     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
516   }
517 
518   /**
519    * @dev Internal function to remove a token ID from the list of a given address
520    * Note that this function is left internal to make ERC721Enumerable possible, but is not
521    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
522    * and doesn't clear approvals.
523    * @param from address representing the previous owner of the given token ID
524    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
525    */
526   function _removeTokenFrom(address from, uint256 tokenId) internal {
527     require(ownerOf(tokenId) == from);
528     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
529     _tokenOwner[tokenId] = address(0);
530   }
531 
532   /**
533    * @dev Internal function to invoke `onERC721Received` on a target address
534    * The call is not executed if the target address is not a contract
535    * @param from address representing the previous owner of the given token ID
536    * @param to target address that will receive the tokens
537    * @param tokenId uint256 ID of the token to be transferred
538    * @param _data bytes optional data to send along with the call
539    * @return whether the call correctly returned the expected magic value
540    */
541   function _checkOnERC721Received(
542     address from,
543     address to,
544     uint256 tokenId,
545     bytes _data
546   )
547     internal
548     returns (bool)
549   {
550     if (!to.isContract()) {
551       return true;
552     }
553     bytes4 retval = IERC721Receiver(to).onERC721Received(
554       msg.sender, from, tokenId, _data);
555     return (retval == _ERC721_RECEIVED);
556   }
557 
558   /**
559    * @dev Private function to clear current approval of a given token ID
560    * Reverts if the given address is not indeed the owner of the token
561    * @param owner owner of the token
562    * @param tokenId uint256 ID of the token to be transferred
563    */
564   function _clearApproval(address owner, uint256 tokenId) private {
565     require(ownerOf(tokenId) == owner);
566     if (_tokenApprovals[tokenId] != address(0)) {
567       _tokenApprovals[tokenId] = address(0);
568     }
569   }
570 }