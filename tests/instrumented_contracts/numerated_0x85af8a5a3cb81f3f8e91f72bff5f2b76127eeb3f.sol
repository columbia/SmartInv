1 pragma solidity >=0.5.0;
2 
3 // Allows anyone to claim a token if they exist in a merkle root.
4 interface IMerkleDistributor {
5     // Returns the address of the token distributed by this contract.
6     function token() external view returns (address);
7     // Returns the merkle root of the merkle tree containing account balances available to claim.
8     function merkleRoot() external view returns (bytes32);
9     // Returns true if the index has been marked claimed.
10     function isClaimed(uint256 index) external view returns (bool);
11     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
12     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
13 
14     // This event is triggered whenever a call to #claim succeeds.
15     event Claimed(uint256 index, address account, uint256 amount);
16 }
17 
18 pragma solidity >=0.6.0 <0.8.0;
19 
20 /**
21  * @dev These functions deal with verification of Merkle trees (hash trees),
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
31         bytes32 computedHash = leaf;
32 
33         for (uint256 i = 0; i < proof.length; i++) {
34             bytes32 proofElement = proof[i];
35 
36             if (computedHash <= proofElement) {
37                 // Hash(current computed hash + current element of the proof)
38                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
39             } else {
40                 // Hash(current element of the proof + current computed hash)
41                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
42             }
43         }
44 
45         // Check if the computed hash (root) is equal to the provided root
46         return computedHash == root;
47     }
48 }
49 
50 
51 
52 pragma solidity >=0.6.0 <0.8.0;
53 
54 /*
55  * @dev Provides information about the current execution context, including the
56  * sender of the transaction and its data. While these are generally available
57  * via msg.sender and msg.data, they should not be accessed in such a direct
58  * manner, since when dealing with GSN meta-transactions the account sending and
59  * paying for execution may not be the actual sender (as far as an application
60  * is concerned).
61  *
62  * This contract is only required for intermediate, library-like contracts.
63  */
64 abstract contract Context {
65     function _msgSender() internal view virtual returns (address payable) {
66         return msg.sender;
67     }
68 
69     function _msgData() internal view virtual returns (bytes memory) {
70         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
71         return msg.data;
72     }
73 }
74 
75 pragma solidity >=0.6.0 <0.8.0;
76 
77 /**
78  * @dev Interface of the ERC20 standard as defined in the EIP.
79  */
80 interface IERC20 {
81     /**
82      * @dev Returns the amount of tokens in existence.
83      */
84     function totalSupply() external view returns (uint256);
85 
86     /**
87      * @dev Returns the amount of tokens owned by `account`.
88      */
89     function balanceOf(address account) external view returns (uint256);
90 
91     /**
92      * @dev Moves `amount` tokens from the caller's account to `recipient`.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transfer(address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Returns the remaining number of tokens that `spender` will be
102      * allowed to spend on behalf of `owner` through {transferFrom}. This is
103      * zero by default.
104      *
105      * This value changes when {approve} or {transferFrom} are called.
106      */
107     function allowance(address owner, address spender) external view returns (uint256);
108 
109     /**
110      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * IMPORTANT: Beware that changing an allowance with this method brings the risk
115      * that someone may use both the old and the new allowance by unfortunate
116      * transaction ordering. One possible solution to mitigate this race
117      * condition is to first reduce the spender's allowance to 0 and set the
118      * desired value afterwards:
119      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address spender, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Moves `amount` tokens from `sender` to `recipient` using the
127      * allowance mechanism. `amount` is then deducted from the caller's
128      * allowance.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Emitted when `value` tokens are moved from one account (`from`) to
138      * another (`to`).
139      *
140      * Note that `value` may be zero.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 value);
143 
144     /**
145      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
146      * a call to {approve}. `value` is the new allowance.
147      */
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 
152 pragma solidity =0.6.11;
153 
154 
155 /**
156  * @dev Contract module which provides a basic access control mechanism, where
157  * there is an account (an owner) that can be granted exclusive access to
158  * specific functions.
159  *
160  * By default, the owner account will be the one that deploys the contract. This
161  * can later be changed with {transferOwnership}.
162  *
163  * This module is used through inheritance. It will make available the modifier
164  * `onlyOwner`, which can be applied to your functions to restrict their use to
165  * the owner.
166  */
167 abstract contract Ownable is Context {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor () internal {
176         address msgSender = _msgSender();
177         _owner = msgSender;
178         emit OwnershipTransferred(address(0), msgSender);
179     }
180 
181     /**
182      * @dev Returns the address of the current owner.
183      */
184     function owner() public view returns (address) {
185         return _owner;
186     }
187 
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         require(_owner == _msgSender(), "Ownable: caller is not the owner");
193         _;
194     }
195 
196     /**
197      * @dev Leaves the contract without owner. It will not be possible to call
198      * `onlyOwner` functions anymore. Can only be called by the current owner.
199      *
200      * NOTE: Renouncing ownership will leave the contract without an owner,
201      * thereby removing any functionality that is only available to the owner.
202      */
203     function renounceOwnership() public virtual onlyOwner {
204         emit OwnershipTransferred(_owner, address(0));
205         _owner = address(0);
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public virtual onlyOwner {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         emit OwnershipTransferred(_owner, newOwner);
215         _owner = newOwner;
216     }
217 }
218 //Interface for the Pepemon factory
219 //Contains only the mint method
220 interface IPepemonFactory{
221     function mint(
222         address _to,
223         uint256 _id,
224         uint256 _quantity,
225         bytes memory _data
226     ) external;
227 }
228 
229 contract MerkleDistributor is IMerkleDistributor, Ownable {
230     address public immutable override token;
231     bytes32 public immutable override merkleRoot;
232     uint public pepemonId;
233 
234     // This is a packed array of booleans.
235     mapping(uint256 => uint256) private claimedBitMap;
236 
237     constructor(address _pepemonFactory, bytes32 merkleRoot_, uint _pepemonId) public {
238         token = _pepemonFactory;
239         merkleRoot = merkleRoot_;
240         pepemonId = _pepemonId;
241     }
242 
243     function isClaimed(uint256 index) public view override returns (bool) {
244         uint256 claimedWordIndex = index / 256;
245         uint256 claimedBitIndex = index % 256;
246         uint256 claimedWord = claimedBitMap[claimedWordIndex];
247         uint256 mask = (1 << claimedBitIndex);
248         return claimedWord & mask == mask;
249     }
250 
251     function _setClaimed(uint256 index) private {
252         uint256 claimedWordIndex = index / 256;
253         uint256 claimedBitIndex = index % 256;
254         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
255     }
256     function setPepemonId(uint id) public onlyOwner{
257         pepemonId  = id;
258     }
259 
260     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
261         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
262 
263         // Verify the merkle proof.
264         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
265         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
266 
267         // Mark it claimed and send the token.
268         _setClaimed(index);
269         IPepemonFactory(token).mint(account, pepemonId ,1,"");
270 
271         emit Claimed(index, account, amount);
272     }
273 }