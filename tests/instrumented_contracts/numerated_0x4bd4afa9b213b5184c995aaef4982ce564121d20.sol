1 contract Destination {
2     function recover(address _from, address _to) returns(bool);
3 }
4 
5 contract RecoveryWithTenant {
6     event Recovery(uint indexed nonce, address indexed from, address indexed to);
7     event Setup(uint indexed nonce, address indexed user);
8     
9     //1: user not existing
10     //2: conflict, user exists already
11     //3: signature not by tenant
12     //4: nonce/signature used before
13     //5: contract call failed
14     //6: oracle access denied
15     //8: requested user not found
16     event Error(uint indexed nonce, uint code);
17     
18     struct User {
19         address addr;
20     }
21     
22     mapping (address => uint) userIndex;
23     User[] public users;
24 
25     address public oracle;
26     address public tenant;
27     mapping(uint => bool) nonceUsed;
28     address public callDestination;
29 
30 
31     modifier onlyOracle() {
32         if (msg.sender == oracle) {
33             _
34         }
35         Error(0, 6);
36     }
37     
38     modifier noEther() {
39         if (msg.value > 0) throw;
40         _
41     }
42 
43     function RecoveryWithTenant() {
44         oracle = msg.sender;
45         tenant = msg.sender;
46         users.length++;
47     }
48     
49     //############# INTERNAL FUNCTIONS
50     
51     function _checkSigned(bytes32 _hash, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool) {
52         address recovered = ecrecover(_hash, _v, _r, _s);
53 
54         if (tenant != recovered) {
55             Error(_nonce, 3);
56             return false;
57         }
58         if (nonceUsed[_nonce]) {
59             Error(_nonce, 4);
60             return false;
61         }
62         nonceUsed[_nonce] = true; 
63         return true;
64     }
65     
66     
67     //############# PUBLIC FUNCTIONS
68     
69     function setOracle(address _newOracle) noEther onlyOracle {
70         oracle = _newOracle;
71     }
72     
73     function configure(address _tenant, address _callDestination, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) noEther onlyOracle returns (bool) {
74         if(tenant != oracle && !_checkSigned(sha3(_tenant, _callDestination, _nonce), _nonce, _v, _r, _s))
75             return false;
76         tenant = _tenant;
77         callDestination = _callDestination;
78         return true;
79     }
80     
81     
82     function addUser(address _userAddr, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) noEther onlyOracle returns (bool) {
83         if(userIndex[_userAddr] > 0) {
84             Error(_nonce, 2);
85             return false;
86         }
87         if(!_checkSigned(sha3(_userAddr, _nonce), _nonce, _v, _r, _s))
88             return false;
89         uint posUser = users.length++;
90         userIndex[_userAddr] = posUser;
91         users[posUser] = User(_userAddr);
92         Setup(_nonce, _userAddr);
93         return true;
94     }
95     
96     function recoverUser(address _oldAddr, address _newAddr, uint _nonce, uint8 _v, bytes32 _r, bytes32 _s) noEther onlyOracle returns (bool) {
97         uint userPos = userIndex[_oldAddr];
98         if (userPos == 0) {
99             Error(_nonce, 1); //user doesn't exsit
100             return false;
101         }
102         
103         if (!_checkSigned(sha3(_oldAddr, _newAddr, _nonce), _nonce, _v, _r, _s))
104             return false;
105         bool result = Destination(callDestination).recover(_oldAddr, _newAddr);
106         if (result) {
107             users[userPos].addr = _newAddr;
108             Recovery(_nonce, _oldAddr, _newAddr);
109             return true;
110         }
111         Error(_nonce, 5);
112         return false;
113     }
114 
115     function () noEther {
116         throw;
117     }
118     
119     //############# STATIC FUNCTIONS
120     
121     function isUser(address _userAddr) constant returns (bool) {
122         return (userIndex[_userAddr] > 0);
123     }
124 
125 }