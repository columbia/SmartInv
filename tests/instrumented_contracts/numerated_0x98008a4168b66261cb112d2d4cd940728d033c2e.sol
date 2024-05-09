1 contract Ownable {
2   address public contractOwner;
3 
4   function Ownable() {
5     contractOwner = msg.sender;
6   }
7 
8   modifier onlyOwner() {
9     require(msg.sender == contractOwner);
10     _;
11   }
12 
13   function transferOwnership(address newOwner) onlyOwner {
14     if (newOwner != address(0)) {
15       contractOwner = newOwner;
16     }
17   }
18 }
19 
20 contract ERC721 {
21     function totalSupply() public view returns (uint256 total);
22     function balanceOf(address _owner) public view returns (uint256 balance);
23     function ownerOf(uint256 _tokenId) external view returns (address tokenOwner);
24     function approve(address _to, uint256 _tokenId) external;
25     function transfer(address _to, uint256 _tokenId) external;
26     function transferFrom(address _from, address _to, uint256 _tokenId) external;
27 
28     event Transfer(address from, address to, uint256 tokenId);
29     event Approval(address tokenOwner, address approved, uint256 tokenId);
30 
31     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
32 }
33 
34 contract DragonBase is Ownable {
35     event Birth(address tokenOwner, uint256 dragonId);
36     event Transfer(address from, address to, uint256 tokenId);
37 
38     struct Dragon {
39       // uint256 genes; TODO
40       // string name; TODO
41       uint8 attack;
42       uint8 defence;
43       uint8 color;
44       uint8 bodyType;
45       uint8 eyesType;
46       uint8 mouthType;
47       uint8 hornsType;
48       uint8 wingsType;
49       uint16 health;
50       uint256 price;
51 
52       uint256 points;
53     }
54 
55     Dragon[] dragons;
56 
57     uint256 dragonsOnSaleCount = 0;
58 
59     mapping (uint256 => address) public dragonIndexToOwner;
60     mapping (address => uint256) ownershipTokenCount;
61     mapping (uint256 => address) public dragonIndexToApproved;
62 
63     function _transfer(address _from, address _to, uint256 _tokenId) internal {
64         ownershipTokenCount[_to]++;
65         dragonIndexToOwner[_tokenId] = _to;
66 
67         if (_from != address(0)) {
68             ownershipTokenCount[_from]--;
69             delete dragonIndexToApproved[_tokenId];
70         }
71 
72         Transfer(_from, _to, _tokenId);
73     }
74 
75     function _createDragon (
76         uint8 _attack,
77         uint8 _defence,
78         uint8 _color,
79         uint8 _bodyType,
80         uint8 _eyesType,
81         uint8 _mouthType,
82         uint8 _hornsType,
83         uint8 _wingsType,
84         uint16 _health,
85         uint256 _price
86       ) internal returns (uint) {
87         Dragon memory _dragon = Dragon({
88           attack: _attack,
89           defence: _defence,
90           color: _color,
91           bodyType: _bodyType,
92           eyesType: _eyesType,
93           mouthType: _mouthType,
94           hornsType: _hornsType,
95           wingsType: _wingsType,
96           health: _health,
97           price: _price,
98           points: 0
99         });
100 
101         uint256 newDragonId = dragons.push(_dragon) - 1;
102 
103         require(newDragonId == uint256(uint32(newDragonId)));
104 
105         dragonsOnSaleCount++;
106 
107         return newDragonId;
108     }
109 }
110 
111 contract ERC721Metadata {
112     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
113         if (_tokenId == 1) {
114             buffer[0] = "Hello World! :D";
115             count = 15;
116         } else if (_tokenId == 2) {
117             buffer[0] = "I would definitely choose a medi";
118             buffer[1] = "um length string.";
119             count = 49;
120         } else if (_tokenId == 3) {
121             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
122             buffer[1] = "st accumsan dapibus augue lorem,";
123             buffer[2] = " tristique vestibulum id, libero";
124             buffer[3] = " suscipit varius sapien aliquam.";
125             count = 128;
126         }
127     }
128 }
129 
130 
131 contract DragonOwnership is DragonBase, ERC721 {
132     string public constant name = "DragonBit";
133     string public constant symbol = "DB";
134     ERC721Metadata public erc721Metadata;
135 
136     bytes4 constant InterfaceSignature_ERC165 =
137         bytes4(keccak256('supportsInterface(bytes4)'));
138 
139     bytes4 constant InterfaceSignature_ERC721 =
140         bytes4(keccak256('name()')) ^
141         bytes4(keccak256('symbol()')) ^
142         bytes4(keccak256('totalSupply()')) ^
143         bytes4(keccak256('balanceOf(address)')) ^
144         bytes4(keccak256('ownerOf(uint256)')) ^
145         bytes4(keccak256('approve(address,uint256)')) ^
146         bytes4(keccak256('transfer(address,uint256)')) ^
147         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
148         bytes4(keccak256('tokensOfOwner(address)')) ^
149         bytes4(keccak256('tokenMetadata(uint256,string)'));
150 
151     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
152     {
153         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
154     }
155 
156     function setMetadataAddress(address _contractAddress) public onlyOwner {
157         erc721Metadata = ERC721Metadata(_contractAddress);
158     }
159 
160     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
161         return dragonIndexToOwner[_tokenId] == _claimant;
162     }
163 
164     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
165         return dragonIndexToApproved[_tokenId] == _claimant;
166     }
167 
168     function _approve(uint256 _tokenId, address _approved) internal {
169         dragonIndexToApproved[_tokenId] = _approved;
170     }
171 
172     function balanceOf(address _owner) public view returns (uint256 count) {
173         return ownershipTokenCount[_owner];
174     }
175 
176     function transfer(
177         address _to,
178         uint256 _tokenId
179     )
180         external
181     {
182         require(_to != address(0));
183         require(_to != address(this));
184         require(_owns(msg.sender, _tokenId));
185         _transfer(msg.sender, _to, _tokenId);
186     }
187 
188     function approve(
189         address _to,
190         uint256 _tokenId
191     )
192         external
193     {
194         require(_owns(msg.sender, _tokenId));
195         _approve(_tokenId, _to);
196         Approval(msg.sender, _to, _tokenId);
197     }
198 
199     function transferFrom(
200         address _from,
201         address _to,
202         uint256 _tokenId
203     )
204         external
205     {
206         require(_to != address(0));
207         require(_to != address(this));
208         require(_approvedFor(msg.sender, _tokenId));
209         require(_owns(_from, _tokenId));
210         _transfer(_from, _to, _tokenId);
211     }
212 
213     function totalSupply() public view returns (uint) {
214         return dragons.length;
215     }
216 
217     function ownerOf(uint256 _tokenId)
218         external
219         view
220         returns (address tokenOwner)
221     {
222         tokenOwner = dragonIndexToOwner[_tokenId];
223 
224         require(tokenOwner != address(0));
225     }
226 
227     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
228         uint256 tokenCount = balanceOf(_owner);
229 
230         if (tokenCount == 0) {
231             return new uint256[](0);
232         } else {
233             uint256[] memory result = new uint256[](tokenCount);
234             uint256 totalDragons = totalSupply();
235             uint256 resultIndex = 0;
236             uint256 dragonId;
237 
238             for (dragonId = 0; dragonId < totalDragons; dragonId++) {
239                 if (_owns(_owner, dragonId)) {
240                     result[resultIndex] = dragonId;
241                     resultIndex++;
242                 }
243             }
244 
245             return result;
246         }
247     }
248 
249     function tokensOnSale() external view returns(uint256[] availableTokens) {
250         if (dragonsOnSaleCount == 0) {
251             return new uint256[](0);
252         } else {
253             uint256[] memory result = new uint256[](dragonsOnSaleCount);
254             uint256 totalDragons = totalSupply();
255             uint256 resultIndex = 0;
256             uint256 dragonId;
257 
258             for (dragonId = 0; dragonId < totalDragons; dragonId++) {
259                 if (_owns(address(0), dragonId)) {
260                     result[resultIndex] = dragonId;
261                     resultIndex++;
262                 }
263             }
264 
265             return result;
266         }
267     }
268 
269     function tokensForFight() external view returns(uint256[] availableTokens) {
270         uint256 dragonsForFightCount = dragons.length - dragonsOnSaleCount - ownershipTokenCount[msg.sender];
271 
272         if (dragonsForFightCount == 0) {
273             return new uint256[](0);
274         } else {
275             uint256[] memory result = new uint256[](dragonsForFightCount);
276             uint256 totalDragons = totalSupply();
277             uint256 resultIndex = 0;
278             uint256 dragonId;
279 
280             for (dragonId = 0; dragonId < totalDragons; dragonId++) {
281                 if (!_owns(address(0), dragonId) && !_owns(address(msg.sender), dragonId)) {
282                     result[resultIndex] = dragonId;
283                     resultIndex++;
284                 }
285             }
286 
287             return result;
288         }
289     }
290 
291     function _memcpy(uint _dest, uint _src, uint _len) private view {
292         // Copy word-length chunks while possible
293         for(; _len >= 32; _len -= 32) {
294             assembly {
295                 mstore(_dest, mload(_src))
296             }
297             _dest += 32;
298             _src += 32;
299         }
300 
301         // Copy remaining bytes
302         uint256 mask = 256 ** (32 - _len) - 1;
303         assembly {
304             let srcpart := and(mload(_src), not(mask))
305             let destpart := and(mload(_dest), mask)
306             mstore(_dest, or(destpart, srcpart))
307         }
308     }
309 
310     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
311         var outputString = new string(_stringLength);
312         uint256 outputPtr;
313         uint256 bytesPtr;
314 
315         assembly {
316             outputPtr := add(outputString, 32)
317             bytesPtr := _rawBytes
318         }
319 
320         _memcpy(outputPtr, bytesPtr, _stringLength);
321 
322         return outputString;
323     }
324 
325     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
326         require(erc721Metadata != address(0));
327         bytes32[4] memory buffer;
328         uint256 count;
329         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
330 
331         return _toString(buffer, count);
332     }
333 }
334 
335 contract DragonCore is DragonOwnership {
336     function getDragon(uint256 _id)
337         external
338         view
339         returns (
340           uint8 attack,
341           uint8 defence,
342           uint8 color,
343           uint8 bodyType,
344           uint8 eyesType,
345           uint8 mouthType,
346           uint8 hornsType,
347           uint8 wingsType,
348           uint16 health,
349           uint256 price,
350           uint256 points
351     ) {
352         Dragon memory d = dragons[_id];
353 
354         attack = d.attack;
355         defence = d.defence;
356         color = d.color;
357         bodyType = d.bodyType;
358         eyesType = d.eyesType;
359         mouthType = d.mouthType;
360         hornsType = d.hornsType;
361         wingsType = d.wingsType;
362         health = d.health;
363         price = d.price;
364         points = d.points;
365     }
366 
367     function createDragon(
368         uint8 _attack,
369         uint8 _defence,
370         uint8 _color,
371         uint8 _bodyType,
372         uint8 _eyesType,
373         uint8 _mouthType,
374         uint8 _hornsType,
375         uint8 _wingsType,
376         uint16 _health,
377         uint16 _price
378       ) external onlyOwner returns (uint) {
379         return _createDragon(
380           _attack,
381           _defence,
382           _color,
383           _bodyType,
384           _eyesType,
385           _mouthType,
386           _hornsType,
387           _wingsType,
388           _health,
389           _price
390         );
391     }
392 
393     function buyDragon(uint256 _id) payable {
394       Dragon memory d = dragons[_id];
395       address dragonOwner = dragonIndexToOwner[_id];
396 
397       require(dragonOwner == address(0));
398       require(msg.value >= d.price);
399 
400       Birth(msg.sender, _id);
401 
402       dragonsOnSaleCount--;
403 
404       _transfer(0, msg.sender, _id);
405     }
406 
407     function withdrawBalance() external onlyOwner {
408         uint256 balance = this.balance;
409         contractOwner.transfer(balance);
410     }
411 }
412 
413 contract Random {
414   uint64 _seed = 0;
415 
416   // return a pseudo random number between lower and upper bounds
417   // given the number of previous blocks it should hash.
418   function random(uint64 upper, uint8 step) public returns (uint64 randomNumber) {
419     _seed = uint64(keccak256(keccak256(block.blockhash(block.number - step), _seed), now));
420 
421     return _seed % upper;
422   }
423 }
424 
425 contract DragonFight is DragonCore, Random {
426 
427     event Fight(uint256 _ownerDragonId,
428                 uint256 _opponentDragonId,
429                 bool firstAttack,
430                 bool secondAttack);
431 
432     function fight(uint256 _ownerDragonId, uint256 _opponentDragonId) external returns(
433         bool attack1,
434         bool attack2,
435         bool attack3,
436         bool attack4
437       ) {
438         require(_owns(msg.sender, _ownerDragonId));
439         require(!_owns(msg.sender, _opponentDragonId));
440         require(!_owns(address(0), _opponentDragonId));
441 
442         Dragon memory ownerDragon = dragons[_ownerDragonId];
443         Dragon memory opponentDragon = dragons[_opponentDragonId];
444 
445         attack1 = _randomAttack(ownerDragon.attack, opponentDragon.defence, 1);
446         attack2 = _randomAttack(ownerDragon.defence, opponentDragon.attack, 2);
447         attack3 = _randomAttack(ownerDragon.attack, opponentDragon.defence, 3);
448         attack4 = _randomAttack(ownerDragon.defence, opponentDragon.attack, 4);
449 
450         uint8 points = (attack1 ? 1 : 0) + (attack2 ? 1 : 0) + (attack3 ? 1 : 0) + (attack4 ? 1 : 0);
451 
452         ownerDragon.points += points;
453 
454         Fight(_ownerDragonId, _opponentDragonId, attack1, attack2);
455     }
456 
457     function _randomAttack(uint8 _ownerDragonAmount, uint8 _opponentDragonAmount, uint8 _step) private
458     returns(bool result) {
459         uint64 ownerValue = random(uint64(_ownerDragonAmount), _step);
460         uint64 opponentValue = random(uint64(_opponentDragonAmount), _step);
461 
462         return ownerValue > opponentValue;
463     }
464 }
465 
466 contract DragonTest is DragonFight {
467 
468     function createTestData() public onlyOwner {
469         // 0.001 eth
470         uint256 price = 1000000000000000;
471 
472         uint newDragon1Id = _createDragon(1, 2, 1, 1, 1, 1, 1, 1, 1, price);
473         _transfer(0, msg.sender, newDragon1Id);
474         dragonsOnSaleCount--;
475 
476         uint newDragon2Id = _createDragon(2, 6, 2, 2, 2, 2, 2, 2, 2, price);
477         _transfer(0, msg.sender, newDragon2Id);
478         dragonsOnSaleCount--;
479 
480         // Free dragons
481         _createDragon(3, 2, 3, 3, 3, 1, 3, 3, 3, price);
482         _createDragon(4, 4, 4, 4, 2, 2, 2, 4, 4, price);
483     }
484 }