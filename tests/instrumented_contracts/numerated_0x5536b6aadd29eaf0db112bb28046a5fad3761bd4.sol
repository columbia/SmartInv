1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC721 Non-Fungible Token Standard Basic Interface
6  * @dev Based on openzepplin open source ERC721 examples.
7  * See (https://github.com/OpenZeppelin/openzeppelin-solidity)
8  */
9 contract ERC721 {
10 
11 	/**
12 	 * @dev 0x01ffc9a7 === 
13 	 *   bytes4(keccak256('supportsInterface(bytes4)'))
14 	 */
15 	bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
16 
17 	/**
18 	 * @dev 0x80ac58cd ===
19 	 *   bytes4(keccak256('balanceOf(address)')) ^
20 	 *   bytes4(keccak256('ownerOf(uint256)')) ^
21 	 *   bytes4(keccak256('approve(address,uint256)')) ^
22 	 *   bytes4(keccak256('getApproved(uint256)')) ^
23 	 *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
24 	 *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
25 	 *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
26 	 *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
27 	 *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
28 	 */
29 	bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
30 
31 	/**
32 	 * @dev 0x780e9d63 ===
33 	 *   bytes4(keccak256('totalSupply()')) ^
34 	 *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
35 	 *   bytes4(keccak256('tokenByIndex(uint256)'))
36 	 */
37 	bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
38 
39 	/**
40 	 * @dev 0x5b5e139f ===
41 	 *   bytes4(keccak256('name()')) ^
42 	 *   bytes4(keccak256('symbol()')) ^
43 	 *   bytes4(keccak256('tokenURI(uint256)'))
44 	 */
45 	bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
46 
47 	/** @dev A mapping of interface id to whether or not it is supported */
48 	mapping(bytes4 => bool) internal supportedInterfaces;
49 
50 	/** @dev Token events */
51 	event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
52 	event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
53 	event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
54 
55 	/** @dev Registers ERC-165, ERC-721, ERC-721 Enumerable and ERC-721 Metadata as supported interfaces */
56 	constructor() public
57 	{
58 		registerInterface(InterfaceId_ERC165);
59 		registerInterface(InterfaceId_ERC721);
60 		registerInterface(InterfaceId_ERC721Enumerable);
61 		registerInterface(InterfaceId_ERC721Metadata);
62 	}
63 
64 	/** @dev Internal function for registering an interface */
65 	function registerInterface(bytes4 _interfaceId) internal
66 	{
67 		require(_interfaceId != 0xffffffff);
68 		supportedInterfaces[_interfaceId] = true;
69 	}
70 
71 	/** @dev ERC-165 interface implementation */
72 	function supportsInterface(bytes4 _interfaceId) external view returns(bool)
73 	{
74 		return supportedInterfaces[_interfaceId];
75 	}
76 
77 	/** @dev ERC-721 interface */
78 	function balanceOf(address _owner) public view returns(uint256 _balance);
79 	function ownerOf(uint256 _tokenId) public view returns(address _owner);
80 	function approve(address _to, uint256 _tokenId) public;
81 	function getApproved(uint256 _tokenId) public view returns(address _operator);
82 	function setApprovalForAll(address _operator, bool _approved) public;
83 	function isApprovedForAll(address _owner, address _operator) public view returns(bool);
84 	function transferFrom(address _from, address _to, uint256 _tokenId) public;
85 	function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
86 	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
87 
88 	/** @dev ERC-721 Enumerable interface */
89 	function totalSupply() public view returns(uint256 _total);
90 	function tokenByIndex(uint256 _index) public view returns(uint256 _tokenId);
91 	function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns(uint256 _tokenId);
92 
93 	/** @dev ERC-721 Metadata interface */
94 	function name() public view returns(string _name);
95 	function symbol() public view returns(string _symbol);
96 	function tokenURI(uint256 _tokenId) public view returns(string);
97 }
98 
99 
100 /**
101  * @title PixelCons Core
102  * @notice The purpose of this contract is to provide a shared ecosystem of minimal pixel art tokens for everyone to use. All users are treated 
103  * equally with the exception of an admin user who only controls the ERC721 metadata function which points to the app website. No fees are 
104  * required to interact with this contract beyond base gas fees. Here are a few notes on the basic workings of the contract:
105  *    PixelCons [The core ERC721 token of this contract]
106  *        -Each PixelCon is unique with an ID that encodes all its pixel data
107  *        -PixelCons can be identified by both TokenIDs and TokenIndexes (index requires fewer bits to store)
108  *        -A PixelCon can never be destroyed
109  *        -Total number of PixelCons is limited to 18,446,744,073,709,551,616 (2^64)
110  *        -A single account can only hold 4,294,967,296 PixelCons (2^32)
111  *    Collections [Grouping mechanism for associating PixelCons together]
112  *        -Collections are identified by an index (zero is invalid)
113  *        -Collections can only be created by a user who both created and currently owns all its PixelCons
114  *        -Total number of collections is limited to 18,446,744,073,709,551,616 (2^64)
115  * For more information about PixelCons, please visit (https://pixelcons.io)
116  * @dev This contract follows the ERC721 token standard with additional functions for creating, grouping, etc.
117  * See (https://github.com/OpenZeppelin/openzeppelin-solidity)
118  * @author PixelCons
119  */
120 contract PixelCons is ERC721 {
121 
122 	using AddressUtils for address;
123 
124 	/** @dev Equal to 'bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))' */
125 	bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
126 
127 
128 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
129 	///////////////////////////////////////////////////////////// Structs ///////////////////////////////////////////////////////////////////////
130 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
131 
132 	/** @dev The main PixelCon struct */
133 	struct PixelCon {
134 		uint256 tokenId;
135 		//// ^256bits ////
136 		address creator;
137 		uint64 collectionIndex;
138 		uint32 dateCreated;
139 	}
140 
141 	/** @dev A struct linking a token owner with its token index */
142 	struct TokenLookup {
143 		address owner;
144 		uint64 tokenIndex;
145 		uint32 ownedIndex;
146 	}
147 
148 
149 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
150 	///////////////////////////////////////////////////////////// Storage ///////////////////////////////////////////////////////////////////////
151 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
152 
153 	/**  @dev The address thats allowed to withdraw volunteered funds sent to this contract */
154 	address internal admin;
155 
156 	/** @dev The URI template for retrieving token metadata */
157 	string internal tokenURITemplate;
158 
159 	////////////////// PixelCon Tokens //////////////////
160 
161 	/** @dev Mapping from token ID to owner/index */
162 	mapping(uint256 => TokenLookup) internal tokenLookup;
163 
164 	/**  @dev Mapping from owner to token indexes */
165 	mapping(address => uint64[]) internal ownedTokens;
166 
167 	/**  @dev Mapping from creator to token indexes */
168 	mapping(address => uint64[]) internal createdTokens;
169 
170 	/** @dev Mapping from token ID to approved address */
171 	mapping(uint256 => address) internal tokenApprovals;
172 
173 	/** @dev Mapping from owner to operator approvals */
174 	mapping(address => mapping(address => bool)) internal operatorApprovals;
175 
176 	/** @dev An array containing all PixelCons in existence */
177 	PixelCon[] internal pixelcons;
178 
179 	/** @dev An array that mirrors 'pixelcons' in terms of indexing, but stores only name data */
180 	bytes8[] internal pixelconNames;
181 
182 	////////////////// Collections //////////////////
183 
184 	/** @dev Mapping from collection index to token indexes */
185 	mapping(uint64 => uint64[]) internal collectionTokens;
186 
187 	/** @dev An array that mirrors 'collectionTokens' in terms of indexing, but stores only name data */
188 	bytes8[] internal collectionNames;
189 
190 
191 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
192 	///////////////////////////////////////////////////////////// Events ////////////////////////////////////////////////////////////////////////
193 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
194 
195 	/** @dev PixelCon token events */
196 	event Create(uint256 indexed _tokenId, address indexed _creator, uint64 _tokenIndex, address _to);
197 	event Rename(uint256 indexed _tokenId, bytes8 _newName);
198 
199 	/**  @dev PixelCon collection events */
200 	event CreateCollection(address indexed _creator, uint64 indexed _collectionIndex);
201 	event RenameCollection(uint64 indexed _collectionIndex, bytes8 _newName);
202 	event ClearCollection(uint64 indexed _collectionIndex);
203 
204 
205 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
206 	/////////////////////////////////////////////////////////// Modifiers ///////////////////////////////////////////////////////////////////////
207 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
208 
209 	/**  @dev Small validators for quick validation of function parameters */
210 	modifier validIndex(uint64 _index) {
211 		require(_index != uint64(0), "Invalid index");
212 		_;
213 	}
214 	modifier validId(uint256 _id) {
215 		require(_id != uint256(0), "Invalid ID");
216 		_;
217 	}
218 	modifier validAddress(address _address) {
219 		require(_address != address(0), "Invalid address");
220 		_;
221 	}
222 
223 
224 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
225 	////////////////////////////////////////////////////////// PixelCons Core ///////////////////////////////////////////////////////////////////
226 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
227 
228 	/**
229 	 * @notice Contract constructor
230 	 */
231 	constructor() public
232 	{
233 		//admin defaults to the contract creator
234 		admin = msg.sender;
235 
236 		//fill zero index pixelcon collection
237 		collectionNames.length++;
238 	}
239 
240 	/**
241 	 * @notice Get the current admin
242 	 * @return The current admin
243 	 */
244 	function getAdmin() public view returns(address)
245 	{
246 		return admin;
247 	}
248 
249 	/**
250 	 * @notice Withdraw all volunteered funds to `(_to)`
251 	 * @param _to Address to withdraw the funds to
252 	 */
253 	function adminWithdraw(address _to) public
254 	{
255 		require(msg.sender == admin, "Only the admin can call this function");
256 		_to.transfer(address(this).balance);
257 	}
258 
259 	/**
260 	 * @notice Change the admin to `(_to)`
261 	 * @param _newAdmin New admin address
262 	 */
263 	function adminChange(address _newAdmin) public
264 	{
265 		require(msg.sender == admin, "Only the admin can call this function");
266 		admin = _newAdmin;
267 	}
268 
269 	/**
270 	 * @notice Change the token URI template
271 	 * @param _newTokenURITemplate New token URI template
272 	 */
273 	function adminSetTokenURITemplate(string _newTokenURITemplate) public
274 	{
275 		require(msg.sender == admin, "Only the admin can call this function");
276 		tokenURITemplate = _newTokenURITemplate;
277 	}
278 
279 	////////////////// PixelCon Tokens //////////////////
280 
281 	/**
282 	 * @notice Create PixelCon `(_tokenId)`
283 	 * @dev Throws if the token ID already exists
284 	 * @param _to Address that will own the PixelCon
285 	 * @param _tokenId ID of the PixelCon to be creates
286 	 * @param _name PixelCon name (not required)
287 	 * @return The index of the new PixelCon
288 	 */
289 	function create(address _to, uint256 _tokenId, bytes8 _name) public payable validAddress(_to) validId(_tokenId) returns(uint64)
290 	{
291 		TokenLookup storage lookupData = tokenLookup[_tokenId];
292 		require(pixelcons.length < uint256(2 ** 64) - 1, "Max number of PixelCons has been reached");
293 		require(lookupData.owner == address(0), "PixelCon already exists");
294 
295 		//get created timestamp (zero as date indicates null)
296 		uint32 dateCreated = 0;
297 		if (now < uint256(2 ** 32)) dateCreated = uint32(now);
298 
299 		//create PixelCon token and set owner
300 		uint64 index = uint64(pixelcons.length);
301 		lookupData.tokenIndex = index;
302 		pixelcons.length++;
303 		pixelconNames.length++;
304 		PixelCon storage pixelcon = pixelcons[index];
305 		pixelcon.tokenId = _tokenId;
306 		pixelcon.creator = msg.sender;
307 		pixelcon.dateCreated = dateCreated;
308 		pixelconNames[index] = _name;
309 		uint64[] storage createdList = createdTokens[msg.sender];
310 		uint createdListIndex = createdList.length;
311 		createdList.length++;
312 		createdList[createdListIndex] = index;
313 		addTokenTo(_to, _tokenId);
314 
315 		emit Create(_tokenId, msg.sender, index, _to);
316 		emit Transfer(address(0), _to, _tokenId);
317 		return index;
318 	}
319 
320 	/**
321 	 * @notice Rename PixelCon `(_tokenId)`
322 	 * @dev Throws if the caller is not the owner and creator of the token
323 	 * @param _tokenId ID of the PixelCon to rename
324 	 * @param _name New name
325 	 * @return The index of the PixelCon
326 	 */
327 	function rename(uint256 _tokenId, bytes8 _name) public validId(_tokenId) returns(uint64)
328 	{
329 		require(isCreatorAndOwner(msg.sender, _tokenId), "Sender is not the creator and owner");
330 
331 		//update name
332 		TokenLookup storage lookupData = tokenLookup[_tokenId];
333 		pixelconNames[lookupData.tokenIndex] = _name;
334 
335 		emit Rename(_tokenId, _name);
336 		return lookupData.tokenIndex;
337 	}
338 
339 	/**
340 	 * @notice Check if PixelCon `(_tokenId)` exists
341 	 * @param _tokenId ID of the PixelCon to query the existence of
342 	 * @return True if the PixelCon exists
343 	 */
344 	function exists(uint256 _tokenId) public view validId(_tokenId) returns(bool)
345 	{
346 		address owner = tokenLookup[_tokenId].owner;
347 		return owner != address(0);
348 	}
349 
350 	/**
351 	 * @notice Get the creator of PixelCon `(_tokenId)`
352 	 * @dev Throws if PixelCon does not exist
353 	 * @param _tokenId ID of the PixelCon to query the creator of
354 	 * @return Creator address for PixelCon
355 	 */
356 	function creatorOf(uint256 _tokenId) public view validId(_tokenId) returns(address)
357 	{
358 		TokenLookup storage lookupData = tokenLookup[_tokenId];
359 		require(lookupData.owner != address(0), "PixelCon does not exist");
360 
361 		return pixelcons[lookupData.tokenIndex].creator;
362 	}
363 
364 	/**
365 	 * @notice Get the total number of PixelCons created by `(_creator)`
366 	 * @param _creator Address to query the total of
367 	 * @return Total number of PixelCons created by given address
368 	 */
369 	function creatorTotal(address _creator) public view validAddress(_creator) returns(uint256)
370 	{
371 		return createdTokens[_creator].length;
372 	}
373 
374 	/**
375 	 * @notice Enumerate PixelCon created by `(_creator)`
376 	 * @dev Throws if index is out of bounds
377 	 * @param _creator Creator address
378 	 * @param _index Counter less than `creatorTotal(_creator)`
379 	 * @return PixelCon ID for the `(_index)`th PixelCon created by `(_creator)`
380 	 */
381 	function tokenOfCreatorByIndex(address _creator, uint256 _index) public view validAddress(_creator) returns(uint256)
382 	{
383 		require(_index < createdTokens[_creator].length, "Index is out of bounds");
384 		PixelCon storage pixelcon = pixelcons[createdTokens[_creator][_index]];
385 		return pixelcon.tokenId;
386 	}
387 
388 	/**
389 	 * @notice Get all details of PixelCon `(_tokenId)`
390 	 * @dev Throws if PixelCon does not exist
391 	 * @param _tokenId ID of the PixelCon to get details for
392 	 * @return PixelCon details
393 	 */
394 	function getTokenData(uint256 _tokenId) public view validId(_tokenId)
395 	returns(uint256 _tknId, uint64 _tknIdx, uint64 _collectionIdx, address _owner, address _creator, bytes8 _name, uint32 _dateCreated)
396 	{
397 		TokenLookup storage lookupData = tokenLookup[_tokenId];
398 		require(lookupData.owner != address(0), "PixelCon does not exist");
399 
400 		PixelCon storage pixelcon = pixelcons[lookupData.tokenIndex];
401 		return (pixelcon.tokenId, lookupData.tokenIndex, pixelcon.collectionIndex, lookupData.owner,
402 			pixelcon.creator, pixelconNames[lookupData.tokenIndex], pixelcon.dateCreated);
403 	}
404 
405 	/**
406 	 * @notice Get all details of PixelCon #`(_tokenIndex)`
407 	 * @dev Throws if PixelCon does not exist
408 	 * @param _tokenIndex Index of the PixelCon to get details for
409 	 * @return PixelCon details
410 	 */
411 	function getTokenDataByIndex(uint64 _tokenIndex) public view
412 	returns(uint256 _tknId, uint64 _tknIdx, uint64 _collectionIdx, address _owner, address _creator, bytes8 _name, uint32 _dateCreated)
413 	{
414 		require(_tokenIndex < totalSupply(), "PixelCon index is out of bounds");
415 
416 		PixelCon storage pixelcon = pixelcons[_tokenIndex];
417 		TokenLookup storage lookupData = tokenLookup[pixelcon.tokenId];
418 		return (pixelcon.tokenId, lookupData.tokenIndex, pixelcon.collectionIndex, lookupData.owner,
419 			pixelcon.creator, pixelconNames[lookupData.tokenIndex], pixelcon.dateCreated);
420 	}
421 
422 	/**
423 	 * @notice Get the index of PixelCon `(_tokenId)`
424 	 * @dev Throws if PixelCon does not exist
425 	 * @param _tokenId ID of the PixelCon to query the index of
426 	 * @return Index of the given PixelCon ID
427 	 */
428 	function getTokenIndex(uint256 _tokenId) validId(_tokenId) public view returns(uint64)
429 	{
430 		TokenLookup storage lookupData = tokenLookup[_tokenId];
431 		require(lookupData.owner != address(0), "PixelCon does not exist");
432 
433 		return lookupData.tokenIndex;
434 	}
435 
436 	////////////////// Collections //////////////////
437 
438 	/**
439 	 * @notice Create PixelCon collection
440 	 * @dev Throws if the message sender is not the owner and creator of the given tokens
441 	 * @param _tokenIndexes Token indexes to group together into a collection
442 	 * @param _name Name of the collection
443 	 * @return Index of the new collection
444 	 */
445 	function createCollection(uint64[] _tokenIndexes, bytes8 _name) public returns(uint64)
446 	{
447 		require(collectionNames.length < uint256(2 ** 64) - 1, "Max number of collections has been reached");
448 		require(_tokenIndexes.length > 1, "Collection must contain more than one PixelCon");
449 
450 		//loop through given indexes to add to collection and check additional requirements
451 		uint64 collectionIndex = uint64(collectionNames.length);
452 		uint64[] storage collection = collectionTokens[collectionIndex];
453 		collection.length = _tokenIndexes.length;
454 		for (uint i = 0; i < _tokenIndexes.length; i++) {
455 			uint64 tokenIndex = _tokenIndexes[i];
456 			require(tokenIndex < totalSupply(), "PixelCon index is out of bounds");
457 
458 			PixelCon storage pixelcon = pixelcons[tokenIndex];
459 			require(isCreatorAndOwner(msg.sender, pixelcon.tokenId), "Sender is not the creator and owner of the PixelCons");
460 			require(pixelcon.collectionIndex == uint64(0), "PixelCon is already in a collection");
461 
462 			pixelcon.collectionIndex = collectionIndex;
463 			collection[i] = tokenIndex;
464 		}
465 		collectionNames.length++;
466 		collectionNames[collectionIndex] = _name;
467 
468 		emit CreateCollection(msg.sender, collectionIndex);
469 		return collectionIndex;
470 	}
471 
472 	/**
473 	 * @notice Rename collection #`(_collectionIndex)`
474 	 * @dev Throws if the message sender is not the owner and creator of all collection tokens
475 	 * @param _collectionIndex Index of the collection to rename
476 	 * @param _name New name
477 	 * @return Index of the collection
478 	 */
479 	function renameCollection(uint64 _collectionIndex, bytes8 _name) validIndex(_collectionIndex) public returns(uint64)
480 	{
481 		require(_collectionIndex < totalCollections(), "Collection does not exist");
482 
483 		//loop through the collections token indexes and check additional requirements
484 		uint64[] storage collection = collectionTokens[_collectionIndex];
485 		require(collection.length > 0, "Collection has been cleared");
486 		for (uint i = 0; i < collection.length; i++) {
487 			PixelCon storage pixelcon = pixelcons[collection[i]];
488 			require(isCreatorAndOwner(msg.sender, pixelcon.tokenId), "Sender is not the creator and owner of the PixelCons");
489 		}
490 
491 		//update
492 		collectionNames[_collectionIndex] = _name;
493 
494 		emit RenameCollection(_collectionIndex, _name);
495 		return _collectionIndex;
496 	}
497 
498 	/**
499 	 * @notice Clear collection #`(_collectionIndex)`
500 	 * @dev Throws if the message sender is not the owner and creator of all collection tokens
501 	 * @param _collectionIndex Index of the collection to clear out
502 	 * @return Index of the collection
503 	 */
504 	function clearCollection(uint64 _collectionIndex) validIndex(_collectionIndex) public returns(uint64)
505 	{
506 		require(_collectionIndex < totalCollections(), "Collection does not exist");
507 
508 		//loop through the collections token indexes and check additional requirements while clearing pixelcon collection index
509 		uint64[] storage collection = collectionTokens[_collectionIndex];
510 		require(collection.length > 0, "Collection is already cleared");
511 		for (uint i = 0; i < collection.length; i++) {
512 			PixelCon storage pixelcon = pixelcons[collection[i]];
513 			require(isCreatorAndOwner(msg.sender, pixelcon.tokenId), "Sender is not the creator and owner of the PixelCons");
514 
515 			pixelcon.collectionIndex = 0;
516 		}
517 
518 		//clear out collection data
519 		delete collectionNames[_collectionIndex];
520 		delete collectionTokens[_collectionIndex];
521 
522 		emit ClearCollection(_collectionIndex);
523 		return _collectionIndex;
524 	}
525 
526 	/**
527 	 * @notice Check if collection #`(_collectionIndex)` exists
528 	 * @param _collectionIndex Index of the collection to query the existence of
529 	 * @return True if collection exists
530 	 */
531 	function collectionExists(uint64 _collectionIndex) public view validIndex(_collectionIndex) returns(bool)
532 	{
533 		return _collectionIndex < totalCollections();
534 	}
535 
536 	/**
537 	 * @notice Check if collection #`(_collectionIndex)` has been cleared
538 	 * @dev Throws if the collection index is out of bounds
539 	 * @param _collectionIndex Index of the collection to query the state of
540 	 * @return True if collection has been cleared
541 	 */
542 	function collectionCleared(uint64 _collectionIndex) public view validIndex(_collectionIndex) returns(bool)
543 	{
544 		require(_collectionIndex < totalCollections(), "Collection does not exist");
545 		return collectionTokens[_collectionIndex].length == uint256(0);
546 	}
547 
548 	/**
549 	 * @notice Get the total number of collections
550 	 * @return Total number of collections
551 	 */
552 	function totalCollections() public view returns(uint256)
553 	{
554 		return collectionNames.length;
555 	}
556 
557 	/**
558 	 * @notice Get the collection index of PixelCon `(_tokenId)`
559 	 * @dev Throws if the PixelCon does not exist
560 	 * @param _tokenId ID of the PixelCon to query the collection of
561 	 * @return Collection index of given PixelCon
562 	 */
563 	function collectionOf(uint256 _tokenId) public view validId(_tokenId) returns(uint256)
564 	{
565 		TokenLookup storage lookupData = tokenLookup[_tokenId];
566 		require(lookupData.owner != address(0), "PixelCon does not exist");
567 
568 		return pixelcons[tokenLookup[_tokenId].tokenIndex].collectionIndex;
569 	}
570 
571 	/**
572 	 * @notice Get the total number of PixelCons in collection #`(_collectionIndex)`
573 	 * @dev Throws if the collection does not exist
574 	 * @param _collectionIndex Collection index to query the total of
575 	 * @return Total number of PixelCons in the collection
576 	 */
577 	function collectionTotal(uint64 _collectionIndex) public view validIndex(_collectionIndex) returns(uint256)
578 	{
579 		require(_collectionIndex < totalCollections(), "Collection does not exist");
580 		return collectionTokens[_collectionIndex].length;
581 	}
582 
583 	/**
584 	 * @notice Get the name of collection #`(_collectionIndex)`
585 	 * @dev Throws if the collection does not exist
586 	 * @param _collectionIndex Collection index to query the name of
587 	 * @return Collection name
588 	 */
589 	function getCollectionName(uint64 _collectionIndex) public view validIndex(_collectionIndex) returns(bytes8)
590 	{
591 		require(_collectionIndex < totalCollections(), "Collection does not exist");
592 		return collectionNames[_collectionIndex];
593 	}
594 
595 	/**
596 	 * @notice Enumerate PixelCon in collection #`(_collectionIndex)`
597 	 * @dev Throws if the collection does not exist or index is out of bounds
598 	 * @param _collectionIndex Collection index
599 	 * @param _index Counter less than `collectionTotal(_collection)`
600 	 * @return PixelCon ID for the `(_index)`th PixelCon in collection #`(_collectionIndex)`
601 	 */
602 	function tokenOfCollectionByIndex(uint64 _collectionIndex, uint256 _index) public view validIndex(_collectionIndex) returns(uint256)
603 	{
604 		require(_collectionIndex < totalCollections(), "Collection does not exist");
605 		require(_index < collectionTokens[_collectionIndex].length, "Index is out of bounds");
606 		PixelCon storage pixelcon = pixelcons[collectionTokens[_collectionIndex][_index]];
607 		return pixelcon.tokenId;
608 	}
609 
610 	////////////////// Web3 Only //////////////////
611 
612 	/**
613 	 * @notice Get the indexes of all PixelCons owned by `(_owner)`
614 	 * @dev This function is for web3 calls only, as it returns a dynamic array
615 	 * @param _owner Owner address
616 	 * @return PixelCon indexes
617 	 */
618 	function getForOwner(address _owner) public view validAddress(_owner) returns(uint64[])
619 	{
620 		return ownedTokens[_owner];
621 	}
622 
623 	/**
624 	 * @notice Get the indexes of all PixelCons created by `(_creator)`
625 	 * @dev This function is for web3 calls only, as it returns a dynamic array
626 	 * @param _creator Creator address 
627 	 * @return PixelCon indexes
628 	 */
629 	function getForCreator(address _creator) public view validAddress(_creator) returns(uint64[])
630 	{
631 		return createdTokens[_creator];
632 	}
633 
634 	/**
635 	 * @notice Get the indexes of all PixelCons in collection #`(_collectionIndex)`
636 	 * @dev This function is for web3 calls only, as it returns a dynamic array
637 	 * @param _collectionIndex Collection index
638 	 * @return PixelCon indexes
639 	 */
640 	function getForCollection(uint64 _collectionIndex) public view validIndex(_collectionIndex) returns(uint64[])
641 	{
642 		return collectionTokens[_collectionIndex];
643 	}
644 
645 	/**
646 	 * @notice Get the basic data for the given PixelCon indexes
647 	 * @dev This function is for web3 calls only, as it returns a dynamic array
648 	 * @param _tokenIndexes List of PixelCon indexes
649 	 * @return All PixelCon basic data
650 	 */
651 	function getBasicData(uint64[] _tokenIndexes) public view returns(uint256[], bytes8[], address[], uint64[])
652 	{
653 		uint256[] memory tokenIds = new uint256[](_tokenIndexes.length);
654 		bytes8[] memory names = new bytes8[](_tokenIndexes.length);
655 		address[] memory owners = new address[](_tokenIndexes.length);
656 		uint64[] memory collectionIdxs = new uint64[](_tokenIndexes.length);
657 
658 		for (uint i = 0; i < _tokenIndexes.length; i++)	{
659 			uint64 tokenIndex = _tokenIndexes[i];
660 			require(tokenIndex < totalSupply(), "PixelCon index is out of bounds");
661 
662 			tokenIds[i] = pixelcons[tokenIndex].tokenId;
663 			names[i] = pixelconNames[tokenIndex];
664 			owners[i] = tokenLookup[pixelcons[tokenIndex].tokenId].owner;
665 			collectionIdxs[i] = pixelcons[tokenIndex].collectionIndex;
666 		}
667 		return (tokenIds, names, owners, collectionIdxs);
668 	}
669 
670 	/**
671 	 * @notice Get the names of all PixelCons
672 	 * @dev This function is for web3 calls only, as it returns a dynamic array
673 	 * @return The names of all PixelCons in existence
674 	 */
675 	function getAllNames() public view returns(bytes8[])
676 	{
677 		return pixelconNames;
678 	}
679 
680 	/**
681 	 * @notice Get the names of all PixelCons from index `(_startIndex)` to `(_endIndex)`
682 	 * @dev This function is for web3 calls only, as it returns a dynamic array
683 	 * @return The names of the PixelCons in the given range
684 	 */
685 	function getNamesInRange(uint64 _startIndex, uint64 _endIndex) public view returns(bytes8[])
686 	{
687 		require(_startIndex <= totalSupply(), "Start index is out of bounds");
688 		require(_endIndex <= totalSupply(), "End index is out of bounds");
689 		require(_startIndex <= _endIndex, "End index is less than the start index");
690 
691 		uint64 length = _endIndex - _startIndex;
692 		bytes8[] memory names = new bytes8[](length);
693 		for (uint i = 0; i < length; i++)	{
694 			names[i] = pixelconNames[_startIndex + i];
695 		}
696 		return names;
697 	}
698 
699 	/**
700 	 * @notice Get details of collection #`(_collectionIndex)`
701 	 * @dev This function is for web3 calls only, as it returns a dynamic array
702 	 * @param _collectionIndex Index of the collection to get the data of
703 	 * @return Collection name and included PixelCon indexes
704 	 */
705 	function getCollectionData(uint64 _collectionIndex) public view validIndex(_collectionIndex) returns(bytes8, uint64[])
706 	{
707 		require(_collectionIndex < totalCollections(), "Collection does not exist");
708 		return (collectionNames[_collectionIndex], collectionTokens[_collectionIndex]);
709 	}
710 
711 	/**
712 	 * @notice Get the names of all collections
713 	 * @dev This function is for web3 calls only, as it returns a dynamic array
714 	 * @return The names of all PixelCon collections in existence
715 	 */
716 	function getAllCollectionNames() public view returns(bytes8[])
717 	{
718 		return collectionNames;
719 	}
720 
721 	/**
722 	 * @notice Get the names of all collections from index `(_startIndex)` to `(_endIndex)`
723 	 * @dev This function is for web3 calls only, as it returns a dynamic array
724 	 * @return The names of the collections in the given range
725 	 */
726 	function getCollectionNamesInRange(uint64 _startIndex, uint64 _endIndex) public view returns(bytes8[])
727 	{
728 		require(_startIndex <= totalCollections(), "Start index is out of bounds");
729 		require(_endIndex <= totalCollections(), "End index is out of bounds");
730 		require(_startIndex <= _endIndex, "End index is less than the start index");
731 
732 		uint64 length = _endIndex - _startIndex;
733 		bytes8[] memory names = new bytes8[](length);
734 		for (uint i = 0; i < length; i++)	{
735 			names[i] = collectionNames[_startIndex + i];
736 		}
737 		return names;
738 	}
739 
740 
741 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
742 	////////////////////////////////////////////////////// ERC-721 Implementation ///////////////////////////////////////////////////////////////
743 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
744 
745 	/**
746 	 * @notice Get the balance of `(_owner)`
747 	 * @param _owner Owner address
748 	 * @return Owner balance
749 	 */
750 	function balanceOf(address _owner) public view validAddress(_owner) returns(uint256)
751 	{
752 		return ownedTokens[_owner].length;
753 	}
754 
755 	/**
756 	 * @notice Get the owner of PixelCon `(_tokenId)`
757 	 * @dev Throws if PixelCon does not exist
758 	 * @param _tokenId ID of the token
759 	 * @return Owner of the given PixelCon
760 	 */
761 	function ownerOf(uint256 _tokenId) public view validId(_tokenId) returns(address)
762 	{
763 		address owner = tokenLookup[_tokenId].owner;
764 		require(owner != address(0), "PixelCon does not exist");
765 		return owner;
766 	}
767 
768 	/**
769 	 * @notice Approve `(_to)` to transfer PixelCon `(_tokenId)` (zero indicates no approved address)
770 	 * @dev Throws if not called by the owner or an approved operator
771 	 * @param _to Address to be approved
772 	 * @param _tokenId ID of the token to be approved
773 	 */
774 	function approve(address _to, uint256 _tokenId) public validId(_tokenId)
775 	{
776 		address owner = tokenLookup[_tokenId].owner;
777 		require(_to != owner, "Cannot approve PixelCon owner");
778 		require(msg.sender == owner || operatorApprovals[owner][msg.sender], "Sender does not have permission to approve address");
779 
780 		tokenApprovals[_tokenId] = _to;
781 		emit Approval(owner, _to, _tokenId);
782 	}
783 
784 	/**
785 	 * @notice Get the approved address for PixelCon `(_tokenId)`
786 	 * @dev Throws if the PixelCon does not exist
787 	 * @param _tokenId ID of the token
788 	 * @return Address currently approved for the given PixelCon
789 	 */
790 	function getApproved(uint256 _tokenId) public view validId(_tokenId) returns(address)
791 	{
792 		address owner = tokenLookup[_tokenId].owner;
793 		require(owner != address(0), "PixelCon does not exist");
794 		return tokenApprovals[_tokenId];
795 	}
796 
797 	/**
798 	 * @notice Set or unset the approval of operator `(_to)`
799 	 * @dev An operator is allowed to transfer all tokens of the sender on their behalf
800 	 * @param _to Operator address to set the approval
801 	 * @param _approved Flag for setting approval
802 	 */
803 	function setApprovalForAll(address _to, bool _approved) public validAddress(_to)
804 	{
805 		require(_to != msg.sender, "Cannot approve self");
806 		operatorApprovals[msg.sender][_to] = _approved;
807 		emit ApprovalForAll(msg.sender, _to, _approved);
808 	}
809 
810 	/**
811 	 * @notice Get if `(_operator)` is an approved operator for owner `(_owner)`
812 	 * @param _owner Owner address 
813 	 * @param _operator Operator address
814 	 * @return True if the given operator is approved by the given owner
815 	 */
816 	function isApprovedForAll(address _owner, address _operator) public view validAddress(_owner) validAddress(_operator) returns(bool)
817 	{
818 		return operatorApprovals[_owner][_operator];
819 	}
820 
821 	/**
822 	 * @notice Transfer the ownership of PixelCon `(_tokenId)` to `(_to)` (try to use 'safeTransferFrom' instead)
823 	 * @dev Throws if the sender is not the owner, approved, or operator
824 	 * @param _from Current owner
825 	 * @param _to Address to receive the PixelCon
826 	 * @param _tokenId ID of the PixelCon to be transferred
827 	 */
828 	function transferFrom(address _from, address _to, uint256 _tokenId) public validAddress(_from) validAddress(_to) validId(_tokenId)
829 	{
830 		require(isApprovedOrOwner(msg.sender, _tokenId), "Sender does not have permission to transfer PixelCon");
831 		clearApproval(_from, _tokenId);
832 		removeTokenFrom(_from, _tokenId);
833 		addTokenTo(_to, _tokenId);
834 
835 		emit Transfer(_from, _to, _tokenId);
836 	}
837 
838 	/**
839 	 * @notice Safely transfer the ownership of PixelCon `(_tokenId)` to `(_to)`
840 	 * @dev Throws if receiver is a contract that does not respond or the sender is not the owner, approved, or operator
841 	 * @param _from Current owner
842 	 * @param _to Address to receive the PixelCon
843 	 * @param _tokenId ID of the PixelCon to be transferred
844 	 */
845 	function safeTransferFrom(address _from, address _to, uint256 _tokenId) public
846 	{
847 		//requirements are checked in 'transferFrom' function
848 		safeTransferFrom(_from, _to, _tokenId, "");
849 	}
850 
851 	/**
852 	 * @notice Safely transfer the ownership of PixelCon `(_tokenId)` to `(_to)`
853 	 * @dev Throws if receiver is a contract that does not respond or the sender is not the owner, approved, or operator
854 	 * @param _from Current owner
855 	 * @param _to Address to receive the PixelCon
856 	 * @param _tokenId ID of the PixelCon to be transferred
857 	 * @param _data Data to send along with a safe transfer check
858 	 */
859 	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public
860 	{
861 		//requirements are checked in 'transferFrom' function
862 		transferFrom(_from, _to, _tokenId);
863 		require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data), "Transfer was not safe");
864 	}
865 
866 
867 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
868 	//////////////////////////////////////////////// ERC-721 Enumeration Implementation /////////////////////////////////////////////////////////
869 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
870 
871 	/**
872 	 * @notice Get the total number of PixelCons in existence
873 	 * @return Total number of PixelCons in existence
874 	 */
875 	function totalSupply() public view returns(uint256)
876 	{
877 		return pixelcons.length;
878 	}
879 
880 	/**
881 	 * @notice Get the ID of PixelCon #`(_tokenIndex)`
882 	 * @dev Throws if index is out of bounds
883 	 * @param _tokenIndex Counter less than `totalSupply()`
884 	 * @return `_tokenIndex`th PixelCon ID
885 	 */
886 	function tokenByIndex(uint256 _tokenIndex) public view returns(uint256)
887 	{
888 		require(_tokenIndex < totalSupply(), "PixelCon index is out of bounds");
889 		return pixelcons[_tokenIndex].tokenId;
890 	}
891 
892 	/**
893 	 * @notice Enumerate PixelCon assigned to owner `(_owner)`
894 	 * @dev Throws if the index is out of bounds
895 	 * @param _owner Owner address
896 	 * @param _index Counter less than `balanceOf(_owner)`
897 	 * @return PixelCon ID for the `(_index)`th PixelCon in owned by `(_owner)`
898 	 */
899 	function tokenOfOwnerByIndex(address _owner, uint256 _index) public view validAddress(_owner) returns(uint256)
900 	{
901 		require(_index < ownedTokens[_owner].length, "Index is out of bounds");
902 		PixelCon storage pixelcon = pixelcons[ownedTokens[_owner][_index]];
903 		return pixelcon.tokenId;
904 	}
905 
906 
907 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
908 	////////////////////////////////////////////////// ERC-721 Metadata Implementation //////////////////////////////////////////////////////////
909 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
910 
911 	/**
912 	 * @notice Get the name of this contract token
913 	 * @return Contract token name
914 	 */
915 	function name() public view returns(string)
916 	{
917 		return "PixelCons";
918 	}
919 
920 	/**
921 	 * @notice Get the symbol for this contract token
922 	 * @return Contract token symbol
923 	 */
924 	function symbol() public view returns(string)
925 	{
926 		return "PXCN";
927 	}
928 
929 	/**
930 	 * @notice Get a distinct Uniform Resource Identifier (URI) for PixelCon `(_tokenId)`
931 	 * @dev Throws if the given PixelCon does not exist
932 	 * @return PixelCon URI
933 	 */
934 	function tokenURI(uint256 _tokenId) public view returns(string)
935 	{
936 		TokenLookup storage lookupData = tokenLookup[_tokenId];
937 		require(lookupData.owner != address(0), "PixelCon does not exist");
938 		PixelCon storage pixelcon = pixelcons[lookupData.tokenIndex];
939 		bytes8 pixelconName = pixelconNames[lookupData.tokenIndex];
940 
941 		//Available values: <tokenId>, <tokenIndex>, <name>, <owner>, <creator>, <dateCreated>, <collectionIndex>
942 
943 		//start with the token URI template and replace in the appropriate values
944 		string memory finalTokenURI = tokenURITemplate;
945 		finalTokenURI = StringUtils.replace(finalTokenURI, "<tokenId>", StringUtils.toHexString(_tokenId, 32));
946 		finalTokenURI = StringUtils.replace(finalTokenURI, "<tokenIndex>", StringUtils.toHexString(uint256(lookupData.tokenIndex), 8));
947 		finalTokenURI = StringUtils.replace(finalTokenURI, "<name>", StringUtils.toHexString(uint256(pixelconName), 8));
948 		finalTokenURI = StringUtils.replace(finalTokenURI, "<owner>", StringUtils.toHexString(uint256(lookupData.owner), 20));
949 		finalTokenURI = StringUtils.replace(finalTokenURI, "<creator>", StringUtils.toHexString(uint256(pixelcon.creator), 20));
950 		finalTokenURI = StringUtils.replace(finalTokenURI, "<dateCreated>", StringUtils.toHexString(uint256(pixelcon.dateCreated), 8));
951 		finalTokenURI = StringUtils.replace(finalTokenURI, "<collectionIndex>", StringUtils.toHexString(uint256(pixelcon.collectionIndex), 8));
952 
953 		return finalTokenURI;
954 	}
955 
956 
957 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
958 	////////////////////////////////////////////////////////////// Utils ////////////////////////////////////////////////////////////////////////
959 	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
960 
961 	/**
962 	 * @notice Check whether the given editor is the current owner and original creator of a given token ID
963 	 * @param _address Address to check for
964 	 * @param _tokenId ID of the token to be edited
965 	 * @return True if the editor is approved for the given token ID, is an operator of the owner, or is the owner of the token
966 	 */
967 	function isCreatorAndOwner(address _address, uint256 _tokenId) internal view returns(bool)
968 	{
969 		TokenLookup storage lookupData = tokenLookup[_tokenId];
970 		address owner = lookupData.owner;
971 		address creator = pixelcons[lookupData.tokenIndex].creator;
972 
973 		return (_address == owner && _address == creator);
974 	}
975 
976 	/**
977 	 * @notice Check whether the given spender can transfer a given token ID
978 	 * @dev Throws if the PixelCon does not exist
979 	 * @param _address Address of the spender to query
980 	 * @param _tokenId ID of the token to be transferred
981 	 * @return True if the spender is approved for the given token ID, is an operator of the owner, or is the owner of the token
982 	 */
983 	function isApprovedOrOwner(address _address, uint256 _tokenId) internal view returns(bool)
984 	{
985 		address owner = tokenLookup[_tokenId].owner;
986 		require(owner != address(0), "PixelCon does not exist");
987 		return (_address == owner || tokenApprovals[_tokenId] == _address || operatorApprovals[owner][_address]);
988 	}
989 
990 	/**
991 	 * @notice Clear current approval of a given token ID
992 	 * @dev Throws if the given address is not indeed the owner of the token
993 	 * @param _owner Owner of the token
994 	 * @param _tokenId ID of the token to be transferred
995 	 */
996 	function clearApproval(address _owner, uint256 _tokenId) internal
997 	{
998 		require(tokenLookup[_tokenId].owner == _owner, "Incorrect PixelCon owner");
999 		if (tokenApprovals[_tokenId] != address(0)) {
1000 			tokenApprovals[_tokenId] = address(0);
1001 		}
1002 	}
1003 
1004 	/**
1005 	 * @notice Add a token ID to the list of a given address
1006 	 * @dev Throws if the receiver address has hit ownership limit or the PixelCon already has an owner
1007 	 * @param _to Address representing the new owner of the given token ID
1008 	 * @param _tokenId ID of the token to be added to the tokens list of the given address
1009 	 */
1010 	function addTokenTo(address _to, uint256 _tokenId) internal
1011 	{
1012 		uint64[] storage ownedList = ownedTokens[_to];
1013 		TokenLookup storage lookupData = tokenLookup[_tokenId];
1014 		require(ownedList.length < uint256(2 ** 32) - 1, "Max number of PixelCons per owner has been reached");
1015 		require(lookupData.owner == address(0), "PixelCon already has an owner");
1016 		lookupData.owner = _to;
1017 
1018 		//update ownedTokens references
1019 		uint ownedListIndex = ownedList.length;
1020 		ownedList.length++;
1021 		lookupData.ownedIndex = uint32(ownedListIndex);
1022 		ownedList[ownedListIndex] = lookupData.tokenIndex;
1023 	}
1024 
1025 	/**
1026 	 * @notice Remove a token ID from the list of a given address
1027 	 * @dev Throws if the given address is not indeed the owner of the token
1028 	 * @param _from Address representing the previous owner of the given token ID
1029 	 * @param _tokenId ID of the token to be removed from the tokens list of the given address
1030 	 */
1031 	function removeTokenFrom(address _from, uint256 _tokenId) internal
1032 	{
1033 		uint64[] storage ownedList = ownedTokens[_from];
1034 		TokenLookup storage lookupData = tokenLookup[_tokenId];
1035 		require(lookupData.owner == _from, "From address is incorrect");
1036 		lookupData.owner = address(0);
1037 
1038 		//update ownedTokens references
1039 		uint64 replacementTokenIndex = ownedList[ownedList.length - 1];
1040 		delete ownedList[ownedList.length - 1];
1041 		ownedList.length--;
1042 		if (lookupData.ownedIndex < ownedList.length) {
1043 			//we just removed the last token index in the array, but if this wasn't the one to remove, then swap it with the one to remove 
1044 			ownedList[lookupData.ownedIndex] = replacementTokenIndex;
1045 			tokenLookup[pixelcons[replacementTokenIndex].tokenId].ownedIndex = lookupData.ownedIndex;
1046 		}
1047 		lookupData.ownedIndex = 0;
1048 	}
1049 
1050 	/**
1051 	 * @notice Invoke `onERC721Received` on a target address (not executed if the target address is not a contract)
1052 	 * @param _from Address representing the previous owner of the given token ID
1053 	 * @param _to Target address that will receive the tokens
1054 	 * @param _tokenId ID of the token to be transferred
1055 	 * @param _data Optional data to send along with the call
1056 	 * @return True if the call correctly returned the expected value
1057 	 */
1058 	function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns(bool)
1059 	{
1060 		if (!_to.isContract()) return true;
1061 
1062 		bytes4 retval = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
1063 		return (retval == ERC721_RECEIVED);
1064 	}
1065 }
1066 
1067 
1068 /**
1069  * @title ERC721 token receiver interface
1070  * @dev Interface for any contract that wants to support safeTransfers from ERC721 asset contracts.
1071  * See (https://github.com/OpenZeppelin/openzeppelin-solidity)
1072  */
1073 contract ERC721Receiver {
1074 
1075 	/**
1076 	 * @dev Magic value to be returned upon successful reception of an NFT.
1077 	 * Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
1078 	 * which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1079 	 */
1080 	bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
1081 
1082 	/**
1083 	 * @notice Handle the receipt of an NFT
1084 	 * @dev The ERC721 smart contract calls this function on the recipient
1085 	 * after a `safetransfer`. This function MAY throw to revert and reject the
1086 	 * transfer. Return of other than the magic value MUST result in the
1087 	 * transaction being reverted.
1088 	 * Note: the contract address is always the message sender.
1089 	 * @param _operator The address which called `safeTransferFrom` function
1090 	 * @param _from The address which previously owned the token
1091 	 * @param _tokenId The NFT identifier which is being transferred
1092 	 * @param _data Additional data with no specified format
1093 	 * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1094 	 */
1095 	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
1096 }
1097 
1098 
1099 /**
1100  * @title AddressUtils Library
1101  * @dev Utility library of inline functions on addresses.
1102  * See (https://github.com/OpenZeppelin/openzeppelin-solidity)
1103  */
1104 library AddressUtils {
1105 
1106 	/**
1107 	 * Returns whether the target address is a contract
1108 	 * @dev This function will return false if invoked during the constructor of a contract,
1109 	 * as the code is not actually created until after the constructor finishes.
1110 	 * @param _account address of the account to check
1111 	 * @return whether the target address is a contract
1112 	 */
1113 	function isContract(address _account) internal view returns(bool) 
1114 	{
1115 		uint256 size;
1116 		// XXX Currently there is no better way to check if there is a contract in an address
1117 		// than to check the size of the code at that address.
1118 		// See https://ethereum.stackexchange.com/a/14016/36603
1119 		// for more details about how this works.
1120 		// TODO Check this again before the Serenity release, because all addresses will be
1121 		// contracts then.
1122 		assembly { size := extcodesize(_account) }
1123 		return size > 0;
1124 	}
1125 }
1126 
1127 
1128 /**
1129  * @title StringUtils Library
1130  * @dev Utility library of inline functions on strings. 
1131  * These functions are very expensive and are only intended for web3 calls
1132  * @author PixelCons
1133  */
1134 library StringUtils {
1135 
1136 	/**
1137 	 * @dev Replaces the given key with the given value in the given string
1138 	 * @param _str String to find and replace in
1139 	 * @param _key Value to search for
1140 	 * @param _value Value to replace key with
1141 	 * @return The replaced string
1142 	 */
1143 	function replace(string _str, string _key, string _value) internal pure returns(string)
1144 	{
1145 		bytes memory bStr = bytes(_str);
1146 		bytes memory bKey = bytes(_key);
1147 		bytes memory bValue = bytes(_value);
1148 
1149 		uint index = indexOf(bStr, bKey);
1150 		if (index < bStr.length) {
1151 			bytes memory rStr = new bytes((bStr.length + bValue.length) - bKey.length);
1152 
1153 			uint i;
1154 			for (i = 0; i < index; i++) rStr[i] = bStr[i];
1155 			for (i = 0; i < bValue.length; i++) rStr[index + i] = bValue[i];
1156 			for (i = 0; i < bStr.length - (index + bKey.length); i++) rStr[index + bValue.length + i] = bStr[index + bKey.length + i];
1157 
1158 			return string(rStr);
1159 		}
1160 		return string(bStr);
1161 	}
1162 
1163 	/**
1164 	 * @dev Converts a given number into a string with hex representation
1165 	 * @param _num Number to convert
1166 	 * @param _byteSize Size of the number in bytes
1167 	 * @return The hex representation as string
1168 	 */
1169 	function toHexString(uint256 _num, uint _byteSize) internal pure returns(string)
1170 	{
1171 		bytes memory s = new bytes(_byteSize * 2 + 2);
1172 		s[0] = 0x30;
1173 		s[1] = 0x78;
1174 		for (uint i = 0; i < _byteSize; i++) {
1175 			byte b = byte(uint8(_num / (2 ** (8 * (_byteSize - 1 - i)))));
1176 			byte hi = byte(uint8(b) / 16);
1177 			byte lo = byte(uint8(b) - 16 * uint8(hi));
1178 			s[2 + 2 * i] = char(hi);
1179 			s[3 + 2 * i] = char(lo);
1180 		}
1181 		return string(s);
1182 	}
1183 
1184 	/**
1185 	 * @dev Gets the ascii hex character for the given value (0-15)
1186 	 * @param _b Byte to get ascii code for
1187 	 * @return The ascii hex character
1188 	 */
1189 	function char(byte _b) internal pure returns(byte c)
1190 	{
1191 		if (_b < 10) return byte(uint8(_b) + 0x30);
1192 		else return byte(uint8(_b) + 0x57);
1193 	}
1194 
1195 	/**
1196 	 * @dev Gets the index of the key string in the given string
1197 	 * @param _str String to search in
1198 	 * @param _key Value to search for
1199 	 * @return The index of the key in the string (string length if not found)
1200 	 */
1201 	function indexOf(bytes _str, bytes _key) internal pure returns(uint)
1202 	{
1203 		for (uint i = 0; i < _str.length - (_key.length - 1); i++) {
1204 			bool matchFound = true;
1205 			for (uint j = 0; j < _key.length; j++) {
1206 				if (_str[i + j] != _key[j]) {
1207 					matchFound = false;
1208 					break;
1209 				}
1210 			}
1211 			if (matchFound) {
1212 				return i;
1213 			}
1214 		}
1215 		return _str.length;
1216 	}
1217 }