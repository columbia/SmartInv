1 pragma solidity ^0.4.16;
2 
3 
4 /* 
5 This contract stores the memories of GuaGua and MiaoMiao.
6 Long last our love and the blockchain.
7 */
8 contract GuaGuaMiaoMiaoMemories {
9 
10     struct Memory {
11         string story;
12         uint256 imageSliceCount;
13         mapping(uint256 => bytes) imageSlices;
14     }
15 
16     Memory[] internal memories;
17 
18     address public guagua;
19     address public miaomiao;
20 
21     function GuaGuaMiaoMiaoMemories() public {
22         guagua = msg.sender;
23     }
24 
25     modifier onlyGuaGua() {
26         require(msg.sender == guagua);
27         _;
28     }
29 
30     modifier onlyMiaoMiao() {
31         require(msg.sender == miaomiao);
32         _;
33     }
34 
35     modifier onlyGuaGuaMiaoMiao() {
36         require(msg.sender == guagua || msg.sender == miaomiao);
37         _;
38     }
39 
40     function initMiaoMiaoAddress(address _miaomiaoAddress) external onlyGuaGuaMiaoMiao {
41         require(_miaomiaoAddress != address(0));
42         miaomiao = _miaomiaoAddress;
43     }
44 
45     function addMemory(string _story, bytes _imageFirstSlice) external onlyGuaGuaMiaoMiao {
46         memories.push(Memory({story: _story, imageSliceCount: 0}));
47         memories[memories.length-1].imageSlices[0] = _imageFirstSlice;
48         memories[memories.length-1].imageSliceCount = 1;
49     }
50 
51     function addMemoryImageSlice(uint256 _index, bytes _imageSlice) external onlyGuaGuaMiaoMiao {
52         require(_index >= 0 && _index < memories.length);
53         memories[_index].imageSlices[memories[_index].imageSliceCount] = _imageSlice;
54         memories[_index].imageSliceCount += 1;
55     }
56 
57     function viewMemory(uint256 _index) public view returns (string story, bytes image) {
58         require(_index >= 0 && _index < memories.length);
59         uint256 imageLen = 0;
60         uint256 i = 0;
61         for (i = 0; i < memories[_index].imageSliceCount; i++){
62             imageLen += memories[_index].imageSlices[i].length;
63         }
64         image = new bytes(imageLen);
65         uint256 j = 0;
66         uint256 k = 0;
67         for (i = 0; i < memories[_index].imageSliceCount; i++){
68             for (j = 0; j < memories[_index].imageSlices[i].length; j++) {
69                 image[k] = memories[_index].imageSlices[i][j];
70                 k += 1;
71             }
72         }
73         story = memories[_index].story;
74         return (story, image);
75     }
76 
77     function viewNumberOfMemories() public view returns(uint256) {
78         return memories.length;
79     }
80     
81 }