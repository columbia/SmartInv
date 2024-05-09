1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC165 {
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 
10 pragma solidity ^0.8.0;
11 
12 interface IERC721 is IERC165 {
13     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
14     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
15     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
16 
17     function balanceOf(address owner) external view returns (uint256 balance);
18 
19     function ownerOf(uint256 tokenId) external view returns (address owner);
20 
21     function safeTransferFrom(address from, address to, uint256 tokenId) external;
22 
23     function transferFrom(address from, address to, uint256 tokenId) external;
24 
25     function approve(address to, uint256 tokenId) external;
26 
27     function getApproved(uint256 tokenId) external view returns (address operator);
28 
29     function setApprovalForAll(address operator, bool _approved) external;
30 
31     function isApprovedForAll(address owner, address operator) external view returns (bool);
32 
33     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
34 }
35 
36 
37 
38 pragma solidity ^0.8.0;
39 
40 interface IERC721Receiver {
41 
42     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
43 }
44 
45 
46 pragma solidity ^0.8.0;
47 
48 interface IERC721Metadata is IERC721 {
49 
50     function name() external view returns (string memory);
51 
52     function symbol() external view returns (string memory);
53 
54     function tokenURI(uint256 tokenId) external view returns (string memory);
55 }
56 
57 
58 
59 pragma solidity ^0.8.0;
60 
61 library Address {
62     function isContract(address account) internal view returns (bool) {
63 
64         uint256 size;
65         assembly { size := extcodesize(account) }
66         return size > 0;
67     }
68 
69     function sendValue(address payable recipient, uint256 amount) internal {
70         require(address(this).balance >= amount, "Address: insufficient balance");
71 
72         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
73         (bool success, ) = recipient.call{ value: amount }("");
74         require(success, "Address: unable to send value, recipient may have reverted");
75     }
76 
77     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
78       return functionCall(target, data, "Address: low-level call failed");
79     }
80 
81     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
82         return functionCallWithValue(target, data, 0, errorMessage);
83     }
84 
85     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
86         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
87     }
88 
89     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
90         require(address(this).balance >= value, "Address: insufficient balance for call");
91         require(isContract(target), "Address: call to non-contract");
92 
93         (bool success, bytes memory returndata) = target.call{ value: value }(data);
94         return _verifyCallResult(success, returndata, errorMessage);
95     }
96 
97     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
98         return functionStaticCall(target, data, "Address: low-level static call failed");
99     }
100 
101     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
102         require(isContract(target), "Address: static call to non-contract");
103 
104         (bool success, bytes memory returndata) = target.staticcall(data);
105         return _verifyCallResult(success, returndata, errorMessage);
106     }
107 
108     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
109         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
110     }
111 
112     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
113         require(isContract(target), "Address: delegate call to non-contract");
114 
115         (bool success, bytes memory returndata) = target.delegatecall(data);
116         return _verifyCallResult(success, returndata, errorMessage);
117     }
118 
119     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
120         if (success) {
121             return returndata;
122         } else {
123             if (returndata.length > 0) {
124 
125                 assembly {
126                     let returndata_size := mload(returndata)
127                     revert(add(32, returndata), returndata_size)
128                 }
129             } else {
130                 revert(errorMessage);
131             }
132         }
133     }
134 }
135 
136 
137 pragma solidity ^0.8.0;
138 
139 abstract contract Context {
140     function _msgSender() internal view virtual returns (address) {
141         return msg.sender;
142     }
143 
144     function _msgData() internal view virtual returns (bytes calldata) {
145         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
146         return msg.data;
147     }
148 }
149 
150 
151 pragma solidity ^0.8.0;
152 
153 library Strings {
154     bytes16 private constant alphabet = "0123456789abcdef";
155 
156     function toString(uint256 value) internal pure returns (string memory) {
157 
158         if (value == 0) {
159             return "0";
160         }
161         uint256 temp = value;
162         uint256 digits;
163         while (temp != 0) {
164             digits++;
165             temp /= 10;
166         }
167         bytes memory buffer = new bytes(digits);
168         while (value != 0) {
169             digits -= 1;
170             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
171             value /= 10;
172         }
173         return string(buffer);
174     }
175 
176     function toHexString(uint256 value) internal pure returns (string memory) {
177         if (value == 0) {
178             return "0x00";
179         }
180         uint256 temp = value;
181         uint256 length = 0;
182         while (temp != 0) {
183             length++;
184             temp >>= 8;
185         }
186         return toHexString(value, length);
187     }
188 
189     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
190         bytes memory buffer = new bytes(2 * length + 2);
191         buffer[0] = "0";
192         buffer[1] = "x";
193         for (uint256 i = 2 * length + 1; i > 1; --i) {
194             buffer[i] = alphabet[value & 0xf];
195             value >>= 4;
196         }
197         require(value == 0, "Strings: hex length insufficient");
198         return string(buffer);
199     }
200 
201 }
202 
203 
204 
205 pragma solidity ^0.8.0;
206 
207 abstract contract ERC165 is IERC165 {
208     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
209         return interfaceId == type(IERC165).interfaceId;
210     }
211 }
212 
213 
214 
215 pragma solidity ^0.8.0;
216 
217 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
218     using Address for address;
219     using Strings for uint256;
220 
221     // Token name
222     string private _name;
223 
224     // Token symbol
225     string private _symbol;
226 
227     // Mapping from token ID to owner address
228     mapping (uint256 => address) private _owners;
229 
230     // Mapping owner address to token count
231     mapping (address => uint256) private _balances;
232 
233     // Mapping from token ID to approved address
234     mapping (uint256 => address) private _tokenApprovals;
235 
236     // Mapping from owner to operator approvals
237     mapping (address => mapping (address => bool)) private _operatorApprovals;
238 
239     constructor (string memory name_, string memory symbol_) {
240         _name = name_;
241         _symbol = symbol_;
242     }
243 
244     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
245         return interfaceId == type(IERC721).interfaceId
246             || interfaceId == type(IERC721Metadata).interfaceId
247             || super.supportsInterface(interfaceId);
248     }
249 
250     function balanceOf(address owner) public view virtual override returns (uint256) {
251         require(owner != address(0), "ERC721: balance query for the zero address");
252         return _balances[owner];
253     }
254 
255     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
256         address owner = _owners[tokenId];
257         require(owner != address(0), "ERC721: owner query for nonexistent token");
258         return owner;
259     }
260 
261     function name() public view virtual override returns (string memory) {
262         return _name;
263     }
264 
265     function symbol() public view virtual override returns (string memory) {
266         return _symbol;
267     }
268 
269     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
270         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
271 
272         string memory baseURI = _baseURI();
273         return bytes(baseURI).length > 0
274             ? string(abi.encodePacked(baseURI, tokenId.toString()))
275             : '';
276     }
277 
278     function _baseURI() internal view virtual returns (string memory) {
279         return "";
280     }
281 
282     function approve(address to, uint256 tokenId) public virtual override {
283         address owner = ERC721.ownerOf(tokenId);
284         require(to != owner, "ERC721: approval to current owner");
285 
286         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
287             "ERC721: approve caller is not owner nor approved for all"
288         );
289 
290         _approve(to, tokenId);
291     }
292 
293     function getApproved(uint256 tokenId) public view virtual override returns (address) {
294         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
295 
296         return _tokenApprovals[tokenId];
297     }
298 
299     function setApprovalForAll(address operator, bool approved) public virtual override {
300         require(operator != _msgSender(), "ERC721: approve to caller");
301 
302         _operatorApprovals[_msgSender()][operator] = approved;
303         emit ApprovalForAll(_msgSender(), operator, approved);
304     }
305 
306     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
307         return _operatorApprovals[owner][operator];
308     }
309 
310     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
311         //solhint-disable-next-line max-line-length
312         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
313 
314         _transfer(from, to, tokenId);
315     }
316 
317     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
318         safeTransferFrom(from, to, tokenId, "");
319     }
320 
321     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
322         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
323         _safeTransfer(from, to, tokenId, _data);
324     }
325 
326     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
327         _transfer(from, to, tokenId);
328         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
329     }
330 
331     function _exists(uint256 tokenId) internal view virtual returns (bool) {
332         return _owners[tokenId] != address(0);
333     }
334 
335     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
336         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
337         address owner = ERC721.ownerOf(tokenId);
338         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
339     }
340 
341     function _safeMint(address to, uint256 tokenId) internal virtual {
342         _safeMint(to, tokenId, "");
343     }
344 
345     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
346         _mint(to, tokenId);
347         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
348     }
349 
350     function _mint(address to, uint256 tokenId) internal virtual {
351         require(to != address(0), "ERC721: mint to the zero address");
352         require(!_exists(tokenId), "ERC721: token already minted");
353 
354         _beforeTokenTransfer(address(0), to, tokenId);
355 
356         _balances[to] += 1;
357         _owners[tokenId] = to;
358 
359         emit Transfer(address(0), to, tokenId);
360     }
361 
362     function _burn(uint256 tokenId) internal virtual {
363         address owner = ERC721.ownerOf(tokenId);
364 
365         _beforeTokenTransfer(owner, address(0), tokenId);
366 
367         // Clear approvals
368         _approve(address(0), tokenId);
369 
370         _balances[owner] -= 1;
371         delete _owners[tokenId];
372 
373         emit Transfer(owner, address(0), tokenId);
374     }
375 
376     function _transfer(address from, address to, uint256 tokenId) internal virtual {
377         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
378         require(to != address(0), "ERC721: transfer to the zero address");
379 
380         _beforeTokenTransfer(from, to, tokenId);
381 
382         // Clear approvals from the previous owner
383         _approve(address(0), tokenId);
384 
385         _balances[from] -= 1;
386         _balances[to] += 1;
387         _owners[tokenId] = to;
388 
389         emit Transfer(from, to, tokenId);
390     }
391 
392     function _approve(address to, uint256 tokenId) internal virtual {
393         _tokenApprovals[tokenId] = to;
394         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
395     }
396 
397     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
398         private returns (bool)
399     {
400         if (to.isContract()) {
401             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
402                 return retval == IERC721Receiver(to).onERC721Received.selector;
403             } catch (bytes memory reason) {
404                 if (reason.length == 0) {
405                     revert("ERC721: transfer to non ERC721Receiver implementer");
406                 } else {
407                     // solhint-disable-next-line no-inline-assembly
408                     assembly {
409                         revert(add(32, reason), mload(reason))
410                     }
411                 }
412             }
413         } else {
414             return true;
415         }
416     }
417 
418     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
419 }
420 
421 
422 pragma solidity ^0.8.0;
423 
424 abstract contract ERC721URIStorage is ERC721 {
425     using Strings for uint256;
426 
427     mapping (uint256 => string) private _tokenURIs;
428 
429     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
430         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
431 
432         string memory _tokenURI = _tokenURIs[tokenId];
433         string memory base = _baseURI();
434 
435         // If there is no base URI, return the token URI.
436         if (bytes(base).length == 0) {
437             return _tokenURI;
438         }
439         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
440         if (bytes(_tokenURI).length > 0) {
441             return string(abi.encodePacked(base, _tokenURI));
442         }
443 
444         return super.tokenURI(tokenId);
445     }
446 
447     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
448         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
449         _tokenURIs[tokenId] = _tokenURI;
450     }
451 
452     function _burn(uint256 tokenId) internal virtual override {
453         super._burn(tokenId);
454 
455         if (bytes(_tokenURIs[tokenId]).length != 0) {
456             delete _tokenURIs[tokenId];
457         }
458     }
459 }
460 
461 
462 
463 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
464 
465 pragma solidity ^0.8.0;
466 
467 library Counters {
468     struct Counter {
469         uint256 _value; // default: 0
470     }
471 
472     function current(Counter storage counter) internal view returns (uint256) {
473         return counter._value;
474     }
475 
476     function increment(Counter storage counter) internal {
477         unchecked {
478             counter._value += 1;
479         }
480     }
481 
482     function decrement(Counter storage counter) internal {
483         uint256 value = counter._value;
484         require(value > 0, "Counter: decrement overflow");
485         unchecked {
486             counter._value = value - 1;
487         }
488     }
489 }
490 
491 
492 // File contracts/Musto.sol
493 
494 library SafeMath {
495     function add(uint256 a, uint256 b) internal pure returns (uint256) {
496         uint256 c = a + b;
497         require(c >= a, "SafeMath: addition overflow");
498 
499         return c;
500     }
501 
502     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
503         return sub(a, b, "SafeMath: subtraction overflow");
504     }
505 
506     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b <= a, errorMessage);
508         uint256 c = a - b;
509 
510         return c;
511     }
512 
513     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
514         if (a == 0) {
515             return 0;
516         }
517 
518         uint256 c = a * b;
519         require(c / a == b, "SafeMath: multiplication overflow");
520 
521         return c;
522     }
523 
524     function div(uint256 a, uint256 b) internal pure returns (uint256) {
525         return div(a, b, "SafeMath: division by zero");
526     }
527 
528     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
529         require(b > 0, errorMessage);
530         uint256 c = a / b;
531         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
532 
533         return c;
534     }
535 
536     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
537         return mod(a, b, "SafeMath: modulo by zero");
538     }
539 
540     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
541         require(b != 0, errorMessage);
542         return a % b;
543     }
544 }
545 
546 pragma solidity ^0.8.0;
547 
548 
549 contract TheUnstableHorsesYard is ERC721URIStorage {
550     using SafeMath for uint256;
551     using Counters for Counters.Counter;
552     Counters.Counter private _tokenIds;
553 
554     // horse own; 
555     address public owner;
556     uint public total_No_Tokens = 1000;
557     uint public total_No_TokensRemaining = total_No_Tokens;
558     uint public total_No_Horses = 999;
559     uint public total_No_HorsesRemaining = total_No_Horses;
560     uint public owner_Horses = 1;
561     uint public owner_HorsesRemaining = owner_Horses;
562     uint public nextTokenId = 1;
563     uint public maxHorsesMintInOnce = 3;
564     uint public price = 30000000000000000;  // 0.03 ETH
565     bool public sale  =  true;  // false
566     uint256 public startingIpfsId = 0;
567     uint256 private _lastIpfsId = 0;
568     uint256 public start = 1;
569     
570 
571     mapping(uint => bool) public exist;
572 
573 
574     // farm juice own;
575     mapping(address => uint) public farmJuices_Owner;
576     mapping(address => bool) public farmJuices_Own;
577     uint private FarmJuice_newTokenId = 1000001;
578     uint public farmJuices = 1000;
579     uint public farmJuicesRemaining = farmJuices;
580     uint public farmJuicesTransfered = 0;
581 
582 
583 
584     // Breed section;
585     uint public total_No_HorsesBreed = 0;
586     uint public StartIndex_HorsesBreed = 100000000001;
587     uint public NextIndex_HorsesBreed  = StartIndex_HorsesBreed;
588 
589     event Minted(address to, uint id, string uri);
590     event PriceUpdated(uint newPrice);
591     event OwnerUpdated(address newOwner);
592 
593     address payable fundWallet;
594     string public baseUri ;
595     string public FarmJuice_baseUri ;
596     string public breed_baseUri ;
597 
598 
599  
600     constructor(address _fundWallet, string memory _baseUri, string memory _FarmJuice_baseUri, string memory _breed_baseUri) ERC721("The Unstable Horses Yard", "TUHY") {
601         owner = msg.sender;
602         fundWallet = payable(_fundWallet); 
603         baseUri = _baseUri; 
604         FarmJuice_baseUri = _FarmJuice_baseUri; 
605         breed_baseUri = _breed_baseUri; 
606     }
607 
608     function fundWalletView() public view returns(address){
609         require(msg.sender == owner || msg.sender == fundWallet, "Only owner");
610         return fundWallet;
611     }  
612 
613     function fundWalletUpdate(address _fundWallet) public  returns(address){
614         require(msg.sender == owner || msg.sender == fundWallet, "Only owner");
615         fundWallet = payable(_fundWallet); 
616     }  
617 
618     /* Mint Horses only OWNER */
619     function mint_owner(address to) public {
620         require(msg.sender == owner || msg.sender == fundWallet, "Only owner can transfer");
621         require(owner_HorsesRemaining >= 0, "mint token limit exceeds");
622         
623         if(total_No_Tokens == total_No_TokensRemaining) {
624             _lastIpfsId = random(1, total_No_Tokens, uint256(uint160(address(_msgSender()))) + 1);
625             startingIpfsId = _lastIpfsId;
626         } else {
627             _lastIpfsId = getIpfsIdToMint();
628         }
629         total_No_TokensRemaining--;
630         owner_HorsesRemaining--;
631         
632         require(exist[nextTokenId] == false, "Mint: Token already exist.");
633         string memory tokenURI = string(abi.encodePacked(baseUri, uint2str(_lastIpfsId)));
634         _mint(to, nextTokenId);
635         _setTokenURI(nextTokenId, (tokenURI));
636         
637         exist[nextTokenId] = true;
638         nextTokenId++;
639         
640     }
641     
642     /* Mint Horses */
643     function mint(uint numberOfMints) public payable {
644         require(sale == true, "sale is off");
645         require(numberOfMints > 0, "minimum 1 token need to be minted");
646         require(numberOfMints <= maxHorsesMintInOnce, "max horses mint limit exceeds");
647         require(total_No_HorsesRemaining - numberOfMints >= 0, "mint token limit exceeds, check how many remaining to mint."); //10000 item cap (9900 public + 100 team mints)
648         require(msg.value >= price * numberOfMints, "price is not correct.");  //User must pay set price.`
649         
650 		for (uint256 i = 0; i < numberOfMints; i++) {
651             if(total_No_Tokens == total_No_TokensRemaining) {
652                 _lastIpfsId = random(1, total_No_Tokens, uint256(uint160(address(_msgSender()))) + 1);
653                 startingIpfsId = _lastIpfsId;
654             } else {
655                 _lastIpfsId = getIpfsIdToMint();
656             }
657             total_No_TokensRemaining--;
658             total_No_HorsesRemaining--;
659             
660             require(exist[nextTokenId] == false, "Mint: Token already exist.");
661             string memory tokenURI = string(abi.encodePacked(baseUri, uint2str(_lastIpfsId)));
662             _mint(msg.sender, nextTokenId);
663             _setTokenURI(nextTokenId, (tokenURI));
664             
665             exist[nextTokenId] = true;
666             nextTokenId++;
667         }
668         // this(address).transfer(msg.value);
669     }
670 
671 
672     
673     /* Farm Juice */
674     function farmJuice_Mint(address player) public {  // there is no fund transfer because only  owner can mint FARM Juices. 
675         require(msg.sender == owner || msg.sender == fundWallet, "Only owner can mint");
676         require(farmJuicesRemaining > 0, "All farm juices  transfered."); 
677         require(farmJuices_Own[player] == false, "User already own farmJuice"); 
678         
679         farmJuicesRemaining--;
680         farmJuicesTransfered++;
681         farmJuices_Owner[player] = FarmJuice_newTokenId;
682         farmJuices_Own[player] = true;
683         
684         string memory FarmJuice_URI = string(abi.encodePacked(FarmJuice_baseUri));
685             
686         _mint(player, FarmJuice_newTokenId);
687         _setTokenURI(FarmJuice_newTokenId, FarmJuice_URI);
688         
689         FarmJuice_newTokenId++;
690     }
691 
692     /* Breed Horse */
693     function Breed(address player, uint token1_ID, uint token2_ID) public {
694         require(farmJuices_Own[msg.sender] == true, "User should own farm Juice for Breeding"); 
695         require(ownerOf(token1_ID) == msg.sender, "User should own Token 1"); 
696         require(ownerOf(token2_ID) == msg.sender, "User should own Token 2"); 
697         
698          string memory tokenURI = string(abi.encodePacked(breed_baseUri, uint2str(NextIndex_HorsesBreed)));
699         _mint(player, NextIndex_HorsesBreed);
700         _setTokenURI(NextIndex_HorsesBreed, tokenURI);
701         
702         NextIndex_HorsesBreed += 1;
703         total_No_HorsesBreed +=  1;
704 
705         burn(token1_ID);
706         burn(token2_ID);
707     }
708     
709     
710 
711     //random number
712 	function random( uint256 from, uint256 to, uint256 salty ) private view returns (uint256) {
713 		uint256 seed =
714 			uint256(
715 				keccak256(
716 					abi.encodePacked(
717 						block.timestamp +
718 							block.difficulty +
719 							((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
720 							block.gaslimit +
721 							((uint256(keccak256(abi.encodePacked(_msgSender())))) / (block.timestamp)) +
722 							block.number +
723 							salty
724 					)
725 				)
726 			);
727 		
728 		uint randomData = 0;
729 		if( (seed.mod(to - from) + from) <= total_No_Horses ){
730 		    randomData = seed.mod(to - from) + from;
731 		} else {
732 		    randomData = total_No_Horses / 2;
733 		}
734 		return randomData;
735 	}
736 	
737     function getIpfsIdToMint() public view returns(uint256 _nextIpfsId) {
738         require(total_No_TokensRemaining > 0, "All tokens have been minted");
739         
740         if(_lastIpfsId == total_No_Tokens && nextTokenId < total_No_Tokens) {
741             _nextIpfsId = start;   // 2
742         } else if(nextTokenId <= total_No_Tokens) {
743             _nextIpfsId = _lastIpfsId + 1;
744         }
745     }
746 	
747     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
748 		if (_i == 0) {
749 			return "0";
750 		}
751 		uint256 j = _i;
752 		uint256 len;
753 		while (j != 0) {
754 			len++;
755 			j /= 10;
756 		}
757 		bytes memory bstr = new bytes(len);
758 		uint256 k = len;
759 		while (_i != 0) {
760 			k = k - 1;
761 			uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
762 			bytes1 b1 = bytes1(temp);
763 			bstr[k] = b1;
764 			_i /= 10;
765 		}
766 		return string(bstr);
767 	}	
768     
769     function update_FarmJuice_URI(string memory newFarmJuice_URI) public{
770       require(msg.sender == owner || msg.sender == fundWallet, "only owner");
771       FarmJuice_baseUri = newFarmJuice_URI;
772     }
773     
774     function update_FarmJuice_limit(uint  add_newTokens) public{
775         require(msg.sender == owner || msg.sender == fundWallet, "Only owner");
776         farmJuices += add_newTokens; 
777         farmJuicesRemaining += add_newTokens;
778     }
779     
780     function burn(uint256 _tokenId) public {
781         require(_exists(_tokenId), "Burn: token does not exist.");
782         require(ownerOf(_tokenId) == _msgSender(), "Burn: caller is not token owner.");
783         _burn(_tokenId);
784     }
785         
786     function balancer() public view returns (uint256){
787         return address(this).balance;
788     }
789     
790     function update_Tokens_Limit(uint add_newTokens) public{
791       require(msg.sender == owner || msg.sender == fundWallet, "Only owner");
792       
793       start = total_No_Tokens + 1;
794       _lastIpfsId = total_No_Tokens;
795       total_No_Tokens += add_newTokens ;
796       total_No_Horses += (add_newTokens - 99) ;
797       total_No_TokensRemaining += add_newTokens;
798       total_No_HorsesRemaining = (add_newTokens - 99);
799       price = 40000000000000000;  // 0.04 ETH
800       maxHorsesMintInOnce = 15;
801       
802       owner_Horses += 99;
803       owner_HorsesRemaining += 99;
804     }
805 
806     function update_Mint_per_Tx(uint _num) public{
807       require(msg.sender == owner || msg.sender == fundWallet, "Only owner");
808       maxHorsesMintInOnce = _num;
809     }
810 
811     function update_Owner(address newOwner) public{
812       require(msg.sender == owner || msg.sender == fundWallet);
813       owner = newOwner;
814       emit OwnerUpdated(newOwner);
815     }
816 
817     function update_price(uint newprice) public{
818       require(msg.sender == owner || msg.sender == fundWallet);
819       price = newprice;
820       emit PriceUpdated(newprice);
821     }
822 
823     function changeSale() public{
824       require(msg.sender == owner || msg.sender == fundWallet);
825       sale = !sale;
826     }
827 
828     function withdraw() public{
829         require(msg.sender == owner || msg.sender == fundWallet, "Only owner");
830         payable(fundWallet).transfer(address(this).balance);
831     }
832     function update_URI(string memory new_URI) public{ 
833       require(msg.sender == owner || msg.sender == fundWallet, "only owner"); 
834        baseUri = new_URI; 
835     }
836 }