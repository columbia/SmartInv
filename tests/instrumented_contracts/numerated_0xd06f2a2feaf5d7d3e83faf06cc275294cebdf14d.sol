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
200     mapping (bytes32 => string) public dbCustomer;
201     
202     struct invoiceInfo {
203         bytes32[] aErc20Tx;
204         bytes32 custID;
205         bytes32 docDate;
206         bytes32 invDate;
207         uint qty;
208         uint salePrice2dec;
209         uint amtExc2dec;
210         uint amtInc2dec;
211     }
212     
213     invoiceInfo[] aInvoices;
214     mapping (bytes32 => uint) mTxRelateWithTokenID;
215     
216 
217     string public name;
218     string public symbol;
219     
220     
221     
222     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
223     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
224     bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
225   
226     // Mapping from token ID to owner
227     mapping (uint256 => address) internal tokenOwner;
228 
229     // Mapping from token ID to approved address
230     mapping (uint256 => address) internal tokenApprovals;
231 
232     // Mapping from owner to number of owned token
233     mapping (address => uint256) internal ownedTokensCount;
234 
235     // Mapping from owner to operator approvals
236     mapping (address => mapping (address => bool)) internal operatorApprovals;
237   
238     
239     constructor() public {
240         dbCustomer["ET1218"] = "บริษัท กรุงเทพดรักสโตร์ จำกัด";
241         
242         name = "IV Token";
243         symbol = "iv";
244         
245         // register the supported interfaces to conform to ERC721 via ERC165
246         _registerInterface(InterfaceId_ERC721);
247         _registerInterface(InterfaceId_ERC721Exists);
248     }
249     
250     function implementsERC721() public pure returns (bool)
251     {
252         return true;
253     }
254     
255     function getTokenIDRelateWithTx(bytes32 _tx) public view returns (uint) {
256         return mTxRelateWithTokenID[_tx];
257     }
258     
259     function totalSupply() public view returns (uint256) {
260         return aInvoices.length;
261     }
262     
263     function getItemByTokenID(uint256 _tokenId) public view returns (
264         bytes32[] aErc20Tx,
265         bytes32 custID,
266         bytes32 docDate,
267         bytes32 invDate,
268         uint qty,
269         uint salePrice2dec,
270         uint amtExc2dec,
271         uint amtInc2dec
272         ) {
273         
274         require(_tokenId > 0);
275         
276         invoiceInfo storage ivInfo = aInvoices[_tokenId - 1];
277         return (
278             ivInfo.aErc20Tx,
279             ivInfo.custID,
280             ivInfo.docDate,
281             ivInfo.invDate,
282             ivInfo.qty,
283             ivInfo.salePrice2dec,
284             ivInfo.amtExc2dec,
285             ivInfo.amtInc2dec
286         );
287     }
288     
289     
290     function addData(
291         bytes32[] aErc20Tx,
292         bytes32 custID,
293         bytes32 docDate,
294         bytes32 invDate,
295         uint qty,
296         uint salePrice2dec,
297         uint amtExc2dec,
298         uint amtInc2dec
299         ) 
300         public 
301         onlyOwner
302         {
303         
304         
305         invoiceInfo memory ivInfo = invoiceInfo({
306             aErc20Tx: aErc20Tx,
307             custID: custID,
308             docDate: docDate,
309             invDate: invDate,
310             qty: qty,
311             salePrice2dec: salePrice2dec,
312             amtExc2dec: amtExc2dec,
313             amtInc2dec: amtInc2dec
314         });
315         
316         uint256 _tokenID = aInvoices.push(ivInfo);
317         for(uint256 i=0; i<aErc20Tx.length; i++) {
318             mTxRelateWithTokenID[aErc20Tx[i]] = _tokenID;
319         }
320         
321         addTokenTo(msg.sender, _tokenID);
322         emit Transfer(address(0), msg.sender, _tokenID);
323     }
324     
325     
326     
327     
328     /**
329     * @dev Gets the balance of the specified address
330     * @param _owner address to query the balance of
331     * @return uint256 representing the amount owned by the passed address
332     */
333     function balanceOf(address _owner) public view returns (uint256) {
334         require(_owner != address(0));
335         return ownedTokensCount[_owner];
336     }
337 
338     /**
339     * @dev Gets the owner of the specified token ID
340     * @param _tokenId uint256 ID of the token to query the owner of
341     * @return owner address currently marked as the owner of the given token ID
342     */
343     function ownerOf(uint256 _tokenId) public view returns (address) {
344         address owner = tokenOwner[_tokenId];
345         require(owner != address(0));
346         return owner;
347     }
348 
349     /**
350     * @dev Returns whether the specified token exists
351     * @param _tokenId uint256 ID of the token to query the existence of
352     * @return whether the token exists
353     */
354     function exists(uint256 _tokenId) public view returns (bool) {
355         address owner = tokenOwner[_tokenId];
356         return owner != address(0);
357     }
358     
359     /**
360     * @dev Approves another address to transfer the given token ID
361     * The zero address indicates there is no approved address.
362     * There can only be one approved address per token at a given time.
363     * Can only be called by the token owner or an approved operator.
364     * @param _to address to be approved for the given token ID
365     * @param _tokenId uint256 ID of the token to be approved
366     */
367     function approve(address _to, uint256 _tokenId) public {
368         address owner = ownerOf(_tokenId);
369         require(_to != owner);
370         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
371 
372         tokenApprovals[_tokenId] = _to;
373         emit Approval(owner, _to, _tokenId);
374     }
375     
376     /**
377     * @dev Gets the approved address for a token ID, or zero if no address set
378     * @param _tokenId uint256 ID of the token to query the approval of
379     * @return address currently approved for the given token ID
380     */
381     function getApproved(uint256 _tokenId) public view returns (address) {
382         return tokenApprovals[_tokenId];
383     }
384 
385     /**
386     * @dev Sets or unsets the approval of a given operator
387     * An operator is allowed to transfer all tokens of the sender on their behalf
388     * @param _to operator address to set the approval
389     * @param _approved representing the status of the approval to be set
390     */
391     function setApprovalForAll(address _to, bool _approved) public {
392         require(_to != msg.sender);
393         operatorApprovals[msg.sender][_to] = _approved;
394         emit ApprovalForAll(msg.sender, _to, _approved);
395     }
396     
397     /**
398     * @dev Tells whether an operator is approved by a given owner
399     * @param _owner owner address which you want to query the approval of
400     * @param _operator operator address which you want to query the approval of
401     * @return bool whether the given operator is approved by the given owner
402     */
403     function isApprovedForAll(
404         address _owner,
405         address _operator
406     )
407     public
408     view
409     returns (bool)
410     {
411         return operatorApprovals[_owner][_operator];
412     }
413 
414     /**
415     * @dev Transfers the ownership of a given token ID to another address
416     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
417     * Requires the msg sender to be the owner, approved, or operator
418     * @param _from current owner of the token
419     * @param _to address to receive the ownership of the given token ID
420     * @param _tokenId uint256 ID of the token to be transferred
421     */
422     function transferFrom(
423         address _from,
424         address _to,
425         uint256 _tokenId
426     )
427     public
428     {
429         require(isApprovedOrOwner(msg.sender, _tokenId));
430         require(_from != address(0));
431         require(_to != address(0));
432 
433         clearApproval(_from, _tokenId);
434         removeTokenFrom(_from, _tokenId);
435         addTokenTo(_to, _tokenId);
436 
437         emit Transfer(_from, _to, _tokenId);
438     }
439 
440     /**
441     * @dev Safely transfers the ownership of a given token ID to another address
442     * If the target address is a contract, it must implement `onERC721Received`,
443     * which is called upon a safe transfer, and return the magic value
444     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
445     * the transfer is reverted.
446     *
447     * Requires the msg sender to be the owner, approved, or operator
448     * @param _from current owner of the token
449     * @param _to address to receive the ownership of the given token ID
450     * @param _tokenId uint256 ID of the token to be transferred
451     */
452     function safeTransferFrom(
453         address _from,
454         address _to,
455         uint256 _tokenId
456     )
457     public
458     {
459         // solium-disable-next-line arg-overflow
460         safeTransferFrom(_from, _to, _tokenId, "");
461     }
462 
463     /**
464     * @dev Safely transfers the ownership of a given token ID to another address
465     * If the target address is a contract, it must implement `onERC721Received`,
466     * which is called upon a safe transfer, and return the magic value
467     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
468     * the transfer is reverted.
469     * Requires the msg sender to be the owner, approved, or operator
470     * @param _from current owner of the token
471     * @param _to address to receive the ownership of the given token ID
472     * @param _tokenId uint256 ID of the token to be transferred
473     * @param _data bytes data to send along with a safe transfer check
474     */
475     function safeTransferFrom(
476         address _from,
477         address _to,
478         uint256 _tokenId,
479         bytes _data
480     )
481     public
482     {
483         transferFrom(_from, _to, _tokenId);
484         // solium-disable-next-line arg-overflow
485         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
486     }
487 
488     /**
489     * @dev Returns whether the given spender can transfer a given token ID
490     * @param _spender address of the spender to query
491     * @param _tokenId uint256 ID of the token to be transferred
492     * @return bool whether the msg.sender is approved for the given token ID,
493     *  is an operator of the owner, or is the owner of the token
494     */
495     function isApprovedOrOwner(
496         address _spender,
497         uint256 _tokenId
498     )
499     internal
500     view
501     returns (bool)
502     {
503         address owner = ownerOf(_tokenId);
504         // Disable solium check because of
505         // https://github.com/duaraghav8/Solium/issues/175
506         // solium-disable-next-line operator-whitespace
507         return (
508             _spender == owner ||
509             getApproved(_tokenId) == _spender ||
510             isApprovedForAll(owner, _spender)
511         );
512     }
513     
514     
515     /**
516     * @dev Internal function to clear current approval of a given token ID
517     * Reverts if the given address is not indeed the owner of the token
518     * @param _owner owner of the token
519     * @param _tokenId uint256 ID of the token to be transferred
520     */
521     function clearApproval(address _owner, uint256 _tokenId) internal {
522         require(ownerOf(_tokenId) == _owner);
523         if (tokenApprovals[_tokenId] != address(0)) {
524         tokenApprovals[_tokenId] = address(0);
525         }
526     }
527 
528     /**
529     * @dev Internal function to add a token ID to the list of a given address
530     * @param _to address representing the new owner of the given token ID
531     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
532     */
533     function addTokenTo(address _to, uint256 _tokenId) internal {
534         require(tokenOwner[_tokenId] == address(0));
535         tokenOwner[_tokenId] = _to;
536         ownedTokensCount[_to]++;
537     }
538 
539     /**
540     * @dev Internal function to remove a token ID from the list of a given address
541     * @param _from address representing the previous owner of the given token ID
542     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
543     */
544     function removeTokenFrom(address _from, uint256 _tokenId) internal {
545         require(ownerOf(_tokenId) == _from);
546         ownedTokensCount[_from]--;
547         tokenOwner[_tokenId] = address(0);
548     }
549 
550     /**
551     * @dev Internal function to invoke `onERC721Received` on a target address
552     * The call is not executed if the target address is not a contract
553     * @param _from address representing the previous owner of the given token ID
554     * @param _to target address that will receive the tokens
555     * @param _tokenId uint256 ID of the token to be transferred
556     * @param _data bytes optional data to send along with the call
557     * @return whether the call correctly returned the expected magic value
558     */
559     function checkAndCallSafeTransfer(
560         address _from,
561         address _to,
562         uint256 _tokenId,
563         bytes _data
564     )
565     internal
566     returns (bool)
567     {
568         if (!isContract(_to)) {
569             return true;
570         }
571         bytes4 retval = ERC721Receiver(_to).onERC721Received(
572         msg.sender, _from, _tokenId, _data);
573         return (retval == ERC721_RECEIVED);
574     }
575     
576     
577     /**
578     * Returns whether the target address is a contract
579     * @dev This function will return false if invoked during the constructor of a contract,
580     * as the code is not actually created until after the constructor finishes.
581     * @param addr address to check
582     * @return whether the target address is a contract
583     */
584     function isContract(address addr) internal view returns (bool) {
585         uint256 size;
586         // XXX Currently there is no better way to check if there is a contract in an address
587         // than to check the size of the code at that address.
588         // See https://ethereum.stackexchange.com/a/14016/36603
589         // for more details about how this works.
590         // TODO Check this again before the Serenity release, because all addresses will be
591         // contracts then.
592         // solium-disable-next-line security/no-inline-assembly
593         assembly { size := extcodesize(addr) }
594         return size > 0;
595     }
596     
597 }