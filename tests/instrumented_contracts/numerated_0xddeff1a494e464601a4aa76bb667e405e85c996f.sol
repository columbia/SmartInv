1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.2;
3 
4 interface Vizmesh {
5     function balanceOf(address account, uint256 id) external view returns (uint256);
6 }
7 
8 contract VizmeshConfigMainnet {
9     address public vizmeshSmartContractAddress;
10     address public ownerAddress;
11     mapping (uint256 => bool) public isPauseds;
12     mapping (uint256 => ethNft) public ethNfts;
13     mapping (uint256 => otherNft) public otherNfts;
14     mapping (uint256 => coord) private coords;
15 
16     event logSetEthNft(address _from, uint256 _frmId, address _nftSmartContractAddress, uint256 _nftTokenId);
17     event logSetOtherNft(address _from, uint256 _frmId, string _delimitedText);
18     event logSetIsPaused(uint256 _frmId, bool _isPaused);
19     event logSetCoord(address _from, uint256 _frmId, int32 _x, int32 _y);
20 
21     constructor () {
22         ownerAddress = msg.sender;
23         vizmeshSmartContractAddress = 0xFDf676eF9A5A74F8279Cd5fC70B8c1b9116b05CD;
24     }
25 
26     struct ethNft {
27         address nftSmartContractAddress;
28         uint256 nftTokenId;
29     }
30 
31     struct otherNft {
32         string delimitedText;
33     }
34 
35     struct coord {
36         int256 x;
37         int256 y;
38     }
39 
40     function setVizmeshSmartContractAddress(address _vizmeshSmartContractAddress)
41         public
42     {
43         require(isOwnerOfSmartContract(), "Must be smart contract owner");
44         vizmeshSmartContractAddress = _vizmeshSmartContractAddress;
45     }
46 
47     function setOwnerOfSmartContract(address _ownerAddress)
48         public
49     {
50         require(isOwnerOfSmartContract(), "Must be smart contract owner");
51         ownerAddress = _ownerAddress;
52     }
53 
54     function isOwnerOfSmartContract()
55         public
56         view
57         returns(bool)
58     {
59         return msg.sender == ownerAddress;
60     }
61 
62     function isOwnerOfFrm(uint256 _frmId)
63         public
64         view
65         returns(bool)
66     {
67         return Vizmesh(vizmeshSmartContractAddress).balanceOf(msg.sender, _frmId) == 1;
68     }
69 
70     function setIsPaused(uint256 _frmId, bool _isPaused)
71         public
72     {
73         require(isOwnerOfSmartContract(), "Must be smart contract owner");
74         isPauseds[_frmId] = _isPaused;
75         emit logSetIsPaused(_frmId, _isPaused);
76     }
77 
78     function setCoord(uint256 _frmId, int32 _x, int32 _y)
79         public
80     {
81         require(isPauseds[_frmId] == false, "FRM must not be paused");
82         require(isOwnerOfFrm(_frmId) || isOwnerOfSmartContract(), "Must be FRM owner or smart contract owner to update FRM coordinates.");
83         coords[_frmId] = coord(_x, _y);
84         emit logSetCoord(msg.sender, _frmId, _x, _y);
85     }
86 
87     function setEthNft(uint256 _frmId, address _nftSmartContractAddress, uint256 _nftTokenId)
88         public
89     {
90         require(isPauseds[_frmId] == false, "FRM must not be paused");
91         require(isOwnerOfFrm(_frmId) || isOwnerOfSmartContract(), "Must be FRM owner or smart contract owner to update FRM NFT.");
92         ethNfts[_frmId] = ethNft(_nftSmartContractAddress, _nftTokenId);
93         emit logSetEthNft(msg.sender, _frmId, _nftSmartContractAddress, _nftTokenId);
94     }
95 
96     function setOtherNft(uint256 _frmId, string memory _delimitedText)
97         public
98     {
99         require(isPauseds[_frmId] == false, "FRM must not be paused");
100         require(isOwnerOfFrm(_frmId) || isOwnerOfSmartContract(), "Must FRM owner or smart contract owner to update FRM NFT.");
101         otherNfts[_frmId] = otherNft(_delimitedText);
102         emit logSetOtherNft(msg.sender, _frmId, _delimitedText);
103     }
104 
105     function getCoord(uint256 _frmId)
106         public
107         view
108         returns(coord memory)
109     {
110         if(coords[_frmId].x == 0){
111             return getDefaultCoord(_frmId);
112         }
113         else {
114             return coords[_frmId];
115         }
116     }
117 
118     function getDefaultCoord(uint256 _frmId)
119         public
120         pure
121         returns(coord memory)
122     {
123         coord memory c = coord(0, 0);
124         int256 i;
125         int256 x;
126         int256 y;
127         for(i = 0; i < 255; i += 1) {
128             if(int256(_frmId) > (i * 2) * (i * 2)) {
129                 continue;
130             }
131             else {
132                 int256 thickness = i - 1;
133                 int256 turn_length = thickness * 2 + 1;
134                 int256 half_turn_length = thickness + 1;
135 
136                 int256 j;
137                 int256 remainder = int256(_frmId) - (thickness * 2) * (thickness * 2);
138 
139                 //Start at 12 o'clock
140                 x = 1;
141                 y = thickness + 1;
142                 for(j=1; j < remainder; j++) {
143                     if(j < half_turn_length) {
144                         x += 1;
145                     }
146                     else if(j < half_turn_length + turn_length ) {
147                         y -= 1;
148                         if (y == 0) {
149                             y -= 1;
150                         }
151                     }
152                     else if(j < half_turn_length + turn_length + turn_length) {
153                         x -= 1;
154                         if (x == 0) {
155                             x -= 1;
156                         }
157                     }
158                     else if(j < half_turn_length + turn_length + turn_length + turn_length) {
159                         y += 1;
160                         if (y == 0) {
161                             y += 1;
162                         }
163                     }
164                     else {
165                         x += 1;
166                     }
167                 }
168 
169                 c = coord(x, y);
170                 break;
171             }
172         }
173         return c;
174     }
175 }