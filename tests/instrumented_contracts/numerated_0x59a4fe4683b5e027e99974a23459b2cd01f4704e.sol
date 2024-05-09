1 // File: contracts/validators/IValidator.sol
2 
3 pragma solidity ^0.5.0;
4 
5 interface IValidator {
6     function validate(uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _exterior) external view returns (bool);
7 }
8 
9 // File: contracts/validators/CityBuildingValidator.sol
10 
11 pragma solidity ^0.5.0;
12 
13 
14 contract CityBuildingValidator is IValidator {
15 
16     uint256 public city;
17     uint256 public rotation;
18 
19     mapping(uint256 => uint256[]) public buildingMappings;
20     mapping(uint256 => mapping(uint256 => uint256[])) public buildingBaseMappings;
21     mapping(uint256 => mapping(uint256 => uint256[])) public buildingBodyMappings;
22     mapping(uint256 => mapping(uint256 => uint256[])) public buildingRoofMappings;
23 
24     mapping(uint256 => uint256[]) public exteriorMappings;
25 
26     address payable public platform;
27     address payable public partner;
28 
29     modifier onlyPlatformOrPartner() {
30         require(msg.sender == platform || msg.sender == partner);
31         _;
32     }
33 
34     constructor (address payable _platform, uint256 _city) public {
35         platform = _platform;
36         partner = msg.sender;
37 
38         city = _city;
39     }
40 
41     function validate(uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _exterior) external view returns (bool) {
42         uint256[] memory buildingOptions = buildingMappings[rotation];
43         if (!contains(buildingOptions, _building)) {
44             return false;
45         }
46 
47         uint256[] memory baseOptions = buildingBaseMappings[rotation][_building];
48         if (!contains(baseOptions, _base)) {
49             return false;
50         }
51 
52         uint256[] memory bodyOptions = buildingBodyMappings[rotation][_building];
53         if (!contains(bodyOptions, _body)) {
54             return false;
55         }
56 
57         uint256[] memory roofOptions = buildingRoofMappings[rotation][_building];
58         if (!contains(roofOptions, _roof)) {
59             return false;
60         }
61 
62         uint256[] memory exteriorOptions = exteriorMappings[rotation];
63         if (!contains(exteriorOptions, _exterior)) {
64             return false;
65         }
66 
67         return true;
68     }
69 
70     function contains(uint256[] memory _array, uint256 _val) internal pure returns (bool) {
71 
72         bool found = false;
73         for (uint i = 0; i < _array.length; i++) {
74             if (_array[i] == _val) {
75                 found = true;
76                 break;
77             }
78         }
79 
80         return found;
81     }
82 
83     function updateRotation(uint256 _rotation) public onlyPlatformOrPartner {
84        rotation = _rotation;
85     }
86 
87     function updateBuildingMappings(uint256 _rotation, uint256[] memory _params) public onlyPlatformOrPartner {
88         buildingMappings[_rotation] = _params;
89     }
90 
91     function updateBuildingBaseMappings(uint256 _rotation, uint256 _building, uint256[] memory _params) public onlyPlatformOrPartner {
92         buildingBaseMappings[_rotation][_building] = _params;
93     }
94 
95     function updateBuildingBodyMappings(uint256 _rotation, uint256 _building, uint256[] memory _params) public onlyPlatformOrPartner {
96         buildingBodyMappings[_rotation][_building] = _params;
97     }
98 
99     function updateBuildingRoofMappings(uint256 _rotation, uint256 _building, uint256[] memory _params) public onlyPlatformOrPartner {
100         buildingRoofMappings[_rotation][_building] = _params;
101     }
102 
103     function updateExteriorMappings(uint256 _rotation, uint256[] memory _params) public onlyPlatformOrPartner {
104         exteriorMappings[_rotation] = _params;
105     }
106 
107     function buildingMappingsArray() public view returns (uint256[] memory) {
108         return buildingMappings[rotation];
109     }
110 
111     function buildingBaseMappingsArray(uint256 _building) public view returns (uint256[] memory) {
112         return buildingBaseMappings[rotation][_building];
113     }
114 
115     function buildingBodyMappingsArray(uint256 _building) public view returns (uint256[] memory) {
116         return buildingBodyMappings[rotation][_building];
117     }
118 
119     function buildingRoofMappingsArray(uint256 _building) public view returns (uint256[] memory) {
120         return buildingRoofMappings[rotation][_building];
121     }
122 
123     function exteriorMappingsArray() public view returns (uint256[] memory) {
124         return exteriorMappings[rotation];
125     }
126 
127     function currentRotation() public view returns (uint256) {
128         return rotation;
129     }
130 }