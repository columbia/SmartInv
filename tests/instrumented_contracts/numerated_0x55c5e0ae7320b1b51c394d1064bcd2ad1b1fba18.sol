1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface ERC721 {
5     function ownerOf(uint256) external view returns (address);
6 
7     function safeTransferFrom(
8         address,
9         address,
10         uint256
11     ) external;
12 }
13 
14 contract EtherPOAPStaking {
15     //EtherPOAP contract address
16     ERC721 constant EtherPOAP = ERC721(0x98C7FA114b2FE921Ba97f628e9dCb72890491721);
17     struct StakeInfo {
18         uint48 startTime;
19         uint48 stakeTime;
20         address staker;
21     }
22     //tokenId to accumulated staked time
23     mapping(uint256 => uint256) public totalStakedTime;
24     //tokenId to token stake information
25     mapping(uint256 => StakeInfo) _stakeInfoMap;
26 
27     event StakeNFT(
28         address indexed staker,
29         uint256 indexed tokenId,
30         uint256 stakeTime
31     );
32 
33     event UnstakeNFT(
34         address indexed staker,
35         uint256 indexed tokenId,
36         uint256 startTime,
37         uint256 presetDuration
38     );
39 
40     function stake(uint256 tokenId, uint48 _stakeTime) public {
41         require(
42             msg.sender == EtherPOAP.ownerOf(tokenId),
43             "you are not the owner of this NFT"
44         );
45         _stakeInfoMap[tokenId].startTime = uint48(block.timestamp);
46         _stakeInfoMap[tokenId].stakeTime = _stakeTime;
47         _stakeInfoMap[tokenId].staker = msg.sender;
48         EtherPOAP.safeTransferFrom(msg.sender, address(this), tokenId);
49         emit StakeNFT(msg.sender, tokenId, _stakeTime);
50     }
51 
52     function unstake(uint256 tokenId) public {
53         require(
54             _stakeInfoMap[tokenId].staker == msg.sender && unlockTime(tokenId) <= block.timestamp,
55             "wrong tokenId or still in locked time"
56         );
57         emit UnstakeNFT(
58             msg.sender,
59             tokenId,
60             _stakeInfoMap[tokenId].startTime,
61             _stakeInfoMap[tokenId].stakeTime
62         );
63         totalStakedTime[tokenId] += block.timestamp - _stakeInfoMap[tokenId].startTime;
64         delete _stakeInfoMap[tokenId];
65         EtherPOAP.safeTransferFrom(address(this), msg.sender, tokenId);
66     }
67 
68     function batchStake(uint256[] memory tokenIds, uint48 _stakeTime) public {
69         for (uint256 i = 0; i < tokenIds.length; i++) {
70             stake(tokenIds[i], _stakeTime);
71         }
72     }
73 
74     function batchUnstake(uint256[] memory tokenIds) public {
75         require(tokenIds.length > 0, "Empty tokenIds input");
76         for (uint256 i = 0; i < tokenIds.length; i++) {
77             unstake(tokenIds[i]);
78         }
79     }
80 
81     function unlockTime(uint256 tokenId) public view returns (uint256) {
82         return
83             uint256(_stakeInfoMap[tokenId].startTime + _stakeInfoMap[tokenId].stakeTime);
84     }
85 
86     function stakeInfoMap(uint256 tokenId) public view returns (uint48 startTime, uint48 stakeTime, address staker) {
87         return (
88             _stakeInfoMap[tokenId].startTime,
89             _stakeInfoMap[tokenId].stakeTime,
90             _stakeInfoMap[tokenId].staker
91         );
92     }
93 
94     function stakedTokens(address user) public view returns (string memory) {
95         string memory res;
96         for (uint256 i = 0; i < 10000; i++) {
97             if (_stakeInfoMap[i].staker == user) {
98                 if (bytes(res).length == 0) {
99                     res = _uint2str(i);
100                 } else {
101                     res = string(abi.encodePacked(res, ", ", _uint2str(i)));
102                 }
103             }
104         }
105         return res;
106     }
107 
108     function _uint2str(uint256 _i) internal pure returns (string memory) {
109         if (_i == 0) {
110             return "0";
111         }
112         uint256 j = _i;
113         uint256 len;
114         while (j != 0) {
115             len++;
116             j /= 10;
117         }
118         bytes memory bStr = new bytes(len);
119         uint256 k = len;
120         while (_i != 0) {
121             k = k - 1;
122             uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
123             bytes1 b1 = bytes1(temp);
124             bStr[k] = b1;
125             _i /= 10;
126         }
127         return string(bStr);
128     }
129 
130     function onERC721Received(
131         address,
132         address,
133         uint256,
134         bytes memory
135     ) public pure returns (bytes4) {
136         return this.onERC721Received.selector;
137     }
138 }