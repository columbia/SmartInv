1 pragma solidity 0.4.24;
2 
3 interface CommAuctionIface {
4     function getNextPrice(bytes32 democHash) external view returns (uint);
5     function noteBallotDeployed(bytes32 democHash) external;
6 
7     // add more when we need it
8 
9     function upgradeMe(address newSC) external;
10 }
11 
12 contract safeSend {
13     bool private txMutex3847834;
14 
15     // we want to be able to call outside contracts (e.g. the admin proxy contract)
16     // but reentrency is bad, so here's a mutex.
17     function doSafeSend(address toAddr, uint amount) internal {
18         doSafeSendWData(toAddr, "", amount);
19     }
20 
21     function doSafeSendWData(address toAddr, bytes data, uint amount) internal {
22         require(txMutex3847834 == false, "ss-guard");
23         txMutex3847834 = true;
24         // we need to use address.call.value(v)() because we want
25         // to be able to send to other contracts, even with no data,
26         // which might use more than 2300 gas in their fallback function.
27         require(toAddr.call.value(amount)(data), "ss-failed");
28         txMutex3847834 = false;
29     }
30 }
31 
32 contract payoutAllC is safeSend {
33     address private _payTo;
34 
35     event PayoutAll(address payTo, uint value);
36 
37     constructor(address initPayTo) public {
38         // DEV NOTE: you can overwrite _getPayTo if you want to reuse other storage vars
39         assert(initPayTo != address(0));
40         _payTo = initPayTo;
41     }
42 
43     function _getPayTo() internal view returns (address) {
44         return _payTo;
45     }
46 
47     function _setPayTo(address newPayTo) internal {
48         _payTo = newPayTo;
49     }
50 
51     function payoutAll() external {
52         address a = _getPayTo();
53         uint bal = address(this).balance;
54         doSafeSend(a, bal);
55         emit PayoutAll(a, bal);
56     }
57 }
58 
59 contract payoutAllCSettable is payoutAllC {
60     constructor (address initPayTo) payoutAllC(initPayTo) public {
61     }
62 
63     function setPayTo(address) external;
64     function getPayTo() external view returns (address) {
65         return _getPayTo();
66     }
67 }
68 
69 contract owned {
70     address public owner;
71 
72     event OwnerChanged(address newOwner);
73 
74     modifier only_owner() {
75         require(msg.sender == owner, "only_owner: forbidden");
76         _;
77     }
78 
79     modifier owner_or(address addr) {
80         require(msg.sender == addr || msg.sender == owner, "!owner-or");
81         _;
82     }
83 
84     constructor() public {
85         owner = msg.sender;
86     }
87 
88     function setOwner(address newOwner) only_owner() external {
89         owner = newOwner;
90         emit OwnerChanged(newOwner);
91     }
92 }
93 
94 contract CommunityAuctionSimple is owned {
95     // about $1USD at $600usd/eth
96     uint public commBallotPriceWei = 1666666666000000;
97 
98     struct Record {
99         bytes32 democHash;
100         uint ts;
101     }
102 
103     mapping (address => Record[]) public ballotLog;
104     mapping (address => address) public upgrades;
105 
106     function getNextPrice(bytes32) external view returns (uint) {
107         return commBallotPriceWei;
108     }
109 
110     function noteBallotDeployed(bytes32 d) external {
111         require(upgrades[msg.sender] == address(0));
112         ballotLog[msg.sender].push(Record(d, now));
113     }
114 
115     function upgradeMe(address newSC) external {
116         require(upgrades[msg.sender] == address(0));
117         upgrades[msg.sender] = newSC;
118     }
119 
120     function getBallotLogN(address a) external view returns (uint) {
121         return ballotLog[a].length;
122     }
123 
124     function setPriceWei(uint newPrice) only_owner() external {
125         commBallotPriceWei = newPrice;
126     }
127 }
128 
129 contract controlledIface {
130     function controller() external view returns (address);
131 }
132 
133 contract hasAdmins is owned {
134     mapping (uint => mapping (address => bool)) admins;
135     uint public currAdminEpoch = 0;
136     bool public adminsDisabledForever = false;
137     address[] adminLog;
138 
139     event AdminAdded(address indexed newAdmin);
140     event AdminRemoved(address indexed oldAdmin);
141     event AdminEpochInc();
142     event AdminDisabledForever();
143 
144     modifier only_admin() {
145         require(adminsDisabledForever == false, "admins must not be disabled");
146         require(isAdmin(msg.sender), "only_admin: forbidden");
147         _;
148     }
149 
150     constructor() public {
151         _setAdmin(msg.sender, true);
152     }
153 
154     function isAdmin(address a) view public returns (bool) {
155         return admins[currAdminEpoch][a];
156     }
157 
158     function getAdminLogN() view external returns (uint) {
159         return adminLog.length;
160     }
161 
162     function getAdminLog(uint n) view external returns (address) {
163         return adminLog[n];
164     }
165 
166     function upgradeMeAdmin(address newAdmin) only_admin() external {
167         // note: already checked msg.sender has admin with `only_admin` modifier
168         require(msg.sender != owner, "owner cannot upgrade self");
169         _setAdmin(msg.sender, false);
170         _setAdmin(newAdmin, true);
171     }
172 
173     function setAdmin(address a, bool _givePerms) only_admin() external {
174         require(a != msg.sender && a != owner, "cannot change your own (or owner's) permissions");
175         _setAdmin(a, _givePerms);
176     }
177 
178     function _setAdmin(address a, bool _givePerms) internal {
179         admins[currAdminEpoch][a] = _givePerms;
180         if (_givePerms) {
181             emit AdminAdded(a);
182             adminLog.push(a);
183         } else {
184             emit AdminRemoved(a);
185         }
186     }
187 
188     // safety feature if admins go bad or something
189     function incAdminEpoch() only_owner() external {
190         currAdminEpoch++;
191         admins[currAdminEpoch][msg.sender] = true;
192         emit AdminEpochInc();
193     }
194 
195     // this is internal so contracts can all it, but not exposed anywhere in this
196     // contract.
197     function disableAdminForever() internal {
198         currAdminEpoch++;
199         adminsDisabledForever = true;
200         emit AdminDisabledForever();
201     }
202 }
203 
204 contract permissioned is owned, hasAdmins {
205     mapping (address => bool) editAllowed;
206     bool public adminLockdown = false;
207 
208     event PermissionError(address editAddr);
209     event PermissionGranted(address editAddr);
210     event PermissionRevoked(address editAddr);
211     event PermissionsUpgraded(address oldSC, address newSC);
212     event SelfUpgrade(address oldSC, address newSC);
213     event AdminLockdown();
214 
215     modifier only_editors() {
216         require(editAllowed[msg.sender], "only_editors: forbidden");
217         _;
218     }
219 
220     modifier no_lockdown() {
221         require(adminLockdown == false, "no_lockdown: check failed");
222         _;
223     }
224 
225 
226     constructor() owned() hasAdmins() public {
227     }
228 
229 
230     function setPermissions(address e, bool _editPerms) no_lockdown() only_admin() external {
231         editAllowed[e] = _editPerms;
232         if (_editPerms)
233             emit PermissionGranted(e);
234         else
235             emit PermissionRevoked(e);
236     }
237 
238     function upgradePermissionedSC(address oldSC, address newSC) no_lockdown() only_admin() external {
239         editAllowed[oldSC] = false;
240         editAllowed[newSC] = true;
241         emit PermissionsUpgraded(oldSC, newSC);
242     }
243 
244     // always allow SCs to upgrade themselves, even after lockdown
245     function upgradeMe(address newSC) only_editors() external {
246         editAllowed[msg.sender] = false;
247         editAllowed[newSC] = true;
248         emit SelfUpgrade(msg.sender, newSC);
249     }
250 
251     function hasPermissions(address a) public view returns (bool) {
252         return editAllowed[a];
253     }
254 
255     function doLockdown() external only_owner() no_lockdown() {
256         disableAdminForever();
257         adminLockdown = true;
258         emit AdminLockdown();
259     }
260 }
261 
262 contract upgradePtr {
263     address ptr = address(0);
264 
265     modifier not_upgraded() {
266         require(ptr == address(0), "upgrade pointer is non-zero");
267         _;
268     }
269 
270     function getUpgradePointer() view external returns (address) {
271         return ptr;
272     }
273 
274     function doUpgradeInternal(address nextSC) internal {
275         ptr = nextSC;
276     }
277 }
278 
279 interface ERC20Interface {
280     // Get the total token supply
281     function totalSupply() constant external returns (uint256 _totalSupply);
282 
283     // Get the account balance of another account with address _owner
284     function balanceOf(address _owner) constant external returns (uint256 balance);
285 
286     // Send _value amount of tokens to address _to
287     function transfer(address _to, uint256 _value) external returns (bool success);
288 
289     // Send _value amount of tokens from address _from to address _to
290     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
291 
292     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
293     // If this function is called again it overwrites the current allowance with _value.
294     // this function is required for some DEX functionality
295     function approve(address _spender, uint256 _value) external returns (bool success);
296 
297     // Returns the amount which _spender is still allowed to withdraw from _owner
298     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
299 
300     // Triggered when tokens are transferred.
301     event Transfer(address indexed _from, address indexed _to, uint256 _value);
302 
303     // Triggered whenever approve(address _spender, uint256 _value) is called.
304     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
305 }