1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.8.3;
4 
5 
6 
7 // Part: ERC721TokenReceiver
8 
9 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
10 interface ERC721TokenReceiver {
11     /// @notice Handle the receipt of an NFT
12     /// @dev The ERC721 smart contract calls this function on the recipient
13     ///  after a `transfer`. This function MAY throw to revert and reject the
14     ///  transfer. Return of other than the magic value MUST result in the
15     ///  transaction being reverted.
16     ///  Note: the contract address is always the message sender.
17     /// @param _operator The address which called `safeTransferFrom` function
18     /// @param _from The address which previously owned the token
19     /// @param _tokenId The NFT identifier which is being transferred
20     /// @param _data Additional data with no specified format
21     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
22     ///         unless throwing
23     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns(bytes4);
24 }
25 
26 // Part: EvohERC721
27 
28 contract EvohERC721 {
29 
30     string public name;
31     string public symbol;
32     uint256 public totalSupply;
33 
34     mapping(bytes4 => bool) public supportsInterface;
35 
36     struct UserData {
37         uint256 balance;
38         uint256[4] ownership;
39     }
40     mapping(address => UserData) userData;
41 
42     address[1024] tokenOwners;
43     address[1024] tokenApprovals;
44     mapping(uint256 => string) tokenURIs;
45 
46     mapping (address => mapping (address => bool)) private operatorApprovals;
47 
48     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
49     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
50     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
51     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
52     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
55     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
56     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
57 
58     constructor(string memory _name, string memory _symbol) {
59         name = _name;
60         symbol = _symbol;
61         supportsInterface[_INTERFACE_ID_ERC165] = true;
62         supportsInterface[_INTERFACE_ID_ERC721] = true;
63         supportsInterface[_INTERFACE_ID_ERC721_METADATA] = true;
64         supportsInterface[_INTERFACE_ID_ERC721_ENUMERABLE] = true;
65     }
66 
67     /// @notice Count all NFTs assigned to an owner
68     function balanceOf(address _owner) external view returns (uint256) {
69         require(_owner != address(0), "Query for zero address");
70         return userData[_owner].balance;
71     }
72 
73     /// @notice Find the owner of an NFT
74     function ownerOf(uint256 tokenId) public view returns (address) {
75         if (tokenId < 1024) {
76             address owner = tokenOwners[tokenId];
77             if (owner != address(0)) return owner;
78         }
79         revert("Query for nonexistent tokenId");
80     }
81 
82     function _transfer(address _from, address _to, uint256 _tokenId) internal {
83         require(_from != address(0));
84         require(_to != address(0));
85         address owner = ownerOf(_tokenId);
86         if (
87             msg.sender == owner ||
88             getApproved(_tokenId) == msg.sender ||
89             isApprovedForAll(owner, msg.sender)
90         ) {
91             delete tokenApprovals[_tokenId];
92             removeOwnership(_from, _tokenId);
93             addOwnership(_to, _tokenId);
94             emit Transfer(_from, _to, _tokenId);
95             return;
96         }
97         revert("Caller is not owner nor approved");
98     }
99 
100     /// @notice Transfers the ownership of an NFT from one address to another address
101     /// @dev Throws unless `msg.sender` is the current owner, an authorized
102     ///  operator, or the approved address for this NFT. Throws if `_from` is
103     ///  not the current owner. Throws if `_to` is the zero address. Throws if
104     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
105     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
106     ///  `onERC721Received` on `_to` and throws if the return value is not
107     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
108     /// @param _from The current owner of the NFT
109     /// @param _to The new owner
110     /// @param _tokenId The NFT to transfer
111     /// @param _data Additional data with no specified format, sent in call to `_to`
112     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
113         _transfer(_from, _to, _tokenId);
114         require(_checkOnERC721Received(_from, _to, _tokenId, _data), "Transfer to non ERC721 receiver");
115     }
116 
117     function removeOwnership(address _owner, uint256 _tokenId) internal {
118         UserData storage data = userData[_owner];
119         data.balance -= 1;
120         uint256 idx = _tokenId / 256;
121         uint256 bitfield = data.ownership[idx];
122         data.ownership[idx] = bitfield & ~(uint256(1) << (_tokenId % 256));
123     }
124 
125     function addOwnership(address _owner, uint256 _tokenId) internal {
126         tokenOwners[_tokenId] = _owner;
127         UserData storage data = userData[_owner];
128         data.balance += 1;
129         uint256 idx = _tokenId / 256;
130         uint256 bitfield = data.ownership[idx];
131         data.ownership[idx] = bitfield | uint256(1) << (_tokenId % 256);
132     }
133 
134     /// @notice Transfers the ownership of an NFT from one address to another address
135     /// @dev This works identically to the other function with an extra data parameter,
136     ///  except this function just sets data to "".
137     /// @param _from The current owner of the NFT
138     /// @param _to The new owner
139     /// @param _tokenId The NFT to transfer
140     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
141         safeTransferFrom(_from, _to, _tokenId, bytes(""));
142     }
143 
144     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
145     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
146     ///  THEY MAY BE PERMANENTLY LOST
147     /// @dev Throws unless `msg.sender` is the current owner, an authorized
148     ///  operator, or the approved address for this NFT. Throws if `_from` is
149     ///  not the current owner. Throws if `_to` is the zero address. Throws if
150     ///  `_tokenId` is not a valid NFT.
151     /// @param _from The current owner of the NFT
152     /// @param _to The new owner
153     /// @param _tokenId The NFT to transfer
154     function transferFrom(address _from, address _to, uint256 _tokenId) external {
155         _transfer(_from, _to, _tokenId);
156     }
157 
158         /// @notice Change or reaffirm the approved address for an NFT
159     function approve(address approved, uint256 tokenId) public {
160         address owner = ownerOf(tokenId);
161         require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
162             "Not owner nor approved for all"
163         );
164         tokenApprovals[tokenId] = approved;
165         emit Approval(owner, approved, tokenId);
166     }
167 
168     /// @notice Get the approved address for a single NFT
169     function getApproved(uint256 tokenId) public view returns (address) {
170         ownerOf(tokenId);
171         return tokenApprovals[tokenId];
172     }
173 
174     /// @notice Enable or disable approval for a third party ("operator") to manage
175     ///         all of `msg.sender`'s assets
176     function setApprovalForAll(address operator, bool approved) external {
177         operatorApprovals[msg.sender][operator] = approved;
178         emit ApprovalForAll(msg.sender, operator, approved);
179     }
180 
181     /// @notice Query if an address is an authorized operator for another address
182     function isApprovedForAll(address owner, address operator) public view returns (bool) {
183         return operatorApprovals[owner][operator];
184     }
185 
186     /// @notice Concatenates tokenId to baseURI and returns the string.
187     function tokenURI(uint256 tokenId) public view returns (string memory) {
188         ownerOf(tokenId);
189         return tokenURIs[tokenId];
190     }
191 
192     /// @notice Enumerate valid NFTs
193     function tokenByIndex(uint256 _index) external view returns (uint256) {
194         require(_index < totalSupply, "Index out of bounds");
195         return _index;
196     }
197 
198     /// @notice Enumerate NFTs assigned to an owner
199     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
200         UserData storage data = userData[_owner];
201         require (_index < data.balance, "Index out of bounds");
202         uint256 bitfield;
203         uint256 count;
204         for (uint256 i = 0; i < 1024; i++) {
205             uint256 key = i % 256;
206             if (key == 0) {
207                 bitfield = data.ownership[i / 256];
208             }
209             if ((bitfield >> key) & uint256(1) == 1) {
210                 if (count == _index) {
211                     return i;
212                 }
213                 count++;
214             }
215         }
216         revert();
217     }
218 
219     function _checkOnERC721Received(
220         address from,
221         address to,
222         uint256 tokenId,
223         bytes memory _data
224     )
225         private
226         returns (bool)
227     {
228         uint256 size;
229         // solhint-disable-next-line no-inline-assembly
230         assembly { size := extcodesize(to) }
231         if (size == 0) {
232             return true;
233         }
234 
235         (bool success, bytes memory returnData) = to.call{ value: 0 }(
236             abi.encodeWithSelector(
237                 ERC721TokenReceiver(to).onERC721Received.selector,
238                 msg.sender,
239                 from,
240                 tokenId,
241                 _data
242             )
243         );
244         require(success, "Transfer to non ERC721 receiver");
245         bytes4 returnValue = abi.decode(returnData, (bytes4));
246         return (returnValue == _ERC721_RECEIVED);
247     }
248 
249 }
250 
251 // File: Claimable.sol
252 
253 contract EvohClaimable is EvohERC721 {
254 
255     uint256 public maxTotalSupply;
256     bytes32 public hashRoot;
257     address public owner;
258     uint256 public startTime;
259 
260     struct ClaimData {
261         bytes32 root;
262         uint256 count;
263         uint256 limit;
264         mapping(address => bool) claimed;
265     }
266 
267     ClaimData[] public claimData;
268 
269     constructor(
270         string memory _name,
271         string memory _symbol,
272         bytes32 _hashRoot,
273         uint256 _maxTotalSupply,
274         uint256 _startTime
275     )
276         EvohERC721(_name, _symbol)
277     {
278         owner = msg.sender;
279         hashRoot = _hashRoot;
280         maxTotalSupply = _maxTotalSupply;
281         startTime = _startTime;
282     }
283 
284     function addClaimRoots(bytes32[] calldata _merkleRoots, uint256[] calldata _claimLimits) external {
285         require(msg.sender == owner);
286         for (uint256 i = 0; i < _merkleRoots.length; i++) {
287             ClaimData storage data = claimData.push();
288             data.root = _merkleRoots[i];
289             data.limit = _claimLimits[i];
290         }
291     }
292 
293     function isClaimed(uint256 _claimIndex, address _account) public view returns (bool) {
294         return claimData[_claimIndex].claimed[_account];
295     }
296 
297     /**
298         @notice Claim an NFT using an eligible account
299         @param _claimIndex Index of the claim hash to validate `_claimProof` against
300         @param _claimProof Proof to validate against the claim root
301      */
302     function claim(
303         uint256 _claimIndex,
304         bytes32[] calldata _claimProof
305     )
306         external
307     {
308         require(block.timestamp >= startTime, "Cannot claim before start time");
309         uint256 claimed = totalSupply;
310         require(maxTotalSupply > claimed, "All NFTs claimed");
311 
312         // Verify the claim
313         bytes32 node = keccak256(abi.encodePacked(msg.sender));
314         ClaimData storage data = claimData[_claimIndex];
315 
316         require(_claimIndex < claimData.length, "Invalid merkleIndex");
317         require(data.count < data.limit, "All NFTs claimed in this airdrop");
318         require(!data.claimed[msg.sender], "User has claimed in this airdrop");
319         require(verify(_claimProof, data.root, node), "Invalid claim proof");
320 
321         // Mark as claimed, write the hash and send the token.
322         data.count++;
323         data.claimed[msg.sender] = true;
324 
325         addOwnership(msg.sender, claimed);
326         emit Transfer(address(0), msg.sender, claimed);
327         totalSupply = claimed + 1;
328     }
329 
330      /**
331         @notice Submit NFT hashes on-chain.
332         @param _indexes Indexes of the hashes being added.
333         @param _hashes IPFS hashes being added.
334         @param _proofs Proofs for the IPFS hashes. These are checked against `hashRoot`.
335      */
336     function submitHashes(
337         uint256[] calldata _indexes,
338         string[] calldata _hashes,
339         bytes32[][] calldata _proofs
340     ) external {
341         require(_indexes.length == _proofs.length);
342         bytes32 root = hashRoot;
343         for (uint256 i = 0; i < _indexes.length; i++) {
344             bytes32 node = keccak256(abi.encodePacked(_indexes[i], _hashes[i]));
345             require(verify(_proofs[i], root, node), "Invalid hash proof");
346             tokenURIs[_indexes[i]] = _hashes[i];
347         }
348     }
349 
350     function verify(
351         bytes32[] calldata proof,
352         bytes32 root,
353         bytes32 leaf
354     )
355         internal
356         pure
357         returns (bool)
358     {
359         bytes32 computedHash = leaf;
360 
361         for (uint256 i = 0; i < proof.length; i++) {
362             bytes32 proofElement = proof[i];
363 
364             if (computedHash <= proofElement) {
365                 // Hash(current computed hash + current element of the proof)
366                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
367             } else {
368                 // Hash(current element of the proof + current computed hash)
369                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
370             }
371         }
372 
373         // Check if the computed hash (root) is equal to the provided root
374         return computedHash == root;
375     }
376 
377 }
