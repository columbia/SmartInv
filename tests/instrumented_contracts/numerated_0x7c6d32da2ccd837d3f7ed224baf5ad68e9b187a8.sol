1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC165
6 {
7     function supportsInterface(bytes4 interfaceId) external view returns (bool);
8 }
9 
10 
11 
12 interface IERC721 is IERC165
13 {
14     event   Transfer(      address indexed from,  address indexed to,       uint256  indexed tokenId);
15     event   Approval(      address indexed owner, address indexed approved, uint256  indexed tokenId);
16     event   ApprovalForAll(address indexed owner, address indexed operator, bool             approved);
17 
18     function balanceOf(        address owner)                                   external view returns (uint256 balance);
19     function ownerOf(          uint256 tokenId)                                 external view returns (address owner);
20     function safeTransferFrom( address from,     address to, uint256 tokenId)   external;
21     function transferFrom(     address from,     address to, uint256 tokenId)   external;
22     function approve(          address to,       uint256 tokenId)               external;
23     function getApproved(      uint256 tokenId)                                 external view returns (address operator);
24     function setApprovalForAll(address operator, bool _approved)                external;
25     function isApprovedForAll( address owner,    address operator)              external view returns (bool);
26     function safeTransferFrom( address from,     address to, uint256 tokenId, bytes calldata data) external;
27 }
28 
29 
30 
31 interface IERC721Metadata is IERC721
32 {
33     function name()                     external view returns (string memory);
34     function symbol()                   external view returns (string memory);
35     function tokenURI(uint256 tokenId)  external view returns (string memory);
36 }
37 
38 
39 
40 interface IERC721Enumerable is IERC721
41 {
42     function totalSupply()                                      external view returns (uint256);
43     function tokenOfOwnerByIndex(address owner, uint256 index)  external view returns (uint256 tokenId);
44     function tokenByIndex(uint256 index)                        external view returns (uint256);
45 }
46 
47 
48 
49 interface IERC721Receiver
50 {
51     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
52 }
53 
54 
55 
56 abstract contract ERC165 is IERC165
57 {
58     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool)
59     {
60         return (interfaceId == type(IERC165).interfaceId);
61     }
62 }
63 
64 
65 
66 abstract contract Context
67 {
68     function _msgSender() internal view virtual returns (address)
69     {
70         return msg.sender;
71     }
72    
73    
74     function _msgData() internal view virtual returns (bytes calldata)
75     {
76         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
77         return msg.data;
78     }
79 }
80 
81 
82 
83 abstract contract Ownable is Context
84 {
85     address private _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89    
90     constructor ()
91     {
92         address msgSender = _msgSender();
93                    _owner = msgSender;
94                    
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97    
98    
99     function owner() public view virtual returns (address)
100     {
101         return _owner;
102     }
103    
104    
105     modifier onlyOwner()
106     {
107         require(owner() == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110    
111    
112     function renounceOwnership() public virtual onlyOwner
113     {
114         emit OwnershipTransferred(_owner, address(0));
115        
116         _owner = address(0);
117     }
118    
119    
120     function transferOwnership(address newOwner) public virtual onlyOwner
121     {
122         require(newOwner != address(0), "Ownable: new owner is the zero address");
123        
124         emit OwnershipTransferred(_owner, newOwner);
125        
126         _owner = newOwner;
127     }
128 }
129 
130 
131 
132 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, Ownable
133 {
134     using Address for address;
135     using Strings for uint256;
136 
137     string private _name;   // Token name
138     string private _symbol; // Token symbol
139 
140     mapping(uint256 => address)                  internal _owners;              // Mapping from token ID to owner address
141     mapping(address => uint256)                  internal _balances;            // Mapping owner address to token count
142     mapping(uint256 => address)                  private  _tokenApprovals;      // Mapping from token ID to approved address
143     mapping(address => mapping(address => bool)) private  _operatorApprovals;   // Mapping from owner to operator approvals
144 
145    
146     constructor(string memory name_, string memory symbol_)
147     {
148         _name   = name_;
149         _symbol = symbol_;
150     }
151    
152    
153     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool)
154     {
155         return  interfaceId == type(IERC721).interfaceId         ||
156                 interfaceId == type(IERC721Metadata).interfaceId ||
157                 super.supportsInterface(interfaceId);
158     }
159    
160    
161     function balanceOf(address owner) public view virtual override returns (uint256)
162     {
163         require(owner != address(0), "ERC721: balance query for the zero address");
164        
165         return _balances[owner];
166     }
167    
168    
169     function ownerOf(uint256 tokenId) public view virtual override returns (address)
170     {
171         address owner = _owners[tokenId];
172         require(owner != address(0), "ERC721: owner query for nonexistent token");
173         return owner;
174     }
175    
176    
177     function name() public view virtual override returns (string memory)
178     {
179         return _name;
180     }
181    
182    
183     function symbol() public view virtual override returns (string memory)
184     {
185         return _symbol;
186     }
187    
188    
189     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
190     {
191         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
192 
193         string memory baseURI = _baseURI();
194        
195         return (bytes(baseURI).length>0) ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
196     }
197    
198    
199     function _baseURI() internal view virtual returns (string memory)
200     {
201         return "";
202     }
203    
204    
205     function approve(address to, uint256 tokenId) public virtual override
206     {
207         address owner = ERC721.ownerOf(tokenId);
208    
209         require(to!=owner, "ERC721: approval to current owner");
210         require(_msgSender()==owner || ERC721.isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
211 
212         _approve(to, tokenId);
213     }
214    
215    
216     function getApproved(uint256 tokenId) public view virtual override returns (address)
217     {
218         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
219 
220         return _tokenApprovals[tokenId];
221     }
222    
223    
224     function setApprovalForAll(address operator, bool approved) public virtual override
225     {
226         require(operator != _msgSender(), "ERC721: approve to caller");
227 
228         _operatorApprovals[_msgSender()][operator] = approved;
229    
230         emit ApprovalForAll(_msgSender(), operator, approved);
231     }
232    
233    
234     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool)
235     {
236         return _operatorApprovals[owner][operator];
237     }
238    
239    
240     function transferFrom(address from, address to, uint256 tokenId) public virtual override
241     {
242         //----- solhint-disable-next-line max-line-length
243        
244         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
245 
246         _transfer(from, to, tokenId);
247     }
248    
249    
250     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override
251     {
252         safeTransferFrom(from, to, tokenId, "");
253     }
254    
255    
256     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override
257     {
258         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
259        
260         _safeTransfer(from, to, tokenId, _data);
261     }
262    
263    
264     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual
265     {
266         _transfer(from, to, tokenId);
267    
268         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
269     }
270    
271    
272     function _exists(uint256 tokenId) internal view virtual returns (bool)
273     {
274         return _owners[tokenId] != address(0);
275     }
276    
277    
278     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool)
279     {
280         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
281        
282         address owner = ERC721.ownerOf(tokenId);
283        
284         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
285     }
286    
287    
288     function _safeMint(address to, uint256 tokenId) internal virtual
289     {
290         _safeMint(to, tokenId, "");
291     }
292    
293    
294     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual
295     {
296         _mint(to, tokenId);
297    
298         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
299     }
300    
301    
302     function _mint(address to, uint256 tokenId) internal virtual
303     {
304         require(to != address(0),  "ERC721: mint to the zero address");
305         require(!_exists(tokenId), "ERC721: token already minted");
306 
307         _beforeTokenTransfer(address(0), to, tokenId);
308 
309         _balances[to]   += 1;
310         _owners[tokenId] = to;
311 
312         emit Transfer(address(0), to, tokenId);
313     }
314    
315    
316     function _batchMint(address to, uint256[] memory tokenIds) internal virtual
317     {
318         require(to != address(0), "ERC721: mint to the zero address");
319        
320         _balances[to] += tokenIds.length;
321 
322         for (uint256 i=0; i < tokenIds.length; i++)
323         {
324             require(!_exists(tokenIds[i]), "ERC721: token already minted");
325 
326             _beforeTokenTransfer(address(0), to, tokenIds[i]);
327 
328             _owners[tokenIds[i]] = to;
329 
330             emit Transfer(address(0), to, tokenIds[i]);
331         }
332     }
333    
334    
335     function _burn(uint256 tokenId) internal virtual
336     {
337         address owner = ERC721.ownerOf(tokenId);
338 
339         _beforeTokenTransfer(owner, address(0), tokenId);
340 
341         _approve(address(0), tokenId);      // Clear approvals
342 
343         _balances[owner] -= 1;
344 
345         delete _owners[tokenId];
346 
347         emit Transfer(owner, address(0), tokenId);
348     }
349    
350    
351     function _transfer(address from, address to, uint256 tokenId) internal virtual
352     {
353         require(ERC721.ownerOf(tokenId)==from,  "ERC721: transfer of token that is not own");
354         require(to != address(0),               "ERC721: transfer to the zero address");
355 
356         _beforeTokenTransfer(from, to, tokenId);
357 
358         _approve(address(0), tokenId);      // Clear approvals from the previous owner
359 
360         _balances[from] -= 1;
361         _balances[to]   += 1;
362         _owners[tokenId] = to;
363 
364         emit Transfer(from, to, tokenId);
365     }
366    
367    
368     function _approve(address to, uint256 tokenId) internal virtual
369     {
370         _tokenApprovals[tokenId] = to;
371    
372         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
373     }
374    
375    
376     function _checkOnERC721Received(address from,address to,uint256 tokenId,bytes memory _data) private returns (bool)
377     {
378         if (to.isContract())
379         {
380             try
381            
382                 IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
383            
384             returns (bytes4 retval)
385             {
386                 return retval == IERC721Receiver(to).onERC721Received.selector;
387             }
388             catch (bytes memory reason)
389             {
390                 if (reason.length==0)
391                 {
392                     revert("ERC721: transfer to non ERC721Receiver implementer");
393                 }
394                 else
395                 {
396                     assembly { revert(add(32, reason), mload(reason)) }     //// solhint-disable-next-line no-inline-assembly
397                 }
398             }
399         }
400         else
401         {
402             return true;
403         }
404     }
405    
406    
407     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual
408     {
409         //
410     }
411 }
412 
413 
414 
415 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable
416 {
417     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;           // Mapping from owner to list of owned token IDs
418     mapping(uint256 => uint256)                     private _ownedTokensIndex;      // Mapping from token ID to index of the owner tokens list
419     mapping(uint256 => uint256)                     private _allTokensIndex;        // Mapping from token id to position in the allTokens array
420 
421     uint256[] private _allTokens;                                                   // Array with all token ids, used for enumeration
422 
423     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool)
424     {
425         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
426     }
427 
428     function totalSupply() public view virtual override returns (uint256)
429     {
430         return _allTokens.length;
431     }
432 
433     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256)
434     {
435         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
436    
437         return _ownedTokens[owner][index];
438     }
439 
440     function tokenByIndex(uint256 index) public view virtual override returns (uint256)
441     {
442         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
443    
444         return _allTokens[index];
445     }
446 
447     function _beforeTokenTransfer(address from,address to,uint256 tokenId) internal virtual override
448     {
449         super._beforeTokenTransfer(from, to, tokenId);
450 
451              if (from == address(0))     _addTokenToAllTokensEnumeration(tokenId);
452         else if (from != to)             _removeTokenFromOwnerEnumeration(from, tokenId);
453        
454              if (to == address(0))       _removeTokenFromAllTokensEnumeration(tokenId);
455         else if (to != from)             _addTokenToOwnerEnumeration(to, tokenId);
456     }
457 
458     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private
459     {
460         uint256 length = ERC721.balanceOf(to);
461    
462         _ownedTokens[to][length]   = tokenId;
463         _ownedTokensIndex[tokenId] = length;
464     }
465 
466     function _addTokenToAllTokensEnumeration(uint256 tokenId) private
467     {
468         _allTokensIndex[tokenId] = _allTokens.length;
469    
470         _allTokens.push(tokenId);
471     }
472 
473     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private
474     {
475         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
476         // then delete the last slot (swap and pop).
477 
478         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
479         uint256 tokenIndex = _ownedTokensIndex[tokenId];
480 
481         // When the token to delete is the last token, the swap operation is unnecessary
482         if (tokenIndex != lastTokenIndex) {
483             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
484 
485             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
486             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
487         }
488 
489         // This also deletes the contents at the last position of the array
490         delete _ownedTokensIndex[tokenId];
491         delete _ownedTokens[from][lastTokenIndex];
492     }
493 
494     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private
495     {
496         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
497         // then delete the last slot (swap and pop).
498 
499         uint256 lastTokenIndex = _allTokens.length - 1;
500         uint256 tokenIndex = _allTokensIndex[tokenId];
501 
502         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
503         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
504         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
505         uint256 lastTokenId = _allTokens[lastTokenIndex];
506 
507         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
508         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
509 
510         // This also deletes the contents at the last position of the array
511         delete _allTokensIndex[tokenId];
512         _allTokens.pop();
513     }
514 }
515 
516 
517 library Strings
518 {
519     bytes16 private constant alphabet = "0123456789abcdef";
520 
521    
522     function toString(uint256 value) internal pure returns (string memory)
523     {
524         // Inspired by OraclizeAPI's implementation - MIT licence
525         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
526 
527         if (value==0)       return "0";
528    
529         uint256 temp = value;
530         uint256 digits;
531    
532         while (temp!=0)
533         {
534             digits++;
535             temp /= 10;
536         }
537        
538         bytes memory buffer = new bytes(digits);
539        
540         while (value != 0)
541         {
542             digits        -= 1;
543             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
544             value         /= 10;
545         }
546        
547         return string(buffer);
548     }
549    
550    
551     function toHexString(uint256 value) internal pure returns (string memory)
552     {
553         if (value==0)       return "0x00";
554        
555         uint256 temp   = value;
556         uint256 length = 0;
557        
558         while (temp != 0)
559         {
560             length++;
561             temp >>= 8;
562         }
563        
564         return toHexString(value, length);
565     }
566    
567    
568     function toHexString(uint256 value, uint256 length) internal pure returns (string memory)
569     {
570         bytes memory buffer = new bytes(2 * length + 2);
571        
572         buffer[0] = "0";
573         buffer[1] = "x";
574        
575         for (uint256 i=2*length+1; i>1; --i)
576         {
577             buffer[i] = alphabet[value & 0xf];
578             value >>= 4;
579         }
580        
581         require(value == 0, "Strings: hex length insufficient");
582         return string(buffer);
583     }
584 }
585 
586 
587 
588 library Address
589 {
590     function isContract(address account) internal view returns (bool)
591     {
592         uint256 size;
593        
594         assembly { size := extcodesize(account) }   // solhint-disable-next-line no-inline-assembly
595         return size > 0;
596     }
597    
598    
599     function sendValue(address payable recipient, uint256 amount) internal
600     {
601         require(address(this).balance >= amount, "Address: insufficient balance");
602 
603         (bool success, ) = recipient.call{ value: amount }(""); // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
604 
605         require(success, "Address: unable to send value, recipient may have reverted");
606     }
607    
608    
609     function functionCall(address target, bytes memory data) internal returns (bytes memory)
610     {
611         return functionCall(target, data, "Address: low-level call failed");
612     }
613    
614    
615     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory)
616     {
617         return functionCallWithValue(target, data, 0, errorMessage);
618     }
619    
620    
621     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory)
622     {
623         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
624     }
625    
626    
627     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory)
628     {
629         require(address(this).balance >= value, "Address: insufficient balance for call");
630         require(isContract(target),             "Address: call to non-contract");
631 
632         (bool success, bytes memory returndata) = target.call{ value: value }(data);    // solhint-disable-next-line avoid-low-level-calls
633 
634         return _verifyCallResult(success, returndata, errorMessage);
635     }
636    
637    
638     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory)
639     {
640         return functionStaticCall(target, data, "Address: low-level static call failed");
641     }
642    
643    
644     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory)
645     {
646         require(isContract(target), "Address: static call to non-contract");
647 
648         (bool success, bytes memory returndata) = target.staticcall(data);  // solhint-disable-next-line avoid-low-level-calls
649 
650         return _verifyCallResult(success, returndata, errorMessage);
651     }
652    
653    
654     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory)
655     {
656         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
657     }
658    
659    
660     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory)
661     {
662         require(isContract(target), "Address: delegate call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.delegatecall(data);    // solhint-disable-next-line avoid-low-level-calls
665        
666         return _verifyCallResult(success, returndata, errorMessage);
667     }
668    
669    
670     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory)
671     {
672         if (success)
673         {
674             return returndata;
675         }
676         else
677         {
678             if (returndata.length > 0)      // Look for revert reason and bubble it up if present
679             {
680                 // The easiest way to bubble the revert reason is using memory via assembly
681                 // solhint-disable-next-line no-inline-assembly
682                 assembly
683                 {
684                     let returndata_size := mload(returndata)
685                     revert(add(32, returndata), returndata_size)
686                 }
687             }
688             else
689             {
690                 revert(errorMessage);
691             }
692         }
693     }
694 }
695 
696 
697 
698 contract LuckyCatz     is  ERC721Enumerable
699 {
700     using Address for address;
701     using Strings for uint256;
702 
703     modifier callerIsUser()
704     {
705         require(tx.origin == msg.sender, "The caller is another contract");
706         _;
707     }
708 
709     event   onWidthdrawal(address from, address to, uint256 amount);
710     event   onMaxMintPerWallet(uint256 lastMaxCount, uint256 newMaxCount);
711    
712     uint256 private     salesDate          = 1634482800;
713     uint256 private     salesPrice         = 0.0001 ether;//0.07 ether;
714 
715     uint256 private     totalTokens        = 7777;
716     uint256 private     leftTokenCount     = totalTokens;
717     uint256 private     mintedTokenCount   = 0;
718     uint256 private     maxMintPerWallet   = 7;
719    
720     string  private     baseURI = 'https://ipfs.io/ipfs/QmUaTJ3LvTr9FGVBDLwEi9nuyJwA2vK2tmVwXQYPbWRw4w/';
721 
722 address private ownerWallet;
723 
724     uint256 private maxReservableTokenCount = 777; //total reserved token for rewards and wages
725     uint256 private     totalReserved           = 0;
726 
727     mapping(address => uint256) private walletMintCounts;
728     mapping(address => uint256) private walletMintedTokenIds;
729 
730 
731     constructor() ERC721("Lucky Catz", "LUCKYCATZ")   // temporary Symbol and title
732     {
733         ownerWallet = msg.sender;
734     }
735      
736    
737 function nftTransfer(address to, uint256 tokenId) external
738 {
739 address fromAddr = _msgSender();
740 
741         require(_isApprovedOrOwner(fromAddr, tokenId), "ERC721: transfer caller is not owner nor approved");
742        
743         _transfer(fromAddr, to, tokenId);
744 
745         require(isERC721ReceivedCheck(fromAddr, to, tokenId, ""), "ERC721: transfer to non ERC721Receiver implementer");
746 }
747 
748 
749 function    isERC721ReceivedCheck(address from,address to,uint256 tokenId,bytes memory _data) private returns (bool)
750 {
751         if (to.isContract())
752         {
753             try
754            
755                 IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
756            
757             returns (bytes4 retval)
758             {
759                 return retval == IERC721Receiver(to).onERC721Received.selector;
760             }
761             catch (bytes memory reason)
762             {
763                 if (reason.length==0)
764                 {
765                     revert("ERC721: transfer to non ERC721Receiver implementer");
766                 }
767                 else
768                 {
769                     assembly { revert(add(32, reason), mload(reason)) }     //// solhint-disable-next-line no-inline-assembly
770                 }
771             }
772         }
773         else
774         {
775             return true;
776         }
777 }
778 
779 
780     function    setBaseTokenURI(string memory newUri) external onlyOwner
781     {
782         baseURI = newUri;
783     }
784    
785    
786     function    addAvailableTokens(uint256 extraAmount) external onlyOwner
787     {
788         totalTokens += extraAmount;
789     }
790    
791    
792     function    setSalesDate(uint256 newSalesDate) external onlyOwner
793     {
794         salesDate = newSalesDate;
795     }
796    
797    
798     function    baseTokenURI() external view returns (string memory)
799     {
800         return baseURI;
801     }
802    
803    
804     function    getAvailableTokens() external view returns (uint256)
805     {
806         return leftTokenCount;
807     }
808    
809    
810     function    getSalesPrice() external view returns (uint256)
811     {
812         return salesPrice;
813     }
814 
815 
816     function    setSalesPrice(uint256 newSalesPrice) external onlyOwner
817     {
818         salesPrice = newSalesPrice;
819     }
820 
821 
822     function    setmaxMintPerWallet(uint256 newMaxCount) external
823     {
824         uint256 lastMaxCount = maxMintPerWallet;
825        
826         maxMintPerWallet = newMaxCount;
827        
828         emit onMaxMintPerWallet(lastMaxCount, maxMintPerWallet);
829     }
830 
831 
832     function    _baseURI() internal view virtual override returns (string memory)
833     {
834         return baseURI;
835     }
836 
837 
838     function    getTokenIdsByWallet(address walletAddress) external view returns(uint256[] memory)
839     {
840         require(walletAddress!=address(0), "BlackHole wallet is not a real owner");
841        
842         uint256          count  = balanceOf(walletAddress);
843         uint256[] memory result = new uint256[](count);
844        
845         for (uint256 i=0; i<count; i++)
846         {
847             result[i] = tokenOfOwnerByIndex(walletAddress, i);
848         }
849        
850         return result;
851     }
852    
853 
854 function    setMaxReserve(uint256 newAmount) external onlyOwner
855     {
856         maxReservableTokenCount = newAmount;
857     }
858 
859 
860     function    reserveSomeTokens(uint256 amount)  external onlyOwner
861     {
862         require(amount         <= 200,                              "Reserve is limited to 200 per call at max");
863         require(leftTokenCount >= amount,                    "Not enough tokens left to reserve anymore");
864         //require(totalReserved+amount <= maxReservableTokenCount,  "Too many to reserve. Reduce the amount");
865        
866         for (uint256 i=0; i < amount; i++)
867         {
868     totalReserved++;
869             walletMintCounts[msg.sender]++;
870             mintedTokenCount++;
871             leftTokenCount--;
872            
873             _mint(msg.sender, mintedTokenCount);
874         }
875     }
876    
877    
878     function    mint() external payable callerIsUser
879     {
880         require(msg.value      >= salesPrice,         "Send exact Amount to claim your Nft");
881         require(leftTokenCount >  0,                  "No tokens left to be claimed");
882 
883         walletMintCounts[msg.sender]++;
884         mintedTokenCount++;
885         leftTokenCount--;
886 
887         _mint(msg.sender, mintedTokenCount);
888     }
889 
890 
891     function    batchMint(uint256 quantity) external payable callerIsUser
892     {
893         require(msg.value     >= salesPrice * quantity,   "Send exact Amount to claim your Nfts");
894         require(leftTokenCount>= quantity,                "No tokens left to be claimed");
895 
896         for (uint256 i=0; i < quantity; i++)
897         {
898             walletMintCounts[msg.sender]++;
899             mintedTokenCount++;
900             leftTokenCount--;
901 
902             _mint(msg.sender, mintedTokenCount);
903         }
904     }
905 
906     function    withdraw() external onlyOwner
907     {
908         address  fromAddr = address(this);
909         uint256  balance  = fromAddr.balance;
910        
911         payable(ownerWallet).transfer(fromAddr.balance);
912 
913         emit onWidthdrawal(fromAddr, ownerWallet, balance);
914     }
915 }