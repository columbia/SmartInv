1 pragma solidity 0.5.11;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * This module is used through inheritance. It will make available the modifier
57  * `onlyOwner`, which can be applied to your functions to restrict their use to
58  * the owner.
59  */
60 contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor () internal {
69         _owner = _msgSender();
70         emit OwnershipTransferred(address(0), _owner);
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(isOwner(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     /**
89      * @dev Returns true if the caller is the current owner.
90      */
91     function isOwner() public view returns (bool) {
92         return _msgSender() == _owner;
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public onlyOwner {
103         emit OwnershipTransferred(_owner, address(0));
104         _owner = address(0);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Can only be called by the current owner.
110      */
111     function transferOwnership(address newOwner) public onlyOwner {
112         _transferOwnership(newOwner);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      */
118     function _transferOwnership(address newOwner) internal {
119         require(newOwner != address(0), "Ownable: new owner is the zero address");
120         emit OwnershipTransferred(_owner, newOwner);
121         _owner = newOwner;
122     }
123 }
124 
125 
126 /**
127  * @dev Required interface of an ERC721 compliant contract.
128  */
129 contract IERC721 is IERC165 {
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
133 
134     /**
135      * @dev Returns the number of NFTs in `owner`'s account.
136      */
137     function balanceOf(address owner) public view returns (uint256 balance);
138 
139     /**
140      * @dev Returns the owner of the NFT specified by `tokenId`.
141      */
142     function ownerOf(uint256 tokenId) public view returns (address owner);
143 
144     /**
145      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
146      * another (`to`).
147      *
148      *
149      *
150      * Requirements:
151      * - `from`, `to` cannot be zero.
152      * - `tokenId` must be owned by `from`.
153      * - If the caller is not `from`, it must be have been allowed to move this
154      * NFT by either {approve} or {setApprovalForAll}.
155      */
156     function safeTransferFrom(address from, address to, uint256 tokenId) public;
157     /**
158      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
159      * another (`to`).
160      *
161      * Requirements:
162      * - If the caller is not `from`, it must be approved to move this NFT by
163      * either {approve} or {setApprovalForAll}.
164      */
165     function transferFrom(address from, address to, uint256 tokenId) public;
166     function approve(address to, uint256 tokenId) public;
167     function getApproved(uint256 tokenId) public view returns (address operator);
168 
169     function setApprovalForAll(address operator, bool _approved) public;
170     function isApprovedForAll(address owner, address operator) public view returns (bool);
171 
172 
173     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
174 }
175 
176 
177 contract ICards is IERC721 {
178 
179     struct Batch {
180         uint48 userID;
181         uint16 size;
182     }
183 
184     function batches(uint index) public view returns (uint48 userID, uint16 size);
185 
186     function userIDToAddress(uint48 id) public view returns (address);
187 
188     function getDetails(
189         uint tokenId
190     )
191         public
192         view
193         returns (
194         uint16 proto,
195         uint8 quality
196     );
197 
198     function setQuality(
199         uint tokenId,
200         uint8 quality
201     ) public;
202 
203     function mintCards(
204         address to,
205         uint16[] memory _protos,
206         uint8[] memory _qualities
207     )
208         public
209         returns (uint);
210 
211     function mintCard(
212         address to,
213         uint16 _proto,
214         uint8 _quality
215     )
216         public
217         returns (uint);
218 
219     function burn(uint tokenId) public;
220 
221     function batchSize()
222         public
223         view
224         returns (uint);
225 }
226 
227 
228 contract PromoFactory is Ownable {
229 
230     ICards public cards;
231 
232     mapping(uint16 => Proto) public protos;
233 
234     uint16 public maxProto;
235     uint16 public minProto;
236 
237     struct Proto {
238         bool isLocked;
239         address minter;
240     }
241 
242     /**
243      * Events
244      */
245 
246     event ProtoAssigned(
247         uint16 proto,
248         address minter
249     );
250 
251     event ProtoLocked(
252         uint16 proto
253     );
254 
255     /**
256      * Constructor
257      */
258 
259     constructor(
260         ICards _cards,
261         uint16 _minProto,
262         uint16 _maxProto
263     )
264         public
265     {
266         cards = _cards;
267         minProto = _minProto;
268         maxProto = _maxProto;
269     }
270 
271     /**
272      * Public functions
273      */
274 
275     function mint(
276         address to,
277         uint16[] memory _protos,
278         uint8[] memory _qualities
279     )
280         public
281     {
282         require(
283             _protos.length == _qualities.length,
284             "Proto Factory: array length mismatch between protos and qualities"
285         );
286 
287         for (uint i; i < _protos.length; i++) {
288             require(
289                 protos[_protos[i]].minter == msg.sender,
290                 "Proto Factory: only assigned minter can mint for this proto"
291             );
292 
293             require(
294                 protos[_protos[i]].isLocked == false,
295                 "Proto Factory: cannot mint a locked proto"
296             );
297         }
298 
299         cards.mintCards(to, _protos, _qualities);
300     }
301 
302     /**
303      * Only Owner functions
304      */
305 
306     function assignProtoMinter(
307         address minter,
308         uint16 proto
309     )
310         public
311         onlyOwner
312     {
313         require(
314             proto >= minProto,
315             "Proto Factory: proto must be greater than min proto"
316         );
317 
318         require(
319             proto <= maxProto,
320             "Proto Factory: proto must be less than max proto"
321         );
322 
323         require(
324             protos[proto].isLocked == false,
325             "Proto Factory: proto already locked"
326         );
327 
328         protos[proto].minter = minter;
329 
330         emit ProtoAssigned(proto, minter);
331 
332     }
333 
334     function lock(
335         uint16 proto
336     )
337         public
338         onlyOwner
339     {
340         require(
341             protos[proto].minter != address(0),
342             "Proto Factory: must be an assigned proto"
343         );
344 
345         require(
346             protos[proto].isLocked == false,
347             "Proto Factory: cannot lock a locked proto"
348         );
349 
350         protos[proto].isLocked = true;
351 
352         emit ProtoLocked(proto);
353     }
354 }