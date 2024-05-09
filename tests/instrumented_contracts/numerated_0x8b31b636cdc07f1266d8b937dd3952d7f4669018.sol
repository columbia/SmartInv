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
60     struct Segment {
61         uint32 row;
62         uint32 col;
63         string hash;
64         string image;
65         string email;
66         string login;
67     }
68     
69     mapping(bytes32 => Picture) public pictures;
70     mapping(bytes32 => mapping(uint32 => mapping(uint32 => Segment))) public segments;
71 
72     event AddPicture(bytes32 indexed hash, uint32 rows, uint32 cols, uint32 width, uint32 height, string image, string name, string author);
73     event SetSegment(bytes32 indexed picture, uint32 indexed row, uint32 indexed col, bytes32 hash, string image);
74     event SegmentOwner(bytes32 indexed picture, uint32 indexed row, uint32 indexed col, string email, string login);
75 
76     function MytilcoinStorage() public {
77         addManager(msg.sender);
78         addManager(0x209eba96c917871f78671a3ed3503ecc4144495c);
79     }
80 
81     function addPicture(string _hash, uint32 _rows, uint32 _cols, uint32 _width, uint32 _height, string _image, string _name, string _author) onlyManager public returns(bool success) {
82         bytes32 key = str_to_bytes32(_hash);
83 
84         require(!(pictures[key].rows > 0));
85         require(_rows > 0 && _cols > 0 && _width > 0 && _height > 0);
86         
87         pictures[key] = Picture({
88             hash: _hash,
89             rows: _rows,
90             cols: _cols,
91             width: _width,
92             height: _height,
93             image: _image,
94             name: _name,
95             author: _author
96         });
97 
98         AddPicture(key, _rows, _cols, _width, _height, _image, _name, _author);
99 
100         return true;
101     }
102 
103     function setSegment(string _picture, uint32 _row, uint32 _col, string _hash, string _image, string _email, string _login) onlyManager public returns(bool success) {
104         bytes32 key = str_to_bytes32(_picture);
105 
106         require(pictures[key].rows > 0);
107         require(_row > 0 && _col > 0 && _row <= pictures[key].rows && _col <= pictures[key].cols);
108         require(!(segments[key][_row][_col].row > 0));
109         
110         segments[key][_row][_col] = Segment({
111             row: _row,
112             col: _col,
113             hash: _hash,
114             image: _image,
115             email: _email,
116             login: _login
117         });
118 
119         SetSegment(key, _row, _col, str_to_bytes32(_hash), _image);
120         SegmentOwner(key, _row, _col, _email, _login);
121 
122         return true;
123     }
124 
125     function setSegmentOwner(string _picture, uint32 _row, uint32 _col, string _email, string _login) onlyManager public returns(bool success) {
126         bytes32 key = str_to_bytes32(_picture);
127 
128         require(pictures[key].rows > 0);
129         require(_row > 0 && _col > 0 && _row <= pictures[key].rows && _col <= pictures[key].cols);
130         require(segments[key][_row][_col].row > 0);
131         
132         segments[key][_row][_col].email = _email;
133         segments[key][_row][_col].login = _login;
134 
135         SegmentOwner(key, _row, _col, _email, _login);
136 
137         return true;
138     }
139 
140     function str_to_bytes32(string memory source) private pure returns(bytes32 result) {
141         bytes memory tempEmptyStringTest = bytes(source);
142         if(tempEmptyStringTest.length == 0) {
143             return 0x0;
144         }
145 
146         assembly {
147             result := mload(add(source, 32))
148         }
149     }
150 }