1 pragma solidity ^0.4.23;
2 
3 
4 contract Functions {
5 
6     bytes32[] public randomHashes;
7 
8     function fillWithHashes() public {
9         require(randomHashes.length == 0);
10 
11         for (uint i = block.number - 100; i < block.number; i++) {
12             randomHashes.push(blockhash(i));
13         }
14     }
15 
16     /// @notice Function to calculate initial random seed based on our hashes
17     /// @param _randomHashIds are ids in our array of hashes
18     /// @param _timestamp is timestamp for that hash
19     /// @return uint representation of random seed
20     function calculateSeed(uint[] _randomHashIds, uint _timestamp) public view returns (uint) {
21         require(_timestamp != 0);
22         require(_randomHashIds.length == 10);
23 
24         bytes32 randomSeed = keccak256(
25             abi.encodePacked(
26             randomHashes[_randomHashIds[0]], randomHashes[_randomHashIds[1]],
27             randomHashes[_randomHashIds[2]], randomHashes[_randomHashIds[3]],
28             randomHashes[_randomHashIds[4]], randomHashes[_randomHashIds[5]],
29             randomHashes[_randomHashIds[6]], randomHashes[_randomHashIds[7]],
30             randomHashes[_randomHashIds[8]], randomHashes[_randomHashIds[9]],
31             _timestamp
32             )
33         );
34 
35         return uint(randomSeed);
36     }
37 
38     function getRandomHashesLength() public view returns(uint) {
39         return randomHashes.length;
40     }
41 
42     /// @notice Function which decodes bytes32 to array of integers
43     /// @param _potentialAssets are potential assets user would like to have
44     /// @return array of assetIds
45     function decodeAssets(bytes32[] _potentialAssets) public pure returns (uint[] assets) {
46         require(_potentialAssets.length > 0);
47 
48         uint[] memory assetsCopy = new uint[](_potentialAssets.length*10);
49         uint numberOfAssets = 0;
50 
51         for (uint j = 0; j < _potentialAssets.length; j++) {
52             uint input;
53             bytes32 pot = _potentialAssets[j];
54 
55             assembly {
56                 input := pot
57             }
58 
59             for (uint i = 10; i > 0; i--) {
60                 uint mask = (2 << ((i-1) * 24)) / 2;
61                 uint b = (input & (mask * 16777215)) / mask;
62 
63                 if (b != 0) {
64                     assetsCopy[numberOfAssets] = b;
65                     numberOfAssets++;
66                 }
67             }
68         }
69 
70         assets = new uint[](numberOfAssets);
71         for (i = 0; i < numberOfAssets; i++) {
72             assets[i] = assetsCopy[i];
73         }
74     }
75 
76     /// @notice Function to pick random assets from potentialAssets array
77     /// @param _finalSeed is final random seed
78     /// @param _potentialAssets is bytes32[] array of potential assets
79     /// @return uint[] array of randomly picked assets
80     function pickRandomAssets(uint _finalSeed, bytes32[] _potentialAssets) public pure returns(uint[] finalPicked) {
81         require(_finalSeed != 0);
82         require(_potentialAssets.length > 0);
83 
84         uint[] memory assetIds = decodeAssets(_potentialAssets);
85         uint[] memory pickedIds = new uint[](assetIds.length);
86 
87         uint finalSeedCopy = _finalSeed;
88         uint index = 0;
89 
90         for (uint i = 0; i < assetIds.length; i++) {
91             finalSeedCopy = uint(keccak256(abi.encodePacked(finalSeedCopy, assetIds[i])));
92             if (finalSeedCopy % 2 == 0) {
93                 pickedIds[index] = assetIds[i];
94                 index++;
95             }
96         }
97 
98         finalPicked = new uint[](index);
99         for (i = 0; i < index; i++) {
100             finalPicked[i] = pickedIds[i];
101         }
102     }
103 
104     /// @notice Function to pick random assets from potentialAssets array
105     /// @param _finalSeed is final random seed
106     /// @param _potentialAssets is bytes32[] array of potential assets
107     /// @param _width of canvas
108     /// @param _height of canvas
109     /// @return arrays of randomly picked assets defining ids, coordinates, zoom, rotation and layers
110     function getImage(uint _finalSeed, bytes32[] _potentialAssets, uint _width, uint _height) public pure 
111     returns(uint[] finalPicked, uint[] x, uint[] y, uint[] zoom, uint[] rotation, uint[] layers) {
112         require(_finalSeed != 0);
113         require(_potentialAssets.length > 0);
114 
115         uint[] memory assetIds = decodeAssets(_potentialAssets);
116         uint[] memory pickedIds = new uint[](assetIds.length);
117         x = new uint[](assetIds.length);
118         y = new uint[](assetIds.length);
119         zoom = new uint[](assetIds.length);
120         rotation = new uint[](assetIds.length);
121         layers = new uint[](assetIds.length);
122 
123         uint finalSeedCopy = _finalSeed;
124         uint index = 0;
125 
126         for (uint i = 0; i < assetIds.length; i++) {
127             finalSeedCopy = uint(keccak256(abi.encodePacked(finalSeedCopy, assetIds[i])));
128             if (finalSeedCopy % 2 == 0) {
129                 pickedIds[index] = assetIds[i];
130                 (x[index], y[index], zoom[index], rotation[index], layers[index]) = pickRandomAssetPosition(finalSeedCopy, _width, _height);
131                 index++;
132             }
133         }
134 
135         finalPicked = new uint[](index);
136         for (i = 0; i < index; i++) {
137             finalPicked[i] = pickedIds[i];
138         }
139     }
140 
141     /// @notice Function to pick random position for an asset
142     /// @param _randomSeed is random seed for that image
143     /// @param _width of canvas
144     /// @param _height of canvas
145     /// @return tuple of uints representing x,y,zoom,and rotation
146     function pickRandomAssetPosition(uint _randomSeed, uint _width, uint _height) public pure 
147     returns (uint x, uint y, uint zoom, uint rotation, uint layer) {
148         
149         x = _randomSeed % _width;
150         y = _randomSeed % _height;
151         zoom = _randomSeed % 200 + 800;
152         rotation = _randomSeed % 360;
153         // using random number for now
154         // if two layers are same, sort by (keccak256(layer, assetId))
155         layer = _randomSeed % 1234567; 
156     }
157 
158     /// @notice Function to calculate final random seed for user
159     /// @param _randomSeed is initially given random seed
160     /// @param _iterations is number of iterations
161     /// @return final seed for user as uint
162     function getFinalSeed(uint _randomSeed, uint _iterations) public pure returns (bytes32) {
163         require(_randomSeed != 0);
164         require(_iterations != 0);
165         bytes32 finalSeed = bytes32(_randomSeed);
166 
167         finalSeed = keccak256(abi.encodePacked(_randomSeed, _iterations));
168         for (uint i = 0; i < _iterations; i++) {
169             finalSeed = keccak256(abi.encodePacked(finalSeed, i));
170         }
171 
172         return finalSeed;
173     }
174 
175     function toHex(uint _randomSeed) public pure returns (bytes32) {
176         return bytes32(_randomSeed);
177     }
178 }