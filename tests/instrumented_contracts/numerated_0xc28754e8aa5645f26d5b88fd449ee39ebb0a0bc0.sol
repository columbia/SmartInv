1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title InstaAccount.
6  * @dev DeFi Smart Account Wallet.
7  */
8 
9 interface IndexInterface {
10     function connectors(uint version) external view returns (address);
11     function check(uint version) external view returns (address);
12     function list() external view returns (address);
13 }
14 
15 interface ConnectorsInterface {
16     function isConnector(address[] calldata logicAddr) external view returns (bool);
17     function isStaticConnector(address[] calldata logicAddr) external view returns (bool);
18 }
19 
20 interface CheckInterface {
21     function isOk() external view returns (bool);
22 }
23 
24 interface ListInterface {
25     function addAuth(address user) external;
26     function removeAuth(address user) external;
27 }
28 
29 
30 contract Record {
31 
32     event LogEnable(address indexed user);
33     event LogDisable(address indexed user);
34     event LogSwitchShield(bool _shield);
35 
36     // InstaIndex Address.
37     address public constant instaIndex = 0x2971AdFa57b20E5a416aE5a708A8655A9c74f723;
38     // The Account Module Version.
39     uint public constant version = 1;
40     // Auth Module(Address of Auth => bool).
41     mapping (address => bool) private auth;
42     // Is shield true/false.
43     bool public shield;
44 
45     /**
46      * @dev Check for Auth if enabled.
47      * @param user address/user/owner.
48      */
49     function isAuth(address user) public view returns (bool) {
50         return auth[user];
51     }
52 
53     /**
54      * @dev Change Shield State.
55     */
56     function switchShield(bool _shield) external {
57         require(auth[msg.sender], "not-self");
58         require(shield != _shield, "shield is set");
59         shield = _shield;
60         emit LogSwitchShield(shield);
61     }
62 
63     /**
64      * @dev Enable New User.
65      * @param user Owner of the Smart Account.
66     */
67     function enable(address user) public {
68         require(msg.sender == address(this) || msg.sender == instaIndex, "not-self-index");
69         require(user != address(0), "not-valid");
70         require(!auth[user], "already-enabled");
71         auth[user] = true;
72         ListInterface(IndexInterface(instaIndex).list()).addAuth(user);
73         emit LogEnable(user);
74     }
75 
76     /**
77      * @dev Disable User.
78      * @param user Owner of the Smart Account.
79     */
80     function disable(address user) public {
81         require(msg.sender == address(this), "not-self");
82         require(user != address(0), "not-valid");
83         require(auth[user], "already-disabled");
84         delete auth[user];
85         ListInterface(IndexInterface(instaIndex).list()).removeAuth(user);
86         emit LogDisable(user);
87     }
88 
89 }
90 
91 contract InstaAccount is Record {
92 
93     event LogCast(address indexed origin, address indexed sender, uint value);
94 
95     receive() external payable {}
96 
97      /**
98      * @dev Delegate the calls to Connector And this function is ran by cast().
99      * @param _target Target to of Connector.
100      * @param _data CallData of function in Connector.
101     */
102     function spell(address _target, bytes memory _data) internal {
103         require(_target != address(0), "target-invalid");
104         assembly {
105             let succeeded := delegatecall(gas(), _target, add(_data, 0x20), mload(_data), 0, 0)
106 
107             switch iszero(succeeded)
108                 case 1 {
109                     // throw if delegatecall failed
110                     let size := returndatasize()
111                     returndatacopy(0x00, 0x00, size)
112                     revert(0x00, size)
113                 }
114         }
115     }
116 
117     /**
118      * @dev This is the main function, Where all the different functions are called
119      * from Smart Account.
120      * @param _targets Array of Target(s) to of Connector.
121      * @param _datas Array of Calldata(S) of function.
122     */
123     function cast(
124         address[] calldata _targets,
125         bytes[] calldata _datas,
126         address _origin
127     )
128     external
129     payable
130     {
131         require(isAuth(msg.sender) || msg.sender == instaIndex, "permission-denied");
132         require(_targets.length == _datas.length , "array-length-invalid");
133         IndexInterface indexContract = IndexInterface(instaIndex);
134         bool isShield = shield;
135         if (!isShield) {
136             require(ConnectorsInterface(indexContract.connectors(version)).isConnector(_targets), "not-connector");
137         } else {
138             require(ConnectorsInterface(indexContract.connectors(version)).isStaticConnector(_targets), "not-static-connector");
139         }
140         for (uint i = 0; i < _targets.length; i++) {
141             spell(_targets[i], _datas[i]);
142         }
143         address _check = indexContract.check(version);
144         if (_check != address(0) && !isShield) require(CheckInterface(_check).isOk(), "not-ok");
145         emit LogCast(_origin, msg.sender, msg.value);
146     }
147 
148 }