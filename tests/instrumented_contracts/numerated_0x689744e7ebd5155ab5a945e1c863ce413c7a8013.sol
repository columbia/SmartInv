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
23 }
24 
25 contract BaseMigration {
26 
27     function convertPurity(uint16 purity)
28         public
29         pure
30         returns (uint8)
31     {
32         return uint8(4 - (purity / 1000));
33     }
34 
35     function convertProto(uint16 proto)
36         public
37         view
38         returns (uint16)
39     {
40         if (proto >= 1 && proto <= 377) {
41             return proto;
42         }
43         // first phoenix
44         if (proto == 380) {
45             return 400;
46         }
47         // light's bidding
48         if (proto == 381) {
49             return 401;
50         }
51         // chimera
52         if (proto == 394) {
53             return 402;
54         }
55         // etherbots
56         (bool found, uint index) = getEtherbotsIndex(proto);
57         if (found) {
58             return uint16(380 + index);
59         }
60         // hyperion
61         if (proto == 378) {
62             return 65000;
63         }
64         // prometheus
65         if (proto == 379) {
66             return 65001;
67         }
68         // atlas
69         if (proto == 383) {
70             return 65002;
71         }
72         // tethys
73         if (proto == 384) {
74             return 65003;
75         }
76         require(false, "BM: unrecognised proto");
77     }
78 
79     uint16[] internal ebs = [
80         400,
81         413,
82         414,
83         421,
84         427,
85         428,
86         389,
87         415,
88         416,
89         422,
90         424,
91         425,
92         426,
93         382,
94         420,
95         417
96     ];
97 
98     function getEtherbotsIndex(uint16 proto)
99         public
100         view
101         returns (bool, uint16)
102     {
103         for (uint16 i = 0; i < ebs.length; i++) {
104             if (ebs[i] == proto) {
105                 return (true, i);
106             }
107         }
108         return (false, 0);
109     }
110 
111 }
112 
113 /**
114  * @dev Interface of the ERC165 standard, as defined in the
115  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
116  *
117  * Implementers can declare support of contract interfaces, which can then be
118  * queried by others (`ERC165Checker`).
119  *
120  * For an implementation, see `ERC165`.
121  */
122 interface IERC165 {
123     /**
124      * @dev Returns true if this contract implements the interface defined by
125      * `interfaceId`. See the corresponding
126      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
127      * to learn more about how these ids are created.
128      *
129      * This function call must use less than 30 000 gas.
130      */
131     function supportsInterface(bytes4 interfaceId) external view returns (bool);
132 }
133 
134 
135 /**
136  * @dev Required interface of an ERC721 compliant contract.
137  */
138 contract IERC721 is IERC165 {
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
142 
143     /**
144      * @dev Returns the number of NFTs in `owner`'s account.
145      */
146     function balanceOf(address owner) public view returns (uint256 balance);
147 
148     /**
149      * @dev Returns the owner of the NFT specified by `tokenId`.
150      */
151     function ownerOf(uint256 tokenId) public view returns (address owner);
152 
153     /**
154      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
155      * another (`to`).
156      *
157      * 
158      *
159      * Requirements:
160      * - `from`, `to` cannot be zero.
161      * - `tokenId` must be owned by `from`.
162      * - If the caller is not `from`, it must be have been allowed to move this
163      * NFT by either `approve` or `setApproveForAll`.
164      */
165     function safeTransferFrom(address from, address to, uint256 tokenId) public;
166     /**
167      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
168      * another (`to`).
169      *
170      * Requirements:
171      * - If the caller is not `from`, it must be approved to move this NFT by
172      * either `approve` or `setApproveForAll`.
173      */
174     function transferFrom(address from, address to, uint256 tokenId) public;
175     function approve(address to, uint256 tokenId) public;
176     function getApproved(uint256 tokenId) public view returns (address operator);
177 
178     function setApprovalForAll(address operator, bool _approved) public;
179     function isApprovedForAll(address owner, address operator) public view returns (bool);
180 
181 
182     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
183 }
184 
185 
186 contract ICards is IERC721 {
187 
188     struct Batch {
189         uint48 userID;
190         uint16 size;
191     }
192 
193     function batches(uint index) public view returns (uint48 userID, uint16 size);
194 
195     function userIDToAddress(uint48 id) public view returns (address);
196 
197     function getDetails(
198         uint tokenId
199     )
200         public
201         view
202         returns (
203         uint16 proto,
204         uint8 quality
205     );
206 
207     function setQuality(
208         uint tokenId,
209         uint8 quality
210     ) public;
211 
212     function mintCards(
213         address to,
214         uint16[] memory _protos,
215         uint8[] memory _qualities
216     )
217         public
218         returns (uint);
219 
220     function mintCard(
221         address to,
222         uint16 _proto,
223         uint8 _quality
224     )
225         public
226         returns (uint);
227 
228     function burn(uint tokenId) public;
229 
230     function batchSize()
231         public
232         view
233         returns (uint);
234 }
235 
236 
237 contract v1Migration is BaseMigration {
238 
239     ICards cards;
240     uint public limit;
241 
242     constructor(
243         ICards _cards,
244         address[] memory _packs,
245         uint _limit
246     ) public {
247 
248         for (uint i = 0; i < _packs.length; i++) {
249             canMigrate[_packs[i]] = true;
250         }
251 
252         cards = _cards;
253         limit = _limit;
254     }
255 
256     mapping (address => bool) public canMigrate;
257 
258     mapping (address => mapping (uint => bool)) public v1Migrated;
259 
260     event Migrated(
261         address indexed user,
262         address indexed pack,
263         uint indexed id,
264         uint start,
265         uint end,
266         uint startID
267     );
268 
269     struct StackDepthLimit {
270         uint16[] oldProtos;
271         uint16[] purities;
272         uint8[] qualities;
273         uint16[] protos;
274     }
275 
276     function migrate(
277         IPackFour pack,
278         uint[] memory ids
279     ) public {
280         for (uint i = 0; i < ids.length; i++) {
281             migrate(pack, ids[i]);
282         }
283     }
284 
285     function migrate(
286         IPackFour pack,
287         uint id
288     )
289         public
290     {
291 
292         require(
293             canMigrate[address(pack)],
294             "V1: must be migrating from an approved pack"
295         );
296 
297         require(
298             !v1Migrated[address(pack)][id],
299             "V1: must not have been already migrated"
300         );
301 
302         (
303             uint16 current,
304             uint16 count,
305             address user,
306             uint256 randomness,
307         ) = pack.purchases(id);
308 
309         // Check if randomness set
310         require(
311             randomness != 0,
312             "V1: must have had randomness set"
313         );
314 
315         // removed variable due to stack limit
316         uint remaining = ((count - current) * 5);
317 
318         require(
319             remaining > 0,
320             "V1: no more cards to migrate"
321         );
322 
323         require(limit >= remaining, "too many cards remaining");
324 
325         StackDepthLimit memory sdl;
326 
327         sdl.protos = new uint16[](remaining);
328         sdl.qualities = new uint8[](remaining);
329 
330         // TODO: Do these need to be converted as well?
331         (sdl.oldProtos, sdl.purities) = pack.predictPacks(id);
332 
333         // Run loop which starts at local counter start of v1Migrated
334         uint loopStart = (current * 5);
335 
336         // For each element, get the old card and make the
337         // appropriate conversion + check not activated
338         for (uint i = 0; i < remaining; i++) {
339             uint x = loopStart+i;
340             sdl.protos[i] = convertProto(sdl.oldProtos[x]);
341             sdl.qualities[i] = convertPurity(sdl.purities[x]);
342         }
343 
344         // Batch Mint cards (details passed as function args)
345         uint startID = cards.mintCards(user, sdl.protos, sdl.qualities);
346 
347         v1Migrated[address(pack)][id] = true;
348 
349         uint loopEnd = loopStart + remaining;
350 
351         emit Migrated(user, address(pack), id, loopStart, loopEnd, startID);
352     }
353 
354 }