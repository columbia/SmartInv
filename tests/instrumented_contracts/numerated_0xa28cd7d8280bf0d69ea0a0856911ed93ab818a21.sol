1 pragma solidity ^0.4.1;
2 
3 contract Destination {
4     function recover(address _from, address _to) returns(bool);
5 }
6 
7 contract RecoveryWithTenant {
8     event Recovery(uint indexed nonce, address indexed from, address indexed to);
9     event Setup(uint indexed nonce, address indexed user);
10     
11     //1: user not existing
12     //2: conflict, user exists already
13     //3: signature not by tenant
14     //4: nonce/signature used before
15     //5: contract call failed
16     //6: oracle access denied
17     //8: requested user not found
18     event Error(uint indexed nonce, uint code);
19     
20     struct User {
21         address addr;
22     }
23     
24     mapping (address => uint) userIndex;
25     User[] public users;
26 
27     address public oracle;
28     address public tenant;
29     mapping(uint => bool) nonceUsed;
30     address public callDestination;
31 
32 
33     modifier onlyOracle() {
34         if (msg.sender == oracle) {
35             _;
36         }
37         Error(0, 6);
38     }
39     
40     modifier noEther() {
41         if (msg.value > 0) throw;
42         _;
43     }
44 
45     function RecoveryWithTenant() {
46         oracle = msg.sender;
47         tenant = msg.sender;
48         users.length++;
49     }
50     
51     //############# INTERNAL FUNCTIONS
52     
53     function _checkSigned(bytes32 _hash, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool) {
54         address recovered = ecrecover(_hash, _v, _r, _s);
55 
56         if (tenant != recovered) {
57             Error(_nonce, 3);
58             return false;
59         }
60         if (nonceUsed[_nonce]) {
61             Error(_nonce, 4);
62             return false;
63         }
64         nonceUsed[_nonce] = true; 
65         return true;
66     }
67     
68     
69     //############# PUBLIC FUNCTIONS
70     
71     function setOracle(address _newOracle) noEther onlyOracle {
72         oracle = _newOracle;
73     }
74     
75     function configure(address _tenant, address _callDestination, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) noEther onlyOracle returns (bool) {
76         if(tenant != oracle && !_checkSigned(sha3(_tenant, _callDestination, _nonce), _nonce, _v, _r, _s))
77             return false;
78         tenant = _tenant;
79         callDestination = _callDestination;
80         return true;
81     }
82     
83     
84     function addUser(address _userAddr, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) noEther onlyOracle returns (bool) {
85         if(userIndex[_userAddr] > 0) {
86             Error(_nonce, 2);
87             return false;
88         }
89         if(!_checkSigned(sha3(_userAddr, _nonce), _nonce, _v, _r, _s))
90             return false;
91         uint posUser = users.length++;
92         userIndex[_userAddr] = posUser;
93         users[posUser] = User(_userAddr);
94         Setup(_nonce, _userAddr);
95         return true;
96     }
97     
98     function recoverUser(address _oldAddr, address _newAddr, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) noEther onlyOracle returns (bool) {
99         uint userPos = userIndex[_oldAddr];
100         if (userPos == 0) {
101             Error(_nonce, 1); //user doesn't exsit
102             return false;
103         }
104         
105         if (!_checkSigned(sha3(_oldAddr, _newAddr, _nonce), _nonce, _v, _r, _s))
106             return false;
107         bool result = Destination(callDestination).recover(_oldAddr, _newAddr);
108         if (result) {
109             users[userPos].addr = _newAddr;
110             delete userIndex[_oldAddr];
111             userIndex[_newAddr] = userPos;
112             Recovery(_nonce, _oldAddr, _newAddr);
113             return true;
114         }
115         Error(_nonce, 5);
116         return false;
117     }
118 
119     function () noEther {
120         throw;
121     }
122     
123     //############# STATIC FUNCTIONS
124     
125     function isUser(address _userAddr) constant returns (bool) {
126         return (userIndex[_userAddr] > 0);
127     }
128 
129 }