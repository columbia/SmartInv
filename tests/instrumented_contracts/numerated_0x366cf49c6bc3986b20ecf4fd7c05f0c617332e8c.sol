1 pragma solidity ^0.5.5;
2 
3 /**
4  * @title IERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface IERC165 {
8     /**
9      * @notice Query if a contract implements an interface
10      * @param interfaceId The interface identifier, as specified in ERC-165
11      * @dev Interface identification is specified in ERC-165. This function
12      * uses less than 30,000 gas.
13      */
14     function supportsInterface(bytes4 interfaceId) external view returns (bool);
15 }
16 
17 /**
18  * @title ERC165
19  * @author Matt Condon (@shrugs)
20  * @dev Implements ERC165 using a lookup table.
21  */
22 contract ERC165 is IERC165 {
23     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
24     /**
25      * 0x01ffc9a7 ===
26      *     bytes4(keccak256('supportsInterface(bytes4)'))
27      */
28 
29     /**
30      * @dev a mapping of interface id to whether or not it's supported
31      */
32     mapping(bytes4 => bool) private _supportedInterfaces;
33 
34     /**
35      * @dev A contract implementing SupportsInterfaceWithLookup
36      * implement ERC165 itself
37      */
38     constructor () internal {
39         _registerInterface(_INTERFACE_ID_ERC165);
40     }
41 
42     /**
43      * @dev implement supportsInterface(bytes4) using a lookup table
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
46         return _supportedInterfaces[interfaceId];
47     }
48 
49     /**
50      * @dev internal method for registering an interface
51      */
52     function _registerInterface(bytes4 interfaceId) internal {
53         require(interfaceId != 0xffffffff);
54         _supportedInterfaces[interfaceId] = true;
55     }
56 }
57 
58 /**
59  * @title ERC721 Non-Fungible Token Standard basic interface
60  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
61  */
62 contract IERC721 is IERC165 {
63     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
64 
65     function balanceOf(address owner) public view returns (uint256 balance);
66     function ownerOf(uint256 tokenId) public view returns (address owner);
67 
68     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
69 }
70 
71 /**
72  * @title ERC721 token receiver interface
73  * @dev Interface for any contract that wants to support safeTransfers
74  * from ERC721 asset contracts.
75  */
76 contract IERC721Receiver {
77     /**
78      * @notice Handle the receipt of an NFT
79      * @dev The ERC721 smart contract calls this function on the recipient
80      * after a `safeTransfer`. This function MUST return the function selector,
81      * otherwise the caller will revert the transaction. The selector to be
82      * returned can be obtained as `this.onERC721Received.selector`. This
83      * function MAY throw to revert and reject the transfer.
84      * Note: the ERC721 contract address is always the message sender.
85      * @param operator The address which called `safeTransferFrom` function
86      * @param from The address which previously owned the token
87      * @param tokenId The NFT identifier which is being transferred
88      * @param data Additional data with no specified format
89      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
90      */
91     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
92         public returns (bytes4);
93 }
94 
95 /**
96  * @title SafeMath
97  * @dev Unsigned math operations with safety checks that revert on error
98  */
99 library SafeMath {
100     /**
101     * @dev Multiplies two unsigned integers, reverts on overflow.
102     */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b);
112         return c;
113     }
114 
115     /**
116     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
117     */
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         // Solidity only automatically asserts when dividing by 0
120         require(b > 0);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123         return c;
124     }
125 
126     /**
127     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
128     */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         require(b <= a);
131         uint256 c = a - b;
132         return c;
133     }
134 
135     /**
136     * @dev Adds two unsigned integers, reverts on overflow.
137     */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a);
141         return c;
142     }
143 
144     /**
145     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
146     * reverts when dividing by zero.
147     */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         require(b != 0);
150         return a % b;
151     }
152 }
153 
154 /**
155  * Utility library of inline functions on addresses
156  */
157 library Address {
158     /**
159      * Returns whether the target address is a contract
160      * @dev This function will return false if invoked during the constructor of a contract,
161      * as the code is not actually created until after the constructor finishes.
162      * @param account address of the account to check
163      * @return whether the target address is a contract
164      */
165     function isContract(address account) internal view returns (bool) {
166         uint256 size;
167         // XXX Currently there is no better way to check if there is a contract in an address
168         // than to check the size of the code at that address.
169         // See https://ethereum.stackexchange.com/a/14016/36603
170         // for more details about how this works.
171         // TODO Check this again before the Serenity release, because all addresses will be
172         // contracts then.
173         // solhint-disable-next-line no-inline-assembly
174         assembly { size := extcodesize(account) }
175         return size > 0;
176     }
177 }
178 
179 /**
180  * @title ERC721 Non-Fungible Token Standard basic implementation
181  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
182  */
183 contract ERC721 is ERC165, IERC721 {
184     using SafeMath for uint256;
185     using Address for address;
186 
187     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
188     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
189     bytes4 internal constant _ERC721_RECEIVED = 0x150b7a02;
190 
191     // Mapping from token ID to owner
192     mapping (uint256 => address) public _tokenOwner;
193 
194     // Mapping from owner to number of owned token
195     mapping (address => uint256) public _ownedTokensCount;
196 
197     bytes4 internal constant _INTERFACE_ID_ERC721 = 0xab7fecf1;
198     /*
199      * 0xab7fecf1 ===
200      *     bytes4(keccak256('balanceOf(address)')) ^
201      *     bytes4(keccak256('ownerOf(uint256)')) ^
202      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
203      */
204 
205     constructor () public {
206         // register the supported interfaces to conform to ERC721 via ERC165
207         _registerInterface(_INTERFACE_ID_ERC721);
208     }
209 
210     /**
211      * @dev Gets the balance of the specified address
212      * @param owner address to query the balance of
213      * @return uint256 representing the amount owned by the passed address
214      */
215     function balanceOf(address owner) public view returns (uint256) {
216         require(owner != address(0));
217         return _ownedTokensCount[owner];
218     }
219 
220     /**
221      * @dev Gets the owner of the specified token ID
222      * @param tokenId uint256 ID of the token to query the owner of
223      * @return owner address currently marked as the owner of the given token ID
224      */
225     function ownerOf(uint256 tokenId) public view returns (address) {
226         address owner = _tokenOwner[tokenId];
227         require(owner != address(0));
228         return owner;
229     }
230 
231     /**
232      * @dev Safely transfers the ownership of a given token ID to another address
233      * If the target address is a contract, it must implement `onERC721Received`,
234      * which is called upon a safe transfer, and return the magic value
235      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
236      * the transfer is reverted.
237      * Requires the msg sender to be the owner, approved, or operator
238      * @param from current owner of the token
239      * @param to address to receive the ownership of the given token ID
240      * @param tokenId uint256 ID of the token to be transferred
241      * @param _data bytes data to send along with a safe transfer check
242      */
243     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
244         require(ownerOf(tokenId) == from);
245         require(to != address(0));
246         require(_checkOnERC721Received(from, to, tokenId, _data));
247         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
248         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
249         _tokenOwner[tokenId] = to;
250         emit Transfer(from, to, tokenId);
251     }
252 
253     /**
254      * @dev Returns whether the specified token exists
255      * @param tokenId uint256 ID of the token to query the existence of
256      * @return whether the token exists
257      */
258     function _exists(uint256 tokenId) internal view returns (bool) {
259         address owner = _tokenOwner[tokenId];
260         return owner != address(0);
261     }
262 
263     /**
264      * @dev Internal function to mint a new token
265      * Reverts if the given token ID already exists
266      * @param to The address that will own the minted token
267      * @param tokenId uint256 ID of the token to be minted
268      */
269     function _mint(address to, uint256 tokenId) internal {
270         require(to != address(0));
271         require(!_exists(tokenId));
272         _tokenOwner[tokenId] = to;
273         _ownedTokensCount[to]= _ownedTokensCount[to].add(1);
274         emit Transfer(address(0), to, tokenId);
275     }
276 
277     /**
278      * @dev Internal function to invoke `onERC721Received` on a target address
279      * The call is not executed if the target address is not a contract
280      * @param from address representing the previous owner of the given token ID
281      * @param to target address that will receive the tokens
282      * @param tokenId uint256 ID of the token to be transferred
283      * @param _data bytes optional data to send along with the call
284      * @return whether the call correctly returned the expected magic value
285      */
286     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
287         internal returns (bool)
288     {
289         if (!to.isContract()) {
290             return true;
291         }
292         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
293         return (retval == _ERC721_RECEIVED);
294     }
295 }
296 
297 /**
298  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
299  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
300  */
301 contract IERC721Metadata is IERC721 {
302     function name() external view returns (string memory);
303     function symbol() external view returns (string memory);
304     function tokenURI(uint256 tokenId) external view returns (string memory);
305 }
306 
307 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
308 
309     // Token class name e.g. "2019 Coachella Gathering Trophies" 
310     string internal _name;
311 
312     // Token class symbol e.g. "CGT19"
313     string internal _symbol;
314 
315     // Mapping for token URIs
316     mapping(uint256 => string) internal _tokenURIs;
317 
318     // // Optional mapping for token names
319     mapping(uint256 => string) internal _tokenNames;
320 
321     bytes4 internal constant _INTERFACE_ID_ERC721_METADATA = 0xbc7bebe8;
322     /**
323      * 0xbc7bebe8 ===
324      *     bytes4(keccak256('name()')) ^
325      *     bytes4(keccak256('symbol()')) ^
326      *     bytes4(keccak256('tokenURI(uint256)')) ^
327      *     bytes4(keccak256('tokenName(uint256)'))
328      */
329 
330     /**
331      * @dev Constructor function
332      */
333     constructor (string memory name, string memory symbol) public {
334         _name = name;
335         _symbol = symbol;
336 
337         // register the supported interfaces to conform to ERC721 via ERC165
338         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
339     }
340 
341     /**
342      * @dev Gets the token name
343      * @return string representing the token name
344      */
345     function name() external view returns (string memory) {
346         return _name;
347     }
348 
349     /**
350      * @dev Gets the token symbol
351      * @return string representing the token symbol
352      */
353     function symbol() external view returns (string memory) {
354         return _symbol;
355     }
356 
357     /**
358      * @dev Returns an URI for a given token ID
359      * Throws if the token ID does not exist. May return an empty string.
360      * @param tokenId uint256 ID of the token to query
361      */
362     function tokenURI(uint256 tokenId) external view returns (string memory) {
363         require(_exists(tokenId));
364         return _tokenURIs[tokenId];
365     }
366 
367     /**
368      * @dev Returns a trophy name for a given token ID
369      * Throws if the token ID does not exist. May return an empty string.
370      * @param tokenId uint256 ID of the token to query
371      */
372     function tokenName(uint256 tokenId) external view returns (string memory) {
373         require(_exists(tokenId));
374         return _tokenNames[tokenId];
375     }
376 
377     /**
378      * @dev Internal function to set the token URI for a given token
379      * Reverts if the token ID does not exist
380      * @param tokenId uint256 ID of the token to set its URI
381      * @param uri string URI to assign
382      */
383     function _setTokenURI(uint256 tokenId, string memory uri) internal {
384         require(_exists(tokenId));
385         _tokenURIs[tokenId] = uri;
386     }
387 
388     /**
389      * @dev Internal function that extracts the part of a string based on the desired length and offset. The
390      *      offset and length must not exceed the lenth of the base string.
391      * 
392      * @param _base When being used for a data type this is the extended object
393      *              otherwise this is the string that will be used for 
394      *              extracting the sub string from
395      * @param _length The length of the sub string to extract
396      * @param _offset The starting point to extract the sub string from
397      * @return string The extracted sub string
398      */
399 
400     function _substring(string memory _base, int _length, int _offset) internal pure returns (string memory) {
401         bytes memory _baseBytes = bytes(_base);
402 
403         assert(uint(_offset+_length) <= _baseBytes.length);
404 
405         string memory _tmp = new string(uint(_length));
406         bytes memory _tmpBytes = bytes(_tmp);
407 
408         uint j = 0;
409             for(uint i = uint(_offset); i < uint(_offset+_length); i++) {
410                 _tmpBytes[j++] = _baseBytes[i];
411             }
412             return string(_tmpBytes);
413         }
414 }
415 
416 /**
417  * @title Gather Standard Trophies - Gathering-based Non-Fungible ERC721 Tokens 
418  * @author Victor Rortvedt (@vrortvedt)
419  * This implementation includes all the required and some optional functionality of the ERC721 standard
420  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
421  */
422 contract GatherStandardTrophies is ERC721, ERC721Metadata {
423 
424     // Address of contract deployer/trophy minter
425     address public creator;
426 
427      /**
428      * @dev Modifier limiting certain functions to creator address
429      */
430     modifier onlyCreator() {
431         require(creator == msg.sender);
432         _;
433     }
434 
435     /**
436      * @dev Constructor function
437      */
438     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
439         name = _name;
440         symbol = _symbol;
441         creator = msg.sender;
442     }
443 
444     /**
445      * @dev Mints six standard trophies at conclusion of gathering
446      * @param winners Array containing six addresses of trophy winners 
447      * @param uri String containing ordered list of all trophies' URI info, in 59 character length chunks pointing to ipfs URL
448      */
449     function mintStandardTrophies(address[] memory winners, string memory uri) public onlyCreator {
450         mintSchmoozerTrophy((winners[0]), _substring(uri,59,0));
451         mintCupidTrophy((winners[1]), _substring(uri,59,59));
452         mintMVPTrophy((winners[2]), _substring(uri,59,118));
453         mintHumanRouterTrophy((winners[3]), _substring(uri,59,177));
454         mintOracleTrophy((winners[4]), _substring(uri,59,236));
455         mintKevinBaconTrophy((winners[5]), _substring(uri,59,295));
456     }
457 
458     /**
459      * @dev Public function that mints Schmoozer trophy at conclusion of gathering to gatherNode with most connections made
460      * @param winner Address of trophy winner 
461      * @param uri String containing IPFS link to URI info
462      */
463     function mintSchmoozerTrophy(address winner, string memory uri) public onlyCreator {
464         _mint(winner, 1);
465         _tokenNames[1] = "Schmoozer Trophy";
466         _tokenURIs[1] = uri;
467     }
468 
469     /**
470      * @dev Public function that mints Cupid trophy at conclusion of gathering to gatherNode with most matches made
471      * @param winner Address of trophy winner 
472      * @param uri String containing IPFS link to URI info
473      */
474     function mintCupidTrophy(address winner, string memory uri) public onlyCreator  {
475         _mint(winner, 2);
476         _tokenNames[2] = "Cupid Trophy";
477         _tokenURIs[2] = uri;
478     } 
479     
480     /**
481      * @dev Public function that mints  MVP trophy at conclusion of gathering to gatherNode with most total points
482      * @param winner Address of trophy winner 
483      * @param uri String containing IPFS link to URI info
484      */ 
485     function mintMVPTrophy(address winner, string memory uri) public onlyCreator {
486         _mint(winner, 3);
487         _tokenNames[3] = "MVP Trophy";
488         _tokenURIs[3] = uri;
489     } 
490 
491     /**
492      * @dev Public function that mints Human Router trophy at conclusion of gathering to gatherNode with most recommendations made
493      * @param winner Address of trophy winner 
494      * @param uri String containing IPFS link to URI info
495      */
496     function mintHumanRouterTrophy(address winner, string memory uri) public onlyCreator {
497         _mint(winner, 4);
498         _tokenNames[4] = "Human Router Trophy";
499         _tokenURIs[4] = uri;
500     }
501     
502     /**
503      * @dev Public function that mints Oracle trophy at conclusion of gathering to gatherNode with most supermatches 
504      * @param winner Address of trophy winner 
505      * @param uri String containing IPFS link to URI info
506      */
507     function mintOracleTrophy(address winner, string memory uri) public onlyCreator {
508         _mint(winner, 5);
509         _tokenNames[5] = "Oracle Trophy";
510         _tokenURIs[5] = uri;
511     } 
512 
513 
514     /**
515      * @dev Public function that mints Kevin Bacon trophy at conclusion of gathering 
516      * to gatherNode with fewest average degrees of separation from all other gatherNodes
517      * @param winner Address of trophy winner 
518      * @param uri String containing IPFS link to URI info
519      */
520     function mintKevinBaconTrophy(address winner, string memory uri) public onlyCreator {
521         _mint(winner, 6);
522         _tokenNames[6] = "Kevin Bacon Trophy";
523         _tokenURIs[6] = uri;
524     }   
525 
526 }