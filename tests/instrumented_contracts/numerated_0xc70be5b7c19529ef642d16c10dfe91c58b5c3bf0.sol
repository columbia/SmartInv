1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Maths
5  * A library to make working with numbers in Solidity hurt your brain less.
6  */
7 library Maths {
8   /**
9    * @dev Adds two addends together, returns the sum
10    * @param addendA the first addend
11    * @param addendB the second addend
12    * @return sum the sum of the equation (e.g. addendA + addendB)
13    */
14   function plus(
15     uint256 addendA,
16     uint256 addendB
17   ) public pure returns (uint256 sum) {
18     sum = addendA + addendB;
19   }
20 
21   /**
22    * @dev Subtracts the minuend from the subtrahend, returns the difference
23    * @param minuend the minuend
24    * @param subtrahend the subtrahend
25    * @return difference the difference (e.g. minuend - subtrahend)
26    */
27   function minus(
28     uint256 minuend,
29     uint256 subtrahend
30   ) public pure returns (uint256 difference) {
31     assert(minuend >= subtrahend);
32     difference = minuend - subtrahend;
33   }
34 
35   /**
36    * @dev Multiplies two factors, returns the product
37    * @param factorA the first factor
38    * @param factorB the second factor
39    * @return product the product of the equation (e.g. factorA * factorB)
40    */
41   function mul(
42     uint256 factorA,
43     uint256 factorB
44   ) public pure returns (uint256 product) {
45     if (factorA == 0 || factorB == 0) return 0;
46     product = factorA * factorB;
47     assert(product / factorA == factorB);
48   }
49 
50   /**
51    * @dev Multiplies two factors, returns the product
52    * @param factorA the first factor
53    * @param factorB the second factor
54    * @return product the product of the equation (e.g. factorA * factorB)
55    */
56   function times(
57     uint256 factorA,
58     uint256 factorB
59   ) public pure returns (uint256 product) {
60     return mul(factorA, factorB);
61   }
62 
63   /**
64    * @dev Divides the dividend by divisor, returns the truncated quotient
65    * @param dividend the dividend
66    * @param divisor the divisor
67    * @return quotient the quotient of the equation (e.g. dividend / divisor)
68    */
69   function div(
70     uint256 dividend,
71     uint256 divisor
72   ) public pure returns (uint256 quotient) {
73     quotient = dividend / divisor;
74     assert(quotient * divisor == dividend);
75   }
76 
77   /**
78    * @dev Divides the dividend by divisor, returns the truncated quotient
79    * @param dividend the dividend
80    * @param divisor the divisor
81    * @return quotient the quotient of the equation (e.g. dividend / divisor)
82    */
83   function dividedBy(
84     uint256 dividend,
85     uint256 divisor
86   ) public pure returns (uint256 quotient) {
87     return div(dividend, divisor);
88   }
89 
90   /**
91    * @dev Divides the dividend by divisor, returns the quotient and remainder
92    * @param dividend the dividend
93    * @param divisor the divisor
94    * @return quotient the quotient of the equation (e.g. dividend / divisor)
95    * @return remainder the remainder of the equation (e.g. dividend % divisor)
96    */
97   function divideSafely(
98     uint256 dividend,
99     uint256 divisor
100   ) public pure returns (uint256 quotient, uint256 remainder) {
101     quotient = div(dividend, divisor);
102     remainder = dividend % divisor;
103   }
104 
105   /**
106    * @dev Returns the lesser of two values.
107    * @param a the first value
108    * @param b the second value
109    * @return result the lesser of the two values
110    */
111   function min(
112     uint256 a,
113     uint256 b
114   ) public pure returns (uint256 result) {
115     result = a <= b ? a : b;
116   }
117 
118   /**
119    * @dev Returns the greater of two values.
120    * @param a the first value
121    * @param b the second value
122    * @return result the greater of the two values
123    */
124   function max(
125     uint256 a,
126     uint256 b
127   ) public pure returns (uint256 result) {
128     result = a >= b ? a : b;
129   }
130 
131   /**
132    * @dev Determines whether a value is less than another.
133    * @param a the first value
134    * @param b the second value
135    * @return isTrue whether a is less than b
136    */
137   function isLessThan(uint256 a, uint256 b) public pure returns (bool isTrue) {
138     isTrue = a < b;
139   }
140 
141   /**
142    * @dev Determines whether a value is equal to or less than another.
143    * @param a the first value
144    * @param b the second value
145    * @return isTrue whether a is less than or equal to b
146    */
147   function isAtMost(uint256 a, uint256 b) public pure returns (bool isTrue) {
148     isTrue = a <= b;
149   }
150 
151   /**
152    * @dev Determines whether a value is greater than another.
153    * @param a the first value
154    * @param b the second value
155    * @return isTrue whether a is greater than b
156    */
157   function isGreaterThan(uint256 a, uint256 b) public pure returns (bool isTrue) {
158     isTrue = a > b;
159   }
160 
161   /**
162    * @dev Determines whether a value is equal to or greater than another.
163    * @param a the first value
164    * @param b the second value
165    * @return isTrue whether a is less than b
166    */
167   function isAtLeast(uint256 a, uint256 b) public pure returns (bool isTrue) {
168     isTrue = a >= b;
169   }
170 }
171 
172 /**
173  * @title Manageable
174  */
175 contract Manageable {
176   address public owner;
177   address public manager;
178 
179   event OwnershipChanged(address indexed previousOwner, address indexed newOwner);
180   event ManagementChanged(address indexed previousManager, address indexed newManager);
181 
182   /**
183    * @dev The Manageable constructor sets the original `owner` of the contract to the sender
184    * account.
185    */
186   function Manageable() public {
187     owner = msg.sender;
188     manager = msg.sender;
189   }
190 
191   /**
192    * @dev Throws if called by any account other than the owner or manager.
193    */
194   modifier onlyManagement() {
195     require(msg.sender == owner || msg.sender == manager);
196     _;
197   }
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) public onlyOwner {
212     require(newOwner != address(0));
213     emit OwnershipChanged(owner, newOwner);
214     owner = newOwner;
215   }
216 
217   /**
218    * @dev Allows the owner or manager to replace the current manager
219    * @param newManager The address to give contract management rights.
220    */
221   function replaceManager(address newManager) public onlyManagement {
222     require(newManager != address(0));
223     emit ManagementChanged(manager, newManager);
224     manager = newManager;
225   }
226 }
227 
228 /**
229  * @title ERC721 Non-Fungible Token Standard basic interface
230  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
231  */
232 contract ERC721Basic {
233   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
234   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
235   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
236 
237   function balanceOf(address _owner) public view returns (uint256 _balance);
238   function ownerOf(uint256 _tokenId) public view returns (address _owner);
239   function exists(uint256 _tokenId) public view returns (bool _exists);
240 
241   function approve(address _to, uint256 _tokenId) public;
242   function getApproved(uint256 _tokenId) public view returns (address _operator);
243 
244   function setApprovalForAll(address _operator, bool _approved) public;
245   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
246 
247   function transferFrom(address _from, address _to, uint256 _tokenId) public;
248   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
249   function safeTransferFrom(
250     address _from,
251     address _to,
252     uint256 _tokenId,
253     bytes _data
254   ) public;
255 }
256 
257 /**
258  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
259  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
260  */
261 contract ERC721Enumerable is ERC721Basic {
262   function totalSupply() public view returns (uint256);
263   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
264   function tokenByIndex(uint256 _index) public view returns (uint256);
265 }
266 
267 
268 /**
269  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
270  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
271  */
272 contract ERC721Metadata is ERC721Basic {
273   function tokenURI(uint256 _tokenId) public view returns (string);
274 }
275 
276 
277 /**
278  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
279  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
280  */
281 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
282 }
283 
284 /**
285  * @title ERC721 token receiver interface
286  * @dev Interface for any contract that wants to support safeTransfers
287  *  from ERC721 asset contracts.
288  */
289 contract ERC721Receiver {
290   /**
291    * @dev Magic value to be returned upon successful reception of an NFT
292    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
293    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
294    */
295   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
296 
297   /**
298    * @notice Handle the receipt of an NFT
299    * @dev The ERC721 smart contract calls this function on the recipient
300    *  after a `safetransfer`. This function MAY throw to revert and reject the
301    *  transfer. This function MUST use 50,000 gas or less. Return of other
302    *  than the magic value MUST result in the transaction being reverted.
303    *  Note: the contract address is always the message sender.
304    * @param _from The sending address
305    * @param _tokenId The NFT identifier which is being transfered
306    * @param _data Additional data with no specified format
307    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
308    */
309   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
310 }
311 
312 /**
313  * @title ERC721 Non-Fungible Token Standard basic implementation
314  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
315  */
316 contract ERC721BasicToken is ERC721Basic {
317   using Maths for uint256;
318 
319   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
320   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
321   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
322 
323   // Mapping from token ID to owner
324   mapping (uint256 => address) internal tokenOwner;
325 
326   // Mapping from token ID to approved address
327   mapping (uint256 => address) internal tokenApprovals;
328 
329   // Mapping from owner to number of owned token
330   mapping (address => uint256) internal ownedTokensCount;
331 
332   // Mapping from owner to operator approvals
333   mapping (address => mapping (address => bool)) internal operatorApprovals;
334 
335   /**
336    * @dev Guarantees msg.sender is owner of the given token
337    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
338    */
339   modifier onlyOwnerOf(uint256 _tokenId) {
340     require(ownerOf(_tokenId) == msg.sender);
341     _;
342   }
343 
344   /**
345    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
346    * @param _tokenId uint256 ID of the token to validate
347    */
348   modifier canTransfer(uint256 _tokenId) {
349     require(isApprovedOrOwner(msg.sender, _tokenId));
350     _;
351   }
352 
353   /**
354    * @dev Gets the balance of the specified address
355    * @param _owner address to query the balance of
356    * @return uint256 representing the amount owned by the passed address
357    */
358   function balanceOf(address _owner) public view returns (uint256) {
359     require(_owner != address(0));
360     return ownedTokensCount[_owner];
361   }
362 
363   /**
364    * @dev Gets the owner of the specified token ID
365    * @param _tokenId uint256 ID of the token to query the owner of
366    * @return owner address currently marked as the owner of the given token ID
367    */
368   function ownerOf(uint256 _tokenId) public view returns (address) {
369     address holder = tokenOwner[_tokenId];
370     require(holder != address(0));
371     return holder;
372   }
373 
374   /**
375    * @dev Returns whether the specified token exists
376    * @param _tokenId uint256 ID of the token to query the existance of
377    * @return whether the token exists
378    */
379   function exists(uint256 _tokenId) public view returns (bool) {
380     address holder = tokenOwner[_tokenId];
381     return holder != address(0);
382   }
383 
384   /**
385    * @dev Approves another address to transfer the given token ID
386    * @dev The zero address indicates there is no approved address.
387    * @dev There can only be one approved address per token at a given time.
388    * @dev Can only be called by the token owner or an approved operator.
389    * @param _to address to be approved for the given token ID
390    * @param _tokenId uint256 ID of the token to be approved
391    */
392   function approve(address _to, uint256 _tokenId) public {
393     address holder = ownerOf(_tokenId);
394     require(_to != holder);
395     require(msg.sender == holder || isApprovedForAll(holder, msg.sender));
396 
397     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
398       tokenApprovals[_tokenId] = _to;
399       emit Approval(holder, _to, _tokenId);
400     }
401   }
402 
403   /**
404    * @dev Gets the approved address for a token ID, or zero if no address set
405    * @param _tokenId uint256 ID of the token to query the approval of
406    * @return address currently approved for a the given token ID
407    */
408   function getApproved(uint256 _tokenId) public view returns (address) {
409     return tokenApprovals[_tokenId];
410   }
411 
412   /**
413    * @dev Sets or unsets the approval of a given operator
414    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
415    * @param _to operator address to set the approval
416    * @param _approved representing the status of the approval to be set
417    */
418   function setApprovalForAll(address _to, bool _approved) public {
419     require(_to != msg.sender);
420     operatorApprovals[msg.sender][_to] = _approved;
421     emit ApprovalForAll(msg.sender, _to, _approved);
422   }
423 
424   /**
425    * @dev Tells whether an operator is approved by a given owner
426    * @param _owner owner address which you want to query the approval of
427    * @param _operator operator address which you want to query the approval of
428    * @return bool whether the given operator is approved by the given owner
429    */
430   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
431     return operatorApprovals[_owner][_operator];
432   }
433 
434   /**
435    * @dev Transfers the ownership of a given token ID to another address
436    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
437    * @dev Requires the msg sender to be the owner, approved, or operator
438    * @param _from current owner of the token
439    * @param _to address to receive the ownership of the given token ID
440    * @param _tokenId uint256 ID of the token to be transferred
441   */
442   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
443     require(_from != address(0));
444     require(_to != address(0));
445 
446     clearApproval(_from, _tokenId);
447     removeTokenFrom(_from, _tokenId);
448     addTokenTo(_to, _tokenId);
449 
450     emit Transfer(_from, _to, _tokenId);
451   }
452 
453   /**
454    * @dev Safely transfers the ownership of a given token ID to another address
455    * @dev If the target address is a contract, it must implement `onERC721Received`,
456    *  which is called upon a safe transfer, and return the magic value
457    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
458    *  the transfer is reverted.
459    * @dev Requires the msg sender to be the owner, approved, or operator
460    * @param _from current owner of the token
461    * @param _to address to receive the ownership of the given token ID
462    * @param _tokenId uint256 ID of the token to be transferred
463   */
464   function safeTransferFrom(
465     address _from,
466     address _to,
467     uint256 _tokenId
468   )
469     public
470     canTransfer(_tokenId)
471   {
472     // solium-disable-next-line arg-overflow
473     safeTransferFrom(_from, _to, _tokenId, "");
474   }
475 
476   /**
477    * @dev Safely transfers the ownership of a given token ID to another address
478    * @dev If the target address is a contract, it must implement `onERC721Received`,
479    *  which is called upon a safe transfer, and return the magic value
480    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
481    *  the transfer is reverted.
482    * @dev Requires the msg sender to be the owner, approved, or operator
483    * @param _from current owner of the token
484    * @param _to address to receive the ownership of the given token ID
485    * @param _tokenId uint256 ID of the token to be transferred
486    * @param _data bytes data to send along with a safe transfer check
487    */
488   function safeTransferFrom(
489     address _from,
490     address _to,
491     uint256 _tokenId,
492     bytes _data
493   )
494     public
495     canTransfer(_tokenId)
496   {
497     transferFrom(_from, _to, _tokenId);
498     // solium-disable-next-line arg-overflow
499     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
500   }
501 
502   /**
503    * @dev Returns whether the given spender can transfer a given token ID
504    * @param _spender address of the spender to query
505    * @param _tokenId uint256 ID of the token to be transferred
506    * @return bool whether the msg.sender is approved for the given token ID,
507    *  is an operator of the owner, or is the owner of the token
508    */
509   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
510     address holder = ownerOf(_tokenId);
511     return _spender == holder || getApproved(_tokenId) == _spender || isApprovedForAll(holder, _spender);
512   }
513 
514   /**
515    * @dev Internal function to mint a new token
516    * @dev Reverts if the given token ID already exists
517    * @param _to The address that will own the minted token
518    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
519    */
520   function _mint(address _to, uint256 _tokenId) internal {
521     require(_to != address(0));
522     addTokenTo(_to, _tokenId);
523     emit Transfer(address(0), _to, _tokenId);
524   }
525 
526   /**
527    * @dev Internal function to burn a specific token
528    * @dev Reverts if the token does not exist
529    * @param _tokenId uint256 ID of the token being burned by the msg.sender
530    */
531   function _burn(address _owner, uint256 _tokenId) internal {
532     clearApproval(_owner, _tokenId);
533     removeTokenFrom(_owner, _tokenId);
534     emit Transfer(_owner, address(0), _tokenId);
535   }
536 
537   /**
538    * @dev Internal function to clear current approval of a given token ID
539    * @dev Reverts if the given address is not indeed the owner of the token
540    * @param _owner owner of the token
541    * @param _tokenId uint256 ID of the token to be transferred
542    */
543   function clearApproval(address _owner, uint256 _tokenId) internal {
544     require(ownerOf(_tokenId) == _owner);
545     if (tokenApprovals[_tokenId] != address(0)) {
546       tokenApprovals[_tokenId] = address(0);
547       emit Approval(_owner, address(0), _tokenId);
548     }
549   }
550 
551   /**
552    * @dev Internal function to add a token ID to the list of a given address
553    * @param _to address representing the new owner of the given token ID
554    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
555    */
556   function addTokenTo(address _to, uint256 _tokenId) internal {
557     require(tokenOwner[_tokenId] == address(0));
558     tokenOwner[_tokenId] = _to;
559     ownedTokensCount[_to] = ownedTokensCount[_to].plus(1);
560   }
561 
562   /**
563    * @dev Internal function to remove a token ID from the list of a given address
564    * @param _from address representing the previous owner of the given token ID
565    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
566    */
567   function removeTokenFrom(address _from, uint256 _tokenId) internal {
568     require(ownerOf(_tokenId) == _from);
569     ownedTokensCount[_from] = ownedTokensCount[_from].minus(1);
570     tokenOwner[_tokenId] = address(0);
571   }
572 
573   /**
574    * @dev Internal function to invoke `onERC721Received` on a target address
575    * @dev The call is not executed if the target address is not a contract
576    * @param _from address representing the previous owner of the given token ID
577    * @param _to target address that will receive the tokens
578    * @param _tokenId uint256 ID of the token to be transferred
579    * @param _data bytes optional data to send along with the call
580    * @return whether the call correctly returned the expected magic value
581    */
582   function checkAndCallSafeTransfer(
583     address _from,
584     address _to,
585     uint256 _tokenId,
586     bytes _data
587   )
588     internal
589     returns (bool)
590   {
591     if (!isContract(_to)) {
592       return true;
593     }
594     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
595     return (retval == ERC721_RECEIVED);
596   }
597 
598   /**
599    * Returns whether the target address is a contract
600    * @dev This function will return false if invoked during the constructor of a contract,
601    *  as the code is not actually created until after the constructor finishes.
602    * @param addr address to check
603    * @return whether the target address is a contract
604    */
605   function isContract(address addr) internal view returns (bool) {
606     uint256 size;
607     // XXX Currently there is no better way to check if there is a contract in an address
608     // than to check the size of the code at that address.
609     // See https://ethereum.stackexchange.com/a/14016/36603
610     // for more details about how this works.
611     // TODO Check this again before the Serenity release, because all addresses will be
612     // contracts then.
613     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
614     return size > 0;
615   }
616 }
617 
618 /**
619  * @title Full ERC721 Token
620  * This implementation includes all the required and some optional functionality of the ERC721 standard
621  * Moreover, it includes approve all functionality using operator terminology
622  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
623  */
624 contract ERC721Token is ERC721, ERC721BasicToken {
625   // Mapping from owner to list of owned token IDs
626   mapping (address => uint256[]) internal ownedTokens;
627 
628   // Mapping from token ID to index of the owner tokens list
629   mapping(uint256 => uint256) internal ownedTokensIndex;
630 
631   // Array with all token ids, used for enumeration
632   uint256[] internal allTokens;
633 
634   // Mapping from token id to position in the allTokens array
635   mapping(uint256 => uint256) internal allTokensIndex;
636 
637   // Optional mapping for token URIs
638   mapping(uint256 => string) internal tokenURIs;
639 
640   /**
641    * @dev Constructor function
642    */
643   function ERC721Token() public { }
644 
645   /**
646    * @dev Returns an URI for a given token ID
647    * @dev Throws if the token ID does not exist. May return an empty string.
648    * @param _tokenId uint256 ID of the token to query
649    */
650   function tokenURI(uint256 _tokenId) public view returns (string) {
651     require(exists(_tokenId));
652     return tokenURIs[_tokenId];
653   }
654 
655   /**
656    * @dev Gets a list of token IDs owned by the requested address
657    * @param _owner address owning the tokens list to be accessed
658    * @return uint256[] list of token IDs owned by the requested address
659    */
660   function tokensOf(address _owner) public view returns (uint256[]) {
661     return ownedTokens[_owner];
662   }
663 
664   /**
665    * @dev Gets the token ID at a given index of the tokens list of the requested owner
666    * @param _owner address owning the tokens list to be accessed
667    * @param _index uint256 representing the index to be accessed of the requested tokens list
668    * @return uint256 token ID at the given index of the tokens list owned by the requested address
669    */
670   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
671     require(_index < balanceOf(_owner));
672     return ownedTokens[_owner][_index];
673   }
674 
675   /**
676    * @dev Gets the total amount of tokens stored by the contract
677    * @return uint256 representing the total amount of tokens
678    */
679   function totalSupply() public view returns (uint256) {
680     return allTokens.length;
681   }
682 
683   /**
684    * @dev Gets the token ID at a given index of all the tokens in this contract
685    * @dev Reverts if the index is greater or equal to the total number of tokens
686    * @param _index uint256 representing the index to be accessed of the tokens list
687    * @return uint256 token ID at the given index of the tokens list
688    */
689   function tokenByIndex(uint256 _index) public view returns (uint256) {
690     require(_index < totalSupply());
691     return allTokens[_index];
692   }
693 
694   /**
695    * @dev Internal function to set the token URI for a given token
696    * @dev Reverts if the token ID does not exist
697    * @param _tokenId uint256 ID of the token to set its URI
698    * @param _uri string URI to assign
699    */
700   function _setTokenURI(uint256 _tokenId, string _uri) internal {
701     require(exists(_tokenId));
702     tokenURIs[_tokenId] = _uri;
703   }
704 
705   /**
706    * @dev Internal function to add a token ID to the list of a given address
707    * @param _to address representing the new owner of the given token ID
708    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
709    */
710   function addTokenTo(address _to, uint256 _tokenId) internal {
711     super.addTokenTo(_to, _tokenId);
712     uint256 length = ownedTokens[_to].length;
713     ownedTokens[_to].push(_tokenId);
714     ownedTokensIndex[_tokenId] = length;
715   }
716 
717   /**
718    * @dev Internal function to remove a token ID from the list of a given address
719    * @param _from address representing the previous owner of the given token ID
720    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
721    */
722   function removeTokenFrom(address _from, uint256 _tokenId) internal {
723     super.removeTokenFrom(_from, _tokenId);
724 
725     uint256 tokenIndex = ownedTokensIndex[_tokenId];
726     uint256 lastTokenIndex = ownedTokens[_from].length.minus(1);
727     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
728 
729     ownedTokens[_from][tokenIndex] = lastToken;
730     ownedTokens[_from][lastTokenIndex] = 0;
731     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
732     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
733     // the lastToken to the first position, and then dropping the element placed in the last position of the list
734 
735     ownedTokens[_from].length--;
736     ownedTokensIndex[_tokenId] = 0;
737     ownedTokensIndex[lastToken] = tokenIndex;
738   }
739 
740   /**
741    * @dev Internal function to mint a new token
742    * @dev Reverts if the given token ID already exists
743    * @param _to address the beneficiary that will own the minted token
744    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
745    */
746   function _mint(address _to, uint256 _tokenId) internal {
747     super._mint(_to, _tokenId);
748 
749     allTokensIndex[_tokenId] = allTokens.length;
750     allTokens.push(_tokenId);
751   }
752 
753   /**
754    * @dev Internal function to burn a specific token
755    * @dev Reverts if the token does not exist
756    * @param _owner owner of the token to burn
757    * @param _tokenId uint256 ID of the token being burned by the msg.sender
758    */
759   function _burn(address _owner, uint256 _tokenId) internal {
760     super._burn(_owner, _tokenId);
761 
762     // Clear metadata (if any)
763     if (bytes(tokenURIs[_tokenId]).length != 0) {
764       delete tokenURIs[_tokenId];
765     }
766 
767     // Reorg all tokens array
768     uint256 tokenIndex = allTokensIndex[_tokenId];
769     uint256 lastTokenIndex = allTokens.length.minus(1);
770     uint256 lastToken = allTokens[lastTokenIndex];
771 
772     allTokens[tokenIndex] = lastToken;
773     allTokens[lastTokenIndex] = 0;
774 
775     allTokens.length--;
776     allTokensIndex[_tokenId] = 0;
777     allTokensIndex[lastToken] = tokenIndex;
778   }
779 
780 }
781 
782 contract CardToken is ERC721Token, Manageable {
783   string public constant name = "Mythereum Card";
784   string public constant symbol = "CARD";
785 
786   mapping (uint8 => string) public className;
787   mapping (uint8 => Card[]) public cardsInEdition;
788   uint8 public latestEditionReleased;
789 
790   struct Card {
791     string    name;
792     uint8     class;
793     uint8     classVariant;
794     uint256   damagePoints;
795     uint256   shieldPoints;
796     uint256   abilityId;
797   }
798 
799   struct Ability {
800     string  name;
801     bool    canBeBlocked;
802     uint8   blackMagicCost;
803     uint8   grayMagicCost;
804     uint8   whiteMagicCost;
805     uint256 addedDamage;
806     uint256 addedShield;
807   }
808 
809   Card[] public cards;
810   Ability[] public abilities;
811 
812   function isEditionAvailable(uint8 _editionNumber) public view returns (bool) {
813     return _editionNumber <= latestEditionReleased;
814   }
815 
816   function mintRandomCards(
817     address _owner,
818     uint8 _editionNumber,
819     uint8 _numCards
820   ) public onlyManagement returns (bool) {
821     require(isEditionAvailable(_editionNumber));
822     for(uint8 i = 0; i < _numCards; i++) {
823       Card storage card = cardsInEdition[_editionNumber][
824         uint256(keccak256(now, _owner, _editionNumber, _numCards, i)) % cardsInEdition[_editionNumber].length
825       ];
826 
827       _cloneCard(card, _owner);
828     }
829     return true;
830   }
831 
832   function mintSpecificCard(
833     address _owner,
834     uint8   _editionNumber,
835     uint256 _cardIndex
836   ) public onlyManagement returns (bool) {
837     require(isEditionAvailable(_editionNumber));
838     require(_cardIndex < cardsInEdition[_editionNumber].length);
839     _cloneCard(cardsInEdition[_editionNumber][_cardIndex], _owner);
840   }
841 
842   function mintSpecificCards(
843     address   _owner,
844     uint8     _editionNumber,
845     uint256[] _cardIndexes
846   ) public onlyManagement returns (bool) {
847     require(isEditionAvailable(_editionNumber));
848     require(_cardIndexes.length > 0 && _cardIndexes.length <= 10);
849 
850     for(uint8 i = 0; i < _cardIndexes.length; i++) {
851       require(_cardIndexes[i] < cardsInEdition[_editionNumber].length);
852       _cloneCard(cardsInEdition[_editionNumber][_cardIndexes[i]], _owner);
853     }
854   }
855 
856   function improveCard(
857     uint256 _tokenId,
858     uint256 _addedDamage,
859     uint256 _addedShield
860   ) public onlyManagement returns (bool) {
861     require(exists(_tokenId));
862     Card storage card = cards[_tokenId];
863     card.damagePoints = card.damagePoints.plus(_addedDamage);
864     card.shieldPoints = card.shieldPoints.plus(_addedShield);
865     return true;
866   }
867 
868   function destroyCard(uint256 _tokenId) public onlyManagement returns (bool) {
869     require(exists(_tokenId));
870     _burn(ownerOf(_tokenId), _tokenId);
871     return true;
872   }
873 
874   function setLatestEdition(uint8 _editionNumber) public onlyManagement {
875     require(cardsInEdition[_editionNumber].length.isAtLeast(1));
876     latestEditionReleased = _editionNumber;
877   }
878 
879   function setTokenURI(uint256 _tokenId, string _uri) public onlyManagement {
880     require(exists(_tokenId));
881     tokenURIs[_tokenId] = _uri;
882   }
883 
884   function addAbility(
885     string  _name,
886     bool    _canBeBlocked,
887     uint8   _blackMagicCost,
888     uint8   _grayMagicCost,
889     uint8   _whiteMagicCost,
890     uint256 _addedDamage,
891     uint256 _addedShield
892   ) public onlyManagement {
893     abilities.push(
894       Ability(
895         _name,
896         _canBeBlocked,
897         _blackMagicCost,
898         _grayMagicCost,
899         _whiteMagicCost,
900         _addedDamage,
901         _addedShield
902       )
903     );
904   }
905 
906   function replaceAbility(
907     uint256 _abilityId,
908     string  _name,
909     bool    _canBeBlocked,
910     uint8   _blackMagicCost,
911     uint8   _grayMagicCost,
912     uint8   _whiteMagicCost,
913     uint256 _addedDamage,
914     uint256 _addedShield
915   ) public onlyManagement {
916     require(_abilityId.isLessThan(abilities.length));
917     abilities[_abilityId].name           = _name;
918     abilities[_abilityId].canBeBlocked   = _canBeBlocked;
919     abilities[_abilityId].blackMagicCost = _blackMagicCost;
920     abilities[_abilityId].grayMagicCost  = _grayMagicCost;
921     abilities[_abilityId].whiteMagicCost = _whiteMagicCost;
922     abilities[_abilityId].addedDamage    = _addedDamage;
923     abilities[_abilityId].addedShield    = _addedShield;
924   }
925 
926   function addCardToEdition(
927     uint8   _editionNumber,
928     string  _name,
929     uint8   _classId,
930     uint8   _classVariant,
931     uint256 _damagePoints,
932     uint256 _shieldPoints,
933     uint256 _abilityId
934   ) public onlyManagement {
935     require(_abilityId.isLessThan(abilities.length));
936 
937     cardsInEdition[_editionNumber].push(
938       Card({
939         name:         _name,
940         class:        _classId,
941         classVariant: _classVariant,
942         damagePoints: _damagePoints,
943         shieldPoints: _shieldPoints,
944         abilityId:    _abilityId
945       })
946     );
947   }
948 
949   function setClassName(uint8 _classId, string _name) public onlyManagement {
950     className[_classId] = _name;
951   }
952 
953   function _cloneCard(Card storage card, address owner) internal {
954     require(card.damagePoints > 0 || card.shieldPoints > 0);
955     uint256 tokenId = cards.length;
956     cards.push(card);
957     _mint(owner, tokenId);
958   }
959 }