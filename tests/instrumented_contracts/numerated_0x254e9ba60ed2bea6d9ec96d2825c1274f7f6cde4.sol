1 pragma solidity ^0.6.0;
2 
3 
4 library MerkleProof {
5     /**
6      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
7      * defined by `root`. For this, a `proof` must be provided, containing
8      * sibling hashes on the branch from the leaf to the root of the tree. Each
9      * pair of leaves and each pair of pre-images are assumed to be sorted.
10      */
11     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
12         bytes32 computedHash = leaf;
13 
14         for (uint256 i = 0; i < proof.length; i++) {
15             bytes32 proofElement = proof[i];
16 
17             if (computedHash <= proofElement) {
18                 // Hash(current computed hash + current element of the proof)
19                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
20             } else {
21                 // Hash(current element of the proof + current computed hash)
22                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
23             }
24         }
25 
26         // Check if the computed hash (root) is equal to the provided root
27         return computedHash == root;
28     }
29 }
30 
31 
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address payable) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes memory) {
110         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
111         return msg.data;
112     }
113 }
114 
115 
116 contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor () internal {
125         address msgSender = _msgSender();
126         _owner = msgSender;
127         emit OwnershipTransferred(address(0), msgSender);
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(_owner == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         emit OwnershipTransferred(_owner, address(0));
154         _owner = address(0);
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         emit OwnershipTransferred(_owner, newOwner);
164         _owner = newOwner;
165     }
166 }
167 
168 
169 
170 contract ClaimContract is Ownable{
171 
172     using MerkleProof for bytes;
173     uint256 claimIteration = 0;
174     address ERC20_CONTRACT;
175     bytes32 public merkleRoot;
176     mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
177     
178     event Claimed(uint256 index, address sender, uint256 amount);
179 
180     constructor(address contractAddress) public Ownable(){
181         ERC20_CONTRACT = contractAddress;
182     }
183 
184     function isClaimed(uint256 index) public view returns (bool) {
185         uint256 claimedWordIndex = index / 256;
186         uint256 claimedBitIndex = index % 256;
187         uint256 claimedWord = claimedBitMap[claimIteration][claimedWordIndex];
188         uint256 mask = (1 << claimedBitIndex);
189         return claimedWord & mask == mask;
190     }
191 
192     function _setClaimed(uint256 index) private {
193         uint256 claimedWordIndex = index / 256;
194         uint256 claimedBitIndex = index % 256;
195         claimedBitMap[claimIteration][claimedWordIndex] = claimedBitMap[claimIteration][claimedWordIndex] | (1 << claimedBitIndex);
196     }
197 
198     function updateMerkleRootHash(bytes32 root) public onlyOwner{
199         merkleRoot=root;
200         claimIteration++;
201     }   
202 
203     function updateContractAddress(address contractAddress) public onlyOwner{
204         ERC20_CONTRACT = contractAddress;
205     } 
206 
207     function fundsInContract() public view returns(uint256){
208         return IERC20(ERC20_CONTRACT).balanceOf(address(this));
209     }
210 
211     function withdrawALT() public onlyOwner{
212         IERC20(ERC20_CONTRACT).transfer(msg.sender,IERC20(ERC20_CONTRACT).balanceOf(address(this)));
213     }
214 
215     function claim(uint256 index,address account,uint256 amount, bytes32[] calldata merkleProof) external{
216         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
217 
218         // Verify the merkle proof.
219         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
220         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
221 
222         // Mark it claimed and send the token.
223         _setClaimed(index);
224         require(IERC20(ERC20_CONTRACT).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
225 
226         emit Claimed(index, account, amount);
227     }
228 }