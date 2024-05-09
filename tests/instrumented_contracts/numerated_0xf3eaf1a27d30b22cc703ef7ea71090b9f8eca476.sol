1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.6;
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     /**
9      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
10      */
11     function toString(uint256 value) internal pure returns (string memory) {
12         // Inspired by OraclizeAPI's implementation - MIT licence
13         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 }
33 
34 /**
35  * @dev These functions deal with verification of Merkle trees (hash trees),
36  */
37 library MerkleProof {
38     /**
39      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
40      * defined by `root`. For this, a `proof` must be provided, containing
41      * sibling hashes on the branch from the leaf to the root of the tree. Each
42      * pair of leaves and each pair of pre-images are assumed to be sorted.
43      */
44     function verify(
45         bytes32[] memory proof,
46         bytes32 root,
47         bytes32 leaf
48     ) internal pure returns (bool) {
49         bytes32 computedHash = leaf;
50 
51         for (uint256 i = 0; i < proof.length; i++) {
52             bytes32 proofElement = proof[i];
53 
54             if (computedHash <= proofElement) {
55                 // Hash(current computed hash + current element of the proof)
56                 computedHash = keccak256(
57                     abi.encodePacked(computedHash, proofElement)
58                 );
59             } else {
60                 // Hash(current element of the proof + current computed hash)
61                 computedHash = keccak256(
62                     abi.encodePacked(proofElement, computedHash)
63                 );
64             }
65         }
66 
67         // Check if the computed hash (root) is equal to the provided root
68         return computedHash == root;
69     }
70 }
71 
72 abstract contract Context {
73     function _msgSender() internal view virtual returns (address) {
74         return msg.sender;
75     }
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     event OwnershipTransferred(
81         address indexed previousOwner,
82         address indexed newOwner
83     );
84 
85     constructor() {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() external virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105     function transferOwnership(address newOwner) external virtual onlyOwner {
106         require(
107             newOwner != address(0),
108             "Ownable: new owner is the zero address"
109         );
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113 }
114 
115 contract PT_Airdrop is Ownable {
116     uint256 internal constant ONE = 10**18;
117 
118     using Strings for uint256;
119 
120     address public platformToken;
121 
122     mapping(address => bool) public claimed;
123 
124     bytes32 merkleRoot =
125         0x3430b672b1f51479da9176524ddd0a41d13512128907c6d5321748299c23ed1f;
126 
127     constructor(address _platformToken) {
128         platformToken = _platformToken;
129     }
130 
131     function setPlatformToken(address _platformToken) external onlyOwner {
132         platformToken = _platformToken;
133     }
134 
135     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
136         merkleRoot = _merkleRoot;
137     }
138 
139     function verifyClaim(
140         address _account,
141         uint256 _vestedAmount,
142         uint256 _nonVestedAmount,
143         bytes32[] calldata _merkleProof
144     ) public view returns (bool) {
145         bytes32 node = keccak256(
146             abi.encodePacked(_vestedAmount, _account, _nonVestedAmount)
147         );
148         return MerkleProof.verify(_merkleProof, merkleRoot, node);
149     }
150 
151     function showElements(
152         address _account,
153         uint256 _vestedAmount,
154         uint256 _nonVestedAmount
155     ) public pure returns (bytes memory) {
156         return abi.encodePacked(_vestedAmount, _account, _nonVestedAmount);
157     }
158 
159     address[] internal vestedAddresses;
160 
161     function claim(
162         uint256 _vestedAmount,
163         uint256 _nonVestedAmount,
164         bytes32[] calldata _merkleProof
165     ) external {
166         require(!claimed[_msgSender()], "claimed");
167         require(
168             verifyClaim(
169                 _msgSender(),
170                 _vestedAmount,
171                 _nonVestedAmount,
172                 _merkleProof
173             ),
174             "not eligible for a claim"
175         );
176         claimed[_msgSender()] = true;
177         PlatformToken(platformToken).autoAirdrop(
178             _msgSender(),
179             _nonVestedAmount
180         );
181 
182         vestedAddresses.push(_msgSender());
183         PlatformToken(platformToken).distributeVest(
184             vestedAddresses,
185             _vestedAmount
186         );
187         delete vestedAddresses;
188     }
189 }
190 
191 interface PlatformToken {
192     function autoAirdrop(address _to, uint256 _amount) external;
193 
194     function distributeVest(address[] calldata vestedAddresses, uint256 amount)
195         external;
196 }