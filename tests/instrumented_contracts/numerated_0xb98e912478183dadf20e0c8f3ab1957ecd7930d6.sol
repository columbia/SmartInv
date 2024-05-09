1 pragma solidity ^0.4.23;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2018 Taboo University MDAO.
6  * Released under the MIT License.
7  *
8  * Taboo Db - An eternal database, providing a sustainable storage solution
9  *            for use throughout the upgrade lifecycle of managing contracts.
10  *
11  * Version 18.5.7
12  *
13  * Web    : https://taboou.com/
14  * Email  : support@taboou.com
15  * Github : https://github.com/taboou/tabooads.bit/
16  */
17 
18 
19 /*******************************************************************************
20  * Owned contract
21  */
22 contract Owned {
23     address public owner;
24     address public newOwner;
25 
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43 
44         emit OwnershipTransferred(owner, newOwner);
45 
46         owner = newOwner;
47 
48         newOwner = address(0);
49     }
50 }
51 
52 
53 /*******************************************************************************
54  * Taboo Db Contract
55  */
56 contract TabooDb is Owned {
57     /* Initialize all storage types. */
58     mapping(bytes32 => address)    private addressStorage;
59     mapping(bytes32 => bool)       private boolStorage;
60     mapping(bytes32 => bytes)      private bytesStorage;
61     mapping(bytes32 => int256)     private intStorage;
62     mapping(bytes32 => string)     private stringStorage;
63     mapping(bytes32 => uint256)    private uIntStorage;
64 
65     /**
66      * @dev Only allow access from the latest version of a contract
67      *      in the Taboo U Networks (TUN) after deployment.
68      */
69     modifier onlyAuthByTUN() {
70         /***********************************************************************
71          * The owner is only allowed to set the authorized contracts upon
72          * deployment, to register the initial contracts, afterwards their
73          * direct access is permanently disabled.
74          */
75         if (msg.sender == owner) {
76             /* Verify owner's write access has not already been disabled. */
77             require(boolStorage[keccak256('owner.auth.disabled')] != true);
78         } else {
79             /* Verify write access is only permitted to authorized accounts. */
80             require(boolStorage[keccak256(msg.sender, '.has.auth')] == true);
81         }
82 
83         _;      // function code is inserted here
84     }
85 
86     /***************************************************************************
87      * Initialize all getter methods.
88      */
89 
90     /// @param _key The key for the record
91     function getAddress(bytes32 _key) external view returns (address) {
92         return addressStorage[_key];
93     }
94 
95     /// @param _key The key for the record
96     function getBool(bytes32 _key) external view returns (bool) {
97         return boolStorage[_key];
98     }
99 
100     /// @param _key The key for the record
101     function getBytes(bytes32 _key) external view returns (bytes) {
102         return bytesStorage[_key];
103     }
104 
105     /// @param _key The key for the record
106     function getInt(bytes32 _key) external view returns (int) {
107         return intStorage[_key];
108     }
109 
110     /// @param _key The key for the record
111     function getString(bytes32 _key) external view returns (string) {
112         return stringStorage[_key];
113     }
114 
115     /// @param _key The key for the record
116     function getUint(bytes32 _key) external view returns (uint) {
117         return uIntStorage[_key];
118     }
119 
120 
121     /***************************************************************************
122      * Initialize all setter methods.
123      */
124 
125     /// @param _key The key for the record
126     function setAddress(bytes32 _key, address _value) onlyAuthByTUN external {
127         addressStorage[_key] = _value;
128     }
129 
130     /// @param _key The key for the record
131     function setBool(bytes32 _key, bool _value) onlyAuthByTUN external {
132         boolStorage[_key] = _value;
133     }
134 
135     /// @param _key The key for the record
136     function setBytes(bytes32 _key, bytes _value) onlyAuthByTUN external {
137         bytesStorage[_key] = _value;
138     }
139 
140     /// @param _key The key for the record
141     function setInt(bytes32 _key, int _value) onlyAuthByTUN external {
142         intStorage[_key] = _value;
143     }
144 
145     /// @param _key The key for the record
146     function setString(bytes32 _key, string _value) onlyAuthByTUN external {
147         stringStorage[_key] = _value;
148     }
149 
150     /// @param _key The key for the record
151     function setUint(bytes32 _key, uint _value) onlyAuthByTUN external {
152         uIntStorage[_key] = _value;
153     }
154 
155 
156     /***************************************************************************
157      * Initialize all delete methods.
158      */
159 
160     /// @param _key The key for the record
161     function deleteAddress(bytes32 _key) onlyAuthByTUN external {
162         delete addressStorage[_key];
163     }
164 
165     /// @param _key The key for the record
166     function deleteBool(bytes32 _key) onlyAuthByTUN external {
167         delete boolStorage[_key];
168     }
169 
170     /// @param _key The key for the record
171     function deleteBytes(bytes32 _key) onlyAuthByTUN external {
172         delete bytesStorage[_key];
173     }
174 
175     /// @param _key The key for the record
176     function deleteInt(bytes32 _key) onlyAuthByTUN external {
177         delete intStorage[_key];
178     }
179 
180     /// @param _key The key for the record
181     function deleteString(bytes32 _key) onlyAuthByTUN external {
182         delete stringStorage[_key];
183     }
184 
185     /// @param _key The key for the record
186     function deleteUint(bytes32 _key) onlyAuthByTUN external {
187         delete uIntStorage[_key];
188     }
189 }