1 pragma solidity ^0.5.1;
2 
3 contract LockRequestable {
4 
5         // MEMBERS
6         /// @notice  the count of all invocations of `generateLockId`.
7         uint256 public lockRequestCount;
8 
9         constructor() public {
10                 lockRequestCount = 0;
11         }
12 
13         // FUNCTIONS
14         /** @notice  Returns a fresh unique identifier.
15             *
16             * @dev the generation scheme uses three components.
17             * First, the blockhash of the previous block.
18             * Second, the deployed address.
19             * Third, the next value of the counter.
20             * This ensure that identifiers are unique across all contracts
21             * following this scheme, and that future identifiers are
22             * unpredictable.
23             *
24             * @return a 32-byte unique identifier.
25             */
26         function generateLockId() internal returns (bytes32 lockId) {
27                 return keccak256(
28                 abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount)
29                 );
30         }
31 }
32 
33 contract CustodianUpgradeable is LockRequestable {
34 
35         // TYPES
36         /// @dev  The struct type for pending custodian changes.
37         struct CustodianChangeRequest {
38                 address proposedNew;
39         }
40 
41         // MEMBERS
42         /// @dev  The address of the account or contract that acts as the custodian.
43         address public custodian;
44 
45         /// @dev  The map of lock ids to pending custodian changes.
46         mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;
47 
48         constructor(address _custodian) public LockRequestable() {
49                 custodian = _custodian;
50         }
51 
52         // MODIFIERS
53         modifier onlyCustodian {
54                 require(msg.sender == custodian);
55                 _;
56         }
57 
58         /** @notice  Requests a change of the custodian associated with this contract.
59             *
60             * @dev  Returns a unique lock id associated with the request.
61             * Anyone can call this function, but confirming the request is authorized
62             * by the custodian.
63             *
64             * @param  _proposedCustodian  The address of the new custodian.
65             * @return  lockId  A unique identifier for this request.
66             */
67         function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
68                 require(_proposedCustodian != address(0));
69 
70                 lockId = generateLockId();
71 
72                 custodianChangeReqs[lockId] = CustodianChangeRequest({
73                         proposedNew: _proposedCustodian
74                 });
75 
76                 emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
77         }
78 
79         /** @notice  Confirms a pending change of the custodian associated with this contract.
80             *
81             * @dev  When called by the current custodian with a lock id associated with a
82             * pending custodian change, the `address custodian` member will be updated with the
83             * requested address.
84             *
85             * @param  _lockId  The identifier of a pending change request.
86             */
87         function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
88                 custodian = getCustodianChangeReq(_lockId);
89 
90                 delete custodianChangeReqs[_lockId];
91 
92                 emit CustodianChangeConfirmed(_lockId, custodian);
93         }
94 
95         // PRIVATE FUNCTIONS
96         function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
97                 CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];
98 
99                 // reject ‘null’ results from the map lookup
100                 // this can only be the case if an unknown `_lockId` is received
101                 require(changeRequest.proposedNew != address(0));
102 
103                 return changeRequest.proposedNew;
104         }
105 
106         /// @dev  Emitted by successful `requestCustodianChange` calls.
107         event CustodianChangeRequested(
108                 bytes32 _lockId,
109                 address _msgSender,
110                 address _proposedCustodian
111         );
112 
113         /// @dev Emitted by successful `confirmCustodianChange` calls.
114         event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
115 }
116 
117 contract TokenSettingsInterface {
118 
119     // METHODS
120     function getTradeAllowed() public view returns (bool);
121     function getMintAllowed() public view returns (bool);
122     function getBurnAllowed() public view returns (bool);
123     
124     // EVENTS
125     event TradeAllowedLocked(bytes32 _lockId, bool _newValue);
126     event TradeAllowedConfirmed(bytes32 _lockId, bool _newValue);
127     event MintAllowedLocked(bytes32 _lockId, bool _newValue);
128     event MintAllowedConfirmed(bytes32 _lockId, bool _newValue);
129     event BurnAllowedLocked(bytes32 _lockId, bool _newValue);
130     event BurnAllowedConfirmed(bytes32 _lockId, bool _newValue);
131 
132     // MODIFIERS
133     modifier onlyCustodian {
134         _;
135     }
136 }
137 
138 
139 contract _BurnAllowed is TokenSettingsInterface, LockRequestable {
140     // cc:IV. BurnAllowed Setting#2;Burn Allowed Switch;1;
141     //
142     // SETTING: Burn Allowed Switch (bool)
143     // Boundary: true or false
144     //
145     // Enables or disables token minting ability globally (even for custodian).
146     //
147     bool private burnAllowed = false;
148 
149     function getBurnAllowed() public view returns (bool) {
150         return burnAllowed;
151     }
152 
153     // SETTING MANAGEMENT
154 
155     struct PendingBurnAllowed {
156         bool burnAllowed;
157         bool set;
158     }
159 
160     mapping (bytes32 => PendingBurnAllowed) public pendingBurnAllowedMap;
161 
162     function requestBurnAllowedChange(bool _burnAllowed) public returns (bytes32 lockId) {
163        require(_burnAllowed != burnAllowed);
164        
165        lockId = generateLockId();
166        pendingBurnAllowedMap[lockId] = PendingBurnAllowed({
167            burnAllowed: _burnAllowed,
168            set: true
169        });
170 
171        emit BurnAllowedLocked(lockId, _burnAllowed);
172     }
173 
174     function confirmBurnAllowedChange(bytes32 _lockId) public onlyCustodian {
175         PendingBurnAllowed storage value = pendingBurnAllowedMap[_lockId];
176         require(value.set == true);
177         burnAllowed = value.burnAllowed;
178         emit BurnAllowedConfirmed(_lockId, value.burnAllowed);
179         delete pendingBurnAllowedMap[_lockId];
180     }
181 }
182 
183 
184 contract _MintAllowed is TokenSettingsInterface, LockRequestable {
185     // cc:III. MintAllowed Setting#2;Mint Allowed Switch;1;
186     //
187     // SETTING: Mint Allowed Switch (bool)
188     // Boundary: true or false
189     //
190     // Enables or disables token minting ability globally (even for custodian).
191     //
192     bool private mintAllowed = false;
193 
194     function getMintAllowed() public view returns (bool) {
195         return mintAllowed;
196     }
197 
198     // SETTING MANAGEMENT
199 
200     struct PendingMintAllowed {
201         bool mintAllowed;
202         bool set;
203     }
204 
205     mapping (bytes32 => PendingMintAllowed) public pendingMintAllowedMap;
206 
207     function requestMintAllowedChange(bool _mintAllowed) public returns (bytes32 lockId) {
208        require(_mintAllowed != mintAllowed);
209        
210        lockId = generateLockId();
211        pendingMintAllowedMap[lockId] = PendingMintAllowed({
212            mintAllowed: _mintAllowed,
213            set: true
214        });
215 
216        emit MintAllowedLocked(lockId, _mintAllowed);
217     }
218 
219     function confirmMintAllowedChange(bytes32 _lockId) public onlyCustodian {
220         PendingMintAllowed storage value = pendingMintAllowedMap[_lockId];
221         require(value.set == true);
222         mintAllowed = value.mintAllowed;
223         emit MintAllowedConfirmed(_lockId, value.mintAllowed);
224         delete pendingMintAllowedMap[_lockId];
225     }
226 }
227 
228 
229 contract _TradeAllowed is TokenSettingsInterface, LockRequestable {
230     // cc:II. TradeAllowed Setting#2;Trade Allowed Switch;1;
231     //
232     // SETTING: Trade Allowed Switch (bool)
233     // Boundary: true or false
234     //
235     // Enables or disables all token transfers, between any recipients, except mint and burn operations.
236     //
237     bool private tradeAllowed = false;
238 
239     function getTradeAllowed() public view returns (bool) {
240         return tradeAllowed;
241     }
242 
243     // SETTING MANAGEMENT
244 
245     struct PendingTradeAllowed {
246         bool tradeAllowed;
247         bool set;
248     }
249 
250     mapping (bytes32 => PendingTradeAllowed) public pendingTradeAllowedMap;
251 
252     function requestTradeAllowedChange(bool _tradeAllowed) public returns (bytes32 lockId) {
253        require(_tradeAllowed != tradeAllowed);
254        
255        lockId = generateLockId();
256        pendingTradeAllowedMap[lockId] = PendingTradeAllowed({
257            tradeAllowed: _tradeAllowed,
258            set: true
259        });
260 
261        emit TradeAllowedLocked(lockId, _tradeAllowed);
262     }
263 
264     function confirmTradeAllowedChange(bytes32 _lockId) public onlyCustodian {
265         PendingTradeAllowed storage value = pendingTradeAllowedMap[_lockId];
266         require(value.set == true);
267         tradeAllowed = value.tradeAllowed;
268         emit TradeAllowedConfirmed(_lockId, value.tradeAllowed);
269         delete pendingTradeAllowedMap[_lockId];
270     }
271 }
272 
273 contract TokenSettings is TokenSettingsInterface, CustodianUpgradeable,
274 _TradeAllowed,
275 _MintAllowed,
276 _BurnAllowed
277     {
278     constructor(address _custodian) public CustodianUpgradeable(_custodian) {
279     }
280 }