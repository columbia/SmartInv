1 pragma solidity 0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b, "mul overflow");
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
17         uint256 c = a / b;
18         // require(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "sub underflow");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "add overflow");
30         return c;
31     }
32 
33     function roundedDiv(uint a, uint b) internal pure returns (uint256) {
34         require(b > 0, "div by 0"); // Solidity automatically throws for div by 0 but require to emit reason
35         uint256 z = a / b;
36         if (a % b >= b / 2) {
37             z++;  // no need for safe add b/c it can happen only if we divided the input
38         }
39         return z;
40     }
41 }
42 
43 /*
44     Generic contract to authorise calls to certain functions only from a given address.
45     The address authorised must be a contract (multisig or not, depending on the permission), except for local test
46 
47     deployment works as:
48            1. contract deployer account deploys contracts
49            2. constructor grants "PermissionGranter" permission to deployer account
50            3. deployer account executes initial setup (no multiSig)
51            4. deployer account grants PermissionGranter permission for the MultiSig contract
52                 (e.g. StabilityBoardProxy or PreTokenProxy)
53            5. deployer account revokes its own PermissionGranter permission
54 */
55 
56 contract Restricted {
57 
58     // NB: using bytes32 rather than the string type because it's cheaper gas-wise:
59     mapping (address => mapping (bytes32 => bool)) public permissions;
60 
61     event PermissionGranted(address indexed agent, bytes32 grantedPermission);
62     event PermissionRevoked(address indexed agent, bytes32 revokedPermission);
63 
64     modifier restrict(bytes32 requiredPermission) {
65         require(permissions[msg.sender][requiredPermission], "msg.sender must have permission");
66         _;
67     }
68 
69     constructor(address permissionGranterContract) public {
70         require(permissionGranterContract != address(0), "permissionGranterContract must be set");
71         permissions[permissionGranterContract]["PermissionGranter"] = true;
72         emit PermissionGranted(permissionGranterContract, "PermissionGranter");
73     }
74 
75     function grantPermission(address agent, bytes32 requiredPermission) public {
76         require(permissions[msg.sender]["PermissionGranter"],
77             "msg.sender must have PermissionGranter permission");
78         permissions[agent][requiredPermission] = true;
79         emit PermissionGranted(agent, requiredPermission);
80     }
81 
82     function grantMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
83         require(permissions[msg.sender]["PermissionGranter"],
84             "msg.sender must have PermissionGranter permission");
85         uint256 length = requiredPermissions.length;
86         for (uint256 i = 0; i < length; i++) {
87             grantPermission(agent, requiredPermissions[i]);
88         }
89     }
90 
91     function revokePermission(address agent, bytes32 requiredPermission) public {
92         require(permissions[msg.sender]["PermissionGranter"],
93             "msg.sender must have PermissionGranter permission");
94         permissions[agent][requiredPermission] = false;
95         emit PermissionRevoked(agent, requiredPermission);
96     }
97 
98     function revokeMultiplePermissions(address agent, bytes32[] requiredPermissions) public {
99         uint256 length = requiredPermissions.length;
100         for (uint256 i = 0; i < length; i++) {
101             revokePermission(agent, requiredPermissions[i]);
102         }
103     }
104 
105 }
106 
107 
108 /* Augmint pretoken contract to record agreements and tokens allocated based on the agreement.
109 
110     Important: this is NOT an ERC20 token!
111 
112     PreTokens are non-fungible: agreements can have different conditions (valuationCap and discount)
113         and pretokens are not tradable.
114 
115     Ownership can be transferred if owner wants to change wallet but the whole agreement and
116         the total pretoken amount is moved to a new account
117 
118     PreTokenSigner can (via MultiSig):
119       - add agreements and issue pretokens to an agreement
120       - change owner of any agreement to handle if an owner lost a private keys
121       - burn pretokens from any agreement to fix potential erroneous issuance
122     These are known compromises on trustlessness hence all these tokens distributed based on signed agreements and
123         preTokens are issued only to a closed group of contributors / team members.
124     If despite these something goes wrong then as a last resort a new pretoken contract can be recreated from agreements.
125 
126     Some ERC20 functions are implemented so agreement owners can see their balances and use transfer in standard wallets.
127     Restrictions:
128       - only total balance can be transfered - effectively ERC20 transfer used to transfer agreement ownership
129       - only agreement holders can transfer
130         (i.e. can't transfer 0 amount if have no agreement to avoid polluting logs with Transfer events)
131       - transfer is only allowed to accounts without an agreement yet
132       - no approval and transferFrom ERC20 functions
133  */
134 
135 contract PreToken is Restricted {
136     using SafeMath for uint256;
137 
138     uint public constant CHUNK_SIZE = 100;
139 
140     string constant public name = "Augmint pretokens"; // solhint-disable-line const-name-snakecase
141     string constant public symbol = "APRE"; // solhint-disable-line const-name-snakecase
142     uint8 constant public decimals = 0; // solhint-disable-line const-name-snakecase
143 
144     uint public totalSupply;
145 
146     struct Agreement {
147         address owner;
148         uint balance;
149         uint32 discount; //  discountRate in parts per million , ie. 10,000 = 1%
150         uint32 valuationCap; // in USD (no decimals)
151     }
152 
153     /* Agreement hash is the SHA-2 (SHA-256) hash of signed agreement document.
154          To generate:
155             OSX: shasum -a 256 agreement.pdf
156             Windows: certUtil -hashfile agreement.pdf SHA256 */
157     mapping(address => bytes32) public agreementOwners; // to lookup agrement by owner
158     mapping(bytes32 => Agreement) public agreements;
159 
160     bytes32[] public allAgreements; // all agreements to able to iterate over
161 
162     event Transfer(address indexed from, address indexed to, uint amount);
163 
164     event NewAgreement(address owner, bytes32 agreementHash, uint32 discount, uint32 valuationCap);
165 
166     constructor(address permissionGranterContract) public Restricted(permissionGranterContract) {} // solhint-disable-line no-empty-blocks
167 
168     function addAgreement(address owner, bytes32 agreementHash, uint32 discount, uint32 valuationCap)
169     external restrict("PreTokenSigner") {
170         require(owner != address(0), "owner must not be 0x0");
171         require(agreementOwners[owner] == 0x0, "owner must not have an aggrement yet");
172         require(agreementHash != 0x0, "agreementHash must not be 0x0");
173         require(discount > 0, "discount must be > 0");
174         require(agreements[agreementHash].discount == 0, "agreement must not exist yet");
175 
176         agreements[agreementHash] = Agreement(owner, 0, discount, valuationCap);
177         agreementOwners[owner] = agreementHash;
178         allAgreements.push(agreementHash);
179 
180         emit NewAgreement(owner, agreementHash, discount, valuationCap);
181     }
182 
183     function issueTo(bytes32 agreementHash, uint amount) external restrict("PreTokenSigner") {
184         Agreement storage agreement = agreements[agreementHash];
185         require(agreement.discount > 0, "agreement must exist");
186 
187         agreement.balance = agreement.balance.add(amount);
188         totalSupply = totalSupply.add(amount);
189 
190         emit Transfer(0x0, agreement.owner, amount);
191     }
192 
193     /* Restricted function to allow pretoken signers to fix incorrect issuance */
194     function burnFrom(bytes32 agreementHash, uint amount)
195     public restrict("PreTokenSigner") returns (bool) {
196         Agreement storage agreement = agreements[agreementHash];
197         require(agreement.discount > 0, "agreement must exist"); // this is redundant b/c of next requires but be explicit
198         require(amount > 0, "burn amount must be > 0");
199         require(agreement.balance >= amount, "must not burn more than balance"); // .sub would revert anyways but emit reason
200 
201         agreement.balance = agreement.balance.sub(amount);
202         totalSupply = totalSupply.sub(amount);
203 
204         emit Transfer(agreement.owner, 0x0, amount);
205         return true;
206     }
207 
208     function balanceOf(address owner) public view returns (uint) {
209         return agreements[agreementOwners[owner]].balance;
210     }
211 
212     /* function to transfer agreement ownership to other wallet by owner
213         it's in ERC20 form so owners can use standard ERC20 wallet just need to pass full balance as value */
214     function transfer(address to, uint amount) public returns (bool) { // solhint-disable-line no-simple-event-func-name
215         require(amount == agreements[agreementOwners[msg.sender]].balance, "must transfer full balance");
216         _transfer(msg.sender, to);
217         return true;
218     }
219 
220     /* Restricted function to allow pretoken signers to fix if pretoken owner lost keys */
221     function transferAgreement(bytes32 agreementHash, address to)
222     public restrict("PreTokenSigner") returns (bool) {
223         _transfer(agreements[agreementHash].owner, to);
224         return true;
225     }
226 
227     /* private function used by transferAgreement & transfer */
228     function _transfer(address from, address to) private {
229         Agreement storage agreement = agreements[agreementOwners[from]];
230         require(agreementOwners[from] != 0x0, "from agreement must exists");
231         require(agreementOwners[to] == 0, "to must not have an agreement");
232         require(to != 0x0, "must not transfer to 0x0");
233 
234         agreement.owner = to;
235 
236         agreementOwners[to] = agreementOwners[from];
237         agreementOwners[from] = 0x0;
238 
239         emit Transfer(from, to, agreement.balance);
240     }
241 
242     function getAgreementsCount() external view returns (uint agreementsCount) {
243         return allAgreements.length;
244     }
245 
246     // UI helper fx - Returns all agreements from offset as
247     // [index in allAgreements, account address as uint, balance, agreementHash as uint,
248     //          discount as uint, valuationCap as uint ]
249     function getAllAgreements(uint offset) external view returns(uint[6][CHUNK_SIZE] agreementsResult) {
250 
251         for (uint8 i = 0; i < CHUNK_SIZE && i + offset < allAgreements.length; i++) {
252             bytes32 agreementHash = allAgreements[i + offset];
253             Agreement storage agreement = agreements[agreementHash];
254 
255             agreementsResult[i] = [ i + offset, uint(agreement.owner), agreement.balance,
256                 uint(agreementHash), uint(agreement.discount), uint(agreement.valuationCap)];
257         }
258     }
259 }