1 // SPDX-License-Identifier: MIT
2 
3 pragma experimental ABIEncoderV2;
4 pragma solidity 0.6.12;
5 
6 
7 // 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 // 
83 /**
84  * @dev These functions deal with verification of Merkle trees (hash trees),
85  */
86 library MerkleProof {
87     /**
88      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
89      * defined by `root`. For this, a `proof` must be provided, containing
90      * sibling hashes on the branch from the leaf to the root of the tree. Each
91      * pair of leaves and each pair of pre-images are assumed to be sorted.
92      */
93     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
94         bytes32 computedHash = leaf;
95 
96         for (uint256 i = 0; i < proof.length; i++) {
97             bytes32 proofElement = proof[i];
98 
99             if (computedHash <= proofElement) {
100                 // Hash(current computed hash + current element of the proof)
101                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
102             } else {
103                 // Hash(current element of the proof + current computed hash)
104                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
105             }
106         }
107 
108         // Check if the computed hash (root) is equal to the provided root
109         return computedHash == root;
110     }
111 }
112 
113 // 
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with GSN meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address payable) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes memory) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 // 
136 /**
137  * @dev Contract module which provides a basic access control mechanism, where
138  * there is an account (an owner) that can be granted exclusive access to
139  * specific functions.
140  *
141  * By default, the owner account will be the one that deploys the contract. This
142  * can later be changed with {transferOwnership}.
143  *
144  * This module is used through inheritance. It will make available the modifier
145  * `onlyOwner`, which can be applied to your functions to restrict their use to
146  * the owner.
147  */
148 contract Ownable is Context {
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     /**
154      * @dev Initializes the contract setting the deployer as the initial owner.
155      */
156     constructor () internal {
157         address msgSender = _msgSender();
158         _owner = msgSender;
159         emit OwnershipTransferred(address(0), msgSender);
160     }
161 
162     /**
163      * @dev Returns the address of the current owner.
164      */
165     function owner() public view returns (address) {
166         return _owner;
167     }
168 
169     /**
170      * @dev Throws if called by any account other than the owner.
171      */
172     modifier onlyOwner() {
173         require(_owner == _msgSender(), "Ownable: caller is not the owner");
174         _;
175     }
176 
177     /**
178      * @dev Leaves the contract without owner. It will not be possible to call
179      * `onlyOwner` functions anymore. Can only be called by the current owner.
180      *
181      * NOTE: Renouncing ownership will leave the contract without an owner,
182      * thereby removing any functionality that is only available to the owner.
183      */
184     function renounceOwnership() public virtual onlyOwner {
185         emit OwnershipTransferred(_owner, address(0));
186         _owner = address(0);
187     }
188 
189     /**
190      * @dev Transfers ownership of the contract to a new account (`newOwner`).
191      * Can only be called by the current owner.
192      */
193     function transferOwnership(address newOwner) public virtual onlyOwner {
194         require(newOwner != address(0), "Ownable: new owner is the zero address");
195         emit OwnershipTransferred(_owner, newOwner);
196         _owner = newOwner;
197     }
198 }
199 
200 // 
201 // Allows anyone to claim a token if they exist in a merkle root.
202 interface IMerkleDistributor {
203   // This event is triggered whenever a call to #claim succeeds.
204   event Claimed(uint256 index, address account, uint256 amount);
205 
206   // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
207   function claim(
208     uint256 index,
209     address account,
210     uint256 amount,
211     bytes32[] calldata merkleProof
212   ) external;
213 
214   // Returns the address of the token distributed by this contract.
215   function token() external view returns (address);
216 
217   // Returns the merkle root of the merkle tree containing account balances available to claim.
218   function merkleRoot() external view returns (bytes32);
219 
220   // Returns true if the index has been marked claimed.
221   function isClaimed(uint256 index) external view returns (bool);
222 
223   // Returns the block timestamp when claims will end
224   function endTime() external view returns (uint256);
225 
226   // Returns true if the claim period has not ended.
227   function isActive() external view returns (bool);
228 }
229 
230 // 
231 contract MerkleDistributor is IMerkleDistributor, Ownable {
232   address public immutable override token;
233   bytes32 public immutable override merkleRoot;
234   uint256 public immutable override endTime;
235 
236   // This is a packed array of booleans.
237   mapping(uint256 => uint256) private _claimedBitMap;
238 
239   constructor(
240     address _token,
241     bytes32 _merkleRoot,
242     uint256 _endTime
243   ) public {
244     token = _token;
245     merkleRoot = _merkleRoot;
246     require(block.timestamp < _endTime, "Invalid endTime");
247     endTime = _endTime;
248   }
249 
250   /** @dev Modifier to check that claim period is active.*/
251   modifier whenActive() {
252     require(isActive(), "Claim period has ended");
253     _;
254   }
255 
256   function claim(
257     uint256 _index,
258     address _account,
259     uint256 _amount,
260     bytes32[] calldata merkleProof
261   ) external override whenActive {
262     require(!isClaimed(_index), "Drop already claimed");
263 
264     // Verify the merkle proof.
265     bytes32 node = keccak256(abi.encodePacked(_index, _account, _amount));
266     require(MerkleProof.verify(merkleProof, merkleRoot, node), "Invalid proof");
267 
268     // Mark it claimed and send the token.
269     _setClaimed(_index);
270     require(IERC20(token).transfer(_account, _amount), "Transfer failed");
271 
272     emit Claimed(_index, _account, _amount);
273   }
274 
275   function isClaimed(uint256 _index) public view override returns (bool) {
276     uint256 claimedWordIndex = _index / 256;
277     uint256 claimedBitIndex = _index % 256;
278     uint256 claimedWord = _claimedBitMap[claimedWordIndex];
279     uint256 mask = (1 << claimedBitIndex);
280     return claimedWord & mask == mask;
281   }
282 
283   function isActive() public view override returns (bool) {
284     return block.timestamp < endTime;
285   }
286 
287   function recoverERC20(address _tokenAddress, uint256 _tokenAmount) public onlyOwner {
288     IERC20(_tokenAddress).transfer(owner(), _tokenAmount);
289   }
290 
291   function _setClaimed(uint256 _index) private {
292     uint256 claimedWordIndex = _index / 256;
293     uint256 claimedBitIndex = _index % 256;
294     _claimedBitMap[claimedWordIndex] = _claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
295   }
296 }