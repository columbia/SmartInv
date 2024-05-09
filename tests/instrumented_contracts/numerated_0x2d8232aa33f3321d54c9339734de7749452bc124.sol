1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interfaces/IOwned.sol
4 
5 /*
6     Owned Contract Interface
7 */
8 contract IOwned {
9     function transferOwnership(address _newOwner) public;
10     function acceptOwnership() public;
11     function transferOwnershipNow(address newContractOwner) public;
12 }
13 
14 // File: contracts/utility/Owned.sol
15 
16 /*
17     This is the "owned" utility contract used by bancor with one additional function - transferOwnershipNow()
18     
19     The original unmodified version can be found here:
20     https://github.com/bancorprotocol/contracts/commit/63480ca28534830f184d3c4bf799c1f90d113846
21     
22     Provides support and utilities for contract ownership
23 */
24 contract Owned is IOwned {
25     address public owner;
26     address public newOwner;
27 
28     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
29 
30     /**
31         @dev constructor
32     */
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     // allows execution by the owner only
38     modifier ownerOnly {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     /**
44         @dev allows transferring the contract ownership
45         the new owner still needs to accept the transfer
46         can only be called by the contract owner
47         @param _newOwner    new contract owner
48     */
49     function transferOwnership(address _newOwner) public ownerOnly {
50         require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53 
54     /**
55         @dev used by a new owner to accept an ownership transfer
56     */
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnerUpdate(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 
64     /**
65         @dev transfers the contract ownership without needing the new owner to accept ownership
66         @param newContractOwner    new contract owner
67     */
68     function transferOwnershipNow(address newContractOwner) ownerOnly public {
69         require(newContractOwner != owner);
70         emit OwnerUpdate(owner, newContractOwner);
71         owner = newContractOwner;
72     }
73 
74 }
75 
76 // File: contracts/interfaces/ILogger.sol
77 
78 /*
79     Logger Contract Interface
80 */
81 
82 contract ILogger {
83     function addNewLoggerPermission(address addressToPermission) public;
84     function emitTaskCreated(uint uuid, uint amount) public;
85     function emitProjectCreated(uint uuid, uint amount, address rewardAddress) public;
86     function emitNewSmartToken(address token) public;
87     function emitIssuance(uint256 amount) public;
88     function emitDestruction(uint256 amount) public;
89     function emitTransfer(address from, address to, uint256 value) public;
90     function emitApproval(address owner, address spender, uint256 value) public;
91     function emitGenericLog(string messageType, string message) public;
92 }
93 
94 // File: contracts/Logger.sol
95 
96 /*
97 
98 Centralized logger allows backend to easily watch all events on all communities without needing to watch each community individually
99 
100 */
101 contract Logger is Owned, ILogger  {
102 
103     // Community
104     event TaskCreated(address msgSender, uint _uuid, uint _amount);
105     event ProjectCreated(address msgSender, uint _uuid, uint _amount, address _address);
106 
107     // SmartToken
108     // triggered when a smart token is deployed - the _token address is defined for forward compatibility
109     //  in case we want to trigger the event from a factory
110     event NewSmartToken(address msgSender, address _token);
111     // triggered when the total supply is increased
112     event Issuance(address msgSender, uint256 _amount);
113     // triggered when the total supply is decreased
114     event Destruction(address msgSender, uint256 _amount);
115     // erc20
116     event Transfer(address msgSender, address indexed _from, address indexed _to, uint256 _value);
117     event Approval(address msgSender, address indexed _owner, address indexed _spender, uint256 _value);
118 
119     // Logger
120     event NewCommunityAddress(address msgSender, address _newAddress);
121 
122     event GenericLog(address msgSender, string messageType, string message);
123     mapping (address => bool) public permissionedAddresses;
124 
125     modifier hasLoggerPermissions(address _address) {
126         require(permissionedAddresses[_address] == true);
127         _;
128     }
129 
130     function addNewLoggerPermission(address addressToPermission) ownerOnly public {
131         permissionedAddresses[addressToPermission] = true;
132     }
133 
134     function emitTaskCreated(uint uuid, uint amount) public hasLoggerPermissions(msg.sender) {
135         emit TaskCreated(msg.sender, uuid, amount);
136     }
137 
138     function emitProjectCreated(uint uuid, uint amount, address rewardAddress) public hasLoggerPermissions(msg.sender) {
139         emit ProjectCreated(msg.sender, uuid, amount, rewardAddress);
140     }
141 
142     function emitNewSmartToken(address token) public hasLoggerPermissions(msg.sender) {
143         emit NewSmartToken(msg.sender, token);
144     }
145 
146     function emitIssuance(uint256 amount) public hasLoggerPermissions(msg.sender) {
147         emit Issuance(msg.sender, amount);
148     }
149 
150     function emitDestruction(uint256 amount) public hasLoggerPermissions(msg.sender) {
151         emit Destruction(msg.sender, amount);
152     }
153 
154     function emitTransfer(address from, address to, uint256 value) public hasLoggerPermissions(msg.sender) {
155         emit Transfer(msg.sender, from, to, value);
156     }
157 
158     function emitApproval(address owner, address spender, uint256 value) public hasLoggerPermissions(msg.sender) {
159         emit Approval(msg.sender, owner, spender, value);
160     }
161 
162     function emitGenericLog(string messageType, string message) public hasLoggerPermissions(msg.sender) {
163         emit GenericLog(msg.sender, messageType, message);
164     }
165 }