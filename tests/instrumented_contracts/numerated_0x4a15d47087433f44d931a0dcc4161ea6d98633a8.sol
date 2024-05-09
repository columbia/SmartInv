1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 library MerkleProof {
7     /**
8      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
9      * defined by `root`. For this, a `proof` must be provided, containing
10      * sibling hashes on the branch from the leaf to the root of the tree. Each
11      * pair of leaves and each pair of pre-images are assumed to be sorted.
12      */
13     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
14         bytes32 computedHash = leaf;
15 
16         for (uint256 i = 0; i < proof.length; i++) {
17             bytes32 proofElement = proof[i];
18 
19             if (computedHash <= proofElement) {
20                 // Hash(current computed hash + current element of the proof)
21                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
22             } else {
23                 // Hash(current element of the proof + current computed hash)
24                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
25             }
26         }
27 
28         // Check if the computed hash (root) is equal to the provided root
29         return computedHash == root;
30     }
31 }
32 
33 
34 interface IFlashToken {
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address account) external view returns (uint256);
38 
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     function approve(address spender, uint256 amount) external returns (bool);
42 
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     function transferFrom(
46         address sender,
47         address recipient,
48         uint256 amount
49     ) external returns (bool);
50 
51     function mint(address to, uint256 value) external returns (bool);
52 
53     function burn(uint256 value) external returns (bool);
54 }
55 
56 
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address payable) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes memory) {
63         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
64         return msg.data;
65     }
66 }
67 
68 
69 contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev Initializes the contract setting the deployer as the initial owner.
76      */
77     constructor () internal {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     /**
84      * @dev Returns the address of the current owner.
85      */
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the owner.
92      */
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     /**
99      * @dev Leaves the contract without owner. It will not be possible to call
100      * `onlyOwner` functions anymore. Can only be called by the current owner.
101      *
102      * NOTE: Renouncing ownership will leave the contract without an owner,
103      * thereby removing any functionality that is only available to the owner.
104      */
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Can only be called by the current owner.
113      */
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         emit OwnershipTransferred(_owner, newOwner);
117         _owner = newOwner;
118     }
119 }
120 
121 
122 
123 
124 contract ClaimContract is Ownable{
125     using MerkleProof for bytes;
126     uint256 public EXPIRY_TIME;
127     address public FLASH_CONTRACT;
128     bytes32 public merkleRoot;
129     mapping(uint256 => uint256) private claimedBitMap;
130 
131     event Claimed(uint256 index, address sender, uint256 amount);
132     
133     constructor(address contractAddress, bytes32 rootHash, uint256 totalDays) public {
134         FLASH_CONTRACT = contractAddress;
135         merkleRoot = rootHash;
136         EXPIRY_TIME = block.timestamp + totalDays;
137     }
138 
139     function updateRootAndTime(bytes32 rootHash, uint256 totalDays) external onlyOwner {
140         merkleRoot = rootHash;
141         EXPIRY_TIME = block.timestamp + totalDays;
142         renounceOwnership();
143     }
144 
145     function isClaimed(uint256 index) public view returns (bool) {
146         uint256 claimedWordIndex = index / 256;
147         uint256 claimedBitIndex = index % 256;
148         uint256 claimedWord = claimedBitMap[claimedWordIndex];
149         uint256 mask = (1 << claimedBitIndex);
150         return claimedWord & mask == mask;
151     }
152 
153     function _setClaimed(uint256 index) private {
154         uint256 claimedWordIndex = index / 256;
155         uint256 claimedBitIndex = index % 256;
156         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
157     }
158 
159     function claim(
160         uint256 index,
161         address account,
162         uint256 amount,
163         bytes32[] calldata merkleProof
164     ) external {
165         require(block.timestamp <= EXPIRY_TIME, "MerkleDistributor: Deadline expired");
166 
167         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
168 
169         // Verify the merkle proof.
170         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
171         require(MerkleProof.verify(merkleProof, merkleRoot, node), "MerkleDistributor: Invalid proof.");
172 
173         // Mark it claimed and send the token.
174         _setClaimed(index);
175         require(IFlashToken(FLASH_CONTRACT).mint(account, amount), "MerkleDistributor: Transfer failed.");
176 
177         emit Claimed(index, account, amount);
178     }
179 
180     function destroy() external {
181         require(block.timestamp >= EXPIRY_TIME, "MerkleDistributor: Deadline not expired");
182         selfdestruct(address(0));
183     }
184 }