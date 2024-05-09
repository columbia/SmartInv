1 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev These functions deal with verification of Merkle trees (hash trees),
9  */
10 library MerkleProof {
11     /**
12      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
13      * defined by `root`. For this, a `proof` must be provided, containing
14      * sibling hashes on the branch from the leaf to the root of the tree. Each
15      * pair of leaves and each pair of pre-images are assumed to be sorted.
16      */
17     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
18         bytes32 computedHash = leaf;
19 
20         for (uint256 i = 0; i < proof.length; i++) {
21             bytes32 proofElement = proof[i];
22 
23             if (computedHash <= proofElement) {
24                 // Hash(current computed hash + current element of the proof)
25                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
26             } else {
27                 // Hash(current element of the proof + current computed hash)
28                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
29             }
30         }
31 
32         // Check if the computed hash (root) is equal to the provided root
33         return computedHash == root;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/GSN/Context.sol
38 
39 pragma solidity ^0.6.0;
40 
41 /*
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with GSN meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address payable) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes memory) {
57         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
58         return msg.data;
59     }
60 }
61 
62 // File: @openzeppelin/contracts/access/Ownable.sol
63 
64 pragma solidity ^0.6.0;
65 
66 /**
67  * @dev Contract module which provides a basic access control mechanism, where
68  * there is an account (an owner) that can be granted exclusive access to
69  * specific functions.
70  *
71  * By default, the owner account will be the one that deploys the contract. This
72  * can later be changed with {transferOwnership}.
73  *
74  * This module is used through inheritance. It will make available the modifier
75  * `onlyOwner`, which can be applied to your functions to restrict their use to
76  * the owner.
77  */
78 contract Ownable is Context {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev Initializes the contract setting the deployer as the initial owner.
85      */
86     constructor () internal {
87         address msgSender = _msgSender();
88         _owner = msgSender;
89         emit OwnershipTransferred(address(0), msgSender);
90     }
91 
92     /**
93      * @dev Returns the address of the current owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public virtual onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Can only be called by the current owner.
122      */
123     function transferOwnership(address newOwner) public virtual onlyOwner {
124         require(newOwner != address(0), "Ownable: new owner is the zero address");
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 // File: contracts/Mintable.sol
131 
132 pragma solidity =0.6.11;
133 
134 interface Mintable {
135     function setTokenId(uint256 id, bytes32 sig) external;
136     function mint(address account, uint256 id, uint256 amount) external;
137 }
138 
139 // File: contracts/Minter.sol
140 
141 pragma solidity =0.6.11;
142 
143 
144 
145 
146 contract Minter is Ownable {
147     event Claimed(
148         uint256 index,
149         bytes32 sig,
150         address account,
151         uint256 count
152     );
153 
154     bytes32 public immutable merkleRoot;
155 
156     Mintable public mintable;
157 
158     mapping(uint256 => bool) public claimed;
159 
160     uint256 public nextId = 1;
161     mapping(bytes32 => uint256) public sigToTokenId;
162 
163     constructor(bytes32 _merkleRoot) public {
164         merkleRoot = _merkleRoot;
165     }
166 
167     function setMintable(Mintable _mintable) public onlyOwner {
168         require(address(mintable) == address(0), "Minter: Can't set Mintable contract twice");
169         mintable = _mintable;
170     }
171 
172     function merkleVerify(bytes32 node, bytes32[] memory proof) public view returns (bool) {
173         return MerkleProof.verify(proof, merkleRoot, node);
174     }
175 
176     function makeNode(
177         uint256 index,
178         bytes32 sig,
179         address account,
180         uint256 count
181     ) public pure returns (bytes32) {
182         return keccak256(abi.encodePacked(index, sig, account, count));
183     }
184 
185     function claim(
186         uint256 index,
187         bytes32 sig,
188         address account,
189         uint256 count,
190         bytes32[] memory proof
191     ) public {
192         require(address(mintable) != address(0), "Minter: Must have a mintable set");
193 
194         require(!claimed[index], "Minter: Can't claim a drop that's already been claimed");
195         claimed[index] = true;
196 
197         bytes32 node = makeNode(index, sig, account, count);
198         require(merkleVerify(node, proof), "Minter: merkle verification failed");
199 
200         uint256 id = sigToTokenId[sig];
201         if (id == 0) {
202             sigToTokenId[sig] = nextId;
203             mintable.setTokenId(nextId, sig);
204             id = nextId;
205 
206             nextId++;
207         }
208 
209         mintable.mint(account, id, count);
210 
211         emit Claimed(index, sig, account, count);
212     }
213 }