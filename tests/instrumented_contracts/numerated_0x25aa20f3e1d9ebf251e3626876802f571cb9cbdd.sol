1 pragma solidity ^0.4.7;
2 
3 
4 /**
5  * @title ERC165
6  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
7  */
8 interface ERC165 {
9 
10   /**
11    * @notice Query if a contract implements an interface
12    * @param _interfaceId The interface identifier, as specified in ERC-165
13    * @dev Interface identification is specified in ERC-165. This function
14    * uses less than 30,000 gas.
15    */
16   function supportsInterface(bytes4 _interfaceId)
17     external
18     view
19     returns (bool);
20 }
21 
22 
23 
24 /**
25  * @title SupportsInterfaceWithLookup
26  * @author Matt Condon (@shrugs)
27  * @dev Implements ERC165 using a lookup table.
28  */
29 contract SupportsInterfaceWithLookup is ERC165 {
30 
31   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
32   /**
33    * 0x01ffc9a7 ===
34    *   bytes4(keccak256('supportsInterface(bytes4)'))
35    */
36 
37   /**
38    * @dev a mapping of interface id to whether or not it's supported
39    */
40   mapping(bytes4 => bool) internal supportedInterfaces;
41 
42   /**
43    * @dev A contract implementing SupportsInterfaceWithLookup
44    * implement ERC165 itself
45    */
46   constructor()
47     public
48   {
49     _registerInterface(InterfaceId_ERC165);
50   }
51 
52   /**
53    * @dev implement supportsInterface(bytes4) using a lookup table
54    */
55   function supportsInterface(bytes4 _interfaceId)
56     external
57     view
58     returns (bool)
59   {
60     return supportedInterfaces[_interfaceId];
61   }
62 
63   /**
64    * @dev private method for registering an interface
65    */
66   function _registerInterface(bytes4 _interfaceId)
67     internal
68   {
69     require(_interfaceId != 0xffffffff);
70     supportedInterfaces[_interfaceId] = true;
71   }
72 }
73 
74 
75 
76 /**
77  * @title ERC721 Non-Fungible Token Standard basic interface
78  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
79  */
80 contract ERC721Basic is ERC165 {
81 
82   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
83   /*
84    * 0x80ac58cd ===
85    *   bytes4(keccak256('balanceOf(address)')) ^
86    *   bytes4(keccak256('ownerOf(uint256)')) ^
87    *   bytes4(keccak256('approve(address,uint256)')) ^
88    *   bytes4(keccak256('getApproved(uint256)')) ^
89    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
90    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
91    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
92    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
93    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
94    */
95 
96   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
97   /*
98    * 0x4f558e79 ===
99    *   bytes4(keccak256('exists(uint256)'))
100    */
101 
102   event Transfer(
103     address indexed _from,
104     address indexed _to,
105     uint256 indexed _tokenId
106   );
107   event Approval(
108     address indexed _owner,
109     address indexed _approved,
110     uint256 indexed _tokenId
111   );
112   event ApprovalForAll(
113     address indexed _owner,
114     address indexed _operator,
115     bool _approved
116   );
117 
118   function balanceOf(address _owner) public view returns (uint256 _balance);
119   function ownerOf(uint256 _tokenId) public view returns (address _owner);
120   function exists(uint256 _tokenId) public view returns (bool _exists);
121 
122   function approve(address _to, uint256 _tokenId) public;
123   function getApproved(uint256 _tokenId)
124     public view returns (address _operator);
125 
126   function setApprovalForAll(address _operator, bool _approved) public;
127   function isApprovedForAll(address _owner, address _operator)
128     public view returns (bool);
129 
130   function transferFrom(address _from, address _to, uint256 _tokenId) public;
131   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
132     public;
133 
134   function safeTransferFrom(
135     address _from,
136     address _to,
137     uint256 _tokenId,
138     bytes _data
139   )
140     public;
141 }
142 
143 
144 
145 /**
146  * @title ERC721 token receiver interface
147  * @dev Interface for any contract that wants to support safeTransfers
148  * from ERC721 asset contracts.
149  */
150 contract ERC721Receiver {
151   /**
152    * @notice Handle the receipt of an NFT
153    * @dev The ERC721 smart contract calls this function on the recipient
154    * after a `safetransfer`. This function MAY throw to revert and reject the
155    * transfer. Return of other than the magic value MUST result in the
156    * transaction being reverted.
157    * Note: the contract address is always the message sender.
158    * @param _operator The address which called `safeTransferFrom` function
159    * @param _from The address which previously owned the token
160    * @param _tokenId The NFT identifier which is being transferred
161    * @param _data Additional data with no specified format
162    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
163    */
164   function onERC721Received(
165     address _operator,
166     address _from,
167     uint256 _tokenId,
168     bytes _data
169   )
170     public
171     returns(bytes4);
172 }
173 
174 
175 
176 contract Ownable {
177   address public owner;
178 
179   constructor() public {
180     owner = msg.sender;
181   }
182 
183   modifier onlyOwner() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188   function transferOwnership(address newOwner) public onlyOwner {
189     if (newOwner != address(0)) {
190       owner = newOwner;
191     }
192   }
193 
194 }
195 
196 
197          
198 
199 contract ivtk is SupportsInterfaceWithLookup, ERC721Basic, Ownable {
200     struct invoiceInfo {
201         bytes32 custID;
202         bytes32 docDate;
203         bytes32 invDate;
204         bytes32[] aErc20Tx;
205         uint[] aQty;
206         uint[] aSalePrice2dec;
207         uint[] aAmtExc2dec;
208         uint[] aAmtInc2dec;
209     }
210     
211     invoiceInfo[] aInvoices;
212     
213 
214     string public name;
215     string public symbol;
216     
217     
218     
219     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
220     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
221     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
222   
223     // Mapping from token ID to owner
224     mapping (uint256 => address) internal tokenOwner;
225 
226     // Mapping from token ID to approved address
227     mapping (uint256 => address) internal tokenApprovals;
228 
229     // Mapping from owner to number of owned token
230     mapping (address => uint256) internal ownedTokensCount;
231 
232     // Mapping from owner to operator approvals
233     mapping (address => mapping (address => bool)) internal operatorApprovals;
234   
235     
236     constructor() public {
237         name = "IV TokenII";
238         symbol = "iv";
239         
240         // register the supported interfaces to conform to ERC721 via ERC165
241         _registerInterface(InterfaceId_ERC721);
242         _registerInterface(InterfaceId_ERC721Exists);
243     }
244     
245     function implementsERC721() public pure returns (bool)
246     {
247         return true;
248     }
249     
250     
251     function totalSupply() public view returns (uint256) {
252         return aInvoices.length;
253     }
254     
255     function getItemByTokenID(uint256 _tokenId) public view returns (
256         bytes32 custID,
257         bytes32 docDate,
258         bytes32 invDate,
259         bytes32[] aErc20Tx,
260         uint[] aQty,
261         uint[] aSalePrice2dec,
262         uint[] aAmtExc2dec,
263         uint[] aAmtInc2dec
264         ) {
265         
266         require(_tokenId > 0);
267         
268         invoiceInfo storage ivInfo = aInvoices[_tokenId - 1];
269         
270         return (
271             ivInfo.custID,
272             ivInfo.docDate,
273             ivInfo.invDate,
274             ivInfo.aErc20Tx,
275             ivInfo.aQty,
276             ivInfo.aSalePrice2dec,
277             ivInfo.aAmtExc2dec,
278             ivInfo.aAmtInc2dec
279         );
280     }
281     
282     
283     function addData(
284         bytes32 custID,
285         bytes32 docDate,
286         bytes32 invDate,
287         bytes32[] aErc20Tx,
288         uint[] aQty,
289         uint[] aSalePrice2dec,
290         uint[] aAmtExc2dec,
291         uint[] aAmtInc2dec
292         ) 
293         public 
294         onlyOwner
295         {
296             
297             
298         
299         invoiceInfo memory ivInfo = invoiceInfo({
300             custID: custID,
301             docDate: docDate,
302             invDate: invDate,
303             aErc20Tx: aErc20Tx,
304             aQty: aQty,
305             aSalePrice2dec: aSalePrice2dec,
306             aAmtExc2dec: aAmtExc2dec,
307             aAmtInc2dec: aAmtInc2dec
308         });
309         
310         uint256 _tokenID = aInvoices.push(ivInfo);
311         
312         addTokenTo(msg.sender, _tokenID);
313         emit Transfer(address(0), msg.sender, _tokenID);
314     }
315     
316     
317     
318     
319     /**
320     * @dev Gets the balance of the specified address
321     * @param _owner address to query the balance of
322     * @return uint256 representing the amount owned by the passed address
323     */
324     function balanceOf(address _owner) public view returns (uint256) {
325         require(_owner != address(0));
326         return ownedTokensCount[_owner];
327     }
328 
329     /**
330     * @dev Gets the owner of the specified token ID
331     * @param _tokenId uint256 ID of the token to query the owner of
332     * @return owner address currently marked as the owner of the given token ID
333     */
334     function ownerOf(uint256 _tokenId) public view returns (address) {
335         address owner = tokenOwner[_tokenId];
336         require(owner != address(0));
337         return owner;
338     }
339 
340     /**
341     * @dev Returns whether the specified token exists
342     * @param _tokenId uint256 ID of the token to query the existence of
343     * @return whether the token exists
344     */
345     function exists(uint256 _tokenId) public view returns (bool) {
346         address owner = tokenOwner[_tokenId];
347         return owner != address(0);
348     }
349     
350     /**
351     * @dev Approves another address to transfer the given token ID
352     * The zero address indicates there is no approved address.
353     * There can only be one approved address per token at a given time.
354     * Can only be called by the token owner or an approved operator.
355     * @param _to address to be approved for the given token ID
356     * @param _tokenId uint256 ID of the token to be approved
357     */
358     function approve(address _to, uint256 _tokenId) public {
359         address owner = ownerOf(_tokenId);
360         require(_to != owner);
361         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
362 
363         tokenApprovals[_tokenId] = _to;
364         emit Approval(owner, _to, _tokenId);
365     }
366     
367     /**
368     * @dev Gets the approved address for a token ID, or zero if no address set
369     * @param _tokenId uint256 ID of the token to query the approval of
370     * @return address currently approved for the given token ID
371     */
372     function getApproved(uint256 _tokenId) public view returns (address) {
373         return tokenApprovals[_tokenId];
374     }
375 
376     /**
377     * @dev Sets or unsets the approval of a given operator
378     * An operator is allowed to transfer all tokens of the sender on their behalf
379     * @param _to operator address to set the approval
380     * @param _approved representing the status of the approval to be set
381     */
382     function setApprovalForAll(address _to, bool _approved) public {
383         require(_to != msg.sender);
384         operatorApprovals[msg.sender][_to] = _approved;
385         emit ApprovalForAll(msg.sender, _to, _approved);
386     }
387     
388     /**
389     * @dev Tells whether an operator is approved by a given owner
390     * @param _owner owner address which you want to query the approval of
391     * @param _operator operator address which you want to query the approval of
392     * @return bool whether the given operator is approved by the given owner
393     */
394     function isApprovedForAll(
395         address _owner,
396         address _operator
397     )
398     public
399     view
400     returns (bool)
401     {
402         return operatorApprovals[_owner][_operator];
403     }
404 
405     /**
406     * @dev Transfers the ownership of a given token ID to another address
407     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
408     * Requires the msg sender to be the owner, approved, or operator
409     * @param _from current owner of the token
410     * @param _to address to receive the ownership of the given token ID
411     * @param _tokenId uint256 ID of the token to be transferred
412     */
413     function transferFrom(
414         address _from,
415         address _to,
416         uint256 _tokenId
417     )
418     public
419     {
420         require(isApprovedOrOwner(msg.sender, _tokenId));
421         require(_from != address(0));
422         require(_to != address(0));
423 
424         clearApproval(_from, _tokenId);
425         removeTokenFrom(_from, _tokenId);
426         addTokenTo(_to, _tokenId);
427 
428         emit Transfer(_from, _to, _tokenId);
429     }
430 
431     /**
432     * @dev Safely transfers the ownership of a given token ID to another address
433     * If the target address is a contract, it must implement `onERC721Received`,
434     * which is called upon a safe transfer, and return the magic value
435     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
436     * the transfer is reverted.
437     *
438     * Requires the msg sender to be the owner, approved, or operator
439     * @param _from current owner of the token
440     * @param _to address to receive the ownership of the given token ID
441     * @param _tokenId uint256 ID of the token to be transferred
442     */
443     function safeTransferFrom(
444         address _from,
445         address _to,
446         uint256 _tokenId
447     )
448     public
449     {
450         // solium-disable-next-line arg-overflow
451         safeTransferFrom(_from, _to, _tokenId, "");
452     }
453 
454     /**
455     * @dev Safely transfers the ownership of a given token ID to another address
456     * If the target address is a contract, it must implement `onERC721Received`,
457     * which is called upon a safe transfer, and return the magic value
458     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
459     * the transfer is reverted.
460     * Requires the msg sender to be the owner, approved, or operator
461     * @param _from current owner of the token
462     * @param _to address to receive the ownership of the given token ID
463     * @param _tokenId uint256 ID of the token to be transferred
464     * @param _data bytes data to send along with a safe transfer check
465     */
466     function safeTransferFrom(
467         address _from,
468         address _to,
469         uint256 _tokenId,
470         bytes _data
471     )
472     public
473     {
474         transferFrom(_from, _to, _tokenId);
475         // solium-disable-next-line arg-overflow
476         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
477     }
478 
479     /**
480     * @dev Returns whether the given spender can transfer a given token ID
481     * @param _spender address of the spender to query
482     * @param _tokenId uint256 ID of the token to be transferred
483     * @return bool whether the msg.sender is approved for the given token ID,
484     *  is an operator of the owner, or is the owner of the token
485     */
486     function isApprovedOrOwner(
487         address _spender,
488         uint256 _tokenId
489     )
490     internal
491     view
492     returns (bool)
493     {
494         address owner = ownerOf(_tokenId);
495         // Disable solium check because of
496         // https://github.com/duaraghav8/Solium/issues/175
497         // solium-disable-next-line operator-whitespace
498         return (
499             _spender == owner ||
500             getApproved(_tokenId) == _spender ||
501             isApprovedForAll(owner, _spender)
502         );
503     }
504     
505     
506     /**
507     * @dev Internal function to clear current approval of a given token ID
508     * Reverts if the given address is not indeed the owner of the token
509     * @param _owner owner of the token
510     * @param _tokenId uint256 ID of the token to be transferred
511     */
512     function clearApproval(address _owner, uint256 _tokenId) internal {
513         require(ownerOf(_tokenId) == _owner);
514         if (tokenApprovals[_tokenId] != address(0)) {
515         tokenApprovals[_tokenId] = address(0);
516         }
517     }
518 
519     /**
520     * @dev Internal function to add a token ID to the list of a given address
521     * @param _to address representing the new owner of the given token ID
522     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
523     */
524     function addTokenTo(address _to, uint256 _tokenId) internal {
525         require(tokenOwner[_tokenId] == address(0));
526         tokenOwner[_tokenId] = _to;
527         ownedTokensCount[_to]++;
528     }
529 
530     /**
531     * @dev Internal function to remove a token ID from the list of a given address
532     * @param _from address representing the previous owner of the given token ID
533     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
534     */
535     function removeTokenFrom(address _from, uint256 _tokenId) internal {
536         require(ownerOf(_tokenId) == _from);
537         ownedTokensCount[_from]--;
538         tokenOwner[_tokenId] = address(0);
539     }
540 
541     /**
542     * @dev Internal function to invoke `onERC721Received` on a target address
543     * The call is not executed if the target address is not a contract
544     * @param _from address representing the previous owner of the given token ID
545     * @param _to target address that will receive the tokens
546     * @param _tokenId uint256 ID of the token to be transferred
547     * @param _data bytes optional data to send along with the call
548     * @return whether the call correctly returned the expected magic value
549     */
550     function checkAndCallSafeTransfer(
551         address _from,
552         address _to,
553         uint256 _tokenId,
554         bytes _data
555     )
556     internal
557     returns (bool)
558     {
559         if (!isContract(_to)) {
560             return true;
561         }
562         bytes4 retval = ERC721Receiver(_to).onERC721Received(
563         msg.sender, _from, _tokenId, _data);
564         return (retval == ERC721_RECEIVED);
565     }
566     
567     
568     /**
569     * Returns whether the target address is a contract
570     * @dev This function will return false if invoked during the constructor of a contract,
571     * as the code is not actually created until after the constructor finishes.
572     * @param addr address to check
573     * @return whether the target address is a contract
574     */
575     function isContract(address addr) internal view returns (bool) {
576         uint256 size;
577         // XXX Currently there is no better way to check if there is a contract in an address
578         // than to check the size of the code at that address.
579         // See https://ethereum.stackexchange.com/a/14016/36603
580         // for more details about how this works.
581         // TODO Check this again before the Serenity release, because all addresses will be
582         // contracts then.
583         // solium-disable-next-line security/no-inline-assembly
584         assembly { size := extcodesize(addr) }
585         return size > 0;
586     }
587     
588 }