1 pragma solidity ^0.8.0;
2 
3 interface IERC165 {
4     function supportsInterface(bytes4 interfaceId) external view returns (bool);
5 }
6 
7 
8 pragma solidity ^0.8.0;
9 
10 abstract contract ERC165 is IERC165 {
11     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
12         return interfaceId == type(IERC165).interfaceId;
13     }
14 }
15 
16 
17 pragma solidity ^0.8.0;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; 
26         return msg.data;
27     }
28 }
29 
30 
31 pragma solidity ^0.8.0;
32 
33 library Address {
34 
35     function isContract(address account) internal view returns (bool) {
36         uint256 size;
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     function sendValue(address payable recipient, uint256 amount) internal {
42         require(address(this).balance >= amount, "Address: insufficient balance");
43         (bool success, ) = recipient.call{ value: amount }("");
44         require(success, "Address: unable to send value, recipient may have reverted");
45     }
46 
47     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
48       return functionCall(target, data, "Address: low-level call failed");
49     }
50 
51     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
52         return functionCallWithValue(target, data, 0, errorMessage);
53     }
54 
55     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
56         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
57     }
58 
59     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
60         require(address(this).balance >= value, "Address: insufficient balance for call");
61         require(isContract(target), "Address: call to non-contract");
62         (bool success, bytes memory returndata) = target.call{ value: value }(data);
63         return _verifyCallResult(success, returndata, errorMessage);
64     }
65 
66     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
67         return functionStaticCall(target, data, "Address: low-level static call failed");
68     }
69 
70     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
71         require(isContract(target), "Address: static call to non-contract");
72         (bool success, bytes memory returndata) = target.staticcall(data);
73         return _verifyCallResult(success, returndata, errorMessage);
74     }
75 
76     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
77         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
78     }
79 
80     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
81         require(isContract(target), "Address: delegate call to non-contract");
82         (bool success, bytes memory returndata) = target.delegatecall(data);
83         return _verifyCallResult(success, returndata, errorMessage);
84     }
85 
86     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
87         if (success) {
88             return returndata;
89         } else {
90             if (returndata.length > 0) {
91                 assembly {
92                     let returndata_size := mload(returndata)
93                     revert(add(32, returndata), returndata_size)
94                 }
95             } else {
96                 revert(errorMessage);
97             }
98         }
99     }
100 }
101 
102 
103 pragma solidity ^0.8.0;
104 
105 interface IERC1155Receiver is IERC165 {
106 
107 
108     function onERC1155Received(
109         address operator,
110         address from,
111         uint256 id,
112         uint256 value,
113         bytes calldata data
114     )
115         external
116         returns(bytes4);
117 
118     function onERC1155BatchReceived(
119         address operator,
120         address from,
121         uint256[] calldata ids,
122         uint256[] calldata values,
123         bytes calldata data
124     )
125         external
126         returns(bytes4);
127 }
128 
129 
130 
131 pragma solidity ^0.8.0;
132 
133 interface IERC1155 is IERC165 {
134 
135     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
136     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
137     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
138     event URI(string value, uint256 indexed id);
139     
140     function balanceOf(address account, uint256 id) external view returns (uint256);
141     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
142     function setApprovalForAll(address operator, bool approved) external;
143     function isApprovedForAll(address account, address operator) external view returns (bool);
144     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
145     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
146 }
147 
148 
149 pragma solidity ^0.8.0;
150 
151 library Strings {
152     bytes16 private constant alphabet = "0123456789abcdef";
153     function toString(uint256 value) internal pure returns (string memory) {
154         if (value == 0) {
155             return "0";
156         }
157         uint256 temp = value;
158         uint256 digits;
159         while (temp != 0) {
160             digits++;
161             temp /= 10;
162         }
163         bytes memory buffer = new bytes(digits);
164         while (value != 0) {
165             digits -= 1;
166             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
167             value /= 10;
168         }
169         return string(buffer);
170     }
171 
172     function toHexString(uint256 value) internal pure returns (string memory) {
173         if (value == 0) {
174             return "0x00";
175         }
176         uint256 temp = value;
177         uint256 length = 0;
178         while (temp != 0) {
179             length++;
180             temp >>= 8;
181         }
182         return toHexString(value, length);
183     }
184 
185     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
186         bytes memory buffer = new bytes(2 * length + 2);
187         buffer[0] = "0";
188         buffer[1] = "x";
189         for (uint256 i = 2 * length + 1; i > 1; --i) {
190             buffer[i] = alphabet[value & 0xf];
191             value >>= 4;
192         }
193         require(value == 0, "Strings: hex length insufficient");
194         return string(buffer);
195     }
196 
197 }
198 
199 
200 
201 pragma solidity ^0.8.0;
202 
203 library SafeMath {
204     
205     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
206         unchecked {
207             uint256 c = a + b;
208             if (c < a) return (false, 0);
209             return (true, c);
210         }
211     }
212 
213     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
214         unchecked {
215             if (b > a) return (false, 0);
216             return (true, a - b);
217         }
218     }
219 
220     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         unchecked {
222             if (a == 0) return (true, 0);
223             uint256 c = a * b;
224             if (c / a != b) return (false, 0);
225             return (true, c);
226         }
227     }
228 
229     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
230         unchecked {
231             if (b == 0) return (false, 0);
232             return (true, a / b);
233         }
234     }
235 
236     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             if (b == 0) return (false, 0);
239             return (true, a % b);
240         }
241     }
242 
243     function add(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a + b;
245     }
246     
247     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248         return a - b;
249     }
250 
251     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a * b;
253     }
254 
255     function div(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a / b;
257     }
258 
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a % b;
261     }
262 
263     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         unchecked {
265             require(b <= a, errorMessage);
266             return a - b;
267         }
268     }
269 
270     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         unchecked {
272             require(b > 0, errorMessage);
273             return a / b;
274         }
275     }
276 
277     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         unchecked {
279             require(b > 0, errorMessage);
280             return a % b;
281         }
282     }
283 }
284 
285 
286 
287 pragma solidity ^0.8.0;
288 
289 abstract contract Ownable is Context {
290     address private _owner;
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293     constructor () {
294         address msgSender = _msgSender();
295         _owner = msgSender;
296         emit OwnershipTransferred(address(0), msgSender);
297     }
298 
299 
300     function owner() public view virtual returns (address) {
301         return _owner;
302     }
303 
304     modifier onlyOwner() {
305         require(owner() == _msgSender(), "Ownable: caller is not the owner");
306         _;
307     }
308 
309     function renounceOwnership() public virtual onlyOwner {
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313 
314     function transferOwnership(address newOwner) public virtual onlyOwner {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         emit OwnershipTransferred(_owner, newOwner);
317         _owner = newOwner;
318     }
319 }
320 
321 
322 pragma solidity ^0.8.0;
323 
324 interface IERC1155MetadataURI is IERC1155 {
325     function uri(uint256 id) external view returns (string memory);
326 }
327 
328 
329 pragma solidity ^0.8.0;
330 
331 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
332     using Address for address;
333 
334     mapping (uint256 => mapping(address => uint256)) private _balances;
335     mapping (address => mapping(address => bool)) private _operatorApprovals;
336     string private _uri;
337 
338     constructor (string memory uri_) {
339         _setURI(uri_);
340     }
341 
342     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
343         return interfaceId == type(IERC1155).interfaceId
344             || interfaceId == type(IERC1155MetadataURI).interfaceId
345             || super.supportsInterface(interfaceId);
346     }
347 
348     function uri(uint256) public view virtual override returns (string memory) {
349         return _uri;
350     }
351 
352     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
353         require(account != address(0), "ERC1155: balance query for the zero address");
354         return _balances[id][account];
355     }
356 
357     function balanceOfBatch(
358         address[] memory accounts,
359         uint256[] memory ids
360     )
361         public
362         view
363         virtual
364         override
365         returns (uint256[] memory)
366     {
367         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
368         uint256[] memory batchBalances = new uint256[](accounts.length);
369         for (uint256 i = 0; i < accounts.length; ++i) {
370             batchBalances[i] = balanceOf(accounts[i], ids[i]);
371         }
372         return batchBalances;
373     }
374 
375   
376     function setApprovalForAll(address operator, bool approved) public virtual override {
377         require(_msgSender() != operator, "ERC1155: setting approval status for self");
378         _operatorApprovals[_msgSender()][operator] = approved;
379         emit ApprovalForAll(_msgSender(), operator, approved);
380     }
381 
382     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
383         return _operatorApprovals[account][operator];
384     }
385 
386  
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 id,
391         uint256 amount,
392         bytes memory data
393     )
394         public
395         virtual
396         override
397     {
398         require(to != address(0), "ERC1155: transfer to the zero address");
399         require(
400             from == _msgSender() || isApprovedForAll(from, _msgSender()),
401             "ERC1155: caller is not owner nor approved"
402         );
403 
404         address operator = _msgSender();
405         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
406         uint256 fromBalance = _balances[id][from];
407         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
408         _balances[id][from] = fromBalance - amount;
409         _balances[id][to] += amount;
410         emit TransferSingle(operator, from, to, id, amount);
411         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
412     }
413 
414    
415     function safeBatchTransferFrom(
416         address from,
417         address to,
418         uint256[] memory ids,
419         uint256[] memory amounts,
420         bytes memory data
421     )
422         public
423         virtual
424         override
425     {
426         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
427         require(to != address(0), "ERC1155: transfer to the zero address");
428         require(
429             from == _msgSender() || isApprovedForAll(from, _msgSender()),
430             "ERC1155: transfer caller is not owner nor approved"
431         );
432 
433         address operator = _msgSender();
434         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
435         for (uint256 i = 0; i < ids.length; ++i) {
436             uint256 id = ids[i];
437             uint256 amount = amounts[i];
438 
439             uint256 fromBalance = _balances[id][from];
440             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
441             _balances[id][from] = fromBalance - amount;
442             _balances[id][to] += amount;
443         }
444 
445         emit TransferBatch(operator, from, to, ids, amounts);
446         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
447     }
448 
449    
450     function _setURI(string memory newuri) internal virtual {
451         _uri = newuri;
452     }
453 
454     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
455         require(account != address(0), "ERC1155: mint to the zero address");
456         address operator = _msgSender();
457         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
458         _balances[id][account] += amount;
459         emit TransferSingle(operator, address(0), account, id, amount);
460         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
461     }
462 
463     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
464         require(to != address(0), "ERC1155: mint to the zero address");
465         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
466         address operator = _msgSender();
467         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
468 
469         for (uint i = 0; i < ids.length; i++) {
470             _balances[ids[i]][to] += amounts[i];
471         }
472 
473         emit TransferBatch(operator, address(0), to, ids, amounts);
474         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
475     }
476 
477 
478     function _burn(address account, uint256 id, uint256 amount) internal virtual {
479         require(account != address(0), "ERC1155: burn from the zero address");
480         address operator = _msgSender();
481         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
482         uint256 accountBalance = _balances[id][account];
483         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
484         _balances[id][account] = accountBalance - amount;
485 
486         emit TransferSingle(operator, account, address(0), id, amount);
487     }
488 
489     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
490         require(account != address(0), "ERC1155: burn from the zero address");
491         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
492         address operator = _msgSender();
493         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
494         for (uint i = 0; i < ids.length; i++) {
495             uint256 id = ids[i];
496             uint256 amount = amounts[i];
497 
498             uint256 accountBalance = _balances[id][account];
499             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
500             _balances[id][account] = accountBalance - amount;
501         }
502 
503         emit TransferBatch(operator, account, address(0), ids, amounts);
504     }
505 
506    
507     function _beforeTokenTransfer(
508         address operator,
509         address from,
510         address to,
511         uint256[] memory ids,
512         uint256[] memory amounts,
513         bytes memory data
514     )
515         internal
516         virtual
517     { }
518 
519     function _doSafeTransferAcceptanceCheck(
520         address operator,
521         address from,
522         address to,
523         uint256 id,
524         uint256 amount,
525         bytes memory data
526     )
527         private
528     {
529         if (to.isContract()) {
530             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
531                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
532                     revert("ERC1155: ERC1155Receiver rejected tokens");
533                 }
534             } catch Error(string memory reason) {
535                 revert(reason);
536             } catch {
537                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
538             }
539         }
540     }
541 
542     function _doSafeBatchTransferAcceptanceCheck(
543         address operator,
544         address from,
545         address to,
546         uint256[] memory ids,
547         uint256[] memory amounts,
548         bytes memory data
549     )
550         private
551     {
552         if (to.isContract()) {
553             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
554                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
555                     revert("ERC1155: ERC1155Receiver rejected tokens");
556                 }
557             } catch Error(string memory reason) {
558                 revert(reason);
559             } catch {
560                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
561             }
562         }
563     }
564 
565     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
566         uint256[] memory array = new uint256[](1);
567         array[0] = element;
568 
569         return array;
570     }
571 }
572 
573 
574 pragma solidity 0.8.0;
575 
576 interface IERC20 {
577 	function totalSupply() external view returns (uint256);
578 	function balanceOf(address account) external view returns (uint256);
579 	function transfer(address recipient, uint256 amount) external returns (bool);
580 	function allowance(address owner, address spender) external view returns (uint256);
581 	function approve(address spender, uint256 amount) external returns (bool);
582 	function transferFrom(
583 		address sender,
584 		address recipient,
585 		uint256 amount
586 	) external returns (bool);
587 
588 	event Transfer(address indexed from, address indexed to, uint256 value);
589 	event Approval(address indexed owner, address indexed spender, uint256 value);
590 }
591 
592 contract TheRichies is ERC1155, Ownable {
593 	using SafeMath for uint256;
594 	using Strings for string;
595 	uint256 public richiesSold;
596 	uint256 public totalRichies = 4444;
597 	uint256 public presaleSupply;
598 	bool public sale = false;
599 	bool public preSale = false;
600 	mapping(uint256 => uint256) private _totalSupply;
601 
602 	string public _baseURI = "https://mint.richiesnft.com/api/richie/";
603 	mapping(uint256 => string) public _tokenURIs;
604 	uint256 public itemPrice;
605 	address public companyWallet = 0xbC4eb5e97C12542EA4951eb8A01A36F7f0957319;
606 
607 	constructor() ERC1155(_baseURI) {
608 		itemPrice = 100000000000000000; // 0.1 ETH
609 	}
610 
611 	function setItemPrice(uint256 _price) public onlyOwner {
612 		itemPrice = _price;
613 	}
614 
615 	function getItemPrice() public view returns (uint256) {
616 		return itemPrice;
617 	}
618 	
619 	function buyPresale(uint256 _howMany) public payable {
620 	    require(presaleSupply < 445 && preSale, "Presale inactive");
621 		require(_howMany <= 10, "max 10 richies at once");
622 		require(itemPrice.mul(_howMany) == msg.value, "insufficient ETH");
623 		for (uint256 i = 0; i < _howMany; i++) {
624 			getRichie();
625 		}
626 		presaleSupply = presaleSupply + _howMany;
627 	}
628 
629 	function buyRichie(uint256 _howMany) public payable {
630 	    require(sale, "Minting has not started yet");
631 	    require(richiesSold < 4439, "All sold out");
632 		require(_howMany <= 10, "max 10 richies at once");
633 		require(itemPrice.mul(_howMany) == msg.value, "insufficient ETH");
634 		for (uint256 i = 0; i < _howMany; i++) {
635 			getRichie();
636 		}
637 	}
638 
639 	function getRichie() private {
640 		for (uint256 i = 0; i < 9999; i++) {
641 			uint256 randID = random(1, totalRichies, uint256(uint160(address(msg.sender))) + i);
642 			if (_totalSupply[randID] == 0) {
643 				_totalSupply[randID] = 1;
644 				_mint(msg.sender, randID, 1, "0x0000");
645 				richiesSold = richiesSold + 1;
646 				return;
647 			}
648 		}
649 		revert("you're very unlucky");
650 	}
651 
652 	function mint(address to, uint256 id, bytes memory data) public onlyOwner {
653 		require(_totalSupply[id] == 0, "this richie is already owned by someone");
654 		_totalSupply[id] = 1;
655 		richiesSold = richiesSold + 1;
656 		_mint(to, id, 1, data);
657 	}
658 
659 	function setBaseURI(string memory newuri) public onlyOwner {
660 		_baseURI = newuri;
661 	}
662 
663 	function uri(uint256 tokenId) public view override returns (string memory) {
664 		return string(abi.encodePacked(_baseURI, uint2str(tokenId)));
665 	}
666 	
667 	function tokenURI(uint256 tokenId) public view returns (string memory) {
668 		return string(abi.encodePacked(_baseURI, uint2str(tokenId)));
669 	}
670 
671 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
672 		if (_i == 0) {
673 			return "0";
674 		}
675 		uint256 j = _i;
676 		uint256 len;
677 		while (j != 0) {
678 			len++;
679 			j /= 10;
680 		}
681 		bytes memory bstr = new bytes(len);
682 		uint256 k = len;
683 		while (_i != 0) {
684 			k = k - 1;
685 			uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
686 			bytes1 b1 = bytes1(temp);
687 			bstr[k] = b1;
688 			_i /= 10;
689 		}
690 		return string(bstr);
691 	}
692 
693 	function totalSupply(uint256 id) public view virtual returns (uint256) {
694 		return _totalSupply[id];
695 	}
696 
697 	function exists(uint256 id) public view virtual returns (bool) {
698 		return totalSupply(id) > 0;
699 	}
700 
701 	function random(
702 		uint256 from,
703 		uint256 to,
704 		uint256 salty
705 	) private view returns (uint256) {
706 		uint256 seed =
707 			uint256(
708 				keccak256(
709 					abi.encodePacked(
710 						block.timestamp +
711 							block.difficulty +
712 							((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
713 							block.gaslimit +
714 							((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
715 							block.number +
716 							salty
717 					)
718 				)
719 			);
720 		return seed.mod(to - from) + from;
721 	}
722 
723 	function withdraw() public onlyOwner {
724 		uint256 balance = address(this).balance;
725 		payable(companyWallet).transfer(balance);
726 	}
727 
728 	function activateSale(bool status) public onlyOwner {
729 		sale = status;
730 	}
731 	
732 	function activatePreSale(bool status) public onlyOwner {
733 		preSale = status;
734 	}
735 
736 	function reclaimToken(IERC20 token) public onlyOwner {
737 		require(address(token) != address(0));
738 		uint256 balance = token.balanceOf(address(this));
739 		token.transfer(msg.sender, balance);
740 	}
741 	
742 
743 }