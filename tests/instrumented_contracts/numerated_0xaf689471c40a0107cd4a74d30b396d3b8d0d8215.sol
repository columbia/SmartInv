1 // SPDX-License-Identifier: MIT AND GPL-v3-or-later
2 pragma solidity 0.8.1;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Returns the address of the current owner.
23      */
24     function owner() public view returns (address) {
25         return _owner;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(isOwner(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     /**
37      * @dev Returns true if the caller is the current owner.
38      */
39     function isOwner() public view returns (bool) {
40         return _msgSender() == _owner;
41     }
42 
43     /**
44      * @dev Leaves the contract without owner. It will not be possible to call
45      * `onlyOwner` functions anymore. Can only be called by the current owner.
46      *
47      * NOTE: Renouncing ownership will leave the contract without an owner,
48      * thereby removing any functionality that is only available to the owner.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Transfers ownership of the contract to a new account (`newOwner`).
57      * Can only be called by the current owner.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers ownership of the contract to a new account (`newOwner`).
65      */
66     function _transferOwnership(address newOwner) internal {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 
74 contract CloneFactory {
75     function createClone(address target, bytes32 salt) internal returns (address result) {
76         bytes20 targetBytes = bytes20(target);
77         assembly {
78             let clone := mload(0x40)
79             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
80             mstore(add(clone, 0x14), targetBytes)
81             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
82             result := create2(0, clone, 0x37, salt)
83         }
84   }
85   
86   function computeCloneAddress(address target, bytes32 salt) internal view returns (address) {
87         bytes20 targetBytes = bytes20(target);
88         bytes32 bytecodeHash;
89         assembly {
90             let clone := mload(0x40)
91             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
92             mstore(add(clone, 0x14), targetBytes)
93             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
94             bytecodeHash := keccak256(clone, 0x37)
95         }
96         bytes32 _data = keccak256(
97             abi.encodePacked(bytes1(0xff), address(this), salt, bytecodeHash)
98         );
99         return address(bytes20(_data << 96));
100     }
101     
102     function isClone(address target, address query) internal view returns (bool result) {
103         bytes20 targetBytes = bytes20(target);
104         assembly {
105             let clone := mload(0x40)
106             mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
107             mstore(add(clone, 0xa), targetBytes)
108             mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
109             
110             let other := add(clone, 0x40)
111             extcodecopy(query, other, 0, 0x2d)
112             result := and(
113                 eq(mload(clone), mload(other)),
114                 eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
115             )
116         }
117     }
118 }
119 
120 
121 library MerkleProof {
122     /**
123      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
124      * defined by `root`. For this, a `proof` must be provided, containing
125      * sibling hashes on the branch from the leaf to the root of the tree. Each
126      * pair of leaves and each pair of pre-images are assumed to be sorted.
127      */
128     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
129         bytes32 computedHash = leaf;
130 
131         for (uint256 i = 0; i < proof.length; i++) {
132             bytes32 proofElement = proof[i];
133 
134             if (computedHash <= proofElement) {
135                 // Hash(current computed hash + current element of the proof)
136                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
137             } else {
138                 // Hash(current element of the proof + current computed hash)
139                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
140             }
141         }
142 
143         // Check if the computed hash (root) is equal to the provided root
144         return computedHash == root;
145     }
146 }
147 
148 
149 interface IERC20 {
150     function transfer(address recipient, uint256 amount) external returns (bool);
151     function balanceOf(address account) external view returns (uint256);
152 }
153 
154 
155 interface IERC721 {
156     function safeTransferFrom(address from, address to, uint256 tokenId) external;
157     function ownerOf(uint256 tokenId) external view returns (address owner);
158 }
159 
160 
161 library Address {
162     /**
163      * @dev Returns true if `account` is a contract.
164      *
165      * [IMPORTANT]
166      * ====
167      * It is unsafe to assume that an address for which this function returns
168      * false is an externally-owned account (EOA) and not a contract.
169      *
170      * Among others, `isContract` will return false for the following
171      * types of addresses:
172      *
173      *  - an externally-owned account
174      *  - a contract in construction
175      *  - an address where a contract will be created
176      *  - an address where a contract lived, but was destroyed
177      * ====
178      */
179     function isContract(address account) internal view returns (bool) {
180         // This method relies on extcodesize, which returns 0 for contracts in
181         // construction, since the code is only stored at the end of the
182         // constructor execution.
183 
184         uint256 size;
185         // solhint-disable-next-line no-inline-assembly
186         assembly { size := extcodesize(account) }
187         return size > 0;
188     }
189 }
190 
191 
192 library SafeERC20 {
193     using Address for address;
194 
195     function safeTransfer(IERC20 token, address to, uint256 value) internal {
196         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
197     }
198 
199     /**
200      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
201      * on the return value: the return value is optional (but if data is returned, it must not be false).
202      * @param token The token targeted by the call.
203      * @param data The call data (encoded using abi.encode or one of its variants).
204      */
205     function callOptionalReturn(IERC20 token, bytes memory data) private {
206         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
207         // we're implementing it ourselves.
208 
209         // A Solidity high level call has three parts:
210         //  1. The target address is checked to verify it contains contract code
211         //  2. The call itself is made, and success asserted
212         //  3. The return value is decoded, which in turn checks the size of the returned data.
213         // solhint-disable-next-line max-line-length
214         require(address(token).isContract(), "SafeERC20: call to non-contract");
215 
216         // solhint-disable-next-line avoid-low-level-calls
217         (bool success, bytes memory returndata) = address(token).call(data);
218         require(success, "SafeERC20: low-level call failed");
219 
220         if (returndata.length > 0) { // Return data is optional
221             // solhint-disable-next-line max-line-length
222             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
223         }
224     }
225 }
226 
227 
228 interface IAstrodrop {
229     // Returns the address of the token distributed by this contract.
230     function token() external view returns (address);
231     // Returns the merkle root of the merkle tree containing account balances available to claim.
232     function merkleRoot() external view returns (bytes32);
233     // Returns true if the index has been marked claimed.
234     function isClaimed(uint256 index) external view returns (bool);
235     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
236     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
237 
238     // This event is triggered whenever a call to #claim succeeds.
239     event Claimed(uint256 index, address account, uint256 amount);
240 }
241 
242 
243 contract Astrodrop is IAstrodrop, Ownable {
244     using SafeERC20 for IERC20;
245 
246     address public override token;
247     bytes32 public override merkleRoot;
248     bool public initialized;
249     uint256 public expireTimestamp;
250 
251     // This is a packed array of booleans.
252     mapping(uint256 => uint256) public claimedBitMap;
253 
254     function init(address owner_, address token_, bytes32 merkleRoot_, uint256 expireTimestamp_) external {
255         require(!initialized, "Astrodrop: Initialized");
256         initialized = true;
257 
258         token = token_;
259         merkleRoot = merkleRoot_;
260         expireTimestamp = expireTimestamp_;
261         
262         _transferOwnership(owner_);
263     }
264 
265     function isClaimed(uint256 index) public view override returns (bool) {
266         uint256 claimedWordIndex = index / 256;
267         uint256 claimedBitIndex = index % 256;
268         uint256 claimedWord = claimedBitMap[claimedWordIndex];
269         uint256 mask = (1 << claimedBitIndex);
270         return claimedWord & mask == mask;
271     }
272 
273     function _setClaimed(uint256 index) private {
274         uint256 claimedWordIndex = index / 256;
275         uint256 claimedBitIndex = index % 256;
276         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
277     }
278 
279     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
280         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
281 
282         // Verify the merkle proof.
283         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
284         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'Astrodrop: Invalid proof');
285 
286         // Mark it claimed and send the token.
287         _setClaimed(index);
288         IERC20(token).safeTransfer(account, amount);
289 
290         emit Claimed(index, account, amount);
291     }
292 
293     function sweep(address token_, address target) external onlyOwner {
294         require(block.timestamp >= expireTimestamp || token_ != token, "Astrodrop: Not expired");
295         IERC20 tokenContract = IERC20(token_);
296         uint256 balance = tokenContract.balanceOf(address(this));
297         tokenContract.safeTransfer(target, balance);
298     }
299 }
300 
301 
302 contract AstrodropERC721 is IAstrodrop, Ownable {
303     using SafeERC20 for IERC20;
304 
305     address public override token;
306     bytes32 public override merkleRoot;
307     bool public initialized;
308     uint256 public expireTimestamp;
309 
310     // This is a packed array of booleans.
311     mapping(uint256 => uint256) public claimedBitMap;
312 
313     function init(address owner_, address token_, bytes32 merkleRoot_, uint256 expireTimestamp_) external {
314         require(!initialized, "Astrodrop: Initialized");
315         initialized = true;
316 
317         token = token_;
318         merkleRoot = merkleRoot_;
319         expireTimestamp = expireTimestamp_;
320         
321         _transferOwnership(owner_);
322     }
323 
324     function isClaimed(uint256 index) public view override returns (bool) {
325         uint256 claimedWordIndex = index / 256;
326         uint256 claimedBitIndex = index % 256;
327         uint256 claimedWord = claimedBitMap[claimedWordIndex];
328         uint256 mask = (1 << claimedBitIndex);
329         return claimedWord & mask == mask;
330     }
331 
332     function _setClaimed(uint256 index) private {
333         uint256 claimedWordIndex = index / 256;
334         uint256 claimedBitIndex = index % 256;
335         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
336     }
337 
338     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
339         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
340 
341         // Verify the merkle proof.
342         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
343         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'Astrodrop: Invalid proof');
344 
345         // Mark it claimed and send the token.
346         _setClaimed(index);
347         IERC721 tokenContract = IERC721(token);
348         tokenContract.safeTransferFrom(tokenContract.ownerOf(amount), account, amount);
349 
350         emit Claimed(index, account, amount);
351     }
352 
353     function sweep(address token_, address target) external onlyOwner {
354         require(block.timestamp >= expireTimestamp || token_ != token, "Astrodrop: Not expired");
355         IERC20 tokenContract = IERC20(token_);
356         uint256 balance = tokenContract.balanceOf(address(this));
357         tokenContract.safeTransfer(target, balance);
358     }
359 }
360 
361 
362 contract AstrodropFactory is CloneFactory {
363     event CreateAstrodrop(address astrodrop, bytes32 ipfsHash);
364 
365     function createAstrodrop(
366         address template,
367         address token,
368         bytes32 merkleRoot,
369         uint256 expireTimestamp,
370         bytes32 salt,
371         bytes32 ipfsHash
372     ) external returns (Astrodrop drop) {
373         drop = Astrodrop(createClone(template, salt));
374         drop.init(msg.sender, token, merkleRoot, expireTimestamp);
375         emit CreateAstrodrop(address(drop), ipfsHash);
376     }
377 
378     function computeAstrodropAddress(
379         address template,
380         bytes32 salt
381     ) external view returns (address) {
382         return computeCloneAddress(template, salt);
383     }
384     
385     function isAstrodrop(address template, address query) external view returns (bool) {
386         return isClone(template, query);
387     }
388 }