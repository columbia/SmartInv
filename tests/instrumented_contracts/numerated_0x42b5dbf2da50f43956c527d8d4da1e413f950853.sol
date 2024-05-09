1 /* ==================================================================== */
2 /* Copyright (c) 2018 The TokenTycoon Project.  All rights reserved.
3 /* 
4 /* https://tokentycoon.io
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         ssesunding@gmail.com            
8 /* ==================================================================== */
9 pragma solidity ^0.4.23;
10 
11 /// @title ERC-165 Standard Interface Detection
12 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
13 interface ERC165 {
14     function supportsInterface(bytes4 interfaceID) external view returns (bool);
15 }
16 
17 /// @title ERC-721 Non-Fungible Token Standard
18 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
19 contract ERC721 is ERC165 {
20     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
21     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
22     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
23     function balanceOf(address _owner) external view returns (uint256);
24     function ownerOf(uint256 _tokenId) external view returns (address);
25     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
26     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
27     function transferFrom(address _from, address _to, uint256 _tokenId) external;
28     function approve(address _approved, uint256 _tokenId) public;
29     function setApprovalForAll(address _operator, bool _approved) external;
30     function getApproved(uint256 _tokenId) external view returns (address);
31     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
32 }
33 
34 /// @title ERC-721 Non-Fungible Token Standard
35 interface ERC721TokenReceiver {
36 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
37 }
38 
39 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
40 interface ERC721Metadata /* is ERC721 */ {
41     function name() external pure returns (string _name);
42     function symbol() external pure returns (string _symbol);
43     function tokenURI(uint256 _tokenId) external view returns (string);
44 }
45 
46 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
47 interface ERC721Enumerable /* is ERC721 */ {
48     function totalSupply() external view returns (uint256);
49     function tokenByIndex(uint256 _index) external view returns (uint256);
50     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
51 }
52 
53 interface ERC721MetadataProvider {
54     function tokenURI(uint256 _tokenId) external view returns (string);
55 }
56 
57 contract AccessAdmin {
58     bool public isPaused = false;
59     address public addrAdmin;  
60 
61     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
62 
63     constructor() public {
64         addrAdmin = msg.sender;
65     }  
66 
67 
68     modifier onlyAdmin() {
69         require(msg.sender == addrAdmin);
70         _;
71     }
72 
73     modifier whenNotPaused() {
74         require(!isPaused);
75         _;
76     }
77 
78     modifier whenPaused {
79         require(isPaused);
80         _;
81     }
82 
83     function setAdmin(address _newAdmin) external onlyAdmin {
84         require(_newAdmin != address(0));
85         emit AdminTransferred(addrAdmin, _newAdmin);
86         addrAdmin = _newAdmin;
87     }
88 
89     function doPause() external onlyAdmin whenNotPaused {
90         isPaused = true;
91     }
92 
93     function doUnpause() external onlyAdmin whenPaused {
94         isPaused = false;
95     }
96 }
97 
98 interface TokenRecipient { 
99     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
100 }
101 
102 contract WonderToken is ERC721, ERC721Metadata, ERC721Enumerable, AccessAdmin {
103     /// @dev All manangers array(tokenId => gene)
104     uint256[] public wonderArray;
105     /// @dev Mananger tokenId vs owner address
106     mapping (uint256 => address) tokenIdToOwner;
107     /// @dev Manangers owner by the owner (array)
108     mapping (address => uint256[]) ownerToWonderArray;
109     /// @dev Mananger token ID search in owner array
110     mapping (uint256 => uint256) tokenIdToOwnerIndex;
111     /// @dev The authorized address for each TTW
112     mapping (uint256 => address) tokenIdToApprovals;
113     /// @dev The authorized operators for each address
114     mapping (address => mapping (address => bool)) operatorToApprovals;
115     /// @dev Trust contract
116     mapping (address => bool) safeContracts;
117     /// @dev Metadata provider
118     ERC721MetadataProvider public providerContract;
119 
120     /// @dev This emits when the approved address for an TTW is changed or reaffirmed.
121     event Approval
122     (
123         address indexed _owner, 
124         address indexed _approved,
125         uint256 _tokenId
126     );
127 
128     /// @dev This emits when an operator is enabled or disabled for an owner.
129     event ApprovalForAll
130     (
131         address indexed _owner,
132         address indexed _operator,
133         bool _approved
134     );
135 
136     /// @dev This emits when the equipment ownership changed 
137     event Transfer
138     (
139         address indexed from,
140         address indexed to,
141         uint256 tokenId
142     );
143     
144     constructor() public {
145         addrAdmin = msg.sender;
146         wonderArray.length += 1;
147     }
148 
149     // modifier
150     /// @dev Check if token ID is valid
151     modifier isValidToken(uint256 _tokenId) {
152         require(_tokenId >= 1 && _tokenId <= wonderArray.length, "TokenId out of range");
153         require(tokenIdToOwner[_tokenId] != address(0), "Token have no owner"); 
154         _;
155     }
156 
157     modifier canTransfer(uint256 _tokenId) {
158         address owner = tokenIdToOwner[_tokenId];
159         require(msg.sender == owner || msg.sender == tokenIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender], "Can not transfer");
160         _;
161     }
162 
163     // ERC721
164     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
165         // ERC165 || ERC721 || ERC165^ERC721
166         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
167     }
168 
169     function name() public pure returns(string) {
170         return "Token Tycoon Wonders";
171     }
172 
173     function symbol() public pure returns(string) {
174         return "TTW";
175     }
176 
177     function tokenURI(uint256 _tokenId) external view returns (string) {
178         if (address(providerContract) == address(0)) {
179             return "";
180         }
181         return providerContract.tokenURI(_tokenId);
182     }
183 
184     /// @dev Search for token quantity address
185     /// @param _owner Address that needs to be searched
186     /// @return Returns token quantity
187     function balanceOf(address _owner) external view returns(uint256) {
188         require(_owner != address(0), "Owner is 0");
189         return ownerToWonderArray[_owner].length;
190     }
191 
192     /// @dev Find the owner of an TTW
193     /// @param _tokenId The tokenId of TTW
194     /// @return Give The address of the owner of this TTW
195     function ownerOf(uint256 _tokenId) external view returns (address owner) {
196         return tokenIdToOwner[_tokenId];
197     }
198 
199     /// @dev Transfers the ownership of an TTW from one address to another address
200     /// @param _from The current owner of the TTW
201     /// @param _to The new owner
202     /// @param _tokenId The TTW to transfer
203     /// @param data Additional data with no specified format, sent in call to `_to`
204     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
205         external
206         whenNotPaused
207     {
208         _safeTransferFrom(_from, _to, _tokenId, data);
209     }
210 
211     /// @dev Transfers the ownership of an TTW from one address to another address
212     /// @param _from The current owner of the TTW
213     /// @param _to The new owner
214     /// @param _tokenId The TTW to transfer
215     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
216         external
217         whenNotPaused
218     {
219         _safeTransferFrom(_from, _to, _tokenId, "");
220     }
221 
222     /// @dev Transfer ownership of an TTW, '_to' must be a vaild address, or the TTW will lost
223     /// @param _from The current owner of the TTW
224     /// @param _to The new owner
225     /// @param _tokenId The TTW to transfer
226     function transferFrom(address _from, address _to, uint256 _tokenId)
227         external
228         whenNotPaused
229         isValidToken(_tokenId)
230         canTransfer(_tokenId)
231     {
232         address owner = tokenIdToOwner[_tokenId];
233         require(owner != address(0), "Owner is 0");
234         require(_to != address(0), "Transfer target address is 0");
235         require(owner == _from, "Transfer to self");
236         
237         _transfer(_from, _to, _tokenId);
238     }
239 
240     /// @dev Set or reaffirm the approved address for an TTW
241     /// @param _approved The new approved TTW controller
242     /// @param _tokenId The TTW to approve
243     function approve(address _approved, uint256 _tokenId) public whenNotPaused {
244         address owner = tokenIdToOwner[_tokenId];
245         require(owner != address(0));
246         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
247 
248         tokenIdToApprovals[_tokenId] = _approved;
249         emit Approval(owner, _approved, _tokenId);
250     }
251 
252     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
253     /// @param _operator Address to add to the set of authorized operators.
254     /// @param _approved True if the operators is approved, false to revoke approval
255     function setApprovalForAll(address _operator, bool _approved) 
256         external 
257         whenNotPaused
258     {
259         operatorToApprovals[msg.sender][_operator] = _approved;
260         emit ApprovalForAll(msg.sender, _operator, _approved);
261     }
262 
263     /// @dev Get the approved address for a single TTW
264     /// @param _tokenId The TTW to find the approved address for
265     /// @return The approved address for this TTW, or the zero address if there is none
266     function getApproved(uint256 _tokenId) 
267         external 
268         view 
269         isValidToken(_tokenId) 
270         returns (address) 
271     {
272         return tokenIdToApprovals[_tokenId];
273     }
274 
275     /// @dev Query if an address is an authorized operator for another address
276     /// @param _owner The address that owns the TTWs
277     /// @param _operator The address that acts on behalf of the owner
278     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
279     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
280         return operatorToApprovals[_owner][_operator];
281     }
282 
283     /// @dev Count TTWs tracked by this contract
284     /// @return A count of valid TTWs tracked by this contract, where each one of
285     ///  them has an assigned and queryable owner not equal to the zero address
286     function totalSupply() external view returns (uint256) {
287         return wonderArray.length - 1;
288     }
289 
290     /// @dev Enumerate valid TTWs
291     /// @param _index A counter less than totalSupply
292     /// @return The token identifier for the `_index`th TTW,
293     function tokenByIndex(uint256 _index) 
294         external
295         view 
296         returns (uint256) 
297     {
298         require(_index < wonderArray.length);
299         return _index;
300     }
301 
302     /// @notice Enumerate TTWs assigned to an owner
303     /// @param _owner Token owner address
304     /// @param _index A counter less than balanceOf(_owner)
305     /// @return The TTW tokenId
306     function tokenOfOwnerByIndex(address _owner, uint256 _index) 
307         external 
308         view 
309         returns (uint256) 
310     {
311         require(_owner != address(0));
312         require(_index < ownerToWonderArray[_owner].length);
313         return ownerToWonderArray[_owner][_index];
314     }
315 
316     /// @dev Do the real transfer with out any condition checking
317     /// @param _from The old owner of this TTW(If created: 0x0)
318     /// @param _to The new owner of this TTW 
319     /// @param _tokenId The tokenId of the TTW
320     function _transfer(address _from, address _to, uint256 _tokenId) internal {
321         if (_from != address(0)) {
322             uint256 indexFrom = tokenIdToOwnerIndex[_tokenId];
323             uint256[] storage ttwArray = ownerToWonderArray[_from];
324             require(ttwArray[indexFrom] == _tokenId);
325 
326             if (indexFrom != ttwArray.length - 1) {
327                 uint256 lastTokenId = ttwArray[ttwArray.length - 1];
328                 ttwArray[indexFrom] = lastTokenId; 
329                 tokenIdToOwnerIndex[lastTokenId] = indexFrom;
330             }
331             ttwArray.length -= 1; 
332             
333             if (tokenIdToApprovals[_tokenId] != address(0)) {
334                 delete tokenIdToApprovals[_tokenId];
335             }      
336         }
337 
338         tokenIdToOwner[_tokenId] = _to;
339         ownerToWonderArray[_to].push(_tokenId);
340         tokenIdToOwnerIndex[_tokenId] = ownerToWonderArray[_to].length - 1;
341         
342         emit Transfer(_from != address(0) ? _from : this, _to, _tokenId);
343     }
344 
345     /// @dev Actually perform the safeTransferFrom
346     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
347         internal
348         isValidToken(_tokenId) 
349         canTransfer(_tokenId)
350     {
351         address owner = tokenIdToOwner[_tokenId];
352         require(owner != address(0));
353         require(_to != address(0));
354         require(owner == _from);
355         
356         _transfer(_from, _to, _tokenId);
357 
358         // Do the callback after everything is done to avoid reentrancy attack
359         uint256 codeSize;
360         assembly { codeSize := extcodesize(_to) }
361         if (codeSize == 0) {
362             return;
363         }
364         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
365         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
366         require(retval == 0xf0b9e5ba);
367     }
368     
369     function setSafeContract(address _actionAddr, bool _useful) external onlyAdmin {
370         safeContracts[_actionAddr] = _useful;
371     }
372 
373     function getSafeContract(address _actionAddr) external view onlyAdmin returns(bool) {
374         return safeContracts[_actionAddr];
375     }
376 
377     function setMetadataProvider(address _provider) external onlyAdmin {
378         providerContract = ERC721MetadataProvider(_provider);
379     }
380 
381     function getOwnTokens(address _owner) external view returns(uint256[]) {
382         require(_owner != address(0));
383         return ownerToWonderArray[_owner];
384     }
385 
386     function safeGiveByContract(uint256 _tokenId, address _to) 
387         external 
388         whenNotPaused
389     {
390         require(safeContracts[msg.sender]);
391         // Only the token's owner is this can use this function
392         require(tokenIdToOwner[_tokenId] == address(this));
393         require(_to != address(0));
394 
395         _transfer(address(this), _to, _tokenId);
396     }
397 
398     /// @dev Safe transfer by trust contracts
399     function safeTransferByContract(uint256 _tokenId, address _to) 
400         external
401         whenNotPaused
402     {
403         require(safeContracts[msg.sender]);
404 
405         require(_tokenId >= 1 && _tokenId <= wonderArray.length);
406         address owner = tokenIdToOwner[_tokenId];
407         require(owner != address(0));
408         require(_to != address(0));
409         require(owner != _to);
410 
411         _transfer(owner, _to, _tokenId);
412     }
413 
414     function initManager(uint256 _gene, uint256 _count) external {
415         require(safeContracts[msg.sender] || msg.sender == addrAdmin);
416         require(_gene > 0 && _count <= 128);
417         address owner = address(this);
418         uint256[] storage ttwArray = ownerToWonderArray[owner];
419         uint256 newTokenId;
420         for (uint256 i = 0; i < _count; ++i) {
421             newTokenId = wonderArray.length;
422             wonderArray.push(_gene);
423             tokenIdToOwner[newTokenId] = owner;
424             tokenIdToOwnerIndex[newTokenId] = ttwArray.length;
425             ttwArray.push(newTokenId);
426             emit Transfer(address(0), owner, newTokenId);
427         }
428     }
429 
430     function approveAndCall(address _spender, uint256 _tokenId, bytes _extraData)
431         external
432         whenNotPaused
433         returns (bool success) 
434     {
435         TokenRecipient spender = TokenRecipient(_spender);
436         approve(_spender, _tokenId);
437         spender.receiveApproval(msg.sender, _tokenId, this, _extraData);
438         return true;
439     }
440 
441     function getProtoIdByTokenId(uint256 _tokenId)
442         external 
443         view 
444         returns(uint256 protoId) 
445     {
446         if (_tokenId > 0 && _tokenId < wonderArray.length) {
447             return wonderArray[_tokenId];
448         }
449     }
450 
451     function getOwnerTokens(address _owner)
452         external
453         view 
454         returns(uint256[] tokenIdArray, uint256[] protoIdArray) 
455     {
456         uint256[] storage ownTokens = ownerToWonderArray[_owner];
457         uint256 count = ownTokens.length;
458         tokenIdArray = new uint256[](count);
459         protoIdArray = new uint256[](count);
460         for (uint256 i = 0; i < count; ++i) {
461             tokenIdArray[i] = ownTokens[i];
462             protoIdArray[i] = wonderArray[tokenIdArray[i]];
463         }
464     } 
465 }