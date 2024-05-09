1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title InstaIndex
6  * @dev Main Contract For DeFi Smart Accounts. This is also a factory contract, Which deploys new Smart Account.
7  * Also Registry for DeFi Smart Accounts.
8  */
9 
10 interface AccountInterface {
11     function version() external view returns (uint);
12     function enable(address authority) external;
13     function cast(address[] calldata _targets, bytes[] calldata _datas, address _origin) external payable returns (bytes32[] memory responses);
14 }
15 
16 interface ListInterface {
17     function init(address _account) external;
18 }
19 
20 contract AddressIndex {
21 
22     event LogNewMaster(address indexed master);
23     event LogUpdateMaster(address indexed master);
24     event LogNewCheck(uint indexed accountVersion, address indexed check);
25     event LogNewAccount(address indexed _newAccount, address indexed _connectors, address indexed _check);
26 
27     // New Master Address.
28     address private newMaster;
29     // Master Address.
30     address public master;
31     // List Registry Address.
32     address public list;
33 
34     // Connectors Modules(Account Module Version => Connectors Registry Module Address).
35     mapping (uint => address) public connectors;
36     // Check Modules(Account Module Version => Check Module Address).
37     mapping (uint => address) public check;
38     // Account Modules(Account Module Version => Account Module Address).
39     mapping (uint => address) public account;
40     // Version Count of Account Modules.
41     uint public versionCount;
42 
43     /**
44     * @dev Throws if the sender not is Master Address.
45     */
46     modifier isMaster() {
47         require(msg.sender == master, "not-master");
48         _;
49     }
50 
51     /**
52      * @dev Change the Master Address.
53      * @param _newMaster New Master Address.
54      */
55     function changeMaster(address _newMaster) external isMaster {
56         require(_newMaster != master, "already-a-master");
57         require(_newMaster != address(0), "not-valid-address");
58         require(newMaster != _newMaster, "already-a-new-master");
59         newMaster = _newMaster;
60         emit LogNewMaster(_newMaster);
61     }
62 
63     function updateMaster() external {
64         require(newMaster != address(0), "not-valid-address");
65         require(msg.sender == newMaster, "not-master");
66         master = newMaster;
67         newMaster = address(0);
68         emit LogUpdateMaster(master);
69     }
70 
71     /**
72      * @dev Change the Check Address of a specific Account Module version.
73      * @param accountVersion Account Module version.
74      * @param _newCheck The New Check Address.
75      */
76     function changeCheck(uint accountVersion, address _newCheck) external isMaster {
77         require(_newCheck != check[accountVersion], "already-a-check");
78         check[accountVersion] = _newCheck;
79         emit LogNewCheck(accountVersion, _newCheck);
80     }
81 
82     /**
83      * @dev Add New Account Module.
84      * @param _newAccount The New Account Module Address.
85      * @param _connectors Connectors Registry Module Address.
86      * @param _check Check Module Address.
87      */
88     function addNewAccount(address _newAccount, address _connectors, address _check) external isMaster {
89         require(_newAccount != address(0), "not-valid-address");
90         versionCount++;
91         require(AccountInterface(_newAccount).version() == versionCount, "not-valid-version");
92         account[versionCount] = _newAccount;
93         if (_connectors != address(0)) connectors[versionCount] = _connectors;
94         if (_check != address(0)) check[versionCount] = _check;
95         emit LogNewAccount(_newAccount, _connectors, _check);
96     }
97 
98 }
99 
100 contract CloneFactory is AddressIndex {
101     /**
102      * @dev Clone a new Account Module.
103      * @param version Account Module version to clone.
104      */
105     function createClone(uint version) internal returns (address result) {
106         bytes20 targetBytes = bytes20(account[version]);
107         // solium-disable-next-line security/no-inline-assembly
108         assembly {
109             let clone := mload(0x40)
110             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
111             mstore(add(clone, 0x14), targetBytes)
112             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
113             result := create(0, clone, 0x37)
114         }
115     }
116 
117     /**
118      * @dev Check if Account Module is a clone.
119      * @param version Account Module version.
120      * @param query Account Module Address.
121      */
122     function isClone(uint version, address query) external view returns (bool result) {
123         bytes20 targetBytes = bytes20(account[version]);
124         // solium-disable-next-line security/no-inline-assembly
125         assembly {
126             let clone := mload(0x40)
127             mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
128             mstore(add(clone, 0xa), targetBytes)
129             mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
130 
131             let other := add(clone, 0x40)
132             extcodecopy(query, other, 0, 0x2d)
133             result := and(
134                 eq(mload(clone), mload(other)),
135                 eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
136             )
137         }
138     }
139 }
140 
141 contract InstaIndex is CloneFactory {
142 
143     event LogAccountCreated(address sender, address indexed owner, address indexed account, address indexed origin);
144 
145     /**
146      * @dev Create a new DeFi Smart Account for a user and run cast function in the new Smart Account.
147      * @param _owner Owner of the Smart Account.
148      * @param accountVersion Account Module version.
149      * @param _targets Array of Target to run cast function.
150      * @param _datas Array of Data(callData) to run cast function.
151      * @param _origin Where Smart Account is created.
152      */
153     function buildWithCast(
154         address _owner,
155         uint accountVersion,
156         address[] calldata _targets,
157         bytes[] calldata _datas,
158         address _origin
159     ) external payable returns (address _account) {
160         _account = build(_owner, accountVersion, _origin);
161         if (_targets.length > 0) AccountInterface(_account).cast.value(msg.value)(_targets, _datas, _origin);
162     }
163 
164     /**
165      * @dev Create a new DeFi Smart Account for a user.
166      * @param _owner Owner of the Smart Account.
167      * @param accountVersion Account Module version.
168      * @param _origin Where Smart Account is created.
169      */
170     function build(
171         address _owner,
172         uint accountVersion,
173         address _origin
174     ) public returns (address _account) {
175         require(accountVersion != 0 && accountVersion <= versionCount, "not-valid-account");
176         _account = createClone(accountVersion);
177         ListInterface(list).init(_account);
178         AccountInterface(_account).enable(_owner);
179         emit LogAccountCreated(msg.sender, _owner, _account, _origin);
180     }
181 
182     /**
183      * @dev Setup Initial things for InstaIndex, after its been deployed and can be only run once.
184      * @param _master The Master Address.
185      * @param _list The List Address.
186      * @param _account The Account Module Address.
187      * @param _connectors The Connectors Registry Module Address.
188      */
189     function setBasics(
190         address _master,
191         address _list,
192         address _account,
193         address _connectors
194     ) external {
195         require(
196             master == address(0) &&
197             list == address(0) &&
198             account[1] == address(0) &&
199             connectors[1] == address(0) &&
200             versionCount == 0,
201             "already-defined"
202         );
203         master = _master;
204         list = _list;
205         versionCount++;
206         account[versionCount] = _account;
207         connectors[versionCount] = _connectors;
208     }
209 
210 }