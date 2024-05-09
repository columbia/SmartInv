1 /*! mytilcoinstorage.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.21;
4 
5 contract Ownable {
6     address public owner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     modifier onlyOwner() { require(msg.sender == owner); _; }
11 
12     function Ownable() public {
13         owner = msg.sender;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0));
18         owner = newOwner;
19         OwnershipTransferred(owner, newOwner);
20     }
21 }
22 
23 contract Manageable is Ownable {
24     mapping(address => bool) public managers;
25 
26     event ManagerAdded(address indexed manager);
27     event ManagerRemoved(address indexed manager);
28 
29     modifier onlyManager() { require(managers[msg.sender]); _; }
30 
31     function addManager(address _manager) onlyOwner public {
32         require(_manager != address(0));
33 
34         managers[_manager] = true;
35 
36         ManagerAdded(_manager);
37     }
38 
39     function removeManager(address _manager) onlyOwner public {
40         require(_manager != address(0));
41 
42         managers[_manager] = false;
43 
44         ManagerRemoved(_manager);
45     }
46 }
47 
48 contract MytilcoinStorage is Manageable {
49     struct Picture {
50         string hash;
51         uint32 rows;
52         uint32 cols;
53         uint32 width;
54         uint32 height;
55         string image;
56         string name;
57         string author;
58     }
59 
60     mapping(bytes32 => Picture) public pictures;
61     mapping(bytes32 => bool) public hashes;
62 
63     event AddPicture(bytes32 indexed hash, uint32 rows, uint32 cols, uint32 width, uint32 height, string image, string name, string author);
64     event SetHash(bytes32 indexed hash);
65 
66     function MytilcoinStorage() public {
67         addManager(msg.sender);
68         addManager(0x73b1046A185bF68c11b4c90d79Cffc2E07519951);
69         addManager(0x7b15d3e5418E5140fF827127Ee1f44d2d65F8710);
70         addManager(0x977482e6f7Ad897Ee70c33A20f30c369f4BF7265);
71         addManager(0xa611D8C5183E533e13ecfFb3E9F9628e9dEF2755);
72         addManager(0xe16BBd0Cf49F4cC1Eb92fFBbaa71d7580b966097);
73         addManager(0x5c9E1b25113A5c18fBFd7655cCd5C160bf79B51E);
74         addManager(0x0812B7182aC1C5285E10644CdF5E9BB6234d0AF0);
75         addManager(0x52e5689a151CA40B56C217B5dB667F66A197e7Bb);
76         addManager(0xA71396Fcb7efd57AeC5FaD1Eb7e5503cDE136123);
77         addManager(0xF3f90257dAd60f8c4496D35117e04eAbb507b713);
78         addManager(0x63B182305Bd56f0b250a4974Cc872169ab706c53);
79         addManager(0x28d2446cE3F1F99B477DD77F9C6361f5b57DcFd8);
80         addManager(0x5c3770785Ebd50Ef7bC91b8afC8a7F86F014c54E);
81         addManager(0x0fDdAe9D4E6670e3699bdBA3058a84b92DFf95b2);
82         addManager(0x5CB547C3fA7abd51E508C980470fb86B731cd0bf);
83         addManager(0xEB9e2e0a32BD1De66762cCaef5438586C6C9ac3c);
84         addManager(0x6dBA00A685e0E4485A838E31A3a7EB63A5935702);
85         addManager(0x2EF9a68D2A9fB9aC4919e2D85cf22780e5EBFCfD);
86         addManager(0x7e4FD70e4F8c355d51E2CCFb15aF87d47e6D2167);
87         addManager(0x51ce146F1128Ff424Dc918441B46Cb56cC95a172);
88         addManager(0x2f2eb8766EC9EaAc7EBa6E851794DB3B45669D2A);
89     }
90 
91     function addPicture(string _hash, uint32 _rows, uint32 _cols, uint32 _width, uint32 _height, string _image, string _name, string _author) onlyManager public returns(bool success) {
92         bytes32 key = str_to_bytes32(_hash);
93 
94         require(!(pictures[key].rows > 0));
95         require(_rows > 0 && _cols > 0 && _width > 0 && _height > 0);
96         
97         pictures[key] = Picture({
98             hash: _hash,
99             rows: _rows,
100             cols: _cols,
101             width: _width,
102             height: _height,
103             image: _image,
104             name: _name,
105             author: _author
106         });
107 
108         AddPicture(key, _rows, _cols, _width, _height, _image, _name, _author);
109 
110         return true;
111     }
112 
113     function setHash(string _hash) onlyManager public returns(bool success) {
114         bytes32 key = str_to_bytes32(_hash);
115 
116         hashes[key] = true;
117 
118         SetHash(key);
119 
120         return true;
121     }
122     
123     function str_to_bytes32(string memory source) private pure returns(bytes32 result) {
124         bytes memory tempEmptyStringTest = bytes(source);
125         if(tempEmptyStringTest.length == 0) {
126             return 0x0;
127         }
128 
129         assembly {
130             result := mload(add(source, 32))
131         }
132     }
133 }