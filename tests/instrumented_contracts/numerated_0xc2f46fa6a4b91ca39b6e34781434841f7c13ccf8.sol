1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC721 interface
51  * @dev see https://github.com/ethereum/eips/issues/721
52  */
53 contract ERC721 {
54     event Transfer(
55         address indexed _from,
56         address indexed _to,
57         uint256 _tokenId
58     );
59     event Approval(
60         address indexed _owner,
61         address indexed _approved,
62         uint256 _tokenId
63     );
64 
65     function balanceOf(address _owner) public view returns (uint256 _balance);
66 
67     function ownerOf(uint256 _tokenId) public view returns (address _owner);
68 
69     function transfer(address _to, uint256 _tokenId) public;
70 
71     function approve(address _to, uint256 _tokenId) public;
72 
73     function takeOwnership(uint256 _tokenId) public;
74 }
75 
76 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC721/ERC721Token.sol
77 
78 /**
79  * @title ERC721Token
80  * Generic implementation for the required functionality of the ERC721 standard
81  */
82 contract NFTKred is ERC721 {
83     using SafeMath for uint256;
84 
85     // Public variables of the contract
86     string public name;
87     string public symbol;
88 
89     // Most Ethereum contracts use 18 decimals, but we restrict it to 7 here
90     // for portability to and from Stellar.
91     uint8 public valueDecimals = 7;
92 
93     // Numeric data
94     mapping(uint => uint) public nftBatch;
95     mapping(uint => uint) public nftSequence;
96     mapping(uint => uint) public nftCount;
97 
98     // The face value of the NFT must be intrinsic so that smart contracts can work with it
99     // Sale price and last sale price are available via the metadata endpoints
100     mapping(uint => uint256) public nftValue;
101 
102     // NFT strings - these are expensive to store, but necessary for API compatibility
103     // And string manipulation is also expensive
104 
105     // Not to be confused with name(), which returns the contract name
106     mapping(uint => string) public nftName;
107 
108     // The NFT type, e.g. coin, card, badge, ticket
109     mapping(uint => string) public nftType;
110 
111     // API address of standard metadata
112     mapping(uint => string) public nftURIs;
113 
114     // IPFS address of extended metadata
115     mapping(uint => string) public tokenIPFSs;
116 
117     // Total amount of tokens
118     uint256 private totalTokens;
119 
120     // Mapping from token ID to owner
121     mapping(uint256 => address) private tokenOwner;
122 
123     // Mapping from token ID to approved address
124     mapping(uint256 => address) private tokenApprovals;
125 
126     // Mapping from owner to list of owned token IDs
127     mapping(address => uint256[]) private ownedTokens;
128 
129     // Mapping from token ID to index of the owner tokens list
130     mapping(uint256 => uint256) private ownedTokensIndex;
131 
132     // Metadata accessors
133     function name() external view returns (string _name) {
134         return name;
135     }
136 
137     function symbol() external view returns (string _symbol) {
138         return symbol;
139     }
140 
141     function tokenURI(uint256 _tokenId) public view returns (string) {
142         require(exists(_tokenId));
143         return nftURIs[_tokenId];
144     }
145 
146     function tokenIPFS(uint256 _tokenId) public view returns (string) {
147         require(exists(_tokenId));
148         return tokenIPFSs[_tokenId];
149     }
150 
151     /**
152     * @dev Returns whether the specified token exists
153     * @param _tokenId uint256 ID of the token to query the existence of
154     * @return whether the token exists
155     */
156     function exists(uint256 _tokenId) public view returns (bool) {
157         address owner = tokenOwner[_tokenId];
158         return owner != address(0);
159     }
160 
161     /**
162      * Constructor function
163      *
164      * Initializes contract with initial supply tokens to the creator of the contract
165      */
166     /* constructor( */
167     constructor(
168         string tokenName,
169         string tokenSymbol
170     ) public {
171         name = tokenName;
172         // Set the name for display purposes
173         symbol = tokenSymbol;
174         // Set the symbol for display purposes
175     }
176 
177     /**
178     * @dev Guarantees msg.sender is owner of the given token
179     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
180     */
181     modifier onlyOwnerOf(uint256 _tokenId) {
182         require(ownerOf(_tokenId) == msg.sender);
183         _;
184     }
185 
186     /**
187     * @dev Gets the total amount of tokens stored by the contract
188     * @return uint256 representing the total amount of tokens
189     */
190     function totalSupply() public view returns (uint256) {
191         return totalTokens;
192     }
193 
194     /**
195     * @dev Gets the balance of the specified address
196     * @param _owner address to query the balance of
197     * @return uint256 representing the amount owned by the passed address
198     */
199     function balanceOf(address _owner) public view returns (uint256) {
200         require(_owner != address(0));
201         return ownedTokens[_owner].length;
202     }
203 
204     /**
205     * @dev Gets the list of tokens owned by a given address
206     * @param _owner address to query the tokens of
207     * @return uint256[] representing the list of tokens owned by the passed address
208     */
209     function tokensOf(address _owner) public view returns (uint256[]) {
210         return ownedTokens[_owner];
211     }
212 
213     /**
214     * @dev Gets the owner of the specified token ID
215     * @param _tokenId uint256 ID of the token to query the owner of
216     * @return owner address currently marked as the owner of the given token ID
217     */
218     function ownerOf(uint256 _tokenId) public view returns (address) {
219         address owner = tokenOwner[_tokenId];
220         require(owner != address(0));
221         return owner;
222     }
223 
224     /**
225      * @dev Gets the approved address to take ownership of a given token ID
226      * @param _tokenId uint256 ID of the token to query the approval of
227      * @return address currently approved to take ownership of the given token ID
228      */
229     function approvedFor(uint256 _tokenId) public view returns (address) {
230         return tokenApprovals[_tokenId];
231     }
232 
233     /**
234     * @dev Transfers the ownership of a given token ID to another address
235     * @param _to address to receive the ownership of the given token ID
236     * @param _tokenId uint256 ID of the token to be transferred
237     */
238     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
239         clearApprovalAndTransfer(msg.sender, _to, _tokenId);
240     }
241 
242     /**
243     * @dev Approves another address to claim for the ownership of the given token ID
244     * @param _to address to be approved for the given token ID
245     * @param _tokenId uint256 ID of the token to be approved
246     */
247     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
248         address owner = ownerOf(_tokenId);
249         require(_to != owner);
250         if (approvedFor(_tokenId) != 0 || _to != 0) {
251             tokenApprovals[_tokenId] = _to;
252             emit Approval(owner, _to, _tokenId);
253         }
254     }
255 
256     /**
257     * @dev Claims the ownership of a given token ID
258     * @param _tokenId uint256 ID of the token being claimed by the msg.sender
259     */
260     function takeOwnership(uint256 _tokenId) public {
261         require(isApprovedFor(msg.sender, _tokenId));
262         clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
263     }
264 
265     // Mint an NFT - should this be a smart contract function dependent on CKr tokens?
266     function mint(
267         address _to,
268         uint256 _tokenId,
269         uint _batch,
270         uint _sequence,
271         uint _count,
272         uint256 _value,
273         string _type,
274         string _IPFS,
275         string _tokenURI
276     ) public /* onlyNonexistentToken(_tokenId) */
277     {
278         // Addresses for direct test (Ethereum wallet) and live test (Geth server)
279         require(
280             msg.sender == 0x979e636D308E86A2D9cB9B2eA5986d6E2f89FcC1 ||
281             msg.sender == 0x0fEB00CAe329050915035dF479Ce6DBf747b01Fd
282         );
283         require(_to != address(0));
284         require(nftValue[_tokenId] == 0);
285 
286         // Batch details - also available from the metadata endpoints
287         nftBatch[_tokenId] = _batch;
288         nftSequence[_tokenId] = _sequence;
289         nftCount[_tokenId] = _count;
290 
291         // Value in CKr + 7 trailing zeroes (to reflect Stellar)
292         nftValue[_tokenId] = _value;
293 
294         // Token type
295         nftType[_tokenId] = _type;
296 
297         // Metadata access via IPFS (canonical URL)
298         tokenIPFSs[_tokenId] = _IPFS;
299 
300         // Metadata access via API (canonical url - add /{platform} for custom-formatted data for your platform
301         nftURIs[_tokenId] = _tokenURI;
302 
303         addToken(_to, _tokenId);
304         emit Transfer(address(0), _to, _tokenId);
305     }
306 
307 
308     /**
309     * @dev Burns a specific token
310     * @param _tokenId uint256 ID of the token being burned by the msg.sender
311     */
312     function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
313         if (approvedFor(_tokenId) != 0) {
314             clearApproval(msg.sender, _tokenId);
315         }
316         removeToken(msg.sender, _tokenId);
317         emit Transfer(msg.sender, 0x0, _tokenId);
318     }
319 
320     /**
321      * @dev Tells whether the msg.sender is approved for the given token ID or not
322      * This function is not private so it can be extended in further implementations like the operatable ERC721
323      * @param _owner address of the owner to query the approval of
324      * @param _tokenId uint256 ID of the token to query the approval of
325      * @return bool whether the msg.sender is approved for the given token ID or not
326      */
327     function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
328         return approvedFor(_tokenId) == _owner;
329     }
330 
331     /**
332     * @dev Internal function to clear current approval and transfer the ownership of a given token ID
333     * @param _from address which you want to send tokens from
334     * @param _to address which you want to transfer the token to
335     * @param _tokenId uint256 ID of the token to be transferred
336     */
337     function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
338         require(_to != address(0));
339         require(_to != ownerOf(_tokenId));
340         require(ownerOf(_tokenId) == _from);
341 
342         clearApproval(_from, _tokenId);
343         removeToken(_from, _tokenId);
344         addToken(_to, _tokenId);
345         emit Transfer(_from, _to, _tokenId);
346     }
347 
348     /**
349     * @dev Internal function to clear current approval of a given token ID
350     * @param _tokenId uint256 ID of the token to be transferred
351     */
352     function clearApproval(address _owner, uint256 _tokenId) private {
353         require(ownerOf(_tokenId) == _owner);
354         tokenApprovals[_tokenId] = 0;
355         emit Approval(_owner, 0, _tokenId);
356     }
357 
358     /**
359     * @dev Internal function to add a token ID to the list of a given address
360     * @param _to address representing the new owner of the given token ID
361     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
362     */
363     function addToken(address _to, uint256 _tokenId) private {
364         require(tokenOwner[_tokenId] == address(0));
365         tokenOwner[_tokenId] = _to;
366         uint256 length = balanceOf(_to);
367         ownedTokens[_to].push(_tokenId);
368         ownedTokensIndex[_tokenId] = length;
369         totalTokens = totalTokens.add(1);
370     }
371 
372     /**
373     * @dev Internal function to remove a token ID from the list of a given address
374     * @param _from address representing the previous owner of the given token ID
375     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
376     */
377     function removeToken(address _from, uint256 _tokenId) private {
378         require(ownerOf(_tokenId) == _from);
379 
380         uint256 tokenIndex = ownedTokensIndex[_tokenId];
381         uint256 lastTokenIndex = balanceOf(_from).sub(1);
382         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
383 
384         tokenOwner[_tokenId] = 0;
385         ownedTokens[_from][tokenIndex] = lastToken;
386         ownedTokens[_from][lastTokenIndex] = 0;
387         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
388         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
389         // the lastToken to the first position, and then dropping the element placed in the last position of the list
390 
391         ownedTokens[_from].length--;
392         ownedTokensIndex[_tokenId] = 0;
393         ownedTokensIndex[lastToken] = tokenIndex;
394         totalTokens = totalTokens.sub(1);
395     }
396 
397     /**
398     * @dev Returns `true` if the contract implements `interfaceID` and `interfaceID` is not 0xffffffff, `false` otherwise
399     * @param  _interfaceID The interface identifier, as specified in ERC-165
400     */
401     function supportsInterface(bytes4 _interfaceID) public pure returns (bool) {
402 
403         if (_interfaceID == 0xffffffff) {
404             return false;
405         }
406         return _interfaceID == 0x01ffc9a7 ||  // From ERC721Base
407                _interfaceID == 0x7c0633c6 ||  // From ERC721Base
408                _interfaceID == 0x80ac58cd ||  // ERC721
409                _interfaceID == 0x5b5e139f;    // ERC712Metadata
410     }
411 }