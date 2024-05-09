1 // File: contracts/interfaces/IModerator.sol
2 
3 pragma solidity 0.5.4;
4 
5 
6 interface IModerator {
7     function verifyIssue(address _tokenHolder, uint256 _value, bytes calldata _data) external view
8         returns (bool allowed, byte statusCode, bytes32 applicationCode);
9 
10     function verifyTransfer(address _from, address _to, uint256 _amount, bytes calldata _data) external view 
11         returns (bool allowed, byte statusCode, bytes32 applicationCode);
12 
13     function verifyTransferFrom(address _from, address _to, address _forwarder, uint256 _amount, bytes calldata _data) external view 
14         returns (bool allowed, byte statusCode, bytes32 applicationCode);
15 
16     function verifyRedeem(address _sender, uint256 _amount, bytes calldata _data) external view 
17         returns (bool allowed, byte statusCode, bytes32 applicationCode);
18 
19     function verifyRedeemFrom(address _sender, address _tokenHolder, uint256 _amount, bytes calldata _data) external view
20         returns (bool allowed, byte statusCode, bytes32 applicationCode);        
21 
22     function verifyControllerTransfer(address _controller, address _from, address _to, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external view
23         returns (bool allowed, byte statusCode, bytes32 applicationCode);
24 
25     function verifyControllerRedeem(address _controller, address _tokenHolder, uint256 _value, bytes calldata _data, bytes calldata _operatorData) external view
26         returns (bool allowed, byte statusCode, bytes32 applicationCode);
27 }
28 
29 // File: openzeppelin-solidity/contracts/access/Roles.sol
30 
31 pragma solidity ^0.5.2;
32 
33 /**
34  * @title Roles
35  * @dev Library for managing addresses assigned to a Role.
36  */
37 library Roles {
38     struct Role {
39         mapping (address => bool) bearer;
40     }
41 
42     /**
43      * @dev give an account access to this role
44      */
45     function add(Role storage role, address account) internal {
46         require(account != address(0));
47         require(!has(role, account));
48 
49         role.bearer[account] = true;
50     }
51 
52     /**
53      * @dev remove an account's access to this role
54      */
55     function remove(Role storage role, address account) internal {
56         require(account != address(0));
57         require(has(role, account));
58 
59         role.bearer[account] = false;
60     }
61 
62     /**
63      * @dev check if an account has this role
64      * @return bool
65      */
66     function has(Role storage role, address account) internal view returns (bool) {
67         require(account != address(0));
68         return role.bearer[account];
69     }
70 }
71 
72 // File: contracts/roles/ModeratorRole.sol
73 
74 pragma solidity 0.5.4;
75 
76 
77 
78 // @notice Moderators are able to modify whitelists and transfer permissions in Moderator contracts.
79 contract ModeratorRole {
80     using Roles for Roles.Role;
81 
82     event ModeratorAdded(address indexed account);
83     event ModeratorRemoved(address indexed account);
84 
85     Roles.Role internal _moderators;
86 
87     modifier onlyModerator() {
88         require(isModerator(msg.sender), "Only Moderators can execute this function.");
89         _;
90     }
91 
92     constructor() internal {
93         _addModerator(msg.sender);
94     }
95 
96     function isModerator(address account) public view returns (bool) {
97         return _moderators.has(account);
98     }
99 
100     function addModerator(address account) public onlyModerator {
101         _addModerator(account);
102     }
103 
104     function renounceModerator() public {
105         _removeModerator(msg.sender);
106     }    
107 
108     function _addModerator(address account) internal {
109         _moderators.add(account);
110         emit ModeratorAdded(account);
111     }    
112 
113     function _removeModerator(address account) internal {
114         _moderators.remove(account);
115         emit ModeratorRemoved(account);
116     }
117 }
118 
119 // File: contracts/lib/Blacklistable.sol
120 
121 pragma solidity 0.5.4;
122 
123 
124 
125 contract Blacklistable is ModeratorRole {
126     event Blacklisted(address account);
127     event Unblacklisted(address account);
128 
129     mapping (address => bool) public isBlacklisted;
130 
131     modifier onlyBlacklisted(address account) {
132         require(isBlacklisted[account], "Account is not blacklisted.");
133         _;
134     }
135 
136     modifier onlyNotBlacklisted(address account) {
137         require(!isBlacklisted[account], "Account is blacklisted.");
138         _;
139     }
140 
141     function blacklist(address account) external onlyModerator {
142         require(account != address(0), "Cannot blacklist zero address.");
143         require(account != msg.sender, "Cannot blacklist self.");
144         require(!isBlacklisted[account], "Address already blacklisted.");
145         isBlacklisted[account] = true;
146         emit Blacklisted(account);
147     }
148 
149     function unblacklist(address account) external onlyModerator {
150         require(account != address(0), "Cannot unblacklist zero address.");
151         require(account != msg.sender, "Cannot unblacklist self.");
152         require(isBlacklisted[account], "Address not blacklisted.");
153         isBlacklisted[account] = false;
154         emit Unblacklisted(account);
155     }
156 }
157 
158 // File: contracts/compliance/BlacklistModerator.sol
159 
160 pragma solidity 0.5.4;
161 
162 
163 
164 
165 contract BlacklistModerator is IModerator, Blacklistable {
166     byte internal constant STATUS_TRANSFER_FAILURE = 0x50; // Uses status codes from ERC-1066
167     byte internal constant STATUS_TRANSFER_SUCCESS = 0x51;
168 
169     bytes32 internal constant ALLOWED_APPLICATION_CODE = keccak256("org.tenx.allowed");
170     bytes32 internal constant FORBIDDEN_APPLICATION_CODE = keccak256("org.tenx.forbidden");
171 
172     function verifyIssue(address _account, uint256, bytes calldata) external view
173         returns (bool allowed, byte statusCode, bytes32 applicationCode) 
174     {
175         if (isAllowed(_account)) {
176             allowed = true;
177             statusCode = STATUS_TRANSFER_SUCCESS;
178             applicationCode = ALLOWED_APPLICATION_CODE;
179         } else {
180             allowed = false;
181             statusCode = STATUS_TRANSFER_FAILURE;
182             applicationCode = FORBIDDEN_APPLICATION_CODE;
183         }
184     }
185 
186     function verifyTransfer(address _from, address _to, uint256, bytes calldata) external view 
187         returns (bool allowed, byte statusCode, bytes32 applicationCode) 
188     {
189         if (isAllowed(_from) && isAllowed(_to)) {
190             allowed = true;
191             statusCode = STATUS_TRANSFER_SUCCESS;
192             applicationCode = ALLOWED_APPLICATION_CODE;
193         } else {
194             allowed = false;
195             statusCode = STATUS_TRANSFER_FAILURE;
196             applicationCode = FORBIDDEN_APPLICATION_CODE;
197         }
198     }
199 
200     function verifyTransferFrom(address _from, address _to, address _sender, uint256, bytes calldata) external view 
201         returns (bool allowed, byte statusCode, bytes32 applicationCode) 
202     {
203         if (isAllowed(_from) && isAllowed(_to) && isAllowed(_sender)) {
204             allowed = true;
205             statusCode = STATUS_TRANSFER_SUCCESS;
206             applicationCode = ALLOWED_APPLICATION_CODE;
207         } else {
208             allowed = false;
209             statusCode = STATUS_TRANSFER_FAILURE;
210             applicationCode = FORBIDDEN_APPLICATION_CODE;
211         }
212     }
213 
214     function verifyRedeem(address _sender, uint256, bytes calldata) external view 
215         returns (bool allowed, byte statusCode, bytes32 applicationCode) 
216     {
217         if (isAllowed(_sender)) {
218             allowed = true;
219             statusCode = STATUS_TRANSFER_SUCCESS;
220             applicationCode = ALLOWED_APPLICATION_CODE;
221         } else {
222             allowed = false;
223             statusCode = STATUS_TRANSFER_FAILURE;
224             applicationCode = FORBIDDEN_APPLICATION_CODE;
225         }
226     }
227 
228     function verifyRedeemFrom(address _sender, address _tokenHolder, uint256, bytes calldata) external view 
229         returns (bool allowed, byte statusCode, bytes32 applicationCode) 
230     {
231         if (isAllowed(_sender) && isAllowed(_tokenHolder)) {
232             allowed = true;
233             statusCode = STATUS_TRANSFER_SUCCESS;
234             applicationCode = ALLOWED_APPLICATION_CODE;
235         } else {
236             allowed = false;
237             statusCode = STATUS_TRANSFER_FAILURE;
238             applicationCode = FORBIDDEN_APPLICATION_CODE;
239         }
240     }        
241 
242     function verifyControllerTransfer(address, address, address, uint256, bytes calldata, bytes calldata) external view 
243         returns (bool allowed, byte statusCode, bytes32 applicationCode) 
244     {
245         allowed = true;
246         statusCode = STATUS_TRANSFER_SUCCESS;
247         applicationCode = ALLOWED_APPLICATION_CODE;
248     }
249 
250     function verifyControllerRedeem(address, address, uint256, bytes calldata, bytes calldata) external view 
251         returns (bool allowed, byte statusCode, bytes32 applicationCode) 
252     {
253         allowed = true;
254         statusCode = STATUS_TRANSFER_SUCCESS;
255         applicationCode = ALLOWED_APPLICATION_CODE;
256     }
257 
258     function isAllowed(address _account) internal view returns (bool) {
259         return !isBlacklisted[_account];
260     }
261 }