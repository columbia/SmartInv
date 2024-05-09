1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 interface INFT {
6     function transferFrom(
7         address _from,
8         address _to,
9         uint256 _tokenId
10     ) external;
11 }
12 
13 contract ElderGateway {
14 
15     /**
16     * @dev Details of locked NFT
17     * @param user owner of tokenId
18     * @param blockNo block.number when locked
19     */
20     struct Details {
21         address user;
22         uint256 blockNo;
23     }
24 
25     /**
26     * @dev mapping holds below values:
27     * collectionAddress => tokenId => Details  
28     */
29     mapping(address => mapping(uint256 => Details)) public lockedData;
30 
31     /** 
32     * @dev Emits event after nft is successfully locked
33     * @param user address which locked nfts (owner of tokens)
34     * @param nft collection address
35     * @param tokenIds list of tokenIds from `nft` collection
36     */
37     event Locked(address indexed user, address indexed nft, uint256[] tokenIds);
38 
39     /** 
40     * @dev Emits event after nft is successfully unlocked
41     * @param user address which unlocked nfts (owner of tokens)
42     * @param nft collection address
43     * @param tokenIds list of tokenIds from `nft` collection
44     */
45     event Unlocked(address indexed user, address indexed nft, uint256[] tokenIds);
46 
47     /**
48     * @dev Locks multiple tokenIds from multiple collections.
49     * @param nfts list of collection addresses.
50     * @param tokenIds list of tokenIds from collections. First dimension index has to match `nfts` index.
51     */
52     function lock(address[] calldata nfts, uint256[][] calldata tokenIds) external {
53         require(nfts.length == tokenIds.length, "NFTs addresses & tokenIds length mismatch.");
54 
55         uint256 nftsLength = nfts.length;
56         uint256 tokenIdsLength;
57         for (uint8 i = 0; i < nftsLength; i++) {
58             tokenIdsLength = tokenIds[i].length;
59             if (tokenIdsLength > 0) {
60                 emit Locked(msg.sender, nfts[i], tokenIds[i]);
61                 for (uint8 j = 0; j < tokenIdsLength; j++) {
62                     lockedData[nfts[i]][tokenIds[i][j]].user = msg.sender;
63                     lockedData[nfts[i]][tokenIds[i][j]].blockNo = block.number;
64                     INFT(nfts[i]).transferFrom(msg.sender, address(this), tokenIds[i][j]);
65                 }
66             }
67         }
68     }
69 
70     /**
71     * @dev Unlocks multiple tokenIds from multiple collections.
72     * @param nfts list of collection addresses.
73     * @param tokenIds list of tokenIds from collections. First dimension index has to match `nfts` index.
74     */
75     function unlock(address[] calldata nfts, uint256[][] calldata tokenIds) external {
76         require(nfts.length == tokenIds.length, "NFTs addresses & tokenIds length mismatch.");
77 
78         uint256 nftsLength = nfts.length;
79         uint256 tokenIdsLength;
80         for (uint8 i = 0; i < nftsLength; i++) {
81             tokenIdsLength = tokenIds[i].length;
82             if (tokenIdsLength > 0) {
83                 emit Unlocked(msg.sender, nfts[i], tokenIds[i]);
84                 for (uint8 j = 0; j < tokenIdsLength; j++) {
85                     require(msg.sender == lockedData[nfts[i]][tokenIds[i][j]].user, "Token does not belong to user.");
86                     require(block.number > lockedData[nfts[i]][tokenIds[i][j]].blockNo, "Unlock too fast.");
87 
88                     delete lockedData[nfts[i]][tokenIds[i][j]];
89                     INFT(nfts[i]).transferFrom(address(this), msg.sender, tokenIds[i][j]);
90                 }
91             }
92         }
93     }
94 
95 }