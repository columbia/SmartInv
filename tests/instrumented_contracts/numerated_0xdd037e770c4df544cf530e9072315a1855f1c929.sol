1 pragma solidity 0.5.11;
2 
3 contract IPackFour {
4 
5     struct Purchase {
6         uint16 current;
7         uint16 count;
8         address user;
9         uint randomness;
10         uint64 commit;
11     }
12 
13     function purchases(uint p) public view returns (
14         uint16 current,
15         uint16 count,
16         address user,
17         uint256 randomness,
18         uint64 commit
19     );
20 
21     function predictPacks(uint id) public view returns (uint16[] memory protos, uint16[] memory purities);
22 
23     function getCardDetails(
24         uint16 packIndex,
25         uint8 cardIndex,
26         uint result
27     )
28         public
29         view
30         returns (uint16 proto, uint16 purity);
31 
32 }
33 
34 contract BaseMigration {
35 
36     function convertPurity(uint16 purity)
37         public
38         pure
39         returns (uint8)
40     {
41         return uint8(4 - (purity / 1000));
42     }
43 
44     function convertProto(uint16 proto)
45         public
46         view
47         returns (uint16)
48     {
49         if (proto >= 1 && proto <= 377) {
50             return proto;
51         }
52         // first phoenix
53         if (proto == 380) {
54             return 400;
55         }
56         // light's bidding
57         if (proto == 381) {
58             return 401;
59         }
60         // chimera
61         if (proto == 394) {
62             return 402;
63         }
64         // etherbots
65         (bool found, uint index) = getEtherbotsIndex(proto);
66         if (found) {
67             return uint16(380 + index);
68         }
69         // hyperion
70         if (proto == 378) {
71             return 65000;
72         }
73         // prometheus
74         if (proto == 379) {
75             return 65001;
76         }
77         // atlas
78         if (proto == 383) {
79             return 65002;
80         }
81         // tethys
82         if (proto == 384) {
83             return 65003;
84         }
85         require(false, "BM: unrecognised proto");
86     }
87 
88     uint16[] internal ebs = [
89         400,
90         413,
91         414,
92         421,
93         427,
94         428,
95         389,
96         415,
97         416,
98         422,
99         424,
100         425,
101         426,
102         382,
103         420,
104         417
105     ];
106 
107     function getEtherbotsIndex(uint16 proto)
108         public
109         view
110         returns (bool, uint16)
111     {
112         for (uint16 i = 0; i < ebs.length; i++) {
113             if (ebs[i] == proto) {
114                 return (true, i);
115             }
116         }
117         return (false, 0);
118     }
119 
120 }
121 
122 /**
123  * @dev Interface of the ERC165 standard, as defined in the
124  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
125  *
126  * Implementers can declare support of contract interfaces, which can then be
127  * queried by others (`ERC165Checker`).
128  *
129  * For an implementation, see `ERC165`.
130  */
131 interface IERC165 {
132     /**
133      * @dev Returns true if this contract implements the interface defined by
134      * `interfaceId`. See the corresponding
135      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
136      * to learn more about how these ids are created.
137      *
138      * This function call must use less than 30 000 gas.
139      */
140     function supportsInterface(bytes4 interfaceId) external view returns (bool);
141 }
142 
143 
144 /**
145  * @dev Required interface of an ERC721 compliant contract.
146  */
147 contract IERC721 is IERC165 {
148     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
149     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
150     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
151 
152     /**
153      * @dev Returns the number of NFTs in `owner`'s account.
154      */
155     function balanceOf(address owner) public view returns (uint256 balance);
156 
157     /**
158      * @dev Returns the owner of the NFT specified by `tokenId`.
159      */
160     function ownerOf(uint256 tokenId) public view returns (address owner);
161 
162     /**
163      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
164      * another (`to`).
165      *
166      * 
167      *
168      * Requirements:
169      * - `from`, `to` cannot be zero.
170      * - `tokenId` must be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move this
172      * NFT by either `approve` or `setApproveForAll`.
173      */
174     function safeTransferFrom(address from, address to, uint256 tokenId) public;
175     /**
176      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
177      * another (`to`).
178      *
179      * Requirements:
180      * - If the caller is not `from`, it must be approved to move this NFT by
181      * either `approve` or `setApproveForAll`.
182      */
183     function transferFrom(address from, address to, uint256 tokenId) public;
184     function approve(address to, uint256 tokenId) public;
185     function getApproved(uint256 tokenId) public view returns (address operator);
186 
187     function setApprovalForAll(address operator, bool _approved) public;
188     function isApprovedForAll(address owner, address operator) public view returns (bool);
189 
190 
191     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
192 }
193 
194 
195 contract ICards is IERC721 {
196 
197     struct Batch {
198         uint48 userID;
199         uint16 size;
200     }
201 
202     function batches(uint index) public view returns (uint48 userID, uint16 size);
203 
204     function userIDToAddress(uint48 id) public view returns (address);
205 
206     function getDetails(
207         uint tokenId
208     )
209         public
210         view
211         returns (
212         uint16 proto,
213         uint8 quality
214     );
215 
216     function setQuality(
217         uint tokenId,
218         uint8 quality
219     ) public;
220 
221     function mintCards(
222         address to,
223         uint16[] memory _protos,
224         uint8[] memory _qualities
225     )
226         public
227         returns (uint);
228 
229     function mintCard(
230         address to,
231         uint16 _proto,
232         uint8 _quality
233     )
234         public
235         returns (uint);
236 
237     function burn(uint tokenId) public;
238 
239     function batchSize()
240         public
241         view
242         returns (uint);
243 }
244 
245 
246 
247 contract SplitV1Migration is BaseMigration {
248 
249     ICards cards;
250     uint public oldLimit;
251     uint16 public newLimit;
252     uint16 public constant size = 5;
253 
254     constructor(
255         ICards _cards,
256         address[] memory _packs,
257         uint _oldLimit,
258         uint16 _newLimit
259     ) public {
260 
261         for (uint i = 0; i < _packs.length; i++) {
262             canMigrate[_packs[i]] = true;
263         }
264 
265         cards = _cards;
266         oldLimit = _oldLimit;
267         require(_newLimit % size == 0, "limit must be divisible by size");
268         newLimit = _newLimit;
269     }
270 
271     mapping (address => bool) public canMigrate;
272 
273     mapping (address => mapping (uint => uint16)) public v1Migrated;
274 
275     event Migrated(
276         address indexed user,
277         address indexed pack,
278         uint indexed id,
279         uint start,
280         uint end,
281         uint startID
282     );
283 
284     function migrateAll(
285         IPackFour pack,
286         uint[] memory ids
287     ) public {
288         for (uint i = 0; i < ids.length; i++) {
289             migrate(pack, ids[i]);
290         }
291     }
292 
293     struct StackDepthLimit {
294         uint16 proto;
295         uint16 purity;
296         uint16[] protos;
297         uint8[] qualities;
298     }
299 
300     function migrate(
301         IPackFour pack,
302         uint id
303     )
304         public
305     {
306 
307         require(
308             canMigrate[address(pack)],
309             "V1: must be migrating from an approved pack"
310         );
311 
312         (
313             uint16 current,
314             uint16 count,
315             address user,
316             uint256 randomness,
317         ) = pack.purchases(id);
318 
319         // Check if randomness set
320         require(
321             randomness != 0,
322             "V1: must have had randomness set"
323         );
324 
325         uint16 remaining = ((count - current) * size);
326 
327         require(
328             remaining > oldLimit,
329             "V1: must have not been able to activate in v1"
330         );
331 
332         remaining -= v1Migrated[address(pack)][id];
333 
334         uint16 loopStart = (current * size) + v1Migrated[address(pack)][id];
335 
336         uint16 len = remaining > newLimit ? newLimit : remaining;
337 
338         StackDepthLimit memory sdl;
339 
340         sdl.protos = new uint16[](len);
341         sdl.qualities = new uint8[](len);
342 
343         uint16 packStart = loopStart / size;
344 
345         for (uint16 i = 0; i < len / size; i++) {
346             for (uint8 j = 0; j < size; j++) {
347                 uint index = (i * size) + j;
348                 (sdl.proto, sdl.purity) = pack.getCardDetails(i + packStart, j, randomness);
349                 sdl.protos[index] = convertProto(sdl.proto);
350                 sdl.qualities[index] = convertPurity(sdl.purity);
351             }
352         }
353 
354         // Batch Mint cards (details passed as function args)
355         uint startID = cards.mintCards(user, sdl.protos, sdl.qualities);
356 
357         v1Migrated[address(pack)][id] += len;
358 
359         uint loopEnd = loopStart + len;
360 
361         emit Migrated(user, address(pack), id, loopStart, loopEnd, startID);
362     }
363 
364 }