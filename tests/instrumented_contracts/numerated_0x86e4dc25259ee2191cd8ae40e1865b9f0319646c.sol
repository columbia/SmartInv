1 pragma solidity ^0.4.24;
2 
3 /**
4  * @summary: CryptoRome Land ERC-998 Bottom-Up Composable NFT Contract (and additional helper contracts)
5  * @author: GigLabs, LLC
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that revert on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, reverts on overflow.
16   */
17   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
18     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (_a == 0) {
22       return 0;
23     }
24 
25     uint256 c = _a * _b;
26     require(c / _a == _b);
27 
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
33   */
34   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     require(_b > 0); // Solidity only automatically asserts when dividing by 0
36     uint256 c = _a / _b;
37     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
38 
39     return c;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     require(_b <= _a);
47     uint256 c = _a - _b;
48 
49     return c;
50   }
51 
52   /**
53   * @dev Adds two numbers, reverts on overflow.
54   */
55   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     uint256 c = _a + _b;
57     require(c >= _a);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
64   * reverts when dividing by zero.
65   */
66   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b != 0);
68     return a % b;
69   }
70 }
71 
72 
73 /**
74  * @title ERC721 Non-Fungible Token Standard basic interface
75  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
76  *  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
77  */
78 interface ERC721 /* is ERC165 */ {
79     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
80     event Approval(address indexed _tokenOwner, address indexed _approved, uint256 indexed _tokenId);
81     event ApprovalForAll(address indexed _tokenOwner, address indexed _operator, bool _approved);
82 
83     function balanceOf(address _tokenOwner) external view returns (uint256 _balance);
84     function ownerOf(uint256 _tokenId) external view returns (address _tokenOwner);
85     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external;
86     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
87     function transferFrom(address _from, address _to, uint256 _tokenId) external;
88     function approve(address _to, uint256 _tokenId) external;
89     function setApprovalForAll(address _operator, bool _approved) external;
90     function getApproved(uint256 _tokenId) external view returns (address _operator);
91     function isApprovedForAll(address _tokenOwner, address _operator) external view returns (bool);
92 }
93  
94  
95 /**
96  * @notice Query if a contract implements an interface
97  * @dev Interface identification is specified in ERC-165. This function
98  * uses less than 30,000 gas.
99  */
100 interface ERC165 {
101     function supportsInterface(bytes4 interfaceID) external view returns (bool);
102 }
103 
104 interface ERC721TokenReceiver {
105     /** 
106      * @notice Handle the receipt of an NFT
107      * @dev The ERC721 smart contract calls this function on the recipient
108      * after a `transfer`. This function MAY throw to revert and reject the
109      * transfer. Return of other than the magic value MUST result in the
110      * transaction being reverted.
111      * Note: the contract address is always the message sender.
112      * @param _operator The address which called `safeTransferFrom` function
113      * @param _from The address which previously owned the token
114      * @param _tokenId The NFT identifier which is being transferred
115      * @param _data Additional data with no specified format
116      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
117      * unless throwing
118      */
119     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
120 }
121 
122 /**
123  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
124  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
125  * Note: the ERC-165 identifier for this interface is 0x5b5e139f.
126  */
127 interface ERC721Metadata /* is ERC721 */ {
128     function name() external view returns (string _name);
129     function symbol() external view returns (string _symbol);
130     function tokenURI(uint256 _tokenId) external view returns (string);
131 }
132 
133 /**
134  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
135  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
136  * Note: the ERC-165 identifier for this interface is 0x780e9d63.
137  */
138 interface ERC721Enumerable /* is ERC721 */ {
139     function totalSupply() external view returns (uint256);
140     function tokenByIndex(uint256 _index) external view returns (uint256);
141     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
142 }
143 
144 /**
145  * @title ERC998ERC721 Bottom-Up Composable Non-Fungible Token
146  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-998.md
147  * Note: the ERC-165 identifier for this interface is 0xa1b23002
148  */
149 interface ERC998ERC721BottomUp {
150     event TransferToParent(address indexed _toContract, uint256 indexed _toTokenId, uint256 _tokenId);
151     event TransferFromParent(address indexed _fromContract, uint256 indexed _fromTokenId, uint256 _tokenId);
152 
153 
154     function rootOwnerOf(uint256 _tokenId) public view returns (bytes32 rootOwner);
155 
156     /**
157     * The tokenOwnerOf function gets the owner of the _tokenId which can be a user address or another ERC721 token.
158     * The tokenOwner address return value can be either a user address or an ERC721 contract address.
159     * If the tokenOwner address is a user address then parentTokenId will be 0 and should not be used or considered.
160     * If tokenOwner address is a user address then isParent is false, otherwise isChild is true, which means that
161     * tokenOwner is an ERC721 contract address and _tokenId is a child of tokenOwner and parentTokenId.
162     */
163     function tokenOwnerOf(uint256 _tokenId) external view returns (bytes32 tokenOwner, uint256 parentTokenId, bool isParent);
164 
165     // Transfers _tokenId as a child to _toContract and _toTokenId
166     function transferToParent(address _from, address _toContract, uint256 _toTokenId, uint256 _tokenId, bytes _data) public;
167     // Transfers _tokenId from a parent ERC721 token to a user address.
168     function transferFromParent(address _fromContract, uint256 _fromTokenId, address _to, uint256 _tokenId, bytes _data) public;
169     // Transfers _tokenId from a parent ERC721 token to a parent ERC721 token.
170     function transferAsChild(address _fromContract, uint256 _fromTokenId, address _toContract, uint256 _toTokenId, uint256 _tokenId, bytes _data) external;
171 
172 }
173 
174 /**
175  * @title ERC998ERC721 Bottom-Up Composable, optional enumerable extension
176  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-998.md
177  * Note: The ERC-165 identifier for this interface is 0x8318b539
178  */
179 interface ERC998ERC721BottomUpEnumerable {
180     function totalChildTokens(address _parentContract, uint256 _parentTokenId) external view returns (uint256);
181     function childTokenByIndex(address _parentContract, uint256 _parentTokenId, uint256 _index) external view returns (uint256);
182 }
183 
184 contract ERC998ERC721BottomUpToken is ERC721, ERC721Metadata, ERC721Enumerable, ERC165, ERC998ERC721BottomUp, ERC998ERC721BottomUpEnumerable {
185     using SafeMath for uint256;
186 
187     struct TokenOwner {
188         address tokenOwner;
189         uint256 parentTokenId;
190     }
191 
192     // return this.rootOwnerOf.selector ^ this.rootOwnerOfChild.selector ^
193     //   this.tokenOwnerOf.selector ^ this.ownerOfChild.selector;
194     bytes32 constant ERC998_MAGIC_VALUE = 0xcd740db5;
195 
196     // total number of tokens
197     uint256 internal tokenCount;
198 
199     // tokenId => token owner
200     mapping(uint256 => TokenOwner) internal tokenIdToTokenOwner;
201 
202     // Mapping from owner to list of owned token IDs
203     mapping(address => uint256[]) internal ownedTokens;
204 
205     // Mapping from token ID to index of the owner tokens list
206     mapping(uint256 => uint256) internal ownedTokensIndex;
207 
208     // root token owner address => (tokenId => approved address)
209     mapping(address => mapping(uint256 => address)) internal rootOwnerAndTokenIdToApprovedAddress;
210 
211     // parent address => (parent tokenId => array of child tokenIds)
212     mapping(address => mapping(uint256 => uint256[])) internal parentToChildTokenIds;
213 
214     // tokenId => position in childTokens array
215     mapping(uint256 => uint256) internal tokenIdToChildTokenIdsIndex;
216 
217     // token owner => (operator address => bool)
218     mapping(address => mapping(address => bool)) internal tokenOwnerToOperators;
219 
220     // Token name
221     string internal name_;
222 
223     // Token symbol
224     string internal symbol_;
225 
226     // Token URI
227     string internal tokenURIBase;
228 
229     mapping(bytes4 => bool) internal supportedInterfaces;
230 
231     //from zepellin ERC721Receiver.sol
232     //old version
233     bytes4 constant ERC721_RECEIVED = 0x150b7a02;
234 
235     function isContract(address _addr) internal view returns (bool) {
236         uint256 size;
237         assembly {size := extcodesize(_addr)}
238         return size > 0;
239     }
240 
241     constructor () public {
242         //ERC165
243         supportedInterfaces[0x01ffc9a7] = true;
244         //ERC721
245         supportedInterfaces[0x80ac58cd] = true;
246         //ERC721Metadata
247         supportedInterfaces[0x5b5e139f] = true;
248         //ERC721Enumerable
249         supportedInterfaces[0x780e9d63] = true;
250         //ERC998ERC721BottomUp
251         supportedInterfaces[0xa1b23002] = true;
252         //ERC998ERC721BottomUpEnumerable
253         supportedInterfaces[0x8318b539] = true;
254     }
255 
256     /////////////////////////////////////////////////////////////////////////////
257     //
258     // ERC165Impl
259     //
260     /////////////////////////////////////////////////////////////////////////////
261     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
262         return supportedInterfaces[_interfaceID];
263     }
264 
265     /////////////////////////////////////////////////////////////////////////////
266     //
267     // ERC721 implementation & ERC998 Authentication
268     //
269     /////////////////////////////////////////////////////////////////////////////
270     function balanceOf(address _tokenOwner) public view returns (uint256) {
271         require(_tokenOwner != address(0));
272         return ownedTokens[_tokenOwner].length;
273     }
274 
275     // returns the immediate owner of the token
276     function ownerOf(uint256 _tokenId) public view returns (address) {
277         address tokenOwner = tokenIdToTokenOwner[_tokenId].tokenOwner;
278         require(tokenOwner != address(0));
279         return tokenOwner;
280     }
281 
282     function transferFrom(address _from, address _to, uint256 _tokenId) external {
283         require(_to != address(this));
284         _transferFromOwnerCheck(_from, _to, _tokenId);
285         _transferFrom(_from, _to, _tokenId);
286     }
287 
288     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
289         _transferFromOwnerCheck(_from, _to, _tokenId);
290         _transferFrom(_from, _to, _tokenId);
291         require(_checkAndCallSafeTransfer(_from, _to, _tokenId, ""));
292 
293     }
294 
295     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
296         _transferFromOwnerCheck(_from, _to, _tokenId);
297         _transferFrom(_from, _to, _tokenId);
298         require(_checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
299     }
300 
301     function _checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal view returns (bool) {
302         if (!isContract(_to)) {
303             return true;
304         }
305         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
306         return (retval == ERC721_RECEIVED);
307     }
308 
309     function _transferFromOwnerCheck(address _from, address _to, uint256 _tokenId) internal {
310         require(_from != address(0));
311         require(_to != address(0));
312         require(tokenIdToTokenOwner[_tokenId].tokenOwner == _from);
313         require(tokenIdToTokenOwner[_tokenId].parentTokenId == 0);
314 
315         // check child approved
316         address approvedAddress = rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId];
317         if(msg.sender != _from) {
318             bytes32 tokenOwner;
319             bool callSuccess;
320             // 0xeadb80b8 == ownerOfChild(address,uint256)
321             bytes memory calldata = abi.encodeWithSelector(0xed81cdda, address(this), _tokenId);
322             assembly {
323                 callSuccess := staticcall(gas, _from, add(calldata, 0x20), mload(calldata), calldata, 0x20)
324                 if callSuccess {
325                     tokenOwner := mload(calldata)
326                 }
327             }
328             if(callSuccess == true) {
329                 require(tokenOwner >> 224 != ERC998_MAGIC_VALUE);
330             }
331             require(tokenOwnerToOperators[_from][msg.sender] || approvedAddress == msg.sender);
332         }
333 
334         // clear approval
335         if (approvedAddress != address(0)) {
336             delete rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId];
337             emit Approval(_from, address(0), _tokenId);
338         }
339     }
340 
341     function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
342         // first remove the token from the owner list of owned tokens
343         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
344         uint256 lastTokenId = ownedTokens[_from][lastTokenIndex];
345         if (lastTokenId != _tokenId) {
346             // replace the _tokenId in the list of ownedTokens with the
347             // last token id in the list. Make sure ownedTokensIndex gets updated
348             // with the new position of the last token id as well.
349             uint256 tokenIndex = ownedTokensIndex[_tokenId];
350             ownedTokens[_from][tokenIndex] = lastTokenId;
351             ownedTokensIndex[lastTokenId] = tokenIndex;
352         }
353 
354         // resize ownedTokens array (automatically deletes the last array entry)
355         ownedTokens[_from].length--;
356 
357         // transfer token
358         tokenIdToTokenOwner[_tokenId].tokenOwner = _to;
359         
360         // add token to the new owner's list of owned tokens
361         ownedTokensIndex[_tokenId] = ownedTokens[_to].length;
362         ownedTokens[_to].push(_tokenId);
363 
364         emit Transfer(_from, _to, _tokenId);
365     }
366 
367     function approve(address _approved, uint256 _tokenId) external {
368         address tokenOwner = tokenIdToTokenOwner[_tokenId].tokenOwner;
369         require(tokenOwner != address(0));
370         address rootOwner = address(rootOwnerOf(_tokenId));
371         require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender]);
372 
373         rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId] = _approved;
374         emit Approval(rootOwner, _approved, _tokenId);
375     }
376 
377     function getApproved(uint256 _tokenId) public view returns (address)  {
378         address rootOwner = address(rootOwnerOf(_tokenId));
379         return rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId];
380     }
381 
382     function setApprovalForAll(address _operator, bool _approved) external {
383         require(_operator != address(0));
384         tokenOwnerToOperators[msg.sender][_operator] = _approved;
385         emit ApprovalForAll(msg.sender, _operator, _approved);
386     }
387 
388     function isApprovedForAll(address _owner, address _operator) external view returns (bool)  {
389         require(_owner != address(0));
390         require(_operator != address(0));
391         return tokenOwnerToOperators[_owner][_operator];
392     }
393 
394     function _tokenOwnerOf(uint256 _tokenId) internal view returns (address tokenOwner, uint256 parentTokenId, bool isParent) {
395         tokenOwner = tokenIdToTokenOwner[_tokenId].tokenOwner;
396         require(tokenOwner != address(0));
397         parentTokenId = tokenIdToTokenOwner[_tokenId].parentTokenId;
398         if (parentTokenId > 0) {
399             isParent = true;
400             parentTokenId--;
401         }
402         else {
403             isParent = false;
404         }
405         return (tokenOwner, parentTokenId, isParent);
406     }
407 
408     
409     function tokenOwnerOf(uint256 _tokenId) external view returns (bytes32 tokenOwner, uint256 parentTokenId, bool isParent) {
410         address tokenOwnerAddress = tokenIdToTokenOwner[_tokenId].tokenOwner;
411         require(tokenOwnerAddress != address(0));
412         parentTokenId = tokenIdToTokenOwner[_tokenId].parentTokenId;
413         if (parentTokenId > 0) {
414             isParent = true;
415             parentTokenId--;
416         }
417         else {
418             isParent = false;
419         }
420         return (ERC998_MAGIC_VALUE << 224 | bytes32(tokenOwnerAddress), parentTokenId, isParent);
421     }
422 
423     // Use Cases handled:
424     // Case 1: Token owner is this contract and no parent tokenId.
425     // Case 2: Token owner is this contract and token
426     // Case 3: Token owner is top-down composable
427     // Case 4: Token owner is an unknown contract
428     // Case 5: Token owner is a user
429     // Case 6: Token owner is a bottom-up composable
430     // Case 7: Token owner is ERC721 token owned by top-down token
431     // Case 8: Token owner is ERC721 token owned by unknown contract
432     // Case 9: Token owner is ERC721 token owned by user
433     function rootOwnerOf(uint256 _tokenId) public view returns (bytes32 rootOwner) {
434         address rootOwnerAddress = tokenIdToTokenOwner[_tokenId].tokenOwner;
435         require(rootOwnerAddress != address(0));
436         uint256 parentTokenId = tokenIdToTokenOwner[_tokenId].parentTokenId;
437         bool isParent = parentTokenId > 0;
438         if (isParent) {
439             parentTokenId--;
440         }
441 
442         if((rootOwnerAddress == address(this))) {
443             do {
444                 if(isParent == false) {
445                     // Case 1: Token owner is this contract and no token.
446                     // This case should not happen.
447                     return ERC998_MAGIC_VALUE << 224 | bytes32(rootOwnerAddress);
448                 }
449                 else {
450                     // Case 2: Token owner is this contract and token
451                     (rootOwnerAddress, parentTokenId, isParent) = _tokenOwnerOf(parentTokenId);
452                 }
453             } while(rootOwnerAddress == address(this));
454             _tokenId = parentTokenId;
455         }
456 
457         bytes memory calldata;
458         bool callSuccess;
459 
460         if (isParent == false) {
461 
462             // success if this token is owned by a top-down token
463             // 0xed81cdda == rootOwnerOfChild(address, uint256)
464             calldata = abi.encodeWithSelector(0xed81cdda, address(this), _tokenId);
465             assembly {
466                 callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
467                 if callSuccess {
468                     rootOwner := mload(calldata)
469                 }
470             }
471             if(callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
472                 // Case 3: Token owner is top-down composable
473                 return rootOwner;
474             }
475             else {
476                 // Case 4: Token owner is an unknown contract
477                 // Or
478                 // Case 5: Token owner is a user
479                 return ERC998_MAGIC_VALUE << 224 | bytes32(rootOwnerAddress);
480             }
481         }
482         else {
483 
484             // 0x43a61a8e == rootOwnerOf(uint256)
485             calldata = abi.encodeWithSelector(0x43a61a8e, parentTokenId);
486             assembly {
487                 callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
488                 if callSuccess {
489                     rootOwner := mload(calldata)
490                 }
491             }
492             if (callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
493                 // Case 6: Token owner is a bottom-up composable
494                 // Or
495                 // Case 2: Token owner is top-down composable
496                 return rootOwner;
497             }
498             else {
499                 // token owner is ERC721
500                 address childContract = rootOwnerAddress;
501                 //0x6352211e == "ownerOf(uint256)"
502                 calldata = abi.encodeWithSelector(0x6352211e, parentTokenId);
503                 assembly {
504                     callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
505                     if callSuccess {
506                         rootOwnerAddress := mload(calldata)
507                     }
508                 }
509                 require(callSuccess);
510 
511                 // 0xed81cdda == rootOwnerOfChild(address,uint256)
512                 calldata = abi.encodeWithSelector(0xed81cdda, childContract, parentTokenId);
513                 assembly {
514                     callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
515                     if callSuccess {
516                         rootOwner := mload(calldata)
517                     }
518                 }
519                 if(callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
520                     // Case 7: Token owner is ERC721 token owned by top-down token
521                     return rootOwner;
522                 }
523                 else {
524                     // Case 8: Token owner is ERC721 token owned by unknown contract
525                     // Or
526                     // Case 9: Token owner is ERC721 token owned by user
527                     return ERC998_MAGIC_VALUE << 224 | bytes32(rootOwnerAddress);
528                 }
529             }
530         }
531     }
532 
533     // List of all Land Tokens assigned to an address.
534     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
535         return ownedTokens[_owner];
536     }
537 
538     /////////////////////////////////////////////////////////////////////////////
539     //
540     // ERC721MetadataImpl
541     //
542     /////////////////////////////////////////////////////////////////////////////
543 
544     function tokenURI(uint256 _tokenId) external view returns (string) {
545         require (exists(_tokenId));
546         return _appendUintToString(tokenURIBase, _tokenId);
547     }
548 
549     function name() external view returns (string) {
550         return name_;
551     }
552 
553     function symbol() external view returns (string) {
554         return symbol_;
555     }
556 
557     function _appendUintToString(string inStr, uint v) private pure returns (string str) {
558         uint maxlength = 100;
559         bytes memory reversed = new bytes(maxlength);
560         uint i = 0;
561         while (v != 0) {
562             uint remainder = v % 10;
563             v = v / 10;
564             reversed[i++] = byte(48 + remainder);
565         }
566         bytes memory inStrb = bytes(inStr);
567         bytes memory s = new bytes(inStrb.length + i);
568         uint j;
569         for (j = 0; j < inStrb.length; j++) {
570             s[j] = inStrb[j];
571         }
572         for (j = 0; j < i; j++) {
573             s[j + inStrb.length] = reversed[i - 1 - j];
574         }
575         str = string(s);
576     }
577 
578     /////////////////////////////////////////////////////////////////////////////
579     //
580     // ERC721EnumerableImpl
581     //
582     /////////////////////////////////////////////////////////////////////////////
583 
584     function exists(uint256 _tokenId) public view returns (bool) {
585         return _tokenId < tokenCount;
586     }
587  
588     function totalSupply() external view returns (uint256) {
589         return tokenCount;
590     }
591 
592     function tokenOfOwnerByIndex(address _tokenOwner, uint256 _index) external view returns (uint256 tokenId) {
593         require(_index < ownedTokens[_tokenOwner].length);
594         return ownedTokens[_tokenOwner][_index];
595     }
596 
597     function tokenByIndex(uint256 _index) external view returns (uint256 tokenId) {
598         require(_index < tokenCount);
599         return _index;
600     }
601 
602     function _mint(address _to, uint256 _tokenId) internal {
603         require (_to != address(0));
604         require (tokenIdToTokenOwner[_tokenId].tokenOwner == address(0));
605         tokenIdToTokenOwner[_tokenId].tokenOwner = _to;
606         ownedTokensIndex[_tokenId] = ownedTokens[_to].length;
607         ownedTokens[_to].push(_tokenId);
608         tokenCount++;
609 
610         emit Transfer(address(0), _to, _tokenId);
611     }
612 
613     /////////////////////////////////////////////////////////////////////////////
614     //
615     // ERC998 Bottom-Up implementation (extenstion of ERC-721)
616     //
617     /////////////////////////////////////////////////////////////////////////////
618 
619     function _removeChild(address _fromContract, uint256 _fromTokenId, uint256 _tokenId) internal {
620         uint256 lastChildTokenIndex = parentToChildTokenIds[_fromContract][_fromTokenId].length - 1;
621         uint256 lastChildTokenId = parentToChildTokenIds[_fromContract][_fromTokenId][lastChildTokenIndex];
622 
623         if (_tokenId != lastChildTokenId) {
624             uint256 currentChildTokenIndex = tokenIdToChildTokenIdsIndex[_tokenId];
625             parentToChildTokenIds[_fromContract][_fromTokenId][currentChildTokenIndex] = lastChildTokenId;
626             tokenIdToChildTokenIdsIndex[lastChildTokenId] = currentChildTokenIndex;
627         }
628         parentToChildTokenIds[_fromContract][_fromTokenId].length--;
629     }
630 
631     function _transferChild(address _from, address _toContract, uint256 _toTokenId, uint256 _tokenId) internal {
632         tokenIdToTokenOwner[_tokenId].parentTokenId = _toTokenId.add(1);
633         uint256 index = parentToChildTokenIds[_toContract][_toTokenId].length;
634         parentToChildTokenIds[_toContract][_toTokenId].push(_tokenId);
635         tokenIdToChildTokenIdsIndex[_tokenId] = index;
636 
637         _transferFrom(_from, _toContract, _tokenId);
638         
639         require(ERC721(_toContract).ownerOf(_toTokenId) != address(0));
640         emit TransferToParent(_toContract, _toTokenId, _tokenId);
641     }
642 
643     function _removeFromToken(address _fromContract, uint256 _fromTokenId, address _to, uint256 _tokenId) internal {
644         require(_fromContract != address(0));
645         require(_to != address(0));
646         require(tokenIdToTokenOwner[_tokenId].tokenOwner == _fromContract);
647         uint256 parentTokenId = tokenIdToTokenOwner[_tokenId].parentTokenId;
648         require(parentTokenId != 0);
649         require(parentTokenId - 1 == _fromTokenId);
650 
651         // authenticate
652         address rootOwner = address(rootOwnerOf(_tokenId));
653         address approvedAddress = rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId];
654         require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender] || approvedAddress == msg.sender);
655 
656         // clear approval
657         if (approvedAddress != address(0)) {
658             delete rootOwnerAndTokenIdToApprovedAddress[rootOwner][_tokenId];
659             emit Approval(rootOwner, address(0), _tokenId);
660         }
661 
662         tokenIdToTokenOwner[_tokenId].parentTokenId = 0;
663 
664         _removeChild(_fromContract, _fromTokenId, _tokenId);
665         emit TransferFromParent(_fromContract, _fromTokenId, _tokenId);
666     }
667 
668     function transferFromParent(address _fromContract, uint256 _fromTokenId, address _to, uint256 _tokenId, bytes _data) public {
669         _removeFromToken(_fromContract, _fromTokenId, _to, _tokenId);
670         delete tokenIdToChildTokenIdsIndex[_tokenId];
671         _transferFrom(_fromContract, _to, _tokenId);
672         require(_checkAndCallSafeTransfer(_fromContract, _to, _tokenId, _data));
673     }
674 
675     function transferToParent(address _from, address _toContract, uint256 _toTokenId, uint256 _tokenId, bytes _data) public {
676         _transferFromOwnerCheck(_from, _toContract, _tokenId);
677         _transferChild(_from, _toContract, _toTokenId, _tokenId);
678     }
679 
680     function transferAsChild(address _fromContract, uint256 _fromTokenId, address _toContract, uint256 _toTokenId, uint256 _tokenId, bytes _data) external {
681         _removeFromToken(_fromContract, _fromTokenId, _toContract, _tokenId);
682         _transferChild(_fromContract, _toContract, _toTokenId, _tokenId);
683     }
684 
685     /////////////////////////////////////////////////////////////////////////////
686     //
687     // ERC998 Bottom-Up Enumerable Implementation
688     //
689     /////////////////////////////////////////////////////////////////////////////
690 
691     function totalChildTokens(address _parentContract, uint256 _parentTokenId) public view returns (uint256) {
692         return parentToChildTokenIds[_parentContract][_parentTokenId].length;
693     }
694 
695     function childTokenByIndex(address _parentContract, uint256 _parentTokenId, uint256 _index) public view returns (uint256) {
696         require(parentToChildTokenIds[_parentContract][_parentTokenId].length > _index);
697         return parentToChildTokenIds[_parentContract][_parentTokenId][_index];
698     }
699 }
700 
701 
702 contract CryptoRomeControl {
703 
704     // Emited when contract is upgraded or ownership changed
705     event ContractUpgrade(address newContract);
706     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
707 
708     // Has control of (most) contract elements
709     address public ownerPrimary;
710     address public ownerSecondary;
711 
712     // Address of owner wallet to transfer funds
713     address public ownerWallet;
714     address public cryptoRomeWallet;
715 
716     // Contracts that need access for gameplay
717     // (state = 1 means access is active, state = 0 means disabled)
718     mapping(address => uint8) public otherOperators;
719 
720     // Improvement contract is the only authorized address that can modify 
721     // existing land data (ex. when player purchases a land improvement). No one else can
722     // modify land - even owners of this contract
723     address public improvementContract;
724 
725     // Tracks if contract is paused or not. If paused, most actions are blocked
726     bool public paused = false;
727 
728     constructor() public {
729         ownerPrimary = msg.sender;
730         ownerSecondary = msg.sender;
731         ownerWallet = msg.sender;
732         cryptoRomeWallet = msg.sender;
733     }
734 
735     modifier onlyOwner() {
736         require (msg.sender == ownerPrimary || msg.sender == ownerSecondary);
737         _;
738     }
739 
740     modifier anyOperator() {
741         require (
742             msg.sender == ownerPrimary ||
743             msg.sender == ownerSecondary ||
744             otherOperators[msg.sender] == 1
745         );
746         _;
747     }
748 
749     modifier onlyOtherOperators() {
750         require (otherOperators[msg.sender] == 1);
751         _;
752     }
753 
754     modifier onlyImprovementContract() {
755         require (msg.sender == improvementContract);
756         _;
757     }
758 
759     function setPrimaryOwner(address _newOwner) external onlyOwner {
760         require (_newOwner != address(0));
761         emit OwnershipTransferred(ownerPrimary, _newOwner);
762         ownerPrimary = _newOwner;
763     }
764 
765     function setSecondaryOwner(address _newOwner) external onlyOwner {
766         require (_newOwner != address(0));
767         emit OwnershipTransferred(ownerSecondary, _newOwner);
768         ownerSecondary = _newOwner;
769     }
770 
771     function setOtherOperator(address _newOperator, uint8 _state) external onlyOwner {
772         require (_newOperator != address(0));
773         otherOperators[_newOperator] = _state;
774     }
775 
776     function setImprovementContract(address _improvementContract) external onlyOwner {
777         require (_improvementContract != address(0));
778         emit OwnershipTransferred(improvementContract, _improvementContract);
779         improvementContract = _improvementContract;
780     }
781 
782     function transferOwnerWalletOwnership(address newWalletAddress) onlyOwner external {
783         require(newWalletAddress != address(0));
784         ownerWallet = newWalletAddress;
785     }
786 
787     function transferCryptoRomeWalletOwnership(address newWalletAddress) onlyOwner external {
788         require(newWalletAddress != address(0));
789         cryptoRomeWallet = newWalletAddress;
790     }
791 
792     modifier whenNotPaused() {
793         require(!paused);
794         _;
795     }
796 
797     modifier whenPaused {
798         require(paused);
799         _;
800     }
801 
802     function pause() public onlyOwner whenNotPaused {
803         paused = true;
804     }
805 
806     function unpause() public onlyOwner whenPaused {
807         paused = false;
808     }
809 
810     function withdrawBalance() public onlyOwner {
811         ownerWallet.transfer(address(this).balance);
812     }
813 }
814 
815 contract CryptoRomeLandComposableNFT is ERC998ERC721BottomUpToken, CryptoRomeControl {
816     using SafeMath for uint256;
817 
818     // Set in case the contract needs to be updated
819     address public newContractAddress;
820 
821     struct LandInfo {
822         uint256 landType;  // 0-4  unit, plot, village, town, city (unit unused)
823         uint256 landImprovements; 
824         uint256 askingPrice;
825     }
826 
827     mapping(uint256 => LandInfo) internal tokenIdToLand;
828 
829     // for sale state of all tokens. tokens map to bits. 0 = not for sale; 1 = for sale
830     // 256 token states per index of this array
831     uint256[] internal allLandForSaleState;
832 
833     // landType => land count
834     mapping(uint256 => uint256) internal landTypeToCount;
835 
836     // total number of villages in existence is 50000 (no more can be created)
837     uint256 constant internal MAX_VILLAGES = 50000;
838 
839     constructor () public {
840         paused = true;
841         name_ = "CryptoRome-Land-NFT";
842         symbol_ = "CRLAND";
843     }
844 
845     function isCryptoRomeLandComposableNFT() external pure returns (bool) {
846         return true;
847     }
848 
849     function getLandTypeCount(uint256 _landType) public view returns (uint256) {
850         return landTypeToCount[_landType];
851     }
852 
853     function setTokenURI(string _tokenURI) external anyOperator {
854         tokenURIBase = _tokenURI;
855     }
856 
857     function setNewAddress(address _v2Address) external onlyOwner {
858         require (_v2Address != address(0));
859         newContractAddress = _v2Address;
860         emit ContractUpgrade(_v2Address);
861     }
862 
863     /////////////////////////////////////////////////////////////////////////////
864     // Get Land
865     //   Token Owner: Address of the token owner
866     //   Parent Token Id: If parentTokenId is > 0, then this land
867     //      token is owned by another token (i.e. it is attached bottom-up).
868     //      parentTokenId is the id of the owner token, and tokenOwner
869     //      address (the first parameter) is the ERC721 contract address of the  
870     //      parent token. If parentTokenId == 0, then this land token is owned
871     //      by a user address.
872     //   Land Types: village=1, town=2, city=3
873     //   Land Improvements: improvements and upgrades
874     //      to each land NFT are coded into a single uint256 value
875     //   Asking Price (in wei): 0 if land is not for sale
876     /////////////////////////////////////////////////////////////////////////////
877     function getLand(uint256 _tokenId) external view
878         returns (
879             address tokenOwner,
880             uint256 parentTokenId,
881             uint256 landType,
882             uint256 landImprovements,
883             uint256 askingPrice
884         ) {
885         TokenOwner storage owner = tokenIdToTokenOwner[_tokenId];
886         LandInfo storage land = tokenIdToLand[_tokenId];
887 
888         parentTokenId = owner.parentTokenId;
889         if (parentTokenId > 0) {
890             parentTokenId--;
891         }
892         tokenOwner = owner.tokenOwner;
893         parentTokenId = owner.parentTokenId;
894         landType = land.landType;
895         landImprovements = land.landImprovements;
896         askingPrice = land.askingPrice;
897     }
898 
899     /////////////////////////////////////////////////////////////////////////////
900     // Create Land NFT
901     //   Land Types: village=1, town=2, city=3
902     //   Land Improvements: improvements and upgrades
903     //      to each land NFT are the coded into a uint256 value
904     /////////////////////////////////////////////////////////////////////////////
905     function _createLand (address _tokenOwner, uint256 _landType, uint256 _landImprovements) internal returns (uint256 tokenId) {
906         require(_tokenOwner != address(0));
907         require(landTypeToCount[1] < MAX_VILLAGES);
908         tokenId = tokenCount;
909 
910         LandInfo memory land = LandInfo({
911             landType: _landType,  // 1-3  village, town, city
912             landImprovements: _landImprovements,
913             askingPrice: 0
914         });
915         
916         // map new tokenId to the newly created land      
917         tokenIdToLand[tokenId] = land;
918         landTypeToCount[_landType]++;
919 
920         if (tokenId % 256 == 0) {
921             // create new land sale state entry in storage
922             allLandForSaleState.push(0);
923         }
924 
925         _mint(_tokenOwner, tokenId);
926 
927         return tokenId;
928     }
929     
930     function createLand (address _tokenOwner, uint256 _landType, uint256 _landImprovements) external anyOperator whenNotPaused returns (uint256 tokenId) {
931         return _createLand (_tokenOwner, _landType, _landImprovements);
932     }
933 
934     ////////////////////////////////////////////////////////////////////////////////
935     // Land Improvement Data
936     //   This uint256 land "dna" value describes all improvements and upgrades 
937     //   to a piece of land. After land token distribution, only the Improvement
938     //   Contract can ever update or modify the land improvement data of a piece
939     //   of land (contract owner cannot modify land).
940     //
941     // For villages, improvementData is a uint256 value containing village
942     // improvement data with the following slot bit mapping
943     //     0-31:     slot 1 improvement info
944     //     32-63:    slot 2 improvement info
945     //     64-95:    slot 3 improvement info
946     //     96-127:   slot 4 improvement info
947     //     128-159:  slot 5 improvement info
948     //     160-191:  slot 6 improvement info
949     //     192-255:  reserved for additional land information
950     //
951     // Each 32 bit slot in the above structure has the following bit mapping
952     //     0-7:      improvement type (index to global list of possible types)
953     //     8-14:     upgrade type 1 - level 0-99  (0 for no upgrade present)
954     //     15-21:    upgrade type 2 - level 0-99  (0 for no upgrade present)
955     //     22:       upgrade type 3 - 1 if upgrade present, 0 if not (no leveling)
956     ////////////////////////////////////////////////////////////////////////////////
957     function getLandImprovementData(uint256 _tokenId) external view returns (uint256) {
958         return tokenIdToLand[_tokenId].landImprovements;
959     }
960 
961     function updateLandImprovementData(uint256 _tokenId, uint256 _newLandImprovementData) external whenNotPaused onlyImprovementContract {
962         require(_tokenId <= tokenCount);
963         tokenIdToLand[_tokenId].landImprovements = _newLandImprovementData;
964     }
965 
966     /////////////////////////////////////////////////////////////////////////////
967     // Land Compose/Decompose functions
968     //   Towns are composed of 3 Villages
969     //   Cities are composed of 3 Towns
970     /////////////////////////////////////////////////////////////////////////////
971 
972     // Attach three child land tokens onto a parent land token (ex. 3 villages onto a town).
973     // This function is called when the parent does not exist yet, so create parent land token first
974     // Ownership of the child lands transfers from the existing owner (sender) to the parent land token
975     function composeNewLand(uint256 _landType, uint256 _childLand1, uint256 _childLand2, uint256 _childLand3) external whenNotPaused returns(uint256) {
976         uint256 parentTokenId = _createLand(msg.sender, _landType, 0);
977         return composeLand(parentTokenId, _childLand1, _childLand2, _childLand3);
978     }
979 
980     // Attach three child land tokens onto a parent land token (ex. 3 villages into a town).
981     // All three children and an existing parent need to be passed into this function.
982     // Ownership of the child lands transfers from the existing owner (sender) to the parent land token
983     function composeLand(uint256 _parentLandId, uint256 _childLand1, uint256 _childLand2, uint256 _childLand3) public whenNotPaused returns(uint256) {
984         require (tokenIdToLand[_parentLandId].landType == 2 || tokenIdToLand[_parentLandId].landType == 3);
985         uint256 validChildLandType = tokenIdToLand[_parentLandId].landType.sub(1);
986         require(tokenIdToLand[_childLand1].landType == validChildLandType &&
987                 tokenIdToLand[_childLand2].landType == validChildLandType &&
988                 tokenIdToLand[_childLand3].landType == validChildLandType);
989 
990         // transfer ownership of child land tokens to parent land token
991         transferToParent(tokenIdToTokenOwner[_childLand1].tokenOwner, address(this), _parentLandId, _childLand1, "");
992         transferToParent(tokenIdToTokenOwner[_childLand2].tokenOwner, address(this), _parentLandId, _childLand2, "");
993         transferToParent(tokenIdToTokenOwner[_childLand3].tokenOwner, address(this), _parentLandId, _childLand3, "");
994 
995         // if this contract is owner of the parent land token, transfer ownership to msg.sender
996         if (tokenIdToTokenOwner[_parentLandId].tokenOwner == address(this)) {
997             _transferFrom(address(this), msg.sender, _parentLandId);
998         }
999 
1000         return _parentLandId;
1001     }
1002 
1003     // Decompose a parent land back to it's attached child land token components (ex. a town into 3 villages).
1004     // The existing owner of the parent land becomes the owner of the three child tokens
1005     // This contract takes over ownership of the parent land token (for later reuse)
1006     // Loop to remove and transfer all land tokens in case other land tokens are attached.
1007     function decomposeLand(uint256 _tokenId) external whenNotPaused {
1008         uint256 numChildren = totalChildTokens(address(this), _tokenId);
1009         require (numChildren > 0);
1010 
1011         // it is lower gas cost to remove children starting from the end of the array
1012         for (uint256 numChild = numChildren; numChild > 0; numChild--) {
1013             uint256 childTokenId = childTokenByIndex(address(this), _tokenId, numChild-1);
1014 
1015             // transfer ownership of underlying lands to msg.sender
1016             transferFromParent(address(this), _tokenId, msg.sender, childTokenId, "");
1017         }
1018 
1019         // transfer ownership of parent land back to this contract owner for reuse
1020         _transferFrom(msg.sender, address(this), _tokenId);
1021     }
1022 
1023     /////////////////////////////////////////////////////////////////////////////
1024     // Sale functions
1025     /////////////////////////////////////////////////////////////////////////////
1026     function _updateSaleData(uint256 _tokenId, uint256 _askingPrice) internal {
1027         tokenIdToLand[_tokenId].askingPrice = _askingPrice;
1028         if (_askingPrice > 0) {
1029             // Item is for sale - set bit
1030             allLandForSaleState[_tokenId.div(256)] = allLandForSaleState[_tokenId.div(256)] | (1 << (_tokenId % 256));
1031         } else {
1032             // Item is no longer for sale - clear bit
1033             allLandForSaleState[_tokenId.div(256)] = allLandForSaleState[_tokenId.div(256)] & ~(1 << (_tokenId % 256));
1034         }
1035     }
1036 
1037     function sellLand(uint256 _tokenId, uint256 _askingPrice) public whenNotPaused {
1038         require(tokenIdToTokenOwner[_tokenId].tokenOwner == msg.sender);
1039         require(tokenIdToTokenOwner[_tokenId].parentTokenId == 0);
1040         require(_askingPrice > 0);
1041         // Put the land token on the market
1042         _updateSaleData(_tokenId, _askingPrice);
1043     }
1044 
1045     function cancelLandSale(uint256 _tokenId) public whenNotPaused {
1046         require(tokenIdToTokenOwner[_tokenId].tokenOwner == msg.sender);
1047         // Take the land token off the market
1048         _updateSaleData(_tokenId, 0);
1049     }
1050 
1051     function purchaseLand(uint256 _tokenId) public whenNotPaused payable {
1052         uint256 price = tokenIdToLand[_tokenId].askingPrice;
1053         require(price <= msg.value);
1054 
1055         // Take the land token off the market
1056         _updateSaleData(_tokenId, 0);
1057 
1058         // Marketplace fee
1059         uint256 marketFee = computeFee(price);
1060         uint256 sellerProceeds = msg.value.sub(marketFee);
1061         cryptoRomeWallet.transfer(marketFee);
1062 
1063         // Return excess payment to sender
1064         uint256 excessPayment = msg.value.sub(price);
1065         msg.sender.transfer(excessPayment);
1066 
1067         // Transfer proceeds to seller. Sale was removed above before this transfer()
1068         // to guard against reentrancy attacks
1069         tokenIdToTokenOwner[_tokenId].tokenOwner.transfer(sellerProceeds);
1070         // Transfer token to buyer
1071         _transferFrom(tokenIdToTokenOwner[_tokenId].tokenOwner, msg.sender, _tokenId);
1072     }
1073 
1074     function getAllForSaleStatus() external view returns(uint256[]) {
1075         // return uint256[] bitmap values up to max tokenId (for ease of querying from UI for marketplace)
1076         //   index 0 of the uint256 holds first 256 land token status; index 1 is next 256 land tokens, etc
1077         //   value of 1 = For Sale; 0 = Not for Sale
1078         return allLandForSaleState;
1079     }
1080 
1081     function computeFee(uint256 amount) internal pure returns(uint256) {
1082         // 3% marketplace fee, most of which will be distributed to the Caesar and Senators of CryptoRome
1083         return amount.mul(3).div(100);
1084     }
1085 }
1086 
1087 contract CryptoRomeLandDistribution is CryptoRomeControl {
1088     using SafeMath for uint256;
1089 
1090     // Set in case the contract needs to be updated
1091     address public newContractAddress;
1092 
1093     CryptoRomeLandComposableNFT public cryptoRomeLandNFTContract;
1094     ImprovementGeneration public improvementGenContract;
1095     uint256 public villageInventoryPrice;
1096     uint256 public numImprovementsPerVillage;
1097 
1098     uint256 constant public LOWEST_VILLAGE_INVENTORY_PRICE = 100000000000000000; // 0.1 ETH
1099 
1100     constructor (address _cryptoRomeLandNFTContractAddress, address _improvementGenContractAddress) public {
1101         require (_cryptoRomeLandNFTContractAddress != address(0));
1102         require (_improvementGenContractAddress != address(0));
1103 
1104         paused = true;
1105 
1106         cryptoRomeLandNFTContract = CryptoRomeLandComposableNFT(_cryptoRomeLandNFTContractAddress);
1107         improvementGenContract = ImprovementGeneration(_improvementGenContractAddress);
1108 
1109         villageInventoryPrice = LOWEST_VILLAGE_INVENTORY_PRICE;
1110         numImprovementsPerVillage = 3;
1111     }
1112 
1113     function setNewAddress(address _v2Address) external onlyOwner {
1114         require (_v2Address != address(0));
1115         newContractAddress = _v2Address;
1116         emit ContractUpgrade(_v2Address);
1117     }
1118 
1119     function setCryptoRomeLandNFTContract(address _cryptoRomeLandNFTContract) external onlyOwner {
1120         require (_cryptoRomeLandNFTContract != address(0));
1121         cryptoRomeLandNFTContract = CryptoRomeLandComposableNFT(_cryptoRomeLandNFTContract);
1122     }
1123 
1124     function setImprovementGenContract(address _improvementGenContractAddress) external onlyOwner {
1125         require (_improvementGenContractAddress != address(0));
1126         improvementGenContract = ImprovementGeneration(_improvementGenContractAddress);
1127     }
1128 
1129     function setVillageInventoryPrice(uint256 _price) external onlyOwner {
1130         require(_price >= LOWEST_VILLAGE_INVENTORY_PRICE);
1131         villageInventoryPrice = _price;
1132     }
1133 
1134     function setNumImprovementsPerVillage(uint256 _numImprovements) external onlyOwner {
1135         require(_numImprovements <= 6);
1136         numImprovementsPerVillage = _numImprovements;
1137     }
1138 
1139     function purchaseFromVillageInventory(uint256 _num) external whenNotPaused payable {
1140         uint256 price = villageInventoryPrice.mul(_num);
1141         require (msg.value >= price);
1142         require (_num > 0 && _num <= 50);
1143 
1144         // Marketplace fee
1145         uint256 marketFee = computeFee(price);
1146         cryptoRomeWallet.transfer(marketFee);
1147 
1148         // Return excess payment to sender
1149         uint256 excessPayment = msg.value.sub(price);
1150         msg.sender.transfer(excessPayment);
1151 
1152         for (uint256 i = 0; i < _num; i++) {
1153             // create a new village w/ random improvements and transfer the NFT to caller
1154             _createVillageWithImprovementsFromInv(msg.sender);
1155         }
1156     }
1157 
1158     function computeFee(uint256 amount) internal pure returns(uint256) {
1159         // 3% marketplace fee, most of which will be distributed to the Caesar and Senators of CryptoRome
1160         return amount.mul(3).div(100);
1161     }
1162 
1163     function batchIssueLand(address _toAddress, uint256[] _landType) external onlyOwner {
1164         require (_toAddress != address(0));
1165         require (_landType.length > 0);
1166 
1167         for (uint256 i = 0; i < _landType.length; i++) {
1168             issueLand(_toAddress, _landType[i]);
1169         }
1170     }
1171 
1172     function batchIssueVillages(address _toAddress, uint256 _num) external onlyOwner {
1173         require (_toAddress != address(0));
1174         require (_num > 0);
1175 
1176         for (uint256 i = 0; i < _num; i++) {
1177             _createVillageWithImprovements(_toAddress);
1178         }
1179     }
1180 
1181     function issueLand(address _toAddress, uint256 _landType) public onlyOwner returns (uint256) {
1182         require (_toAddress != address(0));
1183 
1184         return _createLandWithImprovements(_toAddress, _landType);
1185     }
1186 
1187     function batchCreateLand(uint256[] _landType) external onlyOwner {
1188         require (_landType.length > 0);
1189 
1190         for (uint256 i = 0; i < _landType.length; i++) {
1191             // land created is owned by this contract for staging purposes
1192             // (must later use transferTo or batchTransferTo)
1193             _createLandWithImprovements(address(this), _landType[i]);
1194         }
1195     }
1196 
1197     function batchCreateVillages(uint256 _num) external onlyOwner {
1198         require (_num > 0);
1199 
1200         for (uint256 i = 0; i < _num; i++) {
1201             // land created is owned by this contract for staging purposes
1202             // (must later use transferTo or batchTransferTo)
1203             _createVillageWithImprovements(address(this));
1204         }
1205     }
1206 
1207     function createLand(uint256 _landType) external onlyOwner {
1208         // land created is owned by this contract for staging purposes
1209         // (must later use transferTo or batchTransferTo)
1210         _createLandWithImprovements(address(this), _landType);
1211     }
1212 
1213     function batchTransferTo(uint256[] _tokenIds, address _to) external onlyOwner {
1214         require (_tokenIds.length > 0);
1215         require (_to != address(0));
1216 
1217         for (uint256 i = 0; i < _tokenIds.length; ++i) {
1218             // transfers staged land out of this contract to the owners
1219             cryptoRomeLandNFTContract.transferFrom(address(this), _to, _tokenIds[i]);
1220         }
1221     }
1222 
1223     function transferTo(uint256 _tokenId, address _to) external onlyOwner {
1224         require (_to != address(0));
1225 
1226         // transfers staged land out of this contract to the owners
1227         cryptoRomeLandNFTContract.transferFrom(address(this), _to, _tokenId);
1228     }
1229 
1230     function issueVillageWithImprovementsForPromo(address _toAddress, uint256 numImprovements) external onlyOwner returns (uint256) {
1231         uint256 landImprovements = improvementGenContract.genInitialResourcesForVillage(numImprovements, false);
1232         return cryptoRomeLandNFTContract.createLand(_toAddress, 1, landImprovements);
1233     }
1234 
1235     function _createVillageWithImprovementsFromInv(address _toAddress) internal returns (uint256) {
1236         uint256 landImprovements = improvementGenContract.genInitialResourcesForVillage(numImprovementsPerVillage, true);
1237         return cryptoRomeLandNFTContract.createLand(_toAddress, 1, landImprovements);
1238     }
1239 
1240     function _createVillageWithImprovements(address _toAddress) internal returns (uint256) {
1241         uint256 landImprovements = improvementGenContract.genInitialResourcesForVillage(3, false);
1242         return cryptoRomeLandNFTContract.createLand(_toAddress, 1, landImprovements);
1243     }
1244 
1245     function _createLandWithImprovements(address _toAddress, uint256 _landType) internal returns (uint256) {
1246         require (_landType > 0 && _landType < 4);
1247 
1248         if (_landType == 1) {
1249             return _createVillageWithImprovements(_toAddress);
1250         } else if (_landType == 2) {
1251             uint256 village1TokenId = _createLandWithImprovements(address(this), 1);
1252             uint256 village2TokenId = _createLandWithImprovements(address(this), 1);
1253             uint256 village3TokenId = _createLandWithImprovements(address(this), 1);
1254             uint256 townTokenId = cryptoRomeLandNFTContract.createLand(_toAddress, 2, 0);
1255             cryptoRomeLandNFTContract.composeLand(townTokenId, village1TokenId, village2TokenId, village3TokenId);
1256             return townTokenId;
1257         } else if (_landType == 3) {
1258             uint256 town1TokenId = _createLandWithImprovements(address(this), 2);
1259             uint256 town2TokenId = _createLandWithImprovements(address(this), 2);
1260             uint256 town3TokenId = _createLandWithImprovements(address(this), 2);
1261             uint256 cityTokenId = cryptoRomeLandNFTContract.createLand(_toAddress, 3, 0);
1262             cryptoRomeLandNFTContract.composeLand(cityTokenId, town1TokenId, town2TokenId, town3TokenId);
1263             return cityTokenId;
1264         }
1265     }
1266 }
1267 
1268 interface RandomNumGeneration {
1269     function getRandomNumber(uint256 seed) external returns (uint256);
1270 }
1271 
1272 contract ImprovementGeneration is CryptoRomeControl {
1273     using SafeMath for uint256;
1274     
1275     // Set in case the contract needs to be updated
1276     address public newContractAddress;
1277 
1278     RandomNumGeneration public randomNumberSource; 
1279     uint256 public rarityValueMax;
1280     uint256 public latestPseudoRandomNumber;
1281     uint8 public numResourceImprovements;
1282 
1283     mapping(uint8 => uint256) private improvementIndexToRarityValue;
1284 
1285     constructor () public {
1286         // Starting Improvements
1287         // improvement => rarity value (lower number = higher rarity) 
1288         improvementIndexToRarityValue[1] = 256;  // Wheat
1289         improvementIndexToRarityValue[2] = 256;  // Wood
1290         improvementIndexToRarityValue[3] = 128;  // Grapes
1291         improvementIndexToRarityValue[4] = 128;  // Stone
1292         improvementIndexToRarityValue[5] = 64;   // Clay
1293         improvementIndexToRarityValue[6] = 64;   // Fish
1294         improvementIndexToRarityValue[7] = 32;   // Horse
1295         improvementIndexToRarityValue[8] = 16;   // Iron
1296         improvementIndexToRarityValue[9] = 8;    // Marble
1297         // etc --> More can be added in the future
1298 
1299         // max resource improvement types is 63
1300         numResourceImprovements = 9;
1301         rarityValueMax = 952;
1302     }
1303 
1304     function setNewAddress(address _v2Address) external onlyOwner {
1305         require (_v2Address != address(0));
1306         newContractAddress = _v2Address;
1307         emit ContractUpgrade(_v2Address);
1308     }
1309 
1310     function setRandomNumGenerationContract(address _randomNumberGenAddress) external onlyOwner {
1311         require (_randomNumberGenAddress != address(0));
1312         randomNumberSource = RandomNumGeneration(_randomNumberGenAddress);
1313     }
1314 
1315     function genInitialResourcesForVillage(uint256 numImprovements, bool useRandomInput) external anyOperator returns(uint256) {
1316         require(numImprovements <= 6);
1317         uint256 landImprovements;
1318 
1319         // each improvement takes up one village slot (max 6 slots)
1320         for (uint256 i = 0; i < numImprovements; i++) {
1321             uint8 newImprovement = generateImprovement(useRandomInput);
1322             // each slot is a 32 bit section in the 256 bit landImprovement value
1323             landImprovements |= uint256(newImprovement) << (32*i);
1324         }
1325         
1326         return landImprovements;
1327     }
1328 
1329     function generateImprovement(bool useRandomSource) public anyOperator returns (uint8 newImprovement) {     
1330         // seed does not need to be anything super fancy for initial improvement generation for villages...
1331         // players will not be performing that operation, so this should be random enough
1332         uint256 seed = latestPseudoRandomNumber.add(now);
1333         if (useRandomSource) {
1334             // for cases where players are generating land (i.e. after initial distribution of villages), there
1335             // will need to be a better source of randomness
1336             seed = randomNumberSource.getRandomNumber(seed);
1337         }
1338         
1339         latestPseudoRandomNumber = addmod(uint256(blockhash(block.number-1)), seed, rarityValueMax);
1340         
1341         // do lookup for the improvement
1342         newImprovement = lookupImprovementTypeByRarity(latestPseudoRandomNumber);
1343     }
1344 
1345     function lookupImprovementTypeByRarity(uint256 rarityNum) public view returns (uint8 improvementType) {
1346         uint256 rarityIndexValue;
1347         for (uint8 i = 1; i <= numResourceImprovements; i++) {
1348             rarityIndexValue += improvementIndexToRarityValue[i];
1349             if (rarityNum < rarityIndexValue) {
1350                 return i;
1351             }
1352         }
1353         return 0;
1354     }
1355 
1356     function addNewResourceImprovementType(uint256 rarityValue) external onlyOwner {
1357         require(rarityValue > 0);
1358         require(numResourceImprovements < 63);
1359 
1360         numResourceImprovements++;
1361         rarityValueMax += rarityValue;
1362         improvementIndexToRarityValue[numResourceImprovements] = rarityValue;
1363     }
1364 
1365     function updateImprovementRarityValue(uint256 rarityValue, uint8 improvementIndex) external onlyOwner {
1366         require(rarityValue > 0);
1367         require(improvementIndex <= numResourceImprovements);
1368 
1369         rarityValueMax -= improvementIndexToRarityValue[improvementIndex];
1370         rarityValueMax += rarityValue;
1371         improvementIndexToRarityValue[improvementIndex] = rarityValue;
1372     }
1373 }