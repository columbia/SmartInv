1 pragma solidity ^0.8.0;
2 interface IERC165 {
3 	function supportsInterface(bytes4 interfaceId) external view returns(bool);
4 }
5 
6 pragma solidity ^0.8.0;
7 interface IERC721 is IERC165 {
8 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
9 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
10 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
11 
12 	function balanceOf(address owner) external view returns(uint256 balance);
13 	function ownerOf(uint256 tokenId) external view returns(address owner);
14 	function safeTransferFrom(address from, address to, uint256 tokenId) external;
15 	function transferFrom(address from, address to, uint256 tokenId) external;
16 	function approve(address to, uint256 tokenId) external;
17 	function getApproved(uint256 tokenId) external view returns(address operator);
18 	function setApprovalForAll(address operator, bool _approved) external;
19 	function isApprovedForAll(address owner, address operator) external view returns(bool);
20 	function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
21 }
22 
23 pragma solidity ^0.8.0;
24 interface IERC721Receiver {
25 	function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns(bytes4);
26 }
27 
28 pragma solidity ^0.8.0;
29 interface IERC721Metadata is IERC721 {
30 	function name() external view returns(string memory);
31 	function symbol() external view returns(string memory);
32 	function tokenURI(uint256 tokenId) external view returns(string memory);
33 }
34 
35 pragma solidity ^0.8.0;
36 library Address {
37 	function isContract(address account) internal view returns(bool) {
38 		uint256 size;
39 		assembly {
40 			size := extcodesize(account)
41 		}
42 		return size > 0;
43 	}
44 
45 	function sendValue(address payable recipient, uint256 amount) internal {
46 		require(address(this).balance >= amount, "Insufficient balance");
47 		(bool success, ) = recipient.call{value: amount}("");
48 		require(success, "Address: unable to send value, recipient may have reverted");
49 	}
50 
51 	function functionCall(address target, bytes memory data) internal returns(bytes memory) {
52 		return functionCall(target, data, "Address: low-level call failed");
53 	}
54 
55 	function functionCall(address target, bytes memory data, string memory errorMessage) internal returns(bytes memory) {
56 		return functionCallWithValue(target, data, 0, errorMessage);
57 	}
58 
59 	function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns(bytes memory) {
60 		return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
61 	}
62 
63 	function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns(bytes memory) {
64 		require(address(this).balance >= value, "Insufficient balance!");
65 		require(isContract(target), "Address: call to non-contract");
66 		(bool success, bytes memory returndata) = target.call{value: value}(data);
67 		return verifyCallResult(success, returndata, errorMessage);
68 	}
69 
70 	function functionStaticCall(address target, bytes memory data) internal view returns(bytes memory) {
71 		return functionStaticCall(target, data, "Address: low-level static call failed");
72 	}
73 
74 	function functionStaticCall( address target, bytes memory data, string memory errorMessage) internal view returns(bytes memory) {
75 		require(isContract(target), "Address: static call to non-contract");
76 		(bool success, bytes memory returndata) = target.staticcall(data);
77 		return verifyCallResult(success, returndata, errorMessage);
78 	}
79 
80 	function functionDelegateCall(address target, bytes memory data) internal returns(bytes memory) {
81 		return functionDelegateCall(target, data, "Address: low-level delegate call failed");
82 	}
83 
84 	function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns(bytes memory) {
85 		require(isContract(target), "Address: delegate call to non-contract");
86 		(bool success, bytes memory returndata) = target.delegatecall(data);
87 		return verifyCallResult(success, returndata, errorMessage);
88 	}
89 
90 	function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns(bytes memory) {
91 		if(success) {
92 			return returndata;
93 		}
94 		else {
95 			if(returndata.length > 0) {
96 				assembly {
97 					let returndata_size := mload(returndata)
98 					revert(add(32, returndata), returndata_size)
99 				}
100 			}
101 			else {
102 				revert(errorMessage);
103 			}
104 		}
105 	}
106 }
107 
108 pragma solidity ^0.8.0;
109 abstract contract Context {
110 	function _msgSender() internal view virtual returns(address) {
111 		return msg.sender;
112 	}
113 
114 	function _msgData() internal view virtual returns(bytes calldata) {
115 		return msg.data;
116 	}
117 }
118 
119 pragma solidity ^0.8.0;
120 library Strings {
121 	bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
122 
123 	function toString(uint256 value) internal pure returns(string memory) {
124 		if(value == 0) {
125 			return "0";
126 		}
127 		uint256 temp = value;
128 		uint256 digits;
129 		while (temp != 0) {
130 			digits++;
131 			temp /= 10;
132 		}
133 		bytes memory buffer = new bytes(digits);
134 		while (value != 0) {
135 			digits -= 1;
136 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
137 			value /= 10;
138 		}
139 		return string(buffer);
140 	}
141 
142 	function toHexString(uint256 value) internal pure returns(string memory) {
143 		if(value == 0) {
144 			return "0x00";
145 		}
146 		uint256 temp = value;
147 		uint256 length = 0;
148 		while (temp != 0) {
149 			length++;
150 			temp >>= 8;
151 		}
152 		return toHexString(value, length);
153 	}
154 
155 	function toHexString(uint256 value, uint256 length) internal pure returns(string memory) {
156 		bytes memory buffer = new bytes(2 * length + 2);
157 		buffer[0] = "0";
158 		buffer[1] = "x";
159 		for (uint256 i = 2 * length + 1; i > 1; --i) {
160 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
161 			value >>= 4;
162 		}
163 		require(value == 0, "Strings: hex length insufficient");
164 		return string(buffer);
165 	}
166 }
167 
168 pragma solidity ^0.8.0;
169 abstract contract ERC165 is IERC165 {
170 	function supportsInterface(bytes4 interfaceId) public view virtual override returns(bool) {
171 		return interfaceId == type(IERC165).interfaceId;
172 	}
173 }
174 
175 pragma solidity ^0.8.0;
176 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
177 	using Address for address;
178 	using Strings for uint256;
179 
180 	string private _name;
181 	string private _symbol;
182 	string private _description;
183 	mapping(uint256 => address) private _owners;
184 	mapping(address => uint256) private _balances;
185 	mapping(uint256 => address) private _tokenApprovals;
186 	mapping(address => mapping(address => bool)) private _operatorApprovals;
187 
188 	constructor(string memory name_, string memory symbol_, string memory description_) {
189 		//_name = name_;
190 		//_symbol = symbol_;
191 		//_description = description_;
192 	}
193 
194 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns(bool) {
195 		return
196 		interfaceId == type(IERC721).interfaceId ||
197 		interfaceId == type(IERC721Metadata).interfaceId ||
198 		super.supportsInterface(interfaceId);
199 	}
200 
201 	function balanceOf(address owner) public view virtual override returns(uint256) {
202 		require(owner != address(0), "ERC721: balance query for the zero address");
203 		return _balances[owner];
204 	}
205 
206 	function ownerOf(uint256 tokenId) public view virtual override returns(address) {
207 		address owner = _owners[tokenId];
208 		require(owner != address(0), "Not minted yet!");
209 		return owner;
210 	}
211 
212 	function name() public view virtual override returns(string memory) {
213 		// Overriden
214 		return "";
215 	}
216 
217 	function symbol() public view virtual override returns(string memory) {
218 		// Overriden
219 		return "";
220 	}
221 
222 	function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
223 		//Overriden
224 		return "";
225 	}
226 
227 	function _baseURI() internal view virtual returns(string memory) {
228 		// Overriden
229 		return "";
230 	}
231 
232 	function approve(address to, uint256 tokenId) public virtual override {
233 		address owner = ERC721.ownerOf(tokenId);
234 		require(to != owner, "Not authorized!");
235 		require(
236 			_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
237 				"Not authorized!"
238 		);
239 		_approve(to, tokenId);
240 	}
241 
242 	function getApproved(uint256 tokenId) public view virtual override returns(address) {
243 		require(_exists(tokenId), "Nonexistent token!");
244 		return _tokenApprovals[tokenId];
245 	}
246 
247 	function setApprovalForAll(address operator, bool approved) public virtual override {
248 		require(operator != _msgSender(), "ERC721: approve to caller");
249 		_operatorApprovals[_msgSender()][operator] = approved;
250 		emit ApprovalForAll(_msgSender(), operator, approved);
251 	}
252 
253 	function isApprovedForAll(address owner, address operator) public view virtual override returns(bool) {
254 		return _operatorApprovals[owner][operator];
255 	}
256 
257 	function transferFrom(address from, address to, uint256 tokenId) public virtual override {
258 		//solhint-disable-next-line max-line-length
259 		require(_isApprovedOrOwner(_msgSender(), tokenId), "Not authorized!");
260 		_transfer(from, to, tokenId);
261 	}
262 
263 	function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
264 		safeTransferFrom(from, to, tokenId, "");
265 	}
266 
267 	function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
268 		require(_isApprovedOrOwner(_msgSender(), tokenId), "Not authorized!");
269 		_safeTransfer(from, to, tokenId, _data);
270 	}
271 
272 	function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
273 		_transfer(from, to, tokenId);
274 		require(_checkOnERC721Received(from, to, tokenId, _data), "Attempted transfer to non ERC721Receiver implementer!");
275 	}
276 
277 	function _exists(uint256 tokenId) internal view virtual returns(bool) {
278 		return _owners[tokenId] != address(0);
279 	}
280 
281 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns(bool) {
282 		require(_exists(tokenId), "Token does not exist!");
283 		address owner = ERC721.ownerOf(tokenId);
284 		return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
285 	}
286 
287 	function _safeMint(address to, uint256 tokenId) internal virtual {
288 		_safeMint(to, tokenId, "");
289 	}
290 
291 	function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
292 		_mint(to, tokenId);
293 		require(
294 			_checkOnERC721Received(address(0), to, tokenId, _data),
295 				"ERC721: transfer to non ERC721Receiver implementer"
296 		);
297 	}
298 
299 	function _mint(address to, uint256 tokenId) internal virtual {
300 		_balances[to] += 1;
301 		_owners[tokenId] = to;
302 		emit Transfer(address(0), to, tokenId);
303 	}
304 
305 	function _burn(uint256 tokenId) internal virtual {
306 		require(tokenId != tokenId, "Disabled!");
307 	}
308 
309 	function _transfer(address from, address to, uint256 tokenId) internal virtual {
310 		require(ERC721.ownerOf(tokenId) == from, "Not authorized!");
311 		require(to != address(0), "Cannot transfer to zero addy!");
312 		require(to != address(0), "Cannot transfer to zero addy!");
313 		_approve(address(0), tokenId);
314 		_balances[from] -= 1;
315 		_balances[to] += 1;
316 		_owners[tokenId] = to;
317 		emit Transfer(from, to, tokenId);
318 	}
319 
320 	function _approve(address to, uint256 tokenId) internal virtual {
321 		_tokenApprovals[tokenId] = to;
322 		emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
323 	}
324 
325 	function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns(bool) {
326 		if(to.isContract()) {
327 			try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns(bytes4 retval) {
328 				return retval == IERC721Receiver.onERC721Received.selector;
329 			} catch (bytes memory reason) {
330 				if(reason.length == 0) {
331 					revert("ERC721: transfer to non ERC721Receiver implementer");
332 				} else {
333 					assembly {
334 						revert(add(32, reason), mload(reason))
335 					}
336 				}
337 			}
338 		}
339 		else {
340 			return true;
341 		}
342 	}
343 }
344 
345 pragma solidity ^0.8.0;
346 abstract contract ERC721Burnable is Context, ERC721 {
347 	function burn(uint256 tokenId) public virtual {
348 		//solhint-disable-next-line max-line-length
349 		require(_isApprovedOrOwner(_msgSender(), tokenId), "Not authorized!");
350 		_burn(tokenId);
351 	}
352 }
353 
354 pragma solidity ^0.8.0;
355 
356 pragma solidity ^0.8.0;
357 library SafeMath {
358 	function add(uint256 a, uint256 b) internal pure returns(uint256) {
359 		uint256 c = a + b;
360 		require(c >= a, "Addition overflow!");
361 
362 		return c;
363 	}
364 
365 	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
366 		require(b <= a, "Subtraction overflow!");
367 		uint256 c = a - b;
368 
369 		return c;
370 	}
371 
372 	function mul(uint256 a, uint256 b) internal pure returns(uint256) {
373 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
374 		// benefit is lost if 'b' is also tested.
375 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
376 		if(a == 0) {
377 			return 0;
378 		}
379 
380 		uint256 c = a * b;
381 		require(c / a == b, "Multiplication overflow!");
382 
383 		return c;
384 	}
385 
386 	function div(uint256 a, uint256 b) internal pure returns(uint256) {
387 		// Solidity only automatically asserts when dividing by 0
388 		require(b > 0, "Division by zero!");
389 		uint256 c = a / b;
390 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
391 
392 		return c;
393 	}
394 
395 	function mod(uint256 a, uint256 b) internal pure returns(uint256) {
396 		require(b != 0, "Modulo by zero!");
397 		return a % b;
398 	}
399 }
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev The contract has an owner address, and provides basic authorization control whitch
405  * simplifies the implementation of user permissions. This contract is based on the source code at:
406  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
407  */
408 contract Ownable {
409 
410 	/**
411 	 * @dev Error constants.
412 	 */
413 	string public constant NOT_CURRENT_OWNER = "018001";
414 	string public constant CANNOT_TRANSFER_TO_ZERO_ADDRESS = "018002";
415 
416 	/**
417 	 * @dev Current owner address.
418 	 */
419 	address public owner;
420 
421 	/**
422 	 * @dev An event which is triggered when the owner is changed.
423 	 * @param previousOwner The address of the previous owner.
424 	 * @param newOwner The address of the new owner.
425 	 */
426 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
427 
428 	/**
429 	 * @dev The constructor sets the original `owner` of the contract to the sender account.
430 	 */
431 	constructor() {
432 		owner = msg.sender;
433 	}
434 
435 	/**
436 	 * @dev Throws if called by any account other than the owner.
437 	 */
438 	modifier onlyOwner() {
439 		require(msg.sender == owner, NOT_CURRENT_OWNER);
440 		_;
441 	}
442 
443 	/**
444 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
445 	 * @param _newOwner The address to transfer ownership to.
446 	 */
447 	function transferOwnership(address _newOwner) public onlyOwner {
448 		require(_newOwner != address(0), CANNOT_TRANSFER_TO_ZERO_ADDRESS);
449 		emit OwnershipTransferred(owner, _newOwner);
450 		owner = _newOwner;
451 	}
452 }
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Interface of the ERC20 standard as defined in the EIP.
458  */
459 interface IERC20 {
460 	/**
461 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
462 	 * another (`to`).
463 	 *
464 	 * Note that `value` may be zero.
465 	 */
466 	event Transfer(address indexed from, address indexed to, uint256 value);
467 	
468 	/**
469 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
470 	 * a call to {approve}. `value` is the new allowance.
471 	 */
472 	event Approval(address indexed owner, address indexed spender, uint256 value);
473 	
474 	/**
475 	 * @dev Returns the amount of tokens in existence.
476 	 */
477 	function totalSupply() external view returns (uint256);
478 	
479 	/**
480 	 * @dev Returns the amount of tokens owned by `account`.
481 	 */
482 	function balanceOf(address account) external view returns (uint256);
483 	
484 	/**
485 	 * @dev Moves `amount` tokens from the caller's account to `to`.
486 	 *
487 	 * Returns a boolean value indicating whether the operation succeeded.
488 	 *
489 	 * Emits a {Transfer} event.
490 	 */
491 	function transfer(address to, uint256 amount) external returns (bool);
492 	
493 	/**
494 	 * @dev Returns the remaining number of tokens that `spender` will be
495 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
496 	 * zero by default.
497 	 *
498 	 * This value changes when {approve} or {transferFrom} are called.
499 	 */
500 	function allowance(address owner, address spender) external view returns (uint256);
501 	
502 	/**
503 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
504 	 *
505 	 * Returns a boolean value indicating whether the operation succeeded.
506 	 *
507 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
508 	 * that someone may use both the old and the new allowance by unfortunate
509 	 * transaction ordering. One possible solution to mitigate this race
510 	 * condition is to first reduce the spender's allowance to 0 and set the
511 	 * desired value afterwards:
512 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
513 	 *
514 	 * Emits an {Approval} event.
515 	 */
516 	function approve(address spender, uint256 amount) external returns (bool);
517 	
518 	/**
519 	 * @dev Moves `amount` tokens from `from` to `to` using the
520 	 * allowance mechanism. `amount` is then deducted from the caller's
521 	 * allowance.
522 	 *
523 	 * Returns a boolean value indicating whether the operation succeeded.
524 	 *
525 	 * Emits a {Transfer} event.
526 	 */
527 	function transferFrom(
528 		address from,
529 		address to,
530 		uint256 amount
531 	) external returns (bool);
532 }
533 
534 
535 pragma solidity ^0.8.0;
536 
537 contract BURNER is Context, ERC721Burnable {
538 	event ReceivedRoyalties(address indexed creator, address indexed buyer, uint256 indexed amount);
539 	using SafeMath for uint256;
540 	bytes4 public constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
541 
542 	uint256 private _royaltiesPercentage = 7;
543 	uint256 private _mintFee = 50000000000000000; //0.05 ETH
544 	uint256 private _maxCap = 256;
545 	uint256 private _maxMintPerWallet = 25;
546 	uint256 private _mintedTokens = 0;
547 	address private _smartContractOwner = 0x65C7432E6662A96f4e999603991d5E929E57f60A;
548 	address private _smartContractCopilot = 0x4DaE7E6c0Ca196643012cDc526bBc6b445A2ca59;
549 	string private _name = "";
550 	string private _symbol = "";
551 	string private _description = "";
552 	string private _basePath = "https://crashblossom.co/burner/"; //returns the base path.
553 	string private _projectURI = ""; // Home web page, please leave it empty unless it's stored on a new path.
554 	string private _contractURI = "contract.php"; //return a JSON with the metadata of the contract.
555 	string private _baseTokenURI = "token.php"; //return a JSON with the metadata of any given token.
556 	string private _animationURI = "presentation.php"; //animation_url, it mixes and shows the final image dynamically.
557 	string private _tokenStaticImagePath = "assets/covers/";
558 	string private _banner_collection_URI = "assets/img/banner.jpg"; //Collection's banner.
559 	string private _contractImageURI = "assets/img/icon.jpg"; //Collection's icon.
560 	uint[16] _arrayGasTiers = [0, 3, 6, 9, 12, 15, 20, 65535]; //Tiers for layers 1-7. Layer 0 is base layer, always on. Layers 8 and 9 are special.
561 	mapping(uint => uint) private _tokenIdTracker;
562 	bool private _paused = false;
563 	bool private _frozen = false;
564 
565 	string private _strNotAuthorized = "Not authorized!";
566 	string private _strIDOutBounds = "ID out of bounds!";
567 	string private _strIndexOutOfBounds = "Index out of bounds!";
568 	string private _strNotMintedYet = "Not minted yet!";
569 	string private _strPaused = "Contract is paused!";
570 	string private _strFrozen = "Contract is frozen!";
571 
572 	string private _str1Block = "High Speed";
573 	string private _str2Block = "Medium Speed";
574 	string private _str4Block = "Low Speed";
575 
576 	string private _jsCode = "";
577 	string private _ipfsLayers = "";
578 	string private _serverRepo = "";
579 
580 	// CONSTRUCTOR
581 	constructor(string memory name, string memory symbol, string memory description) ERC721(name, symbol, description) {
582 		_name = name;
583 		_symbol = symbol;
584 		_description = description;
585 		_smartContractOwner = _msgSender();
586 	}
587 
588 	// INTERNAL AUX FUNCTIONS
589 
590 	function char(bytes1 b) internal pure returns(bytes1 c) {
591 		if(uint8(b) < 10) return bytes1(uint8(b) + 0x30);
592 		else return bytes1(uint8(b) + 0x57);
593 	}
594 
595 	function _getGasTier(uint gasCost) private view returns(uint) {
596 		uint retValue = 7;
597 		for(uint i = 0; i < 7; i++) {
598 			if(gasCost > _arrayGasTiers[i] && gasCost <= _arrayGasTiers[i + 1]) {
599 				retValue = i;
600 				break;
601 			}
602 		}
603 
604 		return retValue;
605 	}
606 
607 	function _getTokenTier(uint256 _tokenId) private pure returns(uint256) {
608 		if(_tokenId > 0 && _tokenId < 25) {
609 			return 3;
610 		}
611 		else if(_tokenId > 24 && _tokenId < 77) {
612 			return 2;
613 		}
614 		else {
615 			return 1;
616 		}
617 	}
618 
619 	function _getTokenTierName(uint256 _tokenId) private pure returns(string memory) {
620 		if(_tokenId > 0 && _tokenId < 25) {
621 			return 'Bright';
622 		}
623 		else if(_tokenId > 24 && _tokenId < 77) {
624 			return 'Dark';
625 		}
626 		else {
627 			return 'Collective layers';
628 		}
629 	}
630 
631 	function _getBlocksTierName(uint256 _tokenId) private view returns(string memory) {
632 		if(_tokenId > 0 && _tokenId < 16) {
633 			return _str1Block;
634 		}
635 		else if(_tokenId > 15 && _tokenId < 22) {
636 			return _str2Block;
637 		}
638 		else if(_tokenId > 21 && _tokenId < 25) {
639 			return _str4Block;
640 		}
641 		else if(_tokenId > 24 && _tokenId < 60) {
642 			return _str1Block;
643 		}
644 		else if(_tokenId > 59 && _tokenId < 72) {
645 			return _str2Block;
646 		}
647 		else if(_tokenId > 71 && _tokenId < 77) {
648 			return _str4Block;
649 		}
650 		else if(_tokenId > 76 && _tokenId < 205) {
651 			return _str1Block;
652 		}
653 		else if(_tokenId > 204 && _tokenId < 246) {
654 			return _str2Block;
655 		}
656 		else if(_tokenId > 245 && _tokenId < 257) {
657 			return _str4Block;
658 		}
659 	}
660 
661 	function toAsciiString(address x) internal pure returns(string memory) {
662 		bytes memory s = new bytes(40);
663 		for (uint i = 0; i < 20; i++) {
664 			bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
665 			bytes1 hi = bytes1(uint8(b) / 16);
666 			bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
667 			s[2*i] = char(hi);
668 			s[2*i+1] = char(lo);
669 		}
670 		return string(s);
671 	}
672 
673 	function _uint2str(uint256 _i) internal pure returns(string memory str) {
674 		if (_i == 0)  {
675 			return "0";
676 		}
677 		uint256 j = _i;
678 		uint256 length;
679 		while (j != 0) {
680 			length++;
681 			j /= 10;
682 		}
683 		bytes memory bstr = new bytes(length);
684 		uint256 k = length;
685 		j = _i;
686 		while (j != 0) {
687 			bstr[--k] = bytes1(uint8(48 + j % 10));
688 			j /= 10;
689 		}
690 		str = string(bstr);
691 
692 		return str;
693 	}
694 
695 	// GETTERS
696 
697 	/// @dev Returns the base URL (root folder) of the server storing all the scripts.
698 	function _basePathURI() internal view virtual returns(string memory) {
699 		return _basePath;
700 	}
701 	
702 	/// @dev Returns a URI pointing to the token-level JSON.
703 	function _baseURI() internal view virtual override returns(string memory) {
704 		return string(abi.encodePacked(_basePath, _baseTokenURI));
705 	}
706 
707 	/// @dev Returns a URI pointing to the collection's icon.
708 	function contractImageURI() public view returns(string memory) {
709 		return string(abi.encodePacked(_basePath, _contractImageURI));
710 	}
711 
712 	/// @dev Returns a URI pointing to the contract-level JSON.
713 	function contractURI() public view returns(string memory) {
714 		return string(abi.encodePacked(_basePath, _contractURI));
715 	}
716 	
717 	/// @dev Returns the description of the project.
718 	function description() public view returns(string memory) {
719 		return _description;
720 	}
721 
722 	/// @dev Returns the max amount of allowed mints per wallet.
723 	function _getMaxMintsPerWallet() public view returns(uint) {
724 		return _maxMintPerWallet;
725 	}
726 	
727 	/// @dev Returns a string that can be the actual JSON listing of all the IPFS layers, or a URI pointing at it.
728 	function getIPFSJSON() public view returns(string memory) {
729 		return _ipfsLayers;
730 	}
731 	
732 	/// @dev Returns a string that can be the actual JS code or a URI pointing at it.
733 	function getJSCode() public view returns(string memory) {
734 		return _jsCode;
735 	}
736 	
737 	/// @dev Returns a URI pointing to a remote repo holding all the server-side scripts.
738 	function getRemoteRepo() public view returns(string memory) {
739 		return _serverRepo;
740 	}
741 
742 	/// @dev Returns a boolean telling whether this contract has royalties or not.
743 	function hasRoyalties() public pure returns(bool) {
744 		return true;
745 	}
746 
747 	/// @dev Returns the max amount of tokens this contract can hold (256).
748 	function maxCap() public view returns(uint256) {
749 		return _maxCap;
750 	}
751 
752 	/// @dev Returns the mint fee, expressed in wei.
753 	function mintfee() public view returns(uint256) {
754 		return _mintFee;
755 	}
756 
757 	/// @dev Returns the name of the project (BURNER).
758 	function name() public view override returns(string memory) {
759 		return _name;
760 	}
761 
762 	/// @dev Returns a JSON containing all the contract-level data.
763 	function retrieveContractMetadata() public view returns(string memory data) {
764 		bytes memory json;
765 		uint royalties = _royaltiesPercentage * 100;
766 
767 		json = abi.encodePacked('{', '"name": "');
768 		json = abi.encodePacked(json, _name);
769 		json = abi.encodePacked(json, '"');
770 
771 		json = abi.encodePacked(json, ', ');
772 		json = abi.encodePacked(json, '"description": "');
773 		json = abi.encodePacked(json, _description);
774 		json = abi.encodePacked(json, '"');
775 
776 		json = abi.encodePacked(json, ', ');
777 		json = abi.encodePacked(json, '"image": "');
778 		json = abi.encodePacked(json, _basePath);
779 		json = abi.encodePacked(json, _contractImageURI);
780 		json = abi.encodePacked(json, '"');
781 
782 		json = abi.encodePacked(json, ', ');
783 		json = abi.encodePacked(json, '"external_link": "');
784 		json = abi.encodePacked(json, _basePath);
785 		json = abi.encodePacked(json, _projectURI);
786 		json = abi.encodePacked(json, '"');
787 
788 		json = abi.encodePacked(json, ', ');
789 		json = abi.encodePacked(json, '"banner_image_url": "');
790 		json = abi.encodePacked(json, _basePath);
791 		json = abi.encodePacked(json, _banner_collection_URI);
792 		json = abi.encodePacked(json, '"');
793 
794 		json = abi.encodePacked(json, ', ');
795 		json = abi.encodePacked(json, '"seller_fee_basis_points": ');
796 		json = abi.encodePacked(json, _uint2str(royalties));
797 
798 		json = abi.encodePacked(json, ', ');
799 		json = abi.encodePacked(json, '"fee_recipient": "');
800 		json = abi.encodePacked(json, toAsciiString(_smartContractOwner));
801 		json = abi.encodePacked(json, '"');
802 
803 		json = abi.encodePacked(json, '}');
804 
805 		return string(json);
806 	}
807 
808 	/// @dev Returns a list of all the minted tokens so far.
809 	///      Note: Return value is an array containing all the tokenIDs stored onchain. Unconfirmed tx will not show up here.
810 	function retrieveTokenIDList() public view returns(string memory data) {
811 		bytes memory json;
812 
813 		json = abi.encodePacked('[');
814 
815 		if(_mintedTokens > 0) {
816 			for(uint i = 1; i <= _mintedTokens; i++) {
817 				if(i == 1) {
818 					json = abi.encodePacked(json, _uint2str(_tokenIdTracker[i]));
819 				}
820 				else {
821 					json = abi.encodePacked(json, ',', _uint2str(_tokenIdTracker[i]));
822 				}
823 			}
824 		}
825 
826 		json = abi.encodePacked(json, ']');
827 
828 		return string(json);
829 	}
830 
831 	/// @dev Returns a JSON containing all the associated data to a given token.
832 	/// @param _tokenId Token ID.
833 	function retrieveData(uint256 _tokenId) external view returns(string memory data) {
834 		// This function returns the metadata of a given token.
835 		require(_tokenId > 0, _strIDOutBounds);
836 		require(_tokenId <= _maxCap, _strIDOutBounds);
837 		require(_exists(_tokenId), _strNotMintedYet);
838 
839 		uint256 rarity = 0;
840 		bytes memory json;
841 
842 		rarity = _getTokenTier(_tokenId);
843 
844 		json = abi.encodePacked('{', '"name": "');
845 		json = abi.encodePacked(json, _symbol);
846 		json = abi.encodePacked(json, ' #');
847 		json = abi.encodePacked(json, _uint2str(_tokenId));
848 		json = abi.encodePacked(json, '"');
849 		json = abi.encodePacked(json, ', ');
850 		json = abi.encodePacked(json, '"description": "');
851 		json = abi.encodePacked(json, _description);
852 		json = abi.encodePacked(json, ' Artist: crashblossom, Dev: Ariel Becker.');
853 		json = abi.encodePacked(json, '"');
854 		json = abi.encodePacked(json, ', ');
855 		json = abi.encodePacked(json, '"owner": "0x');
856 		json = abi.encodePacked(json, toAsciiString(ownerOf(_tokenId)));
857 		json = abi.encodePacked(json, '"');
858 		json = abi.encodePacked(json, ', ');
859 		json = abi.encodePacked(json, '"external_url": "');
860 		json = abi.encodePacked(json, _basePath);
861 		json = abi.encodePacked(json, _animationURI);
862 		json = abi.encodePacked(json, '?t=0&local=1&id=');
863 		json = abi.encodePacked(json, _uint2str(_tokenId));
864 		json = abi.encodePacked(json, '"');
865 		json = abi.encodePacked(json, ', ');
866 		json = abi.encodePacked(json, '"animation_url": "');
867 		json = abi.encodePacked(json, _basePath);
868 		json = abi.encodePacked(json, _animationURI);
869 		json = abi.encodePacked(json, '?t=1&id=');
870 		json = abi.encodePacked(json, _uint2str(_tokenId));
871 		json = abi.encodePacked(json, '"');
872 		json = abi.encodePacked(json, ', ');
873 		json = abi.encodePacked(json, '"image": "');
874 		json = abi.encodePacked(json, _basePath);
875 		json = abi.encodePacked(json, _tokenStaticImagePath);
876 		json = abi.encodePacked(json, _uint2str(_tokenId));
877 		json = abi.encodePacked(json, '.jpg');
878 		json = abi.encodePacked(json, '"');
879 		json = abi.encodePacked(json, ', ');
880 		json = abi.encodePacked(json, '"attributes": [');
881 
882 		json = abi.encodePacked(json, '{');
883 		json = abi.encodePacked(json, '"trait_type": "Speed"');
884 		json = abi.encodePacked(json, ', ');
885 		json = abi.encodePacked(json, '"value": "');
886 		json = abi.encodePacked(json, _getBlocksTierName(_tokenId));
887 		json = abi.encodePacked(json, '"');
888 		json = abi.encodePacked(json, '},');
889 
890 		json = abi.encodePacked(json, '{');
891 		json = abi.encodePacked(json, '"trait_type": "Layer"');
892 		json = abi.encodePacked(json, ', ');
893 		json = abi.encodePacked(json, '"value": "Shared"');
894 		json = abi.encodePacked(json, '}');
895 
896 		if(rarity == 2 || rarity == 3) {
897 			json = abi.encodePacked(json, ', ');
898 			json = abi.encodePacked(json, '{');
899 			json = abi.encodePacked(json, '"trait_type": "Layer"');
900 			json = abi.encodePacked(json, ', ');
901 			json = abi.encodePacked(json, '"value": "Dark"');
902 			json = abi.encodePacked(json, '}');
903 		}
904 		if(rarity == 3) {
905 			json = abi.encodePacked(json, ', ');
906 			json = abi.encodePacked(json, '{');
907 			json = abi.encodePacked(json, '"trait_type": "Layer"');
908 			json = abi.encodePacked(json, ', ');
909 			json = abi.encodePacked(json, '"value": "Bright"');
910 			json = abi.encodePacked(json, '}');
911 		}
912 
913 		json = abi.encodePacked(json, ']');
914 		json = abi.encodePacked(json, '}');
915 
916 		return string(json);
917 	}
918 
919 	/// @dev Returns a URI pointing to the server-side script that will display the animation for any token.
920 	function _renderURI() internal view virtual returns(string memory) {
921 		return string(abi.encodePacked(_basePath, _animationURI));
922 	}
923 
924 	/// @dev Returns the royalties' percentage assigned to the project.
925 	function royaltyAmount() public view returns(uint256) {
926 		return _royaltiesPercentage;
927 	}
928 
929 	/// @dev Returns the royalties that will be paid according to token ID and sale price.
930 	///      Note: Return value is expressed in wei.
931 	/// @param _tokenId Token ID.
932 	/// @param _salePrice Sale price, in wei.
933 	function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns(address receiver, uint256 royaltiesAmount) {
934 		require(_tokenId > 0, _strIDOutBounds);
935 		require(_tokenId <= _maxCap, _strIDOutBounds);
936 		require(_exists(_tokenId), _strNotMintedYet);
937 		require(_salePrice > 99, "Price is too small!");
938 
939 		uint256 retValue = _salePrice.div(100).mul(_royaltiesPercentage);
940 		return(_smartContractOwner, retValue);
941 	}
942 
943 	/// @dev Returns a URI pointing to the token's JSON.
944 	/// @param _tokenId Token ID.
945 	function tokenURI(uint256 _tokenId) public view virtual override returns(string memory) {
946 		// Example: https://opensea-creatures-api.herokuapp.com/api/creature/3
947 		require(_tokenId > 0, _strIDOutBounds);
948 		require(_tokenId <= _maxCap, _strIDOutBounds);
949 		require(_exists(_tokenId), _strNotMintedYet);
950 
951 		string memory baseURI = _baseURI();
952 		return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "?id=", Strings.toString(_tokenId))) : "";
953 	}
954 
955 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns(bool) {
956 		return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
957 	}
958 
959 	/// @dev Returns the contract's symbol (BURNER).
960 	function symbol() public view override returns(string memory) {
961 		return _symbol;
962 	}
963 
964 	/// @dev Returns a URI pointing to the folder containing all the layers images.
965 	function tokenImageURI() public view returns(string memory) {
966 		return string(abi.encodePacked(_basePath, _tokenStaticImagePath));
967 	}
968 
969 	/// @dev Returns the animation's renderer URI (the one that initializes the JS script).
970 	/// @param _tokenId Token ID.
971 	function tokenShowcaseURI(uint _tokenId) public view returns(string memory) {
972 		require(_tokenId > 0, _strIDOutBounds);
973 		require(_tokenId <= _maxCap, _strIDOutBounds);
974 		require(_exists(_tokenId), _strNotMintedYet);
975 		string memory uri = string(abi.encodePacked(_basePath, _animationURI));
976 		return bytes(uri).length > 0 ? string(abi.encodePacked(uri, "?t=0&id=", Strings.toString(_tokenId))) : "";
977 	}
978 
979 	// SETTERS
980 
981 	/// @dev Changes the contract's description.
982 	/// @param _desc New description.
983 	function changeDescription(string memory _desc) public {
984 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
985 		require(!_frozen, _strFrozen);
986 		_description = _desc;
987 	}
988 	
989 	/// @dev Freezes the contract, disabling some functions forever.
990 	///      WARNING: ONCE SET, THIS STATE CANNOT BE REVERSED.
991 	///      This is the list of functions that will be disabled by it:
992 	///      changeDescription, setMaxMintsPerWallet, setMintFee, setRoyaltyAmount, setIPFSLayers, setJS, setServerRepoURI.
993 	function freeze() public virtual {
994 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
995 		require(!_frozen, _strFrozen);
996 		_frozen = true;
997 	}
998 
999 	/// @dev Pauses some functions of the contract, like minting.
1000 	function pause() public virtual {
1001 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1002 		require(!_paused, _strPaused);
1003 		_paused = true;
1004 	}
1005 
1006 	/// @dev Sets the admin's address.
1007 	/// @param _newAddress New address.
1008 	function setAdmin(address _newAddress) public {
1009 		require((_msgSender() == _smartContractOwner || _msgSender() == _smartContractCopilot), _strNotAuthorized);
1010 		_smartContractOwner = _newAddress;
1011 	}
1012 
1013 	/// @dev Sets the base URI for all the relative paths.
1014 	/// @param _uri Base URI.
1015 	function setBasePath(string memory _uri) public {
1016 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1017 		_basePath = _uri;
1018 	}
1019 
1020 	/// @dev Sets the relative path to token.php (or any other server-side script responsible for rendering the token's JSON).
1021 	/// @param _relativePath Relative path and filename.
1022 	function setBaseTokenURI(string memory _relativePath) public {
1023 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1024 		_baseTokenURI = _relativePath;
1025 	}
1026 
1027 	/// @dev Sets the relative path to the contract's image.
1028 	/// @param _relativePath Relative path and filename.
1029 	function setContractImage(string memory _relativePath) public {
1030 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1031 		_contractImageURI = _relativePath;
1032 	}
1033 
1034 	/// @dev Sets the relative path to contract.php (or any other server-side script responsible for rendering the contract's JSON).
1035 	/// @param _relativePath Relative path and filename.
1036 	function setContractURI(string memory _relativePath) public {
1037 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1038 		_contractURI = _relativePath;
1039 	}
1040 
1041 	/// @dev Sets the maximum amount of tokens a single wallet can mint.
1042 	///      Note: default value is 25.
1043 	/// @param _maxAmount New value, expressed in percent points.
1044 	function setMaxMintsPerWallet(uint256 _maxAmount) public {
1045 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1046 		require(!_frozen, _strFrozen);
1047 		require(_maxAmount < 257, "Cannot exceed total supply!");
1048 		require(_maxAmount > 0, "Must be 1 or higher!");
1049 		_maxMintPerWallet = _maxAmount;
1050 	}
1051 
1052 	/// @dev Changes the value of the minting fee. Expressed in wei.
1053 	///      Note: default value is 0.01 ETH.
1054 	/// @param _newfee New value, expressed in wei.
1055 	function setMintFee(uint256 _newfee) public {
1056 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1057 		require(!_frozen, _strFrozen);
1058 		_mintFee = _newfee;
1059 	}
1060 
1061 	/// @dev Relative path for the webpage.
1062 	///      Note: Relative to base URI.
1063 	/// @param _relativePath New relative path.
1064 	function setProjectURI(string memory _relativePath) public {
1065 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1066 		_projectURI = _relativePath;
1067 	}
1068 
1069 	/// @dev Changes the value of the royalty percentage. Expressed in percent points.
1070 	///      Note: default value is 7.
1071 	/// @param _percentage New value, expressed in percent points.
1072 	function setRoyaltyAmount(uint256 _percentage) public {
1073 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1074 		require(!_frozen, _strFrozen);
1075 		_royaltiesPercentage = _percentage;
1076 	}
1077 	
1078 	/// @dev Sets the relative path where all the static imagery (gallery images) for each token is stored.
1079 	/// @param _relativePath Path relative to base URL.
1080 	function setTokenStaticImageURI(string memory _relativePath) public {
1081 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1082 		_tokenStaticImagePath = _relativePath;
1083 	}
1084 
1085 	/// @dev Sets the relative path where all the dynamic imagery for each token is stored.
1086 	/// @param _relativePath Path relative to base URL.
1087 	function setTokenImageURI(string memory _relativePath) public {
1088 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1089 		_animationURI = _relativePath;
1090 	}
1091 	
1092 	/// @dev Stores a JSON containing the list of all the imagery used for the token layers.
1093 	///      Note: It can store the list itself or a URI pointing to the actual list.
1094 	/// @param _json A JSON object containing the list of all the hashes for both full-size and thumbnails, or a URI pointing to a valid JSON.
1095 	function setIPFSLayers(string memory _json) public {
1096 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1097 		require(!_frozen, _strFrozen);
1098 		_ipfsLayers = _json;
1099 	}
1100 	
1101 	/// @dev Stores the code of the contract, or a URI pointing to it.
1102 	///      Note: You can minify then ZIP and base64 it to reduce the amount of data. Remember to modify the PHP on the gateway to reflect this.
1103 	/// @param _str URI to the code, or the code itself.
1104 	function setJS(string memory _str) public {
1105 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1106 		require(!_frozen, _strFrozen);
1107 		_jsCode = _str;
1108 	}
1109 	
1110 	/// @dev Stores a URI pointing to the server-side code of the project.
1111 	/// @param _uri URI to the repository.
1112 	function setServerRepoURI(string memory _uri) public {
1113 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1114 		require(!_frozen, _strFrozen);
1115 		_serverRepo = _uri;
1116 	}
1117 	
1118 	/// @dev Unpauses the contract, allowing some functions to operate again.
1119 	function unpause() public virtual {
1120 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1121 		require(_paused, "Contract is already unpaused!");
1122 		_paused = false;
1123 	}
1124 
1125 	// MINT AND OTHER FUNCTIONS
1126 	function royaltiesReceived(address _creator, address _buyer, uint256 _amount) external {
1127 		emit ReceivedRoyalties(_creator, _buyer, _amount);
1128 	}
1129 
1130 	/// @dev Allows to withdraw any ETH available on this contract.
1131 	///      Note: Only the contract's owner can withdraw.
1132 	function withdraw() public payable {
1133 		require(!_paused, _strPaused);
1134 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1135 		uint balance = address(this).balance;
1136 		require(balance > 0, "No ether left to withdraw");
1137 		(bool success, ) = (msg.sender).call{value: balance}("");
1138 		require(success, "Transfer failed.");
1139 	}
1140 	
1141 	/// @dev Allows to withdraw any ERC-20 token sent by error to this contract.
1142 	///      Note: Only the contract's owner can withdraw.
1143 	function withdrawERC20(IERC20 token) public payable {
1144 		require(!_paused, _strPaused);
1145 		require(_msgSender() == _smartContractOwner, _strNotAuthorized);
1146 		require(token.transfer(msg.sender, token.balanceOf(address(this))), "Transfer failed");
1147 	}
1148 	
1149 	/// @dev Mints a random token. Non-admins must pay a fee for it.
1150 	///      Note: The fees are always transferred, even if the user transaction fails.
1151 	function mint() public payable {
1152 		// Shouldn't be paused.
1153 		require(!_paused, _strPaused);
1154 		// Shouldn't attempt to mint more tokens than allowed per address.
1155 		require(ERC721.balanceOf(_msgSender()) < (_maxMintPerWallet), "More than max mints allowed for this addy!");
1156 		// Shouldn't attempt to mint more tokens than the allowed by the contract.
1157 		require(ERC721.balanceOf(_msgSender()) < (_maxCap - _mintedTokens), "This action will surpass the mint cap!");
1158 		// Shouldn't be minted by the zero addy.
1159 		require(_msgSender() != address(0), "Zero address");
1160 
1161 		if(_msgSender() != _smartContractOwner) {
1162 			require(msg.value >= _mintFee, "Not enough ETH!");
1163 		}
1164 
1165 		bool boolBreakLoop = false;
1166 
1167 		while(!boolBreakLoop) {
1168 			//Create a pseudorandom seed in the form of a hash
1169 			bytes32 seed = keccak256(abi.encodePacked(block.timestamp, block.difficulty, _msgSender()));
1170 			// Extract the last byte.
1171 			uint8 _index = uint8(bytes1(seed[0]));
1172 			// Add one so it goes from 1 to 256.
1173 			uint index = _index + 1;
1174 
1175 			// And use that index to mint a pseudorandom tokenID.
1176 			if(!_exists(index)) {
1177 				if(index > 0 && index <= _maxCap) {
1178 					_mint(_msgSender(), index);
1179 					_mintedTokens++;
1180 					_tokenIdTracker[_mintedTokens] = index;
1181 					boolBreakLoop = true;
1182 				}
1183 			}
1184 		}
1185 	}
1186 }