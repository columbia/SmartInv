1 pragma solidity ^0.5.0;
2 
3 library Address {
4 
5     function isContract(address account) internal view returns (bool) {
6 
7         uint256 size;
8         // solhint-disable-next-line no-inline-assembly
9         assembly { size := extcodesize(account) }
10         return size > 0;
11     }
12 }
13 
14 library SafeMath {
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a, "SafeMath: subtraction overflow");
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0, "SafeMath: division by zero");
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b != 0, "SafeMath: modulo by zero");
52         return a % b;
53     }
54 }
55 
56 library Counters {
57     using SafeMath for uint256;
58 
59     struct Counter {
60      
61         uint256 _value; // default: 0
62     }
63 
64     function current(Counter storage counter) internal view returns (uint256) {
65         return counter._value;
66     }
67 
68     function increment(Counter storage counter) internal {
69         counter._value += 1;
70     }
71 
72     function decrement(Counter storage counter) internal {
73         counter._value = counter._value.sub(1);
74     }
75 }
76 
77 interface IERC165 {
78 
79     function supportsInterface(bytes4 interfaceId) external view returns (bool);
80 }
81 
82 contract ERC165 is IERC165 {
83     /*
84      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
85      */
86     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
87 
88     /**
89      * @dev Mapping of interface ids to whether or not it's supported.
90      */
91     mapping(bytes4 => bool) private _supportedInterfaces;
92 
93     constructor () internal {
94  
95         _registerInterface(_INTERFACE_ID_ERC165);
96     }
97 
98     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
99         return _supportedInterfaces[interfaceId];
100     }
101 
102     function _registerInterface(bytes4 interfaceId) internal {
103         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
104         _supportedInterfaces[interfaceId] = true;
105     }
106 }
107 
108 /**
109  * @dev Required interface of an ERC721 compliant contract.
110  */
111 contract IERC721 is IERC165 {
112     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
113     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
114     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
115 
116     /**
117      * @dev Returns the number of NFTs in `owner`'s account.
118      */
119     function balanceOf(address owner) public view returns (uint256 balance);
120 
121     /**
122      * @dev Returns the owner of the NFT specified by `tokenId`.
123      */
124     function ownerOf(uint256 tokenId) public view returns (address owner);
125 
126     function transferFrom(address from, address to, uint256 tokenId) public;
127 } 
128 
129 contract ERC721 is ERC165, IERC721 {
130     using SafeMath for uint256;
131     using Address for address;
132     using Counters for Counters.Counter;
133 
134     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
135 
136     // Mapping from token ID to owner
137     mapping (uint256 => address) private _tokenOwner;
138 
139     // Mapping from token ID to approved address
140     mapping (uint256 => address) private _tokenApprovals;
141 
142     // Mapping from owner to number of owned token
143     mapping (address => Counters.Counter) private _ownedTokensCount;
144 
145     // Mapping from owner to operator approvals
146     mapping (address => mapping (address => bool)) private _operatorApprovals;
147 
148     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
149 
150     constructor () public {
151         // register the supported interfaces to conform to ERC721 via ERC165
152         _registerInterface(_INTERFACE_ID_ERC721);
153     }
154 
155     function balanceOf(address owner) public view returns (uint256) {
156         require(owner != address(0), "ERC721: balance query for the zero address");
157 
158         return _ownedTokensCount[owner].current();
159     }
160 
161     function ownerOf(uint256 tokenId) public view returns (address) {
162         address owner = _tokenOwner[tokenId];
163         require(owner != address(0), "ERC721: owner query for nonexistent token");
164 
165         return owner;
166     }
167 
168     function transferFrom(address from, address to, uint256 tokenId) public {
169         //solhint-disable-next-line max-line-length
170         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
171 
172         _transferFrom(from, to, tokenId);
173     }
174 
175     function _exists(uint256 tokenId) internal view returns (bool) {
176         address owner = _tokenOwner[tokenId];
177         return owner != address(0);
178     }
179 
180     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
181         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
182         address owner = ownerOf(tokenId);
183         return (spender == owner);
184     }
185 
186     function _mint(address to, uint256 tokenId) internal {
187         require(to != address(0), "ERC721: mint to the zero address");
188         require(!_exists(tokenId), "ERC721: token already minted");
189 
190         _tokenOwner[tokenId] = to;
191         _ownedTokensCount[to].increment();
192 
193         emit Transfer(address(0), to, tokenId);
194     }
195 
196     function _transferFrom(address from, address to, uint256 tokenId) internal {
197         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
198         require(to != address(0), "ERC721: transfer to the zero address");
199 
200         _clearApproval(tokenId);
201 
202         _ownedTokensCount[from].decrement();
203         _ownedTokensCount[to].increment();
204 
205         _tokenOwner[tokenId] = to;
206 
207         emit Transfer(from, to, tokenId);
208     }
209 
210     function _clearApproval(uint256 tokenId) private {
211         if (_tokenApprovals[tokenId] != address(0)) {
212             _tokenApprovals[tokenId] = address(0);
213         }
214     }
215 }
216 
217 contract ZodiacNFT is ERC721{
218     constructor(address[] memory _ownerAddress, uint256[] memory _number) public {
219         owner = msg.sender;
220 
221         animals[1] = animalSTR; // STR
222         animals[2] = animalAGI; // AGI
223         animals[3] = animalINT; // INT
224         
225         for (uint i = 0; i< _ownerAddress.length; i++) {
226             whiteListed[_ownerAddress[i]] = _number[i];
227         }
228     }
229 
230     struct Zodiac {
231         uint8 animalID;
232         uint8 special;
233         Stat stat;
234         Appearance appearance;
235     }
236     
237     struct Appearance {
238         uint64 color;
239         uint8 size;
240         uint8 pattern; 
241         uint8 model;
242     }
243     
244     struct Stat {
245         uint256 agility;
246         uint256 strength;
247         uint256 intelligence;
248         uint256 mental;
249     }
250     
251     Zodiac[] zodiacs;
252     mapping(uint256 => uint256[]) animals;
253     mapping(address => uint256) public whiteListed;
254     uint8[12] valueAnimal = [2, 5, 5, 2, 5, 4, 4, 4, 3, 2, 3, 3];
255     uint8[4] animalSTR = [2, 8, 10, 12];
256     uint8[4] animalAGI = [1, 3, 7, 9];
257     uint8[4] animalINT = [4, 5, 6, 11];
258     address public owner;
259     uint256 private nonce = 0;
260 
261     // Functions with this modifier can only be executed by the owner
262     modifier onlyOwner() {
263         require(msg.sender == owner);
264         _;
265     }
266 
267     function createZodiac() external {
268         require(whiteListed[msg.sender] > 0, "You do not have permission to create");
269         Zodiac memory newZodiac;
270         
271         newZodiac.special = uint8(_random() % 9 + 1);
272         newZodiac.appearance.color = uint64(_random() % 216 + 1);
273         newZodiac.appearance.size = uint8(_random() % 5 + 1);
274         newZodiac.appearance.pattern = uint8(_random() % 4 + 1);
275         newZodiac.appearance.model = uint8(_random() % 3 + 1);
276         (newZodiac.stat.strength, newZodiac.stat.agility, newZodiac.stat.intelligence, newZodiac.animalID) = _randomStat();
277         newZodiac.stat.mental = 0;
278 
279         uint256 newZodiacId = zodiacs.push(newZodiac) - 1;
280         super._mint(msg.sender, newZodiacId);
281         whiteListed[msg.sender] -= 1;
282     }
283     
284     // Function to retrieve a specific zodiacs's details.
285     function getZodiacDetails(uint256 _zodiacID) public view returns (
286         uint8, 
287         uint8,
288         uint64,
289         uint8,
290         uint8,
291         uint8,
292         uint256,
293         uint256,
294         uint256,
295         uint256
296         ) {
297         Zodiac storage zodiac = zodiacs[_zodiacID];
298 
299         return(
300                zodiac.animalID,
301                zodiac.special,
302                zodiac.appearance.color,
303                zodiac.appearance.size,
304                zodiac.appearance.pattern,
305                zodiac.appearance.model,
306                zodiac.stat.agility,
307                zodiac.stat.strength,
308                zodiac.stat.intelligence,
309                zodiac.stat.mental);
310     }
311     
312     /** @dev Function to get a list of owned zodiacs' IDs
313       * @return A uint array which contains IDs of all owned zodiacss
314     */
315     function ownedZodiac() public view returns(uint256[] memory) {
316         uint256 zodiacCount = balanceOf(msg.sender);
317         if (zodiacCount == 0) {
318             return new uint256[](0);
319         }
320         
321         uint256[] memory result = new uint256[](zodiacCount);
322         uint256 totalZodiacs = zodiacs.length;
323         uint256 resultIndex = 0;
324         uint256 zodiacID = 0;
325         while (zodiacID < totalZodiacs) {
326             if (ownerOf(zodiacID) == msg.sender) {
327                 result[resultIndex] = zodiacID;
328                 resultIndex = resultIndex + 1;
329             }
330             zodiacID = zodiacID + 1;
331         }
332         return result;
333     }
334 
335     function _randomGacha() private returns(uint256) {
336         uint256 gacha = _random() % 10000 + 1;
337         if (gacha <= 50) {
338             return 30;
339         }
340         if (gacha <= 150) {
341             return 24;
342         } 
343         if (gacha <= 625) {
344             return 15;
345         } 
346         if (gacha <= 2100) {
347             return 9;
348         } 
349         return 0;
350     }
351     
352     function _randomStat() private returns(uint256, uint256, uint256, uint8) {
353         (uint8 animalID, uint256 initSTR, uint256 initAGI, uint256 initINT, uint8 group) = _randomElement();
354 
355         uint256 gacha = _randomGacha();
356         uint256 b = 0;
357         if (gacha > 0) {
358             b = _random() % (gacha / 3) + 1;
359         } 
360         
361         return (
362                 _caculateSTR(group, animalID, initSTR) + b,
363                 _caculateAGI(group, animalID, initAGI) + b,
364                 _caculateINT(group, animalID, initINT) + b, 
365                 uint8(animalID)
366                 );
367     }
368     
369     function _caculateSTR(uint8 _group, uint8 _animalID, uint256 _initSTR) private returns (uint256) {
370         if (_group == 1) {
371             return _random() % (valueAnimal[_animalID - 1] * 2) + _initSTR;
372         } 
373         
374         return _random() % (valueAnimal[_animalID - 1]) + _initSTR;
375     }
376     
377     function _caculateAGI(uint8 _group, uint8 _animalID, uint256 _initAGI) private returns (uint256) {
378         if (_group == 2) {
379             return _random() % (valueAnimal[_animalID - 1] * 2) + _initAGI;
380         } 
381         
382         return _random() % (valueAnimal[_animalID - 1]) + _initAGI;
383     }
384     
385     function _caculateINT(uint8 _group, uint8 _animalID, uint256 _initINT) private returns (uint256) {
386         if (_group == 3) {
387             return  _random() % (valueAnimal[_animalID - 1] * 2) + _initINT;
388         } 
389         
390         return _random() % (valueAnimal[_animalID - 1]) + _initINT;
391     }
392     
393     // Random animal element
394     function _randomElement() private returns(uint8, uint256, uint256, uint256, uint8) {
395         uint8 element = uint8(_random() % 9 + 1);
396         if (element <= 3) { // STR
397             return (uint8(_randomAnimal(1)), 50, 30, 20, 1);
398         } 
399         if (element <= 6) { // AGI
400             return (uint8(_randomAnimal(2)), 25, 50, 25, 2);
401         } 
402         return (uint8(_randomAnimal(3)), 30, 30, 40, 3);
403     }
404     
405     function _randomAnimal(uint8 _animalGroup) private returns(uint256){
406         uint256 animal = _random() % 3 + 1;
407         return animals[_animalGroup][animal];
408     }
409     
410     function _random() private returns(uint256) {
411         nonce += 1;
412         return uint256(keccak256(abi.encodePacked(now, nonce)));
413     }
414     
415     function whiteListAddr(address _addr, uint256 _setCount) public onlyOwner {
416         whiteListed[_addr] = _setCount;
417     }
418     
419     // Below two emergency functions will be never used in normal situations.
420     // These function is only prepared for emergency case such as smart contract hacking Vulnerability or smart contract abolishment
421     // Withdrawn fund by these function cannot belong to any operators or owners.
422     // Withdrawn fund should be distributed to individual accounts having original ownership of withdrawn fund.
423     function emergencyWithdrawalETH(uint256 amount) public onlyOwner {
424         require(msg.sender.send(amount));
425     }
426     
427     // Fallback function
428     function() external payable {
429     }
430 }