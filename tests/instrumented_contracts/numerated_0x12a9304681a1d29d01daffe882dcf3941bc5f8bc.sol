1 pragma solidity 0.5.11;
2 
3 contract BaseMigration {
4 
5     function convertPurity(uint16 purity) public pure returns (uint8) {
6         return uint8(4 - (purity / 1000));
7     }
8 
9     function convertProto(uint16 proto) public view returns (uint16) {
10         if (proto >= 1 && proto <= 377) {
11             return proto;
12         }
13         // first phoenix
14         if (proto == 380) {
15             return 400;
16         }
17         // light's bidding
18         if (proto == 381) {
19             return 401;
20         }
21         // chimera
22         if (proto == 394) {
23             return 402;
24         }
25         // etherbots
26         (bool found, uint index) = getEtherbotsIndex(proto);
27         if (found) {
28             return uint16(380 + index);
29         }
30         // hyperion
31         if (proto == 378) {
32             return 65000;
33         }
34         // prometheus
35         if (proto == 379) {
36             return 65001;
37         }
38         // atlas
39         if (proto == 383) {
40             return 65002;
41         }
42         // tethys
43         if (proto == 384) {
44             return 65003;
45         }
46         require(false, "unrecognised proto");
47     }
48 
49     uint16[] internal ebs = [400, 413, 414, 421, 427, 428, 389, 415, 416, 422, 424, 425, 426, 382, 420, 417];
50 
51     function getEtherbotsIndex(uint16 proto) public view returns (bool, uint16) {
52         for (uint16 i = 0; i < ebs.length; i++) {
53             if (ebs[i] == proto) {
54                 return (true, i);
55             }
56         }
57         return (false, 0);
58     }
59 
60 }
61 
62 /**
63  * @dev Interface of the ERC165 standard, as defined in the
64  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
65  *
66  * Implementers can declare support of contract interfaces, which can then be
67  * queried by others (`ERC165Checker`).
68  *
69  * For an implementation, see `ERC165`.
70  */
71 interface IERC165 {
72     /**
73      * @dev Returns true if this contract implements the interface defined by
74      * `interfaceId`. See the corresponding
75      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
76      * to learn more about how these ids are created.
77      *
78      * This function call must use less than 30 000 gas.
79      */
80     function supportsInterface(bytes4 interfaceId) external view returns (bool);
81 }
82 
83 
84 /**
85  * @dev Required interface of an ERC721 compliant contract.
86  */
87 contract IERC721 is IERC165 {
88     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
89     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
90     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
91 
92     /**
93      * @dev Returns the number of NFTs in `owner`'s account.
94      */
95     function balanceOf(address owner) public view returns (uint256 balance);
96 
97     /**
98      * @dev Returns the owner of the NFT specified by `tokenId`.
99      */
100     function ownerOf(uint256 tokenId) public view returns (address owner);
101 
102     /**
103      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
104      * another (`to`).
105      *
106      * 
107      *
108      * Requirements:
109      * - `from`, `to` cannot be zero.
110      * - `tokenId` must be owned by `from`.
111      * - If the caller is not `from`, it must be have been allowed to move this
112      * NFT by either `approve` or `setApproveForAll`.
113      */
114     function safeTransferFrom(address from, address to, uint256 tokenId) public;
115     /**
116      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
117      * another (`to`).
118      *
119      * Requirements:
120      * - If the caller is not `from`, it must be approved to move this NFT by
121      * either `approve` or `setApproveForAll`.
122      */
123     function transferFrom(address from, address to, uint256 tokenId) public;
124     function approve(address to, uint256 tokenId) public;
125     function getApproved(uint256 tokenId) public view returns (address operator);
126 
127     function setApprovalForAll(address operator, bool _approved) public;
128     function isApprovedForAll(address owner, address operator) public view returns (bool);
129 
130 
131     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
132 }
133 
134 
135 contract OldToken is IERC721 {
136 
137     function getCard(uint id) public view returns (uint16, uint16);
138     function totalSupply() public view returns (uint);
139 
140 }
141 
142 contract ICards is IERC721 {
143 
144     function getDetails(uint tokenId) public view returns (uint16 proto, uint8 quality);
145     function setQuality(uint tokenId, uint8 quality) public;
146     function burn(uint tokenId) public;
147     function batchMintCards(address to, uint16[] memory _protos, uint8[] memory _qualities) public returns (uint);
148     function mintCards(address to, uint16[] memory _protos, uint8[] memory _qualities) public returns (uint);
149     function mintCard(address to, uint16 _proto, uint8 _quality) public returns (uint);
150     function batchSize() public view returns (uint);
151 }
152 
153 
154 
155 
156 contract DirectMigration is BaseMigration {
157 
158     uint threshold;
159     OldToken old;
160     ICards cards;
161     uint limit;
162 
163     event Migrated(address indexed user, uint oldStart, uint oldEnd, uint newStart);
164     event NonGenesisMigrated(address indexed user, uint oldID, uint newID);
165 
166     constructor(OldToken _old, ICards _cards, uint _threshold, uint _limit) public {
167         old = _old;
168         cards = _cards;
169         threshold = _threshold;
170         limit = _limit;
171     }
172 
173     struct IM {
174         uint16 proto;
175         uint16 purity;
176 
177         uint16 p;
178         uint8 q;
179         uint id;
180     }
181 
182     uint public migrated;
183 
184     function multiMigrate() public {
185         while (gasleft() > 3000000) {
186             activatedMigration();
187         }
188     }
189 
190     function activatedMigration() public returns (uint current) {
191         uint start = migrated;
192         address first = old.ownerOf(start);
193         current = start;
194         address owner = first;
195         uint last = old.totalSupply();
196 
197         while (owner == first && current < start + limit) {
198             current++;
199             if (current >= last) {
200                 break;
201             }
202             owner = old.ownerOf(current);
203         }
204 
205         uint size = current - start;
206 
207         require(size > 0, "size is zero");
208 
209         uint16[] memory protos = new uint16[](size);
210         uint8[] memory qualities = new uint8[](size);
211 
212         // dodge the stack variable limit
213         IM memory im;
214         uint count = 0;
215 
216         for (uint i = 0; i < size; i++) {
217             (im.proto, im.purity) = old.getCard(start+i);
218             im.p = convertProto(im.proto);
219             im.q = convertPurity(im.purity);
220             if (im.p > 377) {
221                 im.id = cards.mintCard(first, im.p, im.q);
222                 emit NonGenesisMigrated(first, start + i, im.id);
223             } else {
224                 protos[count] = im.p;
225                 qualities[count] = im.q;
226                 count++;
227             }
228         }
229 
230         if (count > 0) {
231             // change lengths back to count
232             assembly{mstore(protos, count)}
233             assembly{mstore(qualities, count)}
234 
235             uint newStart;
236             if (count <= threshold) {
237                 newStart = cards.mintCards(first, protos, qualities);
238             } else {
239                 newStart = cards.batchMintCards(first, protos, qualities);
240             }
241 
242             emit Migrated(first, start, current, newStart);
243         }
244 
245         migrated = current;
246 
247         
248 
249         return current;
250     }
251 
252 }