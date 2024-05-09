1 pragma solidity 0.4.24;
2 
3 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
4 ///  later changed
5 contract Owned {
6 
7     /// @dev `owner` is the only address that can call a function with this
8     /// modifier
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     address public owner;
15 
16     /// @notice The Constructor assigns the message sender to be `owner`
17     function Owned() public {owner = msg.sender;}
18 
19     /// @notice `owner` can step down and assign some other address to this role
20     /// @param _newOwner The address of the new owner. 0x0 can be used to create
21     ///  an unowned neutral vault, however that cannot be undone
22     function changeOwner(address _newOwner) public onlyOwner {
23         owner = _newOwner;
24     }
25 }
26 
27 contract Callable is Owned {
28 
29     //sender => _allowed
30     mapping(address => bool) public callers;
31 
32     //modifiers
33     modifier onlyCaller {
34         require(callers[msg.sender]);
35         _;
36     }
37 
38     //management of the repositories
39     function updateCaller(address _caller, bool allowed) public onlyOwner {
40         callers[_caller] = allowed;
41     }
42 }
43 
44 contract EternalStorage is Callable {
45 
46     mapping(bytes32 => uint) uIntStorage;
47     mapping(bytes32 => string) stringStorage;
48     mapping(bytes32 => address) addressStorage;
49     mapping(bytes32 => bytes) bytesStorage;
50     mapping(bytes32 => bool) boolStorage;
51     mapping(bytes32 => int) intStorage;
52 
53     // *** Getter Methods ***
54     function getUint(bytes32 _key) external view returns (uint) {
55         return uIntStorage[_key];
56     }
57 
58     function getString(bytes32 _key) external view returns (string) {
59         return stringStorage[_key];
60     }
61 
62     function getAddress(bytes32 _key) external view returns (address) {
63         return addressStorage[_key];
64     }
65 
66     function getBytes(bytes32 _key) external view returns (bytes) {
67         return bytesStorage[_key];
68     }
69 
70     function getBool(bytes32 _key) external view returns (bool) {
71         return boolStorage[_key];
72     }
73 
74     function getInt(bytes32 _key) external view returns (int) {
75         return intStorage[_key];
76     }
77 
78     // *** Setter Methods ***
79     function setUint(bytes32 _key, uint _value) onlyCaller external {
80         uIntStorage[_key] = _value;
81     }
82 
83     function setString(bytes32 _key, string _value) onlyCaller external {
84         stringStorage[_key] = _value;
85     }
86 
87     function setAddress(bytes32 _key, address _value) onlyCaller external {
88         addressStorage[_key] = _value;
89     }
90 
91     function setBytes(bytes32 _key, bytes _value) onlyCaller external {
92         bytesStorage[_key] = _value;
93     }
94 
95     function setBool(bytes32 _key, bool _value) onlyCaller external {
96         boolStorage[_key] = _value;
97     }
98 
99     function setInt(bytes32 _key, int _value) onlyCaller external {
100         intStorage[_key] = _value;
101     }
102 
103     // *** Delete Methods ***
104     function deleteUint(bytes32 _key) onlyCaller external {
105         delete uIntStorage[_key];
106     }
107 
108     function deleteString(bytes32 _key) onlyCaller external {
109         delete stringStorage[_key];
110     }
111 
112     function deleteAddress(bytes32 _key) onlyCaller external {
113         delete addressStorage[_key];
114     }
115 
116     function deleteBytes(bytes32 _key) onlyCaller external {
117         delete bytesStorage[_key];
118     }
119 
120     function deleteBool(bytes32 _key) onlyCaller external {
121         delete boolStorage[_key];
122     }
123 
124     function deleteInt(bytes32 _key) onlyCaller external {
125         delete intStorage[_key];
126     }
127 }