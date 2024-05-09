1 pragma solidity 0.5.11;
2 
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others (`ERC165Checker`).
10  *
11  * For an implementation, see `ERC165`.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 contract IERC721 is IERC165 {
30     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
31     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
32     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
33 
34     /**
35      * @dev Returns the number of NFTs in `owner`'s account.
36      */
37     function balanceOf(address owner) public view returns (uint256 balance);
38 
39     /**
40      * @dev Returns the owner of the NFT specified by `tokenId`.
41      */
42     function ownerOf(uint256 tokenId) public view returns (address owner);
43 
44     /**
45      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
46      * another (`to`).
47      *
48      * 
49      *
50      * Requirements:
51      * - `from`, `to` cannot be zero.
52      * - `tokenId` must be owned by `from`.
53      * - If the caller is not `from`, it must be have been allowed to move this
54      * NFT by either `approve` or `setApproveForAll`.
55      */
56     function safeTransferFrom(address from, address to, uint256 tokenId) public;
57     /**
58      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
59      * another (`to`).
60      *
61      * Requirements:
62      * - If the caller is not `from`, it must be approved to move this NFT by
63      * either `approve` or `setApproveForAll`.
64      */
65     function transferFrom(address from, address to, uint256 tokenId) public;
66     function approve(address to, uint256 tokenId) public;
67     function getApproved(uint256 tokenId) public view returns (address operator);
68 
69     function setApprovalForAll(address operator, bool _approved) public;
70     function isApprovedForAll(address owner, address operator) public view returns (bool);
71 
72 
73     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
74 }
75 
76 
77 contract ICards is IERC721 {
78 
79     struct Batch {
80         uint48 userID;
81         uint16 size;
82     }
83 
84     function batches(uint index) public view returns (uint48 userID, uint16 size);
85 
86     function userIDToAddress(uint48 id) public view returns (address);
87 
88     function getDetails(
89         uint tokenId
90     )
91         public
92         view
93         returns (
94         uint16 proto,
95         uint8 quality
96     );
97 
98     function setQuality(
99         uint tokenId,
100         uint8 quality
101     ) public;
102 
103     function mintCards(
104         address to,
105         uint16[] memory _protos,
106         uint8[] memory _qualities
107     )
108         public
109         returns (uint);
110 
111     function mintCard(
112         address to,
113         uint16 _proto,
114         uint8 _quality
115     )
116         public
117         returns (uint);
118 
119     function burn(uint tokenId) public;
120 
121     function batchSize()
122         public
123         view
124         returns (uint);
125 }
126 
127 contract MigrationMigration {
128 
129     uint public batchIndex;
130     ICards public oldCards;
131     ICards public newCards;
132     uint public constant batchSize = 1251;
133 
134     constructor(ICards _oldCards, ICards _newCards) public {
135         oldCards = _oldCards;
136         newCards = _newCards;
137 
138     }
139 
140     event Migrated(uint batchIndex, uint startID);
141 
142     function migrate() public {
143 
144         (uint48 userID, uint16 size) = oldCards.batches(batchIndex * batchSize);
145         require(size > 0, "must be cards in this batch");
146         uint16[] memory protos = new uint16[](size);
147         uint8[] memory qualities = new uint8[](size);
148         uint startID = batchIndex * batchSize;
149         for (uint i = 0; i < size; i++) {
150             (protos[i], qualities[i]) = oldCards.getDetails(startID + i);
151         }
152         address user = oldCards.userIDToAddress(userID);
153         newCards.mintCards(user, protos, qualities);
154         emit Migrated(batchIndex, startID);
155         batchIndex++;
156     }
157 
158 }