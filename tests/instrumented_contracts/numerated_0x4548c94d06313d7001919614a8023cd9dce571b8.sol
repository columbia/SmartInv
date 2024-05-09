1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.16;
3 
4 interface iGasEvo {
5     function _trueOwnerOf(uint256 tokenId_) external view returns (address);
6     function isTrueOwnerOfAll(address owner, uint256[] calldata tokenIds_) 
7     external view returns (bool);
8 }
9 
10 contract GangsterBoxRevealBatch {
11     
12     // Interface with GAS EVO
13     iGasEvo public GasEvo = iGasEvo(0xa9BA1A433Ec326bca975aef9a1641B42717197e7);
14 
15     // Mapping of packed reveal datas for tokenIds
16     mapping(uint256 => bool[32]) public tokenBatchToRevealed;
17 
18     //////////////////////////////////////
19     //        Internal Functions        //
20     //////////////////////////////////////
21 
22     function _readTokenBatchData(uint256 batchId_) public view 
23     returns (bool[32] memory) {
24         return tokenBatchToRevealed[batchId_];
25     }
26     function _readTokenBatchDatas(uint256[] calldata batchIds_) public view 
27     returns (bool[32][] memory) {
28         uint256 i;
29         uint256 l = batchIds_.length;
30         bool[32][] memory _batches = new bool[32][] (l);
31         unchecked { do { 
32             _batches[i] = _readTokenBatchData(i);
33         } while (++i < l); }
34         return _batches;
35     }
36 
37     function _getBatchIdOfTokenId(uint256 tokenId_) public pure returns (uint256) {
38         return tokenId_ / 32; 
39     }
40     function _getSlotIdOfTokenId(uint256 tokenId_) public pure returns (uint256) {
41         return tokenId_ % 32; 
42     }
43     
44     function _getBatchesForTokens(uint256[] calldata tokenIds_) public pure
45     returns (uint256[] memory) {
46         uint256 i;
47         uint256 l = tokenIds_.length;
48         uint256[] memory _batches = new uint256[] (l);
49         unchecked { do {
50             _batches[i] = _getBatchIdOfTokenId(tokenIds_[i]);
51         } while (++i < l); }
52         return _batches;
53     }
54     function _getSlotsForTokens(uint256[] calldata tokenIds_) public pure
55     returns (uint256[] memory) {
56         uint256 i;
57         uint256 l = tokenIds_.length;
58         uint256[] memory _batches = new uint256[] (l);
59         unchecked { do {
60             _batches[i] = _getSlotIdOfTokenId(tokenIds_[i]);
61         } while (++i < l); }
62         return _batches;
63     }
64 
65     //////////////////////////////////////
66     //          Write Functions         //
67     //////////////////////////////////////
68 
69     function revealTokenSingle(uint256 tokenId_) public {
70         uint256 _batch = _getBatchIdOfTokenId(tokenId_);
71         uint256 _slot = _getSlotIdOfTokenId(tokenId_);
72         require(msg.sender == GasEvo._trueOwnerOf(tokenId_), 
73             "You are not the owner of this token!");
74         tokenBatchToRevealed[_batch][_slot] = true;
75     }
76     function revealTokenBatch(uint256[] calldata tokenIds_) public {
77         uint256 i;
78         uint256 l = tokenIds_.length;
79         uint256[] memory _batches = _getBatchesForTokens(tokenIds_);
80         uint256[] memory _slots = _getSlotsForTokens(tokenIds_);
81         
82         // Patch 2.1 Implementation
83         require(GasEvo.isTrueOwnerOfAll(msg.sender, tokenIds_), 
84             "Not owner of tokens!");
85         
86         unchecked { do { 
87             tokenBatchToRevealed[_batches[i]][_slots[i]] = true;
88         } while (++i < l); }
89     }
90 
91     //////////////////////////////////////
92     //    Front-End Helper Functions    //
93     //////////////////////////////////////
94 
95     function tokenIsRevealed(uint256 tokenId_) public view returns (bool) {
96         uint256 _batch = _getBatchIdOfTokenId(tokenId_);
97         uint256 _slot = _getSlotIdOfTokenId(tokenId_);
98         return tokenBatchToRevealed[_batch][_slot];
99     }
100     function tokensAreRevealed(uint256[] calldata tokenIds_) public view 
101     returns (bool[] memory) {
102         uint256 i;
103         uint256 l = tokenIds_.length;
104         bool[] memory _revealeds = new bool[](l);
105         unchecked { do { 
106             _revealeds[i] = tokenIsRevealed(tokenIds_[i]);
107         } while (++i < l); }
108         return _revealeds;
109     }
110 }