1 pragma solidity ^0.4.23;
2 
3 /// @title ERC-165 Standard Interface Detection
4 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
5 interface ERC165 {
6     function supportsInterface(bytes4 interfaceID) external view returns (bool);
7 }
8 
9 /// @title ERC-721 Non-Fungible Token Standard
10 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
11 contract ERC721 is ERC165 {
12     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
13     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
14     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
15     function balanceOf(address _owner) external view returns (uint256);
16     function ownerOf(uint256 _tokenId) external view returns (address);
17     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
18     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
19     function transferFrom(address _from, address _to, uint256 _tokenId) external;
20     function approve(address _approved, uint256 _tokenId) external;
21     function setApprovalForAll(address _operator, bool _approved) external;
22     function getApproved(uint256 _tokenId) external view returns (address);
23     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
24 }
25 
26 /// @title ERC-721 Non-Fungible Token Standard
27 interface ERC721TokenReceiver {
28 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
29 }
30 
31 contract AccessAdmin {
32     bool public isPaused = false;
33     address public addrAdmin;  
34 
35     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
36 
37     constructor() public {
38         addrAdmin = msg.sender;
39     }  
40 
41 
42     modifier onlyAdmin() {
43         require(msg.sender == addrAdmin);
44         _;
45     }
46 
47     modifier whenNotPaused() {
48         require(!isPaused);
49         _;
50     }
51 
52     modifier whenPaused {
53         require(isPaused);
54         _;
55     }
56 
57     function setAdmin(address _newAdmin) external onlyAdmin {
58         require(_newAdmin != address(0));
59         emit AdminTransferred(addrAdmin, _newAdmin);
60         addrAdmin = _newAdmin;
61     }
62 
63     function doPause() external onlyAdmin whenNotPaused {
64         isPaused = true;
65     }
66 
67     function doUnpause() external onlyAdmin whenPaused {
68         isPaused = false;
69     }
70 }
71 
72 //Ether League Hero Token
73 contract ELHeroToken is ERC721,AccessAdmin{
74     struct Card {
75         uint16 protoId;     // 0  10001-10025 Gen 0 Heroes
76         uint16 hero;        // 1  1-25 hero ID
77         uint16 quality;     // 2  rarities: 1 Common 2 Uncommon 3 Rare 4 Epic 5 Legendary 6 Gen 0 Heroes
78         uint16 feature;     // 3  feature
79         uint16 level;       // 4  level
80         uint16 attrExt1;    // 5  future stat 1
81         uint16 attrExt2;    // 6  future stat 2
82     }
83     
84     /// @dev All card tokenArray (not exceeding 2^32-1)
85     Card[] public cardArray;
86 
87     /// @dev Amount of tokens destroyed
88     uint256 destroyCardCount;
89 
90     /// @dev Card token ID vs owner address
91     mapping (uint256 => address) cardIdToOwner;
92 
93     /// @dev cards owner by the owner (array)
94     mapping (address => uint256[]) ownerToCardArray;
95     
96     /// @dev card token ID search in owner array
97     mapping (uint256 => uint256) cardIdToOwnerIndex;
98 
99     /// @dev The authorized address for each token
100     mapping (uint256 => address) cardIdToApprovals;
101 
102     /// @dev The authorized operators for each address
103     mapping (address => mapping (address => bool)) operatorToApprovals;
104 
105     /// @dev Trust contract
106     mapping (address => bool) actionContracts;
107 
108     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
109         actionContracts[_actionAddr] = _useful;
110     }
111 
112     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
113         return actionContracts[_actionAddr];
114     }
115 
116     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
117     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
118     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
119     event CreateCard(address indexed owner, uint256 tokenId, uint16 protoId, uint16 hero, uint16 quality, uint16 createType);
120     event DeleteCard(address indexed owner, uint256 tokenId, uint16 deleteType);
121     event ChangeCard(address indexed owner, uint256 tokenId, uint16 changeType);
122     
123 
124     modifier isValidToken(uint256 _tokenId) {
125         require(_tokenId >= 1 && _tokenId <= cardArray.length);
126         require(cardIdToOwner[_tokenId] != address(0)); 
127         _;
128     }
129 
130     modifier canTransfer(uint256 _tokenId) {
131         address owner = cardIdToOwner[_tokenId];
132         require(msg.sender == owner || msg.sender == cardIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
133         _;
134     }
135 
136     // ERC721
137     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
138         // ERC165 || ERC721 || ERC165^ERC721
139         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
140     }
141 
142     constructor() public {
143         addrAdmin = msg.sender;
144         cardArray.length += 1;
145     }
146 
147 
148     function name() public pure returns(string) {
149         return "Ether League Hero Token";
150     }
151 
152     function symbol() public pure returns(string) {
153         return "ELHT";
154     }
155 
156     /// @dev Search for token quantity address
157     /// @param _owner Address that needs to be searched
158     /// @return Returns token quantity
159     function balanceOf(address _owner) external view returns (uint256){
160         require(_owner != address(0));
161         return ownerToCardArray[_owner].length;
162     }
163 
164     /// @dev Find the owner of an ELHT
165     /// @param _tokenId The tokenId of ELHT
166     /// @return Give The address of the owner of this ELHT
167     function ownerOf(uint256 _tokenId) external view returns (address){
168         return cardIdToOwner[_tokenId];
169     }
170 
171     /// @dev Transfers the ownership of an ELHT from one address to another address
172     /// @param _from The current owner of the ELHT
173     /// @param _to The new owner
174     /// @param _tokenId The ELHT to transfer
175     /// @param data Additional data with no specified format, sent in call to `_to`
176     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external whenNotPaused{
177         _safeTransferFrom(_from, _to, _tokenId, data);
178     }
179 
180     /// @dev Transfers the ownership of an ELHT from one address to another address
181     /// @param _from The current owner of the ELHT
182     /// @param _to The new owner
183     /// @param _tokenId The ELHT to transfer
184     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused{
185         _safeTransferFrom(_from, _to, _tokenId, "");
186     }
187 
188     /// @dev Transfer ownership of an ELHT, '_to' must be a vaild address, or the ELHT will lost
189     /// @param _from The current owner of the ELHT
190     /// @param _to The new owner
191     /// @param _tokenId The ELHT to transfer
192     function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused isValidToken(_tokenId) canTransfer(_tokenId){
193         address owner = cardIdToOwner[_tokenId];
194         require(owner != address(0));
195         require(_to != address(0));
196         require(owner == _from);
197         
198         _transfer(_from, _to, _tokenId);
199     }
200     
201 
202     /// @dev Set or reaffirm the approved address for an ELHT
203     /// @param _approved The new approved ELHT controller
204     /// @param _tokenId The ELHT to approve
205     function approve(address _approved, uint256 _tokenId) external whenNotPaused{
206         address owner = cardIdToOwner[_tokenId];
207         require(owner != address(0));
208         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
209 
210         cardIdToApprovals[_tokenId] = _approved;
211         emit Approval(owner, _approved, _tokenId);
212     }
213 
214     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
215     /// @param _operator Address to add to the set of authorized operators.
216     /// @param _approved True if the operators is approved, false to revoke approval
217     function setApprovalForAll(address _operator, bool _approved) external whenNotPaused{
218         operatorToApprovals[msg.sender][_operator] = _approved;
219         emit ApprovalForAll(msg.sender, _operator, _approved);
220     }
221 
222     /// @dev Get the approved address for a single ELHT
223     /// @param _tokenId The ELHT to find the approved address for
224     /// @return The approved address for this ELHT, or the zero address if there is none
225     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
226         return cardIdToApprovals[_tokenId];
227     }
228 
229     /// @dev Query if an address is an authorized operator for another address 查询地址是否为另一地址的授权操作者
230     /// @param _owner The address that owns the ELHTs
231     /// @param _operator The address that acts on behalf of the owner
232     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
233     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
234         return operatorToApprovals[_owner][_operator];
235     }
236 
237     /// @dev Count ELHTs tracked by this contract
238     /// @return A count of valid ELHTs tracked by this contract, where each one of them has an assigned and queryable owner not equal to the zero address
239     function totalSupply() external view returns (uint256) {
240         return cardArray.length - destroyCardCount - 1;
241     }
242 
243     /// @dev Actually perform the safeTransferFrom
244     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) internal isValidToken(_tokenId) canTransfer(_tokenId){
245         address owner = cardIdToOwner[_tokenId];
246         require(owner != address(0));
247         require(_to != address(0));
248         require(owner == _from);
249         
250         _transfer(_from, _to, _tokenId);
251 
252         // Do the callback after everything is done to avoid reentrancy attack
253         uint256 codeSize;
254         assembly { codeSize := extcodesize(_to) }
255         if (codeSize == 0) {
256             return;
257         }
258         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
259         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
260         require(retval == 0xf0b9e5ba);
261     }
262 
263     /// @dev Do the real transfer with out any condition checking
264     /// @param _from The old owner of this ELHT(If created: 0x0)
265     /// @param _to The new owner of this ELHT 
266     /// @param _tokenId The tokenId of the ELHT
267     function _transfer(address _from, address _to, uint256 _tokenId) internal {
268         if (_from != address(0)) {
269             uint256 indexFrom = cardIdToOwnerIndex[_tokenId];
270             uint256[] storage cdArray = ownerToCardArray[_from];
271             require(cdArray[indexFrom] == _tokenId);
272 
273             // If the ELHT is not the element of array, change it to with the last
274             if (indexFrom != cdArray.length - 1) {
275                 uint256 lastTokenId = cdArray[cdArray.length - 1];
276                 cdArray[indexFrom] = lastTokenId; 
277                 cardIdToOwnerIndex[lastTokenId] = indexFrom;
278             }
279             cdArray.length -= 1; 
280             
281             if (cardIdToApprovals[_tokenId] != address(0)) {
282                 delete cardIdToApprovals[_tokenId];
283             }      
284         }
285 
286         // Give the ELHT to '_to'
287         cardIdToOwner[_tokenId] = _to;
288         ownerToCardArray[_to].push(_tokenId);
289         cardIdToOwnerIndex[_tokenId] = ownerToCardArray[_to].length - 1;
290         
291         emit Transfer(_from != address(0) ? _from : this, _to, _tokenId);
292     }
293 
294 
295 
296     /*----------------------------------------------------------------------------------------------------------*/
297 
298 
299     /// @dev Card creation
300     /// @param _owner Owner of the equipment created
301     /// @param _attrs Attributes of the equipment created
302     /// @return Token ID of the equipment created
303     function createCard(address _owner, uint16[5] _attrs, uint16 _createType) external whenNotPaused returns(uint256){
304         require(actionContracts[msg.sender]);
305         require(_owner != address(0));
306         uint256 newCardId = cardArray.length;
307         require(newCardId < 4294967296);
308 
309         cardArray.length += 1;
310         Card storage cd = cardArray[newCardId];
311         cd.protoId = _attrs[0];
312         cd.hero = _attrs[1];
313         cd.quality = _attrs[2];
314         cd.feature = _attrs[3];
315         cd.level = _attrs[4];
316 
317         _transfer(0, _owner, newCardId);
318         emit CreateCard(_owner, newCardId, _attrs[0], _attrs[1], _attrs[2], _createType);
319         return newCardId;
320     }
321 
322     /// @dev One specific attribute of the equipment modified
323     function _changeAttrByIndex(Card storage _cd, uint16 _index, uint16 _val) internal {
324         if (_index == 2) {
325             _cd.quality = _val;
326         } else if(_index == 3) {
327             _cd.feature = _val;
328         } else if(_index == 4) {
329             _cd.level = _val;
330         } else if(_index == 5) {
331             _cd.attrExt1 = _val;
332         } else if(_index == 6) {
333             _cd.attrExt2 = _val;
334         }
335     }
336 
337     /// @dev Equiment attributes modified (max 4 stats modified)
338     /// @param _tokenId Equipment Token ID
339     /// @param _idxArray Stats order that must be modified
340     /// @param _params Stat value that must be modified
341     /// @param _changeType Modification type such as enhance, socket, etc.
342     function changeCardAttr(uint256 _tokenId, uint16[5] _idxArray, uint16[5] _params, uint16 _changeType) external whenNotPaused isValidToken(_tokenId) {
343         require(actionContracts[msg.sender]);
344 
345         Card storage cd = cardArray[_tokenId];
346         if (_idxArray[0] > 0) _changeAttrByIndex(cd, _idxArray[0], _params[0]);
347         if (_idxArray[1] > 0) _changeAttrByIndex(cd, _idxArray[1], _params[1]);
348         if (_idxArray[2] > 0) _changeAttrByIndex(cd, _idxArray[2], _params[2]);
349         if (_idxArray[3] > 0) _changeAttrByIndex(cd, _idxArray[3], _params[3]);
350         if (_idxArray[4] > 0) _changeAttrByIndex(cd, _idxArray[4], _params[4]);
351         
352         emit ChangeCard(cardIdToOwner[_tokenId], _tokenId, _changeType);
353     }
354 
355     /// @dev Equipment destruction
356     /// @param _tokenId Equipment Token ID
357     /// @param _deleteType Destruction type, such as craft
358     function destroyCard(uint256 _tokenId, uint16 _deleteType) external whenNotPaused isValidToken(_tokenId) {
359         require(actionContracts[msg.sender]);
360 
361         address _from = cardIdToOwner[_tokenId];
362         uint256 indexFrom = cardIdToOwnerIndex[_tokenId];
363         uint256[] storage cdArray = ownerToCardArray[_from]; 
364         require(cdArray[indexFrom] == _tokenId);
365 
366         if (indexFrom != cdArray.length - 1) {
367             uint256 lastTokenId = cdArray[cdArray.length - 1];
368             cdArray[indexFrom] = lastTokenId; 
369             cardIdToOwnerIndex[lastTokenId] = indexFrom;
370         }
371         cdArray.length -= 1; 
372 
373         cardIdToOwner[_tokenId] = address(0);
374         delete cardIdToOwnerIndex[_tokenId];
375         destroyCardCount += 1;
376 
377         emit Transfer(_from, 0, _tokenId);
378 
379         emit DeleteCard(_from, _tokenId, _deleteType);
380     }
381 
382     /// @dev Safe transfer by trust contracts
383     function safeTransferByContract(uint256 _tokenId, address _to) external whenNotPaused{
384         require(actionContracts[msg.sender]);
385 
386         require(_tokenId >= 1 && _tokenId <= cardArray.length);
387         address owner = cardIdToOwner[_tokenId];
388         require(owner != address(0));
389         require(_to != address(0));
390         require(owner != _to);
391 
392         _transfer(owner, _to, _tokenId);
393     }
394 
395     /// @dev Get fashion attrs by tokenId
396     function getCard(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[7] datas) {
397         Card storage cd = cardArray[_tokenId];
398         datas[0] = cd.protoId;
399         datas[1] = cd.hero;
400         datas[2] = cd.quality;
401         datas[3] = cd.feature;
402         datas[4] = cd.level;
403         datas[5] = cd.attrExt1;
404         datas[6] = cd.attrExt2;
405     }
406 
407     /// Get tokenIds and flags by owner
408     function getOwnCard(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
409         require(_owner != address(0));
410         uint256[] storage cdArray = ownerToCardArray[_owner];
411         uint256 length = cdArray.length;
412         tokens = new uint256[](length);
413         flags = new uint32[](length);
414         for (uint256 i = 0; i < length; ++i) {
415             tokens[i] = cdArray[i];
416             Card storage cd = cardArray[cdArray[i]];
417             flags[i] = uint32(uint32(cd.protoId) * 1000 + uint32(cd.hero) * 10 + cd.quality);
418         }
419     }
420 
421     /// ELHT token info returned based on Token ID transfered (64 at most)
422     function getCardAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
423         uint256 length = _tokens.length;
424         require(length <= 64);
425         attrs = new uint16[](length * 11);
426         uint256 tokenId;
427         uint256 index;
428         for (uint256 i = 0; i < length; ++i) {
429             tokenId = _tokens[i];
430             if (cardIdToOwner[tokenId] != address(0)) {
431                 index = i * 11;
432                 Card storage cd = cardArray[tokenId];
433                 attrs[index] = cd.hero;
434                 attrs[index + 1] = cd.quality;
435                 attrs[index + 2] = cd.feature;
436                 attrs[index + 3] = cd.level;
437                 attrs[index + 4] = cd.attrExt1;
438                 attrs[index + 5] = cd.attrExt2;
439             }   
440         }
441     }
442 
443 
444 }