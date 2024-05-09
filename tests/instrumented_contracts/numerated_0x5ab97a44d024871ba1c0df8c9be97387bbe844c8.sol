1 pragma solidity >=0.5.0;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     require(c / a == b, "SafeMath#mul: OVERFLOW");
10 
11     return c;
12   }
13   
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
16     uint256 c = a / b;
17 
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     require(b <= a, "SafeMath#sub: UNDERFLOW");
23     uint256 c = a - b;
24 
25     return c;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     require(c >= a, "SafeMath#add: OVERFLOW");
31 
32     return c; 
33   }
34 
35   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
36     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
37     return a % b;
38   }
39 
40 }
41 
42 library Address {
43   function isContract(address account) internal view returns (bool) {
44     bytes32 codehash;
45     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
46 
47     // XXX Currently there is no better way to check if there is a contract in an address
48     // than to check the size of the code at that address.
49     // See https://ethereum.stackexchange.com/a/14016/36603
50     // for more details about how this works.
51     // TODO Check this again before the Serenity release, because all addresses will be
52     // contracts then.
53     assembly { codehash := extcodehash(account) }
54     return (codehash != 0x0 && codehash != accountHash);
55   }
56 
57 }
58 
59 library Strings {
60 	function strConcat(
61 		string memory _a,
62 		string memory _b,
63 		string memory _c,
64 		string memory _d,
65 		string memory _e
66 	) internal pure returns (string memory) {
67 		bytes memory _ba = bytes(_a);
68 		bytes memory _bb = bytes(_b);
69 		bytes memory _bc = bytes(_c);
70 		bytes memory _bd = bytes(_d);
71 		bytes memory _be = bytes(_e);
72 		string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
73 		bytes memory babcde = bytes(abcde);
74 		uint256 k = 0;
75 		for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
76 		for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
77 		for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
78 		for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
79 		for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
80 		return string(babcde);
81 	}
82 
83 	function strConcat(
84 		string memory _a,
85 		string memory _b,
86 		string memory _c,
87 		string memory _d
88 	) internal pure returns (string memory) {
89 		return strConcat(_a, _b, _c, _d, "");
90 	}
91 
92 	function strConcat(
93 		string memory _a,
94 		string memory _b,
95 		string memory _c
96 	) internal pure returns (string memory) {
97 		return strConcat(_a, _b, _c, "", "");
98 	}
99 
100 	function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
101 		return strConcat(_a, _b, "", "", "");
102 	}
103 
104 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
105 		if (_i == 0) {
106 			return "0";
107 		}
108 		uint256 j = _i;
109 		uint256 len;
110 		while (j != 0) {
111 			len++;
112 			j /= 10;
113 		}
114 		bytes memory bstr = new bytes(len);
115 		uint256 k = len - 1;
116 		while (_i != 0) {
117 			bstr[k--] = bytes1(uint8(48 + (_i % 10)));
118 			_i /= 10;
119 		}
120 		return string(bstr);
121 	}
122 }
123 
124 contract Context {
125     constructor () internal { }
126 
127     function _msgSender() internal view returns (address payable) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view returns (bytes memory) {
132         this; 
133         return msg.data;
134     }
135 }
136 
137 contract Ownable is Context {
138     address payable public owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     constructor () internal {
143         owner = msg.sender;
144         emit OwnershipTransferred(address(0), msg.sender);
145     }
146 
147     modifier onlyOwner() {
148         require(isOwner(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     function isOwner() public view returns (bool) {
153         return _msgSender() == owner;
154     }
155     
156     function renounceOwnership() public onlyOwner {
157         emit OwnershipTransferred(owner, address(0));
158         owner = address(0);
159     }
160     
161     function transferOwnership(address payable newOwner) public onlyOwner {
162         _transferOwnership(newOwner);
163     }
164 
165     function _transferOwnership(address payable newOwner) internal {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         emit OwnershipTransferred(owner, newOwner);
168         owner = newOwner;
169     }
170 }
171 
172 interface IERC165 {
173     /**
174      * @notice Query if a contract implements an interface
175      * @dev Interface identification is specified in ERC-165. This function
176      * uses less than 30,000 gas
177      * @param _interfaceId The interface identifier, as specified in ERC-165
178      */
179     function supportsInterface(bytes4 _interfaceId)
180     external
181     view
182     returns (bool);
183 }
184 
185 interface IERC721 {
186     /**
187      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
188      */
189     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
190 
191     /**
192      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
193      */
194     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
195 
196     /**
197      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
198      */
199     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
200 
201     /**
202      * @dev Returns the number of tokens in ``owner``'s account.
203      */
204     function balanceOf(address owner) external view returns (uint256 balance);
205 
206     /**
207      * @dev Returns the owner of the `tokenId` token.
208      *
209      * Requirements:
210      *
211      * - `tokenId` must exist.
212      */
213     function ownerOf(uint256 tokenId) external view returns (address owner);
214 
215     /**
216      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
217      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
218      *
219      * Requirements:
220      *
221      * - `from` cannot be the zero address.
222      * - `to` cannot be the zero address.
223      * - `tokenId` token must exist and be owned by `from`.
224      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
225      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
226      *
227      * Emits a {Transfer} event.
228      */
229     function safeTransferFrom(
230         address from,
231         address to,
232         uint256 tokenId
233     ) external;
234 
235     /**
236      * @dev Transfers `tokenId` token from `from` to `to`.
237      *
238      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
239      *
240      * Requirements:
241      *
242      * - `from` cannot be the zero address.
243      * - `to` cannot be the zero address.
244      * - `tokenId` token must be owned by `from`.
245      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(
250         address from,
251         address to,
252         uint256 tokenId
253     ) external;
254 
255     /**
256      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
257      * The approval is cleared when the token is transferred.
258      *
259      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
260      *
261      * Requirements:
262      *
263      * - The caller must own the token or be an approved operator.
264      * - `tokenId` must exist.
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address to, uint256 tokenId) external;
269 
270     /**
271      * @dev Returns the account approved for `tokenId` token.
272      *
273      * Requirements:
274      *
275      * - `tokenId` must exist.
276      */
277     function getApproved(uint256 tokenId) external view returns (address operator);
278 
279     /**
280      * @dev Approve or remove `operator` as an operator for the caller.
281      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
282      *
283      * Requirements:
284      *
285      * - The `operator` cannot be the caller.
286      *
287      * Emits an {ApprovalForAll} event.
288      */
289     function setApprovalForAll(address operator, bool _approved) external;
290 
291     /**
292      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
293      *
294      * See {setApprovalForAll}
295      */
296     function isApprovedForAll(address owner, address operator) external view returns (bool);
297 
298     /**
299      * @dev Safely transfers `tokenId` token from `from` to `to`.
300      *
301      * Requirements:
302      *
303      * - `from` cannot be the zero address.
304      * - `to` cannot be the zero address.
305      * - `tokenId` token must exist and be owned by `from`.
306      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
308      *
309      * Emits a {Transfer} event.
310      */
311     function safeTransferFrom(
312         address from,
313         address to,
314         uint256 tokenId,
315         bytes calldata data
316     ) external;
317 }
318 
319 interface IERC721Receiver {
320     /**
321      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
322      * by `operator` from `from`, this function is called.
323      *
324      * It must return its Solidity selector to confirm the token transfer.
325      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
326      *
327      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
328      */
329     function onERC721Received(
330         address operator,
331         address from,
332         uint256 tokenId,
333         bytes calldata data
334     ) external returns (bytes4);
335 }
336 
337 interface IERC721Metadata {
338     /**
339      * @dev Returns the token collection name.
340      */
341     function name() external view returns (string memory);
342 
343     /**
344      * @dev Returns the token collection symbol.
345      */
346     function symbol() external view returns (string memory);
347 
348     /**
349      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
350      */
351     function tokenURI(uint256 tokenId) external view returns (string memory);
352 }
353 
354 contract ERC721 is Context, IERC165, IERC721, IERC721Metadata {
355     using Address for address;
356 
357     // Token name
358     string public name;
359 
360     // Token symbol
361     string public symbol;
362 
363     // Mapping from token ID to owner address
364     mapping(uint256 => address) private _owners;
365 
366     // Mapping owner address to token count
367     mapping(address => uint256) private _balances;
368 
369     // Mapping from token ID to approved address
370     mapping(uint256 => address) private _tokenApprovals;
371 
372     // Mapping from owner to operator approvals
373     mapping(address => mapping(address => bool)) private _operatorApprovals;
374 
375     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
376     bytes4 constant private INTERFACE_SIGNATURE_ERC721 = 0x80ac58cd;
377     bytes4 constant private INTERFACE_SIGNATURE_ERC721METADATA = 0x5b5e139f;
378     bytes4 constant private INTERFACE_SIGNATURE_ERC721ENUMERABLE = 0x780e9d63;
379 
380     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
381         if (
382             _interfaceId == INTERFACE_SIGNATURE_ERC165 ||
383             _interfaceId == INTERFACE_SIGNATURE_ERC721 ||
384             _interfaceId == INTERFACE_SIGNATURE_ERC721METADATA ||
385             _interfaceId == INTERFACE_SIGNATURE_ERC721ENUMERABLE
386             ) {
387                 return true;
388             }
389         return false;
390     }
391 
392     /**
393      * @dev See {IERC721-balanceOf}.
394      */
395     function balanceOf(address owner) public view  returns (uint256) {
396         require(owner != address(0), "ERC721: balance query for the zero address");
397         return _balances[owner];
398     }
399 
400     /**
401      * @dev See {IERC721-ownerOf}.
402      */
403     function ownerOf(uint256 tokenId) public view  returns (address) {
404         address owner = _owners[tokenId];
405         require(owner != address(0), "ERC721: owner query for nonexistent token");
406         return owner;
407     }
408     
409     /**
410      * @dev See {IERC721-approve}.
411      */
412     function approve(address to, uint256 tokenId) public {
413         address owner = ERC721.ownerOf(tokenId);
414         require(to != owner, "ERC721: approval to current owner");
415 
416         require(
417             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
418             "ERC721: approve caller is not owner nor approved for all"
419         );
420 
421         _approve(to, tokenId);
422     }
423 
424     /**
425      * @dev See {IERC721-getApproved}.
426      */
427     function getApproved(uint256 tokenId) public view returns (address) {
428         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
429 
430         return _tokenApprovals[tokenId];
431     }
432 
433     /**
434      * @dev See {IERC721-setApprovalForAll}.
435      */
436     function setApprovalForAll(address operator, bool approved) public {
437         require(operator != _msgSender(), "ERC721: approve to caller");
438 
439         _operatorApprovals[_msgSender()][operator] = approved;
440         emit ApprovalForAll(_msgSender(), operator, approved);
441     }
442 
443     /**
444      * @dev See {IERC721-isApprovedForAll}.
445      */
446     function isApprovedForAll(address owner, address operator) public view returns (bool) {
447         return _operatorApprovals[owner][operator];
448     }
449 
450     /**
451      * @dev See {IERC721-transferFrom}.
452      */
453     function transferFrom(
454         address from,
455         address to,
456         uint256 tokenId
457     ) public {
458         //solhint-disable-next-line max-line-length
459         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
460 
461         _transfer(from, to, tokenId);
462     }
463 
464     /**
465      * @dev See {IERC721-safeTransferFrom}.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId
471     ) public {
472         safeTransferFrom(from, to, tokenId, "");
473     }
474 
475     /**
476      * @dev See {IERC721-safeTransferFrom}.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId,
482         bytes memory _data
483     ) public {
484         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
485         _safeTransfer(from, to, tokenId, _data);
486     }
487 
488     /**
489      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
490      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
491      *
492      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
493      *
494      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
495      * implement alternative mechanisms to perform token transfer, such as signature-based.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must exist and be owned by `from`.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function _safeTransfer(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes memory _data
511     ) internal {
512         _transfer(from, to, tokenId);
513         _checkOnERC721Received(from, to, tokenId, _data);
514     }
515 
516     /**
517      * @dev Returns whether `tokenId` exists.
518      *
519      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
520      *
521      * Tokens start existing when they are minted (`_mint`),
522      * and stop existing when they are burned (`_burn`).
523      */
524     function _exists(uint256 tokenId) internal view returns (bool) {
525         return _owners[tokenId] != address(0);
526     }
527 
528     /**
529      * @dev Returns whether `spender` is allowed to manage `tokenId`.
530      *
531      * Requirements:
532      *
533      * - `tokenId` must exist.
534      */
535     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
536         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
537         address owner = ERC721.ownerOf(tokenId);
538         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
539     }
540 
541     /**
542      * @dev Safely mints `tokenId` and transfers it to `to`.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must not exist.
547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
548      *
549      * Emits a {Transfer} event.
550      */
551     function _safeMint(address to, uint256 tokenId) internal {
552         _safeMint(to, tokenId, "");
553     }
554 
555     /**
556      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
557      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
558      */
559     function _safeMint(
560         address to,
561         uint256 tokenId,
562         bytes memory _data
563     ) internal {
564         _mint(to, tokenId);
565         _checkOnERC721Received(address(0), to, tokenId, _data);
566     }
567 
568     /**
569      * @dev Mints `tokenId` and transfers it to `to`.
570      *
571      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
572      *
573      * Requirements:
574      *
575      * - `tokenId` must not exist.
576      * - `to` cannot be the zero address.
577      *
578      * Emits a {Transfer} event.
579      */
580     function _mint(address to, uint256 tokenId) internal {
581         require(to != address(0), "ERC721: mint to the zero address");
582         require(!_exists(tokenId), "ERC721: token already minted");
583 
584         _beforeTokenTransfer(address(0), to, tokenId);
585 
586         _balances[to] += 1;
587         _owners[tokenId] = to;
588 
589         emit Transfer(address(0), to, tokenId);
590     }
591 
592     /**
593      * @dev Destroys `tokenId`.
594      * The approval is cleared when the token is burned.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      *
600      * Emits a {Transfer} event.
601      */
602     function _burn(uint256 tokenId) internal {
603         address owner = ERC721.ownerOf(tokenId);
604 
605         _beforeTokenTransfer(owner, address(0), tokenId);
606 
607         // Clear approvals
608         _approve(address(0), tokenId);
609 
610         _balances[owner] -= 1;
611         delete _owners[tokenId];
612 
613         emit Transfer(owner, address(0), tokenId);
614     }
615 
616     /**
617      * @dev Transfers `tokenId` from `from` to `to`.
618      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
619      *
620      * Requirements:
621      *
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must be owned by `from`.
624      *
625      * Emits a {Transfer} event.
626      */
627     function _transfer(
628         address from,
629         address to,
630         uint256 tokenId
631     ) internal {
632         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
633         require(to != address(0), "ERC721: transfer to the zero address");
634 
635         _beforeTokenTransfer(from, to, tokenId);
636 
637         // Clear approvals from the previous owner
638         _approve(address(0), tokenId);
639 
640         _balances[from] -= 1;
641         _balances[to] += 1;
642         _owners[tokenId] = to;
643 
644         emit Transfer(from, to, tokenId);
645     }
646 
647     /**
648      * @dev Approve `to` to operate on `tokenId`
649      *
650      * Emits a {Approval} event.
651      */
652     function _approve(address to, uint256 tokenId) internal {
653         _tokenApprovals[tokenId] = to;
654         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
655     }
656 
657     /**
658      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
659      * The call is not executed if the target address is not a contract.
660      *
661      * @param from address representing the previous owner of the given token ID
662      * @param to target address that will receive the tokens
663      * @param tokenId uint256 ID of the token to be transferred
664      * @param _data bytes optional data to send along with the call
665      * @return bool whether the call correctly returned the expected magic value
666      */
667     bytes4 constant internal ERC721_RECEIVED_VALUE = 0xf0b9e5ba; 
668     
669     function _checkOnERC721Received(
670         address from,
671         address to,
672         uint256 tokenId,
673         bytes memory _data
674     ) private{
675         if (to.isContract()) {
676             bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
677             require(retval == ERC721_RECEIVED_VALUE, "ERC721: INVALID_ON_RECEIVE_MESSAGE");
678         }
679             
680     }
681 
682     /**
683      * @dev Hook that is called before any token transfer. This includes minting
684      * and burning.
685      *
686      * Calling conditions:
687      *
688      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
689      * transferred to `to`.
690      * - When `from` is zero, `tokenId` will be minted for `to`.
691      * - When `to` is zero, ``from``'s `tokenId` will be burned.
692      * - `from` and `to` are never both zero.
693      *
694      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
695      */
696     function _beforeTokenTransfer(
697         address from,
698         address to,
699         uint256 tokenId
700     ) internal {}
701 }
702 
703 contract OwnableDelegateProxy {}
704 
705 contract ProxyRegistry {
706 	mapping(address => OwnableDelegateProxy) public proxies;
707 }
708 
709 
710 interface ERC721Token {
711     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
712     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
713     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
714 
715     function balanceOf(address owner) external view returns (uint256 balance);
716     function ownerOf(uint256 tokenId) external view returns (address owner);
717     function safeTransferFrom(address from, address to, uint256 tokenId) external;
718     function transferFrom(address from, address to, uint256 tokenId) external;
719     function approve(address to, uint256 tokenId) external;
720     function getApproved(uint256 tokenId) external view returns (address operator);
721     function setApprovalForAll(address operator, bool _approved) external;
722     function isApprovedForAll(address owner, address operator) external view returns (bool);
723     function safeTransferFrom(address from, address to, uint256 tokenId,  bytes calldata data) external;
724 
725     function supportsInterface(bytes4 interfaceID) external view returns (bool);
726 }
727 
728 contract ERC721Tradable is ERC721, Ownable{
729     using SafeMath for uint256;
730     using Strings for string;
731     
732     event NFTGenerated(address indexed _owner, uint256 indexed _nftId, uint256 _series);
733     event NewNFTPrice(uint256 indexed _newprice);
734     
735     string internal baseMetadataURI;
736 	address proxyRegistryAddress;
737 	uint256 public totalNFTs;
738 	uint256 NFTAvaliable;
739 	uint256 public currentNFTid = 0;
740 	uint256 public NFTprice = 0.05 * 10**18;
741 	
742 	uint256 totalAirDrop;
743 	uint256 totalAuthorize;
744 	uint256 totalPerverse;
745 	uint256 totalFreeBuy;
746 	
747     uint256 series = 0;
748 	
749 	mapping (address => uint256) public MarketingQuota;
750 	mapping (address => bool) public PartnerTokenCheck;
751 	mapping (address => bool) public IfWhiteList;
752 	mapping (address => bool) public Authorized;
753 	
754 	bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
755 	ERC721Token public CryptoPunks;
756 	ERC721Token public LOSTPOETS;
757 	ERC721Token public PakCube;
758 	ERC721Token public TheCurrency;
759 	
760 	bool public canMint = true;
761 	modifier CanMint() {
762 	    require(canMint);
763 	    _;
764 	}
765     
766 	constructor(
767 		string memory  _name,
768 		string memory _symbol,
769 		uint256 _totalNFTs,
770 		uint256 _airdrop,
771 		uint256 _authorize,
772 		uint256 _perserve,
773 		uint256 _freebuy,
774 		address _proxyRegistryAddress
775 	) public {
776 		name = _name;
777 		symbol = _symbol;
778 		totalNFTs = _totalNFTs;
779 		totalAirDrop = _airdrop;
780 		totalAuthorize = _authorize;
781 		totalPerverse = _perserve;
782 		totalFreeBuy = _freebuy;
783 		NFTAvaliable = _totalNFTs - _airdrop - _authorize - _perserve;
784 		proxyRegistryAddress = _proxyRegistryAddress;
785 	}
786 	
787 	function mintDisable() public onlyOwner {
788 	    canMint = false;
789 	}
790 	
791 	function mintEnable() public onlyOwner {
792 	    canMint = true;
793 	}
794 	
795 	// Regular Purchase
796 	function buyNFT(uint256 _amount) public payable CanMint {
797 	    require(msg.value >= NFTprice.mul(_amount), "Insufficient ETH");
798 	    require(totalFreeBuy >= _amount);
799 	    require(currentNFTid.add(_amount) <= totalNFTs+1, "Total Amount Exceed!");
800 	    for(uint i=0; i< _amount; i++) {
801 	        _mint(msg.sender, currentNFTid);
802 	        currentNFTid = currentNFTid.add(1);
803 	        emit NFTGenerated(msg.sender, currentNFTid, series);
804 	    }
805 	    totalFreeBuy = totalFreeBuy.sub(_amount);
806 	}
807 	
808 	function adminGenerator(uint256 _amount, address receiver) public onlyOwner CanMint {
809 	    require(currentNFTid.add(_amount) <= totalNFTs+1, "Total Amount Exceed!");
810 	    require(NFTAvaliable >= _amount, "NFT not available");
811 	    require(totalPerverse >= _amount, "Perserve Amount Exceed!");
812 	    for(uint i=0; i< _amount; i++) {
813 	        _mint(receiver, currentNFTid);
814 	        currentNFTid = currentNFTid.add(1);
815 	        emit NFTGenerated(receiver, currentNFTid, series);
816 	    }
817 	    NFTAvaliable = NFTAvaliable.sub(_amount);
818 	    totalPerverse = totalPerverse.sub(_amount);
819 	}
820 	
821 	function marketGenerator(uint256 _amount, address receiver) public CanMint {
822 	    require(MarketingQuota[msg.sender] >= _amount, "Marketing Quota is not enough!");
823 	    require(currentNFTid.add(_amount) <= totalNFTs+1, "Total Amount Exceed!");
824 	    for(uint i=0; i< _amount; i++) {
825 	        _mint(receiver, currentNFTid);
826 	        currentNFTid = currentNFTid.add(1);
827 	        emit NFTGenerated(receiver, currentNFTid, series);
828 	    }
829 	    MarketingQuota[msg.sender] = MarketingQuota[msg.sender].sub(_amount);
830 	}
831 	
832 	function authorizedGenerator(uint256 _amount, address receiver) public CanMint {
833 	    require(Authorized[msg.sender]);
834 	    require(totalAuthorize >= _amount);
835 	    require(currentNFTid.add(_amount) <= totalNFTs+1, "Total Amount Exceed!");
836 	    for(uint i=0; i< _amount; i++) {
837 	        _mint(receiver, currentNFTid);
838 	        currentNFTid = currentNFTid.add(1);
839 	        emit NFTGenerated(receiver, currentNFTid, series);
840 	    }
841 	    totalAuthorize = totalAuthorize.sub(_amount);
842 	}
843 	
844 	function authorizeAddress(address _vp) public onlyOwner {
845 	    Authorized[_vp] = true;
846 	}
847 	
848 	function cancelAuthorized(address _vp) public onlyOwner {
849 	    Authorized[_vp] = false;
850 	}
851 	
852 	function setSeries(uint256 _series) public onlyOwner {
853 	    series = _series;
854 	}
855 	
856 	function setMarketQuota(address _spender, uint256 _amount) public onlyOwner {
857 	    require(_amount >0);
858 	    require(NFTAvaliable >= _amount);
859 	    MarketingQuota[_spender] = MarketingQuota[_spender] + _amount;
860 	    NFTAvaliable = NFTAvaliable.sub(_amount);
861 	}
862 	
863 	function airdrop() public CanMint {
864 	    require(_canAirdrop(msg.sender) || _ifWhiteListed(msg.sender), "Unqualified!");
865 	    require(currentNFTid <= totalNFTs, "Total Amount Exceed!");
866 	    require(totalAirDrop > 0);
867 	    _mint(msg.sender, currentNFTid);
868 	    currentNFTid = currentNFTid.add(1);
869 	    emit NFTGenerated(msg.sender, currentNFTid, series);
870 	    if(IfWhiteList[msg.sender]) {
871 	        IfWhiteList[msg.sender] = false;
872 	    } else {
873 	        PartnerTokenCheck[msg.sender] = true;
874 	    }
875 	    totalAirDrop = totalAirDrop.sub(1);
876 	}
877 	
878 	function setWhitelist(address[] memory _users) public onlyOwner {
879 	    uint userLength = _users.length;
880 	    for (uint i = 0; i < userLength; i++) {
881 	        IfWhiteList[_users[i]] = true;
882 	    }
883 	}
884 	
885 	function initialPartnerNFT(address _cryptoPunksAddress, address _lostpoetsAddress, address _pakCube, address _theCurrencyAddress) public onlyOwner {
886 	    ERC721Token cryptoPunks = ERC721Token(_cryptoPunksAddress);
887         CryptoPunks = cryptoPunks;
888         
889         ERC721Token lostpoets = ERC721Token(_lostpoetsAddress);
890         LOSTPOETS = lostpoets;
891         
892         ERC721Token pakCube = ERC721Token(_pakCube);
893         PakCube = pakCube;
894         
895         ERC721Token theCurrencyAddress = ERC721Token(_theCurrencyAddress);
896         TheCurrency = theCurrencyAddress;
897 	}
898 
899 	function _canAirdrop(address _user) private view returns(bool) {
900 	    if (PartnerTokenCheck[_user]){
901 	        return false;
902 	    }
903 	    if(CryptoPunks.balanceOf(_user) > 0) {
904 	        return true;
905 	    } else if (LOSTPOETS.balanceOf(_user) > 0) {
906 	        return true;
907 	    } else if (PakCube.balanceOf(_user) > 0) {
908 	        return true;
909 	    } else if (TheCurrency.balanceOf(_user) > 0) {
910 	        return true;
911 	    } else{
912 	        return false;
913 	    }
914 	}
915 	
916 	function _ifWhiteListed(address _user) private view returns(bool) {
917 	    return IfWhiteList[_user];
918 	}
919 	
920 	function setNFTPrice(uint256 _newPrice) public onlyOwner {
921 	    require(_newPrice > 0);
922 	    NFTprice = _newPrice;
923 	    emit NewNFTPrice(_newPrice);
924 	}
925 	
926 	function setProxyAddress(address _proxyAddress) public onlyOwner {
927 	    proxyRegistryAddress = _proxyAddress;
928 	}
929 
930     function tokenURI(uint256 _tokenId) public view returns (string memory) {
931         require(_exists(_tokenId), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
932         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_tokenId));
933     }
934     
935     function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
936         baseMetadataURI = _newBaseMetadataURI;
937     }
938 
939 	function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyOwner {
940 		_setBaseMetadataURI(_newBaseMetadataURI);
941 	}
942 
943 	function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
944 		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
945 		if (address(proxyRegistry.proxies(_owner)) == _operator) {
946 			return true;
947 		}
948 
949 		return ERC721.isApprovedForAll(_owner, _operator);
950 	}
951 }
952 
953 contract CosmoChamber is ERC721Tradable {
954 	constructor(address _proxyRegistryAddress) public ERC721Tradable("CosmoChamber", "CC", 6001, 800, 500, 500, 4201, _proxyRegistryAddress) {
955 		_setBaseMetadataURI("https://api.cosmochamber.art/metadata/");
956 	}
957 
958 	function contractURI() public pure returns (string memory) {
959 		return "https://www.cosmoschanmber.art/about-us";
960 	}
961 	
962 	function withdrawBalance() external onlyOwner {
963         owner.transfer(address(this).balance);
964     }
965 
966 }