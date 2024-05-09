1 // File: @axie/contract-library/contracts/token/erc20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 
6 interface IERC20 {
7   event Transfer(address indexed _from, address indexed _to, uint256 _value);
8   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
9 
10   function totalSupply() external view returns (uint256 _supply);
11   function balanceOf(address _owner) external view returns (uint256 _balance);
12 
13   function approve(address _spender, uint256 _value) external returns (bool _success);
14   function allowance(address _owner, address _spender) external view returns (uint256 _value);
15 
16   function transfer(address _to, uint256 _value) external returns (bool _success);
17   function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
18 }
19 
20 // File: @axie/contract-library/contracts/access/HasAdmin.sol
21 
22 pragma solidity ^0.5.2;
23 
24 
25 contract HasAdmin {
26   event AdminChanged(address indexed _oldAdmin, address indexed _newAdmin);
27   event AdminRemoved(address indexed _oldAdmin);
28 
29   address public admin;
30 
31   modifier onlyAdmin {
32     require(msg.sender == admin);
33     _;
34   }
35 
36   constructor() internal {
37     admin = msg.sender;
38     emit AdminChanged(address(0), admin);
39   }
40 
41   function changeAdmin(address _newAdmin) external onlyAdmin {
42     require(_newAdmin != address(0));
43     emit AdminChanged(admin, _newAdmin);
44     admin = _newAdmin;
45   }
46 
47   function removeAdmin() external onlyAdmin {
48     emit AdminRemoved(admin);
49     admin = address(0);
50   }
51 }
52 
53 // File: @axie/contract-library/contracts/ownership/Withdrawable.sol
54 
55 pragma solidity ^0.5.2;
56 
57 
58 
59 
60 contract Withdrawable is HasAdmin {
61   function withdrawEther() external onlyAdmin {
62     msg.sender.transfer(address(this).balance);
63   }
64 
65   function withdrawToken(IERC20 _token) external onlyAdmin {
66     require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
67   }
68 }
69 
70 // File: IMerkleDistributor.sol
71 
72 pragma solidity ^0.5.2;
73 
74 
75 // Allows anyone to claim a token if they exist in a merkle root.
76 interface IMerkleDistributor {
77     // Returns the address of the token distributed by this contract.
78     function token() external view returns (address);
79     // Returns the merkle root of the merkle tree containing account balances available to claim.
80     function merkleRoot() external view returns (bytes32);
81     // Returns true if the index has been marked claimed.
82     function claimed(address account) external view returns (bool);
83     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
84     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
85 
86     // This event is triggered whenever a call to #claim succeeds.
87     event Claimed(uint256 index, address account, uint256 amount);
88 }
89 
90 // File: MerkleProof.sol
91 
92 pragma solidity ^0.5.2;
93 
94 
95 /**
96  * @dev These functions deal with verification of Merkle trees (hash trees),
97  */
98 library MerkleProof {
99     /**
100      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
101      * defined by `root`. For this, a `proof` must be provided, containing
102      * sibling hashes on the branch from the leaf to the root of the tree. Each
103      * pair of leaves and each pair of pre-images are assumed to be sorted.
104      */
105     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
106         bytes32 computedHash = leaf;
107 
108         for (uint256 i = 0; i < proof.length; i++) {
109             bytes32 proofElement = proof[i];
110 
111             if (computedHash <= proofElement) {
112                 // Hash(current computed hash + current element of the proof)
113                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
114             } else {
115                 // Hash(current element of the proof + current computed hash)
116                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
117             }
118         }
119 
120         // Check if the computed hash (root) is equal to the provided root
121         return computedHash == root;
122     }
123 }
124 
125 // File: MerkleDistributor.sol
126 
127 pragma solidity ^0.5.2;
128 
129 
130 
131 
132 
133 
134 contract MerkleDistributor is IMerkleDistributor, Withdrawable {
135     address public token;
136     bytes32 public merkleRoot;
137 
138     mapping(address => bool) public claimed;
139 
140     constructor(address token_, bytes32 merkleRoot_) public {
141         token = token_;
142         merkleRoot = merkleRoot_;
143     }
144 
145     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external {
146         require(!claimed[account], 'MerkleDistributor: Already claimed.');
147 
148         // Verify the merkle proof.
149         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
150         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
151 
152         // Mark it claimed and send the token.
153         claimed[account] = true;
154         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
155 
156         emit Claimed(index, account, amount);
157     }
158 }