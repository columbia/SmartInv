1 pragma solidity ^0.4.24;
2 
3 //-----------------------------------------------------------------------------
4 /// @title TOY Ownership
5 /// @notice defines TOY Token ownership-tracking structures and view functions.
6 //-----------------------------------------------------------------------------
7 contract ToyOwnership {
8     struct ToyToken {
9         // owner ID list
10         address owner;
11         // unique identifier
12         uint uid;
13         // timestamp
14         uint timestamp;
15         // exp
16         uint exp;
17         // toy data
18         bytes toyData;
19     }
20 
21     struct ExternalNft{
22         // Contract address
23         address nftContractAddress;
24         // Token Identifier
25         uint nftId;
26     }
27 
28     // Array containing all TOY Tokens. The first element in toyArray returns
29     //  as invalid
30     ToyToken[] toyArray;
31     // Mapping containing all UIDs tracked by this contract. Valid UIDs map to
32     //  index numbers, invalid UIDs map to 0.
33     mapping (uint => uint) uidToToyIndex;
34     // Mapping containing linked external NFTs. Linked TOY Tokens always map to
35     //  non-zero numbers, invalid TOY Tokens map to 0.
36     mapping (uint => ExternalNft) uidToExternalNft;
37     // Mapping containing tokens IDs for tokens created by an external contract
38     //  and whether or not it is linked to a TOY Token 
39     mapping (address => mapping (uint => bool)) linkedExternalNfts;
40     
41     //-------------------------------------------------------------------------
42     /// @dev Throws if TOY Token #`_tokenId` isn't tracked by the toyArray.
43     //-------------------------------------------------------------------------
44     modifier mustExist(uint _tokenId) {
45         require (uidToToyIndex[_tokenId] != 0, "Invalid TOY Token UID");
46         _;
47     }
48 
49     //-------------------------------------------------------------------------
50     /// @dev Throws if TOY Token #`_tokenId` isn't owned by sender.
51     //-------------------------------------------------------------------------
52     modifier mustOwn(uint _tokenId) {
53         require 
54         (
55             ownerOf(_tokenId) == msg.sender, 
56             "Must be owner of this TOY Token"
57         );
58         _;
59     }
60 
61     //-------------------------------------------------------------------------
62     /// @dev Throws if parameter is zero
63     //-------------------------------------------------------------------------
64     modifier notZero(uint _param) {
65         require(_param != 0, "Parameter cannot be zero");
66         _;
67     }
68 
69     //-------------------------------------------------------------------------
70     /// @dev Creates an empty TOY Token as a [0] placeholder for invalid TOY 
71     ///  Token queries.
72     //-------------------------------------------------------------------------
73     constructor () public {
74         toyArray.push(ToyToken(0,0,0,0,""));
75     }
76 
77     //-------------------------------------------------------------------------
78     /// @notice Find the owner of TOY Token #`_tokenId`
79     /// @dev throws if `_owner` is the zero address.
80     /// @param _tokenId The identifier for a TOY Token
81     /// @return The address of the owner of the TOY Token
82     //-------------------------------------------------------------------------
83     function ownerOf(uint256 _tokenId) 
84         public 
85         view 
86         mustExist(_tokenId) 
87         returns (address) 
88     {
89         // owner must not be the zero address
90         require (
91             toyArray[uidToToyIndex[_tokenId]].owner != 0, 
92             "TOY Token has no owner"
93         );
94         return toyArray[uidToToyIndex[_tokenId]].owner;
95     }
96 
97     //-------------------------------------------------------------------------
98     /// @notice Count all TOY Tokens assigned to an owner
99     /// @dev throws if `_owner` is the zero address.
100     /// @param _owner An address to query
101     /// @return The number of TOY Tokens owned by `_owner`, possibly zero
102     //-------------------------------------------------------------------------
103     function balanceOf(address _owner) 
104         public 
105         view 
106         notZero(uint(_owner)) 
107         returns (uint256) 
108     {
109         uint owned;
110         for (uint i = 1; i < toyArray.length; ++i) {
111             if(toyArray[i].owner == _owner) {
112                 ++owned;
113             }
114         }
115         return owned;
116     }
117 
118     //-------------------------------------------------------------------------
119     /// @notice Get a list of TOY Tokens assigned to an owner
120     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
121     ///  `_owner` is the zero address, representing invalid TOY Tokens.
122     /// @param _owner Address to query for TOY Tokens.
123     /// @return The complete list of Unique Indentifiers for TOY Tokens
124     ///  assigned to `_owner`
125     //-------------------------------------------------------------------------
126     function tokensOfOwner(address _owner) external view returns (uint[]) {
127         uint toysOwned = balanceOf(_owner);
128         require(toysOwned > 0, "No owned TOY Tokens");
129         uint counter = 0;
130         uint[] memory result = new uint[](toysOwned);
131         for (uint i = 0; i < toyArray.length; i++) {
132             if(toyArray[i].owner == _owner) {
133                 result[counter] = toyArray[i].uid;
134                 counter++;
135             }
136         }
137         return result;
138     }
139 
140     //-------------------------------------------------------------------------
141     /// @notice Get number of TOY Tokens tracked by this contract
142     /// @return A count of valid TOY Tokens tracked by this contract, where
143     ///  each one has an assigned and queryable owner.
144     //-------------------------------------------------------------------------
145     function totalSupply() external view returns (uint256) {
146         return (toyArray.length - 1);
147     }
148 
149     //-------------------------------------------------------------------------
150     /// @notice Get the UID of TOY Token with index number `index`.
151     /// @dev Throws if `_index` >= `totalSupply()`.
152     /// @param _index A counter less than `totalSupply()`
153     /// @return The UID for the #`_index` TOY Token in the TOY Token array.
154     //-------------------------------------------------------------------------
155     function tokenByIndex(uint256 _index) external view returns (uint256) {
156         // index must correspond to an existing TOY Token
157         require (_index > 0 && _index < toyArray.length, "Invalid index");
158         return (toyArray[_index].uid);
159     }
160 
161     //-------------------------------------------------------------------------
162     /// @notice Enumerate NFTs assigned to an owner
163     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
164     ///  `_owner` is the zero address, representing invalid NFTs.
165     /// @param _owner Address to query for TOY Tokens.
166     /// @param _index A counter less than `balanceOf(_owner)`
167     /// @return The Unique Indentifier for the #`_index` TOY Token assigned to
168     ///  `_owner`, (sort order not specified)
169     //-------------------------------------------------------------------------
170     function tokenOfOwnerByIndex(
171         address _owner, 
172         uint256 _index
173     ) external view notZero(uint(_owner)) returns (uint256) {
174         uint toysOwned = balanceOf(_owner);
175         require(toysOwned > 0, "No owned TOY Tokens");
176         require(_index < toysOwned, "Invalid index");
177         uint counter = 0;
178         for (uint i = 0; i < toyArray.length; i++) {
179             if (toyArray[i].owner == _owner) {
180                 if (counter == _index) {
181                     return(toyArray[i].uid);
182                 } else {
183                     counter++;
184                 }
185             }
186         }
187     }
188 }
189 
190 
191 //-----------------------------------------------------------------------------
192 /// @title Token Receiver Interface
193 //-----------------------------------------------------------------------------
194 interface TokenReceiverInterface {
195     function onERC721Received(
196         address _operator, 
197         address _from, 
198         uint256 _tokenId, 
199         bytes _data
200     ) external returns(bytes4);
201 }
202 
203 
204 //-----------------------------------------------------------------------------
205 /// @title ERC721 Interface
206 //-----------------------------------------------------------------------------
207 interface ERC721 {
208     function transferFrom (
209         address _from, 
210         address _to, 
211         uint256 _tokenId
212     ) external payable;
213     function ownerOf(uint _tokenId) external returns(address);
214     function getApproved(uint256 _tokenId) external view returns (address);
215     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
216 }
217 
218 
219 //-----------------------------------------------------------------------------
220 /// @title TOY Transfers
221 /// @notice Defines transfer functionality for TOY Tokens to transfer ownership.
222 ///  Defines approval functionality for 3rd parties to enable transfers on
223 ///  owners' behalf.
224 //-----------------------------------------------------------------------------
225 contract ToyTransfers is ToyOwnership {
226     //-------------------------------------------------------------------------
227     /// @dev Transfer emits when ownership of a TOY Token changes by any
228     ///  mechanism. This event emits when TOY Tokens are created ('from' == 0).
229     ///  At the time of any transfer, the approved address for that TOY Token
230     ///  (if any) is reset to address(0).
231     //-------------------------------------------------------------------------
232     event Transfer(
233         address indexed _from, 
234         address indexed _to, 
235         uint256 indexed _tokenId
236     );
237 
238     //-------------------------------------------------------------------------
239     /// @dev Approval emits when the approved address for a TOY Token is
240     ///  changed or reaffirmed. The zero address indicates there is no approved
241     ///  address. When a Transfer event emits, this also indicates that the
242     ///  approved address for that TOY Token (if any) is reset to none.
243     //-------------------------------------------------------------------------
244     event Approval(
245         address indexed _owner, 
246         address indexed _approved, 
247         uint256 indexed _tokenId
248     );
249 
250     //-------------------------------------------------------------------------
251     /// @dev This emits when an operator is enabled or disabled for an owner.
252     ///  The operator can manage all TOY Tokens of the owner.
253     //-------------------------------------------------------------------------
254     event ApprovalForAll(
255         address indexed _owner, 
256         address indexed _operator, 
257         bool _approved
258     );
259 
260     // Mapping from token ID to approved address
261     mapping (uint => address) idToApprovedAddress;
262     // Mapping from owner to operator approvals
263     mapping (address => mapping (address => bool)) operatorApprovals;
264 
265     //-------------------------------------------------------------------------
266     /// @dev Throws if called by any account other than token owner, approved
267     ///  address, or authorized operator.
268     //-------------------------------------------------------------------------
269     modifier canOperate(uint _uid) {
270         // sender must be owner of TOY Token #uid, or sender must be the
271         //  approved address of TOY Token #uid, or an authorized operator for
272         //  TOY Token owner
273         require (
274             msg.sender == toyArray[uidToToyIndex[_uid]].owner ||
275             msg.sender == idToApprovedAddress[_uid] ||
276             operatorApprovals[toyArray[uidToToyIndex[_uid]].owner][msg.sender],
277             "Not authorized to operate for this TOY Token"
278         );
279         _;
280     }
281 
282     //-------------------------------------------------------------------------
283     /// @notice Change or reaffirm the approved address for TOY Token #`_tokenId`.
284     /// @dev The zero address indicates there is no approved address.
285     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
286     ///  operator of the current owner.
287     /// @param _approved The new approved TOY Token controller
288     /// @param _tokenId The TOY Token to approve
289     //-------------------------------------------------------------------------
290     function approve(address _approved, uint256 _tokenId) external payable {
291         address owner = ownerOf(_tokenId);
292         // msg.sender must be the current NFT owner, or an authorized operator
293         //  of the current owner.
294         require (
295             msg.sender == owner || isApprovedForAll(owner, msg.sender),
296             "Not authorized to approve for this TOY Token"
297         );
298         idToApprovedAddress[_tokenId] = _approved;
299         emit Approval(owner, _approved, _tokenId);
300     }
301     
302     //-------------------------------------------------------------------------
303     /// @notice Get the approved address for a single NFT
304     /// @dev Throws if `_tokenId` is not a valid NFT.
305     /// @param _tokenId The NFT to find the approved address for
306     /// @return The approved address for this NFT, or the zero address if
307     ///  there is none
308     //-------------------------------------------------------------------------
309     function getApproved(
310         uint256 _tokenId
311     ) external view mustExist(_tokenId) returns (address) {
312         return idToApprovedAddress[_tokenId];
313     }
314     
315     //-------------------------------------------------------------------------
316     /// @notice Enable or disable approval for a third party ("operator") to
317     ///  manage all of sender's TOY Tokens
318     /// @dev Emits the ApprovalForAll event. The contract MUST allow multiple
319     ///  operators per owner.
320     /// @param _operator Address to add to the set of authorized operators
321     /// @param _approved True if the operator is approved, false to revoke
322     ///  approval
323     //-------------------------------------------------------------------------
324     function setApprovalForAll(address _operator, bool _approved) external {
325         require(_operator != msg.sender, "Operator cannot be sender");
326         operatorApprovals[msg.sender][_operator] = _approved;
327         emit ApprovalForAll(msg.sender, _operator, _approved);
328     }
329     
330     //-------------------------------------------------------------------------
331     /// @notice Get whether '_operator' is approved to manage all of '_owner's
332     ///  TOY Tokens
333     /// @param _owner TOY Token Owner.
334     /// @param _operator Address to check for approval.
335     /// @return True if '_operator' is approved to manage all of '_owner's' TOY
336     ///  Tokens.
337     //-------------------------------------------------------------------------
338     function isApprovedForAll(
339         address _owner, 
340         address _operator
341     ) public view returns (bool) {
342         return operatorApprovals[_owner][_operator];
343     }
344 
345     
346     //-------------------------------------------------------------------------
347     /// @notice Transfers ownership of TOY Token #`_tokenId` from `_from` to 
348     ///  `_to`
349     /// @dev Throws unless `msg.sender` is the current owner, an authorized
350     ///  operator, or the approved address for this NFT. Throws if `_from` is
351     ///  not the current owner. Throws if `_to` is the zero address. Throws if
352     ///  `_tokenId` is not a valid NFT. When transfer is complete, checks if
353     ///  `_to` is a smart contract (code size > 0). If so, it calls
354     ///  `onERC721Received` on `_to` and throws if the return value is not
355     ///  `0x150b7a02`. If TOY Token is linked to an external NFT, this function
356     ///  calls TransferFrom from the external address. Throws if this contract
357     ///  is not an approved operator for the external NFT.
358     /// @param _from The current owner of the NFT
359     /// @param _to The new owner
360     /// @param _tokenId The NFT to transfer
361     //-------------------------------------------------------------------------
362     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
363         external 
364         payable 
365         mustExist(_tokenId) 
366         canOperate(_tokenId) 
367         notZero(uint(_to)) 
368     {
369         address owner = ownerOf(_tokenId);
370         // _from address must be current owner of the TOY Token
371         require (
372             _from == owner, 
373             "TOY Token not owned by '_from'"
374         );
375                
376         // if TOY Token has a linked external NFT, call TransferFrom on the 
377         //  external NFT contract
378         ExternalNft memory externalNft = uidToExternalNft[_tokenId];
379         if (externalNft.nftContractAddress != 0) {
380             // initialize external NFT contract
381             ERC721 externalContract = ERC721(externalNft.nftContractAddress);
382             // call TransferFrom
383             externalContract.transferFrom(_from, _to, externalNft.nftId);
384         }
385 
386         // clear approval
387         idToApprovedAddress[_tokenId] = 0;
388         // transfer ownership
389         toyArray[uidToToyIndex[_tokenId]].owner = _to;
390 
391         emit Transfer(_from, _to, _tokenId);
392 
393         // check and call onERC721Received. Throws and rolls back the transfer
394         //  if _to does not implement the expected interface
395         uint size;
396         assembly { size := extcodesize(_to) }
397         if (size > 0) {
398             bytes4 retval = TokenReceiverInterface(_to).onERC721Received(msg.sender, _from, _tokenId, "");
399             require(
400                 retval == 0x150b7a02, 
401                 "Destination contract not equipped to receive TOY Tokens"
402             );
403         }
404     }
405     
406     //-------------------------------------------------------------------------
407     /// @notice Transfers ownership of TOY Token #`_tokenId` from `_from` to 
408     ///  `_to`
409     /// @dev Throws unless `msg.sender` is the current owner, an authorized
410     ///  operator, or the approved address for this NFT. Throws if `_from` is
411     ///  not the current owner. Throws if `_to` is the zero address. Throws if
412     ///  `_tokenId` is not a valid NFT. If TOY Token is linked to an external
413     ///  NFT, this function calls TransferFrom from the external address.
414     ///  Throws if this contract is not an approved operator for the external
415     ///  NFT. When transfer is complete, checks if `_to` is a smart contract
416     ///  (code size > 0). If so, it calls `onERC721Received` on `_to` and
417     ///  throws if the return value is not `0x150b7a02`.
418     /// @param _from The current owner of the NFT
419     /// @param _to The new owner
420     /// @param _tokenId The NFT to transfer
421     /// @param _data Additional data with no pre-specified format
422     //-------------------------------------------------------------------------
423     function safeTransferFrom(
424         address _from, 
425         address _to, 
426         uint256 _tokenId, 
427         bytes _data
428     ) 
429         external 
430         payable 
431         mustExist(_tokenId) 
432         canOperate(_tokenId) 
433         notZero(uint(_to)) 
434     {
435         address owner = ownerOf(_tokenId);
436         // _from address must be current owner of the TOY Token
437         require (
438             _from == owner, 
439             "TOY Token not owned by '_from'"
440         );
441         
442         // if TOY Token has a linked external NFT, call TransferFrom on the 
443         //  external NFT contract
444         ExternalNft memory externalNft = uidToExternalNft[_tokenId];
445         if (externalNft.nftContractAddress != 0) {
446             // initialize external NFT contract
447             ERC721 externalContract = ERC721(externalNft.nftContractAddress);
448             // call TransferFrom
449             externalContract.transferFrom(_from, _to, externalNft.nftId);
450         }
451 
452         // clear approval
453         idToApprovedAddress[_tokenId] = 0;
454         // transfer ownership
455         toyArray[uidToToyIndex[_tokenId]].owner = _to;
456 
457         emit Transfer(_from, _to, _tokenId);
458 
459         // check and call onERC721Received. Throws and rolls back the transfer
460         //  if _to does not implement the expected interface
461         uint size;
462         assembly { size := extcodesize(_to) }
463         if (size > 0) {
464             bytes4 retval = TokenReceiverInterface(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
465             require(
466                 retval == 0x150b7a02,
467                 "Destination contract not equipped to receive TOY Tokens"
468             );
469         }
470     }
471 
472     //-------------------------------------------------------------------------
473     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
474     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
475     ///  THEY MAY BE PERMANENTLY LOST
476     /// @dev Throws unless `msg.sender` is the current owner, an authorized
477     ///  operator, or the approved address for this NFT. Throws if `_from` is
478     ///  not the current owner. Throws if `_to` is the zero address. Throws if
479     ///  `_tokenId` is not a valid NFT. If TOY Token is linked to an external
480     ///  NFT, this function calls TransferFrom from the external address.
481     ///  Throws if this contract is not an approved operator for the external
482     ///  NFT.
483     /// @param _from The current owner of the NFT
484     /// @param _to The new owner
485     /// @param _tokenId The NFT to transfer
486     //-------------------------------------------------------------------------
487     function transferFrom(address _from, address _to, uint256 _tokenId)
488         external 
489         payable 
490         mustExist(_tokenId) 
491         canOperate(_tokenId) 
492         notZero(uint(_to)) 
493     {
494         address owner = ownerOf(_tokenId);
495         // _from address must be current owner of the TOY Token
496         require (
497             _from == owner && _from != 0, 
498             "TOY Token not owned by '_from'"
499         );
500         
501         // if TOY Token has a linked external NFT, call TransferFrom on the 
502         //  external NFT contract
503         ExternalNft memory externalNft = uidToExternalNft[_tokenId];
504         if (externalNft.nftContractAddress != 0) {
505             // initialize external NFT contract
506             ERC721 externalContract = ERC721(externalNft.nftContractAddress);
507             // call TransferFrom
508             externalContract.transferFrom(_from, _to, externalNft.nftId);
509         }
510 
511         // clear approval
512         idToApprovedAddress[_tokenId] = 0;
513         // transfer ownership
514         toyArray[uidToToyIndex[_tokenId]].owner = _to;
515 
516         emit Transfer(_from, _to, _tokenId);
517     }
518 }
519 
520 
521 //-----------------------------------------------------------------------------
522 ///@title ERC-20 function declarations
523 //-----------------------------------------------------------------------------
524 interface ERC20 {
525     function transfer (
526         address to, 
527         uint tokens
528     ) external returns (bool success);
529 
530     function transferFrom (
531         address from, 
532         address to, 
533         uint tokens
534     ) external returns (bool success);
535 }
536 
537 
538 //-----------------------------------------------------------------------------
539 /// @title External Token Handler
540 /// @notice Defines depositing and withdrawal of Ether and ERC-20-compliant
541 ///  tokens into TOY Tokens.
542 //-----------------------------------------------------------------------------
543 contract ExternalTokenHandler is ToyTransfers {
544     // handles the balances of TOY Tokens for every ERC20 token address
545     mapping (address => mapping(uint => uint)) externalTokenBalances;
546     
547     // UID value is 7 bytes. Max value is 2**56 - 1
548     uint constant UID_MAX = 0xFFFFFFFFFFFFFF;
549 
550     //-------------------------------------------------------------------------
551     /// @notice Deposit Ether from sender to approved TOY Token
552     /// @dev Throws if Ether to deposit is zero. Throws if sender is not
553     ///  approved to operate TOY Token #`toUid`. Throws if TOY Token #`toUid`
554     ///  is unlinked. Throws if sender has insufficient balance for deposit.
555     /// @param _toUid the TOY Token to deposit the Ether into
556     //-------------------------------------------------------------------------
557     function depositEther(uint _toUid) 
558         external 
559         payable 
560         canOperate(_toUid)
561         notZero(msg.value)
562     {
563         // TOY Token must be linked
564         require (
565             _toUid < UID_MAX, 
566             "Invalid TOY Token. TOY Token not yet linked"
567         );
568         // add amount to TOY Token's balance
569         externalTokenBalances[address(this)][_toUid] += msg.value;
570     }
571 
572     //-------------------------------------------------------------------------
573     /// @notice Withdraw Ether from approved TOY Token to TOY Token's owner
574     /// @dev Throws if Ether to withdraw is zero. Throws if sender is not an
575     ///  approved operator for TOY Token #`_fromUid`. Throws if TOY Token 
576     ///  #`_fromUid` has insufficient balance to withdraw.
577     /// @param _fromUid the TOY Token to withdraw the Ether from
578     /// @param _amount the amount of Ether to withdraw (in Wei)
579     //-------------------------------------------------------------------------
580     function withdrawEther(
581         uint _fromUid, 
582         uint _amount
583     ) external canOperate(_fromUid) notZero(_amount) {
584         // TOY Token must have sufficient Ether balance
585         require (
586             externalTokenBalances[address(this)][_fromUid] >= _amount,
587             "Insufficient Ether to withdraw"
588         );
589         // subtract amount from TOY Token's balance
590         externalTokenBalances[address(this)][_fromUid] -= _amount;
591         // call transfer function
592         ownerOf(_fromUid).transfer(_amount);
593     }
594 
595     //-------------------------------------------------------------------------
596     /// @notice Withdraw Ether from approved TOY Token and send to '_to'
597     /// @dev Throws if Ether to transfer is zero. Throws if sender is not an
598     ///  approved operator for TOY Token #`to_fromUidUid`. Throws if TOY Token
599     ///  #`_fromUid` has insufficient balance to withdraw.
600     /// @param _fromUid the TOY Token to withdraw and send the Ether from
601     /// @param _to the address to receive the transferred Ether
602     /// @param _amount the amount of Ether to withdraw (in Wei)
603     //-------------------------------------------------------------------------
604     function transferEther(
605         uint _fromUid,
606         address _to,
607         uint _amount
608     ) external canOperate(_fromUid) notZero(_amount) {
609         // TOY Token must have sufficient Ether balance
610         require (
611             externalTokenBalances[address(this)][_fromUid] >= _amount,
612             "Insufficient Ether to transfer"
613         );
614         // subtract amount from TOY Token's balance
615         externalTokenBalances[address(this)][_fromUid] -= _amount;
616         // call transfer function
617         _to.transfer(_amount);
618     }
619 
620     //-------------------------------------------------------------------------
621     /// @notice Deposit ERC-20 tokens from sender to approved TOY Token
622     /// @dev This contract address must be an authorized spender for sender.
623     ///  Throws if tokens to deposit is zero. Throws if sender is not an
624     ///  approved operator for TOY Token #`toUid`. Throws if TOY Token #`toUid`
625     ///  is unlinked. Throws if this contract address has insufficient
626     ///  allowance for transfer. Throws if sender has insufficient balance for 
627     ///  deposit. Throws if tokenAddress has no transferFrom function.
628     /// @param _tokenAddress the ERC-20 contract address
629     /// @param _toUid the TOY Token to deposit the ERC-20 tokens into
630     /// @param _tokens the number of tokens to deposit
631     //-------------------------------------------------------------------------
632     function depositERC20 (
633         address _tokenAddress, 
634         uint _toUid, 
635         uint _tokens
636     ) external canOperate(_toUid) notZero(_tokens) {
637         // TOY Token must be linked
638         require (_toUid < UID_MAX, "Invalid TOY Token. TOY Token not yet linked");
639         // initialize token contract
640         ERC20 tokenContract = ERC20(_tokenAddress);
641         // add amount to TOY Token's balance
642         externalTokenBalances[_tokenAddress][_toUid] += _tokens;
643 
644         // call transferFrom function from token contract
645         tokenContract.transferFrom(msg.sender, address(this), _tokens);
646     }
647 
648     //-------------------------------------------------------------------------
649     /// @notice Deposit ERC-20 tokens from '_to' to approved TOY Token
650     /// @dev This contract address must be an authorized spender for '_from'.
651     ///  Throws if tokens to deposit is zero. Throws if sender is not an
652     ///  approved operator for TOY Token #`toUid`. Throws if TOY Token #`toUid`
653     ///  is unlinked. Throws if this contract address has insufficient
654     ///  allowance for transfer. Throws if sender has insufficient balance for
655     ///  deposit. Throws if tokenAddress has no transferFrom function.
656     /// @param _tokenAddress the ERC-20 contract address
657     /// @param _from the address sending ERC-21 tokens to deposit
658     /// @param _toUid the TOY Token to deposit the ERC-20 tokens into
659     /// @param _tokens the number of tokens to deposit
660     //-------------------------------------------------------------------------
661     function depositERC20From (
662         address _tokenAddress,
663         address _from, 
664         uint _toUid, 
665         uint _tokens
666     ) external canOperate(_toUid) notZero(_tokens) {
667         // TOY Token must be linked
668         require (
669             _toUid < UID_MAX, 
670             "Invalid TOY Token. TOY Token not yet linked"
671         );
672         // initialize token contract
673         ERC20 tokenContract = ERC20(_tokenAddress);
674         // add amount to TOY Token's balance
675         externalTokenBalances[_tokenAddress][_toUid] += _tokens;
676 
677         // call transferFrom function from token contract
678         tokenContract.transferFrom(_from, address(this), _tokens);
679     }
680 
681     //-------------------------------------------------------------------------
682     /// @notice Withdraw ERC-20 tokens from approved TOY Token to TOY Token's
683     ///  owner
684     /// @dev Throws if tokens to withdraw is zero. Throws if sender is not an
685     ///  approved operator for TOY Token #`_fromUid`. Throws if TOY Token 
686     ///  #`_fromUid` has insufficient balance to withdraw. Throws if 
687     ///  tokenAddress has no transfer function.
688     /// @param _tokenAddress the ERC-20 contract address
689     /// @param _fromUid the TOY Token to withdraw the ERC-20 tokens from
690     /// @param _tokens the number of tokens to withdraw
691     //-------------------------------------------------------------------------
692     function withdrawERC20 (
693         address _tokenAddress, 
694         uint _fromUid, 
695         uint _tokens
696     ) external canOperate(_fromUid) notZero(_tokens) {
697         // TOY Token must have sufficient token balance
698         require (
699             externalTokenBalances[_tokenAddress][_fromUid] >= _tokens,
700             "insufficient tokens to withdraw"
701         );
702         // initialize token contract
703         ERC20 tokenContract = ERC20(_tokenAddress);
704         // subtract amount from TOY Token's balance
705         externalTokenBalances[_tokenAddress][_fromUid] -= _tokens;
706         
707         // call transfer function from token contract
708         tokenContract.transfer(ownerOf(_fromUid), _tokens);
709     }
710 
711     //-------------------------------------------------------------------------
712     /// @notice Transfer ERC-20 tokens from your TOY Token to `_to`
713     /// @dev Throws if tokens to transfer is zero. Throws if sender is not an
714     ///  approved operator for TOY Token #`_fromUid`. Throws if TOY Token 
715     ///  #`_fromUid` has insufficient balance to transfer. Throws if 
716     ///  tokenAddress has no transfer function.
717     /// @param _tokenAddress the ERC-20 contract address
718     /// @param _fromUid the TOY Token to withdraw the ERC-20 tokens from
719     /// @param _to the wallet address to send the ERC-20 tokens
720     /// @param _tokens the number of tokens to withdraw
721     //-------------------------------------------------------------------------
722     function transferERC20 (
723         address _tokenAddress, 
724         uint _fromUid, 
725         address _to, 
726         uint _tokens
727     ) external canOperate(_fromUid) notZero(_tokens) {
728         // TOY Token must have sufficient token balance
729         require (
730             externalTokenBalances[_tokenAddress][_fromUid] >= _tokens,
731             "insufficient tokens to withdraw"
732         );
733         // initialize token contract
734         ERC20 tokenContract = ERC20(_tokenAddress);
735         // subtract amount from TOY Token's balance
736         externalTokenBalances[_tokenAddress][_fromUid] -= _tokens;
737         
738         // call transfer function from token contract
739         tokenContract.transfer(_to, _tokens);
740     }
741 
742     //-------------------------------------------------------------------------
743     /// @notice Get external token balance for tokens deposited into TOY Token
744     ///  #`_uid`.
745     /// @dev To query Ether, use THIS CONTRACT'S address as '_tokenAddress'.
746     /// @param _uid Owner of the tokens to query
747     /// @param _tokenAddress Token creator contract address 
748     //-------------------------------------------------------------------------
749     function getExternalTokenBalance(
750         uint _uid, 
751         address _tokenAddress
752     ) external view returns (uint) {
753         return externalTokenBalances[_tokenAddress][_uid];
754     }
755 }
756 
757 
758 //-----------------------------------------------------------------------------
759 /// @title Ownable
760 /// @dev The Ownable contract has an owner address, and provides basic 
761 ///  authorization control functions, this simplifies the implementation of
762 ///  "user permissions".
763 //-----------------------------------------------------------------------------
764 contract Ownable {
765     //-------------------------------------------------------------------------
766     /// @dev Emits when owner address changes by any mechanism.
767     //-------------------------------------------------------------------------
768     event OwnershipTransfer (address previousOwner, address newOwner);
769     
770     // Wallet address that can sucessfully execute onlyOwner functions
771     address owner;
772     
773     //-------------------------------------------------------------------------
774     /// @dev Sets the owner of the contract to the sender account.
775     //-------------------------------------------------------------------------
776     constructor() public {
777         owner = msg.sender;
778         emit OwnershipTransfer(address(0), owner);
779     }
780 
781     //-------------------------------------------------------------------------
782     /// @dev Throws if called by any account other than `owner`.
783     //-------------------------------------------------------------------------
784     modifier onlyOwner() {
785         require(
786             msg.sender == owner, 
787             "Function can only be called by contract owner"
788         );
789         _;
790     }
791 
792     //-------------------------------------------------------------------------
793     /// @notice Transfer control of the contract to a newOwner.
794     /// @dev Throws if `_newOwner` is zero address.
795     /// @param _newOwner The address to transfer ownership to.
796     //-------------------------------------------------------------------------
797     function transferOwnership(address _newOwner) public onlyOwner {
798         // for safety, new owner parameter must not be 0
799         require (
800             _newOwner != address(0),
801             "New owner address cannot be zero"
802         );
803         // define local variable for old owner
804         address oldOwner = owner;
805         // set owner to new owner
806         owner = _newOwner;
807         // emit ownership transfer event
808         emit OwnershipTransfer(oldOwner, _newOwner);
809     }
810 }
811 
812 
813 //-----------------------------------------------------------------------------
814 /// @title TOY Token Interface Support
815 /// @notice Defines supported interfaces for ERC-721 wallets to query
816 //-----------------------------------------------------------------------------
817 contract ToyInterfaceSupport {
818     // mapping of all possible interfaces to whether they are supported
819     mapping (bytes4 => bool) interfaceIdToIsSupported;
820     
821     //-------------------------------------------------------------------------
822     /// @notice ToyInterfaceSupport constructor. Sets to true interfaces
823     ///  supported at launch.
824     //-------------------------------------------------------------------------
825     constructor () public {
826         // supports ERC-165
827         interfaceIdToIsSupported[0x01ffc9a7] = true;
828         // supports ERC-721
829         interfaceIdToIsSupported[0x80ac58cd] = true;
830         // supports ERC-721 Enumeration
831         interfaceIdToIsSupported[0x780e9d63] = true;
832         // supports ERC-721 Metadata
833         interfaceIdToIsSupported[0x5b5e139f] = true;
834     }
835 
836     //-------------------------------------------------------------------------
837     /// @notice Query if a contract implements an interface
838     /// @param interfaceID The interface identifier, as specified in ERC-165
839     /// @dev Interface identification is specified in ERC-165. This function
840     ///  uses less than 30,000 gas.
841     /// @return `true` if the contract implements `interfaceID` and
842     ///  `interfaceID` is not 0xffffffff, `false` otherwise
843     //-------------------------------------------------------------------------
844     function supportsInterface(
845         bytes4 interfaceID
846     ) external view returns (bool) {
847         if(interfaceID == 0xffffffff) {
848             return false;
849         } else {
850             return interfaceIdToIsSupported[interfaceID];
851         }
852     }
853 }
854 
855 
856 //-----------------------------------------------------------------------------
857 /// @title PLAY Token Interface
858 //-----------------------------------------------------------------------------
859 interface PlayInterface {
860     //-------------------------------------------------------------------------
861     /// @notice Get the number of PLAY tokens owned by `tokenOwner`.
862     /// @dev Throws if trying to query the zero address.
863     /// @param tokenOwner The PLAY token owner.
864     /// @return The number of PLAY tokens owned by `tokenOwner` (in pWei).
865     //-------------------------------------------------------------------------
866     function balanceOf(address tokenOwner) external view returns (uint);
867     
868     //-------------------------------------------------------------------------
869     /// @notice Lock `(tokens/1000000000000000000).fixed(0,18)` PLAY from 
870     ///  `from` for `numberOfYears` years.
871     /// @dev Throws if amount to lock is zero. Throws if numberOfYears is zero
872     ///  or greater than maximumLockYears. Throws if `msg.sender` has
873     ///  insufficient allowance to lock. Throws if `from` has insufficient
874     ///  balance to lock.
875     /// @param from The token owner whose PLAY is being locked. Sender must be
876     ///  an approved spender.
877     /// @param numberOfYears The number of years the tokens will be locked.
878     /// @param tokens The number of tokens to lock (in pWei).
879     //-------------------------------------------------------------------------
880     function lockFrom(address from, uint numberOfYears, uint tokens) 
881         external
882         returns(bool); 
883 }
884 
885 
886 //-----------------------------------------------------------------------------
887 /// @title TOY Token Creation
888 /// @notice Defines new TOY Token creation (minting) and TOY Token linking to
889 ///  RFID-enabled physical objects.
890 //-----------------------------------------------------------------------------
891 contract ToyCreation is Ownable, ExternalTokenHandler, ToyInterfaceSupport {
892     //-------------------------------------------------------------------------
893     /// @dev Link emits when an empty TOY Token gets assigned to a valid RFID.
894     //-------------------------------------------------------------------------
895     event Link(uint _oldUid, uint _newUid);
896 
897     // PLAY needed to mint one TOY Token (in pWei)
898     uint public priceToMint = 1000 * 10**18;
899     // Buffer added to the front of every TOY Token at time of creation. TOY
900     //  Tokens with a uid greater than the buffer are unlinked.
901     uint constant uidBuffer = 0x0100000000000000; // 14 zeroes
902     // PLAY Token Contract object to interface with.
903     PlayInterface play = PlayInterface(0xe2427cfEB5C330c007B8599784B97b65b4a3A819);
904 
905     //-------------------------------------------------------------------------
906     /// @notice Update PLAY Token contract variable with new contract address.
907     /// @dev Throws if `_newAddress` is the zero address.
908     /// @param _newAddress Updated contract address.
909     //-------------------------------------------------------------------------
910     function updatePlayTokenContract(address _newAddress) external onlyOwner {
911         play = PlayInterface(_newAddress);
912     }
913 
914     //-------------------------------------------------------------------------
915     /// @notice Change the number of PLAY tokens needed to mint a new TOY Token
916     ///  (in pWei).
917     /// @dev Throws if `_newPrice` is zero.
918     /// @param _newPrice The new price to mint (in pWei)
919     //-------------------------------------------------------------------------
920     function changeToyPrice(uint _newPrice) external onlyOwner {
921         priceToMint = _newPrice;
922     }
923 
924     //-------------------------------------------------------------------------
925     /// @notice Send and lock PLAY to mint a new empty TOY Token for yourself.
926     /// @dev Sender must have approved this contract address as an authorized
927     ///  spender with at least "priceToMint" PLAY. Throws if the sender has
928     ///  insufficient PLAY. Throws if sender has not granted this contract's
929     ///  address sufficient allowance.
930     //-------------------------------------------------------------------------
931     function mint() external {
932         play.lockFrom (msg.sender, 2, priceToMint);
933 
934         uint uid = uidBuffer + toyArray.length;
935         uint index = toyArray.push(ToyToken(msg.sender, uid, 0, 0, ""));
936         uidToToyIndex[uid] = index - 1;
937 
938         emit Transfer(0, msg.sender, uid);
939     }
940 
941     //-------------------------------------------------------------------------
942     /// @notice Send and lock PLAY to mint a new empty TOY Token for 'to'.
943     /// @dev Sender must have approved this contract address as an authorized
944     ///  spender with at least "priceToMint" PLAY. Throws if the sender has
945     ///  insufficient PLAY. Throws if sender has not granted this contract's
946     ///  address sufficient allowance.
947     /// @param _to The address to deduct PLAY Tokens from and send new TOY Token to.
948     //-------------------------------------------------------------------------
949     function mintAndSend(address _to) external {
950         play.lockFrom (msg.sender, 2, priceToMint);
951 
952         uint uid = uidBuffer + toyArray.length;
953         uint index = toyArray.push(ToyToken(_to, uid, 0, 0, ""));
954         uidToToyIndex[uid] = index - 1;
955 
956         emit Transfer(0, _to, uid);
957     }
958 
959     //-------------------------------------------------------------------------
960     /// @notice Send and lock PLAY to mint `_amount` new empty TOY Tokens for
961     ///  yourself.
962     /// @dev Sender must have approved this contract address as an authorized
963     ///  spender with at least "priceToMint" x `_amount` PLAY. Throws if the
964     ///  sender has insufficient PLAY. Throws if sender has not granted this
965     ///  contract's address sufficient allowance.
966     //-------------------------------------------------------------------------
967     function mintBulk(uint _amount) external {
968         play.lockFrom (msg.sender, 2, priceToMint * _amount);
969 
970         for (uint i = 0; i < _amount; ++i) {
971             uint uid = uidBuffer + toyArray.length;
972             uint index = toyArray.push(ToyToken(msg.sender, uid, 0, 0, ""));
973             uidToToyIndex[uid] = index - 1;
974             emit Transfer(0, msg.sender, uid);
975         }
976     }
977 
978     //-------------------------------------------------------------------------
979     /// @notice Change TOY Token #`_toyId` to TOY Token #`_newUid`. Writes any
980     ///  data passed through '_data' into the TOY Token's public data.
981     /// @dev Throws if TOY Token #`_toyId` does not exist. Throws if sender is
982     ///  not approved to operate for TOY Token. Throws if '_toyId' is smaller
983     ///  than 8 bytes. Throws if '_newUid' is bigger than 7 bytes. Throws if 
984     ///  '_newUid' is zero. Throws if '_newUid' is already taken.
985     /// @param _newUid The UID of the RFID chip to link to the TOY Token
986     /// @param _toyId The UID of the empty TOY Token to link
987     /// @param _data A byte string of data to attach to the TOY Token
988     //-------------------------------------------------------------------------
989     function link(
990         bytes7 _newUid, 
991         uint _toyId, 
992         bytes _data
993     ) external canOperate(_toyId) {
994         ToyToken storage toy = toyArray[uidToToyIndex[_toyId]];
995         // _toyId must be an empty TOY Token
996         require (_toyId > uidBuffer, "TOY Token already linked");
997         // _newUid field cannot be empty or greater than 7 bytes
998         require (_newUid > 0 && uint(_newUid) < UID_MAX, "Invalid new UID");
999         // a TOY Token with the new UID must not currently exist
1000         require (
1001             uidToToyIndex[uint(_newUid)] == 0, 
1002             "TOY Token with 'newUID' already exists"
1003         );
1004 
1005         // set new UID's mapping to index to old UID's mapping
1006         uidToToyIndex[uint(_newUid)] = uidToToyIndex[_toyId];
1007         // reset old UID's mapping to index
1008         uidToToyIndex[_toyId] = 0;
1009         // set TOY Token's UID to new UID
1010         toy.uid = uint(_newUid);
1011         // set any data
1012         toy.toyData = _data;
1013         // reset the timestamp
1014         toy.timestamp = now;
1015 
1016         emit Link(_toyId, uint(_newUid));
1017     }
1018 
1019     //-------------------------------------------------------------------------
1020     /// @notice Change TOY Token UIDs to new UIDs for multiple TOY Tokens.
1021     ///  Writes any data passed through '_data' into all the TOY Tokens' data.
1022     /// @dev Throws if any TOY Token's UID does not exist. Throws if sender is
1023     ///  not approved to operate for any TOY Token. Throws if any '_toyId' is
1024     ///  smaller than 8 bytes. Throws if any '_newUid' is bigger than 7 bytes. 
1025     ///  Throws if any '_newUid' is zero. Throws if '_newUid' is already taken.
1026     ///  Throws if array parameters are not the same length.
1027     /// @param _newUid The UID of the RFID chip to link to the TOY Token
1028     /// @param _toyId The UID of the empty TOY Token to link
1029     /// @param _data A byte string of data to attach to the TOY Token
1030     //-------------------------------------------------------------------------
1031     function linkBulk(
1032         bytes7[] _newUid, 
1033         uint[] _toyId, 
1034         bytes _data
1035     ) external {
1036         require (_newUid.length == _toyId.length, "Array lengths not equal");
1037         for (uint i = 0; i < _newUid.length; ++i) {
1038             ToyToken storage toy = toyArray[uidToToyIndex[_toyId[i]]];
1039             // sender must be authorized operator
1040             require (
1041                 msg.sender == toy.owner ||
1042                 msg.sender == idToApprovedAddress[_toyId[i]] ||
1043                 operatorApprovals[toy.owner][msg.sender],
1044                 "Not authorized to operate for this TOY Token"
1045             );
1046             // _toyId must be an empty TOY Token
1047             require (_toyId[i] > uidBuffer, "TOY Token already linked");
1048             // _newUid field cannot be empty or greater than 7 bytes
1049             require (_newUid[i] > 0 && uint(_newUid[i]) < UID_MAX, "Invalid new UID");
1050             // a TOY Token with the new UID must not currently exist
1051             require (
1052                 uidToToyIndex[uint(_newUid[i])] == 0, 
1053                 "TOY Token with 'newUID' already exists"
1054             );
1055 
1056             // set new UID's mapping to index to old UID's mapping
1057             uidToToyIndex[uint(_newUid[i])] = uidToToyIndex[_toyId[i]];
1058             // reset old UID's mapping to index
1059             uidToToyIndex[_toyId[i]] = 0;
1060             // set TOY Token's UID to new UID
1061             toy.uid = uint(_newUid[i]);
1062             // set any data
1063             toy.toyData = _data;
1064             // reset the timestamp
1065             toy.timestamp = now;
1066 
1067             emit Link(_toyId[i], uint(_newUid[i]));
1068         }
1069     }
1070 
1071     //-------------------------------------------------------------------------
1072     /// @notice Set external NFT #`_externalId` as TOY Token #`_toyUid`'s
1073     ///  linked external NFT.
1074     /// @dev Throws if sender is not authorized to operate TOY Token #`_toyUid`
1075     ///  Throws if '_toyUid' is bigger than 7 bytes. Throws if external NFT is
1076     ///  already linked. Throws if sender is not authorized to operate external
1077     ///  NFT.
1078     /// @param _toyUid The UID of the TOY Token to link
1079     /// @param _externalAddress The contract address of the external NFT
1080     /// @param _externalId The UID of the external NFT to link
1081     //-------------------------------------------------------------------------
1082     function linkExternalNft(
1083         uint _toyUid, 
1084         address _externalAddress, 
1085         uint _externalId
1086     ) external canOperate(_toyUid) {
1087         require(_toyUid < UID_MAX, "TOY Token not linked to a physical toy");
1088         require(
1089             linkedExternalNfts[_externalAddress][_externalId] == false,
1090             "External NFT already linked"
1091         );
1092         require(
1093             msg.sender == ERC721(_externalAddress).ownerOf(_externalId),
1094             "Sender does not own external NFT"
1095         );
1096         uidToExternalNft[_toyUid] = ExternalNft(_externalAddress, _externalId);
1097         linkedExternalNfts[_externalAddress][_externalId] = true;
1098     }
1099 }
1100 
1101 
1102 //-----------------------------------------------------------------------------
1103 /// @title TOY Token Interface
1104 /// @notice Interface for highest-level TOY Token getters
1105 //-----------------------------------------------------------------------------
1106 contract ToyInterface is ToyCreation {
1107     // URL Containing TOY Token metadata
1108     string metadataUrl = "http://52.9.230.48:8090/toy_token/";
1109 
1110     //-------------------------------------------------------------------------
1111     /// @notice Change old metadata URL to `_newUrl`
1112     /// @dev Throws if new URL is empty
1113     /// @param _newUrl The new URL containing TOY Token metadata
1114     //-------------------------------------------------------------------------
1115     function updateMetadataUrl(string _newUrl)
1116         external 
1117         onlyOwner 
1118         notZero(bytes(_newUrl).length)
1119     {
1120         metadataUrl = _newUrl;
1121     }
1122 
1123     //-------------------------------------------------------------------------
1124     /// @notice Gets all public info for TOY Token #`_uid`.
1125     /// @dev Throws if TOY Token #`_uid` does not exist.
1126     /// @param _uid the UID of the TOY Token to view.
1127     /// @return TOY Token owner, TOY Token UID, Creation Timestamp, Experience,
1128     ///  and Public Data.
1129     //-------------------------------------------------------------------------
1130     function changeToyData(uint _uid, bytes _data) 
1131         external 
1132         mustExist(_uid)
1133         canOperate(_uid)
1134         returns (address, uint, uint, uint, bytes) 
1135     {
1136         require(_uid < UID_MAX, "TOY Token must be linked");
1137         toyArray[uidToToyIndex[_uid]].toyData = _data;
1138     }
1139 
1140     //-------------------------------------------------------------------------
1141     /// @notice Gets all public info for TOY Token #`_uid`.
1142     /// @dev Throws if TOY Token #`_uid` does not exist.
1143     /// @param _uid the UID of the TOY Token to view.
1144     /// @return TOY Token owner, TOY Token UID, Creation Timestamp, Experience,
1145     ///  and Public Data.
1146     //-------------------------------------------------------------------------
1147     function getToy(uint _uid) 
1148         external
1149         view 
1150         mustExist(_uid) 
1151         returns (address, uint, uint, uint, bytes) 
1152     {
1153         ToyToken memory toy = toyArray[uidToToyIndex[_uid]];
1154         return(toy.owner, toy.uid, toy.timestamp, toy.exp, toy.toyData);
1155     }
1156 
1157     //-------------------------------------------------------------------------
1158     /// @notice Gets all info for TOY Token #`_uid`'s linked NFT.
1159     /// @dev Throws if TOY Token #`_uid` does not exist.
1160     /// @param _uid the UID of the TOY Token to view.
1161     /// @return NFT contract address, External NFT ID.
1162     //-------------------------------------------------------------------------
1163     function getLinkedNft(uint _uid) 
1164         external
1165         view 
1166         mustExist(_uid) 
1167         returns (address, uint) 
1168     {
1169         ExternalNft memory nft = uidToExternalNft[_uid];
1170         return (nft.nftContractAddress, nft.nftId);
1171     }
1172 
1173     //-------------------------------------------------------------------------
1174     /// @notice Gets whether NFT #`_externalId` is linked to a TOY Token.
1175     /// @param _externalAddress the contract address for the external NFT
1176     /// @param _externalId the UID of the external NFT to view.
1177     /// @return NFT contract address, External NFT ID.
1178     //-------------------------------------------------------------------------
1179     function externalNftIsLinked(address _externalAddress, uint _externalId)
1180         external
1181         view
1182         returns(bool)
1183     {
1184         return linkedExternalNfts[_externalAddress][_externalId];
1185     }
1186 
1187     //-------------------------------------------------------------------------
1188     /// @notice A descriptive name for a collection of NFTs in this contract
1189     //-------------------------------------------------------------------------
1190     function name() external pure returns (string) {
1191         return "TOY Tokens";
1192     }
1193 
1194     //-------------------------------------------------------------------------
1195     /// @notice An abbreviated name for NFTs in this contract
1196     //-------------------------------------------------------------------------
1197     function symbol() external pure returns (string) { return "TOY"; }
1198 
1199     //-------------------------------------------------------------------------
1200     /// @notice A distinct URL for a given asset.
1201     /// @dev Throws if `_tokenId` is not a valid NFT.
1202     ///  If:
1203     ///  * The URI is a URL
1204     ///  * The URL is accessible
1205     ///  * The URL points to a valid JSON file format (ECMA-404 2nd ed.)
1206     ///  * The JSON base element is an object
1207     ///  then these names of the base element SHALL have special meaning:
1208     ///  * "name": A string identifying the item to which `_tokenId` grants
1209     ///    ownership
1210     ///  * "description": A string detailing the item to which `_tokenId`
1211     ///    grants ownership
1212     ///  * "image": A URI pointing to a file of image/* mime type representing
1213     ///    the item to which `_tokenId` grants ownership
1214     ///  Wallets and exchanges MAY display this to the end user.
1215     ///  Consider making any images at a width between 320 and 1080 pixels and
1216     ///  aspect ratio between 1.91:1 and 4:5 inclusive.
1217     /// @param _tokenId The TOY Token whose metadata address is being queried
1218     //-------------------------------------------------------------------------
1219     function tokenURI(uint _tokenId) 
1220         external 
1221         view 
1222         returns (string) 
1223     {
1224         // convert TOY Token UID to a 14 character long string of character bytes
1225         bytes memory uidString = intToBytes(_tokenId);
1226         // declare new string of bytes with combined length of url and uid 
1227         bytes memory fullUrlBytes = new bytes(bytes(metadataUrl).length + uidString.length);
1228         // copy URL string and uid string into new string
1229         uint counter = 0;
1230         for (uint i = 0; i < bytes(metadataUrl).length; i++) {
1231             fullUrlBytes[counter++] = bytes(metadataUrl)[i];
1232         }
1233         for (i = 0; i < uidString.length; i++) {
1234             fullUrlBytes[counter++] = uidString[i];
1235         }
1236         // return full URL
1237         return string(fullUrlBytes);
1238     }
1239     
1240     //-------------------------------------------------------------------------
1241     /// @notice Convert int to 14 character bytes
1242     //-------------------------------------------------------------------------
1243     function intToBytes(uint _tokenId) 
1244         private 
1245         pure 
1246         returns (bytes) 
1247     {
1248         // convert int to bytes32
1249         bytes32 x = bytes32(_tokenId);
1250         
1251         // convert each byte into two, and assign each byte a hex digit
1252         bytes memory uidBytes64 = new bytes(64);
1253         for (uint i = 0; i < 32; i++) {
1254             byte b = byte(x[i]);
1255             byte hi = byte(uint8(b) / 16);
1256             byte lo = byte(uint8(b) - 16 * uint8(hi));
1257             uidBytes64[i*2] = char(hi);
1258             uidBytes64[i*2+1] = char(lo);
1259         }
1260         
1261         // reduce size to last 14 chars (7 bytes)
1262         bytes memory uidBytes = new bytes(14);
1263         for (i = 0; i < 14; ++i) {
1264             uidBytes[i] = uidBytes64[i + 50];
1265         }
1266         return uidBytes;
1267     }
1268     
1269     //-------------------------------------------------------------------------
1270     /// @notice Convert byte to UTF-8-encoded hex character
1271     //-------------------------------------------------------------------------
1272     function char(byte b) private pure returns (byte c) {
1273         if (b < 10) return byte(uint8(b) + 0x30);
1274         else return byte(uint8(b) + 0x57);
1275     }
1276 }