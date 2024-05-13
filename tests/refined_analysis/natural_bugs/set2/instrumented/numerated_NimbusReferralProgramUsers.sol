1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external view returns (uint8);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     function getOwner() external view returns (address);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18     address public owner;
19     address public newOwner;
20 
21     event OwnershipTransferred(address indexed from, address indexed to);
22 
23     constructor() {
24         owner = msg.sender;
25         emit OwnershipTransferred(address(0), owner);
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner, "Ownable: Caller is not the owner");
30         _;
31     }
32 
33     function getOwner() external view returns (address) {
34         return owner;
35     }
36 
37     function transferOwnership(address transferOwner) external onlyOwner {
38         require(transferOwner != newOwner);
39         newOwner = transferOwner;
40     }
41 
42     function acceptOwnership() virtual external {
43         require(msg.sender == newOwner);
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46         newOwner = address(0);
47     }
48 }
49 
50 interface INimbusReferralProgram {
51     function userSponsor(uint user) external view returns (uint);
52     function userSponsorByAddress(address user) external view returns (uint);
53     function userIdByAddress(address user) external view returns (uint);
54     function userAddressById(uint id) external view returns (address);
55     function userSponsorAddressByAddress(address user) external view returns (address);
56 }
57 
58 contract NimbusReferralProgramUsers is INimbusReferralProgram, Ownable {
59     uint public lastUserId;
60     mapping(address => uint) public override userIdByAddress;
61     mapping(uint => address) public override userAddressById;
62     mapping(uint => uint) public userCategory;
63     mapping(uint => uint) private _userSponsor;
64     mapping(uint => uint[]) private _userReferrals;
65 
66     bytes32 public immutable DOMAIN_SEPARATOR;
67     // keccak256("UpdateUserAddressBySig(uint256 id,address user,uint256 nonce,uint256 deadline)");
68     bytes32 public constant UPDATE_ADDRESS_TYPEHASH = 0x965f73b57f3777233e641e140ef6fc17fb3dd7594d04c94df9e3bc6f8531614b;
69     // keccak256("UpdateUserDataBySig(uint256 id,address user,bytes32 refHash,uint256 nonce,uint256 deadline)");
70     bytes32 public constant UPDATE_DATA_TYPEHASG = 0x48b1ff889c9b587c3e7ddba4a9f57008181c3ed75eabbc6f2fefb3a62e987e95;
71     mapping(address => uint) public nonces;
72 
73     address public migrator;
74     mapping(address => bool) public registrators;
75 
76     event Register(address indexed user, uint indexed userId, uint indexed sponsorId, uint userType);
77     event MigrateUserBySign(address indexed signatory, uint indexed userId, address indexed userAddress, uint nonce);
78 
79     constructor(address migratorAddress)  {
80         require(migratorAddress != address(0), "Nimbus Referral: Zero address");
81         migrator = migratorAddress;
82         registrators[migratorAddress] = true;
83 
84         uint chainId;
85         assembly {
86             chainId := chainid()
87         }
88         DOMAIN_SEPARATOR = keccak256(
89             abi.encode(
90                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
91                 keccak256(bytes("NimbusReferralProgram")),
92                 keccak256(bytes('1')),
93                 chainId,
94                 address(this)
95             )
96         );
97     }
98 
99     receive() payable external {
100         revert();
101     }
102 
103     modifier onlyMigrator() {
104         require(msg.sender == migrator, "Nimbus Referral: Caller is not the migrator");
105         _;
106     }
107 
108     modifier onlyRegistrator() {
109         require(registrators[msg.sender], "Nimbus Referral: Caller is not the registrator");
110         _;
111     }
112 
113     function userSponsorByAddress(address user) external override view returns (uint) {
114         return _userSponsor[userIdByAddress[user]];
115     }
116 
117     function userSponsor(uint user) external override view returns (uint) {
118         return _userSponsor[user];
119     }
120 
121     function userSponsorAddressByAddress(address user) external override view returns (address) {
122         uint sponsorId = _userSponsor[userIdByAddress[user]];
123         if (sponsorId < 1000000001) return address(0);
124         else return userAddressById[sponsorId];
125     }
126 
127     function getUserReferrals(uint userId) external view returns (uint[] memory) {
128         return _userReferrals[userId];
129     }
130 
131     function getUserReferrals(address user) external view returns (uint[] memory) {
132         return _userReferrals[userIdByAddress[user]];
133     }
134 
135 
136 
137 
138     function registerBySponsorAddress(address sponsorAddress) external returns (uint) { 
139         return _registerUser(msg.sender, userIdByAddress[sponsorAddress], 0);
140     }
141 
142     function register() public returns (uint) {
143         return _registerUser(msg.sender, 1000000001, 0);
144     }
145 
146     function registerBySponsorId(uint sponsorId) public returns (uint) {
147         return _registerUser(msg.sender, sponsorId, 0);
148     }
149 
150     function registerUserBySponsorAddress(address user, address sponsorAddress, uint category) external onlyRegistrator returns (uint) { 
151         return _registerUser(user, userIdByAddress[sponsorAddress], category);
152     }
153 
154     function registerUser(address user, uint category) public onlyRegistrator  returns (uint) {
155         return _registerUser(user, 1000000001, category);
156     }
157 
158     function registerUserBySponsorId(address user, uint sponsorId, uint category) public onlyRegistrator returns (uint) {
159         return _registerUser(user, sponsorId, category);
160     }
161 
162     function _registerUser(address user, uint sponsorId, uint category) private returns (uint) {
163         require(user != address(0), "Nimbus Referral: Address is zero");
164         require(userIdByAddress[user] == 0, "Nimbus Referral: Already registered");
165         require(_userSponsor[sponsorId] != 0, "Nimbus Referral: No such sponsor");
166         
167         uint id = ++lastUserId; //gas saving
168         userIdByAddress[user] = id;
169         userAddressById[id] = user;
170         _userSponsor[id] = sponsorId;
171         _userReferrals[sponsorId].push(id);
172         if (category > 0) userCategory[id] = category;
173         emit Register(user, id, sponsorId, category);
174         return id;
175     }
176 
177 
178 
179     function migrateUsers(uint[] memory ids, uint[] memory sponsorId, address[] memory userAddress) external onlyMigrator {
180         require(lastUserId == 0, "Nimbus Referral: Basic migration is finished");
181         require(ids.length == sponsorId.length, "Nimbus Referral: Different array lengths");     
182         for (uint i; i < ids.length; i++) {
183             uint id = ids[i];
184             _userSponsor[id] = sponsorId[i];
185             if (userAddress[i] != address(0)) {
186                 userIdByAddress[userAddress[i]] = id;
187                 userAddressById[id] = userAddress[i];
188             }
189         }
190     } 
191 
192     function updateUserAddress(uint id, address userAddress) external onlyMigrator {
193         require(userAddress != address(0), "Nimbus Referral: Address is zero");
194         require(_userSponsor[id] > 1000000000, "Nimbus Referral: No such user");
195         require(userIdByAddress[userAddress] == 0, "Nimbus Referral: Address is already in the system");
196         userIdByAddress[userAddress] = id;
197         userAddressById[id] = userAddress;
198     }
199 
200     
201     function updateUserCategory(uint id, uint category) external onlyMigrator {
202         require(_userSponsor[id] > 1000000000, "Nimbus Referral: No such user");
203         userCategory[id] = category;
204     }
205 
206     function updateUserAddressBySig(uint id, address userAddress, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
207         require(block.timestamp <= deadline, "Nimbus Referral: Signature expired");
208         require(userIdByAddress[userAddress] == 0, "Nimbus Referral: Address is already in the system");
209         uint nonce = nonces[userAddress]++;
210         bytes32 digest = keccak256(
211             abi.encodePacked(
212                 '\x19\x01',
213                 DOMAIN_SEPARATOR,
214                 keccak256(abi.encode(UPDATE_ADDRESS_TYPEHASH, id, userAddress, nonce, deadline))
215             )
216         );
217         
218         address recoveredAddress = ecrecover(digest, v, r, s);
219         require(recoveredAddress != address(0) && recoveredAddress == migrator, 'Nimbus Referral: Invalid signature');
220         userIdByAddress[userAddress] = id;
221         userAddressById[id] = userAddress;
222         emit MigrateUserBySign(recoveredAddress, id, userAddress, nonce);
223     }
224 
225     function updateUserCategoryBySig(uint id, uint category, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
226         require(block.timestamp <= deadline, "Nimbus Referral: Signature expired");
227         require(_userSponsor[id] > 1000000000, "Nimbus Referral: No such user");
228         uint nonce = nonces[userAddressById[id]]++;
229         bytes32 digest = keccak256(
230             abi.encodePacked(
231                 '\x19\x01',
232                 DOMAIN_SEPARATOR,
233                 keccak256(abi.encode(UPDATE_ADDRESS_TYPEHASH, id, category, nonce, deadline))
234             )
235         );
236         
237         address recoveredAddress = ecrecover(digest, v, r, s);
238         require(recoveredAddress != address(0) && recoveredAddress == migrator, 'Nimbus Referral: Invalid signature');
239         userCategory[id] = category;
240     }
241 
242     function updateUserDataBySig(uint id, address userAddress, uint[] memory referrals, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
243         require(block.timestamp <= deadline, "Nimbus Referral: Signature expired");
244         uint nonce = nonces[userAddress]++;
245         bytes32 digest = keccak256(
246             abi.encodePacked(
247                 '\x19\x01',
248                 DOMAIN_SEPARATOR,
249                 keccak256(abi.encode(UPDATE_DATA_TYPEHASG, id, userAddress, keccak256(abi.encodePacked(referrals)), nonce, deadline))
250             )
251         );
252         
253         address recoveredAddress = ecrecover(digest, v, r, s);
254         require(recoveredAddress != address(0) && recoveredAddress == migrator, 'Nimbus Referral: Invalid signature');
255         userIdByAddress[userAddress] = id;
256         userAddressById[id] = userAddress;
257         _userReferrals[id] = referrals;
258         emit MigrateUserBySign(recoveredAddress, id, userAddress, nonce);
259     }
260 
261     function updateUserReferralsBySig(uint id, address userAddress, uint[] memory referrals, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
262         require(block.timestamp <= deadline, "Nimbus Referral: Signature expired");
263         uint nonce = nonces[userAddress]++;
264         bytes32 digest = keccak256(
265             abi.encodePacked(
266                 '\x19\x01',
267                 DOMAIN_SEPARATOR,
268                 keccak256(abi.encode(UPDATE_DATA_TYPEHASG, id, userAddress, keccak256(abi.encodePacked(referrals)), nonce, deadline))
269             )
270         );
271         
272         address recoveredAddress = ecrecover(digest, v, r, s);
273         require(recoveredAddress != address(0) && recoveredAddress == migrator, 'Nimbus Referral: Invalid signature');
274         userIdByAddress[userAddress] = id;
275         userAddressById[id] = userAddress;
276         for (uint i; i < referrals.length; i++) {
277             _userReferrals[id].push(referrals[i]);
278         }
279         emit MigrateUserBySign(recoveredAddress, id, userAddress, nonce);
280     }
281 
282     function updateUserReferrals(uint id, uint[] memory referrals) external onlyMigrator {
283         _userReferrals[id] = referrals;
284         for (uint i; i < referrals.length; i++) {
285             _userReferrals[id].push(referrals[i]);
286         }
287     }
288 
289     function updateMigrator(address newMigrator) external {
290         require(msg.sender == migrator || msg.sender == owner, "Nimbus Referral: Not allowed");
291         require(newMigrator != address(0), "Nimbus Referral: Address is zero");
292         migrator = newMigrator;
293     }
294 
295     function updateRegistrator(address registrator, bool isActive) external onlyOwner {
296         registrators[registrator] = isActive;
297     }
298 
299     function finishBasicMigration(uint userId) external onlyMigrator {
300         lastUserId = userId;
301     }
302 }