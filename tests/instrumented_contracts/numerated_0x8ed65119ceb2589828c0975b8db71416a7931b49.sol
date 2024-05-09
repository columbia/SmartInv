1 // File: src/main/solidity/zeppelin-solidity/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev Give an account access to this role.
16      */
17     function add(Role storage role, address account) internal {
18         require(!has(role, account), "Roles: account already has role");
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev Remove an account's access to this role.
24      */
25     function remove(Role storage role, address account) internal {
26         require(has(role, account), "Roles: account does not have role");
27         role.bearer[account] = false;
28     }
29 
30     /**
31      * @dev Check if an account has this role.
32      * @return bool
33      */
34     function has(Role storage role, address account) internal view returns (bool) {
35         require(account != address(0), "Roles: account is the zero address");
36         return role.bearer[account];
37     }
38 }
39 
40 // File: src/main/solidity/zeppelin-solidity/contracts/access/roles/PauserRole.sol
41 
42 pragma solidity ^0.5.0;
43 
44 
45 contract PauserRole {
46     using Roles for Roles.Role;
47 
48     event PauserAdded(address indexed account);
49     event PauserRemoved(address indexed account);
50 
51     Roles.Role private _pausers;
52 
53     constructor () internal {
54         _addPauser(msg.sender);
55     }
56 
57     modifier onlyPauser() {
58         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
59         _;
60     }
61 
62     function isPauser(address account) public view returns (bool) {
63         return _pausers.has(account);
64     }
65 
66     function addPauser(address account) public onlyPauser {
67         _addPauser(account);
68     }
69 
70     function renouncePauser() public {
71         _removePauser(msg.sender);
72     }
73 
74     function _addPauser(address account) internal {
75         _pausers.add(account);
76         emit PauserAdded(account);
77     }
78 
79     function _removePauser(address account) internal {
80         _pausers.remove(account);
81         emit PauserRemoved(account);
82     }
83 }
84 
85 // File: src/main/solidity/zeppelin-solidity/contracts/lifecycle/Pausable.sol
86 
87 pragma solidity ^0.5.0;
88 
89 
90 /**
91  * @dev Contract module which allows children to implement an emergency stop
92  * mechanism that can be triggered by an authorized account.
93  *
94  * This module is used through inheritance. It will make available the
95  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
96  * the functions of your contract. Note that they will not be pausable by
97  * simply including this module, only once the modifiers are put in place.
98  */
99 contract Pausable is PauserRole {
100     /**
101      * @dev Emitted when the pause is triggered by a pauser (`account`).
102      */
103     event Paused(address account);
104 
105     /**
106      * @dev Emitted when the pause is lifted by a pauser (`account`).
107      */
108     event Unpaused(address account);
109 
110     bool private _paused;
111 
112     /**
113      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
114      * to the deployer.
115      */
116     constructor () internal {
117         _paused = false;
118     }
119 
120     /**
121      * @dev Returns true if the contract is paused, and false otherwise.
122      */
123     function paused() public view returns (bool) {
124         return _paused;
125     }
126 
127     /**
128      * @dev Modifier to make a function callable only when the contract is not paused.
129      */
130     modifier whenNotPaused() {
131         require(!_paused, "Pausable: paused");
132         _;
133     }
134 
135     /**
136      * @dev Modifier to make a function callable only when the contract is paused.
137      */
138     modifier whenPaused() {
139         require(_paused, "Pausable: not paused");
140         _;
141     }
142 
143     /**
144      * @dev Called by a pauser to pause, triggers stopped state.
145      */
146     function pause() public onlyPauser whenNotPaused {
147         _paused = true;
148         emit Paused(msg.sender);
149     }
150 
151     /**
152      * @dev Called by a pauser to unpause, returns to normal state.
153      */
154     function unpause() public onlyPauser whenPaused {
155         _paused = false;
156         emit Unpaused(msg.sender);
157     }
158 }
159 
160 // File: src/main/solidity/zeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
161 
162 pragma solidity ^0.5.0;
163 
164 
165 /**
166  * @title WhitelistAdminRole
167  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
168  */
169 contract WhitelistAdminRole {
170     using Roles for Roles.Role;
171 
172     event WhitelistAdminAdded(address indexed account);
173     event WhitelistAdminRemoved(address indexed account);
174 
175     Roles.Role private _whitelistAdmins;
176 
177     constructor () internal {
178         _addWhitelistAdmin(msg.sender);
179     }
180 
181     modifier onlyWhitelistAdmin() {
182         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
183         _;
184     }
185 
186     function isWhitelistAdmin(address account) public view returns (bool) {
187         return _whitelistAdmins.has(account);
188     }
189 
190     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
191         _addWhitelistAdmin(account);
192     }
193 
194     function renounceWhitelistAdmin() public {
195         _removeWhitelistAdmin(msg.sender);
196     }
197 
198     function _addWhitelistAdmin(address account) internal {
199         _whitelistAdmins.add(account);
200         emit WhitelistAdminAdded(account);
201     }
202 
203     function _removeWhitelistAdmin(address account) internal {
204         _whitelistAdmins.remove(account);
205         emit WhitelistAdminRemoved(account);
206     }
207 }
208 
209 // File: src/main/solidity/CrowdliKYCProvider.sol
210 
211 pragma solidity 0.5.0;
212 
213 
214 
215 contract CrowdliKYCProvider is Pausable, WhitelistAdminRole {
216 
217 	/**
218 	 * The verification levels supported by this ICO
219 	 */
220 	enum VerificationTier { None, KYCAccepted, VideoVerified, ExternalTokenAgent } 
221     
222     /**
223      * Defines the max. amount of tokens an investor can purchase for a given verification level (tier)
224      */
225 	mapping (uint => uint) public maxTokenAmountPerTier; 
226     
227     /**
228     * Dictionary that maps addresses to investors which have successfully been verified by the external KYC process
229     */
230     mapping (address => VerificationTier) public verificationTiers;
231 
232     /**
233     * This event is fired when a user has been successfully verified by the external KYC verification process
234     */
235     event LogKYCConfirmation(address indexed sender, VerificationTier verificationTier);
236 
237 	/**
238 	 * This constructor initializes a new  CrowdliKYCProvider initializing the provided token amount threshold for the supported verification tiers
239 	 */
240     constructor(address _kycConfirmer, uint _maxTokenForKYCAcceptedTier, uint _maxTokensForVideoVerifiedTier, uint _maxTokensForExternalTokenAgent) public {
241         addWhitelistAdmin(_kycConfirmer);
242         // Max token amount for non-verified investors
243         maxTokenAmountPerTier[uint(VerificationTier.None)] = 0;
244         
245         // Max token amount for auto KYC auto verified investors
246         maxTokenAmountPerTier[uint(VerificationTier.KYCAccepted)] = _maxTokenForKYCAcceptedTier;
247         
248         // Max token amount for auto KYC video verified investors
249         maxTokenAmountPerTier[uint(VerificationTier.VideoVerified)] = _maxTokensForVideoVerifiedTier;
250         
251         // Max token amount for external token sell providers
252         maxTokenAmountPerTier[uint(VerificationTier.ExternalTokenAgent)] = _maxTokensForExternalTokenAgent;
253     }
254 
255     function confirmKYC(address _addressId, VerificationTier _verificationTier) public onlyWhitelistAdmin whenNotPaused {
256         emit LogKYCConfirmation(_addressId, _verificationTier);
257         verificationTiers[_addressId] = _verificationTier;
258     }
259 
260     function hasVerificationLevel(address _investor, VerificationTier _verificationTier) public view returns (bool) {
261         return (verificationTiers[_investor] == _verificationTier);
262     }
263     
264     function getMaxChfAmountForInvestor(address _investor) public view returns (uint) {
265         return maxTokenAmountPerTier[uint(verificationTiers[_investor])];
266     }    
267 }